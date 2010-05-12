Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0ELBCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 21:02:23 -0400
Received: from trinity.fluff.org ([89.16.178.74]:51000 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab0ELBCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 21:02:22 -0400
Date: Wed, 12 May 2010 02:02:12 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: rpurdie@rpsys.net, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 3/3] gta02: Use pcf50633 backlight driver instead of
	platform backlight driver.
Message-ID: <20100512010211.GL2589@trinity.fluff.org>
References: <1273625074-15312-1-git-send-email-lars@metafoo.de> <1273625074-15312-4-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273625074-15312-4-git-send-email-lars@metafoo.de>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 02:44:34AM +0200, Lars-Peter Clausen wrote:
> Use the pcf50633 backlight driver instead of the platform backlight driver.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Ben Dooks <ben-linux@fluff.org>

ok, does anyone else have a comment on this?

 ---
>  arch/arm/mach-s3c2440/mach-gta02.c |   76 ++++-------------------------------
>  1 files changed, 9 insertions(+), 67 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c2440/mach-gta02.c b/arch/arm/mach-s3c2440/mach-gta02.c
> index 45799c6..120a26f 100644
> --- a/arch/arm/mach-s3c2440/mach-gta02.c
> +++ b/arch/arm/mach-s3c2440/mach-gta02.c
> @@ -49,7 +49,6 @@
>  #include <linux/io.h>
>  
>  #include <linux/i2c.h>
> -#include <linux/backlight.h>
>  #include <linux/regulator/machine.h>
>  
>  #include <linux/mfd/pcf50633/core.h>
> @@ -57,6 +56,7 @@
>  #include <linux/mfd/pcf50633/adc.h>
>  #include <linux/mfd/pcf50633/gpio.h>
>  #include <linux/mfd/pcf50633/pmic.h>
> +#include <linux/mfd/pcf50633/backlight.h>
>  
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
> @@ -254,6 +254,12 @@ static char *gta02_batteries[] = {
>  	"battery",
>  };
>  
> +static struct pcf50633_bl_platform_data gta02_backlight_data = {
> +	.default_brightness = 0x3f,
> +	.default_brightness_limit = 0,
> +	.ramp_time = 5,
> +};
> +
>  struct pcf50633_platform_data gta02_pcf_pdata = {
>  	.resumers = {
>  		[0] =	PCF50633_INT1_USBINS |
> @@ -271,6 +277,8 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
>  
>  	.charger_reference_current_ma = 1000,
>  
> +	.backlight_data = &gta02_backlight_data,
> +
>  	.reg_init_data = {
>  		[PCF50633_REGULATOR_AUTO] = {
>  			.constraints = {
> @@ -478,71 +486,6 @@ static struct s3c2410_udc_mach_info gta02_udc_cfg = {
>  
>  };
>  
> -
> -
> -static void gta02_bl_set_intensity(int intensity)
> -{
> -	struct pcf50633 *pcf = gta02_pcf;
> -	int old_intensity = pcf50633_reg_read(pcf, PCF50633_REG_LEDOUT);
> -
> -	/* We map 8-bit intensity to 6-bit intensity in hardware. */
> -	intensity >>= 2;
> -
> -	/*
> -	 * This can happen during, eg, print of panic on blanked console,
> -	 * but we can't service i2c without interrupts active, so abort.
> -	 */
> -	if (in_atomic()) {
> -		printk(KERN_ERR "gta02_bl_set_intensity called while atomic\n");
> -		return;
> -	}
> -
> -	old_intensity = pcf50633_reg_read(pcf, PCF50633_REG_LEDOUT);
> -	if (intensity == old_intensity)
> -		return;
> -
> -	/* We can't do this anywhere else. */
> -	pcf50633_reg_write(pcf, PCF50633_REG_LEDDIM, 5);
> -
> -	if (!(pcf50633_reg_read(pcf, PCF50633_REG_LEDENA) & 3))
> -		old_intensity = 0;
> -
> -	/*
> -	 * The PCF50633 cannot handle LEDOUT = 0 (datasheet p60)
> -	 * if seen, you have to re-enable the LED unit.
> -	 */
> -	if (!intensity || !old_intensity)
> -		pcf50633_reg_write(pcf, PCF50633_REG_LEDENA, 0);
> -
> -	/* Illegal to set LEDOUT to 0. */
> -	if (!intensity)
> -		pcf50633_reg_set_bit_mask(pcf, PCF50633_REG_LEDOUT, 0x3f, 2);
> -	else
> -		pcf50633_reg_set_bit_mask(pcf, PCF50633_REG_LEDOUT, 0x3f,
> -					  intensity);
> -
> -	if (intensity)
> -		pcf50633_reg_write(pcf, PCF50633_REG_LEDENA, 2);
> -
> -}
> -
> -static struct generic_bl_info gta02_bl_info = {
> -	.name			= "gta02-bl",
> -	.max_intensity		= 0xff,
> -	.default_intensity	= 0xff,
> -	.set_bl_intensity	= gta02_bl_set_intensity,
> -};
> -
> -static struct platform_device gta02_bl_dev = {
> -	.name			= "generic-bl",
> -	.id			= 1,
> -	.dev = {
> -		.platform_data = &gta02_bl_info,
> -	},
> -};
> -
> -
> -
>  /* USB */
>  static struct s3c2410_hcd_info gta02_usb_info __initdata = {
>  	.port[0]	= {
> @@ -579,7 +522,6 @@ static struct platform_device *gta02_devices[] __initdata = {
>  /* These guys DO need to be children of PMU. */
>  
>  static struct platform_device *gta02_devices_pmu_children[] = {
> -	&gta02_bl_dev,
>  };
>  
>  
> -- 
> 1.5.6.5
> 

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

