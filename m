Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0LUXte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:49:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54146 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752191Ab0LUXtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:49:33 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Brandon Leong <bleong@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Add initial per-regulator debugfs support
Date: Tue, 21 Dec 2010 23:49:31 +0000
Message-Id: <1292975371-32233-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only expose the use and open counts to userspace, providing a tiny
bit of insight into what the API is up to.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This is clearly a completely different tack to Brandon's patches in
terms of content but it does expose a bit of the internals like I was
talking about in review of those patches and it gets the basic debugfs
setup stuff done so we don't need to re-review that.

 drivers/regulator/core.c         |   35 +++++++++++++++++++++++++++++++++++
 include/linux/regulator/driver.h |    8 ++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 6066a8f..9fa2095 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -17,6 +17,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/err.h>
@@ -47,6 +48,10 @@ static LIST_HEAD(regulator_map_list);
 static bool has_full_constraints;
 static bool board_wants_dummy_regulator;
 
+#ifdef CONFIG_DEBUG_FS
+static struct dentry *debugfs_root;
+#endif
+
 /*
  * struct regulator_map
  *
@@ -2404,6 +2409,23 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
 	return status;
 }
 
+static void rdev_init_debugfs(struct regulator_dev *rdev)
+{
+#ifdef CONFIG_DEBUG_FS
+	rdev->debugfs = debugfs_create_dir(rdev_get_name(rdev), debugfs_root);
+	if (IS_ERR(rdev->debugfs) || !rdev->debugfs) {
+		rdev_warn(rdev, "Failed to create debugfs directory\n");
+		rdev->debugfs = NULL;
+		return;
+	}
+
+	debugfs_create_u32("use_count", 0444, rdev->debugfs,
+			   &rdev->use_count);
+	debugfs_create_u32("open_count", 0444, rdev->debugfs,
+			   &rdev->open_count);
+#endif
+}
+
 /**
  * regulator_register - register regulator
  * @regulator_desc: regulator to register
@@ -2548,6 +2570,8 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	}
 
 	list_add(&rdev->list, &regulator_list);
+
+	rdev_init_debugfs(rdev);
 out:
 	mutex_unlock(&regulator_list_mutex);
 	return rdev;
@@ -2580,6 +2604,9 @@ void regulator_unregister(struct regulator_dev *rdev)
 		return;
 
 	mutex_lock(&regulator_list_mutex);
+#ifdef CONFIG_DEBUG_FS
+	debugfs_remove_recursive(rdev->debugfs);
+#endif
 	WARN_ON(rdev->open_count);
 	unset_regulator_supplies(rdev);
 	list_del(&rdev->list);
@@ -2723,6 +2750,14 @@ static int __init regulator_init(void)
 
 	ret = class_register(&regulator_class);
 
+#ifdef CONFIG_DEBUG_FS
+	debugfs_root = debugfs_create_dir("regulator", NULL);
+	if (IS_ERR(debugfs_root) || !debugfs_root) {
+		pr_warn("regulator: Failed to create debugfs directory\n");
+		debugfs_root = NULL;
+	}
+#endif
+
 	regulator_dummy_init();
 
 	return ret;
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 975ae06..b8ed16a 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -175,9 +175,9 @@ struct regulator_desc {
  */
 struct regulator_dev {
 	struct regulator_desc *desc;
-	int use_count;
-	int open_count;
 	int exclusive;
+	u32 use_count;
+	u32 open_count;
 
 	/* lists we belong to */
 	struct list_head list; /* list of all regulators */
@@ -195,6 +195,10 @@ struct regulator_dev {
 	struct regulator_dev *supply;	/* for tree */
 
 	void *reg_data;		/* regulator_dev data */
+
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debugfs;
+#endif
 };
 
 struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
-- 
1.5.4.3

