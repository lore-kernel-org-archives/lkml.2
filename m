Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab1JINon (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 09:44:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50403 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186Ab1JINoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 09:44:39 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dp@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regmap: Return a sensible error code if we fail to read the cache
Date: Sun,  9 Oct 2011 14:44:35 +0100
Message-Id: <1318167876-17801-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a register isn't cached then let callers know that so they can fall
back or error handle appropriately.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-indexed.c |    7 +++----
 drivers/base/regmap/regcache-lzo.c     |    4 ++--
 drivers/base/regmap/regcache-rbtree.c  |    3 +--
 drivers/base/regmap/regcache.c         |    2 +-
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/base/regmap/regcache-indexed.c b/drivers/base/regmap/regcache-indexed.c
index 2e10bb1..507731a 100644
--- a/drivers/base/regmap/regcache-indexed.c
+++ b/drivers/base/regmap/regcache-indexed.c
@@ -20,11 +20,10 @@ static int regcache_indexed_read(struct regmap *map, unsigned int reg,
 	int ret;
 
 	ret = regcache_lookup_reg(map, reg);
-	if (ret < 0)
-		*value = 0;
-	else
+	if (ret >= 0)
 		*value = map->reg_defaults[ret].def;
-	return 0;
+
+	return ret;
 }
 
 static int regcache_indexed_write(struct regmap *map, unsigned int reg,
diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
index ad6af92..066aeec 100644
--- a/drivers/base/regmap/regcache-lzo.c
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -232,7 +232,6 @@ static int regcache_lzo_read(struct regmap *map,
 	size_t blksize, tmp_dst_len;
 	void *tmp_dst;
 
-	*value = 0;
 	/* index of the compressed lzo block */
 	blkindex = regcache_lzo_get_blkindex(map, reg);
 	/* register index within the decompressed block */
@@ -261,7 +260,8 @@ static int regcache_lzo_read(struct regmap *map,
 	/* restore the pointer and length of the compressed block */
 	lzo_block->dst = tmp_dst;
 	lzo_block->dst_len = tmp_dst_len;
-	return 0;
+
+	return ret;
 }
 
 static int regcache_lzo_write(struct regmap *map,
diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index f80eebc..e314984 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -193,8 +193,7 @@ static int regcache_rbtree_read(struct regmap *map,
 		*value = regcache_rbtree_get_register(rbnode, reg_tmp,
 						      map->cache_word_size);
 	} else {
-		/* uninitialized registers default to 0 */
-		*value = 0;
+		return -ENOENT;
 	}
 
 	return 0;
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index bf82783..67c7703 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -379,7 +379,7 @@ int regcache_lookup_reg(struct regmap *map, unsigned int reg)
 	if (r)
 		return r - map->reg_defaults;
 	else
-		return -1;
+		return -ENOENT;
 }
 
 int regcache_insert_reg(struct regmap *map, unsigned int reg,
-- 
1.7.6.3

