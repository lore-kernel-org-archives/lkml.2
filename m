Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab0IXSHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:07:04 -0400
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:38696 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669Ab0IXSHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:07:01 -0400
From: "Ash Hughes" <ashley.hughes@blueyonder.co.uk>
To: <kernel@wantstofly.org>, <nico@fluxnic.net>, <linux@arm.linux.org.uk>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] ARM Orion: added Buffalo LS-CHL support
Date: Fri, 24 Sep 2010 19:06:46 +0100
Message-ID: <000001cb5c13$41f1f0e0$c5d5d2a0$@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: ActcEr/4HrfU7J0oStGCKwEbGiRboA==
Content-Language: en-gb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ash Hughes <ashley.hughes@blueyonder.co.uk>
Adds support for Buffalo Linkstation Live v3 (LS-CHL) NAS drives.
Signed-off-by: Ash Hughes <ashley.hughes@blueyonder.co.uk>

---

Code has been in use for several months:
http://forum.buffalo.nas-central.org/viewtopic.php?f=18&t=13566

diff -urBN linux-2.6.34-vanilla/arch/arm/mach-orion5x/Kconfig linux-2.6.34/arch/arm/mach-orion5x/Kconfig
--- linux-2.6.34-vanilla/arch/arm/mach-orion5x/Kconfig	2010-05-16 22:17:36.000000000 +0100
+++ linux-2.6.34/arch/arm/mach-orion5x/Kconfig	2010-06-11 13:46:45.665614309 +0100
@@ -50,6 +50,13 @@
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
diff -urBN linux-2.6.34-vanilla/arch/arm/mach-orion5x/ls-chl-setup.c
linux-2.6.34/arch/arm/mach-orion5x/ls-chl-setup.c
--- linux-2.6.34-vanilla/arch/arm/mach-orion5x/ls-chl-setup.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.34/arch/arm/mach-orion5x/ls-chl-setup.c	2010-09-24 03:56:24.432077623 +0100
@@ -0,0 +1,449 @@
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
+#include <linux/proc_fs.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/pci.h>
+#include <linux/irq.h>
+#include <linux/delay.h>
+#include <linux/mtd/physmap.h>
+#include <linux/mv643xx_eth.h>
+#include <linux/leds.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
+#include <linux/i2c.h>
+#include <linux/serial_reg.h>
+#include <linux/ata_platform.h>
+#include <asm/mach-types.h>
+#include <asm/gpio.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/pci.h>
+#include "common.h"
+#include "mpp.h"
+#include "include/mach/system.h"
+#include <asm/uaccess.h>
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
+	.phy_addr	= 8,
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
+	arch_reset(0, NULL);
+}
+
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
+	.name	   = "gpio-keys",
+	.id	     = -1,
+	.num_resources  = 0,
+	.dev	    = {
+		.platform_data  = &lschl_button_data,
+	},
+};
+
+#define LSCHL_GPIO_HDD_POWER	1
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
+
+#define LSCHL_GPIO_FAN_LOW	16
+#define LSCHL_GPIO_FAN_HIGH	14
+#define LSCHL_GPIO_FAN_LOCK	6
+
+#define BUFFALO_GPIO_FAN_STOP	0
+#define BUFFALO_GPIO_FAN_SLOW	1
+#define BUFFALO_GPIO_FAN_FAST	2
+#define BUFFALO_GPIO_FAN_FULL	3
+
+#define BuffaloGpio_FanStop()	FanControlWrite(BUFFALO_GPIO_FAN_STOP)
+#define BuffaloGpio_FanSlow()	FanControlWrite(BUFFALO_GPIO_FAN_SLOW)
+#define BuffaloGpio_FanFast()	FanControlWrite(BUFFALO_GPIO_FAN_FAST)
+#define BuffaloGpio_FanFull()	FanControlWrite(BUFFALO_GPIO_FAN_FULL)
+
+
+void
+FanControlWrite(unsigned int value)
+{
+	switch (value) {
+	case BUFFALO_GPIO_FAN_STOP:
+		gpio_set_value(LSCHL_GPIO_FAN_LOW, 1);
+		gpio_set_value(LSCHL_GPIO_FAN_HIGH, 1);
+		break;
+	case BUFFALO_GPIO_FAN_SLOW:
+		gpio_set_value(LSCHL_GPIO_FAN_LOW, 1);
+		gpio_set_value(LSCHL_GPIO_FAN_HIGH, 0);
+		break;
+	case BUFFALO_GPIO_FAN_FAST:
+		gpio_set_value(LSCHL_GPIO_FAN_LOW, 0);
+		gpio_set_value(LSCHL_GPIO_FAN_HIGH, 1);
+		break;
+	case BUFFALO_GPIO_FAN_FULL:
+		gpio_set_value(LSCHL_GPIO_FAN_LOW, 0);
+		gpio_set_value(LSCHL_GPIO_FAN_HIGH, 0);
+		break;
+	default:
+		break;
+	} /* end of switch */
+}
+
+unsigned int
+BuffaloGpio_FanControlRead(void)
+{
+
+	int fan_low = gpio_get_value(LSCHL_GPIO_FAN_LOW);
+	int fan_high = gpio_get_value(LSCHL_GPIO_FAN_HIGH);
+
+	if (!fan_low && !fan_high)
+		return BUFFALO_GPIO_FAN_FULL;
+	else if (!fan_low && fan_high)
+		return BUFFALO_GPIO_FAN_FAST;
+	else if (fan_low && !fan_high)
+		return BUFFALO_GPIO_FAN_SLOW;
+	else if (fan_low && fan_high)
+		return BUFFALO_GPIO_FAN_STOP;
+	return 0;
+}
+
+static int
+FanStatusRead(char *pg, char **st, off_t off, int length, int *eof, void *data)
+{
+
+	int len = 0;
+	off_t begin = 0;
+
+	int PinStat = gpio_get_value(LSCHL_GPIO_FAN_LOCK);
+
+	if (!PinStat)
+		len = sprintf(pg, "Fine\n");
+	else
+		len = sprintf(pg, "Stop\n");
+	*st = pg + (off - begin);
+	len -= (off - begin);
+	if (len > length)
+		len = length;
+	return len;
+}
+
+
+
+static int
+FanStatusWrite(struct file *fp, const char *buf, unsigned long cnt, void *d) {
+	return cnt;
+}
+
+static int
+FanCtlWrite(struct file *filep, const char *buf, unsigned long cnt, void *data)
+{
+	int len, ret;
+	char *ptr, tState[8];
+
+	if (cnt > 8)
+		len = 8;
+	else
+		len = cnt;
+
+	ret = copy_from_user(tState, buf, len);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: Setting fan speed failed\n", "ls-chl");
+		return -EFAULT;
+	}
+
+	ptr = strrchr(tState, '\n');
+	if (ptr)
+		*ptr = '\0';
+
+	if (strncmp(tState, "stop", strlen("stop")) == 0)
+		BuffaloGpio_FanStop();
+	else if (strncmp(tState, "slow", strlen("slow")) == 0)
+		BuffaloGpio_FanSlow();
+	else if (strncmp(tState, "fast", strlen("fast")) == 0)
+		BuffaloGpio_FanFast();
+	else if (strncmp(tState, "full", strlen("full")) == 0)
+		BuffaloGpio_FanFull();
+	return cnt;
+}
+
+static int
+FanCtlRead(char *pg, char **start, off_t off, int length, int *eof, void *data)
+{
+	int len = 0;
+	off_t begin = 0;
+
+	unsigned int fan_status = BuffaloGpio_FanControlRead();
+
+	switch (fan_status) {
+	case BUFFALO_GPIO_FAN_STOP:
+		len += sprintf(pg, "stop\n");
+		break;
+	case BUFFALO_GPIO_FAN_SLOW:
+		len += sprintf(pg, "slow\n");
+		break;
+	case BUFFALO_GPIO_FAN_FAST:
+		len += sprintf(pg, "fast\n");
+		break;
+	case BUFFALO_GPIO_FAN_FULL:
+		len += sprintf(pg, "full\n");
+		break;
+	default:
+		break;
+	} /* end of switch */
+
+	*start = pg + (off - begin);
+	len -= (off - begin);
+	if (len > length)
+		len = length;
+	return len;
+}
+
+
+
+
+static void __init lschl_init(void)
+{
+	/*
+	 * Setup basic Orion functions. Need to be called early.
+	 */
+	struct proc_dir_entry *pde;
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
+	i2c_register_board_info(0, &lschl_i2c_rtc, 1);
+
+	pde = proc_mkdir("buffalo", 0);
+	pde = proc_mkdir("buffalo/gpio", 0);
+	pde = proc_mkdir("buffalo/gpio/fan", 0);
+	pde = create_proc_entry("buffalo/gpio/fan/control", 0644, 0);
+	pde->read_proc = FanCtlRead;
+	pde->write_proc = FanCtlWrite;
+	pde = create_proc_entry("buffalo/gpio/fan/lock", 0, 0);
+	pde->read_proc = FanStatusRead;
+	pde->write_proc = FanStatusWrite;
+
+	/* slow down fan */
+	BuffaloGpio_FanSlow();
+	/* usb power on */
+	gpio_set_value(LSCHL_GPIO_USB_POWER, 1);
+
+	/* register power-off method */
+	pm_power_off = lschl_power_off;
+
+	pr_info("%s: finished\n", __func__);
+}
+
+#ifdef CONFIG_MACH_LINKSTATION_LSCHL
+MACHINE_START(LINKSTATION_LSCHL, "Buffalo Linkstation LiveV3 (LS-CHL)")
+	/* Maintainer: Ash Hughes <ashley.hughes@blueyonder.co.uk> */
+	.phys_io	= ORION5X_REGS_PHYS_BASE,
+	.io_pg_offst	= ((ORION5X_REGS_VIRT_BASE) >> 18) & 0xFFFC,
+	.boot_params	= 0x00000100,
+	.init_machine	= lschl_init,
+	.map_io		= orion5x_map_io,
+	.init_irq	= orion5x_init_irq,
+	.timer		= &orion5x_timer,
+	.fixup		= tag_fixup_mem32,
+MACHINE_END
+#endif
diff -urBN linux-2.6.34-vanilla/arch/arm/mach-orion5x/Makefile linux-2.6.34/arch/arm/mach-orion5x/Makefile
--- linux-2.6.34-vanilla/arch/arm/mach-orion5x/Makefile	2010-05-16 22:17:36.000000000 +0100
+++ linux-2.6.34/arch/arm/mach-orion5x/Makefile	2010-08-18 12:33:02.714982012 +0100
@@ -21,3 +21,4 @@
 obj-$(CONFIG_MACH_RD88F5181L_GE)	+= rd88f5181l-ge-setup.o
 obj-$(CONFIG_MACH_RD88F5181L_FXO)	+= rd88f5181l-fxo-setup.o
 obj-$(CONFIG_MACH_RD88F6183AP_GE)	+= rd88f6183ap-ge-setup.o
+obj-$(CONFIG_MACH_LINKSTATION_LSCHL)   += ls-chl-setup.o


