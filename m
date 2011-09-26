Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab1IZGwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 02:52:24 -0400
Received: from h1778886.stratoserver.net ([85.214.133.74]:54675 "EHLO
	h1778886.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1IZGwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 02:52:22 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [RFC] Add gpio based voltage switching regulator
Date: Mon, 26 Sep 2011 08:52:18 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-2-amd64; KDE/4.6.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201109260852.19859.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for regulators that can switch between
two voltage levels by setting a gpio.

An example such a regulator is the TI-tps65024x regulator family.
They contain 4 fixed and 1 runtime-switchable voltage regulators.
The switch can be used by a cpufreq driver to set the core
voltage on some SoCs, for example the S3C2416/2450.

Handling of set_voltage calls with a range that fits neither the
low nor the high voltage is determined by the inbetween_high
option. When set to 1 the high voltage is used, on 0 the low
voltage is used and on -EINVAL an error is returned, disallowing
the usage of the voltage range.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>

---
I'm not hung up on the "inbetween handling", in fact at the moment it
seems to not belong there. But I'm not sure on how to handle
frequency tables like
	[0] = { 1000000, 1150000 },
	[1] = { 1150000, 1250000 },
	[2] = { 1250000, 1350000 },
I.e. the middle value should use the voltage in 2 for switch regulators,
but the defined value for more intelligent ones.

 drivers/regulator/Kconfig        |    8 +
 drivers/regulator/Makefile       |    1 +
 drivers/regulator/switch.c       |  320 ++++++++++++++++++++++++++++++++++++++
 include/linux/regulator/switch.h |   65 ++++++++
 4 files changed, 394 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index c7fd2c0..8510d8c 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -45,6 +45,14 @@ config REGULATOR_FIXED_VOLTAGE
 	  useful for systems which use a combination of software
 	  managed regulators and simple non-configurable regulators.
 
+config REGULATOR_SWITCHED_VOLTAGE
+	tristate "Switched voltage regulator support"
+	help
+	  This driver provides support for regulators that can switch
+	  between two voltages by setting a gpio,
+	  useful for systems which use a combination of software
+	  managed regulators and simple non-configurable regulators.
+
 config REGULATOR_VIRTUAL_CONSUMER
 	tristate "Virtual regulator consumer support"
 	help
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 040d5aa..5a8f4ee 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -5,6 +5,7 @@
 
 obj-$(CONFIG_REGULATOR) += core.o dummy.o
 obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
+obj-$(CONFIG_REGULATOR_SWITCHED_VOLTAGE) += switch.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 
diff --git a/drivers/regulator/switch.c b/drivers/regulator/switch.c
new file mode 100644
index 0000000..012e3e9
--- /dev/null
+++ b/drivers/regulator/switch.c
@@ -0,0 +1,320 @@
+/*
+ * switched.c
+ *
+ * Copyright 2011 Heiko Stuebner <heiko@sntech.de>
+ *
+ * based on fixed.c
+ *
+ * Copyright 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * Copyright (c) 2009 Nokia Corporation
+ * Roger Quadros <ext-roger.quadros@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This is useful for systems with mixed controllable and
+ * non-controllable regulators, as well as for allowing testing on
+ * systems with no controllable regulators.
+ */
+
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/switch.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+
+struct switched_voltage_data {
+	struct regulator_desc desc;
+	struct regulator_dev *dev;
+
+	int microvolts_high;
+	int microvolts_low;
+
+	unsigned startup_delay;
+	int inbetween_high;
+
+	int gpio_enable;
+	int gpio_switch;
+
+	bool switch_high;
+	bool enable_high;
+
+	bool is_switched;
+	bool is_enabled;
+};
+
+static int switched_voltage_is_enabled(struct regulator_dev *dev)
+{
+	struct switched_voltage_data *data = rdev_get_drvdata(dev);
+
+	return data->is_enabled;
+}
+
+static int switched_voltage_enable(struct regulator_dev *dev)
+{
+	struct switched_voltage_data *data = rdev_get_drvdata(dev);
+
+	if (gpio_is_valid(data->gpio_enable)) {
+		gpio_set_value_cansleep(data->gpio_enable, data->enable_high);
+		data->is_enabled = true;
+	}
+
+	return 0;
+}
+
+static int switched_voltage_disable(struct regulator_dev *dev)
+{
+	struct switched_voltage_data *data = rdev_get_drvdata(dev);
+
+	if (gpio_is_valid(data->gpio_enable)) {
+		gpio_set_value_cansleep(data->gpio_enable, !data->enable_high);
+		data->is_enabled = false;
+	}
+
+	return 0;
+}
+
+static int switched_voltage_enable_time(struct regulator_dev *dev)
+{
+	struct switched_voltage_data *data = rdev_get_drvdata(dev);
+
+	return data->startup_delay;
+}
+
+static int switched_voltage_get_voltage(struct regulator_dev *dev)
+{
+	struct switched_voltage_data *data = rdev_get_drvdata(dev);
+
+	return data->is_switched ? data->microvolts_high : data->microvolts_low;
+}
+
+static int switched_voltage_set_voltage(struct regulator_dev *dev,
+					int min_uV, int max_uV,
+					unsigned *selector)
+{
+	struct switched_voltage_data *data = rdev_get_drvdata(dev);
+
+	if (max_uV < data->microvolts_low || min_uV > data->microvolts_high)
+		return -EINVAL;
+
+	if (min_uV <= data->microvolts_low && max_uV >= data->microvolts_low) {
+		gpio_set_value_cansleep(data->gpio_switch, !data->switch_high);
+		data->is_switched = false;
+		return 0;
+	}
+
+	if (min_uV <= data->microvolts_high && max_uV >= data->microvolts_high) {
+		gpio_set_value_cansleep(data->gpio_switch, data->switch_high);
+		data->is_switched = true;
+		return 0;
+	}
+
+	/* target range does not match min_uV or max_uV, inbetween handling */
+	if (data->inbetween_high < 0)
+		return -EINVAL;
+
+	gpio_set_value_cansleep(data->gpio_switch,
+				data->inbetween_high ? data->switch_high
+						     : !data->switch_high);
+	data->is_switched = data->inbetween_high ? true : false;
+
+	return 0;
+}
+
+static int switched_voltage_list_voltage(struct regulator_dev *dev,
+				      unsigned selector)
+{
+	struct switched_voltage_data *data = rdev_get_drvdata(dev);
+
+	switch (selector) {
+	case 0:
+		return data->microvolts_low;
+		break;
+	case 1:
+		return data->microvolts_high;
+		break;
+	default:
+		return -EINVAL;
+		break;
+	}
+}
+
+static struct regulator_ops switched_voltage_ops = {
+	.is_enabled = switched_voltage_is_enabled,
+	.enable = switched_voltage_enable,
+	.disable = switched_voltage_disable,
+	.enable_time = switched_voltage_enable_time,
+	.get_voltage = switched_voltage_get_voltage,
+	.set_voltage = switched_voltage_set_voltage,
+	.list_voltage = switched_voltage_list_voltage,
+};
+
+static int __devinit reg_switched_voltage_probe(struct platform_device *pdev)
+{
+	struct switched_voltage_config *config = pdev->dev.platform_data;
+	struct switched_voltage_data *drvdata;
+	int ret;
+
+	if (!config->init_data) {
+		dev_err(&pdev->dev, "regulator init_data missing\n");
+		return -EINVAL;
+	}
+
+	drvdata = kzalloc(sizeof(struct switched_voltage_data), GFP_KERNEL);
+	if (drvdata == NULL) {
+		dev_err(&pdev->dev, "Failed to allocate device data\n");
+		return -ENOMEM;
+	}
+
+	drvdata->desc.name = kstrdup(config->supply_name, GFP_KERNEL);
+	if (drvdata->desc.name == NULL) {
+		dev_err(&pdev->dev, "Failed to allocate supply name\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+	drvdata->desc.type = REGULATOR_VOLTAGE;
+	drvdata->desc.owner = THIS_MODULE;
+	drvdata->desc.ops = &switched_voltage_ops;
+	drvdata->desc.n_voltages = 2;
+
+	drvdata->gpio_enable = config->gpio_enable;
+	drvdata->startup_delay = config->startup_delay;
+	drvdata->inbetween_high = config->inbetween_high;
+
+	drvdata->microvolts_low = config->init_data->constraints.min_uV;
+	drvdata->microvolts_high = config->init_data->constraints.max_uV;
+
+	if (gpio_is_valid(config->gpio_enable)) {
+		drvdata->enable_high = config->enable_high;
+
+		ret = gpio_request(config->gpio_enable, config->supply_name);
+		if (ret) {
+			dev_err(&pdev->dev,
+			   "Could not obtain regulator enable GPIO %d: %d\n",
+							config->gpio_enable, ret);
+			goto err_name;
+		}
+
+		/* set output direction without changing state
+		 * to prevent glitch
+		 */
+		drvdata->is_enabled = config->enabled_at_boot;
+		ret = drvdata->is_enabled ?
+				config->enable_high : !config->enable_high;
+
+		ret = gpio_direction_output(config->gpio_enable, ret);
+		if (ret) {
+			dev_err(&pdev->dev,
+			   "Could not configure regulator enable GPIO %d direction: %d\n",
+							config->gpio_enable, ret);
+			goto err_gpio;
+		}
+
+	} else {
+		/* Regulator without GPIO control is considered
+		 * always enabled
+		 */
+		drvdata->is_enabled = true;
+	}
+
+	drvdata->switch_high = config->switch_high;
+
+	ret = gpio_request(config->gpio_switch, config->supply_name);
+	if (ret) {
+		dev_err(&pdev->dev,
+		   "Could not obtain regulator switch GPIO %d: %d\n",
+						config->gpio_switch, ret);
+		goto err_gpio;
+	}
+
+	/* set output direction without changing state to prevent glitch */
+	drvdata->is_switched = config->switched_at_boot;
+	ret = drvdata->is_switched ?
+			config->switch_high : !config->switch_high;
+
+	ret = gpio_direction_output(config->gpio_switch, ret);
+	if (ret) {
+		dev_err(&pdev->dev,
+		   "Could not configure regulator switch GPIO %d direction: %d\n",
+						config->gpio_switch, ret);
+		goto err_switch;
+	}
+
+	drvdata->dev = regulator_register(&drvdata->desc, &pdev->dev,
+					  config->init_data, drvdata);
+	if (IS_ERR(drvdata->dev)) {
+		ret = PTR_ERR(drvdata->dev);
+		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
+		goto err_switch;
+	}
+
+	platform_set_drvdata(pdev, drvdata);
+
+	dev_dbg(&pdev->dev, "%s supplying %d-%duV\n", drvdata->desc.name,
+		drvdata->microvolts_low, drvdata->microvolts_high);
+
+	return 0;
+
+err_switch:
+	gpio_free(config->gpio_switch);
+err_gpio:
+	if (gpio_is_valid(config->gpio_enable))
+		gpio_free(config->gpio_enable);
+err_name:
+	kfree(drvdata->desc.name);
+err:
+	kfree(drvdata);
+	return ret;
+}
+
+static int __devexit reg_switched_voltage_remove(struct platform_device *pdev)
+{
+	struct switched_voltage_data *drvdata = platform_get_drvdata(pdev);
+
+	regulator_unregister(drvdata->dev);
+
+	gpio_free(drvdata->gpio_switch);
+
+	if (gpio_is_valid(drvdata->gpio_enable))
+		gpio_free(drvdata->gpio_enable);
+
+	kfree(drvdata->desc.name);
+	kfree(drvdata);
+
+	return 0;
+}
+
+static struct platform_driver regulator_switched_voltage_driver = {
+	.probe		= reg_switched_voltage_probe,
+	.remove		= __devexit_p(reg_switched_voltage_remove),
+	.driver		= {
+		.name		= "reg-switched-voltage",
+		.owner		= THIS_MODULE,
+	},
+};
+
+static int __init regulator_switched_voltage_init(void)
+{
+	return platform_driver_register(&regulator_switched_voltage_driver);
+}
+subsys_initcall(regulator_switched_voltage_init);
+
+static void __exit regulator_switched_voltage_exit(void)
+{
+	platform_driver_unregister(&regulator_switched_voltage_driver);
+}
+module_exit(regulator_switched_voltage_exit);
+
+MODULE_AUTHOR("Heiko Stuebner <heiko@sntech.de>");
+MODULE_DESCRIPTION("switched voltage regulator");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:reg-switched-voltage");
diff --git a/include/linux/regulator/switch.h b/include/linux/regulator/switch.h
new file mode 100644
index 0000000..cd013e9
--- /dev/null
+++ b/include/linux/regulator/switch.h
@@ -0,0 +1,65 @@
+/*
+ * switch.h
+ *
+ * based on fixed.h
+ *
+ * Copyright 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * Copyright (c) 2009 Nokia Corporation
+ * Roger Quadros <ext-roger.quadros@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ */
+
+#ifndef __REGULATOR_SWITCHED_H
+#define __REGULATOR_SWITCHED_H
+
+struct regulator_init_data;
+
+/**
+ * struct switched_voltage_config - fixed_voltage_config structure
+ * @supply_name:	Name of the regulator supply
+ * @gpio_enable:	GPIO to use for enable control
+ * 			set to -EINVAL if not used
+ * @gpio_switch:	GPIO to use for switching voltages
+ * @startup_delay:	Start-up time in microseconds
+ * @enable_high:	Polarity of enable GPIO
+ *			1 = Active high, 0 = Active low
+ * @switch_high:	Polarity of witch GPIO
+ *			1 = max_voltage as high, 0 = max_voltage as low
+ * @enabled_at_boot:	Whether regulator has been enabled at
+ * 			boot or not. 1 = Yes, 0 = No
+ * 			This is used to keep the regulator at
+ * 			the default state
+ * @switched_at_boot:	Whether voltage is high at boot or not.
+ *			1 = Yes, 0 = No
+ * 			This is used to keep the regulator at
+ * 			the default state
+ * @inbetween_high:	How to handle voltage request that match neither
+ * 			min_uV nor max_uV. Set to -EINVAL to return error or
+ *			1 = set to max_uV, 0 = set to min_uV
+ * @init_data:		regulator_init_data
+ *
+ * This structure contains fixed voltage regulator configuration
+ * information that must be passed by platform code to the fixed
+ * voltage regulator driver.
+ */
+struct switched_voltage_config {
+	const char *supply_name;
+	int gpio_enable;
+	int gpio_switch;
+	unsigned startup_delay;
+	unsigned enable_high:1;
+	unsigned switch_high:1;
+	unsigned enabled_at_boot:1;
+	unsigned switched_at_boot:1;
+	int inbetween_high;
+	struct regulator_init_data *init_data;
+};
+
+#endif
-- 
tg: (c6a389f..) topic/drivers/reg-switch (depends on: master)
