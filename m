Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab2BWUzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:55:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60055 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756963Ab2BWUzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:55:06 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Remove default cache sync implementation
Date: Thu, 23 Feb 2012 20:55:00 +0000
Message-Id: <1330030500-13952-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not used as all cache types have sync operations so it's just dead
code which never gets tested.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |   21 ++-------------------
 1 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index fe8c9bb..0d7ac54 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -257,12 +257,11 @@ int regcache_write(struct regmap *map,
 int regcache_sync(struct regmap *map)
 {
 	int ret = 0;
-	unsigned int val;
 	unsigned int i;
 	const char *name;
 	unsigned int bypass;
 
-	BUG_ON(!map->cache_ops);
+	BUG_ON(!map->cache_ops || !map->cache_ops->sync);
 
 	mutex_lock(&map->lock);
 	/* Remember the initial bypass state */
@@ -287,24 +286,8 @@ int regcache_sync(struct regmap *map)
 	}
 	map->cache_bypass = 0;
 
-	if (map->cache_ops->sync) {
-		ret = map->cache_ops->sync(map);
-	} else {
-		for (i = 0; i < map->num_reg_defaults; i++) {
-			ret = regcache_read(map, i, &val);
-			if (ret < 0)
-				goto out;
-			map->cache_bypass = 1;
-			ret = _regmap_write(map, i, val);
-			map->cache_bypass = 0;
-			if (ret < 0)
-				goto out;
-			dev_dbg(map->dev, "Synced register %#x, value %#x\n",
-				map->reg_defaults[i].reg,
-				map->reg_defaults[i].def);
-		}
+	ret = map->cache_ops->sync(map);
 
-	}
 out:
 	trace_regcache_sync(map->dev, name, "stop");
 	/* Restore the bypass state */
-- 
1.7.9.1

