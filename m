Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1LBUsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 15:48:23 -0500
Received: from border.exmeritus.com ([70.167.241.26]:52723 "EHLO
	border.exmeritus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab1LBUsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 15:48:19 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] New "gpio-poweroff" driver to turn off platform devices with GPIOs
Date: Fri,  2 Dec 2011 15:38:01 -0500
Message-Id: <1322858281-17831-4-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1322858281-17831-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1322858281-17831-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is especially useful on systems with an OF device-tree as
they can automatically instantiate the driver from GPIOs described in
the device-tree.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 .../devicetree/bindings/gpio/gpio-poweroff.txt     |   70 ++++
 drivers/gpio/Kconfig                               |   10 +
 drivers/gpio/Makefile                              |    3 +
 drivers/gpio/gpio-poweroff.c                       |  360 ++++++++++++++++++++
 include/linux/power/gpio-poweroff.h                |   43 +++
 5 files changed, 486 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-poweroff.txt
 create mode 100644 drivers/gpio/gpio-poweroff.c
 create mode 100644 include/linux/power/gpio-poweroff.h

diff --git a/Documentation/devicetree/bindings/gpio/gpio-poweroff.txt b/Documentation/devicetree/bindings/gpio/gpio-poweroff.txt
new file mode 100644
index 0000000..418662a
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-poweroff.txt
@@ -0,0 +1,70 @@
+Simple system and device poweroff via GPIO lines
+
+This performs powerdown of individual devices (or the entire system) using
+generic GPIO lines configured in the device tree.
+
+Each device can have the following properties:
+
+  * compatible (REQUIRED)
+      Must be "linux,gpio-poweroff".
+
+  * machine-power-control (OPTIONAL)
+      Does not have a value.  If present, the poweroff device is considered
+      to affect the entire system instead of just a single physical device.
+
+      NOTE1: If this property is absent, the device-node must be present at
+      the correct location in the device-tree so the platform_drv->shutdown
+      callback is executed at the appropriate time during system shutdown.
+
+      NOTE2: In order to trigger devices with this property present, the
+      platform support code must call gpio_machine_poweroff().
+
+  * final-delay-msecs (OPTIONAL)
+      After turning off the final power domain, wait the specified number of
+      milliseconds before continuing.  The default is 0, if not specified.
+
+
+Each device also has a list of power domains to be acted upon, represented as
+three separate properties.  A power domain is made up of the corresponding
+elements in each property array:
+
+  * power-domain-gpios (REQUIRED)
+      An array of GPIO specifiers of each power domain.  All elements must be
+      valid and available or the device will fail to probe.
+
+      The GPIO binding must support the OF_GPIO_ACTIVE_LOW flag in order to
+      specify the polarity of the GPIO.  If your GPIO controller uses the
+      standard Linux of_gpio_simple_xlate(), then you can simply specify a 1
+      in the second cell to indicate an active-low GPIO.
+
+  * power-domain-names (OPTIONAL)
+      An array of the humna-readable names of each power domain.  If missing
+      then generic numbers will be used for each domain.  Entries present
+      beyond the number of "power-domain-gpios" will be ignored.
+
+  * power-domain-delays-msec (OPTIONAL)
+      An array of 32-bit cells, each cell indicating how many milliseconds to
+      delay before activating the GPIO for the given power domain.  If left
+      unspecified then a default of 0 will be assumed. Entries present beyond
+      the number of "power-domain-gpios" will be ignored.
+
+Examples:
+
+gpios {
+	compatible = "simple-bus";
+
+	/* Whole-system power control */
+	power-control {
+		compatible = "linux,gpio-poweroff";
+
+		// Whole system, not a leaf device
+		machine-power-control;
+
+		// Power domains are turned off in this order
+		power-domain-names =	"TS", "S", "U";
+		power-domain-gpios =	<&pca9554a 3 0
+					 &pca9554a 2 0
+					 &pca9554a 1 0>;
+		power-domain-delays-msec = <500 500 500>;
+	};
+};
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 8482a23..b6e1141 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -489,4 +489,14 @@ config GPIO_TPS65910
 	help
 	  Select this option to enable GPIO driver for the TPS65910
 	  chip family.
+
+comment "Generic GPIO-based devices:"
+
+config GPIO_POWEROFF
+	tristate "Generic support for turning off platform devices with GPIOs"
+	help
+	  This enables a generic "gpio-poweroff" driver which may be used by
+	  custom platform-support code or included in OpenFirmware device
+	  trees to power off hardware using generic GPIO lines.
+
 endif
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index dbcb0bc..b52d54e 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -4,6 +4,9 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
 obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
+# Generic GPIO platform drivers.
+obj-$(CONFIG_GPIO_POWEROFF)	+= gpio-poweroff.o
+
 # Device drivers. Generally keep list sorted alphabetically
 obj-$(CONFIG_GPIO_GENERIC)	+= gpio-generic.o
 
diff --git a/drivers/gpio/gpio-poweroff.c b/drivers/gpio/gpio-poweroff.c
new file mode 100644
index 0000000..36ebb3b
--- /dev/null
+++ b/drivers/gpio/gpio-poweroff.c
@@ -0,0 +1,360 @@
+/*
+ * drivers/power/gpio-poweroff.c  -  Generic GPIO poweroff driver
+ *
+ * Maintainer: Kyle Moffett <Kyle.D.Moffett@boeing.com>
+ *
+ * Copyright 2010-2011 eXMeritus, A Boeing Company
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the  terms of  version 2  of the  GNU General Public  License, as
+ * published by the Free Software Foundation.
+ */
+#include <linux/power/gpio-poweroff.h>
+#include <linux/of_platform.h>
+#include <linux/of_gpio.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/types.h>
+#include <linux/gpio.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+
+struct gpio_poweroff {
+	const struct gpio_poweroff_platform_data *pdata;
+	struct platform_device *pdev;
+	struct list_head node;
+};
+
+static struct gpio_poweroff_platform_data *
+gpio_poweroff_get_pdata(struct platform_device *pdev)
+{
+	struct gpio_poweroff_platform_data *pdata;
+	enum of_gpio_flags *gpio_flags = NULL;
+	struct of_gpio *of_gpios = NULL;
+	struct gpio *gpios = NULL;
+	u32 *gpio_mdelays = NULL;
+	struct device_node *np;
+	unsigned long i, nr;
+	int err;
+
+	/* First check for static platform data */
+	if (pdev->dev.platform_data)
+		return pdev->dev.platform_data;
+
+	/* Then check for an OpenFirmware device node */
+	np = pdev->dev.of_node;
+	if (!np) {
+		dev_err(&pdev->dev, "No gpio-poweroff pdata or of_node!\n");
+		return NULL;
+	}
+
+	/* Ok, create platform data based on the device node */
+	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(&pdev->dev, "Can't allocate gpio-poweroff pdata!\n");
+		return NULL;
+	}
+	pdata->dynamic_platform_data = true;
+
+	/*
+	 * If a "machine-power-control" property is present at all, then this
+	 * device will be regarded as a machine-poweroff handler and will not
+	 * be called until the very end when gpio_machine_poweroff() is
+	 * called by the architecture code.
+	 */
+	if (of_get_property(np, "machine-power-control", NULL))
+		pdata->is_machine_poweroff = true;
+	else
+		pdata->is_machine_poweroff = false;
+
+	/*
+	 * If a "final-delay-msecs" property is present, the poweroff
+	 * sequence will continue with the next device after the specified
+	 * delay (which may be zero).
+	 *
+	 * Otherwise it will hang here indefinitely.
+	 */
+	pdata->final_mdelay = 0;
+	of_property_read_u32(np, "final-delay-msecs", &pdata->final_mdelay);
+
+	/* Count the GPIOs */
+	pdata->nr_gpios = nr = of_gpio_count_named(np, "power-domain-gpios");
+	if (!pdata->nr_gpios) {
+		dev_warn(&pdev->dev, "No GPIOs to use during poweroff!\n");
+		return pdata;
+	}
+
+	/* Allocate enough memory for the tables */
+#define KCALLOC_ARRAY(ARRAY, NR, FLAGS) \
+	ARRAY = kcalloc(NR, sizeof((ARRAY)[0]), FLAGS)
+	KCALLOC_ARRAY(of_gpios,     nr, GFP_KERNEL);
+	KCALLOC_ARRAY(gpios,        nr, GFP_KERNEL);
+	KCALLOC_ARRAY(gpio_mdelays, nr, GFP_KERNEL);
+	KCALLOC_ARRAY(gpio_flags,   nr, GFP_KERNEL);
+#undef KCALLOC_ARRAY
+	if (!of_gpios || !gpios || !gpio_mdelays || !gpio_flags) {
+		dev_err(&pdev->dev, "Can't allocate tables for %lu GPIOs\n", nr);
+		goto err_kfree;
+	}
+
+	/* Parse the GPIO information from the device-tree */
+	for (i = 0; i < nr; i++) {
+		const char *label;
+
+		/* Initialize values */
+		of_gpios[i].propname = "power-domain-gpios";
+		of_gpios[i].index = i;
+		of_gpios[i].gpio_flags = GPIOF_DIR_OUT;
+
+		/* Try to read a label from the device-tree */
+		if (!of_property_read_string_index(np, "power-domain-names",
+					i, &label))
+			of_gpios[i].gpio_label = kstrdup(label, GFP_KERNEL);
+		else
+			of_gpios[i].gpio_label = NULL;
+	}
+	err = of_get_gpio_array_flags(np, of_gpios, gpio_flags, gpios, nr);
+	if (err) {
+		dev_err(&pdev->dev, "Unable to parse all %lu GPIOs: %d\n", nr, err);
+		goto err_kfree_labels;
+	}
+
+	/* Set initial output values appropriately */
+	for (i = 0; i < nr; i++) {
+		if (gpio_flags[i] & OF_GPIO_ACTIVE_LOW)
+			gpios[i].flags |= GPIOF_INIT_HIGH;
+		else
+			gpios[i].flags |= GPIOF_INIT_LOW;
+	}
+
+	/* Parse the GPIO delays from the device-tree */
+	err = of_property_read_u32_array(np, "power-domain-delays-msec",
+			gpio_mdelays, nr);
+	if (err) {
+		dev_err(&pdev->dev, "Unable to parse all %lu GPIO delays: %d\n", nr, err);
+		goto err_kfree_labels;
+	}
+
+	/* Free the temporary data and save the other arrays */
+	kfree(of_gpios);
+	pdata->gpios = gpios;
+	pdata->gpio_mdelays = gpio_mdelays;
+	pdata->gpio_flags = gpio_flags;
+	return pdata;
+
+err_kfree_labels:
+	for (i = 0; i < nr; i++)
+		kfree(of_gpios[i].gpio_label);
+err_kfree:
+	kfree(of_gpios);
+	kfree(gpios);
+	kfree(gpio_mdelays);
+	kfree(gpio_flags);
+	kfree(pdata);
+	return NULL;
+}
+
+static void gpio_poweroff_release_pdata(struct platform_device *pdev,
+		const struct gpio_poweroff_platform_data *pdata)
+{
+	unsigned long i, nr = pdata->nr_gpios;
+
+	/* Don't free anything unless we own the platform data */
+	if (!pdata || !pdata->dynamic_platform_data)
+		return;
+
+	/* Free any dynamically-allocated power domain labels */
+	for (i = 0; i < nr; i++)
+		kfree(pdata->gpios[i].label);
+
+	/* Free all the tables and then the platform data itself */
+	kfree(pdata->gpios);
+	kfree(pdata->gpio_mdelays);
+	kfree(pdata->gpio_flags);
+	kfree(pdata);
+}
+
+/* This list is used for "machine-poweroff" devices */
+static LIST_HEAD(gpio_machine_poweroff_list);
+static DEFINE_MUTEX(gpio_machine_poweroff_mutex);
+
+static int __devinit gpio_poweroff_probe(struct platform_device *pdev)
+{
+	const struct gpio_poweroff_platform_data *pdata;
+	struct gpio_poweroff *poweroff;
+	int ret;
+
+	/* Get the platform data from wherever is handy */
+	pdata = gpio_poweroff_get_pdata(pdev);
+	if (!pdata)
+		return -ENODEV;
+
+	/* Allocate a driver datastructure */
+	poweroff = kzalloc(sizeof(*poweroff), GFP_KERNEL);
+	if (!poweroff) {
+		dev_err(&pdev->dev, "Can't allocate gpio-poweroff data!\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * Request all of the GPIOs.
+	 *
+	 * NOTE: The platform_data must set these to outputs, with the
+	 * correct levels so that the board doesn't power off here.
+	 */
+	ret = gpio_request_array(pdata->gpios, pdata->nr_gpios);
+	if (ret) {
+		dev_err(&pdev->dev, "Error requesting poweroff GPIOs!\n");
+		goto err;
+	}
+
+	/* Save the data */
+	poweroff->pdata = pdata;
+	poweroff->pdev = pdev;
+
+	/* If this is a machine-poweroff device, add it to the list */
+	if (pdata->is_machine_poweroff) {
+		mutex_lock(&gpio_machine_poweroff_mutex);
+		list_add_tail(&poweroff->node, &gpio_machine_poweroff_list);
+		mutex_unlock(&gpio_machine_poweroff_mutex);
+	} else {
+		INIT_LIST_HEAD(&poweroff->node);
+	}
+
+	/* Attach the data to the device */
+	dev_set_drvdata(&pdev->dev, poweroff);
+	dev_info(&pdev->dev, "Successfully initialized gpio-poweroff!\n");
+	return 0;
+
+err:
+	dev_err(&pdev->dev, "Could not initialize gpio-poweroff: %d\n", ret);
+	gpio_poweroff_release_pdata(pdev, pdata);
+	kfree(poweroff);
+	return ret;
+}
+
+static int __devexit gpio_poweroff_remove(struct platform_device *pdev)
+{
+	struct gpio_poweroff *poweroff = dev_get_drvdata(&pdev->dev);
+
+	/* Detach the data from the device */
+	dev_info(&pdev->dev, "Removing gpio-poweroff device\n");
+	dev_set_drvdata(&pdev->dev, NULL);
+
+	/* Remove the poweroff device from the list */
+	mutex_lock(&gpio_machine_poweroff_mutex);
+	list_del(&poweroff->node);
+	mutex_unlock(&gpio_machine_poweroff_mutex);
+
+	/* Release the GPIOs and free the driver data */
+	gpio_free_array(poweroff->pdata->gpios, poweroff->pdata->nr_gpios);
+	gpio_poweroff_release_pdata(pdev, poweroff->pdata);
+	kfree(poweroff);
+	return 0;
+}
+
+/* Turn off power using a given "struct gpio_poweroff" */
+static void do_gpio_poweroff(struct gpio_poweroff *poweroff, bool machine)
+{
+	const struct gpio_poweroff_platform_data *pdata = poweroff->pdata;
+	struct device *dev = &poweroff->pdev->dev;
+	unsigned long i;
+
+	/*
+	 * If this device is a "machine-poweroff" device, only execute
+	 * the powerdown at the very end of the shutdown sequence.
+	 */
+	if (pdata->is_machine_poweroff && !machine)
+		return;
+
+	/* Enable each GPIO in order */
+	dev_info(dev, "Performing GPIO-based poweroff...\n");
+	for (i = 0; i < pdata->nr_gpios; i++) {
+		/* Get the label and number of the GPIO */
+		const char *label = pdata->gpios[i].label;
+		int gpio = pdata->gpios[i].gpio;
+
+		enum of_gpio_flags of_flags = 0;
+		unsigned long msec = 0;
+		bool active;
+
+		/* Get the flags and delay (if present) */
+		if (pdata->gpio_flags)
+			of_flags = pdata->gpio_flags[i];
+		if (pdata->gpio_mdelays)
+			msec = pdata->gpio_mdelays[i];
+
+		active = !(of_flags & OF_GPIO_ACTIVE_LOW);
+		if (label)
+			dev_info(dev, "Turning off power domain \"%s\" "
+					"using an active-%s GPIO after %lums",
+					label, (active?"high":"low"), msec);
+		else
+			dev_info(dev, "Turning off power domain %d "
+					"using an active-%s GPIO after %lums",
+					gpio, (active?"high":"low"), msec);
+
+		/* Program the GPIO after the delay */
+		mdelay(msec);
+		gpio_set_value_cansleep(gpio, active);
+	}
+
+	/* Perform the final delay */
+	mdelay(pdata->final_mdelay);
+}
+
+/* Per-device shutdown */
+static void gpio_poweroff_shutdown(struct platform_device *pdev)
+{
+	do_gpio_poweroff(dev_get_drvdata(&pdev->dev), false);
+}
+
+/* Whole-machine shutdown */
+void gpio_machine_poweroff(void)
+{
+	struct gpio_poweroff *poweroff;
+
+	pr_warning("Performing machine poweroff using GPIOs\n");
+
+	/* Iterate over each poweroff device in order */
+	mutex_lock(&gpio_machine_poweroff_mutex);
+	list_for_each_entry(poweroff, &gpio_machine_poweroff_list, node)
+		do_gpio_poweroff(poweroff, true);
+	mutex_unlock(&gpio_machine_poweroff_mutex);
+
+	pr_crit("Still online! System power off using GPIOs failed?\n");
+}
+
+static const struct of_device_id of_match_table[] = {
+	{ .compatible = "linux,gpio-poweroff" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, of_match_table);
+
+static struct platform_driver gpio_poweroff_driver = {
+	.driver = {
+		.name = "gpio-poweroff",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_table,
+	},
+	.probe		= gpio_poweroff_probe,
+	.shutdown	= gpio_poweroff_shutdown,
+	.remove		= __devexit_p(gpio_poweroff_remove),
+};
+
+static int __init gpio_poweroff_init(void)
+{
+	return platform_driver_register(&gpio_poweroff_driver);
+}
+module_init(gpio_poweroff_init);
+
+static void __exit gpio_poweroff_exit(void)
+{
+	platform_driver_unregister(&gpio_poweroff_driver);
+}
+module_exit(gpio_poweroff_exit);
+
+MODULE_AUTHOR("Kyle Moffett");
+MODULE_DESCRIPTION("Simple GPIO Power-Off Driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/power/gpio-poweroff.h b/include/linux/power/gpio-poweroff.h
new file mode 100644
index 0000000..70787f1
--- /dev/null
+++ b/include/linux/power/gpio-poweroff.h
@@ -0,0 +1,43 @@
+/*
+ * gpio-poweroff.h  -  Generic GPIO-based poweroff driver
+ *
+ * Maintainer: Kyle Moffett <Kyle.D.Moffett@boeing.com>
+ *
+ * Copyright (C) 2010-2011 eXMeritus, A Boeing Company
+ *
+ */
+
+#ifndef LINUX_POWER_GPIO_POWEROFF_H_
+#define LINUX_POWER_GPIO_POWEROFF_H_
+
+#include <linux/of_gpio.h>
+#include <linux/types.h>
+#include <linux/gpio.h>
+
+struct gpio_poweroff_platform_data {
+	/* The number of poweroff GPIOs to use */
+	size_t nr_gpios;
+
+	/* An array of pre-requested GPIOs, and active-low/high status */
+	const struct gpio *gpios;
+	const enum of_gpio_flags *gpio_flags;
+
+	/* The delay to use before each GPIO is triggered */
+	const u32 *gpio_mdelays;
+
+	/* The final delay after all GPIOs have been set */
+	u32 final_mdelay;
+
+	/*
+	 * If set, this is excluded from normal platform_device processing
+	 * and only called when gpio_machine_poweroff() is run.
+	 */
+	bool is_machine_poweroff;
+
+	/* The platform_data and arrays should be kfree()d during removal */
+	bool dynamic_platform_data;
+};
+
+void gpio_machine_poweroff(void);
+
+#endif /* not LINUX_POWER_GPIO_POWEROFF_H_ */
-- 
1.7.2.5

