Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab1FSMdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 08:33:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47001 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753535Ab1FSMdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 08:33:21 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Add basic per consumer debugfs
Date: Sun, 19 Jun 2011 13:33:16 +0100
Message-Id: <1308486796-10065-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report the requested load and voltage for each consumer in debugfs when it
is enabled.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cc3dfd6..f59821f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -81,6 +81,9 @@ struct regulator {
 	char *supply_name;
 	struct device_attribute dev_attr;
 	struct regulator_dev *rdev;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debugfs;
+#endif
 };
 
 static int _regulator_is_enabled(struct regulator_dev *rdev);
@@ -1093,7 +1096,28 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 				  dev->kobj.name, err);
 			goto link_name_err;
 		}
+	} else {
+		regulator->supply_name = kstrdup(supply_name, GFP_KERNEL);
+		if (regulator->supply_name == NULL)
+			goto attr_err;
+	}
+
+#ifdef CONFIG_DEBUG_FS
+	regulator->debugfs = debugfs_create_dir(regulator->supply_name,
+						rdev->debugfs);
+	if (IS_ERR_OR_NULL(regulator->debugfs)) {
+		rdev_warn(rdev, "Failed to create debugfs directory\n");
+		regulator->debugfs = NULL;
+	} else {
+		debugfs_create_u32("uA_load", 0444, regulator->debugfs,
+				   &regulator->uA_load);
+		debugfs_create_u32("min_uV", 0444, regulator->debugfs,
+				   &regulator->min_uV);
+		debugfs_create_u32("max_uV", 0444, regulator->debugfs,
+				   &regulator->max_uV);
 	}
+#endif
+
 	mutex_unlock(&rdev->mutex);
 	return regulator;
 link_name_err:
@@ -1272,13 +1296,17 @@ void regulator_put(struct regulator *regulator)
 	mutex_lock(&regulator_list_mutex);
 	rdev = regulator->rdev;
 
+#ifdef CONFIG_DEBUG_FS
+	debugfs_remove_recursive(regulator->debugfs);
+#endif
+
 	/* remove any sysfs entries */
 	if (regulator->dev) {
 		sysfs_remove_link(&rdev->dev.kobj, regulator->supply_name);
-		kfree(regulator->supply_name);
 		device_remove_file(regulator->dev, &regulator->dev_attr);
 		kfree(regulator->dev_attr.attr.name);
 	}
+	kfree(regulator->supply_name);
 	list_del(&regulator->list);
 	kfree(regulator);
 
-- 
1.7.5.4

