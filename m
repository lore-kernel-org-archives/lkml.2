Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab1IFD6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 23:58:30 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57884 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751307Ab1IFD6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 23:58:23 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18mWG0egWEmEJPx8Lv9SB3sxueyLR7XXWgRE3hjun
	6+f0a1kHE4/IiD
Message-ID: <4E659A56.9060305@gmx.de>
Date: Tue, 06 Sep 2011 03:58:14 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: [PATCH] backlight: Fix broken regulator API usage in l4f00242t03
References: <1315246208-26006-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1315246208-26006-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm, it looks like Richard did not respond on this email address for months. But
I noticed there exists a Richard@linuxfoundation and according to
http://lwn.net/Articles/419640/rss
I'd guess it is the same person. If this is true, would you, Richard, *please*
update your email address in MAINTAINERS so people do not needlessly wait for
feedback for ages.
For the patch itself, it looks good to me, but I really feel not qualified to
handle the backlight things. So I'll let handle Andrew any backlight patches for
now but could carry patches in my tree if they get Richard's Ack/Signed-off.


Best regards,

Florian Tobias Schandinat


On 09/05/2011 06:10 PM, Mark Brown wrote:
> The regulator support in the l4f00242t03 is very non-idiomatic, rather
> than requesting the regulators based on the device name and the supply
> names used by the device the driver requires boards to pass system
> specific supply names around through platform data. The driver also
> conditionally requests the regulators based on this platform data, adding
> unneeded conditional code to the driver.
> 
> Fix this by removing the platform data and converting to the standard idiom,
> also updating all in tree users of the driver. As no datasheet appears to
> be available for the LCD I'm guessing the names for the supplies based on
> the existing users and I've no ability to do anything more than compile
> test.
> 
> The use of regulator_set_voltage() in the driver is also problematic, since
> fixed voltages are required the expectation would be that the voltages
> would be fixed in the constraints set by the machines rather than manually
> configured by the driver, but is less problematic.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  arch/arm/mach-imx/mach-mx27_3ds.c     |    6 +--
>  arch/arm/mach-imx/mach-mx31_3ds.c     |    6 +--
>  drivers/video/backlight/l4f00242t03.c |   57 +++++++++++---------------------
>  include/linux/spi/l4f00242t03.h       |    2 -
>  4 files changed, 24 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mach-mx27_3ds.c b/arch/arm/mach-imx/mach-mx27_3ds.c
> index 2eafbac..3772304 100644
> --- a/arch/arm/mach-imx/mach-mx27_3ds.c
> +++ b/arch/arm/mach-imx/mach-mx27_3ds.c
> @@ -241,7 +241,7 @@ static struct regulator_init_data gpo_init = {
>  };
>  
>  static struct regulator_consumer_supply vmmc1_consumers[] = {
> -	REGULATOR_SUPPLY("lcd_2v8", NULL),
> +	REGULATOR_SUPPLY("vcore", "spi0.0"),
>  };
>  
>  static struct regulator_init_data vmmc1_init = {
> @@ -257,7 +257,7 @@ static struct regulator_init_data vmmc1_init = {
>  };
>  
>  static struct regulator_consumer_supply vgen_consumers[] = {
> -	REGULATOR_SUPPLY("vdd_lcdio", NULL),
> +	REGULATOR_SUPPLY("vdd", "spi0.0"),
>  };
>  
>  static struct regulator_init_data vgen_init = {
> @@ -348,8 +348,6 @@ static const struct imx_fb_platform_data mx27_3ds_fb_data __initconst = {
>  static struct l4f00242t03_pdata mx27_3ds_lcd_pdata = {
>  	.reset_gpio		= LCD_RESET,
>  	.data_enable_gpio	= LCD_ENABLE,
> -	.core_supply		= "lcd_2v8",
> -	.io_supply		= "vdd_lcdio",
>  };
>  
>  static struct spi_board_info mx27_3ds_spi_devs[] __initdata = {
> diff --git a/arch/arm/mach-imx/mach-mx31_3ds.c b/arch/arm/mach-imx/mach-mx31_3ds.c
> index 589066f..6484db5 100644
> --- a/arch/arm/mach-imx/mach-mx31_3ds.c
> +++ b/arch/arm/mach-imx/mach-mx31_3ds.c
> @@ -285,8 +285,6 @@ static struct mx3fb_platform_data mx3fb_pdata __initdata = {
>  static struct l4f00242t03_pdata mx31_3ds_l4f00242t03_pdata = {
>  	.reset_gpio		= IOMUX_TO_GPIO(MX31_PIN_LCS1),
>  	.data_enable_gpio	= IOMUX_TO_GPIO(MX31_PIN_SER_RS),
> -	.core_supply		= "lcd_2v8",
> -	.io_supply		= "vdd_lcdio",
>  };
>  
>  /*
> @@ -411,7 +409,7 @@ static struct regulator_init_data vmmc2_init = {
>  };
>  
>  static struct regulator_consumer_supply vmmc1_consumers[] = {
> -	REGULATOR_SUPPLY("lcd_2v8", NULL),
> +	REGULATOR_SUPPLY("vcore", "spi0.0"),
>  	REGULATOR_SUPPLY("cmos_2v8", "soc-camera-pdrv.0"),
>  };
>  
> @@ -428,7 +426,7 @@ static struct regulator_init_data vmmc1_init = {
>  };
>  
>  static struct regulator_consumer_supply vgen_consumers[] = {
> -	REGULATOR_SUPPLY("vdd_lcdio", NULL),
> +	REGULATOR_SUPPLY("vdd", "spi0.0"),
>  };
>  
>  static struct regulator_init_data vgen_init = {
> diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
> index 046c7aa..1ce32fd 100644
> --- a/drivers/video/backlight/l4f00242t03.c
> +++ b/drivers/video/backlight/l4f00242t03.c
> @@ -53,15 +53,11 @@ static void l4f00242t03_lcd_init(struct spi_device *spi)
>  
>  	dev_dbg(&spi->dev, "initializing LCD\n");
>  
> -	if (priv->io_reg) {
> -		regulator_set_voltage(priv->io_reg, 1800000, 1800000);
> -		regulator_enable(priv->io_reg);
> -	}
> +	regulator_set_voltage(priv->io_reg, 1800000, 1800000);
> +	regulator_enable(priv->io_reg);
>  
> -	if (priv->core_reg) {
> -		regulator_set_voltage(priv->core_reg, 2800000, 2800000);
> -		regulator_enable(priv->core_reg);
> -	}
> +	regulator_set_voltage(priv->core_reg, 2800000, 2800000);
> +	regulator_enable(priv->core_reg);
>  
>  	l4f00242t03_reset(pdata->reset_gpio);
>  
> @@ -79,11 +75,8 @@ static void l4f00242t03_lcd_powerdown(struct spi_device *spi)
>  
>  	gpio_set_value(pdata->data_enable_gpio, 0);
>  
> -	if (priv->io_reg)
> -		regulator_disable(priv->io_reg);
> -
> -	if (priv->core_reg)
> -		regulator_disable(priv->core_reg);
> +	regulator_disable(priv->io_reg);
> +	regulator_disable(priv->core_reg);
>  }
>  
>  static int l4f00242t03_lcd_power_get(struct lcd_device *ld)
> @@ -202,24 +195,18 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
>  	if (ret)
>  		goto err3;
>  
> -	if (pdata->io_supply) {
> -		priv->io_reg = regulator_get(NULL, pdata->io_supply);
> -
> -		if (IS_ERR(priv->io_reg)) {
> -			pr_err("%s: Unable to get the IO regulator\n",
> -								__func__);
> -			goto err3;
> -		}
> +	priv->io_reg = regulator_get(&spi->dev, "vdd");
> +	if (IS_ERR(priv->io_reg)) {
> +		dev_err(&spi->dev, "%s: Unable to get the IO regulator\n",
> +		       __func__);
> +		goto err3;
>  	}
>  
> -	if (pdata->core_supply) {
> -		priv->core_reg = regulator_get(NULL, pdata->core_supply);
> -
> -		if (IS_ERR(priv->core_reg)) {
> -			pr_err("%s: Unable to get the core regulator\n",
> -								__func__);
> -			goto err4;
> -		}
> +	priv->core_reg = regulator_get(&spi->dev, "vcore");
> +	if (IS_ERR(priv->core_reg)) {
> +		dev_err(&spi->dev, "%s: Unable to get the core regulator\n",
> +		       __func__);
> +		goto err4;
>  	}
>  
>  	priv->ld = lcd_device_register("l4f00242t03",
> @@ -239,11 +226,9 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
>  	return 0;
>  
>  err5:
> -	if (priv->core_reg)
> -		regulator_put(priv->core_reg);
> +	regulator_put(priv->core_reg);
>  err4:
> -	if (priv->io_reg)
> -		regulator_put(priv->io_reg);
> +	regulator_put(priv->io_reg);
>  err3:
>  	gpio_free(pdata->data_enable_gpio);
>  err2:
> @@ -267,10 +252,8 @@ static int __devexit l4f00242t03_remove(struct spi_device *spi)
>  	gpio_free(pdata->data_enable_gpio);
>  	gpio_free(pdata->reset_gpio);
>  
> -	if (priv->io_reg)
> -		regulator_put(priv->io_reg);
> -	if (priv->core_reg)
> -		regulator_put(priv->core_reg);
> +	regulator_put(priv->io_reg);
> +	regulator_put(priv->core_reg);
>  
>  	kfree(priv);
>  
> diff --git a/include/linux/spi/l4f00242t03.h b/include/linux/spi/l4f00242t03.h
> index aee1dbd..bc8677c 100644
> --- a/include/linux/spi/l4f00242t03.h
> +++ b/include/linux/spi/l4f00242t03.h
> @@ -24,8 +24,6 @@
>  struct l4f00242t03_pdata {
>  	unsigned int	reset_gpio;
>  	unsigned int	data_enable_gpio;
> -	const char 	*io_supply;	/* will be set to 1.8 V */
> -	const char 	*core_supply;	/* will be set to 2.8 V */
>  };
>  
>  #endif /* _INCLUDE_LINUX_SPI_L4F00242T03_H_ */

