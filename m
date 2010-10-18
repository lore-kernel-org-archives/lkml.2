Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab0JRNS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 09:18:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56030 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab0JRNSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 09:18:55 -0400
Date: Mon, 18 Oct 2010 22:18:41 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 1/9] ARM: S3C64XX: add frame buffer support for
 mach-real6410
In-reply-to: <20100929193047.25307.35558.stgit@darius-desktop>
To: "'Darius Augulis'" <augulis.darius@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Cc: paulius.zaleckas@gmail.com, linux-kernel@vger.kernel.org,
        ben-linux@fluff.org
Message-id: <04a301cb6ec6$fda2dc80$f8e89580$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=utf-8
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActgDOsTWdXo/9RuQpuXHPuMXud0GAOuMCoQ
References: <20100929192354.25307.40197.stgit@darius-desktop>
 <20100929193047.25307.35558.stgit@darius-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darius Augulis wrote:
> 
> Add support for frame buffer device for mach-real6410.
> Patch also adds support for feature string parsing
> for real6410. The feature string is kernel command
> line passed and currently lets select only LCD
> configuration. At the moment there is support for
> two LCD configurations - 4.3" and 7.0". Feature
> parser is mach-mini2440 based.
> 
> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
> ---
>  arch/arm/mach-s3c64xx/Kconfig         |    2
>  arch/arm/mach-s3c64xx/mach-real6410.c |  146
> ++++++++++++++++++++++++++++++++-
>  2 files changed, 143 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
> index 1e4d78a..3bbd418 100644
> --- a/arch/arm/mach-s3c64xx/Kconfig
> +++ b/arch/arm/mach-s3c64xx/Kconfig
> @@ -104,6 +104,8 @@ config MACH_REAL6410
>  	select S3C_DEV_HSMMC
>  	select S3C_DEV_HSMMC1
>  	select S3C64XX_SETUP_SDHCI
> +	select S3C_DEV_FB
> +	select S3C64XX_SETUP_FB_24BPP
>  	help
>  	  Machine support for the CoreWind REAL6410
> 
> diff --git a/arch/arm/mach-s3c64xx/mach-real6410.c b/arch/arm/mach-
> s3c64xx/mach-real6410.c
> index e130379..bed75d2 100644
> --- a/arch/arm/mach-s3c64xx/mach-real6410.c
> +++ b/arch/arm/mach-s3c64xx/mach-real6410.c
> @@ -12,24 +12,35 @@
>   *
>  */
> 
> -#include <linux/kernel.h>
> -#include <linux/types.h>
> +#include <linux/init.h>

You did add <linux/init.h> and

>  #include <linux/interrupt.h>
> +#include <linux/fb.h>
> +#include <linux/gpio.h>
> +#include <linux/kernel.h>
>  #include <linux/list.h>
> -#include <linux/init.h>

remove <linux/init.h>...why?

>  #include <linux/dm9000.h>
> -#include <linux/serial_core.h>
>  #include <linux/platform_device.h>
> +#include <linux/serial_core.h>

Same...you removed <linux/serial_core.h> and added it.

> +#include <linux/types.h>

Same...you removed it and added.

> +
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
> +
>  #include <mach/map.h>
> -#include <mach/s3c6410.h>
> +#include <mach/regs-fb.h>
> +#include <mach/regs-gpio.h>
> +#include <mach/regs-modem.h>
>  #include <mach/regs-srom.h>
> +#include <mach/s3c6410.h>
> +
>  #include <plat/cpu.h>
>  #include <plat/devs.h>
> +#include <plat/fb.h>
>  #include <plat/regs-serial.h>
> 
> +#include <video/platform_lcd.h>
> +
>  #define UCON (S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK)
>  #define ULCON (S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB)
>  #define UFCON (S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE)
> @@ -99,22 +110,145 @@ static struct platform_device real6410_device_eth = {
>  	},
>  };
> 
> +static struct s3c_fb_pd_win real6410_fb_win[] = {
> +	{
> +		.win_mode	= {	/* 4.3" 480x272 */
> +			.left_margin	= 3,
> +			.right_margin	= 2,
> +			.upper_margin	= 1,
> +			.lower_margin	= 1,
> +			.hsync_len	= 40,
> +			.vsync_len	= 1,
> +			.xres		= 480,
> +			.yres		= 272,
> +		},
> +		.max_bpp	= 32,
> +		.default_bpp	= 16,
> +	}, {
> +		.win_mode	= {	/* 7.0" 800x480 */
> +			.left_margin	= 8,
> +			.right_margin	= 13,
> +			.upper_margin	= 7,
> +			.lower_margin	= 5,
> +			.hsync_len	= 3,
> +			.vsync_len	= 1,
> +			.xres		= 800,
> +			.yres		= 480,
> +		},
> +		.max_bpp	= 32,
> +		.default_bpp	= 16,
> +	},
> +};
> +
> +static struct s3c_fb_platdata real6410_lcd_pdata __initdata = {
> +	.setup_gpio	= s3c64xx_fb_gpio_setup_24bpp,
> +	.win[0]		= &real6410_fb_win[0],
> +	.vidcon0	= VIDCON0_VIDOUT_RGB | VIDCON0_PNRMODE_RGB,
> +	.vidcon1	= VIDCON1_INV_HSYNC | VIDCON1_INV_VSYNC,
> +};
> +
>  static struct platform_device *real6410_devices[] __initdata = {
>  	&real6410_device_eth,
>  	&s3c_device_hsmmc0,
>  	&s3c_device_hsmmc1,
> +	&s3c_device_fb,
>  };
> 
>  static void __init real6410_map_io(void)
>  {
> +	u32 tmp;
> +
>  	s3c64xx_init_io(NULL, 0);
>  	s3c24xx_init_clocks(12000000);
>  	s3c24xx_init_uarts(real6410_uartcfgs, ARRAY_SIZE(real6410_uartcfgs));
> +
> +	/* set the LCD type */
> +	tmp = __raw_readl(S3C64XX_SPCON);
> +	tmp &= ~S3C64XX_SPCON_LCD_SEL_MASK;
> +	tmp |= S3C64XX_SPCON_LCD_SEL_RGB;
> +	__raw_writel(tmp, S3C64XX_SPCON);
> +
> +	/* remove the LCD bypass */
> +	tmp = __raw_readl(S3C64XX_MODEM_MIFPCON);
> +	tmp &= ~MIFPCON_LCD_BYPASS;
> +	__raw_writel(tmp, S3C64XX_MODEM_MIFPCON);

Hmm...I'm not sure whether above functionality is in map_io()

> +}
> +
> +/*
> + * real6410_features string
> + *
> + * 0-9 LCD configuration
> + *
> + */
> +static char real6410_features_str[12] __initdata = "0";
> +
> +static int __init real6410_features_setup(char *str)
> +{
> +	if (str)
> +		strlcpy(real6410_features_str, str,
> +			sizeof(real6410_features_str));
> +	return 1;
> +}
> +
> +__setup("real6410=", real6410_features_setup);
> +
> +#define FEATURE_SCREEN (1 << 0)
> +
> +struct real6410_features_t {
> +	int done;
> +	int lcd_index;
> +};
> +
> +static void real6410_parse_features(
> +		struct real6410_features_t *features,
> +		const char *features_str)

+static void real6410_parse_features(struct real6410_features_t *features,
+				    const char *features_str)

> +{
> +	const char *fp = features_str;
> +
> +	features->done = 0;
> +	features->lcd_index = 0;
> +
> +	while (*fp) {
> +		char f = *fp++;
> +
> +		switch (f) {
> +		case '0'...'9':	/* tft screen */
> +			if (features->done & FEATURE_SCREEN) {
> +				printk(KERN_INFO "REAL6410: '%c' ignored, "
> +					"screen type already set\n", f);
> +			} else {
> +				int li = f - '0';
> +				if (li >= ARRAY_SIZE(real6410_fb_win))
> +					printk(KERN_INFO "REAL6410: '%c' out "
> +						"of range LCD mode\n", f);
> +				else {
> +					features->lcd_index = li;
> +				}
> +			}
> +			features->done |= FEATURE_SCREEN;
> +			break;
> +		}
> +	}
>  }
> 
>  static void __init real6410_machine_init(void)
>  {
>  	u32 cs1;
> +	struct real6410_features_t features = { 0 };
> +
> +	printk(KERN_INFO "REAL6410: Option string real6410=%s\n",
> +			real6410_features_str);
> +
> +	/* Parse the feature string */
> +	real6410_parse_features(&features, real6410_features_str);
> +
> +	real6410_lcd_pdata.win[0] = &real6410_fb_win[features.lcd_index];
> +
> +	printk(KERN_INFO "REAL6410: selected LCD display is %dx%d\n",
> +		real6410_lcd_pdata.win[0]->win_mode.xres,
> +		real6410_lcd_pdata.win[0]->win_mode.yres);
> +
> +	s3c_fb_set_platdata(&real6410_lcd_pdata);
> 
>  	/* configure nCS1 width to 16 bits */
> 
> @@ -136,6 +270,8 @@ static void __init real6410_machine_init(void)
>  		(4 << S3C64XX_SROM_BCX__TCOS__SHIFT) |
>  		(0 << S3C64XX_SROM_BCX__TACS__SHIFT), S3C64XX_SROM_BC1);
> 
> +	gpio_request(S3C64XX_GPF(15), "LCD power");
> +

Just requesting it is enough?

>  	platform_add_devices(real6410_devices, ARRAY_SIZE(real6410_devices));
>  }
> 


Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

