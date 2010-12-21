Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368Ab0LUAJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 19:09:58 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:39872 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab0LUAJ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 19:09:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=de+kwMnXRTqMnjvntNcroi6zNE27QjuVMRIx6N313BigqKFUnVWnUiqEdnaPsPdUkD
         5lVjsRv1wXqkUiIRVcyPSVMzZcU61K8ISfC+FMMiJM+4YBnT7dip3nnn+DNEBfSPM/cO
         jikPRyW06mRjINeWbmmQ8H7nD38ljkgLETeyo=
MIME-Version: 1.0
In-Reply-To: <AANLkTinyYKrhTcBMMCE4A2oFQHm11cqSZQozytGu+d6o@mail.gmail.com>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
	<20101107165745.GB1759@n2100.arm.linux.org.uk>
	<AANLkTimFJ=Brx4pDiUqZOKDfABaDg0s_yFC7EkZGi7D8@mail.gmail.com>
	<20101107171726.GF1759@n2100.arm.linux.org.uk>
	<20101108171930.GA1471@alchark-u3s.lan>
	<20101111212322.GA15533@alchark-u3s.lan>
	<20101111234957.GA28735@n2100.arm.linux.org.uk>
	<20101219174017.GA31832@alchark-u3s>
	<20101220191549.GH28157@n2100.arm.linux.org.uk>
	<20101220195423.GA14509@alchark-u3s>
	<4D0FC1AE.2050708@bluewatersys.com>
	<AANLkTin4XqbGwznp56Xjt_zest6rxNmir0QDJWTySY4+@mail.gmail.com>
	<4D0FD747.9020700@bluewatersys.com>
	<AANLkTikAWjK7ACyt=LedhyyrhsCk1WCiyWz182CXMe9C@mail.gmail.com>
	<4D0FE546.7050302@bluewatersys.com>
	<AANLkTinyYKrhTcBMMCE4A2oFQHm11cqSZQozytGu+d6o@mail.gmail.com>
Date: Tue, 21 Dec 2010 03:09:55 +0300
Message-ID: <AANLkTik600vg0otkJVVeWCwYv-0=UNnQDr1mCR9Zvpve@mail.gmail.com>
Subject: Re: [PATCH 1/6 v9] ARM: Add basic architecture support for
 VIA/WonderMedia 85xx SoC's
From: Alexey Charkov <alchark@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/21 Alexey Charkov <alchark@gmail.com>:
> 2010/12/21 Ryan Mallon <ryan@bluewatersys.com>:
>> On 12/21/2010 12:00 PM, Alexey Charkov wrote:
>>> 2010/12/21 Ryan Mallon <ryan@bluewatersys.com>:
>>>> On 12/21/2010 10:48 AM, Alexey Charkov wrote:
>>>>> 2010/12/20 Ryan Mallon <ryan@bluewatersys.com>:
>>>>>> On 12/21/2010 08:54 AM, Alexey Charkov wrote:
>>>>>>> +}
>>>>>>> +
>>>>>>> +int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
>>>>>>> +{
>>>>>>> +     unsigned long long c;
>>>>>>> +     unsigned long period_cycles, prescale, pv, dc;
>>>>>>> +
>>>>>>> +     if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
>>>>>>> +             return -EINVAL;
>>>>>>> +
>>>>>>> +     c = 25000000/2; /* wild guess --- need to implement clocks */
>>>>>>> +     c = c * period_ns;
>>>>>>> +     do_div(c, 1000000000);
>>>>>>> +     period_cycles = c;
>>>>>>
>>>>>> This looks like it could be reworked to remove the do_div call.
>>>>>>
>>>>>
>>>>> I just followed PXA implementation in this regard. Are there any
>>>>> specific suggestions? Note that c should not be a complie-time
>>>>> constant eventually, as this is the guessed PWM base frequency (should
>>>>> be read from the hardware, but the code for clocks is not yet in).
>>>>
>>>> I didn't have a particular solution in mind, but often by changing the
>>>> units used and rearranging the math a bit you can often avoid having to
>>>> do horrible multiplies and divides.
>>>>
>>>> For now at least you could avoid the do_div by assigning period_cycles
>>>> directly.
>>>>
>>>
>>> It depends on period_ns, which is passed in as an argument from
>>> whatever uses PWM, so I'm not sure it can be assigned directly.
>>
>> Ah. How big a number is period_ns? Can you do something like this instead?
>>
>>        period_cycles = ((250 / 2) * period_ns) / 10000;
>>
>> and still safely avoid overflows?
>>
>
> The only current in-kernel user of PWM is the backlight, and that
> currently uses period_ns = 250000. At this value it does not overflow.
> However, in a general case the base frequency will also be returned as
> a large number (like 12500000) as per CLK infrastructure conventions
> (once that part is implemented). Further, I can't see any built-in
> reasons for period_ns to be bounded by anything below sizeof(int). The
> hardware will work with up to 4096*1024*1000000000/base_frequency (see
> the code for constraints), so it can in principle overflow with 32 bit
> arithmetics.
>

This discussion led me to look closer at the duty counter calculation:
if period_ns and duty_ns are both large and close to each other (about
0.3 seconds, rare but possible use case for PWM), then (pv * duty_ns)
can overflow in 32 bit multiplication for permissible argument values.
Should I use do_div((u64)pv * (u64)duty_ns, period_ns) here?

Best regards,
Alexey
