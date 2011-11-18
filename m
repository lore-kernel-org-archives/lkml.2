Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab1KRVsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:48:01 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11259 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab1KRVr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:47:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 18 Nov 2011 13:47:58 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Denis Kuzmenko <linux@solonet.org.ua>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Wolfram Sang <w.sang@pengutronix.de>
Date: Fri, 18 Nov 2011 13:47:57 -0800
Subject: RE: [PATCH] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
Thread-Topic: [PATCH] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
Thread-Index: AcymNPVtu2R6Um8dSsCvy5w1sIKPMgABbuMA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74F9D@HQMAIL01.nvidia.com>
References: <4EC572E1.1020209@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74E87@HQMAIL01.nvidia.com>
 <4EC6C785.5010801@solonet.org.ua>
In-Reply-To: <4EC6C785.5010801@solonet.org.ua>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Kuzmenko wrote at Friday, November 18, 2011 2:01 PM:
> On 11/18/2011 07:08 PM, Stephen Warren wrote:
> > Denis Kuzmenko wrote at Thursday, November 17, 2011 1:47 PM:
> >> Make s3c24xx LEDS driver use gpiolib.
> >
> > I made some slightly nit-picky
> > comments below.
> 
> Thanks for looking my patch.
> 
> >> diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
> >
> >>  static void s3c24xx_led_set(struct led_classdev *led_cdev,
> >> -			    enum led_brightness value)
> >> +				enum led_brightness value)
> >
> > Seems unnecessary, but is probably fine.
> 
> That was made unintentionally - will fix in next version.
> 
> >>  {
> >>  	struct s3c24xx_gpio_led *led = to_gpio(led_cdev);
> >>  	struct s3c24xx_led_platdata *pd = led->pdata;
> >>
> >> -	/* there will be a short delay between setting the output and
> >> -	 * going from output to input when using tristate. */
> >> -
> >> -	s3c2410_gpio_setpin(pd->gpio, (value ? 1 : 0) ^
> >> -			    (pd->flags & S3C24XX_LEDF_ACTLOW));
> >> -
> >> -	if (pd->flags & S3C24XX_LEDF_TRISTATE)
> >> -		s3c2410_gpio_cfgpin(pd->gpio,
> >> -			value ? S3C2410_GPIO_OUTPUT : S3C2410_GPIO_INPUT);
> >> +	/*
> >> +	 * ensure value is 0 or 1 to use it with bitwise XOR (^)
> >> +	 * (only 100% brightness is supported)
> >> +	 */
> >> +	value = value ? 1 : 0;
> >> +
> >> +	if (pd->flags & S3C24XX_LEDF_TRISTATE) {
> >> +		if (value) {
> >> +			/* invert value if S3C24XX_LEDF_ACTLOW is set */
> >> +			value = (pd->flags & S3C24XX_LEDF_ACTLOW) ^ value;
> >> +			gpio_direction_output(pd->gpio, value);
> >> +		} else {
> >> +			gpio_direction_input(pd->gpio);
> >> +		}
> >> +	} else {
> >> +		/* invert value if S3C24XX_LEDF_ACTLOW is set */
> >> +		value = (pd->flags & S3C24XX_LEDF_ACTLOW) ^ value;
> >> +		gpio_set_value(pd->gpio, value);
> >> +	}
> >
> > I'd be tempted to simplify the new code a little:
> >
> > 	/* invert value if S3C24XX_LEDF_ACTLOW is set */
> > 	value = !!(pd->flags & S3C24XX_LEDF_ACTLOW) ^ !!value;
> >
> > 	if (pd->flags & S3C24XX_LEDF_TRISTATE) {
> > 		if (value)
> > 			gpio_direction_output(pd->gpio, value);
> > 		else
> > 			gpio_direction_input(pd->gpio);
> > 	} else {
> > 		gpio_set_value(pd->gpio, value);
> > 	}
> 
> I've almost broke my mind writing this part and you've repeated my
> mistake: in line where 'value' is checked ( if(value) ) the 'value'
> shouldn't be inverted independently of S3C24XX_LEDF_ACTLOW flag.
> This because S3C24XX_LEDF_TRISTATE means "tristate to turn off"
> (arch/arm/mach-s3c2410/include/mach/leds-gpio.h:18) - that produces all
> of complexity. Hope my description is understandable (if not, I'm sorry
> - my English is too bad for this).

Oh right yes. I guess you'd need to make the assignment to a second
variable instead of over-writing value then. Given that, your original
code is probably fine.

> >> @@ -76,7 +88,8 @@ static int s3c24xx_led_probe(struct platform_device *dev)
> >>  	led = kzalloc(sizeof(struct s3c24xx_gpio_led), GFP_KERNEL);
> >>  	if (led == NULL) {
> >>  		dev_err(&dev->dev, "No memory for device\n");
> >> -		return -ENOMEM;
> >> +		ret = -ENOMEM;
> >> +		goto err_kzalloc;
> >>  	}
> >
> > That works fine, but isn't strictly necessary; no previous allocations
> > have been made here that need to be undone.
> 
> I tried to use same error handling approach in all code, but you are
> right - I've missed that in this place we can return safely and not
> loosing much of code readability. _But_ this violates approach of not
> having multiple returns unless you *really* need this. Still in doubt...
> 
> >> @@ -91,12 +104,15 @@ static int s3c24xx_led_probe(struct platform_device
> >> *dev)
> >>  	/* no point in having a pull-up if we are always driving */
> >>
> >>  	if (pdata->flags & S3C24XX_LEDF_TRISTATE) {
> >> -		s3c2410_gpio_setpin(pdata->gpio, 0);
> >> -		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_INPUT);
> >> +		ret = gpio_request_one(pdata->gpio, GPIOF_IN, pdata->name);
> >>  	} else {
> >> -		s3c2410_gpio_pullup(pdata->gpio, 0);
> >> -		s3c2410_gpio_setpin(pdata->gpio, 0);
> >> -		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_OUTPUT);
> >> +		ret = gpio_request_one(pdata->gpio, GPIOF_OUT_INIT_LOW,
> >> +												pdata->name);
> >> +		s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_NONE);
> >> +	}
> >
> > I always prefer not to duplicate function calls, but rather to calculate
> > the differing data (either directly in the call, or into a temporary
> > variable first), so:
> >
> > 	ret = gpio_request_one(pdata->gpio,
> > 				(pdata->flags & S3C24XX_LEDF_TRISTATE) ?
> > 				GPIOF_IN : GPIOF_OUT_INIT_LOW,
> > 				pdata->name);
> >
> > 	if (!(pdata->flags & S3C24XX_LEDF_TRISTATE))
> > 		s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_NONE);
> >
> >
> >> +	if (ret < 0) {
> >> +		dev_err(&dev->dev, "gpio_request failed\n");
> >> +		goto err_gpio_request;
> >>  	}
> >
> > You should probably move that error check right after calling
> > gpio_request_one()
> >
> 
> I see no big difference between those two variants, but:
>   1. my code looks for more readable

I actually wrote my comment because I found the function call duplication
less readable. But, this is probably personal preference. Using a temporary
variable rather than a ternary operator in the function call might help.

>   2. your code allows not to call 's3c_gpio_setpull' in case of
> gpio_request fail which looks like the _only_ usable variant.
> 
> Besides that, I've made a mistake changing
> 
> s3c2410_gpio_pullup(pdata->gpio, 0)
> to
> s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_NONE)
> 
> because first variant actually means *enable* pull, trying first UP and,
> if fail, DOWN direction. So pull-resistor is enabled in this case but in
> some *random* direction.
> 
> The only use case for pull-resistor I see here is not to left pin
> floating if someone configured _tristate_off_ LED on pin which actually
> don't have it (LED or anything other connected). Considering this and a
> fact that pullup is default enabled I think that it's safe to remove
> it's configuration at all and left code in my variant. Or to add
> pull-resistor enabling code for *opposite* case (S3C24XX_LEDF_TRISTATE).

-- 
nvpublic

