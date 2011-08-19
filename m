Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1HSJxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 05:53:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47474 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab1HSJx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 05:53:28 -0400
Date: Fri, 19 Aug 2011 11:53:26 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Robert Schwebel <rsc@pengutronix.de>
Subject: Re: [PATCH] mfd wm8350: rename static gpio_set_debounce()
Message-ID: <20110819095326.GB22865@pengutronix.de>
References: <20110810080549.GX31404@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110810080549.GX31404@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Wed, Aug 10, 2011 at 10:05:49AM +0200, Sascha Hauer wrote:
> 
> The kernel already has a function with this name declared
> in asm-generic/gpio.h. So if this header leaks into wm8350/gpio.c
> we get
> 
> drivers/mfd/wm8350-gpio.c:40:12: error: conflicting types for 'gpio_set_debounce'
> include/asm-generic/gpio.h:156:12: note: previous declaration of 'gpio_set_debounce' was here
> 
> Fix this by adding a wm8350_ prefix to the function.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
> 
> This is the minimal solution to this problem. It would be more
> consistent though not required to add a wm8350_ prefix to the
> other functions in this file aswell. Let me know what you prefer.
> 
>  drivers/mfd/wm8350-gpio.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/wm8350-gpio.c b/drivers/mfd/wm8350-gpio.c
> index ebf99be..d584f6b 100644
> --- a/drivers/mfd/wm8350-gpio.c
> +++ b/drivers/mfd/wm8350-gpio.c
> @@ -37,7 +37,7 @@ static int gpio_set_dir(struct wm8350 *wm8350, int gpio, int dir)
>  	return ret;
>  }
>  
> -static int gpio_set_debounce(struct wm8350 *wm8350, int gpio, int db)
> +static int wm8350_gpio_set_debounce(struct wm8350 *wm8350, int gpio, int db)
>  {
>  	if (db == WM8350_GPIO_DEBOUNCE_ON)
>  		return wm8350_set_bits(wm8350, WM8350_GPIO_DEBOUNCE,
> @@ -210,7 +210,7 @@ int wm8350_gpio_config(struct wm8350 *wm8350, int gpio, int dir, int func,
>  		goto err;
>  	if (gpio_set_polarity(wm8350, gpio, pol))
>  		goto err;
> -	if (gpio_set_debounce(wm8350, gpio, debounce))
> +	if (wm8350_gpio_set_debounce(wm8350, gpio, debounce))
>  		goto err;
>  	if (gpio_set_dir(wm8350, gpio, dir))
>  		goto err;
Can you please apply this patch? Even though it works around something
ugly (IMHO), it fixes a build failure on arm/imx. (Not on a vanilla
defconfig though.)

the following happens on next-20110819 and Linus' master:

	...
	  CC      drivers/mfd/wm8350-gpio.o
	/home/ukleinek/gsrc/linux-2.6/drivers/mfd/wm8350-gpio.c:40:12: error: conflicting types for 'gpio_set_debounce'
	/home/ukleinek/gsrc/linux-2.6/include/asm-generic/gpio.h:156:12: note: previous declaration of 'gpio_set_debounce' was here
	make[3]: *** [drivers/mfd/wm8350-gpio.o] Error 1
	make[2]: *** [drivers/mfd/wm8350-gpio.o] Error 2
	make[1]: *** [sub-make] Error 2
	make: *** [all] Error 2

Best regards,
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
