Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab0LJDne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:43:34 -0500
Received: from 26.mail-out.ovh.net ([91.121.27.225]:35028 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755000Ab0LJDnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:43:33 -0500
Date: Fri, 10 Dec 2010 04:38:50 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Christian Glindkamp <christian.glindkamp@taskit.de>
Cc: Ryan Mallon <ryan@bluewatersys.com>, linux@arm.linux.org.uk,
        costa.antonior@gmail.com, Igor Plyatov <plyatov@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux@maxim.org.za, linux-arm-kernel@lists.infradead.org,
        pgsellmann@portner-elektronik.at
Subject: Re: [PATCH] at91: Refactor Stamp9G20 and PControl G20 board file
Message-ID: <20101210033850.GC19897@game.jcrosoft.org>
References: <4CFFE5A9.4040407@bluewatersys.com>
 <1291889759-12281-1-git-send-email-christian.glindkamp@taskit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291889759-12281-1-git-send-email-christian.glindkamp@taskit.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 11661508286034193266
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,

	If the hardware are so near I do need to the need to create a new
	machine use system_rev to auto detect it will be better

	but we need to have only one defconfig as done on rm9200
	it's really reduce the maintainance and allow to be sure when we
	compile the at91sam9g20_defconfig that we do not brake any board

	if a board have incompatible option please the system_rev to specify
	them or a specific entry in the Kconfig for this board it will allow
	also to known this information for the maintainance

Best Regards,
J.
On 11:15 Thu 09 Dec     , Christian Glindkamp wrote:
> As PControl G20 is a carrier board for the Stamp9G20 SoM, some code can
> be shared. Therefore board-stamp9g20.c is refactored to allow reusing the
> SoM initialization and board-pcontrol-g20.c is modified to use it.
> 
> Signed-off-by: Christian Glindkamp <christian.glindkamp@taskit.de>
> ---
> 
> How about this approach? Compile tested for PControl G20 and run time tested
> for Stamp9G20 EVB and PortuxG20.
> 
> Just a side note: PortuxG20 is not a carrier board for the Stamp9G20. It just
> shares so much with the evaluation board, that it makes sense to put them both
> into the same file. And there is no intention to put other boards into this
> file.
> 
>  arch/arm/mach-at91/Makefile                 |    2 +-
>  arch/arm/mach-at91/board-pcontrol-g20.c     |   98 +--------------------------
>  arch/arm/mach-at91/board-stamp9g20.c        |   82 ++++++++++++-----------
>  arch/arm/mach-at91/include/mach/stamp9g20.h |    7 ++
>  4 files changed, 54 insertions(+), 135 deletions(-)
>  create mode 100644 arch/arm/mach-at91/include/mach/stamp9g20.h
> 
> diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
> index 62d686f..d13add7 100644
> --- a/arch/arm/mach-at91/Makefile
> +++ b/arch/arm/mach-at91/Makefile
> @@ -65,7 +65,7 @@ obj-$(CONFIG_MACH_AT91SAM9G20EK) += board-sam9g20ek.o
>  obj-$(CONFIG_MACH_CPU9G20)	+= board-cpu9krea.o
>  obj-$(CONFIG_MACH_STAMP9G20)	+= board-stamp9g20.o
>  obj-$(CONFIG_MACH_PORTUXG20)	+= board-stamp9g20.o
> -obj-$(CONFIG_MACH_PCONTROL_G20)	+= board-pcontrol-g20.o
> +obj-$(CONFIG_MACH_PCONTROL_G20)	+= board-pcontrol-g20.o board-stamp9g20.o
>  
>  # AT91SAM9260/AT91SAM9G20 board-specific support
>  obj-$(CONFIG_MACH_SNAPPER_9260)	+= board-snapper9260.o
> diff --git a/arch/arm/mach-at91/board-pcontrol-g20.c b/arch/arm/mach-at91/board-pcontrol-g20.c
> index bba5a56..feb6578 100644
> --- a/arch/arm/mach-at91/board-pcontrol-g20.c
> +++ b/arch/arm/mach-at91/board-pcontrol-g20.c
> @@ -31,6 +31,7 @@
>  
>  #include <mach/board.h>
>  #include <mach/at91sam9_smc.h>
> +#include <mach/stamp9g20.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> @@ -38,11 +39,7 @@
>  
>  static void __init pcontrol_g20_map_io(void)
>  {
> -	/* Initialize processor: 18.432 MHz crystal */
> -	at91sam9260_initialize(18432000);
> -
> -	/* DGBU on ttyS0. (Rx, Tx) only TTL -> JTAG connector X7 17,19 ) */
> -	at91_register_uart(0, 0, 0);
> +	stamp9g20_map_io();
>  
>  	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS) piggyback  A2 */
>  	at91_register_uart(AT91SAM9260_ID_US0, 1, ATMEL_UART_CTS
> @@ -54,9 +51,6 @@ static void __init pcontrol_g20_map_io(void)
>  
>  	/* USART2 on ttyS3. (Rx, Tx)  9bit-Bus  Multidrop-mode  X4 */
>  	at91_register_uart(AT91SAM9260_ID_US4, 3, 0);
> -
> -	/* set serial console to ttyS0 (ie, DBGU) */
> -	at91_set_serial_console(0);
>  }
>  
>  
> @@ -66,38 +60,6 @@ static void __init init_irq(void)
>  }
>  
>  
> -/*
> - * NAND flash 512MiB 1,8V 8-bit, sector size 128 KiB
> - */
> -static struct atmel_nand_data __initdata nand_data = {
> -	.ale		= 21,
> -	.cle		= 22,
> -	.rdy_pin	= AT91_PIN_PC13,
> -	.enable_pin	= AT91_PIN_PC14,
> -};
> -
> -/*
> - * Bus timings; unit = 7.57ns
> - */
> -static struct sam9_smc_config __initdata nand_smc_config = {
> -	.ncs_read_setup		= 0,
> -	.nrd_setup		= 2,
> -	.ncs_write_setup	= 0,
> -	.nwe_setup		= 2,
> -
> -	.ncs_read_pulse		= 4,
> -	.nrd_pulse		= 4,
> -	.ncs_write_pulse	= 4,
> -	.nwe_pulse		= 4,
> -
> -	.read_cycle		= 7,
> -	.write_cycle		= 7,
> -
> -	.mode			= AT91_SMC_READMODE | AT91_SMC_WRITEMODE
> -			| AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_DBW_8,
> -	.tdf_cycles		= 3,
> -};
> -
>  static struct sam9_smc_config __initdata pcontrol_smc_config[2] = { {
>  	.ncs_read_setup		= 16,
>  	.nrd_setup		= 18,
> @@ -138,14 +100,6 @@ static struct sam9_smc_config __initdata pcontrol_smc_config[2] = { {
>  	.tdf_cycles		= 1,
>  } };
>  
> -static void __init add_device_nand(void)
> -{
> -	/* configure chip-select 3 (NAND) */
> -	sam9_smc_configure(3, &nand_smc_config);
> -	at91_add_device_nand(&nand_data);
> -}
> -
> -
>  static void __init add_device_pcontrol(void)
>  {
>  	/* configure chip-select 4 (IO compatible to 8051  X4 ) */
> @@ -156,23 +110,6 @@ static void __init add_device_pcontrol(void)
>  
>  
>  /*
> - * MCI (SD/MMC)
> - * det_pin, wp_pin and vcc_pin are not connected
> - */
> -#if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
> -static struct mci_platform_data __initdata mmc_data = {
> -	.slot[0] = {
> -		.bus_width	= 4,
> -	},
> -};
> -#else
> -static struct at91_mmc_data __initdata mmc_data = {
> -	.wire4		= 1,
> -};
> -#endif
> -
> -
> -/*
>   * USB Host port
>   */
>  static struct at91_usbh_data __initdata usbh_data = {
> @@ -265,42 +202,13 @@ static struct spi_board_info pcontrol_g20_spi_devices[] = {
>  };
>  
>  
> -/*
> - * Dallas 1-Wire  DS2431
> - */
> -static struct w1_gpio_platform_data w1_gpio_pdata = {
> -	.pin		= AT91_PIN_PA29,
> -	.is_open_drain	= 1,
> -};
> -
> -static struct platform_device w1_device = {
> -	.name			= "w1-gpio",
> -	.id			= -1,
> -	.dev.platform_data	= &w1_gpio_pdata,
> -};
> -
> -static void add_wire1(void)
> -{
> -	at91_set_GPIO_periph(w1_gpio_pdata.pin, 1);
> -	at91_set_multi_drive(w1_gpio_pdata.pin, 1);
> -	platform_device_register(&w1_device);
> -}
> -
> -
>  static void __init pcontrol_g20_board_init(void)
>  {
> -	at91_add_device_serial();
> -	add_device_nand();
> -#if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
> -	at91_add_device_mci(0, &mmc_data);
> -#else
> -	at91_add_device_mmc(0, &mmc_data);
> -#endif
> +	stamp9g20_board_init();
>  	at91_add_device_usbh(&usbh_data);
>  	at91_add_device_eth(&macb_data);
>  	at91_add_device_i2c(pcontrol_g20_i2c_devices,
>  		ARRAY_SIZE(pcontrol_g20_i2c_devices));
> -	add_wire1();
>  	add_device_pcontrol();
>  	at91_add_device_spi(pcontrol_g20_spi_devices,
>  		ARRAY_SIZE(pcontrol_g20_spi_devices));
> diff --git a/arch/arm/mach-at91/board-stamp9g20.c b/arch/arm/mach-at91/board-stamp9g20.c
> index 5206eef..f8902b1 100644
> --- a/arch/arm/mach-at91/board-stamp9g20.c
> +++ b/arch/arm/mach-at91/board-stamp9g20.c
> @@ -32,7 +32,7 @@
>  #include "generic.h"
>  
>  
> -static void __init portuxg20_map_io(void)
> +void __init stamp9g20_map_io(void)
>  {
>  	/* Initialize processor: 18.432 MHz crystal */
>  	at91sam9260_initialize(18432000);
> @@ -40,6 +40,24 @@ static void __init portuxg20_map_io(void)
>  	/* DGBU on ttyS0. (Rx & Tx only) */
>  	at91_register_uart(0, 0, 0);
>  
> +	/* set serial console to ttyS0 (ie, DBGU) */
> +	at91_set_serial_console(0);
> +}
> +
> +static void __init stamp9g20evb_map_io(void)
> +{
> +	stamp9g20_map_io();
> +
> +	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI) */
> +	at91_register_uart(AT91SAM9260_ID_US0, 1, ATMEL_UART_CTS | ATMEL_UART_RTS
> +						| ATMEL_UART_DTR | ATMEL_UART_DSR
> +						| ATMEL_UART_DCD | ATMEL_UART_RI);
> +}
> +
> +static void __init portuxg20_map_io(void)
> +{
> +	stamp9g20_map_io();
> +
>  	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI) */
>  	at91_register_uart(AT91SAM9260_ID_US0, 1, ATMEL_UART_CTS | ATMEL_UART_RTS
>  						| ATMEL_UART_DTR | ATMEL_UART_DSR
> @@ -56,26 +74,6 @@ static void __init portuxg20_map_io(void)
>  
>  	/* USART5 on ttyS6. (Rx, Tx only) */
>  	at91_register_uart(AT91SAM9260_ID_US5, 6, 0);
> -
> -	/* set serial console to ttyS0 (ie, DBGU) */
> -	at91_set_serial_console(0);
> -}
> -
> -static void __init stamp9g20_map_io(void)
> -{
> -	/* Initialize processor: 18.432 MHz crystal */
> -	at91sam9260_initialize(18432000);
> -
> -	/* DGBU on ttyS0. (Rx & Tx only) */
> -	at91_register_uart(0, 0, 0);
> -
> -	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI) */
> -	at91_register_uart(AT91SAM9260_ID_US0, 1, ATMEL_UART_CTS | ATMEL_UART_RTS
> -						| ATMEL_UART_DTR | ATMEL_UART_DSR
> -						| ATMEL_UART_DCD | ATMEL_UART_RI);
> -
> -	/* set serial console to ttyS0 (ie, DBGU) */
> -	at91_set_serial_console(0);
>  }
>  
>  static void __init init_irq(void)
> @@ -156,7 +154,7 @@ static struct at91_udc_data __initdata portuxg20_udc_data = {
>  	.pullup_pin	= 0,		/* pull-up driven by UDC */
>  };
>  
> -static struct at91_udc_data __initdata stamp9g20_udc_data = {
> +static struct at91_udc_data __initdata stamp9g20evb_udc_data = {
>  	.vbus_pin	= AT91_PIN_PA22,
>  	.pullup_pin	= 0,		/* pull-up driven by UDC */
>  };
> @@ -190,7 +188,7 @@ static struct gpio_led portuxg20_leds[] = {
>  	}
>  };
>  
> -static struct gpio_led stamp9g20_leds[] = {
> +static struct gpio_led stamp9g20evb_leds[] = {
>  	{
>  		.name			= "D8",
>  		.gpio			= AT91_PIN_PB18,
> @@ -250,7 +248,7 @@ void add_w1(void)
>  }
>  
>  
> -static void __init generic_board_init(void)
> +void __init stamp9g20_board_init(void)
>  {
>  	/* Serial */
>  	at91_add_device_serial();
> @@ -262,34 +260,40 @@ static void __init generic_board_init(void)
>  #else
>  	at91_add_device_mmc(0, &mmc_data);
>  #endif
> -	/* USB Host */
> -	at91_add_device_usbh(&usbh_data);
> -	/* Ethernet */
> -	at91_add_device_eth(&macb_data);
> -	/* I2C */
> -	at91_add_device_i2c(NULL, 0);
>  	/* W1 */
>  	add_w1();
>  }
>  
>  static void __init portuxg20_board_init(void)
>  {
> -	generic_board_init();
> -	/* SPI */
> -	at91_add_device_spi(portuxg20_spi_devices, ARRAY_SIZE(portuxg20_spi_devices));
> +	stamp9g20_board_init();
> +	/* USB Host */
> +	at91_add_device_usbh(&usbh_data);
>  	/* USB Device */
>  	at91_add_device_udc(&portuxg20_udc_data);
> +	/* Ethernet */
> +	at91_add_device_eth(&macb_data);
> +	/* I2C */
> +	at91_add_device_i2c(NULL, 0);
> +	/* SPI */
> +	at91_add_device_spi(portuxg20_spi_devices, ARRAY_SIZE(portuxg20_spi_devices));
>  	/* LEDs */
>  	at91_gpio_leds(portuxg20_leds, ARRAY_SIZE(portuxg20_leds));
>  }
>  
> -static void __init stamp9g20_board_init(void)
> +static void __init stamp9g20evb_board_init(void)
>  {
> -	generic_board_init();
> +	stamp9g20_board_init();
> +	/* USB Host */
> +	at91_add_device_usbh(&usbh_data);
>  	/* USB Device */
> -	at91_add_device_udc(&stamp9g20_udc_data);
> +	at91_add_device_udc(&stamp9g20evb_udc_data);
> +	/* Ethernet */
> +	at91_add_device_eth(&macb_data);
> +	/* I2C */
> +	at91_add_device_i2c(NULL, 0);
>  	/* LEDs */
> -	at91_gpio_leds(stamp9g20_leds, ARRAY_SIZE(stamp9g20_leds));
> +	at91_gpio_leds(stamp9g20evb_leds, ARRAY_SIZE(stamp9g20evb_leds));
>  }
>  
>  MACHINE_START(PORTUXG20, "taskit PortuxG20")
> @@ -305,7 +309,7 @@ MACHINE_START(STAMP9G20, "taskit Stamp9G20")
>  	/* Maintainer: taskit GmbH */
>  	.boot_params	= AT91_SDRAM_BASE + 0x100,
>  	.timer		= &at91sam926x_timer,
> -	.map_io		= stamp9g20_map_io,
> +	.map_io		= stamp9g20evb_map_io,
>  	.init_irq	= init_irq,
> -	.init_machine	= stamp9g20_board_init,
> +	.init_machine	= stamp9g20evb_board_init,
>  MACHINE_END
> diff --git a/arch/arm/mach-at91/include/mach/stamp9g20.h b/arch/arm/mach-at91/include/mach/stamp9g20.h
> new file mode 100644
> index 0000000..6120f9c
> --- /dev/null
> +++ b/arch/arm/mach-at91/include/mach/stamp9g20.h
> @@ -0,0 +1,7 @@
> +#ifndef __MACH_STAMP9G20_H
> +#define __MACH_STAMP9G20_H
> +
> +void stamp9g20_map_io(void);
> +void stamp9g20_board_init(void);
> +
> +#endif
> -- 
> 1.7.2.3
