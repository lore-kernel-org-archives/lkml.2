Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1GZSGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:06:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54061 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751630Ab1GZSGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:06:23 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/5] regmap: Provide register map dump via debugfs
Date: Tue, 26 Jul 2011 19:06:15 +0100
Message-Id: <1311703576-7955-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311703576-7955-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1311703576-7955-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy over the read parts of the ASoC debugfs implementation into regmap,
allowing users to see what the register values the device has are at
runtime. The implementation, especially the support for seeking, is
mostly due to Dimitris Papastamos' work in ASoC.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/Makefile         |    1 +
 drivers/base/regmap/internal.h       |   15 ++++
 drivers/base/regmap/regmap-debugfs.c |  131 ++++++++++++++++++++++++++++++++++
 drivers/base/regmap/regmap.c         |   11 +++
 4 files changed, 158 insertions(+), 0 deletions(-)
 create mode 100644 drivers/base/regmap/regmap-debugfs.c

diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index f476f45..057c13f 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_REGMAP) += regmap.o
+obj-$(CONFIG_DEBUG_FS) += regmap-debugfs.o
 obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
 obj-$(CONFIG_REGMAP_SPI) += regmap-spi.o
diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 7e61504..78f87f3 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -14,6 +14,7 @@
 #define _REGMAP_INTERNAL_H
 
 #include <linux/regmap.h>
+#include <linux/fs.h>
 
 struct regmap;
 
@@ -36,10 +37,24 @@ struct regmap {
 	struct regmap_format format;  /* Buffer format */
 	const struct regmap_bus *bus;
 
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debugfs;
+#endif
+
 	unsigned int max_register;
 	bool (*writeable_reg)(struct device *dev, unsigned int reg);
 	bool (*readable_reg)(struct device *dev, unsigned int reg);
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
 };
 
+#ifdef CONFIG_DEBUG_FS
+extern void regmap_debugfs_initcall(void);
+extern void regmap_debugfs_init(struct regmap *map);
+extern void regmap_debugfs_exit(struct regmap *map);
+#else
+void regmap_debugfs_initcall(void) { }
+void regmap_debugfs_init(struct regmap *map) { }
+void regmap_debugfs_exit(struct regmap *map) { }
+#endif
+
 #endif
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
new file mode 100644
index 0000000..2be8bf8
--- /dev/null
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -0,0 +1,131 @@
+/*
+ * Register map access API - debugfs
+ *
+ * Copyright 2011 Wolfson Microelectronics plc
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+
+#include "internal.h"
+
+static struct dentry *regmap_debugfs_root;
+
+static int regmap_map_open_file(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	size_t reg_len, val_len, tot_len;
+	size_t buf_pos = 0;
+	loff_t p = 0;
+	ssize_t ret;
+	int i;
+	struct regmap *map = file->private_data;
+	char *buf;
+	unsigned int val;
+
+	if (*ppos < 0 || !count)
+		return -EINVAL;
+
+	buf = kmalloc(count, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	/* Calculate the length of a fixed format  */
+	snprintf(buf, count, "%x", map->max_register);
+	reg_len = strlen(buf);
+	val_len = 2 * map->format.val_bytes;
+	tot_len = reg_len + val_len + 3;      /* : \n */
+
+	for (i = 0; i < map->max_register; i++) {
+		if (map->readable_reg &&
+		    !map->readable_reg(map->dev, i))
+			continue;
+
+		/* If we're in the region the user is trying to read */
+		if (p >= *ppos) {
+			/* ...but not beyond it */
+			if (buf_pos >= count - 1 - tot_len)
+				break;
+
+			/* Format the register */
+			snprintf(buf + buf_pos, count - buf_pos, "%.*x: ",
+				 reg_len, i);
+			buf_pos += reg_len + 2;
+
+			/* Format the value, write all X if we can't read */
+			ret = regmap_read(map, i, &val);
+			if (ret == 0)
+				snprintf(buf + buf_pos, count - buf_pos,
+					 "%.*x", val_len, val);
+			else
+				memset(buf + buf_pos, 'X', val_len);
+			buf_pos += 2 * map->format.val_bytes;
+
+			buf[buf_pos++] = '\n';
+		}
+		p += tot_len;
+	}
+
+	ret = buf_pos;
+
+	if (copy_to_user(user_buf, buf, buf_pos)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	*ppos += buf_pos;
+
+out:
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations regmap_map_fops = {
+	.open = regmap_map_open_file,
+	.read = regmap_map_read_file,
+	.llseek = default_llseek,
+};
+
+
+void regmap_debugfs_init(struct regmap *map)
+{
+	map->debugfs = debugfs_create_dir(dev_name(map->dev),
+					  regmap_debugfs_root);
+	if (!map->debugfs) {
+		dev_warn(map->dev, "Failed to create debugfs directory\n");
+		return;
+	}
+
+	if (map->max_register)
+		debugfs_create_file("registers", 0400, map->debugfs,
+				    map, &regmap_map_fops);
+}
+
+void regmap_debugfs_exit(struct regmap *map)
+{
+	debugfs_remove_recursive(map->debugfs);
+}
+
+void regmap_debugfs_initcall(void)
+{
+	regmap_debugfs_root = debugfs_create_dir("regmap", NULL);
+	if (!regmap_debugfs_root) {
+		pr_warn("regmap: Failed to create debugfs root\n");
+		return;
+	}
+}
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index f51efeb..a3eaef6 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -156,6 +156,8 @@ struct regmap *regmap_init(struct device *dev,
 		goto err_bus;
 	}
 
+	regmap_debugfs_init(map);
+
 	return map;
 
 err_bus:
@@ -172,6 +174,7 @@ EXPORT_SYMBOL_GPL(regmap_init);
  */
 void regmap_exit(struct regmap *map)
 {
+	regmap_debugfs_exit(map);
 	kfree(map->work_buf);
 	module_put(map->bus->owner);
 	kfree(map);
@@ -472,3 +475,11 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits);
+
+static int __init regmap_initcall(void)
+{
+	regmap_debugfs_initcall();
+
+	return 0;
+}
+postcore_initcall(regmap_initcall);
-- 
1.7.5.4

