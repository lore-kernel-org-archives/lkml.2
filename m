Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162110Ab2CSQ0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:26:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63579 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031218Ab2CSQ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:26:30 -0400
From: =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.eu>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.eu>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Denis Turischev <denis@compulab.co.il>
Subject: [PATCH] gpio: add support for ITE IT87xx Super I/O GPIO, replacing gpio-it8761e.
Date: Mon, 19 Mar 2012 17:28:33 +0100
Message-Id: <1332174513-6657-1-git-send-email-flameeyes@flameeyes.eu>
X-Mailer: git-send-email 1.7.8.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is currently written for IT8728 (with support for the
previously-present IT8761E), but the code in it87_wdt suggest it would
work the same way on many other versions.

This is just a first step to verify the working status of the code,
and might require moving to a MFD approach to share with hwmon/it87
and it87_wdt, as they all share the same access to the Super I/O chip
(and all of them use the Super I/O configuration for probing).

Alternate function configuration, currently being handled in this
driver, should also be moved to a separate pinctrl driver.

It does not yet support the polarity-inversion register that is
allowed by the chipset, which might require sysfs attributes per-gpio.

For what concerns the support for IT8761E, the only thing I haven't
implemented, only because I'm unsure of how and why it works, is using
ports 0x4e/0x4f instead of 0x2e/0x2f for Super I/O configuration.

CC: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@stericsson.com>
CC: Denis Turischev <denis@compulab.co.il>
Signed-off-by: Diego Elio Pettenò <flameeyes@flameeyes.eu>
---
 MAINTAINERS                 |    5 +
 drivers/gpio/Kconfig        |   14 +-
 drivers/gpio/Makefile       |    2 +-
 drivers/gpio/gpio-it87.c    |  406 +++++++++++++++++++++++++++++++++++++++++++
 drivers/gpio/gpio-it8761e.c |  234 -------------------------
 5 files changed, 422 insertions(+), 239 deletions(-)
 create mode 100644 drivers/gpio/gpio-it87.c
 delete mode 100644 drivers/gpio/gpio-it8761e.c

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
index 3359f1e..63b8e20 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -85,11 +85,17 @@ config GPIO_GENERIC_PLATFORM
 	help
 	  Say yes here to support basic platform_device memory-mapped GPIO controllers.
 
-config GPIO_IT8761E
-	tristate "IT8761E GPIO support"
-	depends on X86  # unconditional access to IO space.
+config GPIO_IT87
+	tristate "IT87xx GPIO support"
+	depends on X86 # unconditional access to IO space.
 	help
-	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
+	  Say yes here to support GPIO functionality of IT87xx Super I/O chips.
+
+	  This driver is tested with ITE IT8728 Super I/O chips, and
+	  supports the IT8761E Super I/O chip as well.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called gpio_it87
 
 config GPIO_EP93XX
 	def_bool y
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 41fe67f..36cada9 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -17,7 +17,7 @@ obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
 obj-$(CONFIG_ARCH_DAVINCI)	+= gpio-davinci.o
 obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
 obj-$(CONFIG_GPIO_ICH)		+= gpio-ich.o
-obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
+obj-$(CONFIG_GPIO_IT87)		+= gpio-it87.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
 obj-$(CONFIG_ARCH_KS8695)	+= gpio-ks8695.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= gpio-langwell.o
diff --git a/drivers/gpio/gpio-it87.c b/drivers/gpio/gpio-it87.c
new file mode 100644
index 0000000..f4bdd44
--- /dev/null
+++ b/drivers/gpio/gpio-it87.c
@@ -0,0 +1,406 @@
+/*
+ *  GPIO interface for IT87xx Super I/O chips
+ *
+ *  Author: Diego Elio Pettenò <flameeyes@flameeyes.eu>
+ *
+ *  Based on it87_wdt.c     by Oliver Schuster
+ *           gpio-it8761e.c by Denis Turischev
+ *           gpio-stmpe.c   by Rabin Vincent
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
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/errno.h>
+#include <linux/ioport.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+
+/* Chip Id numbers */
+#define NO_DEV_ID	0xffff
+#define IT8728_ID	0x8728
+#define IT8761_ID	0x8761
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
+/**
+ * struct it87_gpio - it87-specific GPIO chip
+ * @chip the underlying gpio_chip structure
+ * @lock a lock to avoid races between operations
+ * @io_base base address for gpio ports
+ * @io_size size of the port rage starting from io_base.
+ * @output_base Super I/O register address for Output Enable register
+ * @simple_base Super I/O 'Simple I/O' Enable register
+ * @simple_size Super IO 'Simple I/O' Enable register size; this is
+ * 	required because IT87xx chips might only provide Simple I/O
+ * 	switches on a subset of lines, whereas the others keep the
+ * 	same status all time.
+ */
+struct it87_gpio {
+	struct gpio_chip chip;
+	spinlock_t lock;
+	u16 io_base;
+	u16 io_size;
+	u8 output_base;
+	u8 simple_base;
+	u8 simple_size;
+};
+
+static struct it87_gpio it87_gpio_chip;
+
+static inline struct it87_gpio *to_it87_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct it87_gpio, chip);
+}
+
+/* Superio chip access functions; copied from wdt_it87 */
+
+static inline int superio_enter(void)
+{
+	/*
+	 * Try to reserve REG and REG + 1 for exclusive access.
+	 */
+	if (!request_muxed_region(REG, 2, KBUILD_MODNAME))
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
+static inline void superio_set_mask(int mask, int reg)
+{
+	u8 curr_val = superio_inb(reg);
+	u8 new_val = curr_val | mask;
+
+	if (curr_val != new_val)
+		superio_outb(new_val, reg);
+}
+
+static inline void superio_clear_mask(int mask, int reg)
+{
+	u8 curr_val = superio_inb(reg);
+	u8 new_val = curr_val & ~mask;
+
+	if (curr_val != new_val)
+		superio_outb(new_val, reg);
+}
+
+static int it87_gpio_request(struct gpio_chip *chip, unsigned gpio_num)
+{
+	u8 mask, group;
+	int rc = 0;
+	struct it87_gpio *it87_gpio = to_it87_gpio(chip);
+
+	mask = 1 << (gpio_num % 8);
+	group = (gpio_num / 8);
+
+	spin_lock(&it87_gpio->lock);
+
+	if ((rc = superio_enter()))
+		goto exit;
+
+	/* not all the IT87xx chips support Simple I/O and not all of
+	 * them allow all the lines to be set/unset to Simple I/O.
+	 */
+	if (group < it87_gpio->simple_size)
+		superio_set_mask(mask, group + it87_gpio->simple_base);
+
+	/* clear output enable, setting the pin to input, as all the
+	 * newly-exported GPIO interfaces are set to input.
+	 */
+	superio_clear_mask(mask, group + it87_gpio->output_base);
+
+	superio_exit();
+
+exit:
+	spin_unlock(&it87_gpio->lock);
+	return rc;
+}
+
+static int it87_gpio_get(struct gpio_chip *chip, unsigned gpio_num)
+{
+	u16 reg;
+	u8 mask;
+	struct it87_gpio *it87_gpio = to_it87_gpio(chip);
+
+	mask = 1 << (gpio_num % 8);
+	reg = (gpio_num / 8) + it87_gpio->io_base;
+
+	return !!(inb(reg) & mask);
+}
+
+static int it87_gpio_direction_in(struct gpio_chip *chip, unsigned gpio_num)
+{
+	u8 mask, group;
+	int rc = 0;
+	struct it87_gpio *it87_gpio = to_it87_gpio(chip);
+
+	mask = 1 << (gpio_num % 8);
+	group = (gpio_num / 8);
+
+	spin_lock(&it87_gpio->lock);
+
+	if ((rc = superio_enter()))
+		goto exit;
+		return rc;
+
+	/* clear the output enable bit */
+	superio_clear_mask(mask, group + it87_gpio->output_base);
+
+	superio_exit();
+
+exit:
+	spin_unlock(&it87_gpio->lock);
+	return rc;
+}
+
+static void it87_gpio_set(struct gpio_chip *chip,
+			  unsigned gpio_num, int val)
+{
+	u8 mask, curr_vals;
+	u16 reg;
+	struct it87_gpio *it87_gpio = to_it87_gpio(chip);
+
+	mask = 1 << (gpio_num % 8);
+	reg = (gpio_num / 8) + it87_gpio->io_base;
+
+	curr_vals = inb(reg);
+	if (val)
+		outb(curr_vals | mask , reg);
+	else
+		outb(curr_vals & ~mask, reg);
+}
+
+static int it87_gpio_direction_out(struct gpio_chip *chip,
+				   unsigned gpio_num, int val)
+{
+	u8 mask, group;
+	int rc = 0;
+	struct it87_gpio *it87_gpio = to_it87_gpio(chip);
+
+	mask = 1 << (gpio_num % 8);
+	group = (gpio_num / 8);
+
+	spin_lock(&it87_gpio->lock);
+
+	if ((rc = superio_enter()))
+		goto exit;
+
+	/* set the output enable bit */
+	superio_set_mask(mask, group + it87_gpio->output_base);
+
+	it87_gpio_set(chip, gpio_num, val);
+
+	superio_exit();
+
+exit:
+	spin_unlock(&it87_gpio->lock);
+	return rc;
+}
+
+static struct gpio_chip it87_template_chip = {
+	.label			= KBUILD_MODNAME,
+	.owner			= THIS_MODULE,
+	.request		= it87_gpio_request,
+	.get			= it87_gpio_get,
+	.direction_input	= it87_gpio_direction_in,
+	.set			= it87_gpio_set,
+	.direction_output	= it87_gpio_direction_out,
+	.base			= -1
+};
+
+static int __init it87_gpio_init(void)
+{
+	int rc = 0, i;
+	u16 chip_type;
+	u8 chip_rev, gpio_ba_reg;
+	char *labels, **labels_table;
+
+	struct it87_gpio *it87_gpio = &it87_gpio_chip;
+
+	if ((rc = superio_enter()))
+		return rc;
+
+	chip_type = superio_inw(CHIPID);
+	chip_rev  = superio_inb(CHIPREV) & 0x0f;
+	superio_exit();
+
+	it87_gpio->chip = it87_template_chip;
+
+	switch(chip_type) {
+	case IT8728_ID:
+		gpio_ba_reg = 0x62;
+		it87_gpio->io_size = 8;
+		it87_gpio->output_base = 0xc8;
+		it87_gpio->simple_base = 0xc0;
+		it87_gpio->simple_size = 5;
+		it87_gpio->chip.ngpio = 64;
+		break;
+	case IT8761_ID:
+		gpio_ba_reg = 0x60;
+		it87_gpio->io_size = 4;
+		it87_gpio->output_base = 0xf0;
+		it87_gpio->simple_size = 0;
+		it87_gpio->chip.ngpio = 16;
+		break;
+	case NO_DEV_ID:
+		pr_err("no device\n");
+		rc = -ENODEV;
+		goto gpio_free;
+	default:
+		pr_err("Unknown Chip found, Chip %04x Revision %x\n",
+		       chip_type, chip_rev);
+		rc = -ENODEV;
+		goto gpio_free;
+	}
+
+	if ((rc = superio_enter()))
+		goto gpio_free;
+
+	superio_select(GPIO);
+
+	/* fetch GPIO base address */
+	it87_gpio->io_base = superio_inw(gpio_ba_reg);
+
+	superio_exit();
+
+	pr_info("Found Chip IT%04x rev %x. %u GPIO lines starting at %04xh\n",
+		chip_type, chip_rev, it87_gpio->chip.ngpio, it87_gpio->io_base);
+
+	if (!request_region(it87_gpio->io_base, it87_gpio->io_size, KBUILD_MODNAME)) {
+		rc = -EBUSY;
+		goto gpio_free;
+	}
+
+	/* Set up aliases for the GPIO connection.
+	 *
+	 * ITE documentation for recent chips such as the IT8728F
+	 * refers to the GPIO lines as GPxy, with a coordinates system
+	 * where x is the GPIO group (starting from 1) and y is the
+	 * bit within the group.
+	 *
+	 * By creating these aliases, we make it easier to understand
+	 * to which GPIO pin we're referring to.
+	 */
+	labels = kcalloc(it87_gpio->chip.ngpio, sizeof("it87_gpXY"), GFP_KERNEL);
+	labels_table = kcalloc(it87_gpio->chip.ngpio, sizeof(const char *), GFP_KERNEL);
+
+	if (!labels || !labels_table) {
+		rc = -ENOMEM;
+		goto gpio_free;
+	}
+
+	for (i = 0; i < it87_gpio->chip.ngpio; i++) {
+		char *label = &labels[i*sizeof("it87_gpXY")];
+		sprintf(label, "it87_gp%u%u", 1+(i/8), i%8);
+		labels_table[i] = label;
+	}
+
+	it87_gpio->chip.names = (const char *const*)labels_table;
+
+	if ((rc = gpiochip_add(&it87_gpio->chip)))
+		goto gpio_release;
+
+	return 0;
+
+gpio_release:
+	release_region(it87_gpio->io_base, it87_gpio->io_size);
+
+gpio_free:
+	kfree(it87_gpio->chip.names[0]);
+	kfree(it87_gpio->chip.names);
+	return rc;
+}
+
+static void __exit it87_gpio_exit(void)
+{
+	struct it87_gpio *it87_gpio = &it87_gpio_chip;
+	int rc;
+
+	if ((rc = gpiochip_remove(&it87_gpio->chip)))
+		pr_warn("gpiochip_remove() failed, rc=%d\n", rc);
+
+	release_region(it87_gpio->io_base, it87_gpio->io_size);
+
+	kfree(it87_gpio->chip.names[0]);
+	kfree(it87_gpio->chip.names);
+}
+
+module_init(it87_gpio_init);
+module_exit(it87_gpio_exit);
+
+MODULE_AUTHOR("Diego Elio Pettenò <flameeyes@flameeyes.eu>");
+MODULE_DESCRIPTION("GPIO interface for IT87xx Super I/O chips");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpio/gpio-it8761e.c b/drivers/gpio/gpio-it8761e.c
deleted file mode 100644
index 278b813..0000000
--- a/drivers/gpio/gpio-it8761e.c
+++ /dev/null
@@ -1,234 +0,0 @@
-/*
- *  GPIO interface for IT8761E Super I/O chip
- *
- *  Author: Denis Turischev <denis@compulab.co.il>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License 2 as published
- *  by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; see the file COPYING.  If not, write to
- *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/io.h>
-#include <linux/errno.h>
-#include <linux/ioport.h>
-
-#include <linux/gpio.h>
-
-#define SIO_CHIP_ID		0x8761
-#define CHIP_ID_HIGH_BYTE	0x20
-#define CHIP_ID_LOW_BYTE	0x21
-
-static u8 ports[2] = { 0x2e, 0x4e };
-static u8 port;
-
-static DEFINE_SPINLOCK(sio_lock);
-
-#define GPIO_NAME		"it8761-gpio"
-#define GPIO_BA_HIGH_BYTE	0x60
-#define GPIO_BA_LOW_BYTE	0x61
-#define GPIO_IOSIZE		4
-#define GPIO1X_IO		0xf0
-#define GPIO2X_IO		0xf1
-
-static u16 gpio_ba;
-
-static u8 read_reg(u8 addr, u8 port)
-{
-	outb(addr, port);
-	return inb(port + 1);
-}
-
-static void write_reg(u8 data, u8 addr, u8 port)
-{
-	outb(addr, port);
-	outb(data, port + 1);
-}
-
-static void enter_conf_mode(u8 port)
-{
-	outb(0x87, port);
-	outb(0x61, port);
-	outb(0x55, port);
-	outb((port == 0x2e) ? 0x55 : 0xaa, port);
-}
-
-static void exit_conf_mode(u8 port)
-{
-	outb(0x2, port);
-	outb(0x2, port + 1);
-}
-
-static void enter_gpio_mode(u8 port)
-{
-	write_reg(0x2, 0x7, port);
-}
-
-static int it8761e_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
-{
-	u16 reg;
-	u8 bit;
-
-	bit = gpio_num % 8;
-	reg = (gpio_num >= 8) ? gpio_ba + 1 : gpio_ba;
-
-	return !!(inb(reg) & (1 << bit));
-}
-
-static int it8761e_gpio_direction_in(struct gpio_chip *gc, unsigned gpio_num)
-{
-	u8 curr_dirs;
-	u8 io_reg, bit;
-
-	bit = gpio_num % 8;
-	io_reg = (gpio_num >= 8) ? GPIO2X_IO : GPIO1X_IO;
-
-	spin_lock(&sio_lock);
-
-	enter_conf_mode(port);
-	enter_gpio_mode(port);
-
-	curr_dirs = read_reg(io_reg, port);
-
-	if (curr_dirs & (1 << bit))
-		write_reg(curr_dirs & ~(1 << bit), io_reg, port);
-
-	exit_conf_mode(port);
-
-	spin_unlock(&sio_lock);
-	return 0;
-}
-
-static void it8761e_gpio_set(struct gpio_chip *gc,
-				unsigned gpio_num, int val)
-{
-	u8 curr_vals, bit;
-	u16 reg;
-
-	bit = gpio_num % 8;
-	reg = (gpio_num >= 8) ? gpio_ba + 1 : gpio_ba;
-
-	spin_lock(&sio_lock);
-
-	curr_vals = inb(reg);
-	if (val)
-		outb(curr_vals | (1 << bit) , reg);
-	else
-		outb(curr_vals & ~(1 << bit), reg);
-
-	spin_unlock(&sio_lock);
-}
-
-static int it8761e_gpio_direction_out(struct gpio_chip *gc,
-					unsigned gpio_num, int val)
-{
-	u8 curr_dirs, io_reg, bit;
-
-	bit = gpio_num % 8;
-	io_reg = (gpio_num >= 8) ? GPIO2X_IO : GPIO1X_IO;
-
-	it8761e_gpio_set(gc, gpio_num, val);
-
-	spin_lock(&sio_lock);
-
-	enter_conf_mode(port);
-	enter_gpio_mode(port);
-
-	curr_dirs = read_reg(io_reg, port);
-
-	if (!(curr_dirs & (1 << bit)))
-		write_reg(curr_dirs | (1 << bit), io_reg, port);
-
-	exit_conf_mode(port);
-
-	spin_unlock(&sio_lock);
-	return 0;
-}
-
-static struct gpio_chip it8761e_gpio_chip = {
-	.label			= GPIO_NAME,
-	.owner			= THIS_MODULE,
-	.get			= it8761e_gpio_get,
-	.direction_input	= it8761e_gpio_direction_in,
-	.set			= it8761e_gpio_set,
-	.direction_output	= it8761e_gpio_direction_out,
-};
-
-static int __init it8761e_gpio_init(void)
-{
-	int i, id, err;
-
-	/* chip and port detection */
-	for (i = 0; i < ARRAY_SIZE(ports); i++) {
-		spin_lock(&sio_lock);
-		enter_conf_mode(ports[i]);
-
-		id = (read_reg(CHIP_ID_HIGH_BYTE, ports[i]) << 8) +
-				read_reg(CHIP_ID_LOW_BYTE, ports[i]);
-
-		exit_conf_mode(ports[i]);
-		spin_unlock(&sio_lock);
-
-		if (id == SIO_CHIP_ID) {
-			port = ports[i];
-			break;
-		}
-	}
-
-	if (!port)
-		return -ENODEV;
-
-	/* fetch GPIO base address */
-	enter_conf_mode(port);
-	enter_gpio_mode(port);
-	gpio_ba = (read_reg(GPIO_BA_HIGH_BYTE, port) << 8) +
-				read_reg(GPIO_BA_LOW_BYTE, port);
-	exit_conf_mode(port);
-
-	if (!request_region(gpio_ba, GPIO_IOSIZE, GPIO_NAME))
-		return -EBUSY;
-
-	it8761e_gpio_chip.base = -1;
-	it8761e_gpio_chip.ngpio = 16;
-
-	err = gpiochip_add(&it8761e_gpio_chip);
-	if (err < 0)
-		goto gpiochip_add_err;
-
-	return 0;
-
-gpiochip_add_err:
-	release_region(gpio_ba, GPIO_IOSIZE);
-	gpio_ba = 0;
-	return err;
-}
-
-static void __exit it8761e_gpio_exit(void)
-{
-	if (gpio_ba) {
-		int ret = gpiochip_remove(&it8761e_gpio_chip);
-
-		WARN(ret, "%s(): gpiochip_remove() failed, ret=%d\n",
-				__func__, ret);
-
-		release_region(gpio_ba, GPIO_IOSIZE);
-		gpio_ba = 0;
-	}
-}
-module_init(it8761e_gpio_init);
-module_exit(it8761e_gpio_exit);
-
-MODULE_AUTHOR("Denis Turischev <denis@compulab.co.il>");
-MODULE_DESCRIPTION("GPIO interface for IT8761E Super I/O chip");
-MODULE_LICENSE("GPL");
-- 
1.7.8.5

