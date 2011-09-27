Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab1I0KZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:25:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33299 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753391Ab1I0KZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:25:18 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH 3/5] regmap: Implement generic syncing functionality
Date: Tue, 27 Sep 2011 11:25:06 +0100
Message-Id: <1317119108-15338-4-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317119108-15338-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1317119108-15338-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the absence of a sync callback, do it manually.  This of course
can't take advantange of the specific optimizations of each
cache type but it will do well enough in most cases.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |   33 ++++++++++++++++++++++++++-------
 1 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index f2d1a5e..2628e42 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -223,20 +223,39 @@ EXPORT_SYMBOL_GPL(regcache_write);
  */
 int regcache_sync(struct regmap *map)
 {
-	int ret;
+	int ret = 0;
+	unsigned int val;
+	unsigned int i;
 	const char *name;
 
 	BUG_ON(!map->cache_ops);
 
+	dev_dbg(map->dev, "Syncing %s cache\n",
+		map->cache_ops->name);
+	name = map->cache_ops->name;
+	trace_regcache_sync(map->dev, name, "start");
 	if (map->cache_ops->sync) {
-		dev_dbg(map->dev, "Syncing %s cache\n",
-			map->cache_ops->name);
-		name = map->cache_ops->name;
-		trace_regcache_sync(map->dev, name, "start");
 		ret = map->cache_ops->sync(map);
-		trace_regcache_sync(map->dev, name, "stop");
+	} else {
+		for (i = 0; i < map->num_reg_defaults; i++) {
+			ret = regcache_read(map, i, &val);
+			if (ret < 0)
+				goto out;
+			regcache_cache_bypass(map, true);
+			ret = regcache_write(map, i, val);
+			regcache_cache_bypass(map, false);
+			if (ret < 0)
+				goto out;
+			dev_dbg(map->dev, "Synced register %#x, value %#x\n",
+				map->reg_defaults[i].reg,
+				map->reg_defaults[i].def);
+		}
+
 	}
-	return 0;
+out:
+	trace_regcache_sync(map->dev, name, "stop");
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(regcache_sync);
 
-- 
1.7.6.4

