Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab1KRWd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:33:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57595 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab1KRWd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:33:26 -0500
Message-ID: <4EC6DD8F.9070904@solonet.org.ua>
Date: Sat, 19 Nov 2011 00:34:55 +0200
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
References: <4EC572E1.1020209@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740D74E87@HQMAIL01.nvidia.com> <4EC6C785.5010801@solonet.org.ua> <4EC6D1D5.9060808@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740D74FAD@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740D74FAD@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 11:59 PM, Stephen Warren wrote:
> Denis Kuzmenko wrote at Friday, November 18, 2011 2:45 PM:
>> Make s3c24xx LEDS driver use gpiolib. Disable using pull-resistor when not
>> using S3C24XX_LEDF_TRISTATE and enble it when in opposite case.
>>
>> Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
> 
>>  	if (pdata->flags & S3C24XX_LEDF_TRISTATE) {
>> -		s3c2410_gpio_setpin(pdata->gpio, 0);
>> -		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_INPUT);
>> +		/*
>> +		 * pull is needed here to protect pin from being left
>> +		 * floating
>> +		 */
>> +		ret = s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_UP);
>> +		if (ret)
>> +			s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_DOWN);
> 
> Sorry, could you explain why it's appropriate to configure a pull here
> at all, let alone why it's OK to have a random pull on the line?
> 

Of course I'll explain.
Imagine you are working with generic GPIO lines on your board connecting
and disconnecting LEDs and other stuff. In this case there can be
situation where GPIO line is configured as TRISTATE LED but have nothing
connected physically to pin. This configuration is dangerous because
input pin without _any_ pull-resistor is _much_ more sensitive to
statical electricity (ESD) so you can *burn* (unsure this is correct
word) your pin much easily (especially is you are using soldering iron
as much as I do). Most of GPIO modules I worked with have "input with
pull-up" as default and most safe initial state (and s3c2440's one is
not an exception).
Maybe, I need to write more wide exlanation in comment above?

>> +		/* initially turn off led */
>> +		ret = gpio_direction_input(pdata->gpio);
>>  	} else {
>> -		s3c2410_gpio_pullup(pdata->gpio, 0);
>> -		s3c2410_gpio_setpin(pdata->gpio, 0);
>> -		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_OUTPUT);
>> +		/* no point in having a pull-up as we are always driving */
>> +		s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_NONE);
>> +		ret = gpio_request_one(pdata->gpio, GPIOF_OUT_INIT_LOW,
>> +								pdata->name);
>> +		/* initially turn off led */
>> +		ret = gpio_direction_output(pdata->gpio,
>> +				!!(pdata->flags & S3C24XX_LEDF_ACTLOW));
> 
> Wouldn't it be better to pass GPIOF_OUT_INIT_HIGH or GPIOF_OUT_INIT_LOW
> to gpio_request_one() based on S3C24XX_LEDF_ACTLOW, and avoid the call to
> gpio_direction_output; that will avoid glitching the line for a short time.
> 
> I'm fine with the rest of the code.
> 

Good finding! There shouldn't be a
	'gpio_request_one(...GPIOF_OUT_INIT_LOW...)'
at all. This is code from previous version since we have already
requested GPIO line and gpio_direction_output follows.
Sorry for that.

I'll send a new version.


-- 
Best regards, Denis Kuzmenko.
