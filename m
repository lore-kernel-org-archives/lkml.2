Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab2EIBW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 21:22:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64315 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab2EIBW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 21:22:56 -0400
Message-ID: <1336526567.14246.1.camel@phoenix>
Subject: [PATCH RFT] regulator: tps65910: Convert to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Wed, 09 May 2012 09:22:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65910-regulator.c |   34 ++++++++-----------------------
 1 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 2deeb7c..6f40d36 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -578,10 +578,10 @@ static int tps65910_get_voltage_dcdc_sel(struct regulator_dev *dev)
 	return -EINVAL;
 }
 
-static int tps65910_get_voltage(struct regulator_dev *dev)
+static int tps65910_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
-	int reg, value, id = rdev_get_id(dev), voltage = 0;
+	int reg, value, id = rdev_get_id(dev);
 
 	reg = pmic->get_ctrl_reg(id);
 	if (reg < 0)
@@ -608,9 +608,7 @@ static int tps65910_get_voltage(struct regulator_dev *dev)
 		return -EINVAL;
 	}
 
-	voltage = pmic->info[id]->voltage_table[value] * 1000;
-
-	return voltage;
+	return value;
 }
 
 static int tps65910_get_voltage_vdd3(struct regulator_dev *dev)
@@ -618,10 +616,10 @@ static int tps65910_get_voltage_vdd3(struct regulator_dev *dev)
 	return 5 * 1000 * 1000;
 }
 
-static int tps65911_get_voltage(struct regulator_dev *dev)
+static int tps65911_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
-	int step_mv, id = rdev_get_id(dev);
+	int id = rdev_get_id(dev);
 	u8 value, reg;
 
 	reg = pmic->get_ctrl_reg(id);
@@ -634,13 +632,6 @@ static int tps65911_get_voltage(struct regulator_dev *dev)
 	case TPS65911_REG_LDO4:
 		value &= LDO1_SEL_MASK;
 		value >>= LDO_SEL_SHIFT;
-		/* The first 5 values of the selector correspond to 1V */
-		if (value < 5)
-			value = 0;
-		else
-			value -= 4;
-
-		step_mv = 50;
 		break;
 	case TPS65911_REG_LDO3:
 	case TPS65911_REG_LDO5:
@@ -649,23 +640,16 @@ static int tps65911_get_voltage(struct regulator_dev *dev)
 	case TPS65911_REG_LDO8:
 		value &= LDO3_SEL_MASK;
 		value >>= LDO_SEL_SHIFT;
-		/* The first 3 values of the selector correspond to 1V */
-		if (value < 3)
-			value = 0;
-		else
-			value -= 2;
-
-		step_mv = 100;
 		break;
 	case TPS65910_REG_VIO:
 		value &= LDO_SEL_MASK;
 		value >>= LDO_SEL_SHIFT;
-		return pmic->info[id]->voltage_table[value] * 1000;
+		break;
 	default:
 		return -EINVAL;
 	}
 
-	return (LDO_MIN_VOLT + value * step_mv) * 1000;
+	return value;
 }
 
 static int tps65910_set_voltage_dcdc_sel(struct regulator_dev *dev,
@@ -901,7 +885,7 @@ static struct regulator_ops tps65910_ops = {
 	.enable_time		= tps65910_enable_time,
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
-	.get_voltage		= tps65910_get_voltage,
+	.get_voltage_sel	= tps65910_get_voltage_sel,
 	.set_voltage_sel	= tps65910_set_voltage_sel,
 	.list_voltage		= tps65910_list_voltage,
 };
@@ -913,7 +897,7 @@ static struct regulator_ops tps65911_ops = {
 	.enable_time		= tps65910_enable_time,
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
-	.get_voltage		= tps65911_get_voltage,
+	.get_voltage_sel	= tps65911_get_voltage_sel,
 	.set_voltage_sel	= tps65911_set_voltage_sel,
 	.list_voltage		= tps65911_list_voltage,
 };
-- 
1.7.5.4



