Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab2L3Tk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 14:40:28 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:65470 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab2L3TkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 14:40:01 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrey.smirnov@convergeddevices.net
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] [regmap] Add provisions to have user-defined read operation
Date: Sun, 30 Dec 2012 11:39:47 -0800
Message-Id: <1356896389-4098-2-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356896389-4098-1-git-send-email-andrew.smirnov@gmail.com>
References: <1356896389-4098-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit is a preparatory commit to provide "no-bus" configuration
option for regmap API. It adds necessary plumbing needed to have the
ability to provide user define register read function.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 drivers/base/regmap/internal.h |    2 ++
 drivers/base/regmap/regmap.c   |   35 ++++++++++++++++++++++++++---------
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 401d191..471eb90 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -74,6 +74,8 @@ struct regmap {
 	const struct regmap_access_table *volatile_table;
 	const struct regmap_access_table *precious_table;
 
+	int (*reg_read)(void *context, unsigned int reg, unsigned int *val);
+
 	u8 read_flag_mask;
 	u8 write_flag_mask;
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 42d5cb0..ceaefcf 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -34,6 +34,9 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 			       unsigned int mask, unsigned int val,
 			       bool *change);
 
+static int _regmap_bus_read(void *context, unsigned int reg,
+			    unsigned int *val);
+
 bool regmap_reg_in_ranges(unsigned int reg,
 			  const struct regmap_range *ranges,
 			  unsigned int nranges)
@@ -430,6 +433,8 @@ struct regmap *regmap_init(struct device *dev,
 		map->read_flag_mask = bus->read_flag_mask;
 	}
 
+	map->reg_read = _regmap_bus_read;
+
 	reg_endian = config->reg_format_endian;
 	if (reg_endian == REGMAP_ENDIAN_DEFAULT)
 		reg_endian = bus->reg_format_endian_default;
@@ -1202,10 +1207,27 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	return ret;
 }
 
+static int _regmap_bus_read(void *context, unsigned int reg,
+			    unsigned int *val)
+{
+	int ret;
+	struct regmap *map = context;
+
+	if (!map->format.parse_val)
+		return -EINVAL;
+
+	ret = _regmap_raw_read(map, reg, map->work_buf, map->format.val_bytes);
+	if (ret == 0)
+		*val = map->format.parse_val(map->work_buf);
+
+	return ret;
+}
+
 static int _regmap_read(struct regmap *map, unsigned int reg,
 			unsigned int *val)
 {
 	int ret;
+	BUG_ON(!map->reg_read);
 
 	if (!map->cache_bypass) {
 		ret = regcache_read(map, reg, val);
@@ -1213,26 +1235,21 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 			return 0;
 	}
 
-	if (!map->format.parse_val)
-		return -EINVAL;
-
 	if (map->cache_only)
 		return -EBUSY;
 
-	ret = _regmap_raw_read(map, reg, map->work_buf, map->format.val_bytes);
+	ret = map->reg_read(map, reg, val);
 	if (ret == 0) {
-		*val = map->format.parse_val(map->work_buf);
-
 #ifdef LOG_DEVICE
 		if (strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
 			dev_info(map->dev, "%x => %x\n", reg, *val);
 #endif
 
 		trace_regmap_reg_read(map->dev, reg, *val);
-	}
 
-	if (ret == 0 && !map->cache_bypass)
-		regcache_write(map, reg, *val);
+		if (!map->cache_bypass)
+			regcache_write(map, reg, *val);
+	}
 
 	return ret;
 }
-- 
1.7.9.5

