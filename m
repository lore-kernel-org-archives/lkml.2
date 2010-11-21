Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab0KWEzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 23:55:46 -0500
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:43384 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017Ab0KWEzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 23:55:45 -0500
From: "Ash Hughes" <ashley.hughes@blueyonder.co.uk>
To: <nico@fluxnic.net>, <kernel@wantstofly.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] ARM Orion: added Buffalo LS-CHL support
Date: Sun, 21 Nov 2010 23:05:10 -0000
Message-ID: <000401cb89d0$8d1927b0$a74b7710$@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcuJ0BP5IjBbsT29RxqMJEp1701Nlg==
Content-Language: en-gb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for Buffalo Linkstation Live v3 (LS-CHL) NAS drives.
Signed-off-by: Ash Hughes <ashley.hughes@blueyonder.co.uk>

---


diff -uprN linux-2.6-vanilla//arch/arm/mach-orion5x/Kconfig linux-2.6/arch/arm/mach-orion5x/Kconfig
--- linux-2.6-vanilla//arch/arm/mach-orion5x/Kconfig	2010-11-14 10:58:39.000000000 +0000
+++ linux-2.6/arch/arm/mach-orion5x/Kconfig	2010-11-14 11:02:42.874582000 +0000
@@ -51,6 +51,13 @@ config MACH_LINKSTATION_PRO
 	  Buffalo Linkstation Pro/Live platform. Both v1 and
 	  v2 devices are supported.
 
+config MACH_LINKSTATION_LSCHL
+	bool "Buffalo Linkstation Live v3 (LS-CHL)"
+	select I2C_BOARDINFO
+	help
+	  Say 'Y' here if you want your kernel to support the
+	  Buffalo Linkstation Live v3 (LS-CHL) platform.
+
 config MACH_LINKSTATION_MINI
 	bool "Buffalo Linkstation Mini"
 	select I2C_BOARDINFO
diff -uprN linux-2.6-vanilla//arch/arm/mach-orion5x/ls-chl-setup.c linux-2.6/arch/arm/mach-orion5x/ls-chl-setup.c
--- linux-2.6-vanilla//arch/arm/mach-orion5x/ls-chl-setup.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6/arch/arm/mach-orion5x/ls-chl-setup.c	2010-11-21 15:33:43.910827481 +0000
@@ -0,0 +1,329 @@
+/*
+ * arch/arm/mach-orion5x/ls-chl-setup.c
+ *
+ * Maintainer: Ash Hughes <ashley.hughes@blueyonder.co.uk>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/physmap.h>
+#include <linux/mv643xx_eth.h>
+#include <linux/leds.h>
+#include <linux/gpio_keys.h>
+#include <linux/gpio-fan.h>
+#include <linux/input.h>
+#include <linux/i2c.h>
+#include <linux/ata_platform.h>
+#include <linux/gpio.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/system.h>
+#include <mach/orion5x.h>
+#include "common.h"
+#include "mpp.h"
+
+/*****************************************************************************
+ * Linkstation LS-CHL Info
+ ****************************************************************************/
+
+/*
+ * 256K NOR flash Device bus boot chip select
+ */
+
+#define LSCHL_NOR_BOOT_BASE	0xf4000000
+#define LSCHL_NOR_BOOT_SIZE	SZ_256K
+
+/*****************************************************************************
+ * 256KB NOR Flash on BOOT Device
+ ****************************************************************************/
+
+static struct physmap_flash_data lschl_nor_flash_data = {
+	.width		= 1,
+};
+
+static struct resource lschl_nor_flash_resource = {
+	.flags	= IORESOURCE_MEM,
+	.start	= LSCHL_NOR_BOOT_BASE,
+	.end	= LSCHL_NOR_BOOT_BASE + LSCHL_NOR_BOOT_SIZE - 1,
+};
+
+static struct platform_device lschl_nor_flash = {
+	.name			= "physmap-flash",
+	.id			= 0,
+	.dev		= {
+		.platform_data	= &lschl_nor_flash_data,
+	},
+	.num_resources		= 1,
+	.resource		= &lschl_nor_flash_resource,
+};
+
+/*****************************************************************************
+ * Ethernet
+ ****************************************************************************/
+
+static struct mv643xx_eth_platform_data lschl_eth_data = {
+	.phy_addr	= MV643XX_ETH_PHY_ADDR(8),
+};
+
+/*****************************************************************************
+ * RTC 5C372a on I2C bus
+ ****************************************************************************/
+
+static struct i2c_board_info __initdata lschl_i2c_rtc = {
+	I2C_BOARD_INFO("rs5c372a", 0x32),
+};
+
+/*****************************************************************************
+ * LEDs attached to GPIO
+ ****************************************************************************/
+
+#define LSCHL_GPIO_LED_ALARM	2
+#define LSCHL_GPIO_LED_INFO	3
+#define LSCHL_GPIO_LED_FUNC	17
+#define LSCHL_GPIO_LED_PWR	0
+
+static struct gpio_led lschl_led_pins[] = {
+	{
+		.name	   = "alarm:red",
+		.gpio	   = LSCHL_GPIO_LED_ALARM,
+		.active_low     = 1,
+	}, {
+		.name	   = "info:amber",
+		.gpio	   = LSCHL_GPIO_LED_INFO,
+		.active_low     = 1,
+	}, {
+		.name	   = "func:blue:top",
+		.gpio	   = LSCHL_GPIO_LED_FUNC,
+		.active_low     = 1,
+	}, {
+		.name	   = "power:blue:bottom",
+		.gpio	   = LSCHL_GPIO_LED_PWR,
+	},
+};
+
+static struct gpio_led_platform_data lschl_led_data = {
+	.leds	   = lschl_led_pins,
+	.num_leds       = ARRAY_SIZE(lschl_led_pins),
+};
+
+static struct platform_device lschl_leds = {
+	.name   = "leds-gpio",
+	.id     = -1,
+	.dev    = {
+		.platform_data  = &lschl_led_data,
+	},
+};
+
+/*****************************************************************************
+ * SATA
+ ****************************************************************************/
+static struct mv_sata_platform_data lschl_sata_data = {
+	.n_ports	= 2,
+};
+
+/*****************************************************************************
+ * LS-CHL specific power off method: reboot
+ ****************************************************************************/
+/*
+ * On the LS-CHL, the shutdown process is following:
+ * - Userland monitors key events until the power switch goes to off position
+ * - The board reboots
+ * - U-boot starts and goes into an idle mode waiting for the user
+ *   to move the switch to ON position
+ *
+ */
+
+static void lschl_power_off(void)
+{
+	arm_machine_restart('h', NULL);
+}
+
+/*****************************************************************************
+ * General Setup
+ ****************************************************************************/
+#define LSCHL_GPIO_USB_POWER	9
+#define LSCHL_GPIO_AUTO_POWER	17
+#define LSCHL_GPIO_POWER	18
+
+/****************************************************************************
+ * GPIO Attached Keys
+ ****************************************************************************/
+#define LSCHL_GPIO_KEY_FUNC		15
+#define LSCHL_GPIO_KEY_POWER		8
+#define LSCHL_GPIO_KEY_AUTOPOWER	10
+#define LSCHL_SW_POWER		0x00
+#define LSCHL_SW_AUTOPOWER	0x01
+#define LSCHL_SW_FUNC		0x02
+
+static struct gpio_keys_button lschl_buttons[] = {
+	{
+		.type		= EV_SW,
+		.code	   = LSCHL_SW_POWER,
+		.gpio	   = LSCHL_GPIO_KEY_POWER,
+		.desc	   = "Power-on Switch",
+		.active_low     = 1,
+	}, {
+		.type		= EV_SW,
+		.code	   = LSCHL_SW_AUTOPOWER,
+		.gpio	   = LSCHL_GPIO_KEY_AUTOPOWER,
+		.desc	   = "Power-auto Switch",
+		.active_low     = 1,
+	}, {
+		.type		= EV_SW,
+		.code	   = LSCHL_SW_FUNC,
+		.gpio	   = LSCHL_GPIO_KEY_FUNC,
+		.desc	   = "Function Switch",
+		.active_low     = 1,
+	},
+};
+
+static struct gpio_keys_platform_data lschl_button_data = {
+	.buttons	= lschl_buttons,
+	.nbuttons       = ARRAY_SIZE(lschl_buttons),
+};
+
+static struct platform_device lschl_button_device = {
+	.name		= "gpio-keys",
+	.id		= -1,
+	.num_resources	= 0,
+	.dev		= {
+		.platform_data  = &lschl_button_data,
+	},
+};
+
+#define LSCHL_GPIO_HDD_POWER	1
+
+/****************************************************************************
+ * GPIO Fan
+ ****************************************************************************/
+
+#define LSCHL_GPIO_FAN_LOW	16
+#define LSCHL_GPIO_FAN_HIGH	14
+#define LSCHL_GPIO_FAN_LOCK	6
+
+static struct gpio_fan_alarm lschl_alarm = {
+	.gpio = LSCHL_GPIO_FAN_LOCK,
+	.active_low = 0,
+};
+
+static struct gpio_fan_speed lschl_speeds[] = {
+	{
+		.rpm = 0,
+		.ctrl_val = 3,
+	}, {
+		.rpm = 1,
+		.ctrl_val = 2,
+	}, {
+		.rpm = 2,
+		.ctrl_val = 1,
+	}, {
+		.rpm = 3,
+		.ctrl_val = 0,
+	},
+};
+
+static int lschl_gpio_list[] = {
+	LSCHL_GPIO_FAN_HIGH, LSCHL_GPIO_FAN_LOW,
+};
+
+static struct gpio_fan_platform_data lschl_fan_data = {
+	.num_ctrl = 2,
+	.ctrl = lschl_gpio_list,
+	.alarm = &lschl_alarm,
+	.num_speed = 4,
+	.speed = lschl_speeds,
+};
+
+static struct platform_device lschl_fan_device = {
+	.name		= "gpio-fan",
+	.id		= -1,
+	.num_resources	= 0,
+	.dev		= {
+		.platform_data  = &lschl_fan_data,
+	},
+};
+
+/****************************************************************************
+ * GPIO Data
+ ****************************************************************************/
+
+static struct orion5x_mpp_mode lschl_mpp_modes[] __initdata = {
+	{  0, MPP_GPIO }, /* LED POWER */
+	{  1, MPP_GPIO }, /* HDD POWER */
+	{  2, MPP_GPIO }, /* LED ALARM */
+	{  3, MPP_GPIO }, /* LED INFO */
+	{  4, MPP_UNUSED },
+	{  5, MPP_UNUSED },
+	{  6, MPP_GPIO }, /* FAN LOCK */
+	{  7, MPP_GPIO }, /* SW INIT */
+	{  8, MPP_GPIO }, /* SW POWER */
+	{  9, MPP_GPIO }, /* USB POWER */
+	{ 10, MPP_GPIO }, /* SW AUTO POWER */
+	{ 11, MPP_UNUSED },
+	{ 12, MPP_UNUSED },
+	{ 13, MPP_UNUSED },
+	{ 14, MPP_GPIO }, /* FAN HIGH */
+	{ 15, MPP_GPIO }, /* SW FUNC */
+	{ 16, MPP_GPIO }, /* FAN LOW */
+	{ 17, MPP_GPIO }, /* LED FUNC */
+	{ 18, MPP_UNUSED },
+	{ 19, MPP_UNUSED },
+	{ -1 },
+};
+
+static void __init lschl_init(void)
+{
+	/*
+	 * Setup basic Orion functions. Needs to be called early.
+	 */
+	orion5x_init();
+
+	orion5x_mpp_conf(lschl_mpp_modes);
+
+	/*
+	 * Configure peripherals.
+	 */
+	orion5x_ehci0_init();
+	orion5x_ehci1_init();
+	orion5x_eth_init(&lschl_eth_data);
+	orion5x_i2c_init();
+	orion5x_sata_init(&lschl_sata_data);
+	orion5x_uart0_init();
+	orion5x_xor_init();
+
+	orion5x_setup_dev_boot_win(LSCHL_NOR_BOOT_BASE,
+				   LSCHL_NOR_BOOT_SIZE);
+	platform_device_register(&lschl_nor_flash);
+
+	platform_device_register(&lschl_leds);
+
+	platform_device_register(&lschl_button_device);
+
+	platform_device_register(&lschl_fan_device);
+
+	i2c_register_board_info(0, &lschl_i2c_rtc, 1);
+
+	/* usb power on */
+	gpio_set_value(LSCHL_GPIO_USB_POWER, 1);
+
+	/* register power-off method */
+	pm_power_off = lschl_power_off;
+
+	pr_info("%s: finished\n", __func__);
+}
+
+MACHINE_START(LINKSTATION_LSCHL, "Buffalo Linkstation LiveV3 (LS-CHL)")
+	/* Maintainer: Ash Hughes <ashley.hughes@blueyonder.co.uk> */
+	.boot_params	= 0x00000100,
+	.init_machine	= lschl_init,
+	.map_io		= orion5x_map_io,
+	.init_irq	= orion5x_init_irq,
+	.timer		= &orion5x_timer,
+	.fixup		= tag_fixup_mem32,
+MACHINE_END
+
diff -uprN linux-2.6-vanilla//arch/arm/mach-orion5x/Makefile linux-2.6/arch/arm/mach-orion5x/Makefile
--- linux-2.6-vanilla//arch/arm/mach-orion5x/Makefile	2010-11-14 10:58:39.000000000 +0000
+++ linux-2.6/arch/arm/mach-orion5x/Makefile	2010-11-14 11:03:34.444582001 +0000
@@ -21,3 +21,4 @@ obj-$(CONFIG_MACH_WNR854T)	+= wnr854t-se
 obj-$(CONFIG_MACH_RD88F5181L_GE)	+= rd88f5181l-ge-setup.o
 obj-$(CONFIG_MACH_RD88F5181L_FXO)	+= rd88f5181l-fxo-setup.o
 obj-$(CONFIG_MACH_RD88F6183AP_GE)	+= rd88f6183ap-ge-setup.o
+obj-$(CONFIG_MACH_LINKSTATION_LSCHL)   += ls-chl-setup.o

