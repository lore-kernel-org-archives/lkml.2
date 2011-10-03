Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab1JCTxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 15:53:34 -0400
Received: from s15407518.onlinehome-server.info ([82.165.136.167]:59005 "EHLO
	s15407518.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756471Ab1JCTxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 15:53:30 -0400
X-Greylist: delayed 2488 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Oct 2011 15:53:29 EDT
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Add driver for gpio-controlled regulators
Date: Mon, 3 Oct 2011 21:11:57 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-2-686; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org,
        Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110032111.57958.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for regulators that can be controlled via gpios.

Examples for such regulators are the TI-tps65024x voltage regulators
with 4 fixed and 1 runtime-switchable voltage regulators
or the TI-bq240XX charger regulators.

The number of controlling gpios is not limited, the mapping between
voltage/current and target gpio state is done via the states map
and the driver can be used for either voltage or current regulators.

A mapping for a regulator with two GPIOs could look like:

gpios = {
	GPIO1,
	GPIO2,
}

states = {
	{ .value = volt_or_cur1, .gpios = (0 << 1) | (0 << 0) },
	{ .value = volt_or_cur2, .gpios = (0 << 1) | (1 << 0) },
	{ .value = volt_or_cur3, .gpios = (1 << 1) | (0 << 0) },
	{ .value = volt_or_cur4, .gpios = (1 << 1) | (1 << 0) },
}

The target-state for the n-th gpio is determined by the n-th bit
in the bitfield of the target-value.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>

---
 drivers/regulator/Kconfig                |    9 +
 drivers/regulator/Makefile               |    1 +
 drivers/regulator/gpio-regulator.c       |  364 ++++++++++++++++++++++++++++++
 include/linux/regulator/gpio-regulator.h |   90 ++++++++
 4 files changed, 464 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index c7fd2c0..5e0c7b6 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -64,6 +64,15 @@ config REGULATOR_USERSPACE_CONSUMER
 
           If unsure, say no.
 
+config REGULATOR_GPIO
+	tristate "GPIO regulator support"
+	help
+	  This driver provides support for regulators that can be
+	  controlled via gpios.
+	  It is capable of supporting current and voltage regulators
+	  and the platform has to provide a mapping of GPIO-states
+	  to target volts/amps.
+
 config REGULATOR_BQ24022
 	tristate "TI bq24022 Dual Input 1-Cell Li-Ion Charger IC"
 	help
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 040d5aa..93a6318 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 
+obj-$(CONFIG_REGULATOR_GPIO) += gpio-regulator.o
 obj-$(CONFIG_REGULATOR_AD5398) += ad5398.o
 obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
 obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
new file mode 100644
index 0000000..c3bccee
--- /dev/null
+++ b/drivers/regulator/gpio-regulator.c
@@ -0,0 +1,364 @@
+/*
+ * gpio-regulator.c
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
+#include <linux/regulator/gpio-regulator.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+
+struct gpio_regulator_data {
+	struct regulator_desc desc;
+	struct regulator_dev *dev;
+
+	int enable_gpio;
+	bool enable_high;
+	bool is_enabled;
+	unsigned startup_delay;
+
+	int *gpios;
+	int nr_gpios;
+
+	struct gpio_regulator_state *states;
+	int nr_states;
+
+	int state;
+};
+
+static int gpio_regulator_is_enabled(struct regulator_dev *dev)
+{
+	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
+
+	return data->is_enabled;
+}
+
+static int gpio_regulator_enable(struct regulator_dev *dev)
+{
+	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
+
+	if (gpio_is_valid(data->enable_gpio)) {
+		gpio_set_value_cansleep(data->enable_gpio, data->enable_high);
+		data->is_enabled = true;
+	}
+
+	return 0;
+}
+
+static int gpio_regulator_disable(struct regulator_dev *dev)
+{
+	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
+
+	if (gpio_is_valid(data->enable_gpio)) {
+		gpio_set_value_cansleep(data->enable_gpio, !data->enable_high);
+		data->is_enabled = false;
+	}
+
+	return 0;
+}
+
+static int gpio_regulator_enable_time(struct regulator_dev *dev)
+{
+	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
+
+	return data->startup_delay;
+}
+
+static int gpio_regulator_get_value(struct regulator_dev *dev)
+{
+	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
+	int ptr;
+
+	for (ptr = 0; ptr < data->nr_states; ptr++)
+		if (data->states[ptr].gpios == data->state)
+			return data->states[ptr].value;
+
+	return -EINVAL;
+}
+
+static int gpio_regulator_set_value(struct regulator_dev *dev,
+					int min, int max)
+{
+	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
+	int ptr, target, state;
+
+	target = -1;
+	for (ptr = 0; ptr < data->nr_states; ptr++)
+		if (data->states[ptr].value >= min &&
+		    data->states[ptr].value <= max)
+			target = data->states[ptr].gpios;
+
+	if (target < 0)
+		return -EINVAL;
+
+	for (ptr = 0; ptr < data->nr_gpios; ptr++) {
+		state = (target & (1 << ptr)) >> ptr;
+		gpio_set_value(data->gpios[ptr], state);
+	}
+	data->state = target;
+
+	return 0;
+}
+
+static int gpio_regulator_set_voltage(struct regulator_dev *dev,
+					int min_uV, int max_uV,
+					unsigned *selector)
+{
+	return gpio_regulator_set_value(dev, min_uV, max_uV);
+}
+
+static int gpio_regulator_list_voltage(struct regulator_dev *dev,
+				      unsigned selector)
+{
+	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
+
+	if (selector >= data->nr_states)
+		return -EINVAL;
+
+	return data->states[selector].value;
+}
+
+static int gpio_regulator_set_current_limit(struct regulator_dev *dev,
+					int min_uA, int max_uA)
+{
+	return gpio_regulator_set_value(dev, min_uA, max_uA);
+}
+
+static struct regulator_ops gpio_regulator_voltage_ops = {
+	.is_enabled = gpio_regulator_is_enabled,
+	.enable = gpio_regulator_enable,
+	.disable = gpio_regulator_disable,
+	.enable_time = gpio_regulator_enable_time,
+	.get_voltage = gpio_regulator_get_value,
+	.set_voltage = gpio_regulator_set_voltage,
+	.list_voltage = gpio_regulator_list_voltage,
+};
+
+static struct regulator_ops gpio_regulator_current_ops = {
+	.is_enabled = gpio_regulator_is_enabled,
+	.enable = gpio_regulator_enable,
+	.disable = gpio_regulator_disable,
+	.enable_time = gpio_regulator_enable_time,
+	.get_current_limit = gpio_regulator_get_value,
+	.set_current_limit = gpio_regulator_set_current_limit,
+};
+
+static int __devinit gpio_regulator_probe(struct platform_device *pdev)
+{
+	struct gpio_regulator_config *config = pdev->dev.platform_data;
+	struct gpio_regulator_data *drvdata;
+	int ptr, ret, state;
+
+	drvdata = kzalloc(sizeof(struct gpio_regulator_data), GFP_KERNEL);
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
+
+	drvdata->gpios = kmalloc(config->nr_gpios * sizeof(int), GFP_KERNEL);
+	if (drvdata->gpios == NULL) {
+		dev_err(&pdev->dev, "Failed to allocate gpio data\n");
+		ret = -ENOMEM;
+		goto err_name;
+	}
+	/* init gpios negative; ability to deinitialize only the set ones */
+	for (ptr = 0; ptr < config->nr_gpios; ptr++)
+		drvdata->gpios[ptr] = -EINVAL;
+
+	drvdata->states = kmemdup(config->states,
+				       config->nr_states *
+					 sizeof(struct gpio_regulator_state),
+				       GFP_KERNEL);
+	if (drvdata == NULL) {
+		dev_err(&pdev->dev, "Failed to allocate state data\n");
+		ret = -ENOMEM;
+		goto err_memgpio;
+	}
+	drvdata->nr_states = config->nr_states;
+
+	drvdata->desc.owner = THIS_MODULE;
+
+	/* if we are a voltage regulator */
+	switch (config->type) {
+	case REGULATOR_VOLTAGE:
+		drvdata->desc.type = REGULATOR_VOLTAGE;
+		drvdata->desc.ops = &gpio_regulator_voltage_ops;
+		drvdata->desc.n_voltages = config->nr_states;
+		break;
+	case REGULATOR_CURRENT:
+		drvdata->desc.type = REGULATOR_CURRENT;
+		drvdata->desc.ops = &gpio_regulator_current_ops;
+		break;
+	default:
+		dev_err(&pdev->dev, "No regulator type set\n");
+		ret = -EINVAL;
+		goto err_memgpio;
+		break;
+	}
+
+	drvdata->enable_gpio = config->enable_gpio;
+	drvdata->startup_delay = config->startup_delay;
+
+	if (gpio_is_valid(config->enable_gpio)) {
+		drvdata->enable_high = config->enable_high;
+
+		ret = gpio_request(config->enable_gpio, config->supply_name);
+		if (ret) {
+			dev_err(&pdev->dev,
+			   "Could not obtain regulator enable GPIO %d: %d\n",
+						config->enable_gpio, ret);
+			goto err_memstate;
+		}
+
+		/* set output direction without changing state
+		 * to prevent glitch
+		 */
+		drvdata->is_enabled = config->enabled_at_boot;
+		ret = drvdata->is_enabled ?
+				config->enable_high : !config->enable_high;
+
+		ret = gpio_direction_output(config->enable_gpio, ret);
+		if (ret) {
+			dev_err(&pdev->dev,
+			   "Could not configure regulator enable GPIO %d direction: %d\n",
+						config->enable_gpio, ret);
+			goto err_enablegpio;
+		}
+	} else {
+		/* Regulator without GPIO control is considered
+		 * always enabled
+		 */
+		drvdata->is_enabled = true;
+	}
+
+	drvdata->nr_gpios = config->nr_gpios;
+	for (ptr = 0; ptr < drvdata->nr_gpios; ptr++) {
+		ret = gpio_request(config->gpios[ptr], config->supply_name);
+		if (ret) {
+			dev_err(&pdev->dev,
+			   "Could not obtain regulator setting GPIO %d: %d\n",
+						config->gpios[ptr], ret);
+			goto err_stategpio;
+		}
+
+		drvdata->gpios[ptr] = config->gpios[ptr];
+
+		state = (config->state_at_boot & (1 << ptr)) >> ptr;
+		ret = gpio_direction_output(drvdata->gpios[ptr], state);
+		if (ret) {
+			dev_err(&pdev->dev,
+			   "Could not configure regulator enable GPIO %d direction: %d\n",
+						drvdata->gpios[ptr], ret);
+			goto err_stategpio;
+		}
+	}
+	drvdata->state = config->state_at_boot;
+
+	drvdata->dev = regulator_register(&drvdata->desc, &pdev->dev,
+					  config->init_data, drvdata);
+	if (IS_ERR(drvdata->dev)) {
+		ret = PTR_ERR(drvdata->dev);
+		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
+		goto err_stategpio;
+	}
+
+	platform_set_drvdata(pdev, drvdata);
+
+	return 0;
+
+err_stategpio:
+	for (ptr = 0; ptr < config->nr_gpios; ptr++)
+		if (gpio_is_valid(drvdata->gpios[ptr]))
+			gpio_free(drvdata->gpios[ptr]);
+err_enablegpio:
+	if (gpio_is_valid(config->enable_gpio))
+		gpio_free(config->enable_gpio);
+err_memstate:
+	kfree(drvdata->states);
+err_memgpio:
+	kfree(drvdata->gpios);
+err_name:
+	kfree(drvdata->desc.name);
+err:
+	kfree(drvdata);
+	return ret;
+}
+
+static int __devexit gpio_regulator_remove(struct platform_device *pdev)
+{
+	struct gpio_regulator_data *drvdata = platform_get_drvdata(pdev);
+	int ptr;
+
+	regulator_unregister(drvdata->dev);
+
+	for (ptr = 0; ptr < drvdata->nr_gpios; ptr++)
+		gpio_free(drvdata->gpios[ptr]);
+
+	kfree(drvdata->states);
+	kfree(drvdata->gpios);
+
+	if (gpio_is_valid(drvdata->enable_gpio))
+		gpio_free(drvdata->enable_gpio);
+
+	kfree(drvdata->desc.name);
+	kfree(drvdata);
+
+	return 0;
+}
+
+static struct platform_driver gpio_regulator_driver = {
+	.probe		= gpio_regulator_probe,
+	.remove		= __devexit_p(gpio_regulator_remove),
+	.driver		= {
+		.name		= "gpio-regulator",
+		.owner		= THIS_MODULE,
+	},
+};
+
+static int __init gpio_regulator_init(void)
+{
+	return platform_driver_register(&gpio_regulator_driver);
+}
+subsys_initcall(gpio_regulator_init);
+
+static void __exit gpio_regulator_exit(void)
+{
+	platform_driver_unregister(&gpio_regulator_driver);
+}
+module_exit(gpio_regulator_exit);
+
+MODULE_AUTHOR("Heiko Stuebner <heiko@sntech.de>");
+MODULE_DESCRIPTION("gpio voltage regulator");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:gpio-regulator");
diff --git a/include/linux/regulator/gpio-regulator.h b/include/linux/regulator/gpio-regulator.h
new file mode 100644
index 0000000..0beb237
--- /dev/null
+++ b/include/linux/regulator/gpio-regulator.h
@@ -0,0 +1,90 @@
+/*
+ * gpio-regulator.h
+ *
+ * Copyright 2011 Heiko Stuebner <heiko@sntech.de>
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
+#ifndef __REGULATOR_GPIO_H
+#define __REGULATOR_GPIO_H
+
+struct regulator_init_data;
+
+enum regulator_type;
+
+/**
+ * struct gpio_regulator_state - state description
+ * @value:		microvolts or microamps
+ * @gpios:		bitfield of gpio target-states for the value
+ *
+ * This structure describes a supported setting of the regulator
+ * and the necessary gpio-state to achieve it.
+ *
+ * The n-th bit in the bitfield describes the state of the n-th GPIO
+ * from the gpios-array defined in gpio_regulator_config below.
+ */
+struct gpio_regulator_state {
+	int value;
+	int gpios;
+};
+
+/**
+ * struct gpio_regulator_config - config structure
+ * @supply_name:	Name of the regulator supply
+ * @enable_gpio:	GPIO to use for enable control
+ *			set to -EINVAL if not used
+ * @enable_high:	Polarity of enable GPIO
+ *			1 = Active high, 0 = Active low
+ * @enabled_at_boot:	Whether regulator has been enabled at
+ *			boot or not. 1 = Yes, 0 = No
+ *			This is used to keep the regulator at
+ *			the default state
+ * @startup_delay:	Start-up time in microseconds
+ * @gpios:		Array containing the gpios needed to control
+ *			the setting of the regulator
+ * @nr_gpios:		Number of gpios
+ * @states:		Array of gpio_regulator_state entries describing
+ *			the gpio state for specific voltages
+ * @nr_states:		Number of states available
+ * @state_at_boot:	State set at boot, default state for the gpios
+ * @regulator_type:	either REGULATOR_CURRENT or REGULATOR_VOLTAGE
+ * @init_data:		regulator_init_data
+ *
+ * This structure contains gpio-voltage regulator configuration
+ * information that must be passed by platform code to the
+ * gpio-voltage regulator driver.
+ */
+struct gpio_regulator_config {
+	const char *supply_name;
+
+	int enable_gpio;
+	unsigned enable_high:1;
+	unsigned enabled_at_boot:1;
+	unsigned startup_delay;
+
+	int *gpios;
+	int nr_gpios;
+
+	struct gpio_regulator_state *states;
+	int nr_states;
+
+	int state_at_boot;
+
+	enum regulator_type type;
+	struct regulator_init_data *init_data;
+};
+
+#endif
-- 
tg: (c6a389f..) topic/drivers/reg-switch (depends on: master)
