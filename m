Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2C1G73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:59:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55007 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2C1G72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:59:28 -0400
Message-ID: <1332917963.19101.2.camel@phoenix>
Subject: [PATCH 2/4] regulator: Add missing n_voltages setting for 88pm8607
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Jett.Zhou" <jtzhou@marvell.com>
Date: Wed, 28 Mar 2012 14:59:23 +0800
In-Reply-To: <1332917909.19101.1.camel@phoenix>
References: <1332917909.19101.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then we can remove the vol_nbits field from struct pm8607_regulator_info.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/88pm8607.c |   51 ++++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 981b47a..81b6659 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -29,7 +29,6 @@ struct pm8607_regulator_info {
 
 	int	vol_reg;
 	int	vol_shift;
-	int	vol_nbits;
 	int	update_reg;
 	int	update_bit;
 	int	enable_reg;
@@ -216,7 +215,7 @@ static int pm8607_list_voltage(struct regulator_dev *rdev, unsigned index)
 	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
 	int ret = -EINVAL;
 
-	if (info->vol_table && (index < (1 << info->vol_nbits))) {
+	if (info->vol_table && (index < rdev->desc->n_voltages)) {
 		ret = info->vol_table[index];
 		if (info->slope_double)
 			ret <<= 1;
@@ -234,7 +233,7 @@ static int choose_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
 		max_uV = max_uV >> 1;
 	}
 	if (info->vol_table) {
-		for (i = 0; i < (1 << info->vol_nbits); i++) {
+		for (i = 0; i < rdev->desc->n_voltages; i++) {
 			if (!info->vol_table[i])
 				break;
 			if ((min_uV <= info->vol_table[i])
@@ -266,7 +265,7 @@ static int pm8607_set_voltage(struct regulator_dev *rdev,
 		return -EINVAL;
 	*selector = ret;
 	val = (uint8_t)(ret << info->vol_shift);
-	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
+	mask = (rdev->desc->n_voltages - 1)  << info->vol_shift;
 
 	ret = pm860x_set_bits(info->i2c, info->vol_reg, mask, val);
 	if (ret)
@@ -292,7 +291,7 @@ static int pm8607_get_voltage(struct regulator_dev *rdev)
 	if (ret < 0)
 		return ret;
 
-	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
+	mask = (rdev->desc->n_voltages - 1)  << info->vol_shift;
 	val = ((unsigned char)ret & mask) >> info->vol_shift;
 
 	return pm8607_list_voltage(rdev, val);
@@ -336,7 +335,7 @@ static struct regulator_ops pm8607_regulator_ops = {
 	.is_enabled	= pm8607_is_enabled,
 };
 
-#define PM8607_DVC(vreg, nbits, ureg, ubit, ereg, ebit)			\
+#define PM8607_DVC(vreg, ureg, ubit, ereg, ebit)			\
 {									\
 	.desc	= {							\
 		.name	= #vreg,					\
@@ -344,10 +343,10 @@ static struct regulator_ops pm8607_regulator_ops = {
 		.type	= REGULATOR_VOLTAGE,				\
 		.id	= PM8607_ID_##vreg,				\
 		.owner	= THIS_MODULE,					\
+		.n_voltages = ARRAY_SIZE(vreg##_table),			\
 	},								\
 	.vol_reg	= PM8607_##vreg,				\
 	.vol_shift	= (0),						\
-	.vol_nbits	= (nbits),					\
 	.update_reg	= PM8607_##ureg,				\
 	.update_bit	= (ubit),					\
 	.enable_reg	= PM8607_##ereg,				\
@@ -357,7 +356,7 @@ static struct regulator_ops pm8607_regulator_ops = {
 	.vol_suspend	= (unsigned int *)&vreg##_suspend_table,	\
 }
 
-#define PM8607_LDO(_id, vreg, shift, nbits, ereg, ebit)			\
+#define PM8607_LDO(_id, vreg, shift, ereg, ebit)			\
 {									\
 	.desc	= {							\
 		.name	= "LDO" #_id,					\
@@ -365,10 +364,10 @@ static struct regulator_ops pm8607_regulator_ops = {
 		.type	= REGULATOR_VOLTAGE,				\
 		.id	= PM8607_ID_LDO##_id,				\
 		.owner	= THIS_MODULE,					\
+		.n_voltages = ARRAY_SIZE(LDO##_id##_table),		\
 	},								\
 	.vol_reg	= PM8607_##vreg,				\
 	.vol_shift	= (shift),					\
-	.vol_nbits	= (nbits),					\
 	.enable_reg	= PM8607_##ereg,				\
 	.enable_bit	= (ebit),					\
 	.slope_double	= (0),						\
@@ -377,23 +376,23 @@ static struct regulator_ops pm8607_regulator_ops = {
 }
 
 static struct pm8607_regulator_info pm8607_regulator_info[] = {
-	PM8607_DVC(BUCK1, 6, GO, 0, SUPPLIES_EN11, 0),
-	PM8607_DVC(BUCK2, 6, GO, 1, SUPPLIES_EN11, 1),
-	PM8607_DVC(BUCK3, 6, GO, 2, SUPPLIES_EN11, 2),
-
-	PM8607_LDO( 1,         LDO1, 0, 2, SUPPLIES_EN11, 3),
-	PM8607_LDO( 2,         LDO2, 0, 3, SUPPLIES_EN11, 4),
-	PM8607_LDO( 3,         LDO3, 0, 3, SUPPLIES_EN11, 5),
-	PM8607_LDO( 4,         LDO4, 0, 3, SUPPLIES_EN11, 6),
-	PM8607_LDO( 5,         LDO5, 0, 2, SUPPLIES_EN11, 7),
-	PM8607_LDO( 6,         LDO6, 0, 3, SUPPLIES_EN12, 0),
-	PM8607_LDO( 7,         LDO7, 0, 3, SUPPLIES_EN12, 1),
-	PM8607_LDO( 8,         LDO8, 0, 3, SUPPLIES_EN12, 2),
-	PM8607_LDO( 9,         LDO9, 0, 3, SUPPLIES_EN12, 3),
-	PM8607_LDO(10,        LDO10, 0, 4, SUPPLIES_EN12, 4),
-	PM8607_LDO(12,        LDO12, 0, 4, SUPPLIES_EN12, 5),
-	PM8607_LDO(13, VIBRATOR_SET, 1, 3,  VIBRATOR_SET, 0),
-	PM8607_LDO(14,        LDO14, 0, 3, SUPPLIES_EN12, 6),
+	PM8607_DVC(BUCK1, GO, 0, SUPPLIES_EN11, 0),
+	PM8607_DVC(BUCK2, GO, 1, SUPPLIES_EN11, 1),
+	PM8607_DVC(BUCK3, GO, 2, SUPPLIES_EN11, 2),
+
+	PM8607_LDO(1,         LDO1, 0, SUPPLIES_EN11, 3),
+	PM8607_LDO(2,         LDO2, 0, SUPPLIES_EN11, 4),
+	PM8607_LDO(3,         LDO3, 0, SUPPLIES_EN11, 5),
+	PM8607_LDO(4,         LDO4, 0, SUPPLIES_EN11, 6),
+	PM8607_LDO(5,         LDO5, 0, SUPPLIES_EN11, 7),
+	PM8607_LDO(6,         LDO6, 0, SUPPLIES_EN12, 0),
+	PM8607_LDO(7,         LDO7, 0, SUPPLIES_EN12, 1),
+	PM8607_LDO(8,         LDO8, 0, SUPPLIES_EN12, 2),
+	PM8607_LDO(9,         LDO9, 0, SUPPLIES_EN12, 3),
+	PM8607_LDO(10,        LDO10, 0, SUPPLIES_EN12, 4),
+	PM8607_LDO(12,        LDO12, 0, SUPPLIES_EN12, 5),
+	PM8607_LDO(13, VIBRATOR_SET, 1, VIBRATOR_SET, 0),
+	PM8607_LDO(14,        LDO14, 0, SUPPLIES_EN12, 6),
 };
 
 static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
-- 
1.7.5.4



