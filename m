Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab2EaNTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:19:37 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:15976 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948Ab2EaNTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:19:35 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2012 09:19:35 EDT
Message-Id: <201205311316.q4VDGj8d013771@sw-eng-lt-dc-vm2>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Mon, 14 May 2012 14:20:42 +0200
Subject: [PATCH 1/2] regmap: Reorganise regmap internal read/write functions.
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate caching and bus access.
Make functions reentrant.

Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
---
 drivers/base/regmap/regmap.c |  110 ++++++++++++++++++++++++-----------------
 1 files changed, 64 insertions(+), 46 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index bb80853..7c5291e 100644
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
@@ -505,12 +515,9 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 
 		return ret;
 	} else {
-		map->format.format_val(map->work_buf + map->format.reg_bytes
-				       + map->format.pad_bytes, val);
-		return _regmap_raw_write(map, reg,
-					 map->work_buf +
-					 map->format.reg_bytes +
-					 map->format.pad_bytes,
+		/* Using stack for value data, to make function reentrant */
+		map->format.format_val(&val, val);
+		return _regmap_raw_write(map, reg, &val,
 					 map->format.val_bytes);
 	}
 }
@@ -620,7 +627,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(regmap_bulk_write);
 
-static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
+static int _regmap_bus_read(struct regmap *map, unsigned int reg, void *val,
 			    unsigned int val_len)
 {
 	u8 *u8 = map->work_buf;
@@ -649,6 +656,12 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
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
@@ -794,11 +807,9 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 	int ret;
 	unsigned int tmp, orig;
 
-	mutex_lock(&map->lock);
-
 	ret = _regmap_read(map, reg, &orig);
 	if (ret != 0)
-		goto out;
+		return ret;
 
 	tmp = orig & ~mask;
 	tmp |= val & mask;
@@ -810,9 +821,6 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 		*change = false;
 	}
 
-out:
-	mutex_unlock(&map->lock);
-
 	return ret;
 }
 
@@ -830,7 +838,12 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
 		       unsigned int mask, unsigned int val)
 {
 	bool change;
-	return _regmap_update_bits(map, reg, mask, val, &change);
+	int ret;
+
+	mutex_lock(&map->lock);
+	ret = _regmap_update_bits(map, reg, mask, val, &change);
+	mutex_unlock(&map->lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits);
 
@@ -850,7 +863,12 @@ int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 			     unsigned int mask, unsigned int val,
 			     bool *change)
 {
-	return _regmap_update_bits(map, reg, mask, val, change);
+	int ret;
+
+	mutex_lock(&map->lock);
+	ret = _regmap_update_bits(map, reg, mask, val, change);
+	mutex_unlock(&map->lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits_check);
 
-- 
1.7.0.4

