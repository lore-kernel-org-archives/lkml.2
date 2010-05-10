Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab0EJVHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:07:15 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:36073 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207Ab0EJVHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:07:12 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 May 2010 17:07:11 EDT
X-Spam-Flag: NO
X-Spam-Score: -1.53
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
To: "Hans Ulli Kroll" <ulli.kroll@googlemail.com>, paulius.zaleckas@gmail.com
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] ARM: Gemini: add support for Wiliboard WBD-222
References: <1273522021-14436-1-git-send-email-ulli.kroll@googlemail.com>
 <1273522021-14436-3-git-send-email-ulli.kroll@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From: "Imre Kaloz" <kaloz@openwrt.org>
Organization: OpenWrt - Wireless Freedom
Date: Mon, 10 May 2010 22:57:15 +0200
Message-ID: <op.vcichpr22s3iss@ecaz>
In-Reply-To: <1273522021-14436-3-git-send-email-ulli.kroll@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Imre Kaloz <kaloz@openwrt.org>

On Mon, 10 May 2010 22:06:59 +0200, Hans Ulli Kroll <ulli.kroll@googlemail.com> wrote:

> From: Imre Kaloz <kaloz@openwrt.org>
>
> Add support for Wiliboard WBD-222.
>
> Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
> ---
>  arch/arm/mach-gemini/Kconfig        |    7 ++
>  arch/arm/mach-gemini/Makefile       |    1 +
>  arch/arm/mach-gemini/board-wbd222.c |  143 +++++++++++++++++++++++++++++++++++
>  3 files changed, 151 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-gemini/board-wbd222.c
>
> diff --git a/arch/arm/mach-gemini/Kconfig b/arch/arm/mach-gemini/Kconfig
> index 4de67ce..7997500 100644
> --- a/arch/arm/mach-gemini/Kconfig
> +++ b/arch/arm/mach-gemini/Kconfig
> @@ -16,6 +16,13 @@ config MACH_WBD111
>  	  Say Y here if you intend to run this kernel on a
>  	  Wiliboard WBD-111.
>+config MACH_WBD222
> +        bool "Wiliboard WBD-222"
> +        select GEMINI_MEM_SWAP
> +        help
> +          Say Y here if you intend to run this kernel on a
> +          Wiliboard WBD-222.
> +
>  endmenu
> config GEMINI_MEM_SWAP
> diff --git a/arch/arm/mach-gemini/Makefile b/arch/arm/mach-gemini/Makefile
> index 3997487..8e02c47 100644
> --- a/arch/arm/mach-gemini/Makefile
> +++ b/arch/arm/mach-gemini/Makefile
> @@ -9,3 +9,4 @@ obj-y			:= irq.o mm.o time.o devices.o gpio.o
>  # Board-specific support
>  obj-$(CONFIG_MACH_RUT100)	+= board-rut1xx.o
>  obj-$(CONFIG_MACH_WBD111)	+= board-wbd111.o
> +obj-$(CONFIG_MACH_WBD222)	+= board-wbd222.o
> diff --git a/arch/arm/mach-gemini/board-wbd222.c b/arch/arm/mach-gemini/board-wbd222.c
> new file mode 100644
> index 0000000..ece8b4c
> --- /dev/null
> +++ b/arch/arm/mach-gemini/board-wbd222.c
> @@ -0,0 +1,143 @@
> +/*
> + *  Support for Wiliboard WBD-222
> + *
> + *  Copyright (C) 2009 Imre Kaloz <kaloz@openwrt.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/leds.h>
> +#include <linux/input.h>
> +#include <linux/skbuff.h>
> +#include <linux/gpio_keys.h>
> +#include <linux/mdio-gpio.h>
> +#include <linux/mtd/mtd.h>
> +#include <linux/mtd/partitions.h>
> +#include <asm/mach-types.h>
> +#include <asm/mach/arch.h>
> +#include <asm/mach/time.h>
> +
> +
> +#include "common.h"
> +
> +static struct gpio_keys_button wbd222_keys[] = {
> +	{
> +		.code		= KEY_SETUP,
> +		.gpio		= 5,
> +		.active_low	= 1,
> +		.desc		= "reset",
> +		.type		= EV_KEY,
> +	},
> +};
> +
> +static struct gpio_keys_platform_data wbd222_keys_data = {
> +	.buttons	= wbd222_keys,
> +	.nbuttons	= ARRAY_SIZE(wbd222_keys),
> +};
> +
> +static struct platform_device wbd222_keys_device = {
> +	.name	= "gpio-keys",
> +	.id	= -1,
> +	.dev	= {
> +		.platform_data = &wbd222_keys_data,
> +	},
> +};
> +
> +static struct gpio_led wbd222_leds[] = {
> +	{
> +		.name			= "L3red",
> +		.gpio			= 1,
> +	},
> +	{
> +		.name			= "L4green",
> +		.gpio			= 2,
> +	},
> +	{
> +		.name			= "L4red",
> +		.gpio			= 3,
> +	},
> +	{
> +		.name			= "L3green",
> +		.gpio			= 5,
> +	},
> +};
> +
> +static struct gpio_led_platform_data wbd222_leds_data = {
> +	.num_leds	= ARRAY_SIZE(wbd222_leds),
> +	.leds		= wbd222_leds,
> +};
> +
> +static struct platform_device wbd222_leds_device = {
> +	.name	= "leds-gpio",
> +	.id	= -1,
> +	.dev	= {
> +		.platform_data = &wbd222_leds_data,
> +	},
> +};
> +
> +static struct sys_timer wbd222_timer = {
> +	.init	= gemini_timer_init,
> +};
> +
> +#ifdef CONFIG_MTD_PARTITIONS
> +static struct mtd_partition wbd222_partitions[] = {
> +	{
> +		.name		= "RedBoot",
> +		.offset		= 0,
> +		.size		= 0x020000,
> +		.mask_flags	= MTD_WRITEABLE,
> +	} , {
> +		.name		= "kernel",
> +		.offset		= 0x020000,
> +		.size		= 0x100000,
> +	} , {
> +		.name		= "rootfs",
> +		.offset		= 0x120000,
> +		.size		= 0x6a0000,
> +	} , {
> +		.name		= "VCTL",
> +		.offset		= 0x7c0000,
> +		.size		= 0x010000,
> +		.mask_flags	= MTD_WRITEABLE,
> +	} , {
> +		.name		= "cfg",
> +		.offset		= 0x7d0000,
> +		.size		= 0x010000,
> +		.mask_flags	= MTD_WRITEABLE,
> +	} , {
> +		.name		= "FIS",
> +		.offset		= 0x7e0000,
> +		.size		= 0x010000,
> +		.mask_flags	= MTD_WRITEABLE,
> +	}
> +};
> +#define wbd222_num_partitions	ARRAY_SIZE(wbd222_partitions)
> +#else
> +#define wbd222_partitions	NULL
> +#define wbd222_num_partitions	0
> +#endif /* CONFIG_MTD_PARTITIONS */
> +
> +static void __init wbd222_init(void)
> +{
> +	gemini_gpio_init();
> +	platform_register_uart();
> +	platform_register_pflash(SZ_8M, wbd222_partitions,
> +		wbd222_num_partitions);
> +	platform_device_register(&wbd222_leds_device);
> +	platform_device_register(&wbd222_keys_device);
> +}
> +
> +MACHINE_START(WBD222, "Wiliboard WBD-222")
> +	.phys_io	= 0x7fffc000,
> +	.io_pg_offst	= ((0xffffc000) >> 18) & 0xfffc,
> +	.boot_params	= 0x100,
> +	.map_io		= gemini_map_io,
> +	.init_irq	= gemini_init_irq,
> +	.timer		= &wbd222_timer,
> +	.init_machine	= wbd222_init,
> +MACHINE_END

