Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab1J1Rwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:52:47 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:48430 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab1J1Rwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:52:45 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 05/13] mtd/docg3: add multiple floor support
Date: Fri, 28 Oct 2011 19:51:24 +0200
Message-Id: <1319824292-11085-6-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for multiple floors, ie. cascaded docg3
chips. There might be 4 docg3 chips cascaded, sharing the
same address space, and providing up to 4 times the storage
capacity of a unique chip.

Each floor will be seen as an independant mtd device.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/docg3.c |  181 +++++++++++++++++++++++++++++-------------
 drivers/mtd/devices/docg3.h |    1 +
 2 files changed, 126 insertions(+), 56 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 5834e6e..709d886 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -952,7 +952,8 @@ static void __init doc_set_driver_info(int chip_id, struct mtd_info *mtd)
 
 	switch (chip_id) {
 	case DOC_CHIPID_G3:
-		mtd->name = "DiskOnChip G3";
+		mtd->name = kasprintf(GFP_KERNEL, "DiskOnChip G3 floor %d",
+				      docg3->device_id);
 		docg3->max_block = 2047;
 		break;
 	}
@@ -979,22 +980,24 @@ static void __init doc_set_driver_info(int chip_id, struct mtd_info *mtd)
 }
 
 /**
- * doc_probe - Probe the IO space for a DiskOnChip G3 chip
- * @pdev: platform device
+ * doc_probe_device - Check if a device is available
+ * @base: the io space where the device is probed
+ * @floor: the floor of the probed device
+ * @dev: the device
  *
- * Probes for a G3 chip at the specified IO space in the platform data
- * ressources.
+ * Checks whether a device at the specified IO range, and floor is available.
  *
- * Returns 0 on success, -ENOMEM, -ENXIO on error
+ * Returns a mtd_info struct if there is a device, ENODEV if none found, ENOMEM
+ * if a memory allocation failed. If floor 0 is checked, a reset of the ASIC is
+ * launched.
  */
-static int __init docg3_probe(struct platform_device *pdev)
+static struct mtd_info *doc_probe_device(void __iomem *base, int floor,
+					 struct device *dev)
 {
-	struct device *dev = &pdev->dev;
-	struct docg3 *docg3;
-	struct mtd_info *mtd;
-	struct resource *ress;
 	int ret, bbt_nbpages;
 	u16 chip_id, chip_id_inv;
+	struct docg3 *docg3;
+	struct mtd_info *mtd;
 
 	ret = -ENOMEM;
 	docg3 = kzalloc(sizeof(struct docg3), GFP_KERNEL);
@@ -1004,69 +1007,132 @@ static int __init docg3_probe(struct platform_device *pdev)
 	if (!mtd)
 		goto nomem2;
 	mtd->priv = docg3;
+	bbt_nbpages = DIV_ROUND_UP(docg3->max_block + 1,
+				   8 * DOC_LAYOUT_PAGE_SIZE);
+	docg3->bbt = kzalloc(bbt_nbpages * DOC_LAYOUT_PAGE_SIZE, GFP_KERNEL);
+	if (!docg3->bbt)
+		goto nomem3;
 
-	ret = -ENXIO;
-	ress = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!ress) {
-		dev_err(dev, "No I/O memory resource defined\n");
-		goto noress;
-	}
-	docg3->base = ioremap(ress->start, DOC_IOSPACE_SIZE);
-
-	docg3->dev = &pdev->dev;
-	docg3->device_id = 0;
+	docg3->dev = dev;
+	docg3->device_id = floor;
+	docg3->base = base;
 	doc_set_device_id(docg3, docg3->device_id);
-	doc_set_asic_mode(docg3, DOC_ASICMODE_RESET);
+	if (!floor)
+		doc_set_asic_mode(docg3, DOC_ASICMODE_RESET);
 	doc_set_asic_mode(docg3, DOC_ASICMODE_NORMAL);
 
 	chip_id = doc_register_readw(docg3, DOC_CHIPID);
 	chip_id_inv = doc_register_readw(docg3, DOC_CHIPID_INV);
 
-	ret = -ENODEV;
+	ret = 0;
 	if (chip_id != (u16)(~chip_id_inv)) {
-		doc_info("No device found at IO addr %p\n",
-			 (void *)ress->start);
-		goto nochipfound;
+		goto nomem3;
 	}
 
 	switch (chip_id) {
 	case DOC_CHIPID_G3:
-		doc_info("Found a G3 DiskOnChip at addr %p\n",
-			 (void *)ress->start);
+		doc_info("Found a G3 DiskOnChip at addr %p, floor %d\n",
+			 base, floor);
 		break;
 	default:
 		doc_err("Chip id %04x is not a DiskOnChip G3 chip\n", chip_id);
-		goto nochipfound;
+		goto nomem3;
 	}
 
 	doc_set_driver_info(chip_id, mtd);
-	platform_set_drvdata(pdev, mtd);
 
-	ret = -ENOMEM;
-	bbt_nbpages = DIV_ROUND_UP(docg3->max_block + 1,
-				   8 * DOC_LAYOUT_PAGE_SIZE);
-	docg3->bbt = kzalloc(bbt_nbpages * DOC_LAYOUT_PAGE_SIZE, GFP_KERNEL);
-	if (!docg3->bbt)
-		goto nochipfound;
 	doc_reload_bbt(docg3);
+	return mtd;
 
-	ret = mtd_device_parse_register(mtd, part_probes,
-					NULL, NULL, 0);
-	if (ret)
-		goto register_error;
-
-	doc_dbg_register(docg3);
-	return 0;
-
-register_error:
-	kfree(docg3->bbt);
-nochipfound:
-	iounmap(docg3->base);
-noress:
+nomem3:
 	kfree(mtd);
 nomem2:
 	kfree(docg3);
 nomem1:
+	return ERR_PTR(ret);
+}
+
+/**
+ * doc_release_device - Release a docg3 floor
+ * @mtd: the device
+ */
+static void doc_release_device(struct mtd_info *mtd)
+{
+	struct docg3 *docg3 = mtd->priv;
+
+	mtd_device_unregister(mtd);
+	kfree(docg3->bbt);
+	kfree(docg3);
+	kfree(mtd->name);
+	kfree(mtd);
+}
+
+/**
+ * doc_probe - Probe the IO space for a DiskOnChip G3 chip
+ * @pdev: platform device
+ *
+ * Probes for a G3 chip at the specified IO space in the platform data
+ * ressources. The floor 0 must be available.
+ *
+ * Returns 0 on success, -ENOMEM, -ENXIO on error
+ */
+static int __init docg3_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct mtd_info *mtd;
+	struct resource *ress;
+	void __iomem *base;
+	int ret, floor, found = 0;
+	struct mtd_info **docg3_floors;
+
+	ret = -ENXIO;
+	ress = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!ress) {
+		dev_err(dev, "No I/O memory resource defined\n");
+		goto noress;
+	}
+	base = ioremap(ress->start, DOC_IOSPACE_SIZE);
+
+	ret = -ENOMEM;
+	docg3_floors = kzalloc(sizeof(*docg3_floors) * DOC_MAX_NBFLOORS,
+			       GFP_KERNEL);
+	if (!docg3_floors)
+		goto nomem;
+
+	ret = 0;
+	for (floor = 0; floor < DOC_MAX_NBFLOORS; floor++) {
+		mtd = doc_probe_device(base, floor, dev);
+		if (floor == 0 && !mtd)
+			goto notfound;
+		if (!IS_ERR_OR_NULL(mtd))
+			ret = mtd_device_parse_register(mtd, part_probes,
+							NULL, NULL, 0);
+		else
+			ret = PTR_ERR(mtd);
+		docg3_floors[floor] = mtd;
+		if (ret)
+			goto err_probe;
+		if (mtd)
+			found++;
+	}
+
+	if (!found)
+		goto notfound;
+
+	platform_set_drvdata(pdev, docg3_floors);
+	doc_dbg_register(docg3_floors[0]->priv);
+	return 0;
+
+notfound:
+	ret = -ENODEV;
+	dev_info(dev, "No supported DiskOnChip found\n");
+err_probe:
+	for (floor = 0; floor < DOC_MAX_NBFLOORS; floor++)
+		if (docg3_floors[floor])
+			doc_release_device(docg3_floors[floor]);
+nomem:
+	iounmap(base);
+noress:
 	return ret;
 }
 
@@ -1078,15 +1144,18 @@ nomem1:
  */
 static int __exit docg3_release(struct platform_device *pdev)
 {
-	struct mtd_info *mtd = platform_get_drvdata(pdev);
-	struct docg3 *docg3 = mtd->priv;
+	struct mtd_info **docg3_floors = platform_get_drvdata(pdev);
+	struct docg3 *docg3 = docg3_floors[0]->priv;
+	void __iomem *base = docg3->base;
+	int floor;
 
 	doc_dbg_unregister(docg3);
-	mtd_device_unregister(mtd);
-	iounmap(docg3->base);
-	kfree(docg3->bbt);
-	kfree(docg3);
-	kfree(mtd);
+	for (floor = 0; floor < DOC_MAX_NBFLOORS; floor++)
+		if (docg3_floors[floor])
+			doc_release_device(docg3_floors[floor]);
+
+	kfree(docg3_floors);
+	iounmap(base);
 	return 0;
 }
 
diff --git a/drivers/mtd/devices/docg3.h b/drivers/mtd/devices/docg3.h
index 62af5aa..75df3a1 100644
--- a/drivers/mtd/devices/docg3.h
+++ b/drivers/mtd/devices/docg3.h
@@ -80,6 +80,7 @@
 
 #define DOC_CHIPID_G3			0x200
 #define DOC_ERASE_MARK			0xaa
+#define DOC_MAX_NBFLOORS		4
 /*
  * Flash registers
  */
-- 
1.7.5.4

