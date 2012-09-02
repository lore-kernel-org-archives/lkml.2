Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2IBPjz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 11:39:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65151 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab2IBPjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 11:39:52 -0400
From: anish kumar <anish198519851985@gmail.com>
To: jic23@cam.ac.uk, linux-iio@vger.kernel.org, cbou@mail.ru,
        dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] [RFC]power: battery: Generic battery driver using IIO
Date: Sun,  2 Sep 2012 21:09:32 +0530
Message-Id: <1346600372-3284-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

This patch is to use IIO to write a generic batttery driver.
There are some inherent assumptions here:
1.User is having both main battery and backup battery.
2.Both batteries use same channel to get the information.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/power/Kconfig                 |    8 +
 drivers/power/Makefile                |    1 +
 drivers/power/generic-battery.c       |  374 +++++++++++++++++++++++++++++++++
 include/linux/power/generic-battery.h |   26 +++
 4 files changed, 409 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/generic-battery.c
 create mode 100644 include/linux/power/generic-battery.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index fcc1bb0..546e86b 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -309,6 +309,14 @@ config AB8500_BATTERY_THERM_ON_BATCTRL
 	help
 	  Say Y to enable battery temperature measurements using
 	  thermistor connected on BATCTRL ADC.
+
+config GENERIC_BATTERY
+	tristate "Generic battery support using IIO"
+	depends on IIO
+	help
+	  Say Y here to enable support for the generic battery driver
+	  which uses IIO framework to read adc for it's main and backup
+	  battery.
 endif # POWER_SUPPLY
 
 source "drivers/power/avs/Kconfig"
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index ee58afb..8284f9c 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -45,3 +45,4 @@ obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
 obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
 obj-$(CONFIG_POWER_AVS)		+= avs/
 obj-$(CONFIG_CHARGER_SMB347)	+= smb347-charger.o
+obj-$(CONFIG_GENERIC_BATTERY)	+= generic-battery.o
diff --git a/drivers/power/generic-battery.c b/drivers/power/generic-battery.c
new file mode 100644
index 0000000..33170b7
--- /dev/null
+++ b/drivers/power/generic-battery.c
@@ -0,0 +1,374 @@
+/*
+ * Generice battery driver code using IIO
+ * Copyright (C) 2012, Anish Kumar <anish198519851985@gmail.com>
+ * based on jz4740-battery.c
+ * based on s3c_adc_battery.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive for
+ * more details.
+ *
+ */
+
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/gpio.h>
+#include <linux/err.h>
+#include <linux/timer.h>
+#include <linux/jiffies.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/iio/consumer.h>
+#include <linux/iio/types.h>
+
+#include <linux/power/generic-battery.h>
+
+#define BAT_POLL_INTERVAL		10000 /* ms */
+#define JITTER_DELAY			500 /* ms */
+
+enum BAT {
+	MAIN_BAT = 0,
+	BACKUP_BAT,
+	BAT_MAX,
+};
+
+struct generic_adc_bat {
+	struct power_supply		psy;
+	struct iio_channel		*channels;
+	int				channel_index;
+};
+
+struct generic_bat {
+	struct generic_adc_bat bat[BAT_MAX];
+	struct generic_platform_data	pdata;
+	int				volt_value;
+	int				cur_value;
+	unsigned int			timestamp;
+	int				level;
+	int				status;
+	int				cable_plugged:1;
+};
+
+static struct generic_bat generic_bat = {
+	.bat[MAIN_BAT] = {
+		.psy.name = "main-bat",
+	},
+	.bat[BACKUP_BAT] = {
+		.psy.name = "backup-bat",
+	},
+};
+
+static struct delayed_work bat_work;
+
+static void generic_adc_bat_ext_power_changed(struct power_supply *psy)
+{
+	schedule_delayed_work(&bat_work,
+			msecs_to_jiffies(JITTER_DELAY));
+}
+
+static enum power_supply_property generic_adc_main_bat_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
+	POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+	POWER_SUPPLY_PROP_MODEL_NAME,
+};
+
+static int charge_finished(struct generic_bat *bat)
+{
+	return bat->pdata.gpio_inverted ?
+		!gpio_get_value(bat->pdata.gpio_charge_finished) :
+		gpio_get_value(bat->pdata.gpio_charge_finished);
+}
+
+static int generic_adc_bat_get_property(struct power_supply *psy,
+		enum power_supply_property psp,
+		union power_supply_propval *val)
+{
+	struct generic_adc_bat *adc_bat;
+	struct generic_bat *bat;
+	int ret, scaleint, scalepart, iio_val;
+	long result = 0;
+
+	if (!strcmp(psy->name, "main-battery")) {
+		adc_bat = container_of(psy,
+					struct generic_adc_bat, psy);
+		bat = container_of(adc_bat,
+				struct generic_bat, bat[MAIN_BAT]);
+	} else if (!strcmp(psy->name, "backup-battery")) {
+		adc_bat = container_of(psy, struct generic_adc_bat, psy);
+		bat = container_of(adc_bat,
+				struct generic_bat, bat[BACKUP_BAT]);
+	} else {
+		/* Ideally this should never happen */
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	if (!bat) {
+		dev_err(psy->dev, "no battery infos ?!\n");
+		return -EINVAL;
+	}
+	ret = iio_read_channel_raw(&adc_bat->channels[adc_bat->channel_index],
+			&iio_val);
+	ret = iio_read_channel_scale(&adc_bat->channels[adc_bat->channel_index],
+			&scaleint, &scalepart);
+	if (ret < 0)
+		return ret;
+
+	switch (ret) {
+	case IIO_VAL_INT:
+		result = iio_val * scaleint;
+		break;
+	case IIO_VAL_INT_PLUS_MICRO:
+		result = (s64)iio_val * (s64)scaleint +
+			div_s64((s64)iio_val * (s64)scalepart, 1000000LL);
+		break;
+	case IIO_VAL_INT_PLUS_NANO:
+		result = (s64)iio_val * (s64)scaleint +
+			div_s64((s64)iio_val * (s64)scalepart, 1000000000LL);
+		break;
+	}
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		if (bat->pdata.gpio_charge_finished < 0)
+			val->intval = bat->level == 100000 ?
+				POWER_SUPPLY_STATUS_FULL : bat->status;
+		else
+			val->intval = bat->status;
+		return 0;
+	case POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN:
+		val->intval = 0;
+		return 0;
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+		val->intval = bat->pdata.cal_charge(result);
+		return 0;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = result;
+		return 0;
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		val->intval = result;
+		return 0;
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval = bat->pdata.battery_info.technology;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+		val->intval = bat->pdata.battery_info.voltage_min_design;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+		val->intval = bat->pdata.battery_info.voltage_max_design;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+		val->intval = bat->pdata.battery_info.charge_full_design;
+		break;
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = bat->pdata.battery_info.name;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return ret;
+}
+
+static void generic_adc_bat_work(struct work_struct *work)
+{
+	struct generic_bat *bat = &generic_bat;
+	int is_charged;
+	int is_plugged;
+	static int was_plugged;
+
+	/* backup battery doesn't have current monitoring capability anyway */
+	is_plugged = power_supply_am_i_supplied(&bat->bat[MAIN_BAT].psy);
+	bat->cable_plugged = is_plugged;
+	if (is_plugged != was_plugged) {
+		was_plugged = is_plugged;
+		if (is_plugged)
+			bat->status = POWER_SUPPLY_STATUS_CHARGING;
+		else
+			bat->status = POWER_SUPPLY_STATUS_DISCHARGING;
+	} else {
+		if ((bat->pdata.gpio_charge_finished >= 0) && is_plugged) {
+			is_charged = charge_finished(&generic_bat);
+			if (is_charged)
+				bat->status = POWER_SUPPLY_STATUS_FULL;
+			else
+				bat->status = POWER_SUPPLY_STATUS_CHARGING;
+		}
+	}
+
+	power_supply_changed(&bat->bat[MAIN_BAT].psy);
+}
+
+static irqreturn_t generic_adc_bat_charged(int irq, void *dev_id)
+{
+	schedule_delayed_work(&bat_work,
+			msecs_to_jiffies(JITTER_DELAY));
+	return IRQ_HANDLED;
+}
+
+static int __devinit generic_adc_bat_probe(struct platform_device *pdev)
+{
+	struct generic_platform_data *pdata = pdev->dev.platform_data;
+	struct iio_channel *channels;
+	int num_channels = 0;
+	int ret, i, j, k = 0;
+	enum iio_chan_type type;
+
+	for (i = 0; i < ARRAY_SIZE(generic_bat.bat); i++) {
+		generic_bat.bat[i].psy.type = POWER_SUPPLY_TYPE_BATTERY;
+		generic_bat.bat[i].psy.properties =
+					generic_adc_main_bat_props;
+		generic_bat.bat[i].psy.num_properties =
+					ARRAY_SIZE(generic_adc_main_bat_props);
+		generic_bat.bat[i].psy.get_property =
+					generic_adc_bat_get_property;
+		generic_bat.bat[i].psy.external_power_changed =
+					generic_adc_bat_ext_power_changed;
+	}
+
+	generic_bat.volt_value = -1;
+	generic_bat.cur_value = -1;
+	generic_bat.cable_plugged = 0;
+	generic_bat.status = POWER_SUPPLY_STATUS_DISCHARGING;
+
+	memcpy(&generic_bat.pdata, pdata, sizeof(struct generic_platform_data));
+
+	for (i = 0; i < ARRAY_SIZE(generic_bat.bat); i++) {
+		ret = power_supply_register(&pdev->dev,
+				&generic_bat.bat[i].psy);
+		if (ret)
+			goto err_reg_main;
+	}
+
+	channels = iio_channel_get_all(dev_name(&pdev->dev));
+	if (IS_ERR(channels)) {
+		ret = PTR_ERR(channels);
+		goto err_reg_backup;
+	}
+
+	while (channels[num_channels].indio_dev)
+		num_channels++;
+
+	for (i = 0; i < ARRAY_SIZE(generic_bat.bat); i++)
+		generic_bat.bat[i].channels = kzalloc(sizeof(struct iio_channel)
+							* BAT_MAX, GFP_KERNEL);
+
+	/* assuming main battery and backup battery is using the same channel */
+	for (i = 0; i < num_channels; i++) {
+		ret = iio_get_channel_type(&channels[i], &type);
+		if (ret < 0)
+			goto err_gpio;
+
+		if (type == IIO_VOLTAGE || type == IIO_CURRENT) {
+			for (j = 0; j < BAT_MAX; j++) {
+				generic_bat.bat[j].channel_index = k;
+				generic_bat.bat[j].channels[k] = channels[i];
+			}
+			k++;
+		}
+		continue;
+	}
+
+	INIT_DELAYED_WORK(&bat_work, generic_adc_bat_work);
+
+	if (pdata->gpio_charge_finished >= 0) {
+		ret = gpio_request(pdata->gpio_charge_finished, "charged");
+		if (ret)
+			goto err_gpio;
+
+		ret = request_irq(gpio_to_irq(pdata->gpio_charge_finished),
+				generic_adc_bat_charged,
+				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+				"battery charged", NULL);
+		if (ret)
+			goto err_gpio;
+	}
+
+	dev_info(&pdev->dev, "successfully loaded\n");
+
+	/* Schedule timer to check current status */
+	schedule_delayed_work(&bat_work,
+			msecs_to_jiffies(JITTER_DELAY));
+
+	iio_channel_release_all(channels);
+
+	return 0;
+
+err_gpio:
+	iio_channel_release_all(channels);
+err_reg_backup:
+	for (i = 0; i < ARRAY_SIZE(generic_bat.bat); i++)
+		power_supply_unregister(&generic_bat.bat[i].psy);
+err_reg_main:
+	return ret;
+}
+
+static int generic_adc_bat_remove(struct platform_device *pdev)
+{
+	int i;
+	struct generic_platform_data *pdata = pdev->dev.platform_data;
+
+	for (i = 0; i < ARRAY_SIZE(generic_bat.bat); i++)
+		power_supply_unregister(&generic_bat.bat[i].psy);
+
+	if (pdata->gpio_charge_finished >= 0) {
+		free_irq(gpio_to_irq(pdata->gpio_charge_finished), NULL);
+		gpio_free(pdata->gpio_charge_finished);
+	}
+
+	cancel_delayed_work(&bat_work);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int generic_adc_bat_suspend(struct platform_device *pdev,
+		pm_message_t state)
+{
+	struct generic_platform_data *pdata = pdev->dev.platform_data;
+	struct generic_bat *bat = container_of(pdata,
+					struct generic_bat, pdata);
+
+	cancel_delayed_work_sync(&bat_work);
+	bat->status = POWER_SUPPLY_STATUS_UNKNOWN;
+
+	return 0;
+}
+
+static int generic_adc_bat_resume(struct platform_device *pdev)
+{
+	/* Schedule timer to check current status */
+	schedule_delayed_work(&bat_work,
+			msecs_to_jiffies(JITTER_DELAY));
+
+	return 0;
+}
+#else
+#define generic_adc_bat_suspend NULL
+#define generic_adc_bat_resume NULL
+#endif
+
+static struct platform_driver generic_adc_bat_driver = {
+	.driver		= {
+		.name	= "generic-adc-battery",
+	},
+	.probe		= generic_adc_bat_probe,
+	.remove		= generic_adc_bat_remove,
+	.suspend	= generic_adc_bat_suspend,
+	.resume		= generic_adc_bat_resume,
+};
+
+module_platform_driver(generic_adc_bat_driver);
+
+MODULE_AUTHOR("anish kumar <anish198519851985@gmail.com>");
+MODULE_DESCRIPTION("generic battery driver using IIO");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/power/generic-battery.h b/include/linux/power/generic-battery.h
new file mode 100644
index 0000000..7a43aa0
--- /dev/null
+++ b/include/linux/power/generic-battery.h
@@ -0,0 +1,26 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef GENERIC_BATTERY_H
+#define GENERIC_BATTERY_H
+
+#include <linux/power_supply.h>
+
+/**
+ * struct generic_platform_data - platform data for generic battery
+ * @battery_info: Information about the battery
+ * @cal_charge: platform callback to calculate charge
+ * @gpio_charge_finished: GPIO number used for interrupts
+ * @gpio_inverted: Is the gpio inverted?
+ */
+struct generic_platform_data {
+	struct power_supply_info battery_info;
+	int	(*cal_charge)(long);
+	int	gpio_charge_finished;
+	int	gpio_inverted;
+};
+
+#endif /* GENERIC_BATTERY_H */
-- 
1.7.1

