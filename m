Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab2KDASG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 20:18:06 -0400
Received: from 173-160-178-141-Washington.hfc.comcastbusiness.net ([173.160.178.141]:46398
	"EHLO relay" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751184Ab2KDASB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 20:18:01 -0400
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
To: andrey.smirnov@convergeddevices.net
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [RFC] regmap: Add no-"bus" configuration possibility
Date: Sat,  3 Nov 2012 17:18:17 -0700
Message-Id: <1351988297-16145-1-git-send-email-andrey.smirnov@convergeddevices.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/base/regmap/internal.h |    4 ++
 drivers/base/regmap/regmap.c   |   93 +++++++++++++++++++++++++++++-----------
 include/linux/regmap.h         |   12 +++++-
 3 files changed, 83 insertions(+), 26 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 80f9ab9..7326357 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -58,6 +58,10 @@ struct regmap {
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
 
+
+	int (*nbstr_read)(void *context, unsigned int reg, unsigned int *val);
+	int (*nbstr_write)(void *context, unsigned int reg, unsigned int val);
+
 	u8 read_flag_mask;
 	u8 write_flag_mask;
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c241ae2..9b409ff 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -326,7 +326,8 @@ struct regmap *regmap_init(struct device *dev,
 	enum regmap_endian reg_endian, val_endian;
 	int i, j;
 
-	if (!bus || !config)
+	if (!config ||
+	    (!bus && !config->nbstr_read && !config->nbstr_write))
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
+	map->nbstr_read = config->nbstr_read;
+	map->nbstr_wrtie = config->nbstr_write;
 	map->cache_type = config->cache_type;
 	map->name = config->name;
 
@@ -373,6 +377,9 @@ struct regmap *regmap_init(struct device *dev,
 		map->read_flag_mask = bus->read_flag_mask;
 	}
 
+	if (!bus)
+		goto skip_format_initialization;
+
 	reg_endian = config->reg_format_endian;
 	if (reg_endian == REGMAP_ENDIAN_DEFAULT)
 		reg_endian = bus->reg_format_endian_default;
@@ -512,6 +519,7 @@ struct regmap *regmap_init(struct device *dev,
 	    !(map->format.format_reg && map->format.format_val))
 		goto err_map;
 
+skip_format_initialization:
 	map->work_buf = kzalloc(map->format.buf_size, GFP_KERNEL);
 	if (map->work_buf == NULL) {
 		ret = -ENOMEM;
@@ -884,7 +892,8 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 	int ret;
 	BUG_ON(!map->format.format_write && !map->format.format_val);
 
-	if (!map->cache_bypass && map->format.format_write) {
+	if (!map->cache_bypass &&
+	    (map->format.format_write || map->nbstr_write)) {
 		ret = regcache_write(map, reg, val);
 		if (ret != 0)
 			return ret;
@@ -901,7 +910,15 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 
 	trace_regmap_reg_write(map->dev, reg, val);
 
-	if (map->format.format_write) {
+	if (map->nbstr_write) {
+		trace_regmap_hw_write_start(map->dev, reg, 1);
+
+		ret = map->nbstr_write(map->bus_context, reg, val);
+
+		trace_regmap_hw_write_done(map->dev, reg, 1);
+
+		return ret;
+	} else if (map->format.format_write) {
 		ret = _regmap_select_page(map, &reg, 1);
 		if (ret < 0)
 			return ret;
@@ -975,6 +992,8 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 {
 	int ret;
 
+	if (map->nbstr_write)
+		return -EINVAL;
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
 	if (reg % map->reg_stride)
@@ -1011,7 +1030,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	size_t val_bytes = map->format.val_bytes;
 	void *wval;
 
-	if (!map->format.parse_val)
+	if (!map->format.parse_val && !map->nbstr_write)
 		return -EINVAL;
 	if (reg % map->reg_stride)
 		return -EINVAL;
@@ -1021,7 +1040,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	/* No formatting is require if val_byte is 1 */
 	if (val_bytes == 1) {
 		wval = (void *)val;
-	} else {
+	} else if (map->format.parse_val) {
 		wval = kmemdup(val, val_count * val_bytes, GFP_KERNEL);
 		if (!wval) {
 			ret = -ENOMEM;
@@ -1035,12 +1054,29 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	 * Some devices does not support bulk write, for
 	 * them we have a series of single write operations.
 	 */
-	if (map->use_single_rw) {
+	if (map->nbstr_write) {
 		for (i = 0; i < val_count; i++) {
+			ret = _regmap_write(map,
+					    reg + (i * map->reg_stride),
+					    val + (i * val_bytes));
+			if (ret != 0)
+				goto out;
+		}
+	} else if (map->use_single_rw) {
+		for (i = 0; i < val_count; i++) {
+			/*
+			   TODO: this code is left as it was in
+			   the original function(pre nbstr_write) but
+			   it looks like it could be a bug since
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
@@ -1101,26 +1137,30 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 			return 0;
 	}
 
-	if (!map->format.parse_val)
+	if (!map->format.parse_val && !map->nbstr_read)
 		return -EINVAL;
 
 	if (map->cache_only)
 		return -EBUSY;
 
-	ret = _regmap_raw_read(map, reg, map->work_buf, map->format.val_bytes);
-	if (ret == 0) {
-		*val = map->format.parse_val(map->work_buf);
+	if (map->nbstr_read) {
+		ret = map->nbstr_read(map->bus_context, reg, val);
+	} else {
+		ret = _regmap_raw_read(map, reg, map->work_buf, map->format.val_bytes);
+		if (ret == 0)
+			*val = map->format.parse_val(map->work_buf);
+	}
 
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
@@ -1171,6 +1211,8 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	unsigned int v;
 	int ret, i;
 
+	if (map->nbstr_read)
+		return -EINVAL;
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
 	if (reg % map->reg_stride)
@@ -1222,12 +1264,13 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 	size_t val_bytes = map->format.val_bytes;
 	bool vol = regmap_volatile_range(map, reg, val_count);
 
-	if (!map->format.parse_val)
+	if (!map->format.parse_val && !map->nbstr_read)
 		return -EINVAL;
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
-	if (vol || map->cache_type == REGCACHE_NONE) {
+	if (!map->nbstr_read &&
+	    (vol || map->cache_type == REGCACHE_NONE)) {
 		/*
 		 * Some devices does not support bulk read, for
 		 * them we have a series of single read operations.
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 7f7e00d..4f0e14d 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -75,7 +75,14 @@ enum regmap_endian {
  * @precious_reg: Optional callback returning true if the rgister
  *                should not be read outside of a call from the driver
  *                (eg, a clear on read interrupt status register).
- *
+ * @nbstr_read: Read operation for devices that do not expose
+ *              interface in which read operations can be serialized
+ *              into a byte stream and therefore "bus" abstraction
+ *              cannot be used for this device.
+ * @nbstr_write: Write operation for devices that do not expose
+ *               interface in which read operations can be serialized
+ *               into a byte stream and therefore "bus" abstraction
+ *               cannot be used for this device.
  * @max_register: Optional, specifies the maximum valid register index.
  * @reg_defaults: Power on reset values for registers (for use with
  *                register cache support).
@@ -117,6 +124,9 @@ struct regmap_config {
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
 
+	int (*nbstr_read)(void *context, unsigned int reg, unsigned int *val);
+	int (*nbstr_write)(void *context, unsigned int reg, unsigned int val);
+
 	unsigned int max_register;
 	const struct reg_default *reg_defaults;
 	unsigned int num_reg_defaults;
-- 
1.7.10.4

