Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab2LUJzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 04:55:18 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:49733 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2LUJzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 04:55:13 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrey.smirnov@convergeddevices.net
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Add "no-bus" option for regmap API
Date: Fri, 21 Dec 2012 01:47:18 -0800
Message-Id: <1356083238-6932-4-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356083238-6932-1-git-send-email-andrew.smirnov@gmail.com>
References: <1356083238-6932-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds provision for "no-bus" usage of the regmap API. In
this configuration user can provide API with two callbacks 'reg_read'
and 'reg_write' which are to be called when reads and writes to one of
device's registers is performed. This is useful for devices that
expose registers but whose register access sequence does not fit the 'bus'
abstraction.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 drivers/base/regmap/internal.h |    6 ++--
 drivers/base/regmap/regmap.c   |   78 ++++++++++++++++++++++++++++------------
 include/linux/regmap.h         |    7 ++++
 3 files changed, 67 insertions(+), 24 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 5d10c6d..644ff3d 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -58,8 +58,10 @@ struct regmap {
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
 
-	int (*reg_read)(struct regmap *map, unsigned int reg, unsigned int *val);
-	int (*reg_write)(struct regmap *map, unsigned int reg, unsigned int val);
+	int (*reg_read)(void *context, unsigned int reg, unsigned int *val);
+	int (*reg_write)(void *context, unsigned int reg, unsigned int val);
+
+	bool cache_registers;
 
 	u8 read_flag_mask;
 	u8 write_flag_mask;
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 006b50b..cd0ad64 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -34,11 +34,11 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 			       unsigned int mask, unsigned int val,
 			       bool *change);
 
-static int _regmap_bus_read(struct regmap *map, unsigned int reg,
+static int _regmap_bus_read(void *context, unsigned int reg,
 			    unsigned int *val);
-static int _regmap_bus_formatted_write(struct regmap *map, unsigned int reg,
+static int _regmap_bus_formatted_write(void *contex, unsigned int reg,
 				       unsigned int val);
-static int _regmap_bus_raw_write(struct regmap *map, unsigned int reg,
+static int _regmap_bus_raw_write(void *context, unsigned int reg,
 				 unsigned int val);
 
 
@@ -334,7 +334,7 @@ struct regmap *regmap_init(struct device *dev,
 	enum regmap_endian reg_endian, val_endian;
 	int i, j;
 
-	if (!bus || !config)
+	if (!config)
 		goto err;
 
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
@@ -343,14 +343,14 @@ struct regmap *regmap_init(struct device *dev,
 		goto err;
 	}
 
-	if (bus->fast_io) {
-		spin_lock_init(&map->spinlock);
-		map->lock = regmap_lock_spinlock;
-		map->unlock = regmap_unlock_spinlock;
-	} else {
+	if (!bus || !bus->fast_io) {
 		mutex_init(&map->mutex);
 		map->lock = regmap_lock_mutex;
 		map->unlock = regmap_unlock_mutex;
+	} else {
+		spin_lock_init(&map->spinlock);
+		map->lock = regmap_lock_spinlock;
+		map->unlock = regmap_unlock_spinlock;
 	}
 	map->format.reg_bytes = DIV_ROUND_UP(config->reg_bits, 8);
 	map->format.pad_bytes = config->pad_bits / 8;
@@ -373,6 +373,15 @@ struct regmap *regmap_init(struct device *dev,
 	map->precious_reg = config->precious_reg;
 	map->cache_type = config->cache_type;
 	map->name = config->name;
+	map->reg_read = config->reg_read;
+	map->reg_write = config->reg_write;
+
+	if (!bus) {
+		map->cache_registers = true;
+		goto skip_format_initialization;
+	} else {
+		map->reg_read = _regmap_bus_read;
+	}
 
 	if (config->read_flag_mask || config->write_flag_mask) {
 		map->read_flag_mask = config->read_flag_mask;
@@ -381,8 +390,6 @@ struct regmap *regmap_init(struct device *dev,
 		map->read_flag_mask = bus->read_flag_mask;
 	}
 
-	map->reg_read = _regmap_bus_read;
-
 	reg_endian = config->reg_format_endian;
 	if (reg_endian == REGMAP_ENDIAN_DEFAULT)
 		reg_endian = bus->reg_format_endian_default;
@@ -528,10 +535,14 @@ struct regmap *regmap_init(struct device *dev,
 		goto err_map;
 	}
 
-	if (map->format.format_write)
+	if (map->format.format_write) {
+		map->cache_registers = true;
 		map->reg_write = _regmap_bus_formatted_write;
-	else if (map->format.format_val)
+	} else if (map->format.format_val) {
 		map->reg_write = _regmap_bus_raw_write;
+	}
+
+skip_format_initialization:
 
 	map->range_tree = RB_ROOT;
 	for (i = 0; i < config->n_ranges; i++) {
@@ -712,7 +723,7 @@ void regmap_exit(struct regmap *map)
 	regcache_exit(map);
 	regmap_debugfs_exit(map);
 	regmap_range_exit(map);
-	if (map->bus->free_context)
+	if (map->bus && map->bus->free_context)
 		map->bus->free_context(map->bus_context);
 	kfree(map->work_buf);
 	kfree(map);
@@ -817,6 +828,8 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	size_t len;
 	int i;
 
+	BUG_ON(!map->bus);
+
 	/* Check for unwritable registers before we start */
 	if (map->writeable_reg)
 		for (i = 0; i < val_len / map->format.val_bytes; i++)
@@ -893,11 +906,13 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	return ret;
 }
 
-static int _regmap_bus_formatted_write(struct regmap *map, unsigned int reg,
+static int _regmap_bus_formatted_write(void *context, unsigned int reg,
 				       unsigned int val)
 {
 	int ret;
-	BUG_ON(!map->format.format_write);
+	struct regmap *map = context;
+
+	BUG_ON(!map->bus || !map->format.format_write);
 
 	ret = _regmap_select_page(map, &reg, 1);
 	if (ret < 0)
@@ -915,10 +930,12 @@ static int _regmap_bus_formatted_write(struct regmap *map, unsigned int reg,
 	return ret;
 }
 
-static int _regmap_bus_raw_write(struct regmap *map, unsigned int reg,
+static int _regmap_bus_raw_write(void *context, unsigned int reg,
 				 unsigned int val)
 {
-	BUG_ON(!map->format.format_val);
+	struct regmap *map = context;
+
+	BUG_ON(!map->bus || !map->format.format_val);
 
 	map->format.format_val(map->work_buf + map->format.reg_bytes
 			       + map->format.pad_bytes, val, 0);
@@ -934,7 +951,7 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 {
 	int ret;
 
-	if (!map->cache_bypass && map->format.format_write) {
+	if (!map->cache_bypass && map->cache_registers) {
 		ret = regcache_write(map, reg, val);
 		if (ret != 0)
 			return ret;
@@ -951,7 +968,10 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 
 	trace_regmap_reg_write(map->dev, reg, val);
 
-	return map->reg_write(map, reg, val);
+	if (map->bus)
+		return map->reg_write(map, reg, val);
+	else
+		return map->reg_write(map->bus_context, reg, val);
 }
 
 /**
@@ -1002,6 +1022,8 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 {
 	int ret;
 
+	if (!map->bus)
+		return -EINVAL;
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
 	if (reg % map->reg_stride)
@@ -1038,6 +1060,8 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	size_t val_bytes = map->format.val_bytes;
 	void *wval;
 
+	if (!map->bus)
+		return -EINVAL;
 	if (!map->format.parse_val)
 		return -EINVAL;
 	if (reg % map->reg_stride)
@@ -1090,6 +1114,8 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	u8 *u8 = map->work_buf;
 	int ret;
 
+	BUG_ON(!map->bus);
+
 	ret = _regmap_select_page(map, &reg, val_len / map->format.val_bytes);
 	if (ret < 0)
 		return ret;
@@ -1117,10 +1143,11 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	return ret;
 }
 
-static int _regmap_bus_read(struct regmap *map, unsigned int reg,
+static int _regmap_bus_read(void *context, unsigned int reg,
 			    unsigned int *val)
 {
 	int ret;
+	struct regmap *map = context;
 
 	if (!map->format.parse_val)
 		return -EINVAL;
@@ -1147,7 +1174,10 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 	if (map->cache_only)
 		return -EBUSY;
 
-	ret = map->reg_read(map, reg, val);
+	if (map->bus)
+		ret = map->reg_read(map, reg, val);
+	else
+		ret = map->reg_read(map->bus_context, reg, val);
 	if (ret == 0) {
 #ifdef LOG_DEVICE
 		if (strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
@@ -1209,6 +1239,8 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	unsigned int v;
 	int ret, i;
 
+	if (!map->bus)
+		return -EINVAL;
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
 	if (reg % map->reg_stride)
@@ -1260,6 +1292,8 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 	size_t val_bytes = map->format.val_bytes;
 	bool vol = regmap_volatile_range(map, reg, val_count);
 
+	if (!map->bus)
+		return -EINVAL;
 	if (!map->format.parse_val)
 		return -EINVAL;
 	if (reg % map->reg_stride)
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 7f7e00d..78ac1c1 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -75,6 +75,10 @@ enum regmap_endian {
  * @precious_reg: Optional callback returning true if the rgister
  *                should not be read outside of a call from the driver
  *                (eg, a clear on read interrupt status register).
+ * @reg_read: Optional callback that if filled will be used to perform
+ *            all the reads from the registers.
+ * @reg_write: Optional callback that if filled will be used to perform
+ *             all the writes to the registers.
  *
  * @max_register: Optional, specifies the maximum valid register index.
  * @reg_defaults: Power on reset values for registers (for use with
@@ -117,6 +121,9 @@ struct regmap_config {
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
 
+	int (*reg_read)(void *context, unsigned int reg, unsigned int *val);
+	int (*reg_write)(void *context, unsigned int reg, unsigned int val);
+
 	unsigned int max_register;
 	const struct reg_default *reg_defaults;
 	unsigned int num_reg_defaults;
-- 
1.7.9.5

