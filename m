Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965003Ab2CPTqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:46:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41028 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342Ab2CPTqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:46:14 -0400
From: =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.eu>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.eu>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] gpio: add support for ITE IT87xx Super I/O GPIO.
Date: Fri, 16 Mar 2012 20:48:13 +0100
Message-Id: <1331927293-17911-1-git-send-email-flameeyes@flameeyes.eu>
X-Mailer: git-send-email 1.7.8.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is currently written for IT8728, but the code in it87_wdt
suggest it would work the same way on many other versions.

This is just a first step to verify the working status of the code,
and might require moving to a MFD approach to share with hwmon/it87
and it87_wdt, as they all share the same access to the Super I/O chip.
That would also allow to set a few more opitons so that you could for
instance change the function selection of a few pins from their
default to GPIO pins.

It does not yet support the polarity-inversion register that is
allowed by the chipset, which might require sysfs attributes per-gpio.

CC: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Diego Elio Pettenò <flameeyes@flameeyes.eu>
---
 MAINTAINERS              |    5 +
 drivers/gpio/Kconfig     |   11 ++
 drivers/gpio/Makefile    |    1 +
 drivers/gpio/gpio-it87.c |  397 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 414 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-it87.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 553ac10..a196f14 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3692,6 +3692,11 @@ S:	Maintained
 F:	Documentation/hwmon/it87
 F:	drivers/hwmon/it87.c
 
+IT87xx GPIO DRIVER
+M:	Diego Elio Pettenò <flameeyes@flameeyes.eu>
+S:	Maintained
+F:	drivers/gpio/gpio-it87.c
+
 IVTV VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
 L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 3359f1e..8dc26b7 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -91,6 +91,17 @@ config GPIO_IT8761E
 	help
 	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
 
+config GPIO_IT87
+	tristate "IT87xx GPIO support"
+	depends on X86 # unconditional access to IO space.
+	help
+	  Say yes here to support GPIO functionality of IT87xx Super I/O chips.
+
+	  This driver currently supports ITE IT8728 Super I/O chips.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called gpio_it87
+
 config GPIO_EP93XX
 	def_bool y
 	depends on ARCH_EP93XX
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 41fe67f..affe510 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_ARCH_DAVINCI)	+= gpio-davinci.o
 obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
 obj-$(CONFIG_GPIO_ICH)		+= gpio-ich.o
 obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
+obj-$(CONFIG_GPIO_IT87)		+= gpio-it87.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
 obj-$(CONFIG_ARCH_KS8695)	+= gpio-ks8695.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= gpio-langwell.o
diff --git a/drivers/gpio/gpio-it87.c b/drivers/gpio/gpio-it87.c
new file mode 100644
index 0000000..958c126
--- /dev/null
+++ b/drivers/gpio/gpio-it87.c
@@ -0,0 +1,397 @@
+/*
+ *  GPIO interface for IT87xx Super I/O chips
+ *
+ *  Author: Diego Elio Pettenò <flameeyes@flameeyes.eu>
+ *
+ *  Based on it87_wdt.c     by Oliver Schuster
+ *           gpio-it8761e.c by Denis Turischev
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
+#define GPIO_NAME "it87-gpio"
+#define PFX GPIO_NAME ": "
+
+/* Chip Id numbers */
+#define NO_DEV_ID	0xffff
+#define IT8728_ID	0x8728
+
+/* IO Ports */
+#define REG		0x2e
+#define VAL		0x2f
+
+/* Logical device Numbers LDN */
+#define GPIO		0x07
+
+/* Configuration Registers and Functions */
+#define LDNREG		0x07
+#define CHIPID		0x20
+#define CHIPREV		0x22
+
+/* GPIO Simple I/O Base Address registers */
+#define GPIO_BASE	0x62
+#define GPIO_IOSIZE	8
+
+/* GPIO polarity inverting registers base */
+#define GPIO_PS_BASE	0xb0 /* to 0xb4 */
+/* Simple I/O Enable registers base */
+#define GPIO_SE_BASE	0xc0 /* to 0xc4 */
+#define GPIO_SE_SIZE	5
+/* Output Enable registers base */
+#define GPIO_OE_BASE	0xc8 /* to 0xcf */
+
+/* Superio Chip */
+
+static inline int superio_enter(void)
+{
+	/*
+	 * Try to reserve REG and REG + 1 for exclusive access.
+	 */
+	if (!request_muxed_region(REG, 2, GPIO_NAME))
+		return -EBUSY;
+
+	outb(0x87, REG);
+	outb(0x01, REG);
+	outb(0x55, REG);
+	outb(0x55, REG);
+	return 0;
+}
+
+static inline void superio_exit(void)
+{
+	outb(0x02, REG);
+	outb(0x02, VAL);
+	release_region(REG, 2);
+}
+
+static inline void superio_select(int ldn)
+{
+	outb(LDNREG, REG);
+	outb(ldn, VAL);
+}
+
+static inline int superio_inb(int reg)
+{
+	outb(reg, REG);
+	return inb(VAL);
+}
+
+static inline void superio_outb(int val, int reg)
+{
+	outb(reg, REG);
+	outb(val, VAL);
+}
+
+static inline int superio_inw(int reg)
+{
+	int val;
+	outb(reg++, REG);
+	val = inb(VAL) << 8;
+	outb(reg, REG);
+	val |= inb(VAL);
+	return val;
+}
+
+static inline void superio_outw(int val, int reg)
+{
+	outb(reg++, REG);
+	outb(val >> 8, VAL);
+	outb(reg, REG);
+	outb(val, VAL);
+}
+
+static inline void superio_set_bit(int bit, int reg)
+{
+	u8 curr_val = superio_inb(reg);
+	u8 new_val = curr_val | 1 << bit;
+
+	if (curr_val != new_val)
+		superio_outb(new_val, reg);
+}
+
+static inline void superio_clear_bit(int bit, int reg)
+{
+	u8 curr_val = superio_inb(reg);
+	u8 new_val = curr_val & ~(1 << bit);
+
+	if (curr_val != new_val)
+		superio_outb(new_val, reg);
+}
+
+static u16 gpio_ba;
+
+static int it87_gpio_request(struct gpio_chip *gc, unsigned gpio_num)
+{
+	u8 bit, group;
+	int rc;
+
+	bit = gpio_num % 8;
+	group = (gpio_num / 8);
+
+	if ((rc = superio_enter()))
+		return rc;
+
+	/* enable Simple I/O on the GPIO pin, removing alternate
+	 * function; only the first five groups are programmable as
+	 * either Simple I/O or alternate function, the final free are
+	 * always set to Simple I/O.
+	 *
+	 * This might differ depending on chip type so it could have
+	 * to be made configurable.
+	 */
+	if (group >= GPIO_SE_SIZE)
+		superio_set_bit(bit, group + GPIO_SE_BASE);
+
+	/* clear output enable, setting the pin to input, as all the
+	 * newly-exported GPIO interfaces are set to input.
+	 */
+	superio_clear_bit(bit, group + GPIO_OE_BASE);
+
+	superio_exit();
+
+	return 0;
+}
+
+static int it87_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
+{
+	u16 reg;
+	u8 bit;
+
+	bit = gpio_num % 8;
+	reg = (gpio_num / 8) + gpio_ba;
+
+	return !!(inb(reg) & (1 << bit));
+}
+
+static int it87_gpio_direction_in(struct gpio_chip *gc, unsigned gpio_num)
+{
+	u8 bit, group;
+	int rc;
+
+	bit = gpio_num % 8;
+	group = (gpio_num / 8);
+
+	if ((rc = superio_enter()))
+		return rc;
+
+	/* clear the output enable bit */
+	superio_clear_bit(bit, group + GPIO_OE_BASE);
+
+	superio_exit();
+
+	return 0;
+}
+
+static void it87_gpio_set(struct gpio_chip *gc,
+			  unsigned gpio_num, int val)
+{
+	unsigned long flags;
+	u8 curr_vals, bit;
+	u16 reg;
+
+	bit = gpio_num % 8;
+	reg = (gpio_num / 8) + gpio_ba;
+
+	curr_vals = inb(reg);
+	if (val)
+		outb(curr_vals | (1 << bit) , reg);
+	else
+		outb(curr_vals & ~(1 << bit), reg);
+}
+
+static int it87_gpio_direction_out(struct gpio_chip *gc,
+				   unsigned gpio_num, int val)
+{
+	u8 bit, group;
+	int rc;
+
+	bit = gpio_num % 8;
+	group = (gpio_num / 8);
+
+	if ((rc = superio_enter()))
+		return rc;
+
+	/* set the output enable bit */
+	superio_set_bit(bit, group + GPIO_OE_BASE);
+
+	it87_gpio_set(gc, gpio_num, val);
+
+	superio_exit();
+
+	return 0;
+}
+
+/* ITE documentation refers to the GPIO registers as coordinates of
+ * group/bit; we alias them as otherwise it becomes hard to find a
+ * correlation between the chip's offsets and the names in the
+ * documentation.
+ */
+static const char *const it87_gpio_aliases[] = {
+	"it87_gp10",
+	"it87_gp11",
+	"it87_gp12",
+	"it87_gp13",
+	"it87_gp14",
+	"it87_gp15",
+	"it87_gp16",
+	"it87_gp17",
+	"it87_gp20",
+	"it87_gp21",
+	"it87_gp22",
+	"it87_gp23",
+	"it87_gp24",
+	"it87_gp25",
+	"it87_gp26",
+	"it87_gp27",
+	"it87_gp30",
+	"it87_gp31",
+	"it87_gp32",
+	"it87_gp33",
+	"it87_gp34",
+	"it87_gp35",
+	"it87_gp36",
+	"it87_gp37",
+	"it87_gp40",
+	"it87_gp41",
+	"it87_gp42",
+	"it87_gp43",
+	"it87_gp44",
+	"it87_gp45",
+	"it87_gp46",
+	"it87_gp47",
+	"it87_gp50",
+	"it87_gp51",
+	"it87_gp52",
+	"it87_gp53",
+	"it87_gp54",
+	"it87_gp55",
+	"it87_gp56",
+	"it87_gp57",
+	"it87_gp60",
+	"it87_gp61",
+	"it87_gp62",
+	"it87_gp63",
+	"it87_gp64",
+	"it87_gp65",
+	"it87_gp66",
+	"it87_gp67",
+	"it87_gp70",
+	"it87_gp71",
+	"it87_gp72",
+	"it87_gp73",
+	"it87_gp74",
+	"it87_gp75",
+	"it87_gp76",
+	"it87_gp77",
+	"it87_gp80",
+	"it87_gp81",
+	"it87_gp82",
+	"it87_gp83",
+	"it87_gp84",
+	"it87_gp85",
+	"it87_gp86",
+	"it87_gp87"
+};
+
+static struct gpio_chip it87_gpio_chip = {
+	.label			= GPIO_NAME,
+	.owner			= THIS_MODULE,
+	.request		= it87_gpio_request,
+	.get			= it87_gpio_get,
+	.direction_input	= it87_gpio_direction_in,
+	.set			= it87_gpio_set,
+	.direction_output	= it87_gpio_direction_out,
+	.names			= it87_gpio_aliases
+};
+
+static int __init it87_gpio_init(void)
+{
+	int rc = 0;
+	u8 chip_rev;
+	u16 chip_type;
+
+	if ((rc = superio_enter()))
+		return rc;
+
+	chip_type = superio_inw(CHIPID);
+	chip_rev  = superio_inb(CHIPREV) & 0x0f;
+	superio_exit();
+
+	switch(chip_type) {
+	case IT8728_ID:
+		break;
+	case NO_DEV_ID:
+		printk(KERN_ERR PFX "no device\n");
+		return -ENODEV;
+	default:
+		printk(KERN_ERR PFX
+		       "Unknown Chip found, Chip %04x Revision %x\n",
+		       chip_type, chip_rev);
+		return -ENODEV;
+	}
+
+	if ((rc = superio_enter()))
+		return rc;
+
+	superio_select(GPIO);
+
+	/* fetch GPIO base address */
+	gpio_ba = superio_inw(GPIO_BASE);
+
+	superio_exit();
+
+	if (!request_region(gpio_ba, GPIO_IOSIZE, GPIO_NAME))
+		return -EBUSY;
+
+	it87_gpio_chip.base = -1;
+	it87_gpio_chip.ngpio = 64;
+
+	if ((rc = gpiochip_add(&it87_gpio_chip)) < 0)
+		goto gpiochip_add_err;
+
+	return 0;
+
+gpiochip_add_err:
+	release_region(gpio_ba, GPIO_IOSIZE);
+	gpio_ba = 0;
+	return rc;
+}
+
+static void __exit it87_gpio_exit(void)
+{
+	if (gpio_ba) {
+		int ret = gpiochip_remove(&it87_gpio_chip);
+
+		WARN(ret, "%s(): gpiochip_remove() failed, ret=%d\n",
+				__func__, ret);
+
+		release_region(gpio_ba, GPIO_IOSIZE);
+		gpio_ba = 0;
+	}
+}
+module_init(it87_gpio_init);
+module_exit(it87_gpio_exit);
+
+MODULE_AUTHOR("Diego Elio Pettenò <flameeyes@flameeyes.eu>");
+MODULE_DESCRIPTION("GPIO interface for IT87xx Super I/O chips");
+MODULE_LICENSE("GPL");
-- 
1.7.8.5

