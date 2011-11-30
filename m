Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab1K3O1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:27:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50890 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752433Ab1K3O1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:27:30 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Add trace event for successful cache reads
Date: Wed, 30 Nov 2011 14:27:27 +0000
Message-Id: <1322663247-12315-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we only trace physical reads, there's no instrumentation if
the read is satisfied from cache.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |   12 ++++++++++--
 include/trace/events/regmap.h  |    9 +++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 1ca2d7a..1ead661 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -193,13 +193,21 @@ void regcache_exit(struct regmap *map)
 int regcache_read(struct regmap *map,
 		  unsigned int reg, unsigned int *value)
 {
+	int ret;
+
 	if (map->cache_type == REGCACHE_NONE)
 		return -ENOSYS;
 
 	BUG_ON(!map->cache_ops);
 
-	if (!regmap_volatile(map, reg))
-		return map->cache_ops->read(map, reg, value);
+	if (!regmap_volatile(map, reg)) {
+		ret = map->cache_ops->read(map, reg, value);
+
+		if (ret == 0)
+			trace_regmap_reg_read_cache(map->dev, reg, *value);
+
+		return ret;
+	}
 
 	return -EINVAL;
 }
diff --git a/include/trace/events/regmap.h b/include/trace/events/regmap.h
index 1e3193b..12fbf43 100644
--- a/include/trace/events/regmap.h
+++ b/include/trace/events/regmap.h
@@ -55,6 +55,15 @@ DEFINE_EVENT(regmap_reg, regmap_reg_read,
 
 );
 
+DEFINE_EVENT(regmap_reg, regmap_reg_read_cache,
+
+	TP_PROTO(struct device *dev, unsigned int reg,
+		 unsigned int val),
+
+	TP_ARGS(dev, reg, val)
+
+);
+
 DECLARE_EVENT_CLASS(regmap_block,
 
 	TP_PROTO(struct device *dev, unsigned int reg, int count),
-- 
1.7.7.3

