Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab1IOKex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 06:34:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55171 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932312Ab1IOKes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:34:48 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/6 v3] regmap: Introduce caching support
Date: Thu, 15 Sep 2011 11:34:34 +0100
Message-Id: <1316082879-21810-2-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316082879-21810-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1316082879-21810-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces caching support for regmap.  The regcache API
has evolved essentially out of ASoC soc-cache so most of the actual
caching types (except LZO) have been tested in the past.

The purpose of regcache is to optimize in time and space the handling
of register caches.  Time optimization is achieved by not having to go
over a slow bus like I2C to read the value of a register, instead it is
cached locally in memory and can be retrieved faster.  Regarding space
optimization, some of the cache types are better at packing the caches,
for e.g. the rbtree and the LZO caches.  By doing this the sacrifice in
time still wins over doing I2C transactions.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/Makefile   |    2 +-
 drivers/base/regmap/internal.h |   52 +++++++
 drivers/base/regmap/regcache.c |  313 ++++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h         |   24 +++-
 4 files changed, 385 insertions(+), 6 deletions(-)
 create mode 100644 drivers/base/regmap/regcache.c

diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index 057c13f..2e103ea 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_REGMAP) += regmap.o
+obj-$(CONFIG_REGMAP) += regmap.o regcache.o
 obj-$(CONFIG_DEBUG_FS) += regmap-debugfs.o
 obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
 obj-$(CONFIG_REGMAP_SPI) += regmap-spi.o
diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 5ab3fef..dbeccd2 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 
 struct regmap;
+struct regcache_ops;
 
 struct regmap_format {
 	size_t buf_size;
@@ -46,6 +47,40 @@ struct regmap {
 	bool (*readable_reg)(struct device *dev, unsigned int reg);
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
+
+	/* regcache specific members */
+	const struct regcache_ops *cache_ops;
+	enum regcache_type cache_type;
+
+	/* number of bytes in cache_defaults_raw */
+	unsigned int cache_size_raw;
+	/* number of bytes per word in cache_defaults_raw */
+	unsigned int cache_word_size;
+	/* number of entries in cache_defaults */
+	unsigned int num_cache_defaults;
+	/* number of entries in cache_defaults_raw */
+	unsigned int num_cache_defaults_raw;
+
+	/* if set, only the cache is modified not the HW */
+	unsigned int cache_only:1;
+	/* if set, only the HW is modified not the cache */
+	unsigned int cache_bypass:1;
+	/* if set, remember to free cache_defaults_raw */
+	unsigned int cache_free:1;
+
+	struct reg_default *cache_defaults;
+	const void *cache_defaults_raw;
+	void *cache;
+};
+
+struct regcache_ops {
+	const char *name;
+	enum regcache_type type;
+	int (*init)(struct regmap *map);
+	int (*exit)(struct regmap *map);
+	int (*read)(struct regmap *map, unsigned int reg, unsigned int *value);
+	int (*write)(struct regmap *map, unsigned int reg, unsigned int value);
+	int (*sync)(struct regmap *map);
 };
 
 bool regmap_writeable(struct regmap *map, unsigned int reg);
@@ -63,4 +98,21 @@ void regmap_debugfs_init(struct regmap *map) { }
 void regmap_debugfs_exit(struct regmap *map) { }
 #endif
 
+/* regcache core declarations */
+int regcache_init(struct regmap *map);
+void regcache_exit(struct regmap *map);
+int regcache_read(struct regmap *map,
+		       unsigned int reg, unsigned int *value);
+int regcache_write(struct regmap *map,
+			unsigned int reg, unsigned int value);
+int regcache_sync(struct regmap *map);
+
+unsigned int regcache_get_val(const void *base, unsigned int idx,
+			      unsigned int word_size);
+bool regcache_set_val(void *base, unsigned int idx,
+		      unsigned int val, unsigned int word_size);
+int regcache_lookup_reg(struct regmap *map, unsigned int reg);
+int regcache_insert_reg(struct regmap *map, unsigned int reg,
+			unsigned int val);
+
 #endif
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
new file mode 100644
index 0000000..ff79f9f
--- /dev/null
+++ b/drivers/base/regmap/regcache.c
@@ -0,0 +1,313 @@
+/*
+ * Register cache access API
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
+#include <trace/events/regmap.h>
+
+#include "internal.h"
+
+static const struct regcache_ops *cache_types[] = {
+};
+
+static int regcache_hw_init(struct regmap *map)
+{
+	int i, j;
+	int ret;
+	int count;
+	unsigned int val;
+	void *tmp_buf;
+
+	if (!map->cache_defaults_raw) {
+		if (!map->num_cache_defaults_raw)
+			return -EINVAL;
+		dev_warn(map->dev, "No cache defaults, reading back from HW\n");
+		tmp_buf = kmalloc(map->cache_size_raw, GFP_KERNEL);
+		if (!tmp_buf)
+			return -EINVAL;
+		ret = regmap_bulk_read(map, 0, tmp_buf,
+				       map->num_cache_defaults_raw);
+		if (ret < 0) {
+			kfree(tmp_buf);
+			return ret;
+		}
+		map->cache_defaults_raw = tmp_buf;
+		map->cache_free = 1;
+	}
+
+	/* calculate the size of cache_defaults */
+	for (count = 0, i = 0; i < map->num_cache_defaults_raw; i++) {
+		val = regcache_get_val(map->cache_defaults_raw,
+				       i, map->cache_word_size);
+		if (!val)
+			continue;
+		count++;
+	}
+
+	map->cache_defaults = kmalloc(count * sizeof(struct reg_default),
+				      GFP_KERNEL);
+	if (!map->cache_defaults)
+		return -ENOMEM;
+
+	/* fill the cache_defaults */
+	map->num_cache_defaults = count;
+	for (i = 0, j = 0; i < map->num_cache_defaults_raw; i++) {
+		val = regcache_get_val(map->cache_defaults_raw,
+				       i, map->cache_word_size);
+		if (!val)
+			continue;
+		map->cache_defaults[j].reg = i;
+		map->cache_defaults[j].def = val;
+		j++;
+	}
+
+	return 0;
+}
+
+int regcache_init(struct regmap *map)
+{
+	int ret;
+	int i;
+	void *tmp_buf;
+
+	if (map->cache_type == REGCACHE_NONE)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(cache_types); i++)
+		if (cache_types[i]->type == map->cache_type)
+			break;
+
+	if (i == ARRAY_SIZE(cache_types)) {
+		dev_err(map->dev, "Could not match compress type: %d\n",
+			map->cache_type);
+		return -EINVAL;
+	}
+
+	map->cache = NULL;
+	map->cache_ops = cache_types[i];
+
+	if (!map->cache_ops->read ||
+	    !map->cache_ops->write ||
+	    !map->cache_ops->name)
+		return -EINVAL;
+
+	/* We still need to ensure that the cache_defaults
+	 * won't vanish from under us.  We'll need to make
+	 * a copy of it.
+	 */
+	if (map->cache_defaults) {
+		if (!map->num_cache_defaults)
+			return -EINVAL;
+		tmp_buf = kmemdup(map->cache_defaults, map->num_cache_defaults *
+				  sizeof(struct reg_default), GFP_KERNEL);
+		if (!tmp_buf)
+			return -ENOMEM;
+		map->cache_defaults = tmp_buf;
+	} else {
+		/* Some devices such as PMIC's don't have cache defaults,
+		 * we cope with this by reading back the HW registers and
+		 * crafting the cache defaults by hand.
+		 */
+		ret = regcache_hw_init(map);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (map->cache_ops->init) {
+		dev_dbg(map->dev, "Initializing %s cache\n",
+			map->cache_ops->name);
+		return map->cache_ops->init(map);
+	}
+	return 0;
+}
+
+void regcache_exit(struct regmap *map)
+{
+	if (map->cache_type == REGCACHE_NONE)
+		return;
+
+	BUG_ON(!map->cache_ops);
+
+	kfree(map->cache_defaults);
+	if (map->cache_free)
+		kfree(map->cache_defaults_raw);
+
+	if (map->cache_ops->exit) {
+		dev_dbg(map->dev, "Destroying %s cache\n",
+			map->cache_ops->name);
+		map->cache_ops->exit(map);
+	}
+}
+
+/**
+ * regcache_read: Fetch the value of a given register from the cache.
+ *
+ * @map: map to configure.
+ * @reg: The register index.
+ * @value: The value to be returned.
+ *
+ * Return a negative value on failure, 0 on success.
+ */
+int regcache_read(struct regmap *map,
+		  unsigned int reg, unsigned int *value)
+{
+	unsigned int max_reg;
+
+	if (map->cache_type == REGCACHE_NONE)
+		return -ENOSYS;
+
+	BUG_ON(!map->cache_ops);
+
+	if (!regmap_readable(map, reg))
+		return -EIO;
+
+	if (map->max_register)
+		max_reg = map->max_register;
+	else
+		max_reg = map->num_cache_defaults_raw;
+
+
+	if (reg < max_reg && !regmap_volatile(map, reg))
+		return map->cache_ops->read(map, reg, value);
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(regcache_read);
+
+/**
+ * regcache_write: Set the value of a given register in the cache.
+ *
+ * @map: map to configure.
+ * @reg: The register index.
+ * @value: The new register value.
+ *
+ * Return a negative value on failure, 0 on success.
+ */
+int regcache_write(struct regmap *map,
+		   unsigned int reg, unsigned int value)
+{
+	unsigned int max_reg;
+
+	if (map->cache_type == REGCACHE_NONE)
+		return 0;
+
+	BUG_ON(!map->cache_ops);
+
+	if (!regmap_writeable(map, reg))
+		return -EIO;
+
+	if (map->max_register)
+		max_reg = map->max_register;
+	else
+		max_reg = map->num_cache_defaults_raw;
+
+	if (reg < max_reg && !regmap_volatile(map, reg))
+		return map->cache_ops->write(map, reg, value);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(regcache_write);
+
+/**
+ * regcache_sync: Sync the register cache with the hardware.
+ *
+ * @map: map to configure.
+ *
+ * Any registers that should not be synced should be marked as
+ * volatile.  In general drivers can choose not to use the provided
+ * syncing functionality if they so require.
+ *
+ * Return a negative value on failure, 0 on success.
+ */
+int regcache_sync(struct regmap *map)
+{
+	BUG_ON(!map->cache_ops);
+
+	if (map->cache_ops->sync) {
+		dev_dbg(map->dev, "Syncing %s cache\n",
+			map->cache_ops->name);
+		return map->cache_ops->sync(map);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(regcache_sync);
+
+bool regcache_set_val(void *base, unsigned int idx,
+		      unsigned int val, unsigned int word_size)
+{
+	switch (word_size) {
+	case 1: {
+		u8 *cache = base;
+		if (cache[idx] == val)
+			return true;
+		cache[idx] = val;
+		break;
+	}
+	case 2: {
+		u16 *cache = base;
+		if (cache[idx] == val)
+			return true;
+		cache[idx] = val;
+		break;
+	}
+	default:
+		BUG();
+	}
+	/* unreachable */
+	return false;
+}
+
+unsigned int regcache_get_val(const void *base, unsigned int idx,
+			      unsigned int word_size)
+{
+	if (!base)
+		return -EINVAL;
+
+	switch (word_size) {
+	case 1: {
+		const u8 *cache = base;
+		return cache[idx];
+	}
+	case 2: {
+		const u16 *cache = base;
+		return cache[idx];
+	}
+	default:
+		BUG();
+	}
+	/* unreachable */
+	return -1;
+}
+
+int regcache_lookup_reg(struct regmap *map, unsigned int reg)
+{
+	unsigned int i;
+
+	for (i = 0; i < map->num_cache_defaults; i++)
+		if (map->cache_defaults[i].reg == reg)
+			return i;
+	return -1;
+}
+
+int regcache_insert_reg(struct regmap *map, unsigned int reg,
+			unsigned int val)
+{
+	void *tmp;
+
+	tmp = krealloc(map->cache_defaults,
+		       (map->num_cache_defaults + 1) * sizeof(struct reg_default),
+		       GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+	map->cache_defaults = tmp;
+	map->num_cache_defaults++;
+	map->cache_defaults[map->num_cache_defaults - 1].reg = reg;
+	map->cache_defaults[map->num_cache_defaults - 1].def = val;
+	return 0;
+}
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 449e264..7591e01 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -20,6 +20,11 @@
 struct i2c_client;
 struct spi_device;
 
+/* An enum of all the supported cache types */
+enum regcache_type {
+	REGCACHE_NONE,
+};
+
 /**
  * Default value for a register.  We use an array of structs rather
  * than a simple array as many modern devices have very sparse
@@ -50,9 +55,14 @@ struct reg_default {
  *                (eg, a clear on read interrupt status register).
  *
  * @max_register: Optional, specifies the maximum valid register index.
- * @reg_defaults: Power on reset values for registers (for use with
- *                register cache support).
- * @num_reg_defaults: Number of elements in reg_defaults.
+ *
+ * @cache_type: The actual cache type.
+ * @cache_defaults: Power on reset values for registers (for use with
+ *                  register cache support).
+ * @num_cache_defaults: Number of elements in cache_defaults.
+ * @cache_defaults_raw: Power on reset values for registers (for use with
+ *                 register cache support).
+ * @num_cache_defaults_raw: Number of elements in cache_defaults_raw.
  */
 struct regmap_config {
 	int reg_bits;
@@ -64,8 +74,12 @@ struct regmap_config {
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
 
 	unsigned int max_register;
-	struct reg_default *reg_defaults;
-	int num_reg_defaults;
+
+	enum regcache_type cache_type;
+	struct reg_default *cache_defaults;
+	unsigned int num_cache_defaults;
+	const void *cache_defaults_raw;
+	unsigned int num_cache_defaults_raw;
 };
 
 typedef int (*regmap_hw_write)(struct device *dev, const void *data,
-- 
1.7.6.1

