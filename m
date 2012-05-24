Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795Ab2EXQrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:47:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51784 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933683Ab2EXQri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:47:38 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 1/2] regmap: allow busses to request formatting with specific endianness
Date: Thu, 24 May 2012 10:47:26 -0600
Message-Id: <1337878047-21177-1-git-send-email-swarren@wwwdotorg.org>
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
v2: Allow regmap_config to specify endianness, and regmap_bus to specify
a default endianness when it doesn't.
---
 drivers/base/regmap/regmap.c |  101 +++++++++++++++++++++++++++++++++++++-----
 include/linux/regmap.h       |   25 ++++++++++
 2 files changed, 115 insertions(+), 11 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 0bcda48..1cf7214 100644
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
@@ -227,6 +249,7 @@ struct regmap *regmap_init(struct device *dev,
 {
 	struct regmap *map, **m;
 	int ret = -EINVAL;
+	enum regmap_endian reg_endian, val_endian;
 
 	if (!bus || !config)
 		goto err;
@@ -275,6 +298,18 @@ struct regmap *regmap_init(struct device *dev,
 		map->read_flag_mask = bus->read_flag_mask;
 	}
 
+	reg_endian = config->reg_format_endian;
+	if (reg_endian == REGMAP_ENDIAN_DEFAULT)
+		reg_endian = bus->reg_format_endian_default;
+	if (reg_endian == REGMAP_ENDIAN_DEFAULT)
+		reg_endian = REGMAP_ENDIAN_BIG;
+
+	val_endian = config->val_format_endian;
+	if (val_endian == REGMAP_ENDIAN_DEFAULT)
+		val_endian = bus->val_format_endian_default;
+	if (val_endian == REGMAP_ENDIAN_DEFAULT)
+		val_endian = REGMAP_ENDIAN_BIG;
+
 	switch (config->reg_bits + map->reg_shift) {
 	case 2:
 		switch (config->val_bits) {
@@ -321,11 +356,29 @@ struct regmap *regmap_init(struct device *dev,
 		break;
 
 	case 16:
-		map->format.format_reg = regmap_format_16;
+		switch (reg_endian) {
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
+		switch (reg_endian) {
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
@@ -338,21 +391,47 @@ struct regmap *regmap_init(struct device *dev,
 		map->format.parse_val = regmap_parse_8;
 		break;
 	case 16:
-		map->format.format_val = regmap_format_16;
-		map->format.parse_val = regmap_parse_16;
+		switch (val_endian) {
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
+		if (val_endian != REGMAP_ENDIAN_BIG)
+			goto err_map;
 		map->format.format_val = regmap_format_24;
 		map->format.parse_val = regmap_parse_24;
 		break;
 	case 32:
-		map->format.format_val = regmap_format_32;
-		map->format.parse_val = regmap_parse_32;
+		switch (val_endian) {
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
 
-	if (map->format.format_write)
+	if (map->format.format_write) {
+		if ((reg_endian != REGMAP_ENDIAN_BIG) ||
+		    (val_endian != REGMAP_ENDIAN_BIG))
+			goto err_map;
 		map->use_single_rw = true;
+	}
 
 	if (!map->format.format_write &&
 	    !(map->format.format_reg && map->format.format_val))
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 56af22e..26136b5 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -43,6 +43,14 @@ struct reg_default {
 
 #ifdef CONFIG_REGMAP
 
+enum regmap_endian {
+	/* Unspecified -> 0 -> Backwards compatible default */
+	REGMAP_ENDIAN_DEFAULT = 0,
+	REGMAP_ENDIAN_BIG,
+	REGMAP_ENDIAN_LITTLE,
+	REGMAP_ENDIAN_NATIVE,
+};
+
 /**
  * Configuration for the register map of a device.
  *
@@ -84,6 +92,12 @@ struct reg_default {
  * @reg_defaults_raw: Power on reset values for registers (for use with
  *                    register cache support).
  * @num_reg_defaults_raw: Number of elements in reg_defaults_raw.
+ * @reg_format_endian: Endianness for formatted register addresses. If this is
+ *                     DEFAULT, the @reg_format_endian_default value from the
+ *                     regmap bus is used.
+ * @val_format_endian: Endianness for formatted register values. If this is
+ *                     DEFAULT, the @reg_format_endian_default value from the
+ *                     regmap bus is used.
  */
 struct regmap_config {
 	const char *name;
@@ -109,6 +123,9 @@ struct regmap_config {
 	u8 write_flag_mask;
 
 	bool use_single_rw;
+
+	enum regmap_endian reg_format_endian;
+	enum regmap_endian val_format_endian;
 };
 
 typedef int (*regmap_hw_write)(void *context, const void *data,
@@ -133,6 +150,12 @@ typedef void (*regmap_hw_free_context)(void *context);
  *         data.
  * @read_flag_mask: Mask to be set in the top byte of the register when doing
  *                  a read.
+ * @reg_format_endian_default: Default endianness for formatted register
+ *     addresses. Used when the regmap_config specifies DEFAULT. If this is
+ *     DEFAULT, BIG is assumed.
+ * @val_format_endian_default: Default endianness for formatted register
+ *     values. Used when the regmap_config specifies DEFAULT. If this is
+ *     DEFAULT, BIG is assumed.
  */
 struct regmap_bus {
 	bool fast_io;
@@ -141,6 +164,8 @@ struct regmap_bus {
 	regmap_hw_read read;
 	regmap_hw_free_context free_context;
 	u8 read_flag_mask;
+	enum regmap_endian reg_format_endian_default;
+	enum regmap_endian val_format_endian_default;
 };
 
 struct regmap *regmap_init(struct device *dev,
-- 
1.7.0.4

