Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1FIGyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 02:54:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55001 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1FIGym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 02:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=MlhzhF7WhEAx6eAvrmmVymWAY/+EycoMu3ugKiTSyc3aBcN3yjZ4uuqysXqF9LsHbK
         8GyyYmDvcVvJ+rtAz5sMX+ZqUSEDNzq4/7fSUAypaSuFbjSatLxeG6yq24c3LwLLY6Y5
         ns9bvEEv7DM4JaskOSOGikPoGGzC1LphekblU=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] This patch adds ok2440 development board support.
Date: Thu, 9 Jun 2011 09:54:02 +0300
User-Agent: KMail/1.13.7 (Linux/2.6.39-gentoo-anarsoul; KDE/4.6.3; i686; ; )
Cc: Wu DaoGuang <wdgvip@gmail.com>, ben-linux@fluff.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <1307581402-3808-1-git-send-email-wdgvip@gmail.com>
In-Reply-To: <1307581402-3808-1-git-send-email-wdgvip@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106090954.03125.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 June 2011 04:03:19 Wu DaoGuang wrote:
> The ok2440 development board is based on SAMSUNG's S3C2440
> microprocessor,which is developed with ARM920T core.
> 
> The file is modified from arch/arm/mach-s3c2440/mach-smdk2440.c
> that maintained by Ben Dooks <ben@simtec.co.uk>
> I modified it to fit the ok2440 development board.
> 
> The following patches are against v3.0-rc2.
> 
> Signed-off-by: Wu DaoGuang <wdgvip@gmail.com>
> ---
>  arch/arm/mach-s3c2440/mach-ok2440.c |  404
> +++++++++++++++++++++++++++++++++++ 1 files changed, 404 insertions(+), 0
> deletions(-)
>  create mode 100755 arch/arm/mach-s3c2440/mach-ok2440.c
> 
> diff --git a/arch/arm/mach-s3c2440/mach-ok2440.c
> b/arch/arm/mach-s3c2440/mach-ok2440.c new file mode 100755

Do not set execute permissions for source files

> index 0000000..8c858f1
> --- /dev/null
> +++ b/arch/arm/mach-s3c2440/mach-ok2440.c
> @@ -0,0 +1,404 @@
> +/* linux/arch/arm/mach-s3c2440/mach-ok2440.c
> + *
> + *	Copyright (c) 2011  Feiling Embedded
> + *	Base on mach-smdk2440.c by Ben Dooks <ben@simtec.co.uk>
> + *
> + *	Wu DaoGuang <wdgvip@gmail.com>
> + *
> + * Thanks to Dimity Andric and TomTom for the loan of an SMDK2440.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> +*/
> +
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/interrupt.h>
> +#include <linux/list.h>
> +#include <linux/timer.h>
> +#include <linux/init.h>
> +#include <linux/serial_core.h>
> +#include <linux/platform_device.h>
> +#include <linux/input.h>
> +#include <linux/io.h>
> +#include <linux/dm9000.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c/at24.h>
> +#include <linux/mmc/host.h>
> +#include <linux/clk.h>
> +#include <linux/syscore_ops.h>
> +
> +#include <linux/gpio.h>
> +#include <linux/gpio_keys.h>
> +
> +#include <linux/mtd/mtd.h>
> +#include <linux/mtd/nand.h>
> +#include <linux/mtd/nand_ecc.h>
> +#include <linux/mtd/partitions.h>
> +
> +
> +#include <asm/mach/arch.h>
> +#include <asm/mach/map.h>
> +#include <asm/mach/irq.h>
> +
> +#include <mach/hardware.h>
> +#include <asm/irq.h>
> +#include <asm/sizes.h>
> +
> +#include <asm/mach-types.h>
> +
> +#include <plat/regs-serial.h>
> +#include <plat/nand.h>
> +#include <plat/iic.h>
> +#include <plat/udc.h>
> +#include <plat/mci.h>
> +
> +#include <mach/regs-gpio.h>
> +#include <mach/leds-gpio.h>
> +#include <mach/regs-lcd.h>
> +#include <mach/regs-mem.h>
> +#include <mach/irqs.h>
> +
> +
> +#include <mach/idle.h>
> +#include <mach/fb.h>
> +#include <plat/gpio-core.h>
> +#include <plat/gpio-cfg-helpers.h>
> +#include <plat/gpio-cfg.h>
> +#include <plat/usb-control.h>
> +
> +#include <plat/s3c2410.h>
> +#include <plat/s3c244x.h>
> +#include <plat/clock.h>
> +#include <plat/devs.h>
> +#include <plat/cpu.h>
> +#include <plat/pm.h>
> +
> +#include <plat/common-smdk.h>
> +#include <sound/s3c24xx_uda134x.h>
> +
> +#define MACH_OK2440_DM9K_BASE (S3C2410_CS4 + 0x300)
> +
> +static struct map_desc ok2440_iodesc[] __initdata = {
> +	/* ISA IO Space map (memory space selected by A24) */
> +
> +	{
> +		.virtual	= (u32)S3C24XX_VA_ISA_WORD,
> +		.pfn		= __phys_to_pfn(S3C2410_CS2),
> +		.length		= 0x10000,
> +		.type		= MT_DEVICE,
> +	}, {
> +		.virtual	= (u32)S3C24XX_VA_ISA_WORD + 0x10000,
> +		.pfn		= __phys_to_pfn(S3C2410_CS2 + (1<<24)),
> +		.length		= SZ_4M,
> +		.type		= MT_DEVICE,
> +	}, {
> +		.virtual	= (u32)S3C24XX_VA_ISA_BYTE,
> +		.pfn		= __phys_to_pfn(S3C2410_CS2),
> +		.length		= 0x10000,
> +		.type		= MT_DEVICE,
> +	}, {
> +		.virtual	= (u32)S3C24XX_VA_ISA_BYTE + 0x10000,
> +		.pfn		= __phys_to_pfn(S3C2410_CS2 + (1<<24)),
> +		.length		= SZ_4M,
> +		.type		= MT_DEVICE,
> +	}
> +};
> +
> +#define UCON	(S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK)
> +#define ULCON	(S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB)
> +#define UFCON	(S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE)
> +
> +static struct s3c2410_uartcfg ok2440_uartcfgs[] __initdata = {
> +	[0] = {
> +		.hwport	     = 0,
> +		.flags	     = 0,
> +		.ucon	     = 0x3c5,
> +		.ulcon	     = 0x03,
> +		.ufcon	     = 0x51,
> +	},
> +	[1] = {
> +		.hwport	     = 1,
> +		.flags	     = 0,
> +		.ucon	     = 0x3c5,
> +		.ulcon	     = 0x03,
> +		.ufcon	     = 0x51,
> +	},
> +	/* IR port */
> +	[2] = {
> +		.hwport	     = 2,
> +		.flags	     = 0,
> +		.ucon	     = 0x3c5,
> +		.ulcon	     = 0x43,
> +		.ufcon	     = 0x51,
> +	}
> +};
> +
> +/* LCD driver info */
> +
> +static struct s3c2410fb_display ok2440_lcd_cfg __initdata = {
> +
> +	.lcdcon5	= S3C2410_LCDCON5_FRM565 |
> +			  S3C2410_LCDCON5_INVVLINE |
> +			  S3C2410_LCDCON5_INVVFRAME |
> +			  S3C2410_LCDCON5_PWREN |
> +			  S3C2410_LCDCON5_HWSWP,
> +
> +	.type		= S3C2410_LCDCON1_TFT,
> +
> +	.width		= 320,
> +	.height		= 240,
> +
> +	.pixclock	= 270000, /* HCLK 60 MHz, divisor 10 */
> +	.xres		= 320,
> +	.yres		= 240,
> +	.bpp		= 16,
> +	.left_margin	= 8,
> +	.right_margin	= 5,
> +	.hsync_len	= 16,
> +	.upper_margin	= 8,
> +	.lower_margin	= 5,
> +	.vsync_len	= 2,
> +};
> +
> +static struct s3c2410fb_mach_info ok2440_fb_info __initdata = {
> +	.displays	= &ok2440_lcd_cfg,
> +	.num_displays	= 1,
> +	.default_display = 0,
> +
> +#if 0
> +	/* currently setup by downloader */
> +	.gpccon		= 0xaa940659,
> +	.gpccon_mask	= 0xffffffff,
> +	.gpcup		= 0x0000ffff,
> +	.gpcup_mask	= 0xffffffff,
> +	.gpdcon		= 0xaa84aaa0,
> +	.gpdcon_mask	= 0xffffffff,
> +	.gpdup		= 0x0000faff,
> +	.gpdup_mask	= 0xffffffff,
> +#endif

This dead code is not necessary.

> +	.lpcsel		= ((0xCE6) & ~7) | 1<<4,
> +};
> +
> +/* Nand flash partitions on ok2440 */
> +static struct mtd_partition ok2440_default_nand_part[] = {
> +	[0] = {
> +		.name	= "u-boot",
> +		.size	= SZ_1M,
> +		.offset	= 0,
> +	},
> +	[1] = {
> +		.name	= "App",
> +		.size	= SZ_2M,
> +		.offset	= SZ_1M,

Use MTDPART_OFS_APPEND instead of calculating offset manually (same for other 
partitions)

> +	},
> +	[2] = {
> +		.name	= "Kernel",
> +		.size	= SZ_1M*4,
> +		.offset	= SZ_1M*3,
> +	},
> +	[3] = {
> +		.name	= "Ramdisk",
> +		.size	= SZ_16M,
> +		.offset	= SZ_1M*7,
> +	},
> +	[3] = {
> +		.name	= "Rootfs",
> +		.size	= MTDPART_SIZ_FULL,
> +		.offset	= SZ_1M*23,
> +	},
> +};
> +static struct s3c2410_nand_set ok2440_nand_sets[] = {
> +	[0] = {
> +		.name		= "nand",
> +		.nr_chips	= 1,
> +		.nr_partitions	= ARRAY_SIZE(ok2440_default_nand_part),
> +		.partitions	= ok2440_default_nand_part,
> +		.flash_bbt	= 1, /* We use u-boot to creat a BBT*/
> +	}
> +};
> +
> +static struct s3c2410_platform_nand ok2440_nand_info __initdata = {
> +	.tacls		= 20,
> +	.twrph0		= 60,
> +	.twrph1		= 20,
> +	.nr_sets	= ARRAY_SIZE(ok2440_nand_sets),
> +	.sets		= ok2440_nand_sets,
> +	.ignore_unset_ecc = 1,
> +};
> +
> +
> +/* DM9000AEP 10/100 ethernet controller */
> +static struct resource ok2440_dm9k_resource[] = {
> +	[0] = {
> +		.start = MACH_OK2440_DM9K_BASE,
> +		.end   = MACH_OK2440_DM9K_BASE + 3,
> +		.flags = IORESOURCE_MEM
> +	},
> +	[1] = {
> +		.start = MACH_OK2440_DM9K_BASE + 4,
> +		.end   = MACH_OK2440_DM9K_BASE + 7,
> +		.flags = IORESOURCE_MEM
> +	},
> +	[2] = {
> +		.start = IRQ_EINT7,
> +		.end   = IRQ_EINT7,
> +		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE,
> +	}
> +};
> +/* The DM9000 has no eeprom ,and it's MAC address is set by
> + * the bootloader before starting the kernel.
> + */
> +static struct dm9000_plat_data ok2440_dm9k_pdata = {
> +	.flags		= (DM9000_PLATF_16BITONLY | DM9000_PLATF_NO_EEPROM),
> +};
> +static struct platform_device ok2440_device_eth = {
> +	.name		= "dm9000",
> +	.id		= -1,
> +	.num_resources	= ARRAY_SIZE(ok2440_dm9k_resource),
> +	.resource	= ok2440_dm9k_resource,
> +	.dev		= {
> +		.platform_data	= &ok2440_dm9k_pdata,
> +	},
> +};
> +
> +/* LEDS sourport */
> +static struct s3c24xx_led_platdata ok2440_led0_pdata = {
> +	.name		= "led0",
> +	.gpio		= S3C2410_GPF(5),
> +	.flags		= S3C24XX_LEDF_ACTLOW | S3C24XX_LEDF_TRISTATE,
> +	.def_trigger	= "heartbeat",
> +};

Please, use leds-gpio driver instead of s3c24xx_led

> +static struct platform_device ok2440_led0 = {
> +	.name		= "s3c24xx_led",
> +	.id		= 0,
> +	.dev		= {
> +		.platform_data = &ok2440_led0_pdata,
> +	}
> +};
> +
> +/* AUDIO */
> +static struct s3c24xx_uda134x_platform_data ok2440_audio_pins = {
> +	.l3_clk = S3C2410_GPB(4),
> +	.l3_mode = S3C2410_GPB(2),
> +	.l3_data = S3C2410_GPB(3),
> +	.model   = UDA134X_UDA1341
> +};
> +
> +static struct platform_device ok2440_audio = {
> +	.name		= "s3c24xx_uda134x",
> +	.id		= 0,
> +	.dev		= {
> +		.platform_data	= &ok2440_audio_pins,
> +	}
> +};
> +
> +static struct platform_device uda1340_codec = {
> +	.name = "uda134x-codec",
> +	.id   = -1,
> +};
> +
> +/*
> + * I2C devices
> + */
> +static struct at24_platform_data at24c08 = {
> +	.byte_len	= SZ_8K / 8,
> +	.page_size	= 16,
> +};
> +
> +static struct i2c_board_info ok2440_i2c_devs[] __initdata = {
> +	{
> +		I2C_BOARD_INFO("24c08", 0x50),
> +		.platform_data	= &at24c08,
> +	},
> +};
> +
> +/*  USB device UDC support */
> +static struct s3c2410_udc_mach_info ok2440_udc_cfg __initdata = {
> +	.pullup_pin = S3C2410_GPG(9),
> +};
> +
> +/* USB */
> +static struct s3c2410_hcd_info ok2440_usb_info __initdata = {
> +	.port[0]	= {
> +		.flags	= S3C_HCDFLG_USED,
> +	},
> +	.port[1]	= {
> +		.flags	= 0,
> +	},
> +};
> +
> +/* MMC/SD */
> +static struct s3c24xx_mci_pdata ok2440_mmc_cfg __initdata = {
> +	.gpio_detect	= S3C2410_GPG(10),
> +	.gpio_wprotect	= S3C2410_GPH(8),
> +	.set_power	= NULL,
> +	.ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34,
> +};
> +
> +
> +struct syscore_ops s3c24xx_irq_syscore_ops = {
> +	.suspend	= s3c24xx_irq_suspend,
> +	.resume		= s3c24xx_irq_resume,
> +};
> +
> +static struct platform_device *ok2440_devices[] __initdata = {
> +	&s3c_device_ohci,
> +	&s3c_device_lcd,
> +	&s3c_device_wdt,
> +	&s3c_device_i2c0,
> +	&s3c_device_iis,
> +	&s3c_device_sdi,
> +	&s3c_device_nand,
> +	&s3c_device_rtc,
> +	&s3c_device_usbgadget,
> +	&uda1340_codec,
> +	&ok2440_device_eth,
> +	&ok2440_audio,
> +	&ok2440_led0,
> +	&samsung_asoc_dma,
> +
> +};
> +
> +static void __init ok2440_map_io(void)
> +{
> +	s3c24xx_init_io(ok2440_iodesc, ARRAY_SIZE(ok2440_iodesc));
> +	s3c24xx_init_clocks(12000000);
> +	s3c24xx_init_uarts(ok2440_uartcfgs, ARRAY_SIZE(ok2440_uartcfgs));
> +}
> +
> +static void __init ok2440_machine_init(void)
> +{
> +	s3c2410_gpio_cfgpin(S3C2410_GPF(5), S3C2410_GPIO_OUTPUT);
> +	s3c2410_gpio_setpin(S3C2410_GPF(5), 1);

Don't use deprecated samsung-specific gpio API, use gpiolib instead.

> +	/*configure the mmc protect to pull high . */
> +	s3c2410_gpio_cfgpin(S3C2410_GPG(8), S3C2410_GPIO_OUTPUT);
> +	s3c2410_gpio_setpin(S3C2410_GPG(8), 1);
> +	s3c24xx_fb_set_platdata(&ok2440_fb_info);
> +	s3c_i2c0_set_platdata(NULL);
> +
> +	s3c_ohci_set_platdata(&ok2440_usb_info);
> +
> +	s3c_nand_set_platdata(&ok2440_nand_info);
> +	s3c24xx_udc_set_platdata(&ok2440_udc_cfg);
> +	s3c24xx_mci_set_platdata(&ok2440_mmc_cfg);
> +	i2c_register_board_info(0, ok2440_i2c_devs,
> +				ARRAY_SIZE(ok2440_i2c_devs));
> +
> +	platform_add_devices(ok2440_devices, ARRAY_SIZE(ok2440_devices));
> +	s3c_pm_init();
> +}
> +
> +MACHINE_START(S3C2440, "OK2440 development board.")
> +	/* Maintainer: Wu DaoGuang <wdgvip@gmail.com> */
> +	.boot_params	= S3C2410_SDRAM_PA + 0x100,
> +
> +	.init_irq	= s3c24xx_init_irq,
> +	.map_io		= ok2440_map_io,
> +	.init_machine	= ok2440_machine_init,
> +	.timer		= &s3c24xx_timer,
> +MACHINE_END
