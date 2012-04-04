Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab2DDVso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:48:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58771 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab2DDVsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:48:43 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/6] regmap: introduce fast_io busses, and use a spinlock for them
Date: Wed,  4 Apr 2012 15:48:28 -0600
Message-Id: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Some bus types have very fast IO. For these, acquiring a mutex for every
IO operation is a significant overhead. Allow busses to indicate their IO
is fast, and enhance regmap to use a spinlock for those busses.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Mark, FYI, this whole series will be a dependency for the Tegra ASoC
series I'll post shortly.

 drivers/base/regmap/internal.h        |    8 ++++-
 drivers/base/regmap/regcache-rbtree.c |    4 +-
 drivers/base/regmap/regcache.c        |   20 +++++-----
 drivers/base/regmap/regmap.c          |   62 ++++++++++++++++++++++++---------
 include/linux/regmap.h                |    3 ++
 5 files changed, 67 insertions(+), 30 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 606b83d..6ee4dc5 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -31,8 +31,14 @@ struct regmap_format {
 	unsigned int (*parse_val)(void *buf);
 };
 
+typedef void (*regmap_lock)(struct regmap *map);
+typedef void (*regmap_unlock)(struct regmap *map);
+
 struct regmap {
-	struct mutex lock;
+	struct mutex mutex;
+	spinlock_t spinlock;
+	regmap_lock lock;
+	regmap_unlock unlock;
 
 	struct device *dev; /* Device we do I/O on */
 	void *work_buf;     /* Scratch buffer used to format I/O */
diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index fb14a63..9eea758 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -139,7 +139,7 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	int nodes = 0;
 	int registers = 0;
 
-	mutex_lock(&map->lock);
+	map->lock(map);
 
 	for (node = rb_first(&rbtree_ctx->root); node != NULL;
 	     node = rb_next(node)) {
@@ -155,7 +155,7 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	seq_printf(s, "%d nodes, %d registers, average %d registers\n",
 		   nodes, registers, registers / nodes);
 
-	mutex_unlock(&map->lock);
+	map->unlock(map);
 
 	return 0;
 }
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 74b6909..d4368e8 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -264,7 +264,7 @@ int regcache_sync(struct regmap *map)
 
 	BUG_ON(!map->cache_ops || !map->cache_ops->sync);
 
-	mutex_lock(&map->lock);
+	map->lock(map);
 	/* Remember the initial bypass state */
 	bypass = map->cache_bypass;
 	dev_dbg(map->dev, "Syncing %s cache\n",
@@ -296,7 +296,7 @@ out:
 	trace_regcache_sync(map->dev, name, "stop");
 	/* Restore the bypass state */
 	map->cache_bypass = bypass;
-	mutex_unlock(&map->lock);
+	map->unlock(map);
 
 	return ret;
 }
@@ -323,7 +323,7 @@ int regcache_sync_region(struct regmap *map, unsigned int min,
 
 	BUG_ON(!map->cache_ops || !map->cache_ops->sync);
 
-	mutex_lock(&map->lock);
+	map->lock(map);
 
 	/* Remember the initial bypass state */
 	bypass = map->cache_bypass;
@@ -342,7 +342,7 @@ out:
 	trace_regcache_sync(map->dev, name, "stop region");
 	/* Restore the bypass state */
 	map->cache_bypass = bypass;
-	mutex_unlock(&map->lock);
+	map->unlock(map);
 
 	return ret;
 }
@@ -362,11 +362,11 @@ EXPORT_SYMBOL_GPL(regcache_sync_region);
  */
 void regcache_cache_only(struct regmap *map, bool enable)
 {
-	mutex_lock(&map->lock);
+	map->lock(map);
 	WARN_ON(map->cache_bypass && enable);
 	map->cache_only = enable;
 	trace_regmap_cache_only(map->dev, enable);
-	mutex_unlock(&map->lock);
+	map->unlock(map);
 }
 EXPORT_SYMBOL_GPL(regcache_cache_only);
 
@@ -381,9 +381,9 @@ EXPORT_SYMBOL_GPL(regcache_cache_only);
  */
 void regcache_mark_dirty(struct regmap *map)
 {
-	mutex_lock(&map->lock);
+	map->lock(map);
 	map->cache_dirty = true;
-	mutex_unlock(&map->lock);
+	map->unlock(map);
 }
 EXPORT_SYMBOL_GPL(regcache_mark_dirty);
 
@@ -400,11 +400,11 @@ EXPORT_SYMBOL_GPL(regcache_mark_dirty);
  */
 void regcache_cache_bypass(struct regmap *map, bool enable)
 {
-	mutex_lock(&map->lock);
+	map->lock(map);
 	WARN_ON(map->cache_only && enable);
 	map->cache_bypass = enable;
 	trace_regmap_cache_bypass(map->dev, enable);
-	mutex_unlock(&map->lock);
+	map->unlock(map);
 }
 EXPORT_SYMBOL_GPL(regcache_cache_bypass);
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 178989a..831ec42 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -179,6 +179,26 @@ static unsigned int regmap_parse_32(void *buf)
 	return b[0];
 }
 
+static void regmap_lock_mutex(struct regmap *map)
+{
+	mutex_lock(&map->mutex);
+}
+
+static void regmap_unlock_mutex(struct regmap *map)
+{
+	mutex_unlock(&map->mutex);
+}
+
+static void regmap_lock_spinlock(struct regmap *map)
+{
+	spin_lock(&map->spinlock);
+}
+
+static void regmap_unlock_spinlock(struct regmap *map)
+{
+	spin_unlock(&map->spinlock);
+}
+
 /**
  * regmap_init(): Initialise register map
  *
@@ -206,7 +226,15 @@ struct regmap *regmap_init(struct device *dev,
 		goto err;
 	}
 
-	mutex_init(&map->lock);
+	if (bus->fast_io) {
+		spin_lock_init(&map->spinlock);
+		map->lock = regmap_lock_spinlock;
+		map->unlock = regmap_unlock_spinlock;
+	} else {
+		mutex_init(&map->mutex);
+		map->lock = regmap_lock_mutex;
+		map->unlock = regmap_unlock_mutex;
+	}
 	map->format.buf_size = (config->reg_bits + config->val_bits) / 8;
 	map->format.reg_bytes = DIV_ROUND_UP(config->reg_bits, 8);
 	map->format.pad_bytes = config->pad_bits / 8;
@@ -386,7 +414,7 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 {
 	int ret;
 
-	mutex_lock(&map->lock);
+	map->lock(map);
 
 	regcache_exit(map);
 	regmap_debugfs_exit(map);
@@ -405,7 +433,7 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 
 	ret = regcache_init(map, config);
 
-	mutex_unlock(&map->lock);
+	map->unlock(map);
 
 	return ret;
 }
@@ -555,11 +583,11 @@ int regmap_write(struct regmap *map, unsigned int reg, unsigned int val)
 {
 	int ret;
 
-	mutex_lock(&map->lock);
+	map->lock(map);
 
 	ret = _regmap_write(map, reg, val);
 
-	mutex_unlock(&map->lock);
+	map->unlock(map);
 
 	return ret;
 }
@@ -586,11 +614,11 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 {
 	int ret;
 
-	mutex_lock(&map->lock);
+	map->lock(map);
 
 	ret = _regmap_raw_write(map, reg, val, val_len);
 
-	mutex_unlock(&map->lock);
+	map->unlock(map);
 
 	return ret;
 }
@@ -620,7 +648,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	if (!map->format.parse_val)
 		return -EINVAL;
 
-	mutex_lock(&map->lock);
+	map->lock(map);
 
 	/* No formatting is require if val_byte is 1 */
 	if (val_bytes == 1) {
@@ -641,7 +669,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 		kfree(wval);
 
 out:
-	mutex_unlock(&map->lock);
+	map->unlock(map);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_bulk_write);
@@ -715,11 +743,11 @@ int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
 {
 	int ret;
 
-	mutex_lock(&map->lock);
+	map->lock(map);
 
 	ret = _regmap_read(map, reg, val);
 
-	mutex_unlock(&map->lock);
+	map->unlock(map);
 
 	return ret;
 }
@@ -744,7 +772,7 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	unsigned int v;
 	int ret, i;
 
-	mutex_lock(&map->lock);
+	map->lock(map);
 
 	if (regmap_volatile_range(map, reg, val_count) || map->cache_bypass ||
 	    map->cache_type == REGCACHE_NONE) {
@@ -765,7 +793,7 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	}
 
  out:
-	mutex_unlock(&map->lock);
+	map->unlock(map);
 
 	return ret;
 }
@@ -818,7 +846,7 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 	int ret;
 	unsigned int tmp, orig;
 
-	mutex_lock(&map->lock);
+	map->lock(map);
 
 	ret = _regmap_read(map, reg, &orig);
 	if (ret != 0)
@@ -835,7 +863,7 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 	}
 
 out:
-	mutex_unlock(&map->lock);
+	map->unlock(map);
 
 	return ret;
 }
@@ -902,7 +930,7 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 	if (map->patch)
 		return -EBUSY;
 
-	mutex_lock(&map->lock);
+	map->lock(map);
 
 	bypass = map->cache_bypass;
 
@@ -930,7 +958,7 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 out:
 	map->cache_bypass = bypass;
 
-	mutex_unlock(&map->lock);
+	map->unlock(map);
 
 	return ret;
 }
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a90abb6..48e9b86 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -109,6 +109,8 @@ typedef int (*regmap_hw_read)(struct device *dev,
 /**
  * Description of a hardware bus for the register map infrastructure.
  *
+ * @fast_io: Register IO is fast. Use a spinlock instead of a mutex
+ *           to perform locking.
  * @write: Write operation.
  * @gather_write: Write operation with split register/value, return -ENOTSUPP
  *                if not implemented  on a given device.
@@ -118,6 +120,7 @@ typedef int (*regmap_hw_read)(struct device *dev,
  *                  a read.
  */
 struct regmap_bus {
+	bool fast_io;
 	regmap_hw_write write;
 	regmap_hw_gather_write gather_write;
 	regmap_hw_read read;
-- 
1.7.0.4

