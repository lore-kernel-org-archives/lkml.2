Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2IQD5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 23:57:20 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51832 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab2IQD5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 23:57:17 -0400
MIME-Version: 1.0
In-Reply-To: <5055F31E.30905@metafoo.de>
References: <1347779683-5025-1-git-send-email-anish198519851985@gmail.com>
	<5055F31E.30905@metafoo.de>
Date: Mon, 17 Sep 2012 09:27:16 +0530
Message-ID: <CAK7N6vrRF1XdMstnM2UcBof4TM-NR3g7bUBn_noZk+aZZiGyrQ@mail.gmail.com>
Subject: Re: [PATCH] [V1]power: battery: Generic battery driver using IIO
From: anish singh <anish198519851985@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: jic23@cam.ac.uk, cbou@mail.ru, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lars,

Thanks for the review.All of you comments are valid but
i just have a small question w.r.t one of your comments.
Inline below.

On Sun, Sep 16, 2012 at 9:11 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 09/16/2012 09:14 AM, anish kumar wrote:
>> From: anish kumar <anish198519851985@gmail.com>
>>
>> In last version:
>> Addressed concerns raised by lars:
>> a. made the adc_bat per device.
>> b. get the IIO channel using hardcoded channel names.
>> c. Minor issues related to gpio_is_valid and some code
>>    refactoring.
>>
>> In this version:
>> Addressed concerns raised by Anton:
>> a. changed the struct name to gab(generic adc battery).
>> b. Added some functions to neaten the code.
>> c. Some minor coding guidelines changes.
>> d. Used the latest function introduce by lars:
>>    iio_read_channel_processed to streamline the code.
>>
>> Signed-off-by: anish kumar <anish198519851985@gmail.com>
>> ---
>>  drivers/power/generic-adc-battery.c       |  442 +++++++++++++++++++++++++++++
>>  include/linux/power/generic-adc-battery.h |   19 ++
>>  2 files changed, 461 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/power/generic-adc-battery.c
>>  create mode 100644 include/linux/power/generic-adc-battery.h
>>
>> diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
>> new file mode 100644
>> index 0000000..fd62916
>> --- /dev/null
>> +++ b/drivers/power/generic-adc-battery.c
>> @@ -0,0 +1,442 @@
>> +/*
>> + * Generic battery driver code using IIO
>> + * Copyright (C) 2012, Anish Kumar <anish198519851985@gmail.com>
>> + * based on jz4740-battery.c
>> + * based on s3c_adc_battery.c
>> + *
>> + * This file is subject to the terms and conditions of the GNU General Public
>> + * License.  See the file COPYING in the main directory of this archive for
>> + * more details.
>> + *
>> + */
>> +#include <linux/interrupt.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/power_supply.h>
>> +#include <linux/gpio.h>
>> +#include <linux/err.h>
>> +#include <linux/timer.h>
>> +#include <linux/jiffies.h>
>> +#include <linux/errno.h>
>> +#include <linux/init.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/iio/consumer.h>
>> +#include <linux/iio/types.h>
>> +#include <linux/power/generic-adc-battery.h>
>> +
>> +enum gab_chan_type {
>> +     VOLTAGE = 0,
>> +     CURRENT,
>> +     POWER,
>> +     MAX_CHAN_TYPE
>> +};
>> +
>> +/*
>> + * gab_chan_name suggests the standard channel names for commonly used
>> + * channel types.
>> + */
>> +static char *gab_chan_name[] = {
>
> const char *const
>
>> +     [VOLTAGE]       = "voltage",
>> +     [CURRENT]       = "current",
>> +     [POWER]         = "power",
>> +};
>> +
>> +struct gab {
>> +     struct power_supply     psy;
>> +     struct iio_channel      **channel;
>> +     struct gab_platform_data        *pdata;
>> +     struct delayed_work bat_work;
>> +     int             was_plugged;
>> +     int             volt_value;
>> +     int             cur_value;
>
> The two above are never really used.
>
>> +     int             level;
>> +     int             status;
>> +     int             cable_plugged:1;
>> +};
> [...]
>> +static enum power_supply_property gab_props[] = {
> const
>> +     POWER_SUPPLY_PROP_STATUS,
>> +     POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
>> +     POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN,
>> +     POWER_SUPPLY_PROP_CHARGE_NOW,
>> +     POWER_SUPPLY_PROP_VOLTAGE_NOW,
>> +     POWER_SUPPLY_PROP_CURRENT_NOW,
>> +     POWER_SUPPLY_PROP_TECHNOLOGY,
>> +     POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
>> +     POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
>> +     POWER_SUPPLY_PROP_MODEL_NAME,
>> +};
>> +
>> +/*
>> + * This properties are set based on the received platform data and this
>> + * should correspond one-to-one with enum chan_type.
>> + */
>> +static enum power_supply_property gab_dyn_props[] = {
> const
>> +     POWER_SUPPLY_PROP_VOLTAGE_NOW,
>> +     POWER_SUPPLY_PROP_CURRENT_NOW,
>> +     POWER_SUPPLY_PROP_POWER_NOW,
>> +};
>> +
>> +static bool charge_finished(struct gab *adc_bat)
>
> missing prefix
>
>> +{
>> +     bool ret = gpio_get_value(adc_bat->pdata->gpio_charge_finished);
>> +     bool inv = adc_bat->pdata->gpio_inverted;
>> +
>> +     return ret ^ inv;
>> +}
>> +
>> +int gab_get_status(struct gab *adc_bat)
> static
>> +{
>> +     struct gab_platform_data *pdata = adc_bat->pdata;
>> +     int chg_gpio = pdata->gpio_charge_finished;
>> +
>> +     if (!gpio_is_valid(chg_gpio) || adc_bat->level < 100000)
>
> level is never really set, is it? Also the 100000 seems to come directly from
> the s3c_adc_battery driver, while this value may be different for every
> battery. I'd use the bat_info->charge_full_design here. Also I'd remove the
> !gpio_is_valid(chg_gpio)  I don't see a reason why the battery could not be
> fully charged even though no charger gpio is given.
gpio_is_valid is just a call to check if the particular gpio is valid or not[1].
I don't seem to understand why we are using it everywhere when only in probe it
makes sense as far as my understanding goes.If in probe it is proper then why
this check again and again(?) or is it possible that someone else
does something somewhere which necessitates this gpio_is_valid check.

And we are using charger gpio in the probe function.

[1] http://lxr.free-electrons.com/source/include/asm-generic/gpio.h?v=2.6.30#L24
>
>> +             return adc_bat->status;
>> +
>> +     return POWER_SUPPLY_STATUS_FULL;
>> +}
>> +
>> +enum gab_chan_type gab_prop_to_chan(enum power_supply_property psp)
> static
>> +{
>> +     switch (psp) {
>> +     case POWER_SUPPLY_PROP_POWER_NOW:
>> +             return POWER;
>> +     case POWER_SUPPLY_PROP_VOLTAGE_NOW:
>> +             return VOLTAGE;
>> +     case POWER_SUPPLY_PROP_CURRENT_NOW:
>> +             return CURRENT;
>> +     default:
>> +             WARN_ON(1);
>
> This WARN_ON will be hit quite often.
>
>> +     }
>> +     return POWER;
>> +}
>> +
>> +int read_channel(struct gab *adc_bat, enum power_supply_property psp,
>> +             int *result)
> static
>> +{
>> +     int ret = 0;
>> +     int chan_index;
>> +
>> +     chan_index = gab_prop_to_chan(psp);
>> +     ret = iio_read_channel_processed(adc_bat->channel[chan_index],
>> +                     result);
>> +     if (ret < 0)
>> +             pr_err("read channel error\n");
>> +     return ret;
>> +}
>> +
>> +static int gab_get_property(struct power_supply *psy,
>> +             enum power_supply_property psp, union power_supply_propval *val)
>> +{
>> +     struct gab *adc_bat;
>> +     struct gab_platform_data *pdata;
>> +     struct power_supply_info *bat_info;
>> +     int result;
>> +     int ret = 0;
>> +
>> +     adc_bat = to_generic_bat(psy);
>> +     if (!adc_bat) {
>> +             dev_err(psy->dev, "no battery infos ?!\n");
>> +             return -EINVAL;
>> +     }
>> +     pdata = adc_bat->pdata;
>> +     bat_info = &pdata->battery_info;
>> +
>> +     ret = read_channel(adc_bat, psp, &result);
>> +     if (ret < 0)
>> +             goto err;
>> +
>> +     switch (psp) {
>> +     case POWER_SUPPLY_PROP_STATUS:
>> +             gab_get_status(adc_bat);
>> +             break;
>> +     case POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN:
>> +             val->intval = 0;
>> +             break;
>> +     case POWER_SUPPLY_PROP_CHARGE_NOW:
>> +             val->intval = pdata->cal_charge(result);
>> +             break;
>> +     case POWER_SUPPLY_PROP_VOLTAGE_NOW:
>> +             val->intval = result;
>> +             break;
>> +     case POWER_SUPPLY_PROP_CURRENT_NOW:
>> +             val->intval = result;
>> +             break;
>> +     case POWER_SUPPLY_PROP_POWER_NOW:
>> +             val->intval = result;
>
> I'd do it this way, that also avoids all the WARN_ONs earlier
>
>         case POWER_SUPPLY_PROP_VOLTAGE_NOW
>         case POWER_SUPPLY_PROP_CURRENT_NOW:
>         case POWER_SUPPLY_PROP_POWER_NOW:
>                 ret = read_channel(adc_bat, psp, &result);
>                 if (ret < 0)
>                         return ret
>                 val->intval = result;
>
>
>> +             break;
>> +     case POWER_SUPPLY_PROP_TECHNOLOGY:
>> +             val->intval = bat_info->technology;
>> +             break;
>> +     case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
>> +             val->intval = bat_info->voltage_min_design;
>> +             break;
>> +     case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
>> +             val->intval = bat_info->voltage_max_design;
>> +             break;
>> +     case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
>> +             val->intval = bat_info->charge_full_design;
>> +             break;
>> +     case POWER_SUPPLY_PROP_MODEL_NAME:
>> +             val->strval = bat_info->name;
>> +             break;
>> +     default:
>> +             return -EINVAL;
>> +     }
>> +err:
>> +     return ret;
>> +}
>> +
>> +static void gab_work(struct work_struct *work)
>> +{
>> +     struct gab *adc_bat;
>> +     struct gab_platform_data *pdata;
>> +     struct delayed_work *delayed_work;
>> +     int is_charged;
>> +     int is_plugged;
>> +
>> +     delayed_work = container_of(work, struct delayed_work, work);
>> +     adc_bat = container_of(delayed_work, struct gab, bat_work);
>> +     pdata = adc_bat->pdata;
>> +
>> +     is_plugged = power_supply_am_i_supplied(&adc_bat->psy);
>> +     adc_bat->cable_plugged = is_plugged;
>> +     if (is_plugged != adc_bat->was_plugged) {
>> +             adc_bat->was_plugged = is_plugged;
>
> I don't thin was_plugged is necessary. If is unplugged it is discharging, if it
> is plugged it is either charging or full. And I think that's the logic that
> should be used to set status. Something like.
>
> if (!is_plugged)
>         adc_bat->status =  POWER_SUPPLY_STATUS_DISCHARGING;
> else if (charge_finished(adc_bat))
>         adc_bat->status = POWER_SUPPLY_STATUS_FULL;
>
> Maybe POWER_SUPPLY_STATUS_NOT_CHARGING is the better status here since we do
> not necessarily know that it is full.
>
> else
>         adc_bat->status = POWER_SUPPLY_STATUS_CHARGING;
>
> This assumes that the gpio_is_valid checking is done in charge_finished and if
> it returns false charge_finished just returns false.
>
>> +             if (is_plugged)
>> +                     adc_bat->status = POWER_SUPPLY_STATUS_CHARGING;
>> +             else
>> +                     adc_bat->status = POWER_SUPPLY_STATUS_DISCHARGING;
>> +     } else {
>> +             if (gpio_is_valid(pdata->gpio_charge_finished)) {
>> +                     if (is_plugged) {
>> +                             is_charged = charge_finished(adc_bat);
>> +                             if (is_charged)
>> +                                     adc_bat->status =
>> +                                             POWER_SUPPLY_STATUS_FULL;
>> +                             else
>> +                                     adc_bat->status =
>> +                                             POWER_SUPPLY_STATUS_CHARGING;
>> +                     }
>> +             }
>> +     }
>> +
>> +     power_supply_changed(&adc_bat->psy);
>
> It makes probably sense to make a copy of adc_bat->status and if it did not
> change don't generate an event.
>
>> +}
>> +
>> +static irqreturn_t gab_charged(int irq, void *dev_id)
>> +{
>> +     struct gab *adc_bat = dev_id;
>> +
>> +     schedule_delayed_work(&adc_bat->bat_work,
>> +                     msecs_to_jiffies(adc_bat->pdata->jitter_delay));
>
> I would use a default jitter delay if it is 0. Does this make sense?
>
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +static int __devinit gab_probe(struct platform_device *pdev)
>> +{
>> +     struct gab *adc_bat;
>> +     struct power_supply     *psy;
>> +     struct gab_platform_data *pdata = pdev->dev.platform_data;
>> +     int ret;
>> +     int num_chans;
>> +     int fail = 0;
>> +
>> +     adc_bat = devm_kzalloc(&pdev->dev, sizeof(*adc_bat), GFP_KERNEL);
>> +     if (!adc_bat) {
>> +             dev_err(&pdev->dev, "failed to allocate memory\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     psy = &adc_bat->psy;
>> +
>> +     /* copying the battery name from platform data */
>> +     psy->name = pdata->battery_name;
>> +
>> +     /* bootup default values for the battery */
>> +     adc_bat->volt_value = -1;
>> +     adc_bat->cur_value = -1;
>> +     adc_bat->cable_plugged = 0;
>> +     adc_bat->status = POWER_SUPPLY_STATUS_DISCHARGING;
>> +     psy->type = POWER_SUPPLY_TYPE_BATTERY;
>> +     psy->get_property = gab_get_property;
>> +     psy->external_power_changed = gab_ext_power_changed;
>> +     adc_bat->pdata = pdata;
>> +
>> +     /* calculate the total number of channels */
>> +     num_chans = ARRAY_SIZE(gab_chan_name);
>> +
>> +     /*
>> +      * copying the static properties and allocating extra memory for holding
>> +      * the extra configurable properties received from platform data.
>> +      */
>> +     psy->properties = devm_kzalloc(&pdev->dev, sizeof(gab_props) +
>> +                     sizeof(*(psy->properties)) * num_chans, GFP_KERNEL);
>
> Maybe use kcalloc here with ARRAY_SIZE(gab_props) + ARRAY_SIZE(gab_chan_name)
> as first parameter and sizeof(*psy->properties) as second.
>
>> +     if (!psy->properties) {
>> +             ret = -ENOMEM;
>> +             goto first_mem_fail;
>> +     }
>> +
>> +     memcpy(psy->properties, gab_props, sizeof(gab_props));
>> +
>> +     /* allocating memory for iio channels */
>> +     adc_bat->channel = devm_kzalloc(&pdev->dev,
>> +                             num_chans * sizeof(struct iio_channel),
>> +                                     GFP_KERNEL);
>
> Since the size is const you could just make channel an aray in the gab struct
> and this allocation would not be needed.
>
>> +     if (!adc_bat->channel) {
>> +             ret = -ENOMEM;
>> +             goto first_mem_fail;
>> +     }
>> +
>> +     /*
>> +      * getting channel from iio and copying the battery properties
>> +      * based on the channel supported by consumer device.
>> +      */
>> +     for (num_chans = 0; gab_chan_name[num_chans]; num_chans++) {
>
> This won't work since gab_chan_name is not NULL terminated. Just make it
> num_chans < ARRAY_SIZE(gab_chan_name). Btw. num_chans is really a bad name in
> this case since it is an iterator variable. Just call it chan or something like
> that.
>
>> +             adc_bat->channel[num_chans] =
>> +                     iio_channel_get(dev_name(&pdev->dev),
>> +                                     gab_chan_name[num_chans]);
>> +             /* we skip for channels which fail */
>> +             if (IS_ERR(adc_bat->channel[num_chans])) {
>> +                     pr_err("%s failed\n", gab_chan_name[num_chans]);
>
> No error message here it will be quite likely that a battery does not provide
> all three types of channels.
>
>> +                     fail++;
>> +             } else {
>> +                     static int index;
>
> static?! Move it outsize of the loop an initialize it to ARRAY_SIZE(gab_props)
> then you can skip the "extra + sizeof(gab_props)" here.
>
>> +                     memcpy(psy->properties + sizeof(gab_props) +
>> +                                     sizeof(*(psy->properties))*index,
>> +                                     &gab_dyn_props[num_chans],
>> +                                     sizeof(gab_dyn_props[num_chans]));
>> +                     index++;
>> +             }
>> +     }
>> +
>> +     /* none of the channels are supported so let's bail out */
>> +     if (fail == num_chans) {
>
> Just check whether index is != 0, you don't need to count the failed requests then.
>
>> +             ret = PTR_ERR(adc_bat->channel[num_chans]);
>
> num_chans will be outside of bounds of channel at this point.
>
>> +             goto first_mem_fail;
>> +     }
>> +
>> +     /*
>> +      * Total number of properties is equal to static properties
>> +      * plus the dynamic properties.Some properties may not be set
>> +      * as come channels may be not be supported by the device.So
>> +      * we need to take care of that.
>> +      */
>> +     psy->num_properties = ARRAY_SIZE(gab_props) +
>> +             ARRAY_SIZE(gab_dyn_props) - fail;
>> +
>> +     ret = power_supply_register(&pdev->dev, psy);
>> +     if (ret)
>> +             goto err_reg_fail;
>> +
>> +     INIT_DELAYED_WORK(&adc_bat->bat_work, gab_work);
>> +
>> +     if (gpio_is_valid(pdata->gpio_charge_finished)) {
>> +             int irq;
>> +             ret = gpio_request(pdata->gpio_charge_finished, "charged");
>> +             if (ret)
>> +                     goto err_gpio;
>> +
>> +             irq = gpio_to_irq(pdata->gpio_charge_finished);
>> +             ret = request_any_context_irq(irq, gab_charged,
>> +                             IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
>> +                             "battery charged", &adc_bat);
>
> Just "adc_bat", not "&adc_bat"
>
>> +             if (ret)
>> +                     goto err_gpio;
>
>                         You also need to free the if requesting the gpio fails.
>
>> +     } else
>> +             goto err_gpio; /* let's bail out */
>> +
>> +     platform_set_drvdata(pdev, &adc_bat);
>
> Same here
>
>> +
>> +     /* Schedule timer to check current status */
>> +     schedule_delayed_work(&adc_bat->bat_work,
>> +                     msecs_to_jiffies(0));
>> +     return 0;
>> +
>> +err_gpio:
>> +     power_supply_unregister(psy);
>> +err_reg_fail:
>> +     for (num_chans = 0; gab_chan_name[num_chans]; num_chans++)
>
> Here again, it's not NULL terminated
>
>> +             iio_channel_release(adc_bat->channel[num_chans]);
>> +first_mem_fail:
>> +     return ret;
>> +}
>> +
>> +static int gab_remove(struct platform_device *pdev)
> __devexit
>> +{
>> +     int num_chans;
>> +     struct gab_platform_data        *pdata;
>> +     struct gab *adc_bat = platform_get_drvdata(pdev);
>> +
>> +     pdata = adc_bat->pdata;
>> +     power_supply_unregister(&adc_bat->psy);
>> +
>> +     if (gpio_is_valid(pdata->gpio_charge_finished)) {
>> +             free_irq(gpio_to_irq(pdata->gpio_charge_finished), NULL);
>
> Needs adc_bat as the second agument
>
>> +             gpio_free(pdata->gpio_charge_finished);
>> +     }
>> +
>> +     for (num_chans = 0; gab_chan_name[num_chans]; num_chans++)
>
> And also here, it's not NULL terminated
>
>> +             iio_channel_release(adc_bat->channel[num_chans]);
>> +     cancel_delayed_work(&adc_bat->bat_work);
>> +     return 0;
>> +}
>> +
> [...]
>> +
>> +static struct platform_driver gab_driver = {
>> +     .driver         = {
>> +             .name   = "generic-adc-battery",
>> +             .owner  = THIS_MODULE,
>> +             .pm     = GAB_PM_OPS
>> +     },
>> +     .probe          = gab_probe,
>> +     .remove         = gab_remove,
>
> __devexit_p
>
>> +};
>> +module_platform_driver(gab_driver);
>> +
>> +MODULE_AUTHOR("anish kumar <anish198519851985@gmail.com>");
>> +MODULE_DESCRIPTION("generic battery driver using IIO");
>> +MODULE_LICENSE("GPL");
>> diff --git a/include/linux/power/generic-adc-battery.h b/include/linux/power/generic-adc-battery.h
>> new file mode 100644
>> index 0000000..8f02e9e
>> --- /dev/null
>> +++ b/include/linux/power/generic-adc-battery.h
>> @@ -0,0 +1,19 @@
>> +/*
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef GENERIC_ADC_BATTERY_H
>> +#define GENERIC_ADC_BATTERY_H
>> +
>
> Kernel doc for the struct would be nice.
>
>> +struct gab_platform_data {
>> +     struct power_supply_info battery_info;
>> +     char    *battery_name;
>
> The power_supply_info struct also has a name field, it would make sense to use it.
>
>> +     int     (*cal_charge)(long value);
>> +     int     gpio_charge_finished;
>> +     bool    gpio_inverted;
>> +     int     jitter_delay;
>> +};
>> +
>> +#endif /* GENERIC_ADC_BATTERY_H */
>
