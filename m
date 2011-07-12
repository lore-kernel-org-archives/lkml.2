Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1GLQjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:39:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39680 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab1GLQjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:39:11 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] spectra: enable device before poking it
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 12 Jul 2011 17:40:03 +0100
Message-ID: <20110712163924.7541.49192.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Otherwise if it is off at boot time things don't go to plan.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/spectra/lld_nand.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)


diff --git a/drivers/staging/spectra/lld_nand.c b/drivers/staging/spectra/lld_nand.c
index 0be7adc..60a14ff 100644
--- a/drivers/staging/spectra/lld_nand.c
+++ b/drivers/staging/spectra/lld_nand.c
@@ -2397,6 +2397,12 @@ static int nand_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	struct mrst_nand_info *pndev = &info;
 	u32 int_mask;
 
+	ret = pci_enable_device(dev);
+	if (ret) {
+		printk(KERN_ERR "Spectra: pci_enable_device failed.\n");
+		return ret;
+	}
+
 	nand_dbg_print(NAND_DBG_WARN, "%s, Line %d, Function: %s\n",
 		       __FILE__, __LINE__, __func__);
 
@@ -2404,7 +2410,7 @@ static int nand_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 			GLOB_HWCTL_REG_SIZE);
 	if (!FlashReg) {
 		printk(KERN_ERR "Spectra: ioremap_nocache failed!");
-		return -ENOMEM;
+		goto failed_disable;
 	}
 	nand_dbg_print(NAND_DBG_WARN,
 		"Spectra: Remapped reg base address: "
@@ -2416,7 +2422,7 @@ static int nand_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (!FlashMem) {
 		printk(KERN_ERR "Spectra: ioremap_nocache failed!");
 		iounmap(FlashReg);
-		return -ENOMEM;
+		goto failed_disable;
 	}
 	nand_dbg_print(NAND_DBG_WARN,
 		"Spectra: Remapped flash base address: "
@@ -2479,11 +2485,6 @@ static int nand_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	iowrite32(0, FlashReg + TWO_ROW_ADDR_CYCLES);
 	iowrite32(1, FlashReg + ECC_ENABLE);
 	enable_ecc = 1;
-	ret = pci_enable_device(dev);
-	if (ret) {
-		printk(KERN_ERR "Spectra: pci_enable_device failed.\n");
-		goto failed_req_csr;
-	}
 
 	pci_set_master(dev);
 	pndev->dev = dev;
@@ -2558,9 +2559,10 @@ static int nand_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 failed_remap_csr:
 	pci_release_regions(dev);
 failed_req_csr:
-	pci_disable_device(dev);
 	iounmap(FlashMem);
 	iounmap(FlashReg);
+failed_disable:
+	pci_disable_device(dev);
 
 	return ret;
 }

