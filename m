Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2JCMnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:43:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56180 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754375Ab2JCMnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:43:07 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] regmap: Provide debugfs read of register ranges
Date: Wed,  3 Oct 2012 13:43:02 +0100
Message-Id: <1349268182-21804-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349268182-21804-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1349268182-21804-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a register range is named then provide a debugfs file showing the
contents of the range separately.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h       |    1 +
 drivers/base/regmap/regmap-debugfs.c |   31 +++++++++++++++++++++++++++++++
 drivers/base/regmap/regmap.c         |    1 +
 3 files changed, 33 insertions(+)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 27e66c3..ac869d2 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -121,6 +121,7 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 struct regmap_range_node {
 	struct rb_node node;
 	const char *name;
+	struct regmap *map;
 
 	unsigned int range_min;
 	unsigned int range_max;
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 25b6843..f4b9dd0 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -183,6 +183,22 @@ static const struct file_operations regmap_map_fops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t regmap_range_read_file(struct file *file, char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct regmap_range_node *range = file->private_data;
+	struct regmap *map = range->map;
+
+	return regmap_read_debugfs(map, range->range_min, range->range_max,
+				   user_buf, count, ppos);
+}
+
+static const struct file_operations regmap_range_fops = {
+	.open = simple_open,
+	.read = regmap_range_read_file,
+	.llseek = default_llseek,
+};
+
 static ssize_t regmap_access_read_file(struct file *file,
 				       char __user *user_buf, size_t count,
 				       loff_t *ppos)
@@ -253,6 +269,9 @@ static const struct file_operations regmap_access_fops = {
 
 void regmap_debugfs_init(struct regmap *map, const char *name)
 {
+	struct rb_node *next;
+	struct regmap_range_node *range_node;
+
 	if (name) {
 		map->debugfs_name = kasprintf(GFP_KERNEL, "%s-%s",
 					      dev_name(map->dev), name);
@@ -285,6 +304,18 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 		debugfs_create_bool("cache_bypass", 0400, map->debugfs,
 				    &map->cache_bypass);
 	}
+
+	next = rb_first(&map->range_tree);
+	while (next) {
+		range_node = rb_entry(next, struct regmap_range_node, node);
+
+		if (range_node->name)
+			debugfs_create_file(range_node->name, 0400,
+					    map->debugfs, range_node,
+					    &regmap_range_fops);
+
+		next = rb_next(&range_node->node);
+	}
 }
 
 void regmap_debugfs_exit(struct regmap *map)
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index ce5129d..366b629 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -579,6 +579,7 @@ struct regmap *regmap_init(struct device *dev,
 			goto err_range;
 		}
 
+		new->map = map;
 		new->name = range_cfg->name;
 		new->range_min = range_cfg->range_min;
 		new->range_max = range_cfg->range_max;
-- 
1.7.10.4

