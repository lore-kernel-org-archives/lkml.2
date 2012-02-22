Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2BVOUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:20:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38952 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615Ab2BVOUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:20:47 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regmap: Expose the driver name in debugfs
Date: Wed, 22 Feb 2012 14:20:09 +0000
Message-Id: <1329920409-30426-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `name' file should contain the name of the device
driver.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index b3b4b8f..a5a96a5 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -33,6 +33,35 @@ static int regmap_open_file(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static ssize_t regmap_name_read_file(struct file *file,
+				     char __user *user_buf, size_t count,
+				     loff_t *ppos)
+{
+	struct regmap *map = file->private_data;
+	int ret;
+	char *buf;
+
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = snprintf(buf, PAGE_SIZE, "%s\n", map->dev->driver->name);
+	if (ret < 0) {
+		kfree(buf);
+		return ret;
+	}
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations regmap_name_fops = {
+	.open = regmap_open_file,
+	.read = regmap_name_read_file,
+	.llseek = default_llseek,
+};
+
 static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
 				    size_t count, loff_t *ppos)
 {
@@ -186,6 +215,9 @@ void regmap_debugfs_init(struct regmap *map)
 		return;
 	}
 
+	debugfs_create_file("name", 0400, map->debugfs,
+			    map, &regmap_name_fops);
+
 	if (map->max_register) {
 		debugfs_create_file("registers", 0400, map->debugfs,
 				    map, &regmap_map_fops);
-- 
1.7.9.1

