Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab2IJPks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:40:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55601 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab2IJPkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:40:45 -0400
From: anish kumar <anish198519851985@gmail.com>
To: lars@metafoo.de, jic23@cam.ac.uk, cbou@mail.ru
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] [RFC]power: battery: Generic battery driver using IIO
Date: Mon, 10 Sep 2012 21:10:21 +0530
Message-Id: <1347291621-8530-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

This is the cleaned up code after the valuable inputs from
the Jonathan, Lars and Anton.

I have tried to accomodate all the concerns however please
let me know incase something is missed out.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/power/generic-adc-battery.c       |  431 +++++++++++++++++++++++++++++
 include/linux/power/generic-adc-battery.h |   33 +++
 2 files changed, 464 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/generic-adc-battery.c
 create mode 100644 include/linux/power/generic-adc-battery.h

diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
new file mode 100644
index 0000000..3459740
--- /dev/null
+++ b/drivers/power/generic-adc-battery.c
@@ -0,0 +1,431 @@
+/*
+ * Generic battery driver code using IIO
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
+#include <linux/power/generic-adc-battery.h>
+
+#define to_generic_bat(ptr)	\
+	container_of(ptr, struct generic_adc_bat, ptr)
+
+/*
+ * channel_name suggests the standard channel names for commonly used
+ * channel types. Please use this names in board file if you support
+ * all the channel names.
+ */
+char channel_name[][BAT_MAX_NAME + 1] = {
+	[VOLTAGE]	= "voltage",
+	[CURRENT]	= "current",
+	[POWER]		= "power",
+};
+
+struct generic_adc_bat {
+	struct power_supply	psy;
+	struct iio_channel	**channel;
+	struct iio_battery_platform_data	pdata;
+	struct delayed_work bat_work;
+	int		was_plugged;
+	int		volt_value;
+	int		cur_value;
+	int		level;
+	int		status;
+	int		cable_plugged:1;
+};
+
+static void generic_adc_bat_ext_power_changed(struct power_supply *psy)
+{
+	struct generic_adc_bat *adc_bat;
+	adc_bat = to_generic_bat(psy);
+
+	schedule_delayed_work(&adc_bat->bat_work,
+			msecs_to_jiffies(adc_bat->pdata.jitter_delay));
+}
+
+static enum power_supply_property bat_props[] = {
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
+/*
+ * This properties are set based on the received platform data and this
+ * should correspond one-to-one with enum chan_type.
+ */
+static enum power_supply_property dyn_props[] = {
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_POWER_NOW,
+};
+
+static int charge_finished(struct generic_adc_bat *adc_bat)
+{
+	return adc_bat->pdata.gpio_inverted ?
+		!gpio_get_value(adc_bat->pdata.gpio_charge_finished) :
+		gpio_get_value(adc_bat->pdata.gpio_charge_finished);
+}
+
+static int generic_adc_bat_get_property(struct power_supply *psy,
+		enum power_supply_property psp,
+		union power_supply_propval *val)
+{
+	struct generic_adc_bat *adc_bat;
+	int scaleint, scalepart, iio_val, ret = 0;
+	long result = 0;
+
+	adc_bat = to_generic_bat(psy);
+	if (!adc_bat) {
+		dev_err(psy->dev, "no battery infos ?!\n");
+		return -EINVAL;
+	}
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_POWER_NOW:
+		ret = iio_read_channel_raw(adc_bat->channel[POWER],
+				&iio_val);
+		ret = iio_read_channel_scale(adc_bat->channel[POWER],
+				&scaleint, &scalepart);
+		if (ret < 0)
+			return ret;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		ret = iio_read_channel_raw(adc_bat->channel[VOLTAGE],
+				&iio_val);
+		ret = iio_read_channel_scale(adc_bat->channel[VOLTAGE],
+				&scaleint, &scalepart);
+		if (ret < 0)
+			return ret;
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		ret = iio_read_channel_raw(adc_bat->channel[CURRENT],
+				&iio_val);
+		ret = iio_read_channel_scale(adc_bat->channel[CURRENT],
+				&scaleint, &scalepart);
+		if (ret < 0)
+			return ret;
+		break;
+	default:
+		break;
+	}
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
+		if (adc_bat->pdata.gpio_charge_finished < 0)
+			val->intval = adc_bat->level == 100000 ?
+				POWER_SUPPLY_STATUS_FULL : adc_bat->status;
+		else
+			val->intval = adc_bat->status;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN:
+		val->intval = 0;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+		val->intval = adc_bat->pdata.cal_charge(result);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = result;
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		val->intval = result;
+		break;
+	case POWER_SUPPLY_PROP_POWER_NOW:
+		val->intval = result;
+		break;
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval = adc_bat->pdata.battery_info.technology;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+		val->intval = adc_bat->pdata.battery_info.voltage_min_design;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+		val->intval = adc_bat->pdata.battery_info.voltage_max_design;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+		val->intval = adc_bat->pdata.battery_info.charge_full_design;
+		break;
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = adc_bat->pdata.battery_info.name;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return ret;
+}
+
+static struct generic_adc_bat adc_bat = {
+	.psy.type = POWER_SUPPLY_TYPE_BATTERY,
+	.psy.get_property =
+		generic_adc_bat_get_property,
+	.psy.external_power_changed =
+		generic_adc_bat_ext_power_changed,
+};
+
+static void generic_adc_bat_work(struct work_struct *work)
+{
+	struct generic_adc_bat *adc_bat;
+	struct delayed_work *delayed_work;
+	int is_charged;
+	int is_plugged;
+
+	delayed_work = container_of(work,
+				struct delayed_work, work);
+	adc_bat = container_of(delayed_work,
+				struct generic_adc_bat, bat_work);
+
+	/* backup battery doesn't have current monitoring capability anyway */
+	is_plugged = power_supply_am_i_supplied(&adc_bat->psy);
+	adc_bat->cable_plugged = is_plugged;
+	if (is_plugged != adc_bat->was_plugged) {
+		adc_bat->was_plugged = is_plugged;
+		if (is_plugged)
+			adc_bat->status = POWER_SUPPLY_STATUS_CHARGING;
+		else
+			adc_bat->status = POWER_SUPPLY_STATUS_DISCHARGING;
+	} else {
+		if ((adc_bat->pdata.gpio_charge_finished >= 0) && is_plugged) {
+			is_charged = charge_finished(adc_bat);
+			if (is_charged)
+				adc_bat->status = POWER_SUPPLY_STATUS_FULL;
+			else
+				adc_bat->status = POWER_SUPPLY_STATUS_CHARGING;
+		}
+	}
+
+	power_supply_changed(&adc_bat->psy);
+}
+
+static irqreturn_t generic_adc_bat_charged(int irq, void *dev_id)
+{
+	struct generic_adc_bat *adc_bat = dev_id;
+	adc_bat = container_of(&adc_bat->bat_work,
+				struct generic_adc_bat, bat_work);
+	schedule_delayed_work(&adc_bat->bat_work,
+			msecs_to_jiffies(adc_bat->pdata.jitter_delay));
+	return IRQ_HANDLED;
+}
+
+/* 
+ * compare the pdata->channel names with the predefined channels and
+ * returns the index of the channel in channel_name array or -1 in the
+ * case of not-found.
+ */
+int channel_cmp(char *name)
+{
+	if (!strcmp(name, channel_name[VOLTAGE]))
+		return VOLTAGE;
+	else if (!strcmp(name, channel_name[CURRENT]))
+		return CURRENT;
+	else if (!strcmp(name, channel_name[POWER]))
+		return POWER;
+	else
+		return -1;
+}
+
+static int __devinit generic_adc_bat_probe(struct platform_device *pdev)
+{
+	struct iio_battery_platform_data *pdata = pdev->dev.platform_data;
+	int ret, chan_index;
+
+	/* copying the battery name from platform data */
+	adc_bat.psy.name = pdata->battery_name;
+
+	/* bootup default values for the battery */
+	adc_bat.volt_value = -1;
+	adc_bat.cur_value = -1;
+	adc_bat.cable_plugged = 0;
+	adc_bat.status = POWER_SUPPLY_STATUS_DISCHARGING;
+
+	/* calculate the total number of channels */
+	for (chan_index = 0; pdata->channel_name[chan_index]; chan_index++)
+		;
+
+	if (!chan_index) {
+		pr_err("atleast provide one channel\n");
+		return -EINVAL;
+	}
+
+	/* copying the static properties and allocating extra memory for holding
+	 * the extra configurable properties received from platform data.
+	*/
+	adc_bat.psy.properties = kzalloc(sizeof(bat_props)
+					+ sizeof(int)*chan_index, GFP_KERNEL);
+	if (!adc_bat.psy.properties) {
+		ret = -ENOMEM;
+		goto first_mem_fail;
+	}
+	memcpy(adc_bat.psy.properties, bat_props, sizeof(bat_props));
+
+	/* allocating memory for iio channels */
+	adc_bat.channel = kzalloc(chan_index * sizeof(struct iio_channel),
+					GFP_KERNEL);
+	if (!adc_bat.channel) {
+		ret = -ENOMEM;
+		goto second_mem_fail;
+	}
+
+	/*
+	 * getting channel from iio and copying the battery properties
+	 * based on the channel set in the platform data.
+	 */
+	for (chan_index = 0; pdata->channel_name[chan_index]; chan_index++) {
+		int channel = channel_cmp(pdata->channel_name[chan_index]);
+		if (channel < 0) {
+			ret = -EINVAL;
+			goto second_mem_fail;
+		}
+
+		adc_bat.channel[chan_index] =
+		iio_channel_get(dev_name(&pdev->dev),
+			pdata->channel_name[chan_index]);
+		if (IS_ERR(adc_bat.channel[chan_index])) {
+			ret = PTR_ERR(adc_bat.channel[chan_index]);
+			goto second_mem_fail;
+		}
+
+		memcpy(adc_bat.psy.properties+sizeof(bat_props),
+			&dyn_props[channel], sizeof(dyn_props[channel]));
+	}
+
+	ret = power_supply_register(&pdev->dev, &adc_bat.psy);
+	if (ret)
+		goto err_reg_fail;
+
+	INIT_DELAYED_WORK(&adc_bat.bat_work, generic_adc_bat_work);
+
+	if (gpio_is_valid(pdata->gpio_charge_finished)) {
+		ret = gpio_request(pdata->gpio_charge_finished, "charged");
+		if (ret)
+			goto err_gpio;
+
+		ret = request_irq(gpio_to_irq(pdata->gpio_charge_finished),
+				generic_adc_bat_charged,
+				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+				"battery charged", &adc_bat);
+		if (ret)
+			goto err_gpio;
+	} else
+		goto err_gpio; /* let's bail out */
+
+	platform_set_drvdata(pdev, &adc_bat);
+	/* Schedule timer to check current status */
+	schedule_delayed_work(&adc_bat.bat_work,
+			msecs_to_jiffies(0));
+	return 0;
+
+err_gpio:
+	power_supply_unregister(&adc_bat.psy);
+err_reg_fail:
+	for (chan_index = 0; pdata->channel_name[chan_index]; chan_index++)
+		iio_channel_release(adc_bat.channel[chan_index]);
+	kfree(adc_bat.channel);
+second_mem_fail:
+	kfree(adc_bat.psy.properties);
+first_mem_fail:
+	return ret;
+}
+
+static int generic_adc_bat_remove(struct platform_device *pdev)
+{
+	int chan_index;
+	struct iio_battery_platform_data *pdata = pdev->dev.platform_data;
+	struct generic_adc_bat *adc_bat = to_generic_bat(pdata);
+
+	power_supply_unregister(&adc_bat->psy);
+
+	if (pdata->gpio_charge_finished >= 0) {
+		free_irq(gpio_to_irq(pdata->gpio_charge_finished), NULL);
+		gpio_free(pdata->gpio_charge_finished);
+	}
+
+	for (chan_index = 0; pdata->channel_name[chan_index]; chan_index++)
+		iio_channel_release(adc_bat->channel[chan_index]);
+	cancel_delayed_work(&adc_bat->bat_work);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int generic_adc_bat_suspend(struct device *dev)
+{
+	struct generic_adc_bat *adc_bat = dev_get_drvdata(dev);
+
+	cancel_delayed_work_sync(&adc_bat->bat_work);
+	adc_bat->status = POWER_SUPPLY_STATUS_UNKNOWN;
+	return 0;
+}
+
+static int generic_adc_bat_resume(struct device *dev)
+{
+	struct generic_adc_bat *adc_bat = dev_get_drvdata(dev);
+
+	/* Schedule timer to check current status */
+	schedule_delayed_work(&adc_bat->bat_work,
+			msecs_to_jiffies(adc_bat->pdata.jitter_delay));
+	return 0;
+}
+
+static const struct dev_pm_ops generic_adc_battery_pm_ops = {
+	.suspend        = generic_adc_bat_suspend,
+	.resume         = generic_adc_bat_resume,
+};
+
+#define GENERIC_ADC_BATTERY_PM_OPS       (&generic_adc_battery_pm_ops)
+#else
+#define GENERIC_ADC_BATTERY_PM_OPS       (NULL)
+#endif
+
+static struct platform_driver generic_adc_bat_driver = {
+	.driver		= {
+		.name	= "generic-adc-battery",
+		.owner	= THIS_MODULE,
+		.pm	= GENERIC_ADC_BATTERY_PM_OPS
+	},
+	.probe		= generic_adc_bat_probe,
+	.remove		= generic_adc_bat_remove,
+};
+
+module_platform_driver(generic_adc_bat_driver);
+
+MODULE_AUTHOR("anish kumar <anish198519851985@gmail.com>");
+MODULE_DESCRIPTION("generic battery driver using IIO");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/power/generic-adc-battery.h b/include/linux/power/generic-adc-battery.h
new file mode 100644
index 0000000..d7c6d20
--- /dev/null
+++ b/include/linux/power/generic-adc-battery.h
@@ -0,0 +1,33 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef GENERIC_ADC_BATTERY_H
+#define GENERIC_ADC_BATTERY_H
+
+/* should be enough for the channel names */
+#define BAT_MAX_NAME	30
+
+enum chan_type {
+	VOLTAGE = 0,
+	CURRENT,
+	POWER,
+	MAX_CHAN_TYPE
+};
+
+extern char channel_name[][BAT_MAX_NAME + 1];
+
+struct iio_battery_platform_data {
+	struct power_supply_info battery_info;
+	char	**channel_name;
+	char	*battery_name;
+	int	(*cal_charge)(long);
+	int	gpio_charge_finished;
+	int	gpio_inverted;
+	int	bat_poll_interval;
+	int	jitter_delay;
+};
+
+#endif /* GENERIC_ADC_BATTERY_H */
-- 
1.7.1

