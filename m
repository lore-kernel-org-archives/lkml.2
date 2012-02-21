Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab2BUGup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 01:50:45 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23359 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2BUGuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 01:50:44 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6626"; a="162556987"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: Simplify debugfs code
Date: Mon, 20 Feb 2012 22:50:42 -0800
Message-Id: <1329807042-19090-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.1.244.gb0d66b
In-Reply-To: <Message-Id: <1329772500-20577-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <Message-Id: <1329772500-20577-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_DEBUG_FS=y debugfs functions will never return an
ERR_PTR. Instead they'll return NULL. The intent is to remove
ifdefs in calling code.

Update the code to reflect this. We gain an extra dentry pointer
per struct regulator and struct regulator_dev but that should be
ok because most distros have debugfs compiled in anyway.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

> Personally I'd be happy to do that, the only reason I put the ifdefs in
> there was that it appears to be idiomatic to do so but I'm not really a
> big fan of it.  Then again I never build kernls without debugfs support
> in them myself...

Here's the patch on top of your patch in case you want it. My compiler 
seems to be clever enough to remove the supply_map_fops when debugfs isn't
enabled.

 drivers/regulator/core.c         |   28 ++++++----------------------
 include/linux/regulator/driver.h |    2 --
 2 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 6b63159..32ba89b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -54,9 +54,7 @@ static LIST_HEAD(regulator_map_list);
 static bool has_full_constraints;
 static bool board_wants_dummy_regulator;
 
-#ifdef CONFIG_DEBUG_FS
 static struct dentry *debugfs_root;
-#endif
 
 /*
  * struct regulator_map
@@ -84,9 +82,7 @@ struct regulator {
 	char *supply_name;
 	struct device_attribute dev_attr;
 	struct regulator_dev *rdev;
-#ifdef CONFIG_DEBUG_FS
 	struct dentry *debugfs;
-#endif
 };
 
 static int _regulator_is_enabled(struct regulator_dev *rdev);
@@ -1142,12 +1138,10 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 			goto attr_err;
 	}
 
-#ifdef CONFIG_DEBUG_FS
 	regulator->debugfs = debugfs_create_dir(regulator->supply_name,
 						rdev->debugfs);
-	if (IS_ERR_OR_NULL(regulator->debugfs)) {
+	if (!regulator->debugfs) {
 		rdev_warn(rdev, "Failed to create debugfs directory\n");
-		regulator->debugfs = NULL;
 	} else {
 		debugfs_create_u32("uA_load", 0444, regulator->debugfs,
 				   &regulator->uA_load);
@@ -1156,7 +1150,6 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 		debugfs_create_u32("max_uV", 0444, regulator->debugfs,
 				   &regulator->max_uV);
 	}
-#endif
 
 	mutex_unlock(&rdev->mutex);
 	return regulator;
@@ -1365,9 +1358,7 @@ void regulator_put(struct regulator *regulator)
 	mutex_lock(&regulator_list_mutex);
 	rdev = regulator->rdev;
 
-#ifdef CONFIG_DEBUG_FS
 	debugfs_remove_recursive(regulator->debugfs);
-#endif
 
 	/* remove any sysfs entries */
 	if (regulator->dev) {
@@ -2710,11 +2701,9 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
 
 static void rdev_init_debugfs(struct regulator_dev *rdev)
 {
-#ifdef CONFIG_DEBUG_FS
 	rdev->debugfs = debugfs_create_dir(rdev_get_name(rdev), debugfs_root);
-	if (IS_ERR_OR_NULL(rdev->debugfs)) {
+	if (!rdev->debugfs) {
 		rdev_warn(rdev, "Failed to create debugfs directory\n");
-		rdev->debugfs = NULL;
 		return;
 	}
 
@@ -2722,7 +2711,6 @@ static void rdev_init_debugfs(struct regulator_dev *rdev)
 			   &rdev->use_count);
 	debugfs_create_u32("open_count", 0444, rdev->debugfs,
 			   &rdev->open_count);
-#endif
 }
 
 /**
@@ -2902,9 +2890,7 @@ void regulator_unregister(struct regulator_dev *rdev)
 		return;
 
 	mutex_lock(&regulator_list_mutex);
-#ifdef CONFIG_DEBUG_FS
 	debugfs_remove_recursive(rdev->debugfs);
-#endif
 	flush_work_sync(&rdev->disable_work.work);
 	WARN_ON(rdev->open_count);
 	unset_regulator_supplies(rdev);
@@ -3114,12 +3100,14 @@ static ssize_t supply_map_read_file(struct file *file, char __user *user_buf,
 
 	return ret;
 }
+#endif
 
 static const struct file_operations supply_map_fops = {
+#ifdef CONFIG_DEBUG_FS
 	.read = supply_map_read_file,
 	.llseek = default_llseek,
-};
 #endif
+};
 
 static int __init regulator_init(void)
 {
@@ -3127,16 +3115,12 @@ static int __init regulator_init(void)
 
 	ret = class_register(&regulator_class);
 
-#ifdef CONFIG_DEBUG_FS
 	debugfs_root = debugfs_create_dir("regulator", NULL);
-	if (IS_ERR_OR_NULL(debugfs_root)) {
+	if (!debugfs_root)
 		pr_warn("regulator: Failed to create debugfs directory\n");
-		debugfs_root = NULL;
-	}
 
 	debugfs_create_file("supply_map", 0444, debugfs_root, NULL,
 			    &supply_map_fops);
-#endif
 
 	regulator_dummy_init();
 
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 4214b9a..c5dcada 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -207,9 +207,7 @@ struct regulator_dev {
 
 	void *reg_data;		/* regulator_dev data */
 
-#ifdef CONFIG_DEBUG_FS
 	struct dentry *debugfs;
-#endif
 };
 
 struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

