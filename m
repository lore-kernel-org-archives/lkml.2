Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab1KRU70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 15:59:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38769 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab1KRU7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 15:59:25 -0500
Message-ID: <4EC6C785.5010801@solonet.org.ua>
Date: Fri, 18 Nov 2011 23:00:53 +0200
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
References: <4EC572E1.1020209@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740D74E87@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740D74E87@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 07:08 PM, Stephen Warren wrote:
> Denis Kuzmenko wrote at Thursday, November 17, 2011 1:47 PM:
>> Make s3c24xx LEDS driver use gpiolib.
>
> I made some slightly nit-picky
> comments below.

Thanks for looking my patch.

>> diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
> 
>>  static void s3c24xx_led_set(struct led_classdev *led_cdev,
>> -			    enum led_brightness value)
>> +				enum led_brightness value)
> 
> Seems unnecessary, but is probably fine.

That was made unintentionally - will fix in next version.

>>  {
>>  	struct s3c24xx_gpio_led *led = to_gpio(led_cdev);
>>  	struct s3c24xx_led_platdata *pd = led->pdata;
>>
>> -	/* there will be a short delay between setting the output and
>> -	 * going from output to input when using tristate. */
>> -
>> -	s3c2410_gpio_setpin(pd->gpio, (value ? 1 : 0) ^
>> -			    (pd->flags & S3C24XX_LEDF_ACTLOW));
>> -
>> -	if (pd->flags & S3C24XX_LEDF_TRISTATE)
>> -		s3c2410_gpio_cfgpin(pd->gpio,
>> -			value ? S3C2410_GPIO_OUTPUT : S3C2410_GPIO_INPUT);
>> +	/*
>> +	 * ensure value is 0 or 1 to use it with bitwise XOR (^)
>> +	 * (only 100% brightness is supported)
>> +	 */
>> +	value = value ? 1 : 0;
>> +
>> +	if (pd->flags & S3C24XX_LEDF_TRISTATE) {
>> +		if (value) {
>> +			/* invert value if S3C24XX_LEDF_ACTLOW is set */
>> +			value = (pd->flags & S3C24XX_LEDF_ACTLOW) ^ value;
>> +			gpio_direction_output(pd->gpio, value);
>> +		} else {
>> +			gpio_direction_input(pd->gpio);
>> +		}
>> +	} else {
>> +		/* invert value if S3C24XX_LEDF_ACTLOW is set */
>> +		value = (pd->flags & S3C24XX_LEDF_ACTLOW) ^ value;
>> +		gpio_set_value(pd->gpio, value);
>> +	}
> 
> I'd be tempted to simplify the new code a little:
> 
> 	/* invert value if S3C24XX_LEDF_ACTLOW is set */
> 	value = !!(pd->flags & S3C24XX_LEDF_ACTLOW) ^ !!value;
> 
> 	if (pd->flags & S3C24XX_LEDF_TRISTATE) {
> 		if (value)
> 			gpio_direction_output(pd->gpio, value);
> 		else
> 			gpio_direction_input(pd->gpio);
> 	} else {
> 		gpio_set_value(pd->gpio, value);
> 	}

I've almost broke my mind writing this part and you've repeated my
mistake: in line where 'value' is checked ( if(value) ) the 'value'
shouldn't be inverted independently of S3C24XX_LEDF_ACTLOW flag.
This because S3C24XX_LEDF_TRISTATE means "tristate to turn off"
(arch/arm/mach-s3c2410/include/mach/leds-gpio.h:18) - that produces all
of complexity. Hope my description is understandable (if not, I'm sorry
- my English is too bad for this).

>> @@ -76,7 +88,8 @@ static int s3c24xx_led_probe(struct platform_device *dev)
>>  	led = kzalloc(sizeof(struct s3c24xx_gpio_led), GFP_KERNEL);
>>  	if (led == NULL) {
>>  		dev_err(&dev->dev, "No memory for device\n");
>> -		return -ENOMEM;
>> +		ret = -ENOMEM;
>> +		goto err_kzalloc;
>>  	}
>
> That works fine, but isn't strictly necessary; no previous allocations
> have been made here that need to be undone.
> 

I tried to use same error handling approach in all code, but you are
right - I've missed that in this place we can return safely and not
loosing much of code readability. _But_ this violates approach of not
having multiple returns unless you *really* need this. Still in doubt...

>> @@ -91,12 +104,15 @@ static int s3c24xx_led_probe(struct platform_device
>> *dev)
>>  	/* no point in having a pull-up if we are always driving */
>>
>>  	if (pdata->flags & S3C24XX_LEDF_TRISTATE) {
>> -		s3c2410_gpio_setpin(pdata->gpio, 0);
>> -		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_INPUT);
>> +		ret = gpio_request_one(pdata->gpio, GPIOF_IN, pdata->name);
>>  	} else {
>> -		s3c2410_gpio_pullup(pdata->gpio, 0);
>> -		s3c2410_gpio_setpin(pdata->gpio, 0);
>> -		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_OUTPUT);
>> +		ret = gpio_request_one(pdata->gpio, GPIOF_OUT_INIT_LOW,
>> +												pdata->name);
>> +		s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_NONE);
>> +	}
> 
> I always prefer not to duplicate function calls, but rather to calculate
> the differing data (either directly in the call, or into a temporary
> variable first), so:
> 
> 	ret = gpio_request_one(pdata->gpio, 
> 				(pdata->flags & S3C24XX_LEDF_TRISTATE) ?
> 				GPIOF_IN : GPIOF_OUT_INIT_LOW,
> 				pdata->name);
> 
> 	if (!(pdata->flags & S3C24XX_LEDF_TRISTATE))
> 		s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_NONE);
> 
> 
>> +	if (ret < 0) {
>> +		dev_err(&dev->dev, "gpio_request failed\n");
>> +		goto err_gpio_request;
>>  	}
> 
> You should probably move that error check right after calling
> gpio_request_one()
> 

I see no big difference between those two variants, but:
  1. my code looks for more readable
  2. your code allows not to call 's3c_gpio_setpull' in case of
gpio_request fail which looks like the _only_ usable variant.

Besides that, I've made a mistake changing

s3c2410_gpio_pullup(pdata->gpio, 0)
to
s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_NONE)

because first variant actually means *enable* pull, trying first UP and,
if fail, DOWN direction. So pull-resistor is enabled in this case but in
some *random* direction.

The only use case for pull-resistor I see here is not to left pin
floating if someone configured _tristate_off_ LED on pin which actually
don't have it (LED or anything other connected). Considering this and a
fact that pullup is default enabled I think that it's safe to remove
it's configuration at all and left code in my variant. Or to add
pull-resistor enabling code for *opposite* case (S3C24XX_LEDF_TRISTATE).

-- 
Best regards, Denis Kuzmenko.
