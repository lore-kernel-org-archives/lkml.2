Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1IBPqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:46:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35192 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753195Ab1IBPqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:46:34 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/8] regmap: Add the indexed cache support
Date: Fri,  2 Sep 2011 16:46:09 +0100
Message-Id: <1314978375-11539-3-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the simplest form of a cache available in regcache.  Any
registers whose default value is 0 are ignored.  If any of those
registers are modified in the future, they will be placed in the
cache on demand.  The cache layout is essentially using the provided
register defaults by the regcache core directly and does not re-map
it to another representation.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/Makefile           |    2 +-
 drivers/base/regmap/internal.h         |    1 +
 drivers/base/regmap/regcache-indexed.c |   65 ++++++++++++++++++++++++++++++++
 drivers/base/regmap/regcache.c         |    3 +
 include/linux/regmap.h                 |    1 +
 5 files changed, 71 insertions(+), 1 deletions(-)
 create mode 100644 drivers/base/regmap/regcache-indexed.c

diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index 2e103ea..418d151 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_REGMAP) += regmap.o regcache.o
+obj-$(CONFIG_REGMAP) += regmap.o regcache.o regcache-indexed.o
 obj-$(CONFIG_DEBUG_FS) += regmap-debugfs.o
 obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
 obj-$(CONFIG_REGMAP_SPI) += regmap-spi.o
diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index b7acbeb..148ab9f 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -113,4 +113,5 @@ int regcache_lookup_reg(struct regmap *map, unsigned int reg);
 int regcache_insert_reg(struct regmap *map, unsigned int reg,
 			unsigned int val);
 
+extern struct regcache_ops regcache_indexed_ops;
 #endif
diff --git a/drivers/base/regmap/regcache-indexed.c b/drivers/base/regmap/regcache-indexed.c
new file mode 100644
index 0000000..1f1af43
--- /dev/null
+++ b/drivers/base/regmap/regcache-indexed.c
@@ -0,0 +1,65 @@
+/*
+ * Register cache access API - indexed caching support
+ *
+ * Copyright 2011 Wolfson Microelectronics plc
+ *
+ * Author: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/slab.h>
+
+#include "internal.h"
+
+static int regcache_indexed_read(struct regmap *map, unsigned int reg,
+				 unsigned int *value)
+{
+	int ret;
+
+	ret = regcache_lookup_reg(map, reg);
+	if (ret < 0)
+		*value = 0;
+	else
+		*value = map->cache_defaults[ret].def;
+	return 0;
+}
+
+static int regcache_indexed_write(struct regmap *map, unsigned int reg,
+				  unsigned int value)
+{
+	int ret;
+
+	ret = regcache_lookup_reg(map, reg);
+	if (ret < 0)
+		return regcache_insert_reg(map, reg, value);
+	map->cache_defaults[ret].def = value;
+	return 0;
+}
+
+static int regcache_indexed_sync(struct regmap *map)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < map->num_cache_defaults; ++i) {
+		ret = regmap_write(map, map->cache_defaults[i].reg,
+				   map->cache_defaults[i].def);
+		if (ret < 0)
+			return ret;
+		dev_dbg(map->dev, "Synced register %#x, value %#x\n",
+			map->cache_defaults[i].reg,
+			map->cache_defaults[i].def);
+	}
+	return 0;
+}
+
+struct regcache_ops regcache_indexed_ops = {
+	.type = REGCACHE_INDEXED,
+	.name = "indexed",
+	.read = regcache_indexed_read,
+	.write = regcache_indexed_write,
+	.sync = regcache_indexed_sync
+};
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 90b7e1f..dfefe40 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -16,6 +16,9 @@
 #include "internal.h"
 
 static const struct regcache_ops *cache_types[] = {
+#ifdef CONFIG_REGCACHE_INDEXED
+	&regcache_indexed_ops,
+#endif
 };
 
 int regcache_init(struct regmap *map)
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index b81e86a..4d1ad09 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -23,6 +23,7 @@ struct spi_device;
 /* An enum of all the supported cache types */
 enum regcache_type {
 	REGCACHE_NONE,
+	REGCACHE_INDEXED,
 };
 
 /**
-- 
1.7.6.1

