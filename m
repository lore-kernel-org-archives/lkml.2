Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab2FTKpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:45:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52337 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811Ab2FTKpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:45:49 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: arizona: Add support for microphone supplies on Arizona devices
Date: Wed, 20 Jun 2012 11:45:41 +0100
Message-Id: <1340189141-20219-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Wolfson Arizona platform is used for a range of low power audio hub
CODECs. Many of these devices feature an integrated power supply for the
microphone which is supported by this driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/Kconfig           |    7 ++
 drivers/regulator/Makefile          |    1 +
 drivers/regulator/arizona-micsupp.c |  184 +++++++++++++++++++++++++++++++++++
 3 files changed, 192 insertions(+)
 create mode 100644 drivers/regulator/arizona-micsupp.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 00ffe05..3211176 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -88,6 +88,13 @@ config REGULATOR_AAT2870
 	  If you have a AnalogicTech AAT2870 say Y to enable the
 	  regulator driver.
 
+config REGULATOR_ARIZONA
+	tristate "Wolfson Arizona class devices"
+	depends on MFD_ARIZONA
+	help
+	  Support for the regulators found on Wolfson Arizona class
+	  devices.
+
 config REGULATOR_DA903X
 	tristate "Dialog Semiconductor DA9030/DA9034 regulators"
 	depends on PMIC_DA903X
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index d8544539..f1bddce 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
 obj-$(CONFIG_REGULATOR_AD5398) += ad5398.o
 obj-$(CONFIG_REGULATOR_ANATOP) += anatop-regulator.o
+obj-$(CONFIG_REGULATOR_ARIZONA) += arizona-micsupp.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_DA9052)	+= da9052-regulator.o
 obj-$(CONFIG_REGULATOR_DBX500_PRCMU) += dbx500-prcmu.o
diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
new file mode 100644
index 0000000..97d85b0
--- /dev/null
+++ b/drivers/regulator/arizona-micsupp.c
@@ -0,0 +1,184 @@
+/*
+ * arizona-micsupp.c  --  Microphone supply for Arizona devices
+ *
+ * Copyright 2012 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/arizona/core.h>
+#include <linux/mfd/arizona/pdata.h>
+#include <linux/mfd/arizona/registers.h>
+
+#define ARIZONA_MICSUPP_MAX_SELECTOR 0x1f
+
+struct arizona_micsupp {
+	struct regulator_dev *regulator;
+	struct arizona *arizona;
+
+	struct regulator_consumer_supply supply;
+	struct regulator_init_data init_data;
+};
+
+static int arizona_micsupp_list_voltage(struct regulator_dev *rdev,
+					unsigned int selector)
+{
+	if (selector > ARIZONA_MICSUPP_MAX_SELECTOR)
+		return -EINVAL;
+
+	if (selector == ARIZONA_MICSUPP_MAX_SELECTOR)
+		return 3300000;
+	else
+		return (selector * 50000) + 1700000;
+}
+
+static int arizona_micsupp_map_voltage(struct regulator_dev *rdev,
+				       int min_uV, int max_uV)
+{
+	unsigned int voltage;
+	int selector;
+
+	if (min_uV < 1700000)
+		min_uV = 1700000;
+
+	if (min_uV >= 3300000)
+		selector = ARIZONA_MICSUPP_MAX_SELECTOR;
+	else
+		selector = DIV_ROUND_UP(min_uV - 1700000, 50000);
+
+	if (selector < 0)
+		return -EINVAL;
+
+	voltage = arizona_micsupp_list_voltage(rdev, selector);
+	if (voltage < min_uV || voltage > max_uV)
+		return -EINVAL;
+
+	return selector;
+}
+
+static struct regulator_ops arizona_micsupp_ops = {
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+
+	.list_voltage = arizona_micsupp_list_voltage,
+	.map_voltage = arizona_micsupp_map_voltage,
+
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+};
+
+static const struct regulator_desc arizona_micsupp = {
+	.name = "MICVDD",
+	.supply_name = "CPVDD",
+	.type = REGULATOR_VOLTAGE,
+	.n_voltages = ARIZONA_MICSUPP_MAX_SELECTOR + 1,
+	.ops = &arizona_micsupp_ops,
+
+	.vsel_reg = ARIZONA_LDO2_CONTROL_1,
+	.vsel_mask = ARIZONA_LDO2_VSEL_MASK,
+	.enable_reg = ARIZONA_MIC_CHARGE_PUMP_1,
+	.enable_mask = ARIZONA_CPMIC_ENA,
+
+	.owner = THIS_MODULE,
+};
+
+static const struct regulator_init_data arizona_micsupp_default = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS |
+				REGULATOR_CHANGE_VOLTAGE,
+		.min_uV = 1700000,
+		.max_uV = 3300000,
+	},
+
+	.num_consumer_supplies = 1,
+};
+
+static __devinit int arizona_micsupp_probe(struct platform_device *pdev)
+{
+	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
+	struct regulator_config config = { };
+	struct arizona_micsupp *micsupp;
+	int ret;
+
+	micsupp = devm_kzalloc(&pdev->dev, sizeof(*micsupp), GFP_KERNEL);
+	if (micsupp == NULL) {
+		dev_err(&pdev->dev, "Unable to allocate private data\n");
+		return -ENOMEM;
+	}
+
+	micsupp->arizona = arizona;
+
+	/*
+	 * Since the chip usually supplies itself we provide some
+	 * default init_data for it.  This will be overridden with
+	 * platform data if provided.
+	 */
+	micsupp->init_data = arizona_micsupp_default;
+	micsupp->init_data.consumer_supplies = &micsupp->supply;
+	micsupp->supply.supply = "MICVDD";
+	micsupp->supply.dev_name = dev_name(arizona->dev);
+
+	config.dev = arizona->dev;
+	config.driver_data = micsupp;
+	config.regmap = arizona->regmap;
+
+	if (arizona->pdata.micvdd)
+		config.init_data = arizona->pdata.micvdd;
+	else
+		config.init_data = &micsupp->init_data;
+
+	micsupp->regulator = regulator_register(&arizona_micsupp, &config);
+	if (IS_ERR(micsupp->regulator)) {
+		ret = PTR_ERR(micsupp->regulator);
+		dev_err(arizona->dev, "Failed to register mic supply: %d\n",
+			ret);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, micsupp);
+
+	return 0;
+}
+
+static __devexit int arizona_micsupp_remove(struct platform_device *pdev)
+{
+	struct arizona_micsupp *micsupp = platform_get_drvdata(pdev);
+
+	regulator_unregister(micsupp->regulator);
+
+	return 0;
+}
+
+static struct platform_driver arizona_micsupp_driver = {
+	.probe = arizona_micsupp_probe,
+	.remove = __devexit_p(arizona_micsupp_remove),
+	.driver		= {
+		.name	= "arizona-micsupp",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(arizona_micsupp_driver);
+
+/* Module information */
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_DESCRIPTION("Arizona microphone supply driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:arizona-micsupp");
-- 
1.7.10

