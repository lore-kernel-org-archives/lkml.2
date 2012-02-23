Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab2BWWD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:03:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44248 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784Ab2BWWDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:03:25 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Add tracepoints for cache only and cache bypass
Date: Thu, 23 Feb 2012 22:03:19 +0000
Message-Id: <1330034599-6448-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useful for figuring out where the hardware interaction went or came from.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    2 ++
 include/trace/events/regmap.h  |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 6cd0398..1124abc 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -360,6 +360,7 @@ void regcache_cache_only(struct regmap *map, bool enable)
 	mutex_lock(&map->lock);
 	WARN_ON(map->cache_bypass && enable);
 	map->cache_only = enable;
+	trace_regmap_cache_only(map->dev, enable);
 	mutex_unlock(&map->lock);
 }
 EXPORT_SYMBOL_GPL(regcache_cache_only);
@@ -397,6 +398,7 @@ void regcache_cache_bypass(struct regmap *map, bool enable)
 	mutex_lock(&map->lock);
 	WARN_ON(map->cache_only && enable);
 	map->cache_bypass = enable;
+	trace_regmap_cache_bypass(map->dev, enable);
 	mutex_unlock(&map->lock);
 }
 EXPORT_SYMBOL_GPL(regcache_cache_bypass);
diff --git a/include/trace/events/regmap.h b/include/trace/events/regmap.h
index 12fbf43..d697382 100644
--- a/include/trace/events/regmap.h
+++ b/include/trace/events/regmap.h
@@ -139,6 +139,42 @@ TRACE_EVENT(regcache_sync,
 		  __get_str(type), __get_str(status))
 );
 
+DECLARE_EVENT_CLASS(regmap_bool,
+
+	TP_PROTO(struct device *dev, bool flag),
+
+	TP_ARGS(dev, flag),
+
+	TP_STRUCT__entry(
+		__string(	name,		dev_name(dev)	)
+		__field(	int,		flag		)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, dev_name(dev));
+		__entry->flag = flag;
+	),
+
+	TP_printk("%s flag=%d", __get_str(name),
+		  (int)__entry->flag)
+);
+
+DEFINE_EVENT(regmap_bool, regmap_cache_only,
+
+	TP_PROTO(struct device *dev, bool flag),
+
+	TP_ARGS(dev, flag)
+
+);
+
+DEFINE_EVENT(regmap_bool, regmap_cache_bypass,
+
+	TP_PROTO(struct device *dev, bool flag),
+
+	TP_ARGS(dev, flag)
+
+);
+
 #endif /* _TRACE_REGMAP_H */
 
 /* This part must be outside protection */
-- 
1.7.9.1

