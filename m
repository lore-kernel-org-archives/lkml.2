Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1J0H6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:58:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51179 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353Ab1J0H6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:58:44 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Track if the register cache is dirty and suppress unneeded syncs
Date: Thu, 27 Oct 2011 09:58:36 +0200
Message-Id: <1319702316-20647-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow drivers to optimise out the register cache sync if they didn't need
to do one. If the hardware is desynced from the register cache (by power
loss for example) then the driver should call regcache_mark_dirty() to
let the core know about this.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h |    1 +
 drivers/base/regmap/regcache.c |   19 +++++++++++++++++++
 drivers/base/regmap/regmap.c   |    4 +++-
 include/linux/regmap.h         |    1 +
 4 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 348ff02..6483e0b 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -74,6 +74,7 @@ struct regmap {
 	struct reg_default *reg_defaults;
 	const void *reg_defaults_raw;
 	void *cache;
+	bool cache_dirty;
 };
 
 struct regcache_ops {
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 666f6f5..6ab9f03 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -241,6 +241,8 @@ int regcache_sync(struct regmap *map)
 		map->cache_ops->name);
 	name = map->cache_ops->name;
 	trace_regcache_sync(map->dev, name, "start");
+	if (!map->cache_dirty)
+		goto out;
 	if (map->cache_ops->sync) {
 		ret = map->cache_ops->sync(map);
 	} else {
@@ -291,6 +293,23 @@ void regcache_cache_only(struct regmap *map, bool enable)
 EXPORT_SYMBOL_GPL(regcache_cache_only);
 
 /**
+ * regcache_mark_dirty: Mark the register cache as dirty
+ *
+ * @map: map to mark
+ *
+ * Mark the register cache as dirty, for example due to the device
+ * having been powered down for suspend.  If the cache is not marked
+ * as dirty then the cache sync will be suppressed.
+ */
+void regcache_mark_dirty(struct regmap *map)
+{
+	mutex_lock(&map->lock);
+	map->cache_dirty = true;
+	mutex_unlock(&map->lock);
+}
+EXPORT_SYMBOL_GPL(regcache_mark_dirty);
+
+/**
  * regcache_cache_bypass: Put a register map into cache bypass mode
  *
  * @map: map to configure
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index bf441db..3aca18d 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -306,8 +306,10 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 		ret = regcache_write(map, reg, val);
 		if (ret != 0)
 			return ret;
-		if (map->cache_only)
+		if (map->cache_only) {
+			map->cache_dirty = true;
 			return 0;
+		}
 	}
 
 	trace_regmap_reg_write(map->dev, reg, val);
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 827f70c..24d78d4 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -143,6 +143,7 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
 int regcache_sync(struct regmap *map);
 void regcache_cache_only(struct regmap *map, bool enable);
 void regcache_cache_bypass(struct regmap *map, bool enable);
+void regcache_mark_dirty(struct regmap *map);
 
 /**
  * Description of an IRQ for the generic regmap irq_chip.
-- 
1.7.6.3

