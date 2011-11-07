Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1KGSJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:09:48 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49581 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1KGSJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:09:47 -0500
Message-ID: <4EB81EEA.100@kernel.org>
Date: Mon, 07 Nov 2011 18:09:46 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: guenter.roeck@ericsson.com
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zdevai@gmail.com" <zdevai@gmail.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] IIO:hwmon interface client driver.
References: <4EB817C6.5070503@kernel.org>  <1320687781-15306-1-git-send-email-jic23@kernel.org> <1320688379.2309.121.camel@groeck-laptop>
In-Reply-To: <1320688379.2309.121.camel@groeck-laptop>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 05:52 PM, Guenter Roeck wrote:
> Hi Jonathan,
> 
> I know I must be getting annoying, but somehow it seems I just keep
> finding something whenever I look at the code again.
Not at all.  It's becoming clear I wrote some extremely slapdash code.
Sorry I have been wasting your time with this!
> 
> On Mon, 2011-11-07 at 12:43 -0500, Jonathan Cameron wrote:
>> From: Jonathan Cameron <jic23@cam.ac.uk>
>>
>> Should move to drivers/hwmon once people are happy with it.
>>
>> Minimal support of simple in, curr and temp attributes
>> so far.
>>
>> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
>> ---
>> Fixed up the missing free Guenter spotted.
>> Thanks!
>>  drivers/iio/Kconfig     |    8 ++
>>  drivers/iio/Makefile    |    1 +
>>  drivers/iio/iio_hwmon.c |  228 +++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 237 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/iio/iio_hwmon.c
>>
>> diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
>> index 308bc97..c2f0970 100644
>> --- a/drivers/iio/Kconfig
>> +++ b/drivers/iio/Kconfig
>> @@ -11,6 +11,14 @@ menuconfig IIO
>>  
>>  if IIO
>>  
>> +config IIO_HWMON
>> +       tristate "Hwmon driver that uses channels specified via iio maps"
>> +       depends on HWMON
>> +       help
>> +	  This is a platform driver that in combination with a suitable
>> +	  map allows IIO devices to provide  basic hwmon functionality
>> +	  for those channels specified in the map.
>> +
>>  source "drivers/iio/adc/Kconfig"
>>  source "drivers/iio/imu/Kconfig"
>>  source "drivers/iio/light/Kconfig"
>> diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
>> index cfb588a..5f9c01a 100644
>> --- a/drivers/iio/Makefile
>> +++ b/drivers/iio/Makefile
>> @@ -6,6 +6,7 @@ obj-y = inkern.o
>>  obj-$(CONFIG_IIO) += iio.o
>>  industrialio-y := core.o
>>  
>> +obj-$(CONFIG_IIO_HWMON) += iio_hwmon.o
>>  obj-y += adc/
>>  obj-y += imu/
>>  obj-y += light/
>> diff --git a/drivers/iio/iio_hwmon.c b/drivers/iio/iio_hwmon.c
>> new file mode 100644
>> index 0000000..880ce6d
>> --- /dev/null
>> +++ b/drivers/iio/iio_hwmon.c
>> @@ -0,0 +1,228 @@
>> +/* Hwmon client for industrial I/O devices
>> + *
>> + * Copyright (c) 2011 Jonathan Cameron
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published by
>> + * the Free Software Foundation.
>> + *
>> + * Limited functionality currently supported.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +#include <linux/module.h>
>> +#include <linux/err.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/iio/inkern.h>
>> +#include <linux/hwmon.h>
>> +#include <linux/hwmon-sysfs.h>
>> +
>> +/**
>> + * struct iio_hwmon_state - device instance state
>> + * @channels:		filled with null terminated array of channels from iio
>> + * @num_channels:	number of channels in channels (saves counting twice)
>> + * @hwmon_dev:		associated hwmon device
>> + * @attr_group:	the group of attributes
>> + * @attrs:		null terminated array of attribute pointers.
>> + */
>> +struct iio_hwmon_state {
>> +	struct iio_channel **channels;
>> +	int num_channels;
>> +	struct device *hwmon_dev;
>> +	struct attribute_group attr_group;
>> +	struct attribute **attrs;
>> +};
>> +
>> +/*
>> + * Assumes that IIO and hwmon operate in the same base units.
>> + * This is supposed to be true, but needs verification for
>> + * new channel types.
>> + */
>> +static ssize_t iio_hwmon_read_val(struct device *dev,
>> +				  struct device_attribute *attr,
>> +				  char *buf)
>> +{
>> +	long result;
>> +	int val, ret, scaleint, scalepart;
>> +	struct sensor_device_attribute *sattr = to_sensor_dev_attr(attr);
>> +	struct iio_hwmon_state *state = dev_get_drvdata(dev);
>> +
>> +	/*
>> +	 * No locking between this pair, so theoretically possible
>> +	 * the scale has changed.
>> +	 */
>> +	ret = iio_read_channel_raw(state->channels[sattr->index],
>> +				   &val);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = iio_read_channel_scale(state->channels[sattr->index],
>> +				     &scaleint, &scalepart);
>> +	if (ret < 0)
>> +		return ret;
>> +	switch (ret) {
>> +	case IIO_VAL_INT:
>> +		result = val * scaleint;
>> +		break;
>> +	case IIO_VAL_INT_PLUS_MICRO:
>> +		result = (long)val * (long)scaleint +
>> +			div_s64((s64)val * (s64)scalepart, 1000000LL);
>> +		break;
>> +	case IIO_VAL_INT_PLUS_NANO:
>> +		result = (long)val * (long)scaleint +
>> +			div_s64((s64)val * (s64)scalepart, 1000000000LL);
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +	return sprintf(buf, "%ld\n", result);
>> +}
>> +
>> +static void iio_hwmon_free_attrs(struct iio_hwmon_state *st)
>> +{
>> +	int i;
>> +	struct sensor_device_attribute *a;
>> +	for (i = 0; i < st->num_channels; i++)
>> +		if (st->attrs[i]) {
>> +			a = to_sensor_dev_attr(
>> +				container_of(st->attrs[i],
>> +					     struct device_attribute,
>> +					     attr));
> 
> I finally looked into kasprintf ... which as it turns out allocates
> memory. Yet, there is no kfree(a->dev_attr.attr.name).
> 
> Thanks,
> Guenter
> 
> 
> 

