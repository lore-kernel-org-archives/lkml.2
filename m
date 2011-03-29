Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1C2BKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 21:10:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63053 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab1C2BKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 21:10:20 -0400
Date: Tue, 29 Mar 2011 10:10:16 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] power_supply: Add driver for MAX8903 charger
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@gmail.com>
Message-id: <1301361016-24392-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 29 Mar 2011 01:10:16.0612 (UTC)
 FILETIME=[1070EE40:01CBEDAE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX8903 is an integrated battery charger and selector with two
power inputs (USB and AC adapter). This driver enables the charger,
handles interrupts, and provides power-supply-class information to
userland.

Tested on Exynos4 NURI / S5PC210 SLP7 boards.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/Kconfig                 |    8 +
 drivers/power/Makefile                |    1 +
 drivers/power/max8903_charger.c       |  391 +++++++++++++++++++++++++++++++++
 include/linux/power/max8903_charger.h |   57 +++++
 4 files changed, 457 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/max8903_charger.c
 create mode 100644 include/linux/power/max8903_charger.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 61bf5d7..d234e40 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -189,6 +189,14 @@ config CHARGER_ISP1704
 	  Say Y to enable support for USB Charger Detection with
 	  ISP1707/ISP1704 USB transceivers.
 
+config CHARGER_MAX8903
+	tristate "MAX8903 Battery DC-DC Charger for USB and Adapter Power"
+	help
+	  Say Y to enable support for the MAX8903 DC-DC charger and sysfs.
+	  The driver supports controlling charger-enable and current-limit
+	  pins based on the status of charger connections with interrupt
+	  handlers.
+
 config CHARGER_TWL4030
 	tristate "OMAP TWL4030 BCI charger driver"
 	depends on TWL4030_CORE
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 8385bfa..8fcd93f 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -32,5 +32,6 @@ obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
 obj-$(CONFIG_BATTERY_JZ4740)	+= jz4740-battery.o
 obj-$(CONFIG_BATTERY_INTEL_MID)	+= intel_mid_battery.o
 obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
+obj-$(CONFIG_CHARGER_MAX8903)	+= max8903_charger.o
 obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
 obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
diff --git a/drivers/power/max8903_charger.c b/drivers/power/max8903_charger.c
new file mode 100644
index 0000000..33ff0e3
--- /dev/null
+++ b/drivers/power/max8903_charger.c
@@ -0,0 +1,391 @@
+/*
+ * max8903_charger.c - Maxim 8903 USB/Adapter Charger Driver
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ * MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/power_supply.h>
+#include <linux/platform_device.h>
+#include <linux/power/max8903_charger.h>
+
+struct max8903_data {
+	struct max8903_pdata *pdata;
+	struct device *dev;
+	struct power_supply psy;
+	bool fault;
+	bool usb_in;
+	bool ta_in;
+};
+
+static enum power_supply_property max8903_charger_props[] = {
+	POWER_SUPPLY_PROP_STATUS, /* Charger status output */
+	POWER_SUPPLY_PROP_ONLINE, /* External power source */
+	POWER_SUPPLY_PROP_HEALTH, /* Fault or OK */
+};
+
+static int max8903_get_property(struct power_supply *psy,
+		enum power_supply_property psp,
+		union power_supply_propval *val)
+{
+	struct max8903_data *data = container_of(psy,
+			struct max8903_data, psy);
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
+		if (data->pdata->chg) {
+			if (gpio_get_value(data->pdata->chg) == 0)
+				val->intval = POWER_SUPPLY_STATUS_CHARGING;
+			else if (data->usb_in || data->ta_in)
+				val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
+			else
+				val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+		}
+		break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = 0;
+		if (data->usb_in || data->ta_in)
+			val->intval = 1;
+		break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		val->intval = POWER_SUPPLY_HEALTH_GOOD;
+		if (data->fault)
+			val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static irqreturn_t max8903_dcin(int irq, void *_data)
+{
+	struct max8903_data *data = _data;
+	struct max8903_pdata *pdata = data->pdata;
+	bool ta_in;
+	enum power_supply_type old_type;
+
+	ta_in = gpio_get_value(pdata->dok) ? false : true;
+
+	if (ta_in == data->ta_in)
+		return IRQ_HANDLED;
+
+	data->ta_in = ta_in;
+
+	/* Set Current-Limit-Mode 1:DC 0:USB */
+	if (pdata->dcm)
+		gpio_set_value(pdata->dcm, ta_in ? 1 : 0);
+
+	/* Charger Enable / Disable (cen is negated) */
+	if (pdata->cen)
+		gpio_set_value(pdata->cen, ta_in ? 0 :
+				(data->usb_in ? 0 : 1));
+
+	dev_dbg(data->dev, "TA(DC-IN) Charger %s.\n", ta_in ?
+			"Connected" : "Disconnected");
+
+	old_type = data->psy.type;
+
+	if (data->ta_in)
+		data->psy.type = POWER_SUPPLY_TYPE_MAINS;
+	else if (data->usb_in)
+		data->psy.type = POWER_SUPPLY_TYPE_USB;
+	else
+		data->psy.type = POWER_SUPPLY_TYPE_BATTERY;
+
+	if (old_type != data->psy.type)
+		power_supply_changed(&data->psy);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t max8903_usbin(int irq, void *_data)
+{
+	struct max8903_data *data = _data;
+	struct max8903_pdata *pdata = data->pdata;
+	bool usb_in;
+	enum power_supply_type old_type;
+
+	usb_in = gpio_get_value(pdata->uok) ? false : true;
+
+	if (usb_in == data->usb_in)
+		return IRQ_HANDLED;
+
+	data->usb_in = usb_in;
+
+	/* Do not touch Current-Limit-Mode */
+
+	/* Charger Enable / Disable (cen is negated) */
+	if (pdata->cen)
+		gpio_set_value(pdata->cen, usb_in ? 0 :
+				(data->ta_in ? 0 : 1));
+
+	dev_dbg(data->dev, "USB Charger %s.\n", usb_in ?
+			"Connected" : "Disconnected");
+
+	old_type = data->psy.type;
+
+	if (data->ta_in)
+		data->psy.type = POWER_SUPPLY_TYPE_MAINS;
+	else if (data->usb_in)
+		data->psy.type = POWER_SUPPLY_TYPE_USB;
+	else
+		data->psy.type = POWER_SUPPLY_TYPE_BATTERY;
+
+	if (old_type != data->psy.type)
+		power_supply_changed(&data->psy);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t max8903_fault(int irq, void *_data)
+{
+	struct max8903_data *data = _data;
+	struct max8903_pdata *pdata = data->pdata;
+	bool fault;
+
+	fault = gpio_get_value(pdata->flt) ? false : true;
+
+	if (fault == data->fault)
+		return IRQ_HANDLED;
+
+	data->fault = fault;
+
+	if (fault)
+		dev_err(data->dev, "Charger suffers a fault and stops.\n");
+	else
+		dev_err(data->dev, "Charger recovered from a fault.\n");
+
+	return IRQ_HANDLED;
+}
+
+static __devinit int max8903_probe(struct platform_device *pdev)
+{
+	struct max8903_data *data;
+	struct device *dev = &pdev->dev;
+	struct max8903_pdata *pdata = pdev->dev.platform_data;
+	int ret = 0;
+	int gpio;
+	int ta_in = 0;
+	int usb_in = 0;
+
+	data = kzalloc(sizeof(struct max8903_data), GFP_KERNEL);
+	if (data == NULL) {
+		dev_err(dev, "Cannot allocate memory.\n");
+		return -ENOMEM;
+	}
+	data->pdata = pdata;
+	data->dev = dev;
+	platform_set_drvdata(pdev, data);
+
+	if (pdata->dc_valid == false && pdata->usb_valid == false) {
+		dev_err(dev, "No valid power sources.\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (pdata->dc_valid) {
+		if (pdata->dok && gpio_is_valid(pdata->dok) &&
+				pdata->dcm && gpio_is_valid(pdata->dcm)) {
+			gpio = pdata->dok; /* PULL_UPed Interrupt */
+			ta_in = gpio_get_value(gpio) ? 0 : 1;
+
+			gpio = pdata->dcm; /* Output */
+			gpio_set_value(gpio, ta_in);
+		} else {
+			dev_err(dev, "When DC is wired, DOK and DCM should"
+					" be wired as well.\n");
+			ret = -EINVAL;
+			goto err;
+		}
+	} else {
+		if (pdata->dcm) {
+			if (gpio_is_valid(pdata->dcm))
+				gpio_set_value(pdata->dcm, 0);
+			else {
+				dev_err(dev, "Invalid pin: dcm.\n");
+				ret = -EINVAL;
+				goto err;
+			}
+		}
+	}
+
+	if (pdata->usb_valid) {
+		if (pdata->uok && gpio_is_valid(pdata->uok)) {
+			gpio = pdata->uok;
+			usb_in = gpio_get_value(gpio) ? 0 : 1;
+		} else {
+			dev_err(dev, "When USB is wired, UOK should be wired."
+					"as well.\n");
+			ret = -EINVAL;
+			goto err;
+		}
+	}
+
+	if (pdata->cen) {
+		if (gpio_is_valid(pdata->cen)) {
+			gpio_set_value(pdata->cen, (ta_in || usb_in) ? 0 : 1);
+		} else {
+			dev_err(dev, "Invalid pin: cen.\n");
+			ret = -EINVAL;
+			goto err;
+		}
+	}
+
+	if (pdata->chg) {
+		if (!gpio_is_valid(pdata->chg)) {
+			dev_err(dev, "Invalid pin: chg.\n");
+			ret = -EINVAL;
+			goto err;
+		}
+	}
+
+	if (pdata->flt) {
+		if (!gpio_is_valid(pdata->flt)) {
+			dev_err(dev, "Invalid pin: flt.\n");
+			ret = -EINVAL;
+			goto err;
+		}
+	}
+
+	if (pdata->usus) {
+		if (!gpio_is_valid(pdata->usus)) {
+			dev_err(dev, "Invalid pin: usus.\n");
+			ret = -EINVAL;
+			goto err;
+		}
+	}
+
+	data->fault = false;
+	data->ta_in = ta_in;
+	data->usb_in = usb_in;
+
+	data->psy.name = "max8903_charger";
+	data->psy.type = (ta_in) ? POWER_SUPPLY_TYPE_MAINS :
+			((usb_in) ? POWER_SUPPLY_TYPE_USB :
+			 POWER_SUPPLY_TYPE_BATTERY);
+	data->psy.get_property = max8903_get_property;
+	data->psy.properties = max8903_charger_props;
+	data->psy.num_properties = ARRAY_SIZE(max8903_charger_props);
+
+	ret = power_supply_register(dev, &data->psy);
+	if (ret) {
+		dev_err(dev, "failed: power supply register.\n");
+		goto err;
+	}
+
+	if (pdata->dc_valid) {
+		ret = request_threaded_irq(gpio_to_irq(pdata->dok),
+				NULL, max8903_dcin,
+				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+				"MAX8903 DC IN", data);
+		if (ret) {
+			dev_err(dev, "Cannot request irq %d for DC (%d)\n",
+					gpio_to_irq(pdata->dok), ret);
+			goto err_psy;
+		}
+	}
+
+	if (pdata->usb_valid) {
+		ret = request_threaded_irq(gpio_to_irq(pdata->uok),
+				NULL, max8903_usbin,
+				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+				"MAX8903 USB IN", data);
+		if (ret) {
+			dev_err(dev, "Cannot request irq %d for USB (%d)\n",
+					gpio_to_irq(pdata->uok), ret);
+			goto err_dc_irq;
+		}
+	}
+
+	if (pdata->flt) {
+		ret = request_threaded_irq(gpio_to_irq(pdata->flt),
+				NULL, max8903_fault,
+				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+				"MAX8903 Fault", data);
+		if (ret) {
+			dev_err(dev, "Cannot request irq %d for Fault (%d)\n",
+					gpio_to_irq(pdata->flt), ret);
+			goto err_usb_irq;
+		}
+	}
+
+	return 0;
+
+err_usb_irq:
+	if (pdata->usb_valid)
+		free_irq(gpio_to_irq(pdata->uok), data);
+err_dc_irq:
+	if (pdata->dc_valid)
+		free_irq(gpio_to_irq(pdata->dok), data);
+err_psy:
+	power_supply_unregister(&data->psy);
+err:
+	kfree(data);
+	return ret;
+}
+
+static __devexit int max8903_remove(struct platform_device *pdev)
+{
+	struct max8903_data *data = platform_get_drvdata(pdev);
+
+	if (data) {
+		struct max8903_pdata *pdata = data->pdata;
+
+		if (pdata->flt)
+			free_irq(gpio_to_irq(pdata->flt), data);
+		if (pdata->usb_valid)
+			free_irq(gpio_to_irq(pdata->uok), data);
+		if (pdata->dc_valid)
+			free_irq(gpio_to_irq(pdata->dok), data);
+		power_supply_unregister(&data->psy);
+		kfree(data);
+	}
+
+	return 0;
+}
+
+static struct platform_driver max8903_driver = {
+	.probe	= max8903_probe,
+	.remove	= __devexit_p(max8903_remove),
+	.driver = {
+		.name	= "max8903-charger",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init max8903_init(void)
+{
+	return platform_driver_register(&max8903_driver);
+}
+module_init(max8903_init);
+
+static void __exit max8903_exit(void)
+{
+	platform_driver_unregister(&max8903_driver);
+}
+module_exit(max8903_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("MAX8903 Charger Driver");
+MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
+MODULE_ALIAS("max8903-charger");
diff --git a/include/linux/power/max8903_charger.h b/include/linux/power/max8903_charger.h
new file mode 100644
index 0000000..24f51db
--- /dev/null
+++ b/include/linux/power/max8903_charger.h
@@ -0,0 +1,57 @@
+/*
+ * max8903_charger.h - Maxim 8903 USB/Adapter Charger Driver
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ * MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#ifndef __MAX8903_CHARGER_H__
+#define __MAX8903_CHARGER_H__
+
+struct max8903_pdata {
+	/*
+	 * GPIOs
+	 * cen, chg, flt, and usus are optional.
+	 * dok, dcm, and uok are not optional depending on the status of
+	 * dc_valid and usb_valid.
+	 */
+	int cen;	/* Charger Enable input */
+	int dok;	/* DC(Adapter) Power OK output */
+	int uok;	/* USB Power OK output */
+	int chg;	/* Charger status output */
+	int flt;	/* Fault output */
+	int dcm;	/* Current-Limit Mode input (1: DC, 2: USB) */
+	int usus;	/* USB Suspend Input (1: suspended) */
+
+	/*
+	 * DC(Adapter/TA) is wired
+	 * When dc_valid is true,
+	 *	dok and dcm should be valid.
+	 *
+	 * At least one of dc_valid or usb_valid should be true.
+	 */
+	bool dc_valid;
+	/*
+	 * USB is wired
+	 * When usb_valid is true,
+	 *	uok should be valid.
+	 */
+	bool usb_valid;
+};
+
+#endif /* __MAX8903_CHARGER_H__ */
-- 
1.7.1

