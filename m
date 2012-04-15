Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab2DOLto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 07:49:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44643 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab2DOLtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 07:49:42 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/8] regulator: wm831x-dcdc: Use regulator_get_voltage_sel_regmap()
Date: Sun, 15 Apr 2012 12:49:20 +0100
Message-Id: <1334490565-19808-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1334490565-19808-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index c964863..d57cc74 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -685,23 +685,9 @@ static int wm831x_buckp_set_suspend_voltage(struct regulator_dev *rdev,
 	return wm831x_buckp_set_voltage_int(rdev, reg, uV, uV, &selector);
 }
 
-static int wm831x_buckp_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
-	struct wm831x *wm831x = dcdc->wm831x;
-	u16 reg = dcdc->base + WM831X_DCDC_ON_CONFIG;
-	int val;
-
-	val = wm831x_reg_read(wm831x, reg);
-	if (val < 0)
-		return val;
-
-	return val & WM831X_DC3_ON_VSEL_MASK;
-}
-
 static struct regulator_ops wm831x_buckp_ops = {
 	.set_voltage = wm831x_buckp_set_voltage,
-	.get_voltage_sel = wm831x_buckp_get_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.list_voltage = wm831x_buckp_list_voltage,
 	.set_suspend_voltage = wm831x_buckp_set_suspend_voltage,
 
@@ -764,10 +750,13 @@ static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
 	dcdc->desc.n_voltages = WM831X_BUCKP_MAX_SELECTOR + 1;
 	dcdc->desc.ops = &wm831x_buckp_ops;
 	dcdc->desc.owner = THIS_MODULE;
+	dcdc->desc.vsel_reg = dcdc->base + WM831X_DCDC_ON_CONFIG;
+	dcdc->desc.vsel_mask = WM831X_DC3_ON_VSEL_MASK;
 
 	config.dev = pdev->dev.parent;
 	config.init_data = pdata->dcdc[id];
 	config.driver_data = dcdc;
+	config.regmap = wm831x->regmap;
 
 	dcdc->regulator = regulator_register(&dcdc->desc, &config);
 	if (IS_ERR(dcdc->regulator)) {
-- 
1.7.9.1

