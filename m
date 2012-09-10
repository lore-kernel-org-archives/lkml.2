Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab2IJT56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:57:58 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30364 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231Ab2IJT47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:56:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        stefano.stabellini@eu.citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 07/10] xen/pcifront: Use Xen-SWIOTLB when initting if required.
Date: Mon, 10 Sep 2012 15:46:04 -0400
Message-Id: <1347306367-28669-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We piggyback on "xen/swiotlb: Use the swiotlb_late_init_with_tbl to init
Xen-SWIOTLB late when PV PCI is used." functionality to start up
the Xen-SWIOTLB if we are hot-plugged. This allows us to bypass
the need to supply 'iommu=soft' on the Linux command line (mostly).
With this patch, if a user forgot 'iommu=soft' on the command line,
and hotplug a PCI device they will get:

pcifront pci-0: Installing PCI frontend
Warning: only able to allocate 4 MB for software IO TLB
software IO TLB [mem 0x2a000000-0x2a3fffff] (4MB) mapped at [ffff88002a000000-ffff88002a3fffff]
pcifront pci-0: Creating PCI Frontend Bus 0000:00
pcifront pci-0: PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffffff]
pci 0000:00:00.0: [8086:10d3] type 00 class 0x020000
pci 0000:00:00.0: reg 10: [mem 0xfe5c0000-0xfe5dffff]
pci 0000:00:00.0: reg 14: [mem 0xfe500000-0xfe57ffff]
pci 0000:00:00.0: reg 18: [io  0xe000-0xe01f]
pci 0000:00:00.0: reg 1c: [mem 0xfe5e0000-0xfe5e3fff]
pcifront pci-0: claiming resource 0000:00:00.0/0
pcifront pci-0: claiming resource 0000:00:00.0/1
pcifront pci-0: claiming resource 0000:00:00.0/2
pcifront pci-0: claiming resource 0000:00:00.0/3
e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
e1000e 0000:00:00.0: Disabling ASPM L0s L1
e1000e 0000:00:00.0: enabling device (0000 -> 0002)
e1000e 0000:00:00.0: Xen PCI mapped GSI16 to IRQ34
e1000e 0000:00:00.0: (unregistered net_device): Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
e1000e 0000:00:00.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1b:21:ab:c6:13
e1000e 0000:00:00.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:00.0: eth0: MAC: 3, PHY: 8, PBA No: E46981-005

The "Warning only" will go away if one supplies 'iommu=soft' instead
as we have a higher chance of being able to allocate large swaths of
memory.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/pci/xen-pcifront.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index d6cc62c..0ad8ca3 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -21,6 +21,7 @@
 #include <linux/bitops.h>
 #include <linux/time.h>
 
+#include <asm/xen/swiotlb-xen.h>
 #define INVALID_GRANT_REF (0)
 #define INVALID_EVTCHN    (-1)
 
@@ -668,7 +669,7 @@ static irqreturn_t pcifront_handler_aer(int irq, void *dev)
 	schedule_pcifront_aer_op(pdev);
 	return IRQ_HANDLED;
 }
-static int pcifront_connect(struct pcifront_device *pdev)
+static int pcifront_connect_and_init_dma(struct pcifront_device *pdev)
 {
 	int err = 0;
 
@@ -681,9 +682,13 @@ static int pcifront_connect(struct pcifront_device *pdev)
 		dev_err(&pdev->xdev->dev, "PCI frontend already installed!\n");
 		err = -EEXIST;
 	}
-
 	spin_unlock(&pcifront_dev_lock);
 
+	if (!err && !swiotlb_nr_tbl()) {
+		err = pci_xen_swiotlb_init_late();
+		if (err)
+			dev_err(&pdev->xdev->dev, "Could not setup SWIOTLB!\n");
+	}
 	return err;
 }
 
@@ -842,10 +847,10 @@ static int __devinit pcifront_try_connect(struct pcifront_device *pdev)
 	    XenbusStateInitialised)
 		goto out;
 
-	err = pcifront_connect(pdev);
+	err = pcifront_connect_and_init_dma(pdev);
 	if (err) {
 		xenbus_dev_fatal(pdev->xdev, err,
-				 "Error connecting PCI Frontend");
+				 "Error setting up PCI Frontend");
 		goto out;
 	}
 
-- 
1.7.7.6

