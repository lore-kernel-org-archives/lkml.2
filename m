Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab2D3Giz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 02:38:55 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:28354
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619Ab2D3Gix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 02:38:53 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz2dh2a8h668h839h93fhd24hd2bhbe9i)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [PATCH] Regmap: Converts group operation into single read write
 operations
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: <linux-kernel@vger.kernel.org>
CC: <broonie@opensource.wolfsonmicro.com>, <Anthony.Olech@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Apr 2012 12:05:46 +0530
Message-ID: <1335767746.9546.15.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices does not support bulk read and write operations, for them
we have series of single write and read operations.

Signed-off-by: Anthony Olech <Anthony.Olech@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/base/regmap/internal.h |    3 +++
 drivers/base/regmap/regmap.c   |   40 ++++++++++++++++++++++++++++++++++++----
 include/linux/regmap.h         |    5 +++++
 3 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index d92e9b1..2eb7197 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -91,6 +91,9 @@ struct regmap {
 
 	struct reg_default *patch;
 	int patch_regs;
+
+	/* if set, converts bulk rw to single rw */
+	bool use_single_rw;
 };
 
 struct regcache_ops {
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 8a25006..a9a2c27 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -247,6 +247,8 @@ struct regmap *regmap_init(struct device *dev,
 		map->reg_stride = config->reg_stride;
 	else
 		map->reg_stride = 1;
+	if (config->use_single_rw)
+		map->use_single_rw = config->use_single_rw;
 	map->dev = dev;
 	map->bus = bus;
 	map->bus_context = bus_context;
@@ -686,7 +688,21 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 		for (i = 0; i < val_count * val_bytes; i += val_bytes)
 			map->format.parse_val(wval + i);
 	}
-	ret = _regmap_raw_write(map, reg, wval, val_bytes * val_count);
+	/*
+	 * Some devices does not support bulk write, for
+	 * them we have a series of single write operations.
+	 */
+	if (map->use_single_rw) {
+		for (i = 0; i < val_count; i++) {
+			ret = regmap_raw_write(map,
+						reg + (i * map->reg_stride),
+						val + (i * val_bytes),
+						val_bytes);
+			if (ret != 0)
+				return ret;
+		}
+	} else
+		ret = _regmap_raw_write(map, reg, wval, val_bytes * val_count);
 
 	if (val_bytes != 1)
 		kfree(wval);
@@ -855,9 +871,25 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 		return -EINVAL;
 
 	if (vol || map->cache_type == REGCACHE_NONE) {
-		ret = regmap_raw_read(map, reg, val, val_bytes * val_count);
-		if (ret != 0)
-			return ret;
+		/*
+		 * Some devices does not support bulk read, for
+		 * them we have a series of single read operations.
+		 */
+		if (map->use_single_rw) {
+			for (i = 0; i < val_count; i++) {
+				ret = regmap_raw_read(map,
+						reg + (i * map->reg_stride),
+						val + (i * val_bytes),
+						val_bytes);
+				if (ret != 0)
+					return ret;
+			}
+		} else {
+			ret = regmap_raw_read(map, reg, val,
+					      val_bytes * val_count);
+			if (ret != 0)
+				return ret;
+		}
 
 		for (i = 0; i < val_count * val_bytes; i += val_bytes)
 			map->format.parse_val(val + i);
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 0258bcd..ae797b1 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -76,6 +76,9 @@ struct reg_default {
  * @write_flag_mask: Mask to be set in the top byte of the register when doing
  *                   a write. If both read_flag_mask and write_flag_mask are
  *                   empty the regmap_bus default masks are used.
+ * @use_single_rw: If set, converts the bulk read and write operations into
+ *		    a series of single read and write operations. This is useful
+ *		    for device that does not support bulk read and write.
  *
  * @cache_type: The actual cache type.
  * @reg_defaults_raw: Power on reset values for registers (for use with
@@ -104,6 +107,8 @@ struct regmap_config {
 
 	u8 read_flag_mask;
 	u8 write_flag_mask;
+
+	bool use_single_rw;
 };
 
 typedef int (*regmap_hw_write)(void *context, const void *data,


