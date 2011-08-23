Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab1HWQjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:39:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52296 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753287Ab1HWQjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:39:14 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Add debugfs file showing the supply map table
Date: Tue, 23 Aug 2011 17:39:10 +0100
Message-Id: <1314117550-6663-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useful for working out why things aren't getting plugged together properly.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d8e6a42..9a33fe2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2907,6 +2907,43 @@ void *regulator_get_init_drvdata(struct regulator_init_data *reg_init_data)
 }
 EXPORT_SYMBOL_GPL(regulator_get_init_drvdata);
 
+#ifdef CONFIG_DEBUG_FS
+static ssize_t supply_map_read_file(struct file *file, char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	ssize_t len, ret = 0;
+	struct regulator_map *map;
+
+	if (!buf)
+		return -ENOMEM;
+
+	list_for_each_entry(map, &regulator_map_list, list) {
+		len = snprintf(buf + ret, PAGE_SIZE - ret,
+			       "%s -> %s.%s\n",
+			       rdev_get_name(map->regulator), map->dev_name,
+			       map->supply);
+		if (len >= 0)
+			ret += len;
+		if (ret > PAGE_SIZE) {
+			ret = PAGE_SIZE;
+			break;
+		}
+	}
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+
+	return ret;
+}
+
+static const struct file_operations supply_map_fops = {
+	.read = supply_map_read_file,
+	.llseek = default_llseek,
+};
+#endif
+
 static int __init regulator_init(void)
 {
 	int ret;
@@ -2919,6 +2956,10 @@ static int __init regulator_init(void)
 		pr_warn("regulator: Failed to create debugfs directory\n");
 		debugfs_root = NULL;
 	}
+
+	if (IS_ERR(debugfs_create_file("supply_map", 0444, debugfs_root,
+				       NULL, &supply_map_fops)))
+		pr_warn("regulator: Failed to create supplies debugfs\n");
 #endif
 
 	regulator_dummy_init();
-- 
1.7.5.4

