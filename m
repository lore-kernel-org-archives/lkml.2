Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab2FSHyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 03:54:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42674 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2FSHyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 03:54:11 -0400
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>, Axel Lin <axel.lin@gmail.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 1/2] regulator: max77686: Convert driver to use regulator_set_voltage_time_sel.
Date: Tue, 19 Jun 2012 13:23:42 +0530
Message-Id: <1340092423-10073-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the driver to use regulator_set_voltage_time_sel() as
.set_voltage_time_sel() callback. It also sets ramp_delay as 100000 uV/us for
LDOs & normal BUCKs and 27500 uV/us(default/reset value) for BUCKs[2/3/4] in
regulator_desc[].

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/max77686.c |   42 +++++++++---------------------------------
 1 files changed, 9 insertions(+), 33 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 2dd4ac9..a29eee3 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -40,6 +40,8 @@
 #define MAX77686_LDO_LOW_UVSTEP	25000
 #define MAX77686_BUCK_MINUV	750000
 #define MAX77686_BUCK_UVSTEP	50000
+#define MAX77686_RAMP_DELAY	100000			/* uV/us */
+#define MAX77686_DVS_RAMP_DELAY	27500			/* uV/us */
 #define MAX77686_DVS_MINUV	600000
 #define MAX77686_DVS_UVSTEP	12500
 
@@ -66,28 +68,8 @@ struct max77686_data {
 	struct device *dev;
 	struct max77686_dev *iodev;
 	struct regulator_dev **rdev;
-	int ramp_delay; /* in mV/us */
 };
 
-static int max77686_set_dvs_voltage_time_sel(struct regulator_dev *rdev,
-			unsigned int old_selector, unsigned int new_selector)
-{
-	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
-	int ramp_rate[] = {13, 27, 55, 100};
-
-	return DIV_ROUND_UP(rdev->desc->uV_step *
-			    abs(new_selector - old_selector),
-			    ramp_rate[max77686->ramp_delay] * 1000);
-}
-
-static int max77686_set_voltage_time_sel(struct regulator_dev *rdev,
-			unsigned int old_selector, unsigned int new_selector)
-{
-	/* Unconditionally 100 mV/us */
-	return DIV_ROUND_UP(rdev->desc->uV_step *
-			    abs(new_selector - old_selector), 100 * 1000);
-}
-
 static struct regulator_ops max77686_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
 	.map_voltage		= regulator_map_voltage_linear,
@@ -96,7 +78,7 @@ static struct regulator_ops max77686_ops = {
 	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
-	.set_voltage_time_sel	= max77686_set_voltage_time_sel,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 };
 
 static struct regulator_ops max77686_buck_dvs_ops = {
@@ -107,7 +89,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
-	.set_voltage_time_sel	= max77686_set_dvs_voltage_time_sel,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 };
 
 #define regulator_desc_ldo(num)		{				\
@@ -118,6 +100,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.owner		= THIS_MODULE,					\
 	.min_uV		= MAX77686_LDO_MINUV,				\
 	.uV_step	= MAX77686_LDO_UVSTEP,				\
+	.ramp_delay	= MAX77686_RAMP_DELAY,				\
 	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
 	.vsel_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
 	.vsel_mask	= MAX77686_VSEL_MASK,				\
@@ -133,6 +116,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.owner		= THIS_MODULE,					\
 	.min_uV		= MAX77686_LDO_LOW_MINUV,			\
 	.uV_step	= MAX77686_LDO_LOW_UVSTEP,			\
+	.ramp_delay	= MAX77686_RAMP_DELAY,				\
 	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
 	.vsel_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
 	.vsel_mask	= MAX77686_VSEL_MASK,				\
@@ -148,6 +132,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.owner		= THIS_MODULE,					\
 	.min_uV		= MAX77686_BUCK_MINUV,				\
 	.uV_step	= MAX77686_BUCK_UVSTEP,				\
+	.ramp_delay	= MAX77686_RAMP_DELAY,				\
 	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
 	.vsel_reg	= MAX77686_REG_BUCK5OUT + (num - 5) * 2,	\
 	.vsel_mask	= MAX77686_VSEL_MASK,				\
@@ -162,6 +147,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.owner		= THIS_MODULE,					\
 	.min_uV		= MAX77686_BUCK_MINUV,				\
 	.uV_step	= MAX77686_BUCK_UVSTEP,				\
+	.ramp_delay	= MAX77686_RAMP_DELAY,				\
 	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
 	.vsel_reg	= MAX77686_REG_BUCK1OUT,			\
 	.vsel_mask	= MAX77686_VSEL_MASK,				\
@@ -176,6 +162,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.owner		= THIS_MODULE,					\
 	.min_uV		= MAX77686_DVS_MINUV,				\
 	.uV_step	= MAX77686_DVS_UVSTEP,				\
+	.ramp_delay	= MAX77686_DVS_RAMP_DELAY,			\
 	.n_voltages	= MAX77686_DVS_VSEL_MASK + 1,			\
 	.vsel_reg	= MAX77686_REG_BUCK2DVS1 + (num - 2) * 10,	\
 	.vsel_mask	= MAX77686_DVS_VSEL_MASK,			\
@@ -255,17 +242,6 @@ static __devinit int max77686_pmic_probe(struct platform_device *pdev)
 	max77686->iodev = iodev;
 	platform_set_drvdata(pdev, max77686);
 
-	max77686->ramp_delay = RAMP_RATE_NO_CTRL; /* Set 0x3 for RAMP */
-	regmap_update_bits(max77686->iodev->regmap,
-			MAX77686_REG_BUCK2CTRL1, MAX77686_RAMP_RATE_MASK,
-			max77686->ramp_delay << 6);
-	regmap_update_bits(max77686->iodev->regmap,
-			MAX77686_REG_BUCK3CTRL1, MAX77686_RAMP_RATE_MASK,
-			max77686->ramp_delay << 6);
-	regmap_update_bits(max77686->iodev->regmap,
-			MAX77686_REG_BUCK4CTRL1, MAX77686_RAMP_RATE_MASK,
-			max77686->ramp_delay << 6);
-
 	for (i = 0; i < MAX77686_REGULATORS; i++) {
 		config.dev = max77686->dev;
 		config.regmap = iodev->regmap;
-- 
1.7.0.4

