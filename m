Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab2CHEHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 23:07:47 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42145 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab2CHEHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 23:07:46 -0500
Message-ID: <1331179657.4048.1.camel@phoenix>
Subject: [PATCH] regulator: Simplify the implementation of
 tps65912_get_voltage_dcdc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 08 Mar 2012 12:07:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call tps65912_list_voltage_dcdc instead of duplicating the same code.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65912-regulator.c |  112 +++++++++++++-------------------
 1 files changed, 45 insertions(+), 67 deletions(-)

diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index da00d88..b685757 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -506,66 +506,88 @@ static unsigned int tps65912_get_mode(struct regulator_dev *dev)
 	return mode;
 }
 
-static int tps65912_get_voltage_dcdc(struct regulator_dev *dev)
+static int tps65912_list_voltage_dcdc(struct regulator_dev *dev,
+					unsigned selector)
 {
 	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
-	struct tps65912 *mfd = pmic->mfd;
-	int id = rdev_get_id(dev), voltage = 0, range;
-	int opvsel = 0, avsel = 0, sr, vsel;
+	int range, voltage = 0, id = rdev_get_id(dev);
 
 	switch (id) {
 	case TPS65912_REG_DCDC1:
-		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC1_OP);
-		avsel = tps65912_reg_read(mfd, TPS65912_DCDC1_AVS);
 		range = pmic->dcdc1_range;
 		break;
 	case TPS65912_REG_DCDC2:
-		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC2_OP);
-		avsel = tps65912_reg_read(mfd, TPS65912_DCDC2_AVS);
 		range = pmic->dcdc2_range;
 		break;
 	case TPS65912_REG_DCDC3:
-		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC3_OP);
-		avsel = tps65912_reg_read(mfd, TPS65912_DCDC3_AVS);
 		range = pmic->dcdc3_range;
 		break;
 	case TPS65912_REG_DCDC4:
-		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC4_OP);
-		avsel = tps65912_reg_read(mfd, TPS65912_DCDC4_AVS);
 		range = pmic->dcdc4_range;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
-	if (sr)
-		vsel = avsel;
-	else
-		vsel = opvsel;
-	vsel &= 0x3F;
-
 	switch (range) {
 	case 0:
 		/* 0.5 - 1.2875V in 12.5mV steps */
-		voltage = tps65912_vsel_to_uv_range0(vsel);
+		voltage = tps65912_vsel_to_uv_range0(selector);
 		break;
 	case 1:
 		/* 0.7 - 1.4875V in 12.5mV steps */
-		voltage = tps65912_vsel_to_uv_range1(vsel);
+		voltage = tps65912_vsel_to_uv_range1(selector);
 		break;
 	case 2:
 		/* 0.5 - 2.075V in 25mV steps */
-		voltage = tps65912_vsel_to_uv_range2(vsel);
+		voltage = tps65912_vsel_to_uv_range2(selector);
 		break;
 	case 3:
 		/* 0.5 - 3.8V in 50mV steps */
-		voltage = tps65912_vsel_to_uv_range3(vsel);
+		voltage = tps65912_vsel_to_uv_range3(selector);
 		break;
 	}
 	return voltage;
 }
 
+static int tps65912_get_voltage_dcdc(struct regulator_dev *dev)
+{
+	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
+	struct tps65912 *mfd = pmic->mfd;
+	int id = rdev_get_id(dev);
+	int opvsel = 0, avsel = 0, sr, vsel;
+
+	switch (id) {
+	case TPS65912_REG_DCDC1:
+		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC1_OP);
+		avsel = tps65912_reg_read(mfd, TPS65912_DCDC1_AVS);
+		break;
+	case TPS65912_REG_DCDC2:
+		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC2_OP);
+		avsel = tps65912_reg_read(mfd, TPS65912_DCDC2_AVS);
+		break;
+	case TPS65912_REG_DCDC3:
+		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC3_OP);
+		avsel = tps65912_reg_read(mfd, TPS65912_DCDC3_AVS);
+		break;
+	case TPS65912_REG_DCDC4:
+		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC4_OP);
+		avsel = tps65912_reg_read(mfd, TPS65912_DCDC4_AVS);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
+	if (sr)
+		vsel = avsel;
+	else
+		vsel = opvsel;
+	vsel &= 0x3F;
+
+	return tps65912_list_voltage_dcdc(dev, vsel);
+}
+
 static int tps65912_set_voltage_dcdc(struct regulator_dev *dev,
 						unsigned selector)
 {
@@ -609,50 +631,6 @@ static int tps65912_set_voltage_ldo(struct regulator_dev *dev,
 	return tps65912_reg_write(mfd, reg, selector | value);
 }
 
-static int tps65912_list_voltage_dcdc(struct regulator_dev *dev,
-					unsigned selector)
-{
-	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
-	int range, voltage = 0, id = rdev_get_id(dev);
-
-	switch (id) {
-	case TPS65912_REG_DCDC1:
-		range = pmic->dcdc1_range;
-		break;
-	case TPS65912_REG_DCDC2:
-		range = pmic->dcdc2_range;
-		break;
-	case TPS65912_REG_DCDC3:
-		range = pmic->dcdc3_range;
-		break;
-	case TPS65912_REG_DCDC4:
-		range = pmic->dcdc4_range;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	switch (range) {
-	case 0:
-		/* 0.5 - 1.2875V in 12.5mV steps */
-		voltage = tps65912_vsel_to_uv_range0(selector);
-		break;
-	case 1:
-		/* 0.7 - 1.4875V in 12.5mV steps */
-		voltage = tps65912_vsel_to_uv_range1(selector);
-		break;
-	case 2:
-		/* 0.5 - 2.075V in 25mV steps */
-		voltage = tps65912_vsel_to_uv_range2(selector);
-		break;
-	case 3:
-		/* 0.5 - 3.8V in 50mV steps */
-		voltage = tps65912_vsel_to_uv_range3(selector);
-		break;
-	}
-	return voltage;
-}
-
 static int tps65912_list_voltage_ldo(struct regulator_dev *dev,
 					unsigned selector)
 {
-- 
1.7.5.4



