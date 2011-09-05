Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab1IENvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 09:51:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39845 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754113Ab1IENvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 09:51:11 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 6/6] regmap: Incorporate the regcache core into regmap
Date: Mon,  5 Sep 2011 14:51:02 +0100
Message-Id: <1315230662-12401-7-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1315230662-12401-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1315230662-12401-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch incorporates the regcache core code into regmap.  All previous
patches have been no-ops essentially up to this point.

The bulk read operation is not supported by regcache at the moment.  This
will be implemented incrementally.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   56 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index fa2bd89..df4e00a 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -146,6 +146,13 @@ struct regmap *regmap_init(struct device *dev,
 	map->readable_reg = config->readable_reg;
 	map->volatile_reg = config->volatile_reg;
 	map->precious_reg = config->precious_reg;
+	map->cache_type = config->cache_type;
+	map->cache_defaults = config->cache_defaults;
+	map->num_cache_defaults = config->num_cache_defaults;
+	map->num_cache_defaults_raw = config->num_cache_defaults_raw;
+	map->cache_defaults_raw = config->cache_defaults_raw;
+	map->cache_size_raw = (config->val_bits / 8) * config->num_cache_defaults_raw;
+	map->cache_word_size = config->val_bits / 8;
 
 	switch (config->reg_bits) {
 	case 4:
@@ -201,6 +208,12 @@ struct regmap *regmap_init(struct device *dev,
 		goto err_bus;
 	}
 
+#ifdef CONFIG_REGCACHE
+	ret = regcache_init(map);
+	if (ret < 0)
+		goto err_bus;
+#endif
+
 	regmap_debugfs_init(map);
 
 	return map;
@@ -219,6 +232,9 @@ EXPORT_SYMBOL_GPL(regmap_init);
  */
 void regmap_exit(struct regmap *map)
 {
+#ifdef CONFIG_REGCACHE
+	regcache_exit(map);
+#endif
 	regmap_debugfs_exit(map);
 	kfree(map->work_buf);
 	module_put(map->bus->owner);
@@ -321,6 +337,20 @@ int regmap_write(struct regmap *map, unsigned int reg, unsigned int val)
 
 	mutex_lock(&map->lock);
 
+#ifdef CONFIG_REGCACHE
+	if (!map->cache_bypass) {
+		ret = regcache_write(map, reg, val);
+		if (ret < 0) {
+			mutex_unlock(&map->lock);
+			return ret;
+		}
+		if (map->cache_only) {
+			mutex_unlock(&map->lock);
+			return 0;
+		}
+	}
+#endif
+
 	ret = _regmap_write(map, reg, val);
 
 	mutex_unlock(&map->lock);
@@ -422,6 +452,16 @@ int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
 
 	mutex_lock(&map->lock);
 
+#ifdef CONFIG_REGCACHE
+	if (!map->cache_bypass) {
+		ret = regcache_read(map, reg, val);
+		if (!ret) {
+			mutex_unlock(&map->lock);
+			return 0;
+		}
+	}
+#endif
+
 	ret = _regmap_read(map, reg, val);
 
 	mutex_unlock(&map->lock);
@@ -473,6 +513,8 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 	int ret, i;
 	size_t val_bytes = map->format.val_bytes;
 
+	WARN_ON(map->cache_type != REGCACHE_NONE);
+
 	if (!map->format.parse_val)
 		return -EINVAL;
 
@@ -512,6 +554,20 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
 	tmp &= ~mask;
 	tmp |= val & mask;
 
+#ifdef CONFIG_REGCACHE
+	if (!map->cache_bypass) {
+		ret = regcache_write(map, reg, tmp);
+		if (ret < 0) {
+			mutex_unlock(&map->lock);
+			return ret;
+		}
+		if (map->cache_only) {
+			mutex_unlock(&map->lock);
+			return 0;
+		}
+	}
+#endif
+
 	ret = _regmap_write(map, reg, tmp);
 
 out:
-- 
1.7.6.1

