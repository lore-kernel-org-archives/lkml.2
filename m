Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab1DTVHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 17:07:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21138 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1DTVHb (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 20 Apr 2011 17:07:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, konrad@kernel.org
Subject: [PATCH v6] xen pci backend driver.
Date: Wed, 20 Apr 2011 17:07:19 -0400
Message-Id: <1303333640-5994-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DAF4B0F.002A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch implements the Xen pci backend for upstream Linux.
This is the host side counterpart to the frontend driver in
drivers/pci/xen-pcifront.c. The PV protocol is also implemented by
frontend drivers in other OSes too, such as the BSDs.

This driver has a long history as an out of tree driver but I am
submitting it here as a single monolithic patch to aid review. Once it
has been reviewed and is considered suitable for merging can we perhaps
consider merging the equivalent git branch which maintains much of
history?

The patch is based on the driver from the xen.git pvops kernel tree but
has been put through the checkpatch.pl wringer plus several manual
cleanup passes. It has also been moved from drivers/xen/pciback to
drivers/pci/xen-pciback.

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

For all of this work, there is also support in the toolstack 
(http://xenbits.xen.org/hg/xen-unstable.hg/) to permit the guest to see the
BARs, IO ports, etc - I can go in more details if somebody is interested.

The git tree of the broken out driver is available at:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/xen-pciback-0.6

Note that this driver depends on couple of fixes to the Xen backend
subsystem. Those are available in devel/backend.base.v3 branch and are
intended for the 2.6.40 merge window.

 drivers/pci/Kconfig                             |   43 +
 drivers/pci/Makefile                            |    1 +
 drivers/pci/xen-pciback/Makefile                |   12 +
 drivers/pci/xen-pciback/conf_space.c            |  438 ++++++++
 drivers/pci/xen-pciback/conf_space.h            |  126 +++
 drivers/pci/xen-pciback/conf_space_capability.c |  207 ++++
 drivers/pci/xen-pciback/conf_space_header.c     |  386 +++++++
 drivers/pci/xen-pciback/conf_space_quirks.c     |  140 +++
 drivers/pci/xen-pciback/conf_space_quirks.h     |   33 +
 drivers/pci/xen-pciback/passthrough.c           |  178 +++
 drivers/pci/xen-pciback/pci_stub.c              | 1374 +++++++++++++++++++++++
 drivers/pci/xen-pciback/pciback.h               |  129 +++
 drivers/pci/xen-pciback/pciback_ops.c           |  384 +++++++
 drivers/pci/xen-pciback/vpci.c                  |  246 ++++
 drivers/pci/xen-pciback/xenbus.c                |  728 ++++++++++++
 15 files changed, 4425 insertions(+), 0 deletions(-)
