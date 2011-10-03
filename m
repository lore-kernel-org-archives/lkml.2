Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1JCJuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:50:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40151 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754074Ab1JCJuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:50:16 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regmap: Optimize the lookup path to use binary search
Date: Mon,  3 Oct 2011 10:50:14 +0100
Message-Id: <1317635414-31082-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there are more lookups than insertions in a typical
scenario, optimize the linear search into a binary search.  For
this to work, we need to keep reg_defaults sorted upon
insertions, for now be lazy and use sort().

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index f32c08c..b10e38f 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -12,6 +12,7 @@
 
 #include <linux/slab.h>
 #include <trace/events/regmap.h>
+#include <linux/sort.h>
 
 #include "internal.h"
 
@@ -356,14 +357,30 @@ unsigned int regcache_get_val(const void *base, unsigned int idx,
 
 int regcache_lookup_reg(struct regmap *map, unsigned int reg)
 {
-	unsigned int i;
-
-	for (i = 0; i < map->num_reg_defaults; i++)
-		if (map->reg_defaults[i].reg == reg)
-			return i;
+	unsigned int min, max, index;
+
+	min = 0;
+	max = map->num_reg_defaults - 1;
+	do {
+		index = (min + max) / 2;
+		if (map->reg_defaults[index].reg == reg)
+			return index;
+		if (map->reg_defaults[index].reg < reg)
+			min = index + 1;
+		else
+			max = index;
+	} while (min <= max);
 	return -1;
 }
 
+static int regcache_insert_cmp(const void *a, const void *b)
+{
+	const struct reg_default *_a = a;
+	const struct reg_default *_b = b;
+
+	return _a->reg - _b->reg;
+}
+
 int regcache_insert_reg(struct regmap *map, unsigned int reg,
 			unsigned int val)
 {
@@ -378,5 +395,7 @@ int regcache_insert_reg(struct regmap *map, unsigned int reg,
 	map->num_reg_defaults++;
 	map->reg_defaults[map->num_reg_defaults - 1].reg = reg;
 	map->reg_defaults[map->num_reg_defaults - 1].def = val;
+	sort(map->reg_defaults, map->num_reg_defaults,
+	     sizeof(struct reg_default), regcache_insert_cmp, NULL);
 	return 0;
 }
-- 
1.7.6.4

