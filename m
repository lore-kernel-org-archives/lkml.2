Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422680Ab2CPK1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:27:16 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60975 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161009Ab2CPK1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:27:14 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/edac/amd8131_edac.c: add missing pci_dev_put
Date: Fri, 16 Mar 2012 11:27:06 +0100
Message-Id: <1331893626-5368-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Add a call to pci_dev_put in each error case.  This is motivated by the
associated remove function, which always calls pci_dev_put.

Shift the error-handling code to the end of the function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/edac/amd8131_edac.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/amd8131_edac.c b/drivers/edac/amd8131_edac.c
index a5c6805..dcfd53b 100644
--- a/drivers/edac/amd8131_edac.c
+++ b/drivers/edac/amd8131_edac.c
@@ -249,6 +249,7 @@ static struct amd8131_info amd8131_chipset = {
 static int amd8131_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	struct amd8131_dev_info *dev_info;
+	int ret;
 
 	for (dev_info = amd8131_chipset.devices; dev_info->inst != NO_BRIDGE;
 		dev_info++)
@@ -265,12 +266,12 @@ static int amd8131_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	dev_info->dev = pci_dev_get(dev);
 
 	if (pci_enable_device(dev_info->dev)) {
-		pci_dev_put(dev_info->dev);
 		printk(KERN_ERR "failed to enable:"
 			"vendor %x, device %x, devfn %x, name %s\n",
 			PCI_VENDOR_ID_AMD, amd8131_chipset.err_dev,
 			dev_info->devfn, dev_info->ctl_name);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto error;
 	}
 
 	/*
@@ -280,8 +281,10 @@ static int amd8131_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	 */
 	dev_info->edac_idx = edac_pci_alloc_index();
 	dev_info->edac_dev = edac_pci_alloc_ctl_info(0, dev_info->ctl_name);
-	if (!dev_info->edac_dev)
-		return -ENOMEM;
+	if (!dev_info->edac_dev) {
+		ret = -ENOMEM;
+		goto error;
+	}
 
 	dev_info->edac_dev->pvt_info = dev_info;
 	dev_info->edac_dev->dev = &dev_info->dev->dev;
@@ -298,8 +301,8 @@ static int amd8131_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (edac_pci_add_device(dev_info->edac_dev, dev_info->edac_idx) > 0) {
 		printk(KERN_ERR "failed edac_pci_add_device() for %s\n",
 			dev_info->ctl_name);
-		edac_pci_free_ctl_info(dev_info->edac_dev);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto error_info;
 	}
 
 	printk(KERN_INFO "added one device on AMD8131 "
@@ -308,6 +311,11 @@ static int amd8131_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		dev_info->devfn, dev_info->ctl_name);
 
 	return 0;
+error_info:
+	edac_pci_free_ctl_info(dev_info->edac_dev);
+error:
+	pci_dev_put(dev_info->dev);
+	return ret;
 }
 
 static void amd8131_remove(struct pci_dev *dev)

