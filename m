Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab2BXNit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:38:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47041 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714Ab2BXNiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:38:25 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] regmap: Allow drivers to sync only part of the register cache
Date: Fri, 24 Feb 2012 13:38:21 +0000
Message-Id: <1330090702-22160-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1330090702-22160-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1330090702-22160-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a regcache_sync_region() operation which allows drivers to
write only part of the cache back to the hardware. This is intended
for use in cases like power domains or DSP memories where part of the
device register map may be reset without fully resetting the device.

Fully supporting these devices is likely to require additional work to
make specific regions of the register map cache only while they are in
reset, but this is enough for most devices.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |   45 ++++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h         |    2 +
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 002916e..938cb1d 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -302,6 +302,51 @@ out:
 EXPORT_SYMBOL_GPL(regcache_sync);
 
 /**
+ * regcache_sync_region: Sync part  of the register cache with the hardware.
+ *
+ * @map: map to sync.
+ * @min: first register to sync
+ * @max: last register to sync
+ *
+ * Write all non-default register values in the specified region to
+ * the hardware.
+ *
+ * Return a negative value on failure, 0 on success.
+ */
+int regcache_sync_region(struct regmap *map, unsigned int min,
+			 unsigned int max)
+{
+	int ret = 0;
+	const char *name;
+	unsigned int bypass;
+
+	BUG_ON(!map->cache_ops || !map->cache_ops->sync);
+
+	mutex_lock(&map->lock);
+
+	/* Remember the initial bypass state */
+	bypass = map->cache_bypass;
+
+	name = map->cache_ops->name;
+	dev_dbg(map->dev, "Syncing %s cache from %d-%d\n", name, min, max);
+
+	trace_regcache_sync(map->dev, name, "start region");
+
+	if (!map->cache_dirty)
+		goto out;
+
+	ret = map->cache_ops->sync(map, min, max);
+
+out:
+	trace_regcache_sync(map->dev, name, "stop region");
+	/* Restore the bypass state */
+	map->cache_bypass = bypass;
+	mutex_unlock(&map->lock);
+
+	return ret;
+}
+
+/**
  * regcache_cache_only: Put a register map into cache only mode
  *
  * @map: map to configure
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index df9ffcc..c500c64 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -160,6 +160,8 @@ int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 int regmap_get_val_bytes(struct regmap *map);
 
 int regcache_sync(struct regmap *map);
+int regcache_sync_region(struct regmap *map, unsigned int min,
+			 unsigned int max);
 void regcache_cache_only(struct regmap *map, bool enable);
 void regcache_cache_bypass(struct regmap *map, bool enable);
 void regcache_mark_dirty(struct regmap *map);
-- 
1.7.9.1

