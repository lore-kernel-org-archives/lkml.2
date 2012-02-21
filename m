Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2BUT2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:28:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49214 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752334Ab2BUT2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:28:21 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Support raw reads from cached registers
Date: Tue, 21 Feb 2012 19:28:18 +0000
Message-Id: <1329852498-28543-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fall back to a register by register read to do so; most likely we'll be
cache only so the overhead will be low.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   28 ++++++++++++++++++++++------
 1 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e015acd..e146b02 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -712,16 +712,32 @@ EXPORT_SYMBOL_GPL(regmap_read);
 int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 		    size_t val_len)
 {
-	size_t val_count = val_len / map->format.val_bytes;
-	int ret;
-
-	WARN_ON(!regmap_volatile_range(map, reg, val_count) &&
-		map->cache_type != REGCACHE_NONE);
+	size_t val_bytes = map->format.val_bytes;
+	size_t val_count = val_len / val_bytes;
+	unsigned int v;
+	int ret, i;
 
 	mutex_lock(&map->lock);
 
-	ret = _regmap_raw_read(map, reg, val, val_len);
+	if (regmap_volatile_range(map, reg, val_count) || map->cache_bypass ||
+	    map->cache_type == REGCACHE_NONE) {
+		/* Physical block read if there's no cache involved */
+		ret = _regmap_raw_read(map, reg, val, val_len);
+
+	} else {
+		/* Otherwise go word by word for the cache; should be low
+		 * cost as we expect to hit the cache.
+		 */
+		for (i = 0; i < val_count; i++) {
+			ret = _regmap_read(map, reg + i, &v);
+			if (ret != 0)
+				goto out;
+
+			map->format.format_val(val + (i * val_bytes), v);
+		}
+	}
 
+ out:
 	mutex_unlock(&map->lock);
 
 	return ret;
-- 
1.7.9.1

