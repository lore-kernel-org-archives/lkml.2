Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1IENv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 09:51:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39841 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754098Ab1IENvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 09:51:10 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 5/6] regmap: Add the regcache_sync trace event
Date: Mon,  5 Sep 2011 14:51:01 +0100
Message-Id: <1315230662-12401-6-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1315230662-12401-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1315230662-12401-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |    8 +++++++-
 include/trace/events/regmap.h  |   24 ++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 67613de..abd13ee 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -219,12 +219,18 @@ EXPORT_SYMBOL_GPL(regcache_write);
  */
 int regcache_sync(struct regmap *map)
 {
+	int ret;
+	const char *name;
+
 	BUG_ON(!map->cache_ops);
 
 	if (map->cache_ops->sync) {
 		dev_dbg(map->dev, "Syncing %s cache\n",
 			map->cache_ops->name);
-		return map->cache_ops->sync(map);
+		name = map->cache_ops->name;
+		trace_regcache_sync(map->dev, name, "start");
+		ret = map->cache_ops->sync(map);
+		trace_regcache_sync(map->dev, name, "stop");
 	}
 	return 0;
 }
diff --git a/include/trace/events/regmap.h b/include/trace/events/regmap.h
index e35e37c..1e3193b 100644
--- a/include/trace/events/regmap.h
+++ b/include/trace/events/regmap.h
@@ -106,6 +106,30 @@ DEFINE_EVENT(regmap_block, regmap_hw_write_done,
 	TP_ARGS(dev, reg, count)
 );
 
+TRACE_EVENT(regcache_sync,
+
+	TP_PROTO(struct device *dev, const char *type,
+		 const char *status),
+
+	TP_ARGS(dev, type, status),
+
+	TP_STRUCT__entry(
+		__string(       name,           dev_name(dev)   )
+		__string(	status,		status		)
+		__string(	type,		type		)
+		__field(	int,		type		)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, dev_name(dev));
+		__assign_str(status, status);
+		__assign_str(type, type);
+	),
+
+	TP_printk("%s type=%s status=%s", __get_str(name),
+		  __get_str(type), __get_str(status))
+);
+
 #endif /* _TRACE_REGMAP_H */
 
 /* This part must be outside protection */
-- 
1.7.6.1

