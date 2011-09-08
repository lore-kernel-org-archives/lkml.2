Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab1IHOBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:01:16 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:50799 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900Ab1IHOBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:01:13 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 1/2] regmap: Support half writes and padding between register and value.
Date: Thu,  8 Sep 2011 15:09:23 +0100
Message-Id: <1315490964-25718-2-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1315490964-25718-1-git-send-email-jic23@cam.ac.uk>
References: <1315490964-25718-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note half writes currently assume address numbers are even only.
That's a pain for caching so other suggestions welcome.  I could set
it as a 7 bit address and increase the padding to 9 bits.  That makes
the write bit a little strange though as it will be going into the
padding.

Not signed off by Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/base/regmap/internal.h |    1 +
 drivers/base/regmap/regmap.c   |   42 ++++++++++++++++++++++++++++++++++-----
 include/linux/regmap.h         |    6 +++++
 3 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 7e14d5a..a6fb2f4 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -22,6 +22,7 @@ struct regmap_format {
 	size_t buf_size;
 	size_t reg_bytes;
 	size_t val_bytes;
+	bool half_write;
 	void (*format_write)(struct regmap *map,
 			     unsigned int reg, unsigned int val);
 	void (*format_reg)(void *buf, unsigned int reg);
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e7adfe7..41f1e7f 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -71,6 +71,16 @@ static void regmap_format_4_12_write(struct regmap *map,
 	*out = cpu_to_be16((reg << 12) | val);
 }
 
+static void regmap_format_8_16_half_write(struct regmap *map,
+					 unsigned int reg, unsigned int val)
+{
+	u8 *out8 = map->work_buf;
+	out8[0] = reg | map->write_flag_mask;; 
+	out8[1] = val;
+	out8[2] = (reg + 1) | map->write_flag_mask;
+	out8[3] = val >> 8;
+}
+
 static void regmap_format_7_9_write(struct regmap *map,
 				    unsigned int reg, unsigned int val)
 {
@@ -136,9 +146,12 @@ struct regmap *regmap_init(struct device *dev,
 	}
 
 	mutex_init(&map->lock);
-	map->format.buf_size = (config->reg_bits + config->val_bits) / 8;
-	map->format.reg_bytes = config->reg_bits / 8;
+	map->format.buf_size = (config->reg_bits +
+				config->reg_pad_bits +
+				config->val_bits) / 8;
+	map->format.reg_bytes = (config->reg_bits + config->reg_pad_bits)/ 8;
 	map->format.val_bytes = config->val_bits / 8;
+	map->format.half_write = config->half_write;
 	map->dev = dev;
 	map->bus = bus;
 	map->max_register = config->max_register;
@@ -176,6 +189,9 @@ struct regmap *regmap_init(struct device *dev,
 		break;
 
 	case 8:
+		if (map->format.half_write)
+			map->format.format_write =
+				regmap_format_8_16_half_write;
 		map->format.format_reg = regmap_format_8;
 		break;
 
@@ -256,13 +272,27 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	 * send the work_buf directly, otherwise try to do a gather
 	 * write.
 	 */
-	if (val == map->work_buf + map->format.reg_bytes)
-		ret = map->bus->write(map->dev, map->work_buf,
-				      map->format.reg_bytes + val_len);
-	else if (map->bus->gather_write)
+	if (val == map->work_buf + map->format.reg_bytes) {
+		if (map->format.half_write) {
+			ret = map->bus->write(map->dev, map->work_buf,
+					      (map->format.reg_bytes +
+					       val_len) >> 1);
+			if (ret >= 0)
+				ret = map->bus->write(map->dev,
+						      map->work_buf +
+						      ((map->format.reg_bytes +
+							val_len) >> 1),
+						      (map->format.reg_bytes +
+						       val_len) >> 1);
+		} else {
+			ret = map->bus->write(map->dev, map->work_buf,
+					      map->format.reg_bytes + val_len);
+		}
+	} else if (map->bus->gather_write) {
 		ret = map->bus->gather_write(map->dev, map->work_buf,
 					     map->format.reg_bytes,
 					     val, val_len);
+	}
 
 	/* If that didn't work fall back on linearising by hand. */
 	if (ret == -ENOTSUPP) {
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 18d4afa..564d703 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -37,6 +37,8 @@ struct reg_default {
  * Configuration for the register map of a device.
  *
  * @reg_bits: Number of bits in a register address, mandatory.
+ * @reg_pad_bits: Number of bits of padding between register
+ *                address and start of value.
  * @val_bits: Number of bits in a register value, mandatory.
  *
  * @writeable_reg: Optional callback returning true if the register
@@ -59,9 +61,12 @@ struct reg_default {
  * @write_flag_mask: Mask to be set in the top byte of the register when doing
  *                   a write. If both read_flag_mask and write_flag_mask are
  *                   empty the regmap_bus default masks are used.
+ * @half_write: Flag to indicate that writes are done in two parts, half of
+ *              the register in each.
  */
 struct regmap_config {
 	int reg_bits;
+	int reg_pad_bits;
 	int val_bits;
 
 	bool (*writeable_reg)(struct device *dev, unsigned int reg);
@@ -75,6 +80,7 @@ struct regmap_config {
 
 	u8 read_flag_mask;
 	u8 write_flag_mask;
+	bool half_write;
 };
 
 typedef int (*regmap_hw_write)(struct device *dev, const void *data,
-- 
1.7.3.4

