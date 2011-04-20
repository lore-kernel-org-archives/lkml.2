Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1DTSej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:34:39 -0400
Received: from the.earth.li ([46.43.34.31]:54741 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab1DTSef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 14:34:35 -0400
Date: Wed, 20 Apr 2011 11:34:34 -0700
From: Jonathan McDowell <noodles@earth.li>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: Add support for PC8741x SuperIO chip GPIOs
Message-ID: <20110420183433.GV4835@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the GPIOs on the National Semiconductor/Winbond
PC87413/87414/87416/87417 SuperIO LPC family.

These chips feature 51 GPIOs (46 configurable as input or output, 5
output only).

Signed-off-by: Jonathan McDowell <noodles@earth.li>

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 664660e..cc150db 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -81,6 +81,17 @@ config GPIO_IT8761E
 	help
 	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
 
+config GPIO_PC8741X
+	tristate "PC8741x SuperIO GPIO support"
+	depends on GPIOLIB
+	help
+	  Say yes here to support the GPIO functionality of the
+	  PC87413/87414/87416/87417 SuperIO chips. These chips contain a
+	  total of 51 GPIOs.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called pc8741x_gpio.
+
 config GPIO_PL061
 	bool "PrimeCell PL061 GPIO support"
 	depends on ARM_AMBA
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 3351cf8..d2752b2 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
 obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_74X164)	+= 74x164.o
+obj-$(CONFIG_GPIO_PC8741X)	+= pc8741x_gpio.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_PCH)		+= pch_gpio.o
diff --git a/drivers/gpio/pc8741x_gpio.c b/drivers/gpio/pc8741x_gpio.c
new file mode 100644
index 0000000..cea084a
--- /dev/null
+++ b/drivers/gpio/pc8741x_gpio.c
@@ -0,0 +1,271 @@
+/*
+ *  pc8741x_gpio.c - GPIO interface for PC87413/4/6/7 Super I/O chip
+ *
+ *  Copyright 2011 Jonathan McDowell <noodles@earth.li>
+ *
+ *  Based on drivers/gpio/it8761e_gpio.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/errno.h>
+#include <linux/ioport.h>
+
+#include <linux/gpio.h>
+
+#define PC8741X_CHIP_ID		0xEE
+
+#define PC8741X_FUNC_SEL	0x07
+#define PC8741X_SID		0x20
+#define PC8741X_SRID		0x27
+#define PC8741X_FUNC_ENABLE	0x30
+#define PC8741X_BASE_HIGH	0x60
+#define PC8741X_BASE_LOW	0x61
+
+#define PC8741X_GPSEL		0xF0
+#define PC8741X_GPCFG1		0xF1
+#define PC8741X_GPEVR		0xF2
+#define PC8741X_GPCFG2		0xF3
+
+#define PC8741X_FUNC_GPIO	0x07
+
+static u8 ports[2] = { 0x2e, 0x4e };
+static u8 port;
+
+static u8 block_in_offs[6] = { 1, 3, 7, 9, 11, 15 };
+static u8 block_out_offs[7] = { 0, 2, 6, 8, 10, 14, 16 };
+
+static DEFINE_SPINLOCK(pc8741x_sio_lock);
+
+#define GPIO_NAME		"pc8741x-gpio"
+#define GPIO_IOSIZE		17
+
+static u16 gpio_ba;
+
+static int pc8741x_superio_enter(int base)
+{
+	if (!request_muxed_region(base, 2, GPIO_NAME))
+		return -EBUSY;
+
+	return 0;
+}
+
+static void pc8741x_superio_exit(int base)
+{
+	release_region(base, 2);
+}
+
+static u8 pc8741x_read_reg(u8 addr, u8 port)
+{
+	outb(addr, port);
+	return inb(port + 1);
+}
+
+static void pc8741x_write_reg(u8 data, u8 addr, u8 port)
+{
+	outb(addr, port);
+	outb(data, port + 1);
+}
+
+static void pc8741x_select_func(u8 port, u8 func)
+{
+	pc8741x_write_reg(func, PC8741X_FUNC_SEL, port);
+}
+
+static int pc8741x_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
+{
+	u8 block, pin;
+
+	if (gpio_num < 46) {
+		block = gpio_num >> 3;
+		pin = gpio_num & 7;
+	} else {
+		/* Block 6 is output only */
+		return 0;
+	}
+
+	return !!(inb(gpio_ba + block_in_offs[block]) & (1 << pin));
+}
+
+static int pc8741x_gpio_direction_in(struct gpio_chip *gc, unsigned gpio_num)
+{
+	u8 block, pin, cur;
+	int err;
+
+	if (gpio_num < 46) {
+		block = gpio_num >> 3;
+		pin = gpio_num & 7;
+	} else {
+		/* Block 6 is output only */
+		return -EINVAL;
+	}
+
+	err = pc8741x_superio_enter(port);
+	if (err)
+		return err;
+
+	pc8741x_select_func(port, PC8741X_FUNC_GPIO);
+	pc8741x_write_reg(block << 4 & pin, PC8741X_GPSEL, port);
+
+	cur = pc8741x_read_reg(PC8741X_GPCFG1, port);
+
+	if (cur & 1)
+		pc8741x_write_reg(cur & ~1, PC8741X_GPCFG1, port);
+
+	pc8741x_superio_exit(port);
+	return 0;
+}
+
+static void pc8741x_gpio_set(struct gpio_chip *gc,
+				unsigned gpio_num, int val)
+{
+	u8 block, pin, cur;
+
+	if (gpio_num < 46) {
+		block = gpio_num >> 3;
+		pin = gpio_num & 7;
+	} else {
+		block = 6;
+		pin = gpio_num - 46;
+	}
+
+	spin_lock(&pc8741x_sio_lock);
+
+	cur = inb(gpio_ba + block_out_offs[block]);
+
+	if (val)
+		outb(cur | (1 << pin), gpio_ba + block_out_offs[block]);
+	else
+		outb(cur & ~(1 << pin), gpio_ba + block_out_offs[block]);
+
+	spin_unlock(&pc8741x_sio_lock);
+}
+
+static int pc8741x_gpio_direction_out(struct gpio_chip *gc, unsigned gpio_num,
+					int val)
+{
+	u8 block, pin, cur;
+	int err;
+
+	pc8741x_gpio_set(gc, gpio_num, val);
+
+	if (gpio_num < 46) {
+		block = gpio_num >> 3;
+		pin = gpio_num & 7;
+	} else {
+		block = 6;
+		pin = gpio_num - 47;
+	}
+
+	err = pc8741x_superio_enter(port);
+	if (err)
+		return err;
+
+	pc8741x_select_func(port, PC8741X_FUNC_GPIO);
+	pc8741x_write_reg(block << 4 & pin, PC8741X_GPSEL, port);
+
+	cur = pc8741x_read_reg(PC8741X_GPCFG1, port);
+
+	if (!(cur & 1))
+		pc8741x_write_reg(cur | 1, PC8741X_GPCFG1, port);
+
+	pc8741x_superio_exit(port);
+
+	return 0;
+}
+
+static struct gpio_chip pc8741x_gpio_chip = {
+	.label			= GPIO_NAME,
+	.owner			= THIS_MODULE,
+	.get			= pc8741x_gpio_get,
+	.direction_input	= pc8741x_gpio_direction_in,
+	.set			= pc8741x_gpio_set,
+	.direction_output	= pc8741x_gpio_direction_out,
+};
+
+static int __init pc8741x_gpio_init(void)
+{
+	int i, id, err;
+
+	/* chip and port detection */
+	for (i = 0; i < ARRAY_SIZE(ports); i++) {
+		if (!pc8741x_superio_enter(ports[i])) {
+
+			id = pc8741x_read_reg(PC8741X_SID, ports[i]);
+
+			pc8741x_superio_exit(ports[i]);
+
+			if (id == PC8741X_CHIP_ID) {
+				port = ports[i];
+				break;
+			}
+		}
+	}
+
+	if (!port)
+		return -ENODEV;
+
+	err = pc8741x_superio_enter(port);
+	if (err)
+		return err;
+	id = pc8741x_read_reg(PC8741X_SRID, port);
+	printk(KERN_INFO "pc8741x_gpio: Found PC8741x revision %d\n", id);
+
+	/* fetch GPIO base address */
+	pc8741x_select_func(port, PC8741X_FUNC_GPIO);
+	pc8741x_write_reg(1, PC8741X_FUNC_ENABLE, port);
+	gpio_ba = (pc8741x_read_reg(PC8741X_BASE_HIGH, port) << 8) +
+				pc8741x_read_reg(PC8741X_BASE_LOW, port);
+	pc8741x_superio_exit(port);
+
+	if (!request_region(gpio_ba, GPIO_IOSIZE, GPIO_NAME))
+		return -EBUSY;
+
+	pc8741x_gpio_chip.base = -1;
+	pc8741x_gpio_chip.ngpio = 51;
+
+	err = gpiochip_add(&pc8741x_gpio_chip);
+	if (err < 0)
+		goto gpiochip_add_err;
+
+	return 0;
+
+gpiochip_add_err:
+	release_region(gpio_ba, GPIO_IOSIZE);
+	gpio_ba = 0;
+	return err;
+}
+
+static void __exit pc8741x_gpio_exit(void)
+{
+	if (gpio_ba) {
+		int ret = gpiochip_remove(&pc8741x_gpio_chip);
+
+		WARN(ret, "%s(): gpiochip_remove() failed, ret=%d\n",
+				__func__, ret);
+
+		release_region(gpio_ba, GPIO_IOSIZE);
+		gpio_ba = 0;
+	}
+}
+module_init(pc8741x_gpio_init);
+module_exit(pc8741x_gpio_exit);
+
+MODULE_AUTHOR("Jonathan McDowell <noodles@earth.li>");
+MODULE_DESCRIPTION("GPIO interface for PC87413/4/6/7 Super I/O chip");
+MODULE_LICENSE("GPL");
