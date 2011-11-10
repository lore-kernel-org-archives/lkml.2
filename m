Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934114Ab1KJIJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:09:22 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:46182 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933702Ab1KJIHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:07:12 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 16/16] mtd/docg3: add protection areas sysfs access
Date: Thu, 10 Nov 2011 09:05:42 +0100
Message-Id: <1320912342-30147-17-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As each docg3 chip has 2 protection areas (DPS0 and DPS1),
and because theses areas can prevent user access to the chip
data, add for each floor the sysfs entries which insert the
protection key into the right DPS.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/docg3.c |  121 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/devices/docg3.h |   13 +++++
 2 files changed, 134 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 35df377..d7df311 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -1513,6 +1513,123 @@ static int doc_write(struct mtd_info *mtd, loff_t to, size_t len,
 	return ret;
 }
 
+static struct docg3 *sysfs_dev2docg3(struct device *dev,
+				     struct device_attribute *attr)
+{
+	int floor;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct mtd_info **docg3_floors = platform_get_drvdata(pdev);
+
+	floor = attr->attr.name[1] - '0';
+	if (floor < 0 || floor >= DOC_MAX_NBFLOORS)
+		return NULL;
+	else
+		return docg3_floors[floor]->priv;
+}
+
+static ssize_t dps0_is_key_locked(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct docg3 *docg3 = sysfs_dev2docg3(dev, attr);
+	int dps0;
+
+	doc_set_device_id(docg3, docg3->device_id);
+	dps0 = doc_register_readb(docg3, DOC_DPS0_STATUS);
+	doc_set_device_id(docg3, 0);
+
+	return sprintf(buf, "%d\n", !(dps0 & DOC_DPS_KEY_OK));
+}
+
+static ssize_t dps1_is_key_locked(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct docg3 *docg3 = sysfs_dev2docg3(dev, attr);
+	int dps1;
+
+	doc_set_device_id(docg3, docg3->device_id);
+	dps1 = doc_register_readb(docg3, DOC_DPS1_STATUS);
+	doc_set_device_id(docg3, 0);
+
+	return sprintf(buf, "%d\n", !(dps1 & DOC_DPS_KEY_OK));
+}
+
+static ssize_t dps0_insert_key(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct docg3 *docg3 = sysfs_dev2docg3(dev, attr);
+	int i;
+
+	if (count != DOC_LAYOUT_DPS_KEY_LENGTH)
+		return -EINVAL;
+
+	doc_set_device_id(docg3, docg3->device_id);
+	for (i = 0; i < DOC_LAYOUT_DPS_KEY_LENGTH; i++)
+		doc_writeb(docg3, buf[i], DOC_DPS0_KEY);
+	doc_set_device_id(docg3, 0);
+	return count;
+}
+
+static ssize_t dps1_insert_key(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct docg3 *docg3 = sysfs_dev2docg3(dev, attr);
+	int i;
+
+	if (count != DOC_LAYOUT_DPS_KEY_LENGTH)
+		return -EINVAL;
+
+	doc_set_device_id(docg3, docg3->device_id);
+	for (i = 0; i < DOC_LAYOUT_DPS_KEY_LENGTH; i++)
+		doc_writeb(docg3, buf[i], DOC_DPS1_KEY);
+	doc_set_device_id(docg3, 0);
+	return count;
+}
+
+#define FLOOR_SYSFS(id) { \
+	__ATTR(f##id##_dps0_is_keylocked, S_IRUGO, dps0_is_key_locked, NULL), \
+	__ATTR(f##id##_dps1_is_keylocked, S_IRUGO, dps1_is_key_locked, NULL), \
+	__ATTR(f##id##_dps0_protection_key, S_IWUGO, NULL, dps0_insert_key), \
+	__ATTR(f##id##_dps1_protection_key, S_IWUGO, NULL, dps1_insert_key), \
+}
+
+static struct device_attribute doc_sys_attrs[DOC_MAX_NBFLOORS][4] = {
+	FLOOR_SYSFS(0), FLOOR_SYSFS(1), FLOOR_SYSFS(2), FLOOR_SYSFS(3)
+};
+
+static int doc_register_sysfs(struct platform_device *pdev,
+			      struct mtd_info **floors)
+{
+	int ret = 0, floor, i = 0;
+	struct device *dev = &pdev->dev;
+
+	for (floor = 0; !ret && floor < DOC_MAX_NBFLOORS && floors[floor];
+	     floor++)
+		for (i = 0; !ret && i < 4; i++)
+			ret = device_create_file(dev, &doc_sys_attrs[floor][i]);
+	if (!ret)
+		return 0;
+	do {
+		while (--i >= 0)
+			device_remove_file(dev, &doc_sys_attrs[floor][i]);
+		i = 4;
+	} while (--floor >= 0);
+	return ret;
+}
+
+static void doc_unregister_sysfs(struct platform_device *pdev,
+				 struct mtd_info **floors)
+{
+	struct device *dev = &pdev->dev;
+	int floor, i;
+
+	for (floor = 0; floor < DOC_MAX_NBFLOORS && floors[floor];
+	     floor++)
+		for (i = 0; i < 4; i++)
+			device_remove_file(dev, &doc_sys_attrs[floor][i]);
+}
+
 /*
  * Debug sysfs entries
  */
@@ -1927,6 +2044,9 @@ static int __init docg3_probe(struct platform_device *pdev)
 			found++;
 	}
 
+	ret = doc_register_sysfs(pdev, docg3_floors);
+	if (ret)
+		goto err_probe;
 	if (!found)
 		goto notfound;
 
@@ -1963,6 +2083,7 @@ static int __exit docg3_release(struct platform_device *pdev)
 	void __iomem *base = docg3->base;
 	int floor;
 
+	doc_unregister_sysfs(pdev, docg3_floors);
 	doc_dbg_unregister(docg3);
 	for (floor = 0; floor < DOC_MAX_NBFLOORS; floor++)
 		if (docg3_floors[floor])
diff --git a/drivers/mtd/devices/docg3.h b/drivers/mtd/devices/docg3.h
index 07182f9..a349915 100644
--- a/drivers/mtd/devices/docg3.h
+++ b/drivers/mtd/devices/docg3.h
@@ -118,6 +118,8 @@
 #define DOC_BCH_SYNDROM(idx)		(0x1048 + (idx << 0))
 
 #define DOC_PROTECTION			0x1056
+#define DOC_DPS0_KEY			0x105c
+#define DOC_DPS1_KEY			0x105e
 #define DOC_DPS0_ADDRLOW		0x1060
 #define DOC_DPS0_ADDRHIGH		0x1062
 #define DOC_DPS1_ADDRLOW		0x1064
@@ -252,6 +254,17 @@
 #define DOC_PLANES_STATUS_PLANE0_KO	0x02
 #define DOC_PLANES_STATUS_PLANE1_KO	0x04
 
+/*
+ * DPS key management
+ *
+ * Each floor of docg3 has 2 protection areas: DPS0 and DPS1. These areas span
+ * across block boundaries, and define whether these blocks can be read or
+ * written.
+ * The definition is dynamically stored in page 0 of blocks (2,3) for DPS0, and
+ * page 0 of blocks (4,5) for DPS1.
+ */
+#define DOC_LAYOUT_DPS_KEY_LENGTH	8
+
 /**
  * struct docg3 - DiskOnChip driver private data
  * @dev: the device currently under control
-- 
1.7.5.4

