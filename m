Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab2JPN5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 09:57:25 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:42970 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab2JPN5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 09:57:24 -0400
From: ciminaghi@gnudd.com
To: broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH v2] regmap : make lock/unlock functions customizable.
Date: Tue, 16 Oct 2012 15:56:59 +0200
Message-Id: <1350395819-31108-1-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

It is sometimes convenient for a regmap user to override the standard
regmap lock/unlock functions with custom functions.
For instance this can be useful in case an already existing spinlock
or mutex has to be used for locking a set of registers instead of the
internal regmap spinlock/mutex.
Note that the fast_io field of struct regmap_bus is ignored in case
custom locking functions are used.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---

I finally just removed the (actually unneeded) cast to struct regmap * in the
default version of the lock/unlock functions. Hope I got it right this time.

 drivers/base/regmap/internal.h |    4 +--
 drivers/base/regmap/regmap.c   |   65 +++++++++++++++++++++++-----------------
 include/linux/regmap.h         |   16 +++++++++-
 3 files changed, 54 insertions(+), 31 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index ac869d2..2cd01b5 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -31,14 +31,12 @@ struct regmap_format {
 	unsigned int (*parse_val)(void *buf);
 };
 
-typedef void (*regmap_lock)(struct regmap *map);
-typedef void (*regmap_unlock)(struct regmap *map);
-
 struct regmap {
 	struct mutex mutex;
 	spinlock_t spinlock;
 	regmap_lock lock;
 	regmap_unlock unlock;
+	void *lock_arg; /* This is passed to lock/unlock functions */
 
 	struct device *dev; /* Device we do I/O on */
 	void *work_buf;     /* Scratch buffer used to format I/O */
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 1526174..0585726 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -214,23 +214,27 @@ static unsigned int regmap_parse_32_native(void *buf)
 	return *(u32 *)buf;
 }
 
-static void regmap_lock_mutex(struct regmap *map)
+static void regmap_lock_mutex(void *__map)
 {
+	struct regmap *map = __map;
 	mutex_lock(&map->mutex);
 }
 
-static void regmap_unlock_mutex(struct regmap *map)
+static void regmap_unlock_mutex(void *__map)
 {
+	struct regmap *map = __map;
 	mutex_unlock(&map->mutex);
 }
 
-static void regmap_lock_spinlock(struct regmap *map)
+static void regmap_lock_spinlock(void *__map)
 {
+	struct regmap *map = __map;
 	spin_lock(&map->spinlock);
 }
 
-static void regmap_unlock_spinlock(struct regmap *map)
+static void regmap_unlock_spinlock(void *__map)
 {
+	struct regmap *map = __map;
 	spin_unlock(&map->spinlock);
 }
 
@@ -335,14 +339,21 @@ struct regmap *regmap_init(struct device *dev,
 		goto err;
 	}
 
-	if (bus->fast_io) {
-		spin_lock_init(&map->spinlock);
-		map->lock = regmap_lock_spinlock;
-		map->unlock = regmap_unlock_spinlock;
+	if (config->lock && config->unlock) {
+		map->lock = config->lock;
+		map->unlock = config->unlock;
+		map->lock_arg = config->lock_arg;
 	} else {
-		mutex_init(&map->mutex);
-		map->lock = regmap_lock_mutex;
-		map->unlock = regmap_unlock_mutex;
+		if (bus->fast_io) {
+			spin_lock_init(&map->spinlock);
+			map->lock = regmap_lock_spinlock;
+			map->unlock = regmap_unlock_spinlock;
+		} else {
+			mutex_init(&map->mutex);
+			map->lock = regmap_lock_mutex;
+			map->unlock = regmap_unlock_mutex;
+		}
+		map->lock_arg = map;
 	}
 	map->format.reg_bytes = DIV_ROUND_UP(config->reg_bits, 8);
 	map->format.pad_bytes = config->pad_bits / 8;
@@ -994,11 +1005,11 @@ int regmap_write(struct regmap *map, unsigned int reg, unsigned int val)
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
-	map->lock(map);
+	map->lock(map->lock_arg);
 
 	ret = _regmap_write(map, reg, val);
 
-	map->unlock(map);
+	map->unlock(map->lock_arg);
 
 	return ret;
 }
@@ -1030,11 +1041,11 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
-	map->lock(map);
+	map->lock(map->lock_arg);
 
 	ret = _regmap_raw_write(map, reg, val, val_len);
 
-	map->unlock(map);
+	map->unlock(map->lock_arg);
 
 	return ret;
 }
@@ -1066,7 +1077,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
-	map->lock(map);
+	map->lock(map->lock_arg);
 
 	/* No formatting is require if val_byte is 1 */
 	if (val_bytes == 1) {
@@ -1102,7 +1113,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 		kfree(wval);
 
 out:
-	map->unlock(map);
+	map->unlock(map->lock_arg);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_bulk_write);
@@ -1197,11 +1208,11 @@ int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
-	map->lock(map);
+	map->lock(map->lock_arg);
 
 	ret = _regmap_read(map, reg, val);
 
-	map->unlock(map);
+	map->unlock(map->lock_arg);
 
 	return ret;
 }
@@ -1231,7 +1242,7 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
-	map->lock(map);
+	map->lock(map->lock_arg);
 
 	if (regmap_volatile_range(map, reg, val_count) || map->cache_bypass ||
 	    map->cache_type == REGCACHE_NONE) {
@@ -1253,7 +1264,7 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	}
 
  out:
-	map->unlock(map);
+	map->unlock(map->lock_arg);
 
 	return ret;
 }
@@ -1360,9 +1371,9 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
 	bool change;
 	int ret;
 
-	map->lock(map);
+	map->lock(map->lock_arg);
 	ret = _regmap_update_bits(map, reg, mask, val, &change);
-	map->unlock(map);
+	map->unlock(map->lock_arg);
 
 	return ret;
 }
@@ -1386,9 +1397,9 @@ int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 {
 	int ret;
 
-	map->lock(map);
+	map->lock(map->lock_arg);
 	ret = _regmap_update_bits(map, reg, mask, val, change);
-	map->unlock(map);
+	map->unlock(map->lock_arg);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits_check);
@@ -1417,7 +1428,7 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 	if (map->patch)
 		return -EBUSY;
 
-	map->lock(map);
+	map->lock(map->lock_arg);
 
 	bypass = map->cache_bypass;
 
@@ -1445,7 +1456,7 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 out:
 	map->cache_bypass = bypass;
 
-	map->unlock(map);
+	map->unlock(map->lock_arg);
 
 	return ret;
 }
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 41e9e4e..fedf7ba 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -54,6 +54,9 @@ enum regmap_endian {
 	REGMAP_ENDIAN_NATIVE,
 };
 
+typedef void (*regmap_lock)(void *);
+typedef void (*regmap_unlock)(void *);
+
 /**
  * Configuration for the register map of a device.
  *
@@ -76,6 +79,12 @@ enum regmap_endian {
  * @precious_reg: Optional callback returning true if the rgister
  *                should not be read outside of a call from the driver
  *                (eg, a clear on read interrupt status register).
+ * @lock:         Optional lock callback (overrides regmap's default lock
+ *                function, based on spinlock or mutex).
+ * @unlock:       As above for unlocking.
+ * @lock_arg:     this field is passed as the only argument of lock/unlock
+ *                functions (ignored in case regular lock/unlock functions
+ *                are not overridden).
  *
  * @max_register: Optional, specifies the maximum valid register index.
  * @reg_defaults: Power on reset values for registers (for use with
@@ -117,6 +126,9 @@ struct regmap_config {
 	bool (*readable_reg)(struct device *dev, unsigned int reg);
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
+	regmap_lock lock;
+	regmap_unlock unlock;
+	void *lock_arg;
 
 	unsigned int max_register;
 	const struct reg_default *reg_defaults;
@@ -186,7 +198,9 @@ typedef void (*regmap_hw_free_context)(void *context);
  * Description of a hardware bus for the register map infrastructure.
  *
  * @fast_io: Register IO is fast. Use a spinlock instead of a mutex
- *           to perform locking.
+ *	     to perform locking. This field is ignored if custom lock/unlock
+ *	     functions are used (see fields lock/unlock of
+ *	     struct regmap_config).
  * @write: Write operation.
  * @gather_write: Write operation with split register/value, return -ENOTSUPP
  *                if not implemented  on a given device.
-- 
1.7.10.4

