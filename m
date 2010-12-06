Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab0LFUKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:10:43 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:34224 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752266Ab0LFUKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:10:42 -0500
Message-ID: <4CFD4395.6050006@bluewatersys.com>
Date: Tue, 07 Dec 2010 09:12:05 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Igor Plyatov <plyatov@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux@maxim.org.za,
        linux@arm.linux.org.uk, nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        costa.antonior@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mach-at91: Support for gms board added.
References: <1291663938-8325-1-git-send-email-plyatov@gmail.com>
In-Reply-To: <1291663938-8325-1-git-send-email-plyatov@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 08:32 AM, Igor Plyatov wrote:
> The gms is a board from GeoSIG Ltd. It is based on the Stamp9G20 module from Taskit.
>
> Signed-off-by: Igor Plyatov <plyatov@gmail.com>
> ---

Hi Igor,

A few comments below.

>  arch/arm/configs/stamp9g20gms_defconfig | 1830 +++++++++++++++++++++++++++++++
>  arch/arm/mach-at91/Kconfig              |    7 +
>  arch/arm/mach-at91/Makefile             |    1 +
>  arch/arm/mach-at91/board-stamp9g20gms.c |  720 ++++++++++++
>  arch/arm/mach-at91/include/mach/gms.h   |   27 +
>  5 files changed, 2585 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/configs/stamp9g20gms_defconfig
>  create mode 100644 arch/arm/mach-at91/board-stamp9g20gms.c
>  create mode 100644 arch/arm/mach-at91/include/mach/gms.h
> 
> diff --git a/arch/arm/configs/stamp9g20gms_defconfig b/arch/arm/configs/stamp9g20gms_defconfig
> new file mode 100644
> index 0000000..430b57f
> --- /dev/null
> +++ b/arch/arm/configs/stamp9g20gms_defconfig
> @@ -0,0 +1,1830 @@

We are trying to avoid adding more large defconfigs. Can you roll this
into one of the existing defconfigs or at least run it through Uwe's
defconfig minimiser script.

<snip>

> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index c015b68..5f31223 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -381,6 +381,13 @@ config MACH_PCONTROL_G20
>  	  Select this if you are using taskit's Stamp9G20 CPU module on this
>  	  carrier board, beeing the decentralized unit of a building automation
>  	  system; featuring nvram, eth-switch, iso-rs485, display, io
> +
> +config MACH_STAMP9G20GMS
> +	bool "GeoSIG Stamp9G20 GMS"
> +	help
> +	  Select this if you are using taskit's Stamp9G20 with GeoSIG's GMS.
> +	  <http://www.geosig.com>
> +
>  endif
>  
>  if (ARCH_AT91SAM9260 || ARCH_AT91SAM9G20)
> diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
> index 62d686f..6eeeba7 100644
> --- a/arch/arm/mach-at91/Makefile
> +++ b/arch/arm/mach-at91/Makefile
> @@ -64,6 +64,7 @@ obj-$(CONFIG_MACH_AT91SAM9RLEK)	+= board-sam9rlek.o
>  obj-$(CONFIG_MACH_AT91SAM9G20EK) += board-sam9g20ek.o
>  obj-$(CONFIG_MACH_CPU9G20)	+= board-cpu9krea.o
>  obj-$(CONFIG_MACH_STAMP9G20)	+= board-stamp9g20.o
> +obj-$(CONFIG_MACH_STAMP9G20GMS)	+= board-stamp9g20gms.o
>  obj-$(CONFIG_MACH_PORTUXG20)	+= board-stamp9g20.o
>  obj-$(CONFIG_MACH_PCONTROL_G20)	+= board-pcontrol-g20.o
>  
> diff --git a/arch/arm/mach-at91/board-stamp9g20gms.c b/arch/arm/mach-at91/board-stamp9g20gms.c
> new file mode 100644
> index 0000000..d286c1f
> --- /dev/null
> +++ b/arch/arm/mach-at91/board-stamp9g20gms.c
> @@ -0,0 +1,720 @@
> +/*
> + *  Copyright (C) 2010 Christian Glindkamp <christian.glindkamp@taskit.de>
> + *                     taskit GmbH
> + *                2010 Igor Plyatov <plyatov@gmail.com>
> + *                     GeoSIG Ltd
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
> +#include <linux/mm.h>

What do you need this for?

> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +#include <linux/w1-gpio.h>
> +#include <linux/i2c/pcf857x.h>
> +#include <linux/gpio_keys.h>
> +#include <linux/input.h>
> +
> +#include <asm/mach-types.h>
> +#include <asm/mach/arch.h>
> +
> +#include <mach/board.h>
> +#include <mach/at91sam9_smc.h>
> +#include <mach/gms.h>
> +
> +#include "sam9_smc.h"
> +#include "generic.h"
> +
> +static void __init stamp9g20gms_map_io(void)
> +{
> +	/* Initialize processor: 18.432 MHz crystal */
> +	at91sam9260_initialize(18432000);
> +
> +	/* DGBU on ttyS0. (Rx & Tx only) */
> +	at91_register_uart(0, 0, 0);
> +
> +	/*
> +	 * USART0 on ttyS1 (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI).
> +	 * Used for Internal Analog Modem.
> +	 */
> +	at91_register_uart(AT91SAM9260_ID_US0, 1,
> +			     ATMEL_UART_CTS | ATMEL_UART_RTS
> +			   | ATMEL_UART_DTR | ATMEL_UART_DSR
> +			   | ATMEL_UART_DCD | ATMEL_UART_RI);
> +	/*
> +	 * USART1 on ttyS2 (Rx, Tx, CTS, RTS).
> +	 * Used for GPS or WiFi or Data stream.
> +	 */
> +	at91_register_uart(AT91SAM9260_ID_US1, 2,
> +			   ATMEL_UART_CTS | ATMEL_UART_RTS);
> +	/*
> +	 * USART2 on ttyS3 (Rx, Tx, CTS, RTS).
> +	 * Used for External Modem.
> +	 */
> +	at91_register_uart(AT91SAM9260_ID_US2, 3,
> +			   ATMEL_UART_CTS | ATMEL_UART_RTS);
> +	/*
> +	 * USART3 on ttyS4 (Rx, Tx, RTS).
> +	 * Used for RS-485.
> +	 */
> +	at91_register_uart(AT91SAM9260_ID_US3, 4, ATMEL_UART_RTS);

Nitpick, blank line after the above line.

> +	/*
> +	 * USART4 on ttyS5 (Rx, Tx).
> +	 * Used for TRX433 Radio Module.
> +	 */
> +	at91_register_uart(AT91SAM9260_ID_US4, 5, 0);
> +
> +	/* set serial console to ttyS0 (ie, DBGU) */
> +	at91_set_serial_console(0);
> +}
> +
> +static void __init init_irq(void)
> +{
> +	at91sam9260_init_interrupts(NULL);
> +}
> +
> +/******************************************************************************
> + * NAND flash
> + ******************************************************************************/
> +static struct atmel_nand_data __initdata nand_data = {
> +	.ale		= 21,
> +	.cle		= 22,
> +	.rdy_pin	= AT91_PIN_PC13,
> +	.enable_pin	= AT91_PIN_PC14,
> +	.bus_width_16	= 0,
> +};
> +
> +static struct sam9_smc_config __initdata nand_smc_config = {
> +	.ncs_read_setup		= 0,
> +	.nrd_setup		= 2,
> +	.ncs_write_setup	= 0,
> +	.nwe_setup		= 2,
> +
> +	.ncs_read_pulse		= 4,
> +	.nrd_pulse		= 4,
> +	.ncs_write_pulse	= 4,
> +	.nwe_pulse		= 4,
> +
> +	.read_cycle		= 7,
> +	.write_cycle		= 7,
> +
> +	.mode			=	AT91_SMC_READMODE | \

Nitpick, remove the tab on the right hand side of the equals here.

> +					AT91_SMC_WRITEMODE | \
> +					AT91_SMC_EXNWMODE_DISABLE | \
> +					AT91_SMC_DBW_8,
> +	.tdf_cycles		= 3,
> +};
> +
> +static void __init add_device_nand(void)
> +{
> +	/* configure chip-select 3 (NAND) */
> +	sam9_smc_configure(3, &nand_smc_config);
> +
> +	at91_add_device_nand(&nand_data);
> +}
> +
> +/******************************************************************************
> + * MCI (SD/MMC)
> + * det_pin, wp_pin and vcc_pin are not connected
> + ******************************************************************************/
> +#if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
> +static struct mci_platform_data __initdata mmc_data = {
> +	.slot[0] = {
> +		.bus_width	= 4,
> +	},
> +};
> +#else
> +static struct at91_mmc_data __initdata mmc_data = {
> +	.slot_b		= 0,
> +	.wire4		= 1,
> +};
> +#endif
> +
> +/******************************************************************************
> + * USB Host port
> + ******************************************************************************/
> +static struct at91_usbh_data __initdata usbh_data = {
> +	.ports		= 2,
> +};
> +
> +

You only need a single blank line between code blocks. Also, not sure if
you need the massive comment headers for structs which should be
relatively self explanatory.

> +/******************************************************************************
> + * USB Device port
> + ******************************************************************************/
> +static struct at91_udc_data __initdata stamp9g20gms_udc_data = {
> +	.vbus_pin	= AT91_PIN_PA22,
> +	.pullup_pin	= 0,		/* pull-up driven by UDC */
> +};
> +
> +
> +/******************************************************************************
> + * MACB Ethernet device
> + ******************************************************************************/
> +static struct at91_eth_data __initdata macb_data = {
> +	.phy_irq_pin	= AT91_PIN_PA28,
> +	.is_rmii	= 1,
> +};
> +
> +
> +/******************************************************************************
> + * LEDs and GPOs
> + ******************************************************************************/
> +#if defined(CONFIG_LEDS_GPIO) || defined(CONFIG_LEDS_GPIO_MODULE)
> +static struct gpio_led stamp9g20gms_gpio_leds[] = {
> +	{
> +		.name                   = "gpo:spi1reset",
> +		.gpio                   = AT91_PIN_PC1,
> +		.active_low             = 0,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +	{
> +		.name                   = "gpo:trig_net_out",
> +		.gpio                   = AT91_PIN_PB20,
> +		.active_low             = 0,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +	{
> +		.name                   = "gpo:trig_net_dir",
> +		.gpio                   = AT91_PIN_PB19,
> +		.active_low             = 0,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +	{
> +		.name                   = "gpo:charge_dis",
> +		.gpio                   = AT91_PIN_PC2,
> +		.active_low             = 0,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +	{
> +		.name                   = "led:event",
> +		.gpio                   = AT91_PIN_PB17,
> +		.active_low             = 1,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +	{
> +		.name                   = "led:lan",
> +		.gpio                   = AT91_PIN_PB18,
> +		.active_low             = 1,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +	{
> +		.name                   = "led:error",
> +		.gpio                   = AT91_PIN_PB16,
> +		.active_low             = 1,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_ON,
> +	}
> +};
> +
> +static struct gpio_led_platform_data stamp9g20gms_gpio_led_info = {
> +	.leds		= stamp9g20gms_gpio_leds,
> +	.num_leds	= ARRAY_SIZE(stamp9g20gms_gpio_leds),
> +};
> +
> +static struct platform_device stamp9g20gms_leds = {
> +	.name	= "leds-gpio",
> +	.id	= 0,
> +	.dev	= {
> +		.platform_data	= &stamp9g20gms_gpio_led_info,
> +	}
> +};
> +
> +static void __init stamp9g20gms_leds_init(void)
> +{
> +	platform_device_register(&stamp9g20gms_leds);
> +}
> +#else
> +static inline void stamp9g20gms_leds_init(void) {}
> +#endif
> +
> +/* PCF8574 0x20 GPIO - U1 on the GS_IA18-CB_V3 board */
> +#if	(defined(CONFIG_LEDS_GPIO) || defined(CONFIG_LEDS_GPIO_MODULE)) && \
> +	(defined(CONFIG_GPIO_PCF857X) || defined(CONFIG_GPIO_PCF857X_MODULE))
> +static struct gpio_led stamp9g20gms_pcf_gpio_leds1[] = {
> +	{ /* bit 0 */
> +		.name                   = "gpo:hdc_power",
> +		.gpio                   = PCF_GPIO_HDC_POWER,
> +		.active_low             = 0,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +	{ /* bit 1 */
> +		.name                   = "gpo:wifi_setup",
> +		.gpio                   = PCF_GPIO_WIFI_SETUP,
> +		.active_low             = 1,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +	{ /* bit 2 */
> +		.name                   = "gpo:wifi_enable",
> +		.gpio                   = PCF_GPIO_WIFI_ENABLE,
> +		.active_low             = 1,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +	{ /* bit 3  */
> +		.name                   = "gpo:wifi_reset",
> +		.gpio                   = PCF_GPIO_WIFI_RESET,
> +		.active_low             = 1,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_ON,
> +	},
> +	/* bit 4 used as GPI  */
> +	{ /* bit 5 */
> +		.name                   = "gpo:gps_setup",
> +		.gpio                   = PCF_GPIO_GPS_SETUP,
> +		.active_low             = 1,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +	{ /* bit 6 */
> +		.name                   = "gpo:gps_standby",
> +		.gpio                   = PCF_GPIO_GPS_STANDBY,
> +		.active_low             = 0,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_ON,
> +	},
> +	{ /* bit 7 */
> +		.name                   = "gpo:gps_power",
> +		.gpio                   = PCF_GPIO_GPS_POWER,
> +		.active_low             = 0,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	}
> +};
> +
> +static struct gpio_led_platform_data stamp9g20gms_pcf_gpio_led_info1 = {
> +	.leds		= stamp9g20gms_pcf_gpio_leds1,
> +	.num_leds	= ARRAY_SIZE(stamp9g20gms_pcf_gpio_leds1),
> +};
> +
> +static struct platform_device stamp9g20gms_pcf_leds1 = {
> +	.name	= "leds-gpio", /* GS_IA18-CB_board */
> +	.id	= 1,
> +	.dev	= {
> +		.platform_data	= &stamp9g20gms_pcf_gpio_led_info1,
> +	}
> +};
> +
> +/* PCF8574 0x22 GPIO - U1 on the GS_2G_OPT1-A_V0 board (Alarm) */
> +static struct gpio_led stamp9g20gms_pcf_gpio_leds2[] = {
> +	{ /* bit 0 */
> +		.name                   = "gpo:alarm_1",
> +		.gpio                   = PCF_GPIO_ALARM1,
> +		.active_low             = 1,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +	{ /* bit 1 */
> +		.name                   = "gpo:alarm_2",
> +		.gpio                   = PCF_GPIO_ALARM2,
> +		.active_low             = 1,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +	{ /* bit 2 */
> +		.name                   = "gpo:alarm_3",
> +		.gpio                   = PCF_GPIO_ALARM3,
> +		.active_low             = 1,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +	{ /* bit 3 */
> +		.name                   = "gpo:alarm_4",
> +		.gpio                   = PCF_GPIO_ALARM4,
> +		.active_low             = 1,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +	/* bits 4, 5, 6 not used */
> +	{ /* bit 7 */
> +		.name                   = "gpo:alarm_v_relay_on",
> +		.gpio                   = PCF_GPIO_ALARM_V_RELAY_ON,
> +		.active_low             = 0,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +};
> +
> +static struct gpio_led_platform_data stamp9g20gms_pcf_gpio_led_info2 = {
> +	.leds		= stamp9g20gms_pcf_gpio_leds2,
> +	.num_leds	= ARRAY_SIZE(stamp9g20gms_pcf_gpio_leds2),
> +};
> +
> +static struct platform_device stamp9g20gms_pcf_leds2 = {
> +	.name	= "leds-gpio",
> +	.id	= 2,
> +	.dev	= {
> +		.platform_data	= &stamp9g20gms_pcf_gpio_led_info2,
> +	}
> +};
> +
> +/* PCF8574 0x24 GPIO U1 on the GS_2G-OPT23-A_V0 board (Modem) */
> +static struct gpio_led stamp9g20gms_pcf_gpio_leds3[] = {
> +	{ /* bit 0 */
> +		.name                   = "gpo:modem_power",
> +		.gpio                   = PCF_GPIO_MODEM_POWER,
> +		.active_low             = 1,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_OFF,
> +	},
> +	  /* bits 1 and 2 not used */
> +	{ /* bit 3 */
> +		.name                   = "gpo:modem_reset",
> +		.gpio                   = PCF_GPIO_MODEM_RESET,
> +		.active_low             = 1,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_ON,
> +	},
> +	  /* bits 4, 5 and 6 not used */
> +	{ /* bit 7 */
> +		.name                   = "gpo:trx_reset",
> +		.gpio                   = PCF_GPIO_TRX_RESET,
> +		.active_low             = 1,
> +		.default_trigger        = "none",
> +		.default_state          = LEDS_GPIO_DEFSTATE_ON,
> +	}
> +};
> +
> +static struct gpio_led_platform_data stamp9g20gms_pcf_gpio_led_info3 = {
> +	.leds		= stamp9g20gms_pcf_gpio_leds3,
> +	.num_leds	= ARRAY_SIZE(stamp9g20gms_pcf_gpio_leds3),
> +};
> +
> +static struct platform_device stamp9g20gms_pcf_leds3 = {
> +	.name	= "leds-gpio",
> +	.id	= 3,
> +	.dev	= {
> +		.platform_data	= &stamp9g20gms_pcf_gpio_led_info3,
> +	}
> +};
> +
> +static void __init stamp9g20gms_pcf_leds_init(void)
> +{
> +	platform_device_register(&stamp9g20gms_pcf_leds1);
> +	platform_device_register(&stamp9g20gms_pcf_leds2);
> +	platform_device_register(&stamp9g20gms_pcf_leds3);
> +}
> +#else
> +static inline void stamp9g20gms_pcf_leds_init(void) {}
> +#endif /* CONFIG_LEDS_GPIO || CONFIG_GPIO_PCF857X */
> +
> +/******************************************************************************
> + * SPI busses.
> + ******************************************************************************/
> +static struct spi_board_info stamp9g20gms_spi_devices[] = {
> +	{ /* User accessible spi0, cs0 used for communication with MSP RTC */
> +		.modalias = "spidev",
> +		.bus_num = 0,
> +		.chip_select  = 0,
> +		.max_speed_hz = 580000,
> +		.mode = SPI_MODE_1,

Tab align these like the other structs in this file.

> +	},
> +	{ /* User accessible spi1, cs0 used for communication with int. DSP */
> +		.modalias = "spidev",
> +		.bus_num = 1,
> +		.chip_select  = 0,
> +		.max_speed_hz = 5600000,
> +		.mode = SPI_MODE_0,
> +	},
> +	{ /* User accessible spi1, cs1 used for communication with ext. DSP */
> +		.modalias = "spidev",
> +		.bus_num = 1,
> +		.chip_select  = 1,
> +		.max_speed_hz = 5600000,
> +		.mode = SPI_MODE_0,
> +	},
> +	{ /* User accessible spi1, cs2 used for communication with ext. DSP */
> +		.modalias = "spidev",
> +		.bus_num = 1,
> +		.chip_select  = 2,
> +		.max_speed_hz = 5600000,
> +		.mode = SPI_MODE_0,
> +	},
> +	{ /* User accessible spi1, cs3 used for communication with ext. DSP */
> +		.modalias = "spidev",
> +		.bus_num = 1,
> +		.chip_select  = 3,
> +		.max_speed_hz = 5600000,
> +		.mode = SPI_MODE_0,
> +	}
> +};
> +
> +/******************************************************************************
> + * Dallas 1-Wire
> + ******************************************************************************/
> +static struct w1_gpio_platform_data w1_gpio_pdata = {
> +	.pin		= AT91_PIN_PA29,
> +	.is_open_drain	= 1,
> +};
> +
> +static struct platform_device w1_device = {
> +	.name			= "w1-gpio",
> +	.id			= -1,
> +	.dev.platform_data	= &w1_gpio_pdata,
> +};
> +
> +void add_w1(void)
> +{
> +	at91_set_GPIO_periph(w1_gpio_pdata.pin, 1);
> +	at91_set_multi_drive(w1_gpio_pdata.pin, 1);
> +	platform_device_register(&w1_device);
> +}
> +
> +/******************************************************************************
> + * GPI Buttons
> + ******************************************************************************/
> +#if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
> +static struct gpio_keys_button stamp9g20gms_buttons[] = {
> +	{
> +		.gpio		= AT91_PIN_PB21,
> +		.code		= BTN_1,
> +		.desc		= "TRIG_NET_IN",
> +		.type		= EV_KEY,
> +		.active_low	= 0,
> +		.wakeup		= 1,
> +	},
> +	{
> +		.gpio		= AT91_PIN_PB13, /* SW80 */
> +		.code		= BTN_2,
> +		.desc		= "Card umount 0",
> +		.type		= EV_KEY,
> +		.active_low	= 1,
> +		.wakeup		= 1,
> +	},
> +	{
> +		.gpio		= AT91_PIN_PB12, /* SW79 */
> +		.code		= BTN_3,
> +		.desc		= "Card umount 1",
> +		.type		= EV_KEY,
> +		.active_low	= 1,
> +		.wakeup		= 1,
> +	},
> +	{
> +		.gpio		= AT91_PIN_PA25,
> +		.code		= KEY_POWER,
> +		.desc		= "Power Off Button",
> +		.type		= EV_KEY,
> +		.active_low	= 0,
> +		.wakeup		= 1,
> +	}
> +};
> +
> +static struct gpio_keys_platform_data stamp9g20gms_button_data = {
> +	.buttons	= stamp9g20gms_buttons,
> +	.nbuttons	= ARRAY_SIZE(stamp9g20gms_buttons),
> +};
> +
> +static struct platform_device stamp9g20gms_button_device = {
> +	.name		= "gpio-keys",
> +	.id		= -1,
> +	.num_resources	= 0,
> +	.dev		= {
> +		.platform_data	= &stamp9g20gms_button_data,
> +	}
> +};
> +
> +static void __init stamp9g20gms_add_device_buttons(void)
> +{
> +	/* Configure "TRIG_NET_IN" input with pullup */
> +	at91_set_gpio_input(AT91_PIN_PB21, 1);  /* BTN_1 */
> +	at91_set_deglitch(AT91_PIN_PB21, 1);
> +	/* Configure "Card umount 0" input with pullup */
> +	at91_set_gpio_input(AT91_PIN_PB12, 1);  /* BTN_2 */
> +	at91_set_deglitch(AT91_PIN_PB12, 1);
> +	/* Configure "Card umount 1" input with pullup */
> +	at91_set_gpio_input(AT91_PIN_PB13, 1);  /* BTN_3 */
> +	at91_set_deglitch(AT91_PIN_PB13, 1);
> +	/* Configure "Power Off Button" input without pullup */
> +	at91_set_gpio_input(AT91_PIN_PA25, 0);  /* KEY_POWER */
> +	at91_set_deglitch(AT91_PIN_PA25, 1);

I really dislike this style of commenting. You shouldn't need a comment
to explain the at91_set_gpio_input function. The comments for the button
functions should be replaced by using defines, ie:

#define BTN_1_TRIG_NET_IN    AT91_PIN_PB21
#define BTN_2_CARD_UNMOUNT_0 AT91_PIN_PB12
#define BTN_3_CARD_UNMOUNT_1 AT91_PIN_PB13
#define BTN_POWER            AT91_PIN_PA25

> +	platform_device_register(&stamp9g20gms_button_device);
> +}
> +#else
> +static void __init stamp9g20gms_add_device_buttons(void) {}
> +#endif
> +
> +/******************************************************************************
> + * I2C
> + ******************************************************************************/
> +#if defined(CONFIG_GPIO_PCF857X) || defined(CONFIG_GPIO_PCF857X_MODULE)
> +static int pcf8574x_0x20_setup(struct i2c_client *client, int gpio,
> +				unsigned int ngpio, void *context)
> +{
> +	int status;
> +
> +	status = gpio_request(gpio + 4, "eth_det");

Why gpio + 4? Either have the correct gpio passed in, or have a
define/comment explaining the magic number 4.

> +	if (status < 0) {
> +		pr_err("error: can't request GPIO%d\n", gpio + 4);
> +		return -ENOSYS;

Why not return the error code which was returned by gpio_request?

> +	}
> +	status = gpio_direction_input(gpio + 4);
> +	if (status < 0) {
> +		pr_err("error: can't setup GPIO%d as input\n", gpio + 4);
> +		return -ENOSYS;
> +	}
> +	status = gpio_export(gpio + 4, false);
> +	if (status < 0) {
> +		pr_err("error: can't export GPIO%d\n", gpio + 4);
> +		return -ENOSYS;
> +	}
> +	status = gpio_sysfs_set_active_low(gpio + 4, 1);
> +	if (status < 0) {
> +		pr_err("error: gpio_sysfs_set active_low(GPIO%d, 1)\n", gpio+4);
> +		return -ENOSYS;
> +	}
> +
> +	return 0;
> +}
> +
> +static int pcf8574x_0x20_teardown(struct i2c_client *client, int gpio,
> +					unsigned ngpio, void *context)
> +{
> +	gpio_free(gpio + 4);
> +	return 0;
> +}
> +
> +static struct pcf857x_platform_data stamp9g20_pcf20_pdata = {
> +	.gpio_base	= GS_IA18_S_PCF_GPIO_BASE0,
> +	.n_latch	= (1 << 4),
> +	.setup		= pcf8574x_0x20_setup,
> +	.teardown	= pcf8574x_0x20_teardown,
> +};
> +
> +static struct pcf857x_platform_data stamp9g20_pcf22_pdata = {
> +	.gpio_base	= GS_IA18_S_PCF_GPIO_BASE1,
> +};
> +
> +static struct pcf857x_platform_data stamp9g20_pcf24_pdata = {
> +	.gpio_base	= GS_IA18_S_PCF_GPIO_BASE2,
> +};
> +#endif /* CONFIG_GPIO_PCF857X */
> +
> +static struct i2c_board_info __initdata stamp9g20gms_i2c_devices[] = {
> +#if defined(CONFIG_GPIO_PCF857X) || defined(CONFIG_GPIO_PCF857X_MODULE)
> +	{ /* U1 on the GS_IA18-CB_V3 board */
> +		I2C_BOARD_INFO("pcf8574", 0x20),
> +		.platform_data = &stamp9g20_pcf20_pdata,
> +	},
> +	{ /* U1 on the GS_2G_OPT1-A_V0 board (Alarm) */
> +		I2C_BOARD_INFO("pcf8574", 0x22),
> +		.platform_data = &stamp9g20_pcf22_pdata,
> +	},
> +	{ /* U1 on the GS_2G-OPT23-A_V0 board (Modem) */
> +		I2C_BOARD_INFO("pcf8574", 0x24),
> +		.platform_data = &stamp9g20_pcf24_pdata,
> +	},
> +#endif /* CONFIG_GPIO_PCF857X */
> +#if defined(CONFIG_EEPROM_AT24) || defined(CONFIG_EEPROM_AT24_MODULE)
> +	{
> +		I2C_BOARD_INFO("24c1024", 0x50),
> +	},
> +#else

Does this really need to be surrounded by an ifdef? There is no harm in
having a an I2C_BOARD_INFO entry for a device which is not present/not
probed. The code ugliness hardly seems worth the tiny saving this would
gain.

> +	{
> +		NULL,
> +	},

If you are going to keep the ifdef, this entry is not needed.

> +#endif /* CONFIG_EEPROM_AT24 */
> +};
> +
> +/******************************************************************************
> + * Compact Flash
> + ******************************************************************************/
> +#if	defined(CONFIG_PATA_AT91) || defined(CONFIG_PATA_AT91_MODULE)
> +static struct at91_cf_data __initdata stamp9g20gms_cf1_data = {
> +	.irq_pin	= AT91_PIN_PA27,
> +	.det_pin	= AT91_PIN_PB30,
> +	.rst_pin	= AT91_PIN_PB31,
> +	.chipselect	= 5,
> +	.flags		= AT91_CF_TRUE_IDE,
> +};
> +#endif /* CONFIG_PATA_AT91 */
> +
> +/* Power Off by RTC */
> +static void stamp9g20gms_power_off(void)
> +{
> +	pr_notice("Power supply will be switched off automatically now or after"
> +			" 60 seconds without ArmDAS.\n");

printk's should be on one line so they can be grepped for.

> +	at91_set_gpio_output(AT91_PIN_PA25, 1);
> +	/* Spin to death... */
> +	while (1)
> +		;
> +}
> +
> +static int __init stamp9g20gms_power_off_init(void)
> +{
> +	pm_power_off = stamp9g20gms_power_off;
> +	return 0;
> +}
> +
> +/* ---------------------------------------------------------------------------*/
> +
> +static void __init generic_board_init(void)
> +{
> +	/* Serial */
> +	at91_add_device_serial();
> +	/* NAND */
> +	add_device_nand();
> +	/* MMC */
> +#if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
> +	at91_add_device_mci(0, &mmc_data);
> +#else
> +	at91_add_device_mmc(0, &mmc_data);
> +#endif /* CONFIG_MMC_ATMELMCI */
> +	/* W1 */
> +	add_w1();

Again the comments here are unhelpful since the function names reiterate
exactly what the comment says.

> +}
> +
> +static void __init stamp9g20gms_board_init(void)
> +{
> +	generic_board_init();
> +	/* USB Host */
> +	at91_add_device_usbh(&usbh_data);
> +	/* USB Device */
> +	at91_add_device_udc(&stamp9g20gms_udc_data);
> +	/* Ethernet */
> +	at91_add_device_eth(&macb_data);
> +	/* LEDs */
> +	stamp9g20gms_leds_init();
> +	stamp9g20gms_pcf_leds_init();
> +	/* Push Buttons */
> +	stamp9g20gms_add_device_buttons();
> +	/* I2C */

Remove the comments here too.

> +	at91_add_device_i2c(stamp9g20gms_i2c_devices,
> +				ARRAY_SIZE(stamp9g20gms_i2c_devices));
> +	/* Compact Flash */
> +#if	defined(CONFIG_PATA_AT91) || defined(CONFIG_PATA_AT91_MODULE)
> +	at91_add_device_cf(&stamp9g20gms_cf1_data);
> +#endif /* CONFIG_PATA_AT91 */

I think a lot of the ifdefs in this file could be removed. This is no
harm in having a device structure present for something that won't have
a driver attached later. The impact on code size is pretty minimal and
it makes the code easier to follow.

> +	/* SPI */
> +	at91_add_device_spi(stamp9g20gms_spi_devices,
> +				ARRAY_SIZE(stamp9g20gms_spi_devices));
> +	stamp9g20gms_power_off_init();
> +}
> +
> +MACHINE_START(STAMP9G20, "Stamp9G20 on the GeoSIG GS_IA18_S board")
> +	/* Maintainer: GeoSIG Ltd */
> +	.boot_params	= AT91_SDRAM_BASE + 0x100,
> +	.timer		= &at91sam926x_timer,
> +	.map_io		= stamp9g20gms_map_io,
> +	.init_irq	= init_irq,
> +	.init_machine	= stamp9g20gms_board_init,
> +MACHINE_END
> diff --git a/arch/arm/mach-at91/include/mach/gms.h b/arch/arm/mach-at91/include/mach/gms.h
> new file mode 100644
> index 0000000..5d5b46f
> --- /dev/null
> +++ b/arch/arm/mach-at91/include/mach/gms.h
> @@ -0,0 +1,27 @@
> +/* PCF8574 0x20 GPIO - U1 on the GS_IA18-CB_V3 board */
> +#define	GS_IA18_S_PCF_GPIO_BASE0	NR_BUILTIN_GPIO
> +#define	PCF_GPIO_HDC_POWER		(GS_IA18_S_PCF_GPIO_BASE0 + 0)
> +#define	PCF_GPIO_WIFI_SETUP		(GS_IA18_S_PCF_GPIO_BASE0 + 1)
> +#define	PCF_GPIO_WIFI_ENABLE		(GS_IA18_S_PCF_GPIO_BASE0 + 2)
> +#define	PCF_GPIO_WIFI_RESET		(GS_IA18_S_PCF_GPIO_BASE0 + 3)
> +#define	PCF_GPIO_ETH_DETECT		(GS_IA18_S_PCF_GPIO_BASE0 + 4)
> +#define	PCF_GPIO_GPS_SETUP		(GS_IA18_S_PCF_GPIO_BASE0 + 5)
> +#define	PCF_GPIO_GPS_STANDBY		(GS_IA18_S_PCF_GPIO_BASE0 + 6)
> +#define	PCF_GPIO_GPS_POWER		(GS_IA18_S_PCF_GPIO_BASE0 + 7)

Don't need a tab after the define.

> +/* PCF8574 0x22 GPIO - U1 on the GS_2G_OPT1-A_V0 board (Alarm) */
> +#define	GS_IA18_S_PCF_GPIO_BASE1	(GS_IA18_S_PCF_GPIO_BASE0 + 8)
> +#define	PCF_GPIO_ALARM1			(GS_IA18_S_PCF_GPIO_BASE1 + 0)
> +#define	PCF_GPIO_ALARM2			(GS_IA18_S_PCF_GPIO_BASE1 + 1)
> +#define	PCF_GPIO_ALARM3			(GS_IA18_S_PCF_GPIO_BASE1 + 2)
> +#define	PCF_GPIO_ALARM4			(GS_IA18_S_PCF_GPIO_BASE1 + 3)
> +/* bits 4, 5, 6 not used */
> +#define	PCF_GPIO_ALARM_V_RELAY_ON	(GS_IA18_S_PCF_GPIO_BASE1 + 7)
> +
> +/* PCF8574 0x24 GPIO U1 on the GS_2G-OPT23-A_V0 board (Modem) */
> +#define	GS_IA18_S_PCF_GPIO_BASE2	(GS_IA18_S_PCF_GPIO_BASE1 + 8)
> +#define	PCF_GPIO_MODEM_POWER		(GS_IA18_S_PCF_GPIO_BASE2 + 0)
> +#define	PCF_GPIO_MODEM_RESET		(GS_IA18_S_PCF_GPIO_BASE2 + 3)
> +/* bits 1, 2, 4, 5 not used */
> +#define	PCF_GPIO_TRX_RESET		(GS_IA18_S_PCF_GPIO_BASE2 + 6)
> +/* bit 7 not used */

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
