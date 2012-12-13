Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab2LMIsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 03:48:32 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:58679 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab2LMIsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 03:48:30 -0500
Message-ID: <1355388504.31434.8.camel@phoenix>
Subject: [RFC/RFT][PATCH 4/4] regulator: tps6586x: Use activate_[reg|bit]
 with regmap based voltage_sel operations
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Rapoport <mike@compulab.co.il>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Dec 2012 16:48:24 +0800
In-Reply-To: <1355388248.31434.3.camel@phoenix>
References: <1355388248.31434.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps6586x-regulator.c |   54 ++++++--------------------------
 1 file changed, 10 insertions(+), 44 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index f86da67..1b5e8b9 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -61,10 +61,6 @@ struct tps6586x_regulator {
 
 	int enable_bit[2];
 	int enable_reg[2];
-
-	/* for DVM regulators */
-	int go_reg;
-	int go_bit;
 };
 
 static inline struct device *to_tps6586x_dev(struct regulator_dev *rdev)
@@ -72,37 +68,10 @@ static inline struct device *to_tps6586x_dev(struct regulator_dev *rdev)
 	return rdev_get_dev(rdev)->parent;
 }
 
-static int tps6586x_set_voltage_sel(struct regulator_dev *rdev,
-				    unsigned selector)
-{
-	struct tps6586x_regulator *ri = rdev_get_drvdata(rdev);
-	struct device *parent = to_tps6586x_dev(rdev);
-	int ret, val, rid = rdev_get_id(rdev);
-	uint8_t mask;
-
-	val = selector << (ffs(rdev->desc->vsel_mask) - 1);
-	mask = rdev->desc->vsel_mask;
-
-	ret = tps6586x_update(parent, rdev->desc->vsel_reg, val, mask);
-	if (ret)
-		return ret;
-
-	/* Update go bit for DVM regulators */
-	switch (rid) {
-	case TPS6586X_ID_LDO_2:
-	case TPS6586X_ID_LDO_4:
-	case TPS6586X_ID_SM_0:
-	case TPS6586X_ID_SM_1:
-		ret = tps6586x_set_bits(parent, ri->go_reg, 1 << ri->go_bit);
-		break;
-	}
-	return ret;
-}
-
 static struct regulator_ops tps6586x_regulator_ops = {
 	.list_voltage = regulator_list_voltage_table,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
-	.set_voltage_sel = tps6586x_set_voltage_sel,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
@@ -142,7 +111,7 @@ static const unsigned int tps6586x_dvm_voltages[] = {
 };
 
 #define TPS6586X_REGULATOR(_id, _pin_name, vdata, vreg, shift, nbits,	\
-			   ereg0, ebit0, ereg1, ebit1)			\
+			   ereg0, ebit0, ereg1, ebit1, goreg, gobit)	\
 	.desc	= {							\
 		.supply_name = _pin_name,				\
 		.name	= "REG-" #_id,					\
@@ -156,29 +125,26 @@ static const unsigned int tps6586x_dvm_voltages[] = {
 		.enable_mask = 1 << (ebit0),				\
 		.vsel_reg = TPS6586X_##vreg,				\
 		.vsel_mask = ((1 << (nbits)) - 1) << (shift),		\
+		.activate_reg = (goreg),				\
+		.activate_bit = (gobit),				\
 	},								\
 	.enable_reg[0]	= TPS6586X_SUPPLY##ereg0,			\
 	.enable_bit[0]	= (ebit0),					\
 	.enable_reg[1]	= TPS6586X_SUPPLY##ereg1,			\
 	.enable_bit[1]	= (ebit1),
 
-#define TPS6586X_REGULATOR_DVM_GOREG(goreg, gobit)			\
-	.go_reg = TPS6586X_##goreg,					\
-	.go_bit = (gobit),
-
 #define TPS6586X_LDO(_id, _pname, vdata, vreg, shift, nbits,		\
 		     ereg0, ebit0, ereg1, ebit1)			\
 {									\
 	TPS6586X_REGULATOR(_id, _pname, vdata, vreg, shift, nbits,	\
-			   ereg0, ebit0, ereg1, ebit1)			\
+			   ereg0, ebit0, ereg1, ebit1, 0, 0)		\
 }
 
 #define TPS6586X_DVM(_id, _pname, vdata, vreg, shift, nbits,		\
 		     ereg0, ebit0, ereg1, ebit1, goreg, gobit)		\
 {									\
 	TPS6586X_REGULATOR(_id, _pname, vdata, vreg, shift, nbits,	\
-			   ereg0, ebit0, ereg1, ebit1)			\
-	TPS6586X_REGULATOR_DVM_GOREG(goreg, gobit)			\
+			   ereg0, ebit0, ereg1, ebit1, goreg, gobit)	\
 }
 
 #define TPS6586X_SYS_REGULATOR()					\
@@ -207,13 +173,13 @@ static struct tps6586x_regulator tps6586x_regulator[] = {
 	TPS6586X_LDO(SM_2, "vin-sm2", sm2, SUPPLYV2, 0, 5, ENC, 7, END, 7),
 
 	TPS6586X_DVM(LDO_2, "vinldo23", dvm, LDO2BV1, 0, 5, ENA, 3,
-					ENB, 3, VCC2, 6),
+					ENB, 3, TPS6586X_VCC2, BIT(6)),
 	TPS6586X_DVM(LDO_4, "vinldo4", ldo4, LDO4V1, 0, 5, ENC, 3,
-					END, 3, VCC1, 6),
+					END, 3, TPS6586X_VCC1, BIT(6)),
 	TPS6586X_DVM(SM_0, "vin-sm0", dvm, SM0V1, 0, 5, ENA, 1,
-					ENB, 1, VCC1, 2),
+					ENB, 1, TPS6586X_VCC1, BIT(2)),
 	TPS6586X_DVM(SM_1, "vin-sm1", dvm, SM1V1, 0, 5, ENA, 0,
-					ENB, 0, VCC1, 0),
+					ENB, 0, TPS6586X_VCC1, BIT(0)),
 };
 
 /*
-- 
1.7.9.5



