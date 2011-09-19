Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1ISNee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 09:34:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40237 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755812Ab1ISNeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 09:34:20 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 6/6 v5] regmap: Incorporate the regcache core into regmap
Date: Mon, 19 Sep 2011 14:34:05 +0100
Message-Id: <1316439245-26221-7-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316439245-26221-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1316439245-26221-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch incorporates the regcache core code into regmap.  All previous
patches have been no-ops essentially up to this point.

The bulk read operation is not supported by regcache at the moment.  This
will be implemented incrementally.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Tested-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regmap.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e7adfe7..602083f 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -146,6 +146,13 @@ struct regmap *regmap_init(struct device *dev,
 	map->readable_reg = config->readable_reg;
 	map->volatile_reg = config->volatile_reg;
 	map->precious_reg = config->precious_reg;
+	map->cache_type = config->cache_type;
+	map->reg_defaults = config->reg_defaults;
+	map->num_reg_defaults = config->num_reg_defaults;
+	map->num_reg_defaults_raw = config->num_reg_defaults_raw;
+	map->reg_defaults_raw = config->reg_defaults_raw;
+	map->cache_size_raw = (config->val_bits / 8) * config->num_reg_defaults_raw;
+	map->cache_word_size = config->val_bits / 8;
 
 	if (config->read_flag_mask || config->write_flag_mask) {
 		map->read_flag_mask = config->read_flag_mask;
@@ -208,6 +215,10 @@ struct regmap *regmap_init(struct device *dev,
 		goto err_map;
 	}
 
+	ret = regcache_init(map);
+	if (ret < 0)
+		goto err_map;
+
 	regmap_debugfs_init(map);
 
 	return map;
@@ -224,6 +235,7 @@ EXPORT_SYMBOL_GPL(regmap_init);
  */
 void regmap_exit(struct regmap *map)
 {
+	regcache_exit(map);
 	regmap_debugfs_exit(map);
 	kfree(map->work_buf);
 	kfree(map);
@@ -290,6 +302,12 @@ static int _regmap_write(struct regmap *map, unsigned int reg,
 	int ret;
 	BUG_ON(!map->format.format_write && !map->format.format_val);
 
+	if (!map->cache_bypass) {
+		ret = regcache_write(map, reg, val);
+		if (!ret || map->cache_only)
+			return 0;
+	}
+
 	trace_regmap_reg_write(map->dev, reg, val);
 
 	if (map->format.format_write) {
@@ -428,6 +446,14 @@ int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
 
 	mutex_lock(&map->lock);
 
+	if (!map->cache_bypass) {
+		ret = regcache_read(map, reg, val);
+		if (!ret) {
+			mutex_unlock(&map->lock);
+			return 0;
+		}
+	}
+
 	ret = _regmap_read(map, reg, val);
 
 	mutex_unlock(&map->lock);
@@ -479,6 +505,8 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 	int ret, i;
 	size_t val_bytes = map->format.val_bytes;
 
+	WARN_ON(map->cache_type != REGCACHE_NONE);
+
 	if (!map->format.parse_val)
 		return -EINVAL;
 
-- 
1.7.6.1

