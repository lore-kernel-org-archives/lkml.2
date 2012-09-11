Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab2IKJ7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:59:24 -0400
Received: from smtp-out-025.synserver.de ([212.40.185.25]:1301 "EHLO
	smtp-out-025.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab2IKJ7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:59:22 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 6540
Message-ID: <504F0B9B.2050504@metafoo.de>
Date: Tue, 11 Sep 2012 11:59:55 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: anish kumar <anish198519851985@gmail.com>
CC: jic23@cam.ac.uk, cbou@mail.ru, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH] [RFC]power: battery: Generic battery driver using IIO
References: <1347291621-8530-1-git-send-email-anish198519851985@gmail.com>
In-Reply-To: <1347291621-8530-1-git-send-email-anish198519851985@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 05:40 PM, anish kumar wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 
> This is the cleaned up code after the valuable inputs from
> the Jonathan, Lars and Anton.
> 
> I have tried to accomodate all the concerns however please
> let me know incase something is missed out.
> 
> Signed-off-by: anish kumar <anish198519851985@gmail.com>

Hi,


> ---
>  drivers/power/generic-adc-battery.c       |  431 +++++++++++++++++++++++++++++
>  include/linux/power/generic-adc-battery.h |   33 +++
>  2 files changed, 464 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/power/generic-adc-battery.c
>  create mode 100644 include/linux/power/generic-adc-battery.h
> 
> diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
> new file mode 100644
> index 0000000..3459740
> --- /dev/null
> +++ b/drivers/power/generic-adc-battery.c
> @@ -0,0 +1,431 @@
[...]
> +
> +static int generic_adc_bat_get_property(struct power_supply *psy,
> +		enum power_supply_property psp,
> +		union power_supply_propval *val)
> +{
> +	struct generic_adc_bat *adc_bat;
> +	int scaleint, scalepart, iio_val, ret = 0;
> +	long result = 0;
> +
> +	adc_bat = to_generic_bat(psy);
> +	if (!adc_bat) {
> +		dev_err(psy->dev, "no battery infos ?!\n");
> +		return -EINVAL;
> +	}
> +
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_POWER_NOW:
> +		ret = iio_read_channel_raw(adc_bat->channel[POWER],
> +				&iio_val);
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

I think it's a good idea to factor the channel reading and scale conversion
out into a helper function.

> +
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_STATUS:
> +		if (adc_bat->pdata.gpio_charge_finished < 0)

gpio_is_valid

> +			val->intval = adc_bat->level == 100000 ?
> +				POWER_SUPPLY_STATUS_FULL : adc_bat->status;
> +		else
> +			val->intval = adc_bat->status;
> +		break;
[...]
> +	return ret;
> +}
> +

[...]

> +static void generic_adc_bat_work(struct work_struct *work)
> +{
> +	struct generic_adc_bat *adc_bat;
> +	struct delayed_work *delayed_work;
> +	int is_charged;
> +	int is_plugged;
> +
> +	delayed_work = container_of(work,
> +				struct delayed_work, work);
> +	adc_bat = container_of(delayed_work,
> +				struct generic_adc_bat, bat_work);
> +
> +	/* backup battery doesn't have current monitoring capability anyway */
> +	is_plugged = power_supply_am_i_supplied(&adc_bat->psy);
> +	adc_bat->cable_plugged = is_plugged;
> +	if (is_plugged != adc_bat->was_plugged) {
> +		adc_bat->was_plugged = is_plugged;
> +		if (is_plugged)
> +			adc_bat->status = POWER_SUPPLY_STATUS_CHARGING;
> +		else
> +			adc_bat->status = POWER_SUPPLY_STATUS_DISCHARGING;
> +	} else {
> +		if ((adc_bat->pdata.gpio_charge_finished >= 0) && is_plugged) {

gpio_is_valid

> +			is_charged = charge_finished(adc_bat);
> +			if (is_charged)
> +				adc_bat->status = POWER_SUPPLY_STATUS_FULL;
> +			else
> +				adc_bat->status = POWER_SUPPLY_STATUS_CHARGING;
> +		}
> +	}
> +
> +	power_supply_changed(&adc_bat->psy);
> +}

[...]

> +
> +/* 
> + * compare the pdata->channel names with the predefined channels and
> + * returns the index of the channel in channel_name array or -1 in the
> + * case of not-found.
> + */
> +int channel_cmp(char *name)
> +{
> +	if (!strcmp(name, channel_name[VOLTAGE]))
> +		return VOLTAGE;
> +	else if (!strcmp(name, channel_name[CURRENT]))
> +		return CURRENT;
> +	else if (!strcmp(name, channel_name[POWER]))
> +		return POWER;
> +	else
> +		return -1;
> +}
> +
> +static int __devinit generic_adc_bat_probe(struct platform_device *pdev)
> +{
> +	struct iio_battery_platform_data *pdata = pdev->dev.platform_data;
> +	int ret, chan_index;
> +
> +	/* copying the battery name from platform data */
> +	adc_bat.psy.name = pdata->battery_name;

You should make a per device copy of adc_bat, otherwise there can only be
one device at a time.

> +
> +	/* bootup default values for the battery */
> +	adc_bat.volt_value = -1;
> +	adc_bat.cur_value = -1;
> +	adc_bat.cable_plugged = 0;
> +	adc_bat.status = POWER_SUPPLY_STATUS_DISCHARGING;
> +
> +	/* calculate the total number of channels */
> +	for (chan_index = 0; pdata->channel_name[chan_index]; chan_index++)
> +		;
> +
> +	if (!chan_index) {
> +		pr_err("atleast provide one channel\n");
> +		return -EINVAL;
> +	}
> +
> +	/* copying the static properties and allocating extra memory for holding
> +	 * the extra configurable properties received from platform data.
> +	*/
> +	adc_bat.psy.properties = kzalloc(sizeof(bat_props)
> +					+ sizeof(int)*chan_index, GFP_KERNEL);
> +	if (!adc_bat.psy.properties) {
> +		ret = -ENOMEM;
> +		goto first_mem_fail;
> +	}
> +	memcpy(adc_bat.psy.properties, bat_props, sizeof(bat_props));
> +
> +	/* allocating memory for iio channels */
> +	adc_bat.channel = kzalloc(chan_index * sizeof(struct iio_channel),
> +					GFP_KERNEL);
> +	if (!adc_bat.channel) {
> +		ret = -ENOMEM;
> +		goto second_mem_fail;
> +	}
> +
> +	/*
> +	 * getting channel from iio and copying the battery properties
> +	 * based on the channel set in the platform data.
> +	 */
> +	for (chan_index = 0; pdata->channel_name[chan_index]; chan_index++) {
> +		int channel = channel_cmp(pdata->channel_name[chan_index]);
> +		if (channel < 0) {
> +			ret = -EINVAL;
> +			goto second_mem_fail;
> +		}
> +
> +		adc_bat.channel[chan_index] =
> +		iio_channel_get(dev_name(&pdev->dev),
> +			pdata->channel_name[chan_index]);

Just request the channel with the hardcoded channel names. There is no need
to pass these in via platform data. If a channel is not found just skip it
and continue with the next one. Only if 0 channels were found return an error.

> +		if (IS_ERR(adc_bat.channel[chan_index])) {
> +			ret = PTR_ERR(adc_bat.channel[chan_index]);
> +			goto second_mem_fail;
> +		}
> +
> +		memcpy(adc_bat.psy.properties+sizeof(bat_props),
> +			&dyn_props[channel], sizeof(dyn_props[channel]));

You need to increase the offset for each new property.

> +	}
> +
> +	ret = power_supply_register(&pdev->dev, &adc_bat.psy);
> +	if (ret)
> +		goto err_reg_fail;
> +
> +	INIT_DELAYED_WORK(&adc_bat.bat_work, generic_adc_bat_work);
> +
> +	if (gpio_is_valid(pdata->gpio_charge_finished)) {
> +		ret = gpio_request(pdata->gpio_charge_finished, "charged");
> +		if (ret)
> +			goto err_gpio;
> +
> +		ret = request_irq(gpio_to_irq(pdata->gpio_charge_finished),
> +				generic_adc_bat_charged,
> +				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
> +				"battery charged", &adc_bat);

I'd make this request_any_context_irq, some IRQ expander use nested IRQs.

> +		if (ret)
> +			goto err_gpio;
> +	} else
> +		goto err_gpio; /* let's bail out */
> +
> +	platform_set_drvdata(pdev, &adc_bat);
> +	/* Schedule timer to check current status */
> +	schedule_delayed_work(&adc_bat.bat_work,
> +			msecs_to_jiffies(0));
> +	return 0;
> +
> +err_gpio:
> +	power_supply_unregister(&adc_bat.psy);
> +err_reg_fail:
> +	for (chan_index = 0; pdata->channel_name[chan_index]; chan_index++)
> +		iio_channel_release(adc_bat.channel[chan_index]);
> +	kfree(adc_bat.channel);
> +second_mem_fail:
> +	kfree(adc_bat.psy.properties);
> +first_mem_fail:
> +	return ret;
> +}
> +
> +static int generic_adc_bat_remove(struct platform_device *pdev)
> +{
> +	int chan_index;
> +	struct iio_battery_platform_data *pdata = pdev->dev.platform_data;
> +	struct generic_adc_bat *adc_bat = to_generic_bat(pdata);
> +
> +	power_supply_unregister(&adc_bat->psy);
> +
> +	if (pdata->gpio_charge_finished >= 0) {

gpio_is_valid

> +		free_irq(gpio_to_irq(pdata->gpio_charge_finished), NULL);
> +		gpio_free(pdata->gpio_charge_finished);
> +	}
> +
> +	for (chan_index = 0; pdata->channel_name[chan_index]; chan_index++)
> +		iio_channel_release(adc_bat->channel[chan_index]);
> +	cancel_delayed_work(&adc_bat->bat_work);
> +	return 0;
> +}

