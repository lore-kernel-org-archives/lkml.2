Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab1DDJKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:10:51 -0400
Received: from router.aksignal.cz ([188.175.113.102]:50470 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1DDJKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:10:49 -0400
Message-ID: <4D998B12.1040909@aksignal.cz>
Date: Mon, 04 Apr 2011 11:10:42 +0200
From: =?UTF-8?B?UHJjaGFsIEppxZnDrQ==?= <jiri.prchal@aksignal.cz>
Organization: AK signal Brno
User-Agent: Mozilla/5.0 (X11; U; Linux i686; cs-CZ; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Lightning/1.0b1 Thunderbird/3.0.11
MIME-Version: 1.0
To: Ryan Mallon <ryan@bluewatersys.com>, linux-arm-kernel@lists.infradead.org
CC: linux@maxim.org.za, nicolas.ferre@atmel.com, plagnioj@jcrosoft.co,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARCH arm: adding new board: CDU
References: <1300949648-15078-1-git-send-email-horms@verge.net.au> <1300949648-15078-2-git-send-email-horms@verge.net.au> <4D8B2068.60402@aksignal.cz> <4D8BA47B.8050904@bluewatersys.com>
In-Reply-To: <4D8BA47B.8050904@bluewatersys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this is separated PATCH adding new board CDU.

Depend on: [PATCH 1/2] ALSA: ASoc: TLV320AIC3X: ad SPI and clock on GPIO2 or BCLK
	[PATCH] ALSA: ASoc: new functions snd_soc_7_8_*
	[PATCH 2/2] ALSA: ASoc: putting together AT91SAM9260 and TLV320AIC3X
Kernel version: 2.6.38
Signed-off-by: Jiri Prchal <jiri.prchal@aksignal.cz>

Dne 24.3.2011 21:07, Ryan Mallon napsal(a):
> On 03/24/2011 11:43 PM, Prchal Jiří wrote:
>> Hi,
>> this patch is for example how to put together AT91SAM9260 and TLV320AIC3106 controlled via SPI.
>> It tooks me a lot of time to make it working, so I think it could be helpfull for other people.
>>
>> In original source "snd-soc-afeb9260.c" which I use as example is BIG ERROR:
>> In function "afeb9260_soc_init" is missing call of "atmel_ssc_set_audio(0);". It cause bug "PROBLEM: Asoc driver in
>> 2.6.37.3 for AT91SAM9260 / TLV320AIC3X is broken" which I post some time ago.
> 
> Hi Jiri,
> 
> This patch is actually doing two things: adding board support for a new
> at91sam9260 device and adding the audio glue for the new board. It
> should be split into two patches. Quick review below.
> 
> ~Ryan
> 
>>
>> Depend on: [PATCH 1/2] ALSA: ASoc: TLV320AIC3X: ad SPI and clock on GPIO2 or BCLK
>> Kernel version: 2.6.38
>> Signed-off-by: Jiri Prchal <jiri.prchal@aksignal.cz>
>> ---
>>
>> diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/arch/arm/mach-at91/board-cdu.c
>> /home/prchal/arm/fw-cdu/linux/linux-2.6.38/arch/arm/mach-at91/board-cdu.c
>> --- linux-2.6.38-vanilla/arch/arm/mach-at91/board-cdu.c	1970-01-01 01:00:00.000000000 +0100
>> +++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/arch/arm/mach-at91/board-cdu.c	2011-03-24 09:15:23.852370981 +0100
>> @@ -0,0 +1,345 @@
>> +/*
>> + * linux/arch/arm/mach-at91/board-cdu.c
>> + *
>> + *  Copyright (C) 2005 SAN People
>> + *  Copyright (C) 2006 Atmel
>> + *  Copyright (C) 2011 AKsignal Brno
>> + *                     jiri.prchal@aksignal.cz
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + */
>> +
>> +#include <linux/types.h>
>> +#include <linux/init.h>
>> +#include <linux/mm.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/spi/spi.h>
>> +#include <linux/clk.h>
>> +#include <linux/spi/mcp23s08.h>
>> +#include <linux/dma-mapping.h>
>> +
>> +#include <mach/hardware.h>
>> +#include <asm/setup.h>
>> +#include <asm/mach-types.h>
>> +#include <asm/irq.h>
>> +
>> +#include <asm/mach/arch.h>
>> +#include <asm/mach/map.h>
>> +#include <asm/mach/irq.h>
>> +
>> +#include <mach/board.h>
>> +#include <mach/gpio.h>
>> +#include <mach/at91sam9_smc.h>
>> +
>> +#include "sam9_smc.h"
>> +#include "generic.h"
>> +
>> +static void __init cdu_map_io(void)
>> +{
>> +	/* Initialize processor: 6 MHz crystal */
>> +	at91sam9260_initialize(6000000);
>> +
>> +	/* DBGU on ttyS0. (Rx & Tx only) */
>> +	at91_register_uart(0, 0, 0);
>> +
>> +	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI) */
>> +	at91_register_uart(AT91SAM9260_ID_US0, 1, ATMEL_UART_CTS | ATMEL_UART_RTS
>> +			   | ATMEL_UART_DTR | ATMEL_UART_DSR | ATMEL_UART_DCD
>> +			   | ATMEL_UART_RI);
>> +
>> +	/* USART1 on ttyS2. (Rx, Tx, RTS) */
>> +	at91_register_uart(AT91SAM9260_ID_US1, 2, ATMEL_UART_RTS);
>> +
>> +	/* USART2 on ttyS3. (Rx, Tx, RTS) */
>> +	at91_register_uart(AT91SAM9260_ID_US2, 3, ATMEL_UART_RTS);
>> +
>> +	/* USART3 on ttyS4. (Rx, Tx, RTS) */
>> +	at91_register_uart(AT91SAM9260_ID_US3, 4, ATMEL_UART_RTS);
>> +
>> +	/* USART4 on ttyS5. (Tx) */
>> +	/* EBUS - transmit audio, no rx */
>> +	/*at91_register_uart(AT91SAM9260_ID_US4, 5, 0);*/
>> +
>> +	/* set serial console to ttyS0 (ie, DBGU) */
>> +	at91_set_serial_console(0);
>> +}
>> +
>> +static void __init cdu_init_irq(void)
>> +{
>> +	at91sam9260_init_interrupts(NULL);
>> +}
>> +
>> +/*
>> + * USB Host port
>> + */
>> +static struct at91_usbh_data __initdata cdu_usbh_data = {
>> +	.ports		= 2,
>> +};
>> +
>> +/*
>> + * USB Device port
>> + */
>> +static struct at91_udc_data __initdata cdu_udc_data = {
>> +	.vbus_pin	= AT91_PIN_PC15,
>> +	.pullup_pin	= 0,		/* pull-up driven by UDC */
>> +};
>> +
>> +/*
>> + * SPI devices.
>> + */
>> +#define MCP23S08_GPIO_BASE	128
>> +
>> +static const struct mcp23s08_platform_data mcp23s08_gpio_info = {
>> +	.chip[0].is_present	= true,
>> +	.chip[0].pullups	= 0,
>> +	.base			= MCP23S08_GPIO_BASE,
>> +};
>> +
>> +static struct spi_board_info cdu_spi_devices[] = {
>> +	{ /* ADC LTC2488 */
>> +		.modalias	= "spidev",
>> +		.chip_select	= 0,
>> +		.max_speed_hz	= 1 * 1000 * 1000,
>> +		.bus_num	= 1,
>> +	},
>> +	{ /* GPIO expander MCP23S08 */
>> +		.modalias	= "mcp23s08",
>> +		.chip_select	= 1,
>> +		.max_speed_hz	= 1000000,
>> +		.bus_num	= 1,
>> +		.platform_data	= &mcp23s08_gpio_info,
>> +		.mode		= SPI_MODE_3,
>> +	},
>> +	{ /* non volatile memory (F-RAM) FM25VN10 */
>> +		.modalias	= "spidev",
>> +		.chip_select	= 2,
>> +		.max_speed_hz	= 1 * 1000 * 1000,
>> +		.bus_num	= 1,
>> +	},
>> +	{ /* audiocodec TLV320AIC3106 */
>> +		.modalias	= "tlv320aic3x-codec",
>> +		.chip_select	= 3,
>> +		.max_speed_hz	= 1000000,
>> +		.bus_num	= 1,
>> +		.mode		= SPI_MODE_1,
>> +	},
>> +};
>> +
>> +/*
>> + * MACB Ethernet device
>> + */
>> +static struct at91_eth_data __initdata cdu_macb_data = {
>> +	.phy_irq_pin	= 0, //nc,
> 
> Don't use // comments. This line can just be deleted since it default to
> zero.
I'd like to keep this lines to explicitly see not connected pins.

> 
>> +	.is_rmii	= 1,
>> +};
>> +
>> +/*
>> + * NAND flash
>> + */
>> +static struct mtd_partition __initdata cdu_nand_partition[] = {
>> +	{
>> +		.name   = "bootstrap",
>> +		.offset = 0,
>> +	  .size   = 0x40000,
> 
> Tabbing is messed here.
> 
>> +	},
>> +	{
>> +		.name   = "uboot",
>> +		.offset = 0x40000,
> 
> You can use MTDPART_OFS_NXTBLK for the offset to align this partition
> immediately after the previous one.
> 
>> +		.size   = (0xc0000 - 0x40000),
> 
> What's with the odd sizes? You should use the sizes from asm/sizes.h.
Used sizes and offsets.

> 
>> +	},
>> +	{
>> +		.name   = "ubootenv",
>> +		.offset = 0xc0000,
>> +		.size   = (0x100000 - 0xc0000),
>> +	},
>> +	{
>> +		.name   = "kernel",
>> +		.offset = 0x100000,
>> +		.size   = (0x400000 - 0x100000),
>> +	},
>> +	{
>> +		.name   = "rootfs",
>> +		.offset = 0x400000,
>> +		.size   = (0x8000000 - 0x400000),
>> +	},
>> +};
>> +
>> +static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
>> +{
>> +	*num_partitions = ARRAY_SIZE(cdu_nand_partition);
>> +	return cdu_nand_partition;
>> +}
>> +
>> +static struct atmel_nand_data __initdata cdu_nand_data = {
>> +	.ale		= 21,
>> +	.cle		= 22,
>> +//	.det_pin	= ... not connected
> 
> Delete this line.
> 
>> +	.rdy_pin	= AT91_PIN_PC13,
>> +	.enable_pin	= AT91_PIN_PC14,
>> +	.partition_info	= nand_partitions,
>> +	.bus_width_16	= 0,
>> +};
>> +
>> +static struct sam9_smc_config __initdata cdu_nand_smc_config = {
>> +	.ncs_read_setup		= 0,
>> +	.nrd_setup		= 1,
>> +	.ncs_write_setup	= 0,
>> +	.nwe_setup		= 1,
>> +
>> +	.ncs_read_pulse		= 3,
>> +	.nrd_pulse		= 3,
>> +	.ncs_write_pulse	= 3,
>> +	.nwe_pulse		= 3,
>> +
>> +	.read_cycle		= 5,
>> +	.write_cycle		= 5,
>> +
>> +	.mode			= AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE,
>> +	.tdf_cycles		= 2,
>> +};
>> +
>> +static void __init cdu_add_device_nand(void)
>> +{
>> +	/* setup bus-width (8 or 16) */
>> +	if (cdu_nand_data.bus_width_16)
>> +		cdu_nand_smc_config.mode |= AT91_SMC_DBW_16;
>> +	else
>> +		cdu_nand_smc_config.mode |= AT91_SMC_DBW_8;
> 
> bus_width_16 is explicitly set to zero above, so this logic should not
> be needed.
> 
Removed.

>> +	/* configure chip-select 3 (NAND) */
>> +	sam9_smc_configure(3, &cdu_nand_smc_config);
>> +
>> +	at91_add_device_nand(&cdu_nand_data);
>> +}
>> +
>> +/*
>> +* MCI (SD/MMC)
>> +*/
>> +static struct at91_mmc_data __initdata ek_mmc_data = {
>> +  .slot_b		= 0,
>> +  .wire4		= 1,
>> +  //	.det_pin	= ... not connected
>> +  //	.wp_pin		= ... not connected
>> +  //	.vcc_pin	= ... not connected
> 
> Delete these lines.
> 
>> +};
>> +
>> +/*
>> + * LEDs
>> + */
>> +static struct gpio_led cdu_leds[] = {
>> +	{
>> +		.name			= "red",
>> +		.gpio			= AT91_PIN_PC10,
>> +		.default_trigger	= "timer",
>> +	},
>> +	{
>> +		.name			= "green",
>> +		.gpio			= AT91_PIN_PA5,
>> +		.default_trigger	= "heartbeat",
>> +	},
>> +	{
>> +		.name			= "yellow",
>> +		.gpio			= AT91_PIN_PB20,
>> +		.active_low		= 1,
>> +		.default_trigger	= "mmc0",
>> +	},
>> +	{
>> +		.name			= "blue",
>> +		.gpio			= AT91_PIN_PB21,
>> +		.active_low		= 1,
>> +		.default_trigger	= "nand-disk",
>> +	},
>> +};
>> +
>> +/*
>> + * GPIOs
>> + */
>> +static struct gpio gpios[] = {
>> +	{ AT91_PIN_PA0,  GPIOF_OUT_INIT_LOW,  "ebus_dir"},
>> +	{ AT91_PIN_PA1,  GPIOF_OUT_INIT_LOW,  "time_dir"},
>> +	{ AT91_PIN_PB12, GPIOF_OUT_INIT_LOW,  "gsm_rst"},
>> +	{ AT91_PIN_PB13, GPIOF_OUT_INIT_LOW,  "gsm_on"},
>> +	{ AT91_PIN_PC2,  GPIOF_IN,            "por"},
>> +	{ AT91_PIN_PC7,  GPIOF_OUT_INIT_HIGH, "spk_shdn"},
>> +
>> +	{ AT91_PIN_PC0,  GPIOF_IN,            "in13"},
>> +	{ AT91_PIN_PC1,  GPIOF_IN,            "in14"},
>> +	{ AT91_PIN_PA22, GPIOF_IN,            "in17"},
>> +	{ AT91_PIN_PA23, GPIOF_IN,            "in18"},
>> +	{ AT91_PIN_PA24, GPIOF_IN,            "in19"},
>> +	{ AT91_PIN_PA25, GPIOF_IN,            "in20"},
>> +
>> +	{ AT91_PIN_PA26, GPIOF_OUT_INIT_LOW,  "out15"},
>> +	{ AT91_PIN_PA27, GPIOF_OUT_INIT_LOW,  "out16"},
>> +	{ AT91_PIN_PA28, GPIOF_OUT_INIT_LOW,  "out17"},
>> +	{ AT91_PIN_PA29, GPIOF_OUT_INIT_LOW,  "out18"},
>> +	{ AT91_PIN_PA30, GPIOF_OUT_INIT_LOW,  "out19"},
>> +	{ AT91_PIN_PB29, GPIOF_OUT_INIT_LOW,  "out20"},
>> +
>> +	{ MCP23S08_GPIO_BASE + 0, GPIOF_IN,   "busadrp"},
>> +	{ MCP23S08_GPIO_BASE + 2, GPIOF_IN,   "busadr5"},
>> +	{ MCP23S08_GPIO_BASE + 3, GPIOF_IN,   "busadr4"},
>> +	{ MCP23S08_GPIO_BASE + 4, GPIOF_IN,   "busadr3"},
>> +	{ MCP23S08_GPIO_BASE + 5, GPIOF_IN,   "busadr2"},
>> +	{ MCP23S08_GPIO_BASE + 6, GPIOF_IN,   "busadr1"},
>> +	{ MCP23S08_GPIO_BASE + 7, GPIOF_IN,   "busadr0"},
>> +};
>> +
>> +static void __init cdu_add_gpio (void)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE (gpios); i++) {
>> +		gpio_request_one (gpios[i].gpio, gpios[i].flags, gpios[i].label);
>> +	}
> 
> Nitpick, don't need braces on the for loop here. Also, remove the spaces
> between cdu_add_gpiop, ARRAY_SIZE, and gpio_request_one and their
> opening parenthesis.
> 
There are two lines now.

>> +}
>> +
>> +/*
>> + * init
>> + */
>> +static void __init cdu_board_init(void)
>> +{
>> +	/* Serial */
>> +	at91_add_device_serial();
>> +	/* USB Host */
>> +	at91_add_device_usbh(&cdu_usbh_data);
>> +	/* USB Device */
>> +	at91_add_device_udc(&cdu_udc_data);
>> +	/* SPI */
>> +	at91_add_device_spi(cdu_spi_devices, ARRAY_SIZE(cdu_spi_devices));
>> +	/* NAND */
>> +	cdu_add_device_nand();
>> +	/* Ethernet */
>> +	at91_add_device_eth(&cdu_macb_data);
>> +	/* MMC */
>> +	at91_add_device_mmc(0, &ek_mmc_data);
>> +	/* SSC */
>> +	at91_add_device_ssc(AT91SAM9260_ID_SSC, (ATMEL_SSC_TF | ATMEL_SSC_TK | ATMEL_SSC_TD | ATMEL_SSC_RD));
>> +	/* LEDs */
>> +	at91_gpio_leds(cdu_leds, ARRAY_SIZE(cdu_leds));
>> +	// GPIO
>> +	cdu_add_gpio ();
> 
> I might be a bit alone on this, but I find this cut and paste comment
> style for the at91 device initialisation awful. The function names are
> very self explanatory and the comments only serve to make the init code
> more difficult to read. Also, remove the // comment.
> 
Removed.

>> +}
>> +
>> +MACHINE_START(AT91SAM9260EK, "CDU")
>> +	/* Maintainer: Atmel */
> 
> Nice of you to assign maintainership of your board to Atmel :-). You
> should possibly add a MAINTAINERS entry for this board.
New maitainer.

> 
>> +	.boot_params	= AT91_SDRAM_BASE + 0x100,
>> +	.timer		= &at91sam926x_timer,
>> +	.map_io		= cdu_map_io,
>> +	.init_irq	= cdu_init_irq,
>> +	.init_machine	= cdu_board_init,
>> +MACHINE_END
>> diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/arch/arm/mach-at91/Kconfig
>> /home/prchal/arm/fw-cdu/linux/linux-2.6.38/arch/arm/mach-at91/Kconfig
>> --- linux-2.6.38-vanilla/arch/arm/mach-at91/Kconfig	2011-03-15 02:20:32.000000000 +0100
>> +++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/arch/arm/mach-at91/Kconfig	2011-03-16 09:19:40.000000000 +0100
>> @@ -213,6 +213,12 @@ config MACH_AT91SAM9260EK
>>  	  Select this if you are using Atmel's AT91SAM9260-EK or AT91SAM9XE Evaluation Kit
>>  	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=3933>
>>
>> +config MACH_CDU
>> +	bool "CDU AKsignal board"
>> +	help
>> +	  Select this if you are using AKsignal CDU board
>> +	  <http://www.aksignal.cz>
>> +
>>  config MACH_CAM60
>>  	bool "KwikByte KB9260 (CAM60) board"
>>  	help
>> diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/arch/arm/mach-at91/Makefile
>> /home/prchal/arm/fw-cdu/linux/linux-2.6.38/arch/arm/mach-at91/Makefile
>> --- linux-2.6.38-vanilla/arch/arm/mach-at91/Makefile	2011-03-15 02:20:32.000000000 +0100
>> +++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/arch/arm/mach-at91/Makefile	2011-03-16 09:19:40.000000000 +0100
>> @@ -40,6 +40,7 @@ obj-$(CONFIG_MACH_ECO920)	+= board-eco92
>>
>>  # AT91SAM9260 board-specific support
>>  obj-$(CONFIG_MACH_AT91SAM9260EK) += board-sam9260ek.o
>> +obj-$(CONFIG_MACH_CDU)		 += board-cdu.o
>>  obj-$(CONFIG_MACH_CAM60)	+= board-cam60.o
>>  obj-$(CONFIG_MACH_SAM9_L9260)	+= board-sam9-l9260.o
>>  obj-$(CONFIG_MACH_USB_A9260)	+= board-usb-a9260.o
> 
> The first patch, adding just the support for the cdu board should end here.
> 

diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/arch/arm/mach-at91/board-cdu.c
linux-2.6.38-patch/arch/arm/mach-at91/board-cdu.c
--- linux-2.6.38-vanilla/arch/arm/mach-at91/board-cdu.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.38-patch/arch/arm/mach-at91/board-cdu.c	2011-03-28 15:52:03.413048601 +0200
@@ -0,0 +1,332 @@
+/*
+ * linux/arch/arm/mach-at91/board-cdu.c
+ *
+ *  Copyright (C) 2005 SAN People
+ *  Copyright (C) 2006 Atmel
+ *  Copyright (C) 2011 AKsignal Brno
+ *                     jiri.prchal@aksignal.cz
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/clk.h>
+#include <linux/spi/mcp23s08.h>
+#include <linux/dma-mapping.h>
+
+#include <mach/hardware.h>
+#include <asm/setup.h>
+#include <asm/mach-types.h>
+#include <asm/irq.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+
+#include <mach/board.h>
+#include <mach/gpio.h>
+#include <mach/at91sam9_smc.h>
+
+#include "sam9_smc.h"
+#include "generic.h"
+
+static void __init cdu_map_io(void)
+{
+	/* Initialize processor: 6 MHz crystal */
+	at91sam9260_initialize(6000000);
+
+	/* DBGU on ttyS0. (Rx & Tx only) */
+	at91_register_uart(0, 0, 0);
+
+	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI) */
+	at91_register_uart(AT91SAM9260_ID_US0, 1, ATMEL_UART_CTS | ATMEL_UART_RTS
+			   | ATMEL_UART_DTR | ATMEL_UART_DSR | ATMEL_UART_DCD
+			   | ATMEL_UART_RI);
+
+	/* USART1 on ttyS2. (Rx, Tx, RTS) */
+	at91_register_uart(AT91SAM9260_ID_US1, 2, ATMEL_UART_RTS);
+
+	/* USART2 on ttyS3. (Rx, Tx, RTS) */
+	at91_register_uart(AT91SAM9260_ID_US2, 3, ATMEL_UART_RTS);
+
+	/* USART3 on ttyS4. (Rx, Tx, RTS) */
+	at91_register_uart(AT91SAM9260_ID_US3, 4, ATMEL_UART_RTS);
+
+	/* USART4 on ttyS5. (Tx) */
+	/* EBUS - transmit audio, no rx */
+	/*at91_register_uart(AT91SAM9260_ID_US4, 5, 0);*/
+
+	/* set serial console to ttyS0 (ie, DBGU) */
+	at91_set_serial_console(0);
+}
+
+static void __init cdu_init_irq(void)
+{
+	at91sam9260_init_interrupts(NULL);
+}
+
+/*
+ * USB Host port
+ */
+static struct at91_usbh_data __initdata cdu_usbh_data = {
+	.ports		= 2,
+};
+
+/*
+ * USB Device port
+ */
+static struct at91_udc_data __initdata cdu_udc_data = {
+	.vbus_pin	= AT91_PIN_PC15,
+	.pullup_pin	= 0,		/* pull-up driven by UDC */
+};
+
+/*
+ * SPI devices.
+ */
+#define MCP23S08_GPIO_BASE	128
+
+static const struct mcp23s08_platform_data mcp23s08_gpio_info = {
+	.chip[0].is_present	= true,
+	.chip[0].pullups	= 0,
+	.base			= MCP23S08_GPIO_BASE,
+};
+
+static struct spi_board_info cdu_spi_devices[] = {
+	{ /* ADC LTC2488 */
+		.modalias	= "spidev",
+		.chip_select	= 0,
+		.max_speed_hz	= 1 * 1000 * 1000,
+		.bus_num	= 1,
+	},
+	{ /* GPIO expander MCP23S08 */
+		.modalias	= "mcp23s08",
+		.chip_select	= 1,
+		.max_speed_hz	= 1000000,
+		.bus_num	= 1,
+		.platform_data	= &mcp23s08_gpio_info,
+		.mode		= SPI_MODE_3,
+	},
+	{ /* non volatile memory (F-RAM) FM25VN10 */
+		.modalias	= "spidev",
+		.chip_select	= 2,
+		.max_speed_hz	= 1 * 1000 * 1000,
+		.bus_num	= 1,
+	},
+	{ /* audiocodec TLV320AIC3106 */
+		.modalias	= "tlv320aic3x-codec",
+		.chip_select	= 3,
+		.max_speed_hz	= 1000000,
+		.bus_num	= 1,
+		.mode		= SPI_MODE_1,
+	},
+};
+
+/*
+ * MACB Ethernet device
+ */
+static struct at91_eth_data __initdata cdu_macb_data = {
+	/*.phy_irq_pin	= ... not connected */
+	.is_rmii	= 1,
+};
+
+/*
+ * NAND flash
+ */
+static struct mtd_partition __initdata cdu_nand_partition[] = {
+	{
+		.name   = "bootstrap",
+		.offset = 0,
+		.size   = SZ_256K,
+	},
+	{
+		.name   = "uboot",
+		.offset = MTDPART_OFS_APPEND,
+		.size   = SZ_512K,
+	},
+	{
+		.name   = "ubootenv",
+		.offset = MTDPART_OFS_APPEND,
+		.size   = SZ_256K,
+	},
+	{
+		.name   = "kernel",
+		.offset = MTDPART_OFS_APPEND,
+		.size   = SZ_4M,
+	},
+	{
+		.name   = "rootfs",
+		.offset = MTDPART_OFS_APPEND,
+		.size   = MTDPART_SIZ_FULL,
+	},
+};
+
+static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
+{
+	*num_partitions = ARRAY_SIZE(cdu_nand_partition);
+	return cdu_nand_partition;
+}
+
+static struct atmel_nand_data __initdata cdu_nand_data = {
+	.ale		= 21,
+	.cle		= 22,
+	/*.det_pin	= ... not connected */
+	.rdy_pin	= AT91_PIN_PC13,
+	.enable_pin	= AT91_PIN_PC14,
+	.partition_info	= nand_partitions,
+	.bus_width_16	= 0,
+};
+
+static struct sam9_smc_config __initdata cdu_nand_smc_config = {
+	.ncs_read_setup		= 0,
+	.nrd_setup		= 1,
+	.ncs_write_setup	= 0,
+	.nwe_setup		= 1,
+
+	.ncs_read_pulse		= 3,
+	.nrd_pulse		= 3,
+	.ncs_write_pulse	= 3,
+	.nwe_pulse		= 3,
+
+	.read_cycle		= 5,
+	.write_cycle		= 5,
+
+	.mode			= AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE,
+	.tdf_cycles		= 2,
+};
+
+static void __init cdu_add_device_nand(void)
+{
+	/* setup bus-width 8 */
+	cdu_nand_smc_config.mode |= AT91_SMC_DBW_8;
+
+	/* configure chip-select 3 (NAND) */
+	sam9_smc_configure(3, &cdu_nand_smc_config);
+
+	at91_add_device_nand(&cdu_nand_data);
+}
+
+/*
+* MCI (SD/MMC)
+*/
+static struct at91_mmc_data __initdata ek_mmc_data = {
+	.slot_b		= 0,
+	.wire4		= 1,
+	/*.det_pin	= ... not connected */
+	/*.wp_pin	= ... not connected */
+	/*.vcc_pin	= ... not connected */
+};
+
+/*
+ * LEDs
+ */
+static struct gpio_led cdu_leds[] = {
+	{
+		.name			= "red",
+		.gpio			= AT91_PIN_PC10,
+		.default_trigger	= "timer",
+	},
+	{
+		.name			= "green",
+		.gpio			= AT91_PIN_PA5,
+		.default_trigger	= "heartbeat",
+	},
+	{
+		.name			= "yellow",
+		.gpio			= AT91_PIN_PB20,
+		.active_low		= 1,
+		.default_trigger	= "mmc0",
+	},
+	{
+		.name			= "blue",
+		.gpio			= AT91_PIN_PB21,
+		.active_low		= 1,
+		.default_trigger	= "nand-disk",
+	},
+};
+
+/*
+ * GPIOs
+ */
+static struct gpio gpios[] = {
+	{ AT91_PIN_PA0,  GPIOF_OUT_INIT_LOW,  "ebus_dir"},
+	{ AT91_PIN_PA1,  GPIOF_OUT_INIT_LOW,  "time_dir"},
+	{ AT91_PIN_PB12, GPIOF_OUT_INIT_LOW,  "gsm_rst"},
+	{ AT91_PIN_PB13, GPIOF_OUT_INIT_LOW,  "gsm_on"},
+	{ AT91_PIN_PC2,  GPIOF_IN,            "por"},
+	{ AT91_PIN_PC7,  GPIOF_OUT_INIT_HIGH, "spk_shdn"},
+
+	{ AT91_PIN_PC0,  GPIOF_IN,            "in13"},
+	{ AT91_PIN_PC1,  GPIOF_IN,            "in14"},
+	{ AT91_PIN_PA22, GPIOF_IN,            "in17"},
+	{ AT91_PIN_PA23, GPIOF_IN,            "in18"},
+	{ AT91_PIN_PA24, GPIOF_IN,            "in19"},
+	{ AT91_PIN_PA25, GPIOF_IN,            "in20"},
+
+	{ AT91_PIN_PA26, GPIOF_OUT_INIT_LOW,  "out15"},
+	{ AT91_PIN_PA27, GPIOF_OUT_INIT_LOW,  "out16"},
+	{ AT91_PIN_PA28, GPIOF_OUT_INIT_LOW,  "out17"},
+	{ AT91_PIN_PA29, GPIOF_OUT_INIT_LOW,  "out18"},
+	{ AT91_PIN_PA30, GPIOF_OUT_INIT_LOW,  "out19"},
+	{ AT91_PIN_PB29, GPIOF_OUT_INIT_LOW,  "out20"},
+
+	{ MCP23S08_GPIO_BASE + 0, GPIOF_IN,   "busadrp"},
+	{ MCP23S08_GPIO_BASE + 2, GPIOF_IN,   "busadr5"},
+	{ MCP23S08_GPIO_BASE + 3, GPIOF_IN,   "busadr4"},
+	{ MCP23S08_GPIO_BASE + 4, GPIOF_IN,   "busadr3"},
+	{ MCP23S08_GPIO_BASE + 5, GPIOF_IN,   "busadr2"},
+	{ MCP23S08_GPIO_BASE + 6, GPIOF_IN,   "busadr1"},
+	{ MCP23S08_GPIO_BASE + 7, GPIOF_IN,   "busadr0"},
+};
+
+static void __init cdu_add_gpio(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(gpios); i++) {
+		gpio_request_one(gpios[i].gpio, gpios[i].flags, gpios[i].label);
+		gpio_export_name(gpios[i].gpio, 0, gpios[i].label);
+	}
+}
+
+/*
+ * init
+ */
+static void __init cdu_board_init(void)
+{
+	at91_add_device_serial();
+	at91_add_device_usbh(&cdu_usbh_data);
+	at91_add_device_udc(&cdu_udc_data);
+	at91_add_device_spi(cdu_spi_devices, ARRAY_SIZE(cdu_spi_devices));
+	cdu_add_device_nand();
+	at91_add_device_eth(&cdu_macb_data);
+	at91_add_device_mmc(0, &ek_mmc_data);
+	at91_add_device_ssc(AT91SAM9260_ID_SSC, (ATMEL_SSC_TF | ATMEL_SSC_TK | ATMEL_SSC_TD | ATMEL_SSC_RD));
+	at91_gpio_leds(cdu_leds, ARRAY_SIZE(cdu_leds));
+	cdu_add_gpio ();
+}
+
+MACHINE_START(AT91SAM9260EK, "CDU")
+	/* Maintainer: AKsignal Brno */
+	.boot_params	= AT91_SDRAM_BASE + 0x100,
+	.timer		= &at91sam926x_timer,
+	.map_io		= cdu_map_io,
+	.init_irq	= cdu_init_irq,
+	.init_machine	= cdu_board_init,
+MACHINE_END
diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/arch/arm/mach-at91/Kconfig
linux-2.6.38-patch/arch/arm/mach-at91/Kconfig
--- linux-2.6.38-vanilla/arch/arm/mach-at91/Kconfig	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-patch/arch/arm/mach-at91/Kconfig	2011-03-16 09:19:40.000000000 +0100
@@ -213,6 +213,12 @@ config MACH_AT91SAM9260EK
 	  Select this if you are using Atmel's AT91SAM9260-EK or AT91SAM9XE Evaluation Kit
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=3933>

+config MACH_CDU
+	bool "CDU AKsignal board"
+	help
+	  Select this if you are using AKsignal CDU board
+	  <http://www.aksignal.cz>
+
 config MACH_CAM60
 	bool "KwikByte KB9260 (CAM60) board"
 	help
diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/arch/arm/mach-at91/Makefile
linux-2.6.38-patch/arch/arm/mach-at91/Makefile
--- linux-2.6.38-vanilla/arch/arm/mach-at91/Makefile	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-patch/arch/arm/mach-at91/Makefile	2011-03-16 09:19:40.000000000 +0100
@@ -40,6 +40,7 @@ obj-$(CONFIG_MACH_ECO920)	+= board-eco92

 # AT91SAM9260 board-specific support
 obj-$(CONFIG_MACH_AT91SAM9260EK) += board-sam9260ek.o
+obj-$(CONFIG_MACH_CDU)		 += board-cdu.o
 obj-$(CONFIG_MACH_CAM60)	+= board-cam60.o
 obj-$(CONFIG_MACH_SAM9_L9260)	+= board-sam9-l9260.o
 obj-$(CONFIG_MACH_USB_A9260)	+= board-usb-a9260.o
diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/MAINTAINERS linux-2.6.38-patch/MAINTAINERS
--- linux-2.6.38-vanilla/MAINTAINERS	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-patch/MAINTAINERS	2011-03-25 08:37:56.693049978 +0100
@@ -1640,6 +1640,13 @@ F:	include/linux/can/error.h
 F:	include/linux/can/netlink.h
 F:	include/linux/can/platform/

+CDU BOARD
+M:	Jiri Prchal <jiri.prchal@aksignal.cz>
+L:	linux-arch@vger.kernel.org
+W:	http://www.linux4sam.org
+S:	Supported
+F:	arch/arm/mach-at91/
+
 CELL BROADBAND ENGINE ARCHITECTURE
 M:	Arnd Bergmann <arnd@arndb.de>
 L:	linuxppc-dev@lists.ozlabs.org
Soubory linux-2.6.38-vanilla/scripts/recordmcount a linux-2.6.38-patch/scripts/recordmcount jsou rĹŻznĂŠ
