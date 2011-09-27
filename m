Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1I0SRC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:17:02 -0400
Received: from smtp-out-134.synserver.de ([212.40.185.134]:1073 "HELO
	smtp-out-133.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751678Ab1I0SRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:17:00 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 19656
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/2] regmap: rbtree-cache: Move cached rbnode handling into lookup function
Date: Tue, 27 Sep 2011 20:15:38 +0200
Message-Id: <1317147338-21492-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1317147338-21492-1-git-send-email-lars@metafoo.de>
References: <1317147338-21492-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the handling of the cached rbnode into regcache_rbtree_lookup. This allows
us to remove of some duplicated code sections in regcache_rbtree_read and
regcache_rbtree_write.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regcache-rbtree.c |   61 ++++++++++-----------------------
 1 files changed, 18 insertions(+), 43 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 52669de..de32ced 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -56,23 +56,33 @@ static void regcache_rbtree_set_register(struct regcache_rbtree_node *rbnode,
 	regcache_set_val(rbnode->block, idx, val, word_size);
 }
 
-static struct regcache_rbtree_node *regcache_rbtree_lookup(
-	struct rb_root *root, unsigned int reg)
+static struct regcache_rbtree_node *regcache_rbtree_lookup(struct regmap *map,
+	unsigned int reg)
 {
+	struct regcache_rbtree_ctx *rbtree_ctx = map->cache;
 	struct rb_node *node;
 	struct regcache_rbtree_node *rbnode;
 	unsigned int base_reg, top_reg;
 
-	node = root->rb_node;
+	rbnode = rbtree_ctx->cached_rbnode;
+	if (rbnode) {
+		regcache_rbtree_get_base_top_reg(rbnode, &base_reg, &top_reg);
+		if (reg >= base_reg && reg <= top_reg)
+			return rbnode;
+	}
+
+	node = rbtree_ctx->root.rb_node;
 	while (node) {
 		rbnode = container_of(node, struct regcache_rbtree_node, node);
 		regcache_rbtree_get_base_top_reg(rbnode, &base_reg, &top_reg);
-		if (reg >= base_reg && reg <= top_reg)
+		if (reg >= base_reg && reg <= top_reg) {
+			rbtree_ctx->cached_rbnode = rbnode;
 			return rbnode;
-		else if (reg > top_reg)
+		} else if (reg > top_reg) {
 			node = node->rb_right;
-		else if (reg < base_reg)
+		} else if (reg < base_reg) {
 			node = node->rb_left;
+		}
 	}
 
 	return NULL;
@@ -174,32 +184,14 @@ static int regcache_rbtree_exit(struct regmap *map)
 static int regcache_rbtree_read(struct regmap *map,
 				unsigned int reg, unsigned int *value)
 {
-	struct regcache_rbtree_ctx *rbtree_ctx;
 	struct regcache_rbtree_node *rbnode;
-	unsigned int base_reg, top_reg;
 	unsigned int reg_tmp;
 
-	rbtree_ctx = map->cache;
-	/* look up the required register in the cached rbnode */
-	rbnode = rbtree_ctx->cached_rbnode;
-	if (rbnode) {
-		regcache_rbtree_get_base_top_reg(rbnode, &base_reg, &top_reg);
-		if (reg >= base_reg && reg <= top_reg) {
-			reg_tmp = reg - base_reg;
-			*value = regcache_rbtree_get_register(rbnode, reg_tmp,
-							      map->cache_word_size);
-			return 0;
-		}
-	}
-	/* if we can't locate it in the cached rbnode we'll have
-	 * to traverse the rbtree looking for it.
-	 */
-	rbnode = regcache_rbtree_lookup(&rbtree_ctx->root, reg);
+	rbnode = regcache_rbtree_lookup(map, reg);
 	if (rbnode) {
 		reg_tmp = reg - rbnode->base_reg;
 		*value = regcache_rbtree_get_register(rbnode, reg_tmp,
 						      map->cache_word_size);
-		rbtree_ctx->cached_rbnode = rbnode;
 	} else {
 		/* uninitialized registers default to 0 */
 		*value = 0;
@@ -243,31 +235,15 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 	struct rb_node *node;
 	unsigned int val;
 	unsigned int reg_tmp;
-	unsigned int base_reg, top_reg;
 	unsigned int pos;
 	int i;
 	int ret;
 
 	rbtree_ctx = map->cache;
-	/* look up the required register in the cached rbnode */
-	rbnode = rbtree_ctx->cached_rbnode;
-	if (rbnode) {
-		regcache_rbtree_get_base_top_reg(rbnode, &base_reg, &top_reg);
-		if (reg >= base_reg && reg <= top_reg) {
-			reg_tmp = reg - base_reg;
-			val = regcache_rbtree_get_register(rbnode, reg_tmp,
-							   map->cache_word_size);
-			if (val == value)
-				return 0;
-			regcache_rbtree_set_register(rbnode, reg_tmp, value,
-						     map->cache_word_size);
-			return 0;
-		}
-	}
 	/* if we can't locate it in the cached rbnode we'll have
 	 * to traverse the rbtree looking for it.
 	 */
-	rbnode = regcache_rbtree_lookup(&rbtree_ctx->root, reg);
+	rbnode = regcache_rbtree_lookup(map, reg);
 	if (rbnode) {
 		reg_tmp = reg - rbnode->base_reg;
 		val = regcache_rbtree_get_register(rbnode, reg_tmp,
@@ -276,7 +252,6 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 			return 0;
 		regcache_rbtree_set_register(rbnode, reg_tmp, value,
 					     map->cache_word_size);
-		rbtree_ctx->cached_rbnode = rbnode;
 	} else {
 		/* bail out early, no need to create the rbnode yet */
 		if (!value)
-- 
1.7.2.5

