Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab2EOPHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:07:22 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:55119 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210Ab2EOPHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:07:20 -0400
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: acking@vmware.com, dtor@vmware.com, dsouders@vmware.com,
        cschamp@vmware.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, virtualization@lists.linux-foundation.org,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [vmw_vmci RFC 00/11] VMCI for Linux
Date: Tue, 15 May 2012 08:06:57 -0700
Message-Id: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In an effort to improve the out-of-the-box experience with Linux
kernels for VMware users, VMware is working on readying the Virtual
Machine Communication Interface (vmw_vmci) and VMCI Sockets (vmw_vsock) kernel
modules for inclusion in the Linux kernel. The purpose of this post
is to acquire feedback on the vmw_vmci kernel module. The vmw_vsock
kernel module will be presented in a later post.

VMCI allows virtual machines to communicate with host kernel modules
and the VMware hypervisors. User level applications both in a virtual
machine and on the host can use vmw_vmci through VMCI Sockets, a socket
address family designed to be compatible with UDP and TCP at the
interface level. Today, VMCI and VMCI Sockets are used by the VMware
shared folders (HGFS) and various VMware Tools components inside the
guest for zero-config, network-less access to VMware host services. In
addition to this, VMware's users are using VMCI Sockets for various
applications, where network access of the virtual machine is
restricted or non-existent. Examples of this are VMs communicating
with device proxies for proprietary hardware running as host
applications and automated testing of applications running within
virtual machines.

In a virtual machine, VMCI is exposed as a regular PCI device. The
primary communication mechanisms supported are a point-to-point
bidirectional transport based on a pair of memory-mapped queues, and
asynchronous notifications in the form of datagrams and
doorbells. These features are available to kernel level components
such as HGFS and VMCI Sockets through the VMCI kernel API. In addition
to this, the VMCI kernel API provides support for receiving events
related to the state of the VMCI communication channels, and the
virtual machine itself.

Outside the virtual machine, the host side support of the VMCI kernel
module makes the same VMCI kernel API available to VMCI endpoints on
the host. In addition to this, the host side manages each VMCI device
in a virtual machine through a context object. This context object
serves to identify the virtual machine for communication, and to track
the resource consumption of the given VMCI device. Both operations
related to communication between the virtual machine and the host
kernel, and those related to the management of the VMCI device state
in the host kernel, are invoked by the user level component of the
hypervisor through a set of ioctls on the VMCI device node.  To
provide seamless support for nested virtualization, where a virtual
machine may use both a VMCI PCI device to talk to its hypervisor, and
the VMCI host side support to run nested virtual machines, the VMCI
host and virtual machine support are combined in a single kernel
module.

For additional information about the use of VMCI and in particular
VMCI Sockets, please refer to the VMCI Socket Programming Guide
available at https://www.vmware.com/support/developer/vmci-sdk/.

Andrew Stiegmann (stieg) (11):
  Apply VMCI context code
  Apply VMCI datagram code
  Apply VMCI doorbell code
  Apply VMCI driver code
  Apply VMCI event code
  Apply dynamic array code
  Apply VMCI hash table
  Apply VMCI queue pairs
  Apply VMCI resource code
  Apply vmci routing code
  Apply the header code to make VMCI build

 drivers/misc/Kconfig                      |    1 +
 drivers/misc/Makefile                     |    1 +
 drivers/misc/vmw_vmci/Kconfig             |   16 +
 drivers/misc/vmw_vmci/Makefile            |   43 +
 drivers/misc/vmw_vmci/vmci_common_int.h   |   72 +
 drivers/misc/vmw_vmci/vmci_context.c      | 1743 +++++++++++
 drivers/misc/vmw_vmci/vmci_context.h      |  150 +
 drivers/misc/vmw_vmci/vmci_datagram.c     |  760 +++++
 drivers/misc/vmw_vmci/vmci_datagram.h     |   57 +
 drivers/misc/vmw_vmci/vmci_doorbell.c     |  989 +++++++
 drivers/misc/vmw_vmci/vmci_doorbell.h     |   57 +
 drivers/misc/vmw_vmci/vmci_driver.c       | 2875 ++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_driver.h       |   52 +
 drivers/misc/vmw_vmci/vmci_event.c        |  614 ++++
 drivers/misc/vmw_vmci/vmci_event.h        |   29 +
 drivers/misc/vmw_vmci/vmci_handle_array.c |  300 ++
 drivers/misc/vmw_vmci/vmci_handle_array.h |   50 +
 drivers/misc/vmw_vmci/vmci_hash_table.c   |  494 ++++
 drivers/misc/vmw_vmci/vmci_hash_table.h   |   56 +
 drivers/misc/vmw_vmci/vmci_queue_pair.c   | 4517 +++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_queue_pair.h   |  258 ++
 drivers/misc/vmw_vmci/vmci_resource.c     |  320 ++
 drivers/misc/vmw_vmci/vmci_resource.h     |   61 +
 drivers/misc/vmw_vmci/vmci_route.c        |  234 ++
 drivers/misc/vmw_vmci/vmci_route.h        |   34 +
 include/linux/vmw_vmci_api.h              |  103 +
 include/linux/vmw_vmci_defs.h             | 1003 +++++++
 27 files changed, 14889 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/Kconfig
 create mode 100644 drivers/misc/vmw_vmci/Makefile
 create mode 100644 drivers/misc/vmw_vmci/vmci_common_int.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_context.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_context.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_datagram.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_datagram.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_doorbell.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_doorbell.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_driver.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_driver.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_event.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_event.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_handle_array.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_handle_array.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_hash_table.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_hash_table.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_queue_pair.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_queue_pair.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_resource.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_resource.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_route.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_route.h
 create mode 100644 include/linux/vmw_vmci_api.h
 create mode 100644 include/linux/vmw_vmci_defs.h

