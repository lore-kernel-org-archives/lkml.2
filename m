Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab0JNAP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:15:59 -0400
Received: from smtplq-out4.aruba.it ([62.149.158.24]:51526 "HELO
	smtplq01.aruba.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751292Ab0JNAP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:15:57 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Oct 2010 20:15:56 EDT
From: Sergio Tanzilli <tanzilli@acmesystems.it>
To: linux@arm.linux.org.uk
Cc: linux@maxim.org.za, nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        costa.antonior@gmail.com, eschwab@online.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sergio Tanzilli <tanzilli@acmesystems.it>
Subject: [PATCH] Acme Systems FOX Board G20 board files
Date: Thu, 14 Oct 2010 02:06:26 +0200
Message-Id: <1287014786-25543-1-git-send-email-tanzilli@acmesystems.it>
X-Mailer: git-send-email 1.7.0.4
Signed-off-by: Sergio Tanzilli <tanzilli@acmesystems.it>
X-Spam-Rating: smtp6.ad.aruba.it 1.6.2 0/1000/N
X-Spam-Rating: smtplq01.aruba.it 1.6.2 0/1000/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 arch/arm/mach-at91/Kconfig        |    7 +
 arch/arm/mach-at91/Makefile       |    2 +
 arch/arm/mach-at91/board-foxg20.c |  279 +++++++++++++++++++++++++++++++++++++
 3 files changed, 288 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-at91/board-foxg20.c

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 939bccd..35def97 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -364,6 +364,13 @@ config MACH_STAMP9G20
 	  evaluation board.
 	  <http://www.taskit.de/en/>
 
+config MACH_FOXG20
+	bool "Acme Systems srl FOX Board G20"
+	depends on ARCH_AT91SAM9G20
+	help
+	  Select this if you are using Acme Systems
+	  FOX Board G20 <http://www.acmesystems.it>
+
 endif
 
 if (ARCH_AT91SAM9260 || ARCH_AT91SAM9G20)
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index ca2ac00..686bc6d 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -65,6 +65,8 @@ obj-$(CONFIG_MACH_AT91SAM9G20EK_2MMC) += board-sam9g20ek-2slot-mmc.o
 obj-$(CONFIG_MACH_CPU9G20)	+= board-cpu9krea.o
 obj-$(CONFIG_MACH_STAMP9G20)	+= board-stamp9g20.o
 obj-$(CONFIG_MACH_PORTUXG20)	+= board-stamp9g20.o
+obj-$(CONFIG_MACH_FOXG20)	+= board-foxg20.o
+
 
 # AT91SAM9260/AT91SAM9G20 board-specific support
 obj-$(CONFIG_MACH_SNAPPER_9260)	+= board-snapper9260.o
diff --git a/arch/arm/mach-at91/board-foxg20.c b/arch/arm/mach-at91/board-foxg20.c
new file mode 100644
index 0000000..f6179c2
--- /dev/null
+++ b/arch/arm/mach-at91/board-foxg20.c
@@ -0,0 +1,279 @@
+/*
+ *  Copyright (C) 2005 SAN People
+ *  Copyright (C) 2008 Atmel
+ *  Copyright (C) 2010 Lee McLoughlin - lee@lmmrtech.com
+ *  Copyright (C) 2010 Sergio Tanzilli - tanzilli@acmesystems.it
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
+#include <linux/spi/at73c213.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
+#include <linux/clk.h>
+#include <linux/w1-gpio.h>
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
+/*
+ * The FOX Board G20 hardware comes as the "Netus G20" board with
+ * just the cpu, ram, dataflash and two header connectors.
+ * This is plugged into the FOX Board which provides the ethernet,
+ * usb, rtc, leds, switch, ...
+ *
+ * For more info visit: http://www.acmesystems.it/foxg20
+ */
+
+
+static void __init foxg20_map_io(void)
+{
+	/* Initialize processor: 18.432 MHz crystal */
+	at91sam9260_initialize(18432000);
+
+	/* DBGU on ttyS0. (Rx & Tx only) */
+	at91_register_uart(0, 0, 0);
+
+	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI) */
+	at91_register_uart(AT91SAM9260_ID_US0, 1,
+				ATMEL_UART_CTS
+				| ATMEL_UART_RTS
+				| ATMEL_UART_DTR
+				| ATMEL_UART_DSR
+				| ATMEL_UART_DCD
+				| ATMEL_UART_RI);
+
+	/* USART1 on ttyS2. (Rx, Tx, RTS, CTS) */
+	at91_register_uart(AT91SAM9260_ID_US1, 2,
+		ATMEL_UART_CTS
+		| ATMEL_UART_RTS);
+
+	/* USART2 on ttyS3. (Rx & Tx only) */
+	at91_register_uart(AT91SAM9260_ID_US2, 3, 0);
+
+	/* USART3 on ttyS4. (Rx, Tx, RTS, CTS) */
+	at91_register_uart(AT91SAM9260_ID_US3, 4,
+		ATMEL_UART_CTS
+		| ATMEL_UART_RTS);
+
+	/* USART4 on ttyS5. (Rx & Tx only) */
+	at91_register_uart(AT91SAM9260_ID_US4, 5, 0);
+
+	/* USART5 on ttyS6. (Rx & Tx only) */
+	at91_register_uart(AT91SAM9260_ID_US5, 6, 0);
+
+	/* set serial console to ttyS0 (ie, DBGU) */
+	at91_set_serial_console(0);
+
+	/* Set the internal pull-up resistor on DRXD */
+	at91_set_A_periph(AT91_PIN_PB14, 1);
+
+}
+
+static void __init foxg20_init_irq(void)
+{
+	at91sam9260_init_interrupts(NULL);
+}
+
+
+/*
+ * USB Host port
+ */
+static struct at91_usbh_data __initdata foxg20_usbh_data = {
+	.ports		= 2,
+};
+
+/*
+ * USB Device port
+ */
+static struct at91_udc_data __initdata foxg20_udc_data = {
+	.vbus_pin	= AT91_PIN_PC6,
+	.pullup_pin	= 0,		/* pull-up driven by UDC */
+};
+
+
+/*
+ * SPI devices.
+ */
+static struct spi_board_info foxg20_spi_devices[] = {
+#if !defined(CONFIG_MMC_AT91)
+	{
+		.modalias	= "mtd_dataflash",
+		.chip_select	= 1,
+		.max_speed_hz	= 15 * 1000 * 1000,
+		.bus_num	= 0,
+	},
+#endif
+};
+
+
+/*
+ * MACB Ethernet device
+ */
+static struct at91_eth_data __initdata foxg20_macb_data = {
+	.phy_irq_pin	= AT91_PIN_PA7,
+	.is_rmii	= 1,
+};
+
+
+
+
+/*
+ * MCI (SD/MMC)
+ * det_pin, wp_pin and vcc_pin are not connected
+ */
+static struct at91_mmc_data __initdata foxg20_mmc_data = {
+	.slot_b		= 1,
+	.wire4		= 1,
+};
+
+
+/*
+ * LEDs
+ */
+static struct gpio_led foxg20_leds[] = {
+	{	/* user led, red */
+		.name			= "user_led",
+		.gpio			= AT91_PIN_PC7,
+		.active_low		= 0,
+		.default_trigger	= "heartbeat",
+	},
+};
+
+
+/*
+ * GPIO Buttons
+ */
+#if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
+static struct gpio_keys_button foxg20_buttons[] = {
+	{
+		.gpio		= AT91_PIN_PC4,
+		.code		= BTN_1,
+		.desc		= "Button 1",
+		.active_low	= 1,
+		.wakeup		= 1,
+	},
+};
+
+static struct gpio_keys_platform_data foxg20_button_data = {
+	.buttons	= foxg20_buttons,
+	.nbuttons	= ARRAY_SIZE(foxg20_buttons),
+};
+
+static struct platform_device foxg20_button_device = {
+	.name		= "gpio-keys",
+	.id		= -1,
+	.num_resources	= 0,
+	.dev		= {
+		.platform_data	= &foxg20_button_data,
+	}
+};
+
+static void __init foxg20_add_device_buttons(void)
+{
+	at91_set_gpio_input(AT91_PIN_PC4, 1);	/* btn1 */
+	at91_set_deglitch(AT91_PIN_PC4, 1);
+
+	platform_device_register(&foxg20_button_device);
+}
+#else
+static void __init foxg20_add_device_buttons(void) {}
+#endif
+
+
+#if defined(CONFIG_W1_MASTER_GPIO) || defined(CONFIG_W1_MASTER_GPIO_MODULE)
+static struct w1_gpio_platform_data w1_gpio_pdata = {
+	/* If you choose to use a pin other than PB16 it needs to be 3.3V */
+	.pin		= AT91_PIN_PB16,
+	.is_open_drain  = 1,
+};
+
+static struct platform_device w1_device = {
+	.name                   = "w1-gpio",
+	.id                     = -1,
+	.dev.platform_data      = &w1_gpio_pdata,
+};
+
+static void __init at91_add_device_w1(void)
+{
+	at91_set_GPIO_periph(w1_gpio_pdata.pin, 1);
+	at91_set_multi_drive(w1_gpio_pdata.pin, 1);
+	platform_device_register(&w1_device);
+}
+
+#endif
+
+
+static struct i2c_board_info __initdata foxg20_i2c_devices[] = {
+	{
+		I2C_BOARD_INFO("24c512", 0x50),
+	},
+};
+
+
+static void __init foxg20_board_init(void)
+{
+	/* Serial */
+	at91_add_device_serial();
+	/* USB Host */
+	at91_add_device_usbh(&foxg20_usbh_data);
+	/* USB Device */
+	at91_add_device_udc(&foxg20_udc_data);
+	/* SPI */
+	at91_add_device_spi(foxg20_spi_devices, ARRAY_SIZE(foxg20_spi_devices));
+	/* Ethernet */
+	at91_add_device_eth(&foxg20_macb_data);
+	/* MMC */
+	at91_add_device_mmc(0, &foxg20_mmc_data);
+	/* I2C */
+	at91_add_device_i2c(foxg20_i2c_devices, ARRAY_SIZE(foxg20_i2c_devices));
+	/* LEDs */
+	at91_gpio_leds(foxg20_leds, ARRAY_SIZE(foxg20_leds));
+	/* Push Buttons */
+	foxg20_add_device_buttons();
+#if defined(CONFIG_W1_MASTER_GPIO) || defined(CONFIG_W1_MASTER_GPIO_MODULE)
+	at91_add_device_w1();
+#endif
+}
+
+MACHINE_START(FOXG20, "Acme Systems srl FOX Board G20")
+	/* Maintainer: Sergio Tanzilli */
+	.phys_io	= AT91_BASE_SYS,
+	.io_pg_offst	= (AT91_VA_BASE_SYS >> 18) & 0xfffc,
+	.boot_params	= AT91_SDRAM_BASE + 0x100,
+	.timer		= &at91sam926x_timer,
+	.map_io		= foxg20_map_io,
+	.init_irq	= foxg20_init_irq,
+	.init_machine	= foxg20_board_init,
+MACHINE_END
-- 
1.7.0.4

