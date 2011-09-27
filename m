Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab1I0KZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:25:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33296 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404Ab1I0KZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:25:19 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH 4/5] regmap: Remove redundant member `word_size' from regcache_rbtree_node
Date: Tue, 27 Sep 2011 11:25:07 +0100
Message-Id: <1317119108-15338-5-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317119108-15338-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1317119108-15338-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-rbtree.c |   53 ++++++++++++++++++--------------
 1 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 4d7ba45..dd1b937 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -23,8 +23,6 @@ struct regcache_rbtree_node {
 	struct rb_node node;
 	/* base register handled by this block */
 	unsigned int base_reg;
-	/* number of bytes needed to represent the register index */
-	unsigned int word_size;
 	/* block of adjacent registers */
 	void *block;
 	/* number of registers available in the block */
@@ -45,11 +43,12 @@ static inline void regcache_rbtree_get_base_top_reg(
 }
 
 static unsigned int regcache_rbtree_get_register(
-	struct regcache_rbtree_node *rbnode, unsigned int idx)
+	struct regcache_rbtree_node *rbnode, unsigned int idx,
+	unsigned int word_size)
 {
 	unsigned int val;
 
-	switch (rbnode->word_size) {
+	switch (word_size) {
 	case 1: {
 		u8 *p = rbnode->block;
 		val = p[idx];
@@ -68,9 +67,10 @@ static unsigned int regcache_rbtree_get_register(
 }
 
 static void regcache_rbtree_set_register(struct regcache_rbtree_node *rbnode,
-					 unsigned int idx, unsigned int val)
+					 unsigned int idx, unsigned int val,
+					 unsigned int word_size)
 {
-	switch (rbnode->word_size) {
+	switch (word_size) {
 	case 1: {
 		u8 *p = rbnode->block;
 		p[idx] = val;
@@ -217,7 +217,8 @@ static int regcache_rbtree_read(struct regmap *map,
 		regcache_rbtree_get_base_top_reg(rbnode, &base_reg, &top_reg);
 		if (reg >= base_reg && reg <= top_reg) {
 			reg_tmp = reg - base_reg;
-			*value = regcache_rbtree_get_register(rbnode, reg_tmp);
+			*value = regcache_rbtree_get_register(rbnode, reg_tmp,
+							      map->cache_word_size);
 			return 0;
 		}
 	}
@@ -227,7 +228,8 @@ static int regcache_rbtree_read(struct regmap *map,
 	rbnode = regcache_rbtree_lookup(&rbtree_ctx->root, reg);
 	if (rbnode) {
 		reg_tmp = reg - rbnode->base_reg;
-		*value = regcache_rbtree_get_register(rbnode, reg_tmp);
+		*value = regcache_rbtree_get_register(rbnode, reg_tmp,
+						      map->cache_word_size);
 		rbtree_ctx->cached_rbnode = rbnode;
 	} else {
 		/* uninitialized registers default to 0 */
@@ -240,19 +242,19 @@ static int regcache_rbtree_read(struct regmap *map,
 
 static int regcache_rbtree_insert_to_block(struct regcache_rbtree_node *rbnode,
 					   unsigned int pos, unsigned int reg,
-					   unsigned int value)
+					   unsigned int value, unsigned int word_size)
 {
 	u8 *blk;
 
 	blk = krealloc(rbnode->block,
-		       (rbnode->blklen + 1) * rbnode->word_size, GFP_KERNEL);
+		       (rbnode->blklen + 1) * word_size, GFP_KERNEL);
 	if (!blk)
 		return -ENOMEM;
 
 	/* insert the register value in the correct place in the rbnode block */
-	memmove(blk + (pos + 1) * rbnode->word_size,
-		blk + pos * rbnode->word_size,
-		(rbnode->blklen - pos) * rbnode->word_size);
+	memmove(blk + (pos + 1) * word_size,
+		blk + pos * word_size,
+		(rbnode->blklen - pos) * word_size);
 
 	/* update the rbnode block, its size and the base register */
 	rbnode->block = blk;
@@ -260,7 +262,7 @@ static int regcache_rbtree_insert_to_block(struct regcache_rbtree_node *rbnode,
 	if (!pos)
 		rbnode->base_reg = reg;
 
-	regcache_rbtree_set_register(rbnode, pos, value);
+	regcache_rbtree_set_register(rbnode, pos, value, word_size);
 	return 0;
 }
 
@@ -284,10 +286,12 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 		regcache_rbtree_get_base_top_reg(rbnode, &base_reg, &top_reg);
 		if (reg >= base_reg && reg <= top_reg) {
 			reg_tmp = reg - base_reg;
-			val = regcache_rbtree_get_register(rbnode, reg_tmp);
+			val = regcache_rbtree_get_register(rbnode, reg_tmp,
+							   map->cache_word_size);
 			if (val == value)
 				return 0;
-			regcache_rbtree_set_register(rbnode, reg_tmp, value);
+			regcache_rbtree_set_register(rbnode, reg_tmp, value,
+						     map->cache_word_size);
 			return 0;
 		}
 	}
@@ -297,10 +301,12 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 	rbnode = regcache_rbtree_lookup(&rbtree_ctx->root, reg);
 	if (rbnode) {
 		reg_tmp = reg - rbnode->base_reg;
-		val = regcache_rbtree_get_register(rbnode, reg_tmp);
+		val = regcache_rbtree_get_register(rbnode, reg_tmp,
+						   map->cache_word_size);
 		if (val == value)
 			return 0;
-		regcache_rbtree_set_register(rbnode, reg_tmp, value);
+		regcache_rbtree_set_register(rbnode, reg_tmp, value,
+					     map->cache_word_size);
 		rbtree_ctx->cached_rbnode = rbnode;
 	} else {
 		/* bail out early, no need to create the rbnode yet */
@@ -320,7 +326,8 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 				else
 					pos = i;
 				ret = regcache_rbtree_insert_to_block(rbnode_tmp, pos,
-								      reg, value);
+								      reg, value,
+								      map->cache_word_size);
 				if (ret)
 					return ret;
 				rbtree_ctx->cached_rbnode = rbnode_tmp;
@@ -337,14 +344,13 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 			return -ENOMEM;
 		rbnode->blklen = 1;
 		rbnode->base_reg = reg;
-		rbnode->word_size = map->cache_word_size;
-		rbnode->block = kmalloc(rbnode->blklen * rbnode->word_size,
+		rbnode->block = kmalloc(rbnode->blklen * map->cache_word_size,
 					GFP_KERNEL);
 		if (!rbnode->block) {
 			kfree(rbnode);
 			return -ENOMEM;
 		}
-		regcache_rbtree_set_register(rbnode, 0, value);
+		regcache_rbtree_set_register(rbnode, 0, value, map->cache_word_size);
 		regcache_rbtree_insert(&rbtree_ctx->root, rbnode);
 		rbtree_ctx->cached_rbnode = rbnode;
 	}
@@ -367,7 +373,8 @@ static int regcache_rbtree_sync(struct regmap *map)
 		rbnode = rb_entry(node, struct regcache_rbtree_node, node);
 		for (i = 0; i < rbnode->blklen; i++) {
 			regtmp = rbnode->base_reg + i;
-			val = regcache_rbtree_get_register(rbnode, i);
+			val = regcache_rbtree_get_register(rbnode, i,
+							   map->cache_word_size);
 			ret = regcache_lookup_reg(map, i);
 			if (ret < 0)
 				def = 0;
-- 
1.7.6.4

