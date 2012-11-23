Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab2KWVZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 16:25:20 -0500
Received: from 173-160-178-141-Washington.hfc.comcastbusiness.net ([173.160.178.141]:46553
	"EHLO relay" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756359Ab2KWVZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 16:25:19 -0500
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
To: andrey.smirnov@convergeddevices.net
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2] [RFC] regmap: Add no-"bus" configuration possibility
Date: Fri, 23 Nov 2012 13:25:24 -0800
Message-Id: <1353705924-25401-1-git-send-email-andrey.smirnov@convergeddevices.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second version of the patch with incorporated suggestions form
Mark(hopefully):
   https://lkml.org/lkml/2012/11/20/249

Once again at this point this patch is for illustrative purposes. If
the overall structure and nature of the change is agreed upon, I'll
work on properly implementing it and testing it with my driver code(SI476X).

Original description of the first version:

This patch proposes extension to the API that was suggested by Mark in
the following thread:
http://article.gmane.org/gmane.linux.kernel/1383734

The idea behind extensions is to allow the devices that expose some
register-like interface but whose protocol for reading or writing
those registers could not be simplified to serialized bytestream
writes to be used within 'regmap' framework

This patch adds two callbacks to the 'regmap' configuration which user
is expected to set with their implementation of read and write
functionality for the device.

I am not very well versed with the code of the remap framework so I
apologize if my proposal has some glaring mistakes and I would
welcome any suggestion or criticism on how to either improve the code
or implement the proposal in a better way.

This commit has only purpose of illustrating the proposed extension of
the 'regmap' API. It has never been compiled or tested.
---
 drivers/base/regmap/internal.h |    4 +
 drivers/base/regmap/regmap.c   |  172 ++++++++++++++++++++++++++++------------
 include/linux/regmap.h         |   12 ++-
 3 files changed, 137 insertions(+), 51 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 80f9ab9..2bb5f8e 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -58,6 +58,10 @@ struct regmap {
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
 
+	int (*reg_read)(struct regmap *map, unsigned int reg, unsigned int *val);
+	int (*reg_write)(struct regmap *map, unsigned int reg, unsigned int val);
+	int (*reg_cache)(struct regmap *map, unsigned int reg, unsigned int val);
+
 	u8 read_flag_mask;
 	u8 write_flag_mask;
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c241ae2..4ecb4b8 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -326,7 +326,8 @@ struct regmap *regmap_init(struct device *dev,
 	enum regmap_endian reg_endian, val_endian;
 	int i, j;
 
-	if (!bus || !config)
+	if (!config ||
+	    (!bus && !config->reg_read && !config->reg_write))
 		goto err;
 
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
@@ -335,15 +336,16 @@ struct regmap *regmap_init(struct device *dev,
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
+
 	map->format.reg_bytes = DIV_ROUND_UP(config->reg_bits, 8);
 	map->format.pad_bytes = config->pad_bits / 8;
 	map->format.val_bytes = DIV_ROUND_UP(config->val_bits, 8);
@@ -355,14 +357,16 @@ struct regmap *regmap_init(struct device *dev,
 	else
 		map->reg_stride = 1;
 	map->use_single_rw = config->use_single_rw;
-	map->dev = dev;
 	map->bus = bus;
+	map->dev = dev;
 	map->bus_context = bus_context;
 	map->max_register = config->max_register;
 	map->writeable_reg = config->writeable_reg;
 	map->readable_reg = config->readable_reg;
 	map->volatile_reg = config->volatile_reg;
 	map->precious_reg = config->precious_reg;
+	map->reg_read = config->reg_read;
+	map->reg_write = config->reg_write;
 	map->cache_type = config->cache_type;
 	map->name = config->name;
 
@@ -373,6 +377,11 @@ struct regmap *regmap_init(struct device *dev,
 		map->read_flag_mask = bus->read_flag_mask;
 	}
 
+	if (!bus)
+		goto skip_format_initialization;
+	else
+		map->reg_read = _regmap_bus_read;
+
 	reg_endian = config->reg_format_endian;
 	if (reg_endian == REGMAP_ENDIAN_DEFAULT)
 		reg_endian = bus->reg_format_endian_default;
@@ -512,6 +521,15 @@ struct regmap *regmap_init(struct device *dev,
 	    !(map->format.format_reg && map->format.format_val))
 		goto err_map;
 
+skip_format_initialization:
+	if (map->format.format_write) {
+		map->reg_cache = _regmap_reg_cache;
+		map->reg_write = _regmap_bus_formatted_write;
+	} else if (map->format.format_val) {
+		map->reg_cache = NULL;
+		map->reg_write = _regmap_bus_raw_write;
+	}
+
 	map->work_buf = kzalloc(map->format.buf_size, GFP_KERNEL);
 	if (map->work_buf == NULL) {
 		ret = -ENOMEM;
@@ -878,13 +896,49 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	return ret;
 }
 
-int _regmap_write(struct regmap *map, unsigned int reg,
-		  unsigned int val)
+
+static int _regmap_bus_formatted_write(struct regmap *map, unsigned int reg,
+				       unsigned int val)
+{
+	int ret;
+	BUG_ON(!map->format.format_write);
+
+	ret = _regmap_select_page(map, &reg, 1);
+	if (ret < 0)
+		return ret;
+
+	map->format.format_write(map, reg, val);
+
+	trace_regmap_hw_write_start(map->dev, reg, 1);
+
+	ret = map->bus->write(map->bus_context, map->work_buf,
+			      map->format.buf_size);
+
+	trace_regmap_hw_write_done(map->dev, reg, 1);
+
+	return ret;
+}
+
+static int _regmap_bus_raw_write(struct regmap *map, unsigned int reg,
+				 unsigned int val)
+
 {
 	int ret;
-	BUG_ON(!map->format.format_write && !map->format.format_val);
+	BUG_ON(!map->format.format_val);
+
+	map->format.format_val(map->work_buf + map->format.reg_bytes
+			       + map->format.pad_bytes, val, 0);
+	return _regmap_raw_write(map, reg,
+				 map->work_buf +
+				 map->format.reg_bytes +
+				 map->format.pad_bytes,
+				 map->format.val_bytes);
+}
 
-	if (!map->cache_bypass && map->format.format_write) {
+static int _regmap_reg_cache(struct regmap *map, unsigned int reg,
+			     unsigned int val)
+{
+	if (!map->cache_bypass) {
 		ret = regcache_write(map, reg, val);
 		if (ret != 0)
 			return ret;
@@ -894,37 +948,31 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 		}
 	}
 
-#ifdef LOG_DEVICE
-	if (strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
-		dev_info(map->dev, "%x <= %x\n", reg, val);
-#endif
+	return 0;
+}
 
-	trace_regmap_reg_write(map->dev, reg, val);
+int _regmap_write(struct regmap *map, unsigned int reg,
+		  unsigned int val)
+{
+	int ret;
+	BUG_ON(!map->reg_write);
 
-	if (map->format.format_write) {
-		ret = _regmap_select_page(map, &reg, 1);
+	if (map->reg_cache) {
+		ret = map->reg_cache(map, reg, val);
 		if (ret < 0)
 			return ret;
+	}
 
-		map->format.format_write(map, reg, val);
-
-		trace_regmap_hw_write_start(map->dev, reg, 1);
+#ifdef LOG_DEVICE
+	if (strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
+		dev_info(map->dev, "%x <= %x\n", reg, val);
+#endif
 
-		ret = map->bus->write(map->bus_context, map->work_buf,
-				      map->format.buf_size);
+	trace_regmap_reg_write(map->dev, reg, val);
 
-		trace_regmap_hw_write_done(map->dev, reg, 1);
+	ret = map->reg_write(map, reg, val);
 
-		return ret;
-	} else {
-		map->format.format_val(map->work_buf + map->format.reg_bytes
-				       + map->format.pad_bytes, val, 0);
-		return _regmap_raw_write(map, reg,
-					 map->work_buf +
-					 map->format.reg_bytes +
-					 map->format.pad_bytes,
-					 map->format.val_bytes);
-	}
+	return ret;
 }
 
 /**
@@ -975,6 +1023,8 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 {
 	int ret;
 
+	if (!map->bus)
+		return -EINVAL;
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
 	if (reg % map->reg_stride)
@@ -1011,7 +1061,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	size_t val_bytes = map->format.val_bytes;
 	void *wval;
 
-	if (!map->format.parse_val)
+	if (!map->format.parse_val || !map->bus)
 		return -EINVAL;
 	if (reg % map->reg_stride)
 		return -EINVAL;
@@ -1021,7 +1071,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	/* No formatting is require if val_byte is 1 */
 	if (val_bytes == 1) {
 		wval = (void *)val;
-	} else {
+	} else if (map->format.parse_val) {
 		wval = kmemdup(val, val_count * val_bytes, GFP_KERNEL);
 		if (!wval) {
 			ret = -ENOMEM;
@@ -1037,10 +1087,17 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	 */
 	if (map->use_single_rw) {
 		for (i = 0; i < val_count; i++) {
+			/*
+			   TODO: It looks like it could be a bug since
+			   returning at this point would not unlock
+			   regmap. Shouldn't it also be _regmap_raw_write
+			   since the map->lock has already been
+			   called? Need to investigate this further.
+			 */
 			ret = regmap_raw_write(map,
-						reg + (i * map->reg_stride),
-						val + (i * val_bytes),
-						val_bytes);
+					       reg + (i * map->reg_stride),
+					       val + (i * val_bytes),
+					       val_bytes);
 			if (ret != 0)
 				return ret;
 		}
@@ -1090,10 +1147,27 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	return ret;
 }
 
+static int _regmap_bus_read(struct regmap *map, unsigned int reg,
+			    unsigned int *val)
+{
+	int ret;
+
+	if (!map->format.parse_val)
+		return -EINVAL;
+
+	ret = _regmap_raw_read(map, reg, map->work_buf, map->format.val_bytes);
+	if (ret == 0)
+		*val = map->format.parse_val(map->work_buf);
+
+	return ret;
+}
+
 static int _regmap_read(struct regmap *map, unsigned int reg,
 			unsigned int *val)
 {
 	int ret;
+	BUG_ON(!map->reg_read);
+
 
 	if (!map->cache_bypass) {
 		ret = regcache_read(map, reg, val);
@@ -1101,26 +1175,21 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 			return 0;
 	}
 
-	if (!map->format.parse_val)
-		return -EINVAL;
-
 	if (map->cache_only)
 		return -EBUSY;
 
-	ret = _regmap_raw_read(map, reg, map->work_buf, map->format.val_bytes);
-	if (ret == 0) {
-		*val = map->format.parse_val(map->work_buf);
+	ret g= map->reg_read(map, reg, val);
 
+	if (ret == 0) {
 #ifdef LOG_DEVICE
 		if (strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
 			dev_info(map->dev, "%x => %x\n", reg, *val);
 #endif
-
 		trace_regmap_reg_read(map->dev, reg, *val);
-	}
 
-	if (ret == 0 && !map->cache_bypass)
-		regcache_write(map, reg, *val);
+		if (!map->cache_bypass)
+			regcache_write(map, reg, *val);
+	}
 
 	return ret;
 }
@@ -1171,6 +1240,8 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	unsigned int v;
 	int ret, i;
 
+	if (!map->bus)
+		return -EINVAL;
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
 	if (reg % map->reg_stride)
@@ -1222,7 +1293,7 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 	size_t val_bytes = map->format.val_bytes;
 	bool vol = regmap_volatile_range(map, reg, val_count);
 
-	if (!map->format.parse_val)
+	if (!map->format.parse_val || !map->bus)
 		return -EINVAL;
 	if (reg % map->reg_stride)
 		return -EINVAL;
@@ -1418,3 +1489,4 @@ static int __init regmap_initcall(void)
 	return 0;
 }
 postcore_initcall(regmap_initcall);
+
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 7f7e00d..8e0e946 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -53,6 +53,8 @@ enum regmap_endian {
 	REGMAP_ENDIAN_NATIVE,
 };
 
+struct regmap;
+
 /**
  * Configuration for the register map of a device.
  *
@@ -75,7 +77,12 @@ enum regmap_endian {
  * @precious_reg: Optional callback returning true if the rgister
  *                should not be read outside of a call from the driver
  *                (eg, a clear on read interrupt status register).
- *
+ * @reg_read: Optional, register read callback. For devices using
+ *            predefined "bus"(I2C, etc.) this is filled by the regmap
+ *            susbsytem.
+ * @reg_write: Optional, register write callback. For devices using
+ *             predefined "bus"(I2C, etc.) this is filled by the regmap
+ *             susbsytem.
  * @max_register: Optional, specifies the maximum valid register index.
  * @reg_defaults: Power on reset values for registers (for use with
  *                register cache support).
@@ -117,6 +124,9 @@ struct regmap_config {
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
 
+	int (*reg_read)(struct regmap *map, unsigned int reg, unsigned int *val);
+	int (*reg_write)(struct regmap *map, unsigned int reg, unsigned int val);
+
 	unsigned int max_register;
 	const struct reg_default *reg_defaults;
 	unsigned int num_reg_defaults;
-- 
1.7.10.4

