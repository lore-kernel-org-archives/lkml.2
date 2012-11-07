Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2KGSk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:40:27 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:34947 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289Ab2KGSk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:40:26 -0500
Subject: [PATCH 00/12] VMCI for Linux upstreaming
To: linux-kernel@vger.kernel.org, georgezhang@vmware.com,
        virtualization@lists.linux-foundation.org
From: George Zhang <georgezhang@vmware.com>
Cc: pv-drivers@vmware.com, gregkh@linuxfoundation.org
Date: Wed, 07 Nov 2012 10:40:26 -0800
Message-ID: <20121107183624.9658.78903.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* * *
This series of VMCI linux upstreaming patches include latest udpate from
VMware.

Summary of changes:
	- Fix some new sparse issues.
	- Remove some unneeded casts for VMCI.
	- add more __user annotations for VMCI.
	- Remove kernel version-specific bits from vSockets.


* * *

In an effort to improve the out-of-the-box experience with Linux
kernels for VMware users, VMware is working on readying the Virtual
Machine Communication Interface (vmw_vmci) and VMCI Sockets
(vmw_vsock) kernel modules for inclusion in the Linux kernel. The
purpose of this post is to acquire feedback on the vmw_vmci kernel
module. The vmw_vsock kernel module will be presented in a later post.


* * *

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



---

George Zhang (12):
      VMCI: context implementation.
      VMCI: datagram implementation.
      VMCI: doorbell implementation.
      VMCI: device driver implementaton.
      VMCI: event handling implementation.
      VMCI: handle array implementation.
      VMCI: queue pairs implementation.
      VMCI: resource object implementation.
      VMCI: routing implementation.
      VMCI: guest side driver implementation.
      VMCI: host side driver implementation.
      VMCI: Some header and config files.


 drivers/misc/Kconfig                      |    1 
 drivers/misc/Makefile                     |    2 
 drivers/misc/vmw_vmci/Kconfig             |   16 
 drivers/misc/vmw_vmci/Makefile            |    4 
 drivers/misc/vmw_vmci/vmci_common_int.h   |   34 
 drivers/misc/vmw_vmci/vmci_context.c      | 1246 ++++++++++
 drivers/misc/vmw_vmci/vmci_context.h      |  183 ++
 drivers/misc/vmw_vmci/vmci_datagram.c     |  506 ++++
 drivers/misc/vmw_vmci/vmci_datagram.h     |   52 
 drivers/misc/vmw_vmci/vmci_doorbell.c     |  605 +++++
 drivers/misc/vmw_vmci/vmci_doorbell.h     |   51 
 drivers/misc/vmw_vmci/vmci_driver.c       |  116 +
 drivers/misc/vmw_vmci/vmci_driver.h       |   50 
 drivers/misc/vmw_vmci/vmci_event.c        |  229 ++
 drivers/misc/vmw_vmci/vmci_event.h        |   25 
 drivers/misc/vmw_vmci/vmci_guest.c        |  762 ++++++
 drivers/misc/vmw_vmci/vmci_handle_array.c |  142 +
 drivers/misc/vmw_vmci/vmci_handle_array.h |   52 
 drivers/misc/vmw_vmci/vmci_host.c         | 1033 +++++++++
 drivers/misc/vmw_vmci/vmci_queue_pair.c   | 3506 +++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_queue_pair.h   |  191 ++
 drivers/misc/vmw_vmci/vmci_resource.c     |  232 ++
 drivers/misc/vmw_vmci/vmci_resource.h     |   59 
 drivers/misc/vmw_vmci/vmci_route.c        |  229 ++
 drivers/misc/vmw_vmci/vmci_route.h        |   30 
 include/linux/vmw_vmci_api.h              |   82 +
 include/linux/vmw_vmci_defs.h             |  973 ++++++++
 27 files changed, 10411 insertions(+), 0 deletions(-)
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
 create mode 100644 drivers/misc/vmw_vmci/vmci_guest.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_handle_array.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_handle_array.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_host.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_queue_pair.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_queue_pair.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_resource.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_resource.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_route.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_route.h
 create mode 100644 include/linux/vmw_vmci_api.h
 create mode 100644 include/linux/vmw_vmci_defs.h

-- 
Signature
