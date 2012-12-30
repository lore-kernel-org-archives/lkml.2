Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab2L3TkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 14:40:22 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:35483 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab2L3TkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 14:40:02 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrey.smirnov@convergeddevices.net
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] [regmap] Add provisions to have user-defined write operation
Date: Sun, 30 Dec 2012 11:39:48 -0800
Message-Id: <1356896389-4098-3-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356896389-4098-1-git-send-email-andrew.smirnov@gmail.com>
References: <1356896389-4098-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit is a preparatory commit to provide "no-bus" configuration
option for regmap API. It adds necessary plumbing needed to have the
ability to provide user define register write function.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 drivers/base/regmap/internal.h |    1 +
 drivers/base/regmap/regmap.c   |   83 ++++++++++++++++++++++++++--------------
 2 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 471eb90..51f0574 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -75,6 +75,7 @@ struct regmap {
 	const struct regmap_access_table *precious_table;
 
 	int (*reg_read)(void *context, unsigned int reg, unsigned int *val);
+	int (*reg_write)(void *context, unsigned int reg, unsigned int val);
 
 	u8 read_flag_mask;
 	u8 write_flag_mask;
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index ceaefcf..6845a07 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -36,6 +36,10 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 
 static int _regmap_bus_read(void *context, unsigned int reg,
 			    unsigned int *val);
+static int _regmap_bus_formatted_write(void *context, unsigned int reg,
+				       unsigned int val);
+static int _regmap_bus_raw_write(void *context, unsigned int reg,
+				 unsigned int val);
 
 bool regmap_reg_in_ranges(unsigned int reg,
 			  const struct regmap_range *ranges,
@@ -580,6 +584,11 @@ struct regmap *regmap_init(struct device *dev,
 		goto err_map;
 	}
 
+	if (map->format.format_write)
+		map->reg_write = _regmap_bus_formatted_write;
+	else if (map->format.format_val)
+		map->reg_write = _regmap_bus_raw_write;
+
 	map->range_tree = RB_ROOT;
 	for (i = 0; i < config->num_ranges; i++) {
 		const struct regmap_range_cfg *range_cfg = &config->ranges[i];
@@ -986,12 +995,54 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	return ret;
 }
 
+static int _regmap_bus_formatted_write(void *context, unsigned int reg,
+				       unsigned int val)
+{
+	int ret;
+	struct regmap_range_node *range;
+	struct regmap *map = context;
+
+	BUG_ON(!map->format.format_write);
+
+	range = _regmap_range_lookup(map, reg);
+	if (range) {
+		ret = _regmap_select_page(map, &reg, range, 1);
+		if (ret != 0)
+			return ret;
+	}
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
+static int _regmap_bus_raw_write(void *context, unsigned int reg,
+				 unsigned int val)
+{
+	struct regmap *map = context;
+
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
-	struct regmap_range_node *range;
 	int ret;
-	BUG_ON(!map->format.format_write && !map->format.format_val);
 
 	if (!map->cache_bypass && map->format.format_write) {
 		ret = regcache_write(map, reg, val);
@@ -1010,33 +1061,7 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 
 	trace_regmap_reg_write(map->dev, reg, val);
 
-	if (map->format.format_write) {
-		range = _regmap_range_lookup(map, reg);
-		if (range) {
-			ret = _regmap_select_page(map, &reg, range, 1);
-			if (ret != 0)
-				return ret;
-		}
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

