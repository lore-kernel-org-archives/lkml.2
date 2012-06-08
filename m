Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370Ab2FHC15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 22:27:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38313 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab2FHC14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 22:27:56 -0400
Message-ID: <1339122469.5794.2.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: ab8500: Use
 regulator_list_voltage_linear for ab8500_regulator_fixed_ops
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Fri, 08 Jun 2012 10:27:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also removes set_voltage_time_sel callback from ab8500_regulator_fixed_ops
because the voltage won't change. ( And ab8500_regulator_fixed_ops does not
implement get_voltage_sel so set_voltage_time_sel won't be called )

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab8500.c |   41 +++++++++--------------------------------
 1 file changed, 9 insertions(+), 32 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 290c289..c931c7c 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -32,7 +32,6 @@
  * @regulator_dev: regulator device
  * @max_uV: maximum voltage (for variable voltage supplies)
  * @min_uV: minimum voltage (for variable voltage supplies)
- * @fixed_uV: typical voltage (for fixed voltage supplies)
  * @update_bank: bank to control on/off
  * @update_reg: register to control on/off
  * @update_mask: mask to enable/disable regulator
@@ -48,7 +47,6 @@ struct ab8500_regulator_info {
 	struct regulator_dev	*regulator;
 	int max_uV;
 	int min_uV;
-	int fixed_uV;
 	u8 update_bank;
 	u8 update_reg;
 	u8 update_mask;
@@ -271,29 +269,9 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
 };
 
-static int ab8500_fixed_list_voltage(struct regulator_dev *rdev,
-				     unsigned selector)
-{
-	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
-
-	if (info == NULL) {
-		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
-		return -EINVAL;
-	}
-
-	return info->fixed_uV;
-}
-
 static int ab8500_fixed_get_voltage(struct regulator_dev *rdev)
 {
-	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
-
-	if (info == NULL) {
-		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
-		return -EINVAL;
-	}
-
-	return info->fixed_uV;
+	return rdev->desc->min_uV;
 }
 
 static struct regulator_ops ab8500_regulator_fixed_ops = {
@@ -301,9 +279,8 @@ static struct regulator_ops ab8500_regulator_fixed_ops = {
 	.disable	= ab8500_regulator_disable,
 	.is_enabled	= ab8500_regulator_is_enabled,
 	.get_voltage	= ab8500_fixed_get_voltage,
-	.list_voltage	= ab8500_fixed_list_voltage,
+	.list_voltage	= regulator_list_voltage_linear,
 	.enable_time	= ab8500_regulator_enable_time,
-	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
 };
 
 static struct ab8500_regulator_info
@@ -408,9 +385,9 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.min_uV		= 2000000,
 		},
 		.delay			= 10000,
-		.fixed_uV		= 2000000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
 		.update_mask		= 0x82,
@@ -424,8 +401,8 @@ static struct ab8500_regulator_info
 			.id             = AB8500_LDO_USB,
 			.owner          = THIS_MODULE,
 			.n_voltages     = 1,
+			.min_uV		= 3300000,
 		},
-		.fixed_uV               = 3300000,
 		.update_bank            = 0x03,
 		.update_reg             = 0x82,
 		.update_mask            = 0x03,
@@ -439,8 +416,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.min_uV		= 2000000,
 		},
-		.fixed_uV		= 2000000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x02,
@@ -454,8 +431,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.min_uV		= 2050000,
 		},
-		.fixed_uV		= 2050000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x08,
@@ -469,8 +446,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.min_uV		= 2050000,
 		},
-		.fixed_uV		= 2050000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x10,
@@ -484,8 +461,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.min_uV		= 1800000,
 		},
-		.fixed_uV		= 1800000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x04,
@@ -499,8 +476,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.min_uV		= 1200000,
 		},
-		.fixed_uV		= 1200000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x06,
 		.update_mask		= 0x0c,
-- 
1.7.9.5



