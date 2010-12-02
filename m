Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab0LBKpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:45:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62550 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab0LBKpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:45:33 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=E8etAOPTCBw8ccTZ9LMU-Yf=wELn+VQkg2eom@mail.gmail.com>
References: <AANLkTi=E8etAOPTCBw8ccTZ9LMU-Yf=wELn+VQkg2eom@mail.gmail.com>
Date: Thu, 2 Dec 2010 18:45:32 +0800
Message-ID: <AANLkTim4TURXFb3g_L1jzU9S+Jic6OZp48uvAoZOh4+w@mail.gmail.com>
Subject: [PATCH 2/2] make mc13783 regulator code generic
From: Yong Shen <yong.shen@linaro.org>
To: List Linux Arm Kernel <linux-arm-kernel@lists.infradead.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd485a0fd70b404966b1e0e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd485a0fd70b404966b1e0e
Content-Type: text/plain; charset=ISO-8859-1

Hi there,

Please give comments inline and use attached patch for testing.

Thanks
Yong


>From 377c680c35089aea7697397c42349189843eeaff Mon Sep 17 00:00:00 2001
From: Yong Shen <yong.shen@linaro.org>
Date: Thu, 2 Dec 2010 14:59:00 +0800
Subject: [PATCH 2/2] make mc13783 regulator code generic

move some common functions and micros of mc13783 regulaor driver to
a seperate file, which makes it possible for mc13892 to share code.

Signed-off-by: Yong Shen <yong.shen@linaro.org>
---
 drivers/regulator/Kconfig                  |    4 +
 drivers/regulator/Makefile                 |    1 +
 drivers/regulator/mc13783-regulator.c      |  317 ++++------------------------
 drivers/regulator/mc13xxx-regulator-core.c |  234 ++++++++++++++++++++
 drivers/regulator/mc13xxx.h                |  101 +++++++++
 5 files changed, 382 insertions(+), 275 deletions(-)
 create mode 100644 drivers/regulator/mc13xxx-regulator-core.c
 create mode 100644 drivers/regulator/mc13xxx.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index dd30e88..6e54253 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -186,9 +186,13 @@ config REGULATOR_PCAP
 	 This driver provides support for the voltage regulators of the
 	 PCAP2 PMIC.

+config REGULATOR_MC13XXX_CORE
+	bool
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
index e4f2787..48c4cb4 100644
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
@@ -17,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include "mc13xxx.h"

 #define MC13783_REG_SWITCHERS5			29
 #define MC13783_REG_SWITCHERS5_SW3EN			(1 << 20)
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
 	MC13783_DEFINE(REG, _name, _reg, _vsel_reg, _voltages)
 #define MC13783_DEFINE_REGU(_name, _reg, _vsel_reg, _voltages)		\
 	MC13783_DEFINE(REG, _name, _reg, _vsel_reg, _voltages)

-static struct mc13783_regulator mc13783_regulators[] = {
+static struct mc13xxx_regulator mc13783_regulators[] = {
 	MC13783_DEFINE_SW(SW3, SWITCHERS5, SWITCHERS5, mc13783_sw3_val),

 	MC13783_FIXED_DEFINE(REG, VAUDIO, REGULATORMODE0, mc13783_vaudio_val),
@@ -274,207 +228,16 @@ static struct mc13783_regulator mc13783_regulators[] = {
 	MC13783_GPO_DEFINE(REG, PWGT2SPI, POWERMISC, mc13783_pwgtdrv_val),
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

@@ -489,15 +252,16 @@ int mc13783_powermisc_rmw(struct
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

@@ -506,17 +270,18 @@ static int mc13783_gpo_regulator_enable(struct
regulator_dev *rdev)
 	    id == MC13783_REG_PWGT2SPI)
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
@@ -526,25 +291,26 @@ static int mc13783_gpo_regulator_disable(struct
regulator_dev *rdev)
 	/* Power Gate disable value is 1 */
 	if (id == MC13783_REG_PWGT1SPI ||
 	    id == MC13783_REG_PWGT2SPI)
-		dis_val = mc13783_regulators[id].enable_bit;
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
index 0000000..bf53ff6
--- /dev/null
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -0,0 +1,234 @@
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
+#include <linux/regulator/machine.h>
+#include <linux/regulator/driver.h>
+#include <linux/platform_device.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include "mc13xxx.h"
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
+int mc13xxx_sw_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	return 1;
+}
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Yong Shen <yong.shen@linaro.org>");
+MODULE_DESCRIPTION("Regulator Driver for Freescale MC13xxx PMIC");
+MODULE_ALIAS("mc13xxx-regulator-core");
diff --git a/drivers/regulator/mc13xxx.h b/drivers/regulator/mc13xxx.h
new file mode 100644
index 0000000..a60c9be
--- /dev/null
+++ b/drivers/regulator/mc13xxx.h
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

--000e0cd485a0fd70b404966b1e0e
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0002-make-mc13783-regulator-code-generic.patch"
Content-Disposition: attachment; 
	filename="0002-make-mc13783-regulator-code-generic.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gh7itp3b1

RnJvbSAzNzdjNjgwYzM1MDg5YWVhNzY5NzM5N2M0MjM0OTE4OTg0M2VlYWZmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZb25nIFNoZW4gPHlvbmcuc2hlbkBsaW5hcm8ub3JnPgpEYXRl
OiBUaHUsIDIgRGVjIDIwMTAgMTQ6NTk6MDAgKzA4MDAKU3ViamVjdDogW1BBVENIIDIvMl0gbWFr
ZSBtYzEzNzgzIHJlZ3VsYXRvciBjb2RlIGdlbmVyaWMKCm1vdmUgc29tZSBjb21tb24gZnVuY3Rp
b25zIGFuZCBtaWNyb3Mgb2YgbWMxMzc4MyByZWd1bGFvciBkcml2ZXIgdG8KYSBzZXBlcmF0ZSBm
aWxlLCB3aGljaCBtYWtlcyBpdCBwb3NzaWJsZSBmb3IgbWMxMzg5MiB0byBzaGFyZSBjb2RlLgoK
U2lnbmVkLW9mZi1ieTogWW9uZyBTaGVuIDx5b25nLnNoZW5AbGluYXJvLm9yZz4KLS0tCiBkcml2
ZXJzL3JlZ3VsYXRvci9LY29uZmlnICAgICAgICAgICAgICAgICAgfCAgICA0ICsKIGRyaXZlcnMv
cmVndWxhdG9yL01ha2VmaWxlICAgICAgICAgICAgICAgICB8ICAgIDEgKwogZHJpdmVycy9yZWd1
bGF0b3IvbWMxMzc4My1yZWd1bGF0b3IuYyAgICAgIHwgIDMxNyArKysrLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tCiBkcml2ZXJzL3JlZ3VsYXRvci9tYzEzeHh4LXJlZ3VsYXRvci1jb3JlLmMgfCAg
MjM0ICsrKysrKysrKysrKysrKysrKysrCiBkcml2ZXJzL3JlZ3VsYXRvci9tYzEzeHh4LmggICAg
ICAgICAgICAgICAgfCAgMTAxICsrKysrKysrKwogNSBmaWxlcyBjaGFuZ2VkLCAzODIgaW5zZXJ0
aW9ucygrKSwgMjc1IGRlbGV0aW9ucygtKQogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvcmVn
dWxhdG9yL21jMTN4eHgtcmVndWxhdG9yLWNvcmUuYwogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZl
cnMvcmVndWxhdG9yL21jMTN4eHguaAoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvcmVndWxhdG9yL0tj
b25maWcgYi9kcml2ZXJzL3JlZ3VsYXRvci9LY29uZmlnCmluZGV4IGRkMzBlODguLjZlNTQyNTMg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcmVndWxhdG9yL0tjb25maWcKKysrIGIvZHJpdmVycy9yZWd1
bGF0b3IvS2NvbmZpZwpAQCAtMTg2LDkgKzE4NiwxMyBAQCBjb25maWcgUkVHVUxBVE9SX1BDQVAK
IAkgVGhpcyBkcml2ZXIgcHJvdmlkZXMgc3VwcG9ydCBmb3IgdGhlIHZvbHRhZ2UgcmVndWxhdG9y
cyBvZiB0aGUKIAkgUENBUDIgUE1JQy4KIAorY29uZmlnIFJFR1VMQVRPUl9NQzEzWFhYX0NPUkUK
Kwlib29sCisKIGNvbmZpZyBSRUdVTEFUT1JfTUMxMzc4MwogCXRyaXN0YXRlICJTdXBwb3J0IHJl
Z3VsYXRvcnMgb24gRnJlZXNjYWxlIE1DMTM3ODMgUE1JQyIKIAlkZXBlbmRzIG9uIE1GRF9NQzEz
NzgzCisJc2VsZWN0IFJFR1VMQVRPUl9NQzEzWFhYX0NPUkUKIAloZWxwCiAJICBTYXkgeSBoZXJl
IHRvIHN1cHBvcnQgdGhlIHJlZ3VsYXRvcnMgZm91bmQgb24gdGhlIEZyZWVzY2FsZSBNQzEzNzgz
CiAJICBQTUlDLgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9yZWd1bGF0b3IvTWFrZWZpbGUgYi9kcml2
ZXJzL3JlZ3VsYXRvci9NYWtlZmlsZQppbmRleCBiZmY4MTU3Li4xMTg3NmJlIDEwMDY0NAotLS0g
YS9kcml2ZXJzL3JlZ3VsYXRvci9NYWtlZmlsZQorKysgYi9kcml2ZXJzL3JlZ3VsYXRvci9NYWtl
ZmlsZQpAQCAtMzAsNiArMzAsNyBAQCBvYmotJChDT05GSUdfUkVHVUxBVE9SX0RBOTAzWCkJKz0g
ZGE5MDN4Lm8KIG9iai0kKENPTkZJR19SRUdVTEFUT1JfUENGNTA2MzMpICs9IHBjZjUwNjMzLXJl
Z3VsYXRvci5vCiBvYmotJChDT05GSUdfUkVHVUxBVE9SX1BDQVApICs9IHBjYXAtcmVndWxhdG9y
Lm8KIG9iai0kKENPTkZJR19SRUdVTEFUT1JfTUMxMzc4MykgKz0gbWMxMzc4My1yZWd1bGF0b3Iu
bworb2JqLSQoQ09ORklHX1JFR1VMQVRPUl9NQzEzWFhYX0NPUkUpICs9ICBtYzEzeHh4LXJlZ3Vs
YXRvci1jb3JlLm8KIG9iai0kKENPTkZJR19SRUdVTEFUT1JfQUIzMTAwKSArPSBhYjMxMDAubwog
CiBvYmotJChDT05GSUdfUkVHVUxBVE9SX1RQUzY1MDIzKSArPSB0cHM2NTAyMy1yZWd1bGF0b3Iu
bwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9yZWd1bGF0b3IvbWMxMzc4My1yZWd1bGF0b3IuYyBiL2Ry
aXZlcnMvcmVndWxhdG9yL21jMTM3ODMtcmVndWxhdG9yLmMKaW5kZXggZTRmMjc4Ny4uNDhjNGNi
NCAxMDA2NDQKLS0tIGEvZHJpdmVycy9yZWd1bGF0b3IvbWMxMzc4My1yZWd1bGF0b3IuYworKysg
Yi9kcml2ZXJzL3JlZ3VsYXRvci9tYzEzNzgzLXJlZ3VsYXRvci5jCkBAIC0xLDYgKzEsNyBAQAog
LyoKICAqIFJlZ3VsYXRvciBEcml2ZXIgZm9yIEZyZWVzY2FsZSBNQzEzNzgzIFBNSUMKICAqCisg
KiBDb3B5cmlnaHQgMjAxMCBZb25nIFNoZW4gPHlvbmcuc2hlbkBsaW5hcm8ub3JnPgogICogQ29w
eXJpZ2h0IChDKSAyMDA4IFNhc2NoYSBIYXVlciwgUGVuZ3V0cm9uaXggPHMuaGF1ZXJAcGVuZ3V0
cm9uaXguZGU+CiAgKiBDb3B5cmlnaHQgMjAwOSBBbGJlcnRvIFBhbml6em8gPG1hcmFtYW9wZXJj
aGVzZWltb3J0b0BnbWFpbC5jb20+CiAgKgpAQCAtMTcsNiArMTgsNyBAQAogI2luY2x1ZGUgPGxp
bnV4L3NsYWIuaD4KICNpbmNsdWRlIDxsaW51eC9pbml0Lmg+CiAjaW5jbHVkZSA8bGludXgvZXJy
Lmg+CisjaW5jbHVkZSAibWMxM3h4eC5oIgogCiAjZGVmaW5lIE1DMTM3ODNfUkVHX1NXSVRDSEVS
UzUJCQkyOQogI2RlZmluZSBNQzEzNzgzX1JFR19TV0lUQ0hFUlM1X1NXM0VOCQkJKDEgPDwgMjAp
CkBAIC04OSwxNiArOTEsNiBAQAogI2RlZmluZSBNQzEzNzgzX1JFR19QT1dFUk1JU0NfUFdHVFNQ
SV9NCQkJKDMgPDwgMTUpCiAKIAotc3RydWN0IG1jMTM3ODNfcmVndWxhdG9yIHsKLQlzdHJ1Y3Qg
cmVndWxhdG9yX2Rlc2MgZGVzYzsKLQlpbnQgcmVnOwotCWludCBlbmFibGVfYml0OwotCWludCB2
c2VsX3JlZzsKLQlpbnQgdnNlbF9zaGlmdDsKLQlpbnQgdnNlbF9tYXNrOwotCWludCBjb25zdCAq
dm9sdGFnZXM7Ci19OwotCiAvKiBWb2x0YWdlIFZhbHVlcyAqLwogc3RhdGljIGNvbnN0IGludCBj
b25zdCBtYzEzNzgzX3N3M192YWxbXSA9IHsKIAk1MDAwMDAwLCA1MDAwMDAwLCA1MDAwMDAwLCA1
NTAwMDAwLApAQCAtMTc1LDY0ICsxNjcsMjYgQEAgc3RhdGljIGNvbnN0IGludCBjb25zdCBtYzEz
NzgzX3B3Z3RkcnZfdmFsW10gPSB7CiAJNTUwMDAwMCwKIH07CiAKLXN0YXRpYyBzdHJ1Y3QgcmVn
dWxhdG9yX29wcyBtYzEzNzgzX3JlZ3VsYXRvcl9vcHM7Ci1zdGF0aWMgc3RydWN0IHJlZ3VsYXRv
cl9vcHMgbWMxMzc4M19maXhlZF9yZWd1bGF0b3Jfb3BzOwogc3RhdGljIHN0cnVjdCByZWd1bGF0
b3Jfb3BzIG1jMTM3ODNfZ3BvX3JlZ3VsYXRvcl9vcHM7CiAKLSNkZWZpbmUgTUMxMzc4M19ERUZJ
TkUocHJlZml4LCBfbmFtZSwgX3JlZywgX3ZzZWxfcmVnLCBfdm9sdGFnZXMpCVwKLQlbTUMxMzc4
M18gIyMgcHJlZml4ICMjIF8gIyMgX25hbWVdID0gewkJCQlcCi0JCS5kZXNjID0gewkJCQkJCVwK
LQkJCS5uYW1lID0gI3ByZWZpeCAiXyIgI19uYW1lLAkJCVwKLQkJCS5uX3ZvbHRhZ2VzID0gQVJS
QVlfU0laRShfdm9sdGFnZXMpLAkJXAotCQkJLm9wcyA9ICZtYzEzNzgzX3JlZ3VsYXRvcl9vcHMs
CQkJXAotCQkJLnR5cGUgPSBSRUdVTEFUT1JfVk9MVEFHRSwJCQlcCi0JCQkuaWQgPSBNQzEzNzgz
XyAjIyBwcmVmaXggIyMgXyAjIyBfbmFtZSwJCVwKLQkJCS5vd25lciA9IFRISVNfTU9EVUxFLAkJ
CQlcCi0JCX0sCQkJCQkJCVwKLQkJLnJlZyA9IE1DMTM3ODNfUkVHXyAjIyBfcmVnLAkJCQlcCi0J
CS5lbmFibGVfYml0ID0gTUMxMzc4M19SRUdfICMjIF9yZWcgIyMgXyAjIyBfbmFtZSAjIyBFTiwJ
XAotCQkudnNlbF9yZWcgPSBNQzEzNzgzX1JFR18gIyMgX3ZzZWxfcmVnLAkJCVwKLQkJLnZzZWxf
c2hpZnQgPSBNQzEzNzgzX1JFR18gIyMgX3ZzZWxfcmVnICMjIF8gIyMgX25hbWUgIyMgVlNFTCxc
Ci0JCS52c2VsX21hc2sgPSBNQzEzNzgzX1JFR18gIyMgX3ZzZWxfcmVnICMjIF8gIyMgX25hbWUg
IyMgVlNFTF9NLFwKLQkJLnZvbHRhZ2VzID0gIF92b2x0YWdlcywJCQkJCVwKLQl9CisjZGVmaW5l
IE1DMTM3ODNfREVGSU5FKHByZWZpeCwgbmFtZSwgcmVnLCB2c2VsX3JlZywgdm9sdGFnZXMpCVwK
KwlNQzEzeHh4X0RFRklORShNQzEzNzgzX1JFR18sIG5hbWUsIHJlZywgdnNlbF9yZWcsIHZvbHRh
Z2VzLCBcCisJCQltYzEzeHh4X3JlZ3VsYXRvcl9vcHMpCiAKLSNkZWZpbmUgTUMxMzc4M19GSVhF
RF9ERUZJTkUocHJlZml4LCBfbmFtZSwgX3JlZywgX3ZvbHRhZ2VzKQkJXAotCVtNQzEzNzgzXyAj
IyBwcmVmaXggIyMgXyAjIyBfbmFtZV0gPSB7CQkJCVwKLQkJLmRlc2MgPSB7CQkJCQkJXAotCQkJ
Lm5hbWUgPSAjcHJlZml4ICJfIiAjX25hbWUsCQkJXAotCQkJLm5fdm9sdGFnZXMgPSBBUlJBWV9T
SVpFKF92b2x0YWdlcyksCQlcCi0JCQkub3BzID0gJm1jMTM3ODNfZml4ZWRfcmVndWxhdG9yX29w
cywJCVwKLQkJCS50eXBlID0gUkVHVUxBVE9SX1ZPTFRBR0UsCQkJXAotCQkJLmlkID0gTUMxMzc4
M18gIyMgcHJlZml4ICMjIF8gIyMgX25hbWUsCQlcCi0JCQkub3duZXIgPSBUSElTX01PRFVMRSwJ
CQkJXAotCQl9LAkJCQkJCQlcCi0JCS5yZWcgPSBNQzEzNzgzX1JFR18gIyMgX3JlZywJCQkJXAot
CQkuZW5hYmxlX2JpdCA9IE1DMTM3ODNfUkVHXyAjIyBfcmVnICMjIF8gIyMgX25hbWUgIyMgRU4s
CVwKLQkJLnZvbHRhZ2VzID0gIF92b2x0YWdlcywJCQkJCVwKLQl9CisjZGVmaW5lIE1DMTM3ODNf
RklYRURfREVGSU5FKHByZWZpeCwgbmFtZSwgcmVnLCB2b2x0YWdlcykJCVwKKwlNQzEzeHh4X0ZJ
WEVEX0RFRklORShNQzEzNzgzX1JFR18sIG5hbWUsIHJlZywgdm9sdGFnZXMsIFwKKwkJCW1jMTN4
eHhfZml4ZWRfcmVndWxhdG9yX29wcykKIAotI2RlZmluZSBNQzEzNzgzX0dQT19ERUZJTkUocHJl
Zml4LCBfbmFtZSwgX3JlZywgIF92b2x0YWdlcykJCVwKLQlbTUMxMzc4M18gIyMgcHJlZml4ICMj
IF8gIyMgX25hbWVdID0gewkJCQlcCi0JCS5kZXNjID0gewkJCQkJCVwKLQkJCS5uYW1lID0gI3By
ZWZpeCAiXyIgI19uYW1lLAkJCVwKLQkJCS5uX3ZvbHRhZ2VzID0gQVJSQVlfU0laRShfdm9sdGFn
ZXMpLAkJXAotCQkJLm9wcyA9ICZtYzEzNzgzX2dwb19yZWd1bGF0b3Jfb3BzLAkJXAotCQkJLnR5
cGUgPSBSRUdVTEFUT1JfVk9MVEFHRSwJCQlcCi0JCQkuaWQgPSBNQzEzNzgzXyAjIyBwcmVmaXgg
IyMgXyAjIyBfbmFtZSwJCVwKLQkJCS5vd25lciA9IFRISVNfTU9EVUxFLAkJCQlcCi0JCX0sCQkJ
CQkJCVwKLQkJLnJlZyA9IE1DMTM3ODNfUkVHXyAjIyBfcmVnLAkJCQlcCi0JCS5lbmFibGVfYml0
ID0gTUMxMzc4M19SRUdfICMjIF9yZWcgIyMgXyAjIyBfbmFtZSAjIyBFTiwJXAotCQkudm9sdGFn
ZXMgPSAgX3ZvbHRhZ2VzLAkJCQkJXAotCX0KKyNkZWZpbmUgTUMxMzc4M19HUE9fREVGSU5FKHBy
ZWZpeCwgbmFtZSwgcmVnLCB2b2x0YWdlcykJCVwKKwlNQzEzeHh4X0dQT19ERUZJTkUoTUMxMzc4
M19SRUdfLCBuYW1lLCByZWcsIHZvbHRhZ2VzLCBcCisJCQltYzEzNzgzX2dwb19yZWd1bGF0b3Jf
b3BzKQogCiAjZGVmaW5lIE1DMTM3ODNfREVGSU5FX1NXKF9uYW1lLCBfcmVnLCBfdnNlbF9yZWcs
IF92b2x0YWdlcykJCVwKIAlNQzEzNzgzX0RFRklORShSRUcsIF9uYW1lLCBfcmVnLCBfdnNlbF9y
ZWcsIF92b2x0YWdlcykKICNkZWZpbmUgTUMxMzc4M19ERUZJTkVfUkVHVShfbmFtZSwgX3JlZywg
X3ZzZWxfcmVnLCBfdm9sdGFnZXMpCQlcCiAJTUMxMzc4M19ERUZJTkUoUkVHLCBfbmFtZSwgX3Jl
ZywgX3ZzZWxfcmVnLCBfdm9sdGFnZXMpCiAKLXN0YXRpYyBzdHJ1Y3QgbWMxMzc4M19yZWd1bGF0
b3IgbWMxMzc4M19yZWd1bGF0b3JzW10gPSB7CitzdGF0aWMgc3RydWN0IG1jMTN4eHhfcmVndWxh
dG9yIG1jMTM3ODNfcmVndWxhdG9yc1tdID0gewogCU1DMTM3ODNfREVGSU5FX1NXKFNXMywgU1dJ
VENIRVJTNSwgU1dJVENIRVJTNSwgbWMxMzc4M19zdzNfdmFsKSwKIAogCU1DMTM3ODNfRklYRURf
REVGSU5FKFJFRywgVkFVRElPLCBSRUdVTEFUT1JNT0RFMCwgbWMxMzc4M192YXVkaW9fdmFsKSwK
QEAgLTI3NCwyMDcgKzIyOCwxNiBAQCBzdGF0aWMgc3RydWN0IG1jMTM3ODNfcmVndWxhdG9yIG1j
MTM3ODNfcmVndWxhdG9yc1tdID0gewogCU1DMTM3ODNfR1BPX0RFRklORShSRUcsIFBXR1QyU1BJ
LCBQT1dFUk1JU0MsIG1jMTM3ODNfcHdndGRydl92YWwpLAogfTsKIAotc3RydWN0IG1jMTM3ODNf
cmVndWxhdG9yX3ByaXYgewotCXN0cnVjdCBtYzEzNzgzICptYzEzNzgzOwotCXUzMiBwb3dlcm1p
c2NfcHdndF9zdGF0ZTsKLQlzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmVndWxhdG9yc1tdOwotfTsK
LQotc3RhdGljIGludCBtYzEzNzgzX3JlZ3VsYXRvcl9lbmFibGUoc3RydWN0IHJlZ3VsYXRvcl9k
ZXYgKnJkZXYpCi17Ci0Jc3RydWN0IG1jMTM3ODNfcmVndWxhdG9yX3ByaXYgKnByaXYgPSByZGV2
X2dldF9kcnZkYXRhKHJkZXYpOwotCWludCBpZCA9IHJkZXZfZ2V0X2lkKHJkZXYpOwotCWludCBy
ZXQ7Ci0KLQlkZXZfZGJnKHJkZXZfZ2V0X2RldihyZGV2KSwgIiVzIGlkOiAlZFxuIiwgX19mdW5j
X18sIGlkKTsKLQotCW1jMTM3ODNfbG9jayhwcml2LT5tYzEzNzgzKTsKLQlyZXQgPSBtYzEzNzgz
X3JlZ19ybXcocHJpdi0+bWMxMzc4MywgbWMxMzc4M19yZWd1bGF0b3JzW2lkXS5yZWcsCi0JCQlt
YzEzNzgzX3JlZ3VsYXRvcnNbaWRdLmVuYWJsZV9iaXQsCi0JCQltYzEzNzgzX3JlZ3VsYXRvcnNb
aWRdLmVuYWJsZV9iaXQpOwotCW1jMTM3ODNfdW5sb2NrKHByaXYtPm1jMTM3ODMpOwotCi0JcmV0
dXJuIHJldDsKLX0KLQotc3RhdGljIGludCBtYzEzNzgzX3JlZ3VsYXRvcl9kaXNhYmxlKHN0cnVj
dCByZWd1bGF0b3JfZGV2ICpyZGV2KQotewotCXN0cnVjdCBtYzEzNzgzX3JlZ3VsYXRvcl9wcml2
ICpwcml2ID0gcmRldl9nZXRfZHJ2ZGF0YShyZGV2KTsKLQlpbnQgaWQgPSByZGV2X2dldF9pZChy
ZGV2KTsKLQlpbnQgcmV0OwotCi0JZGV2X2RiZyhyZGV2X2dldF9kZXYocmRldiksICIlcyBpZDog
JWRcbiIsIF9fZnVuY19fLCBpZCk7Ci0KLQltYzEzNzgzX2xvY2socHJpdi0+bWMxMzc4Myk7Ci0J
cmV0ID0gbWMxMzc4M19yZWdfcm13KHByaXYtPm1jMTM3ODMsIG1jMTM3ODNfcmVndWxhdG9yc1tp
ZF0ucmVnLAotCQkJbWMxMzc4M19yZWd1bGF0b3JzW2lkXS5lbmFibGVfYml0LCAwKTsKLQltYzEz
NzgzX3VubG9jayhwcml2LT5tYzEzNzgzKTsKLQotCXJldHVybiByZXQ7Ci19Ci0KLXN0YXRpYyBp
bnQgbWMxMzc4M19yZWd1bGF0b3JfaXNfZW5hYmxlZChzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRl
dikKLXsKLQlzdHJ1Y3QgbWMxMzc4M19yZWd1bGF0b3JfcHJpdiAqcHJpdiA9IHJkZXZfZ2V0X2Ry
dmRhdGEocmRldik7Ci0JaW50IHJldCwgaWQgPSByZGV2X2dldF9pZChyZGV2KTsKLQl1bnNpZ25l
ZCBpbnQgdmFsOwotCi0JbWMxMzc4M19sb2NrKHByaXYtPm1jMTM3ODMpOwotCXJldCA9IG1jMTM3
ODNfcmVnX3JlYWQocHJpdi0+bWMxMzc4MywgbWMxMzc4M19yZWd1bGF0b3JzW2lkXS5yZWcsICZ2
YWwpOwotCW1jMTM3ODNfdW5sb2NrKHByaXYtPm1jMTM3ODMpOwotCi0JaWYgKHJldCkKLQkJcmV0
dXJuIHJldDsKLQotCXJldHVybiAodmFsICYgbWMxMzc4M19yZWd1bGF0b3JzW2lkXS5lbmFibGVf
Yml0KSAhPSAwOwotfQotCi1zdGF0aWMgaW50IG1jMTM3ODNfcmVndWxhdG9yX2xpc3Rfdm9sdGFn
ZShzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldiwKLQkJCQkJCXVuc2lnbmVkIHNlbGVjdG9yKQot
ewotCWludCBpZCA9IHJkZXZfZ2V0X2lkKHJkZXYpOwotCi0JaWYgKHNlbGVjdG9yID49IG1jMTM3
ODNfcmVndWxhdG9yc1tpZF0uZGVzYy5uX3ZvbHRhZ2VzKQotCQlyZXR1cm4gLUVJTlZBTDsKLQot
CXJldHVybiBtYzEzNzgzX3JlZ3VsYXRvcnNbaWRdLnZvbHRhZ2VzW3NlbGVjdG9yXTsKLX0KLQot
c3RhdGljIGludCBtYzEzNzgzX2dldF9iZXN0X3ZvbHRhZ2VfaW5kZXgoc3RydWN0IHJlZ3VsYXRv
cl9kZXYgKnJkZXYsCi0JCQkJCQlpbnQgbWluX3VWLCBpbnQgbWF4X3VWKQotewotCWludCByZWdf
aWQgPSByZGV2X2dldF9pZChyZGV2KTsKLQlpbnQgaTsKLQlpbnQgYmVzdG1hdGNoOwotCWludCBi
ZXN0aW5kZXg7Ci0KLQkvKgotCSAqIExvY2F0ZSB0aGUgbWluaW11bSB2b2x0YWdlIGZpdHRpbmcg
dGhlIGNyaXRlcmlhIG9uCi0JICogdGhpcyByZWd1bGF0b3IuIFRoZSBzd2l0Y2hhYmxlIHZvbHRh
Z2VzIGFyZSBub3QKLQkgKiBpbiBzdHJpY3QgZmFsbGluZyBvcmRlciBzbyB3ZSBuZWVkIHRvIGNo
ZWNrIHRoZW0KLQkgKiBhbGwgZm9yIHRoZSBiZXN0IG1hdGNoLgotCSAqLwotCWJlc3RtYXRjaCA9
IElOVF9NQVg7Ci0JYmVzdGluZGV4ID0gLTE7Ci0JZm9yIChpID0gMDsgaSA8IG1jMTM3ODNfcmVn
dWxhdG9yc1tyZWdfaWRdLmRlc2Mubl92b2x0YWdlczsgaSsrKSB7Ci0JCWlmIChtYzEzNzgzX3Jl
Z3VsYXRvcnNbcmVnX2lkXS52b2x0YWdlc1tpXSA+PSBtaW5fdVYgJiYKLQkJICAgIG1jMTM3ODNf
cmVndWxhdG9yc1tyZWdfaWRdLnZvbHRhZ2VzW2ldIDwgYmVzdG1hdGNoKSB7Ci0JCQliZXN0bWF0
Y2ggPSBtYzEzNzgzX3JlZ3VsYXRvcnNbcmVnX2lkXS52b2x0YWdlc1tpXTsKLQkJCWJlc3RpbmRl
eCA9IGk7Ci0JCX0KLQl9Ci0KLQlpZiAoYmVzdGluZGV4IDwgMCB8fCBiZXN0bWF0Y2ggPiBtYXhf
dVYpIHsKLQkJZGV2X3dhcm4oJnJkZXYtPmRldiwgIm5vIHBvc3NpYmxlIHZhbHVlIGZvciAlZDw9
eDw9JWQgdVZcbiIsCi0JCQkJbWluX3VWLCBtYXhfdVYpOwotCQlyZXR1cm4gLUVJTlZBTDsKLQl9
Ci0JcmV0dXJuIGJlc3RpbmRleDsKLX0KLQotc3RhdGljIGludCBtYzEzNzgzX3JlZ3VsYXRvcl9z
ZXRfdm9sdGFnZShzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldiwKLQkJCQkJCWludCBtaW5fdVYs
IGludCBtYXhfdVYpCi17Ci0Jc3RydWN0IG1jMTM3ODNfcmVndWxhdG9yX3ByaXYgKnByaXYgPSBy
ZGV2X2dldF9kcnZkYXRhKHJkZXYpOwotCWludCB2YWx1ZSwgaWQgPSByZGV2X2dldF9pZChyZGV2
KTsKLQlpbnQgcmV0OwotCi0JZGV2X2RiZyhyZGV2X2dldF9kZXYocmRldiksICIlcyBpZDogJWQg
bWluX3VWOiAlZCBtYXhfdVY6ICVkXG4iLAotCQlfX2Z1bmNfXywgaWQsIG1pbl91ViwgbWF4X3VW
KTsKLQotCS8qIEZpbmQgdGhlIGJlc3QgaW5kZXggKi8KLQl2YWx1ZSA9IG1jMTM3ODNfZ2V0X2Jl
c3Rfdm9sdGFnZV9pbmRleChyZGV2LCBtaW5fdVYsIG1heF91Vik7Ci0JZGV2X2RiZyhyZGV2X2dl
dF9kZXYocmRldiksICIlcyBiZXN0IHZhbHVlOiAlZCBcbiIsIF9fZnVuY19fLCB2YWx1ZSk7Ci0J
aWYgKHZhbHVlIDwgMCkKLQkJcmV0dXJuIHZhbHVlOwotCi0JbWMxMzc4M19sb2NrKHByaXYtPm1j
MTM3ODMpOwotCXJldCA9IG1jMTM3ODNfcmVnX3Jtdyhwcml2LT5tYzEzNzgzLCBtYzEzNzgzX3Jl
Z3VsYXRvcnNbaWRdLnZzZWxfcmVnLAotCQkJbWMxMzc4M19yZWd1bGF0b3JzW2lkXS52c2VsX21h
c2ssCi0JCQl2YWx1ZSA8PCBtYzEzNzgzX3JlZ3VsYXRvcnNbaWRdLnZzZWxfc2hpZnQpOwotCW1j
MTM3ODNfdW5sb2NrKHByaXYtPm1jMTM3ODMpOwotCi0JcmV0dXJuIHJldDsKLX0KLQotc3RhdGlj
IGludCBtYzEzNzgzX3JlZ3VsYXRvcl9nZXRfdm9sdGFnZShzdHJ1Y3QgcmVndWxhdG9yX2RldiAq
cmRldikKLXsKLQlzdHJ1Y3QgbWMxMzc4M19yZWd1bGF0b3JfcHJpdiAqcHJpdiA9IHJkZXZfZ2V0
X2RydmRhdGEocmRldik7Ci0JaW50IHJldCwgaWQgPSByZGV2X2dldF9pZChyZGV2KTsKLQl1bnNp
Z25lZCBpbnQgdmFsOwotCi0JZGV2X2RiZyhyZGV2X2dldF9kZXYocmRldiksICIlcyBpZDogJWRc
biIsIF9fZnVuY19fLCBpZCk7Ci0KLQltYzEzNzgzX2xvY2socHJpdi0+bWMxMzc4Myk7Ci0JcmV0
ID0gbWMxMzc4M19yZWdfcmVhZChwcml2LT5tYzEzNzgzLAotCQkJCW1jMTM3ODNfcmVndWxhdG9y
c1tpZF0udnNlbF9yZWcsICZ2YWwpOwotCW1jMTM3ODNfdW5sb2NrKHByaXYtPm1jMTM3ODMpOwot
Ci0JaWYgKHJldCkKLQkJcmV0dXJuIHJldDsKLQotCXZhbCA9ICh2YWwgJiBtYzEzNzgzX3JlZ3Vs
YXRvcnNbaWRdLnZzZWxfbWFzaykKLQkJPj4gbWMxMzc4M19yZWd1bGF0b3JzW2lkXS52c2VsX3No
aWZ0OwotCi0JZGV2X2RiZyhyZGV2X2dldF9kZXYocmRldiksICIlcyBpZDogJWQgdmFsOiAlZFxu
IiwgX19mdW5jX18sIGlkLCB2YWwpOwotCi0JQlVHX09OKHZhbCA8IDAgfHwgdmFsID4gbWMxMzc4
M19yZWd1bGF0b3JzW2lkXS5kZXNjLm5fdm9sdGFnZXMpOwotCi0JcmV0dXJuIG1jMTM3ODNfcmVn
dWxhdG9yc1tpZF0udm9sdGFnZXNbdmFsXTsKLX0KLQotc3RhdGljIHN0cnVjdCByZWd1bGF0b3Jf
b3BzIG1jMTM3ODNfcmVndWxhdG9yX29wcyA9IHsKLQkuZW5hYmxlID0gbWMxMzc4M19yZWd1bGF0
b3JfZW5hYmxlLAotCS5kaXNhYmxlID0gbWMxMzc4M19yZWd1bGF0b3JfZGlzYWJsZSwKLQkuaXNf
ZW5hYmxlZCA9IG1jMTM3ODNfcmVndWxhdG9yX2lzX2VuYWJsZWQsCi0JLmxpc3Rfdm9sdGFnZSA9
IG1jMTM3ODNfcmVndWxhdG9yX2xpc3Rfdm9sdGFnZSwKLQkuc2V0X3ZvbHRhZ2UgPSBtYzEzNzgz
X3JlZ3VsYXRvcl9zZXRfdm9sdGFnZSwKLQkuZ2V0X3ZvbHRhZ2UgPSBtYzEzNzgzX3JlZ3VsYXRv
cl9nZXRfdm9sdGFnZSwKLX07Ci0KLXN0YXRpYyBpbnQgbWMxMzc4M19maXhlZF9yZWd1bGF0b3Jf
c2V0X3ZvbHRhZ2Uoc3RydWN0IHJlZ3VsYXRvcl9kZXYgKnJkZXYsCi0JCQkJCQlpbnQgbWluX3VW
LCBpbnQgbWF4X3VWKQotewotCWludCBpZCA9IHJkZXZfZ2V0X2lkKHJkZXYpOwotCi0JZGV2X2Ri
ZyhyZGV2X2dldF9kZXYocmRldiksICIlcyBpZDogJWQgbWluX3VWOiAlZCBtYXhfdVY6ICVkXG4i
LAotCQlfX2Z1bmNfXywgaWQsIG1pbl91ViwgbWF4X3VWKTsKLQotCWlmIChtaW5fdVYgPj0gbWMx
Mzc4M19yZWd1bGF0b3JzW2lkXS52b2x0YWdlc1swXSAmJgotCSAgICBtYXhfdVYgPD0gbWMxMzc4
M19yZWd1bGF0b3JzW2lkXS52b2x0YWdlc1swXSkKLQkJcmV0dXJuIDA7Ci0JZWxzZQotCQlyZXR1
cm4gLUVJTlZBTDsKLX0KLQotc3RhdGljIGludCBtYzEzNzgzX2ZpeGVkX3JlZ3VsYXRvcl9nZXRf
dm9sdGFnZShzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldikKLXsKLQlpbnQgaWQgPSByZGV2X2dl
dF9pZChyZGV2KTsKLQotCWRldl9kYmcocmRldl9nZXRfZGV2KHJkZXYpLCAiJXMgaWQ6ICVkXG4i
LCBfX2Z1bmNfXywgaWQpOwotCi0JcmV0dXJuIG1jMTM3ODNfcmVndWxhdG9yc1tpZF0udm9sdGFn
ZXNbMF07Ci19Ci0KLXN0YXRpYyBzdHJ1Y3QgcmVndWxhdG9yX29wcyBtYzEzNzgzX2ZpeGVkX3Jl
Z3VsYXRvcl9vcHMgPSB7Ci0JLmVuYWJsZSA9IG1jMTM3ODNfcmVndWxhdG9yX2VuYWJsZSwKLQku
ZGlzYWJsZSA9IG1jMTM3ODNfcmVndWxhdG9yX2Rpc2FibGUsCi0JLmlzX2VuYWJsZWQgPSBtYzEz
NzgzX3JlZ3VsYXRvcl9pc19lbmFibGVkLAotCS5saXN0X3ZvbHRhZ2UgPSBtYzEzNzgzX3JlZ3Vs
YXRvcl9saXN0X3ZvbHRhZ2UsCi0JLnNldF92b2x0YWdlID0gbWMxMzc4M19maXhlZF9yZWd1bGF0
b3Jfc2V0X3ZvbHRhZ2UsCi0JLmdldF92b2x0YWdlID0gbWMxMzc4M19maXhlZF9yZWd1bGF0b3Jf
Z2V0X3ZvbHRhZ2UsCi19OwotCi1pbnQgbWMxMzc4M19wb3dlcm1pc2Nfcm13KHN0cnVjdCBtYzEz
NzgzX3JlZ3VsYXRvcl9wcml2ICpwcml2LCB1MzIgbWFzaywKK2ludCBtYzEzNzgzX3Bvd2VybWlz
Y19ybXcoc3RydWN0IG1jMTN4eHhfcmVndWxhdG9yX3ByaXYgKnByaXYsIHUzMiBtYXNrLAogCQkJ
CQkJCQkJdTMyIHZhbCkKIHsKLQlzdHJ1Y3QgbWMxMzc4MyAqbWMxMzc4MyA9IHByaXYtPm1jMTM3
ODM7CisJc3RydWN0IG1jMTN4eHggKm1jMTM3ODMgPSBwcml2LT5tYzEzeHh4OwogCWludCByZXQ7
CiAJdTMyIHZhbHJlYWQ7CiAKIAlCVUdfT04odmFsICYgfm1hc2spOwogCi0JcmV0ID0gbWMxMzc4
M19yZWdfcmVhZChtYzEzNzgzLCBNQzEzNzgzX1JFR19QT1dFUk1JU0MsICZ2YWxyZWFkKTsKKwly
ZXQgPSBtYzEzeHh4X3JlZ19yZWFkKG1jMTM3ODMsIE1DMTM3ODNfUkVHX1BPV0VSTUlTQywgJnZh
bHJlYWQpOwogCWlmIChyZXQpCiAJCXJldHVybiByZXQ7CiAKQEAgLTQ4OSwxNSArMjUyLDE2IEBA
IGludCBtYzEzNzgzX3Bvd2VybWlzY19ybXcoc3RydWN0IG1jMTM3ODNfcmVndWxhdG9yX3ByaXYg
KnByaXYsIHUzMiBtYXNrLAogCXZhbHJlYWQgPSAodmFscmVhZCAmIH5NQzEzNzgzX1JFR19QT1dF
Uk1JU0NfUFdHVFNQSV9NKSB8CiAJCQkJCQlwcml2LT5wb3dlcm1pc2NfcHdndF9zdGF0ZTsKIAot
CXJldHVybiBtYzEzNzgzX3JlZ193cml0ZShtYzEzNzgzLCBNQzEzNzgzX1JFR19QT1dFUk1JU0Ms
IHZhbHJlYWQpOworCXJldHVybiBtYzEzeHh4X3JlZ193cml0ZShtYzEzNzgzLCBNQzEzNzgzX1JF
R19QT1dFUk1JU0MsIHZhbHJlYWQpOwogfQogCiBzdGF0aWMgaW50IG1jMTM3ODNfZ3BvX3JlZ3Vs
YXRvcl9lbmFibGUoc3RydWN0IHJlZ3VsYXRvcl9kZXYgKnJkZXYpCiB7Ci0Jc3RydWN0IG1jMTM3
ODNfcmVndWxhdG9yX3ByaXYgKnByaXYgPSByZGV2X2dldF9kcnZkYXRhKHJkZXYpOworCXN0cnVj
dCBtYzEzeHh4X3JlZ3VsYXRvcl9wcml2ICpwcml2ID0gcmRldl9nZXRfZHJ2ZGF0YShyZGV2KTsK
KwlzdHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3IgKm1jMTN4eHhfcmVndWxhdG9ycyA9IHByaXYtPm1j
MTN4eHhfcmVndWxhdG9yczsKIAlpbnQgaWQgPSByZGV2X2dldF9pZChyZGV2KTsKIAlpbnQgcmV0
OwotCXUzMiBlbl92YWwgPSBtYzEzNzgzX3JlZ3VsYXRvcnNbaWRdLmVuYWJsZV9iaXQ7CisJdTMy
IGVuX3ZhbCA9IG1jMTN4eHhfcmVndWxhdG9yc1tpZF0uZW5hYmxlX2JpdDsKIAogCWRldl9kYmco
cmRldl9nZXRfZGV2KHJkZXYpLCAiJXMgaWQ6ICVkXG4iLCBfX2Z1bmNfXywgaWQpOwogCkBAIC01
MDYsMTcgKzI3MCwxOCBAQCBzdGF0aWMgaW50IG1jMTM3ODNfZ3BvX3JlZ3VsYXRvcl9lbmFibGUo
c3RydWN0IHJlZ3VsYXRvcl9kZXYgKnJkZXYpCiAJICAgIGlkID09IE1DMTM3ODNfUkVHX1BXR1Qy
U1BJKQogCQllbl92YWwgPSAwOwogCi0JbWMxMzc4M19sb2NrKHByaXYtPm1jMTM3ODMpOwotCXJl
dCA9IG1jMTM3ODNfcG93ZXJtaXNjX3Jtdyhwcml2LCBtYzEzNzgzX3JlZ3VsYXRvcnNbaWRdLmVu
YWJsZV9iaXQsCisJbWMxM3h4eF9sb2NrKHByaXYtPm1jMTN4eHgpOworCXJldCA9IG1jMTM3ODNf
cG93ZXJtaXNjX3Jtdyhwcml2LCBtYzEzeHh4X3JlZ3VsYXRvcnNbaWRdLmVuYWJsZV9iaXQsCiAJ
CQkJCWVuX3ZhbCk7Ci0JbWMxMzc4M191bmxvY2socHJpdi0+bWMxMzc4Myk7CisJbWMxM3h4eF91
bmxvY2socHJpdi0+bWMxM3h4eCk7CiAKIAlyZXR1cm4gcmV0OwogfQogCiBzdGF0aWMgaW50IG1j
MTM3ODNfZ3BvX3JlZ3VsYXRvcl9kaXNhYmxlKHN0cnVjdCByZWd1bGF0b3JfZGV2ICpyZGV2KQog
ewotCXN0cnVjdCBtYzEzNzgzX3JlZ3VsYXRvcl9wcml2ICpwcml2ID0gcmRldl9nZXRfZHJ2ZGF0
YShyZGV2KTsKKwlzdHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3JfcHJpdiAqcHJpdiA9IHJkZXZfZ2V0
X2RydmRhdGEocmRldik7CisJc3RydWN0IG1jMTN4eHhfcmVndWxhdG9yICptYzEzeHh4X3JlZ3Vs
YXRvcnMgPSBwcml2LT5tYzEzeHh4X3JlZ3VsYXRvcnM7CiAJaW50IGlkID0gcmRldl9nZXRfaWQo
cmRldik7CiAJaW50IHJldDsKIAl1MzIgZGlzX3ZhbCA9IDA7CkBAIC01MjYsMjUgKzI5MSwyNiBA
QCBzdGF0aWMgaW50IG1jMTM3ODNfZ3BvX3JlZ3VsYXRvcl9kaXNhYmxlKHN0cnVjdCByZWd1bGF0
b3JfZGV2ICpyZGV2KQogCS8qIFBvd2VyIEdhdGUgZGlzYWJsZSB2YWx1ZSBpcyAxICovCiAJaWYg
KGlkID09IE1DMTM3ODNfUkVHX1BXR1QxU1BJIHx8CiAJICAgIGlkID09IE1DMTM3ODNfUkVHX1BX
R1QyU1BJKQotCQlkaXNfdmFsID0gbWMxMzc4M19yZWd1bGF0b3JzW2lkXS5lbmFibGVfYml0Owor
CQlkaXNfdmFsID0gbWMxM3h4eF9yZWd1bGF0b3JzW2lkXS5lbmFibGVfYml0OwogCi0JbWMxMzc4
M19sb2NrKHByaXYtPm1jMTM3ODMpOwotCXJldCA9IG1jMTM3ODNfcG93ZXJtaXNjX3Jtdyhwcml2
LCBtYzEzNzgzX3JlZ3VsYXRvcnNbaWRdLmVuYWJsZV9iaXQsCisJbWMxM3h4eF9sb2NrKHByaXYt
Pm1jMTN4eHgpOworCXJldCA9IG1jMTM3ODNfcG93ZXJtaXNjX3Jtdyhwcml2LCBtYzEzeHh4X3Jl
Z3VsYXRvcnNbaWRdLmVuYWJsZV9iaXQsCiAJCQkJCWRpc192YWwpOwotCW1jMTM3ODNfdW5sb2Nr
KHByaXYtPm1jMTM3ODMpOworCW1jMTN4eHhfdW5sb2NrKHByaXYtPm1jMTN4eHgpOwogCiAJcmV0
dXJuIHJldDsKIH0KIAogc3RhdGljIGludCBtYzEzNzgzX2dwb19yZWd1bGF0b3JfaXNfZW5hYmxl
ZChzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldikKIHsKLQlzdHJ1Y3QgbWMxMzc4M19yZWd1bGF0
b3JfcHJpdiAqcHJpdiA9IHJkZXZfZ2V0X2RydmRhdGEocmRldik7CisJc3RydWN0IG1jMTN4eHhf
cmVndWxhdG9yX3ByaXYgKnByaXYgPSByZGV2X2dldF9kcnZkYXRhKHJkZXYpOworCXN0cnVjdCBt
YzEzeHh4X3JlZ3VsYXRvciAqbWMxM3h4eF9yZWd1bGF0b3JzID0gcHJpdi0+bWMxM3h4eF9yZWd1
bGF0b3JzOwogCWludCByZXQsIGlkID0gcmRldl9nZXRfaWQocmRldik7CiAJdW5zaWduZWQgaW50
IHZhbDsKIAotCW1jMTM3ODNfbG9jayhwcml2LT5tYzEzNzgzKTsKLQlyZXQgPSBtYzEzNzgzX3Jl
Z19yZWFkKHByaXYtPm1jMTM3ODMsIG1jMTM3ODNfcmVndWxhdG9yc1tpZF0ucmVnLCAmdmFsKTsK
LQltYzEzNzgzX3VubG9jayhwcml2LT5tYzEzNzgzKTsKKwltYzEzeHh4X2xvY2socHJpdi0+bWMx
M3h4eCk7CisJcmV0ID0gbWMxM3h4eF9yZWdfcmVhZChwcml2LT5tYzEzeHh4LCBtYzEzeHh4X3Jl
Z3VsYXRvcnNbaWRdLnJlZywgJnZhbCk7CisJbWMxM3h4eF91bmxvY2socHJpdi0+bWMxM3h4eCk7
CiAKIAlpZiAocmV0KQogCQlyZXR1cm4gcmV0OwpAQCAtNTU0LDIyICszMjAsMjIgQEAgc3RhdGlj
IGludCBtYzEzNzgzX2dwb19yZWd1bGF0b3JfaXNfZW5hYmxlZChzdHJ1Y3QgcmVndWxhdG9yX2Rl
diAqcmRldikKIAl2YWwgPSAodmFsICYgfk1DMTM3ODNfUkVHX1BPV0VSTUlTQ19QV0dUU1BJX00p
IHwKIAkgICAgICAocHJpdi0+cG93ZXJtaXNjX3B3Z3Rfc3RhdGUgXiBNQzEzNzgzX1JFR19QT1dF
Uk1JU0NfUFdHVFNQSV9NKTsKIAotCXJldHVybiAodmFsICYgbWMxMzc4M19yZWd1bGF0b3JzW2lk
XS5lbmFibGVfYml0KSAhPSAwOworCXJldHVybiAodmFsICYgbWMxM3h4eF9yZWd1bGF0b3JzW2lk
XS5lbmFibGVfYml0KSAhPSAwOwogfQogCiBzdGF0aWMgc3RydWN0IHJlZ3VsYXRvcl9vcHMgbWMx
Mzc4M19ncG9fcmVndWxhdG9yX29wcyA9IHsKIAkuZW5hYmxlID0gbWMxMzc4M19ncG9fcmVndWxh
dG9yX2VuYWJsZSwKIAkuZGlzYWJsZSA9IG1jMTM3ODNfZ3BvX3JlZ3VsYXRvcl9kaXNhYmxlLAog
CS5pc19lbmFibGVkID0gbWMxMzc4M19ncG9fcmVndWxhdG9yX2lzX2VuYWJsZWQsCi0JLmxpc3Rf
dm9sdGFnZSA9IG1jMTM3ODNfcmVndWxhdG9yX2xpc3Rfdm9sdGFnZSwKLQkuc2V0X3ZvbHRhZ2Ug
PSBtYzEzNzgzX2ZpeGVkX3JlZ3VsYXRvcl9zZXRfdm9sdGFnZSwKLQkuZ2V0X3ZvbHRhZ2UgPSBt
YzEzNzgzX2ZpeGVkX3JlZ3VsYXRvcl9nZXRfdm9sdGFnZSwKKwkubGlzdF92b2x0YWdlID0gbWMx
M3h4eF9yZWd1bGF0b3JfbGlzdF92b2x0YWdlLAorCS5zZXRfdm9sdGFnZSA9IG1jMTN4eHhfZml4
ZWRfcmVndWxhdG9yX3NldF92b2x0YWdlLAorCS5nZXRfdm9sdGFnZSA9IG1jMTN4eHhfZml4ZWRf
cmVndWxhdG9yX2dldF92b2x0YWdlLAogfTsKIAogc3RhdGljIGludCBfX2RldmluaXQgbWMxMzc4
M19yZWd1bGF0b3JfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKIHsKLQlzdHJ1
Y3QgbWMxMzc4M19yZWd1bGF0b3JfcHJpdiAqcHJpdjsKLQlzdHJ1Y3QgbWMxMzc4MyAqbWMxMzc4
MyA9IGRldl9nZXRfZHJ2ZGF0YShwZGV2LT5kZXYucGFyZW50KTsKKwlzdHJ1Y3QgbWMxM3h4eF9y
ZWd1bGF0b3JfcHJpdiAqcHJpdjsKKwlzdHJ1Y3QgbWMxM3h4eCAqbWMxMzc4MyA9IGRldl9nZXRf
ZHJ2ZGF0YShwZGV2LT5kZXYucGFyZW50KTsKIAlzdHJ1Y3QgbWMxMzc4M19yZWd1bGF0b3JfcGxh
dGZvcm1fZGF0YSAqcGRhdGEgPQogCQlkZXZfZ2V0X3BsYXRkYXRhKCZwZGV2LT5kZXYpOwogCXN0
cnVjdCBtYzEzNzgzX3JlZ3VsYXRvcl9pbml0X2RhdGEgKmluaXRfZGF0YTsKQEAgLTU4Myw3ICsz
NDksOCBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBtYzEzNzgzX3JlZ3VsYXRvcl9wcm9iZShzdHJ1
Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCWlmICghcHJpdikKIAkJcmV0dXJuIC1FTk9NRU07
CiAKLQlwcml2LT5tYzEzNzgzID0gbWMxMzc4MzsKKwlwcml2LT5tYzEzeHh4X3JlZ3VsYXRvcnMg
PSBtYzEzNzgzX3JlZ3VsYXRvcnM7CisJcHJpdi0+bWMxM3h4eCA9IG1jMTM3ODM7CiAKIAlmb3Ig
KGkgPSAwOyBpIDwgcGRhdGEtPm51bV9yZWd1bGF0b3JzOyBpKyspIHsKIAkJaW5pdF9kYXRhID0g
JnBkYXRhLT5yZWd1bGF0b3JzW2ldOwpAQCAtNjEzLDcgKzM4MCw3IEBAIGVycjoKIAogc3RhdGlj
IGludCBfX2RldmV4aXQgbWMxMzc4M19yZWd1bGF0b3JfcmVtb3ZlKHN0cnVjdCBwbGF0Zm9ybV9k
ZXZpY2UgKnBkZXYpCiB7Ci0Jc3RydWN0IG1jMTM3ODNfcmVndWxhdG9yX3ByaXYgKnByaXYgPSBw
bGF0Zm9ybV9nZXRfZHJ2ZGF0YShwZGV2KTsKKwlzdHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3JfcHJp
diAqcHJpdiA9IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBkZXYpOwogCXN0cnVjdCBtYzEzNzgzX3Jl
Z3VsYXRvcl9wbGF0Zm9ybV9kYXRhICpwZGF0YSA9CiAJCWRldl9nZXRfcGxhdGRhdGEoJnBkZXYt
PmRldik7CiAJaW50IGk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3JlZ3VsYXRvci9tYzEzeHh4LXJl
Z3VsYXRvci1jb3JlLmMgYi9kcml2ZXJzL3JlZ3VsYXRvci9tYzEzeHh4LXJlZ3VsYXRvci1jb3Jl
LmMKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uYmY1M2ZmNgotLS0gL2Rldi9u
dWxsCisrKyBiL2RyaXZlcnMvcmVndWxhdG9yL21jMTN4eHgtcmVndWxhdG9yLWNvcmUuYwpAQCAt
MCwwICsxLDIzNCBAQAorLyoKKyAqIFJlZ3VsYXRvciBEcml2ZXIgZm9yIEZyZWVzY2FsZSBNQzEz
eHh4IFBNSUMKKyAqCisgKiBDb3B5cmlnaHQgMjAxMCBZb25nIFNoZW4gPHlvbmcuc2hlbkBsaW5h
cm8ub3JnPgorICoKKyAqIEJhc2VkIG9uIG1jMTM3ODMgcmVndWxhdG9yIGRyaXZlciA6CisgKiBD
b3B5cmlnaHQgKEMpIDIwMDggU2FzY2hhIEhhdWVyLCBQZW5ndXRyb25peCA8cy5oYXVlckBwZW5n
dXRyb25peC5kZT4KKyAqIENvcHlyaWdodCAyMDA5IEFsYmVydG8gUGFuaXp6byA8bWFyYW1hb3Bl
cmNoZXNlaW1vcnRvQGdtYWlsLmNvbT4KKyAqCisgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0
d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQorICogaXQgdW5kZXIg
dGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSB2ZXJzaW9uIDIgYXMK
KyAqIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLgorICoKKyAqIFJl
Z3MgaW5mb3MgdGFrZW4gZnJvbSBtYzEzeHh4IGRyaXZlcnMgZnJvbSBmcmVlc2NhbGUgYW5kIG1j
MTN4eHgucGRmIGZpbGUKKyAqIGZyb20gZnJlZXNjYWxlCisgKi8KKworI2luY2x1ZGUgPGxpbnV4
L21mZC9tYzEzeHh4Lmg+CisjaW5jbHVkZSA8bGludXgvcmVndWxhdG9yL21hY2hpbmUuaD4KKyNp
bmNsdWRlIDxsaW51eC9yZWd1bGF0b3IvZHJpdmVyLmg+CisjaW5jbHVkZSA8bGludXgvcGxhdGZv
cm1fZGV2aWNlLmg+CisjaW5jbHVkZSA8bGludXgva2VybmVsLmg+CisjaW5jbHVkZSA8bGludXgv
c2xhYi5oPgorI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KKyNpbmNsdWRlIDxsaW51eC9lcnIuaD4K
KyNpbmNsdWRlICJtYzEzeHh4LmgiCisKK3N0YXRpYyBpbnQgbWMxM3h4eF9yZWd1bGF0b3JfZW5h
YmxlKHN0cnVjdCByZWd1bGF0b3JfZGV2ICpyZGV2KQoreworCXN0cnVjdCBtYzEzeHh4X3JlZ3Vs
YXRvcl9wcml2ICpwcml2ID0gcmRldl9nZXRfZHJ2ZGF0YShyZGV2KTsKKwlzdHJ1Y3QgbWMxM3h4
eF9yZWd1bGF0b3IgKm1jMTN4eHhfcmVndWxhdG9ycyA9IHByaXYtPm1jMTN4eHhfcmVndWxhdG9y
czsKKwlpbnQgaWQgPSByZGV2X2dldF9pZChyZGV2KTsKKwlpbnQgcmV0OworCisJZGV2X2RiZyhy
ZGV2X2dldF9kZXYocmRldiksICIlcyBpZDogJWRcbiIsIF9fZnVuY19fLCBpZCk7CisKKwltYzEz
eHh4X2xvY2socHJpdi0+bWMxM3h4eCk7CisJcmV0ID0gbWMxM3h4eF9yZWdfcm13KHByaXYtPm1j
MTN4eHgsIG1jMTN4eHhfcmVndWxhdG9yc1tpZF0ucmVnLAorCQkJbWMxM3h4eF9yZWd1bGF0b3Jz
W2lkXS5lbmFibGVfYml0LAorCQkJbWMxM3h4eF9yZWd1bGF0b3JzW2lkXS5lbmFibGVfYml0KTsK
KwltYzEzeHh4X3VubG9jayhwcml2LT5tYzEzeHh4KTsKKworCXJldHVybiByZXQ7Cit9CisKK3N0
YXRpYyBpbnQgbWMxM3h4eF9yZWd1bGF0b3JfZGlzYWJsZShzdHJ1Y3QgcmVndWxhdG9yX2RldiAq
cmRldikKK3sKKwlzdHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3JfcHJpdiAqcHJpdiA9IHJkZXZfZ2V0
X2RydmRhdGEocmRldik7CisJc3RydWN0IG1jMTN4eHhfcmVndWxhdG9yICptYzEzeHh4X3JlZ3Vs
YXRvcnMgPSBwcml2LT5tYzEzeHh4X3JlZ3VsYXRvcnM7CisJaW50IGlkID0gcmRldl9nZXRfaWQo
cmRldik7CisJaW50IHJldDsKKworCWRldl9kYmcocmRldl9nZXRfZGV2KHJkZXYpLCAiJXMgaWQ6
ICVkXG4iLCBfX2Z1bmNfXywgaWQpOworCisJbWMxM3h4eF9sb2NrKHByaXYtPm1jMTN4eHgpOwor
CXJldCA9IG1jMTN4eHhfcmVnX3Jtdyhwcml2LT5tYzEzeHh4LCBtYzEzeHh4X3JlZ3VsYXRvcnNb
aWRdLnJlZywKKwkJCW1jMTN4eHhfcmVndWxhdG9yc1tpZF0uZW5hYmxlX2JpdCwgMCk7CisJbWMx
M3h4eF91bmxvY2socHJpdi0+bWMxM3h4eCk7CisKKwlyZXR1cm4gcmV0OworfQorCitzdGF0aWMg
aW50IG1jMTN4eHhfcmVndWxhdG9yX2lzX2VuYWJsZWQoc3RydWN0IHJlZ3VsYXRvcl9kZXYgKnJk
ZXYpCit7CisJc3RydWN0IG1jMTN4eHhfcmVndWxhdG9yX3ByaXYgKnByaXYgPSByZGV2X2dldF9k
cnZkYXRhKHJkZXYpOworCXN0cnVjdCBtYzEzeHh4X3JlZ3VsYXRvciAqbWMxM3h4eF9yZWd1bGF0
b3JzID0gcHJpdi0+bWMxM3h4eF9yZWd1bGF0b3JzOworCWludCByZXQsIGlkID0gcmRldl9nZXRf
aWQocmRldik7CisJdW5zaWduZWQgaW50IHZhbDsKKworCW1jMTN4eHhfbG9jayhwcml2LT5tYzEz
eHh4KTsKKwlyZXQgPSBtYzEzeHh4X3JlZ19yZWFkKHByaXYtPm1jMTN4eHgsIG1jMTN4eHhfcmVn
dWxhdG9yc1tpZF0ucmVnLCAmdmFsKTsKKwltYzEzeHh4X3VubG9jayhwcml2LT5tYzEzeHh4KTsK
KworCWlmIChyZXQpCisJCXJldHVybiByZXQ7CisKKwlyZXR1cm4gKHZhbCAmIG1jMTN4eHhfcmVn
dWxhdG9yc1tpZF0uZW5hYmxlX2JpdCkgIT0gMDsKK30KKworaW50IG1jMTN4eHhfcmVndWxhdG9y
X2xpc3Rfdm9sdGFnZShzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldiwKKwkJCQkJCXVuc2lnbmVk
IHNlbGVjdG9yKQoreworCWludCBpZCA9IHJkZXZfZ2V0X2lkKHJkZXYpOworCXN0cnVjdCBtYzEz
eHh4X3JlZ3VsYXRvcl9wcml2ICpwcml2ID0gcmRldl9nZXRfZHJ2ZGF0YShyZGV2KTsKKwlzdHJ1
Y3QgbWMxM3h4eF9yZWd1bGF0b3IgKm1jMTN4eHhfcmVndWxhdG9ycyA9IHByaXYtPm1jMTN4eHhf
cmVndWxhdG9yczsKKworCWlmIChzZWxlY3RvciA+PSBtYzEzeHh4X3JlZ3VsYXRvcnNbaWRdLmRl
c2Mubl92b2x0YWdlcykKKwkJcmV0dXJuIC1FSU5WQUw7CisKKwlyZXR1cm4gbWMxM3h4eF9yZWd1
bGF0b3JzW2lkXS52b2x0YWdlc1tzZWxlY3Rvcl07Cit9CisKK2ludCBtYzEzeHh4X2dldF9iZXN0
X3ZvbHRhZ2VfaW5kZXgoc3RydWN0IHJlZ3VsYXRvcl9kZXYgKnJkZXYsCisJCQkJCQlpbnQgbWlu
X3VWLCBpbnQgbWF4X3VWKQoreworCXN0cnVjdCBtYzEzeHh4X3JlZ3VsYXRvcl9wcml2ICpwcml2
ID0gcmRldl9nZXRfZHJ2ZGF0YShyZGV2KTsKKwlzdHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3IgKm1j
MTN4eHhfcmVndWxhdG9ycyA9IHByaXYtPm1jMTN4eHhfcmVndWxhdG9yczsKKwlpbnQgcmVnX2lk
ID0gcmRldl9nZXRfaWQocmRldik7CisJaW50IGk7CisJaW50IGJlc3RtYXRjaDsKKwlpbnQgYmVz
dGluZGV4OworCisJLyoKKwkgKiBMb2NhdGUgdGhlIG1pbmltdW0gdm9sdGFnZSBmaXR0aW5nIHRo
ZSBjcml0ZXJpYSBvbgorCSAqIHRoaXMgcmVndWxhdG9yLiBUaGUgc3dpdGNoYWJsZSB2b2x0YWdl
cyBhcmUgbm90CisJICogaW4gc3RyaWN0IGZhbGxpbmcgb3JkZXIgc28gd2UgbmVlZCB0byBjaGVj
ayB0aGVtCisJICogYWxsIGZvciB0aGUgYmVzdCBtYXRjaC4KKwkgKi8KKwliZXN0bWF0Y2ggPSBJ
TlRfTUFYOworCWJlc3RpbmRleCA9IC0xOworCWZvciAoaSA9IDA7IGkgPCBtYzEzeHh4X3JlZ3Vs
YXRvcnNbcmVnX2lkXS5kZXNjLm5fdm9sdGFnZXM7IGkrKykgeworCQlpZiAobWMxM3h4eF9yZWd1
bGF0b3JzW3JlZ19pZF0udm9sdGFnZXNbaV0gPj0gbWluX3VWICYmCisJCSAgICBtYzEzeHh4X3Jl
Z3VsYXRvcnNbcmVnX2lkXS52b2x0YWdlc1tpXSA8IGJlc3RtYXRjaCkgeworCQkJYmVzdG1hdGNo
ID0gbWMxM3h4eF9yZWd1bGF0b3JzW3JlZ19pZF0udm9sdGFnZXNbaV07CisJCQliZXN0aW5kZXgg
PSBpOworCQl9CisJfQorCisJaWYgKGJlc3RpbmRleCA8IDAgfHwgYmVzdG1hdGNoID4gbWF4X3VW
KSB7CisJCWRldl93YXJuKCZyZGV2LT5kZXYsICJubyBwb3NzaWJsZSB2YWx1ZSBmb3IgJWQ8PXg8
PSVkIHVWXG4iLAorCQkJCW1pbl91ViwgbWF4X3VWKTsKKwkJcmV0dXJuIC1FSU5WQUw7CisJfQor
CXJldHVybiBiZXN0aW5kZXg7Cit9CisKK3N0YXRpYyBpbnQgbWMxM3h4eF9yZWd1bGF0b3Jfc2V0
X3ZvbHRhZ2Uoc3RydWN0IHJlZ3VsYXRvcl9kZXYgKnJkZXYsCisJCQkJCQlpbnQgbWluX3VWLCBp
bnQgbWF4X3VWKQoreworCXN0cnVjdCBtYzEzeHh4X3JlZ3VsYXRvcl9wcml2ICpwcml2ID0gcmRl
dl9nZXRfZHJ2ZGF0YShyZGV2KTsKKwlzdHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3IgKm1jMTN4eHhf
cmVndWxhdG9ycyA9IHByaXYtPm1jMTN4eHhfcmVndWxhdG9yczsKKwlpbnQgdmFsdWUsIGlkID0g
cmRldl9nZXRfaWQocmRldik7CisJaW50IHJldDsKKworCWRldl9kYmcocmRldl9nZXRfZGV2KHJk
ZXYpLCAiJXMgaWQ6ICVkIG1pbl91VjogJWQgbWF4X3VWOiAlZFxuIiwKKwkJX19mdW5jX18sIGlk
LCBtaW5fdVYsIG1heF91Vik7CisKKwkvKiBGaW5kIHRoZSBiZXN0IGluZGV4ICovCisJdmFsdWUg
PSBtYzEzeHh4X2dldF9iZXN0X3ZvbHRhZ2VfaW5kZXgocmRldiwgbWluX3VWLCBtYXhfdVYpOwor
CWRldl9kYmcocmRldl9nZXRfZGV2KHJkZXYpLCAiJXMgYmVzdCB2YWx1ZTogJWRcbiIsIF9fZnVu
Y19fLCB2YWx1ZSk7CisJaWYgKHZhbHVlIDwgMCkKKwkJcmV0dXJuIHZhbHVlOworCisJbWMxM3h4
eF9sb2NrKHByaXYtPm1jMTN4eHgpOworCXJldCA9IG1jMTN4eHhfcmVnX3Jtdyhwcml2LT5tYzEz
eHh4LCBtYzEzeHh4X3JlZ3VsYXRvcnNbaWRdLnZzZWxfcmVnLAorCQkJbWMxM3h4eF9yZWd1bGF0
b3JzW2lkXS52c2VsX21hc2ssCisJCQl2YWx1ZSA8PCBtYzEzeHh4X3JlZ3VsYXRvcnNbaWRdLnZz
ZWxfc2hpZnQpOworCW1jMTN4eHhfdW5sb2NrKHByaXYtPm1jMTN4eHgpOworCisJcmV0dXJuIHJl
dDsKK30KKworc3RhdGljIGludCBtYzEzeHh4X3JlZ3VsYXRvcl9nZXRfdm9sdGFnZShzdHJ1Y3Qg
cmVndWxhdG9yX2RldiAqcmRldikKK3sKKwlzdHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3JfcHJpdiAq
cHJpdiA9IHJkZXZfZ2V0X2RydmRhdGEocmRldik7CisJc3RydWN0IG1jMTN4eHhfcmVndWxhdG9y
ICptYzEzeHh4X3JlZ3VsYXRvcnMgPSBwcml2LT5tYzEzeHh4X3JlZ3VsYXRvcnM7CisJaW50IHJl
dCwgaWQgPSByZGV2X2dldF9pZChyZGV2KTsKKwl1bnNpZ25lZCBpbnQgdmFsOworCisJZGV2X2Ri
ZyhyZGV2X2dldF9kZXYocmRldiksICIlcyBpZDogJWRcbiIsIF9fZnVuY19fLCBpZCk7CisKKwlt
YzEzeHh4X2xvY2socHJpdi0+bWMxM3h4eCk7CisJcmV0ID0gbWMxM3h4eF9yZWdfcmVhZChwcml2
LT5tYzEzeHh4LAorCQkJCW1jMTN4eHhfcmVndWxhdG9yc1tpZF0udnNlbF9yZWcsICZ2YWwpOwor
CW1jMTN4eHhfdW5sb2NrKHByaXYtPm1jMTN4eHgpOworCisJaWYgKHJldCkKKwkJcmV0dXJuIHJl
dDsKKworCXZhbCA9ICh2YWwgJiBtYzEzeHh4X3JlZ3VsYXRvcnNbaWRdLnZzZWxfbWFzaykKKwkJ
Pj4gbWMxM3h4eF9yZWd1bGF0b3JzW2lkXS52c2VsX3NoaWZ0OworCisJZGV2X2RiZyhyZGV2X2dl
dF9kZXYocmRldiksICIlcyBpZDogJWQgdmFsOiAlZFxuIiwgX19mdW5jX18sIGlkLCB2YWwpOwor
CisJQlVHX09OKHZhbCA8IDAgfHwgdmFsID4gbWMxM3h4eF9yZWd1bGF0b3JzW2lkXS5kZXNjLm5f
dm9sdGFnZXMpOworCisJcmV0dXJuIG1jMTN4eHhfcmVndWxhdG9yc1tpZF0udm9sdGFnZXNbdmFs
XTsKK30KKworc3RydWN0IHJlZ3VsYXRvcl9vcHMgbWMxM3h4eF9yZWd1bGF0b3Jfb3BzID0gewor
CS5lbmFibGUgPSBtYzEzeHh4X3JlZ3VsYXRvcl9lbmFibGUsCisJLmRpc2FibGUgPSBtYzEzeHh4
X3JlZ3VsYXRvcl9kaXNhYmxlLAorCS5pc19lbmFibGVkID0gbWMxM3h4eF9yZWd1bGF0b3JfaXNf
ZW5hYmxlZCwKKwkubGlzdF92b2x0YWdlID0gbWMxM3h4eF9yZWd1bGF0b3JfbGlzdF92b2x0YWdl
LAorCS5zZXRfdm9sdGFnZSA9IG1jMTN4eHhfcmVndWxhdG9yX3NldF92b2x0YWdlLAorCS5nZXRf
dm9sdGFnZSA9IG1jMTN4eHhfcmVndWxhdG9yX2dldF92b2x0YWdlLAorfTsKKworaW50IG1jMTN4
eHhfZml4ZWRfcmVndWxhdG9yX3NldF92b2x0YWdlKHN0cnVjdCByZWd1bGF0b3JfZGV2ICpyZGV2
LAorCQkJCQkJaW50IG1pbl91ViwgaW50IG1heF91VikKK3sKKwlzdHJ1Y3QgbWMxM3h4eF9yZWd1
bGF0b3JfcHJpdiAqcHJpdiA9IHJkZXZfZ2V0X2RydmRhdGEocmRldik7CisJc3RydWN0IG1jMTN4
eHhfcmVndWxhdG9yICptYzEzeHh4X3JlZ3VsYXRvcnMgPSBwcml2LT5tYzEzeHh4X3JlZ3VsYXRv
cnM7CisJaW50IGlkID0gcmRldl9nZXRfaWQocmRldik7CisKKwlkZXZfZGJnKHJkZXZfZ2V0X2Rl
dihyZGV2KSwgIiVzIGlkOiAlZCBtaW5fdVY6ICVkIG1heF91VjogJWRcbiIsCisJCV9fZnVuY19f
LCBpZCwgbWluX3VWLCBtYXhfdVYpOworCisJaWYgKG1pbl91ViA+PSBtYzEzeHh4X3JlZ3VsYXRv
cnNbaWRdLnZvbHRhZ2VzWzBdICYmCisJICAgIG1heF91ViA8PSBtYzEzeHh4X3JlZ3VsYXRvcnNb
aWRdLnZvbHRhZ2VzWzBdKQorCQlyZXR1cm4gMDsKKwllbHNlCisJCXJldHVybiAtRUlOVkFMOwor
fQorCitpbnQgbWMxM3h4eF9maXhlZF9yZWd1bGF0b3JfZ2V0X3ZvbHRhZ2Uoc3RydWN0IHJlZ3Vs
YXRvcl9kZXYgKnJkZXYpCit7CisJc3RydWN0IG1jMTN4eHhfcmVndWxhdG9yX3ByaXYgKnByaXYg
PSByZGV2X2dldF9kcnZkYXRhKHJkZXYpOworCXN0cnVjdCBtYzEzeHh4X3JlZ3VsYXRvciAqbWMx
M3h4eF9yZWd1bGF0b3JzID0gcHJpdi0+bWMxM3h4eF9yZWd1bGF0b3JzOworCWludCBpZCA9IHJk
ZXZfZ2V0X2lkKHJkZXYpOworCisJZGV2X2RiZyhyZGV2X2dldF9kZXYocmRldiksICIlcyBpZDog
JWRcbiIsIF9fZnVuY19fLCBpZCk7CisKKwlyZXR1cm4gbWMxM3h4eF9yZWd1bGF0b3JzW2lkXS52
b2x0YWdlc1swXTsKK30KKworc3RydWN0IHJlZ3VsYXRvcl9vcHMgbWMxM3h4eF9maXhlZF9yZWd1
bGF0b3Jfb3BzID0geworCS5lbmFibGUgPSBtYzEzeHh4X3JlZ3VsYXRvcl9lbmFibGUsCisJLmRp
c2FibGUgPSBtYzEzeHh4X3JlZ3VsYXRvcl9kaXNhYmxlLAorCS5pc19lbmFibGVkID0gbWMxM3h4
eF9yZWd1bGF0b3JfaXNfZW5hYmxlZCwKKwkubGlzdF92b2x0YWdlID0gbWMxM3h4eF9yZWd1bGF0
b3JfbGlzdF92b2x0YWdlLAorCS5zZXRfdm9sdGFnZSA9IG1jMTN4eHhfZml4ZWRfcmVndWxhdG9y
X3NldF92b2x0YWdlLAorCS5nZXRfdm9sdGFnZSA9IG1jMTN4eHhfZml4ZWRfcmVndWxhdG9yX2dl
dF92b2x0YWdlLAorfTsKKworaW50IG1jMTN4eHhfc3dfcmVndWxhdG9yX2lzX2VuYWJsZWQoc3Ry
dWN0IHJlZ3VsYXRvcl9kZXYgKnJkZXYpCit7CisJcmV0dXJuIDE7Cit9CisKK01PRFVMRV9MSUNF
TlNFKCJHUEwgdjIiKTsKK01PRFVMRV9BVVRIT1IoIllvbmcgU2hlbiA8eW9uZy5zaGVuQGxpbmFy
by5vcmc+Iik7CitNT0RVTEVfREVTQ1JJUFRJT04oIlJlZ3VsYXRvciBEcml2ZXIgZm9yIEZyZWVz
Y2FsZSBNQzEzeHh4IFBNSUMiKTsKK01PRFVMRV9BTElBUygibWMxM3h4eC1yZWd1bGF0b3ItY29y
ZSIpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9yZWd1bGF0b3IvbWMxM3h4eC5oIGIvZHJpdmVycy9y
ZWd1bGF0b3IvbWMxM3h4eC5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLmE2
MGM5YmUKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL3JlZ3VsYXRvci9tYzEzeHh4LmgKQEAg
LTAsMCArMSwxMDEgQEAKKy8qCisgKiBtYzEzeHh4LmggLSByZWd1bGF0b3JzIGZvciB0aGUgRnJl
ZXNjYWxlIG1jMTN4eHggUE1JQworICoKKyAqICBDb3B5cmlnaHQgKEMpIDIwMTAgWW9uZyBTaGVu
IDx5b25nLnNoZW5AbGluYXJvLm9yZz4KKyAqCisgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0
d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQorICogaXQgdW5kZXIg
dGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQg
YnkKKyAqIHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJzaW9uIDIgb2Yg
dGhlIExpY2Vuc2UsIG9yCisgKiAoYXQgeW91ciBvcHRpb24pIGFueSBsYXRlciB2ZXJzaW9uLgor
ICovCisKKyNpZm5kZWYgX19MSU5VWF9SRUdVTEFUT1JfTUMxM1hYWF9ICisjZGVmaW5lIF9fTElO
VVhfUkVHVUxBVE9SX01DMTNYWFhfSAorCisjaW5jbHVkZSA8bGludXgvcmVndWxhdG9yL2RyaXZl
ci5oPgorCitzdHJ1Y3QgbWMxM3h4eF9yZWd1bGF0b3IgeworCXN0cnVjdCByZWd1bGF0b3JfZGVz
YyBkZXNjOworCWludCByZWc7CisJaW50IGVuYWJsZV9iaXQ7CisJaW50IHZzZWxfcmVnOworCWlu
dCB2c2VsX3NoaWZ0OworCWludCB2c2VsX21hc2s7CisJaW50IGhpX2JpdDsKKwlpbnQgY29uc3Qg
KnZvbHRhZ2VzOworfTsKKworc3RydWN0IG1jMTN4eHhfcmVndWxhdG9yX3ByaXYgeworCXN0cnVj
dCBtYzEzeHh4ICptYzEzeHh4OworCXUzMiBwb3dlcm1pc2NfcHdndF9zdGF0ZTsKKwlzdHJ1Y3Qg
bWMxM3h4eF9yZWd1bGF0b3IgKm1jMTN4eHhfcmVndWxhdG9yczsKKwlzdHJ1Y3QgcmVndWxhdG9y
X2RldiAqcmVndWxhdG9yc1tdOworfTsKKworZXh0ZXJuIGludCBtYzEzeHh4X3N3X3JlZ3VsYXRv
cihzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldik7CitleHRlcm4gaW50IG1jMTN4eHhfc3dfcmVn
dWxhdG9yX2lzX2VuYWJsZWQoc3RydWN0IHJlZ3VsYXRvcl9kZXYgKnJkZXYpOworZXh0ZXJuIGlu
dCBtYzEzeHh4X2dldF9iZXN0X3ZvbHRhZ2VfaW5kZXgoc3RydWN0IHJlZ3VsYXRvcl9kZXYgKnJk
ZXYsCisJCQkJCQlpbnQgbWluX3VWLCBpbnQgbWF4X3VWKTsKK2V4dGVybiBpbnQgbWMxM3h4eF9y
ZWd1bGF0b3JfbGlzdF92b2x0YWdlKHN0cnVjdCByZWd1bGF0b3JfZGV2ICpyZGV2LAorCQkJCQkJ
dW5zaWduZWQgc2VsZWN0b3IpOworZXh0ZXJuIGludCBtYzEzeHh4X2ZpeGVkX3JlZ3VsYXRvcl9z
ZXRfdm9sdGFnZShzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldiwKKwkJCQkJCWludCBtaW5fdVYs
IGludCBtYXhfdVYpOworZXh0ZXJuIGludCBtYzEzeHh4X2ZpeGVkX3JlZ3VsYXRvcl9nZXRfdm9s
dGFnZShzdHJ1Y3QgcmVndWxhdG9yX2RldiAqcmRldik7CisKK2V4dGVybiBzdHJ1Y3QgcmVndWxh
dG9yX29wcyBtYzEzeHh4X3JlZ3VsYXRvcl9vcHM7CitleHRlcm4gc3RydWN0IHJlZ3VsYXRvcl9v
cHMgbWMxM3h4eF9maXhlZF9yZWd1bGF0b3Jfb3BzOworCisjZGVmaW5lIE1DMTN4eHhfREVGSU5F
KHByZWZpeCwgX25hbWUsIF9yZWcsIF92c2VsX3JlZywgX3ZvbHRhZ2VzLCBfb3BzKQlcCisJW3By
ZWZpeCAjIyBfbmFtZV0gPSB7CQkJCVwKKwkJLmRlc2MgPSB7CQkJCQkJXAorCQkJLm5hbWUgPSAj
cHJlZml4ICJfIiAjX25hbWUsCQkJXAorCQkJLm5fdm9sdGFnZXMgPSBBUlJBWV9TSVpFKF92b2x0
YWdlcyksCQlcCisJCQkub3BzID0gJl9vcHMsCQkJXAorCQkJLnR5cGUgPSBSRUdVTEFUT1JfVk9M
VEFHRSwJCQlcCisJCQkuaWQgPSBwcmVmaXggIyMgX25hbWUsCQlcCisJCQkub3duZXIgPSBUSElT
X01PRFVMRSwJCQkJXAorCQl9LAkJCQkJCQlcCisJCS5yZWcgPSBwcmVmaXggIyMgX3JlZywJCQkJ
XAorCQkuZW5hYmxlX2JpdCA9IHByZWZpeCAjIyBfcmVnICMjIF8gIyMgX25hbWUgIyMgRU4sCVwK
KwkJLnZzZWxfcmVnID0gcHJlZml4ICMjIF92c2VsX3JlZywJCQlcCisJCS52c2VsX3NoaWZ0ID0g
cHJlZml4ICMjIF92c2VsX3JlZyAjIyBfICMjIF9uYW1lICMjIFZTRUwsXAorCQkudnNlbF9tYXNr
ID0gcHJlZml4ICMjIF92c2VsX3JlZyAjIyBfICMjIF9uYW1lICMjIFZTRUxfTSxcCisJCS52b2x0
YWdlcyA9ICBfdm9sdGFnZXMsCQkJCQlcCisJfQorCisjZGVmaW5lIE1DMTN4eHhfRklYRURfREVG
SU5FKHByZWZpeCwgX25hbWUsIF9yZWcsIF92b2x0YWdlcywgX29wcykJXAorCVtwcmVmaXggIyMg
X25hbWVdID0gewkJCQlcCisJCS5kZXNjID0gewkJCQkJCVwKKwkJCS5uYW1lID0gI3ByZWZpeCAi
XyIgI19uYW1lLAkJCVwKKwkJCS5uX3ZvbHRhZ2VzID0gQVJSQVlfU0laRShfdm9sdGFnZXMpLAkJ
XAorCQkJLm9wcyA9ICZfb3BzLAkJXAorCQkJLnR5cGUgPSBSRUdVTEFUT1JfVk9MVEFHRSwJCQlc
CisJCQkuaWQgPSBwcmVmaXggIyMgX25hbWUsCQlcCisJCQkub3duZXIgPSBUSElTX01PRFVMRSwJ
CQkJXAorCQl9LAkJCQkJCQlcCisJCS5yZWcgPSBwcmVmaXggIyMgX3JlZywJCQkJXAorCQkuZW5h
YmxlX2JpdCA9IHByZWZpeCAjIyBfcmVnICMjIF8gIyMgX25hbWUgIyMgRU4sCVwKKwkJLnZvbHRh
Z2VzID0gIF92b2x0YWdlcywJCQkJCVwKKwl9CisKKyNkZWZpbmUgTUMxM3h4eF9HUE9fREVGSU5F
KHByZWZpeCwgX25hbWUsIF9yZWcsICBfdm9sdGFnZXMsIF9vcHMpCVwKKwlbcHJlZml4ICMjIF9u
YW1lXSA9IHsJCQkJXAorCQkuZGVzYyA9IHsJCQkJCQlcCisJCQkubmFtZSA9ICNwcmVmaXggIl8i
ICNfbmFtZSwJCQlcCisJCQkubl92b2x0YWdlcyA9IEFSUkFZX1NJWkUoX3ZvbHRhZ2VzKSwJCVwK
KwkJCS5vcHMgPSAmX29wcywJCVwKKwkJCS50eXBlID0gUkVHVUxBVE9SX1ZPTFRBR0UsCQkJXAor
CQkJLmlkID0gcHJlZml4ICMjIF9uYW1lLAkJXAorCQkJLm93bmVyID0gVEhJU19NT0RVTEUsCQkJ
CVwKKwkJfSwJCQkJCQkJXAorCQkucmVnID0gcHJlZml4ICMjIF9yZWcsCQkJCVwKKwkJLmVuYWJs
ZV9iaXQgPSBwcmVmaXggIyMgX3JlZyAjIyBfICMjIF9uYW1lICMjIEVOLAlcCisJCS52b2x0YWdl
cyA9ICBfdm9sdGFnZXMsCQkJCQlcCisJfQorCisjZGVmaW5lIE1DMTN4eHhfREVGSU5FX1NXKF9u
YW1lLCBfcmVnLCBfdnNlbF9yZWcsIF92b2x0YWdlcywgb3BzKQlcCisJTUMxM3h4eF9ERUZJTkUo
U1csIF9uYW1lLCBfcmVnLCBfdnNlbF9yZWcsIF92b2x0YWdlcywgb3BzKQorI2RlZmluZSBNQzEz
eHh4X0RFRklORV9SRUdVKF9uYW1lLCBfcmVnLCBfdnNlbF9yZWcsIF92b2x0YWdlcywgb3BzKQlc
CisJTUMxM3h4eF9ERUZJTkUoUkVHVSwgX25hbWUsIF9yZWcsIF92c2VsX3JlZywgX3ZvbHRhZ2Vz
LCBvcHMpCisKKyNlbmRpZgotLSAKMS43LjAuNAoK
--000e0cd485a0fd70b404966b1e0e--
