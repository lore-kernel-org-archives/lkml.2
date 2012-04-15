Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2DOLuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 07:50:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44650 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754270Ab2DOLto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 07:49:44 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 7/8] regulator: wm831x-dcdc: Use generic regmap enable/disable operations
Date: Sun, 15 Apr 2012 12:49:24 +0100
Message-Id: <1334490565-19808-7-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c |   70 +++++++++++++--------------------------
 1 files changed, 23 insertions(+), 47 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index d57cc74..f2ab926 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -61,41 +61,6 @@ struct wm831x_dcdc {
 	int dvs_vsel;
 };
 
-static int wm831x_dcdc_is_enabled(struct regulator_dev *rdev)
-{
-	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
-	struct wm831x *wm831x = dcdc->wm831x;
-	int mask = 1 << rdev_get_id(rdev);
-	int reg;
-
-	reg = wm831x_reg_read(wm831x, WM831X_DCDC_ENABLE);
-	if (reg < 0)
-		return reg;
-
-	if (reg & mask)
-		return 1;
-	else
-		return 0;
-}
-
-static int wm831x_dcdc_enable(struct regulator_dev *rdev)
-{
-	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
-	struct wm831x *wm831x = dcdc->wm831x;
-	int mask = 1 << rdev_get_id(rdev);
-
-	return wm831x_set_bits(wm831x, WM831X_DCDC_ENABLE, mask, mask);
-}
-
-static int wm831x_dcdc_disable(struct regulator_dev *rdev)
-{
-	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
-	struct wm831x *wm831x = dcdc->wm831x;
-	int mask = 1 << rdev_get_id(rdev);
-
-	return wm831x_set_bits(wm831x, WM831X_DCDC_ENABLE, mask, 0);
-}
-
 static unsigned int wm831x_dcdc_get_mode(struct regulator_dev *rdev)
 
 {
@@ -415,9 +380,9 @@ static struct regulator_ops wm831x_buckv_ops = {
 	.set_current_limit = wm831x_buckv_set_current_limit,
 	.get_current_limit = wm831x_buckv_get_current_limit,
 
-	.is_enabled = wm831x_dcdc_is_enabled,
-	.enable = wm831x_dcdc_enable,
-	.disable = wm831x_dcdc_disable,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
 	.get_status = wm831x_dcdc_get_status,
 	.get_mode = wm831x_dcdc_get_mode,
 	.set_mode = wm831x_dcdc_set_mode,
@@ -545,6 +510,8 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 	dcdc->desc.n_voltages = WM831X_BUCKV_MAX_SELECTOR + 1;
 	dcdc->desc.ops = &wm831x_buckv_ops;
 	dcdc->desc.owner = THIS_MODULE;
+	dcdc->desc.enable_reg = WM831X_DCDC_ENABLE;
+	dcdc->desc.enable_mask = 1 << id;
 
 	ret = wm831x_reg_read(wm831x, dcdc->base + WM831X_DCDC_ON_CONFIG);
 	if (ret < 0) {
@@ -566,6 +533,7 @@ static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
 	config.dev = pdev->dev.parent;
 	config.init_data = pdata->dcdc[id];
 	config.driver_data = dcdc;
+	config.regmap = wm831x->regmap;
 
 	dcdc->regulator = regulator_register(&dcdc->desc, &config);
 	if (IS_ERR(dcdc->regulator)) {
@@ -691,9 +659,9 @@ static struct regulator_ops wm831x_buckp_ops = {
 	.list_voltage = wm831x_buckp_list_voltage,
 	.set_suspend_voltage = wm831x_buckp_set_suspend_voltage,
 
-	.is_enabled = wm831x_dcdc_is_enabled,
-	.enable = wm831x_dcdc_enable,
-	.disable = wm831x_dcdc_disable,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
 	.get_status = wm831x_dcdc_get_status,
 	.get_mode = wm831x_dcdc_get_mode,
 	.set_mode = wm831x_dcdc_set_mode,
@@ -752,6 +720,8 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 	dcdc->desc.owner = THIS_MODULE;
 	dcdc->desc.vsel_reg = dcdc->base + WM831X_DCDC_ON_CONFIG;
 	dcdc->desc.vsel_mask = WM831X_DC3_ON_VSEL_MASK;
+	dcdc->desc.enable_reg = WM831X_DCDC_ENABLE;
+	dcdc->desc.enable_mask = 1 << id;
 
 	config.dev = pdev->dev.parent;
 	config.init_data = pdata->dcdc[id];
@@ -840,9 +810,9 @@ static int wm831x_boostp_get_status(struct regulator_dev *rdev)
 static struct regulator_ops wm831x_boostp_ops = {
 	.get_status = wm831x_boostp_get_status,
 
-	.is_enabled = wm831x_dcdc_is_enabled,
-	.enable = wm831x_dcdc_enable,
-	.disable = wm831x_dcdc_disable,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
 };
 
 static __devinit int wm831x_boostp_probe(struct platform_device *pdev)
@@ -882,10 +852,13 @@ static __devinit int wm831x_boostp_probe(struct platform_device *pdev)
 	dcdc->desc.type = REGULATOR_VOLTAGE;
 	dcdc->desc.ops = &wm831x_boostp_ops;
 	dcdc->desc.owner = THIS_MODULE;
+	dcdc->desc.enable_reg = WM831X_DCDC_ENABLE;
+	dcdc->desc.enable_mask = 1 << id;
 
 	config.dev = pdev->dev.parent;
 	config.init_data = pdata->dcdc[id];
 	config.driver_data = dcdc;
+	config.regmap = wm831x->regmap;
 
 	dcdc->regulator = regulator_register(&dcdc->desc, &config);
 	if (IS_ERR(dcdc->regulator)) {
@@ -946,9 +919,9 @@ static struct platform_driver wm831x_boostp_driver = {
 #define WM831X_EPE_BASE 6
 
 static struct regulator_ops wm831x_epe_ops = {
-	.is_enabled = wm831x_dcdc_is_enabled,
-	.enable = wm831x_dcdc_enable,
-	.disable = wm831x_dcdc_disable,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
 	.get_status = wm831x_dcdc_get_status,
 };
 
@@ -983,10 +956,13 @@ static __devinit int wm831x_epe_probe(struct platform_device *pdev)
 	dcdc->desc.ops = &wm831x_epe_ops;
 	dcdc->desc.type = REGULATOR_VOLTAGE;
 	dcdc->desc.owner = THIS_MODULE;
+	dcdc->desc.enable_reg = WM831X_DCDC_ENABLE;
+	dcdc->desc.enable_mask = 1 << dcdc->desc.id;
 
 	config.dev = pdev->dev.parent;
 	config.init_data = pdata->epe[id];
 	config.driver_data = dcdc;
+	config.regmap = wm831x->regmap;
 
 	dcdc->regulator = regulator_register(&dcdc->desc, &config);
 	if (IS_ERR(dcdc->regulator)) {
-- 
1.7.9.1

