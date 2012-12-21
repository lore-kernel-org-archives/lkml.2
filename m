Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab2LUJx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 04:53:56 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:51364 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2LUJxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 04:53:42 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrey.smirnov@convergeddevices.net
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Add provisions to have user-defined write operation
Date: Fri, 21 Dec 2012 01:47:17 -0800
Message-Id: <1356083238-6932-3-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356083238-6932-1-git-send-email-andrew.smirnov@gmail.com>
References: <1356083238-6932-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit is a preparatory commit to provide "no-bus" configuration
option for regmap API. It adds necessary plumbing needed to have the
ability to provide user define register write function.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 drivers/base/regmap/internal.h |    1 +
 drivers/base/regmap/regmap.c   |   72 ++++++++++++++++++++++++++--------------
 2 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index c450c1f..5d10c6d 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -59,6 +59,7 @@ struct regmap {
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
 
 	int (*reg_read)(struct regmap *map, unsigned int reg, unsigned int *val);
+	int (*reg_write)(struct regmap *map, unsigned int reg, unsigned int val);
 
 	u8 read_flag_mask;
 	u8 write_flag_mask;
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 4e45877..006b50b 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -36,6 +36,11 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 
 static int _regmap_bus_read(struct regmap *map, unsigned int reg,
 			    unsigned int *val);
+static int _regmap_bus_formatted_write(struct regmap *map, unsigned int reg,
+				       unsigned int val);
+static int _regmap_bus_raw_write(struct regmap *map, unsigned int reg,
+				 unsigned int val);
+
 
 bool regmap_writeable(struct regmap *map, unsigned int reg)
 {
@@ -523,6 +528,11 @@ struct regmap *regmap_init(struct device *dev,
 		goto err_map;
 	}
 
+	if (map->format.format_write)
+		map->reg_write = _regmap_bus_formatted_write;
+	else if (map->format.format_val)
+		map->reg_write = _regmap_bus_raw_write;
+
 	map->range_tree = RB_ROOT;
 	for (i = 0; i < config->n_ranges; i++) {
 		const struct regmap_range_cfg *range_cfg = &config->ranges[i];
@@ -883,11 +893,46 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	return ret;
 }
 
+static int _regmap_bus_formatted_write(struct regmap *map, unsigned int reg,
+				       unsigned int val)
+{
+	int ret;
+	BUG_ON(!map->format.format_write);
+
+	ret = _regmap_select_page(map, &reg, 1);
+	if (ret < 0)
+		return ret;
+
+	map->format.format_write(map, reg, val);
+
+	trace_regmap_hw_write_start(map->dev, reg, 1);
+
+	ret = map->bus->write(map->bus_context, map->work_buf,
+			      map->format.buf_size);
+
+	trace_regmap_hw_write_done(map->dev, reg, 1);
+
+	return ret;
+}
+
+static int _regmap_bus_raw_write(struct regmap *map, unsigned int reg,
+				 unsigned int val)
+{
+	BUG_ON(!map->format.format_val);
+
+	map->format.format_val(map->work_buf + map->format.reg_bytes
+			       + map->format.pad_bytes, val, 0);
+	return _regmap_raw_write(map, reg,
+				 map->work_buf +
+				 map->format.reg_bytes +
+				 map->format.pad_bytes,
+				 map->format.val_bytes);
+}
+
 int _regmap_write(struct regmap *map, unsigned int reg,
 		  unsigned int val)
 {
 	int ret;
-	BUG_ON(!map->format.format_write && !map->format.format_val);
 
 	if (!map->cache_bypass && map->format.format_write) {
 		ret = regcache_write(map, reg, val);
@@ -906,30 +951,7 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 
 	trace_regmap_reg_write(map->dev, reg, val);
 
-	if (map->format.format_write) {
-		ret = _regmap_select_page(map, &reg, 1);
-		if (ret < 0)
-			return ret;
-
-		map->format.format_write(map, reg, val);
-
-		trace_regmap_hw_write_start(map->dev, reg, 1);
-
-		ret = map->bus->write(map->bus_context, map->work_buf,
-				      map->format.buf_size);
-
-		trace_regmap_hw_write_done(map->dev, reg, 1);
-
-		return ret;
-	} else {
-		map->format.format_val(map->work_buf + map->format.reg_bytes
-				       + map->format.pad_bytes, val, 0);
-		return _regmap_raw_write(map, reg,
-					 map->work_buf +
-					 map->format.reg_bytes +
-					 map->format.pad_bytes,
-					 map->format.val_bytes);
-	}
+	return map->reg_write(map, reg, val);
 }
 
 /**
-- 
1.7.9.5

