Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab2LUJxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 04:53:47 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:42132 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2LUJxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 04:53:39 -0500
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 04:53:38 EST
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrey.smirnov@convergeddevices.net
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Add provisions to have user-defined read operation
Date: Fri, 21 Dec 2012 01:47:16 -0800
Message-Id: <1356083238-6932-2-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356083238-6932-1-git-send-email-andrew.smirnov@gmail.com>
References: <1356083238-6932-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit is a preparatory commit to provide "no-bus" configuration
option for regmap API. It adds necessary plumbing needed to have the
ability to provide user define register read function.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 drivers/base/regmap/internal.h |    2 ++
 drivers/base/regmap/regmap.c   |   34 +++++++++++++++++++++++++---------
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 80f9ab9..c450c1f 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -58,6 +58,8 @@ struct regmap {
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
 
+	int (*reg_read)(struct regmap *map, unsigned int reg, unsigned int *val);
+
 	u8 read_flag_mask;
 	u8 write_flag_mask;
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c241ae2..4e45877 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -34,6 +34,9 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 			       unsigned int mask, unsigned int val,
 			       bool *change);
 
+static int _regmap_bus_read(struct regmap *map, unsigned int reg,
+			    unsigned int *val);
+
 bool regmap_writeable(struct regmap *map, unsigned int reg)
 {
 	if (map->max_register && reg > map->max_register)
@@ -373,6 +376,8 @@ struct regmap *regmap_init(struct device *dev,
 		map->read_flag_mask = bus->read_flag_mask;
 	}
 
+	map->reg_read = _regmap_bus_read;
+
 	reg_endian = config->reg_format_endian;
 	if (reg_endian == REGMAP_ENDIAN_DEFAULT)
 		reg_endian = bus->reg_format_endian_default;
@@ -1090,10 +1095,26 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	return ret;
 }
 
+static int _regmap_bus_read(struct regmap *map, unsigned int reg,
+			    unsigned int *val)
+{
+	int ret;
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
@@ -1101,26 +1122,21 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
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

