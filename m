Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab1KRQyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:54:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58404 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597Ab1KRQyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:54:03 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Remove indexed cache type
Date: Fri, 18 Nov 2011 16:53:59 +0000
Message-Id: <1321635239-31776-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no situation where it offers any advantage over rbtree
and there are no current users so remove the code for simplicity.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/Makefile           |    2 +-
 drivers/base/regmap/internal.h         |    3 -
 drivers/base/regmap/regcache-indexed.c |   64 --------------------------------
 drivers/base/regmap/regcache.c         |   20 ----------
 include/linux/regmap.h                 |    1 -
 5 files changed, 1 insertions(+), 89 deletions(-)
 delete mode 100644 drivers/base/regmap/regcache-indexed.c

diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index 3dbe5d3..defd579 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_REGMAP) += regmap.o regcache.o regcache-indexed.o
+obj-$(CONFIG_REGMAP) += regmap.o regcache.o
 obj-$(CONFIG_REGMAP) += regcache-rbtree.o regcache-lzo.o
 obj-$(CONFIG_DEBUG_FS) += regmap-debugfs.o
 obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 954f7b7..1a02b75 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -119,10 +119,7 @@ unsigned int regcache_get_val(const void *base, unsigned int idx,
 bool regcache_set_val(void *base, unsigned int idx,
 		      unsigned int val, unsigned int word_size);
 int regcache_lookup_reg(struct regmap *map, unsigned int reg);
-int regcache_insert_reg(struct regmap *map, unsigned int reg,
-			unsigned int val);
 
-extern struct regcache_ops regcache_indexed_ops;
 extern struct regcache_ops regcache_rbtree_ops;
 extern struct regcache_ops regcache_lzo_ops;
 
diff --git a/drivers/base/regmap/regcache-indexed.c b/drivers/base/regmap/regcache-indexed.c
deleted file mode 100644
index 507731a..0000000
--- a/drivers/base/regmap/regcache-indexed.c
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- * Register cache access API - indexed caching support
- *
- * Copyright 2011 Wolfson Microelectronics plc
- *
- * Author: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/slab.h>
-
-#include "internal.h"
-
-static int regcache_indexed_read(struct regmap *map, unsigned int reg,
-				 unsigned int *value)
-{
-	int ret;
-
-	ret = regcache_lookup_reg(map, reg);
-	if (ret >= 0)
-		*value = map->reg_defaults[ret].def;
-
-	return ret;
-}
-
-static int regcache_indexed_write(struct regmap *map, unsigned int reg,
-				  unsigned int value)
-{
-	int ret;
-
-	ret = regcache_lookup_reg(map, reg);
-	if (ret < 0)
-		return regcache_insert_reg(map, reg, value);
-	map->reg_defaults[ret].def = value;
-	return 0;
-}
-
-static int regcache_indexed_sync(struct regmap *map)
-{
-	unsigned int i;
-	int ret;
-
-	for (i = 0; i < map->num_reg_defaults; i++) {
-		ret = _regmap_write(map, map->reg_defaults[i].reg,
-				    map->reg_defaults[i].def);
-		if (ret < 0)
-			return ret;
-		dev_dbg(map->dev, "Synced register %#x, value %#x\n",
-			map->reg_defaults[i].reg,
-			map->reg_defaults[i].def);
-	}
-	return 0;
-}
-
-struct regcache_ops regcache_indexed_ops = {
-	.type = REGCACHE_INDEXED,
-	.name = "indexed",
-	.read = regcache_indexed_read,
-	.write = regcache_indexed_write,
-	.sync = regcache_indexed_sync
-};
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index e21eebd..1ca2d7a 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -19,7 +19,6 @@
 #include "internal.h"
 
 static const struct regcache_ops *cache_types[] = {
-	&regcache_indexed_ops,
 	&regcache_rbtree_ops,
 	&regcache_lzo_ops,
 };
@@ -420,22 +419,3 @@ int regcache_lookup_reg(struct regmap *map, unsigned int reg)
 	else
 		return -ENOENT;
 }
-
-int regcache_insert_reg(struct regmap *map, unsigned int reg,
-			unsigned int val)
-{
-	void *tmp;
-
-	tmp = krealloc(map->reg_defaults,
-		       (map->num_reg_defaults + 1) * sizeof(struct reg_default),
-		       GFP_KERNEL);
-	if (!tmp)
-		return -ENOMEM;
-	map->reg_defaults = tmp;
-	map->num_reg_defaults++;
-	map->reg_defaults[map->num_reg_defaults - 1].reg = reg;
-	map->reg_defaults[map->num_reg_defaults - 1].def = val;
-	sort(map->reg_defaults, map->num_reg_defaults,
-	     sizeof(struct reg_default), regcache_default_cmp, NULL);
-	return 0;
-}
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 458f15f..81dfe0a 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -23,7 +23,6 @@ struct spi_device;
 /* An enum of all the supported cache types */
 enum regcache_type {
 	REGCACHE_NONE,
-	REGCACHE_INDEXED,
 	REGCACHE_RBTREE,
 	REGCACHE_COMPRESSED
 };
-- 
1.7.7.3

