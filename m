Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab1JXP6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 11:58:48 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:42958 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826Ab1JXP6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 11:58:47 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4EA58B39.8030608@cam.ac.uk>
Date: Mon, 24 Oct 2011 16:58:49 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: guenter.roeck@ericsson.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
References: <1319103187-27791-1-git-send-email-jic23@cam.ac.uk>  <1319103187-27791-6-git-send-email-jic23@cam.ac.uk>  <1319123566.3720.297.camel@groeck-laptop> <4EA03E8D.1010303@cam.ac.uk>  <4EA53973.9080102@cam.ac.uk> <1319470784.2583.46.camel@groeck-laptop>
In-Reply-To: <1319470784.2583.46.camel@groeck-laptop>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/11 16:39, Guenter Roeck wrote:
> On Mon, 2011-10-24 at 06:09 -0400, Jonathan Cameron wrote:
> [ ... ]
>>>>> +/*
>>>>> + * Assumes that IIO and hwmon operate in the same base units.
>>>>> + * This is supposed to be true, but needs verification for
>>>>> + * new channel types.
>>>>> + */
>>>>> +static ssize_t iio_hwmon_read_val(struct device *dev,
>>>>> +				  struct device_attribute *attr,
>>>>> +				  char *buf)
>>>>> +{
>>>>> +	long result;
>>>>> +	int val, ret, scaleint, scalepart;
>>>>> +	struct sensor_device_attribute *sattr = to_sensor_dev_attr(attr);
>>>>> +	struct iio_hwmon_state *state = dev_get_drvdata(dev);
>>>>> +
>>>>> +	/*
>>>>> +	 * No locking between this pair, so theoretically possible
>>>>> +	 * the scale has changed.
>>>>> +	 */
>>>>> +	ret = iio_read_channel_raw(state->channels[sattr->index],
>>>>> +				   &val);
>>>>> +	if (ret < 0)
>>>>> +		return ret;
>>>>> +
>>>>> +	ret = iio_read_channel_scale(state->channels[sattr->index],
>>>>> +				     &scaleint, &scalepart);
>>>>> +	if (ret < 0)
>>>>> +		return ret;
>>>>> +	switch (ret) {
>>>>> +	case IIO_VAL_INT:
>>>>> +		result = val * scaleint;
>>>>> +		break;
>>>>> +	case IIO_VAL_INT_PLUS_MICRO:
>>>>> +		result = (long)val * (long)scaleint +
>>>>> +			(long)val * (long)scalepart / 1000000L;
>>>>> +		break;
>>>>> +	case IIO_VAL_INT_PLUS_NANO:
>>>>> +		result = (long)val * (long)scaleint +
>>>>> +			(long)val * (long)scalepart / 1000000000L;
>>>>> +		break;
>>>>
>>>> Still easy to imagine that val * scalepart gets larger than 2147483647L
>>>> (on machines where sizeof(long) = 4) ... it will already happen if the
>>>> result of (val * scalepart / 1000000000) is larger than 2. 
>>> Good point.  I really ought to have done the calcs.
>>> If we have maximum possible value in here things will be ugly.
>>>
>>> Worst case is scalepart is 9999999999. (could be done as 1 - 0.000000001
>>> which would be nicer, but we don't specify a preference - from this
>>> discussion I am suspecting we should!)
>>>
>>> Looks like 64 bits is going to be a requirement as you say.
>>>>
>>>> What value range do you expect to see here ?
>>>>
>>>> If (val * scaleint) is already the milli-unit, scalepart would possibly
>>>> only address fractions of milli-units. If so, the result of (val *
>>>> scalepart / 1000000000L) might always be smaller than 1, ie 0. 
>>> It certainly should be.
>>>> If so, for the calculation to have any value, you might be better off using
>>>> DIV_ROUND_CLOSEST(val * scalepart, 1000000000L).
>>> Good idea.
>>>>
>>>> I am a bit confused by this anyway. Since hwmon in general reports
>>>> milli-units, VAL_INT appears to reflect milli-units, VAL_INT_PLUS_MICRO
>>>> really means nano-units, and IIO_VAL_INT_PLUS_NANO really means
>>>> pico-units. Is this correct ?
>>> Micro units of the scale factor.
>>>
>>> Take my test part a max1363...
>>> Scale is actually 0.5 so each adc count (e.g. raw value) is 0.5millivolts.
>>>
>>> scale int here is 0,
>>> scale part is 500,000 (so 0.5) and it returns IIO_VAL_INT_PLUS_MICRO.
>>
>> How about the following?  It'll be extremely costly, but this isn't exactly
>> a fast path!
>>
>> 	case IIO_VAL_INT_PLUS_MICRO:
>> 		result = (s64)val * (s64)scaleint +
>> 			div_s64((s64)val * (s64)scalepart, 1000000LL);
>> 		break;
>> 	case IIO_VAL_INT_PLUS_NANO:
>> 		result = (s64)val * (s64)scaleint +
>> 			div_s64((s64)val * (s64)scalepart, 1000000000LL);
>> 		break;
> 
> Is div_s64 really necessary, or would
> 
> 		result = (long)val * (long)scaleint +
> 			DIV_ROUND_CLOSEST((s64)val * (s64)scalepart,
> 					 1000000000LL);
> 
> work as well ?
Not if you want it to compile on arm v5 by the look of it.

ERROR: "__aeabi_ldivmod" [drivers/staging/iio/iio_hwmon.ko] undefined!

