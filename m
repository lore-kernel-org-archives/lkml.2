Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab1DANr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 09:47:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49266 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab1DANrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 09:47:25 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] gpio: support for Synopsys DesignWare APB GPIO
Date: Fri,  1 Apr 2011 14:47:18 +0100
Message-Id: <1301665638-29841-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the Synopsys DesignWare APB GPIO controller
that can be found in some ARM systems.  The controller supports up to
4x32 bit ports and port A is capable of raising interrupts.

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/gpio/Kconfig                  |    8 +
 drivers/gpio/Makefile                 |    1 +
 drivers/gpio/dw_gpio.c                |  573 +++++++++++++++++++++++++++++++++
 include/linux/platform_data/dw_gpio.h |   24 ++
 4 files changed, 606 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/dw_gpio.c
 create mode 100644 include/linux/platform_data/dw_gpio.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d3b2953..135d996 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -131,6 +131,14 @@ config GPIO_VX855
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
+config GPIO_DW
+	bool "Synopsys DesignWare APB GPIO controller"
+	depends on GPIOLIB
+	help
+	  Say M here to build support for the Synopsys DesignWare APB
+	  GPIO controller found in some ARM systems.  This GPIO controller
+	  supports upto 4 ports of GPIO and GPIO interrupts on port A.
+
 comment "I2C GPIO expanders:"
 
 config GPIO_MAX7300
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index becef59..377d8b9 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -43,3 +43,4 @@ obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
 obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
 obj-$(CONFIG_AB8500_GPIO)       += ab8500-gpio.o
+obj-$(CONFIG_GPIO_DW)		+= dw_gpio.o
diff --git a/drivers/gpio/dw_gpio.c b/drivers/gpio/dw_gpio.c
new file mode 100644
index 0000000..1a474df
--- /dev/null
+++ b/drivers/gpio/dw_gpio.c
@@ -0,0 +1,573 @@
+/*
+ * Driver for the Synopsys DesignWare GPIO Controller.
+ *
+ * Copyright (C) 2011 Picochip Ltd, Jamie Iles
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/gpio.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/dw_gpio.h>
+
+struct dw_gpio_chip {
+	struct gpio_chip	chip;
+	void __iomem		*iobase;
+	int			porta_end;
+	int			portb_end;
+	int			portc_end;
+	int			portd_end;
+	int			irq_base;
+	int			nr_irq;
+	spinlock_t		lock;
+};
+
+static inline struct dw_gpio_chip *to_dw_gpio_chip(struct gpio_chip *chip)
+{
+	return container_of(chip, struct dw_gpio_chip, chip);
+}
+
+#define GPIO_SW_PORT_A_DR_REG_OFFSET		0x00
+#define GPIO_SW_PORT_A_DDR_REG_OFFSET		0x04
+#define GPIO_SW_PORT_A_CTL_REG_OFFSET		0x08
+#define GPIO_SW_PORT_B_DR_REG_OFFSET		0x0C
+#define GPIO_SW_PORT_B_DDR_REG_OFFSET		0x10
+#define GPIO_SW_PORT_B_CTL_REG_OFFSET		0x14
+#define GPIO_SW_PORT_C_DR_REG_OFFSET		0x18
+#define GPIO_SW_PORT_C_DDR_REG_OFFSET		0x1C
+#define GPIO_SW_PORT_C_CTL_REG_OFFSET		0x20
+#define GPIO_SW_PORT_D_DR_REG_OFFSET		0x24
+#define GPIO_SW_PORT_D_DDR_REG_OFFSET		0x28
+#define GPIO_SW_PORT_D_CTL_REG_OFFSET		0x2C
+
+#define GPIO_INT_EN_REG_OFFSET			0x30
+#define GPIO_INT_MASK_REG_OFFSET		0x34
+#define GPIO_INT_TYPE_LEVEL_REG_OFFSET		0x38
+#define GPIO_INT_POLARITY_REG_OFFSET		0x3c
+#define GPIO_INT_STATUS_REG_OFFSET		0x40
+#define GPIO_PORT_A_EOI_REG_OFFSET		0x4c
+
+#define GPIO_SW_PORT_A_EXT_REG_OFFSET		0x50
+#define GPIO_SW_PORT_B_EXT_REG_OFFSET		0x54
+#define GPIO_SW_PORT_C_EXT_REG_OFFSET		0x58
+#define GPIO_SW_PORT_D_EXT_REG_OFFSET		0x5C
+
+#define GPIO_CFG1_REG_OFFSET		0x74
+#define GPIO_NR_PORTS_SHIFT		2
+#define GPIO_NR_PORTS_MASK		(0x3 << GPIO_NR_PORTS_SHIFT)
+
+#define GPIO_CFG2_REG_OFFSET		0x70
+#define GPIO_PORTA_WIDTH_SHIFT		0
+#define GPIO_PORTA_WIDTH_MASK		(0x1F << GPIO_PORTA_WIDTH_SHIFT)
+#define GPIO_PORTB_WIDTH_SHIFT		5
+#define GPIO_PORTB_WIDTH_MASK		(0x1F << GPIO_PORTB_WIDTH_SHIFT)
+#define GPIO_PORTC_WIDTH_SHIFT		10
+#define GPIO_PORTC_WIDTH_MASK		(0x1F << GPIO_PORTC_WIDTH_SHIFT)
+#define GPIO_PORTD_WIDTH_SHIFT		15
+#define GPIO_PORTD_WIDTH_MASK		(0x1F << GPIO_PORTD_WIDTH_SHIFT)
+
+/*
+ * Get the port mapping for the controller.  There are 4 possible ports that
+ * we can use but some platforms may reserve ports for hardware purposes that
+ * cannot be used as GPIO so we allow these to be masked off.
+ */
+static void dw_gpio_configure_ports(struct dw_gpio_chip *dw,
+				    unsigned long port_mask)
+{
+	unsigned long cfg1, cfg2;
+	int nr_ports;
+
+	cfg1 = readl(dw->iobase + GPIO_CFG1_REG_OFFSET);
+	cfg2 = readl(dw->iobase + GPIO_CFG2_REG_OFFSET);
+
+	nr_ports = (cfg1 & GPIO_NR_PORTS_MASK) >> GPIO_NR_PORTS_SHIFT;
+
+	if (port_mask & DW_GPIO_PORTA_MASK) {
+		dw->porta_end = ((cfg2 & GPIO_PORTA_WIDTH_MASK) >>
+				 GPIO_PORTA_WIDTH_SHIFT) + 1;
+		if (nr_ports == 1)
+			return;
+	} else
+		dw->porta_end = 0;
+
+	if (port_mask & DW_GPIO_PORTB_MASK) {
+		dw->portb_end = ((cfg2 & GPIO_PORTB_WIDTH_MASK) >>
+				 GPIO_PORTB_WIDTH_SHIFT) + 1 + dw->porta_end;
+		if (nr_ports == 2)
+			return;
+	} else
+		dw->portb_end = dw->porta_end;
+
+	if (port_mask & DW_GPIO_PORTC_MASK) {
+		dw->portc_end = ((cfg2 & GPIO_PORTC_WIDTH_MASK) >>
+				 GPIO_PORTC_WIDTH_SHIFT) + 1 + dw->portb_end;
+		if (nr_ports == 3)
+			return;
+	} else
+		dw->portc_end = dw->portb_end;
+
+	if (port_mask & DW_GPIO_PORTD_MASK)
+		dw->portd_end = ((cfg2 & GPIO_PORTD_WIDTH_MASK) >>
+				 GPIO_PORTD_WIDTH_SHIFT) + 1 + dw->portc_end;
+	else
+		dw->portd_end = dw->portb_end;
+}
+
+#define __DWGPIO_REG(__chip, __gpio_nr, __reg)				\
+	({								\
+		void __iomem *ret = NULL;				\
+		if ((__gpio_nr) <= (__chip)->porta_end)			\
+			ret = ((__chip)->iobase +			\
+				GPIO_SW_PORT_A_##__reg##_REG_OFFSET);	\
+		else if ((__gpio_nr) <= (__chip)->portb_end)		\
+			ret = ((__chip)->iobase +			\
+				GPIO_SW_PORT_B_##__reg##_REG_OFFSET);	\
+		else if ((__gpio_nr) <= (__chip)->portc_end)		\
+			ret = ((__chip)->iobase +			\
+				GPIO_SW_PORT_C_##__reg##_REG_OFFSET);	\
+		else							\
+			ret = ((__chip)->iobase +			\
+				GPIO_SW_PORT_D_##__reg##_REG_OFFSET);	\
+		ret;							\
+	})
+
+#define DWGPIO_DR(__chip, __gpio_nr)	__DWGPIO_REG((__chip), \
+						     (__gpio_nr), DR)
+#define DWGPIO_DDR(__chip, __gpio_nr)	__DWGPIO_REG((__chip), \
+						     (__gpio_nr), DDR)
+#define DWGPIO_CTL(__chip, __gpio_nr)	__DWGPIO_REG((__chip), \
+						     (__gpio_nr), CTL)
+#define DWGPIO_EXT(__chip, __gpio_nr)	__DWGPIO_REG((__chip), \
+						     (__gpio_nr), EXT)
+#define INT_EN_REG(__chip)		((__chip)->iobase + \
+					 GPIO_INT_EN_REG_OFFSET)
+#define INT_MASK_REG(__chip)		((__chip)->iobase + \
+					 GPIO_INT_MASK_REG_OFFSET)
+#define INT_TYPE_REG(__chip)		((__chip)->iobase + \
+					 GPIO_INT_TYPE_LEVEL_REG_OFFSET)
+#define INT_POLARITY_REG(__chip)	((__chip)->iobase + \
+					 GPIO_INT_POLARITY_REG_OFFSET)
+#define INT_STATUS_REG(__chip)		((__chip)->iobase + \
+					 GPIO_INT_STATUS_REG_OFFSET)
+#define EOI_REG(__chip)			((__chip)->iobase + \
+					 GPIO_PORT_A_EOI_REG_OFFSET)
+
+static inline unsigned dw_gpio_bit_offs(struct dw_gpio_chip *dw,
+					unsigned offset)
+{
+	/*
+	 * The gpios are controlled via three sets of registers. The register
+	 * addressing is already taken care of by the __DWGPIO_REG macro,
+	 * this takes care of the bit offsets within each register.
+	 */
+	if (offset <= dw->porta_end)
+		return offset;
+	else if (offset <= dw->portb_end)
+		return offset - dw->porta_end;
+	else if (offset <= dw->portc_end)
+		return offset - dw->portb_end;
+	else
+		return offset - dw->portc_end;
+}
+
+static int dwgpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct dw_gpio_chip *dw = to_dw_gpio_chip(chip);
+	void __iomem *ddr = DWGPIO_DDR(dw, offset);
+	void __iomem *cr = DWGPIO_CTL(dw, offset);
+	unsigned long flags, val, bit_offset = dw_gpio_bit_offs(dw, offset);
+
+	spin_lock_irqsave(&dw->lock, flags);
+	/* Mark the pin as an output. */
+	val = readl(ddr);
+	val &= ~(1 << bit_offset);
+	writel(val, ddr);
+
+	/* Set the pin as software controlled. */
+	val = readl(cr);
+	val &= ~(1 << bit_offset);
+	writel(val, cr);
+	spin_unlock_irqrestore(&dw->lock, flags);
+
+	return 0;
+}
+
+static int dwgpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct dw_gpio_chip *dw = to_dw_gpio_chip(chip);
+	void __iomem *ext = DWGPIO_EXT(dw, offset);
+	unsigned long bit_offset = dw_gpio_bit_offs(dw, offset);
+
+	return !!(readl(ext) & (1 << bit_offset));
+}
+
+static void dwgpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct dw_gpio_chip *dw = to_dw_gpio_chip(chip);
+	void __iomem *dr = DWGPIO_DR(dw, offset);
+	unsigned long val, flags, bit_offset = dw_gpio_bit_offs(dw, offset);
+
+	spin_lock_irqsave(&dw->lock, flags);
+	val = readl(dr);
+	val &= ~(1 << bit_offset);
+	val |= (!!value << bit_offset);
+	writel(val, dr);
+	spin_unlock_irqrestore(&dw->lock, flags);
+}
+
+static int dwgpio_direction_output(struct gpio_chip *chip, unsigned offset,
+				    int value)
+{
+	struct dw_gpio_chip *dw = to_dw_gpio_chip(chip);
+	void __iomem *ddr = DWGPIO_DDR(dw, offset);
+	void __iomem *cr = DWGPIO_CTL(dw, offset);
+	unsigned long flags, val, bit_offset = dw_gpio_bit_offs(dw, offset);
+
+	/* Set the value first so we don't glitch. */
+	dwgpio_set(chip, offset, value);
+
+	spin_lock_irqsave(&dw->lock, flags);
+	/* Mark the pin as an output. */
+	val = readl(ddr);
+	val |= (1 << bit_offset);
+	writel(val, ddr);
+
+	/* Set the pin as software controlled. */
+	val = readl(cr);
+	val &= ~(1 << bit_offset);
+	writel(val, cr);
+	spin_unlock_irqrestore(&dw->lock, flags);
+
+	return 0;
+}
+
+static int dwgpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct dw_gpio_chip *dw = to_dw_gpio_chip(chip);
+
+	return dw->nr_irq && offset < dw->nr_irq ? dw->irq_base + offset :
+		-EINVAL;
+}
+
+static void dwgpio_irq_enable(struct irq_data *d)
+{
+	int gpio = irq_to_gpio(d->irq);
+	struct dw_gpio_chip *dw = irq_data_get_irq_chip_data(d);
+	void *port_inten = INT_EN_REG(dw);
+	unsigned long val, flags;
+
+	spin_lock_irqsave(&dw->lock, flags);
+	val = readl(port_inten);
+	val |= (1 << gpio);
+	writel(val, port_inten);
+	spin_unlock_irqrestore(&dw->lock, flags);
+}
+
+static void dwgpio_irq_disable(struct irq_data *d)
+{
+	int gpio = irq_to_gpio(d->irq);
+	struct dw_gpio_chip *dw = irq_data_get_irq_chip_data(d);
+	void __iomem *port_inten = INT_EN_REG(dw);
+	unsigned long val, flags;
+
+	spin_lock_irqsave(&dw->lock, flags);
+	val = readl(port_inten);
+	val &= ~(1 << gpio);
+	writel(val, port_inten);
+	spin_unlock_irqrestore(&dw->lock, flags);
+}
+
+static void dwgpio_irq_mask(struct irq_data *d)
+{
+	int gpio = irq_to_gpio(d->irq);
+	struct dw_gpio_chip *dw = irq_data_get_irq_chip_data(d);
+	void __iomem *port_mask = INT_MASK_REG(dw);
+	unsigned long val, flags;
+
+	spin_lock_irqsave(&dw->lock, flags);
+	val = readl(port_mask);
+	val |= (1 << gpio);
+	writel(val, port_mask);
+	spin_unlock_irqrestore(&dw->lock, flags);
+}
+
+static void dwgpio_irq_ack(struct irq_data *d)
+{
+	int gpio = irq_to_gpio(d->irq);
+	struct dw_gpio_chip *dw = irq_data_get_irq_chip_data(d);
+	void __iomem *port_intmask = INT_MASK_REG(dw);
+	void __iomem *port_eoi = EOI_REG(dw);
+	void __iomem *port_inttype_level = INT_TYPE_REG(dw);
+	unsigned long val, flags;
+
+	spin_lock_irqsave(&dw->lock, flags);
+	val = readl(port_inttype_level);
+	if (val & (1 << gpio)) {
+		/* Edge-sensitive */
+		val = readl(port_eoi);
+		val |= (1 << gpio);
+		writel(val, port_eoi);
+	} else {
+		/* Level-sensitive */
+		val = readl(port_intmask);
+		val |= (1 << gpio);
+		writel(val, port_intmask);
+	}
+	spin_unlock_irqrestore(&dw->lock, flags);
+}
+
+static void dwgpio_irq_unmask(struct irq_data *d)
+{
+	struct dw_gpio_chip *dw = irq_data_get_irq_chip_data(d);
+	int gpio = irq_to_gpio(d->irq);
+	void __iomem *port_intmask = INT_MASK_REG(dw);
+	unsigned long val, flags;
+
+	spin_lock_irqsave(&dw->lock, flags);
+	val = readl(port_intmask);
+	val &= ~(1 << gpio);
+	writel(val, port_intmask);
+	spin_unlock_irqrestore(&dw->lock, flags);
+}
+
+static int dwgpio_irq_set_type(struct irq_data *d,
+			       unsigned int trigger)
+{
+	int gpio = irq_to_gpio(d->irq);
+	struct dw_gpio_chip *dw = irq_data_get_irq_chip_data(d);
+	void __iomem *port_inttype_level = INT_TYPE_REG(dw);
+	void __iomem *port_int_polarity = INT_POLARITY_REG(dw);
+	unsigned long level, polarity, flags;
+
+	if (trigger & ~(IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
+			IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
+		return -EINVAL;
+
+	spin_lock_irqsave(&dw->lock, flags);
+	level = readl(port_inttype_level);
+	polarity = readl(port_int_polarity);
+
+	if (trigger & IRQ_TYPE_EDGE_RISING) {
+		level	    |= (1 << gpio);
+		polarity    |= (1 << gpio);
+	} else if (trigger & IRQ_TYPE_EDGE_FALLING) {
+		level	    |= (1 << gpio);
+		polarity    &= ~(1 << gpio);
+	} else if (trigger & IRQ_TYPE_LEVEL_HIGH) {
+		level	    &= ~(1 << gpio);
+		polarity    |= (1 << gpio);
+	} else if (trigger & IRQ_TYPE_LEVEL_LOW) {
+		level	    &= ~(1 << gpio);
+		polarity    &= ~(1 << gpio);
+	}
+
+	writel(level, port_inttype_level);
+	writel(polarity, port_int_polarity);
+	spin_unlock_irqrestore(&dw->lock, flags);
+
+	return 0;
+}
+
+static struct irq_chip dwgpio_irqchip = {
+	.name		= "dwgpio",
+	.irq_ack	= dwgpio_irq_ack,
+	.irq_mask	= dwgpio_irq_mask,
+	.irq_unmask	= dwgpio_irq_unmask,
+	.irq_enable	= dwgpio_irq_enable,
+	.irq_disable	= dwgpio_irq_disable,
+	.irq_set_type	= dwgpio_irq_set_type,
+};
+
+static void dw_gpio_irq_handler(unsigned irq, struct irq_desc *desc)
+{
+	struct dw_gpio_chip *dw = irq_get_handler_data(irq);
+	int i;
+
+	/*
+	 * Mask and ack the interrupt in the parent interrupt controller
+	 * before handling it.
+	 */
+	desc->irq_data.chip->irq_mask(&desc->irq_data);
+	desc->irq_data.chip->irq_ack(&desc->irq_data);
+	for (;;) {
+		unsigned long status = readl(INT_STATUS_REG(dw));
+
+		if (!status)
+			break;
+		writel(status, EOI_REG(dw));
+
+		for_each_set_bit(i, &status, 8)
+			generic_handle_irq(dw->irq_base + i);
+	}
+	desc->irq_data.chip->irq_unmask(&desc->irq_data);
+}
+
+/*
+ * We want to enable/disable interrupts for the GPIO pins through the GPIO
+ * block itself.  The current configuration assumes a 1-to-1 mapping of GPIO
+ * interrupt sources to IRQ numbers.  We use a chained handler as the GPIO
+ * IRQ's may pass through a separate VIC on some systems so need to be
+ * enabled/disabled there too.
+ *
+ * The chained handler simply converts from the virtual IRQ handler to the
+ * real interrupt source and calls the GPIO IRQ handler.
+ */
+static void dwgpio_irq_init(struct dw_gpio_chip *dw,
+			    struct resource *demux_irqs,
+			    struct resource *irqs)
+{
+	int i;
+
+	if (!demux_irqs && !irqs)
+		return;
+
+	if (!demux_irqs || !irqs ||
+	    resource_size(demux_irqs) != resource_size(irqs)) {
+		dev_warn(dw->chip.dev, "unsupported IRQ demuxing configuration, continuing without GPIO IRQ support\n");
+		return;
+	}
+
+	dw->irq_base = irqs->start;
+
+	writel(0, INT_EN_REG(dw));
+	writel(~0, EOI_REG(dw));
+	for (i = irqs->start; i <= irqs->end; ++i) {
+		irq_set_chip_and_handler_name(i, &dwgpio_irqchip,
+					      handle_simple_irq, "demux");
+		irq_set_chip_data(i, dw);
+		irq_set_status_flags(i, IRQ_TYPE_EDGE_BOTH |
+					IRQ_TYPE_LEVEL_HIGH |
+					IRQ_TYPE_LEVEL_LOW);
+		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
+	}
+
+	for (i = demux_irqs->start; i <= demux_irqs->end; ++i) {
+		irq_set_handler_data(i, dw);
+		irq_set_chained_handler(i, dw_gpio_irq_handler);
+		set_irq_flags(i, IRQF_VALID);
+	}
+}
+
+static int __devinit dwgpio_probe(struct platform_device *pdev)
+{
+	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct resource *demux_irqs, *irqs;
+	struct dw_gpio_chip *dw = devm_kzalloc(&pdev->dev, sizeof(*dw),
+					       GFP_KERNEL);
+	int err;
+	struct dw_gpio_pdata *pdata = pdev->dev.platform_data;
+
+	if (!dw)
+		return -ENOMEM;
+
+	if (!mem || !pdata)
+		return -ENODEV;
+
+	if (!devm_request_mem_region(&pdev->dev, mem->start, resource_size(mem),
+				     "dwgpio"))
+		return -EBUSY;
+
+	dw->iobase = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
+	if (!dw->iobase)
+		return -ENOMEM;
+
+	dw_gpio_configure_ports(dw, pdata->port_mask);
+
+	dw->chip.direction_input	= dwgpio_direction_input;
+	dw->chip.direction_output	= dwgpio_direction_output;
+	dw->chip.get			= dwgpio_get;
+	dw->chip.set			= dwgpio_set;
+	dw->chip.to_irq			= dwgpio_to_irq;
+	dw->chip.owner			= THIS_MODULE;
+	dw->chip.base			= pdata->gpio_base;
+	dw->chip.ngpio			= pdata->ngpio;
+	dw->chip.dev			= &pdev->dev;
+	spin_lock_init(&dw->lock);
+
+	err = gpiochip_add(&dw->chip);
+	if (err) {
+		dev_err(&pdev->dev, "failed to register dwgpio chip\n");
+		return err;
+	}
+
+	demux_irqs = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	irqs = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
+	dwgpio_irq_init(dw, demux_irqs, irqs);
+	platform_set_drvdata(pdev, dw);
+
+	return 0;
+}
+
+static void dwgpio_irq_stop(struct dw_gpio_chip *dw,
+			    struct resource *demux_irqs,
+			    struct resource *irqs)
+{
+	int i;
+
+	if (!demux_irqs || !irqs ||
+	    resource_size(demux_irqs) != resource_size(irqs))
+		return;
+
+	for (i = irqs->start; i < irqs->end; ++i) {
+		irq_set_chip(i, NULL);
+		irq_set_chip_data(i, NULL);
+	}
+
+	for (i = demux_irqs->start; i < demux_irqs->end; ++i) {
+		irq_set_chip(i, NULL);
+		irq_set_chip_data(i, NULL);
+	}
+}
+
+static int __devexit dwgpio_remove(struct platform_device *pdev)
+{
+	struct resource *irqs, *demux_irqs;
+	struct dw_gpio_chip *dw = platform_get_drvdata(pdev);
+	int err;
+
+	demux_irqs = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	irqs = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
+	dwgpio_irq_stop(dw, demux_irqs, irqs);
+
+	err = gpiochip_remove(&dw->chip);
+	if (err) {
+		dev_err(&pdev->dev, "failed to remove gpio_chip\n");
+		goto out;
+	}
+
+	platform_set_drvdata(pdev, NULL);
+
+out:
+	return err;
+}
+
+static struct platform_driver dwgpio_driver = {
+	.probe		= dwgpio_probe,
+	.remove		= __devexit_p(dwgpio_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "dwgpio",
+	},
+};
+
+static int __init dwgpio_init(void)
+{
+	return platform_driver_register(&dwgpio_driver);
+}
+module_init(dwgpio_init);
+
+static void __exit dwgpio_exit(void)
+{
+	platform_driver_unregister(&dwgpio_driver);
+}
+module_exit(dwgpio_exit);
+
+MODULE_AUTHOR("Jamie Iles");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Synopsys DesignWare GPIO driver");
diff --git a/include/linux/platform_data/dw_gpio.h b/include/linux/platform_data/dw_gpio.h
new file mode 100644
index 0000000..1ec64c5
--- /dev/null
+++ b/include/linux/platform_data/dw_gpio.h
@@ -0,0 +1,24 @@
+/*
+ * Platform data for the Synopsys DesignWare GPIO Controller.
+ *
+ * Copyright (C) 2011 Picochip Ltd, Jamie Iles
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __DW_GPIO_PDATA_H__
+#define __DW_GPIO_PDATA_H__
+
+#define DW_GPIO_PORTA_MASK	(1 << 0)
+#define DW_GPIO_PORTB_MASK	(1 << 1)
+#define DW_GPIO_PORTC_MASK	(1 << 2)
+#define DW_GPIO_PORTD_MASK	(1 << 3)
+
+struct dw_gpio_pdata {
+	int		gpio_base;	/* First GPIO in the chip. */
+	int		ngpio;		/* Number of GPIO pins. */
+	unsigned long	port_mask;	/* Mask of ports to use for GPIO. */
+};
+
+#endif /* __DW_GPIO_PDATA_H__ */
-- 
1.7.4

