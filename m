Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab1ANCMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 21:12:48 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:38765 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab1ANCMm (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 13 Jan 2011 21:12:42 -0500
Date: Thu, 13 Jan 2011 21:10:51 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Campbell <ian.campbell@citrix.com>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [GIT PULL] (xen) stable/platform-pci-fixes for 2.6.38
Message-ID: <20110114021051.GB4034@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please git pull the following git tree:
  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/platform-pci-fixes

which has patches since git commit 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5:
Linus Torvalds (1):
      Linux 2.6.37

The patchset includes fixes to the PCI driver for 0x5853:0x0001 which is
presented to Linux when it is running as a fully virtualized guest. That
driver can talk to the QEMU backend and notify QEMU to turn off the
virtualized network and IDE driver and swap over to using the para-virtualized one.

The driver was working right up to 2.6.37-rc7 (rc8?) and then a couple of
the reverts in the PCI API broke this driver. So these patches fix that.

Ian Campbell (2):
      xen-platform: use PCI interfaces to request IO and MEM resources.
      xen: rename platform-pci module to xen-platform-pci.

Konrad Rzeszutek Wilk (1):
      xen-platform: Fix compile errors if CONFIG_PCI is not enabled.

 drivers/xen/Kconfig        |    2 +-
 drivers/xen/Makefile       |    3 ++-
 drivers/xen/platform-pci.c |   21 +++++++--------------
 3 files changed, 10 insertions(+), 16 deletions(-)


diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 6e6180c..6f52b31 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -64,7 +64,7 @@ config XEN_SYS_HYPERVISOR
 
 config XEN_PLATFORM_PCI
 	tristate "xen platform pci device driver"
-	depends on XEN_PVHVM
+	depends on XEN_PVHVM && PCI
 	default m
 	help
 	  Driver for the Xen PCI Platform device: it is responsible for
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 533a199..f81819b 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -11,9 +11,10 @@ obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
 obj-$(CONFIG_XEN_DEV_EVTCHN)	+= xen-evtchn.o
 obj-$(CONFIG_XENFS)		+= xenfs/
 obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
-obj-$(CONFIG_XEN_PLATFORM_PCI)	+= platform-pci.o
+obj-$(CONFIG_XEN_PLATFORM_PCI)	+= xen-platform-pci.o
 obj-$(CONFIG_SWIOTLB_XEN)	+= swiotlb-xen.o
 obj-$(CONFIG_XEN_DOM0)		+= pci.o
 
 xen-evtchn-y			:= evtchn.o
 
+xen-platform-pci-y		:= platform-pci.o
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index c01b5dd..afbe041 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -105,7 +105,7 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 				       const struct pci_device_id *ent)
 {
 	int i, ret;
-	long ioaddr, iolen;
+	long ioaddr;
 	long mmio_addr, mmio_len;
 	unsigned int max_nr_gframes;
 
@@ -114,7 +114,6 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 		return i;
 
 	ioaddr = pci_resource_start(pdev, 0);
-	iolen = pci_resource_len(pdev, 0);
 
 	mmio_addr = pci_resource_start(pdev, 1);
 	mmio_len = pci_resource_len(pdev, 1);
@@ -125,19 +124,13 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 		goto pci_out;
 	}
 
-	if (request_mem_region(mmio_addr, mmio_len, DRV_NAME) == NULL) {
-		dev_err(&pdev->dev, "MEM I/O resource 0x%lx @ 0x%lx busy\n",
-		       mmio_addr, mmio_len);
-		ret = -EBUSY;
+	ret = pci_request_region(pdev, 1, DRV_NAME);
+	if (ret < 0)
 		goto pci_out;
-	}
 
-	if (request_region(ioaddr, iolen, DRV_NAME) == NULL) {
-		dev_err(&pdev->dev, "I/O resource 0x%lx @ 0x%lx busy\n",
-		       iolen, ioaddr);
-		ret = -EBUSY;
+	ret = pci_request_region(pdev, 0, DRV_NAME);
+	if (ret < 0)
 		goto mem_out;
-	}
 
 	platform_mmio = mmio_addr;
 	platform_mmiolen = mmio_len;
@@ -169,9 +162,9 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 	return 0;
 
 out:
-	release_region(ioaddr, iolen);
+	pci_release_region(pdev, 0);
 mem_out:
-	release_mem_region(mmio_addr, mmio_len);
+	pci_release_region(pdev, 1);
 pci_out:
 	pci_disable_device(pdev);
 	return ret;
