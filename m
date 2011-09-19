Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1ISSFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:05:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38799 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756234Ab1ISSEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:04:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/5] regmap: Fix hookup of regcache into regmap
Date: Mon, 19 Sep 2011 19:03:44 +0100
Message-Id: <1316455424-11173-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1316455424-11173-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110919175948.GD540@opensource.wolfsonmicro.com>
 <1316455424-11173-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Only suppress physical writes if we're in cache only mode
- Use the cache for all reads, not just internal ones
- Return -EBUSY if we're in cache only mode.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 602083f..3596465 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -304,7 +304,9 @@ static int _regmap_write(struct regmap *map, unsigned int reg,
 
 	if (!map->cache_bypass) {
 		ret = regcache_write(map, reg, val);
-		if (!ret || map->cache_only)
+		if (ret != 0)
+			return ret;
+		if (map->cache_only)
 			return 0;
 	}
 
@@ -421,6 +423,15 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 	if (!map->format.parse_val)
 		return -EINVAL;
 
+	if (!map->cache_bypass) {
+		ret = regcache_read(map, reg, val);
+		if (ret == 0)
+			return 0;
+	}
+
+	if (map->cache_only)
+		return -EBUSY;
+
 	ret = _regmap_raw_read(map, reg, map->work_buf, map->format.val_bytes);
 	if (ret == 0) {
 		*val = map->format.parse_val(map->work_buf);
@@ -446,14 +457,6 @@ int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
 
 	mutex_lock(&map->lock);
 
-	if (!map->cache_bypass) {
-		ret = regcache_read(map, reg, val);
-		if (!ret) {
-			mutex_unlock(&map->lock);
-			return 0;
-		}
-	}
-
 	ret = _regmap_read(map, reg, val);
 
 	mutex_unlock(&map->lock);
-- 
1.7.6.3

