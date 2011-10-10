Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab1JJM10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:27:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35778 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785Ab1JJM1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:27:25 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Support some block operations on cached devices
Date: Mon, 10 Oct 2011 13:27:22 +0100
Message-Id: <1318249642-11654-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support raw reads if all the registers being read are volatile, the cache
will have no impact for tem.

Support bulk reads either directly (if all the registers are volatile) or
by falling back to iterating over single register reads otherwise.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   34 ++++++++++++++++++++++++++--------
 1 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 85bffdd..bf441db 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -482,8 +482,14 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 		    size_t val_len)
 {
 	int ret;
+	int i;
+	bool vol = true;
 
-	WARN_ON(map->cache_type != REGCACHE_NONE);
+	for (i = 0; i < val_len / map->format.val_bytes; i++)
+		if (!regmap_volatile(map, reg + i))
+			vol = false;
+
+	WARN_ON(!vol && map->cache_type != REGCACHE_NONE);
 
 	mutex_lock(&map->lock);
 
@@ -511,18 +517,30 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 {
 	int ret, i;
 	size_t val_bytes = map->format.val_bytes;
-
-	WARN_ON(map->cache_type != REGCACHE_NONE);
+	bool vol = true;
 
 	if (!map->format.parse_val)
 		return -EINVAL;
 
-	ret = regmap_raw_read(map, reg, val, val_bytes * val_count);
-	if (ret != 0)
-		return ret;
+	/* Is this a block of volatile registers? */
+	for (i = 0; i < val_count; i++)
+		if (!regmap_volatile(map, reg + i))
+			vol = false;
 
-	for (i = 0; i < val_count * val_bytes; i += val_bytes)
-		map->format.parse_val(val + i);
+	if (vol || map->cache_type == REGCACHE_NONE) {
+		ret = regmap_raw_read(map, reg, val, val_bytes * val_count);
+		if (ret != 0)
+			return ret;
+
+		for (i = 0; i < val_count * val_bytes; i += val_bytes)
+			map->format.parse_val(val + i);
+	} else {
+		for (i = 0; i < val_count; i++) {
+			ret = regmap_read(map, reg + i, val + (i * val_bytes));
+			if (ret != 0)
+				return ret;
+		}
+	}
 
 	return 0;
 }
-- 
1.7.6.3

