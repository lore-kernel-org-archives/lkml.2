Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab2LSOxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 09:53:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37570 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521Ab2LSOxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 09:53:47 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <damm@opensource.se>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: flat: Add flat cache type
Date: Wed, 19 Dec 2012 14:53:43 +0000
Message-Id: <1355928823-25950-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While for I2C and SPI devices the overhead of using rbtree for devices with
only one block of registers is negligible the same isn't always going to
be true for MMIO devices where the I/O costs are very much lower. Cater
for these devices by adding a simple flat array type for them where the
lookups are simple array accesses, taking us right back to the original
ASoC cache implementation.

Thanks to Magnus Damm for the discussion which prompted this.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/Makefile        |    2 +-
 drivers/base/regmap/internal.h      |    1 +
 drivers/base/regmap/regcache-flat.c |   72 +++++++++++++++++++++++++++++++++++
 drivers/base/regmap/regcache.c      |    1 +
 include/linux/regmap.h              |    3 +-
 5 files changed, 77 insertions(+), 2 deletions(-)
 create mode 100644 drivers/base/regmap/regcache-flat.c

diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index 5e75d1b..cf12998 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_REGMAP) += regmap.o regcache.o
-obj-$(CONFIG_REGMAP) += regcache-rbtree.o regcache-lzo.o
+obj-$(CONFIG_REGMAP) += regcache-rbtree.o regcache-lzo.o regcache-flat.o
 obj-$(CONFIG_DEBUG_FS) += regmap-debugfs.o
 obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
 obj-$(CONFIG_REGMAP_SPI) += regmap-spi.o
diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 401d191..e22bb80 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -177,5 +177,6 @@ int regcache_lookup_reg(struct regmap *map, unsigned int reg);
 
 extern struct regcache_ops regcache_rbtree_ops;
 extern struct regcache_ops regcache_lzo_ops;
+extern struct regcache_ops regcache_flat_ops;
 
 #endif
diff --git a/drivers/base/regmap/regcache-flat.c b/drivers/base/regmap/regcache-flat.c
new file mode 100644
index 0000000..d9762e4
--- /dev/null
+++ b/drivers/base/regmap/regcache-flat.c
@@ -0,0 +1,72 @@
+/*
+ * Register cache access API - flat caching support
+ *
+ * Copyright 2012 Wolfson Microelectronics plc
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/seq_file.h>
+
+#include "internal.h"
+
+static int regcache_flat_init(struct regmap *map)
+{
+	int i;
+	unsigned int *cache;
+
+	map->cache = kzalloc(sizeof(unsigned int) * (map->max_register + 1),
+			     GFP_KERNEL);
+	if (!map->cache)
+		return -ENOMEM;
+
+	cache = map->cache;
+
+	for (i = 0; i < map->num_reg_defaults; i++)
+		cache[map->reg_defaults[i].reg] = map->reg_defaults[i].def;
+
+	return 0;
+}
+
+static int regcache_flat_exit(struct regmap *map)
+{
+	kfree(map->cache);
+	map->cache = NULL;
+
+	return 0;
+}
+
+static int regcache_flat_read(struct regmap *map,
+			      unsigned int reg, unsigned int *value)
+{
+	unsigned int *cache = map->cache;
+
+	*value = cache[reg];
+
+	return 0;
+}
+
+static int regcache_flat_write(struct regmap *map, unsigned int reg,
+			       unsigned int value)
+{
+	unsigned int *cache = map->cache;
+
+	cache[reg] = value;
+
+	return 0;
+}
+
+struct regcache_ops regcache_flat_ops = {
+	.type = REGCACHE_FLAT,
+	.name = "flat",
+	.init = regcache_flat_init,
+	.exit = regcache_flat_exit,
+	.read = regcache_flat_read,
+	.write = regcache_flat_write,
+};
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 835883b..e69ff3e 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -22,6 +22,7 @@
 static const struct regcache_ops *cache_types[] = {
 	&regcache_rbtree_ops,
 	&regcache_lzo_ops,
+	&regcache_flat_ops,
 };
 
 static int regcache_hw_init(struct regmap *map)
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index b7e95bf..390d879 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -28,7 +28,8 @@ struct regmap_range_cfg;
 enum regcache_type {
 	REGCACHE_NONE,
 	REGCACHE_RBTREE,
-	REGCACHE_COMPRESSED
+	REGCACHE_COMPRESSED,
+	REGCACHE_FLAT,
 };
 
 /**
-- 
1.7.10.4

