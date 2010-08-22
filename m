Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0HVVL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 17:11:27 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:64983 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752424Ab0HVVLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 17:11:24 -0400
Message-ID: <4C719276.3090503@bluewatersys.com>
Date: Mon, 23 Aug 2010 09:11:18 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Maxim Osipov <maxim.osipov@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Victor <avictor.za@gmail.com>,
        Andrew Victor <linux@maxim.org.za>
Subject: Re: [PATCH] AT91: Add Flexibity board support.
References: <AANLkTikLSwsQz4U+0QmR61QcB=5i1kL+QY6Wu0FhUHKV@mail.gmail.com>
In-Reply-To: <AANLkTikLSwsQz4U+0QmR61QcB=5i1kL+QY6Wu0FhUHKV@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2010 10:56 PM, Maxim Osipov wrote:
> From 7e33ab3221ca1e391d677e0e47b25b7e513966a0 Mon Sep 17 00:00:00 2001
> From: Maxim Osipov <maxim.osipov@gmail.com>
> Date: Sat, 21 Aug 2010 14:40:53 +0400
> Subject: [PATCH] AT91: Add Flexibity board support.
>
> Signed-off-by: Maxim Osipov <maxim.osipov@gmail.com>
>   
Cc'ed Andrew Victor, who is the maintainer for at91.
> ---
>  arch/arm/configs/flexibity_defconfig | 2769 ++++++++++++++++++++++++++++++++++
>  arch/arm/mach-at91/Kconfig           |    6 +
>  arch/arm/mach-at91/Makefile          |    1 +
>  arch/arm/mach-at91/board-flexibity.c |  199 +++
>  4 files changed, 2975 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/configs/flexibity_defconfig
>  create mode 100644 arch/arm/mach-at91/board-flexibity.c
>
> diff --git a/arch/arm/configs/flexibity_defconfig b/arch/arm/configs/flexibity_defconfig
> new file mode 100644
> index 0000000..85c75dc
> --- /dev/null
> +++ b/arch/arm/configs/flexibity_defconfig
>   
There is an effort at the moment to reduce the number and size of the
defconfigs in the kernel. I don't think it has been done for the at91
yet, but we should be trying to create single defconfigs for all 9260,
9261, etc boards. Probably best to omit the defconfig for the moment.
>  # AT91SAM9261 board-specific support
>  obj-$(CONFIG_MACH_AT91SAM9261EK) += board-sam9261ek.o
> diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
> new file mode 100644
> index 0000000..8937cc1
> --- /dev/null
> +++ b/arch/arm/mach-at91/board-flexibity.c
> @@ -0,0 +1,199 @@
> +/*
> + * linux/arch/arm/mach-at91/board-flexibity.c
> + *
> + *  Copyright (C) 2010 Flexibity
> + *  Copyright (C) 2005 SAN People
> + *  Copyright (C) 2006 Atmel
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#include <linux/types.h>
> +#include <linux/init.h>
> +#include <linux/mm.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/spi/spi.h>
> +#include <linux/spi/at73c213.h>
> +#include <linux/clk.h>
> +#include <linux/i2c/at24.h>
> +#include <linux/gpio_keys.h>
> +#include <linux/input.h>
> +
> +#include <asm/setup.h>
> +#include <asm/mach-types.h>
> +#include <asm/irq.h>
> +
> +#include <asm/mach/arch.h>
> +#include <asm/mach/map.h>
> +#include <asm/mach/irq.h>
> +
> +#include <mach/hardware.h>
> +#include <mach/board.h>
> +#include <mach/gpio.h>
> +#include <mach/at91sam9_smc.h>
> +#include <mach/at91_shdwc.h>
>
>   
Not sure if you need all of these files included. I think you can
probably remove at least: linux/types.h, linux/mm.h, linux/module.h,
linux/spi/at73c213.h, linux/clk.h, linux/i2c/at24.h, asm/setup.h,
asm/irq.h, and asm/mach/map.h. You might be able to remove a couple more
also.

mach/gpio.h should be replaced with linux/gpio.h
> +#include "sam9_smc.h"
> +#include "generic.h"
> +
> +
>   
Don't use double blank lines.
> +static void __init ek_map_io(void)
>   
Should be called flexibility_map_io, same goes for other function/struct
names.
> +{
> +	/* Initialize processor: 18.432 MHz crystal */
> +	at91sam9260_initialize(18432000);
> +
> +	/* DBGU on ttyS0. (Rx & Tx only) */
> +	at91_register_uart(0, 0, 0);
> +
> +	/* set serial console to ttyS0 (ie, DBGU) */
> +	at91_set_serial_console(0);
> +}
> +
> +static void __init ek_init_irq(void)
> +{
> +	at91sam9260_init_interrupts(NULL);
> +}
> +
> +
> +/*
> + * USB Host port
> + */
>   

Single line comments take up less space. This comment doesn't really
offer much more than is in the code below anyway. Same goes for the
heading comments above the other sections.

> +static struct at91_usbh_data __initdata ek_usbh_data = {
> +	.ports		= 2,
> +};
> +
> +/*
> + * USB Device port
> + */
> +static struct at91_udc_data __initdata ek_udc_data = {
> +	.vbus_pin	= AT91_PIN_PC5,
> +	.pullup_pin	= 0,		/* pull-up driven by UDC */
> +};
> +
> +/*
> + * SPI devices.
> + */
> +static struct spi_board_info ek_spi_devices[] = {
> +	{	/* DataFlash chip */
> +		.modalias	= "mtd_dataflash",
> +		.chip_select	= 1,
> +		.max_speed_hz	= 15 * 1000 * 1000,
> +		.bus_num	= 0,
> +	},
> +};
> +
> +/*
> + * MCI (SD/MMC)
> + */
> +static struct at91_mmc_data __initdata ek_mmc_data = {
> +	.slot_b		= 0,
> +	.wire4		= 1,
> +	.det_pin	= AT91_PIN_PC9,
> +	.wp_pin		= AT91_PIN_PC4,
> +//	.vcc_pin	= ... not connected
>   

Remove this line.

> +};
> +
> +
> +/*
> + * LEDs
> + */
> +static struct gpio_led ek_leds[] = {
> +	{
> +		.name			= "usb1:green",
> +		.gpio			= AT91_PIN_PA12,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	},
> +	{
> +		.name			= "usb1:red",
> +		.gpio			= AT91_PIN_PA13,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	},
> +	{
> +		.name			= "usb2:green",
> +		.gpio			= AT91_PIN_PB26,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	},
> +	{
> +		.name			= "usb2:red",
> +		.gpio			= AT91_PIN_PB27,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	},
> +	{
> +		.name			= "usb3:green",
> +		.gpio			= AT91_PIN_PC8,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	},
> +	{
> +		.name			= "usb3:red",
> +		.gpio			= AT91_PIN_PC6,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	},
> +	{
> +		.name			= "usb4:green",
> +		.gpio			= AT91_PIN_PB4,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	},
> +	{
> +		.name			= "usb4:red",
> +		.gpio			= AT91_PIN_PB5,
> +		.active_low		= 1,
> +		.default_trigger	= "default-on",
> +	}
> +};
> +
> +static struct i2c_board_info __initdata ek_i2c_devices[] = {
> +	/* more devices can be added using expansion connectors */
> +};
>
>   
Remove this struct since it is not used.
> +
> +static void __init ek_add_device_buttons(void) {}
> +
>   
Remove, not needed.
> +
> +static void __init ek_board_init(void)
> +{
> +	/* Serial */
> +	at91_add_device_serial();
> +	/* USB Host */
> +	at91_add_device_usbh(&ek_usbh_data);
> +	/* USB Device */
> +	at91_add_device_udc(&ek_udc_data);
> +	/* SPI */
> +	at91_add_device_spi(ek_spi_devices, ARRAY_SIZE(ek_spi_devices));
> +	/* MMC */
> +	at91_add_device_mmc(0, &ek_mmc_data);
> +	/* I2C */
> +	at91_add_device_i2c(ek_i2c_devices, ARRAY_SIZE(ek_i2c_devices));
> +	/* LEDs */
> +	at91_gpio_leds(ek_leds, ARRAY_SIZE(ek_leds));
>   
The comments in this function don't really add any information. I know
that other at91 boards do this, but someone needs to break the habit :-).
> +}
> +
> +MACHINE_START(FLEXIBITY, "Flexibity Connect")
> +	/* Maintainer: Maxim Osipov */
> +	.phys_io	= AT91_BASE_SYS,
> +	.io_pg_offst	= (AT91_VA_BASE_SYS >> 18) & 0xfffc,
> +	.boot_params	= AT91_SDRAM_BASE + 0x100,
> +	.timer		= &at91sam926x_timer,
> +	.map_io		= ek_map_io,
> +	.init_irq	= ek_init_irq,
> +	.init_machine	= ek_board_init,
> +MACHINE_END
> -- 1.7.1

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751 
Fax:   +64 3 3779135			  USA 1800 261 2934

