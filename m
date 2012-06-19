Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab2FSHyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 03:54:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57872 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab2FSHyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 03:54:20 -0400
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>, Axel Lin <axel.lin@gmail.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 2/2] regulator: max77686: Implement .set_ramp_delay() callback.
Date: Tue, 19 Jun 2012 13:23:43 +0530
Message-Id: <1340092423-10073-2-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340092423-10073-1-git-send-email-yadi.brar@samsung.com>
References: <1340092423-10073-1-git-send-email-yadi.brar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the .set_ramp_delay callback to set the ramp_delay on
hardware for BUCK2/3/4 if ramp_delay is set in regulator constraints.

This patch also do some cleaning work for unrequired members of
struct max77686_data.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/max77686.c |   38 ++++++++++++++++++++++++++++++--------
 1 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index a29eee3..535eb1f 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -65,11 +65,35 @@ enum max77686_ramp_rate {
 };
 
 struct max77686_data {
-	struct device *dev;
-	struct max77686_dev *iodev;
 	struct regulator_dev **rdev;
 };
 
+static int max77686_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
+{
+	unsigned int ramp_value = RAMP_RATE_NO_CTRL;
+
+	switch (ramp_delay) {
+	case 1 ... 13750:
+		ramp_value = RAMP_RATE_13P75MV;
+		break;
+	case 13751 ... 27500:
+		ramp_value = RAMP_RATE_27P5MV;
+		break;
+	case 27501 ... 55000:
+		ramp_value = RAMP_RATE_55MV;
+		break;
+	case 55001 ... 100000:
+		break;
+	default:
+		pr_warn("%s: ramp_delay: %d not supported, setting 100000\n",
+			rdev->desc->name, ramp_delay);
+	}
+
+	return regmap_update_bits(rdev->regmap, MAX77686_REG_BUCK2CTRL1 +
+				  (rdev->desc->id - MAX77686_BUCK2) * 10,
+				  MAX77686_RAMP_RATE_MASK, ramp_value << 6);
+}
+
 static struct regulator_ops max77686_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
 	.map_voltage		= regulator_map_voltage_linear,
@@ -90,6 +114,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+	.set_ramp_delay		= max77686_set_ramp_delay,
 };
 
 #define regulator_desc_ldo(num)		{				\
@@ -238,20 +263,17 @@ static __devinit int max77686_pmic_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	rdev = max77686->rdev;
-	max77686->dev = &pdev->dev;
-	max77686->iodev = iodev;
+	config.dev = &pdev->dev;
+	config.regmap = iodev->regmap;
 	platform_set_drvdata(pdev, max77686);
 
 	for (i = 0; i < MAX77686_REGULATORS; i++) {
-		config.dev = max77686->dev;
-		config.regmap = iodev->regmap;
-		config.driver_data = max77686;
 		config.init_data = pdata->regulators[i].initdata;
 
 		rdev[i] = regulator_register(&regulators[i], &config);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
-			dev_err(max77686->dev,
+			dev_err(&pdev->dev,
 				"regulator init failed for %d\n", i);
 				rdev[i] = NULL;
 				goto err;
-- 
1.7.0.4

