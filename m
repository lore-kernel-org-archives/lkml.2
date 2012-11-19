Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab2KSKEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:04:25 -0500
Received: from smtp-out-217.synserver.de ([212.40.185.217]:1121 "EHLO
	smtp-out-217.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2KSKEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:04:24 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32694
Message-ID: <50AA0431.9060609@metafoo.de>
Date: Mon, 19 Nov 2012 11:04:33 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: adc: Add Texas Instruments ADC081C021/027 support
References: <1353313289-983-1-git-send-email-thierry.reding@avionic-design.de> <50A9FCFC.60002@metafoo.de> <20121119095053.GA3951@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121119095053.GA3951@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 10:50 AM, Thierry Reding wrote:
> On Mon, Nov 19, 2012 at 10:33:48AM +0100, Lars-Peter Clausen wrote:
>> On 11/19/2012 09:21 AM, Thierry Reding wrote:
>>> Add support for reading conversion results from the ADC and provide them
>>> through a single IIO channel. A proper scaling factor is also exported
>>> based on the reference voltage provided by a regulator.
>>>
>>> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>>> ---
>> [...]
>>> +static int adc081c_read_raw(struct iio_dev *iio,
>>> +			    struct iio_chan_spec const *channel, int *value,
>>> +			    int *micro, long mask)
>>> +{
>>> +	struct adc081c *adc = iio_priv(iio);
>>> +	int err, scale;
>>> +
>>> +	switch (mask) {
>>> +	case IIO_CHAN_INFO_RAW:
>>> +		err = i2c_smbus_read_word_swapped(adc->i2c, REG_CONV_RES);
>>> +		if (err < 0)
>>> +			return err;
>>> +
>>> +		*value = (err >> 4) & 0xff;
>>> +		return IIO_VAL_INT;
>>> +
>>> +	case IIO_CHAN_INFO_SCALE:
>>> +		err = regulator_get_voltage(adc->ref);
>>> +		if (err < 0)
>>> +			return err;
>>> +
>>> +		scale = err / 255;
>>
>> Shouldn't this be 256?
> 
> Well, the maximum value that the conversion register can contain is 255,
> so if we divide by 256 we'll always be slightly off, right? Or maybe I
> misunderstand what the scale factor is supposed to do. From reading the
> documentation it seems like user-space is supposed to multiply the raw
> value by the scale to obtain the real voltage.

So usually for ADCs the scale is from 0V to VREF - 1 lsb or VREF - 0.5 LSB.
I just had a look at the adc081c927 datasheet and it looks as if it is no
exception.

> 
>>> +
>>> +		*value = scale / 1000000;
>>> +		*micro = scale % 1000000;
>>
>> scale for voltages is in microvolt, so I think it this is off by a factor of
>> 1000.
> 
> If scale is supposed to be in microvolts, then this is off by a factor
> of 1000000 since regulator_get_voltage() returns the voltage in
> microvolts as well.

sorry, I meant millivolts, too early in the morning ;)

> 
>> For ADCs it often makes sense to use IIO_VAL_FRACTIONAL_LOG2 with the val
>> being set to the reference voltage (in mV) and val2 being set to the number
>> of bits.
>>
>> E.g in your case
>>
>> 		*val = err / 1000;
>> 		*val2 = 8;
> 
> I'm confused, IIO_VAL_FRACTIONAL_LOG2 is supposed to return mV, but
> IIO_VAL_INT_PLUS_MICRO will return uV?
> 
> And setting val2 to 8 will cause the scaling factor to be 256, and not
> 255, so the converted value will actually be off (as I mentioned above).
> 

