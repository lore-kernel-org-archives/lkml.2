Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1JXKJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 06:09:57 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:54364 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab1JXKJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 06:09:56 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4EA53973.9080102@cam.ac.uk>
Date: Mon, 24 Oct 2011 11:09:55 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: guenter.roeck@ericsson.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linus.ml.walleij@gmail.com" <linus.ml.walleij@gmail.com>,
        "zdevai@gmail.com" <zdevai@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 5/6] IIO:hwmon interface client driver.
References: <1319103187-27791-1-git-send-email-jic23@cam.ac.uk>  <1319103187-27791-6-git-send-email-jic23@cam.ac.uk> <1319123566.3720.297.camel@groeck-laptop> <4EA03E8D.1010303@cam.ac.uk>
In-Reply-To: <4EA03E8D.1010303@cam.ac.uk>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/11 16:30, Jonathan Cameron wrote:
> On 10/20/11 16:12, Guenter Roeck wrote:
>> On Thu, 2011-10-20 at 05:33 -0400, Jonathan Cameron wrote:
>>> Should move to drivers/hwmon once people are happy with it.
>>>
>>> Minimal support of simple in, curr and temp attributes
>>> so far.
>>>
>>> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
>>> ---
>>>  drivers/iio/Kconfig     |    8 ++
>>>  drivers/iio/Makefile    |    1 +
>>>  drivers/iio/iio_hwmon.c |  227 +++++++++++++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 236 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
>>> index 308bc97..c2f0970 100644
>>> --- a/drivers/iio/Kconfig
>>> +++ b/drivers/iio/Kconfig
>>> @@ -11,6 +11,14 @@ menuconfig IIO
>>>  
>>>  if IIO
>>>  
>>> +config IIO_HWMON
>>> +       tristate "Hwmon driver that uses channels specified via iio maps"
>>> +       depends on HWMON
>>> +       help
>>> +	  This is a platform driver that in combination with a suitable
>>> +	  map allows IIO devices to provide  basic hwmon functionality
>>> +	  for those channels specified in the map.
>>> +
>>>  source "drivers/iio/adc/Kconfig"
>>>  source "drivers/iio/imu/Kconfig"
>>>  source "drivers/iio/light/Kconfig"
>>> diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
>>> index cfb588a..5f9c01a 100644
>>> --- a/drivers/iio/Makefile
>>> +++ b/drivers/iio/Makefile
>>> @@ -6,6 +6,7 @@ obj-y = inkern.o
>>>  obj-$(CONFIG_IIO) += iio.o
>>>  industrialio-y := core.o
>>>  
>>> +obj-$(CONFIG_IIO_HWMON) += iio_hwmon.o
>>>  obj-y += adc/
>>>  obj-y += imu/
>>>  obj-y += light/
>>> diff --git a/drivers/iio/iio_hwmon.c b/drivers/iio/iio_hwmon.c
>>> new file mode 100644
>>> index 0000000..b3348ad
>>> --- /dev/null
>>> +++ b/drivers/iio/iio_hwmon.c
>>> @@ -0,0 +1,227 @@
>>> +/* Hwmon client for industrial I/O devices
>>> + *
>>> + * Copyright (c) 2011 Jonathan Cameron
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify it
>>> + * under the terms of the GNU General Public License version 2 as published by
>>> + * the Free Software Foundation.
>>> + *
>>> + * Limited functionality currently supported.
>>
>> Just nitpicking ... this comment doesn't provide much value. It doesn't
>> explain the limits, nor what could be improved.
>>
>>> + */
>>> +
>>> +#include <linux/kernel.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/module.h>
>>> +#include <linux/err.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/iio/inkern.h>
>>> +#include <linux/hwmon.h>
>>> +#include <linux/hwmon-sysfs.h>
>>> +
>>> +/**
>>> + * struct iio_hwmon_state - device instance state
>>> + * @channels:		filled with null terminated array of channels from iio
>>> + * @num_channels:	number of channels in channels (saves counting twice)
>>> + * @hwmon_dev:		associated hwmon device
>>> + * @attr_group:	the group of attributes
>>> + * @attrs:		null terminated array of attribute pointers.
>>> + */
>>> +struct iio_hwmon_state {
>>> +	struct iio_channel **channels;
>>> +	int num_channels;
>>> +	struct device *hwmon_dev;
>>> +	struct attribute_group attr_group;
>>> +	struct attribute **attrs;
>>> +};
>>> +
>>> +/*
>>> + * Assumes that IIO and hwmon operate in the same base units.
>>> + * This is supposed to be true, but needs verification for
>>> + * new channel types.
>>> + */
>>> +static ssize_t iio_hwmon_read_val(struct device *dev,
>>> +				  struct device_attribute *attr,
>>> +				  char *buf)
>>> +{
>>> +	long result;
>>> +	int val, ret, scaleint, scalepart;
>>> +	struct sensor_device_attribute *sattr = to_sensor_dev_attr(attr);
>>> +	struct iio_hwmon_state *state = dev_get_drvdata(dev);
>>> +
>>> +	/*
>>> +	 * No locking between this pair, so theoretically possible
>>> +	 * the scale has changed.
>>> +	 */
>>> +	ret = iio_read_channel_raw(state->channels[sattr->index],
>>> +				   &val);
>>> +	if (ret < 0)
>>> +		return ret;
>>> +
>>> +	ret = iio_read_channel_scale(state->channels[sattr->index],
>>> +				     &scaleint, &scalepart);
>>> +	if (ret < 0)
>>> +		return ret;
>>> +	switch (ret) {
>>> +	case IIO_VAL_INT:
>>> +		result = val * scaleint;
>>> +		break;
>>> +	case IIO_VAL_INT_PLUS_MICRO:
>>> +		result = (long)val * (long)scaleint +
>>> +			(long)val * (long)scalepart / 1000000L;
>>> +		break;
>>> +	case IIO_VAL_INT_PLUS_NANO:
>>> +		result = (long)val * (long)scaleint +
>>> +			(long)val * (long)scalepart / 1000000000L;
>>> +		break;
>>
>> Still easy to imagine that val * scalepart gets larger than 2147483647L
>> (on machines where sizeof(long) = 4) ... it will already happen if the
>> result of (val * scalepart / 1000000000) is larger than 2. 
> Good point.  I really ought to have done the calcs.
> If we have maximum possible value in here things will be ugly.
> 
> Worst case is scalepart is 9999999999. (could be done as 1 - 0.000000001
> which would be nicer, but we don't specify a preference - from this
> discussion I am suspecting we should!)
> 
> Looks like 64 bits is going to be a requirement as you say.
>>
>> What value range do you expect to see here ?
>>
>> If (val * scaleint) is already the milli-unit, scalepart would possibly
>> only address fractions of milli-units. If so, the result of (val *
>> scalepart / 1000000000L) might always be smaller than 1, ie 0. 
> It certainly should be.
>> If so, for the calculation to have any value, you might be better off using
>> DIV_ROUND_CLOSEST(val * scalepart, 1000000000L).
> Good idea.
>>
>> I am a bit confused by this anyway. Since hwmon in general reports
>> milli-units, VAL_INT appears to reflect milli-units, VAL_INT_PLUS_MICRO
>> really means nano-units, and IIO_VAL_INT_PLUS_NANO really means
>> pico-units. Is this correct ?
> Micro units of the scale factor.
> 
> Take my test part a max1363...
> Scale is actually 0.5 so each adc count (e.g. raw value) is 0.5millivolts.
> 
> scale int here is 0,
> scale part is 500,000 (so 0.5) and it returns IIO_VAL_INT_PLUS_MICRO.

How about the following?  It'll be extremely costly, but this isn't exactly
a fast path!

	case IIO_VAL_INT_PLUS_MICRO:
		result = (s64)val * (s64)scaleint +
			div_s64((s64)val * (s64)scalepart, 1000000LL);
		break;
	case IIO_VAL_INT_PLUS_NANO:
		result = (s64)val * (s64)scaleint +
			div_s64((s64)val * (s64)scalepart, 1000000000LL);
		break;

Everything should fit in there and it should give us pretty good precision.
> 
> 
>>
>>> +	default:
>>> +		return -EINVAL;
>>> +	}
>>> +	return sprintf(buf, "%ld\n", result);
>>> +}
>>> +
>>> +static void iio_hwmon_free_attrs(struct iio_hwmon_state *st)
>>> +{
>>> +	int i;
>>> +	struct sensor_device_attribute *a;
>>> +	for (i = 0; i < st->num_channels; i++)
>>> +		if (st->attrs[i]) {
>>> +			a = to_sensor_dev_attr(
>>> +				container_of(st->attrs[i],
>>> +					     struct device_attribute,
>>> +					     attr));
>>> +			kfree(a);
>>> +		}
>>> +}
>>> +
>>> +static int __devinit iio_hwmon_probe(struct platform_device *pdev)
>>> +{
>>> +	struct iio_hwmon_state *st;
>>> +	struct sensor_device_attribute *a;
>>> +	int ret, i;
>>> +	int in_i = 1, temp_i = 1, curr_i = 1;
>>> +
>>> +	st = kzalloc(sizeof(*st), GFP_KERNEL);
>>> +	if (st == NULL) {
>>> +		ret = -ENOMEM;
>>> +		goto error_ret;
>>> +	}
>>> +
>>> +	st->channels = iio_channel_get_all(&pdev->dev, NULL);
>>> +	if (IS_ERR(st->channels)) {
>>> +		ret = PTR_ERR(st->channels);
>>> +		goto error_free_state;
>>> +	}
>>> +
>>> +	/* count how many attributes we have */
>>> +	while (st->channels[st->num_channels])
>>> +		st->num_channels++;
>>> +
>>> +	st->attrs = kzalloc(sizeof(st->attrs) * (st->num_channels + 1),
>>> +			    GFP_KERNEL);
>>
>> Why "+ 1" ?
> Null terminated list for attribute groups.  Hence the kzalloc.
>>
>> Unless I am missing something, you only use st->attrs[0] ..
>> st->attrs[st->num_channels-1].
>>
>> Thanks,
>> Guenter
>>
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

