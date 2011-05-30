Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab1E3OoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:44:22 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:61439 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab1E3OoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:44:20 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 1/4] gpio: gpio-mxc: add gpio driver for Freescale MXC architecture
Date: Mon, 30 May 2011 22:52:16 +0800
Message-Id: <1306767139-24763-2-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org>
References: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpio-mxc driver by copying arch/arm/plat-mxc/gpio.c into
drivers/gpio with the following changes.

 * Use readl/writel to replace mach-specific accessors
   __raw_readl/__raw_writel

 * Migrate to platform driver by adding .probe function

 * Add a list to save all mx2 ports references, so that
   mx2_gpio_irq_handler can walk through all interrupt status
   registers

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/plat-mxc/include/mach/gpio.h |    2 +
 drivers/gpio/Makefile                 |    1 +
 drivers/gpio/gpio-mxc.c               |  423 +++++++++++++++++++++++++++++++++
 3 files changed, 426 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-mxc.c

diff --git a/arch/arm/plat-mxc/include/mach/gpio.h b/arch/arm/plat-mxc/include/mach/gpio.h
index a2747f1..87bd4ef 100644
--- a/arch/arm/plat-mxc/include/mach/gpio.h
+++ b/arch/arm/plat-mxc/include/mach/gpio.h
@@ -37,7 +37,9 @@
 #define irq_to_gpio(irq)	((irq) - MXC_GPIO_IRQ_START)
 
 struct mxc_gpio_port {
+	struct list_head node;
 	void __iomem *base;
+	int id;
 	int irq;
 	int irq_high;
 	int virtual_irq_start;
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index b605f8e..060eb79 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -47,4 +47,5 @@ obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
 obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
 obj-$(CONFIG_AB8500_GPIO)       += ab8500-gpio.o
+obj-$(CONFIG_ARCH_MXC)		+= gpio-mxc.o
 obj-$(CONFIG_GPIO_TPS65910)	+= tps65910-gpio.o
diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
new file mode 100644
index 0000000..df3df3f
--- /dev/null
+++ b/drivers/gpio/gpio-mxc.c
@@ -0,0 +1,423 @@
+/*
+ * MXC GPIO support. (c) 2008 Daniel Mack <daniel@caiaq.de>
+ * Copyright 2008 Juergen Beisert, kernel@pengutronix.de
+ *
+ * Based on code from Freescale,
+ * Copyright (C) 2004-2010 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <mach/hardware.h>
+#include <asm-generic/bug.h>
+
+/*
+ * MX2 has one interrupt *for all* gpio ports. The list is used
+ * to save the references to all ports, so that mx2_gpio_irq_handler
+ * can walk through all interrupt status registers.
+ */
+static LIST_HEAD(mxc_gpio_ports);
+
+#define cpu_is_mx1_mx2()	(cpu_is_mx1() || cpu_is_mx2())
+
+#define GPIO_DR		(cpu_is_mx1_mx2() ? 0x1c : 0x00)
+#define GPIO_GDIR	(cpu_is_mx1_mx2() ? 0x00 : 0x04)
+#define GPIO_PSR	(cpu_is_mx1_mx2() ? 0x24 : 0x08)
+#define GPIO_ICR1	(cpu_is_mx1_mx2() ? 0x28 : 0x0C)
+#define GPIO_ICR2	(cpu_is_mx1_mx2() ? 0x2C : 0x10)
+#define GPIO_IMR	(cpu_is_mx1_mx2() ? 0x30 : 0x14)
+#define GPIO_ISR	(cpu_is_mx1_mx2() ? 0x34 : 0x18)
+
+#define GPIO_INT_LOW_LEV	(cpu_is_mx1_mx2() ? 0x3 : 0x0)
+#define GPIO_INT_HIGH_LEV	(cpu_is_mx1_mx2() ? 0x2 : 0x1)
+#define GPIO_INT_RISE_EDGE	(cpu_is_mx1_mx2() ? 0x0 : 0x2)
+#define GPIO_INT_FALL_EDGE	(cpu_is_mx1_mx2() ? 0x1 : 0x3)
+#define GPIO_INT_NONE		0x4
+
+/* Note: This driver assumes 32 GPIOs are handled in one register */
+
+static void _clear_gpio_irqstatus(struct mxc_gpio_port *port, u32 index)
+{
+	writel(1 << index, port->base + GPIO_ISR);
+}
+
+static void _set_gpio_irqenable(struct mxc_gpio_port *port, u32 index,
+				int enable)
+{
+	u32 l;
+
+	l = readl(port->base + GPIO_IMR);
+	l = (l & (~(1 << index))) | (!!enable << index);
+	writel(l, port->base + GPIO_IMR);
+}
+
+static void gpio_ack_irq(struct irq_data *d)
+{
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
+	u32 gpio = irq_to_gpio(d->irq);
+	_clear_gpio_irqstatus(port, gpio & 0x1f);
+}
+
+static void gpio_mask_irq(struct irq_data *d)
+{
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
+	u32 gpio = irq_to_gpio(d->irq);
+	_set_gpio_irqenable(port, gpio & 0x1f, 0);
+}
+
+static void gpio_unmask_irq(struct irq_data *d)
+{
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
+	u32 gpio = irq_to_gpio(d->irq);
+	_set_gpio_irqenable(port, gpio & 0x1f, 1);
+}
+
+static int mxc_gpio_get(struct gpio_chip *chip, unsigned offset);
+
+static int gpio_set_irq_type(struct irq_data *d, u32 type)
+{
+	u32 gpio = irq_to_gpio(d->irq);
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
+	u32 bit, val;
+	int edge;
+	void __iomem *reg = port->base;
+
+	port->both_edges &= ~(1 << (gpio & 31));
+	switch (type) {
+	case IRQ_TYPE_EDGE_RISING:
+		edge = GPIO_INT_RISE_EDGE;
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		edge = GPIO_INT_FALL_EDGE;
+		break;
+	case IRQ_TYPE_EDGE_BOTH:
+		val = mxc_gpio_get(&port->chip, gpio & 31);
+		if (val) {
+			edge = GPIO_INT_LOW_LEV;
+			pr_debug("mxc: set GPIO %d to low trigger\n", gpio);
+		} else {
+			edge = GPIO_INT_HIGH_LEV;
+			pr_debug("mxc: set GPIO %d to high trigger\n", gpio);
+		}
+		port->both_edges |= 1 << (gpio & 31);
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		edge = GPIO_INT_LOW_LEV;
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+		edge = GPIO_INT_HIGH_LEV;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	reg += GPIO_ICR1 + ((gpio & 0x10) >> 2); /* lower or upper register */
+	bit = gpio & 0xf;
+	val = readl(reg) & ~(0x3 << (bit << 1));
+	writel(val | (edge << (bit << 1)), reg);
+	_clear_gpio_irqstatus(port, gpio & 0x1f);
+
+	return 0;
+}
+
+static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
+{
+	void __iomem *reg = port->base;
+	u32 bit, val;
+	int edge;
+
+	reg += GPIO_ICR1 + ((gpio & 0x10) >> 2); /* lower or upper register */
+	bit = gpio & 0xf;
+	val = readl(reg);
+	edge = (val >> (bit << 1)) & 3;
+	val &= ~(0x3 << (bit << 1));
+	if (edge == GPIO_INT_HIGH_LEV) {
+		edge = GPIO_INT_LOW_LEV;
+		pr_debug("mxc: switch GPIO %d to low trigger\n", gpio);
+	} else if (edge == GPIO_INT_LOW_LEV) {
+		edge = GPIO_INT_HIGH_LEV;
+		pr_debug("mxc: switch GPIO %d to high trigger\n", gpio);
+	} else {
+		pr_err("mxc: invalid configuration for GPIO %d: %x\n",
+		       gpio, edge);
+		return;
+	}
+	writel(val | (edge << (bit << 1)), reg);
+}
+
+/* handle 32 interrupts in one status register */
+static void mxc_gpio_irq_handler(struct mxc_gpio_port *port, u32 irq_stat)
+{
+	u32 gpio_irq_no_base = port->virtual_irq_start;
+
+	while (irq_stat != 0) {
+		int irqoffset = fls(irq_stat) - 1;
+
+		if (port->both_edges & (1 << irqoffset))
+			mxc_flip_edge(port, irqoffset);
+
+		generic_handle_irq(gpio_irq_no_base + irqoffset);
+
+		irq_stat &= ~(1 << irqoffset);
+	}
+}
+
+/* MX1 and MX3 has one interrupt *per* gpio port */
+static void mx3_gpio_irq_handler(u32 irq, struct irq_desc *desc)
+{
+	u32 irq_stat;
+	struct mxc_gpio_port *port = irq_get_handler_data(irq);
+
+	irq_stat = readl(port->base + GPIO_ISR) & readl(port->base + GPIO_IMR);
+
+	mxc_gpio_irq_handler(port, irq_stat);
+}
+
+/* MX2 has one interrupt *for all* gpio ports */
+static void mx2_gpio_irq_handler(u32 irq, struct irq_desc *desc)
+{
+	u32 irq_msk, irq_stat;
+	struct mxc_gpio_port *port;
+
+	/* walk through all interrupt status registers */
+	list_for_each_entry(port, &mxc_gpio_ports, node) {
+		irq_msk = readl(port->base + GPIO_IMR);
+		if (!irq_msk)
+			continue;
+
+		irq_stat =readl(port->base + GPIO_ISR) & irq_msk;
+		if (irq_stat)
+			mxc_gpio_irq_handler(port, irq_stat);
+	}
+}
+
+/*
+ * Set interrupt number "irq" in the GPIO as a wake-up source.
+ * While system is running, all registered GPIO interrupts need to have
+ * wake-up enabled. When system is suspended, only selected GPIO interrupts
+ * need to have wake-up enabled.
+ * @param  irq          interrupt source number
+ * @param  enable       enable as wake-up if equal to non-zero
+ * @return       This function returns 0 on success.
+ */
+static int gpio_set_wake_irq(struct irq_data *d, u32 enable)
+{
+	u32 gpio = irq_to_gpio(d->irq);
+	u32 gpio_idx = gpio & 0x1F;
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
+
+	if (enable) {
+		if (port->irq_high && (gpio_idx >= 16))
+			enable_irq_wake(port->irq_high);
+		else
+			enable_irq_wake(port->irq);
+	} else {
+		if (port->irq_high && (gpio_idx >= 16))
+			disable_irq_wake(port->irq_high);
+		else
+			disable_irq_wake(port->irq);
+	}
+
+	return 0;
+}
+
+static struct irq_chip gpio_irq_chip = {
+	.name = "GPIO",
+	.irq_ack = gpio_ack_irq,
+	.irq_mask = gpio_mask_irq,
+	.irq_unmask = gpio_unmask_irq,
+	.irq_set_type = gpio_set_irq_type,
+	.irq_set_wake = gpio_set_wake_irq,
+};
+
+static void _set_gpio_direction(struct gpio_chip *chip, unsigned offset,
+				int dir)
+{
+	struct mxc_gpio_port *port =
+		container_of(chip, struct mxc_gpio_port, chip);
+	u32 l;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	l = readl(port->base + GPIO_GDIR);
+	if (dir)
+		l |= 1 << offset;
+	else
+		l &= ~(1 << offset);
+	writel(l, port->base + GPIO_GDIR);
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static void mxc_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct mxc_gpio_port *port =
+		container_of(chip, struct mxc_gpio_port, chip);
+	void __iomem *reg = port->base + GPIO_DR;
+	u32 l;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	l = (readl(reg) & (~(1 << offset))) | (!!value << offset);
+	writel(l, reg);
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static int mxc_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct mxc_gpio_port *port =
+		container_of(chip, struct mxc_gpio_port, chip);
+
+	return (readl(port->base + GPIO_PSR) >> offset) & 1;
+}
+
+static int mxc_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	_set_gpio_direction(chip, offset, 0);
+	return 0;
+}
+
+static int mxc_gpio_direction_output(struct gpio_chip *chip,
+				     unsigned offset, int value)
+{
+	mxc_gpio_set(chip, offset, value);
+	_set_gpio_direction(chip, offset, 1);
+	return 0;
+}
+
+/*
+ * This lock class tells lockdep that GPIO irqs are in a different
+ * category than their parents, so it won't report false recursion.
+ */
+static struct lock_class_key gpio_lock_class;
+
+static int __devinit mxc_gpio_probe(struct platform_device *pdev)
+{
+	struct mxc_gpio_port *port;
+	struct resource *iores;
+	int err, i;
+
+	port = kzalloc(sizeof(struct mxc_gpio_port), GFP_KERNEL);
+	if (!port)
+		return -ENOMEM;
+
+	port->id = pdev->id;
+	port->virtual_irq_start = MXC_GPIO_IRQ_START + port->id * 32;
+
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iores) {
+		err = -ENODEV;
+		goto out_kfree;
+	}
+
+	if (!request_mem_region(iores->start, resource_size(iores),
+				pdev->name)) {
+		err = -EBUSY;
+		goto out_kfree;
+	}
+
+	port->base = ioremap(iores->start, resource_size(iores));
+	if (!port->base) {
+		err = -ENOMEM;
+		goto out_release_mem;
+	}
+
+	port->irq_high = platform_get_irq(pdev, 1);
+	port->irq = platform_get_irq(pdev, 0);
+	if (port->irq < 0) {
+		err = -EINVAL;
+		goto out_iounmap;
+	}
+
+	/* disable the interrupt and clear the status */
+	writel(0, port->base + GPIO_IMR);
+	writel(~0, port->base + GPIO_ISR);
+
+	for (i = port->virtual_irq_start;
+		i < port->virtual_irq_start + 32; i++) {
+		irq_set_lockdep_class(i, &gpio_lock_class);
+		irq_set_chip_and_handler(i, &gpio_irq_chip, handle_level_irq);
+		set_irq_flags(i, IRQF_VALID);
+		irq_set_chip_data(i, port);
+	}
+
+	if (cpu_is_mx2()) {
+		/* setup one handler for all GPIO interrupts */
+		if (port->id == 0)
+			irq_set_chained_handler(port->irq,
+						mx2_gpio_irq_handler);
+	} else {
+		/* setup one handler for each entry */
+		irq_set_chained_handler(port->irq, mx3_gpio_irq_handler);
+		irq_set_handler_data(port->irq, port);
+		if (port->irq_high > 0) {
+			/* setup handler for GPIO 16 to 31 */
+			irq_set_chained_handler(port->irq_high,
+						mx3_gpio_irq_handler);
+			irq_set_handler_data(port->irq_high, port);
+		}
+	}
+
+	/* register gpio chip */
+	port->chip.direction_input = mxc_gpio_direction_input;
+	port->chip.direction_output = mxc_gpio_direction_output;
+	port->chip.get = mxc_gpio_get;
+	port->chip.set = mxc_gpio_set;
+	port->chip.base = port->id * 32;
+	port->chip.ngpio = 32;
+
+	spin_lock_init(&port->lock);
+
+	err = gpiochip_add(&port->chip);
+	if (err)
+		goto out_iounmap;
+
+	list_add_tail(&port->node, &mxc_gpio_ports);
+
+	return 0;
+
+out_iounmap:
+	iounmap(port->base);
+out_release_mem:
+	release_mem_region(iores->start, resource_size(iores));
+out_kfree:
+	kfree(port);
+	dev_info(&pdev->dev, "%s failed with errno %d\n", __func__, err);
+	return err;
+}
+
+static struct platform_driver mxc_gpio_driver = {
+	.driver		= {
+		.name	= "gpio-mxc",
+	},
+	.probe		= mxc_gpio_probe,
+};
+
+static int __init gpio_mxc_init(void)
+{
+	return platform_driver_register(&mxc_gpio_driver);
+}
+postcore_initcall(gpio_mxc_init);
+
+MODULE_AUTHOR("Freescale Semiconductor, "
+	      "Daniel Mack <danielncaiaq.de>, "
+	      "Juergen Beisert <kernel@pengutronix.de>");
+MODULE_DESCRIPTION("Freescale MXC GPIO");
+MODULE_LICENSE("GPL");
-- 
1.7.4.1

