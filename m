Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1GEFL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 01:11:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56199 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab1GEFLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 01:11:22 -0400
From: Sekhar Nori <nsekhar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Kevin Hilman <khilman@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Cyril Chemparathy <cyril@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [RFC/RFT 2/2] davinci: use generic memory mapped gpio for tnetv107x
Date: Tue, 5 Jul 2011 10:41:00 +0530
Message-ID: <6639b07562e3e6643dd07d5ed3907cb5158ce16b.1309840042.git.nsekhar@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <cover.1309840042.git.nsekhar@ti.com>
References: <cover.1309840042.git.nsekhar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO controller on TNETV107x SoC can use
the generic memory mapped GPIO driver.

Shift to the generic driver instead of the
private implementation.

Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/mach-davinci/Kconfig             |    1 +
 arch/arm/mach-davinci/Makefile            |    1 -
 arch/arm/mach-davinci/devices-tnetv107x.c |   68 ++++++++++
 arch/arm/mach-davinci/gpio-tnetv107x.c    |  205 -----------------------------
 arch/arm/mach-davinci/tnetv107x.c         |    3 -
 5 files changed, 69 insertions(+), 209 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/gpio-tnetv107x.c

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index c0deaca..ec0c6d3 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -53,6 +53,7 @@ config ARCH_DAVINCI_DM365
 config ARCH_DAVINCI_TNETV107X
 	select CPU_V6
 	select CP_INTC
+	select GPIO_GENERIC_PLATFORM
 	bool "TNETV107X based system"
 
 comment "DaVinci Board Type"
diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
index 0b87a1c..40557c8 100644
--- a/arch/arm/mach-davinci/Makefile
+++ b/arch/arm/mach-davinci/Makefile
@@ -17,7 +17,6 @@ obj-$(CONFIG_ARCH_DAVINCI_DM365)	+= dm365.o devices.o
 obj-$(CONFIG_ARCH_DAVINCI_DA830)        += da830.o devices-da8xx.o
 obj-$(CONFIG_ARCH_DAVINCI_DA850)        += da850.o devices-da8xx.o
 obj-$(CONFIG_ARCH_DAVINCI_TNETV107X)    += tnetv107x.o devices-tnetv107x.o
-obj-$(CONFIG_ARCH_DAVINCI_TNETV107X)    += gpio-tnetv107x.o
 
 obj-$(CONFIG_AINTC)			+= irq.o
 obj-$(CONFIG_CP_INTC)			+= cp_intc.o
diff --git a/arch/arm/mach-davinci/devices-tnetv107x.c b/arch/arm/mach-davinci/devices-tnetv107x.c
index 6162cae..eab43b1 100644
--- a/arch/arm/mach-davinci/devices-tnetv107x.c
+++ b/arch/arm/mach-davinci/devices-tnetv107x.c
@@ -18,6 +18,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
 #include <linux/slab.h>
+#include <linux/basic_mmio_gpio.h>
 
 #include <mach/common.h>
 #include <mach/irqs.h>
@@ -31,6 +32,7 @@
 #define TNETV107X_TPTC0_BASE			0x01c10000
 #define TNETV107X_TPTC1_BASE			0x01c10400
 #define TNETV107X_WDOG_BASE			0x08086700
+#define TNETV107X_GPIO_BASE			0x08088000
 #define TNETV107X_TSC_BASE			0x08088500
 #define TNETV107X_SDIO0_BASE			0x08088700
 #define TNETV107X_SDIO1_BASE			0x08088800
@@ -362,11 +364,77 @@ static struct platform_device ssp_device = {
 	.resource	= ssp_resources,
 };
 
+#define TNETV107X_N_GPIO_DEV	DIV_ROUND_UP(TNETV107X_N_GPIO, 32)
+
+static struct resource gpio_resources[TNETV107X_N_GPIO_DEV][4] = {
+	[0 ... TNETV107X_N_GPIO_DEV - 1] = {
+		{
+			.name	= "dat",
+			.start	= TNETV107X_GPIO_BASE + 0x4,
+			.end	= TNETV107X_GPIO_BASE + 0x4 + 0x4 - 1,
+		},
+		{
+			.name	= "set",
+			.start	= TNETV107X_GPIO_BASE + 0x10,
+			.end	= TNETV107X_GPIO_BASE + 0x10 + 0x4 - 1,
+		},
+		{
+			.name	= "dirin",
+			.start	= TNETV107X_GPIO_BASE + 0x1c,
+			.end	= TNETV107X_GPIO_BASE + 0x1c + 0x4 - 1,
+		},
+		{
+			.name	= "en",
+			.start	= TNETV107X_GPIO_BASE + 0x28,
+			.end	= TNETV107X_GPIO_BASE + 0x28 + 0x4 - 1,
+		},
+	},
+};
+
+static struct platform_device gpio_device[] = {
+	[0 ... TNETV107X_N_GPIO_DEV - 1] = {
+		.name		= "basic-mmio-gpio",
+		.num_resources	= 4,
+	},
+};
+
+static struct bgpio_pdata gpio_pdata[TNETV107X_N_GPIO_DEV];
+
+static void __init tnetv107x_gpio_init(void)
+{
+	int i, j;
+
+	for (i = 1; i < TNETV107X_N_GPIO_DEV; i++) {
+		for (j = 0; j < 4; j++) {
+			gpio_resources[i][j].start += 0x4 * i;
+			gpio_resources[i][j].end += 0x4 * i;
+		}
+	}
+
+	for (i = 0; i < TNETV107X_N_GPIO_DEV; i++) {
+		int base = i * 32;
+
+		gpio_device[i].id = i;
+		gpio_device[i].resource = gpio_resources[i];
+
+		gpio_pdata[i].base = base;
+		gpio_pdata[i].ngpio = TNETV107X_N_GPIO - base;
+		if (gpio_pdata[i].ngpio > 32)
+			gpio_pdata[i].ngpio = 32;
+
+		gpio_device[i].dev.platform_data = &gpio_pdata[i];
+
+		platform_device_register(&gpio_device[i]);
+	}
+}
+
 void __init tnetv107x_devices_init(struct tnetv107x_device_info *info)
 {
 	int i, error;
 	struct clk *tsc_clk;
 
+	tnetv107x_gpio_init();
+
 	/*
 	 * The reset defaults for tnetv107x tsc clock divider is set too high.
 	 * This forces the clock down to a range that allows the ADC to
diff --git a/arch/arm/mach-davinci/gpio-tnetv107x.c b/arch/arm/mach-davinci/gpio-tnetv107x.c
deleted file mode 100644
index 3fa3e28..0000000
--- a/arch/arm/mach-davinci/gpio-tnetv107x.c
+++ /dev/null
@@ -1,205 +0,0 @@
-/*
- * Texas Instruments TNETV107X GPIO Controller
- *
- * Copyright (C) 2010 Texas Instruments
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/gpio.h>
-
-#include <mach/common.h>
-#include <mach/tnetv107x.h>
-
-struct tnetv107x_gpio_regs {
-	u32	idver;
-	u32	data_in[3];
-	u32	data_out[3];
-	u32	direction[3];
-	u32	enable[3];
-};
-
-#define gpio_reg_index(gpio)	((gpio) >> 5)
-#define gpio_reg_bit(gpio)	BIT((gpio) & 0x1f)
-
-#define gpio_reg_rmw(reg, mask, val)	\
-	__raw_writel((__raw_readl(reg) & ~(mask)) | (val), (reg))
-
-#define gpio_reg_set_bit(reg, gpio)	\
-	gpio_reg_rmw((reg) + gpio_reg_index(gpio), 0, gpio_reg_bit(gpio))
-
-#define gpio_reg_clear_bit(reg, gpio)	\
-	gpio_reg_rmw((reg) + gpio_reg_index(gpio), gpio_reg_bit(gpio), 0)
-
-#define gpio_reg_get_bit(reg, gpio)	\
-	(__raw_readl((reg) + gpio_reg_index(gpio)) & gpio_reg_bit(gpio))
-
-#define chip2controller(chip)		\
-	container_of(chip, struct davinci_gpio_controller, chip)
-
-#define TNETV107X_GPIO_CTLRS	DIV_ROUND_UP(TNETV107X_N_GPIO, 32)
-
-static struct davinci_gpio_controller chips[TNETV107X_GPIO_CTLRS];
-
-static int tnetv107x_gpio_request(struct gpio_chip *chip, unsigned offset)
-{
-	struct davinci_gpio_controller *ctlr = chip2controller(chip);
-	struct tnetv107x_gpio_regs __iomem *regs = ctlr->regs;
-	unsigned gpio = chip->base + offset;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctlr->lock, flags);
-
-	gpio_reg_set_bit(regs->enable, gpio);
-
-	spin_unlock_irqrestore(&ctlr->lock, flags);
-
-	return 0;
-}
-
-static void tnetv107x_gpio_free(struct gpio_chip *chip, unsigned offset)
-{
-	struct davinci_gpio_controller *ctlr = chip2controller(chip);
-	struct tnetv107x_gpio_regs __iomem *regs = ctlr->regs;
-	unsigned gpio = chip->base + offset;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctlr->lock, flags);
-
-	gpio_reg_clear_bit(regs->enable, gpio);
-
-	spin_unlock_irqrestore(&ctlr->lock, flags);
-}
-
-static int tnetv107x_gpio_dir_in(struct gpio_chip *chip, unsigned offset)
-{
-	struct davinci_gpio_controller *ctlr = chip2controller(chip);
-	struct tnetv107x_gpio_regs __iomem *regs = ctlr->regs;
-	unsigned gpio = chip->base + offset;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctlr->lock, flags);
-
-	gpio_reg_set_bit(regs->direction, gpio);
-
-	spin_unlock_irqrestore(&ctlr->lock, flags);
-
-	return 0;
-}
-
-static int tnetv107x_gpio_dir_out(struct gpio_chip *chip,
-		unsigned offset, int value)
-{
-	struct davinci_gpio_controller *ctlr = chip2controller(chip);
-	struct tnetv107x_gpio_regs __iomem *regs = ctlr->regs;
-	unsigned gpio = chip->base + offset;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctlr->lock, flags);
-
-	if (value)
-		gpio_reg_set_bit(regs->data_out, gpio);
-	else
-		gpio_reg_clear_bit(regs->data_out, gpio);
-
-	gpio_reg_clear_bit(regs->direction, gpio);
-
-	spin_unlock_irqrestore(&ctlr->lock, flags);
-
-	return 0;
-}
-
-static int tnetv107x_gpio_get(struct gpio_chip *chip, unsigned offset)
-{
-	struct davinci_gpio_controller *ctlr = chip2controller(chip);
-	struct tnetv107x_gpio_regs __iomem *regs = ctlr->regs;
-	unsigned gpio = chip->base + offset;
-	int ret;
-
-	ret = gpio_reg_get_bit(regs->data_in, gpio);
-
-	return ret ? 1 : 0;
-}
-
-static void tnetv107x_gpio_set(struct gpio_chip *chip,
-		unsigned offset, int value)
-{
-	struct davinci_gpio_controller *ctlr = chip2controller(chip);
-	struct tnetv107x_gpio_regs __iomem *regs = ctlr->regs;
-	unsigned gpio = chip->base + offset;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctlr->lock, flags);
-
-	if (value)
-		gpio_reg_set_bit(regs->data_out, gpio);
-	else
-		gpio_reg_clear_bit(regs->data_out, gpio);
-
-	spin_unlock_irqrestore(&ctlr->lock, flags);
-}
-
-static int __init tnetv107x_gpio_setup(void)
-{
-	int i, base;
-	unsigned ngpio;
-	struct davinci_soc_info *soc_info = &davinci_soc_info;
-	struct tnetv107x_gpio_regs *regs;
-	struct davinci_gpio_controller *ctlr;
-
-	if (soc_info->gpio_type != GPIO_TYPE_TNETV107X)
-		return 0;
-
-	ngpio = soc_info->gpio_num;
-	if (ngpio == 0) {
-		pr_err("GPIO setup:  how many GPIOs?\n");
-		return -EINVAL;
-	}
-
-	if (WARN_ON(TNETV107X_N_GPIO < ngpio))
-		ngpio = TNETV107X_N_GPIO;
-
-	regs = ioremap(soc_info->gpio_base, SZ_4K);
-	if (WARN_ON(!regs))
-		return -EINVAL;
-
-	for (i = 0, base = 0; base < ngpio; i++, base += 32) {
-		ctlr = &chips[i];
-
-		ctlr->chip.label	= "tnetv107x";
-		ctlr->chip.can_sleep	= 0;
-		ctlr->chip.base		= base;
-		ctlr->chip.ngpio	= ngpio - base;
-		if (ctlr->chip.ngpio > 32)
-			ctlr->chip.ngpio = 32;
-
-		ctlr->chip.request		= tnetv107x_gpio_request;
-		ctlr->chip.free			= tnetv107x_gpio_free;
-		ctlr->chip.direction_input	= tnetv107x_gpio_dir_in;
-		ctlr->chip.get			= tnetv107x_gpio_get;
-		ctlr->chip.direction_output	= tnetv107x_gpio_dir_out;
-		ctlr->chip.set			= tnetv107x_gpio_set;
-
-		spin_lock_init(&ctlr->lock);
-
-		ctlr->regs	= regs;
-		ctlr->set_data	= &regs->data_out[i];
-		ctlr->clr_data	= &regs->data_out[i];
-		ctlr->in_data	= &regs->data_in[i];
-
-		gpiochip_add(&ctlr->chip);
-	}
-
-	soc_info->gpio_ctlrs = chips;
-	soc_info->gpio_ctlrs_num = DIV_ROUND_UP(ngpio, 32);
-	return 0;
-}
-pure_initcall(tnetv107x_gpio_setup);
diff --git a/arch/arm/mach-davinci/tnetv107x.c b/arch/arm/mach-davinci/tnetv107x.c
index 1b28fdd..11399d4 100644
--- a/arch/arm/mach-davinci/tnetv107x.c
+++ b/arch/arm/mach-davinci/tnetv107x.c
@@ -39,7 +39,6 @@
 #define TNETV107X_TIMER0_BASE			0x08086500
 #define TNETV107X_TIMER1_BASE			0x08086600
 #define TNETV107X_CHIP_CFG_BASE			0x08087000
-#define TNETV107X_GPIO_BASE			0x08088000
 #define TNETV107X_CLOCK_CONTROL_BASE		0x0808a000
 #define TNETV107X_PSC_BASE			0x0808b000
 
@@ -746,9 +745,7 @@ static struct davinci_soc_info tnetv107x_soc_info = {
 	.intc_irq_prios		= irq_prios,
 	.intc_irq_num		= TNETV107X_N_CP_INTC_IRQ,
 	.intc_host_map		= intc_host_map,
-	.gpio_base		= TNETV107X_GPIO_BASE,
 	.gpio_type		= GPIO_TYPE_TNETV107X,
-	.gpio_num		= TNETV107X_N_GPIO,
 	.timer_info		= &timer_info,
 	.serial_dev		= &tnetv107x_serial_device,
 	.reset			= tnetv107x_watchdog_reset,
-- 
1.7.3.2

