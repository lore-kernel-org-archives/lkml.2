Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960Ab1JIMJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 08:09:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59492 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744Ab1JIMJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 08:09:31 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Ensure rbtree syncs registers set to zero properly
Date: Sun,  9 Oct 2011 13:09:28 +0100
Message-Id: <1318162168-3284-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the check for registers set at their default value by avoiding
picking a default value in the case where we don't have one. Instead we
only compare the current value to the current value when we looked one
up. This fixes the case where we don't have a default stored but the value
was set to zero when that isn't the chip default.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-rbtree.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 40f23dd..270bd05 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -319,13 +319,12 @@ static int regcache_rbtree_sync(struct regmap *map)
 			regtmp = rbnode->base_reg + i;
 			val = regcache_rbtree_get_register(rbnode, i,
 							   map->cache_word_size);
+
+			/* Is this the hardware default?  If so skip. */
 			ret = regcache_lookup_reg(map, i);
-			if (ret < 0)
-				def = 0;
-			else
-				def = map->reg_defaults[ret].def;
-			if (val == def)
+			if (ret > 0 && val == map->reg_defaults[ret].def)
 				continue;
+
 			map->cache_bypass = 1;
 			ret = _regmap_write(map, regtmp, val);
 			map->cache_bypass = 0;
-- 
1.7.6.3

