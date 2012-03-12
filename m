Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab2CLWk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:40:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61950 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400Ab2CLWk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:40:58 -0400
Message-ID: <1331592048.5392.1.camel@phoenix>
Subject: [PATCH] regulator: Use simple equations to get register address
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 13 Mar 2012 06:40:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address of ctrl and sel registers can be calculated by simple equations.
This patch simplifies the implementation in tps65912_get_ctrl_register and
implements tps65912_get_sel_register to replace tps65912_get_dcdc_sel_register
and tps65912_get_ldo_sel_register.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65912-regulator.c |  162 ++++----------------------------
 1 files changed, 18 insertions(+), 144 deletions(-)

diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index b685757..9c4d827 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -219,146 +219,30 @@ static unsigned long tps65912_vsel_to_uv_ldo(u8 vsel)
 
 static int tps65912_get_ctrl_register(int id)
 {
-	switch (id) {
-	case TPS65912_REG_DCDC1:
-		return TPS65912_DCDC1_AVS;
-	case TPS65912_REG_DCDC2:
-		return TPS65912_DCDC2_AVS;
-	case TPS65912_REG_DCDC3:
-		return TPS65912_DCDC3_AVS;
-	case TPS65912_REG_DCDC4:
-		return TPS65912_DCDC4_AVS;
-	case TPS65912_REG_LDO1:
-		return TPS65912_LDO1_AVS;
-	case TPS65912_REG_LDO2:
-		return TPS65912_LDO2_AVS;
-	case TPS65912_REG_LDO3:
-		return TPS65912_LDO3_AVS;
-	case TPS65912_REG_LDO4:
-		return TPS65912_LDO4_AVS;
-	case TPS65912_REG_LDO5:
-		return TPS65912_LDO5;
-	case TPS65912_REG_LDO6:
-		return TPS65912_LDO6;
-	case TPS65912_REG_LDO7:
-		return TPS65912_LDO7;
-	case TPS65912_REG_LDO8:
-		return TPS65912_LDO8;
-	case TPS65912_REG_LDO9:
-		return TPS65912_LDO9;
-	case TPS65912_REG_LDO10:
-		return TPS65912_LDO10;
-	default:
+	if (id >= TPS65912_REG_DCDC1 && id <= TPS65912_REG_LDO4)
+		return id * 3 + TPS65912_DCDC1_AVS;
+	else if (id >= TPS65912_REG_LDO5 && id <= TPS65912_REG_LDO10)
+		return id - TPS65912_REG_LDO5 + TPS65912_LDO5;
+	else
 		return -EINVAL;
-	}
 }
 
-static int tps65912_get_dcdc_sel_register(struct tps65912_reg *pmic, int id)
+static int tps65912_get_sel_register(struct tps65912_reg *pmic, int id)
 {
 	struct tps65912 *mfd = pmic->mfd;
-	int opvsel = 0, sr = 0;
+	int opvsel;
 	u8 reg = 0;
 
-	if (id < TPS65912_REG_DCDC1 || id > TPS65912_REG_DCDC4)
-		return -EINVAL;
-
-	switch (id) {
-	case TPS65912_REG_DCDC1:
-		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC1_OP);
-		sr = ((opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT);
-		if (sr)
-			reg = TPS65912_DCDC1_AVS;
+	if (id >= TPS65912_REG_DCDC1 && id <= TPS65912_REG_LDO4) {
+		opvsel = tps65912_reg_read(mfd, id * 3 + TPS65912_DCDC1_OP);
+		if (opvsel & OP_SELREG_MASK)
+			reg = id * 3 + TPS65912_DCDC1_AVS;
 		else
-			reg = TPS65912_DCDC1_OP;
-		break;
-	case TPS65912_REG_DCDC2:
-		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC2_OP);
-		sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
-		if (sr)
-			reg = TPS65912_DCDC2_AVS;
-		else
-			reg = TPS65912_DCDC2_OP;
-		break;
-	case TPS65912_REG_DCDC3:
-		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC3_OP);
-		sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
-		if (sr)
-			reg = TPS65912_DCDC3_AVS;
-		else
-			reg = TPS65912_DCDC3_OP;
-		break;
-	case TPS65912_REG_DCDC4:
-		opvsel = tps65912_reg_read(mfd, TPS65912_DCDC4_OP);
-		sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
-		if (sr)
-			reg = TPS65912_DCDC4_AVS;
-		else
-			reg = TPS65912_DCDC4_OP;
-		break;
-	}
-	return reg;
-}
-
-static int tps65912_get_ldo_sel_register(struct tps65912_reg *pmic, int id)
-{
-	struct tps65912 *mfd = pmic->mfd;
-	int opvsel = 0, sr = 0;
-	u8 reg = 0;
-
-	if (id < TPS65912_REG_LDO1 || id > TPS65912_REG_LDO10)
+			reg = id * 3 + TPS65912_DCDC1_OP;
+	} else if (id >= TPS65912_REG_LDO5 && id <= TPS65912_REG_LDO10) {
+		reg = id - TPS65912_REG_LDO5 + TPS65912_LDO5;
+	} else {
 		return -EINVAL;
-
-	switch (id) {
-	case TPS65912_REG_LDO1:
-		opvsel = tps65912_reg_read(mfd, TPS65912_LDO1_OP);
-		sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
-		if (sr)
-			reg = TPS65912_LDO1_AVS;
-		else
-			reg = TPS65912_LDO1_OP;
-		break;
-	case TPS65912_REG_LDO2:
-		opvsel = tps65912_reg_read(mfd, TPS65912_LDO2_OP);
-		sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
-		if (sr)
-			reg = TPS65912_LDO2_AVS;
-		else
-			reg = TPS65912_LDO2_OP;
-		break;
-	case TPS65912_REG_LDO3:
-		opvsel = tps65912_reg_read(mfd, TPS65912_LDO3_OP);
-		sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
-		if (sr)
-			reg = TPS65912_LDO3_AVS;
-		else
-			reg = TPS65912_LDO3_OP;
-		break;
-	case TPS65912_REG_LDO4:
-		opvsel = tps65912_reg_read(mfd, TPS65912_LDO4_OP);
-		sr = (opvsel & OP_SELREG_MASK) >> OP_SELREG_SHIFT;
-		if (sr)
-			reg = TPS65912_LDO4_AVS;
-		else
-			reg = TPS65912_LDO4_OP;
-		break;
-	case TPS65912_REG_LDO5:
-		reg = TPS65912_LDO5;
-		break;
-	case TPS65912_REG_LDO6:
-		reg = TPS65912_LDO6;
-		break;
-	case TPS65912_REG_LDO7:
-		reg = TPS65912_LDO7;
-		break;
-	case TPS65912_REG_LDO8:
-		reg = TPS65912_LDO8;
-		break;
-	case TPS65912_REG_LDO9:
-		reg = TPS65912_LDO9;
-		break;
-	case TPS65912_REG_LDO10:
-		reg = TPS65912_LDO10;
-		break;
 	}
 
 	return reg;
@@ -597,7 +481,7 @@ static int tps65912_set_voltage_dcdc(struct regulator_dev *dev,
 	int value;
 	u8 reg;
 
-	reg = tps65912_get_dcdc_sel_register(pmic, id);
+	reg = tps65912_get_sel_register(pmic, id);
 	value = tps65912_reg_read(mfd, reg);
 	value &= 0xC0;
 	return tps65912_reg_write(mfd, reg, selector | value);
@@ -611,7 +495,7 @@ static int tps65912_get_voltage_ldo(struct regulator_dev *dev)
 	int vsel = 0;
 	u8 reg;
 
-	reg = tps65912_get_ldo_sel_register(pmic, id);
+	reg = tps65912_get_sel_register(pmic, id);
 	vsel = tps65912_reg_read(mfd, reg);
 	vsel &= 0x3F;
 
@@ -625,7 +509,7 @@ static int tps65912_set_voltage_ldo(struct regulator_dev *dev,
 	struct tps65912 *mfd = pmic->mfd;
 	int id = rdev_get_id(dev), reg, value;
 
-	reg = tps65912_get_ldo_sel_register(pmic, id);
+	reg = tps65912_get_sel_register(pmic, id);
 	value = tps65912_reg_read(mfd, reg);
 	value &= 0xC0;
 	return tps65912_reg_write(mfd, reg, selector | value);
@@ -748,22 +632,12 @@ static struct platform_driver tps65912_driver = {
 	.remove = __devexit_p(tps65912_remove),
 };
 
-/**
- * tps65912_init
- *
- * Module init function
- */
 static int __init tps65912_init(void)
 {
 	return platform_driver_register(&tps65912_driver);
 }
 subsys_initcall(tps65912_init);
 
-/**
- * tps65912_cleanup
- *
- * Module exit function
- */
 static void __exit tps65912_cleanup(void)
 {
 	platform_driver_unregister(&tps65912_driver);
-- 
1.7.5.4



