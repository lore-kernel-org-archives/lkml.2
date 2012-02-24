Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab2BXNi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:38:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47040 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135Ab2BXNiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:38:25 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] regmap: Supply ranges to the sync operations
Date: Fri, 24 Feb 2012 13:38:20 +0000
Message-Id: <1330090702-22160-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow us to support partial sync operations add minimum and
maximum register arguments to the sync operation and update the rbtree
and lzo caches to use this new information. The LZO implementation is
obviously not good, we could exit the iteration earlier, but there may
be room for more wide reaching optimisation there.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h        |    2 +-
 drivers/base/regmap/regcache-lzo.c    |   10 ++++++++--
 drivers/base/regmap/regcache-rbtree.c |   25 ++++++++++++++++++++++---
 drivers/base/regmap/regcache.c        |    2 +-
 4 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index abd7667..fcafc5b 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -88,7 +88,7 @@ struct regcache_ops {
 	int (*exit)(struct regmap *map);
 	int (*read)(struct regmap *map, unsigned int reg, unsigned int *value);
 	int (*write)(struct regmap *map, unsigned int reg, unsigned int value);
-	int (*sync)(struct regmap *map);
+	int (*sync)(struct regmap *map, unsigned int min, unsigned int max);
 };
 
 bool regmap_writeable(struct regmap *map, unsigned int reg);
diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
index 3025cf9..77dc532 100644
--- a/drivers/base/regmap/regcache-lzo.c
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -331,7 +331,8 @@ out:
 	return ret;
 }
 
-static int regcache_lzo_sync(struct regmap *map)
+static int regcache_lzo_sync(struct regmap *map, unsigned int min,
+			     unsigned int max)
 {
 	struct regcache_lzo_ctx **lzo_blocks;
 	unsigned int val;
@@ -339,7 +340,12 @@ static int regcache_lzo_sync(struct regmap *map)
 	int ret;
 
 	lzo_blocks = map->cache;
-	for_each_set_bit(i, lzo_blocks[0]->sync_bmp, lzo_blocks[0]->sync_bmp_nbits) {
+	i = min;
+	for_each_set_bit_from(i, lzo_blocks[0]->sync_bmp,
+			      lzo_blocks[0]->sync_bmp_nbits) {
+		if (i > max)
+			continue;
+
 		ret = regcache_read(map, i, &val);
 		if (ret)
 			return ret;
diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 32620c4..bae183c 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -357,7 +357,8 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 	return 0;
 }
 
-static int regcache_rbtree_sync(struct regmap *map)
+static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
+				unsigned int max)
 {
 	struct regcache_rbtree_ctx *rbtree_ctx;
 	struct rb_node *node;
@@ -365,12 +366,30 @@ static int regcache_rbtree_sync(struct regmap *map)
 	unsigned int regtmp;
 	unsigned int val;
 	int ret;
-	int i;
+	int i, base, end;
 
 	rbtree_ctx = map->cache;
 	for (node = rb_first(&rbtree_ctx->root); node; node = rb_next(node)) {
 		rbnode = rb_entry(node, struct regcache_rbtree_node, node);
-		for (i = 0; i < rbnode->blklen; i++) {
+
+		if (rbnode->base_reg < min)
+			continue;
+		if (rbnode->base_reg > max)
+			break;
+		if (rbnode->base_reg + rbnode->blklen < min)
+			continue;
+
+		if (min < rbnode->base_reg + rbnode->blklen)
+			base = min - rbnode->base_reg;
+		else
+			base = 0;
+
+		if (max < rbnode->base_reg + rbnode->blklen)
+			end = rbnode->base_reg + rbnode->blklen - max;
+		else
+			end = rbnode->blklen;
+
+		for (i = base; i < end; i++) {
 			regtmp = rbnode->base_reg + i;
 			val = regcache_rbtree_get_register(rbnode, i,
 							   map->cache_word_size);
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 11198e4..002916e 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -286,7 +286,7 @@ int regcache_sync(struct regmap *map)
 	}
 	map->cache_bypass = 0;
 
-	ret = map->cache_ops->sync(map);
+	ret = map->cache_ops->sync(map, 0, map->max_register);
 
 	if (ret == 0)
 		map->cache_dirty = false;
-- 
1.7.9.1

