Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935347Ab1ETFo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:44:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44051 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab1ETFo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:44:56 -0400
X-AuditID: cbfee61a-b7ce2ae000001a8f-d7-4dd5ffd6eaa8
Date: Fri, 20 May 2011 14:44:47 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH 1/4] Move to Samsung common GPIO library to drivers/gpio
To: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, kgene.kim@samsung.com, linux-arm-kernel@lists.infradead.org
Message-id: <20110520054447.GA9956@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 20 May 2011 05:44:53.0564 (UTC)
 FILETIME=[0AF347C0:01CC16B1]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

It's common gpiolib for recent Samsung SoCs. Move to drivers/gpio

CC: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/plat-samsung/Makefile  |    1 -
 arch/arm/plat-samsung/gpiolib.c |  206 --------------------------------------
 drivers/gpio/Kconfig            |    6 +
 drivers/gpio/Makefile           |    1 +
 drivers/gpio/samsung-gpiolib.c  |  207 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 214 insertions(+), 207 deletions(-)
 delete mode 100644 arch/arm/plat-samsung/gpiolib.c
 create mode 100644 drivers/gpio/samsung-gpiolib.c

diff --git a/arch/arm/plat-samsung/Makefile b/arch/arm/plat-samsung/Makefile
index e9de58a..53eb15b 100644
--- a/arch/arm/plat-samsung/Makefile
+++ b/arch/arm/plat-samsung/Makefile
@@ -19,7 +19,6 @@ obj-y				+= gpio.o
 obj-y				+= gpio-config.o
 obj-y				+= dev-asocdma.o
 
-obj-$(CONFIG_SAMSUNG_GPIOLIB_4BIT)	+= gpiolib.o
 obj-$(CONFIG_SAMSUNG_CLKSRC)	+= clock-clksrc.o
 
 obj-$(CONFIG_SAMSUNG_IRQ_UART)	+= irq-uart.o
diff --git a/arch/arm/plat-samsung/gpiolib.c b/arch/arm/plat-samsung/gpiolib.c
deleted file mode 100644
index ea37c04..0000000
--- a/arch/arm/plat-samsung/gpiolib.c
+++ /dev/null
@@ -1,206 +0,0 @@
-/* arch/arm/plat-samsung/gpiolib.c
- *
- * Copyright 2008 Openmoko, Inc.
- * Copyright 2008 Simtec Electronics
- *      Ben Dooks <ben@simtec.co.uk>
- *      http://armlinux.simtec.co.uk/
- *
- * Copyright (c) 2009 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com/
- *
- * SAMSUNG - GPIOlib support
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/irq.h>
-#include <linux/io.h>
-#include <linux/gpio.h>
-#include <plat/gpio-core.h>
-#include <plat/gpio-cfg.h>
-#include <plat/gpio-cfg-helpers.h>
-
-#ifndef DEBUG_GPIO
-#define gpio_dbg(x...) do { } while (0)
-#else
-#define gpio_dbg(x...) printk(KERN_DEBUG x)
-#endif
-
-/* The samsung_gpiolib_4bit routines are to control the gpio banks where
- * the gpio configuration register (GPxCON) has 4 bits per GPIO, as the
- * following example:
- *
- * base + 0x00: Control register, 4 bits per gpio
- *		gpio n: 4 bits starting at (4*n)
- *		0000 = input, 0001 = output, others mean special-function
- * base + 0x04: Data register, 1 bit per gpio
- *		bit n: data bit n
- *
- * Note, since the data register is one bit per gpio and is at base + 0x4
- * we can use s3c_gpiolib_get and s3c_gpiolib_set to change the state of
- * the output.
-*/
-
-static int samsung_gpiolib_4bit_input(struct gpio_chip *chip,
-				      unsigned int offset)
-{
-	struct s3c_gpio_chip *ourchip = to_s3c_gpio(chip);
-	void __iomem *base = ourchip->base;
-	unsigned long con;
-
-	con = __raw_readl(base + GPIOCON_OFF);
-	con &= ~(0xf << con_4bit_shift(offset));
-	__raw_writel(con, base + GPIOCON_OFF);
-
-	gpio_dbg("%s: %p: CON now %08lx\n", __func__, base, con);
-
-	return 0;
-}
-
-static int samsung_gpiolib_4bit_output(struct gpio_chip *chip,
-				       unsigned int offset, int value)
-{
-	struct s3c_gpio_chip *ourchip = to_s3c_gpio(chip);
-	void __iomem *base = ourchip->base;
-	unsigned long con;
-	unsigned long dat;
-
-	con = __raw_readl(base + GPIOCON_OFF);
-	con &= ~(0xf << con_4bit_shift(offset));
-	con |= 0x1 << con_4bit_shift(offset);
-
-	dat = __raw_readl(base + GPIODAT_OFF);
-
-	if (value)
-		dat |= 1 << offset;
-	else
-		dat &= ~(1 << offset);
-
-	__raw_writel(dat, base + GPIODAT_OFF);
-	__raw_writel(con, base + GPIOCON_OFF);
-	__raw_writel(dat, base + GPIODAT_OFF);
-
-	gpio_dbg("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
-
-	return 0;
-}
-
-/* The next set of routines are for the case where the GPIO configuration
- * registers are 4 bits per GPIO but there is more than one register (the
- * bank has more than 8 GPIOs.
- *
- * This case is the similar to the 4 bit case, but the registers are as
- * follows:
- *
- * base + 0x00: Control register, 4 bits per gpio (lower 8 GPIOs)
- *		gpio n: 4 bits starting at (4*n)
- *		0000 = input, 0001 = output, others mean special-function
- * base + 0x04: Control register, 4 bits per gpio (up to 8 additions GPIOs)
- *		gpio n: 4 bits starting at (4*n)
- *		0000 = input, 0001 = output, others mean special-function
- * base + 0x08: Data register, 1 bit per gpio
- *		bit n: data bit n
- *
- * To allow us to use the s3c_gpiolib_get and s3c_gpiolib_set routines we
- * store the 'base + 0x4' address so that these routines see the data
- * register at ourchip->base + 0x04.
- */
-
-static int samsung_gpiolib_4bit2_input(struct gpio_chip *chip,
-				       unsigned int offset)
-{
-	struct s3c_gpio_chip *ourchip = to_s3c_gpio(chip);
-	void __iomem *base = ourchip->base;
-	void __iomem *regcon = base;
-	unsigned long con;
-
-	if (offset > 7)
-		offset -= 8;
-	else
-		regcon -= 4;
-
-	con = __raw_readl(regcon);
-	con &= ~(0xf << con_4bit_shift(offset));
-	__raw_writel(con, regcon);
-
-	gpio_dbg("%s: %p: CON %08lx\n", __func__, base, con);
-
-	return 0;
-}
-
-static int samsung_gpiolib_4bit2_output(struct gpio_chip *chip,
-					unsigned int offset, int value)
-{
-	struct s3c_gpio_chip *ourchip = to_s3c_gpio(chip);
-	void __iomem *base = ourchip->base;
-	void __iomem *regcon = base;
-	unsigned long con;
-	unsigned long dat;
-	unsigned con_offset = offset;
-
-	if (con_offset > 7)
-		con_offset -= 8;
-	else
-		regcon -= 4;
-
-	con = __raw_readl(regcon);
-	con &= ~(0xf << con_4bit_shift(con_offset));
-	con |= 0x1 << con_4bit_shift(con_offset);
-
-	dat = __raw_readl(base + GPIODAT_OFF);
-
-	if (value)
-		dat |= 1 << offset;
-	else
-		dat &= ~(1 << offset);
-
-	__raw_writel(dat, base + GPIODAT_OFF);
-	__raw_writel(con, regcon);
-	__raw_writel(dat, base + GPIODAT_OFF);
-
-	gpio_dbg("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
-
-	return 0;
-}
-
-void __init samsung_gpiolib_add_4bit(struct s3c_gpio_chip *chip)
-{
-	chip->chip.direction_input = samsung_gpiolib_4bit_input;
-	chip->chip.direction_output = samsung_gpiolib_4bit_output;
-	chip->pm = __gpio_pm(&s3c_gpio_pm_4bit);
-}
-
-void __init samsung_gpiolib_add_4bit2(struct s3c_gpio_chip *chip)
-{
-	chip->chip.direction_input = samsung_gpiolib_4bit2_input;
-	chip->chip.direction_output = samsung_gpiolib_4bit2_output;
-	chip->pm = __gpio_pm(&s3c_gpio_pm_4bit);
-}
-
-void __init samsung_gpiolib_add_4bit_chips(struct s3c_gpio_chip *chip,
-					   int nr_chips)
-{
-	for (; nr_chips > 0; nr_chips--, chip++) {
-		samsung_gpiolib_add_4bit(chip);
-		s3c_gpiolib_add(chip);
-	}
-}
-
-void __init samsung_gpiolib_add_4bit2_chips(struct s3c_gpio_chip *chip,
-					    int nr_chips)
-{
-	for (; nr_chips > 0; nr_chips--, chip++) {
-		samsung_gpiolib_add_4bit2(chip);
-		s3c_gpiolib_add(chip);
-	}
-}
-
-void __init samsung_gpiolib_add_2bit_chips(struct s3c_gpio_chip *chip,
-					   int nr_chips)
-{
-	for (; nr_chips > 0; nr_chips--, chip++)
-		s3c_gpiolib_add(chip);
-}
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d3b2953..42376b7 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -75,6 +75,12 @@ config GPIO_BASIC_MMIO
 	help
 	  Say yes here to support basic memory-mapped GPIO controllers.
 
+config GPIO_SAMSUNG
+	bool "Samsung SoCs GPIO library support"
+	default y if SAMSUNG_GPIOLIB_4BIT
+	help
+	  Say yes here to support Samsung SoCs GPIO library
+
 config GPIO_IT8761E
 	tristate "IT8761E GPIO support"
 	depends on GPIOLIB
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index becef59..229082d 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
 obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
+obj-$(CONFIG_GPIO_SAMSUNG)	+= samsung-gpiolib.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
 obj-$(CONFIG_GPIO_MAX7300)	+= max7300.o
diff --git a/drivers/gpio/samsung-gpiolib.c b/drivers/gpio/samsung-gpiolib.c
new file mode 100644
index 0000000..925b66e
--- /dev/null
+++ b/drivers/gpio/samsung-gpiolib.c
@@ -0,0 +1,207 @@
+/*
+ * drivers/gpio/samsung-gpiolib.c
+ *
+ * Copyright 2008 Openmoko, Inc.
+ * Copyright 2008 Simtec Electronics
+ *      Ben Dooks <ben@simtec.co.uk>
+ *      http://armlinux.simtec.co.uk/
+ *
+ * Copyright (c) 2009 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * SAMSUNG - GPIOlib support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <plat/gpio-core.h>
+#include <plat/gpio-cfg.h>
+#include <plat/gpio-cfg-helpers.h>
+
+#ifndef DEBUG_GPIO
+#define gpio_dbg(x...) do { } while (0)
+#else
+#define gpio_dbg(x...) printk(KERN_DEBUG x)
+#endif
+
+/* The samsung_gpiolib_4bit routines are to control the gpio banks where
+ * the gpio configuration register (GPxCON) has 4 bits per GPIO, as the
+ * following example:
+ *
+ * base + 0x00: Control register, 4 bits per gpio
+ *		gpio n: 4 bits starting at (4*n)
+ *		0000 = input, 0001 = output, others mean special-function
+ * base + 0x04: Data register, 1 bit per gpio
+ *		bit n: data bit n
+ *
+ * Note, since the data register is one bit per gpio and is at base + 0x4
+ * we can use s3c_gpiolib_get and s3c_gpiolib_set to change the state of
+ * the output.
+*/
+
+static int samsung_gpiolib_4bit_input(struct gpio_chip *chip,
+				      unsigned int offset)
+{
+	struct s3c_gpio_chip *ourchip = to_s3c_gpio(chip);
+	void __iomem *base = ourchip->base;
+	unsigned long con;
+
+	con = __raw_readl(base + GPIOCON_OFF);
+	con &= ~(0xf << con_4bit_shift(offset));
+	__raw_writel(con, base + GPIOCON_OFF);
+
+	gpio_dbg("%s: %p: CON now %08lx\n", __func__, base, con);
+
+	return 0;
+}
+
+static int samsung_gpiolib_4bit_output(struct gpio_chip *chip,
+				       unsigned int offset, int value)
+{
+	struct s3c_gpio_chip *ourchip = to_s3c_gpio(chip);
+	void __iomem *base = ourchip->base;
+	unsigned long con;
+	unsigned long dat;
+
+	con = __raw_readl(base + GPIOCON_OFF);
+	con &= ~(0xf << con_4bit_shift(offset));
+	con |= 0x1 << con_4bit_shift(offset);
+
+	dat = __raw_readl(base + GPIODAT_OFF);
+
+	if (value)
+		dat |= 1 << offset;
+	else
+		dat &= ~(1 << offset);
+
+	__raw_writel(dat, base + GPIODAT_OFF);
+	__raw_writel(con, base + GPIOCON_OFF);
+	__raw_writel(dat, base + GPIODAT_OFF);
+
+	gpio_dbg("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
+
+	return 0;
+}
+
+/* The next set of routines are for the case where the GPIO configuration
+ * registers are 4 bits per GPIO but there is more than one register (the
+ * bank has more than 8 GPIOs.
+ *
+ * This case is the similar to the 4 bit case, but the registers are as
+ * follows:
+ *
+ * base + 0x00: Control register, 4 bits per gpio (lower 8 GPIOs)
+ *		gpio n: 4 bits starting at (4*n)
+ *		0000 = input, 0001 = output, others mean special-function
+ * base + 0x04: Control register, 4 bits per gpio (up to 8 additions GPIOs)
+ *		gpio n: 4 bits starting at (4*n)
+ *		0000 = input, 0001 = output, others mean special-function
+ * base + 0x08: Data register, 1 bit per gpio
+ *		bit n: data bit n
+ *
+ * To allow us to use the s3c_gpiolib_get and s3c_gpiolib_set routines we
+ * store the 'base + 0x4' address so that these routines see the data
+ * register at ourchip->base + 0x04.
+ */
+
+static int samsung_gpiolib_4bit2_input(struct gpio_chip *chip,
+				       unsigned int offset)
+{
+	struct s3c_gpio_chip *ourchip = to_s3c_gpio(chip);
+	void __iomem *base = ourchip->base;
+	void __iomem *regcon = base;
+	unsigned long con;
+
+	if (offset > 7)
+		offset -= 8;
+	else
+		regcon -= 4;
+
+	con = __raw_readl(regcon);
+	con &= ~(0xf << con_4bit_shift(offset));
+	__raw_writel(con, regcon);
+
+	gpio_dbg("%s: %p: CON %08lx\n", __func__, base, con);
+
+	return 0;
+}
+
+static int samsung_gpiolib_4bit2_output(struct gpio_chip *chip,
+					unsigned int offset, int value)
+{
+	struct s3c_gpio_chip *ourchip = to_s3c_gpio(chip);
+	void __iomem *base = ourchip->base;
+	void __iomem *regcon = base;
+	unsigned long con;
+	unsigned long dat;
+	unsigned con_offset = offset;
+
+	if (con_offset > 7)
+		con_offset -= 8;
+	else
+		regcon -= 4;
+
+	con = __raw_readl(regcon);
+	con &= ~(0xf << con_4bit_shift(con_offset));
+	con |= 0x1 << con_4bit_shift(con_offset);
+
+	dat = __raw_readl(base + GPIODAT_OFF);
+
+	if (value)
+		dat |= 1 << offset;
+	else
+		dat &= ~(1 << offset);
+
+	__raw_writel(dat, base + GPIODAT_OFF);
+	__raw_writel(con, regcon);
+	__raw_writel(dat, base + GPIODAT_OFF);
+
+	gpio_dbg("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
+
+	return 0;
+}
+
+void __init samsung_gpiolib_add_4bit(struct s3c_gpio_chip *chip)
+{
+	chip->chip.direction_input = samsung_gpiolib_4bit_input;
+	chip->chip.direction_output = samsung_gpiolib_4bit_output;
+	chip->pm = __gpio_pm(&s3c_gpio_pm_4bit);
+}
+
+void __init samsung_gpiolib_add_4bit2(struct s3c_gpio_chip *chip)
+{
+	chip->chip.direction_input = samsung_gpiolib_4bit2_input;
+	chip->chip.direction_output = samsung_gpiolib_4bit2_output;
+	chip->pm = __gpio_pm(&s3c_gpio_pm_4bit);
+}
+
+void __init samsung_gpiolib_add_4bit_chips(struct s3c_gpio_chip *chip,
+					   int nr_chips)
+{
+	for (; nr_chips > 0; nr_chips--, chip++) {
+		samsung_gpiolib_add_4bit(chip);
+		s3c_gpiolib_add(chip);
+	}
+}
+
+void __init samsung_gpiolib_add_4bit2_chips(struct s3c_gpio_chip *chip,
+					    int nr_chips)
+{
+	for (; nr_chips > 0; nr_chips--, chip++) {
+		samsung_gpiolib_add_4bit2(chip);
+		s3c_gpiolib_add(chip);
+	}
+}
+
+void __init samsung_gpiolib_add_2bit_chips(struct s3c_gpio_chip *chip,
+					   int nr_chips)
+{
+	for (; nr_chips > 0; nr_chips--, chip++)
+		s3c_gpiolib_add(chip);
+}
-- 
1.7.5.1.300.gc565c

