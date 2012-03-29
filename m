Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab2C2Crv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 22:47:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51961 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786Ab2C2Cro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 22:47:44 -0400
Message-ID: <1332989256.29774.2.camel@phoenix>
Subject: [PATCH] regulator: Only update [LDOx|DCx]_HIB_MODE bits in
 wm8350_[ldo|dcdc]_set_suspend_disable
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 29 Mar 2012 10:47:36 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What we want is to disable output by setting [LDOx|DCx]_HIB_MODE bits.
Current code also clears other bits in LDOx/DCDCx Low Power register.

R202 (CAh) LDO1 Low Power
BIT[13:12] LDO1 Hibernate behaviour:
00 = Select voltage image settings
01 = disable output
10 = reserved
11 = reserved

R182 (B6h) DCDC1 Low Power
BIT[14:12] DC-DC1 Hibernate behaviour:
000 = Use current settings (no change)
001 = Select voltage image settings
010 = Force standby mode
011 = Force standby mode and voltage image settings.
100 = Force LDO mode
101 = Force LDO mode and voltage image settings.
110 = Reserved.
111 = Disable output

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8350-regulator.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index c5f3b40..05ecfb8 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -535,25 +535,25 @@ static int wm8350_dcdc_set_suspend_disable(struct regulator_dev *rdev)
 		val = wm8350_reg_read(wm8350, WM8350_DCDC1_LOW_POWER);
 		wm8350->pmic.dcdc1_hib_mode = val & WM8350_DCDC_HIB_MODE_MASK;
 		wm8350_reg_write(wm8350, WM8350_DCDC1_LOW_POWER,
-			WM8350_DCDC_HIB_MODE_DIS);
+				 val | WM8350_DCDC_HIB_MODE_DIS);
 		break;
 	case WM8350_DCDC_3:
 		val = wm8350_reg_read(wm8350, WM8350_DCDC3_LOW_POWER);
 		wm8350->pmic.dcdc3_hib_mode = val & WM8350_DCDC_HIB_MODE_MASK;
 		wm8350_reg_write(wm8350, WM8350_DCDC3_LOW_POWER,
-			WM8350_DCDC_HIB_MODE_DIS);
+				 val | WM8350_DCDC_HIB_MODE_DIS);
 		break;
 	case WM8350_DCDC_4:
 		val = wm8350_reg_read(wm8350, WM8350_DCDC4_LOW_POWER);
 		wm8350->pmic.dcdc4_hib_mode = val & WM8350_DCDC_HIB_MODE_MASK;
 		wm8350_reg_write(wm8350, WM8350_DCDC4_LOW_POWER,
-			WM8350_DCDC_HIB_MODE_DIS);
+				 val | WM8350_DCDC_HIB_MODE_DIS);
 		break;
 	case WM8350_DCDC_6:
 		val = wm8350_reg_read(wm8350, WM8350_DCDC6_LOW_POWER);
 		wm8350->pmic.dcdc6_hib_mode = val & WM8350_DCDC_HIB_MODE_MASK;
 		wm8350_reg_write(wm8350, WM8350_DCDC6_LOW_POWER,
-			WM8350_DCDC_HIB_MODE_DIS);
+				 val | WM8350_DCDC_HIB_MODE_DIS);
 		break;
 	case WM8350_DCDC_2:
 	case WM8350_DCDC_5:
@@ -749,7 +749,7 @@ static int wm8350_ldo_set_suspend_disable(struct regulator_dev *rdev)
 
 	/* all LDOs have same mV bits */
 	val = wm8350_reg_read(wm8350, volt_reg) & ~WM8350_LDO1_HIB_MODE_MASK;
-	wm8350_reg_write(wm8350, volt_reg, WM8350_LDO1_HIB_MODE_DIS);
+	wm8350_reg_write(wm8350, volt_reg, val | WM8350_LDO1_HIB_MODE_DIS);
 	return 0;
 }
 
-- 
1.7.5.4



