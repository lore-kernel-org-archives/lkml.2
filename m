Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab2IIJ7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 05:59:47 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55289 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab2IIJ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 05:59:46 -0400
Message-ID: <504C688C.3010400@kernel.org>
Date: Sun, 09 Sep 2012 10:59:40 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: anish kumar <anish198519851985@gmail.com>, linux-iio@vger.kernel.org,
        cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC]power: battery: Generic battery driver using IIO
References: <1346600372-3284-1-git-send-email-anish198519851985@gmail.com>	 <5049A7B8.506@kernel.org> <1347088218.5051.152.camel@anish-Inspiron-N5050>	 <504B1941.6000708@kernel.org> <1347183129.5051.174.camel@anish-Inspiron-N5050> <504C655D.70901@metafoo.de>
In-Reply-To: <504C655D.70901@metafoo.de>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2012 10:46 AM, Lars-Peter Clausen wrote:
> On 09/09/2012 11:32 AM, anish kumar wrote:
>>>>>> +	channels = iio_channel_get_all(dev_name(&pdev->dev));
>>>>> I would give these explicit names and get the two individual channels by 
>>>>> name. I think it will give you cleaner code.
>>>> Yes, now it will be based on pdata->voltage_channel,
>>>> pdata->current_channel and so on.We will use this to get the channel.
>>> Maybe better to just do this via the iio_map structures in the platform data
>>> and standard naming for each channel.
>>>
>>> "voltage", "current", "power" would do nicely. Note we'll have to add the
>>> relevant naming for the other side to more IIO device drivers via the
>>> 'datasheet_name' element of iio_chan_spec.   A quick grep shows this
>>> is only done in drivers/staging/iio/max1363_core.c so far (bet you can't
>>> guess what is soldered to my test board :)
>> Sorry I couldn't understand this but this is what I came up with.Hope it
>> doesn't disappoint.
>> It has the advantage of getting extended easily.
>>
>> enum chan_type{
>>         VOLTAGE,
>>         CURRENT,
>>         POWER,
>>         MAX_TYPE
>> };
>>
>> struct channel_map {
>>         struct iio_map channel;
>>         enum chan_type type;
>> };
>>
>> struct iio_battery_platform_data {
>>         struct power_supply_info battery_info;
>>         struct channel_map *map;
>>         int     num_map;
>>         char    battery_name[BAT_MAX_NAME];
>>         int     (*cal_charge)(long);
>>         int     gpio_charge_finished;
>>         int     gpio_inverted;
>>         int     bat_poll_interval;
>>         int     jitter_delay;
>> };
>>
>> here goes the assignment:
>> for(i = 0; i < pdata->num_map; i++) {
>>         switch(pdata->map[i].type)
>>         case VOLTAGE:
>>                 adc_bat->channel[VOLTAGE] = 
>>                  iio_channel_get(
>>                         pdata->map[i].channel.consumer_dev_name,
>>                         pdata->map[i].channel.adc_channel_label);
>>                 adc_bat->chan_index = 1 << VOLTAGE;
>>                 break;  
>>         case CURRENT:
>>                 adc_bat->channel[CURRENT] =
>>                 iio_channel_get(
>>                         pdata->map->channel->consumer_dev_name,
>>                         pdata->map[i].channel.adc_channel_label);
>>                 adc_bat->chan_index = 1 << CURRENT;
>>                 break;  
>>         case POWER:
>>                 adc_bat->channel[POWER] =
>>                 iio_channel_get(
>>                         pdata->map[i].channel.consumer_dev_name,
>>                         pdata->map[i].channel.adc_channel_label);
>>                 adc_bat->chan_index = 1 << POWER;
>>                 break;  
>>         default:
>>                 pr_info("add any other channels here in the case\n");
>> }
>>
>> With the chan_index we can know which property is set or every time we
>> need to run through pdata->map[i].type to know the property set.
> 
> Hi,
> 
> I think what Jonathon meant is something like this.
> 
> adc_bat->channel[VOLTAGE] = iio_channel_get(dev_name(&pdev->dev), "voltage");
> ...
> adc_bat->channel[CURRENT] = iio_channel_get(dev_name(&pdev->dev), "current");
> ...
> adc_bat->channel[POWER] = iio_channel_get(dev_name(&pdev->dev), "power");
> 
> That's the beauty of the channel iio_map you can map an arbitrary channel of
> your ADC to a virtual identifier.
> 
> E.g. an example map could look like.
> 
> static struct iio_map map[] = {
> 	{ "AIN1", "iio-battery.1", "voltage" },
> };
> 
> With this when the battery driver calls iio_channel_get(... "voltage") it will
> get the "AIN1" channel of the device.
> 
Exactly what I meant, thanks Lars.

I'm not sure any consumers are actually using that interface at the moment
as the main ones are hwmon and input (in my wip branch) and in both those
cases the association doesn't matter.

