Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab2GZLik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:38:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43308 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119Ab2GZLij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:38:39 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH] regmap: Don't lock in regmap_reinit_cache()
Date: Thu, 26 Jul 2012 12:45:55 +0100
Message-Id: <1343303155-27610-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When bus->fast_io is set, the locking here is done with spinlocks.
This is currently true for the regmap-mmio bus implementation.

While holding a spinlock we can't go to sleep, various operations
like removing the debugfs entries or re-initializing the cache will
sleep, therefore, shift the locking up to the user.

Change-Id: I766bdce4ea3415ed87116a937576aa4812aad508
Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c241ae2..52069d2 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -659,13 +659,12 @@ EXPORT_SYMBOL_GPL(devm_regmap_init);
  * new cache.  This can be used to restore the cache to defaults or to
  * update the cache configuration to reflect runtime discovery of the
  * hardware.
+ *
+ * No explicit locking is done here, the user needs to ensure that
+ * this function will not race with other calls to regmap.
  */
 int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 {
-	int ret;
-
-	map->lock(map);
-
 	regcache_exit(map);
 	regmap_debugfs_exit(map);
 
@@ -681,11 +680,7 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 	map->cache_bypass = false;
 	map->cache_only = false;
 
-	ret = regcache_init(map, config);
-
-	map->unlock(map);
-
-	return ret;
+	return regcache_init(map, config);
 }
 EXPORT_SYMBOL_GPL(regmap_reinit_cache);
 
-- 
1.7.11.3

