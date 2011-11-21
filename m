Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab1KUTq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:46:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40663 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab1KUTqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:46:24 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regmap: Provide debugfs dump of the rbtree cache data
Date: Mon, 21 Nov 2011 19:46:17 +0000
Message-Id: <1321904777-3077-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1321904777-3077-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1321904777-3077-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show the register ranges we have in each rbtree node in debugfs, plus
some statistics on how big each node is and the total number of nodes.
It may also be worth collecting data on the ranges of dirty registers
to see if there's much mileage in trying to coalesce writes on sync.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-rbtree.c |   49 +++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index e71320f..7767cbb 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -11,7 +11,9 @@
  */
 
 #include <linux/slab.h>
+#include <linux/debugfs.h>
 #include <linux/rbtree.h>
+#include <linux/seq_file.h>
 
 #include "internal.h"
 
@@ -125,6 +127,51 @@ static int regcache_rbtree_insert(struct rb_root *root,
 	return 1;
 }
 
+#ifdef CONFIG_DEBUG_FS
+static int rbtree_show(struct seq_file *s, void *ignored)
+{
+	struct regmap *map = s->private;
+	struct regcache_rbtree_ctx *rbtree_ctx = map->cache;
+	struct regcache_rbtree_node *n;
+	struct rb_node *node;
+	unsigned int base, top;
+	int nodes = 0;
+	int registers = 0;
+
+	mutex_lock(&map->lock);
+
+	for (node = rb_first(&rbtree_ctx->root); node != NULL;
+	     node = rb_next(node)) {
+		n = container_of(node, struct regcache_rbtree_node, node);
+
+		regcache_rbtree_get_base_top_reg(n, &base, &top);
+		seq_printf(s, "%x-%x (%d)\n", base, top, top - base + 1);
+
+		nodes++;
+		registers += top - base + 1;
+	}
+
+	seq_printf(s, "%d nodes, %d registers, average %d registers\n",
+		   nodes, registers, registers / nodes);
+
+	mutex_unlock(&map->lock);
+
+	return 0;
+}
+
+static int rbtree_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rbtree_show, inode->i_private);
+}
+
+static const struct file_operations rbtree_fops = {
+	.open		= rbtree_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+#endif
+
 static int regcache_rbtree_init(struct regmap *map)
 {
 	struct regcache_rbtree_ctx *rbtree_ctx;
@@ -147,6 +194,8 @@ static int regcache_rbtree_init(struct regmap *map)
 			goto err;
 	}
 
+	debugfs_create_file("rbtree", 0400, map->debugfs, map, &rbtree_fops);
+
 	return 0;
 
 err:
-- 
1.7.7.3

