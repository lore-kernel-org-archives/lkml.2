Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1JRK1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 06:27:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51544 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007Ab1JRK1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 06:27:16 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dp@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Prepare LZO cache for variable block sizes
Date: Tue, 18 Oct 2011 11:27:13 +0100
Message-Id: <1318933633-5759-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Give regcache_lzo_block_count() a copy of the map so that when we decide
we want to make the LZO cache more controllable we can more easily do so.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-lzo.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
index 066aeec..0075690 100644
--- a/drivers/base/regmap/regcache-lzo.c
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -27,7 +27,7 @@ struct regcache_lzo_ctx {
 };
 
 #define LZO_BLOCK_NUM 8
-static int regcache_lzo_block_count(void)
+static int regcache_lzo_block_count(struct regmap *map)
 {
 	return LZO_BLOCK_NUM;
 }
@@ -106,19 +106,22 @@ static inline int regcache_lzo_get_blkindex(struct regmap *map,
 					    unsigned int reg)
 {
 	return (reg * map->cache_word_size) /
-		DIV_ROUND_UP(map->cache_size_raw, regcache_lzo_block_count());
+		DIV_ROUND_UP(map->cache_size_raw,
+			     regcache_lzo_block_count(map));
 }
 
 static inline int regcache_lzo_get_blkpos(struct regmap *map,
 					  unsigned int reg)
 {
-	return reg % (DIV_ROUND_UP(map->cache_size_raw, regcache_lzo_block_count()) /
+	return reg % (DIV_ROUND_UP(map->cache_size_raw,
+				   regcache_lzo_block_count(map)) /
 		      map->cache_word_size);
 }
 
 static inline int regcache_lzo_get_blksize(struct regmap *map)
 {
-	return DIV_ROUND_UP(map->cache_size_raw, regcache_lzo_block_count());
+	return DIV_ROUND_UP(map->cache_size_raw,
+			    regcache_lzo_block_count(map));
 }
 
 static int regcache_lzo_init(struct regmap *map)
@@ -131,7 +134,7 @@ static int regcache_lzo_init(struct regmap *map)
 
 	ret = 0;
 
-	blkcount = regcache_lzo_block_count();
+	blkcount = regcache_lzo_block_count(map);
 	map->cache = kzalloc(blkcount * sizeof *lzo_blocks,
 			     GFP_KERNEL);
 	if (!map->cache)
@@ -203,7 +206,7 @@ static int regcache_lzo_exit(struct regmap *map)
 	if (!lzo_blocks)
 		return 0;
 
-	blkcount = regcache_lzo_block_count();
+	blkcount = regcache_lzo_block_count(map);
 	/*
 	 * the pointer to the bitmap used for syncing the cache
 	 * is shared amongst all lzo_blocks.  Ensure it is freed
-- 
1.7.6.3

