Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab2IOJFM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 05:05:12 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:34983 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2IOJFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 05:05:09 -0400
Message-ID: <505444C2.5080409@kernel.org>
Date: Sat, 15 Sep 2012 10:05:06 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] iio: adc: add new lp8788 adc driver
References: <A874F61F95741C4A9BA573A70FE3998F41EF45CC@DQHE02.ent.ti.com> <504DADE1.6010303@metafoo.de> <A874F61F95741C4A9BA573A70FE3998F41EF4BFC@DQHE02.ent.ti.com> <5052EC67.7010706@metafoo.de> <A874F61F95741C4A9BA573A70FE3998F41EF4EE3@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF4EE3@DQHE02.ent.ti.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2012 01:15 AM, Kim, Milo wrote:
>>> The LP8788 has 13 ADC input selection.
>>>
>>> ADC selection:
>>> Battery voltage, general ADC1 and so on.
>>>
>>> ADC result:
>>> Result = MAX_VALUE * (raw + 0.5) / 4095  except ADC is the charger
>> voltage
>>> If the ADC input is the charger voltage,
>>> Result = MAX_VALUE * (raw + 0.5) / (4095 * 0.48)
>>>
>>> The raw value is from the registers.
>>> It has the range between 0 to 4095. (12bits)
>>>
>>> MAX_VALUE is constant for each selection.
>>> For the battery voltage, there are three ADC inputs. 5.0/5.5/6.0V
>>> Battery voltage for Max 5.0V = 5.0
>>> Battery voltage for Max 5.5V = 5.5
>>> Battery voltage for Max 6.0V = 6.0
>>> Charger = 6.0
>>> ADC1 = 2.5
>>>
>>> I'm afraid I still misunderstand how IIO ADC works.
>>> Could you me some guide how to setup the scale in the driver?
>>
>> The scale is a fixpoint value, which should be multiplied with the raw
>> value
>> to get the result in the proper unit. The unit depends on the channel
>> type,
>> e.g. for voltage it is mV and for temperature it is C. The number of
>> decimal
>> places for the fixed point value depends on whether you return
>> INT_PLUS_MICRO it's 6, if you return INT_PLUS_NANO it is 9. The digits
>> before the decimal point are stored in "val" the digits after the
>> decimal
>> point are stored in "val2".
>>
>> E.g. if you have
>> *val = 1;
>> *val2 = 1256;
>> return INT_PLUS_MICRO;
>>
>> your scale factor is 1.001256, if you'd return INT_PLUS_NANO you scale
>> factor would be 1.0000001256 instead.
>>
>> In your case you could for example calculate the voltage scales as:
>>
>> tmp = MAX_VALUE * 1000000 / 4095;
>> *val = tmp / 1000000;
>> *val2 = tmp % 1000000;
>>
>> This assumes that MAX_VALUE is in millivolt.
>>
>> E.g. if MAX_VALUE is 5.0V you should get a scale of 1.220703 (val = 1,
>> val2
>> = 220703). Since your MAX_VALUE is fixed you can probably just pre-
>> calculate
>> the result of MAX_VALUE * 1000000 / 4095 for each channel, similar like
>> you
>> already did with your lp8788_scale table.
> 
> Superb! Thanks a lot for your clear explanation.
> 
> I have one more question about the temperature ADC.
> 
> The LP8788 has no dedicated temperature ADC, but it provides four
> general inputs - ADC1 to 4.
> The IIO consumer can get the battery temperature among general ADC inputs.
> I think the ADC driver should not assume that ADC1..4 is for the temperature,
> because the selection is configurable in the platform side.
> 
> Then how can I set the unit of ADC MAX_VALUE?
> I would set the unit of ADC MAX_VALUE to mili (same as voltage) and
> the result is converted by the IIO consumer manually.
> Does it make sense ?
Yes, if there is a temperature sensor attached to an ADC channel it
is not up to the ADC driver to know this, but rather to the consumer driver.
> 
> Best Regards,
> Milo
> 
