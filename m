Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab2LJQZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 11:25:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47777 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753517Ab2LJQZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 11:25:40 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] regmap: debugfs: Cache offsets of valid regions for dump
Date: Tue, 11 Dec 2012 01:25:32 +0900
Message-Id: <1355156732-2943-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355156732-2943-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1355156732-2943-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid doing a linear scan of the entire register map for each read() of
the debugfs register dump by recording the offsets where valid registers
exist when we first read the registers file. This assumes the set of
valid registers never changes, if this is not the case invalidation of
the cache will be required.

This could be further improved for large blocks of contiguous registers
by calculating the register we will read from within the block - currently
we do a linear scan of the block. An rbtree may also be worthwhile.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h       |   10 +++++
 drivers/base/regmap/regmap-debugfs.c |   67 +++++++++++++++++++++++++++-------
 2 files changed, 63 insertions(+), 14 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 7cf8c64..8580388 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -15,6 +15,7 @@
 
 #include <linux/regmap.h>
 #include <linux/fs.h>
+#include <linux/list.h>
 
 struct regmap;
 struct regcache_ops;
@@ -31,6 +32,13 @@ struct regmap_format {
 	unsigned int (*parse_val)(void *buf);
 };
 
+struct regmap_debugfs_off_cache {
+	struct list_head list;
+	off_t min;
+	off_t max;
+	unsigned int base_reg;
+};
+
 struct regmap {
 	struct mutex mutex;
 	spinlock_t spinlock;
@@ -52,6 +60,8 @@ struct regmap {
 	unsigned int debugfs_reg_len;
 	unsigned int debugfs_val_len;
 	unsigned int debugfs_tot_len;
+
+	struct list_head debugfs_off_cache;
 #endif
 
 	unsigned int max_register;
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 749a1dc..07aad78 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -65,25 +65,53 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 						  loff_t from,
 						  loff_t *pos)
 {
-	loff_t p = *pos;
-	unsigned int i;
-
-	for (i = base; i <= map->max_register; i += map->reg_stride) {
-		if (!regmap_readable(map, i))
-			continue;
-
-		if (regmap_precious(map, i))
-			continue;
+	struct regmap_debugfs_off_cache *c = NULL;
+	loff_t p = 0;
+	unsigned int i, ret;
+
+	/*
+	 * If we don't have a cache build one so we don't have to do a
+	 * linear scan each time.
+	 */
+	if (list_empty(&map->debugfs_off_cache)) {
+		for (i = base; i <= map->max_register; i += map->reg_stride) {
+			/* Skip unprinted registers, closing off cache entry */
+			if (!regmap_readable(map, i) ||
+			    regmap_precious(map, i)) {
+				if (c) {
+					c->max = p - 1;
+					list_add_tail(&c->list,
+						      &map->debugfs_off_cache);
+					c = NULL;
+				}
+
+				continue;
+			}
+
+			/* No cache entry?  Start a new one */
+			if (!c) {
+				c = kzalloc(sizeof(*c), GFP_KERNEL);
+				if (!c)
+					break;
+				c->min = p;
+				c->base_reg = i;
+			}
+
+			p += map->debugfs_tot_len;
+		}
+	}
 
-		if (i >= from) {
-			*pos = p;
-			return i;
+	/* Find the relevant block */
+	list_for_each_entry(c, &map->debugfs_off_cache, list) {
+		if (*pos >= c->min && *pos <= c->max) {
+			*pos = c->min;
+			return c->base_reg;
 		}
 
-		p += map->debugfs_tot_len;
+		ret = c->max;
 	}
 
-	return base;
+	return ret;
 }
 
 static ssize_t regmap_read_debugfs(struct regmap *map, unsigned int from,
@@ -309,6 +337,8 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 	struct rb_node *next;
 	struct regmap_range_node *range_node;
 
+	INIT_LIST_HEAD(&map->debugfs_off_cache);
+
 	if (name) {
 		map->debugfs_name = kasprintf(GFP_KERNEL, "%s-%s",
 					      dev_name(map->dev), name);
@@ -357,7 +387,16 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 
 void regmap_debugfs_exit(struct regmap *map)
 {
+	struct regmap_debugfs_off_cache *c;
+
 	debugfs_remove_recursive(map->debugfs);
+	while (!list_empty(&map->debugfs_off_cache)) {
+		c = list_first_entry(&map->debugfs_off_cache,
+				     struct regmap_debugfs_off_cache,
+				     list);
+		list_del(&c->list);
+		kfree(c);
+	}
 	kfree(map->debugfs_name);
 }
 
-- 
1.7.10.4

