Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab2IIJdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 05:33:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35300 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2IIJcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 05:32:24 -0400
Subject: Re: [PATCH] [RFC]power: battery: Generic battery driver using IIO
From: anish kumar <anish198519851985@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, lars@metafoo.de
In-Reply-To: <504B1941.6000708@kernel.org>
References: <1346600372-3284-1-git-send-email-anish198519851985@gmail.com>
	 <5049A7B8.506@kernel.org> <1347088218.5051.152.camel@anish-Inspiron-N5050>
	 <504B1941.6000708@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Sep 2012 15:02:09 +0530
Message-ID: <1347183129.5051.174.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-08 at 11:09 +0100, Jonathan Cameron wrote:
> On 09/08/2012 08:10 AM, anish kumar wrote:
> > Thanks for your time.
> > On Fri, 2012-09-07 at 08:52 +0100, Jonathan Cameron wrote:
> >> On 02/09/12 16:39, anish kumar wrote:
> >>> From: anish kumar <anish198519851985@gmail.com>
> >>>
> >>> This patch is to use IIO to write a generic batttery driver.
> >> battery
> >>> There are some inherent assumptions here:
> >>> 1.User is having both main battery and backup battery.
> >> Seems rather like that could be easily enough relaxed or configured via
> >> platform data?
> > Yes
> >>> 2.Both batteries use same channel to get the information.
> >> Do you mean same actual channel (physical pin) or same ADC
> >> (with appropriate mux etc)?
> > As lars pointed out it would be better if we have multiple channels
> > per battery.The channel what I am referring here is the name of 
> > different channels which will be exported by adc driver to get
> > voltage, current and power.
> 
> I agree entirely with what Lars-Peter said.  A separate instance of
> the driver per battery will make life much cleaner and allow as you
> say for separate channels for voltage, current and power for each one.
> I guess it may be a case of trying to get each one for every battery
> and continue with whatever turns out to be available.
> 
> >>>
> >> Mostly fine. There are a few corners I didn't understand as I don't
> >> have time to dive into the battery framework in the near future. Will 
> >> leave it up to those more familiar with that side of things!
> >>
> >> My only real issue is that it would be cleaner to do the individual
> >> channels by name rather than a get all as you 'know' here how many
> >> channels are expected.
> > agreed.
> >>
> >> Also don't release the IIO channels until you are actually finished
> >> using them as holding them should prevent the ADC module from going away
> >> underneath you (which is nasty :)
> > agreed.
> >>
> >> Sorry it took so long to get back to you on this.
> > That is the biggest advantage of working in open-source.
> > We can take our own time.
> :)
> >>
> >> So what happened in 1985?
> > Was hurrying to get an email id :)
> And there I was imagining a magical significance to it....
> 
> >>
> >> Jonathan
> >>> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> >>> ---
> >>>   drivers/power/Kconfig                 |    8 +
> >>>   drivers/power/Makefile                |    1 +
> >>>   drivers/power/generic-battery.c       |  374 +++++++++++++++++++++++++++++++++
> >>>   include/linux/power/generic-battery.h |   26 +++
> >>>   4 files changed, 409 insertions(+), 0 deletions(-)
> >>>   create mode 100644 drivers/power/generic-battery.c
> >>>   create mode 100644 include/linux/power/generic-battery.h
> >>>
> >>> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> >>> index fcc1bb0..546e86b 100644
> >>> --- a/drivers/power/Kconfig
> >>> +++ b/drivers/power/Kconfig
> >>> @@ -309,6 +309,14 @@ config AB8500_BATTERY_THERM_ON_BATCTRL
> >>>   	help
> >>>   	  Say Y to enable battery temperature measurements using
> >>>   	  thermistor connected on BATCTRL ADC.
> >>> +
> >>> +config GENERIC_BATTERY
> >>> +	tristate "Generic battery support using IIO"
> >>> +	depends on IIO
> >>> +	help
> >>> +	  Say Y here to enable support for the generic battery driver
> >>> +	  which uses IIO framework to read adc for it's main and backup
> >> ADC
> >>> +	  battery.
> >>>   endif # POWER_SUPPLY
> >>>
> >>>   source "drivers/power/avs/Kconfig"
> >>> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> >>> index ee58afb..8284f9c 100644
> >>> --- a/drivers/power/Makefile
> >>> +++ b/drivers/power/Makefile
> >>> @@ -45,3 +45,4 @@ obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
> >>>   obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
> >>>   obj-$(CONFIG_POWER_AVS)		+= avs/
> >>>   obj-$(CONFIG_CHARGER_SMB347)	+= smb347-charger.o
> >>> +obj-$(CONFIG_GENERIC_BATTERY)	+= generic-battery.o
> >>> diff --git a/drivers/power/generic-battery.c b/drivers/power/generic-battery.c
> >>> new file mode 100644
> >>> index 0000000..33170b7
> >>> --- /dev/null
> >>> +++ b/drivers/power/generic-battery.c
> >>> @@ -0,0 +1,374 @@
> >>> +/*
> >>> + * Generice battery driver code using IIO
> >> Generic
> >>> + * Copyright (C) 2012, Anish Kumar <anish198519851985@gmail.com>
> >>> + * based on jz4740-battery.c
> >>> + * based on s3c_adc_battery.c
> >>> + *
> >>> + * This file is subject to the terms and conditions of the GNU General Public
> >>> + * License.  See the file COPYING in the main directory of this archive for
> >>> + * more details.
> >>> + *
> >> bonus blank line to remove
> >>> + */
> >>> +
> >>> +#include <linux/interrupt.h>
> >>> +#include <linux/platform_device.h>
> >>> +#include <linux/power_supply.h>
> >>> +#include <linux/gpio.h>
> >>> +#include <linux/err.h>
> >>> +#include <linux/timer.h>
> >>> +#include <linux/jiffies.h>
> >>> +#include <linux/errno.h>
> >>> +#include <linux/init.h>
> >>> +#include <linux/module.h>
> >>> +#include <linux/slab.h>
> >>> +#include <linux/iio/consumer.h>
> >>> +#include <linux/iio/types.h>
> >>> +
> >>> +#include <linux/power/generic-battery.h>
> >>> +
> >>> +#define BAT_POLL_INTERVAL		10000 /* ms */
> >>> +#define JITTER_DELAY			500 /* ms */
> >> Elements to make configurable?
> > Yes probably make it platform data?
> >>> +
> >>> +enum BAT {
> >>> +	MAIN_BAT = 0,
> >>> +	BACKUP_BAT,
> >>> +	BAT_MAX,
> >>> +};
> >>> +
> >> Document this please. It's not immediately obvious what
> >> channel_index is.
> > This will be removed as we will be using only one device.
> >>
> >> Why not just have a direct pointer to the correct channel?
> >>> +struct generic_adc_bat {
> >>> +	struct power_supply		psy;
> >>> +	struct iio_channel		*channels;
> >>> +	int				channel_index;
> >>> +};
> >>> +
> >>> +struct generic_bat {
> >> Spacing is a bit random in here
> >>> +	struct generic_adc_bat bat[BAT_MAX];
> >>> +	struct generic_platform_data	pdata;
> >>> +	int				volt_value;
> >>> +	int				cur_value;
> >>> +	unsigned int			timestamp;
> >>> +	int				level;
> >>> +	int				status;
> >>> +	int				cable_plugged:1;
> >>> +};
> >>> +
> >>> +static struct generic_bat generic_bat = {
> >>> +	.bat[MAIN_BAT] = {
> >>> +		.psy.name = "main-bat",
> >>> +	},
> >>> +	.bat[BACKUP_BAT] = {
> >>> +		.psy.name = "backup-bat",
> >>> +	},
> >>> +};
> >>> +
> >>> +static struct delayed_work bat_work;
> >>> +
> >>> +static void generic_adc_bat_ext_power_changed(struct power_supply *psy)
> >>> +{
> >>> +	schedule_delayed_work(&bat_work,
> >>> +			msecs_to_jiffies(JITTER_DELAY));
> >>> +}
> >>> +
> >>> +static enum power_supply_property generic_adc_main_bat_props[] = {
> >>> +	POWER_SUPPLY_PROP_STATUS,
> >>> +	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
> >>> +	POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN,
> >>> +	POWER_SUPPLY_PROP_CHARGE_NOW,
> >>> +	POWER_SUPPLY_PROP_VOLTAGE_NOW,
> >>> +	POWER_SUPPLY_PROP_CURRENT_NOW,
> >>> +	POWER_SUPPLY_PROP_TECHNOLOGY,
> >>> +	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
> >>> +	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
> >>> +	POWER_SUPPLY_PROP_MODEL_NAME,
> >>> +};
> >>> +
> >>> +static int charge_finished(struct generic_bat *bat)
> >>> +{
> >>> +	return bat->pdata.gpio_inverted ?
> >>> +		!gpio_get_value(bat->pdata.gpio_charge_finished) :
> >>> +		gpio_get_value(bat->pdata.gpio_charge_finished);
> >>> +}
> >>> +
> >>> +static int generic_adc_bat_get_property(struct power_supply *psy,
> >>> +		enum power_supply_property psp,
> >>> +		union power_supply_propval *val)
> >>> +{
> >>> +	struct generic_adc_bat *adc_bat;
> >>> +	struct generic_bat *bat;
> >>> +	int ret, scaleint, scalepart, iio_val;
> >>> +	long result = 0;
> >>> +
> >>> +	if (!strcmp(psy->name, "main-battery")) {
> >>> +		adc_bat = container_of(psy,
> >>> +					struct generic_adc_bat, psy);
> >> This first statement is I think shared so move it out of the if / else
> > This whole logic will change as we will be using only one device and
> > if has user has multiple batteries then he can register multiple
> > devices.
> Yes, much cleaner that way.
> >>
> >>> +		bat = container_of(adc_bat,
> >>> +				struct generic_bat, bat[MAIN_BAT]);
> >>> +	} else if (!strcmp(psy->name, "backup-battery")) {
> >>> +		adc_bat = container_of(psy, struct generic_adc_bat, psy);
> >>> +		bat = container_of(adc_bat,
> >>> +				struct generic_bat, bat[BACKUP_BAT]);
> >>> +	} else {
> >>> +		/* Ideally this should never happen */
> >>> +		WARN_ON(1);
> >>> +		return -EINVAL;
> >>> +	}
> >>> +
> >>> +	if (!bat) {
> >> 	> +		dev_err(psy->dev, "no battery infos ?!\n");
> >>> +		return -EINVAL;
> >>> +	
> >>> +	ret = iio_read_channel_raw(&adc_bat->channels[adc_bat->channel_index],
> >>> +			&iio_val);
> >>> +	ret = iio_read_channel_scale(&adc_bat->channels[adc_bat->channel_index],
> >>> +			&scaleint, &scalepart);
> >>> +	if (ret < 0)
> >>> +		return ret;
> >>> +
> >> A quick comment here on what the battery framework is expecting vs IIO
> >> supplying would be good.  It may be that this particular output is one 
> >> that we should lift over into the core rather than end up with multiple
> >> drivers doing the same thing.
> > I think for this we need to get all the channels supported by a
> > particular adc device and once we get the information regarding the
> > channel(current/voltage/power) supported we can find out "What
> > information is exported about this channel which may include scale or
> > raw adc value".This can be used to call the corresponding API's.
> Agreed. If I'd read this far I'd never have said the same thing at the top
> of this email ;)
> >>
> >>> +	switch (ret) {
> >>> +	case IIO_VAL_INT:
> >>> +		result = iio_val * scaleint;
> >>> +		break;
> >>> +	case IIO_VAL_INT_PLUS_MICRO:
> >>> +		result = (s64)iio_val * (s64)scaleint +
> >>> +			div_s64((s64)iio_val * (s64)scalepart, 1000000LL);
> >>> +		break;
> >>> +	case IIO_VAL_INT_PLUS_NANO:
> >>> +		result = (s64)iio_val * (s64)scaleint +
> >>> +			div_s64((s64)iio_val * (s64)scalepart, 1000000000LL);
> >>> +		break;
> >>> +	}
> >>> +
> >>> +	switch (psp) {
> >>> +	case POWER_SUPPLY_PROP_STATUS:
> >>> +		if (bat->pdata.gpio_charge_finished < 0)
> >>> +			val->intval = bat->level == 100000 ?
> >>> +				POWER_SUPPLY_STATUS_FULL : bat->status;
> >>> +		else
> >>> +			val->intval = bat->status;
> >>> +		return 0;
> >>> +	case POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN:
> >>> +		val->intval = 0;
> >>> +		return 0;
> >>> +	case POWER_SUPPLY_PROP_CHARGE_NOW:
> >>> +		val->intval = bat->pdata.cal_charge(result);
> >>> +		return 0;
> >>> +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> >>> +		val->intval = result;
> >>> +		return 0;
> >>> +	case POWER_SUPPLY_PROP_CURRENT_NOW:
> >>> +		val->intval = result;
> >>> +		return 0;
> >> why return from these and break from the later ones (to return much the 
> >> same I think...)?
> > my mistake.
> >>> +	case POWER_SUPPLY_PROP_TECHNOLOGY:
> >>> +		val->intval = bat->pdata.battery_info.technology;
> >>> +		break;
> >>> +	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
> >>> +		val->intval = bat->pdata.battery_info.voltage_min_design;
> >>> +		break;
> >>> +	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
> >>> +		val->intval = bat->pdata.battery_info.voltage_max_design;
> >>> +		break;
> >>> +	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
> >>> +		val->intval = bat->pdata.battery_info.charge_full_design;
> >>> +		break;
> >>> +	case POWER_SUPPLY_PROP_MODEL_NAME:
> >>> +		val->strval = bat->pdata.battery_info.name;
> >>> +		break;
> >>> +	default:
> >>> +		return -EINVAL;
> >>> +	}
> >>> +	return ret;
> >>> +}
> >>> +
> >>> +static void generic_adc_bat_work(struct work_struct *work)
> >>> +{
> >>> +	struct generic_bat *bat = &generic_bat;
> >>> +	int is_charged;
> >>> +	int is_plugged;
> >>> +	static int was_plugged;
> >> That's nasty. Prevents even the theoretical posibility of multiple 
> >> copies of the driver. That should be in the device specific data.
> > yes should be part of device specific data.
> >>> +
> >>> +	/* backup battery doesn't have current monitoring capability anyway */
> >> Always or in this particular configuration?
> > I was told by Anton Vorontsov.Anyway now this driver will be per device
> > so shouldn't matter.
> Maybe one day people will stick enough batteries on my phone for it to last
> one whole day ;)
> >>
> >>> +	is_plugged = power_supply_am_i_supplied(&bat->bat[MAIN_BAT].psy);
> >>> +	bat->cable_plugged = is_plugged;
> >>> +	if (is_plugged != was_plugged) {
> >>> +		was_plugged = is_plugged;
> >>> +		if (is_plugged)
> >>> +			bat->status = POWER_SUPPLY_STATUS_CHARGING;
> >>> +		else
> >>> +			bat->status = POWER_SUPPLY_STATUS_DISCHARGING;
> >>> +	} else {
> >>> +		if ((bat->pdata.gpio_charge_finished >= 0) && is_plugged) {
> >>> +			is_charged = charge_finished(&generic_bat);
> >>> +			if (is_charged)
> >>> +				bat->status = POWER_SUPPLY_STATUS_FULL;
> >>> +			else
> >>> +				bat->status = POWER_SUPPLY_STATUS_CHARGING;
> >>> +		}
> >>> +	}
> >>> +
> >>> +	power_supply_changed(&bat->bat[MAIN_BAT].psy);
> >>> +}
> >>> +
> >>> +static irqreturn_t generic_adc_bat_charged(int irq, void *dev_id)
> >>> +{
> >>> +	schedule_delayed_work(&bat_work,
> >>> +			msecs_to_jiffies(JITTER_DELAY));
> >>> +	return IRQ_HANDLED;
> >>> +}
> >>> +
> >>> +static int __devinit generic_adc_bat_probe(struct platform_device *pdev)
> >>> +{
> >>> +	struct generic_platform_data *pdata = pdev->dev.platform_data;
> >>> +	struct iio_channel *channels;
> >>> +	int num_channels = 0;
> >>> +	int ret, i, j, k = 0;
> >>> +	enum iio_chan_type type;
> >>> +
> >>> +	for (i = 0; i < ARRAY_SIZE(generic_bat.bat); i++) {
> >>> +		generic_bat.bat[i].psy.type = POWER_SUPPLY_TYPE_BATTERY;
> >>> +		generic_bat.bat[i].psy.properties =
> >>> +					generic_adc_main_bat_props;
> >>> +		generic_bat.bat[i].psy.num_properties =
> >>> +					ARRAY_SIZE(generic_adc_main_bat_props);
> >>> +		generic_bat.bat[i].psy.get_property =
> >>> +					generic_adc_bat_get_property;
> >>> +		generic_bat.bat[i].psy.external_power_changed =
> >>> +					generic_adc_bat_ext_power_changed;
> >> Could you do this with a static const array?  Looks like there is 
> >> nothing dynamic in here and that would make for cleaner code to read. 
> >> Given other elements of psy are clearly dynamic (dev pointer) you will 
> >> have to memcpy the static version in which is tedious. Still easier
> >> to read though in my view.
> >>> +	}
> > right.
> >>> +
> >>> +	generic_bat.volt_value = -1;
> >>> +	generic_bat.cur_value = -1;
> >>> +	generic_bat.cable_plugged = 0;
> >>> +	generic_bat.status = POWER_SUPPLY_STATUS_DISCHARGING;
> >>> +
> >>> +	memcpy(&generic_bat.pdata, pdata, sizeof(struct generic_platform_data));
> >>> +
> >> Is there anything dynamic in the pdata?  If not it would be cleaner just 
> >> to use a pointer to it rather than make a copy (I can't immediately spot 
> >> anything but them I'm not familiar with the battery
> >> side of things.
> > We can just assign it to generic_bat so that it can be used in the
> > relevant functions.Otherwise we need to use dev_set_drvdata and
> > dev_get_drvdata. 
> >>> +	for (i = 0; i < ARRAY_SIZE(generic_bat.bat); i++) {
> >>> +		ret = power_supply_register(&pdev->dev,
> >>> +				&generic_bat.bat[i].psy);
> >>> +		if (ret)
> >>> +			goto err_reg_main;
> >>> +	}
> >>> +
> >>> +	channels = iio_channel_get_all(dev_name(&pdev->dev));
> >> I would give these explicit names and get the two individual channels by 
> >> name. I think it will give you cleaner code.
> > Yes, now it will be based on pdata->voltage_channel,
> > pdata->current_channel and so on.We will use this to get the channel.
> Maybe better to just do this via the iio_map structures in the platform data
> and standard naming for each channel.
> 
> "voltage", "current", "power" would do nicely. Note we'll have to add the
> relevant naming for the other side to more IIO device drivers via the
> 'datasheet_name' element of iio_chan_spec.   A quick grep shows this
> is only done in drivers/staging/iio/max1363_core.c so far (bet you can't
> guess what is soldered to my test board :)
Sorry I couldn't understand this but this is what I came up with.Hope it
doesn't disappoint.
It has the advantage of getting extended easily.

enum chan_type{
        VOLTAGE,
        CURRENT,
        POWER,
        MAX_TYPE
};

struct channel_map {
        struct iio_map channel;
        enum chan_type type;
};

struct iio_battery_platform_data {
        struct power_supply_info battery_info;
        struct channel_map *map;
        int     num_map;
        char    battery_name[BAT_MAX_NAME];
        int     (*cal_charge)(long);
        int     gpio_charge_finished;
        int     gpio_inverted;
        int     bat_poll_interval;
        int     jitter_delay;
};

here goes the assignment:
for(i = 0; i < pdata->num_map; i++) {
        switch(pdata->map[i].type)
        case VOLTAGE:
                adc_bat->channel[VOLTAGE] = 
                 iio_channel_get(
                        pdata->map[i].channel.consumer_dev_name,
                        pdata->map[i].channel.adc_channel_label);
                adc_bat->chan_index = 1 << VOLTAGE;
                break;  
        case CURRENT:
                adc_bat->channel[CURRENT] =
                iio_channel_get(
                        pdata->map->channel->consumer_dev_name,
                        pdata->map[i].channel.adc_channel_label);
                adc_bat->chan_index = 1 << CURRENT;
                break;  
        case POWER:
                adc_bat->channel[POWER] =
                iio_channel_get(
                        pdata->map[i].channel.consumer_dev_name,
                        pdata->map[i].channel.adc_channel_label);
                adc_bat->chan_index = 1 << POWER;
                break;  
        default:
                pr_info("add any other channels here in the case\n");
}

With the chan_index we can know which property is set or every time we
need to run through pdata->map[i].type to know the property set.
> 
> >>> +	if (IS_ERR(channels)) {
> >>> +		ret = PTR_ERR(channels);
> >>> +		goto err_reg_backup;
> >>> +	}
> >>> +
> >>> +	while (channels[num_channels].indio_dev)
> >>> +		num_channels++;
> >>> +
> >>> +	for (i = 0; i < ARRAY_SIZE(generic_bat.bat); i++)
> >>> +		generic_bat.bat[i].channels = kzalloc(sizeof(struct iio_channel)
> >>> +							* BAT_MAX, GFP_KERNEL);
> >>> +
> >>> +	/* assuming main battery and backup battery is using the same channel */
> >>> +	for (i = 0; i < num_channels; i++) {
> >>> +		ret = iio_get_channel_type(&channels[i], &type);
> >> Using named channels you should 'know' you have the correct type.  You 
> >> can of course check if you don't trust your platform data though!
> > right.
> >>> +		if (ret < 0)
> >>> +			goto err_gpio;
> >>> +
> >>> +		if (type == IIO_VOLTAGE || type == IIO_CURRENT) {
> >>> +			for (j = 0; j < BAT_MAX; j++) {
> >>> +				generic_bat.bat[j].channel_index = k;
> >>> +				generic_bat.bat[j].channels[k] = channels[i];
> >>> +			}
> >>> +			k++;
> >>> +		}
> >>> +		continue;
> >>> +	}
> >>> +
> >>> +	INIT_DELAYED_WORK(&bat_work, generic_adc_bat_work);
> >>> +
> >>> +	if (pdata->gpio_charge_finished >= 0) {
> >>> +		ret = gpio_request(pdata->gpio_charge_finished, "charged");
> >>> +		if (ret)
> >>> +			goto err_gpio;
> >>> +
> >>> +		ret = request_irq(gpio_to_irq(pdata->gpio_charge_finished),
> >>> +				generic_adc_bat_charged,
> >>> +				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
> >>> +				"battery charged", NULL);
> >>> +		if (ret)
> >>> +			goto err_gpio;
> >>> +	}
> >>> +
> >>> +	dev_info(&pdev->dev, "successfully loaded\n");
> >>> +
> >>> +	/* Schedule timer to check current status */
> >>> +	schedule_delayed_work(&bat_work,
> >>> +			msecs_to_jiffies(JITTER_DELAY));
> >>> +
> >>> +	iio_channel_release_all(channels);
> >> Not if you want to prevent the adc driver from being removed from under 
> >> you.  They should only be released in the driver removal.
> > right.
> >>> +
> >>> +	return 0;
> >>> +
> >>> +err_gpio:
> >>> +	iio_channel_release_all(channels);
> >>> +err_reg_backup:
> >>> +	for (i = 0; i < ARRAY_SIZE(generic_bat.bat); i++)
> >>> +		power_supply_unregister(&generic_bat.bat[i].psy);
> >>> +err_reg_main:
> >>> +	return ret;
> >>> +}
> >>> +
> >>> +static int generic_adc_bat_remove(struct platform_device *pdev)
> >>> +{
> >>> +	int i;
> >>> +	struct generic_platform_data *pdata = pdev->dev.platform_data;
> >>> +
> >>> +	for (i = 0; i < ARRAY_SIZE(generic_bat.bat); i++)
> >>> +		power_supply_unregister(&generic_bat.bat[i].psy);
> >>
> >> You should release the IIO channels here when they are no longer needed.
> > right.
> >>> +
> >>> +	if (pdata->gpio_charge_finished >= 0) {
> >> I forget, is a gpio index of 0 definitely invalid?
> >>> +		free_irq(gpio_to_irq(pdata->gpio_charge_finished), NULL);
> >>> +		gpio_free(pdata->gpio_charge_finished);
> >>> +	}
> >>> +
> >>> +	cancel_delayed_work(&bat_work);
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +#ifdef CONFIG_PM
> >>> +static int generic_adc_bat_suspend(struct platform_device *pdev,
> >>> +		pm_message_t state)
> >>> +{
> >>> +	struct generic_platform_data *pdata = pdev->dev.platform_data;
> >>> +	struct generic_bat *bat = container_of(pdata,
> >>> +					struct generic_bat, pdata);
> >>> +
> >>> +	cancel_delayed_work_sync(&bat_work);
> >>> +	bat->status = POWER_SUPPLY_STATUS_UNKNOWN;
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static int generic_adc_bat_resume(struct platform_device *pdev)
> >>> +{
> >>> +	/* Schedule timer to check current status */
> >>> +	schedule_delayed_work(&bat_work,
> >>> +			msecs_to_jiffies(JITTER_DELAY));
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +#else
> >>> +#define generic_adc_bat_suspend NULL
> >>> +#define generic_adc_bat_resume NULL
> >>> +#endif
> >>> +
> >>> +static struct platform_driver generic_adc_bat_driver = {
> >>> +	.driver		= {
> >>> +		.name	= "generic-adc-battery",
> >>> +	},
> >>> +	.probe		= generic_adc_bat_probe,
> >>> +	.remove		= generic_adc_bat_remove,
> >>> +	.suspend	= generic_adc_bat_suspend,
> >>> +	.resume		= generic_adc_bat_resume,
> >>> +};
> >>> +
> >>> +module_platform_driver(generic_adc_bat_driver);
> >>> +
> >>> +MODULE_AUTHOR("anish kumar <anish198519851985@gmail.com>");
> >>> +MODULE_DESCRIPTION("generic battery driver using IIO");
> >>> +MODULE_LICENSE("GPL");
> >>> diff --git a/include/linux/power/generic-battery.h b/include/linux/power/generic-battery.h
> >>> new file mode 100644
> >>> index 0000000..7a43aa0
> >>> --- /dev/null
> >>> +++ b/include/linux/power/generic-battery.h
> >>> @@ -0,0 +1,26 @@
> >>> +/*
> >>> + * This program is free software; you can redistribute it and/or modify
> >>> + * it under the terms of the GNU General Public License version 2 as
> >>> + * published by the Free Software Foundation.
> >>> + */
> >>> +
> >>> +#ifndef GENERIC_BATTERY_H
> >>> +#define GENERIC_BATTERY_H
> >>> +
> >>> +#include <linux/power_supply.h>
> >>> +
> >>> +/**
> >>> + * struct generic_platform_data - platform data for generic battery
> >> A little inconsistent on capitalization.  (might as well do it now or
> >> one of those people who delight in trivial patches will 'tidy' it
> >> up for you :)
> > I don't mind as it is a good start for people to get familiar with the 
> > linux patch process.
> Can tell you don't get to deal with the tedious merge conflicts that result ;)
> 
> > However I will address this valuable comments.
> >>> + * @battery_info: Information about the battery
> >>> + * @cal_charge: platform callback to calculate charge
> >>> + * @gpio_charge_finished: GPIO number used for interrupts
> >>> + * @gpio_inverted: Is the gpio inverted?
> >>> + */
> >>> +struct generic_platform_data {
> >>> +	struct power_supply_info battery_info;
> >>> +	int	(*cal_charge)(long);
> >>> +	int	gpio_charge_finished;
> >>> +	int	gpio_inverted;
> >>> +};
> >>> +
> >>> +#endif /* GENERIC_BATTERY_H */
> >>>
> >>
> > 
> > 


