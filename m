Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062Ab2BJNJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:09:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19934 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758694Ab2BJNJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:09:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 10 Feb 2012 05:09:06 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org,
        lars@metafoo.de, linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V2] regmap: add regmap_bulk_write() for register write
Date: Fri, 10 Feb 2012 18:37:18 +0530
Message-Id: <1328879238-9290-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bulk_write() supports the data transfer to multi
register which takes the data into cpu_endianness format
and does formatting of data to device format before
sending to device.
The transfer can be completed in single transfer or multiple
transfer based on data formatting.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Change commit message.
- Byte swapping in input data packet.
 drivers/base/regmap/regmap.c |   53 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h       |    2 +
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index b4f4455..875e381 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -482,6 +482,59 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 }
 EXPORT_SYMBOL_GPL(regmap_raw_write);
 
+/*
+ * regmap_bulk_write(): Write multiple registers to the device
+ *
+ * @map: Register map to write to
+ * @reg: First register to be write from
+ * @val: Block of data to be written, in native register size for device
+ * @val_count: Number of registers to write
+ *
+ * This function is intended to be used for writing a large block of
+ * data to be device either in single transfer or multiple transfer.
+ *
+ * A value of zero will be returned on success, a negative errno will
+ * be returned in error cases.
+ */
+int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
+		     size_t val_count)
+{
+	int ret = 0, i;
+	unsigned int ival;
+	size_t val_bytes = map->format.val_bytes;
+
+	mutex_lock(&map->lock);
+
+	if (map->format.parse_val) {
+		void *wptr = kmemdup(val, val_count, GFP_KERNEL);
+		if (!wptr) {
+			mutex_unlock(&map->lock);
+			dev_err(map->dev, "Error in memory allocation\n");
+			return -ENOMEM;
+		}
+		for (i = 0; i < val_count * val_bytes; i += val_bytes)
+			map->format.parse_val(wptr + i);
+		ret = _regmap_raw_write(map, reg, wptr, val_bytes * val_count);
+
+		kfree(wptr);
+	} else {
+		for (i = 0; i < val_count; i++) {
+			memcpy(&ival, val + (i * val_bytes), val_bytes);
+			ret = _regmap_write(map, reg + i, ival);
+			if (ret) {
+				dev_err(map->dev,
+				    "Error in register %u write, ret %d\n",
+						reg + i, ret);
+				break;
+			}
+		}
+	}
+
+	mutex_unlock(&map->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regmap_bulk_write);
+
 static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 			    unsigned int val_len)
 {
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a6ed6e6..0925e24 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -135,6 +135,8 @@ int regmap_reinit_cache(struct regmap *map,
 int regmap_write(struct regmap *map, unsigned int reg, unsigned int val);
 int regmap_raw_write(struct regmap *map, unsigned int reg,
 		     const void *val, size_t val_len);
+int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
+			size_t val_count);
 int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val);
 int regmap_raw_read(struct regmap *map, unsigned int reg,
 		    void *val, size_t val_len);
-- 
1.7.1.1

