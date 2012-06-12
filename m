Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2FLMKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:10:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40656 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab2FLMKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:10:32 -0400
Message-ID: <1339503026.2881.3.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: wm8350: Reuse map_voltage() to get
 selector of a given uV
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 12 Jun 2012 20:10:26 +0800
In-Reply-To: <1339502910.2881.1.camel@phoenix>
References: <1339502910.2881.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reuse map_voltage() to get the selector of a given uV.

Then we can remove wm8350_ldo_mvolts_to_val() and wm8350_dcdc_mvolts_to_val().
Also remove unused wm8350_dcdc_val_to_mvolts() function.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8350-regulator.c |  127 +++++++++++++---------------------
 1 file changed, 50 insertions(+), 77 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index c4913be..7f0fa22 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -108,24 +108,6 @@ static int get_isink_val(int min_uA, int max_uA, u16 *setting)
 	return -EINVAL;
 }
 
-static inline unsigned int wm8350_ldo_mvolts_to_val(int mV)
-{
-	if (mV < 1800)
-		return (mV - 900) / 50;
-	else
-		return ((mV - 1800) / 100) + 16;
-}
-
-static inline int wm8350_dcdc_val_to_mvolts(unsigned int val)
-{
-	return (val * 25) + 850;
-}
-
-static inline unsigned int wm8350_dcdc_mvolts_to_val(int mV)
-{
-	return (mV - 850) / 25;
-}
-
 static int wm8350_isink_set_current(struct regulator_dev *rdev, int min_uA,
 	int max_uA)
 {
@@ -353,19 +335,10 @@ EXPORT_SYMBOL_GPL(wm8350_isink_set_flash);
 static int wm8350_dcdc_set_suspend_voltage(struct regulator_dev *rdev, int uV)
 {
 	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
-	int volt_reg, mV = uV / 1000, dcdc = rdev_get_id(rdev);
+	int sel, volt_reg, dcdc = rdev_get_id(rdev);
 	u16 val;
 
-	dev_dbg(wm8350->dev, "%s %d mV %d\n", __func__, dcdc, mV);
-
-	if (mV && (mV < 850 || mV > 4025)) {
-		dev_err(wm8350->dev,
-			"DCDC%d suspend voltage %d mV out of range\n",
-			dcdc, mV);
-		return -EINVAL;
-	}
-	if (mV == 0)
-		mV = 850;
+	dev_dbg(wm8350->dev, "%s %d mV %d\n", __func__, dcdc, uV / 1000);
 
 	switch (dcdc) {
 	case WM8350_DCDC_1:
@@ -386,10 +359,13 @@ static int wm8350_dcdc_set_suspend_voltage(struct regulator_dev *rdev, int uV)
 		return -EINVAL;
 	}
 
+	sel = regulator_map_voltage_linear(rdev, uV, uV);
+	if (sel < 0)
+		return -EINVAL;
+
 	/* all DCDCs have same mV bits */
 	val = wm8350_reg_read(wm8350, volt_reg) & ~WM8350_DC1_VSEL_MASK;
-	wm8350_reg_write(wm8350, volt_reg,
-			 val | wm8350_dcdc_mvolts_to_val(mV));
+	wm8350_reg_write(wm8350, volt_reg, val | sel);
 	return 0;
 }
 
@@ -566,19 +542,49 @@ static int wm8350_dcdc_set_suspend_mode(struct regulator_dev *rdev,
 	return 0;
 }
 
+static int wm8350_ldo_list_voltage(struct regulator_dev *rdev,
+				    unsigned selector)
+{
+	if (selector > WM8350_LDO1_VSEL_MASK)
+		return -EINVAL;
+
+	if (selector < 16)
+		return (selector * 50000) + 900000;
+	else
+		return ((selector - 16) * 100000) + 1800000;
+}
+
+static int wm8350_ldo_map_voltage(struct regulator_dev *rdev, int min_uV,
+				  int max_uV)
+{
+	int volt, sel;
+	int min_mV = min_uV / 1000;
+	int max_mV = max_uV / 1000;
+
+	if (min_mV < 900 || min_mV > 3300)
+		return -EINVAL;
+	if (max_mV < 900 || max_mV > 3300)
+		return -EINVAL;
+
+	if (min_mV < 1800) /* step size is 50mV < 1800mV */
+		sel = DIV_ROUND_UP(min_uV - 900, 50);
+	else /* step size is 100mV > 1800mV */
+		sel = DIV_ROUND_UP(min_uV - 1800, 100) + 16;
+
+	volt = wm8350_ldo_list_voltage(rdev, sel);
+	if (volt < min_uV || volt > max_uV)
+		return -EINVAL;
+
+	return sel;
+}
+
 static int wm8350_ldo_set_suspend_voltage(struct regulator_dev *rdev, int uV)
 {
 	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
-	int volt_reg, mV = uV / 1000, ldo = rdev_get_id(rdev);
+	int sel, volt_reg, ldo = rdev_get_id(rdev);
 	u16 val;
 
-	dev_dbg(wm8350->dev, "%s %d mV %d\n", __func__, ldo, mV);
-
-	if (mV < 900 || mV > 3300) {
-		dev_err(wm8350->dev, "LDO%d voltage %d mV out of range\n",
-			ldo, mV);
-		return -EINVAL;
-	}
+	dev_dbg(wm8350->dev, "%s %d mV %d\n", __func__, ldo, uV / 1000);
 
 	switch (ldo) {
 	case WM8350_LDO_1:
@@ -597,10 +603,13 @@ static int wm8350_ldo_set_suspend_voltage(struct regulator_dev *rdev, int uV)
 		return -EINVAL;
 	}
 
+	sel = wm8350_ldo_map_voltage(rdev, uV, uV);
+	if (sel < 0)
+		return -EINVAL;
+
 	/* all LDOs have same mV bits */
 	val = wm8350_reg_read(wm8350, volt_reg) & ~WM8350_LDO1_VSEL_MASK;
-	wm8350_reg_write(wm8350, volt_reg,
-			 val | wm8350_ldo_mvolts_to_val(mV));
+	wm8350_reg_write(wm8350, volt_reg, val | sel);
 	return 0;
 }
 
@@ -662,42 +671,6 @@ static int wm8350_ldo_set_suspend_disable(struct regulator_dev *rdev)
 	return 0;
 }
 
-static int wm8350_ldo_list_voltage(struct regulator_dev *rdev,
-				    unsigned selector)
-{
-	if (selector > WM8350_LDO1_VSEL_MASK)
-		return -EINVAL;
-
-	if (selector < 16)
-		return (selector * 50000) + 900000;
-	else
-		return ((selector - 16) * 100000) + 1800000;
-}
-
-static int wm8350_ldo_map_voltage(struct regulator_dev *rdev, int min_uV,
-				  int max_uV)
-{
-	int volt, sel;
-	int min_mV = min_uV / 1000;
-	int max_mV = max_uV / 1000;
-
-	if (min_mV < 900 || min_mV > 3300)
-		return -EINVAL;
-	if (max_mV < 900 || max_mV > 3300)
-		return -EINVAL;
-
-	if (min_mV < 1800) /* step size is 50mV < 1800mV */
-		sel = DIV_ROUND_UP(min_uV - 900, 50);
-	else /* step size is 100mV > 1800mV */
-		sel = DIV_ROUND_UP(min_uV - 1800, 100) + 16;
-
-	volt = wm8350_ldo_list_voltage(rdev, sel);
-	if (volt < min_uV || volt > max_uV)
-		return -EINVAL;
-
-	return sel;
-}
-
 int wm8350_dcdc_set_slot(struct wm8350 *wm8350, int dcdc, u16 start,
 			 u16 stop, u16 fault)
 {
-- 
1.7.9.5



