Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab1F0H1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 03:27:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:57636 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964Ab1F0H00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 03:26:26 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de
Subject: [PATCH v2 2/2] gpio: Add a driver for Sodaville GPIO controller
Date: Mon, 27 Jun 2011 09:26:23 +0200
Message-Id: <1309159583-11339-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309159583-11339-1-git-send-email-bigeasy@linutronix.de>
References: <1309159583-11339-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sodaville has GPIO controller behind the PCI bus. To my suprissed it is
not the same as on PXA.

The interrupt & gpio chip can be referenced from the device tree like
from any other driver. Unfortunately the driver which uses the gpio
interrupt has to use irq_of_parse_and_map() instead of
platform_get_irq(). The problem is that the platform device (which is
created from the device tree) is most likely created before the
interrupt chip is registered and therefore irq_of_parse_and_map() fails.

In theory the driver works as module. In reality most of the irq
functions are not exported to modules and it is possible that _this_
module is unloaded while the provided irqs are still in use.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
[torbenh@linutronix.de: make it work after the irq namespace cleanup,
	                add some device tree entries.]
Signed-off-by: Torben Hohn <torbenh@linutronix.de>
[bigeasy@linutronix.de: convert to generic irq & gpio chip]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 .../devicetree/bindings/gpio/sodaville.txt         |   48 +++
 arch/x86/platform/ce4100/falconfalls.dts           |    7 +-
 drivers/gpio/Kconfig                               |    8 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-sodaville.c                      |  302 ++++++++++++++++++++
 5 files changed, 364 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/sodaville.txt
 create mode 100644 drivers/gpio/gpio-sodaville.c

diff --git a/Documentation/devicetree/bindings/gpio/sodaville.txt b/Documentation/devicetree/bindings/gpio/sodaville.txt
new file mode 100644
index 0000000..563eff2
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/sodaville.txt
@@ -0,0 +1,48 @@
+GPIO controller on CE4100 / Sodaville SoCs
+==========================================
+
+The bindings for CE4100's GPIO controller match the generic description
+which is covered by the gpio.txt file in this folder.
+
+The only additional property is the intel,muxctl property which holds the
+value which is written into the MUXCNTL register.
+
+There is no compatible property for now because the driver is probed via
+PCI id (vendor 0x8086 device 0x2e67).
+
+The interrupt specifier consists of two cells encoded as follows:
+ - <1st cell>: The interrupt-number that identifies the interrupt source.
+ - <2nd cell>: The level-sense information, encoded as follows:
+		4 - active high level-sensitive
+		8 - active low level-sensitive
+
+Example of the GPIO device and one user:
+
+	pcigpio: gpio@b,1 {
+			/* two cells for GPIO and interrupt */
+			#gpio-cells = <2>;
+			#interrupt-cells = <2>;
+			compatible = "pci8086,2e67.2",
+					   "pci8086,2e67",
+					   "pciclassff0000",
+					   "pciclassff00";
+
+			reg = <0x15900 0x0 0x0 0x0 0x0>;
+			/* Interrupt line of the gpio device */
+			interrupts = <15 1>;
+			/* It is an interrupt and GPIO controller itself */
+			interrupt-controller;
+			gpio-controller;
+			intel,muxctl = <0>;
+	};
+
+	testuser@20 {
+			compatible = "example,testuser";
+			/* User the 11th GPIO line as an active high triggered
+			 * level interrupt
+			 */
+			interrupts = <11 8>;
+			interrupt-parent = <&pcigpio>;
+			/* Use this GPIO also with the gpio functions */
+			gpios = <&pcigpio 11 0>;
+	};
diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
index e70be38..ce874f8 100644
--- a/arch/x86/platform/ce4100/falconfalls.dts
+++ b/arch/x86/platform/ce4100/falconfalls.dts
@@ -208,16 +208,19 @@
 					interrupts = <14 1>;
 				};
 
-				gpio@b,1 {
+				pcigpio: gpio@b,1 {
+					#gpio-cells = <2>;
+					#interrupt-cells = <2>;
 					compatible = "pci8086,2e67.2",
 						   "pci8086,2e67",
 						   "pciclassff0000",
 						   "pciclassff00";
 
-					#gpio-cells = <2>;
 					reg = <0x15900 0x0 0x0 0x0 0x0>;
 					interrupts = <15 1>;
+					interrupt-controller;
 					gpio-controller;
+					intel,muxctl = <0>;
 				};
 
 				i2c-controller@b,2 {
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 9f06e63..4765f63 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -376,6 +376,14 @@ config GPIO_ML_IOH
 	  Hub) which is for IVI(In-Vehicle Infotainment) use.
 	  This driver can access the IOH's GPIO device.
 
+config GPIO_SODAVILLE
+	bool "Intel Sodaville GPIO support"
+	depends on PCI && OF
+	select GPIO_GENERIC
+	select GENERIC_IRQ_CHIP
+	help
+	  Say Y here to support Intel Sodaville GPIO.
+
 config GPIO_TIMBERDALE
 	bool "Support for timberdale GPIO IP"
 	depends on MFD_TIMBERDALE && HAS_IOMEM
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 0fbdd75..cc6d662 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_GPIO_S5PV210)	+= gpio-s5pv210.o
 
 obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
 obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
+obj-$(CONFIG_GPIO_SODAVILLE)	+= gpio-sodaville.o
 obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
 obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
 obj-$(CONFIG_ARCH_TEGRA)	+= gpio-tegra.o
diff --git a/drivers/gpio/gpio-sodaville.c b/drivers/gpio/gpio-sodaville.c
new file mode 100644
index 0000000..9ba15d3
--- /dev/null
+++ b/drivers/gpio/gpio-sodaville.c
@@ -0,0 +1,302 @@
+/*
+ *  GPIO interface for Intel Sodaville SoCs.
+ *
+ *  Copyright (c) 2010, 2011 Intel Corporation
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License 2 as published
+ *  by the Free Software Foundation.
+ *
+ */
+
+#include <linux/errno.h>
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+#include <linux/of_irq.h>
+#include <linux/basic_mmio_gpio.h>
+
+#define DRV_NAME		"sdv_gpio"
+#define SDV_NUM_PUB_GPIOS	12
+#define PCI_DEVICE_ID_SDV_GPIO	0x2e67
+#define GPIO_BAR		0
+
+#define GPOUTR		0x00
+#define GPOER		0x04
+#define GPINR		0x08
+
+#define GPSTR		0x0c
+#define GPIT1R0		0x10
+#define GPIO_INT	0x14
+#define GPIT1R1		0x18
+
+#define GPMUXCTL	0x1c
+
+struct sdv_gpio_chip_data {
+	int irq_base;
+	void __iomem *gpio_pub_base;
+	struct irq_domain id;
+	struct irq_chip_generic *gc;
+	struct bgpio_chip bgpio;
+};
+
+static int sdv_gpio_pub_set_type(struct irq_data *d, unsigned int type)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct sdv_gpio_chip_data *sd = gc->private;
+	void __iomem *type_reg;
+	u32 irq_offs = d->irq - sd->irq_base;
+	u32 reg;
+
+	if (irq_offs < 8)
+		type_reg = sd->gpio_pub_base + GPIT1R0;
+	else
+		type_reg = sd->gpio_pub_base + GPIT1R1;
+
+	reg = readl(type_reg);
+
+	switch (type) {
+	case IRQ_TYPE_LEVEL_HIGH:
+		reg &= ~BIT(4 * (irq_offs % 8));
+		break;
+
+	case IRQ_TYPE_LEVEL_LOW:
+		reg |= BIT(4 * (irq_offs % 8));
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	writel(reg, type_reg);
+	return 0;
+}
+
+static irqreturn_t sdv_gpio_pub_irq_handler(int irq, void *data)
+{
+	struct sdv_gpio_chip_data *sd = data;
+	u32 irq_stat = readl(sd->gpio_pub_base + GPSTR);
+
+	irq_stat &= readl(sd->gpio_pub_base + GPIO_INT);
+	if (!irq_stat)
+		return IRQ_NONE;
+
+	while (irq_stat) {
+		u32 irq_bit = __fls(irq_stat);
+
+		irq_stat &= ~BIT(irq_bit);
+		generic_handle_irq(sd->irq_base + irq_bit);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int sdv_xlate(struct irq_domain *h, struct device_node *node,
+		const u32 *intspec, u32 intsize, irq_hw_number_t *out_hwirq,
+		u32 *out_type)
+{
+	u32 line, type;
+
+	if (node != h->of_node)
+		return -EINVAL;
+
+	if (intsize < 2)
+		return -EINVAL;
+
+	line = *intspec;
+	*out_hwirq = line;
+
+	intspec++;
+	type = *intspec;
+
+	switch (type) {
+	case IRQ_TYPE_LEVEL_LOW:
+	case IRQ_TYPE_LEVEL_HIGH:
+		*out_type = type;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct irq_domain_ops irq_domain_sdv_ops = {
+	.dt_translate	= sdv_xlate,
+};
+
+static __devinit int sdv_register_irqsupport(struct sdv_gpio_chip_data *sd,
+		struct pci_dev *pdev)
+{
+	struct irq_chip_type *ct;
+	int ret;
+
+	sd->irq_base = irq_alloc_descs(-1, 0, SDV_NUM_PUB_GPIOS, -1);
+	if (sd->irq_base < 0)
+		return sd->irq_base;
+
+	/* mask + ACK all interrupt sources */
+	writel(0, sd->gpio_pub_base + GPIO_INT);
+	writel((1 << 11) - 1, sd->gpio_pub_base + GPSTR);
+
+	ret = request_irq(pdev->irq, sdv_gpio_pub_irq_handler, IRQF_SHARED,
+			"sdv_gpio", sd);
+	if (ret)
+		goto out_free_desc;
+
+	sd->id.irq_base = sd->irq_base;
+	sd->id.of_node = of_node_get(pdev->dev.of_node);
+	sd->id.ops = &irq_domain_sdv_ops;
+
+	/*
+	 * This gpio irq controller latches level irqs. Testing shows that if
+	 * we unmask & ACK the IRQ before the source of the interrupt is gone
+	 * then the interrupt is active again.
+	 */
+	sd->gc = irq_alloc_generic_chip("sdv-gpio", 1, sd->irq_base,
+			sd->gpio_pub_base, handle_fasteoi_irq);
+	if (!sd->gc) {
+		ret = -ENOMEM;
+		goto out_free_irq;
+	}
+
+	sd->gc->private = sd;
+	ct = sd->gc->chip_types;
+	ct->type = IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW;
+	ct->regs.eoi = GPSTR;
+	ct->regs.mask = GPIO_INT;
+	ct->chip.irq_mask = irq_gc_mask_clr_bit;
+	ct->chip.irq_unmask = irq_gc_mask_set_bit;
+	ct->chip.irq_eoi = irq_gc_eoi;
+	ct->chip.irq_set_type = sdv_gpio_pub_set_type;
+
+	irq_setup_generic_chip(sd->gc, IRQ_MSK(SDV_NUM_PUB_GPIOS),
+			IRQ_GC_INIT_MASK_CACHE, IRQ_NOREQUEST,
+			IRQ_LEVEL | IRQ_NOPROBE);
+
+	irq_domain_add(&sd->id);
+	return 0;
+out_free_irq:
+	free_irq(pdev->irq, sd);
+out_free_desc:
+	irq_free_descs(sd->irq_base, SDV_NUM_PUB_GPIOS);
+	return ret;
+}
+
+static int __devinit sdv_gpio_probe(struct pci_dev *pdev,
+					const struct pci_device_id *pci_id)
+{
+	struct sdv_gpio_chip_data *sd;
+	unsigned long addr;
+	const void *prop;
+	int len;
+	int ret;
+	u32 mux_val;
+
+	sd = kzalloc(sizeof(struct sdv_gpio_chip_data), GFP_KERNEL);
+	if (!sd)
+		return -ENOMEM;
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "can't enable device.\n");
+		goto done;
+	}
+
+	ret = pci_request_region(pdev, GPIO_BAR, DRV_NAME);
+	if (ret) {
+		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", GPIO_BAR);
+		goto disable_pci;
+	}
+
+	addr = pci_resource_start(pdev, GPIO_BAR);
+	if (!addr)
+		goto release_reg;
+	sd->gpio_pub_base = ioremap(addr, pci_resource_len(pdev, GPIO_BAR));
+
+	prop = of_get_property(pdev->dev.of_node, "intel,muxctl", &len);
+	if (prop && len == 4) {
+		mux_val = of_read_number(prop, 1);
+		writel(mux_val, sd->gpio_pub_base + GPMUXCTL);
+	}
+
+	ret = bgpio_init(&sd->bgpio, &pdev->dev, 4,
+			sd->gpio_pub_base + GPINR, sd->gpio_pub_base + GPOUTR,
+			NULL, sd->gpio_pub_base + GPOER, NULL, false);
+	if (ret)
+		goto unmap;
+	sd->bgpio.gc.ngpio = SDV_NUM_PUB_GPIOS;
+
+	ret = gpiochip_add(&sd->bgpio.gc);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "gpiochip_add() failed.\n");
+		goto unmap;
+	}
+
+	ret = sdv_register_irqsupport(sd, pdev);
+	if (ret)
+		goto unmap;
+
+	pci_set_drvdata(pdev, sd);
+	dev_info(&pdev->dev, "Sodaville GPIO driver registered.\n");
+	return 0;
+
+unmap:
+	iounmap(sd->gpio_pub_base);
+release_reg:
+	pci_release_region(pdev, GPIO_BAR);
+disable_pci:
+	pci_disable_device(pdev);
+done:
+	kfree(sd);
+	return ret;
+}
+
+static void sdv_gpio_remove(struct pci_dev *pdev)
+{
+	struct sdv_gpio_chip_data *sd = pci_get_drvdata(pdev);
+
+	irq_domain_del(&sd->id);
+	free_irq(pdev->irq, sd);
+	irq_free_descs(sd->irq_base, SDV_NUM_PUB_GPIOS);
+
+	if (gpiochip_remove(&sd->bgpio.gc))
+		dev_err(&pdev->dev, "gpiochip_remove() failed.\n");
+
+	pci_release_region(pdev, GPIO_BAR);
+	iounmap(sd->gpio_pub_base);
+	pci_disable_device(pdev);
+	kfree(sd);
+}
+
+static struct pci_device_id sdv_gpio_pci_ids[] __devinitdata = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_SDV_GPIO) },
+	{ 0, },
+};
+
+static struct pci_driver sdv_gpio_driver = {
+	.name = DRV_NAME,
+	.id_table = sdv_gpio_pci_ids,
+	.probe = sdv_gpio_probe,
+	.remove = sdv_gpio_remove,
+};
+
+static int __init sdv_gpio_init(void)
+{
+	return pci_register_driver(&sdv_gpio_driver);
+}
+module_init(sdv_gpio_init);
+
+static void __exit sdv_gpio_exit(void)
+{
+	pci_unregister_driver(&sdv_gpio_driver);
+}
+module_exit(sdv_gpio_exit);
+
+MODULE_AUTHOR("Hans J. Koch <hjk@linutronix.de>");
+MODULE_DESCRIPTION("GPIO interface for Intel Sodaville SoCs");
+MODULE_LICENSE("GPL v2");
-- 
1.7.4.4

