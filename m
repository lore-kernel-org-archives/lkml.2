Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1KUTfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:35:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53973 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab1KUTfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:35:53 -0500
Message-ID: <4ECAA894.4050500@solonet.org.ua>
Date: Mon, 21 Nov 2011 21:37:56 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
References: <4EC572E1.1020209@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740D74E87@HQMAIL01.nvidia.com> <4EC6C785.5010801@solonet.org.ua> <4EC6D1D5.9060808@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740D74FAD@HQMAIL01.nvidia.com> <4EC6DD8F.9070904@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740D74FE6@HQMAIL01.nvidia.com> <4EC6E75E.2080200@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF174F08C135@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF174F08C135@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 08:07 PM, Stephen Warren wrote:
> Denis Kuzmenko wrote at Friday, November 18, 2011 4:17 PM:
>> On 11/19/2011 12:44 AM, Stephen Warren wrote:
>>> Denis Kuzmenko wrote at Friday, November 18, 2011 3:35 PM:
>>>> On 11/18/2011 11:59 PM, Stephen Warren wrote:
>>>>> Denis Kuzmenko wrote at Friday, November 18, 2011 2:45 PM:
>>>>>> Make s3c24xx LEDS driver use gpiolib. Disable using pull-resistor when not
>>>>>> using S3C24XX_LEDF_TRISTATE and enble it when in opposite case.
>>>>>>
>>>>>> Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
>>>>>
>>>>>>  	if (pdata->flags & S3C24XX_LEDF_TRISTATE) {
>>>>>> -		s3c2410_gpio_setpin(pdata->gpio, 0);
>>>>>> -		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_INPUT);
>>>>>> +		/*
>>>>>> +		 * pull is needed here to protect pin from being left
>>>>>> +		 * floating
>>>>>> +		 */
>>>>>> +		ret = s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_UP);
>>>>>> +		if (ret)
>>>>>> +			s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_DOWN);
>>>>>
>>>>> Sorry, could you explain why it's appropriate to configure a pull here
>>>>> at all, let alone why it's OK to have a random pull on the line?
>>>>
>>>> Of course I'll explain.
>>>> Imagine you are working with generic GPIO lines on your board connecting
>>>> and disconnecting LEDs and other stuff. In this case there can be
>>>> situation where GPIO line is configured as TRISTATE LED but have nothing
>>>> connected physically to pin. This configuration is dangerous because
>>>> input pin without _any_ pull-resistor is _much_ more sensitive to
>>>> statical electricity (ESD) so you can *burn* (unsure this is correct
>>>> word) your pin much easily (especially is you are using soldering iron
>>>> as much as I do). Most of GPIO modules I worked with have "input with
>>>> pull-up" as default and most safe initial state (and s3c2440's one is
>>>> not an exception).
>>>> Maybe, I need to write more wide exlanation in comment above?
>>>
>>> OK, I see the need for a pull of some kind (although aren't there meant
>>> to be ESD protection diodes for this purpose; relying on what are probably
>>> pretty weak pullup/down resistors doesn't seem like it will provide much
>>> protection at all).
>>
>> I don't mean pull as any kind of good protection. But it's much better
>> to have it than not.
> 
> Hmm. I'm not entirely convinced. If the board already has a pull-up/down,
> it seems like it won't really make much difference to ESD, and you can't
> make any assumptions in the core driver about whether such an external
> resistor is already present. In fact, adding another pull resistor inside
> the SoC in parallel will reduce the overall resistance, and increase wasted
> power.
> 

	I don't think it's a real protection. It's rather "mistake-proofing"
(Poka-Yoke).
	You are right, I didn't considered additional pulls (however I can't
imagine tristate LED usage with additional external pull) and power
consumptions.
	I was just wondering, why was pull needed in previous implementation.
Additional ESD protection was the only thing I could imagine. I don't
think it's needed there and I'm OK to remove pull-related code.
	So I'll remove it, test and send patch V3?


> I meant that /if/ the GPIO HW or SoC really requires this for safety, then
> the implementation behind gpio_direction_input() should be doing this.
> That said, it seems pretty magic to do this.
> 
> Can you get the SoC vendor and gpiolib implementor for this SoC to weigh in
> on this and answer if "magically" enabling a tri-state is a good thing to
> do?

I don't like magic things neither believe that it's possible to get
those people to this conversation. So lets just remove that code?

-- 
Best regards, Denis Kuzmenko.
