Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab2AWNwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 08:52:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45770 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822Ab2AWNwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 08:52:05 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Support register patch sets
Date: Mon, 23 Jan 2012 13:52:02 +0000
Message-Id: <1327326722-7644-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device manufacturers frequently provide register sequences, usually not
fully documented, to be run at startup in order to provide better defaults
for devices (for example, improving performance in the light of silicon
evaluation). Support such updates by allowing drivers to register update
sets with the core. These updates will be written to the device immediately
and will also be rewritten when the cache is synced.

The assumption is that the reason for resyncing the cache will always be
that the device has been powered off. If this turns out to not be the case
then a separate operation can be provided.

Currently the implementation only allows a single set of updates to be
specified for a device, this could be extended in future.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h |    3 ++
 drivers/base/regmap/regcache.c |   11 +++++++
 drivers/base/regmap/regmap.c   |   58 ++++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h         |    3 ++
 4 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index e33f1be..9ec8d8f 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -76,6 +76,9 @@ struct regmap {
 	const void *reg_defaults_raw;
 	void *cache;
 	bool cache_dirty;
+
+	struct reg_default *patch;
+	int patch_regs;
 };
 
 struct regcache_ops {
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 1ead661..ce2034c 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -268,6 +268,17 @@ int regcache_sync(struct regmap *map)
 		map->cache_ops->name);
 	name = map->cache_ops->name;
 	trace_regcache_sync(map->dev, name, "start");
+
+	/* Apply any patch first */
+	for (i = 0; i < map->patch_regs; i++) {
+		ret = _regmap_write(map, map->patch[i].reg, map->patch[i].def);
+		if (ret != 0) {
+			dev_err(map->dev, "Failed to write %x = %x: %d\n",
+				map->patch[i].reg, map->patch[i].def, ret);
+			goto out;
+		}
+	}
+
 	if (!map->cache_dirty)
 		goto out;
 	if (map->cache_ops->sync) {
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 80129c0..a5b27fb 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -682,6 +682,64 @@ int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits_check);
 
+/**
+ * regmap_register_patch: Register and apply register updates to be applied
+ *                        on device initialistion
+ *
+ * @map: Register map to apply updates to.
+ * @regs: Values to update.
+ * @num_regs: Number of entries in regs.
+ *
+ * Register a set of register updates to be applied to the device
+ * whenever the device registers are synchronised with the cache and
+ * apply them immediately.  Typically this is used to apply
+ * corrections to be applied to the device defaults on startup, such
+ * as the updates some vendors provide to undocumented registers.
+ */
+int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
+			  int num_regs)
+{
+	int i, ret;
+	bool bypass;
+
+	/* If needed the implementation can be extended to support this */
+	if (map->patch)
+		return -EBUSY;
+
+	mutex_lock(&map->lock);
+
+	bypass = map->cache_bypass;
+
+	map->cache_bypass = true;
+
+	/* Write out first; it's useful to apply even if we fail later. */
+	for (i = 0; i < num_regs; i++) {
+		ret = _regmap_write(map, regs[i].reg, regs[i].def);
+		if (ret != 0) {
+			dev_err(map->dev, "Failed to write %x = %x: %d\n",
+				regs[i].reg, regs[i].def, ret);
+			goto out;
+		}
+	}
+
+	map->patch = kcalloc(sizeof(struct reg_default), num_regs, GFP_KERNEL);
+	if (map->patch != NULL) {
+		memcpy(map->patch, regs,
+		       num_regs * sizeof(struct reg_default));
+		map->patch_regs = num_regs;
+	} else {
+		ret = -ENOMEM;
+	}
+
+out:
+	map->cache_bypass = bypass;
+
+	mutex_unlock(&map->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regmap_register_patch);
+
 static int __init regmap_initcall(void)
 {
 	regmap_debugfs_initcall();
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a6ed6e6..e8a31a3 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -151,6 +151,9 @@ void regcache_cache_only(struct regmap *map, bool enable);
 void regcache_cache_bypass(struct regmap *map, bool enable);
 void regcache_mark_dirty(struct regmap *map);
 
+int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
+			  int num_regs);
+
 /**
  * Description of an IRQ for the generic regmap irq_chip.
  *
-- 
1.7.7.3

