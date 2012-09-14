Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320Ab2INIfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:35:20 -0400
Received: from smtp-out-028.synserver.de ([212.40.185.28]:1212 "EHLO
	smtp-out-028.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759284Ab2INIfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:35:16 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25416
Message-ID: <5052EC67.7010706@metafoo.de>
Date: Fri, 14 Sep 2012 10:35:51 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@kernel.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] iio: adc: add new lp8788 adc driver
References: <A874F61F95741C4A9BA573A70FE3998F41EF45CC@DQHE02.ent.ti.com> <504DADE1.6010303@metafoo.de> <A874F61F95741C4A9BA573A70FE3998F41EF4BFC@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF4BFC@DQHE02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 02:33 AM, Kim, Milo wrote:
>> Hi,
>>
>> One issue and a couple of nitpicks inline.
> 
> I really appreciate it.
> Please see my questions below.
> 
>>> +	switch (mask) {
>>> +	case IIO_CHAN_INFO_RAW:
>>> +		ret = lp8788_get_adc_result(adc, id, val) ? -EIO :
>> IIO_VAL_INT;
>>> +		break;
>>> +	case IIO_CHAN_INFO_SCALE:
>>> +		*val = (lp8788_scale[id] / 1000) * 1000;
>>> +		*val2 = (lp8788_scale[id] % 1000) * 1000000;
>>
>> This looks suspicious. E.g. if the entry in your table has the value
>> "1234"
>> you'd end up with a scale factor of 1000.234000000. Which looks wrong
>> for
>> two reasons, given that you return INT_PLUS_MICRO val2 should never
>> exceed 6
>> decimal digits and secondly val is multiplied by a factor of thousand.
>>
>> Can you tell us in what unit the values in lp8788_scale are, that would
>> make
>> review easier.
> 
> The LP8788 has 13 ADC input selection.
> 
> ADC selection:
> Battery voltage, general ADC1 and so on.
> 
> ADC result:
> Result = MAX_VALUE * (raw + 0.5) / 4095  except ADC is the charger voltage
> If the ADC input is the charger voltage,
> Result = MAX_VALUE * (raw + 0.5) / (4095 * 0.48)
> 
> The raw value is from the registers.
> It has the range between 0 to 4095. (12bits)
> 
> MAX_VALUE is constant for each selection.
> For the battery voltage, there are three ADC inputs. 5.0/5.5/6.0V
> Battery voltage for Max 5.0V = 5.0
> Battery voltage for Max 5.5V = 5.5
> Battery voltage for Max 6.0V = 6.0
> Charger = 6.0
> ADC1 = 2.5 
> 
> I'm afraid I still misunderstand how IIO ADC works.
> Could you me some guide how to setup the scale in the driver?

The scale is a fixpoint value, which should be multiplied with the raw value
to get the result in the proper unit. The unit depends on the channel type,
e.g. for voltage it is mV and for temperature it is C. The number of decimal
places for the fixed point value depends on whether you return
INT_PLUS_MICRO it's 6, if you return INT_PLUS_NANO it is 9. The digits
before the decimal point are stored in "val" the digits after the decimal
point are stored in "val2".

E.g. if you have
*val = 1;
*val2 = 1256;
return INT_PLUS_MICRO;

your scale factor is 1.001256, if you'd return INT_PLUS_NANO you scale
factor would be 1.0000001256 instead.

In your case you could for example calculate the voltage scales as:

tmp = MAX_VALUE * 1000000 / 4095;
*val = tmp / 1000000;
*val2 = tmp % 1000000;

This assumes that MAX_VALUE is in millivolt.

E.g. if MAX_VALUE is 5.0V you should get a scale of 1.220703 (val = 1, val2
= 220703). Since your MAX_VALUE is fixed you can probably just pre-calculate
the result of MAX_VALUE * 1000000 / 4095 for each channel, similar like you
already did with your lp8788_scale table.

- Lars



