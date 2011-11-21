Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab1KUWuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:50:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49593 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1KUWt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:49:59 -0500
Message-ID: <4ECAD613.3030605@solonet.org.ua>
Date: Tue, 22 Nov 2011 00:52:03 +0200
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
References: <4EC572E1.1020209@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740D74E87@HQMAIL01.nvidia.com> <4EC6C785.5010801@solonet.org.ua> <4EC6D1D5.9060808@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740D74FAD@HQMAIL01.nvidia.com> <4EC6DD8F.9070904@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740D74FE6@HQMAIL01.nvidia.com> <4EC6E75E.2080200@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF174F08C135@HQMAIL01.nvidia.com> <4ECAA894.4050500@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF174F08C246@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF174F08C246@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 12:03 AM, Stephen Warren wrote:
> Denis Kuzmenko wrote at Monday, November 21, 2011 12:38 PM:
>> On 11/21/2011 08:07 PM, Stephen Warren wrote:
>>> Denis Kuzmenko wrote at Friday, November 18, 2011 4:17 PM:
>>>> On 11/19/2011 12:44 AM, Stephen Warren wrote:
> ...
>>>>> OK, I see the need for a pull of some kind (although aren't there meant
>>>>> to be ESD protection diodes for this purpose; relying on what are probably
>>>>> pretty weak pullup/down resistors doesn't seem like it will provide much
>>>>> protection at all).
>>>>
>>>> I don't mean pull as any kind of good protection. But it's much better
>>>> to have it than not.
>>>
>>> Hmm. I'm not entirely convinced. If the board already has a pull-up/down,
>>> it seems like it won't really make much difference to ESD, and you can't
>>> make any assumptions in the core driver about whether such an external
>>> resistor is already present. In fact, adding another pull resistor inside
>>> the SoC in parallel will reduce the overall resistance, and increase wasted
>>> power.
>>>
>>
>> 	I don't think it's a real protection. It's rather "mistake-proofing"
>> (Poka-Yoke).
>> 	You are right, I didn't considered additional pulls (however I can't
>> imagine tristate LED usage with additional external pull) and power
>> consumptions.
>> 	I was just wondering, why was pull needed in previous implementation.
>> Additional ESD protection was the only thing I could imagine. I don't
>> think it's needed there and I'm OK to remove pull-related code.
>> 	So I'll remove it, test and send patch V3?
> 
> I don't see any pulls being configured in the original code at all,
> unless some of the s3c2410_* function have unexpected side-effect. The
> only related thing is in probe:
> 
>         /* no point in having a pull-up if we are always driving */
> 
>         if (pdata->flags & S3C24XX_LEDF_TRISTATE) {
> ..
>         } else {
>                 s3c2410_gpio_pullup(pdata->gpio, 0);
> 
> which I assume disables an pull in the case where the pin is always driven.
> 
> So, yes, I'd say submit v3 without any pull manipulation at all.
> 

Actually, "s3c2410_gpio_pullup(pdata->gpio, 0);" enables pull in the
same way I've done that. Here is it's code:

/* gpiolib wrappers until these are totally eliminated */

void s3c2410_gpio_pullup(unsigned int pin, unsigned int to)
{
	int ret;

	WARN_ON(to);	/* should be none of these left */

	if (!to) {
		/* if pull is enabled, try first with up, and if that
		 * fails, try using down */

		ret = s3c_gpio_setpull(pin, S3C_GPIO_PULL_UP);
		if (ret)
			s3c_gpio_setpull(pin, S3C_GPIO_PULL_DOWN);
	} else {
		s3c_gpio_setpull(pin, S3C_GPIO_PULL_NONE);
	}
}

So pull is enabled in same "random" way as I did but for *opposite*
state of S3C24XX_LEDF_TRISTATE flag.
And again:

>> 	I was just wondering, why was pull needed in previous implementation.
>> Additional ESD protection was the only thing I could imagine. I don't
>> think it's needed there and I'm OK to remove pull-related code.
>> 	So I'll remove it, test and send patch V3?

-- 
Best regards, Denis Kuzmenko.
