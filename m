Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1I1KoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 06:44:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50439 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282Ab1I1Knz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 06:43:55 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/7] regmap: Add a mutex to guard the sync operation
Date: Wed, 28 Sep 2011 11:43:43 +0100
Message-Id: <1317206627-6673-3-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h |    1 +
 drivers/base/regmap/regcache.c |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 2d51b1b..a0b931d 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -32,6 +32,7 @@ struct regmap_format {
 
 struct regmap {
 	struct mutex lock;
+	struct mutex sync_lock;
 
 	struct device *dev; /* Device we do I/O on */
 	void *work_buf;     /* Scratch buffer used to format I/O */
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index f46e247..b843b5f 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -130,6 +130,8 @@ int regcache_init(struct regmap *map)
 	if (!map->max_register)
 		map->max_register = map->num_reg_defaults_raw;
 
+	mutex_init(&map->sync_lock);
+
 	if (map->cache_ops->init) {
 		dev_dbg(map->dev, "Initializing %s cache\n",
 			map->cache_ops->name);
@@ -230,6 +232,7 @@ int regcache_sync(struct regmap *map)
 
 	BUG_ON(!map->cache_ops);
 
+	mutex_lock(&map->sync_lock);
 	dev_dbg(map->dev, "Syncing %s cache\n",
 		map->cache_ops->name);
 	name = map->cache_ops->name;
@@ -254,6 +257,7 @@ int regcache_sync(struct regmap *map)
 	}
 out:
 	trace_regcache_sync(map->dev, name, "stop");
+	mutex_unlock(&map->sync_lock);
 
 	return ret;
 }
-- 
1.7.6.4

