Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab0LAHP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:15:57 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64927 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab0LAHP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:15:56 -0500
MIME-Version: 1.0
Date: Wed, 1 Dec 2010 15:15:55 +0800
Message-ID: <AANLkTi=E8etAOPTCBw8ccTZ9LMU-Yf=wELn+VQkg2eom@mail.gmail.com>
Subject: [PATCHv2] make mc13783 regulator code generic
From: Yong Shen <yong.shen@linaro.org>
To: Linaro Dev <linaro-dev@lists.linaro.org>,
        List Linux Arm Kernel <linux-arm-kernel@lists.infradead.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015174c36b284967a04965413ed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174c36b284967a04965413ed
Content-Type: text/plain; charset=ISO-8859-1

Hi there,

This is the v2 with some changes according to comments from v1. There
will be few patches coming out after this one, for mc13892 regulator
to share some code with mc13783.

Still, cause the firewall problem, I send out patch this way. Please
give comments inline and use attached patch for testing.

Yong

>From b3451070f4665c90f11e600a8722f86b68437ded Mon Sep 17 00:00:00 2001
From: Yong Shen <yong.shen@linaro.org>
Date: Tue, 30 Nov 2010 14:11:34 +0800
Subject: [PATCH] make mc13783 regulator code generic

move some common functions and micros of mc13783 regulaor driver to
a seperate file, which makes it possible for mc13892 to share code.

Signed-off-by: Yong Shen <yong.shen@linaro.org>
---
 drivers/regulator/Kconfig                  |    4 +
 drivers/regulator/Makefile                 |    1 +
 drivers/regulator/mc13783-regulator.c      |  325 ++++------------------------
 drivers/regulator/mc13xxx-regulator-core.c |  239 ++++++++++++++++++++
 include/linux/mfd/mc13783.h                |   67 +++---
 include/linux/regulator/mc13xxx.h          |  101 +++++++++
 6 files changed, 425 insertions(+), 312 deletions(-)
 create mode 100644 drivers/regulator/mc13xxx-regulator-core.c
 create mode 100644 include/linux/regulator/mc13xxx.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index dd30e88..63c2bdd 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -186,9 +186,13 @@ config REGULATOR_PCAP
 	 This driver provides support for the voltage regulators of the
 	 PCAP2 PMIC.

+config REGULATOR_MC13XXX_CORE
+	tristate "Support regulators on Freescale MC13xxx PMIC"
+
 config REGULATOR_MC13783
 	tristate "Support regulators on Freescale MC13783 PMIC"
 	depends on MFD_MC13783
+	select REGULATOR_MC13XXX_CORE
 	help
 	  Say y here to support the regulators found on the Freescale MC13783
 	  PMIC.
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index bff8157..11876be 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
 obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
+obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
 obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o

 obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
diff --git a/drivers/regulator/mc13783-regulator.c
b/drivers/regulator/mc13783-regulator.c
index 4597d50..0681960 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -1,6 +1,7 @@
 /*
  * Regulator Driver for Freescale MC13783 PMIC
  *
+ * Copyright 2010 Yong Shen <yong.shen@linaro.org>
  * Copyright (C) 2008 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
  * Copyright 2009 Alberto Panizzo <maramaopercheseimorto@gmail.com>
  *
@@ -10,6 +11,7 @@
  */

 #include <linux/mfd/mc13783.h>
+#include <linux/regulator/mc13xxx.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/driver.h>
 #include <linux/platform_device.h>
@@ -89,16 +91,6 @@
 #define MC13783_REG_POWERMISC_PWGTSPI_M			(3 << 15)


-struct mc13783_regulator {
-	struct regulator_desc desc;
-	int reg;
-	int enable_bit;
-	int vsel_reg;
-	int vsel_shift;
-	int vsel_mask;
-	int const *voltages;
-};
-
 /* Voltage Values */
 static const int const mc13783_sw3_val[] = {
 	5000000, 5000000, 5000000, 5500000,
@@ -175,64 +167,26 @@ static const int const mc13783_pwgtdrv_val[] = {
 	5500000,
 };

-static struct regulator_ops mc13783_regulator_ops;
-static struct regulator_ops mc13783_fixed_regulator_ops;
 static struct regulator_ops mc13783_gpo_regulator_ops;

-#define MC13783_DEFINE(prefix, _name, _reg, _vsel_reg, _voltages)	\
-	[MC13783_ ## prefix ## _ ## _name] = {				\
-		.desc = {						\
-			.name = #prefix "_" #_name,			\
-			.n_voltages = ARRAY_SIZE(_voltages),		\
-			.ops = &mc13783_regulator_ops,			\
-			.type = REGULATOR_VOLTAGE,			\
-			.id = MC13783_ ## prefix ## _ ## _name,		\
-			.owner = THIS_MODULE,				\
-		},							\
-		.reg = MC13783_REG_ ## _reg,				\
-		.enable_bit = MC13783_REG_ ## _reg ## _ ## _name ## EN,	\
-		.vsel_reg = MC13783_REG_ ## _vsel_reg,			\
-		.vsel_shift = MC13783_REG_ ## _vsel_reg ## _ ## _name ## VSEL,\
-		.vsel_mask = MC13783_REG_ ## _vsel_reg ## _ ## _name ## VSEL_M,\
-		.voltages =  _voltages,					\
-	}
+#define MC13783_DEFINE(prefix, name, reg, vsel_reg, voltages)	\
+	MC13xxx_DEFINE(MC13783_REG_, name, reg, vsel_reg, voltages, \
+			mc13xxx_regulator_ops)

-#define MC13783_FIXED_DEFINE(prefix, _name, _reg, _voltages)		\
-	[MC13783_ ## prefix ## _ ## _name] = {				\
-		.desc = {						\
-			.name = #prefix "_" #_name,			\
-			.n_voltages = ARRAY_SIZE(_voltages),		\
-			.ops = &mc13783_fixed_regulator_ops,		\
-			.type = REGULATOR_VOLTAGE,			\
-			.id = MC13783_ ## prefix ## _ ## _name,		\
-			.owner = THIS_MODULE,				\
-		},							\
-		.reg = MC13783_REG_ ## _reg,				\
-		.enable_bit = MC13783_REG_ ## _reg ## _ ## _name ## EN,	\
-		.voltages =  _voltages,					\
-	}
+#define MC13783_FIXED_DEFINE(prefix, name, reg, voltages)		\
+	MC13xxx_FIXED_DEFINE(MC13783_REG_, name, reg, voltages, \
+			mc13xxx_fixed_regulator_ops)

-#define MC13783_GPO_DEFINE(prefix, _name, _reg,  _voltages)		\
-	[MC13783_ ## prefix ## _ ## _name] = {				\
-		.desc = {						\
-			.name = #prefix "_" #_name,			\
-			.n_voltages = ARRAY_SIZE(_voltages),		\
-			.ops = &mc13783_gpo_regulator_ops,		\
-			.type = REGULATOR_VOLTAGE,			\
-			.id = MC13783_ ## prefix ## _ ## _name,		\
-			.owner = THIS_MODULE,				\
-		},							\
-		.reg = MC13783_REG_ ## _reg,				\
-		.enable_bit = MC13783_REG_ ## _reg ## _ ## _name ## EN,	\
-		.voltages =  _voltages,					\
-	}
+#define MC13783_GPO_DEFINE(prefix, name, reg, voltages)		\
+	MC13xxx_GPO_DEFINE(MC13783_REG_, name, reg, voltages, \
+			mc13783_gpo_regulator_ops)

 #define MC13783_DEFINE_SW(_name, _reg, _vsel_reg, _voltages)		\
 	MC13783_DEFINE(SW, _name, _reg, _vsel_reg, _voltages)
 #define MC13783_DEFINE_REGU(_name, _reg, _vsel_reg, _voltages)		\
 	MC13783_DEFINE(REGU, _name, _reg, _vsel_reg, _voltages)

-static struct mc13783_regulator mc13783_regulators[] = {
+static struct mc13xxx_regulator mc13783_regulators[] = {
 	MC13783_DEFINE_SW(SW3, SWITCHERS5, SWITCHERS5, mc13783_sw3_val),

 	MC13783_FIXED_DEFINE(REGU, VAUDIO, REGULATORMODE0, mc13783_vaudio_val),
@@ -274,207 +228,16 @@ static struct mc13783_regulator mc13783_regulators[] = {
 	MC13783_GPO_DEFINE(REGU, PWGT2SPI, POWERMISC, mc13783_pwgtdrv_val),
 };

-struct mc13783_regulator_priv {
-	struct mc13783 *mc13783;
-	u32 powermisc_pwgt_state;
-	struct regulator_dev *regulators[];
-};
-
-static int mc13783_regulator_enable(struct regulator_dev *rdev)
-{
-	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
-	int ret;
-
-	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
-
-	mc13783_lock(priv->mc13783);
-	ret = mc13783_reg_rmw(priv->mc13783, mc13783_regulators[id].reg,
-			mc13783_regulators[id].enable_bit,
-			mc13783_regulators[id].enable_bit);
-	mc13783_unlock(priv->mc13783);
-
-	return ret;
-}
-
-static int mc13783_regulator_disable(struct regulator_dev *rdev)
-{
-	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
-	int ret;
-
-	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
-
-	mc13783_lock(priv->mc13783);
-	ret = mc13783_reg_rmw(priv->mc13783, mc13783_regulators[id].reg,
-			mc13783_regulators[id].enable_bit, 0);
-	mc13783_unlock(priv->mc13783);
-
-	return ret;
-}
-
-static int mc13783_regulator_is_enabled(struct regulator_dev *rdev)
-{
-	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
-	int ret, id = rdev_get_id(rdev);
-	unsigned int val;
-
-	mc13783_lock(priv->mc13783);
-	ret = mc13783_reg_read(priv->mc13783, mc13783_regulators[id].reg, &val);
-	mc13783_unlock(priv->mc13783);
-
-	if (ret)
-		return ret;
-
-	return (val & mc13783_regulators[id].enable_bit) != 0;
-}
-
-static int mc13783_regulator_list_voltage(struct regulator_dev *rdev,
-						unsigned selector)
-{
-	int id = rdev_get_id(rdev);
-
-	if (selector >= mc13783_regulators[id].desc.n_voltages)
-		return -EINVAL;
-
-	return mc13783_regulators[id].voltages[selector];
-}
-
-static int mc13783_get_best_voltage_index(struct regulator_dev *rdev,
-						int min_uV, int max_uV)
-{
-	int reg_id = rdev_get_id(rdev);
-	int i;
-	int bestmatch;
-	int bestindex;
-
-	/*
-	 * Locate the minimum voltage fitting the criteria on
-	 * this regulator. The switchable voltages are not
-	 * in strict falling order so we need to check them
-	 * all for the best match.
-	 */
-	bestmatch = INT_MAX;
-	bestindex = -1;
-	for (i = 0; i < mc13783_regulators[reg_id].desc.n_voltages; i++) {
-		if (mc13783_regulators[reg_id].voltages[i] >= min_uV &&
-		    mc13783_regulators[reg_id].voltages[i] < bestmatch) {
-			bestmatch = mc13783_regulators[reg_id].voltages[i];
-			bestindex = i;
-		}
-	}
-
-	if (bestindex < 0 || bestmatch > max_uV) {
-		dev_warn(&rdev->dev, "no possible value for %d<=x<=%d uV\n",
-				min_uV, max_uV);
-		return -EINVAL;
-	}
-	return bestindex;
-}
-
-static int mc13783_regulator_set_voltage(struct regulator_dev *rdev,
-						int min_uV, int max_uV)
-{
-	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
-	int value, id = rdev_get_id(rdev);
-	int ret;
-
-	dev_dbg(rdev_get_dev(rdev), "%s id: %d min_uV: %d max_uV: %d\n",
-		__func__, id, min_uV, max_uV);
-
-	/* Find the best index */
-	value = mc13783_get_best_voltage_index(rdev, min_uV, max_uV);
-	dev_dbg(rdev_get_dev(rdev), "%s best value: %d \n", __func__, value);
-	if (value < 0)
-		return value;
-
-	mc13783_lock(priv->mc13783);
-	ret = mc13783_reg_rmw(priv->mc13783, mc13783_regulators[id].vsel_reg,
-			mc13783_regulators[id].vsel_mask,
-			value << mc13783_regulators[id].vsel_shift);
-	mc13783_unlock(priv->mc13783);
-
-	return ret;
-}
-
-static int mc13783_regulator_get_voltage(struct regulator_dev *rdev)
-{
-	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
-	int ret, id = rdev_get_id(rdev);
-	unsigned int val;
-
-	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
-
-	mc13783_lock(priv->mc13783);
-	ret = mc13783_reg_read(priv->mc13783,
-				mc13783_regulators[id].vsel_reg, &val);
-	mc13783_unlock(priv->mc13783);
-
-	if (ret)
-		return ret;
-
-	val = (val & mc13783_regulators[id].vsel_mask)
-		>> mc13783_regulators[id].vsel_shift;
-
-	dev_dbg(rdev_get_dev(rdev), "%s id: %d val: %d\n", __func__, id, val);
-
-	BUG_ON(val < 0 || val > mc13783_regulators[id].desc.n_voltages);
-
-	return mc13783_regulators[id].voltages[val];
-}
-
-static struct regulator_ops mc13783_regulator_ops = {
-	.enable = mc13783_regulator_enable,
-	.disable = mc13783_regulator_disable,
-	.is_enabled = mc13783_regulator_is_enabled,
-	.list_voltage = mc13783_regulator_list_voltage,
-	.set_voltage = mc13783_regulator_set_voltage,
-	.get_voltage = mc13783_regulator_get_voltage,
-};
-
-static int mc13783_fixed_regulator_set_voltage(struct regulator_dev *rdev,
-						int min_uV, int max_uV)
-{
-	int id = rdev_get_id(rdev);
-
-	dev_dbg(rdev_get_dev(rdev), "%s id: %d min_uV: %d max_uV: %d\n",
-		__func__, id, min_uV, max_uV);
-
-	if (min_uV >= mc13783_regulators[id].voltages[0] &&
-	    max_uV <= mc13783_regulators[id].voltages[0])
-		return 0;
-	else
-		return -EINVAL;
-}
-
-static int mc13783_fixed_regulator_get_voltage(struct regulator_dev *rdev)
-{
-	int id = rdev_get_id(rdev);
-
-	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
-
-	return mc13783_regulators[id].voltages[0];
-}
-
-static struct regulator_ops mc13783_fixed_regulator_ops = {
-	.enable = mc13783_regulator_enable,
-	.disable = mc13783_regulator_disable,
-	.is_enabled = mc13783_regulator_is_enabled,
-	.list_voltage = mc13783_regulator_list_voltage,
-	.set_voltage = mc13783_fixed_regulator_set_voltage,
-	.get_voltage = mc13783_fixed_regulator_get_voltage,
-};
-
-int mc13783_powermisc_rmw(struct mc13783_regulator_priv *priv, u32 mask,
+int mc13783_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
 									u32 val)
 {
-	struct mc13783 *mc13783 = priv->mc13783;
+	struct mc13xxx *mc13783 = priv->mc13xxx;
 	int ret;
 	u32 valread;

 	BUG_ON(val & ~mask);

-	ret = mc13783_reg_read(mc13783, MC13783_REG_POWERMISC, &valread);
+	ret = mc13xxx_reg_read(mc13783, MC13783_REG_POWERMISC, &valread);
 	if (ret)
 		return ret;

@@ -489,34 +252,36 @@ int mc13783_powermisc_rmw(struct
mc13783_regulator_priv *priv, u32 mask,
 	valread = (valread & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
 						priv->powermisc_pwgt_state;

-	return mc13783_reg_write(mc13783, MC13783_REG_POWERMISC, valread);
+	return mc13xxx_reg_write(mc13783, MC13783_REG_POWERMISC, valread);
 }

 static int mc13783_gpo_regulator_enable(struct regulator_dev *rdev)
 {
-	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
 	int id = rdev_get_id(rdev);
 	int ret;
-	u32 en_val = mc13783_regulators[id].enable_bit;
+	u32 en_val = mc13xxx_regulators[id].enable_bit;

 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);

 	/* Power Gate enable value is 0 */
-	if (id == MC13783_REGU_PWGT1SPI ||
-	    id == MC13783_REGU_PWGT2SPI)
+	if (id == MC13783_REG_PWGT1SPI ||
+	    id == MC13783_REG_PWGT2SPI)
 		en_val = 0;

-	mc13783_lock(priv->mc13783);
-	ret = mc13783_powermisc_rmw(priv, mc13783_regulators[id].enable_bit,
+	mc13xxx_lock(priv->mc13xxx);
+	ret = mc13783_powermisc_rmw(priv, mc13xxx_regulators[id].enable_bit,
 					en_val);
-	mc13783_unlock(priv->mc13783);
+	mc13xxx_unlock(priv->mc13xxx);

 	return ret;
 }

 static int mc13783_gpo_regulator_disable(struct regulator_dev *rdev)
 {
-	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
 	int id = rdev_get_id(rdev);
 	int ret;
 	u32 dis_val = 0;
@@ -524,27 +289,28 @@ static int mc13783_gpo_regulator_disable(struct
regulator_dev *rdev)
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);

 	/* Power Gate disable value is 1 */
-	if (id == MC13783_REGU_PWGT1SPI ||
-	    id == MC13783_REGU_PWGT2SPI)
-		dis_val = mc13783_regulators[id].enable_bit;
+	if (id == MC13783_REG_PWGT1SPI ||
+	    id == MC13783_REG_PWGT2SPI)
+		dis_val = mc13xxx_regulators[id].enable_bit;

-	mc13783_lock(priv->mc13783);
-	ret = mc13783_powermisc_rmw(priv, mc13783_regulators[id].enable_bit,
+	mc13xxx_lock(priv->mc13xxx);
+	ret = mc13783_powermisc_rmw(priv, mc13xxx_regulators[id].enable_bit,
 					dis_val);
-	mc13783_unlock(priv->mc13783);
+	mc13xxx_unlock(priv->mc13xxx);

 	return ret;
 }

 static int mc13783_gpo_regulator_is_enabled(struct regulator_dev *rdev)
 {
-	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
 	int ret, id = rdev_get_id(rdev);
 	unsigned int val;

-	mc13783_lock(priv->mc13783);
-	ret = mc13783_reg_read(priv->mc13783, mc13783_regulators[id].reg, &val);
-	mc13783_unlock(priv->mc13783);
+	mc13xxx_lock(priv->mc13xxx);
+	ret = mc13xxx_reg_read(priv->mc13xxx, mc13xxx_regulators[id].reg, &val);
+	mc13xxx_unlock(priv->mc13xxx);

 	if (ret)
 		return ret;
@@ -554,22 +320,22 @@ static int
mc13783_gpo_regulator_is_enabled(struct regulator_dev *rdev)
 	val = (val & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
 	      (priv->powermisc_pwgt_state ^ MC13783_REG_POWERMISC_PWGTSPI_M);

-	return (val & mc13783_regulators[id].enable_bit) != 0;
+	return (val & mc13xxx_regulators[id].enable_bit) != 0;
 }

 static struct regulator_ops mc13783_gpo_regulator_ops = {
 	.enable = mc13783_gpo_regulator_enable,
 	.disable = mc13783_gpo_regulator_disable,
 	.is_enabled = mc13783_gpo_regulator_is_enabled,
-	.list_voltage = mc13783_regulator_list_voltage,
-	.set_voltage = mc13783_fixed_regulator_set_voltage,
-	.get_voltage = mc13783_fixed_regulator_get_voltage,
+	.list_voltage = mc13xxx_regulator_list_voltage,
+	.set_voltage = mc13xxx_fixed_regulator_set_voltage,
+	.get_voltage = mc13xxx_fixed_regulator_get_voltage,
 };

 static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
 {
-	struct mc13783_regulator_priv *priv;
-	struct mc13783 *mc13783 = dev_get_drvdata(pdev->dev.parent);
+	struct mc13xxx_regulator_priv *priv;
+	struct mc13xxx *mc13783 = dev_get_drvdata(pdev->dev.parent);
 	struct mc13783_regulator_platform_data *pdata =
 		dev_get_platdata(&pdev->dev);
 	struct mc13783_regulator_init_data *init_data;
@@ -583,7 +349,8 @@ static int __devinit
mc13783_regulator_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;

-	priv->mc13783 = mc13783;
+	priv->mc13xxx_regulators = mc13783_regulators;
+	priv->mc13xxx = mc13783;

 	for (i = 0; i < pdata->num_regulators; i++) {
 		init_data = &pdata->regulators[i];
@@ -613,7 +380,7 @@ err:

 static int __devexit mc13783_regulator_remove(struct platform_device *pdev)
 {
-	struct mc13783_regulator_priv *priv = platform_get_drvdata(pdev);
+	struct mc13xxx_regulator_priv *priv = platform_get_drvdata(pdev);
 	struct mc13783_regulator_platform_data *pdata =
 		dev_get_platdata(&pdev->dev);
 	int i;
diff --git a/drivers/regulator/mc13xxx-regulator-core.c
b/drivers/regulator/mc13xxx-regulator-core.c
new file mode 100644
index 0000000..e7e0def
--- /dev/null
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -0,0 +1,239 @@
+/*
+ * Regulator Driver for Freescale MC13xxx PMIC
+ *
+ * Copyright 2010 Yong Shen <yong.shen@linaro.org>
+ *
+ * Based on mc13783 regulator driver :
+ * Copyright (C) 2008 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
+ * Copyright 2009 Alberto Panizzo <maramaopercheseimorto@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Regs infos taken from mc13xxx drivers from freescale and mc13xxx.pdf file
+ * from freescale
+ */
+
+#include <linux/mfd/mc13xxx.h>
+#include <linux/regulator/mc13xxx.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/driver.h>
+#include <linux/platform_device.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/err.h>
+
+static int mc13xxx_regulator_enable(struct regulator_dev *rdev)
+{
+	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
+	int id = rdev_get_id(rdev);
+	int ret;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+
+	mc13xxx_lock(priv->mc13xxx);
+	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].reg,
+			mc13xxx_regulators[id].enable_bit,
+			mc13xxx_regulators[id].enable_bit);
+	mc13xxx_unlock(priv->mc13xxx);
+
+	return ret;
+}
+
+static int mc13xxx_regulator_disable(struct regulator_dev *rdev)
+{
+	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
+	int id = rdev_get_id(rdev);
+	int ret;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+
+	mc13xxx_lock(priv->mc13xxx);
+	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].reg,
+			mc13xxx_regulators[id].enable_bit, 0);
+	mc13xxx_unlock(priv->mc13xxx);
+
+	return ret;
+}
+
+static int mc13xxx_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
+	int ret, id = rdev_get_id(rdev);
+	unsigned int val;
+
+	mc13xxx_lock(priv->mc13xxx);
+	ret = mc13xxx_reg_read(priv->mc13xxx, mc13xxx_regulators[id].reg, &val);
+	mc13xxx_unlock(priv->mc13xxx);
+
+	if (ret)
+		return ret;
+
+	return (val & mc13xxx_regulators[id].enable_bit) != 0;
+}
+
+int mc13xxx_regulator_list_voltage(struct regulator_dev *rdev,
+						unsigned selector)
+{
+	int id = rdev_get_id(rdev);
+	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
+
+	if (selector >= mc13xxx_regulators[id].desc.n_voltages)
+		return -EINVAL;
+
+	return mc13xxx_regulators[id].voltages[selector];
+}
+
+int mc13xxx_get_best_voltage_index(struct regulator_dev *rdev,
+						int min_uV, int max_uV)
+{
+	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
+	int reg_id = rdev_get_id(rdev);
+	int i;
+	int bestmatch;
+	int bestindex;
+
+	/*
+	 * Locate the minimum voltage fitting the criteria on
+	 * this regulator. The switchable voltages are not
+	 * in strict falling order so we need to check them
+	 * all for the best match.
+	 */
+	bestmatch = INT_MAX;
+	bestindex = -1;
+	for (i = 0; i < mc13xxx_regulators[reg_id].desc.n_voltages; i++) {
+		if (mc13xxx_regulators[reg_id].voltages[i] >= min_uV &&
+		    mc13xxx_regulators[reg_id].voltages[i] < bestmatch) {
+			bestmatch = mc13xxx_regulators[reg_id].voltages[i];
+			bestindex = i;
+		}
+	}
+
+	if (bestindex < 0 || bestmatch > max_uV) {
+		dev_warn(&rdev->dev, "no possible value for %d<=x<=%d uV\n",
+				min_uV, max_uV);
+		return -EINVAL;
+	}
+	return bestindex;
+}
+
+static int mc13xxx_regulator_set_voltage(struct regulator_dev *rdev,
+						int min_uV, int max_uV)
+{
+	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
+	int value, id = rdev_get_id(rdev);
+	int ret;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d min_uV: %d max_uV: %d\n",
+		__func__, id, min_uV, max_uV);
+
+	/* Find the best index */
+	value = mc13xxx_get_best_voltage_index(rdev, min_uV, max_uV);
+	dev_dbg(rdev_get_dev(rdev), "%s best value: %d\n", __func__, value);
+	if (value < 0)
+		return value;
+
+	mc13xxx_lock(priv->mc13xxx);
+	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].vsel_reg,
+			mc13xxx_regulators[id].vsel_mask,
+			value << mc13xxx_regulators[id].vsel_shift);
+	mc13xxx_unlock(priv->mc13xxx);
+
+	return ret;
+}
+
+static int mc13xxx_regulator_get_voltage(struct regulator_dev *rdev)
+{
+	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
+	int ret, id = rdev_get_id(rdev);
+	unsigned int val;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+
+	mc13xxx_lock(priv->mc13xxx);
+	ret = mc13xxx_reg_read(priv->mc13xxx,
+				mc13xxx_regulators[id].vsel_reg, &val);
+	mc13xxx_unlock(priv->mc13xxx);
+
+	if (ret)
+		return ret;
+
+	val = (val & mc13xxx_regulators[id].vsel_mask)
+		>> mc13xxx_regulators[id].vsel_shift;
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d val: %d\n", __func__, id, val);
+
+	BUG_ON(val < 0 || val > mc13xxx_regulators[id].desc.n_voltages);
+
+	return mc13xxx_regulators[id].voltages[val];
+}
+
+struct regulator_ops mc13xxx_regulator_ops = {
+	.enable = mc13xxx_regulator_enable,
+	.disable = mc13xxx_regulator_disable,
+	.is_enabled = mc13xxx_regulator_is_enabled,
+	.list_voltage = mc13xxx_regulator_list_voltage,
+	.set_voltage = mc13xxx_regulator_set_voltage,
+	.get_voltage = mc13xxx_regulator_get_voltage,
+};
+
+int mc13xxx_fixed_regulator_set_voltage(struct regulator_dev *rdev,
+						int min_uV, int max_uV)
+{
+	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
+	int id = rdev_get_id(rdev);
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d min_uV: %d max_uV: %d\n",
+		__func__, id, min_uV, max_uV);
+
+	if (min_uV >= mc13xxx_regulators[id].voltages[0] &&
+	    max_uV <= mc13xxx_regulators[id].voltages[0])
+		return 0;
+	else
+		return -EINVAL;
+}
+
+int mc13xxx_fixed_regulator_get_voltage(struct regulator_dev *rdev)
+{
+	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
+	int id = rdev_get_id(rdev);
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+
+	return mc13xxx_regulators[id].voltages[0];
+}
+
+struct regulator_ops mc13xxx_fixed_regulator_ops = {
+	.enable = mc13xxx_regulator_enable,
+	.disable = mc13xxx_regulator_disable,
+	.is_enabled = mc13xxx_regulator_is_enabled,
+	.list_voltage = mc13xxx_regulator_list_voltage,
+	.set_voltage = mc13xxx_fixed_regulator_set_voltage,
+	.get_voltage = mc13xxx_fixed_regulator_get_voltage,
+};
+
+int mc13xxx_sw_regulator(struct regulator_dev *rdev)
+{
+	return 0;
+}
+
+int mc13xxx_sw_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	return 1;
+}
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Yong Shen <yong.shen@linaro.org>");
+MODULE_DESCRIPTION("Regulator Driver for Freescale MC13xxx PMIC");
+MODULE_ALIAS("platform:mc13xxx-regulator-core");
diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
index b4c741e..7d0f3d6 100644
--- a/include/linux/mfd/mc13783.h
+++ b/include/linux/mfd/mc13783.h
@@ -1,4 +1,5 @@
 /*
+ * Copyright 2010 Yong Shen <yong.shen@linaro.org>
  * Copyright 2009-2010 Pengutronix
  * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
  *
@@ -122,39 +123,39 @@ int mc13783_adc_do_conversion(struct mc13783
*mc13783, unsigned int mode,
 		unsigned int channel, unsigned int *sample);


-#define	MC13783_SW_SW1A		0
-#define	MC13783_SW_SW1B		1
-#define	MC13783_SW_SW2A		2
-#define	MC13783_SW_SW2B		3
-#define	MC13783_SW_SW3		4
-#define	MC13783_SW_PLL		5
-#define	MC13783_REGU_VAUDIO	6
-#define	MC13783_REGU_VIOHI	7
-#define	MC13783_REGU_VIOLO	8
-#define	MC13783_REGU_VDIG	9
-#define	MC13783_REGU_VGEN	10
-#define	MC13783_REGU_VRFDIG	11
-#define	MC13783_REGU_VRFREF	12
-#define	MC13783_REGU_VRFCP	13
-#define	MC13783_REGU_VSIM	14
-#define	MC13783_REGU_VESIM	15
-#define	MC13783_REGU_VCAM	16
-#define	MC13783_REGU_VRFBG	17
-#define	MC13783_REGU_VVIB	18
-#define	MC13783_REGU_VRF1	19
-#define	MC13783_REGU_VRF2	20
-#define	MC13783_REGU_VMMC1	21
-#define	MC13783_REGU_VMMC2	22
-#define	MC13783_REGU_GPO1	23
-#define	MC13783_REGU_GPO2	24
-#define	MC13783_REGU_GPO3	25
-#define	MC13783_REGU_GPO4	26
-#define	MC13783_REGU_V1		27
-#define	MC13783_REGU_V2		28
-#define	MC13783_REGU_V3		29
-#define	MC13783_REGU_V4		30
-#define	MC13783_REGU_PWGT1SPI	31
-#define	MC13783_REGU_PWGT2SPI	32
+#define	MC13783_REG_SW1A		0
+#define	MC13783_REG_SW1B		1
+#define	MC13783_REG_SW2A		2
+#define	MC13783_REG_SW2B		3
+#define	MC13783_REG_SW3		4
+#define	MC13783_REG_PLL		5
+#define	MC13783_REG_VAUDIO	6
+#define	MC13783_REG_VIOHI	7
+#define	MC13783_REG_VIOLO	8
+#define	MC13783_REG_VDIG	9
+#define	MC13783_REG_VGEN	10
+#define	MC13783_REG_VRFDIG	11
+#define	MC13783_REG_VRFREF	12
+#define	MC13783_REG_VRFCP	13
+#define	MC13783_REG_VSIM	14
+#define	MC13783_REG_VESIM	15
+#define	MC13783_REG_VCAM	16
+#define	MC13783_REG_VRFBG	17
+#define	MC13783_REG_VVIB	18
+#define	MC13783_REG_VRF1	19
+#define	MC13783_REG_VRF2	20
+#define	MC13783_REG_VMMC1	21
+#define	MC13783_REG_VMMC2	22
+#define	MC13783_REG_GPO1	23
+#define	MC13783_REG_GPO2	24
+#define	MC13783_REG_GPO3	25
+#define	MC13783_REG_GPO4	26
+#define	MC13783_REG_V1		27
+#define	MC13783_REG_V2		28
+#define	MC13783_REG_V3		29
+#define	MC13783_REG_V4		30
+#define	MC13783_REG_PWGT1SPI	31
+#define	MC13783_REG_PWGT2SPI	32

 #define MC13783_IRQ_ADCDONE	MC13XXX_IRQ_ADCDONE
 #define MC13783_IRQ_ADCBISDONE	MC13XXX_IRQ_ADCBISDONE
diff --git a/include/linux/regulator/mc13xxx.h
b/include/linux/regulator/mc13xxx.h
new file mode 100644
index 0000000..a60c9be
--- /dev/null
+++ b/include/linux/regulator/mc13xxx.h
@@ -0,0 +1,101 @@
+/*
+ * mc13xxx.h - regulators for the Freescale mc13xxx PMIC
+ *
+ *  Copyright (C) 2010 Yong Shen <yong.shen@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __LINUX_REGULATOR_MC13XXX_H
+#define __LINUX_REGULATOR_MC13XXX_H
+
+#include <linux/regulator/driver.h>
+
+struct mc13xxx_regulator {
+	struct regulator_desc desc;
+	int reg;
+	int enable_bit;
+	int vsel_reg;
+	int vsel_shift;
+	int vsel_mask;
+	int hi_bit;
+	int const *voltages;
+};
+
+struct mc13xxx_regulator_priv {
+	struct mc13xxx *mc13xxx;
+	u32 powermisc_pwgt_state;
+	struct mc13xxx_regulator *mc13xxx_regulators;
+	struct regulator_dev *regulators[];
+};
+
+extern int mc13xxx_sw_regulator(struct regulator_dev *rdev);
+extern int mc13xxx_sw_regulator_is_enabled(struct regulator_dev *rdev);
+extern int mc13xxx_get_best_voltage_index(struct regulator_dev *rdev,
+						int min_uV, int max_uV);
+extern int mc13xxx_regulator_list_voltage(struct regulator_dev *rdev,
+						unsigned selector);
+extern int mc13xxx_fixed_regulator_set_voltage(struct regulator_dev *rdev,
+						int min_uV, int max_uV);
+extern int mc13xxx_fixed_regulator_get_voltage(struct regulator_dev *rdev);
+
+extern struct regulator_ops mc13xxx_regulator_ops;
+extern struct regulator_ops mc13xxx_fixed_regulator_ops;
+
+#define MC13xxx_DEFINE(prefix, _name, _reg, _vsel_reg, _voltages, _ops)	\
+	[prefix ## _name] = {				\
+		.desc = {						\
+			.name = #prefix "_" #_name,			\
+			.n_voltages = ARRAY_SIZE(_voltages),		\
+			.ops = &_ops,			\
+			.type = REGULATOR_VOLTAGE,			\
+			.id = prefix ## _name,		\
+			.owner = THIS_MODULE,				\
+		},							\
+		.reg = prefix ## _reg,				\
+		.enable_bit = prefix ## _reg ## _ ## _name ## EN,	\
+		.vsel_reg = prefix ## _vsel_reg,			\
+		.vsel_shift = prefix ## _vsel_reg ## _ ## _name ## VSEL,\
+		.vsel_mask = prefix ## _vsel_reg ## _ ## _name ## VSEL_M,\
+		.voltages =  _voltages,					\
+	}
+
+#define MC13xxx_FIXED_DEFINE(prefix, _name, _reg, _voltages, _ops)	\
+	[prefix ## _name] = {				\
+		.desc = {						\
+			.name = #prefix "_" #_name,			\
+			.n_voltages = ARRAY_SIZE(_voltages),		\
+			.ops = &_ops,		\
+			.type = REGULATOR_VOLTAGE,			\
+			.id = prefix ## _name,		\
+			.owner = THIS_MODULE,				\
+		},							\
+		.reg = prefix ## _reg,				\
+		.enable_bit = prefix ## _reg ## _ ## _name ## EN,	\
+		.voltages =  _voltages,					\
+	}
+
+#define MC13xxx_GPO_DEFINE(prefix, _name, _reg,  _voltages, _ops)	\
+	[prefix ## _name] = {				\
+		.desc = {						\
+			.name = #prefix "_" #_name,			\
+			.n_voltages = ARRAY_SIZE(_voltages),		\
+			.ops = &_ops,		\
+			.type = REGULATOR_VOLTAGE,			\
+			.id = prefix ## _name,		\
+			.owner = THIS_MODULE,				\
+		},							\
+		.reg = prefix ## _reg,				\
+		.enable_bit = prefix ## _reg ## _ ## _name ## EN,	\
+		.voltages =  _voltages,					\
+	}
+
+#define MC13xxx_DEFINE_SW(_name, _reg, _vsel_reg, _voltages, ops)	\
+	MC13xxx_DEFINE(SW, _name, _reg, _vsel_reg, _voltages, ops)
+#define MC13xxx_DEFINE_REGU(_name, _reg, _vsel_reg, _voltages, ops)	\
+	MC13xxx_DEFINE(REGU, _name, _reg, _vsel_reg, _voltages, ops)
+
+#endif
-- 
1.7.0.4

Cheers
Yong

--0015174c36b284967a04965413ed
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-make-mc13783-regulator-code-generic.patch"
Content-Disposition: attachment; 
	filename="0001-make-mc13783-regulator-code-generic.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gh5vni5a0

RnJvbSBiMzQ1MTA3MGY0NjY1YzkwZjExZTYwMGE4NzIyZjg2YjY4NDM3ZGVkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZb25nIFNoZW4gPHlvbmcuc2hlbkBsaW5hcm8ub3JnPgpEYXRl
OiBUdWUsIDMwIE5vdiAyMDEwIDE0OjExOjM0ICswODAwClN1YmplY3Q6IFtQQVRDSF0gbWFrZSBt
YzEzNzgzIHJlZ3VsYXRvciBjb2RlIGdlbmVyaWMKCm1vdmUgc29tZSBjb21tb24gZnVuY3Rpb25z
IGFuZCBtaWNyb3Mgb2YgbWMxMzc4MyByZWd1bGFvciBkcml2ZXIgdG8KYSBzZXBlcmF0ZSBmaWxl
LCB3aGljaCBtYWtlcyBpdCBwb3NzaWJsZSBmb3IgbWMxMzg5MiB0byBzaGFyZSBjb2RlLgoKU2ln
bmVkLW9mZi1ieTogWW9uZyBTaGVuIDx5b25nLnNoZW5AbGluYXJvLm9yZz4KLS0tCiBkcml2ZXJz
L3JlZ3VsYXRvci9LY29uZmlnICAgICAgICAgICAgICAgICAgfCAgICA0ICsKIGRyaXZlcnMvcmVn
dWxhdG9yL01ha2VmaWxlICAgICAgICAgICAgICAgICB8ICAgIDEgKwogZHJpdmVycy9yZWd1bGF0
b3IvbWMxMzc4My1yZWd1bGF0b3IuYyAgICAgIHwgIDMyNSArKysrLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tCiBkcml2ZXJzL3JlZ3VsYXRvci9tYzEzeHh4LXJlZ3VsYXRvci1jb3JlLmMgfCAgMjM5
ICsrKysrKysrKysrKysrKysrKysrCiBpbmNsdWRlL2xpbnV4L21mZC9tYzEzNzgzLmggICAgICAg
ICAgICAgICAgfCAgIDY3ICsrKy0tLQogaW5jbHVkZS9saW51eC9yZWd1bGF0b3IvbWMxM3h4eC5o
ICAgICAgICAgIHwgIDEwMSArKysrKysrKysKIDYgZmlsZXMgY2hhbmdlZCwgNDI1IGluc2VydGlv
bnMoKyksIDMxMiBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL3JlZ3Vs
YXRvci9tYzEzeHh4LXJlZ3VsYXRvci1jb3JlLmMKIGNyZWF0ZSBtb2RlIDEwMDY0NCBpbmNsdWRl
L2xpbnV4L3JlZ3VsYXRvci9tYzEzeHh4LmgKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3JlZ3VsYXRv
ci9LY29uZmlnIGIvZHJpdmVycy9yZWd1bGF0b3IvS2NvbmZpZwppbmRleCBkZDMwZTg4Li42M2My
YmRkIDEwMDY0NAotLS0gYS9kcml2ZXJzL3JlZ3VsYXRvci9LY29uZmlnCisrKyBiL2RyaXZlcnMv
cmVndWxhdG9yL0tjb25maWcKQEAgLTE4Niw5ICsxODYsMTMgQEAgY29uZmlnIFJFR1VMQVRPUl9Q
Q0FQCiAJIFRoaXMgZHJpdmVyIHByb3ZpZGVzIHN1cHBvcnQgZm9yIHRoZSB2b2x0YWdlIHJlZ3Vs
YXRvcnMgb2YgdGhlCiAJIFBDQVAyIFBNSUMuCiAKK2NvbmZpZyBSRUdVTEFUT1JfTUMxM1hYWF9D
T1JFCisJdHJpc3RhdGUgIlN1cHBvcnQgcmVndWxhdG9ycyBvbiBGcmVlc2NhbGUgTUMxM3h4eCBQ
TUlDIgorCiBjb25maWcgUkVHVUxBVE9SX01DMTM3ODMKIAl0cmlzdGF0ZSAiU3VwcG9ydCByZWd1
bGF0b3JzIG9uIEZyZWVzY2FsZSBNQzEzNzgzIFBNSUMiCiAJZGVwZW5kcyBvbiBNRkRfTUMxMzc4
MworCXNlbGVjdCBSRUdVTEFUT1JfTUMxM1hYWF9DT1JFCiAJaGVscAogCSAgU2F5IHkgaGVyZSB0
byBzdXBwb3J0IHRoZSByZWd1bGF0b3JzIGZvdW5kIG9uIHRoZSBGcmVlc2NhbGUgTUMxMzc4Mwog
CSAgUE1JQy4KZGlmZiAtLWdpdCBhL2RyaXZlcnMvcmVndWxhdG9yL01ha2VmaWxlIGIvZHJpdmVy
cy9yZWd1bGF0b3IvTWFrZWZpbGUKaW5kZXggYmZmODE1Ny4uMTE4NzZiZSAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9yZWd1bGF0b3IvTWFrZWZpbGUKKysrIGIvZHJpdmVycy9yZWd1bGF0b3IvTWFrZWZp
bGUKQEAgLTMwLDYgKzMwLDcgQEAgb2JqLSQoQ09ORklHX1JFR1VMQVRPUl9EQTkwM1gpCSs9IGRh
OTAzeC5vCiBvYmotJChDT05GSUdfUkVHVUxBVE9SX1BDRjUwNjMzKSArPSBwY2Y1MDYzMy1yZWd1
bGF0b3Iubwogb2JqLSQoQ09ORklHX1JFR1VMQVRPUl9QQ0FQKSArPSBwY2FwLXJlZ3VsYXRvci5v
CiBvYmotJChDT05GSUdfUkVHVUxBVE9SX01DMTM3ODMpICs9IG1jMTM3ODMtcmVndWxhdG9yLm8K
K29iai0kKENPTkZJR19SRUdVTEFUT1JfTUMxM1hYWF9DT1JFKSArPSAgbWMxM3h4eC1yZWd1bGF0
b3ItY29yZS5vCiBvYmotJChDT05GSUdfUkVHVUxBVE9SX0FCMzEwMCkgKz0gYWIzMTAwLm8KIAog
b2JqLSQoQ09ORklHX1JFR1VMQVRPUl9UUFM2NTAyMykgKz0gdHBzNjUwMjMtcmVndWxhdG9yLm8K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcmVndWxhdG9yL21jMTM3ODMtcmVndWxhdG9yLmMgYi9kcml2
ZXJzL3JlZ3VsYXRvci9tYzEzNzgzLXJlZ3VsYXRvci5jCmluZGV4IDQ1OTdkNTAuLjA2ODE5NjAg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcmVndWxhdG9yL21jMTM3ODMtcmVndWxhdG9yLmMKKysrIGIv
ZHJpdmVycy9yZWd1bGF0b3IvbWMxMzc4My1yZWd1bGF0b3IuYwpAQCAtMSw2ICsxLDcgQEAKIC8q
CiAgKiBSZWd1bGF0b3IgRHJpdmVyIGZvciBGcmVlc2NhbGUgTUMxMzc4MyBQTUlDCiAgKgorICog
Q29weXJpZ2h0IDIwMTAgWW9uZyBTaGVuIDx5b25nLnNoZW5AbGluYXJvLm9yZz4KICAqIENvcHly
aWdodCAoQykgMjAwOCBTYXNjaGEgSGF1ZXIsIFBlbmd1dHJvbml4IDxzLmhhdWVyQHBlbmd1dHJv
bml4LmRlPgogICogQ29weXJpZ2h0IDIwMDkgQWxiZXJ0byBQYW5penpvIDxtYXJhbWFvcGVyY2hl
c2VpbW9ydG9AZ21haWwuY29tPgogICoKQEAgLTEwLDYgKzExLDcgQEAKICAqLwogCiAjaW5jbHVk
ZSA8bGludXgvbWZkL21jMTM3ODMuaD4KKyNpbmNsdWRlIDxsaW51eC9yZWd1bGF0b3IvbWMxM3h4
eC5oPgogI2luY2x1ZGUgPGxpbnV4L3JlZ3VsYXRvci9tYWNoaW5lLmg+CiAjaW5jbHVkZSA8bGlu
dXgvcmVndWxhdG9yL2RyaXZlci5oPgogI2luY2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2RldmljZS5o
PgpAQCAtODksMTYgKzkxLDYgQEAKICNkZWZpbmUgTUMxMzc4M19SRUdfUE9XRVJNSVNDX1BXR1RT
UElfTQkJCSgzIDw8IDE1KQogCiAKLXN0cnVjdCBtYzEzNzgzX3JlZ3VsYXRvciB7Ci0Jc3RydWN0
IHJlZ3VsYXRvcl9kZXNjIGRlc2M7Ci0JaW50IHJlZzsKLQlpbnQgZW5hYmxlX2JpdDsKLQlpbnQg
dnNlbF9yZWc7Ci0JaW50IHZzZWxfc2hpZnQ7Ci0JaW50IHZzZWxfbWFzazsKLQlpbnQgY29uc3Qg
KnZvbHRhZ2VzOwotfTsKLQogLyogVm9sdGFnZSBWYWx1ZXMgKi8KIHN0YXRpYyBjb25zdCBpbnQg
Y29uc3QgbWMxMzc4M19zdzNfdmFsW10gPSB7CiAJNTAwMDAwMCwgNTAwMDAwMCwgNTAwMDAwMCwg
NTUwMDAwMCwKQEAgLTE3NSw2NCArMTY3LDI2IEBAIHN0YXRpYyBjb25zdCBpbnQgY29uc3QgbWMx
Mzc4M19wd2d0ZHJ2X3ZhbFtdID0gewogCTU1MDAwMDAsCiB9OwogCi1zdGF0aWMgc3RydWN0IHJl
Z3VsYXRvcl9vcHMgbWMxMzc4M19yZWd1bGF0b3Jfb3BzOwotc3RhdGljIHN0cnVjdCByZWd1bGF0
b3Jfb3BzIG1jMTM3ODNfZml4ZWRfcmVndWxhdG9yX29wczsKIHN0YXRpYyBzdHJ1Y3QgcmVndWxh
dG9yX29wcyBtYzEzNzgzX2dwb19yZWd1bGF0b3Jfb3BzOwogCi0jZGVmaW5lIE1DMTM3ODNfREVG
SU5FKHByZWZpeCwgX25hbWUsIF9yZWcsIF92c2VsX3JlZywgX3ZvbHRhZ2VzKQlcCi0JW01DMTM3
ODNfICMjIHByZWZpeCAjIyBfICMjIF9uYW1lXSA9IHsJCQkJXAotCQkuZGVzYyA9IHsJCQkJCQlc
Ci0JCQkubmFtZSA9ICNwcmVmaXggIl8iICNfbmFtZSwJCQlcCi0JCQkubl92b2x0YWdlcyA9IEFS
UkFZX1NJWkUoX3ZvbHRhZ2VzKSwJCVwKLQkJCS5vcHMgPSAmbWMxMzc4M19yZWd1bGF0b3Jfb3Bz
LAkJCVwKLQkJCS50eXBlID0gUkVHVUxBVE9SX1ZPTFRBR0UsCQkJXAotCQkJLmlkID0gTUMxMzc4
M18gIyMgcHJlZml4ICMjIF8gIyMgX25hbWUsCQlcCi0JCQkub3duZXIgPSBUSElTX01PRFVMRSwJ
CQkJXAotCQl9LAkJCQkJCQlcCi0JCS5yZWcgPSBNQzEzNzgzX1JFR18gIyMgX3JlZywJCQkJXAot
CQkuZW5hYmxlX2JpdCA9IE1DMTM3ODNfUkVHXyAjIyBfcmVnICMjIF8gIyMgX25hbWUgIyMgRU4s
CVwKLQkJLnZzZWxfcmVnID0gTUMxMzc4M19SRUdfICMjIF92c2VsX3JlZywJCQlcCi0JCS52c2Vs
X3NoaWZ0ID0gTUMxMzc4M19SRUdfICMjIF92c2VsX3JlZyAjIyBfICMjIF9uYW1lICMjIFZTRUws
XAotCQkudnNlbF9tYXNrID0gTUMxMzc4M19SRUdfICMjIF92c2VsX3JlZyAjIyBfICMjIF9uYW1l
ICMjIFZTRUxfTSxcCi0JCS52b2x0YWdlcyA9ICBfdm9sdGFnZXMsCQkJCQlcCi0JfQorI2RlZmlu
ZSBNQzEzNzgzX0RFRklORShwcmVmaXgsIG5hbWUsIHJlZywgdnNlbF9yZWcsIHZvbHRhZ2VzKQlc
CisJTUMxM3h4eF9ERUZJTkUoTUMxMzc4M19SRUdfLCBuYW1lLCByZWcsIHZzZWxfcmVnLCB2b2x0
YWdlcywgXAorCQkJbWMxM3h4eF9yZWd1bGF0b3Jfb3BzKQogCi0jZGVmaW5lIE1DMTM3ODNfRklY
RURfREVGSU5FKHByZWZpeCwgX25hbWUsIF9yZWcsIF92b2x0YWdlcykJCVwKLQlbTUMxMzc4M18g
IyMgcHJlZml4ICMjIF8gIyMgX25hbWVdID0gewkJCQlcCi0JCS5kZXNjID0gewkJCQkJCVwKLQkJ
CS5uYW1lID0gI3ByZWZpeCAiXyIgI19uYW1lLAkJCVwKLQkJCS5uX3ZvbHRhZ2VzID0gQVJSQVlf
U0laRShfdm9sdGFnZXMpLAkJXAotCQkJLm9wcyA9ICZtYzEzNzgzX2ZpeGVkX3JlZ3VsYXRvcl9v
cHMsCQlcCi0JCQkudHlwZSA9IFJFR1VMQVRPUl9WT0xUQUdFLAkJCVwKLQkJCS5pZCA9IE1DMTM3
ODNfICMjIHByZWZpeCAjIyBfICMjIF9uYW1lLAkJXAotCQkJLm93bmVyID0gVEhJU19NT0RVTEUs
CQkJCVwKLQkJfSwJCQkJCQkJXAotCQkucmVnID0gTUMxMzc4M19SRUdfICMjIF9yZWcsCQkJCVwK
LQkJLmVuYWJsZV9iaXQgPSBNQzEzNzgzX1JFR18gIyMgX3JlZyAjIyBfICMjIF9uYW1lICMjIEVO
LAlcCi0JCS52b2x0YWdlcyA9ICBfdm9sdGFnZXMsCQkJCQlcCi0JfQorI2RlZmluZSBNQzEzNzgz
X0ZJWEVEX0RFRklORShwcmVmaXgsIG5hbWUsIHJlZywgdm9sdGFnZXMpCQlcCisJTUMxM3h4eF9G
SVhFRF9ERUZJTkUoTUMxMzc4M19SRUdfLCBuYW1lLCByZWcsIHZvbHRhZ2VzLCBcCisJCQltYzEz
eHh4X2ZpeGVkX3JlZ3VsYXRvcl9vcHMpCiAKLSNkZWZpbmUgTUMxMzc4M19HUE9fREVGSU5FKHBy
ZWZpeCwgX25hbWUsIF9yZWcsICBfdm9sdGFnZXMpCQlcCi0JW01DMTM3ODNfICMjIHByZWZpeCAj
IyBfICMjIF9uYW1lXSA9IHsJCQkJXAotCQkuZGVzYyA9IHsJCQkJCQlcCi0JCQkubmFtZSA9ICNw
cmVmaXggIl8iICNfbmFtZSwJCQlcCi0JCQkubl92b2x0YWdlcyA9IEFSUkFZX1NJWkUoX3ZvbHRh
Z2VzKSwJCVwKLQkJCS5vcHMgPSAmbWMxMzc4M19ncG9fcmVndWxhdG9yX29wcywJCVwKLQkJCS50
eXBlID0gUkVHVUxBVE9SX1ZPTFRBR0UsCQkJXAotCQkJLmlkID0gTUMxMzc4M18gIyMgcHJlZml4
ICMjIF8gIyMgX25hbWUsCQlcCi0JCQkub3duZXIgPSBUSElTX01PRFVMRSwJCQkJXAotCQl9LAkJ
CQkJCQlcCi0JCS5yZWcgPSBNQzEzNzgzX1JFR18gIyMgX3JlZywJCQkJXAotCQkuZW5hYmxlX2Jp
dCA9IE1DMTM3ODNfUkVHXyAjIyBfcmVnICMjIF8gIyMgX25hbWUgIyMgRU4sCVwKLQkJLnZvbHRh
Z2VzID0gIF92b2x0YWdlcywJCQkJCVwKLQl9CisjZGVmaW5lIE1DMTM3ODNfR1BPX0RFRklORShw
cmVmaXgsIG5hbWUsIHJlZywgdm9sdGFnZXMpCQlcCisJTUMxM3h4eF9HUE9fREVGSU5FKE1DMTM3
ODNfUkVHXywgbmFtZSwgcmVnLCB2b2x0YWdlcywgXAorCQkJbWMxMzc4M19ncG9fcmVndWxhdG9y
X29wcykKIAogI2RlZmluZSBNQzEzNzgzX0RFRklORV9TVyhfbmFtZSwgX3JlZywgX3ZzZWxfcmVn
LCBfdm9sdGFnZXMpCQlcCiAJTUMxMzc4M19ERUZJTkUoU1csIF9uYW1lLCBfcmVnLCBfdnNlbF9y
ZWcsIF92b2x0YWdlcykKICNkZWZpbmUgTUMxMzc4M19ERUZJTkVfUkVHVShfbmFtZSwgX3JlZywg
X3ZzZWxfcmVnLCBfdm9sdGFnZXMpCQlcCiAJTUMxMzc4M19ERUZJTkUoUkVHVSwgX25hbWUsIF9y
ZWcsIF92c2VsX3JlZywgX3ZvbHRhZ2VzKQogCi1zdGF0aWMgc3RydWN0IG1jMTM3ODNfcmVndWxh
dG9yIG1jMTM3ODNfcmVndWxhdG9yc1tdID0geworc3RhdGljIHN0cnVjdCBtYzEzeHh4X3JlZ3Vs
YXRvciBtYzEzNzgzX3JlZ3VsYXRvcnNbXSA9IHsKIAlNQzEzNzgzX0RFRklORV9TVyhTVzMsIFNX
SVRDSEVSUzUsIFNXSVRDSEVSUzUsIG1jMTM3ODNfc3czX3ZhbCksCiAKIAlNQzEzNzgzX0ZJWEVE
X0RFRklORShSRUdVLCBWQVVESU8sIFJFR1VMQVRPUk1PREUwLCBtYzEzNzgzX3ZhdWRpb192YWwp
LApAQCAtMjc0LDIwNyArMjI4LDE2IEBAIHN0YXRpYyBzdHJ1Y3QgbWMxMzc4M19yZWd1bGF0b3Ig
bWMxMzc4M19yZWd1bGF0b3JzW10gPSB7CiAJTUMxMzc4M19HUE9fREVGSU5FKFJFR1UsIFBXR1Qy
U1BJLCBQT1dFUk1JU0MsIG1jMTM3ODNfcHdndGRydl92YWwpLAogfTsKIAotc3RydWN0IG1jMTM3
ODNfcmVndWxhdG9yX3ByaXYgewotCXN0cnVjdCBtYzEzNzgzICptYzEzNzgzOwotCXUzMiBwb3dl
cm1pc2NfcHdndF9zdGF0ZTsKLQlzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmVndWxhdG9yc1tdOwot
fTsKLQotc3RhdGljIGludCBtYzEzNzgzX3JlZ3VsYXRvcl9lbmFibGUoc3RydWN0IHJlZ3VsYXRv
cl9kZXYgKnJkZXYpCi17Ci0Jc3RydWN0IG1jMTM3ODNfcmVndWxhdG9yX3ByaXYgKnByaXYgPSBy
ZGV2X2dldF9kcnZkYXRhKHJkZXYpOwotCWludCBpZCA9IHJkZXZfZ2V0X2lkKHJkZXYpOwotCWlu
dCByZXQ7Ci0KLQlkZXZfZGJnKHJkZXZfZ2V0X2RldihyZGV2KSwgIiVzIGlkOiAlZFxuIiwgX19m
dW5jX18sIGlkKTsKLQotCW1jMTM3ODNfbG9jayhwcml2LT5tYzEzNzgzKTsKLQlyZXQgPSBtYzEz
NzgzX3JlZ19ybXcocHJpdi0+bWMxMzc4MywgbWMxMzc4M19yZWd1bGF0b3JzW2lkXS5yZWcsCi0J
CQltYzEzNzgzX3JlZ3VsYXRvcnNbaWRdLmVuYWJsZV9iaXQsCi0JCQltYzEzNzgzX3JlZ3VsYXRv
cnNbaWRdLmVuYWJsZV9iaXQpOwotCW1jMTM3ODNfdW5sb2NrKHByaXYtPm1jMTM3ODMpOwotCi0J
cmV0dXJuIHJldDsKLX0KLQotc3RhdGljIGludCBtYzEzNzgzX3JlZ3VsYXRvcl9kaXNhYmxlKHN0
cnVjdCByZWd1bGF0b3JfZGV2ICpyZGV2KQotewotCXN0cnVjdCBtYzEzNzgzX3JlZ3VsYXRvcl9w
cml2ICpwcml2ID0gcmRldl9nZXRfZHJ2ZGF0YShyZGV2KTsKLQlpbnQgaWQgPSByZGV2X2dldF9p
ZChyZGV2KTsKLQlpbnQgcmV0OwotCi0JZGV2X2RiZyhyZGV2X2dldF9kZXYocmRldiksICIlcyBp
ZDogJWRcbiIsIF9fZnVuY19fLCBpZCk7Ci0KLQltYzEzNzgzX2xvY2socHJpdi0+bWMxMzc4Myk7
Ci0JcmV0ID0gbWMxMzc4M19yZWdfcm13KHByaXYtPm1jMTM3ODMsIG1jMTM3ODNfcmVndWxhdG9y
c1tpZF0ucmVnLAotCQkJbWMxMzc4M19yZWd1bGF0b3JzW2lkXS5lbmFibGVfYml0LCAwKTsKLQlt
YzEzNzgzX3VubG9jayhwcml2LT5tYzEzNzgzKTsKLQotCXJldHVybiByZXQ7Ci19Ci0KLXN0YXRp
YyBpbnQgbWMxMzc4M19yZWd1bGF0b3JfaXNfZW5hYmxlZChzdHJ1Y3QgcmVndWxhdG9yX2RldiAq
cmRldikKLXsKLQlzdHJ1Y3QgbWMxMzc4M19yZWd1bGF0b3JfcHJpdiAqcHJpdiA9IHJkZXZfZ2V0
X2RydmRhdGEocmRldik7Ci0JaW50IHJldCwgaWQgPSByZGV2X2dldF9pZChyZGV2KTsKLQl1bnNp
Z25lZCBpbnQgdmFsOwotCi0JbWMxMzc4M19sb2NrKHByaXYtPm1jMTM3ODMpOwotCXJldCA9IG1j
MTM3ODNfcmVnX3JlYWQocHJpdi0+bWMxMzc4MywgbWMxMzc4M19yZWd1bGF0b3JzW2lkXS5yZWcs
ICZ2YWwpOwotCW1jMTM3ODNfdW5sb2NrKHByaXYtPm1jMTM3ODMpOwotCi0JaWYgKHJldCkKLQkJ
cmV0dXJuIHJldDsKLQotCXJldHVybiAodmFsICYgbWMxMzc4M19yZWd1bGF0b3JzW2lkXS5lbmFi
bGVfYml0KSAhPSAwOwotfQotCi1zdGF0aWMgaW50IG1jMTM3ODNfcmVndWxhdG9yX2xpc3Rfdm9s
dGFnZShzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldiwKLQkJCQkJCXVuc2lnbmVkIHNlbGVjdG9y
KQotewotCWludCBpZCA9IHJkZXZfZ2V0X2lkKHJkZXYpOwotCi0JaWYgKHNlbGVjdG9yID49IG1j
MTM3ODNfcmVndWxhdG9yc1tpZF0uZGVzYy5uX3ZvbHRhZ2VzKQotCQlyZXR1cm4gLUVJTlZBTDsK
LQotCXJldHVybiBtYzEzNzgzX3JlZ3VsYXRvcnNbaWRdLnZvbHRhZ2VzW3NlbGVjdG9yXTsKLX0K
LQotc3RhdGljIGludCBtYzEzNzgzX2dldF9iZXN0X3ZvbHRhZ2VfaW5kZXgoc3RydWN0IHJlZ3Vs
YXRvcl9kZXYgKnJkZXYsCi0JCQkJCQlpbnQgbWluX3VWLCBpbnQgbWF4X3VWKQotewotCWludCBy
ZWdfaWQgPSByZGV2X2dldF9pZChyZGV2KTsKLQlpbnQgaTsKLQlpbnQgYmVzdG1hdGNoOwotCWlu
dCBiZXN0aW5kZXg7Ci0KLQkvKgotCSAqIExvY2F0ZSB0aGUgbWluaW11bSB2b2x0YWdlIGZpdHRp
bmcgdGhlIGNyaXRlcmlhIG9uCi0JICogdGhpcyByZWd1bGF0b3IuIFRoZSBzd2l0Y2hhYmxlIHZv
bHRhZ2VzIGFyZSBub3QKLQkgKiBpbiBzdHJpY3QgZmFsbGluZyBvcmRlciBzbyB3ZSBuZWVkIHRv
IGNoZWNrIHRoZW0KLQkgKiBhbGwgZm9yIHRoZSBiZXN0IG1hdGNoLgotCSAqLwotCWJlc3RtYXRj
aCA9IElOVF9NQVg7Ci0JYmVzdGluZGV4ID0gLTE7Ci0JZm9yIChpID0gMDsgaSA8IG1jMTM3ODNf
cmVndWxhdG9yc1tyZWdfaWRdLmRlc2Mubl92b2x0YWdlczsgaSsrKSB7Ci0JCWlmIChtYzEzNzgz
X3JlZ3VsYXRvcnNbcmVnX2lkXS52b2x0YWdlc1tpXSA+PSBtaW5fdVYgJiYKLQkJICAgIG1jMTM3
ODNfcmVndWxhdG9yc1tyZWdfaWRdLnZvbHRhZ2VzW2ldIDwgYmVzdG1hdGNoKSB7Ci0JCQliZXN0
bWF0Y2ggPSBtYzEzNzgzX3JlZ3VsYXRvcnNbcmVnX2lkXS52b2x0YWdlc1tpXTsKLQkJCWJlc3Rp
bmRleCA9IGk7Ci0JCX0KLQl9Ci0KLQlpZiAoYmVzdGluZGV4IDwgMCB8fCBiZXN0bWF0Y2ggPiBt
YXhfdVYpIHsKLQkJZGV2X3dhcm4oJnJkZXYtPmRldiwgIm5vIHBvc3NpYmxlIHZhbHVlIGZvciAl
ZDw9eDw9JWQgdVZcbiIsCi0JCQkJbWluX3VWLCBtYXhfdVYpOwotCQlyZXR1cm4gLUVJTlZBTDsK
LQl9Ci0JcmV0dXJuIGJlc3RpbmRleDsKLX0KLQotc3RhdGljIGludCBtYzEzNzgzX3JlZ3VsYXRv
cl9zZXRfdm9sdGFnZShzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldiwKLQkJCQkJCWludCBtaW5f
dVYsIGludCBtYXhfdVYpCi17Ci0Jc3RydWN0IG1jMTM3ODNfcmVndWxhdG9yX3ByaXYgKnByaXYg
PSByZGV2X2dldF9kcnZkYXRhKHJkZXYpOwotCWludCB2YWx1ZSwgaWQgPSByZGV2X2dldF9pZChy
ZGV2KTsKLQlpbnQgcmV0OwotCi0JZGV2X2RiZyhyZGV2X2dldF9kZXYocmRldiksICIlcyBpZDog
JWQgbWluX3VWOiAlZCBtYXhfdVY6ICVkXG4iLAotCQlfX2Z1bmNfXywgaWQsIG1pbl91ViwgbWF4
X3VWKTsKLQotCS8qIEZpbmQgdGhlIGJlc3QgaW5kZXggKi8KLQl2YWx1ZSA9IG1jMTM3ODNfZ2V0
X2Jlc3Rfdm9sdGFnZV9pbmRleChyZGV2LCBtaW5fdVYsIG1heF91Vik7Ci0JZGV2X2RiZyhyZGV2
X2dldF9kZXYocmRldiksICIlcyBiZXN0IHZhbHVlOiAlZCBcbiIsIF9fZnVuY19fLCB2YWx1ZSk7
Ci0JaWYgKHZhbHVlIDwgMCkKLQkJcmV0dXJuIHZhbHVlOwotCi0JbWMxMzc4M19sb2NrKHByaXYt
Pm1jMTM3ODMpOwotCXJldCA9IG1jMTM3ODNfcmVnX3Jtdyhwcml2LT5tYzEzNzgzLCBtYzEzNzgz
X3JlZ3VsYXRvcnNbaWRdLnZzZWxfcmVnLAotCQkJbWMxMzc4M19yZWd1bGF0b3JzW2lkXS52c2Vs
X21hc2ssCi0JCQl2YWx1ZSA8PCBtYzEzNzgzX3JlZ3VsYXRvcnNbaWRdLnZzZWxfc2hpZnQpOwot
CW1jMTM3ODNfdW5sb2NrKHByaXYtPm1jMTM3ODMpOwotCi0JcmV0dXJuIHJldDsKLX0KLQotc3Rh
dGljIGludCBtYzEzNzgzX3JlZ3VsYXRvcl9nZXRfdm9sdGFnZShzdHJ1Y3QgcmVndWxhdG9yX2Rl
diAqcmRldikKLXsKLQlzdHJ1Y3QgbWMxMzc4M19yZWd1bGF0b3JfcHJpdiAqcHJpdiA9IHJkZXZf
Z2V0X2RydmRhdGEocmRldik7Ci0JaW50IHJldCwgaWQgPSByZGV2X2dldF9pZChyZGV2KTsKLQl1
bnNpZ25lZCBpbnQgdmFsOwotCi0JZGV2X2RiZyhyZGV2X2dldF9kZXYocmRldiksICIlcyBpZDog
JWRcbiIsIF9fZnVuY19fLCBpZCk7Ci0KLQltYzEzNzgzX2xvY2socHJpdi0+bWMxMzc4Myk7Ci0J
cmV0ID0gbWMxMzc4M19yZWdfcmVhZChwcml2LT5tYzEzNzgzLAotCQkJCW1jMTM3ODNfcmVndWxh
dG9yc1tpZF0udnNlbF9yZWcsICZ2YWwpOwotCW1jMTM3ODNfdW5sb2NrKHByaXYtPm1jMTM3ODMp
OwotCi0JaWYgKHJldCkKLQkJcmV0dXJuIHJldDsKLQotCXZhbCA9ICh2YWwgJiBtYzEzNzgzX3Jl
Z3VsYXRvcnNbaWRdLnZzZWxfbWFzaykKLQkJPj4gbWMxMzc4M19yZWd1bGF0b3JzW2lkXS52c2Vs
X3NoaWZ0OwotCi0JZGV2X2RiZyhyZGV2X2dldF9kZXYocmRldiksICIlcyBpZDogJWQgdmFsOiAl
ZFxuIiwgX19mdW5jX18sIGlkLCB2YWwpOwotCi0JQlVHX09OKHZhbCA8IDAgfHwgdmFsID4gbWMx
Mzc4M19yZWd1bGF0b3JzW2lkXS5kZXNjLm5fdm9sdGFnZXMpOwotCi0JcmV0dXJuIG1jMTM3ODNf
cmVndWxhdG9yc1tpZF0udm9sdGFnZXNbdmFsXTsKLX0KLQotc3RhdGljIHN0cnVjdCByZWd1bGF0
b3Jfb3BzIG1jMTM3ODNfcmVndWxhdG9yX29wcyA9IHsKLQkuZW5hYmxlID0gbWMxMzc4M19yZWd1
bGF0b3JfZW5hYmxlLAotCS5kaXNhYmxlID0gbWMxMzc4M19yZWd1bGF0b3JfZGlzYWJsZSwKLQku
aXNfZW5hYmxlZCA9IG1jMTM3ODNfcmVndWxhdG9yX2lzX2VuYWJsZWQsCi0JLmxpc3Rfdm9sdGFn
ZSA9IG1jMTM3ODNfcmVndWxhdG9yX2xpc3Rfdm9sdGFnZSwKLQkuc2V0X3ZvbHRhZ2UgPSBtYzEz
NzgzX3JlZ3VsYXRvcl9zZXRfdm9sdGFnZSwKLQkuZ2V0X3ZvbHRhZ2UgPSBtYzEzNzgzX3JlZ3Vs
YXRvcl9nZXRfdm9sdGFnZSwKLX07Ci0KLXN0YXRpYyBpbnQgbWMxMzc4M19maXhlZF9yZWd1bGF0
b3Jfc2V0X3ZvbHRhZ2Uoc3RydWN0IHJlZ3VsYXRvcl9kZXYgKnJkZXYsCi0JCQkJCQlpbnQgbWlu
X3VWLCBpbnQgbWF4X3VWKQotewotCWludCBpZCA9IHJkZXZfZ2V0X2lkKHJkZXYpOwotCi0JZGV2
X2RiZyhyZGV2X2dldF9kZXYocmRldiksICIlcyBpZDogJWQgbWluX3VWOiAlZCBtYXhfdVY6ICVk
XG4iLAotCQlfX2Z1bmNfXywgaWQsIG1pbl91ViwgbWF4X3VWKTsKLQotCWlmIChtaW5fdVYgPj0g
bWMxMzc4M19yZWd1bGF0b3JzW2lkXS52b2x0YWdlc1swXSAmJgotCSAgICBtYXhfdVYgPD0gbWMx
Mzc4M19yZWd1bGF0b3JzW2lkXS52b2x0YWdlc1swXSkKLQkJcmV0dXJuIDA7Ci0JZWxzZQotCQly
ZXR1cm4gLUVJTlZBTDsKLX0KLQotc3RhdGljIGludCBtYzEzNzgzX2ZpeGVkX3JlZ3VsYXRvcl9n
ZXRfdm9sdGFnZShzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldikKLXsKLQlpbnQgaWQgPSByZGV2
X2dldF9pZChyZGV2KTsKLQotCWRldl9kYmcocmRldl9nZXRfZGV2KHJkZXYpLCAiJXMgaWQ6ICVk
XG4iLCBfX2Z1bmNfXywgaWQpOwotCi0JcmV0dXJuIG1jMTM3ODNfcmVndWxhdG9yc1tpZF0udm9s
dGFnZXNbMF07Ci19Ci0KLXN0YXRpYyBzdHJ1Y3QgcmVndWxhdG9yX29wcyBtYzEzNzgzX2ZpeGVk
X3JlZ3VsYXRvcl9vcHMgPSB7Ci0JLmVuYWJsZSA9IG1jMTM3ODNfcmVndWxhdG9yX2VuYWJsZSwK
LQkuZGlzYWJsZSA9IG1jMTM3ODNfcmVndWxhdG9yX2Rpc2FibGUsCi0JLmlzX2VuYWJsZWQgPSBt
YzEzNzgzX3JlZ3VsYXRvcl9pc19lbmFibGVkLAotCS5saXN0X3ZvbHRhZ2UgPSBtYzEzNzgzX3Jl
Z3VsYXRvcl9saXN0X3ZvbHRhZ2UsCi0JLnNldF92b2x0YWdlID0gbWMxMzc4M19maXhlZF9yZWd1
bGF0b3Jfc2V0X3ZvbHRhZ2UsCi0JLmdldF92b2x0YWdlID0gbWMxMzc4M19maXhlZF9yZWd1bGF0
b3JfZ2V0X3ZvbHRhZ2UsCi19OwotCi1pbnQgbWMxMzc4M19wb3dlcm1pc2Nfcm13KHN0cnVjdCBt
YzEzNzgzX3JlZ3VsYXRvcl9wcml2ICpwcml2LCB1MzIgbWFzaywKK2ludCBtYzEzNzgzX3Bvd2Vy
bWlzY19ybXcoc3RydWN0IG1jMTN4eHhfcmVndWxhdG9yX3ByaXYgKnByaXYsIHUzMiBtYXNrLAog
CQkJCQkJCQkJdTMyIHZhbCkKIHsKLQlzdHJ1Y3QgbWMxMzc4MyAqbWMxMzc4MyA9IHByaXYtPm1j
MTM3ODM7CisJc3RydWN0IG1jMTN4eHggKm1jMTM3ODMgPSBwcml2LT5tYzEzeHh4OwogCWludCBy
ZXQ7CiAJdTMyIHZhbHJlYWQ7CiAKIAlCVUdfT04odmFsICYgfm1hc2spOwogCi0JcmV0ID0gbWMx
Mzc4M19yZWdfcmVhZChtYzEzNzgzLCBNQzEzNzgzX1JFR19QT1dFUk1JU0MsICZ2YWxyZWFkKTsK
KwlyZXQgPSBtYzEzeHh4X3JlZ19yZWFkKG1jMTM3ODMsIE1DMTM3ODNfUkVHX1BPV0VSTUlTQywg
JnZhbHJlYWQpOwogCWlmIChyZXQpCiAJCXJldHVybiByZXQ7CiAKQEAgLTQ4OSwzNCArMjUyLDM2
IEBAIGludCBtYzEzNzgzX3Bvd2VybWlzY19ybXcoc3RydWN0IG1jMTM3ODNfcmVndWxhdG9yX3By
aXYgKnByaXYsIHUzMiBtYXNrLAogCXZhbHJlYWQgPSAodmFscmVhZCAmIH5NQzEzNzgzX1JFR19Q
T1dFUk1JU0NfUFdHVFNQSV9NKSB8CiAJCQkJCQlwcml2LT5wb3dlcm1pc2NfcHdndF9zdGF0ZTsK
IAotCXJldHVybiBtYzEzNzgzX3JlZ193cml0ZShtYzEzNzgzLCBNQzEzNzgzX1JFR19QT1dFUk1J
U0MsIHZhbHJlYWQpOworCXJldHVybiBtYzEzeHh4X3JlZ193cml0ZShtYzEzNzgzLCBNQzEzNzgz
X1JFR19QT1dFUk1JU0MsIHZhbHJlYWQpOwogfQogCiBzdGF0aWMgaW50IG1jMTM3ODNfZ3BvX3Jl
Z3VsYXRvcl9lbmFibGUoc3RydWN0IHJlZ3VsYXRvcl9kZXYgKnJkZXYpCiB7Ci0Jc3RydWN0IG1j
MTM3ODNfcmVndWxhdG9yX3ByaXYgKnByaXYgPSByZGV2X2dldF9kcnZkYXRhKHJkZXYpOworCXN0
cnVjdCBtYzEzeHh4X3JlZ3VsYXRvcl9wcml2ICpwcml2ID0gcmRldl9nZXRfZHJ2ZGF0YShyZGV2
KTsKKwlzdHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3IgKm1jMTN4eHhfcmVndWxhdG9ycyA9IHByaXYt
Pm1jMTN4eHhfcmVndWxhdG9yczsKIAlpbnQgaWQgPSByZGV2X2dldF9pZChyZGV2KTsKIAlpbnQg
cmV0OwotCXUzMiBlbl92YWwgPSBtYzEzNzgzX3JlZ3VsYXRvcnNbaWRdLmVuYWJsZV9iaXQ7CisJ
dTMyIGVuX3ZhbCA9IG1jMTN4eHhfcmVndWxhdG9yc1tpZF0uZW5hYmxlX2JpdDsKIAogCWRldl9k
YmcocmRldl9nZXRfZGV2KHJkZXYpLCAiJXMgaWQ6ICVkXG4iLCBfX2Z1bmNfXywgaWQpOwogCiAJ
LyogUG93ZXIgR2F0ZSBlbmFibGUgdmFsdWUgaXMgMCAqLwotCWlmIChpZCA9PSBNQzEzNzgzX1JF
R1VfUFdHVDFTUEkgfHwKLQkgICAgaWQgPT0gTUMxMzc4M19SRUdVX1BXR1QyU1BJKQorCWlmIChp
ZCA9PSBNQzEzNzgzX1JFR19QV0dUMVNQSSB8fAorCSAgICBpZCA9PSBNQzEzNzgzX1JFR19QV0dU
MlNQSSkKIAkJZW5fdmFsID0gMDsKIAotCW1jMTM3ODNfbG9jayhwcml2LT5tYzEzNzgzKTsKLQly
ZXQgPSBtYzEzNzgzX3Bvd2VybWlzY19ybXcocHJpdiwgbWMxMzc4M19yZWd1bGF0b3JzW2lkXS5l
bmFibGVfYml0LAorCW1jMTN4eHhfbG9jayhwcml2LT5tYzEzeHh4KTsKKwlyZXQgPSBtYzEzNzgz
X3Bvd2VybWlzY19ybXcocHJpdiwgbWMxM3h4eF9yZWd1bGF0b3JzW2lkXS5lbmFibGVfYml0LAog
CQkJCQllbl92YWwpOwotCW1jMTM3ODNfdW5sb2NrKHByaXYtPm1jMTM3ODMpOworCW1jMTN4eHhf
dW5sb2NrKHByaXYtPm1jMTN4eHgpOwogCiAJcmV0dXJuIHJldDsKIH0KIAogc3RhdGljIGludCBt
YzEzNzgzX2dwb19yZWd1bGF0b3JfZGlzYWJsZShzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldikK
IHsKLQlzdHJ1Y3QgbWMxMzc4M19yZWd1bGF0b3JfcHJpdiAqcHJpdiA9IHJkZXZfZ2V0X2RydmRh
dGEocmRldik7CisJc3RydWN0IG1jMTN4eHhfcmVndWxhdG9yX3ByaXYgKnByaXYgPSByZGV2X2dl
dF9kcnZkYXRhKHJkZXYpOworCXN0cnVjdCBtYzEzeHh4X3JlZ3VsYXRvciAqbWMxM3h4eF9yZWd1
bGF0b3JzID0gcHJpdi0+bWMxM3h4eF9yZWd1bGF0b3JzOwogCWludCBpZCA9IHJkZXZfZ2V0X2lk
KHJkZXYpOwogCWludCByZXQ7CiAJdTMyIGRpc192YWwgPSAwOwpAQCAtNTI0LDI3ICsyODksMjgg
QEAgc3RhdGljIGludCBtYzEzNzgzX2dwb19yZWd1bGF0b3JfZGlzYWJsZShzdHJ1Y3QgcmVndWxh
dG9yX2RldiAqcmRldikKIAlkZXZfZGJnKHJkZXZfZ2V0X2RldihyZGV2KSwgIiVzIGlkOiAlZFxu
IiwgX19mdW5jX18sIGlkKTsKIAogCS8qIFBvd2VyIEdhdGUgZGlzYWJsZSB2YWx1ZSBpcyAxICov
Ci0JaWYgKGlkID09IE1DMTM3ODNfUkVHVV9QV0dUMVNQSSB8fAotCSAgICBpZCA9PSBNQzEzNzgz
X1JFR1VfUFdHVDJTUEkpCi0JCWRpc192YWwgPSBtYzEzNzgzX3JlZ3VsYXRvcnNbaWRdLmVuYWJs
ZV9iaXQ7CisJaWYgKGlkID09IE1DMTM3ODNfUkVHX1BXR1QxU1BJIHx8CisJICAgIGlkID09IE1D
MTM3ODNfUkVHX1BXR1QyU1BJKQorCQlkaXNfdmFsID0gbWMxM3h4eF9yZWd1bGF0b3JzW2lkXS5l
bmFibGVfYml0OwogCi0JbWMxMzc4M19sb2NrKHByaXYtPm1jMTM3ODMpOwotCXJldCA9IG1jMTM3
ODNfcG93ZXJtaXNjX3Jtdyhwcml2LCBtYzEzNzgzX3JlZ3VsYXRvcnNbaWRdLmVuYWJsZV9iaXQs
CisJbWMxM3h4eF9sb2NrKHByaXYtPm1jMTN4eHgpOworCXJldCA9IG1jMTM3ODNfcG93ZXJtaXNj
X3Jtdyhwcml2LCBtYzEzeHh4X3JlZ3VsYXRvcnNbaWRdLmVuYWJsZV9iaXQsCiAJCQkJCWRpc192
YWwpOwotCW1jMTM3ODNfdW5sb2NrKHByaXYtPm1jMTM3ODMpOworCW1jMTN4eHhfdW5sb2NrKHBy
aXYtPm1jMTN4eHgpOwogCiAJcmV0dXJuIHJldDsKIH0KIAogc3RhdGljIGludCBtYzEzNzgzX2dw
b19yZWd1bGF0b3JfaXNfZW5hYmxlZChzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldikKIHsKLQlz
dHJ1Y3QgbWMxMzc4M19yZWd1bGF0b3JfcHJpdiAqcHJpdiA9IHJkZXZfZ2V0X2RydmRhdGEocmRl
dik7CisJc3RydWN0IG1jMTN4eHhfcmVndWxhdG9yX3ByaXYgKnByaXYgPSByZGV2X2dldF9kcnZk
YXRhKHJkZXYpOworCXN0cnVjdCBtYzEzeHh4X3JlZ3VsYXRvciAqbWMxM3h4eF9yZWd1bGF0b3Jz
ID0gcHJpdi0+bWMxM3h4eF9yZWd1bGF0b3JzOwogCWludCByZXQsIGlkID0gcmRldl9nZXRfaWQo
cmRldik7CiAJdW5zaWduZWQgaW50IHZhbDsKIAotCW1jMTM3ODNfbG9jayhwcml2LT5tYzEzNzgz
KTsKLQlyZXQgPSBtYzEzNzgzX3JlZ19yZWFkKHByaXYtPm1jMTM3ODMsIG1jMTM3ODNfcmVndWxh
dG9yc1tpZF0ucmVnLCAmdmFsKTsKLQltYzEzNzgzX3VubG9jayhwcml2LT5tYzEzNzgzKTsKKwlt
YzEzeHh4X2xvY2socHJpdi0+bWMxM3h4eCk7CisJcmV0ID0gbWMxM3h4eF9yZWdfcmVhZChwcml2
LT5tYzEzeHh4LCBtYzEzeHh4X3JlZ3VsYXRvcnNbaWRdLnJlZywgJnZhbCk7CisJbWMxM3h4eF91
bmxvY2socHJpdi0+bWMxM3h4eCk7CiAKIAlpZiAocmV0KQogCQlyZXR1cm4gcmV0OwpAQCAtNTU0
LDIyICszMjAsMjIgQEAgc3RhdGljIGludCBtYzEzNzgzX2dwb19yZWd1bGF0b3JfaXNfZW5hYmxl
ZChzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldikKIAl2YWwgPSAodmFsICYgfk1DMTM3ODNfUkVH
X1BPV0VSTUlTQ19QV0dUU1BJX00pIHwKIAkgICAgICAocHJpdi0+cG93ZXJtaXNjX3B3Z3Rfc3Rh
dGUgXiBNQzEzNzgzX1JFR19QT1dFUk1JU0NfUFdHVFNQSV9NKTsKIAotCXJldHVybiAodmFsICYg
bWMxMzc4M19yZWd1bGF0b3JzW2lkXS5lbmFibGVfYml0KSAhPSAwOworCXJldHVybiAodmFsICYg
bWMxM3h4eF9yZWd1bGF0b3JzW2lkXS5lbmFibGVfYml0KSAhPSAwOwogfQogCiBzdGF0aWMgc3Ry
dWN0IHJlZ3VsYXRvcl9vcHMgbWMxMzc4M19ncG9fcmVndWxhdG9yX29wcyA9IHsKIAkuZW5hYmxl
ID0gbWMxMzc4M19ncG9fcmVndWxhdG9yX2VuYWJsZSwKIAkuZGlzYWJsZSA9IG1jMTM3ODNfZ3Bv
X3JlZ3VsYXRvcl9kaXNhYmxlLAogCS5pc19lbmFibGVkID0gbWMxMzc4M19ncG9fcmVndWxhdG9y
X2lzX2VuYWJsZWQsCi0JLmxpc3Rfdm9sdGFnZSA9IG1jMTM3ODNfcmVndWxhdG9yX2xpc3Rfdm9s
dGFnZSwKLQkuc2V0X3ZvbHRhZ2UgPSBtYzEzNzgzX2ZpeGVkX3JlZ3VsYXRvcl9zZXRfdm9sdGFn
ZSwKLQkuZ2V0X3ZvbHRhZ2UgPSBtYzEzNzgzX2ZpeGVkX3JlZ3VsYXRvcl9nZXRfdm9sdGFnZSwK
KwkubGlzdF92b2x0YWdlID0gbWMxM3h4eF9yZWd1bGF0b3JfbGlzdF92b2x0YWdlLAorCS5zZXRf
dm9sdGFnZSA9IG1jMTN4eHhfZml4ZWRfcmVndWxhdG9yX3NldF92b2x0YWdlLAorCS5nZXRfdm9s
dGFnZSA9IG1jMTN4eHhfZml4ZWRfcmVndWxhdG9yX2dldF92b2x0YWdlLAogfTsKIAogc3RhdGlj
IGludCBfX2RldmluaXQgbWMxMzc4M19yZWd1bGF0b3JfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2Rl
dmljZSAqcGRldikKIHsKLQlzdHJ1Y3QgbWMxMzc4M19yZWd1bGF0b3JfcHJpdiAqcHJpdjsKLQlz
dHJ1Y3QgbWMxMzc4MyAqbWMxMzc4MyA9IGRldl9nZXRfZHJ2ZGF0YShwZGV2LT5kZXYucGFyZW50
KTsKKwlzdHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3JfcHJpdiAqcHJpdjsKKwlzdHJ1Y3QgbWMxM3h4
eCAqbWMxMzc4MyA9IGRldl9nZXRfZHJ2ZGF0YShwZGV2LT5kZXYucGFyZW50KTsKIAlzdHJ1Y3Qg
bWMxMzc4M19yZWd1bGF0b3JfcGxhdGZvcm1fZGF0YSAqcGRhdGEgPQogCQlkZXZfZ2V0X3BsYXRk
YXRhKCZwZGV2LT5kZXYpOwogCXN0cnVjdCBtYzEzNzgzX3JlZ3VsYXRvcl9pbml0X2RhdGEgKmlu
aXRfZGF0YTsKQEAgLTU4Myw3ICszNDksOCBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBtYzEzNzgz
X3JlZ3VsYXRvcl9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCWlmICghcHJp
dikKIAkJcmV0dXJuIC1FTk9NRU07CiAKLQlwcml2LT5tYzEzNzgzID0gbWMxMzc4MzsKKwlwcml2
LT5tYzEzeHh4X3JlZ3VsYXRvcnMgPSBtYzEzNzgzX3JlZ3VsYXRvcnM7CisJcHJpdi0+bWMxM3h4
eCA9IG1jMTM3ODM7CiAKIAlmb3IgKGkgPSAwOyBpIDwgcGRhdGEtPm51bV9yZWd1bGF0b3JzOyBp
KyspIHsKIAkJaW5pdF9kYXRhID0gJnBkYXRhLT5yZWd1bGF0b3JzW2ldOwpAQCAtNjEzLDcgKzM4
MCw3IEBAIGVycjoKIAogc3RhdGljIGludCBfX2RldmV4aXQgbWMxMzc4M19yZWd1bGF0b3JfcmVt
b3ZlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpCiB7Ci0Jc3RydWN0IG1jMTM3ODNfcmVn
dWxhdG9yX3ByaXYgKnByaXYgPSBwbGF0Zm9ybV9nZXRfZHJ2ZGF0YShwZGV2KTsKKwlzdHJ1Y3Qg
bWMxM3h4eF9yZWd1bGF0b3JfcHJpdiAqcHJpdiA9IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBkZXYp
OwogCXN0cnVjdCBtYzEzNzgzX3JlZ3VsYXRvcl9wbGF0Zm9ybV9kYXRhICpwZGF0YSA9CiAJCWRl
dl9nZXRfcGxhdGRhdGEoJnBkZXYtPmRldik7CiAJaW50IGk7CmRpZmYgLS1naXQgYS9kcml2ZXJz
L3JlZ3VsYXRvci9tYzEzeHh4LXJlZ3VsYXRvci1jb3JlLmMgYi9kcml2ZXJzL3JlZ3VsYXRvci9t
YzEzeHh4LXJlZ3VsYXRvci1jb3JlLmMKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAw
MC4uZTdlMGRlZgotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZlcnMvcmVndWxhdG9yL21jMTN4eHgt
cmVndWxhdG9yLWNvcmUuYwpAQCAtMCwwICsxLDIzOSBAQAorLyoKKyAqIFJlZ3VsYXRvciBEcml2
ZXIgZm9yIEZyZWVzY2FsZSBNQzEzeHh4IFBNSUMKKyAqCisgKiBDb3B5cmlnaHQgMjAxMCBZb25n
IFNoZW4gPHlvbmcuc2hlbkBsaW5hcm8ub3JnPgorICoKKyAqIEJhc2VkIG9uIG1jMTM3ODMgcmVn
dWxhdG9yIGRyaXZlciA6CisgKiBDb3B5cmlnaHQgKEMpIDIwMDggU2FzY2hhIEhhdWVyLCBQZW5n
dXRyb25peCA8cy5oYXVlckBwZW5ndXRyb25peC5kZT4KKyAqIENvcHlyaWdodCAyMDA5IEFsYmVy
dG8gUGFuaXp6byA8bWFyYW1hb3BlcmNoZXNlaW1vcnRvQGdtYWlsLmNvbT4KKyAqCisgKiBUaGlz
IHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29y
IG1vZGlmeQorICogaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMg
TGljZW5zZSB2ZXJzaW9uIDIgYXMKKyAqIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBG
b3VuZGF0aW9uLgorICoKKyAqIFJlZ3MgaW5mb3MgdGFrZW4gZnJvbSBtYzEzeHh4IGRyaXZlcnMg
ZnJvbSBmcmVlc2NhbGUgYW5kIG1jMTN4eHgucGRmIGZpbGUKKyAqIGZyb20gZnJlZXNjYWxlCisg
Ki8KKworI2luY2x1ZGUgPGxpbnV4L21mZC9tYzEzeHh4Lmg+CisjaW5jbHVkZSA8bGludXgvcmVn
dWxhdG9yL21jMTN4eHguaD4KKyNpbmNsdWRlIDxsaW51eC9yZWd1bGF0b3IvbWFjaGluZS5oPgor
I2luY2x1ZGUgPGxpbnV4L3JlZ3VsYXRvci9kcml2ZXIuaD4KKyNpbmNsdWRlIDxsaW51eC9wbGF0
Zm9ybV9kZXZpY2UuaD4KKyNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4KKyNpbmNsdWRlIDxsaW51
eC9zbGFiLmg+CisjaW5jbHVkZSA8bGludXgvaW5pdC5oPgorI2luY2x1ZGUgPGxpbnV4L2Vyci5o
PgorCitzdGF0aWMgaW50IG1jMTN4eHhfcmVndWxhdG9yX2VuYWJsZShzdHJ1Y3QgcmVndWxhdG9y
X2RldiAqcmRldikKK3sKKwlzdHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3JfcHJpdiAqcHJpdiA9IHJk
ZXZfZ2V0X2RydmRhdGEocmRldik7CisJc3RydWN0IG1jMTN4eHhfcmVndWxhdG9yICptYzEzeHh4
X3JlZ3VsYXRvcnMgPSBwcml2LT5tYzEzeHh4X3JlZ3VsYXRvcnM7CisJaW50IGlkID0gcmRldl9n
ZXRfaWQocmRldik7CisJaW50IHJldDsKKworCWRldl9kYmcocmRldl9nZXRfZGV2KHJkZXYpLCAi
JXMgaWQ6ICVkXG4iLCBfX2Z1bmNfXywgaWQpOworCisJbWMxM3h4eF9sb2NrKHByaXYtPm1jMTN4
eHgpOworCXJldCA9IG1jMTN4eHhfcmVnX3Jtdyhwcml2LT5tYzEzeHh4LCBtYzEzeHh4X3JlZ3Vs
YXRvcnNbaWRdLnJlZywKKwkJCW1jMTN4eHhfcmVndWxhdG9yc1tpZF0uZW5hYmxlX2JpdCwKKwkJ
CW1jMTN4eHhfcmVndWxhdG9yc1tpZF0uZW5hYmxlX2JpdCk7CisJbWMxM3h4eF91bmxvY2socHJp
di0+bWMxM3h4eCk7CisKKwlyZXR1cm4gcmV0OworfQorCitzdGF0aWMgaW50IG1jMTN4eHhfcmVn
dWxhdG9yX2Rpc2FibGUoc3RydWN0IHJlZ3VsYXRvcl9kZXYgKnJkZXYpCit7CisJc3RydWN0IG1j
MTN4eHhfcmVndWxhdG9yX3ByaXYgKnByaXYgPSByZGV2X2dldF9kcnZkYXRhKHJkZXYpOworCXN0
cnVjdCBtYzEzeHh4X3JlZ3VsYXRvciAqbWMxM3h4eF9yZWd1bGF0b3JzID0gcHJpdi0+bWMxM3h4
eF9yZWd1bGF0b3JzOworCWludCBpZCA9IHJkZXZfZ2V0X2lkKHJkZXYpOworCWludCByZXQ7CisK
KwlkZXZfZGJnKHJkZXZfZ2V0X2RldihyZGV2KSwgIiVzIGlkOiAlZFxuIiwgX19mdW5jX18sIGlk
KTsKKworCW1jMTN4eHhfbG9jayhwcml2LT5tYzEzeHh4KTsKKwlyZXQgPSBtYzEzeHh4X3JlZ19y
bXcocHJpdi0+bWMxM3h4eCwgbWMxM3h4eF9yZWd1bGF0b3JzW2lkXS5yZWcsCisJCQltYzEzeHh4
X3JlZ3VsYXRvcnNbaWRdLmVuYWJsZV9iaXQsIDApOworCW1jMTN4eHhfdW5sb2NrKHByaXYtPm1j
MTN4eHgpOworCisJcmV0dXJuIHJldDsKK30KKworc3RhdGljIGludCBtYzEzeHh4X3JlZ3VsYXRv
cl9pc19lbmFibGVkKHN0cnVjdCByZWd1bGF0b3JfZGV2ICpyZGV2KQoreworCXN0cnVjdCBtYzEz
eHh4X3JlZ3VsYXRvcl9wcml2ICpwcml2ID0gcmRldl9nZXRfZHJ2ZGF0YShyZGV2KTsKKwlzdHJ1
Y3QgbWMxM3h4eF9yZWd1bGF0b3IgKm1jMTN4eHhfcmVndWxhdG9ycyA9IHByaXYtPm1jMTN4eHhf
cmVndWxhdG9yczsKKwlpbnQgcmV0LCBpZCA9IHJkZXZfZ2V0X2lkKHJkZXYpOworCXVuc2lnbmVk
IGludCB2YWw7CisKKwltYzEzeHh4X2xvY2socHJpdi0+bWMxM3h4eCk7CisJcmV0ID0gbWMxM3h4
eF9yZWdfcmVhZChwcml2LT5tYzEzeHh4LCBtYzEzeHh4X3JlZ3VsYXRvcnNbaWRdLnJlZywgJnZh
bCk7CisJbWMxM3h4eF91bmxvY2socHJpdi0+bWMxM3h4eCk7CisKKwlpZiAocmV0KQorCQlyZXR1
cm4gcmV0OworCisJcmV0dXJuICh2YWwgJiBtYzEzeHh4X3JlZ3VsYXRvcnNbaWRdLmVuYWJsZV9i
aXQpICE9IDA7Cit9CisKK2ludCBtYzEzeHh4X3JlZ3VsYXRvcl9saXN0X3ZvbHRhZ2Uoc3RydWN0
IHJlZ3VsYXRvcl9kZXYgKnJkZXYsCisJCQkJCQl1bnNpZ25lZCBzZWxlY3RvcikKK3sKKwlpbnQg
aWQgPSByZGV2X2dldF9pZChyZGV2KTsKKwlzdHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3JfcHJpdiAq
cHJpdiA9IHJkZXZfZ2V0X2RydmRhdGEocmRldik7CisJc3RydWN0IG1jMTN4eHhfcmVndWxhdG9y
ICptYzEzeHh4X3JlZ3VsYXRvcnMgPSBwcml2LT5tYzEzeHh4X3JlZ3VsYXRvcnM7CisKKwlpZiAo
c2VsZWN0b3IgPj0gbWMxM3h4eF9yZWd1bGF0b3JzW2lkXS5kZXNjLm5fdm9sdGFnZXMpCisJCXJl
dHVybiAtRUlOVkFMOworCisJcmV0dXJuIG1jMTN4eHhfcmVndWxhdG9yc1tpZF0udm9sdGFnZXNb
c2VsZWN0b3JdOworfQorCitpbnQgbWMxM3h4eF9nZXRfYmVzdF92b2x0YWdlX2luZGV4KHN0cnVj
dCByZWd1bGF0b3JfZGV2ICpyZGV2LAorCQkJCQkJaW50IG1pbl91ViwgaW50IG1heF91VikKK3sK
KwlzdHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3JfcHJpdiAqcHJpdiA9IHJkZXZfZ2V0X2RydmRhdGEo
cmRldik7CisJc3RydWN0IG1jMTN4eHhfcmVndWxhdG9yICptYzEzeHh4X3JlZ3VsYXRvcnMgPSBw
cml2LT5tYzEzeHh4X3JlZ3VsYXRvcnM7CisJaW50IHJlZ19pZCA9IHJkZXZfZ2V0X2lkKHJkZXYp
OworCWludCBpOworCWludCBiZXN0bWF0Y2g7CisJaW50IGJlc3RpbmRleDsKKworCS8qCisJICog
TG9jYXRlIHRoZSBtaW5pbXVtIHZvbHRhZ2UgZml0dGluZyB0aGUgY3JpdGVyaWEgb24KKwkgKiB0
aGlzIHJlZ3VsYXRvci4gVGhlIHN3aXRjaGFibGUgdm9sdGFnZXMgYXJlIG5vdAorCSAqIGluIHN0
cmljdCBmYWxsaW5nIG9yZGVyIHNvIHdlIG5lZWQgdG8gY2hlY2sgdGhlbQorCSAqIGFsbCBmb3Ig
dGhlIGJlc3QgbWF0Y2guCisJICovCisJYmVzdG1hdGNoID0gSU5UX01BWDsKKwliZXN0aW5kZXgg
PSAtMTsKKwlmb3IgKGkgPSAwOyBpIDwgbWMxM3h4eF9yZWd1bGF0b3JzW3JlZ19pZF0uZGVzYy5u
X3ZvbHRhZ2VzOyBpKyspIHsKKwkJaWYgKG1jMTN4eHhfcmVndWxhdG9yc1tyZWdfaWRdLnZvbHRh
Z2VzW2ldID49IG1pbl91ViAmJgorCQkgICAgbWMxM3h4eF9yZWd1bGF0b3JzW3JlZ19pZF0udm9s
dGFnZXNbaV0gPCBiZXN0bWF0Y2gpIHsKKwkJCWJlc3RtYXRjaCA9IG1jMTN4eHhfcmVndWxhdG9y
c1tyZWdfaWRdLnZvbHRhZ2VzW2ldOworCQkJYmVzdGluZGV4ID0gaTsKKwkJfQorCX0KKworCWlm
IChiZXN0aW5kZXggPCAwIHx8IGJlc3RtYXRjaCA+IG1heF91VikgeworCQlkZXZfd2FybigmcmRl
di0+ZGV2LCAibm8gcG9zc2libGUgdmFsdWUgZm9yICVkPD14PD0lZCB1VlxuIiwKKwkJCQltaW5f
dVYsIG1heF91Vik7CisJCXJldHVybiAtRUlOVkFMOworCX0KKwlyZXR1cm4gYmVzdGluZGV4Owor
fQorCitzdGF0aWMgaW50IG1jMTN4eHhfcmVndWxhdG9yX3NldF92b2x0YWdlKHN0cnVjdCByZWd1
bGF0b3JfZGV2ICpyZGV2LAorCQkJCQkJaW50IG1pbl91ViwgaW50IG1heF91VikKK3sKKwlzdHJ1
Y3QgbWMxM3h4eF9yZWd1bGF0b3JfcHJpdiAqcHJpdiA9IHJkZXZfZ2V0X2RydmRhdGEocmRldik7
CisJc3RydWN0IG1jMTN4eHhfcmVndWxhdG9yICptYzEzeHh4X3JlZ3VsYXRvcnMgPSBwcml2LT5t
YzEzeHh4X3JlZ3VsYXRvcnM7CisJaW50IHZhbHVlLCBpZCA9IHJkZXZfZ2V0X2lkKHJkZXYpOwor
CWludCByZXQ7CisKKwlkZXZfZGJnKHJkZXZfZ2V0X2RldihyZGV2KSwgIiVzIGlkOiAlZCBtaW5f
dVY6ICVkIG1heF91VjogJWRcbiIsCisJCV9fZnVuY19fLCBpZCwgbWluX3VWLCBtYXhfdVYpOwor
CisJLyogRmluZCB0aGUgYmVzdCBpbmRleCAqLworCXZhbHVlID0gbWMxM3h4eF9nZXRfYmVzdF92
b2x0YWdlX2luZGV4KHJkZXYsIG1pbl91ViwgbWF4X3VWKTsKKwlkZXZfZGJnKHJkZXZfZ2V0X2Rl
dihyZGV2KSwgIiVzIGJlc3QgdmFsdWU6ICVkXG4iLCBfX2Z1bmNfXywgdmFsdWUpOworCWlmICh2
YWx1ZSA8IDApCisJCXJldHVybiB2YWx1ZTsKKworCW1jMTN4eHhfbG9jayhwcml2LT5tYzEzeHh4
KTsKKwlyZXQgPSBtYzEzeHh4X3JlZ19ybXcocHJpdi0+bWMxM3h4eCwgbWMxM3h4eF9yZWd1bGF0
b3JzW2lkXS52c2VsX3JlZywKKwkJCW1jMTN4eHhfcmVndWxhdG9yc1tpZF0udnNlbF9tYXNrLAor
CQkJdmFsdWUgPDwgbWMxM3h4eF9yZWd1bGF0b3JzW2lkXS52c2VsX3NoaWZ0KTsKKwltYzEzeHh4
X3VubG9jayhwcml2LT5tYzEzeHh4KTsKKworCXJldHVybiByZXQ7Cit9CisKK3N0YXRpYyBpbnQg
bWMxM3h4eF9yZWd1bGF0b3JfZ2V0X3ZvbHRhZ2Uoc3RydWN0IHJlZ3VsYXRvcl9kZXYgKnJkZXYp
Cit7CisJc3RydWN0IG1jMTN4eHhfcmVndWxhdG9yX3ByaXYgKnByaXYgPSByZGV2X2dldF9kcnZk
YXRhKHJkZXYpOworCXN0cnVjdCBtYzEzeHh4X3JlZ3VsYXRvciAqbWMxM3h4eF9yZWd1bGF0b3Jz
ID0gcHJpdi0+bWMxM3h4eF9yZWd1bGF0b3JzOworCWludCByZXQsIGlkID0gcmRldl9nZXRfaWQo
cmRldik7CisJdW5zaWduZWQgaW50IHZhbDsKKworCWRldl9kYmcocmRldl9nZXRfZGV2KHJkZXYp
LCAiJXMgaWQ6ICVkXG4iLCBfX2Z1bmNfXywgaWQpOworCisJbWMxM3h4eF9sb2NrKHByaXYtPm1j
MTN4eHgpOworCXJldCA9IG1jMTN4eHhfcmVnX3JlYWQocHJpdi0+bWMxM3h4eCwKKwkJCQltYzEz
eHh4X3JlZ3VsYXRvcnNbaWRdLnZzZWxfcmVnLCAmdmFsKTsKKwltYzEzeHh4X3VubG9jayhwcml2
LT5tYzEzeHh4KTsKKworCWlmIChyZXQpCisJCXJldHVybiByZXQ7CisKKwl2YWwgPSAodmFsICYg
bWMxM3h4eF9yZWd1bGF0b3JzW2lkXS52c2VsX21hc2spCisJCT4+IG1jMTN4eHhfcmVndWxhdG9y
c1tpZF0udnNlbF9zaGlmdDsKKworCWRldl9kYmcocmRldl9nZXRfZGV2KHJkZXYpLCAiJXMgaWQ6
ICVkIHZhbDogJWRcbiIsIF9fZnVuY19fLCBpZCwgdmFsKTsKKworCUJVR19PTih2YWwgPCAwIHx8
IHZhbCA+IG1jMTN4eHhfcmVndWxhdG9yc1tpZF0uZGVzYy5uX3ZvbHRhZ2VzKTsKKworCXJldHVy
biBtYzEzeHh4X3JlZ3VsYXRvcnNbaWRdLnZvbHRhZ2VzW3ZhbF07Cit9CisKK3N0cnVjdCByZWd1
bGF0b3Jfb3BzIG1jMTN4eHhfcmVndWxhdG9yX29wcyA9IHsKKwkuZW5hYmxlID0gbWMxM3h4eF9y
ZWd1bGF0b3JfZW5hYmxlLAorCS5kaXNhYmxlID0gbWMxM3h4eF9yZWd1bGF0b3JfZGlzYWJsZSwK
KwkuaXNfZW5hYmxlZCA9IG1jMTN4eHhfcmVndWxhdG9yX2lzX2VuYWJsZWQsCisJLmxpc3Rfdm9s
dGFnZSA9IG1jMTN4eHhfcmVndWxhdG9yX2xpc3Rfdm9sdGFnZSwKKwkuc2V0X3ZvbHRhZ2UgPSBt
YzEzeHh4X3JlZ3VsYXRvcl9zZXRfdm9sdGFnZSwKKwkuZ2V0X3ZvbHRhZ2UgPSBtYzEzeHh4X3Jl
Z3VsYXRvcl9nZXRfdm9sdGFnZSwKK307CisKK2ludCBtYzEzeHh4X2ZpeGVkX3JlZ3VsYXRvcl9z
ZXRfdm9sdGFnZShzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldiwKKwkJCQkJCWludCBtaW5fdVYs
IGludCBtYXhfdVYpCit7CisJc3RydWN0IG1jMTN4eHhfcmVndWxhdG9yX3ByaXYgKnByaXYgPSBy
ZGV2X2dldF9kcnZkYXRhKHJkZXYpOworCXN0cnVjdCBtYzEzeHh4X3JlZ3VsYXRvciAqbWMxM3h4
eF9yZWd1bGF0b3JzID0gcHJpdi0+bWMxM3h4eF9yZWd1bGF0b3JzOworCWludCBpZCA9IHJkZXZf
Z2V0X2lkKHJkZXYpOworCisJZGV2X2RiZyhyZGV2X2dldF9kZXYocmRldiksICIlcyBpZDogJWQg
bWluX3VWOiAlZCBtYXhfdVY6ICVkXG4iLAorCQlfX2Z1bmNfXywgaWQsIG1pbl91ViwgbWF4X3VW
KTsKKworCWlmIChtaW5fdVYgPj0gbWMxM3h4eF9yZWd1bGF0b3JzW2lkXS52b2x0YWdlc1swXSAm
JgorCSAgICBtYXhfdVYgPD0gbWMxM3h4eF9yZWd1bGF0b3JzW2lkXS52b2x0YWdlc1swXSkKKwkJ
cmV0dXJuIDA7CisJZWxzZQorCQlyZXR1cm4gLUVJTlZBTDsKK30KKworaW50IG1jMTN4eHhfZml4
ZWRfcmVndWxhdG9yX2dldF92b2x0YWdlKHN0cnVjdCByZWd1bGF0b3JfZGV2ICpyZGV2KQorewor
CXN0cnVjdCBtYzEzeHh4X3JlZ3VsYXRvcl9wcml2ICpwcml2ID0gcmRldl9nZXRfZHJ2ZGF0YShy
ZGV2KTsKKwlzdHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3IgKm1jMTN4eHhfcmVndWxhdG9ycyA9IHBy
aXYtPm1jMTN4eHhfcmVndWxhdG9yczsKKwlpbnQgaWQgPSByZGV2X2dldF9pZChyZGV2KTsKKwor
CWRldl9kYmcocmRldl9nZXRfZGV2KHJkZXYpLCAiJXMgaWQ6ICVkXG4iLCBfX2Z1bmNfXywgaWQp
OworCisJcmV0dXJuIG1jMTN4eHhfcmVndWxhdG9yc1tpZF0udm9sdGFnZXNbMF07Cit9CisKK3N0
cnVjdCByZWd1bGF0b3Jfb3BzIG1jMTN4eHhfZml4ZWRfcmVndWxhdG9yX29wcyA9IHsKKwkuZW5h
YmxlID0gbWMxM3h4eF9yZWd1bGF0b3JfZW5hYmxlLAorCS5kaXNhYmxlID0gbWMxM3h4eF9yZWd1
bGF0b3JfZGlzYWJsZSwKKwkuaXNfZW5hYmxlZCA9IG1jMTN4eHhfcmVndWxhdG9yX2lzX2VuYWJs
ZWQsCisJLmxpc3Rfdm9sdGFnZSA9IG1jMTN4eHhfcmVndWxhdG9yX2xpc3Rfdm9sdGFnZSwKKwku
c2V0X3ZvbHRhZ2UgPSBtYzEzeHh4X2ZpeGVkX3JlZ3VsYXRvcl9zZXRfdm9sdGFnZSwKKwkuZ2V0
X3ZvbHRhZ2UgPSBtYzEzeHh4X2ZpeGVkX3JlZ3VsYXRvcl9nZXRfdm9sdGFnZSwKK307CisKK2lu
dCBtYzEzeHh4X3N3X3JlZ3VsYXRvcihzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldikKK3sKKwly
ZXR1cm4gMDsKK30KKworaW50IG1jMTN4eHhfc3dfcmVndWxhdG9yX2lzX2VuYWJsZWQoc3RydWN0
IHJlZ3VsYXRvcl9kZXYgKnJkZXYpCit7CisJcmV0dXJuIDE7Cit9CisKK01PRFVMRV9MSUNFTlNF
KCJHUEwgdjIiKTsKK01PRFVMRV9BVVRIT1IoIllvbmcgU2hlbiA8eW9uZy5zaGVuQGxpbmFyby5v
cmc+Iik7CitNT0RVTEVfREVTQ1JJUFRJT04oIlJlZ3VsYXRvciBEcml2ZXIgZm9yIEZyZWVzY2Fs
ZSBNQzEzeHh4IFBNSUMiKTsKK01PRFVMRV9BTElBUygicGxhdGZvcm06bWMxM3h4eC1yZWd1bGF0
b3ItY29yZSIpOwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tZmQvbWMxMzc4My5oIGIvaW5j
bHVkZS9saW51eC9tZmQvbWMxMzc4My5oCmluZGV4IGI0Yzc0MWUuLjdkMGYzZDYgMTAwNjQ0Ci0t
LSBhL2luY2x1ZGUvbGludXgvbWZkL21jMTM3ODMuaAorKysgYi9pbmNsdWRlL2xpbnV4L21mZC9t
YzEzNzgzLmgKQEAgLTEsNCArMSw1IEBACiAvKgorICogQ29weXJpZ2h0IDIwMTAgWW9uZyBTaGVu
IDx5b25nLnNoZW5AbGluYXJvLm9yZz4KICAqIENvcHlyaWdodCAyMDA5LTIwMTAgUGVuZ3V0cm9u
aXgKICAqIFV3ZSBLbGVpbmUtS29lbmlnIDx1LmtsZWluZS1rb2VuaWdAcGVuZ3V0cm9uaXguZGU+
CiAgKgpAQCAtMTIyLDM5ICsxMjMsMzkgQEAgaW50IG1jMTM3ODNfYWRjX2RvX2NvbnZlcnNpb24o
c3RydWN0IG1jMTM3ODMgKm1jMTM3ODMsIHVuc2lnbmVkIGludCBtb2RlLAogCQl1bnNpZ25lZCBp
bnQgY2hhbm5lbCwgdW5zaWduZWQgaW50ICpzYW1wbGUpOwogCiAKLSNkZWZpbmUJTUMxMzc4M19T
V19TVzFBCQkwCi0jZGVmaW5lCU1DMTM3ODNfU1dfU1cxQgkJMQotI2RlZmluZQlNQzEzNzgzX1NX
X1NXMkEJCTIKLSNkZWZpbmUJTUMxMzc4M19TV19TVzJCCQkzCi0jZGVmaW5lCU1DMTM3ODNfU1df
U1czCQk0Ci0jZGVmaW5lCU1DMTM3ODNfU1dfUExMCQk1Ci0jZGVmaW5lCU1DMTM3ODNfUkVHVV9W
QVVESU8JNgotI2RlZmluZQlNQzEzNzgzX1JFR1VfVklPSEkJNwotI2RlZmluZQlNQzEzNzgzX1JF
R1VfVklPTE8JOAotI2RlZmluZQlNQzEzNzgzX1JFR1VfVkRJRwk5Ci0jZGVmaW5lCU1DMTM3ODNf
UkVHVV9WR0VOCTEwCi0jZGVmaW5lCU1DMTM3ODNfUkVHVV9WUkZESUcJMTEKLSNkZWZpbmUJTUMx
Mzc4M19SRUdVX1ZSRlJFRgkxMgotI2RlZmluZQlNQzEzNzgzX1JFR1VfVlJGQ1AJMTMKLSNkZWZp
bmUJTUMxMzc4M19SRUdVX1ZTSU0JMTQKLSNkZWZpbmUJTUMxMzc4M19SRUdVX1ZFU0lNCTE1Ci0j
ZGVmaW5lCU1DMTM3ODNfUkVHVV9WQ0FNCTE2Ci0jZGVmaW5lCU1DMTM3ODNfUkVHVV9WUkZCRwkx
NwotI2RlZmluZQlNQzEzNzgzX1JFR1VfVlZJQgkxOAotI2RlZmluZQlNQzEzNzgzX1JFR1VfVlJG
MQkxOQotI2RlZmluZQlNQzEzNzgzX1JFR1VfVlJGMgkyMAotI2RlZmluZQlNQzEzNzgzX1JFR1Vf
Vk1NQzEJMjEKLSNkZWZpbmUJTUMxMzc4M19SRUdVX1ZNTUMyCTIyCi0jZGVmaW5lCU1DMTM3ODNf
UkVHVV9HUE8xCTIzCi0jZGVmaW5lCU1DMTM3ODNfUkVHVV9HUE8yCTI0Ci0jZGVmaW5lCU1DMTM3
ODNfUkVHVV9HUE8zCTI1Ci0jZGVmaW5lCU1DMTM3ODNfUkVHVV9HUE80CTI2Ci0jZGVmaW5lCU1D
MTM3ODNfUkVHVV9WMQkJMjcKLSNkZWZpbmUJTUMxMzc4M19SRUdVX1YyCQkyOAotI2RlZmluZQlN
QzEzNzgzX1JFR1VfVjMJCTI5Ci0jZGVmaW5lCU1DMTM3ODNfUkVHVV9WNAkJMzAKLSNkZWZpbmUJ
TUMxMzc4M19SRUdVX1BXR1QxU1BJCTMxCi0jZGVmaW5lCU1DMTM3ODNfUkVHVV9QV0dUMlNQSQkz
MgorI2RlZmluZQlNQzEzNzgzX1JFR19TVzFBCQkwCisjZGVmaW5lCU1DMTM3ODNfUkVHX1NXMUIJ
CTEKKyNkZWZpbmUJTUMxMzc4M19SRUdfU1cyQQkJMgorI2RlZmluZQlNQzEzNzgzX1JFR19TVzJC
CQkzCisjZGVmaW5lCU1DMTM3ODNfUkVHX1NXMwkJNAorI2RlZmluZQlNQzEzNzgzX1JFR19QTEwJ
CTUKKyNkZWZpbmUJTUMxMzc4M19SRUdfVkFVRElPCTYKKyNkZWZpbmUJTUMxMzc4M19SRUdfVklP
SEkJNworI2RlZmluZQlNQzEzNzgzX1JFR19WSU9MTwk4CisjZGVmaW5lCU1DMTM3ODNfUkVHX1ZE
SUcJOQorI2RlZmluZQlNQzEzNzgzX1JFR19WR0VOCTEwCisjZGVmaW5lCU1DMTM3ODNfUkVHX1ZS
RkRJRwkxMQorI2RlZmluZQlNQzEzNzgzX1JFR19WUkZSRUYJMTIKKyNkZWZpbmUJTUMxMzc4M19S
RUdfVlJGQ1AJMTMKKyNkZWZpbmUJTUMxMzc4M19SRUdfVlNJTQkxNAorI2RlZmluZQlNQzEzNzgz
X1JFR19WRVNJTQkxNQorI2RlZmluZQlNQzEzNzgzX1JFR19WQ0FNCTE2CisjZGVmaW5lCU1DMTM3
ODNfUkVHX1ZSRkJHCTE3CisjZGVmaW5lCU1DMTM3ODNfUkVHX1ZWSUIJMTgKKyNkZWZpbmUJTUMx
Mzc4M19SRUdfVlJGMQkxOQorI2RlZmluZQlNQzEzNzgzX1JFR19WUkYyCTIwCisjZGVmaW5lCU1D
MTM3ODNfUkVHX1ZNTUMxCTIxCisjZGVmaW5lCU1DMTM3ODNfUkVHX1ZNTUMyCTIyCisjZGVmaW5l
CU1DMTM3ODNfUkVHX0dQTzEJMjMKKyNkZWZpbmUJTUMxMzc4M19SRUdfR1BPMgkyNAorI2RlZmlu
ZQlNQzEzNzgzX1JFR19HUE8zCTI1CisjZGVmaW5lCU1DMTM3ODNfUkVHX0dQTzQJMjYKKyNkZWZp
bmUJTUMxMzc4M19SRUdfVjEJCTI3CisjZGVmaW5lCU1DMTM3ODNfUkVHX1YyCQkyOAorI2RlZmlu
ZQlNQzEzNzgzX1JFR19WMwkJMjkKKyNkZWZpbmUJTUMxMzc4M19SRUdfVjQJCTMwCisjZGVmaW5l
CU1DMTM3ODNfUkVHX1BXR1QxU1BJCTMxCisjZGVmaW5lCU1DMTM3ODNfUkVHX1BXR1QyU1BJCTMy
CiAKICNkZWZpbmUgTUMxMzc4M19JUlFfQURDRE9ORQlNQzEzWFhYX0lSUV9BRENET05FCiAjZGVm
aW5lIE1DMTM3ODNfSVJRX0FEQ0JJU0RPTkUJTUMxM1hYWF9JUlFfQURDQklTRE9ORQpkaWZmIC0t
Z2l0IGEvaW5jbHVkZS9saW51eC9yZWd1bGF0b3IvbWMxM3h4eC5oIGIvaW5jbHVkZS9saW51eC9y
ZWd1bGF0b3IvbWMxM3h4eC5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLmE2
MGM5YmUKLS0tIC9kZXYvbnVsbAorKysgYi9pbmNsdWRlL2xpbnV4L3JlZ3VsYXRvci9tYzEzeHh4
LmgKQEAgLTAsMCArMSwxMDEgQEAKKy8qCisgKiBtYzEzeHh4LmggLSByZWd1bGF0b3JzIGZvciB0
aGUgRnJlZXNjYWxlIG1jMTN4eHggUE1JQworICoKKyAqICBDb3B5cmlnaHQgKEMpIDIwMTAgWW9u
ZyBTaGVuIDx5b25nLnNoZW5AbGluYXJvLm9yZz4KKyAqCisgKiBUaGlzIHByb2dyYW0gaXMgZnJl
ZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQorICogaXQg
dW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJs
aXNoZWQgYnkKKyAqIHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJzaW9u
IDIgb2YgdGhlIExpY2Vuc2UsIG9yCisgKiAoYXQgeW91ciBvcHRpb24pIGFueSBsYXRlciB2ZXJz
aW9uLgorICovCisKKyNpZm5kZWYgX19MSU5VWF9SRUdVTEFUT1JfTUMxM1hYWF9ICisjZGVmaW5l
IF9fTElOVVhfUkVHVUxBVE9SX01DMTNYWFhfSAorCisjaW5jbHVkZSA8bGludXgvcmVndWxhdG9y
L2RyaXZlci5oPgorCitzdHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3IgeworCXN0cnVjdCByZWd1bGF0
b3JfZGVzYyBkZXNjOworCWludCByZWc7CisJaW50IGVuYWJsZV9iaXQ7CisJaW50IHZzZWxfcmVn
OworCWludCB2c2VsX3NoaWZ0OworCWludCB2c2VsX21hc2s7CisJaW50IGhpX2JpdDsKKwlpbnQg
Y29uc3QgKnZvbHRhZ2VzOworfTsKKworc3RydWN0IG1jMTN4eHhfcmVndWxhdG9yX3ByaXYgewor
CXN0cnVjdCBtYzEzeHh4ICptYzEzeHh4OworCXUzMiBwb3dlcm1pc2NfcHdndF9zdGF0ZTsKKwlz
dHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3IgKm1jMTN4eHhfcmVndWxhdG9yczsKKwlzdHJ1Y3QgcmVn
dWxhdG9yX2RldiAqcmVndWxhdG9yc1tdOworfTsKKworZXh0ZXJuIGludCBtYzEzeHh4X3N3X3Jl
Z3VsYXRvcihzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldik7CitleHRlcm4gaW50IG1jMTN4eHhf
c3dfcmVndWxhdG9yX2lzX2VuYWJsZWQoc3RydWN0IHJlZ3VsYXRvcl9kZXYgKnJkZXYpOworZXh0
ZXJuIGludCBtYzEzeHh4X2dldF9iZXN0X3ZvbHRhZ2VfaW5kZXgoc3RydWN0IHJlZ3VsYXRvcl9k
ZXYgKnJkZXYsCisJCQkJCQlpbnQgbWluX3VWLCBpbnQgbWF4X3VWKTsKK2V4dGVybiBpbnQgbWMx
M3h4eF9yZWd1bGF0b3JfbGlzdF92b2x0YWdlKHN0cnVjdCByZWd1bGF0b3JfZGV2ICpyZGV2LAor
CQkJCQkJdW5zaWduZWQgc2VsZWN0b3IpOworZXh0ZXJuIGludCBtYzEzeHh4X2ZpeGVkX3JlZ3Vs
YXRvcl9zZXRfdm9sdGFnZShzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldiwKKwkJCQkJCWludCBt
aW5fdVYsIGludCBtYXhfdVYpOworZXh0ZXJuIGludCBtYzEzeHh4X2ZpeGVkX3JlZ3VsYXRvcl9n
ZXRfdm9sdGFnZShzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldik7CisKK2V4dGVybiBzdHJ1Y3Qg
cmVndWxhdG9yX29wcyBtYzEzeHh4X3JlZ3VsYXRvcl9vcHM7CitleHRlcm4gc3RydWN0IHJlZ3Vs
YXRvcl9vcHMgbWMxM3h4eF9maXhlZF9yZWd1bGF0b3Jfb3BzOworCisjZGVmaW5lIE1DMTN4eHhf
REVGSU5FKHByZWZpeCwgX25hbWUsIF9yZWcsIF92c2VsX3JlZywgX3ZvbHRhZ2VzLCBfb3BzKQlc
CisJW3ByZWZpeCAjIyBfbmFtZV0gPSB7CQkJCVwKKwkJLmRlc2MgPSB7CQkJCQkJXAorCQkJLm5h
bWUgPSAjcHJlZml4ICJfIiAjX25hbWUsCQkJXAorCQkJLm5fdm9sdGFnZXMgPSBBUlJBWV9TSVpF
KF92b2x0YWdlcyksCQlcCisJCQkub3BzID0gJl9vcHMsCQkJXAorCQkJLnR5cGUgPSBSRUdVTEFU
T1JfVk9MVEFHRSwJCQlcCisJCQkuaWQgPSBwcmVmaXggIyMgX25hbWUsCQlcCisJCQkub3duZXIg
PSBUSElTX01PRFVMRSwJCQkJXAorCQl9LAkJCQkJCQlcCisJCS5yZWcgPSBwcmVmaXggIyMgX3Jl
ZywJCQkJXAorCQkuZW5hYmxlX2JpdCA9IHByZWZpeCAjIyBfcmVnICMjIF8gIyMgX25hbWUgIyMg
RU4sCVwKKwkJLnZzZWxfcmVnID0gcHJlZml4ICMjIF92c2VsX3JlZywJCQlcCisJCS52c2VsX3No
aWZ0ID0gcHJlZml4ICMjIF92c2VsX3JlZyAjIyBfICMjIF9uYW1lICMjIFZTRUwsXAorCQkudnNl
bF9tYXNrID0gcHJlZml4ICMjIF92c2VsX3JlZyAjIyBfICMjIF9uYW1lICMjIFZTRUxfTSxcCisJ
CS52b2x0YWdlcyA9ICBfdm9sdGFnZXMsCQkJCQlcCisJfQorCisjZGVmaW5lIE1DMTN4eHhfRklY
RURfREVGSU5FKHByZWZpeCwgX25hbWUsIF9yZWcsIF92b2x0YWdlcywgX29wcykJXAorCVtwcmVm
aXggIyMgX25hbWVdID0gewkJCQlcCisJCS5kZXNjID0gewkJCQkJCVwKKwkJCS5uYW1lID0gI3By
ZWZpeCAiXyIgI19uYW1lLAkJCVwKKwkJCS5uX3ZvbHRhZ2VzID0gQVJSQVlfU0laRShfdm9sdGFn
ZXMpLAkJXAorCQkJLm9wcyA9ICZfb3BzLAkJXAorCQkJLnR5cGUgPSBSRUdVTEFUT1JfVk9MVEFH
RSwJCQlcCisJCQkuaWQgPSBwcmVmaXggIyMgX25hbWUsCQlcCisJCQkub3duZXIgPSBUSElTX01P
RFVMRSwJCQkJXAorCQl9LAkJCQkJCQlcCisJCS5yZWcgPSBwcmVmaXggIyMgX3JlZywJCQkJXAor
CQkuZW5hYmxlX2JpdCA9IHByZWZpeCAjIyBfcmVnICMjIF8gIyMgX25hbWUgIyMgRU4sCVwKKwkJ
LnZvbHRhZ2VzID0gIF92b2x0YWdlcywJCQkJCVwKKwl9CisKKyNkZWZpbmUgTUMxM3h4eF9HUE9f
REVGSU5FKHByZWZpeCwgX25hbWUsIF9yZWcsICBfdm9sdGFnZXMsIF9vcHMpCVwKKwlbcHJlZml4
ICMjIF9uYW1lXSA9IHsJCQkJXAorCQkuZGVzYyA9IHsJCQkJCQlcCisJCQkubmFtZSA9ICNwcmVm
aXggIl8iICNfbmFtZSwJCQlcCisJCQkubl92b2x0YWdlcyA9IEFSUkFZX1NJWkUoX3ZvbHRhZ2Vz
KSwJCVwKKwkJCS5vcHMgPSAmX29wcywJCVwKKwkJCS50eXBlID0gUkVHVUxBVE9SX1ZPTFRBR0Us
CQkJXAorCQkJLmlkID0gcHJlZml4ICMjIF9uYW1lLAkJXAorCQkJLm93bmVyID0gVEhJU19NT0RV
TEUsCQkJCVwKKwkJfSwJCQkJCQkJXAorCQkucmVnID0gcHJlZml4ICMjIF9yZWcsCQkJCVwKKwkJ
LmVuYWJsZV9iaXQgPSBwcmVmaXggIyMgX3JlZyAjIyBfICMjIF9uYW1lICMjIEVOLAlcCisJCS52
b2x0YWdlcyA9ICBfdm9sdGFnZXMsCQkJCQlcCisJfQorCisjZGVmaW5lIE1DMTN4eHhfREVGSU5F
X1NXKF9uYW1lLCBfcmVnLCBfdnNlbF9yZWcsIF92b2x0YWdlcywgb3BzKQlcCisJTUMxM3h4eF9E
RUZJTkUoU1csIF9uYW1lLCBfcmVnLCBfdnNlbF9yZWcsIF92b2x0YWdlcywgb3BzKQorI2RlZmlu
ZSBNQzEzeHh4X0RFRklORV9SRUdVKF9uYW1lLCBfcmVnLCBfdnNlbF9yZWcsIF92b2x0YWdlcywg
b3BzKQlcCisJTUMxM3h4eF9ERUZJTkUoUkVHVSwgX25hbWUsIF9yZWcsIF92c2VsX3JlZywgX3Zv
bHRhZ2VzLCBvcHMpCisKKyNlbmRpZgotLSAKMS43LjAuNAoK
--0015174c36b284967a04965413ed--
