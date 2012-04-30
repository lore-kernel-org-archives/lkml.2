Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab2D3WvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:51:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48736 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756884Ab2D3WvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:51:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: wm8350: Convert to use core regmap vsel readback
Date: Mon, 30 Apr 2012 23:51:16 +0100
Message-Id: <1335826277-3094-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8350-regulator.c |   75 +++++++++-------------------------
 1 file changed, 19 insertions(+), 56 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 94e550d..5ccab37 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -405,34 +405,6 @@ static int wm8350_dcdc_set_voltage(struct regulator_dev *rdev, int min_uV,
 	return 0;
 }
 
-static int wm8350_dcdc_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
-	int volt_reg, dcdc = rdev_get_id(rdev);
-
-	switch (dcdc) {
-	case WM8350_DCDC_1:
-		volt_reg = WM8350_DCDC1_CONTROL;
-		break;
-	case WM8350_DCDC_3:
-		volt_reg = WM8350_DCDC3_CONTROL;
-		break;
-	case WM8350_DCDC_4:
-		volt_reg = WM8350_DCDC4_CONTROL;
-		break;
-	case WM8350_DCDC_6:
-		volt_reg = WM8350_DCDC6_CONTROL;
-		break;
-	case WM8350_DCDC_2:
-	case WM8350_DCDC_5:
-	default:
-		return -EINVAL;
-	}
-
-	/* all DCDCs have same mV bits */
-	return wm8350_reg_read(wm8350, volt_reg) & WM8350_DC1_VSEL_MASK;
-}
-
 static int wm8350_dcdc_list_voltage(struct regulator_dev *rdev,
 				    unsigned selector)
 {
@@ -805,32 +777,6 @@ static int wm8350_ldo_set_voltage(struct regulator_dev *rdev, int min_uV,
 	return 0;
 }
 
-static int wm8350_ldo_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
-	int volt_reg, ldo = rdev_get_id(rdev);
-
-	switch (ldo) {
-	case WM8350_LDO_1:
-		volt_reg = WM8350_LDO1_CONTROL;
-		break;
-	case WM8350_LDO_2:
-		volt_reg = WM8350_LDO2_CONTROL;
-		break;
-	case WM8350_LDO_3:
-		volt_reg = WM8350_LDO3_CONTROL;
-		break;
-	case WM8350_LDO_4:
-		volt_reg = WM8350_LDO4_CONTROL;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	/* all LDOs have same mV bits */
-	return wm8350_reg_read(wm8350, volt_reg) & WM8350_LDO1_VSEL_MASK;
-}
-
 static int wm8350_ldo_list_voltage(struct regulator_dev *rdev,
 				    unsigned selector)
 {
@@ -1225,7 +1171,7 @@ static int wm8350_ldo_is_enabled(struct regulator_dev *rdev)
 
 static struct regulator_ops wm8350_dcdc_ops = {
 	.set_voltage = wm8350_dcdc_set_voltage,
-	.get_voltage_sel = wm8350_dcdc_get_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.list_voltage = wm8350_dcdc_list_voltage,
 	.enable = wm8350_dcdc_enable,
 	.disable = wm8350_dcdc_disable,
@@ -1249,7 +1195,7 @@ static struct regulator_ops wm8350_dcdc2_5_ops = {
 
 static struct regulator_ops wm8350_ldo_ops = {
 	.set_voltage = wm8350_ldo_set_voltage,
-	.get_voltage_sel = wm8350_ldo_get_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.list_voltage = wm8350_ldo_list_voltage,
 	.enable = wm8350_ldo_enable,
 	.disable = wm8350_ldo_disable,
@@ -1277,6 +1223,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_DC1,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
+		.vsel_reg = WM8350_DCDC1_CONTROL,
+		.vsel_mask = WM8350_DC1_VSEL_MASK,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1294,6 +1242,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_DC3,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
+		.vsel_reg = WM8350_DCDC3_CONTROL,
+		.vsel_mask = WM8350_DC3_VSEL_MASK,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1303,6 +1253,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_DC4,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
+		.vsel_reg = WM8350_DCDC4_CONTROL,
+		.vsel_mask = WM8350_DC4_VSEL_MASK,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1320,6 +1272,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_DC6,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
+		.vsel_reg = WM8350_DCDC6_CONTROL,
+		.vsel_mask = WM8350_DC6_VSEL_MASK,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1329,6 +1283,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_LDO1,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_LDO1_VSEL_MASK + 1,
+		.vsel_reg = WM8350_LDO1_CONTROL,
+		.vsel_mask = WM8350_LDO1_VSEL_MASK,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1338,6 +1294,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_LDO2,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_LDO2_VSEL_MASK + 1,
+		.vsel_reg = WM8350_LDO2_CONTROL,
+		.vsel_mask = WM8350_LDO2_VSEL_MASK,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1347,6 +1305,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_LDO3,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_LDO3_VSEL_MASK + 1,
+		.vsel_reg = WM8350_LDO3_CONTROL,
+		.vsel_mask = WM8350_LDO3_VSEL_MASK,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1356,6 +1316,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_LDO4,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_LDO4_VSEL_MASK + 1,
+		.vsel_reg = WM8350_LDO4_CONTROL,
+		.vsel_mask = WM8350_LDO4_VSEL_MASK,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1429,6 +1391,7 @@ static int wm8350_regulator_probe(struct platform_device *pdev)
 	config.dev = &pdev->dev;
 	config.init_data = pdev->dev.platform_data;
 	config.driver_data = dev_get_drvdata(&pdev->dev);
+	config.regmap = wm8350->regmap;
 
 	/* register regulator */
 	rdev = regulator_register(&wm8350_reg[pdev->id], &config);
-- 
1.7.10

