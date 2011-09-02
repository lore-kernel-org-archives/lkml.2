Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1IBPqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:46:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53659 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753248Ab1IBPqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:46:43 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 6/8] regmap: Incorporate the regcache core into regmap
Date: Fri,  2 Sep 2011 16:46:13 +0100
Message-Id: <1314978375-11539-7-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch incorporates the regcache core code into regmap.  All previous
patches have been no-ops essentially up to this point.

The bulk read operation is not supported by regcache at the moment.  This
will be implemented incrementally.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   55 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index fa2bd89..fdc4266 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -146,6 +146,12 @@ struct regmap *regmap_init(struct device *dev,
 	map->readable_reg = config->readable_reg;
 	map->volatile_reg = config->volatile_reg;
 	map->precious_reg = config->precious_reg;
+	map->cache_type = config->cache_type;
+	map->num_cache_defaults_raw = config->num_cache_defaults_raw;
+	map->cache_defaults = NULL;
+	map->cache_defaults_raw = config->cache_defaults_raw;
+	map->cache_size_raw = (config->val_bits / 8) * config->num_cache_defaults_raw;
+	map->cache_word_size = config->val_bits / 8;
 
 	switch (config->reg_bits) {
 	case 4:
@@ -201,6 +207,12 @@ struct regmap *regmap_init(struct device *dev,
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
@@ -219,6 +231,9 @@ EXPORT_SYMBOL_GPL(regmap_init);
  */
 void regmap_exit(struct regmap *map)
 {
+#ifdef CONFIG_REGCACHE
+	regcache_exit(map);
+#endif
 	regmap_debugfs_exit(map);
 	kfree(map->work_buf);
 	module_put(map->bus->owner);
@@ -321,6 +336,20 @@ int regmap_write(struct regmap *map, unsigned int reg, unsigned int val)
 
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
@@ -422,6 +451,16 @@ int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
 
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
@@ -473,6 +512,8 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 	int ret, i;
 	size_t val_bytes = map->format.val_bytes;
 
+	WARN_ON(map->cache_type != REGCACHE_NONE);
+
 	if (!map->format.parse_val)
 		return -EINVAL;
 
@@ -512,6 +553,20 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
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

