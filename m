Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab1LLISY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 03:18:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59922 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1LLISW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 03:18:22 -0500
Date: Mon, 12 Dec 2011 00:18:16 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 09/10] input: serio: ams-delta: Toggle keyboard power
 over GPIO
Message-ID: <20111212081816.GG4682@core.coreip.homeip.net>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <1323634328-856-10-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323634328-856-10-git-send-email-jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 11, 2011 at 09:12:07PM +0100, Janusz Krzysztofik wrote:
> Don't use Amstrad Delta custom I/O functions once GPIO interface is
> available for the underlying hardware.
> 
> Depends on patch 8/10 "omapfb: lcd_ams_delta: Drive control lines over
> GPIO".
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

Acked-by: Dmitry Torokhov <dtor@mail.ru>

> ---
>  arch/arm/mach-omap1/board-ams-delta.c             |    5 --
>  arch/arm/plat-omap/include/plat/board-ams-delta.h |    2 -
>  drivers/input/serio/ams_delta_serio.c             |   45 +++++++++++---------
>  3 files changed, 25 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
> index b7422e3..587118c 100644
> --- a/arch/arm/mach-omap1/board-ams-delta.c
> +++ b/arch/arm/mach-omap1/board-ams-delta.c
> @@ -232,11 +232,6 @@ static struct gpio _latch_gpios[] __initconst = {
>  		.label	= "dockit2",
>  	},
>  	{
> -		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_PWR,
> -		.flags	= GPIOF_OUT_INIT_LOW,
> -		.label	= "keybrd_pwr",
> -	},
> -	{
>  		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_DATAOUT,
>  		.flags	= GPIOF_OUT_INIT_LOW,
>  		.label	= "keybrd_dataout",
> diff --git a/arch/arm/plat-omap/include/plat/board-ams-delta.h b/arch/arm/plat-omap/include/plat/board-ams-delta.h
> index 1d0706e..004c827 100644
> --- a/arch/arm/plat-omap/include/plat/board-ams-delta.h
> +++ b/arch/arm/plat-omap/include/plat/board-ams-delta.h
> @@ -28,8 +28,6 @@
>  
>  #if defined (CONFIG_MACH_AMS_DELTA)
>  
> -#define AMD_DELTA_LATCH2_KEYBRD_PWR	0x0100
> -#define AMD_DELTA_LATCH2_KEYBRD_DATA	0x0200
>  #define AMD_DELTA_LATCH2_SCARD_RSTIN	0x0400
>  #define AMD_DELTA_LATCH2_SCARD_CMDVCC	0x0800
>  
> diff --git a/drivers/input/serio/ams_delta_serio.c b/drivers/input/serio/ams_delta_serio.c
> index d4d08bd..1499c7d 100644
> --- a/drivers/input/serio/ams_delta_serio.c
> +++ b/drivers/input/serio/ams_delta_serio.c
> @@ -92,8 +92,7 @@ static irqreturn_t ams_delta_serio_interrupt(int irq, void *dev_id)
>  static int ams_delta_serio_open(struct serio *serio)
>  {
>  	/* enable keyboard */
> -	ams_delta_latch2_write(AMD_DELTA_LATCH2_KEYBRD_PWR,
> -			AMD_DELTA_LATCH2_KEYBRD_PWR);
> +	gpio_set_value(AMS_DELTA_GPIO_PIN_KEYBRD_PWR, 1);
>  
>  	return 0;
>  }
> @@ -101,9 +100,26 @@ static int ams_delta_serio_open(struct serio *serio)
>  static void ams_delta_serio_close(struct serio *serio)
>  {
>  	/* disable keyboard */
> -	ams_delta_latch2_write(AMD_DELTA_LATCH2_KEYBRD_PWR, 0);
> +	gpio_set_value(AMS_DELTA_GPIO_PIN_KEYBRD_PWR, 0);
>  }
>  
> +static struct gpio _gpios[] __initconst_or_module = {
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_DATA,
> +		.flags	= GPIOF_DIR_IN,
> +		.label	= "serio-data",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_CLK,
> +		.flags	= GPIOF_DIR_IN,
> +		.label	= "serio-clock",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_PWR,
> +		.flags	= GPIOF_OUT_INIT_LOW,
> +		.label	= "serio-power",
> +	},
> +};
>  static int __init ams_delta_serio_init(void)
>  {
>  	int err;
> @@ -123,19 +139,11 @@ static int __init ams_delta_serio_init(void)
>  	strlcpy(ams_delta_serio->phys, "GPIO/serio0",
>  			sizeof(ams_delta_serio->phys));
>  
> -	err = gpio_request(AMS_DELTA_GPIO_PIN_KEYBRD_DATA, "serio-data");
> +	err = gpio_request_array(_gpios, ARRAY_SIZE(_gpios));
>  	if (err) {
> -		pr_err("ams_delta_serio: Couldn't request gpio pin for data\n");
> +		pr_err("ams_delta_serio: Couldn't request gpio pins\n");
>  		goto serio;
>  	}
> -	gpio_direction_input(AMS_DELTA_GPIO_PIN_KEYBRD_DATA);
> -
> -	err = gpio_request(AMS_DELTA_GPIO_PIN_KEYBRD_CLK, "serio-clock");
> -	if (err) {
> -		pr_err("ams_delta_serio: couldn't request gpio pin for clock\n");
> -		goto gpio_data;
> -	}
> -	gpio_direction_input(AMS_DELTA_GPIO_PIN_KEYBRD_CLK);
>  
>  	err = request_irq(gpio_to_irq(AMS_DELTA_GPIO_PIN_KEYBRD_CLK),
>  			ams_delta_serio_interrupt, IRQ_TYPE_EDGE_RISING,
> @@ -143,7 +151,7 @@ static int __init ams_delta_serio_init(void)
>  	if (err < 0) {
>  		pr_err("ams_delta_serio: couldn't request gpio interrupt %d\n",
>  				gpio_to_irq(AMS_DELTA_GPIO_PIN_KEYBRD_CLK));
> -		goto gpio_clk;
> +		goto gpio;
>  	}
>  	/*
>  	 * Since GPIO register handling for keyboard clock pin is performed
> @@ -157,10 +165,8 @@ static int __init ams_delta_serio_init(void)
>  	dev_info(&ams_delta_serio->dev, "%s\n", ams_delta_serio->name);
>  
>  	return 0;
> -gpio_clk:
> -	gpio_free(AMS_DELTA_GPIO_PIN_KEYBRD_CLK);
> -gpio_data:
> -	gpio_free(AMS_DELTA_GPIO_PIN_KEYBRD_DATA);
> +gpio:
> +	gpio_free_array(_gpios, ARRAY_SIZE(_gpios));
>  serio:
>  	kfree(ams_delta_serio);
>  	return err;
> @@ -171,7 +177,6 @@ static void __exit ams_delta_serio_exit(void)
>  {
>  	serio_unregister_port(ams_delta_serio);
>  	free_irq(OMAP_GPIO_IRQ(AMS_DELTA_GPIO_PIN_KEYBRD_CLK), 0);
> -	gpio_free(AMS_DELTA_GPIO_PIN_KEYBRD_CLK);
> -	gpio_free(AMS_DELTA_GPIO_PIN_KEYBRD_DATA);
> +	gpio_free_array(_gpios, ARRAY_SIZE(_gpios));
>  }
>  module_exit(ams_delta_serio_exit);
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Dmitry
