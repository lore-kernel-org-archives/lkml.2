Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357Ab2EIXtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:49:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56975 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761273Ab2EIXrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:47:55 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Yadwinder Singh <yadi.brar@samsung.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/6] regulator: wm8350: Convert DCDCs to set_voltage_sel() and linear voltages
Date: Thu, 10 May 2012 00:47:32 +0100
Message-Id: <1336607255-4967-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336607255-4967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336607255-4967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8350 DCDCs have a simple linear mapping from selectors to voltages
so can be converted very simply to use the new infrastructure for a nice
reduction in code size.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8350-regulator.c |   64 +++++-----------------------------
 1 file changed, 8 insertions(+), 56 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 12ecaec..a618284 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -359,60 +359,6 @@ int wm8350_isink_set_flash(struct wm8350 *wm8350, int isink, u16 mode,
 }
 EXPORT_SYMBOL_GPL(wm8350_isink_set_flash);
 
-static int wm8350_dcdc_set_voltage(struct regulator_dev *rdev, int min_uV,
-				   int max_uV, unsigned *selector)
-{
-	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
-	int volt_reg, dcdc = rdev_get_id(rdev), mV,
-		min_mV = min_uV / 1000, max_mV = max_uV / 1000;
-	u16 val;
-
-	if (min_mV < 850 || min_mV > 4025)
-		return -EINVAL;
-	if (max_mV < 850 || max_mV > 4025)
-		return -EINVAL;
-
-	/* step size is 25mV */
-	mV = (min_mV - 826) / 25;
-	if (wm8350_dcdc_val_to_mvolts(mV) > max_mV)
-		return -EINVAL;
-	BUG_ON(wm8350_dcdc_val_to_mvolts(mV) < min_mV);
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
-	*selector = mV;
-
-	/* all DCDCs have same mV bits */
-	val = wm8350_reg_read(wm8350, volt_reg) & ~WM8350_DC1_VSEL_MASK;
-	wm8350_reg_write(wm8350, volt_reg, val | mV);
-	return 0;
-}
-
-static int wm8350_dcdc_list_voltage(struct regulator_dev *rdev,
-				    unsigned selector)
-{
-	if (selector > WM8350_DCDC_MAX_VSEL)
-		return -EINVAL;
-	return wm8350_dcdc_val_to_mvolts(selector) * 1000;
-}
-
 static int wm8350_dcdc_set_suspend_voltage(struct regulator_dev *rdev, int uV)
 {
 	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
@@ -1087,9 +1033,9 @@ static unsigned int wm8350_dcdc_get_optimum_mode(struct regulator_dev *rdev,
 }
 
 static struct regulator_ops wm8350_dcdc_ops = {
-	.set_voltage = wm8350_dcdc_set_voltage,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
-	.list_voltage = wm8350_dcdc_list_voltage,
+	.list_voltage = regulator_list_voltage_linear,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
 	.is_enabled = regulator_is_enabled_regmap,
@@ -1140,6 +1086,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_DC1,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
+		.min_uV = 850000,
+		.uV_step = 25000,
 		.vsel_reg = WM8350_DCDC1_CONTROL,
 		.vsel_mask = WM8350_DC1_VSEL_MASK,
 		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
@@ -1163,6 +1111,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_DC3,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
+		.min_uV = 850000,
+		.uV_step = 25000,
 		.vsel_reg = WM8350_DCDC3_CONTROL,
 		.vsel_mask = WM8350_DC3_VSEL_MASK,
 		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
@@ -1199,6 +1149,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_DC6,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
+		.min_uV = 850000,
+		.uV_step = 25000,
 		.vsel_reg = WM8350_DCDC6_CONTROL,
 		.vsel_mask = WM8350_DC6_VSEL_MASK,
 		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
-- 
1.7.10

