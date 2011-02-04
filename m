Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab1BDJfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 04:35:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40446 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab1BDJfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 04:35:08 -0500
Date: Fri, 4 Feb 2011 10:34:58 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 15/19] mc13xxx: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110204093458.GH30452@pengutronix.de>
References: <20110202195417.228e2656@queued.net>
 <20110202202015.0fe392a9@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110202202015.0fe392a9@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andres,

On Wed, Feb 02, 2011 at 08:20:15PM -0800, Andres Salomon wrote:
> 
> No need to explicitly set the cell's platform_data/data_size.
> 
> In this case, move the various platform_data pointers
> to driver_data.  All of the clients which make use of it
> are also changed.
> 
> Mfd-core makes a copy of platform_data, but driver_data keeps a pointer
> to the original data.  Because each cell's platform_data previously
> pointed to a local (stack) variable, the various ARM mach types that set
> the pdata are updated to keep the memory around.
I didn't get this even after reading it 5 times.  You wrote in the
subject that drivers now have access to mfd_cell.  I don't see where
e.g. drivers/leds/leds-mc13783.c uses that?!  Does this depend on some
mfd-changes I don't see and this is just a first step?

After reading the changes I think I understood:

 - You made things that were passed as platform_data before available
   via driver_data.
 - Because platform_data is copied and driver_data is not at register
   time, the data being platform_data cannot be __initdata or stack
   local anymore, so this needs fixing.

In sum this results in .data becoming bigger (which is bad).

And I think this patch has a conceptual problem, too.  In my opionion
platform_data is the point to hand over platform specific data to a
driver.  driver_data is something that is private to the driver and has
to be considered opaque for the platform.  The driver was sort of OK
before ...

> diff --git a/arch/arm/mach-imx/mach-mx27_3ds.c b/arch/arm/mach-imx/mach-mx27_3ds.c
> index 1643315..edcecaa 100644
> --- a/arch/arm/mach-imx/mach-mx27_3ds.c
> +++ b/arch/arm/mach-imx/mach-mx27_3ds.c
> @@ -226,10 +226,14 @@ static struct mc13783_regulator_init_data mx27_3ds_regulators[] = {
>  	},
>  };
>  
> -/* MC13783 */
> -static struct mc13783_platform_data mc13783_pdata __initdata = {
> +static struct mc13783_regulator_platform_data mx27_regs = {
The prefix mx27 is misleading. If you want to take the machine name
into account use mx27_3ds, otherwise just use mc13783_regulator_pdata or
similar. (And note that "regs" isn't that good IMHO, too, as it might
stand for registers, too. And even mx27_3ds_regulators would be too
general. This applies to the changes below, too.)

>  	.regulators = mx27_3ds_regulators,
>  	.num_regulators = ARRAY_SIZE(mx27_3ds_regulators),
> +};
> +
> +/* MC13783 */
a very minor nitpick is you moved the comment for mx27_3ds, but not for
e.g. mx31_3ds.

> +static struct mc13783_platform_data mc13783_pdata __initdata = {
> +	.regulators = &mx27_regs,
>  	.flags  = MC13783_USE_REGULATOR,
>  };
>  
> diff --git a/arch/arm/mach-imx/mach-pcm038.c b/arch/arm/mach-imx/mach-pcm038.c
> index 5056148..b5ae8cc 100644
> --- a/arch/arm/mach-imx/mach-pcm038.c
> +++ b/arch/arm/mach-imx/mach-pcm038.c
> @@ -262,9 +262,13 @@ static struct mc13783_regulator_init_data pcm038_regulators[] = {
>  	},
>  };
>  
> -static struct mc13783_platform_data pcm038_pmic = {
> +static struct mc13783_regulator_platform_data pcm038_regs = {
>  	.regulators = pcm038_regulators,
>  	.num_regulators = ARRAY_SIZE(pcm038_regulators),
> +};
> +
> +static struct mc13783_platform_data pcm038_pmic = {
> +	.regulators = &pcm038_regs,
>  	.flags = MC13783_USE_ADC | MC13783_USE_REGULATOR |
>  		 MC13783_USE_TOUCHSCREEN,
>  };
> diff --git a/arch/arm/mach-mx3/mach-mx31_3ds.c b/arch/arm/mach-mx3/mach-mx31_3ds.c
> index 0d65db8..3e613ee 100644
> --- a/arch/arm/mach-mx3/mach-mx31_3ds.c
> +++ b/arch/arm/mach-mx3/mach-mx31_3ds.c
> @@ -156,9 +156,13 @@ static struct mc13783_regulator_init_data mx31_3ds_regulators[] = {
>  };
>  
>  /* MC13783 */
> -static struct mc13783_platform_data mc13783_pdata __initdata = {
> +static struct mc13783_regulator_platform_data mc13783_regs = {
>  	.regulators = mx31_3ds_regulators,
>  	.num_regulators = ARRAY_SIZE(mx31_3ds_regulators),
> +};
> +
> +static struct mc13783_platform_data mc13783_pdata __initdata = {
> +	.regulators = &mc13783_regs,
>  	.flags  = MC13783_USE_REGULATOR | MC13783_USE_TOUCHSCREEN,
>  };
>  
> diff --git a/arch/arm/mach-mx3/mach-mx31moboard.c b/arch/arm/mach-mx3/mach-mx31moboard.c
> index 1aa8d65..424fbd9 100644
> --- a/arch/arm/mach-mx3/mach-mx31moboard.c
> +++ b/arch/arm/mach-mx3/mach-mx31moboard.c
> @@ -267,9 +267,13 @@ static struct mc13783_leds_platform_data moboard_leds = {
>  	.tc2_period = MC13783_LED_PERIOD_10MS,
>  };
>  
> -static struct mc13783_platform_data moboard_pmic = {
> +static struct mc13783_regulator_platform_data moboard_regs = {
>  	.regulators = moboard_regulators,
>  	.num_regulators = ARRAY_SIZE(moboard_regulators),
> +};
> +
> +static struct mc13783_platform_data moboard_pmic = {
> +	.regulators = &moboard_regs,
>  	.leds = &moboard_leds,
>  	.flags = MC13783_USE_REGULATOR | MC13783_USE_RTC |
>  		MC13783_USE_ADC | MC13783_USE_LED,
> diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
> index f05bb08..687fb13 100644
> --- a/drivers/leds/leds-mc13783.c
> +++ b/drivers/leds/leds-mc13783.c
> @@ -30,6 +30,7 @@ struct mc13783_led {
>  	struct mc13783		*master;
>  	enum led_brightness	new_brightness;
>  	int			id;
> +	int			num_leds;
>  };
>  
>  #define MC13783_REG_LED_CONTROL_0	51
> @@ -181,9 +182,9 @@ static int __devinit mc13783_led_setup(struct mc13783_led *led, int max_current)
>  	return ret;
>  }
>  
> -static int __devinit mc13783_leds_prepare(struct platform_device *pdev)
> +static int __devinit mc13783_leds_prepare(struct platform_device *pdev,
> +		struct mc13783_leds_platform_data *pdata)
>  {
> -	struct mc13783_leds_platform_data *pdata = dev_get_platdata(&pdev->dev);
>  	struct mc13783 *dev = dev_get_drvdata(pdev->dev.parent);
>  	int ret = 0;
>  	int reg = 0;
> @@ -264,7 +265,7 @@ out:
>  
>  static int __devinit mc13783_led_probe(struct platform_device *pdev)
>  {
> -	struct mc13783_leds_platform_data *pdata = dev_get_platdata(&pdev->dev);
> +	struct mc13783_leds_platform_data *pdata = platform_get_drvdata(pdev);
>  	struct mc13783_led_platform_data *led_cur;
>  	struct mc13783_led *led, *led_dat;
>  	int ret, i;
> @@ -286,12 +287,15 @@ static int __devinit mc13783_led_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	ret = mc13783_leds_prepare(pdev);
> +	ret = mc13783_leds_prepare(pdev, pdata);
>  	if (ret) {
>  		dev_err(&pdev->dev, "unable to init led driver\n");
>  		goto err_free;
>  	}
>  
> +	/* no need to save the num of LEDs for any other elements of 'led' */
> +	led[0].num_leds = pdata->num_leds;
> +
So for n leds you introduced n-1 useless ints.

So all in all, I don't like that change, maybe just because I don't
understand your motivation.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
