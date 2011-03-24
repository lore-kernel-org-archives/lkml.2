Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab1CXKoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 06:44:03 -0400
Received: from router.aksignal.cz ([188.175.113.102]:41952 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab1CXKoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 06:44:00 -0400
Message-ID: <4D8B2068.60402@aksignal.cz>
Date: Thu, 24 Mar 2011 11:43:52 +0100
From: =?ISO-8859-2?Q?Prchal_Ji=F8=ED?= <jiri.prchal@aksignal.cz>
Organization: AK signal Brno
User-Agent: Mozilla/5.0 (X11; U; Linux i686; cs-CZ; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Lightning/1.0b1 Thunderbird/3.0.11
MIME-Version: 1.0
To: alsa-devel@vger.kernel.org, alsa-devel@alsa-project.org,
        vbarinov@embeddedalley.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ALSA: ASoc: putting together AT91SAM9260 and TLV320AIC3X
References: <1300949648-15078-1-git-send-email-horms@verge.net.au> <1300949648-15078-2-git-send-email-horms@verge.net.au>
In-Reply-To: <1300949648-15078-2-git-send-email-horms@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this patch is for example how to put together AT91SAM9260 and TLV320AIC3106 controlled via SPI.
It tooks me a lot of time to make it working, so I think it could be helpfull for other people.

In original source "snd-soc-afeb9260.c" which I use as example is BIG ERROR:
In function "afeb9260_soc_init" is missing call of "atmel_ssc_set_audio(0);". It cause bug "PROBLEM: Asoc driver in
2.6.37.3 for AT91SAM9260 / TLV320AIC3X is broken" which I post some time ago.

Depend on: [PATCH 1/2] ALSA: ASoc: TLV320AIC3X: ad SPI and clock on GPIO2 or BCLK
Kernel version: 2.6.38
Signed-off-by: Jiri Prchal <jiri.prchal@aksignal.cz>
---

diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/arch/arm/mach-at91/board-cdu.c
/home/prchal/arm/fw-cdu/linux/linux-2.6.38/arch/arm/mach-at91/board-cdu.c
--- linux-2.6.38-vanilla/arch/arm/mach-at91/board-cdu.c	1970-01-01 01:00:00.000000000 +0100
+++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/arch/arm/mach-at91/board-cdu.c	2011-03-24 09:15:23.852370981 +0100
@@ -0,0 +1,345 @@
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
+	.phy_irq_pin	= 0, //nc,
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
+	  .size   = 0x40000,
+	},
+	{
+		.name   = "uboot",
+		.offset = 0x40000,
+		.size   = (0xc0000 - 0x40000),
+	},
+	{
+		.name   = "ubootenv",
+		.offset = 0xc0000,
+		.size   = (0x100000 - 0xc0000),
+	},
+	{
+		.name   = "kernel",
+		.offset = 0x100000,
+		.size   = (0x400000 - 0x100000),
+	},
+	{
+		.name   = "rootfs",
+		.offset = 0x400000,
+		.size   = (0x8000000 - 0x400000),
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
+//	.det_pin	= ... not connected
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
+	/* setup bus-width (8 or 16) */
+	if (cdu_nand_data.bus_width_16)
+		cdu_nand_smc_config.mode |= AT91_SMC_DBW_16;
+	else
+		cdu_nand_smc_config.mode |= AT91_SMC_DBW_8;
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
+  .slot_b		= 0,
+  .wire4		= 1,
+  //	.det_pin	= ... not connected
+  //	.wp_pin		= ... not connected
+  //	.vcc_pin	= ... not connected
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
+static void __init cdu_add_gpio (void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE (gpios); i++) {
+		gpio_request_one (gpios[i].gpio, gpios[i].flags, gpios[i].label);
+	}
+}
+
+/*
+ * init
+ */
+static void __init cdu_board_init(void)
+{
+	/* Serial */
+	at91_add_device_serial();
+	/* USB Host */
+	at91_add_device_usbh(&cdu_usbh_data);
+	/* USB Device */
+	at91_add_device_udc(&cdu_udc_data);
+	/* SPI */
+	at91_add_device_spi(cdu_spi_devices, ARRAY_SIZE(cdu_spi_devices));
+	/* NAND */
+	cdu_add_device_nand();
+	/* Ethernet */
+	at91_add_device_eth(&cdu_macb_data);
+	/* MMC */
+	at91_add_device_mmc(0, &ek_mmc_data);
+	/* SSC */
+	at91_add_device_ssc(AT91SAM9260_ID_SSC, (ATMEL_SSC_TF | ATMEL_SSC_TK | ATMEL_SSC_TD | ATMEL_SSC_RD));
+	/* LEDs */
+	at91_gpio_leds(cdu_leds, ARRAY_SIZE(cdu_leds));
+	// GPIO
+	cdu_add_gpio ();
+}
+
+MACHINE_START(AT91SAM9260EK, "CDU")
+	/* Maintainer: Atmel */
+	.boot_params	= AT91_SDRAM_BASE + 0x100,
+	.timer		= &at91sam926x_timer,
+	.map_io		= cdu_map_io,
+	.init_irq	= cdu_init_irq,
+	.init_machine	= cdu_board_init,
+MACHINE_END
diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/arch/arm/mach-at91/Kconfig
/home/prchal/arm/fw-cdu/linux/linux-2.6.38/arch/arm/mach-at91/Kconfig
--- linux-2.6.38-vanilla/arch/arm/mach-at91/Kconfig	2011-03-15 02:20:32.000000000 +0100
+++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/arch/arm/mach-at91/Kconfig	2011-03-16 09:19:40.000000000 +0100
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
/home/prchal/arm/fw-cdu/linux/linux-2.6.38/arch/arm/mach-at91/Makefile
--- linux-2.6.38-vanilla/arch/arm/mach-at91/Makefile	2011-03-15 02:20:32.000000000 +0100
+++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/arch/arm/mach-at91/Makefile	2011-03-16 09:19:40.000000000 +0100
@@ -40,6 +40,7 @@ obj-$(CONFIG_MACH_ECO920)	+= board-eco92

 # AT91SAM9260 board-specific support
 obj-$(CONFIG_MACH_AT91SAM9260EK) += board-sam9260ek.o
+obj-$(CONFIG_MACH_CDU)		 += board-cdu.o
 obj-$(CONFIG_MACH_CAM60)	+= board-cam60.o
 obj-$(CONFIG_MACH_SAM9_L9260)	+= board-sam9-l9260.o
 obj-$(CONFIG_MACH_USB_A9260)	+= board-usb-a9260.o
diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/atmel/Kconfig
/home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/atmel/Kconfig
--- linux-2.6.38-vanilla/sound/soc/atmel/Kconfig	2011-03-15 02:20:32.000000000 +0100
+++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/atmel/Kconfig	2011-03-22 09:46:46.751566158 +0100
@@ -50,3 +50,11 @@ config SND_AT91_SOC_AFEB9260
 	select SND_SOC_TLV320AIC23
 	help
 	  Say Y here to support sound on AFEB9260 board.
+
+config SND_AT91_SOC_CDU
+	tristate "SoC Audio support for CDU board"
+	depends on ARCH_AT91 && MACH_CDU && SND_ATMEL_SOC
+	select SND_ATMEL_SOC_SSC
+	select SND_SOC_TLV320AIC3X
+	help
+	  Say Y here to support sound on CDU board.
diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/atmel/Makefile
/home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/atmel/Makefile
--- linux-2.6.38-vanilla/sound/soc/atmel/Makefile	2011-03-15 02:20:32.000000000 +0100
+++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/atmel/Makefile	2011-03-16 09:26:17.000000000 +0100
@@ -14,3 +14,4 @@ snd-soc-playpaq-objs := playpaq_wm8510.o
 obj-$(CONFIG_SND_AT91_SOC_SAM9G20_WM8731) += snd-soc-sam9g20-wm8731.o
 obj-$(CONFIG_SND_AT32_SOC_PLAYPAQ) += snd-soc-playpaq.o
 obj-$(CONFIG_SND_AT91_SOC_AFEB9260) += snd-soc-afeb9260.o
+obj-$(CONFIG_SND_AT91_SOC_CDU) += snd-soc-cdu.o
diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/atmel/snd-soc-cdu.c
/home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/atmel/snd-soc-cdu.c
--- linux-2.6.38-vanilla/sound/soc/atmel/snd-soc-cdu.c	1970-01-01 01:00:00.000000000 +0100
+++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/atmel/snd-soc-cdu.c	2011-03-24 09:27:55.404367652 +0100
@@ -0,0 +1,264 @@
+/*
+ * snd-soc-cdu  --  SoC audio for AT91SAM9260-based
+ * 			AKsignal CDU board.
+ *
+ *  Copyright (C) 2005 SAN People
+ *  Copyright (C) 2008 Atmel
+ *  Copyright (C) 2011 AK signal Brno
+ *
+ * Authors: Sedji Gaouaou <sedji.gaouaou@atmel.com>
+ *          Jiri Prchal <jiri.prchal@aksignal.cz>
+ *
+ * Based on ati_b1_wm8731.c by:
+ * Frank Mandarino <fmandarino@endrelia.com>
+ * Copyright 2006 Endrelia Technologies Inc.
+ * Based on corgi.c by:
+ * Copyright 2005 Wolfson Microelectronics PLC.
+ * Copyright 2005 Openedhand Ltd.
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
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/timer.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+
+#include <linux/atmel-ssc.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+
+#include <asm/mach-types.h>
+#include <mach/hardware.h>
+#include <mach/gpio.h>
+
+#include "../codecs/tlv320aic3x.h"
+#include "atmel-pcm.h"
+#include "atmel_ssc_dai.h"
+
+struct {
+	unsigned int channels;
+	snd_pcm_format_t format;
+	unsigned int rate;
+	unsigned int codecclk;
+	unsigned int cmrdiv;
+	unsigned int period;
+} cdu_audio[] = {
+	/* 16 bit stereo modes */
+	{2, SNDRV_PCM_FORMAT_S16_LE, 8000, 2096000, 25, 130,},
+	{2, SNDRV_PCM_FORMAT_S16_LE, 16000, 2496000, 21, 77,},
+	{2, SNDRV_PCM_FORMAT_S16_LE, 32000, 2496000, 21, 38,},
+	{2, SNDRV_PCM_FORMAT_S16_LE, 48000, 2016000, 26, 20,},
+	{2, SNDRV_PCM_FORMAT_S16_LE, 96000, 4032000, 13, 20,},
+
+	{2, SNDRV_PCM_FORMAT_S16_LE, 11025, 2381400, 22, 107,},
+	{2, SNDRV_PCM_FORMAT_S16_LE, 22050, 2381400, 22, 53,},
+	{2, SNDRV_PCM_FORMAT_S16_LE, 44100, 2381400, 22, 26,},
+	{2, SNDRV_PCM_FORMAT_S16_LE, 88200, 4762800, 11, 26,},
+
+	{2, SNDRV_PCM_FORMAT_S16_LE, 11520, 2626560, 20, 113,},
+	{2, SNDRV_PCM_FORMAT_S16_LE, 23040, 2626560, 20, 56,},
+
+};
+
+static int cdu_hw_params(struct snd_pcm_substream *substream, struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
+	int ret;
+	int i, found = 0;
+	snd_pcm_format_t format = params_format(params);
+	unsigned int rate = params_rate(params);
+	unsigned int channels = params_channels(params);
+
+	/* set codec DAI configuration */
+	ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS);
+	if (ret < 0)
+		return ret;
+
+	/* set cpu DAI configuration */
+	ret = snd_soc_dai_set_fmt(cpu_dai, SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS);
+	if (ret < 0)
+		return ret;
+
+	/* find the correct audio parameters */
+	for (i = 0; i < ARRAY_SIZE(cdu_audio); i++) {
+		if (rate == cdu_audio[i].rate &&
+		    format == cdu_audio[i].format &&
+		    channels == cdu_audio[i].channels) {
+			found = 1;
+			break;
+		}
+	}
+	if (!found)
+		return -EINVAL;
+
+	/* Set the codec system clock for DAC and ADC */
+	ret = snd_soc_dai_set_sysclk(codec_dai, CLKIN_BCLK, cdu_audio[i].codecclk, SND_SOC_CLOCK_IN);
+	if (ret < 0) {
+		printk(KERN_ERR "can't set codec system clock\n");
+		return ret;
+	}
+
+	/* Set the cpu clock dividers to BCLK */
+	ret = snd_soc_dai_set_clkdiv(cpu_dai, ATMEL_SSC_CMR_DIV, cdu_audio[i].cmrdiv);
+	ret |= snd_soc_dai_set_clkdiv(cpu_dai, ATMEL_SSC_TCMR_PERIOD, cdu_audio[i].period);
+	ret |= snd_soc_dai_set_clkdiv(cpu_dai, ATMEL_SSC_RCMR_PERIOD, cdu_audio[i].period);
+	if (ret < 0) {
+		printk(KERN_ERR "can't set cpu system clock\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct snd_soc_ops cdu_ops = {
+	.hw_params = cdu_hw_params,
+};
+
+static const struct snd_soc_dapm_widget cdu_dapm_widgets[] = {
+	SND_SOC_DAPM_HP("Headphone Jack", NULL),
+	SND_SOC_DAPM_LINE("Line Out", NULL),
+	SND_SOC_DAPM_MIC("Mic Jack", NULL),
+	SND_SOC_DAPM_LINE("Line In", NULL),
+};
+
+static const struct snd_soc_dapm_route intercon[] = {
+	/* Headphone connected to HPLOUT, HPROUT */
+	{"Headphone Jack", NULL, "HPLOUT"},
+	{"Headphone Jack", NULL, "HPROUT"},
+
+	/* Line Out connected to LLOUT, RLOUT */
+	{"Line Out", NULL, "LLOUT"},
+	{"Line Out", NULL, "RLOUT"},
+
+	/* Mic connected to (MIC3L | MIC3R) */
+	{"MIC3L", NULL, "Mic Bias 2V"},
+	{"MIC3R", NULL, "Mic Bias 2V"},
+	{"Mic Bias 2V", NULL, "Mic Jack"},
+
+	/* Line In connected to (LINE1L | LINE2L), (LINE1R | LINE2R) */
+	{"LINE1L", NULL, "Line In"},
+	{"LINE2L", NULL, "Line In"},
+	{"LINE1R", NULL, "Line In"},
+	{"LINE2R", NULL, "Line In"},
+};
+
+/*
+ * Logic for a aic3x as connected on a cdu board.
+ */
+static int cdu_aic3x_init(struct snd_soc_pcm_runtime *rtd)
+{
+	struct snd_soc_codec *codec = rtd->codec;
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	struct snd_soc_dapm_context *dapm = &codec->dapm;
+	int ret;
+
+	printk(KERN_DEBUG "cdu_aic3x: cdu_aic3x_init called\n");
+
+	/* Add specific widgets */
+	snd_soc_dapm_new_controls(dapm, cdu_dapm_widgets,
+				  ARRAY_SIZE(cdu_dapm_widgets));
+	/* Set up specific audio path interconnects */
+	snd_soc_dapm_add_routes(dapm, intercon, ARRAY_SIZE(intercon));
+
+	/* always connected */
+	snd_soc_dapm_enable_pin(dapm, "Headphone Jack");
+	snd_soc_dapm_enable_pin(dapm, "Line Out");
+	snd_soc_dapm_enable_pin(dapm, "Mic Jack");
+	snd_soc_dapm_enable_pin(dapm, "Line In");
+
+	snd_soc_dapm_sync(dapm);
+
+	return 0;
+}
+
+static struct snd_soc_dai_link cdu_dai = {
+	.name		= "TLV320AIC3106",
+	.stream_name	= "PCM",
+	.cpu_dai_name	= "atmel-ssc-dai.0",
+	.codec_dai_name	= "tlv320aic3x-hifi",
+	.init = cdu_aic3x_init,
+	.platform_name	= "atmel-pcm-audio",
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+	.codec_name	= "tlv320aic3x-codec.0-001b",
+#endif
+#if defined(CONFIG_SPI_MASTER)
+	.codec_name	= "spi1.3",
+#endif
+	.ops		= &cdu_ops,
+};
+
+static struct snd_soc_card snd_soc_cdu = {
+	.name		= "TLV320AIC3106",
+	.dai_link	= &cdu_dai,
+	.num_links	= 1,
+};
+
+static struct platform_device *cdu_snd_device;
+
+static int __init cdu_init(void)
+{
+	struct clk *pllb;
+	int ret;
+
+	ret = atmel_ssc_set_audio(0);
+	if (ret != 0) {
+		pr_err("Failed to set SSC 0 for audio: %d\n", ret);
+		return ret;
+	}
+
+	cdu_snd_device = platform_device_alloc("soc-audio", -1);
+	if (!cdu_snd_device) {
+		printk(KERN_ERR "ASoC: Platform device allocation failed\n");
+		ret = -ENOMEM;
+	}
+
+	platform_set_drvdata(cdu_snd_device, &snd_soc_cdu);
+
+	ret = platform_device_add(cdu_snd_device);
+	if (ret) {
+		printk(KERN_ERR "ASoC: Platform device allocation failed\n");
+		goto err_device_add;
+	}
+
+	return ret;
+
+err_device_add:
+	platform_device_put(cdu_snd_device);
+err:
+	return ret;
+}
+
+static void __exit cdu_exit(void)
+{
+	platform_device_unregister(cdu_snd_device);
+	cdu_snd_device = NULL;
+}
+
+module_init(cdu_init);
+module_exit(cdu_exit);
+
+/* Module information */
+MODULE_AUTHOR("Jiri Prchal <jiri.prchal@aksignal.cz>");
+MODULE_DESCRIPTION("ALSA SoC CDU_AIC3X");
+MODULE_LICENSE("GPL");
