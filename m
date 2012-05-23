Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab2EWWeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 18:34:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35283 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2EWWeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 18:34:01 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/2] regmap: allow busses to request formatting with specific endianness
Date: Wed, 23 May 2012 16:33:53 -0600
Message-Id: <1337812434-7609-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Add a field to struct regmap_bus that allows bus drivers to request that
register addresses and values be formatted with a specific endianness.

The default endianness is unchanged from current operation: Big.

Implement native endian formatting/parsing for 16- and 32-bit values.
This will be enough to support regmap-mmio.c.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
I'm not 100% sure if this is the approach you had in mind. However, anything
more all-encompassing would require separating the concepts of endianness and
serialization that are coupled together in functions like
regmap_format_4_12_write, and I'm not sure how that would work conceptually.

 drivers/base/regmap/regmap.c |   90 +++++++++++++++++++++++++++++++++++++-----
 include/linux/regmap.h       |    9 ++++
 2 files changed, 89 insertions(+), 10 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 2aa076e..33da8bd 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -119,13 +119,19 @@ static void regmap_format_8(void *buf, unsigned int val, unsigned int shift)
 	b[0] = val << shift;
 }
 
-static void regmap_format_16(void *buf, unsigned int val, unsigned int shift)
+static void regmap_format_16_be(void *buf, unsigned int val, unsigned int shift)
 {
 	__be16 *b = buf;
 
 	b[0] = cpu_to_be16(val << shift);
 }
 
+static void regmap_format_16_native(void *buf, unsigned int val,
+				    unsigned int shift)
+{
+	*(u16 *)buf = val << shift;
+}
+
 static void regmap_format_24(void *buf, unsigned int val, unsigned int shift)
 {
 	u8 *b = buf;
@@ -137,13 +143,19 @@ static void regmap_format_24(void *buf, unsigned int val, unsigned int shift)
 	b[2] = val;
 }
 
-static void regmap_format_32(void *buf, unsigned int val, unsigned int shift)
+static void regmap_format_32_be(void *buf, unsigned int val, unsigned int shift)
 {
 	__be32 *b = buf;
 
 	b[0] = cpu_to_be32(val << shift);
 }
 
+static void regmap_format_32_native(void *buf, unsigned int val,
+				    unsigned int shift)
+{
+	*(u32 *)buf = val << shift;
+}
+
 static unsigned int regmap_parse_8(void *buf)
 {
 	u8 *b = buf;
@@ -151,7 +163,7 @@ static unsigned int regmap_parse_8(void *buf)
 	return b[0];
 }
 
-static unsigned int regmap_parse_16(void *buf)
+static unsigned int regmap_parse_16_be(void *buf)
 {
 	__be16 *b = buf;
 
@@ -160,6 +172,11 @@ static unsigned int regmap_parse_16(void *buf)
 	return b[0];
 }
 
+static unsigned int regmap_parse_16_native(void *buf)
+{
+	return *(u16 *)buf;
+}
+
 static unsigned int regmap_parse_24(void *buf)
 {
 	u8 *b = buf;
@@ -170,7 +187,7 @@ static unsigned int regmap_parse_24(void *buf)
 	return ret;
 }
 
-static unsigned int regmap_parse_32(void *buf)
+static unsigned int regmap_parse_32_be(void *buf)
 {
 	__be32 *b = buf;
 
@@ -179,6 +196,11 @@ static unsigned int regmap_parse_32(void *buf)
 	return b[0];
 }
 
+static unsigned int regmap_parse_32_native(void *buf)
+{
+	return *(u32 *)buf;
+}
+
 static void regmap_lock_mutex(struct regmap *map)
 {
 	mutex_lock(&map->mutex);
@@ -279,6 +301,8 @@ struct regmap *regmap_init(struct device *dev,
 	case 2:
 		switch (config->val_bits) {
 		case 6:
+			if (bus->format_endian != REGMAP_ENDIAN_BIG)
+				goto err_map;
 			map->format.format_write = regmap_format_2_6_write;
 			break;
 		default:
@@ -289,6 +313,8 @@ struct regmap *regmap_init(struct device *dev,
 	case 4:
 		switch (config->val_bits) {
 		case 12:
+			if (bus->format_endian != REGMAP_ENDIAN_BIG)
+				goto err_map;
 			map->format.format_write = regmap_format_4_12_write;
 			break;
 		default:
@@ -299,6 +325,8 @@ struct regmap *regmap_init(struct device *dev,
 	case 7:
 		switch (config->val_bits) {
 		case 9:
+			if (bus->format_endian != REGMAP_ENDIAN_BIG)
+				goto err_map;
 			map->format.format_write = regmap_format_7_9_write;
 			break;
 		default:
@@ -309,6 +337,8 @@ struct regmap *regmap_init(struct device *dev,
 	case 10:
 		switch (config->val_bits) {
 		case 14:
+			if (bus->format_endian != REGMAP_ENDIAN_BIG)
+				goto err_map;
 			map->format.format_write = regmap_format_10_14_write;
 			break;
 		default:
@@ -321,11 +351,29 @@ struct regmap *regmap_init(struct device *dev,
 		break;
 
 	case 16:
-		map->format.format_reg = regmap_format_16;
+		switch (bus->format_endian) {
+		case REGMAP_ENDIAN_BIG:
+			map->format.format_reg = regmap_format_16_be;
+			break;
+		case REGMAP_ENDIAN_NATIVE:
+			map->format.format_reg = regmap_format_16_native;
+			break;
+		default:
+			goto err_map;
+		}
 		break;
 
 	case 32:
-		map->format.format_reg = regmap_format_32;
+		switch (bus->format_endian) {
+		case REGMAP_ENDIAN_BIG:
+			map->format.format_reg = regmap_format_32_be;
+			break;
+		case REGMAP_ENDIAN_NATIVE:
+			map->format.format_reg = regmap_format_32_native;
+			break;
+		default:
+			goto err_map;
+		}
 		break;
 
 	default:
@@ -338,16 +386,38 @@ struct regmap *regmap_init(struct device *dev,
 		map->format.parse_val = regmap_parse_8;
 		break;
 	case 16:
-		map->format.format_val = regmap_format_16;
-		map->format.parse_val = regmap_parse_16;
+		switch (bus->format_endian) {
+		case REGMAP_ENDIAN_BIG:
+			map->format.format_val = regmap_format_16_be;
+			map->format.parse_val = regmap_parse_16_be;
+			break;
+		case REGMAP_ENDIAN_NATIVE:
+			map->format.format_val = regmap_format_16_native;
+			map->format.parse_val = regmap_parse_16_native;
+			break;
+		default:
+			goto err_map;
+		}
 		break;
 	case 24:
+		if (bus->format_endian != REGMAP_ENDIAN_BIG)
+			goto err_map;
 		map->format.format_val = regmap_format_24;
 		map->format.parse_val = regmap_parse_24;
 		break;
 	case 32:
-		map->format.format_val = regmap_format_32;
-		map->format.parse_val = regmap_parse_32;
+		switch (bus->format_endian) {
+		case REGMAP_ENDIAN_BIG:
+			map->format.format_val = regmap_format_32_be;
+			map->format.parse_val = regmap_parse_32_be;
+			break;
+		case REGMAP_ENDIAN_NATIVE:
+			map->format.format_val = regmap_format_32_native;
+			map->format.parse_val = regmap_parse_32_native;
+			break;
+		default:
+			goto err_map;
+		}
 		break;
 	}
 
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 56af22e..6452afd 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -121,6 +121,12 @@ typedef int (*regmap_hw_read)(void *context,
 			      void *val_buf, size_t val_size);
 typedef void (*regmap_hw_free_context)(void *context);
 
+enum regmap_endian {
+	REGMAP_ENDIAN_BIG = 0, /* Compatible default if unspecified */
+	REGMAP_ENDIAN_LITTLE,
+	REGMAP_ENDIAN_NATIVE,
+};
+
 /**
  * Description of a hardware bus for the register map infrastructure.
  *
@@ -133,6 +139,8 @@ typedef void (*regmap_hw_free_context)(void *context);
  *         data.
  * @read_flag_mask: Mask to be set in the top byte of the register when doing
  *                  a read.
+ * @format_endian: Endianness for formatted register addresses, values, or
+ *                 serialized combinations thereof.
  */
 struct regmap_bus {
 	bool fast_io;
@@ -141,6 +149,7 @@ struct regmap_bus {
 	regmap_hw_read read;
 	regmap_hw_free_context free_context;
 	u8 read_flag_mask;
+	enum regmap_endian format_endian;
 };
 
 struct regmap *regmap_init(struct device *dev,
-- 
1.7.0.4

