Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab2ASLxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 06:53:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50721 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432Ab2ASLxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 06:53:16 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Add support for padding between register and address
Date: Thu, 19 Jan 2012 11:53:13 +0000
Message-Id: <1326973993-26179-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices, especially those with high speed control interfaces, require
padding between the register and the data. Support this in the regmap API
by providing a pad_bits configuration parameter.

Only devices with integer byte counts are supported.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h |    1 +
 drivers/base/regmap/regmap.c   |   32 +++++++++++++++++++++-----------
 include/linux/regmap.h         |    2 ++
 3 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 1a02b75..e33f1be 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -22,6 +22,7 @@ struct regcache_ops;
 struct regmap_format {
 	size_t buf_size;
 	size_t reg_bytes;
+	size_t pad_bytes;
 	size_t val_bytes;
 	void (*format_write)(struct regmap *map,
 			     unsigned int reg, unsigned int val);
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index be10a4f..e9c2ac0 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -160,7 +160,9 @@ struct regmap *regmap_init(struct device *dev,
 	mutex_init(&map->lock);
 	map->format.buf_size = (config->reg_bits + config->val_bits) / 8;
 	map->format.reg_bytes = config->reg_bits / 8;
+	map->format.pad_bytes = config->pad_bits / 8;
 	map->format.val_bytes = config->val_bits / 8;
+	map->format.buf_size += map->format.pad_bytes;
 	map->dev = dev;
 	map->bus = bus;
 	map->max_register = config->max_register;
@@ -235,7 +237,7 @@ struct regmap *regmap_init(struct device *dev,
 	    !(map->format.format_reg && map->format.format_val))
 		goto err_map;
 
-	map->work_buf = kmalloc(map->format.buf_size, GFP_KERNEL);
+	map->work_buf = kzalloc(map->format.buf_size, GFP_KERNEL);
 	if (map->work_buf == NULL) {
 		ret = -ENOMEM;
 		goto err_map;
@@ -329,23 +331,28 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	 * send the work_buf directly, otherwise try to do a gather
 	 * write.
 	 */
-	if (val == map->work_buf + map->format.reg_bytes)
+	if (val == (map->work_buf + map->format.pad_bytes +
+		    map->format.reg_bytes))
 		ret = map->bus->write(map->dev, map->work_buf,
-				      map->format.reg_bytes + val_len);
+				      map->format.reg_bytes +
+				      map->format.pad_bytes +
+				      val_len);
 	else if (map->bus->gather_write)
 		ret = map->bus->gather_write(map->dev, map->work_buf,
-					     map->format.reg_bytes,
+					     map->format.reg_bytes +
+					     map->format.pad_bytes,
 					     val, val_len);
 
 	/* If that didn't work fall back on linearising by hand. */
 	if (ret == -ENOTSUPP) {
-		len = map->format.reg_bytes + val_len;
-		buf = kmalloc(len, GFP_KERNEL);
+		len = map->format.reg_bytes + map->format.pad_bytes + val_len;
+		buf = kzalloc(len, GFP_KERNEL);
 		if (!buf)
 			return -ENOMEM;
 
 		memcpy(buf, map->work_buf, map->format.reg_bytes);
-		memcpy(buf + map->format.reg_bytes, val, val_len);
+		memcpy(buf + map->format.reg_bytes + map->format.pad_bytes,
+		       val, val_len);
 		ret = map->bus->write(map->dev, buf, len);
 
 		kfree(buf);
@@ -387,10 +394,12 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 
 		return ret;
 	} else {
-		map->format.format_val(map->work_buf + map->format.reg_bytes,
-				       val);
+		map->format.format_val(map->work_buf + map->format.reg_bytes
+				       + map->format.pad_bytes, val);
 		return _regmap_raw_write(map, reg,
-					 map->work_buf + map->format.reg_bytes,
+					 map->work_buf +
+					 map->format.reg_bytes +
+					 map->format.pad_bytes,
 					 map->format.val_bytes);
 	}
 }
@@ -473,7 +482,8 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	trace_regmap_hw_read_start(map->dev, reg,
 				   val_len / map->format.val_bytes);
 
-	ret = map->bus->read(map->dev, map->work_buf, map->format.reg_bytes,
+	ret = map->bus->read(map->dev, map->work_buf,
+			     map->format.reg_bytes + map->format.pad_bytes,
 			     val, val_len);
 
 	trace_regmap_hw_read_done(map->dev, reg,
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index eb93921..a6ed6e6 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -44,6 +44,7 @@ struct reg_default {
  * Configuration for the register map of a device.
  *
  * @reg_bits: Number of bits in a register address, mandatory.
+ * @pad_bits: Number of bits of padding between register and value.
  * @val_bits: Number of bits in a register value, mandatory.
  *
  * @writeable_reg: Optional callback returning true if the register
@@ -74,6 +75,7 @@ struct reg_default {
  */
 struct regmap_config {
 	int reg_bits;
+	int pad_bits;
 	int val_bits;
 
 	bool (*writeable_reg)(struct device *dev, unsigned int reg);
-- 
1.7.7.3

