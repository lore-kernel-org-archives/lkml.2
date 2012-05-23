Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007Ab2EWPB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:01:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33298 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964860Ab2EWPBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:01:25 -0400
Message-ID: <1337785274.12699.5.camel@phoenix>
Subject: [PATCH 2/2] regulator: wm8350: Convert wm8350_dcdc_ops to
 set_voltage_sel and regulator_map_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 23 May 2012 23:01:14 +0800
In-Reply-To: <1337785166.12699.3.camel@phoenix>
References: <1337785166.12699.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8350-regulator.c |   30 ++++++------------------------
 1 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 6d143a918..3f451e8 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -125,11 +125,6 @@ static inline unsigned int wm8350_ldo_mvolts_to_val(int mV)
 		return ((mV - 1800) / 100) + 16;
 }
 
-static inline int wm8350_dcdc_val_to_mvolts(unsigned int val)
-{
-	return (val * 25) + 850;
-}
-
 static inline unsigned int wm8350_dcdc_mvolts_to_val(int mV)
 {
 	return (mV - 850) / 25;
@@ -359,25 +354,13 @@ int wm8350_isink_set_flash(struct wm8350 *wm8350, int isink, u16 mode,
 }
 EXPORT_SYMBOL_GPL(wm8350_isink_set_flash);
 
-static int wm8350_dcdc_set_voltage(struct regulator_dev *rdev, int min_uV,
-				   int max_uV, unsigned *selector)
+static int wm8350_dcdc_set_voltage_sel(struct regulator_dev *rdev,
+				       unsigned selector)
 {
 	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
-	int volt_reg, dcdc = rdev_get_id(rdev), mV,
-		min_mV = min_uV / 1000, max_mV = max_uV / 1000;
+	int volt_reg, dcdc = rdev_get_id(rdev);
 	u16 val;
 
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
 	switch (dcdc) {
 	case WM8350_DCDC_1:
 		volt_reg = WM8350_DCDC1_CONTROL;
@@ -397,11 +380,9 @@ static int wm8350_dcdc_set_voltage(struct regulator_dev *rdev, int min_uV,
 		return -EINVAL;
 	}
 
-	*selector = mV;
-
 	/* all DCDCs have same mV bits */
 	val = wm8350_reg_read(wm8350, volt_reg) & ~WM8350_DC1_VSEL_MASK;
-	wm8350_reg_write(wm8350, volt_reg, val | mV);
+	wm8350_reg_write(wm8350, volt_reg, val | selector);
 	return 0;
 }
 
@@ -1216,9 +1197,10 @@ static int wm8350_ldo_is_enabled(struct regulator_dev *rdev)
 }
 
 static struct regulator_ops wm8350_dcdc_ops = {
-	.set_voltage = wm8350_dcdc_set_voltage,
+	.set_voltage_sel = wm8350_dcdc_set_voltage_sel,
 	.get_voltage_sel = wm8350_dcdc_get_voltage_sel,
 	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
 	.enable = wm8350_dcdc_enable,
 	.disable = wm8350_dcdc_disable,
 	.get_mode = wm8350_dcdc_get_mode,
-- 
1.7.5.4



