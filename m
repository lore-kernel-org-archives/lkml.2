Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496Ab2BOBOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:14:53 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:43569 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761450Ab2BOBOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:14:07 -0500
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: vm-crosstalk@vmware.com, dtor@vmware.com, cschamp@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [PATCH 00/14] RFC: VMCI for Linux
Date: Tue, 14 Feb 2012 17:05:41 -0800
Message-Id: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In an effort to improve the out-of-the-box experience with Linux
kernels for VMware users, VMware is working on readying the Virtual
Machine Communication Interface (VMCI) and VMCI Sockets (vsock) kernel
modules for inclusion in the Linux kernel. The purpose of this initial
post is to both show how much we love Linux on Valentine's day and 
request early feedback on the VMCI kernel module with the
intent of addressing any major issues early in the process. The VMCI
Socket kernel module will be presented in a later post.

VMCI allows virtual machines to communicate with host kernel modules
and the VMware hypervisors. User level applications both in a virtual
machine and on the host can use VMCI through VMCI Sockets, a socket
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

Andrew Stiegmann (stieg) (14):
  Add vmciContext.*
  Add vmciDatagram.*
  Add vmciDoorbell.*
  Add vmciDriver.*
  Add vmciEvent.*
  Add vmciHashtable.*
  Add vmciQueuePair.*
  Add vmciResource.*
  Add vmciRoute.*
  Add accessor methods for Queue Pairs in VMCI
  Add VMCI kernel API defs and the internal header file
  Add misc header files used by VMCI
  Add main driver and kernel interface file
  Add Kconfig and Makefiles for VMCI

 drivers/misc/Kconfig                        |    1 +
 drivers/misc/Makefile                       |    1 +
 drivers/misc/vmw_vmci/Kconfig               |   16 +
 drivers/misc/vmw_vmci/Makefile              |   36 +
 drivers/misc/vmw_vmci/driver.c              | 2352 +++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmciCommonInt.h       |  105 ++
 drivers/misc/vmw_vmci/vmciContext.c         | 1763 +++++++++++++++++
 drivers/misc/vmw_vmci/vmciContext.h         |   77 +
 drivers/misc/vmw_vmci/vmciDatagram.c        |  842 +++++++++
 drivers/misc/vmw_vmci/vmciDatagram.h        |   42 +
 drivers/misc/vmw_vmci/vmciDoorbell.c        | 1072 +++++++++++
 drivers/misc/vmw_vmci/vmciDoorbell.h        |   37 +
 drivers/misc/vmw_vmci/vmciDriver.c          |  663 +++++++
 drivers/misc/vmw_vmci/vmciDriver.h          |   57 +
 drivers/misc/vmw_vmci/vmciEvent.c           |  648 +++++++
 drivers/misc/vmw_vmci/vmciEvent.h           |   32 +
 drivers/misc/vmw_vmci/vmciHashtable.c       |  519 +++++
 drivers/misc/vmw_vmci/vmciHashtable.h       |   58 +
 drivers/misc/vmw_vmci/vmciKernelAPI.h       |   28 +
 drivers/misc/vmw_vmci/vmciKernelAPI1.h      |  148 ++
 drivers/misc/vmw_vmci/vmciKernelAPI2.h      |   48 +
 drivers/misc/vmw_vmci/vmciKernelIf.c        | 1351 ++++++++++++++
 drivers/misc/vmw_vmci/vmciQPair.c           | 1164 ++++++++++++
 drivers/misc/vmw_vmci/vmciQueue.h           |  108 ++
 drivers/misc/vmw_vmci/vmciQueuePair.c       | 2696 +++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmciQueuePair.h       |   95 +
 drivers/misc/vmw_vmci/vmciResource.c        |  383 ++++
 drivers/misc/vmw_vmci/vmciResource.h        |   68 +
 drivers/misc/vmw_vmci/vmciRoute.c           |  249 +++
 drivers/misc/vmw_vmci/vmciRoute.h           |   36 +
 drivers/misc/vmw_vmci/vmci_call_defs.h      |  264 +++
 drivers/misc/vmw_vmci/vmci_defs.h           |  772 ++++++++
 drivers/misc/vmw_vmci/vmci_handle_array.h   |  339 ++++
 drivers/misc/vmw_vmci/vmci_infrastructure.h |  119 ++
 drivers/misc/vmw_vmci/vmci_iocontrols.h     |  411 ++++
 drivers/misc/vmw_vmci/vmci_kernel_if.h      |  111 ++
 36 files changed, 16711 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/Kconfig
 create mode 100644 drivers/misc/vmw_vmci/Makefile
 create mode 100644 drivers/misc/vmw_vmci/driver.c
 create mode 100644 drivers/misc/vmw_vmci/vmciCommonInt.h
 create mode 100644 drivers/misc/vmw_vmci/vmciContext.c
 create mode 100644 drivers/misc/vmw_vmci/vmciContext.h
 create mode 100644 drivers/misc/vmw_vmci/vmciDatagram.c
 create mode 100644 drivers/misc/vmw_vmci/vmciDatagram.h
 create mode 100644 drivers/misc/vmw_vmci/vmciDoorbell.c
 create mode 100644 drivers/misc/vmw_vmci/vmciDoorbell.h
 create mode 100644 drivers/misc/vmw_vmci/vmciDriver.c
 create mode 100644 drivers/misc/vmw_vmci/vmciDriver.h
 create mode 100644 drivers/misc/vmw_vmci/vmciEvent.c
 create mode 100644 drivers/misc/vmw_vmci/vmciEvent.h
 create mode 100644 drivers/misc/vmw_vmci/vmciHashtable.c
 create mode 100644 drivers/misc/vmw_vmci/vmciHashtable.h
 create mode 100644 drivers/misc/vmw_vmci/vmciKernelAPI.h
 create mode 100644 drivers/misc/vmw_vmci/vmciKernelAPI1.h
 create mode 100644 drivers/misc/vmw_vmci/vmciKernelAPI2.h
 create mode 100644 drivers/misc/vmw_vmci/vmciKernelIf.c
 create mode 100644 drivers/misc/vmw_vmci/vmciQPair.c
 create mode 100644 drivers/misc/vmw_vmci/vmciQueue.h
 create mode 100644 drivers/misc/vmw_vmci/vmciQueuePair.c
 create mode 100644 drivers/misc/vmw_vmci/vmciQueuePair.h
 create mode 100644 drivers/misc/vmw_vmci/vmciResource.c
 create mode 100644 drivers/misc/vmw_vmci/vmciResource.h
 create mode 100644 drivers/misc/vmw_vmci/vmciRoute.c
 create mode 100644 drivers/misc/vmw_vmci/vmciRoute.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_call_defs.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_defs.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_handle_array.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_infrastructure.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_iocontrols.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_kernel_if.h
