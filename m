Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab2IHKK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 06:10:56 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47287 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab2IHKKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 06:10:55 -0400
Message-ID: <504B19AD.2070505@kernel.org>
Date: Sat, 08 Sep 2012 11:10:53 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: anish kumar <anish198519851985@gmail.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, jic23@cam.ac.uk,
        linux-iio@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC]power: battery: Generic battery driver using IIO
References: <1346600372-3284-1-git-send-email-anish198519851985@gmail.com>  <5049B501.20604@metafoo.de> <1347089429.5051.157.camel@anish-Inspiron-N5050>
In-Reply-To: <1347089429.5051.157.camel@anish-Inspiron-N5050>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2012 08:30 AM, anish kumar wrote:
> On Fri, 2012-09-07 at 10:49 +0200, Lars-Peter Clausen wrote:
>> On 09/02/2012 05:39 PM, anish kumar wrote:
>>> From: anish kumar <anish198519851985@gmail.com>
>>>
>>> This patch is to use IIO to write a generic batttery driver.
>>> There are some inherent assumptions here:
>>> 1.User is having both main battery and backup battery.
>>> 2.Both batteries use same channel to get the information.
>>>
>>
>> Hi thanks for stepping up to take care of this and sorry for the late reply.
> Thanks to you.
>>
>>> Signed-off-by: anish kumar <anish198519851985@gmail.com>
>>> ---
>> [...]
>>> +
>>> +struct generic_adc_bat {
>>> +	struct power_supply		psy;
>>> +	struct iio_channel		*channels;
>>> +	int				channel_index;
>>> +};
>>> +
>>> +struct generic_bat {
>>> +	struct generic_adc_bat bat[BAT_MAX];
>>> +	struct generic_platform_data	pdata;
>>> +	int				volt_value;
>>> +	int				cur_value;
>>> +	unsigned int			timestamp;
>>> +	int				level;
>>> +	int				status;
>>> +	int				cable_plugged:1;
>>> +};
>>> +
>>> +static struct generic_bat generic_bat = {
>>> +	.bat[MAIN_BAT] = {
>>> +		.psy.name = "main-bat",
>>> +	},
>>> +	.bat[BACKUP_BAT] = {
>>> +		.psy.name = "backup-bat",
>>> +	},
>>> +};
>>
>> This should be per device. I'd also just use one power_supply per device. If
>> somebody has multiple batteries in their system they can register multiple
>> devices. This should make the driver more flexible.
> Yes makes sense of having one driver/device and if someone has more
> devices to register than it can be done by registering multiple devices
> with different platform data.
>>
>>> +
>>> +static struct delayed_work bat_work;
>>
>> This should also go into the generic_bat struct.
> right.
>>
>>  +
>>> +static void generic_adc_bat_ext_power_changed(struct power_supply *psy)
>>> +{
>>> +	schedule_delayed_work(&bat_work,
>>> +			msecs_to_jiffies(JITTER_DELAY));
>>> +}
>>> +
>>> +static enum power_supply_property generic_adc_main_bat_props[] = {
>>> +	POWER_SUPPLY_PROP_STATUS,
>>> +	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
>>> +	POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN,
>>> +	POWER_SUPPLY_PROP_CHARGE_NOW,
>>> +	POWER_SUPPLY_PROP_VOLTAGE_NOW,
>>> +	POWER_SUPPLY_PROP_CURRENT_NOW,
>>> +	POWER_SUPPLY_PROP_TECHNOLOGY,
>>> +	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
>>> +	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
>>> +	POWER_SUPPLY_PROP_MODEL_NAME,
>>> +};
>>
>> It probably make sense to create this at runtime, depending on which kind of
>> IIO channels are provided. E.g. for VOLTAGE_NOW/CURRENT_NOW.
> Yes, something like
> pdata->voltage_channel/pdata->current_channel/pdata->power_channel and
> if this property is set then register the VOLTAGE_NOW/CURRENT_NOW/POWER_
> property.
As stated in the other branch of this thread, just use standard naming and do this
via the iio_map that you'll need in platform data anyway.
>>
>> [...]
>>> +
>>> +static int generic_adc_bat_get_property(struct power_supply *psy,
>>> +		enum power_supply_property psp,
>>> +		union power_supply_propval *val)
>>> +{
>>> +	struct generic_adc_bat *adc_bat;
>>> +	struct generic_bat *bat;
>>> +	int ret, scaleint, scalepart, iio_val;
>>> +	long result = 0;
>>> +
>>> +	if (!strcmp(psy->name, "main-battery")) {
>>> +		adc_bat = container_of(psy,
>>> +					struct generic_adc_bat, psy);
>>> +		bat = container_of(adc_bat,
>>> +				struct generic_bat, bat[MAIN_BAT]);
>>> +	} else if (!strcmp(psy->name, "backup-battery")) {
>>> +		adc_bat = container_of(psy, struct generic_adc_bat, psy);
>>> +		bat = container_of(adc_bat,
>>> +				struct generic_bat, bat[BACKUP_BAT]);
>>> +	} else {
>>> +		/* Ideally this should never happen */
>>> +		WARN_ON(1);
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	if (!bat) {
>>> +		dev_err(psy->dev, "no battery infos ?!\n");
>>> +		return -EINVAL;
>>> +	}
>>> +	ret = iio_read_channel_raw(&adc_bat->channels[adc_bat->channel_index],
>>> +			&iio_val);
>>> +	ret = iio_read_channel_scale(&adc_bat->channels[adc_bat->channel_index],
>>> +			&scaleint, &scalepart);
>>
>> It would probably make sense to only sample if the attribute for
>> VOLTAGE_NOW/CURRENT_NOW property is read.
> right.
>>
>> [...]
>>
>>> +
>>> +	switch (psp) {
>>> +	case POWER_SUPPLY_PROP_STATUS:
>>> +		if (bat->pdata.gpio_charge_finished < 0)
>>> +			val->intval = bat->level == 100000 ?
>>> +				POWER_SUPPLY_STATUS_FULL : bat->status;
>>> +		else
>>> +			val->intval = bat->status;
>>> +		return 0;
>>> +	case POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN:
>>> +		val->intval = 0;
>>> +		return 0;
>>> +	case POWER_SUPPLY_PROP_CHARGE_NOW:
>>> +		val->intval = bat->pdata.cal_charge(result);
>>> +		return 0;
>>> +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
>>> +		val->intval = result;
>>> +		return 0;
>>> +	case POWER_SUPPLY_PROP_CURRENT_NOW:
>>> +		val->intval = result;
>>> +		return 0;
>>
>> also this will return the same value for VOLTAGE_NOW and CURRENT_NOW since
>> there is only one channel per battery. It might make sense to allow multiple
>> channels per battery, one reporting current one voltage and also one for power.
> absolutely makes sense.
>>
>>
>>> +	case POWER_SUPPLY_PROP_TECHNOLOGY:
>>> +		val->intval = bat->pdata.battery_info.technology;
>>> +		break;
>>> +	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
>>> +		val->intval = bat->pdata.battery_info.voltage_min_design;
>>> +		break;
>>> +	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
>>> +		val->intval = bat->pdata.battery_info.voltage_max_design;
>>> +		break;
>>> +	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
>>> +		val->intval = bat->pdata.battery_info.charge_full_design;
>>> +		break;
>>> +	case POWER_SUPPLY_PROP_MODEL_NAME:
>>> +		val->strval = bat->pdata.battery_info.name;
>>> +		break;
>>> +	default:
>>> +		return -EINVAL;
>>> +	}
>>> +	return ret;
>>> +}
>>> +
>> [...]
>>> +
>>> +static int __devinit generic_adc_bat_probe(struct platform_device *pdev)
>>> +{
>>> +[...]
>>> +
>>> +	/* assuming main battery and backup battery is using the same channel */
>>> +	for (i = 0; i < num_channels; i++) {
>>> +		ret = iio_get_channel_type(&channels[i], &type);
>>> +		if (ret < 0)
>>> +			goto err_gpio;
>>> +
>>> +		if (type == IIO_VOLTAGE || type == IIO_CURRENT) {
>>> +			for (j = 0; j < BAT_MAX; j++) {
>>> +				generic_bat.bat[j].channel_index = k;
>>> +				generic_bat.bat[j].channels[k] = channels[i];
>>> +			}
>>> +			k++;
>>> +		}
>>> +		continue;
>>
>> continue at the end of a loop is a noop.
> right.
>>
>>> +	}
>>> +
>>> +	INIT_DELAYED_WORK(&bat_work, generic_adc_bat_work);
>>> +
>>> +	if (pdata->gpio_charge_finished >= 0) {
>>
>> gpio_is_valid
> right.
>>
>>> +		ret = gpio_request(pdata->gpio_charge_finished, "charged");
>>> +		if (ret)
>>> +			goto err_gpio;
>>> +
>>> +		ret = request_irq(gpio_to_irq(pdata->gpio_charge_finished),
>>> +				generic_adc_bat_charged,
>>> +				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
>>> +				"battery charged", NULL);
>>> +		if (ret)
>>> +			goto err_gpio;
>>> +	}
>>> +
>>> +	dev_info(&pdev->dev, "successfully loaded\n");
>>
>> I'd remove that message.
> ok.
>>
>>> +
>>> +	/* Schedule timer to check current status */
>>> +	schedule_delayed_work(&bat_work,
>>> +			msecs_to_jiffies(JITTER_DELAY));
>>> +
>>> +	iio_channel_release_all(channels);
>>> +
>>> +	return 0;
>>> +
>>> +err_gpio:
>>> +	iio_channel_release_all(channels);
>>> +err_reg_backup:
>>> +	for (i = 0; i < ARRAY_SIZE(generic_bat.bat); i++)
>>> +		power_supply_unregister(&generic_bat.bat[i].psy);
>>> +err_reg_main:
>>> +	return ret;
>>> +}
>>> +
>>
>> [...]
>>
>>> +
>>> +#ifdef CONFIG_PM
>>> +static int generic_adc_bat_suspend(struct platform_device *pdev,
>>> +		pm_message_t state)
>>> +{
>>> +	struct generic_platform_data *pdata = pdev->dev.platform_data;
>>> +	struct generic_bat *bat = container_of(pdata,
>>> +					struct generic_bat, pdata);
>>> +
>>> +	cancel_delayed_work_sync(&bat_work);
>>> +	bat->status = POWER_SUPPLY_STATUS_UNKNOWN;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int generic_adc_bat_resume(struct platform_device *pdev)
>>> +{
>>> +	/* Schedule timer to check current status */
>>> +	schedule_delayed_work(&bat_work,
>>> +			msecs_to_jiffies(JITTER_DELAY));
>>> +
>>> +	return 0;
>>> +}
>>> +#else
>>> +#define generic_adc_bat_suspend NULL
>>> +#define generic_adc_bat_resume NULL
>>> +#endif
>>> +
>>> +static struct platform_driver generic_adc_bat_driver = {
>>> +	.driver		= {
>>> +		.name	= "generic-adc-battery",
>>> +	},
>>> +	.probe		= generic_adc_bat_probe,
>>> +	.remove		= generic_adc_bat_remove,
>>> +	.suspend	= generic_adc_bat_suspend,
>>> +	.resume		= generic_adc_bat_resume,
>>
>> Use dev_pm_ops instead. Using the suspend and resume callbacks is deprecated.
> makes sense.
>>
>>> +};
>>> +
>>> +module_platform_driver(generic_adc_bat_driver);
>>> +
>>> +MODULE_AUTHOR("anish kumar <anish198519851985@gmail.com>");
>>> +MODULE_DESCRIPTION("generic battery driver using IIO");
>>> +MODULE_LICENSE("GPL");
>>> diff --git a/include/linux/power/generic-battery.h b/include/linux/power/generic-battery.h
>>> new file mode 100644
>>> index 0000000..7a43aa0
>>> --- /dev/null
>>> +++ b/include/linux/power/generic-battery.h
>>> @@ -0,0 +1,26 @@
>>> +/*
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>> +
>>> +#ifndef GENERIC_BATTERY_H
>>> +#define GENERIC_BATTERY_H
>>> +
>>> +#include <linux/power_supply.h>
>>> +
>>> +/**
>>> + * struct generic_platform_data - platform data for generic battery
>>> + * @battery_info: Information about the battery
>>> + * @cal_charge: platform callback to calculate charge
>>> + * @gpio_charge_finished: GPIO number used for interrupts
>>> + * @gpio_inverted: Is the gpio inverted?
>>> + */
>>> +struct generic_platform_data {
>>
>> The name might be a bit to generic ;) I'd go for
>> generic_battery_platform_data or iio_battery_platform_data.
> it will be iio_battery_platform_data.
>>
>>> +	struct power_supply_info battery_info;
>>> +	int	(*cal_charge)(long);
>>> +	int	gpio_charge_finished;
>>> +	int	gpio_inverted;
>>> +};
>>> +
>>> +#endif /* GENERIC_BATTERY_H */
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
