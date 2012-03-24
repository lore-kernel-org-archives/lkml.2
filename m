Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab2CXBos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 21:44:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48421 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2CXBor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 21:44:47 -0400
Message-ID: <1332553482.14114.7.camel@phoenix>
Subject: [PATCH 4/4] regulator: Merge tps6586x_regulator_ldo_ops and
 tps6586x_regulator_dvm_ops
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>, Danny Huang <dahuang@nvidia.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sat, 24 Mar 2012 09:44:42 +0800
In-Reply-To: <1332553050.14114.1.camel@phoenix>
References: <1332553050.14114.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now all the callback implementation are the same for both ldo and dvm
regulator_ops, merge them to tps6586x_regulator_ops.

Also rename tps6586x_ldo_list_voltage to tps6586x_list_voltage.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6586x-regulator.c |   25 +++++++------------------
 1 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index 51ca882..18f5337 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -75,8 +75,7 @@ static inline struct device *to_tps6586x_dev(struct regulator_dev *rdev)
 	return rdev_get_dev(rdev)->parent->parent;
 }
 
-static int tps6586x_ldo_list_voltage(struct regulator_dev *rdev,
-				     unsigned selector)
+static int tps6586x_list_voltage(struct regulator_dev *rdev, unsigned selector)
 {
 	struct tps6586x_regulator *info = rdev_get_drvdata(rdev);
 	int rid = rdev_get_id(rdev);
@@ -168,18 +167,8 @@ static int tps6586x_regulator_is_enabled(struct regulator_dev *rdev)
 	return !!(reg_val & (1 << ri->enable_bit[0]));
 }
 
-static struct regulator_ops tps6586x_regulator_ldo_ops = {
-	.list_voltage = tps6586x_ldo_list_voltage,
-	.get_voltage_sel = tps6586x_get_voltage_sel,
-	.set_voltage_sel = tps6586x_set_voltage_sel,
-
-	.is_enabled = tps6586x_regulator_is_enabled,
-	.enable = tps6586x_regulator_enable,
-	.disable = tps6586x_regulator_disable,
-};
-
-static struct regulator_ops tps6586x_regulator_dvm_ops = {
-	.list_voltage = tps6586x_ldo_list_voltage,
+static struct regulator_ops tps6586x_regulator_ops = {
+	.list_voltage = tps6586x_list_voltage,
 	.get_voltage_sel = tps6586x_get_voltage_sel,
 	.set_voltage_sel = tps6586x_set_voltage_sel,
 
@@ -213,11 +202,11 @@ static int tps6586x_dvm_voltages[] = {
 	1325, 1350, 1375, 1400, 1425, 1450, 1475, 1500,
 };
 
-#define TPS6586X_REGULATOR(_id, vdata, _ops, vreg, shift, nbits,	\
+#define TPS6586X_REGULATOR(_id, vdata, vreg, shift, nbits,		\
 			   ereg0, ebit0, ereg1, ebit1)			\
 	.desc	= {							\
 		.name	= "REG-" #_id,					\
-		.ops	= &tps6586x_regulator_##_ops,			\
+		.ops	= &tps6586x_regulator_ops,			\
 		.type	= REGULATOR_VOLTAGE,				\
 		.id	= TPS6586X_ID_##_id,				\
 		.n_voltages = ARRAY_SIZE(tps6586x_##vdata##_voltages),	\
@@ -239,14 +228,14 @@ static int tps6586x_dvm_voltages[] = {
 #define TPS6586X_LDO(_id, vdata, vreg, shift, nbits,			\
 		     ereg0, ebit0, ereg1, ebit1)			\
 {									\
-	TPS6586X_REGULATOR(_id, vdata, ldo_ops, vreg, shift, nbits,	\
+	TPS6586X_REGULATOR(_id, vdata, vreg, shift, nbits,		\
 			   ereg0, ebit0, ereg1, ebit1)			\
 }
 
 #define TPS6586X_DVM(_id, vdata, vreg, shift, nbits,			\
 		     ereg0, ebit0, ereg1, ebit1, goreg, gobit)		\
 {									\
-	TPS6586X_REGULATOR(_id, vdata, dvm_ops, vreg, shift, nbits,	\
+	TPS6586X_REGULATOR(_id, vdata, vreg, shift, nbits,		\
 			   ereg0, ebit0, ereg1, ebit1)			\
 	TPS6586X_REGULATOR_DVM_GOREG(goreg, gobit)			\
 }
-- 
1.7.5.4



