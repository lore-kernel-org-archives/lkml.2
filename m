Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1ASM3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 07:29:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48283 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab1ASM3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 07:29:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eJkAIqxKqXjY2CEwQWfMwqxRp9huJCy4dG1BzSd7/eF5DmcLjh2ozwO+iLfVgqj/LO
         sq/E59yNaqVgQUZpIgpc7gCKMD8V+vmzL2UG/GMdtb6nYGyfty1doE69TBOmZvfr+1ti
         +/Jx490fjFtHGKyKbISbuTAWEYKzq8AXpLz4g=
Subject: Re: [PATCHv4 3/4] OMAP3: Devkit8000: Check return value of
 gpio_request
From: Daniel Morsing <daniel.morsing@gmail.com>
To: Thomas Weber <weber@corscience.de>
Cc: linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        charu@ti.com, sshtylyov@mvista.com
In-Reply-To: <1295425166-25540-4-git-send-email-weber@corscience.de>
References: <1295425166-25540-1-git-send-email-weber@corscience.de>
	 <1295425166-25540-4-git-send-email-weber@corscience.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 13:29:50 +0100
Message-ID: <1295440190.2635.18.camel@morsing>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas

On Wed, 2011-01-19 at 09:19 +0100, Thomas Weber wrote:
> The return value of gpio_request is ignored.
> This patch adds the check of the return value of gpio_request.
> 
> Signed-off-by: Thomas Weber <weber@corscience.de>
> ---
>  arch/arm/mach-omap2/board-devkit8000.c |   16 ++++++++++++++--
>  1 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
> index 9fb416b..4ddd81c 100644
> --- a/arch/arm/mach-omap2/board-devkit8000.c
> +++ b/arch/arm/mach-omap2/board-devkit8000.c
> @@ -234,6 +234,8 @@ static struct gpio_led gpio_leds[];
>  static int devkit8000_twl_gpio_setup(struct device *dev,
>  		unsigned gpio, unsigned ngpio)
>  {
> +	int ret;
> +
>  	omap_mux_init_gpio(29, OMAP_PIN_INPUT);
>  	/* gpio + 0 is "mmc0_cd" (input/IRQ) */
>  	mmc[0].gpio_cd = gpio + 0;
> @@ -244,13 +246,23 @@ static int devkit8000_twl_gpio_setup(struct device *dev,
>  
>  	/* TWL4030_GPIO_MAX + 0 is "LCD_PWREN" (out, active high) */
>  	devkit8000_lcd_device.reset_gpio = gpio + TWL4030_GPIO_MAX + 0;
> -	gpio_request(devkit8000_lcd_device.reset_gpio, "LCD_PWREN");
> +	ret = gpio_request(devkit8000_lcd_device.reset_gpio, "LCD_PWREN");
> +	if (ret < 0) {
> +		printk(KERN_ERR "Failed to request GPIO for LCD_PWRN\n");
> +		return ret;
> +	}
> +

If we fail here, reset_gpio will be set to the gpio the was requested.
The main reason for this would be that the gpio has already been
requested, so any subsequent lcd operations could potentially mess up
some other code.

>  	/* Disable until needed */
>  	gpio_direction_output(devkit8000_lcd_device.reset_gpio, 0);
>  
>  	/* gpio + 7 is "DVI_PD" (out, active low) */
>  	devkit8000_dvi_device.reset_gpio = gpio + 7;
> -	gpio_request(devkit8000_dvi_device.reset_gpio, "DVI PowerDown");
> +	ret = gpio_request(devkit8000_dvi_device.reset_gpio, "DVI PowerDown");
> +	if (ret < 0) {
> +		printk(KERN_ERR "Failed to request GPIO for DVI PowerDown\n");
> +		return ret;
> +	}
> +

Same as above.

>  	/* Disable until needed */
>  	gpio_direction_output(devkit8000_dvi_device.reset_gpio, 0);
>  

Consider switching to gpio_request_{one, array}. Besides making
everything cleaner, it would also provide error checking for the
unlikely case that the request succeeded, but the direction setting
failed.

Also agreeing with Manjunath. This patch should be merged with the
adjust lcd gpio patch. The patches depend on each other and the
resulting patch is not big enough to warrant a split.

Regards,
Daniel

