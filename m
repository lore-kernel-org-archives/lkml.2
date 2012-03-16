Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab2CPCJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 22:09:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57337 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab2CPCIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 22:08:50 -0400
From: Marc Reilly <marc@cpdesign.com.au>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Marc Reilly <marc@cpdesign.com.au>
Subject: [PATCH 2/2] regmap: Use pad_bits and reg_bits when determining register format.
Date: Fri, 16 Mar 2012 12:11:43 +1100
Message-Id: <1331860303-9483-2-git-send-email-marc@cpdesign.com.au>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1331860303-9483-1-git-send-email-marc@cpdesign.com.au>
References: <1331860303-9483-1-git-send-email-marc@cpdesign.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change combines any padding bits into the register address bits when
determining register format handlers to use the next byte-divisible
register size.
A reg_shift member is introduced to the regmap struct to enable fixup
of the reg format.
Format handlers now take an extra parameter specifying the number of
bits to shift the value by.

Signed-off-by: Marc Reilly <marc@cpdesign.com.au>
---
 drivers/base/regmap/internal.h |    7 +++++--
 drivers/base/regmap/regmap.c   |   27 +++++++++++++++------------
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index e93d7b7..7b1411d 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -26,8 +26,8 @@ struct regmap_format {
 	size_t val_bytes;
 	void (*format_write)(struct regmap *map,
 			     unsigned int reg, unsigned int val);
-	void (*format_reg)(void *buf, unsigned int reg);
-	void (*format_val)(void *buf, unsigned int val);
+	void (*format_reg)(void *buf, unsigned int reg, unsigned int shift);
+	void (*format_val)(void *buf, unsigned int val, unsigned int shift);
 	unsigned int (*parse_val)(void *buf);
 };
 
@@ -52,6 +52,9 @@ struct regmap {
 	u8 read_flag_mask;
 	u8 write_flag_mask;
 
+	/* number of bits to (left) shift the reg value when formatting*/
+	int reg_shift;
+
 	/* regcache specific members */
 	const struct regcache_ops *cache_ops;
 	enum regcache_type cache_type;
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 9cfe203..ca08592 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -112,34 +112,36 @@ static void regmap_format_10_14_write(struct regmap *map,
 	out[0] = reg >> 2;
 }
 
-static void regmap_format_8(void *buf, unsigned int val)
+static void regmap_format_8(void *buf, unsigned int val, unsigned int shift)
 {
 	u8 *b = buf;
 
-	b[0] = val;
+	b[0] = val << shift;
 }
 
-static void regmap_format_16(void *buf, unsigned int val)
+static void regmap_format_16(void *buf, unsigned int val, unsigned int shift)
 {
 	__be16 *b = buf;
 
-	b[0] = cpu_to_be16(val);
+	b[0] = cpu_to_be16(val << shift);
 }
 
-static void regmap_format_24(void *buf, unsigned int val)
+static void regmap_format_24(void *buf, unsigned int val, unsigned int shift)
 {
 	u8 *b = buf;
 
+	val <<= shift;
+
 	b[0] = val >> 16;
 	b[1] = val >> 8;
 	b[2] = val;
 }
 
-static void regmap_format_32(void *buf, unsigned int val)
+static void regmap_format_32(void *buf, unsigned int val, unsigned int shift)
 {
 	__be32 *b = buf;
 
-	b[0] = cpu_to_be32(val);
+	b[0] = cpu_to_be32(val << shift);
 }
 
 static unsigned int regmap_parse_8(void *buf)
@@ -210,6 +212,7 @@ struct regmap *regmap_init(struct device *dev,
 	map->format.pad_bytes = config->pad_bits / 8;
 	map->format.val_bytes = DIV_ROUND_UP(config->val_bits, 8);
 	map->format.buf_size += map->format.pad_bytes;
+	map->reg_shift = config->pad_bits % 8;
 	map->dev = dev;
 	map->bus = bus;
 	map->max_register = config->max_register;
@@ -226,7 +229,7 @@ struct regmap *regmap_init(struct device *dev,
 		map->read_flag_mask = bus->read_flag_mask;
 	}
 
-	switch (config->reg_bits) {
+	switch (config->reg_bits + map->reg_shift) {
 	case 2:
 		switch (config->val_bits) {
 		case 6:
@@ -392,7 +395,7 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 			if (!map->writeable_reg(map->dev, reg + i))
 				return -EINVAL;
 
-	map->format.format_reg(map->work_buf, reg);
+	map->format.format_reg(map->work_buf, reg, map->reg_shift);
 
 	u8[0] |= map->write_flag_mask;
 
@@ -467,7 +470,7 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 		return ret;
 	} else {
 		map->format.format_val(map->work_buf + map->format.reg_bytes
-				       + map->format.pad_bytes, val);
+				       + map->format.pad_bytes, val, 0);
 		return _regmap_raw_write(map, reg,
 					 map->work_buf +
 					 map->format.reg_bytes +
@@ -541,7 +544,7 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	u8 *u8 = map->work_buf;
 	int ret;
 
-	map->format.format_reg(map->work_buf, reg);
+	map->format.format_reg(map->work_buf, reg, map->reg_shift);
 
 	/*
 	 * Some buses or devices flag reads by setting the high bits in the
@@ -649,7 +652,7 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 			if (ret != 0)
 				goto out;
 
-			map->format.format_val(val + (i * val_bytes), v);
+			map->format.format_val(val + (i * val_bytes), v, 0);
 		}
 	}
 
-- 
1.7.3.4

