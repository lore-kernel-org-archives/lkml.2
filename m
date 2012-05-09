Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344Ab2EIXtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:49:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56983 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761274Ab2EIXrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:47:55 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Yadwinder Singh <yadi.brar@samsung.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/6] regulator: wm8350: Convert LDOs to set_voltage_sel()
Date: Thu, 10 May 2012 00:47:33 +0100
Message-Id: <1336607255-4967-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336607255-4967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336607255-4967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there are two linear ranges for the LDO voltages provide a voltage
mapping function and then use regulator_set_voltage_sel_regmap().

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8350-regulator.c |   38 +++++++---------------------------
 1 file changed, 8 insertions(+), 30 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index a618284..9efca21 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -671,13 +671,12 @@ static int wm8350_ldo_set_suspend_disable(struct regulator_dev *rdev)
 	return 0;
 }
 
-static int wm8350_ldo_set_voltage(struct regulator_dev *rdev, int min_uV,
-				  int max_uV, unsigned *selector)
+static int wm8350_ldo_map_voltage(struct regulator_dev *rdev, int min_uV,
+				  int max_uV)
 {
-	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
-	int volt_reg, ldo = rdev_get_id(rdev), mV, min_mV = min_uV / 1000,
-		max_mV = max_uV / 1000;
-	u16 val;
+	int mV;
+	int min_mV = min_uV / 1000;
+	int max_mV = max_uV / 1000;
 
 	if (min_mV < 900 || min_mV > 3300)
 		return -EINVAL;
@@ -698,29 +697,7 @@ static int wm8350_ldo_set_voltage(struct regulator_dev *rdev, int min_uV,
 		BUG_ON(wm8350_ldo_val_to_mvolts(mV) < min_mV);
 	}
 
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
-	*selector = mV;
-
-	/* all LDOs have same mV bits */
-	val = wm8350_reg_read(wm8350, volt_reg) & ~WM8350_LDO1_VSEL_MASK;
-	wm8350_reg_write(wm8350, volt_reg, val | mV);
-	return 0;
+	return mV;
 }
 
 static int wm8350_ldo_list_voltage(struct regulator_dev *rdev,
@@ -1057,7 +1034,8 @@ static struct regulator_ops wm8350_dcdc2_5_ops = {
 };
 
 static struct regulator_ops wm8350_ldo_ops = {
-	.set_voltage = wm8350_ldo_set_voltage,
+	.map_voltage = wm8350_ldo_map_voltage,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.list_voltage = wm8350_ldo_list_voltage,
 	.enable = regulator_enable_regmap,
-- 
1.7.10

