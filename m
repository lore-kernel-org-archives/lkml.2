Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab1I2Ngg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:36:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56534 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754398Ab1I2Ngf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:36:35 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/4] regmap: Lock the sync path, ensure we use the lockless _regmap_write()
Date: Thu, 29 Sep 2011 14:36:25 +0100
Message-Id: <1317303388-4040-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-indexed.c |    4 ++--
 drivers/base/regmap/regcache-lzo.c     |    2 +-
 drivers/base/regmap/regcache-rbtree.c  |    2 +-
 drivers/base/regmap/regcache.c         |    4 +++-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regcache-indexed.c b/drivers/base/regmap/regcache-indexed.c
index 268497a..2e10bb1 100644
--- a/drivers/base/regmap/regcache-indexed.c
+++ b/drivers/base/regmap/regcache-indexed.c
@@ -45,8 +45,8 @@ static int regcache_indexed_sync(struct regmap *map)
 	int ret;
 
 	for (i = 0; i < map->num_reg_defaults; i++) {
-		ret = regmap_write(map, map->reg_defaults[i].reg,
-				   map->reg_defaults[i].def);
+		ret = _regmap_write(map, map->reg_defaults[i].reg,
+				    map->reg_defaults[i].def);
 		if (ret < 0)
 			return ret;
 		dev_dbg(map->dev, "Synced register %#x, value %#x\n",
diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
index 9079cb5..ad6af92 100644
--- a/drivers/base/regmap/regcache-lzo.c
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -339,7 +339,7 @@ static int regcache_lzo_sync(struct regmap *map)
 		if (ret)
 			return ret;
 		map->cache_bypass = 1;
-		ret = regmap_write(map, i, val);
+		ret = _regmap_write(map, i, val);
 		map->cache_bypass = 0;
 		if (ret)
 			return ret;
diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index de32ced..40f23dd 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -327,7 +327,7 @@ static int regcache_rbtree_sync(struct regmap *map)
 			if (val == def)
 				continue;
 			map->cache_bypass = 1;
-			ret = regmap_write(map, regtmp, val);
+			ret = _regmap_write(map, regtmp, val);
 			map->cache_bypass = 0;
 			if (ret)
 				return ret;
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 4dfab41..8393c47 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -230,6 +230,7 @@ int regcache_sync(struct regmap *map)
 
 	BUG_ON(!map->cache_ops);
 
+	mutex_lock(&map->lock);
 	dev_dbg(map->dev, "Syncing %s cache\n",
 		map->cache_ops->name);
 	name = map->cache_ops->name;
@@ -242,7 +243,7 @@ int regcache_sync(struct regmap *map)
 			if (ret < 0)
 				goto out;
 			map->cache_bypass = 1;
-			ret = regmap_write(map, i, val);
+			ret = _regmap_write(map, i, val);
 			map->cache_bypass = 0;
 			if (ret < 0)
 				goto out;
@@ -254,6 +255,7 @@ int regcache_sync(struct regmap *map)
 	}
 out:
 	trace_regcache_sync(map->dev, name, "stop");
+	mutex_unlock(&map->lock);
 
 	return ret;
 }
-- 
1.7.6.4

