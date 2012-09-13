Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab2IMXxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:53:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33629 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759110Ab2IMXsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:48:50 -0400
Date: Thu, 13 Sep 2012 16:46:14 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: anish kumar <anish198519851985@gmail.com>
Cc: lars@metafoo.de, jic23@cam.ac.uk, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH] power: battery: Generic battery driver using IIO
Message-ID: <20120913234613.GA12943@lizard>
References: <1347552992-13836-1-git-send-email-anish198519851985@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1347552992-13836-1-git-send-email-anish198519851985@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 09:46:32PM +0530, anish kumar wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 
> In this version:
> Addressed concerns raised by lars:
> a. made the adc_bat per device.
> b. get the IIO channel using hardcoded channel names.
> c. Minor issues related to gpio_is_valid and some code
>    refactoring.
> 
> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> ---

Anish, much thanks for your work! This is much appreciated.

There are a few comments below, they don't require any design
changes, just some technical issues, which wouldn't hard to fix,
I guess.

And again, thanks for your efforts!

>  drivers/power/generic-adc-battery.c       |  460 +++++++++++++++++++++++++++++
>  include/linux/power/generic-adc-battery.h |   33 ++
>  2 files changed, 493 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/power/generic-adc-battery.c
>  create mode 100644 include/linux/power/generic-adc-battery.h
> 
> diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
> new file mode 100644
> index 0000000..003e0e1
> --- /dev/null
> +++ b/drivers/power/generic-adc-battery.c
> @@ -0,0 +1,460 @@
> +/*
> + * Generic battery driver code using IIO
> + * Copyright (C) 2012, Anish Kumar <anish198519851985@gmail.com>
> + * based on jz4740-battery.c
> + * based on s3c_adc_battery.c
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file COPYING in the main directory of this archive for
> + * more details.
> + *

No need for this empty comment line.

> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/power_supply.h>
> +#include <linux/gpio.h>
> +#include <linux/err.h>
> +#include <linux/timer.h>
> +#include <linux/jiffies.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/iio/consumer.h>
> +#include <linux/iio/types.h>
> +

No need for this empty line.

> +#include <linux/power/generic-adc-battery.h>
> +
> +#define to_generic_bat(ptr)	\
> +	container_of(ptr, struct generic_adc_bat, ptr)

This will fit on one line.

Plus, it look strange that you use 'struct generic_adc_bat' before
actually declaring it. :-) Surely it works because it's a macro.

Also, while this is a simple one-liner, I'd really suggest making
it a function. That way you also won't have a risk to evaluate
'ptr' expression twice, plus the function is type-safe (unlike
the macro).

> +
> +enum chan_type {
> +	VOLTAGE = 0,
> +	CURRENT,
> +	POWER,
> +	MAX_CHAN_TYPE

The enum is in the global namespace. Please prefix items with
GEN_ADC_BAT (or GENERIC_ADC_BAT, but that would be too long).

Personally, I like making acronyms. I.e., while file name already
makes it pretty clear that it is generic_adc_battery, in the file
itself you can use short gab_ and GAB_ everywhere.

Anyways, it's up to you. generic_adc_bat_ prefix is also fine. But
be consistent.

The same with chan_type, please prefix it with something.

> +};
> +
> +#define CHAN_MAX_NAME 30
> +/*
> + * channel_name suggests the standard channel names for commonly used
> + * channel types.
> + */
> +char channel_name[][CHAN_MAX_NAME + 1] = {

Ditto. gab_channel_name.

Plus, you can make it char *gab_channel_name[] = {
	[VOLTAGE] = "voltage",
	[...] = ...,
};

Thus no need for MAX_NAME.

> +	[VOLTAGE]	= "voltage",
> +	[CURRENT]	= "current",
> +	[POWER]		= "power",
> +};
> +
> +struct generic_adc_bat {
> +	struct power_supply	psy;
> +	struct iio_channel	**channel;
> +	struct iio_battery_platform_data	*pdata;
> +	struct delayed_work bat_work;
> +	int		was_plugged;
> +	int		volt_value;
> +	int		cur_value;
> +	int		level;
> +	int		status;
> +	int		cable_plugged:1;
> +};
> +
> +static void generic_adc_bat_ext_power_changed(struct power_supply *psy)
> +{
> +	struct generic_adc_bat *adc_bat;
> +	adc_bat = to_generic_bat(psy);

This would fit into one line.

> +
> +	schedule_delayed_work(&adc_bat->bat_work,
> +			msecs_to_jiffies(adc_bat->pdata->jitter_delay));
> +}
> +
> +static enum power_supply_property bat_props[] = {

While it's static, it still looks awkward that you don't prefix it.

> +	POWER_SUPPLY_PROP_STATUS,
> +	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
> +	POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN,
> +	POWER_SUPPLY_PROP_CHARGE_NOW,
> +	POWER_SUPPLY_PROP_VOLTAGE_NOW,
> +	POWER_SUPPLY_PROP_CURRENT_NOW,
> +	POWER_SUPPLY_PROP_TECHNOLOGY,
> +	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
> +	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
> +	POWER_SUPPLY_PROP_MODEL_NAME,
> +};
> +
> +/*
> + * This properties are set based on the received platform data and this
> + * should correspond one-to-one with enum chan_type.
> + */
> +static enum power_supply_property dyn_props[] = {
> +	POWER_SUPPLY_PROP_VOLTAGE_NOW,
> +	POWER_SUPPLY_PROP_CURRENT_NOW,
> +	POWER_SUPPLY_PROP_POWER_NOW,
> +};
> +
> +static int charge_finished(struct generic_adc_bat *adc_bat)
> +{
> +	return adc_bat->pdata->gpio_inverted ?
> +		!gpio_get_value(adc_bat->pdata->gpio_charge_finished) :
> +		gpio_get_value(adc_bat->pdata->gpio_charge_finished);

That looks unreadable.

How about:

bool ret = gpio_get_value(adc_bat->pdata->gpio_charge_finished);
bool inv = adc_bat->pdata->gpio_inverted;

return ret ^ inv;

(you can also make gpio_inverted bool, as well as return value of
charge_finished function)

> +}
> +
> +long read_scale_channel(struct generic_adc_bat *adc_bat,
> +			enum power_supply_property psp)

static? prefix?

> +{
> +	int scaleint, scalepart, iio_val, ret = 0;

One variable declaration per line, please.

int scaleint;
int scalepart;
etc.

> +	int result = 0;
> +
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_POWER_NOW:
> +		ret = iio_read_channel_raw(adc_bat->channel[POWER],
> +				&iio_val);

you don't use this return value, why assign?

Also, this is very repeated.

How about introducing a function
int gab_read_chan(enum gab_chan, int *val, int *scaleint, int *scalepart)
{
	int ret;

	ret = iio_read_channel_raw(chan, val);
	if (ret < 0)
		return ret;

	ret = iio_read_channel_scale(chan, scaleint, scalepart);
	if (ret < 0)
		return ret;

	return 0;
}

Then you'll have

switch (psp) {
	case POWER_SUPPLY_PROP_POWER_NOW:
		ret = gab_read_chan(adc_bat->channel[POWER],
				    &iio_val, &scaleint, &scalepart);
		break;
	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
		ret = gab_read_chan(adc_bat->channel[VOLTAGE],
				    &iio_val, &scaleint, &scalepart);
		break;
	....
}

if (ret < 0)
	return ret;

It is easily noticed that this is quite repeating too.

So we can do better, let's introduce property-to-channel function:

enum gab_chan gab_prop_to_chan(enum power_supply_property psp)
{
	switch (psp) {
	case POWER_SUPPLY_PROP_POWER_NOW:
		return GAB_POWER;
	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
		return GAB_VOLTAGE;
	....
	}
	WARN_ON(1);
	return GAB_POWER;
}


And then we can just do this:

enum gab_chan chan = gab_prop_to_chan(psp);

ret = gab_read_chan(chan, &iio_val, &scaleint, &scalepart);
if (ret < 0)
	return 0;

Which is much nicer. :-)

> +		ret = iio_read_channel_scale(adc_bat->channel[POWER],
> +				&scaleint, &scalepart);
> +		if (ret < 0)
> +			return ret;
> +		break;
> +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> +		ret = iio_read_channel_raw(adc_bat->channel[VOLTAGE],
> +				&iio_val);
> +		ret = iio_read_channel_scale(adc_bat->channel[VOLTAGE],
> +				&scaleint, &scalepart);
> +		if (ret < 0)
> +			return ret;
> +		break;
> +	case POWER_SUPPLY_PROP_CURRENT_NOW:
> +		ret = iio_read_channel_raw(adc_bat->channel[CURRENT],
> +				&iio_val);
> +		ret = iio_read_channel_scale(adc_bat->channel[CURRENT],
> +				&scaleint, &scalepart);
> +		if (ret < 0)
> +			return ret;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	switch (ret) {
> +	case IIO_VAL_INT:
> +		result = iio_val * scaleint;
> +		break;
> +	case IIO_VAL_INT_PLUS_MICRO:
> +		result = (s64)iio_val * (s64)scaleint +
> +			div_s64((s64)iio_val * (s64)scalepart, 1000000LL);
> +		break;
> +	case IIO_VAL_INT_PLUS_NANO:
> +		result = (s64)iio_val * (s64)scaleint +
> +			div_s64((s64)iio_val * (s64)scalepart, 1000000000LL);
> +		break;
> +	}
> +	return result;
> +}
> +
> +static int generic_adc_bat_get_property(struct power_supply *psy,
> +		enum power_supply_property psp,
> +		union power_supply_propval *val)
> +{
> +	struct generic_adc_bat *adc_bat;
> +	int ret = 0;
> +	long result;
> +
> +	adc_bat = to_generic_bat(psy);
> +	if (!adc_bat) {
> +		dev_err(psy->dev, "no battery infos ?!\n");
> +		return -EINVAL;
> +	}
> +
> +	result = read_scale_channel(adc_bat, psp);
> +	if (result < 0) {
> +		dev_err(psy->dev, "read channel error\n");
> +		ret =  -EINVAL;
> +		goto err;
> +	}
> +
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_STATUS:
> +		if (gpio_is_valid(adc_bat->pdata->gpio_charge_finished)) {
> +			if (adc_bat->pdata->gpio_charge_finished < 0)
> +				val->intval = adc_bat->level == 100000 ?
> +					POWER_SUPPLY_STATUS_FULL :
> +					adc_bat->status;

This is u?n(r)e:a<d?a->b=l&e. :-)

Plus, I guess there's some logic error: you check gpio_charge_finished
for gpio_is_valid, and then for it "< 0", which is always false. I
think you don't need "< 0" check.

How about a separate function for this?

I.e.

int gab_get_status(struct generic_adc_bat *gab)
{
	struct gab_platform_data *pdata = gab->pdata;
	int chg_gpio = pdata->gpio_charge_finished

	if (!gpio_is_valid(chg_gpio) || adc_bat->level < 100000)
		return adc_bat->status;

	return POWER_SUPPLY_STATUS_FULL;
}

> +			else
> +				val->intval = adc_bat->status;
> +		}
> +		break;
> +	case POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN:
> +		val->intval = 0;
> +		break;
> +	case POWER_SUPPLY_PROP_CHARGE_NOW:
> +		val->intval = adc_bat->pdata->cal_charge(result);
> +		break;
> +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> +		val->intval = result;
> +		break;
> +	case POWER_SUPPLY_PROP_CURRENT_NOW:
> +		val->intval = result;
> +		break;
> +	case POWER_SUPPLY_PROP_POWER_NOW:
> +		val->intval = result;
> +		break;
> +	case POWER_SUPPLY_PROP_TECHNOLOGY:
> +		val->intval = adc_bat->pdata->battery_info.technology;
> +		break;
> +	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
> +		val->intval = adc_bat->pdata->battery_info.voltage_min_design;

You repeat 'adc_bat->pdata->battery_info' too much. Please introduce
short a variable. I.e.

struct power_supply_info *bi = &adc_bat->pdata->battery_info;

Then you can type bi->voltage_min_design;

> +		break;
> +	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
> +		val->intval = adc_bat->pdata->battery_info.voltage_max_design;
> +		break;
> +	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
> +		val->intval = adc_bat->pdata->battery_info.charge_full_design;
> +		break;
> +	case POWER_SUPPLY_PROP_MODEL_NAME:
> +		val->strval = adc_bat->pdata->battery_info.name;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +err:
> +	return ret;
> +}
> +
> +static void generic_adc_bat_work(struct work_struct *work)
> +{
> +	struct generic_adc_bat *adc_bat;
> +	struct delayed_work *delayed_work;
> +	int is_charged;
> +	int is_plugged;
> +
> +	delayed_work = container_of(work,
> +				struct delayed_work, work);
This fits into one line.

> +	adc_bat = container_of(delayed_work,
> +				struct generic_adc_bat, bat_work);

Ditto.

> +	is_plugged = power_supply_am_i_supplied(&adc_bat->psy);
> +	adc_bat->cable_plugged = is_plugged;
> +	if (is_plugged != adc_bat->was_plugged) {
> +		adc_bat->was_plugged = is_plugged;
> +		if (is_plugged)
> +			adc_bat->status = POWER_SUPPLY_STATUS_CHARGING;
> +		else
> +			adc_bat->status = POWER_SUPPLY_STATUS_DISCHARGING;
> +	} else {
> +		if (gpio_is_valid(adc_bat->pdata->gpio_charge_finished)) {
> +			if ((adc_bat->pdata->gpio_charge_finished >= 0) &&

If you use gpio_is_valid, you don't need another >= check.

> +								is_plugged) {
> +				is_charged = charge_finished(adc_bat);
> +				if (is_charged)
> +					adc_bat->status =
> +						POWER_SUPPLY_STATUS_FULL;
> +				else
> +					adc_bat->status =
> +						POWER_SUPPLY_STATUS_CHARGING;
> +			}
> +		}
> +	}
> +
> +	power_supply_changed(&adc_bat->psy);
> +}
> +
> +static irqreturn_t generic_adc_bat_charged(int irq, void *dev_id)
> +{
> +	struct generic_adc_bat *adc_bat = dev_id;

Need an empty line here.

> +	adc_bat = container_of(&adc_bat->bat_work,
> +				struct generic_adc_bat, bat_work);

Something is seriously wrong here. You probably don't need container_of.

Plus you pass pointer-to-pointer to request_irq()... I doubt it will
work.

> +	schedule_delayed_work(&adc_bat->bat_work,
> +			msecs_to_jiffies(adc_bat->pdata->jitter_delay));
> +	return IRQ_HANDLED;
> +}
> +
> +static int __devinit generic_adc_bat_probe(struct platform_device *pdev)
> +{
> +	struct generic_adc_bat *adc_bat;
> +	struct iio_battery_platform_data *pdata = pdev->dev.platform_data;
> +	int ret, chan_index, fail = 0;

One variable per line.

int ret;
int chan_index;
...

> +
> +	adc_bat = devm_kzalloc(&pdev->dev, sizeof(*adc_bat), GFP_KERNEL);
> +	if (!adc_bat) {
> +		dev_err(&pdev->dev, "failed to allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* copying the battery name from platform data */
> +	adc_bat->psy.name = pdata->battery_name;
> +
> +	/* bootup default values for the battery */
> +	adc_bat->volt_value = -1;
> +	adc_bat->cur_value = -1;
> +	adc_bat->cable_plugged = 0;
> +	adc_bat->status = POWER_SUPPLY_STATUS_DISCHARGING;
> +	adc_bat->psy.type = POWER_SUPPLY_TYPE_BATTERY;
> +	adc_bat->psy.get_property =
> +		generic_adc_bat_get_property;
> +	adc_bat->psy.external_power_changed =
> +		generic_adc_bat_ext_power_changed;

These four lines will fit into two.

> +	adc_bat->pdata = pdata;
> +
> +	/* calculate the total number of channels */
> +	for (chan_index = 0; channel_name[chan_index]; chan_index++)
> +		;

I think you can use ARRAY_SIZE(channel_name) macro from linux/kernel.h
instead of the loop.

Plus, you should really name it num_chans.

> +
> +	if (!chan_index) {
> +		pr_err("atleast provide one channel\n");

The chan_index is calculated from the static array that never changes.
I think you don't need this check.

> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * copying the static properties and allocating extra memory for holding
> +	 * the extra configurable properties received from platform data.
> +	*/

*/ is wrongly indented.

> +	adc_bat->psy.properties = kzalloc(sizeof(bat_props)
> +					+ sizeof(int)*chan_index, GFP_KERNEL);

Instead of sizeof(int), better sizeof(*adc_bat->psy.properties).

Also, you need whitespaces around *.

And I don't see where you're filling-in num_properties. How
does it work without it?

> +	if (!adc_bat->psy.properties) {
> +		ret = -ENOMEM;
> +		goto first_mem_fail;
> +	}
> +	memcpy(adc_bat->psy.properties, bat_props, sizeof(bat_props));
> +
> +	/* allocating memory for iio channels */
> +	adc_bat->channel = kzalloc(chan_index * sizeof(struct iio_channel),
> +					GFP_KERNEL);

adc_bat->channels = kzalloc(num_chans * sizeof(*adc_bat->channels),
			    GFP_KERNEL);

Plus, I think you can use devm_kzalloc() here, and above.

> +	if (!adc_bat->channel) {
> +		ret = -ENOMEM;
> +		goto second_mem_fail;
> +	}
> +
> +	/*
> +	 * getting channel from iio and copying the battery properties
> +	 * based on the channel supported by consumer device.
> +	 */
> +	for (chan_index = 0; channel_name[chan_index]; chan_index++) {
> +		adc_bat->channel[chan_index] =
> +		iio_channel_get(dev_name(&pdev->dev),
> +			channel_name[chan_index]);
> +		/* we skip for channels which fail */
> +		if (IS_ERR(adc_bat->channel[chan_index]))
> +			fail++;
> +		else {

Need {} braces for if statement too, so it'll have to be
} else{, per coding style.

> +			static int index;

empty line here please.

> +			memcpy(adc_bat->psy.properties +
> +				sizeof(bat_props) + sizeof(int)*index,
> +				&dyn_props[chan_index],
> +				sizeof(dyn_props[chan_index]));

I'm too lazy to even think what it does... I hope it works. :-D

> +			index++;
> +		}
> +	}
> +
> +	/* none of the channels are supported so let's bail out */
> +	if (fail == chan_index) {
> +		ret = PTR_ERR(adc_bat->channel[chan_index]);
> +		goto second_mem_fail;
> +	}
> +
> +	ret = power_supply_register(&pdev->dev, &adc_bat->psy);
> +	if (ret)
> +		goto err_reg_fail;
> +
> +	INIT_DELAYED_WORK(&adc_bat->bat_work, generic_adc_bat_work);
> +
> +	if (gpio_is_valid(pdata->gpio_charge_finished)) {
> +		ret = gpio_request(pdata->gpio_charge_finished, "charged");
> +		if (ret)
> +			goto err_gpio;
> +
> +		ret = request_any_context_irq(gpio_to_irq
> +				(pdata->gpio_charge_finished),

Very unfortunate line break, at first I thought that you don't
need parenthesis, but then I noticed that it's actually a function
call. Heh. please introduce a local variable int irq; above (just
after if (gpio_is_valid)...

i.e.

int irq = gpio_to_irq(pdata->gpio_charge_finished);

ret = request_any_context_irq(irq, .....).

> +				generic_adc_bat_charged,
> +				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
> +				"battery charged", &adc_bat);

Here, &adc_bat (pointer-to-pointer) looks very wrong. Why do you do
this?

> +		if (ret)
> +			goto err_gpio;
> +	} else
> +		goto err_gpio; /* let's bail out */

} else {
	...
}

> +	platform_set_drvdata(pdev, &adc_bat);
> +
> +	/* Schedule timer to check current status */
> +	schedule_delayed_work(&adc_bat->bat_work,
> +			msecs_to_jiffies(0));
> +	return 0;
> +
> +err_gpio:
> +	power_supply_unregister(&adc_bat->psy);
> +err_reg_fail:
> +	for (chan_index = 0; channel_name[chan_index]; chan_index++)
> +		iio_channel_release(adc_bat->channel[chan_index]);
> +	kfree(adc_bat->channel);
> +second_mem_fail:
> +	kfree(adc_bat->psy.properties);
> +first_mem_fail:
> +	return ret;
> +}
> +
> +static int generic_adc_bat_remove(struct platform_device *pdev)
> +{
> +	int chan_index;
> +	struct generic_adc_bat *adc_bat = platform_get_drvdata(pdev);
> +
> +	power_supply_unregister(&adc_bat->psy);
> +
> +	if (gpio_is_valid(adc_bat->pdata->gpio_charge_finished)) {
> +		if (adc_bat->pdata->gpio_charge_finished >= 0) {

You don't need >= check. gpio_is_valid is used for this.

> +			free_irq(gpio_to_irq(
> +				adc_bat->pdata->gpio_charge_finished),
> +								NULL);

Please don't be scared to introduce temporary variables if they make
code more readable. Here, introduce 'int irq = gpio_to_irq(...)';

> +			gpio_free(adc_bat->pdata->gpio_charge_finished);
> +		}
> +	}
> +
> +	for (chan_index = 0; channel_name[chan_index]; chan_index++)
> +		iio_channel_release(adc_bat->channel[chan_index]);
> +	cancel_delayed_work(&adc_bat->bat_work);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int generic_adc_bat_suspend(struct device *dev)
> +{
> +	struct generic_adc_bat *adc_bat = dev_get_drvdata(dev);
> +
> +	cancel_delayed_work_sync(&adc_bat->bat_work);
> +	adc_bat->status = POWER_SUPPLY_STATUS_UNKNOWN;
> +	return 0;
> +}
> +
> +static int generic_adc_bat_resume(struct device *dev)
> +{
> +	struct generic_adc_bat *adc_bat = dev_get_drvdata(dev);
> +
> +	/* Schedule timer to check current status */
> +	schedule_delayed_work(&adc_bat->bat_work,
> +			msecs_to_jiffies(adc_bat->pdata->jitter_delay));
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops generic_adc_battery_pm_ops = {
> +	.suspend        = generic_adc_bat_suspend,
> +	.resume         = generic_adc_bat_resume,
> +};
> +
> +#define GENERIC_ADC_BATTERY_PM_OPS       (&generic_adc_battery_pm_ops)
> +#else
> +#define GENERIC_ADC_BATTERY_PM_OPS       (NULL)
> +#endif
> +
> +static struct platform_driver generic_adc_bat_driver = {
> +	.driver		= {
> +		.name	= "generic-adc-battery",
> +		.owner	= THIS_MODULE,
> +		.pm	= GENERIC_ADC_BATTERY_PM_OPS
> +	},
> +	.probe		= generic_adc_bat_probe,
> +	.remove		= generic_adc_bat_remove,
> +};
> +

No need for this empty line.

> +module_platform_driver(generic_adc_bat_driver);
> +
> +MODULE_AUTHOR("anish kumar <anish198519851985@gmail.com>");
> +MODULE_DESCRIPTION("generic battery driver using IIO");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/power/generic-adc-battery.h b/include/linux/power/generic-adc-battery.h
> new file mode 100644
> index 0000000..d7c6d20
> --- /dev/null
> +++ b/include/linux/power/generic-adc-battery.h
> @@ -0,0 +1,33 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef GENERIC_ADC_BATTERY_H
> +#define GENERIC_ADC_BATTERY_H
> +
> +/* should be enough for the channel names */
> +#define BAT_MAX_NAME	30
> +
> +enum chan_type {
> +	VOLTAGE = 0,
> +	CURRENT,
> +	POWER,
> +	MAX_CHAN_TYPE
> +};

You define chan_type twice. Keep only one declaration, this one,
in the header file.

> +
> +extern char channel_name[][BAT_MAX_NAME + 1];

Uhm. Making it extern means that you're no longer able to use
this driver as a module. And the module isn't a problem per se,
it just a sign of some bigger problem... Maybe you should rethink
how you pass channel name, dunno.

> +struct iio_battery_platform_data {

Inconsistent. Either use generic_adc_battery_ prefix, or
iio_battery_, or anything you like, but please be consistent across
all the driver and files.

> +	struct power_supply_info battery_info;
> +	char	**channel_name;
> +	char	*battery_name;
> +	int	(*cal_charge)(long);

Long what? :-) Please specify a variable name.

> +	int	gpio_charge_finished;
> +	int	gpio_inverted;
> +	int	bat_poll_interval;
> +	int	jitter_delay;
> +};
> +
> +#endif /* GENERIC_ADC_BATTERY_H */

Cheers,
Anton.
