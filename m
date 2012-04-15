Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab2DOLDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 07:03:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32891 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797Ab2DOLDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 07:03:23 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: wm8994: Convert to set_voltage_sel()
Date: Sun, 15 Apr 2012 12:03:19 +0100
Message-Id: <1334487799-824-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to implement set_voltage() as there is only a very small
range of selectors for the regulators in the WM8994 and the voltages are
not expected to vary frequently at runtime.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8994-regulator.c |   41 +++++-----------------------------
 1 files changed, 6 insertions(+), 35 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index f4a6294..0ee81e1 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -98,18 +98,11 @@ static int wm8994_ldo1_get_voltage_sel(struct regulator_dev *rdev)
 	return (val & WM8994_LDO1_VSEL_MASK) >> WM8994_LDO1_VSEL_SHIFT;
 }
 
-static int wm8994_ldo1_set_voltage(struct regulator_dev *rdev,
-				   int min_uV, int max_uV, unsigned *s)
+static int wm8994_ldo1_set_voltage_sel(struct regulator_dev *rdev,
+				       unsigned selector)
 {
 	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
-	int selector, v;
 
-	selector = (min_uV - 2400000) / 100000;
-	v = wm8994_ldo1_list_voltage(rdev, selector);
-	if (v < 0 || v > max_uV)
-		return -EINVAL;
-
-	*s = selector;
 	selector <<= WM8994_LDO1_VSEL_SHIFT;
 
 	return wm8994_set_bits(ldo->wm8994, WM8994_LDO_1,
@@ -124,7 +117,7 @@ static struct regulator_ops wm8994_ldo1_ops = {
 
 	.list_voltage = wm8994_ldo1_list_voltage,
 	.get_voltage_sel = wm8994_ldo1_get_voltage_sel,
-	.set_voltage = wm8994_ldo1_set_voltage,
+	.set_voltage_sel = wm8994_ldo1_set_voltage_sel,
 };
 
 static int wm8994_ldo2_list_voltage(struct regulator_dev *rdev,
@@ -165,33 +158,11 @@ static int wm8994_ldo2_get_voltage_sel(struct regulator_dev *rdev)
 	return (val & WM8994_LDO2_VSEL_MASK) >> WM8994_LDO2_VSEL_SHIFT;
 }
 
-static int wm8994_ldo2_set_voltage(struct regulator_dev *rdev,
-				   int min_uV, int max_uV, unsigned *s)
+static int wm8994_ldo2_set_voltage_sel(struct regulator_dev *rdev,
+				       unsigned selector)
 {
 	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
-	int selector, v;
-
-	switch (ldo->wm8994->type) {
-	case WM8994:
-		selector = (min_uV - 900000) / 100000;
-		break;
-	case WM8958:
-		selector = (min_uV - 1000000) / 100000;
-		break;
-	case WM1811:
-		selector = (min_uV - 950000) / 100000;
-		if (selector == 0)
-			selector = 1;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	v = wm8994_ldo2_list_voltage(rdev, selector);
-	if (v < 0 || v > max_uV)
-		return -EINVAL;
 
-	*s = selector;
 	selector <<= WM8994_LDO2_VSEL_SHIFT;
 
 	return wm8994_set_bits(ldo->wm8994, WM8994_LDO_2,
@@ -206,7 +177,7 @@ static struct regulator_ops wm8994_ldo2_ops = {
 
 	.list_voltage = wm8994_ldo2_list_voltage,
 	.get_voltage_sel = wm8994_ldo2_get_voltage_sel,
-	.set_voltage = wm8994_ldo2_set_voltage,
+	.set_voltage_sel = wm8994_ldo2_set_voltage_sel,
 };
 
 static const struct regulator_desc wm8994_ldo_desc[] = {
-- 
1.7.9.1

