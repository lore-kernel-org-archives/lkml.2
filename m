Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab2IPHPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 03:15:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34890 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab2IPHPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 03:15:07 -0400
From: anish kumar <anish198519851985@gmail.com>
To: lars@metafoo.de, jic23@cam.ac.uk, cbou@mail.ru
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] [V1]power: battery: Generic battery driver using IIO
Date: Sun, 16 Sep 2012 12:44:43 +0530
Message-Id: <1347779683-5025-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

In last version:
Addressed concerns raised by lars:
a. made the adc_bat per device.
b. get the IIO channel using hardcoded channel names.
c. Minor issues related to gpio_is_valid and some code
   refactoring.

In this version:
Addressed concerns raised by Anton:
a. changed the struct name to gab(generic adc battery).
b. Added some functions to neaten the code.
c. Some minor coding guidelines changes.
d. Used the latest function introduce by lars:
   iio_read_channel_processed to streamline the code.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/power/generic-adc-battery.c       |  442 +++++++++++++++++++++++++++++
 include/linux/power/generic-adc-battery.h |   19 ++
 2 files changed, 461 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/generic-adc-battery.c
 create mode 100644 include/linux/power/generic-adc-battery.h

diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
new file mode 100644
index 0000000..fd62916
--- /dev/null
+++ b/drivers/power/generic-adc-battery.c
@@ -0,0 +1,442 @@
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
+#include <linux/power/generic-adc-battery.h>
+
+enum gab_chan_type {
+	VOLTAGE = 0,
+	CURRENT,
+	POWER,
+	MAX_CHAN_TYPE
+};
+
+/*
+ * gab_chan_name suggests the standard channel names for commonly used
+ * channel types.
+ */
+static char *gab_chan_name[] = {
+	[VOLTAGE]	= "voltage",
+	[CURRENT]	= "current",
+	[POWER]		= "power",
+};
+
+struct gab {
+	struct power_supply	psy;
+	struct iio_channel	**channel;
+	struct gab_platform_data	*pdata;
+	struct delayed_work bat_work;
+	int		was_plugged;
+	int		volt_value;
+	int		cur_value;
+	int		level;
+	int		status;
+	int		cable_plugged:1;
+};
+
+struct gab *to_generic_bat(struct power_supply *psy)
+{
+	return	container_of(psy, struct gab, psy);
+}
+
+static void gab_ext_power_changed(struct power_supply *psy)
+{
+	struct gab *adc_bat;
+	adc_bat = to_generic_bat(psy);
+
+	schedule_delayed_work(&adc_bat->bat_work,
+			msecs_to_jiffies(adc_bat->pdata->jitter_delay));
+}
+
+static enum power_supply_property gab_props[] = {
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
+static enum power_supply_property gab_dyn_props[] = {
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_POWER_NOW,
+};
+
+static bool charge_finished(struct gab *adc_bat)
+{
+	bool ret = gpio_get_value(adc_bat->pdata->gpio_charge_finished);
+	bool inv = adc_bat->pdata->gpio_inverted;
+
+	return ret ^ inv;
+}
+
+int gab_get_status(struct gab *adc_bat)
+{
+	struct gab_platform_data *pdata = adc_bat->pdata;
+	int chg_gpio = pdata->gpio_charge_finished;
+
+	if (!gpio_is_valid(chg_gpio) || adc_bat->level < 100000)
+		return adc_bat->status;
+
+	return POWER_SUPPLY_STATUS_FULL;
+}
+
+enum gab_chan_type gab_prop_to_chan(enum power_supply_property psp)
+{
+	switch (psp) {
+	case POWER_SUPPLY_PROP_POWER_NOW:
+		return POWER;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		return VOLTAGE;
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		return CURRENT;
+	default:
+		WARN_ON(1);
+	}
+	return POWER;
+}
+
+int read_channel(struct gab *adc_bat, enum power_supply_property psp,
+		int *result)
+{
+	int ret = 0;
+	int chan_index;
+
+	chan_index = gab_prop_to_chan(psp);
+	ret = iio_read_channel_processed(adc_bat->channel[chan_index],
+			result);
+	if (ret < 0)
+		pr_err("read channel error\n");
+	return ret;
+}
+
+static int gab_get_property(struct power_supply *psy,
+		enum power_supply_property psp, union power_supply_propval *val)
+{
+	struct gab *adc_bat;
+	struct gab_platform_data *pdata;
+	struct power_supply_info *bat_info;
+	int result;
+	int ret = 0;
+
+	adc_bat = to_generic_bat(psy);
+	if (!adc_bat) {
+		dev_err(psy->dev, "no battery infos ?!\n");
+		return -EINVAL;
+	}
+	pdata = adc_bat->pdata;
+	bat_info = &pdata->battery_info;
+
+	ret = read_channel(adc_bat, psp, &result);
+	if (ret < 0)
+		goto err;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		gab_get_status(adc_bat);
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN:
+		val->intval = 0;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+		val->intval = pdata->cal_charge(result);
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
+		val->intval = bat_info->technology;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+		val->intval = bat_info->voltage_min_design;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+		val->intval = bat_info->voltage_max_design;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+		val->intval = bat_info->charge_full_design;
+		break;
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = bat_info->name;
+		break;
+	default:
+		return -EINVAL;
+	}
+err:
+	return ret;
+}
+
+static void gab_work(struct work_struct *work)
+{
+	struct gab *adc_bat;
+	struct gab_platform_data *pdata;
+	struct delayed_work *delayed_work;
+	int is_charged;
+	int is_plugged;
+
+	delayed_work = container_of(work, struct delayed_work, work);
+	adc_bat = container_of(delayed_work, struct gab, bat_work);
+	pdata = adc_bat->pdata;
+
+	is_plugged = power_supply_am_i_supplied(&adc_bat->psy);
+	adc_bat->cable_plugged = is_plugged;
+	if (is_plugged != adc_bat->was_plugged) {
+		adc_bat->was_plugged = is_plugged;
+		if (is_plugged)
+			adc_bat->status = POWER_SUPPLY_STATUS_CHARGING;
+		else
+			adc_bat->status = POWER_SUPPLY_STATUS_DISCHARGING;
+	} else {
+		if (gpio_is_valid(pdata->gpio_charge_finished)) {
+			if (is_plugged) {
+				is_charged = charge_finished(adc_bat);
+				if (is_charged)
+					adc_bat->status =
+						POWER_SUPPLY_STATUS_FULL;
+				else
+					adc_bat->status =
+						POWER_SUPPLY_STATUS_CHARGING;
+			}
+		}
+	}
+
+	power_supply_changed(&adc_bat->psy);
+}
+
+static irqreturn_t gab_charged(int irq, void *dev_id)
+{
+	struct gab *adc_bat = dev_id;
+
+	schedule_delayed_work(&adc_bat->bat_work,
+			msecs_to_jiffies(adc_bat->pdata->jitter_delay));
+	return IRQ_HANDLED;
+}
+
+static int __devinit gab_probe(struct platform_device *pdev)
+{
+	struct gab *adc_bat;
+	struct power_supply	*psy;
+	struct gab_platform_data *pdata = pdev->dev.platform_data;
+	int ret;
+	int num_chans;
+	int fail = 0;
+
+	adc_bat = devm_kzalloc(&pdev->dev, sizeof(*adc_bat), GFP_KERNEL);
+	if (!adc_bat) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	psy = &adc_bat->psy;
+
+	/* copying the battery name from platform data */
+	psy->name = pdata->battery_name;
+
+	/* bootup default values for the battery */
+	adc_bat->volt_value = -1;
+	adc_bat->cur_value = -1;
+	adc_bat->cable_plugged = 0;
+	adc_bat->status = POWER_SUPPLY_STATUS_DISCHARGING;
+	psy->type = POWER_SUPPLY_TYPE_BATTERY;
+	psy->get_property = gab_get_property;
+	psy->external_power_changed = gab_ext_power_changed;
+	adc_bat->pdata = pdata;
+
+	/* calculate the total number of channels */
+	num_chans = ARRAY_SIZE(gab_chan_name);
+
+	/*
+	 * copying the static properties and allocating extra memory for holding
+	 * the extra configurable properties received from platform data.
+	 */
+	psy->properties = devm_kzalloc(&pdev->dev, sizeof(gab_props) +
+			sizeof(*(psy->properties)) * num_chans,	GFP_KERNEL);
+	if (!psy->properties) {
+		ret = -ENOMEM;
+		goto first_mem_fail;
+	}
+
+	memcpy(psy->properties, gab_props, sizeof(gab_props));
+
+	/* allocating memory for iio channels */
+	adc_bat->channel = devm_kzalloc(&pdev->dev,
+				num_chans * sizeof(struct iio_channel),
+					GFP_KERNEL);
+	if (!adc_bat->channel) {
+		ret = -ENOMEM;
+		goto first_mem_fail;
+	}
+
+	/*
+	 * getting channel from iio and copying the battery properties
+	 * based on the channel supported by consumer device.
+	 */
+	for (num_chans = 0; gab_chan_name[num_chans]; num_chans++) {
+		adc_bat->channel[num_chans] =
+			iio_channel_get(dev_name(&pdev->dev),
+					gab_chan_name[num_chans]);
+		/* we skip for channels which fail */
+		if (IS_ERR(adc_bat->channel[num_chans])) {
+			pr_err("%s failed\n", gab_chan_name[num_chans]);
+			fail++;
+		} else {
+			static int index;
+			memcpy(psy->properties + sizeof(gab_props) +
+					sizeof(*(psy->properties))*index,
+					&gab_dyn_props[num_chans],
+					sizeof(gab_dyn_props[num_chans]));
+			index++;
+		}
+	}
+
+	/* none of the channels are supported so let's bail out */
+	if (fail == num_chans) {
+		ret = PTR_ERR(adc_bat->channel[num_chans]);
+		goto first_mem_fail;
+	}
+
+	/*
+	 * Total number of properties is equal to static properties
+	 * plus the dynamic properties.Some properties may not be set
+	 * as come channels may be not be supported by the device.So
+	 * we need to take care of that.
+	 */
+	psy->num_properties = ARRAY_SIZE(gab_props) +
+		ARRAY_SIZE(gab_dyn_props) - fail;
+
+	ret = power_supply_register(&pdev->dev, psy);
+	if (ret)
+		goto err_reg_fail;
+
+	INIT_DELAYED_WORK(&adc_bat->bat_work, gab_work);
+
+	if (gpio_is_valid(pdata->gpio_charge_finished)) {
+		int irq;
+		ret = gpio_request(pdata->gpio_charge_finished, "charged");
+		if (ret)
+			goto err_gpio;
+
+		irq = gpio_to_irq(pdata->gpio_charge_finished);
+		ret = request_any_context_irq(irq, gab_charged,
+				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+				"battery charged", &adc_bat);
+		if (ret)
+			goto err_gpio;
+	} else
+		goto err_gpio; /* let's bail out */
+
+	platform_set_drvdata(pdev, &adc_bat);
+
+	/* Schedule timer to check current status */
+	schedule_delayed_work(&adc_bat->bat_work,
+			msecs_to_jiffies(0));
+	return 0;
+
+err_gpio:
+	power_supply_unregister(psy);
+err_reg_fail:
+	for (num_chans = 0; gab_chan_name[num_chans]; num_chans++)
+		iio_channel_release(adc_bat->channel[num_chans]);
+first_mem_fail:
+	return ret;
+}
+
+static int gab_remove(struct platform_device *pdev)
+{
+	int num_chans;
+	struct gab_platform_data	*pdata;
+	struct gab *adc_bat = platform_get_drvdata(pdev);
+
+	pdata = adc_bat->pdata;
+	power_supply_unregister(&adc_bat->psy);
+
+	if (gpio_is_valid(pdata->gpio_charge_finished)) {
+		free_irq(gpio_to_irq(pdata->gpio_charge_finished), NULL);
+		gpio_free(pdata->gpio_charge_finished);
+	}
+
+	for (num_chans = 0; gab_chan_name[num_chans]; num_chans++)
+		iio_channel_release(adc_bat->channel[num_chans]);
+	cancel_delayed_work(&adc_bat->bat_work);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int gab_suspend(struct device *dev)
+{
+	struct gab *adc_bat = dev_get_drvdata(dev);
+
+	cancel_delayed_work_sync(&adc_bat->bat_work);
+	adc_bat->status = POWER_SUPPLY_STATUS_UNKNOWN;
+	return 0;
+}
+
+static int gab_resume(struct device *dev)
+{
+	struct gab *adc_bat = dev_get_drvdata(dev);
+
+	/* Schedule timer to check current status */
+	schedule_delayed_work(&adc_bat->bat_work,
+			msecs_to_jiffies(adc_bat->pdata->jitter_delay));
+	return 0;
+}
+
+static const struct dev_pm_ops gab_pm_ops = {
+	.suspend        = gab_suspend,
+	.resume         = gab_resume,
+};
+
+#define GAB_PM_OPS       (&gab_pm_ops)
+#else
+#define GAB_PM_OPS       (NULL)
+#endif
+
+static struct platform_driver gab_driver = {
+	.driver		= {
+		.name	= "generic-adc-battery",
+		.owner	= THIS_MODULE,
+		.pm	= GAB_PM_OPS
+	},
+	.probe		= gab_probe,
+	.remove		= gab_remove,
+};
+module_platform_driver(gab_driver);
+
+MODULE_AUTHOR("anish kumar <anish198519851985@gmail.com>");
+MODULE_DESCRIPTION("generic battery driver using IIO");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/power/generic-adc-battery.h b/include/linux/power/generic-adc-battery.h
new file mode 100644
index 0000000..8f02e9e
--- /dev/null
+++ b/include/linux/power/generic-adc-battery.h
@@ -0,0 +1,19 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef GENERIC_ADC_BATTERY_H
+#define GENERIC_ADC_BATTERY_H
+
+struct gab_platform_data {
+	struct power_supply_info battery_info;
+	char	*battery_name;
+	int	(*cal_charge)(long value);
+	int	gpio_charge_finished;
+	bool	gpio_inverted;
+	int	jitter_delay;
+};
+
+#endif /* GENERIC_ADC_BATTERY_H */
-- 
1.7.1

