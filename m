Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1HDLgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:36:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17827 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab1HDLgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:36:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 04 Aug 2011 04:36:04 -0700
From: dahuang@nvidia.com
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com, mike@compulab.co.il,
        sameo@linux.intel.com, xxie@nvidia.com, gking@nvidia.com
Cc: linux-kernel@vger.kernel.org, Danny Huang <dahuang@nvidia.com>
Subject: [PATCH] regulator: tps6586x: add SMx slew rate setting
Date: Thu,  4 Aug 2011 19:34:22 +0800
Message-Id: <1312457662-4490-1-git-send-email-dahuang@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Huang <dahuang@nvidia.com>

Add output vlotage slew rate setting for SM0/SM1

From: Xin Xie <xxie@nvidia.com>

Signed-off-by: Xin Xie <xxie@nvidia.com>
Signed-off-by: Danny Huang <dahuang@nvidia.com>
---
 drivers/regulator/tps6586x-regulator.c |   27 ++++++++++++++++++++++++++-
 include/linux/mfd/tps6586x.h           |   15 +++++++++++++++
 2 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index bb04a75..9e5b459 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -332,6 +332,31 @@ static inline int tps6586x_regulator_preinit(struct device *parent,
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
+	/* only SM0 and SM1 can have the slew rate settings */
+	switch (pdev->id) {
+	case TPS6586X_ID_SM_0:
+		reg = TPS6586X_SM0SL;
+		break;
+	case TPS6586X_ID_SM_1:
+		reg = TPS6586X_SM1SL;
+		break;
+	default:
+		dev_err(&pdev->dev, "invalid regulator ID\n");
+		return -EINVAL;
+	}
+	return tps6586x_write(parent, reg, setting->slew_rate);
+}
+
 static inline struct tps6586x_regulator *find_regulator_info(int id)
 {
 	struct tps6586x_regulator *ri;
@@ -374,7 +399,7 @@ static int __devinit tps6586x_regulator_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rdev);
 
-	return 0;
+	return tps6586x_regulator_set_slew_rate(pdev);
 }
 
 static int __devexit tps6586x_regulator_remove(struct platform_device *pdev)
diff --git a/include/linux/mfd/tps6586x.h b/include/linux/mfd/tps6586x.h
index b6bab1b..9dfb2bb 100644
--- a/include/linux/mfd/tps6586x.h
+++ b/include/linux/mfd/tps6586x.h
@@ -48,6 +48,21 @@ enum {
 	TPS6586X_INT_RTC_ALM2,
 };
 
+enum {
+	TPS6586x_SLEW_RATE_INSTANTLY,
+	TPS6586x_SLEW_RATE_110UV,
+	TPS6586x_SLEW_RATE_220UV,
+	TPS6586x_SLEW_RATE_440UV,
+	TPS6586x_SLEW_RATE_880UV,
+	TPS6586x_SLEW_RATE_1760UV,
+	TPS6586x_SLEW_RATE_3520UV,
+	TPS6586x_SLEW_RATE_7040UV,
+};
+
+struct tps6586x_settings {
+	int slew_rate;
+};
+
 struct tps6586x_subdev_info {
 	int		id;
 	const char	*name;
-- 
1.7.0.4

