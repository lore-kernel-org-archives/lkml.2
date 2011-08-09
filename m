Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1HIKr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 06:47:59 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13857 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1HIKr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 06:47:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 09 Aug 2011 03:47:57 -0700
From: dahuang@nvidia.com
To: broonie@opensource.wolfsonmicro.com, lrg@ti.com, mike@compulab.co.il,
        sameo@linux.intel.com, xxie@nvidia.com
Cc: linux-kernel@vger.kernel.org, Danny Huang <dahuang@nvidia.com>
Subject: [PATCH] regulator: tps6586x: add SMx slew rate setting
Date: Tue,  9 Aug 2011 18:47:50 +0800
Message-Id: <1312886870-17451-1-git-send-email-dahuang@nvidia.com>
X-Mailer: git-send-email 1.7.6
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xie <xxie@nvidia.com>

Add output vlotage slew rate setting for SM0/SM1

Signed-off-by: Xin Xie <xxie@nvidia.com>
Signed-off-by: Danny Huang <dahuang@nvidia.com>
---
 drivers/regulator/tps6586x-regulator.c |   32 +++++++++++++++++++++++++++++++-
 include/linux/mfd/tps6586x.h           |   16 ++++++++++++++++
 2 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index bb04a75..dbcf09d 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -332,6 +332,36 @@ static inline int tps6586x_regulator_preinit(struct device *parent,
 				 1 << ri->enable_bit[1]);
 }
 
+static int tps6586x_regulator_set_slew_rate(struct platform_device *pdev)
+{
+	struct device *parent = pdev->dev.parent;
+	struct regulator_init_data *p = pdev->dev.platform_data;
+	struct tps6586x_settings *setting = p->driver_data;
+	uint8_t reg;
+
+	if (setting == NULL)
+		return 0;
+
+	if (!(setting->slew_rate & TPS6586X_SLEW_RATE_SET))
+		return 0;
+
+	/* only SM0 and SM1 can have the slew rate settings */
+	switch (pdev->id) {
+	case TPS6586X_ID_SM_0:
+		reg = TPS6586X_SM0SL;
+		break;
+	case TPS6586X_ID_SM_1:
+		reg = TPS6586X_SM1SL;
+		break;
+	default:
+		dev_warn(&pdev->dev, "Only SM0/SM1 can set slew rate\n");
+		return -EINVAL;
+	}
+
+	return tps6586x_write(parent, reg,
+			setting->slew_rate & TPS6586X_SLEW_RATE_MASK);
+}
+
 static inline struct tps6586x_regulator *find_regulator_info(int id)
 {
 	struct tps6586x_regulator *ri;
@@ -374,7 +404,7 @@ static int __devinit tps6586x_regulator_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rdev);
 
-	return 0;
+	return tps6586x_regulator_set_slew_rate(pdev);
 }
 
 static int __devexit tps6586x_regulator_remove(struct platform_device *pdev)
diff --git a/include/linux/mfd/tps6586x.h b/include/linux/mfd/tps6586x.h
index b6bab1b..b19176e 100644
--- a/include/linux/mfd/tps6586x.h
+++ b/include/linux/mfd/tps6586x.h
@@ -1,6 +1,18 @@
 #ifndef __LINUX_MFD_TPS6586X_H
 #define __LINUX_MFD_TPS6586X_H
 
+#define TPS6586X_SLEW_RATE_INSTANTLY	0x00
+#define TPS6586X_SLEW_RATE_110UV	0x01
+#define TPS6586X_SLEW_RATE_220UV	0x02
+#define TPS6586X_SLEW_RATE_440UV	0x03
+#define TPS6586X_SLEW_RATE_880UV	0x04
+#define TPS6586X_SLEW_RATE_1760UV	0x05
+#define TPS6586X_SLEW_RATE_3520UV	0x06
+#define TPS6586X_SLEW_RATE_7040UV	0x07
+
+#define TPS6586X_SLEW_RATE_SET		0x08
+#define TPS6586X_SLEW_RATE_MASK         0x07
+
 enum {
 	TPS6586X_ID_SM_0,
 	TPS6586X_ID_SM_1,
@@ -48,6 +60,10 @@ enum {
 	TPS6586X_INT_RTC_ALM2,
 };
 
+struct tps6586x_settings {
+	int slew_rate;
+};
+
 struct tps6586x_subdev_info {
 	int		id;
 	const char	*name;
-- 
1.7.6

