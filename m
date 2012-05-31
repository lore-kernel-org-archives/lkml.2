Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab2EaQIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:08:43 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:24937 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659Ab2EaQIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:08:42 -0400
Message-Id: <201205311607.q4VG7avr012901@sw-eng-lt-dc-vm2>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Thu, 31 May 2012 16:11:12 +0200
Subject: [PATCH 1/4] regmap: Reorganise internal read/write functions.
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract from _regmap_raw_write() and _regmap_raw_read() code responsible
for data formatting and bus access and place it in separate functions:
_regmap_bus_write() and _regmap_bus_read().

Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
---
 drivers/base/regmap/regmap.c |   80 +++++++++++++++++++++++++-----------------
 1 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index bb80853..a365aa8 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -396,40 +396,11 @@ void regmap_exit(struct regmap *map)
 }
 EXPORT_SYMBOL_GPL(regmap_exit);
 
-static int _regmap_raw_write(struct regmap *map, unsigned int reg,
-			     const void *val, size_t val_len)
+static int _regmap_bus_write(struct regmap *map, unsigned int reg,
+			     void *val, size_t val_len)
 {
 	u8 *u8 = map->work_buf;
-	void *buf;
 	int ret = -ENOTSUPP;
-	size_t len;
-	int i;
-
-	/* Check for unwritable registers before we start */
-	if (map->writeable_reg)
-		for (i = 0; i < val_len / map->format.val_bytes; i++)
-			if (!map->writeable_reg(map->dev, reg + i))
-				return -EINVAL;
-
-	if (!map->cache_bypass && map->format.parse_val) {
-		unsigned int ival;
-		int val_bytes = map->format.val_bytes;
-		for (i = 0; i < val_len / val_bytes; i++) {
-			memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
-			ival = map->format.parse_val(map->work_buf);
-			ret = regcache_write(map, reg + i, ival);
-			if (ret) {
-				dev_err(map->dev,
-				   "Error in caching of register: %u ret: %d\n",
-					reg + i, ret);
-				return ret;
-			}
-		}
-		if (map->cache_only) {
-			map->cache_dirty = true;
-			return 0;
-		}
-	}
 
 	map->format.format_reg(map->work_buf, reg);
 
@@ -456,6 +427,9 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 
 	/* If that didn't work fall back on linearising by hand. */
 	if (ret == -ENOTSUPP) {
+		void *buf;
+		size_t len;
+
 		len = map->format.reg_bytes + map->format.pad_bytes + val_len;
 		buf = kzalloc(len, GFP_KERNEL);
 		if (!buf)
@@ -475,6 +449,42 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	return ret;
 }
 
+static int _regmap_raw_write(struct regmap *map, unsigned int reg,
+			     const void *val, size_t val_len)
+{
+	void *_val = (void *)val;
+	int i;
+	int ret;
+
+	/* Check for unwritable registers before we start */
+	if (map->writeable_reg)
+		for (i = 0; i < val_len / map->format.val_bytes; i++)
+			if (!map->writeable_reg(map->dev, reg + i))
+				return -EINVAL;
+
+	if (!map->cache_bypass && map->format.parse_val) {
+		unsigned int ival;
+		int val_bytes = map->format.val_bytes;
+		for (i = 0; i < val_len / map->format.val_bytes; i++) {
+			memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
+			ival = map->format.parse_val(map->work_buf);
+			ret = regcache_write(map, reg + i, ival);
+			if (ret) {
+				dev_err(map->dev,
+				   "Error in caching of register: %u ret: %d\n",
+					reg + i, ret);
+				return ret;
+			}
+		}
+		if (map->cache_only) {
+			map->cache_dirty = true;
+			return 0;
+		}
+	}
+
+	return _regmap_bus_write(map, reg, _val, val_len);
+}
+
 int _regmap_write(struct regmap *map, unsigned int reg,
 		  unsigned int val)
 {
@@ -620,7 +630,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(regmap_bulk_write);
 
-static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
+static int _regmap_bus_read(struct regmap *map, unsigned int reg, void *val,
 			    unsigned int val_len)
 {
 	u8 *u8 = map->work_buf;
@@ -649,6 +659,12 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	return ret;
 }
 
+static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
+			    unsigned int val_len)
+{
+	return _regmap_bus_read(map, reg, val, val_len);
+}
+
 static int _regmap_read(struct regmap *map, unsigned int reg,
 			unsigned int *val)
 {
-- 
1.7.0.4

