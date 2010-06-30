Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab0F3QQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:16:24 -0400
Received: from compulab.co.il ([67.18.134.219]:55408 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab0F3QQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:16:22 -0400
Message-ID: <4C2B6E1F.80004@compulab.co.il>
Date: Wed, 30 Jun 2010 19:17:35 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH 2/2] gpio: introduce f71808e_gpio driver for F71808E Super
 I/O chip.
References: <4B8A2F34.3020505@compulab.co.il> <4C2B616F.90803@compulab.co.il>
In-Reply-To: <4C2B616F.90803@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Turischev <denis@compulab.co.il>

---
 drivers/gpio/Kconfig        |    6 +
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/f71808e_gpio.c |  284 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 291 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/f71808e_gpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index f666023..475e846 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -96,6 +96,12 @@ config GPIO_IT8761E
 	help
 	  Say yes here to support GPIO functionality of IT8761E super I/O chip.

+config GPIO_F71808E
+	tristate "F71808E GPIO support"
+	depends on GPIOLIB
+	help
+	  Say yes here to support GPIO functionality of F71808E super I/O chip.
+
 config GPIO_SCH
 	tristate "Intel SCH GPIO"
 	depends on GPIOLIB && PCI
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 51c3cdd..cb4dd30 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -31,3 +31,4 @@ obj-$(CONFIG_GPIO_WM8994)	+= wm8994-gpio.o
 obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
 obj-$(CONFIG_GPIO_RDC321X)	+= rdc321x-gpio.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
+obj-$(CONFIG_GPIO_F71808E)	+= f71808e_gpio.o
diff --git a/drivers/gpio/f71808e_gpio.c b/drivers/gpio/f71808e_gpio.c
new file mode 100644
index 0000000..8ccdd9f
--- /dev/null
+++ b/drivers/gpio/f71808e_gpio.c
@@ -0,0 +1,284 @@
+/*
+ *  f71808e_gpio.c - GPIO interface for f71808E Super I/O chip
+ *
+ *  Author: Denis Turischev <denis@compulab.co.il>
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
+#define GPIO_NAME		"f71808-gpio"
+
+#define CHIP_ID			0x0901
+#define VENDOR_ID		0x3219
+
+#define LDN			0x07
+#define CR_GPIO			0x06
+
+#define CHIP_ID_HIGH_BYTE	0x20
+#define CHIP_ID_LOW_BYTE	0x21
+#define VENDOR_ID_HIGH_BYTE	0x22
+#define VENDOR_ID_LOW_BYTE	0x23
+
+static u8 ports[2] = { 0x2e, 0x4e };
+static u8 port;
+
+static DEFINE_SPINLOCK(sio_lock);
+
+
+static u8 read_reg(u8 addr, u8 port)
+{
+	outb(addr, port);
+	return inb(port + 1);
+}
+
+static void write_reg(u8 data, u8 addr, u8 port)
+{
+	outb(addr, port);
+	outb(data, port + 1);
+}
+
+static void enter_conf_mode(u8 port)
+{
+	outb(0x87, port);
+	outb(0x87, port);
+}
+
+static void exit_conf_mode(u8 port)
+{
+	outb(0xaa, port);
+}
+
+static void enter_gpio_mode(u8 port)
+{
+	write_reg(CR_GPIO, LDN, port);
+}
+
+static int f71808e_gpio_rename(unsigned gpio_num)
+{
+	/* [0-7] -> [0-7] */
+	if (gpio_num <= 7)
+		return gpio_num;
+
+	/*  [8-12] -> [10-14]*/
+	if (gpio_num <= 12)
+		return gpio_num + 2;
+
+	/* [13-20] -> [20-27] */
+	if (gpio_num <= 20)
+		return gpio_num + 7;
+
+	/* [21-25] -> [30-34] */
+	return gpio_num + 9;
+}
+
+static int f71808e_gpio_direction_in(struct gpio_chip *gc, unsigned _gpio_num)
+{
+	unsigned gpio_num;
+	u8 curr_vals, reg, bit;
+
+	gpio_num = f71808e_gpio_rename(_gpio_num);
+
+	bit = gpio_num % 10;
+	reg = 0xf0 - (gpio_num / 10) * 0x10;
+
+	spin_lock(&sio_lock);
+
+	enter_conf_mode(port);
+	enter_gpio_mode(port);
+
+	curr_vals = read_reg(reg, port);
+
+	if (curr_vals & (1 << bit))
+		write_reg(curr_vals & ~(1 << bit), reg, port);
+
+	exit_conf_mode(port);
+
+	spin_unlock(&sio_lock);
+
+	return 0;
+}
+
+static int f71808e_gpio_direction_out(struct gpio_chip *gc,
+					unsigned _gpio_num, int val)
+{
+	unsigned gpio_num;
+	u8 curr_vals, reg, bit;
+
+	gpio_num = f71808e_gpio_rename(_gpio_num);
+
+	bit = gpio_num % 10;
+	reg = 0xf0 - (gpio_num / 10) * 0x10;
+
+	spin_lock(&sio_lock);
+
+	enter_conf_mode(port);
+	enter_gpio_mode(port);
+
+	curr_vals = read_reg(reg, port);
+
+	if (!(curr_vals & (1 << bit)))
+		write_reg(curr_vals | (1 << bit), reg, port);
+
+	exit_conf_mode(port);
+
+	spin_unlock(&sio_lock);
+	return 0;
+}
+
+static int f71808e_gpio_get(struct gpio_chip *gc, unsigned _gpio_num)
+{
+	unsigned gpio_num, res;
+	u8 reg, bit;
+
+	gpio_num = f71808e_gpio_rename(_gpio_num);
+
+	bit = gpio_num % 10;
+	reg = 0xf2 - (gpio_num / 10) * 0x10;
+
+	spin_lock(&sio_lock);
+
+	enter_conf_mode(port);
+	enter_gpio_mode(port);
+
+	res = !!(read_reg(reg, port) & (1 << bit));
+
+	exit_conf_mode(port);
+
+	spin_unlock(&sio_lock);
+
+	return res;
+}
+
+static void f71808e_gpio_set(struct gpio_chip *gc,
+				unsigned _gpio_num, int val)
+{
+	unsigned gpio_num;
+	u8 curr_vals, reg, bit;
+
+	gpio_num = f71808e_gpio_rename(_gpio_num);
+
+	bit = gpio_num % 10;
+	reg = 0xf1 - (gpio_num / 10) * 0x10;
+
+	spin_lock(&sio_lock);
+
+	enter_conf_mode(port);
+	enter_gpio_mode(port);
+
+	curr_vals = read_reg(reg, port);
+
+	if (val)
+		write_reg(curr_vals | (1 << bit), reg, port);
+	else
+		write_reg(curr_vals & ~(1 << bit), reg, port);
+
+	exit_conf_mode(port);
+
+	spin_unlock(&sio_lock);
+}
+
+static struct gpio_chip f71808e_gpio_chip = {
+	.label			= GPIO_NAME,
+	.owner			= THIS_MODULE,
+	.get			= f71808e_gpio_get,
+	.direction_input	= f71808e_gpio_direction_in,
+	.set			= f71808e_gpio_set,
+	.direction_output	= f71808e_gpio_direction_out,
+};
+
+static int __init f71808e_gpio_init(void)
+{
+	int i, chip_id, vendor_id, err;
+	u8 io_reg, curr_vals;
+
+	/* chip and port detection */
+	for (i = 0; i < ARRAY_SIZE(ports); i++) {
+		spin_lock(&sio_lock);
+		enter_conf_mode(ports[i]);
+
+		chip_id = (read_reg(CHIP_ID_HIGH_BYTE, ports[i]) << 8) +
+				read_reg(CHIP_ID_LOW_BYTE, ports[i]);
+
+		vendor_id = (read_reg(VENDOR_ID_HIGH_BYTE, ports[i]) << 8) +
+				read_reg(VENDOR_ID_LOW_BYTE, ports[i]);
+
+		exit_conf_mode(ports[i]);
+		spin_unlock(&sio_lock);
+
+		if ((chip_id == CHIP_ID) && (vendor_id == VENDOR_ID)) {
+			port = ports[i];
+			break;
+		}
+	}
+
+	if (!port)
+		return -ENODEV;
+
+	/* Enable all pins with GPIO capability */
+	/* By default we enable all possible GPIOs on the chip */
+	spin_lock(&sio_lock);
+	enter_conf_mode(port);
+
+	/* Enable GPIO30 and GPIO31 */
+	io_reg = 0x27;
+	curr_vals = read_reg(io_reg, port);
+	write_reg(curr_vals & 0xfe, io_reg, port);
+
+	/* Enable GPIO[0-7], GPIO30, GPIO31, GPIO34 */
+	io_reg = 0x29;
+	write_reg(0xff, io_reg, port);
+
+	/* Enable GPIO[10-14], GPIO21, GPIO23 */
+	io_reg = 0x2a;
+	write_reg(0x13, io_reg, port);
+
+	/* Enable GPIO[20-27] */
+	io_reg = 0x2b;
+	write_reg(0xff, io_reg, port);
+
+	exit_conf_mode(port);
+	spin_unlock(&sio_lock);
+
+	f71808e_gpio_chip.base = -1;
+	f71808e_gpio_chip.ngpio = 26;
+
+	err = gpiochip_add(&f71808e_gpio_chip);
+	if (err < 0)
+		goto gpiochip_add_err;
+
+	return 0;
+
+gpiochip_add_err:
+	return err;
+}
+
+static void __exit f71808e_gpio_exit(void)
+{
+	gpiochip_remove(&f71808e_gpio_chip);
+}
+module_init(f71808e_gpio_init);
+module_exit(f71808e_gpio_exit);
+
+MODULE_AUTHOR("Denis Turischev <denis@compulab.co.il>");
+MODULE_DESCRIPTION("GPIO interface for F71808E Super I/O chip");
+MODULE_LICENSE("GPL");
-- 
1.7.0.4
