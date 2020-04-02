resource "null_resource" "null01" {
  connection {
    bastion_host = "${var.bastion_host}"

    #host = "52.116.140.31"
    host = "${var.target_hosts}"
    user = "root"
    #private_key = "${file("~/.ssh/ansible")}"

    private_key = "${var.ssh_private_key}"
  }

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "remote-exec" {
    script = "ls -al"
  }

  provisioner "ansible" {
    plays {
      playbook = {
        file_path = "${path.module}/ansible-data/playbooks/install-tree.yml"

        roles_path = [
          "${path.module}/ansible-data/roles",
        ]
      }

      verbose = true
      #hosts   = ["${var.target_hosts}"]
    }

    ansible_ssh_settings {
      insecure_no_strict_host_key_checking = "${var.insecure_no_strict_host_key_checking}"
      connect_timeout_seconds              = 60
    }
  }
}

variable "ssh_private_key" {
  description = "private ssh key"
  default     = "key"
}

variable "insecure_no_strict_host_key_checking" {
  default = false
}

variable "bastion_host" {
  description = "Bastion host public IP address"
  default     = "52.116.140.15"
}

variable "target_hosts" {
  description = "List of private IP addresses of target hosts"
  default     = "172.16.4.4"
}
