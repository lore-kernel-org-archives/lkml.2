Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1GLUPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:15:30 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22753 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab1GLUP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:15:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: JBeulich@novell.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, jeremy@goop.org,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@citrix.com,
        linux-pci@vger.kernel.org
Subject: [PATCH v6.2] xen pci backend driver.
Date: Tue, 12 Jul 2011 16:15:04 -0400
Message-Id: <1310501705-5773-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4E1CAB58.0076:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch implements the Xen pci backend for upstream Linux.
This is the host side counterpart to the frontend driver in
drivers/pci/xen-pcifront.c. The PV protocol is also implemented by
frontend drivers in other OSes too, such as the BSDs.

This driver has a long history as an out of tree driver but I am
submitting it here as a single monolithic patch to aid review.

Changelog: [since v6 posting]
 - Moved it drivers/xen/xen-pciback
 - Fixed BUG: scheduling while atomic
 - Made the two compile options XEN_PCIDEV_BACKEND_PASS and XEN_PCIDEV_BACKEND_VPCI
   irrelevant by allowing the user during runtime to choose which backend to use.
[v5, v4, v..]:
 - Lots of things.

The patch is based on the driver from the xen.git pvops kernel tree but
has been put through the checkpatch.pl wringer plus several manual
cleanup passes and bugfixes. It has also been moved from drivers/xen/pciback
to drivers/pci/xen-pciback.

The PV protocol is rather simple. There is page shared with the guest,
which has the 'struct xen_pci_sharedinfo' embossed in it. The backend
has a thread that is kicked every-time the structure is changed and
based on the operation field it performs specific tasks:

 XEN_PCI_OP_conf_[read|write]:
   Read/Write 0xCF8/0xCFC filtered data. (conf_space*.c)
   Based on which field is probed, we either enable/disable the PCI
   device, change power state, read VPD, etc. The goal is to provide
   a Physical IRQ (PIRQ) to the guest.

   The PIRQ is Xen hypervisor global IRQ value irrespective of the IRQ
   is tied in to the IO-APIC, or is a vector. For GSI type
   interrupts, the PIRQ==GSI holds. For MSI/MSI-X the
   PIRQ value != Linux IRQ number (thought PIRQ==vector).

   Hence when a device is has been given an IRQ value in dev->irq, that
   value there is a PIRQ value that is passed in to the guest - so that
   the guest can hook up to the same exact Physical IRQ.

   Please note, that with Xen, all interrupts (except those level shared ones)
   are injected directly to the guest - there is no host interaction.

 XEN_PCI_OP_[enable|disable]_msi[|x] (pciback_ops.c)
   Enables/disables the MSI/MSI-X
   capability of the device. In essence these operations except an
   PIRQ value, or PIRQ values (MSI-X). The host side needs only to "bind"
   the PIRQ to the guest and pass the PIRQ value back to the guest.

   When the device is activated, the interrupts are directly injected in the
   guest without involving the host.

 XEN_PCI_OP_aer_[detected|resume|mmio|slotreset]: In case of failure,
  perform the appropriate AER commands on the guest. Right now that is
  a cop-out - we just kill the guest.

Besides implementing those commands, it also has:

 - a "fake" interrupt handler that ACKs IRQs if the interrupt is
   level and is shared with the guest. This is done so that we don't
   get the "irq(x): nobody cared" in the host.

 - hide a PCI device from the host. When booting up, the user can specify
   xen-pciback.hide=(1:0:0)(BDF..) so that host does not try to use the
   device.

 - two backend engines for exporting PCI topology to the guest. The user
   can specify "passthrough=1" to make the PCI topology mirror the one of
   the host, or leave it as default where the PCI BDF topology starts at
   00:00.0 for PCI devices.

For all of this work, there is also support in the toolstack
(http://xenbits.xen.org/hg/xen-unstable.hg/) to permit the guest to see the
BARs, IO ports, etc - I can go in more details if somebody is interested.

The git tree of the broken out driver is available at:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/xen-pciback-0.6.2

 drivers/xen/Kconfig                             |   22 +
 drivers/xen/Makefile                            |    1 +
 drivers/xen/xen-pciback/Makefile                |    7 +
 drivers/xen/xen-pciback/conf_space.c            |  438 +++++++
 drivers/xen/xen-pciback/conf_space.h            |  126 +++
 drivers/xen/xen-pciback/conf_space_capability.c |  207 ++++
 drivers/xen/xen-pciback/conf_space_header.c     |  386 +++++++
 drivers/xen/xen-pciback/conf_space_quirks.c     |  140 +++
 drivers/xen/xen-pciback/conf_space_quirks.h     |   33 +
 drivers/xen/xen-pciback/passthrough.c           |  193 ++++
 drivers/xen/xen-pciback/pci_stub.c              | 1376 +++++++++++++++++++++++
 drivers/xen/xen-pciback/pciback.h               |  183 +++
 drivers/xen/xen-pciback/pciback_ops.c           |  384 +++++++
 drivers/xen/xen-pciback/vpci.c                  |  259 +++++
 drivers/xen/xen-pciback/xenbus.c                |  749 ++++++++++++
 15 files changed, 4504 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xen/xen-pciback/Makefile
 create mode 100644 drivers/xen/xen-pciback/conf_space.c
 create mode 100644 drivers/xen/xen-pciback/conf_space.h
 create mode 100644 drivers/xen/xen-pciback/conf_space_capability.c
 create mode 100644 drivers/xen/xen-pciback/conf_space_header.c
 create mode 100644 drivers/xen/xen-pciback/conf_space_quirks.c
 create mode 100644 drivers/xen/xen-pciback/conf_space_quirks.h
 create mode 100644 drivers/xen/xen-pciback/passthrough.c
 create mode 100644 drivers/xen/xen-pciback/pci_stub.c
 create mode 100644 drivers/xen/xen-pciback/pciback.h
 create mode 100644 drivers/xen/xen-pciback/pciback_ops.c
 create mode 100644 drivers/xen/xen-pciback/vpci.c
 create mode 100644 drivers/xen/xen-pciback/xenbus.c

