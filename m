Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab1CIMD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 07:03:26 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:39792 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932224Ab1CIMDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 07:03:25 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>
Subject: [PATCH 2/3] regulator: add a subdriver for TI TPS6105x regulator portions v2
Date: Wed, 9 Mar 2011 13:02:55 +0100
Message-ID: <1299672175-4745-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This adds a subdriver for the regulator found inside the TPS61050
and TPS61052 chips.

Cc: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: Ola Lilja <ola.o.lilja@stericsson.com>
Cc: Jonas Aberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/Kconfig                    |    2 +
 drivers/regulator/Kconfig              |    9 ++
 drivers/regulator/Makefile             |    2 +-
 drivers/regulator/tps6105x-regulator.c |  195 ++++++++++++++++++++++++++++++++
 include/linux/mfd/tps6105x.h           |    6 +
 5 files changed, 213 insertions(+), 1 deletions(-)
 create mode 100644 drivers/regulator/tps6105x-regulator.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 35b085a..3a6411f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -121,6 +121,8 @@ config UCB1400_CORE
 config TPS6105X
 	tristate "TPS61050/61052 Boost Converters"
 	depends on I2C
+	select REGULATOR
+	select REGULATOR_FIXED_VOLTAGE
 	help
 	  This option enables a driver for the TP61050/TPS61052
 	  high-power "white LED driver". This boost converter is
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index e1d9436..0e52301 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -214,6 +214,15 @@ config REGULATOR_AB3100
 	 AB3100 analog baseband dealing with power regulators
 	 for the system.
 
+config REGULATOR_TPS6105X
+	tristate "TI TPS6105X Power regulators"
+	depends on TPS6105X
+	default y if TPS6105X
+	help
+	  This driver supports TPS61050/TPS61052 voltage regulator chips.
+	  It is a single boost converter primarily for white LEDs and
+	  audio amplifiers.
+
 config REGULATOR_TPS65023
 	tristate "TI TPS65023 Power regulators"
 	depends on I2C
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 0b5e88c..1d797c7 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -33,7 +33,7 @@ obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
 obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
 obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
 obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
-
+obj-$(CONFIG_REGULATOR_TPS6105X) += tps6105x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6507X) += tps6507x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6524X) += tps6524x-regulator.o
diff --git a/drivers/regulator/tps6105x-regulator.c b/drivers/regulator/tps6105x-regulator.c
new file mode 100644
index 0000000..d6d6a48
--- /dev/null
+++ b/drivers/regulator/tps6105x-regulator.c
@@ -0,0 +1,195 @@
+/*
+ * Driver for TPS61050/61052 boost converters, typically used for white LEDs
+ * or audio amplifiers.
+ *
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/mfd/tps6105x.h>
+
+static const int tps6105x_voltages[] = {
+	4500000,
+	5000000,
+	5250000,
+	5000000, /* There is an additional 5V */
+};
+
+static int tps6105x_regulator_enable(struct regulator_dev *rdev)
+{
+	struct tps6105x *tps6105x = rdev_get_drvdata(rdev);
+	int ret;
+
+	/* Activate voltage mode */
+	ret = tps6105x_mask_and_set(tps6105x, TPS6105X_REG_0,
+		TPS6105X_REG0_MODE_MASK,
+		TPS6105X_REG0_MODE_VOLTAGE << TPS6105X_REG0_MODE_SHIFT);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int tps6105x_regulator_disable(struct regulator_dev *rdev)
+{
+	struct tps6105x *tps6105x = rdev_get_drvdata(rdev);
+	int ret;
+
+	/* Set into shutdown mode */
+	ret = tps6105x_mask_and_set(tps6105x, TPS6105X_REG_0,
+		TPS6105X_REG0_MODE_MASK,
+		TPS6105X_REG0_MODE_SHUTDOWN << TPS6105X_REG0_MODE_SHIFT);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int tps6105x_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	struct tps6105x *tps6105x = rdev_get_drvdata(rdev);
+	u8 regval;
+	int ret;
+
+	ret = tps6105x_get(tps6105x, TPS6105X_REG_0, &regval);
+	if (ret)
+		return ret;
+	regval &= TPS6105X_REG0_MODE_MASK;
+	regval >>= TPS6105X_REG0_MODE_SHIFT;
+
+	if (regval == TPS6105X_REG0_MODE_VOLTAGE)
+		return 1;
+
+	return 0;
+}
+
+static int tps6105x_regulator_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct tps6105x *tps6105x = rdev_get_drvdata(rdev);
+	u8 regval;
+	int ret;
+
+	ret = tps6105x_get(tps6105x, TPS6105X_REG_0, &regval);
+	if (ret)
+		return ret;
+
+	regval &= TPS6105X_REG0_VOLTAGE_MASK;
+	regval >>= TPS6105X_REG0_VOLTAGE_SHIFT;
+	return (int) regval;
+}
+
+static int tps6105x_regulator_set_voltage_sel(struct regulator_dev *rdev,
+					      unsigned selector)
+{
+	struct tps6105x *tps6105x = rdev_get_drvdata(rdev);
+	int ret;
+
+	ret = tps6105x_mask_and_set(tps6105x, TPS6105X_REG_0,
+				    TPS6105X_REG0_VOLTAGE_MASK,
+				    selector << TPS6105X_REG0_VOLTAGE_SHIFT);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int tps6105x_regulator_list_voltage(struct regulator_dev *rdev,
+					   unsigned selector)
+{
+	if (selector >= ARRAY_SIZE(tps6105x_voltages))
+		return -EINVAL;
+
+	return tps6105x_voltages[selector];
+}
+
+static struct regulator_ops tps6105x_regulator_ops = {
+	.enable		= tps6105x_regulator_enable,
+	.disable	= tps6105x_regulator_disable,
+	.is_enabled	= tps6105x_regulator_is_enabled,
+	.get_voltage_sel = tps6105x_regulator_get_voltage_sel,
+	.set_voltage_sel = tps6105x_regulator_set_voltage_sel,
+	.list_voltage	= tps6105x_regulator_list_voltage,
+};
+
+static struct regulator_desc tps6105x_regulator_desc = {
+	.name		= "tps6105x-boost",
+	.ops		= &tps6105x_regulator_ops,
+	.type		= REGULATOR_VOLTAGE,
+	.id		= 0,
+	.owner		= THIS_MODULE,
+	.n_voltages	= ARRAY_SIZE(tps6105x_voltages),
+};
+
+/*
+ * Registers the chip as a voltage regulator
+ */
+static int __devinit tps6105x_regulator_probe(struct platform_device *pdev)
+{
+	struct tps6105x *tps6105x = platform_get_drvdata(pdev);
+	struct tps6105x_platform_data *pdata = tps6105x->pdata;
+	int ret;
+
+	/* This instance is not set for regulator mode so bail out */
+	if (pdata->mode != TPS6105X_MODE_VOLTAGE) {
+		dev_info(&pdev->dev,
+			 "chip not in voltage mode mode, exit probe \n");
+		return 0;
+	}
+
+	/* Register regulator with framework */
+	tps6105x->regulator = regulator_register(&tps6105x_regulator_desc,
+					     &tps6105x->client->dev,
+					     pdata->regulator_data, tps6105x);
+	if (IS_ERR(tps6105x->regulator)) {
+		ret = PTR_ERR(tps6105x->regulator);
+		dev_err(&tps6105x->client->dev,
+			"failed to register regulator\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __devexit tps6105x_regulator_remove(struct platform_device *pdev)
+{
+	struct tps6105x *tps6105x = platform_get_drvdata(pdev);
+	regulator_unregister(tps6105x->regulator);
+	return 0;
+}
+
+static struct platform_driver tps6105x_regulator_driver = {
+	.driver = {
+		.name  = "tps6105x-regulator",
+		.owner = THIS_MODULE,
+	},
+	.probe = tps6105x_regulator_probe,
+	.remove = __devexit_p(tps6105x_regulator_remove),
+};
+
+static __init int tps6105x_regulator_init(void)
+{
+	return platform_driver_register(&tps6105x_regulator_driver);
+}
+subsys_initcall(tps6105x_regulator_init);
+
+static __exit void tps6105x_regulator_exit(void)
+{
+	platform_driver_unregister(&tps6105x_regulator_driver);
+}
+module_exit(tps6105x_regulator_exit);
+
+MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
+MODULE_DESCRIPTION("TPS6105x regulator driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tps6105x-regulator");
diff --git a/include/linux/mfd/tps6105x.h b/include/linux/mfd/tps6105x.h
index f259244..386743d 100644
--- a/include/linux/mfd/tps6105x.h
+++ b/include/linux/mfd/tps6105x.h
@@ -10,6 +10,7 @@
 #define MFD_TPS6105X_H
 
 #include <linux/i2c.h>
+#include <linux/regulator/machine.h>
 
 /*
  * Register definitions to all subdrivers
@@ -71,20 +72,25 @@ enum tps6105x_mode {
  * struct tps6105x_platform_data - TPS61905x platform data
  * @mode: what mode this instance shall be operated in,
  *	this is not selectable at runtime
+ * @regulator_data: initialization data for the voltage
+ *	regulator if used as a voltage source
  */
 struct tps6105x_platform_data {
 	enum tps6105x_mode mode;
+	struct regulator_init_data *regulator_data;
 };
 
 /**
  * struct tps6105x - state holder for the TPS6105x drivers
  * @mutex: mutex to serialize I2C accesses
  * @i2c_client: corresponding I2C client
+ * @regulator: regulator device if used in voltage mode
  */
 struct tps6105x {
 	struct tps6105x_platform_data *pdata;
 	struct mutex		lock;
 	struct i2c_client	*client;
+	struct regulator_dev	*regulator;
 };
 
 extern int tps6105x_set(struct tps6105x *tps6105x, u8 reg, u8 value);
-- 
1.7.3.2

