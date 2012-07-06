Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2GFNOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:14:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35527 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924Ab2GFNOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:14:08 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Add hook for printk logging for debugging during early init
Date: Fri,  6 Jul 2012 14:14:05 +0100
Message-Id: <1341580445-29426-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes for failures during very early init the trace infrastructure
isn't available early enough to be used.  For this sort of problem
defining LOG_DEVICE will add printks for basic register I/O on a specific
device, allowing trace to be extracted when the trace system doesn't come
up early enough to work with.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 13fc70b..c241ae2 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -22,6 +22,14 @@
 
 #include "internal.h"
 
+/*
+ * Sometimes for failures during very early init the trace
+ * infrastructure isn't available early enough to be used.  For this
+ * sort of problem defining LOG_DEVICE will add printks for basic
+ * register I/O on a specific device.
+ */
+#undef LOG_DEVICE
+
 static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 			       unsigned int mask, unsigned int val,
 			       bool *change);
@@ -886,6 +894,11 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 		}
 	}
 
+#ifdef LOG_DEVICE
+	if (strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
+		dev_info(map->dev, "%x <= %x\n", reg, val);
+#endif
+
 	trace_regmap_reg_write(map->dev, reg, val);
 
 	if (map->format.format_write) {
@@ -1097,6 +1110,12 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 	ret = _regmap_raw_read(map, reg, map->work_buf, map->format.val_bytes);
 	if (ret == 0) {
 		*val = map->format.parse_val(map->work_buf);
+
+#ifdef LOG_DEVICE
+		if (strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
+			dev_info(map->dev, "%x => %x\n", reg, *val);
+#endif
+
 		trace_regmap_reg_read(map->dev, reg, *val);
 	}
 
-- 
1.7.10

