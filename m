Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab1E1PCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:02:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64671 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1E1PCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:02:13 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v2 1/2] gpio: gpio-mxs: add gpio driver for Freescale MXS architecture
Date: Sat, 28 May 2011 23:09:33 +0800
Message-Id: <1306595374-25178-2-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306595374-25178-1-git-send-email-shawn.guo@linaro.org>
References: <1306595374-25178-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpio-mxs driver by copying arch/arm/mach-mxs/gpio.c into
drivers/gpio with the following changes.

 * Use readl/writel to replace mach-specific accessors
   __raw_readl/__raw_writel
 * Migrate to platform driver by adding .probe function

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/gpio/Makefile   |    1 +
 drivers/gpio/gpio-mxs.c |  371 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 372 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-mxs.c

diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index d92ce3a..914331c 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -40,3 +40,4 @@ obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
 obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
 obj-$(CONFIG_AB8500_GPIO)       += ab8500-gpio.o
+obj-$(CONFIG_ARCH_MXS)		+= gpio-mxs.o
diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
new file mode 100644
index 0000000..d03da20
--- /dev/null
+++ b/drivers/gpio/gpio-mxs.c
@@ -0,0 +1,371 @@
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
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA  02110-1301, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <mach/mxs.h>
+
+struct mxs_gpio_port {
+	void __iomem *base;
+	int id;
+	int irq;
+	int irq_high;
+	int virtual_irq_start;
+	struct gpio_chip chip;
+};
+
+#define MXS_SET		0x4
+#define MXS_CLR		0x8
+
+#define PINCTRL_DOUT(n)		((cpu_is_mx23() ? 0x0500 : 0x0700) + (n) * 0x10)
+#define PINCTRL_DIN(n)		((cpu_is_mx23() ? 0x0600 : 0x0900) + (n) * 0x10)
+#define PINCTRL_DOE(n)		((cpu_is_mx23() ? 0x0700 : 0x0b00) + (n) * 0x10)
+#define PINCTRL_PIN2IRQ(n)	((cpu_is_mx23() ? 0x0800 : 0x1000) + (n) * 0x10)
+#define PINCTRL_IRQEN(n)	((cpu_is_mx23() ? 0x0900 : 0x1100) + (n) * 0x10)
+#define PINCTRL_IRQLEV(n)	((cpu_is_mx23() ? 0x0a00 : 0x1200) + (n) * 0x10)
+#define PINCTRL_IRQPOL(n)	((cpu_is_mx23() ? 0x0b00 : 0x1300) + (n) * 0x10)
+#define PINCTRL_IRQSTAT(n)	((cpu_is_mx23() ? 0x0c00 : 0x1400) + (n) * 0x10)
+
+#define GPIO_INT_FALL_EDGE	0x0
+#define GPIO_INT_LOW_LEV	0x1
+#define GPIO_INT_RISE_EDGE	0x2
+#define GPIO_INT_HIGH_LEV	0x3
+#define GPIO_INT_LEV_MASK	(1 << 0)
+#define GPIO_INT_POL_MASK	(1 << 1)
+
+/* Note: This driver assumes 32 GPIOs are handled in one register */
+
+static void clear_gpio_irqstatus(struct mxs_gpio_port *port, u32 index)
+{
+	writel(1 << index, port->base + PINCTRL_IRQSTAT(port->id) + MXS_CLR);
+}
+
+static void set_gpio_irqenable(struct mxs_gpio_port *port, u32 index,
+				int enable)
+{
+	if (enable) {
+		writel(1 << index,
+			port->base + PINCTRL_IRQEN(port->id) + MXS_SET);
+		writel(1 << index,
+			port->base + PINCTRL_PIN2IRQ(port->id) + MXS_SET);
+	} else {
+		writel(1 << index,
+			port->base + PINCTRL_IRQEN(port->id) + MXS_CLR);
+	}
+}
+
+static void mxs_gpio_ack_irq(struct irq_data *d)
+{
+	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
+	u32 gpio = irq_to_gpio(d->irq);
+	clear_gpio_irqstatus(port, gpio & 0x1f);
+}
+
+static void mxs_gpio_mask_irq(struct irq_data *d)
+{
+	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
+	u32 gpio = irq_to_gpio(d->irq);
+	set_gpio_irqenable(port, gpio & 0x1f, 0);
+}
+
+static void mxs_gpio_unmask_irq(struct irq_data *d)
+{
+	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
+	u32 gpio = irq_to_gpio(d->irq);
+	set_gpio_irqenable(port, gpio & 0x1f, 1);
+}
+
+static int mxs_gpio_get(struct gpio_chip *chip, unsigned offset);
+
+static int mxs_gpio_set_irq_type(struct irq_data *d, unsigned int type)
+{
+	u32 gpio = irq_to_gpio(d->irq);
+	u32 pin_mask = 1 << (gpio & 31);
+	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
+	void __iomem *pin_addr;
+	int edge;
+
+	switch (type) {
+	case IRQ_TYPE_EDGE_RISING:
+		edge = GPIO_INT_RISE_EDGE;
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		edge = GPIO_INT_FALL_EDGE;
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
+	/* set level or edge */
+	pin_addr = port->base + PINCTRL_IRQLEV(port->id);
+	if (edge & GPIO_INT_LEV_MASK)
+		writel(pin_mask, pin_addr + MXS_SET);
+	else
+		writel(pin_mask, pin_addr + MXS_CLR);
+
+	/* set polarity */
+	pin_addr = port->base + PINCTRL_IRQPOL(port->id);
+	if (edge & GPIO_INT_POL_MASK)
+		writel(pin_mask, pin_addr + MXS_SET);
+	else
+		writel(pin_mask, pin_addr + MXS_CLR);
+
+	clear_gpio_irqstatus(port, gpio & 0x1f);
+
+	return 0;
+}
+
+/* MXS has one interrupt *per* gpio port */
+static void mxs_gpio_irq_handler(u32 irq, struct irq_desc *desc)
+{
+	u32 irq_stat;
+	struct mxs_gpio_port *port = irq_get_handler_data(irq);
+	u32 gpio_irq_no_base = port->virtual_irq_start;
+
+	desc->irq_data.chip->irq_ack(&desc->irq_data);
+
+	irq_stat = readl(port->base + PINCTRL_IRQSTAT(port->id)) &
+			readl(port->base + PINCTRL_IRQEN(port->id));
+
+	while (irq_stat != 0) {
+		int irqoffset = fls(irq_stat) - 1;
+		generic_handle_irq(gpio_irq_no_base + irqoffset);
+		irq_stat &= ~(1 << irqoffset);
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
+static int mxs_gpio_set_wake_irq(struct irq_data *d, unsigned int enable)
+{
+	u32 gpio = irq_to_gpio(d->irq);
+	u32 gpio_idx = gpio & 0x1f;
+	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
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
+	.name = "mxs gpio",
+	.irq_ack = mxs_gpio_ack_irq,
+	.irq_mask = mxs_gpio_mask_irq,
+	.irq_unmask = mxs_gpio_unmask_irq,
+	.irq_set_type = mxs_gpio_set_irq_type,
+	.irq_set_wake = mxs_gpio_set_wake_irq,
+};
+
+static void mxs_set_gpio_direction(struct gpio_chip *chip, unsigned offset,
+				int dir)
+{
+	struct mxs_gpio_port *port =
+		container_of(chip, struct mxs_gpio_port, chip);
+	void __iomem *pin_addr = port->base + PINCTRL_DOE(port->id);
+
+	if (dir)
+		writel(1 << offset, pin_addr + MXS_SET);
+	else
+		writel(1 << offset, pin_addr + MXS_CLR);
+}
+
+static int mxs_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct mxs_gpio_port *port =
+		container_of(chip, struct mxs_gpio_port, chip);
+
+	return (readl(port->base + PINCTRL_DIN(port->id)) >> offset) & 1;
+}
+
+static void mxs_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct mxs_gpio_port *port =
+		container_of(chip, struct mxs_gpio_port, chip);
+	void __iomem *pin_addr = port->base + PINCTRL_DOUT(port->id);
+
+	if (value)
+		writel(1 << offset, pin_addr + MXS_SET);
+	else
+		writel(1 << offset, pin_addr + MXS_CLR);
+}
+
+static int mxs_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct mxs_gpio_port *port =
+		container_of(chip, struct mxs_gpio_port, chip);
+
+	return port->virtual_irq_start + offset;
+}
+
+static int mxs_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	mxs_set_gpio_direction(chip, offset, 0);
+	return 0;
+}
+
+static int mxs_gpio_direction_output(struct gpio_chip *chip,
+				     unsigned offset, int value)
+{
+	mxs_gpio_set(chip, offset, value);
+	mxs_set_gpio_direction(chip, offset, 1);
+	return 0;
+}
+
+static int __devinit mxs_gpio_probe(struct platform_device *pdev)
+{
+	static void __iomem *base;
+	struct mxs_gpio_port *port;
+	struct resource *iores = NULL;
+	int err, i;
+
+	port = kzalloc(sizeof(struct mxs_gpio_port), GFP_KERNEL);
+	if (!port)
+		return -ENOMEM;
+
+	port->id = pdev->id;
+	port->virtual_irq_start = MXS_GPIO_IRQ_START + port->id * 32;
+
+	/*
+	 * map memory region only once, as all the gpio ports
+	 * share the same one
+	 */
+	if (!base) {
+		iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		if (!iores) {
+			err = -ENODEV;
+			goto out_kfree;
+		}
+
+		if (!request_mem_region(iores->start, resource_size(iores),
+					pdev->name)) {
+			err = -EBUSY;
+			goto out_kfree;
+		}
+
+		base = ioremap(iores->start, resource_size(iores));
+		if (!base) {
+			err = -ENOMEM;
+			goto out_release_mem;
+		}
+	}
+	port->base = base;
+
+	port->irq = platform_get_irq(pdev, 0);
+	if (port->irq < 0) {
+		err = -EINVAL;
+		goto out_iounmap;
+	}
+
+	/* disable the interrupt and clear the status */
+	writel(0, port->base + PINCTRL_PIN2IRQ(port->id));
+	writel(0, port->base + PINCTRL_IRQEN(port->id));
+
+	/* clear address has to be used to clear IRQSTAT bits */
+	writel(~0U, port->base + PINCTRL_IRQSTAT(port->id) + MXS_CLR);
+
+	for (i = port->virtual_irq_start;
+		i < port->virtual_irq_start + 32; i++) {
+		irq_set_chip_and_handler(i, &gpio_irq_chip,
+					 handle_level_irq);
+		set_irq_flags(i, IRQF_VALID);
+		irq_set_chip_data(i, port);
+	}
+
+	/* setup one handler for each entry */
+	irq_set_chained_handler(port->irq, mxs_gpio_irq_handler);
+	irq_set_handler_data(port->irq, port);
+
+	/* register gpio chip */
+	port->chip.direction_input = mxs_gpio_direction_input;
+	port->chip.direction_output = mxs_gpio_direction_output;
+	port->chip.get = mxs_gpio_get;
+	port->chip.set = mxs_gpio_set;
+	port->chip.to_irq = mxs_gpio_to_irq;
+	port->chip.base = port->id * 32;
+	port->chip.ngpio = 32;
+
+	err = gpiochip_add(&port->chip);
+	if (err)
+		goto out_iounmap;
+
+	platform_set_drvdata(pdev, port);
+
+	return 0;
+
+out_iounmap:
+	if (iores)
+		iounmap(port->base);
+out_release_mem:
+	if (iores)
+		release_mem_region(iores->start, resource_size(iores));
+out_kfree:
+	kfree(port);
+	dev_info(&pdev->dev, "%s failed with errno %d\n", __func__, err);
+	return err;
+}
+
+static struct platform_driver mxs_gpio_driver = {
+	.driver		= {
+		.name	= "gpio-mxs",
+	},
+	.probe		= mxs_gpio_probe,
+};
+
+static int __init mxs_gpio_init(void)
+{
+	return platform_driver_register(&mxs_gpio_driver);
+}
+postcore_initcall(mxs_gpio_init);
+
+MODULE_AUTHOR("Freescale Semiconductor, "
+	      "Daniel Mack <danielncaiaq.de>, "
+	      "Juergen Beisert <kernel@pengutronix.de>");
+MODULE_DESCRIPTION("Freescale MXS GPIO");
+MODULE_LICENSE("GPL");
-- 
1.7.4.1

