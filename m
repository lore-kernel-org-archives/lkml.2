Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab1LELpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:45:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37646 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932091Ab1LELpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:45:09 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regmap: Allow drivers to reinitialise the register cache at runtime
Date: Mon,  5 Dec 2011 11:44:59 +0000
Message-Id: <1323085500-27462-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes the register map information may change in ways that drivers can
discover at runtime. For example, new revisions of a device may add new
registers. Support runtime discovery by drivers by allowing the register
cache to be reinitialised with a new function regmap_reinit_cache() which
discards the existing cache and creates a new one.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   33 +++++++++++++++++++++++++++++++++
 include/linux/regmap.h       |    2 ++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index add5da6..be10a4f 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -259,6 +259,39 @@ err:
 EXPORT_SYMBOL_GPL(regmap_init);
 
 /**
+ * regmap_reinit_cache(): Reinitialise the current register cache
+ *
+ * @map: Register map to operate on.
+ * @config: New configuration.  Only the cache data will be used.
+ *
+ * Discard any existing register cache for the map and initialize a
+ * new cache.  This can be used to restore the cache to defaults or to
+ * update the cache configuration to reflect runtime discovery of the
+ * hardware.
+ */
+int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
+{
+	int ret;
+
+	mutex_lock(&map->lock);
+
+	regcache_exit(map);
+
+	map->max_register = config->max_register;
+	map->writeable_reg = config->writeable_reg;
+	map->readable_reg = config->readable_reg;
+	map->volatile_reg = config->volatile_reg;
+	map->precious_reg = config->precious_reg;
+	map->cache_type = config->cache_type;
+
+	ret = regcache_init(map, config);
+
+	mutex_unlock(&map->lock);
+
+	return ret;
+}
+
+/**
  * regmap_exit(): Free a previously allocated register map
  */
 void regmap_exit(struct regmap *map)
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a83e4a0..cfce3a3 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -128,6 +128,8 @@ struct regmap *regmap_init_spi(struct spi_device *dev,
 			       const struct regmap_config *config);
 
 void regmap_exit(struct regmap *map);
+int regmap_reinit_cache(struct regmap *map,
+			const struct regmap_config *config);
 int regmap_write(struct regmap *map, unsigned int reg, unsigned int val);
 int regmap_raw_write(struct regmap *map, unsigned int reg,
 		     const void *val, size_t val_len);
-- 
1.7.7.3

