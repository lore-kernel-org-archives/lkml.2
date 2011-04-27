Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009Ab1D0OhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:37:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:32954 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1D0OhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:37:21 -0400
Date: Wed, 27 Apr 2011 16:37:18 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: x86@kernel.org, sodaville@linutronix.de, linux-kernel@vger.kernel.org,
        Torben Hohn <torbenh@linutronix.de>,
        Florian Fainelli <florian@openwrt.org>
Subject: [PATCH 2/2] gpio: Add a driver for Sodaville GPIO controller
Message-ID: <20110427143718.GC15211@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J. Koch <hjk@linutronix.de>

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
[bigeasy@linutronix.de: some refactoring, a little documentation]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 .../devicetree/bindings/gpio/sodaville.txt         |    8 +
 arch/x86/platform/ce4100/falconfalls.dts           |    7 +-
 drivers/gpio/Kconfig                               |    6 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/sodaville_gpio.c                      |  421 ++++++++++++++++++++
 5 files changed, 441 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/sodaville.txt
 create mode 100644 drivers/gpio/sodaville_gpio.c

diff --git a/Documentation/devicetree/bindings/gpio/sodaville.txt b/Documentation/devicetree/bindings/gpio/sodaville.txt
new file mode 100644
index 0000000..6610cf3
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/sodaville.txt
@@ -0,0 +1,8 @@
+GPIO controller on CE4100 / Sodaville SoCs
+==========================================
+
+The bindings for CE4100's GPIO controller match the generic description
+which is covered by the gpio.txt file in this folder.
+
+The only additional property is the muxctl property which holds the
+value which is written into the MUXCNTL register.
diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
index e70be38..751a9ec 100644
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
+					muxctl = <0>;
 				};
 
 				i2c-controller@b,2 {
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d3b2953..2a665de 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -345,6 +345,12 @@ config GPIO_ML_IOH
 	  Hub) which is for IVI(In-Vehicle Infotainment) use.
 	  This driver can access the IOH's GPIO device.
 
+config GPIO_SODAVILLE
+	bool "Intel Sodaville GPIO support"
+	depends on PCI
+	help
+	  Say Y here to support Intel Sodaville GPIO.
+
 config GPIO_TIMBERDALE
 	bool "Support for timberdale GPIO IP"
 	depends on MFD_TIMBERDALE && GPIOLIB && HAS_IOMEM
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index becef59..7fbc00d 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_GPIO_PCH)		+= pch_gpio.o
 obj-$(CONFIG_GPIO_PL061)	+= pl061.o
 obj-$(CONFIG_GPIO_STMPE)	+= stmpe-gpio.o
 obj-$(CONFIG_GPIO_TC3589X)	+= tc3589x-gpio.o
+obj-$(CONFIG_GPIO_SODAVILLE)	+= sodaville_gpio.o
 obj-$(CONFIG_GPIO_TIMBERDALE)	+= timbgpio.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
 obj-$(CONFIG_GPIO_UCB1400)	+= ucb1400_gpio.o
diff --git a/drivers/gpio/sodaville_gpio.c b/drivers/gpio/sodaville_gpio.c
new file mode 100644
index 0000000..1fcdbb0
--- /dev/null
+++ b/drivers/gpio/sodaville_gpio.c
@@ -0,0 +1,421 @@
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
+
+static DEFINE_SPINLOCK(gpio_lock);
+
+#define DRV_NAME		"sdv_gpio"
+#define SDV_NUM_PUB_GPIOS	12
+#define PCI_DEVICE_ID_SDV_GPIO	0x2e67
+#define GPIO_BAR		0
+
+#define GPOUTR		0x00
+#define GPOER		0x04
+#define GPINR		0x08
+#define GPSTR		0x0c
+#define GPIT1R0		0x10
+#define GPIO_INT	0x14
+#define GPIT1R1		0x18
+#define GPMUXCTL	0x1c
+
+void __iomem *gpio_pub_base;
+
+struct sdv_irq_chip_data {
+	int irq_base;
+	struct irq_domain id;
+};
+
+static void sdv_gpio_pub_mask_irq(struct irq_data *irq)
+{
+	struct sdv_irq_chip_data *data = irq_data_get_irq_chip_data(irq);
+	u32 reg;
+
+	reg = readl(gpio_pub_base + GPIO_INT);
+	reg &= ~BIT(irq->irq - data->irq_base);
+	writel(reg, gpio_pub_base + GPIO_INT);
+}
+
+static void sdv_gpio_pub_ack_irq(struct irq_data *irq)
+{
+	struct sdv_irq_chip_data *data = irq_data_get_irq_chip_data(irq);
+	u32 reg;
+
+	reg = (BIT(irq->irq - data->irq_base));
+	writel(reg, gpio_pub_base + GPSTR);
+}
+
+static void sdv_gpio_pub_unmask_irq(struct irq_data *irq)
+{
+	struct sdv_irq_chip_data *data = irq_data_get_irq_chip_data(irq);
+	u32 reg;
+
+	reg = readl(gpio_pub_base + GPIO_INT);
+	reg |= (BIT(irq->irq - data->irq_base));
+	writel(reg, gpio_pub_base + GPIO_INT);
+}
+
+static int sdv_gpio_pub_set_type(struct irq_data *irq, unsigned int type)
+{
+	struct sdv_irq_chip_data *data = irq_data_get_irq_chip_data(irq);
+	u32 irq_offs = irq->irq - data->irq_base;
+	u32 reg;
+
+	if (irq_offs < 8)
+		reg = readl(gpio_pub_base + GPIT1R0);
+	else
+		reg = readl(gpio_pub_base + GPIT1R1);
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
+	if (irq_offs < 8)
+		writel(reg, gpio_pub_base + GPIT1R0);
+	else
+		writel(reg, gpio_pub_base + GPIT1R1);
+
+	return 0;
+}
+
+static irqreturn_t sdv_gpio_pub_irq_handler(int irq, void *data)
+{
+	struct sdv_irq_chip_data *sdv_data = data;
+	u32 irq_stat = readl(gpio_pub_base + GPSTR);
+
+	irq_stat &= readl(gpio_pub_base + GPIO_INT);
+	if (!irq_stat)
+		return IRQ_NONE;
+
+	while (irq_stat) {
+		int irq_bit = __fls(irq_stat);
+
+		generic_handle_irq(sdv_data->irq_base + irq_bit);
+		irq_stat &= ~BIT(irq_bit);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static struct irq_chip sdv_gpio_pub_irq_chip = {
+	.name		= "sdv-gpio",
+	.irq_mask	= sdv_gpio_pub_mask_irq,
+	.irq_eoi	= sdv_gpio_pub_ack_irq,
+	.irq_unmask	= sdv_gpio_pub_unmask_irq,
+	.irq_set_type	= sdv_gpio_pub_set_type,
+};
+
+static int sdv_xlate(struct irq_domain *h, const u32 *intspec, u32 intsize,
+		u32 *out_hwirq, u32 *out_type)
+{
+	struct sdv_irq_chip_data *sdv_data = h->priv;
+	u32 line, type;
+
+	if (intsize < 2)
+		return -EINVAL;
+
+	/* irqs are offset by sdv_data->irq_base */
+	line = *intspec;
+	*out_hwirq = line + sdv_data->irq_base;
+
+	intspec++;
+	type = *intspec;
+
+	/* Only level interrupts are supported by the IRQ chip */
+	switch (type) {
+	case 1:
+		*out_type = IRQ_TYPE_LEVEL_LOW;
+		break;
+	case 2:
+		*out_type = IRQ_TYPE_LEVEL_HIGH;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static __devinit int register_irqsupport(struct pci_dev *pdev)
+{
+	struct sdv_irq_chip_data *sdv_data;
+	int irq;
+	int last_irq;
+	int ret = -1;
+
+	sdv_data = kzalloc(sizeof(struct sdv_irq_chip_data), GFP_KERNEL);
+	if (!sdv_data) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = irq_alloc_descs(-1, 0, SDV_NUM_PUB_GPIOS, -1);
+	if (ret < 0)
+		goto out_kfree;
+
+	sdv_data->irq_base = ret;
+
+	/* mask + ACK all interrupt sources */
+	writel(0, gpio_pub_base + GPIO_INT);
+	writel((1 << 11) - 1, gpio_pub_base + GPSTR);
+
+	ret = request_irq(pdev->irq, sdv_gpio_pub_irq_handler, IRQF_SHARED,
+			"sdv_gpio", sdv_data);
+	if (ret)
+		goto out_free_desc;
+
+	/*
+	 * This gpio irq controller latches level irqs. Testing shows that if
+	 * we unmask & ACK the IRQ before the source of the interrupt is gone
+	 * then the interrupt is active again.
+	 */
+	last_irq = sdv_data->irq_base + SDV_NUM_PUB_GPIOS;
+	for (irq = sdv_data->irq_base; irq < last_irq; irq++) {
+		irq_set_chip_and_handler_name(irq, &sdv_gpio_pub_irq_chip,
+				handle_fasteoi_irq, "fasteoi");
+		irq_set_chip_data(irq, sdv_data);
+	}
+
+	pci_set_drvdata(pdev, sdv_data);
+
+	sdv_data->id.controller = pdev->dev.of_node;
+	sdv_data->id.xlate = sdv_xlate;
+	sdv_data->id.priv = sdv_data;
+	irq_add_of_interrupt_host(&sdv_data->id);
+
+	return 0;
+
+out_free_desc:
+	irq_free_descs(sdv_data->irq_base, SDV_NUM_PUB_GPIOS);
+out_kfree:
+	kfree(sdv_data);
+out:
+	pdev->dev.p = 0;
+	return ret;
+}
+
+static void unregister_irqsupport(struct pci_dev *pdev)
+{
+	struct sdv_irq_chip_data *sdv_data = pci_get_drvdata(pdev);
+
+	if (sdv_data) {
+		irq_remove_of_interrupt_host(&sdv_data->id);
+		free_irq(pdev->irq, sdv_data);
+		irq_free_descs(sdv_data->irq_base, SDV_NUM_PUB_GPIOS);
+		kfree(sdv_data);
+	}
+}
+
+static int sdv_gpio_is_output(unsigned gpio_num)
+{
+	return readl(gpio_pub_base + GPOER) & BIT(gpio_num);
+}
+
+static int sdv_gpio_pub_get(struct gpio_chip *gc, unsigned gpio_num)
+{
+	u32 reg;
+
+	if (sdv_gpio_is_output(gpio_num))
+		reg = readl(gpio_pub_base + GPOUTR);
+	else
+		reg = readl(gpio_pub_base + GPINR);
+
+	return (reg & BIT(gpio_num)) ? 1 : 0;
+}
+
+static void sdv_gpio_pub_set(struct gpio_chip *gc,
+				unsigned gpio_num, int val)
+{
+	u32 curr_vals;
+
+	spin_lock(&gpio_lock);
+
+	curr_vals = readl(gpio_pub_base + GPOUTR);
+
+	if (val)
+		curr_vals |= BIT(gpio_num);
+	else
+		curr_vals &= ~BIT(gpio_num);
+
+	writel(curr_vals, gpio_pub_base + GPOUTR);
+	spin_unlock(&gpio_lock);
+}
+
+static int sdv_gpio_pub_direction_in(struct gpio_chip *gc,
+					unsigned gpio_num)
+{
+	u32 curr_dirs;
+
+	spin_lock(&gpio_lock);
+
+	curr_dirs = readl(gpio_pub_base + GPOER);
+
+	if (curr_dirs & BIT(gpio_num))
+		writel(curr_dirs & ~BIT(gpio_num), gpio_pub_base + GPOER);
+
+	spin_unlock(&gpio_lock);
+	return 0;
+}
+
+static int sdv_gpio_pub_direction_out(struct gpio_chip *gc,
+					unsigned gpio_num, int val)
+{
+	u32 curr_dirs;
+
+	sdv_gpio_pub_set(gc, gpio_num, val);
+
+	spin_lock(&gpio_lock);
+
+	curr_dirs = readl(gpio_pub_base + GPOER);
+
+	if (!(curr_dirs & BIT(gpio_num)))
+		writel(curr_dirs | BIT(gpio_num), gpio_pub_base + GPOER);
+
+	spin_unlock(&gpio_lock);
+	return 0;
+}
+
+static struct gpio_chip sdv_gpio_pub = {
+	.label			= "sdv_gpio",
+	.owner			= THIS_MODULE,
+	.get			= sdv_gpio_pub_get,
+	.set			= sdv_gpio_pub_set,
+	.direction_input	= sdv_gpio_pub_direction_in,
+	.direction_output	= sdv_gpio_pub_direction_out,
+};
+
+static int __devinit sdv_gpio_probe(struct pci_dev *pdev,
+					const struct pci_device_id *pci_id)
+{
+	unsigned long addr;
+	const void *prop;
+	int len;
+	int ret;
+	u32 mux_val;
+
+	if (gpio_pub_base) {
+		dev_err(&pdev->dev, KERN_ERR "Driver does not (yet) support "
+				"multiple devices.\n");
+		return -EBUSY;
+	}
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
+	gpio_pub_base = ioremap(addr, pci_resource_len(pdev, GPIO_BAR));
+
+	prop = of_get_property(pdev->dev.of_node, "muxctl", &len);
+	if (prop && len == 4) {
+		mux_val = of_read_number(prop, 1);
+		writel(mux_val, gpio_pub_base + GPMUXCTL);
+	}
+
+	sdv_gpio_pub.base = -1;
+	sdv_gpio_pub.ngpio = SDV_NUM_PUB_GPIOS;
+	sdv_gpio_pub.dev = &pdev->dev;
+
+	ret = gpiochip_add(&sdv_gpio_pub);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "gpiochip_add() failed.\n");
+		goto unmap;
+	}
+
+	ret = register_irqsupport(pdev);
+	if (ret)
+		goto unmap;
+
+	dev_info(&pdev->dev, "Sodaville GPIO driver registered.\n");
+
+	return 0;
+
+unmap:
+	iounmap(gpio_pub_base);
+	gpio_pub_base = NULL;
+release_reg:
+	pci_release_region(pdev, GPIO_BAR);
+disable_pci:
+	pci_disable_device(pdev);
+done:
+	return ret;
+}
+
+static void sdv_gpio_remove(struct pci_dev *pdev)
+{
+	if (!gpio_pub_base)
+		return;
+
+	unregister_irqsupport(pdev);
+
+	if (gpiochip_remove(&sdv_gpio_pub))
+		dev_err(&pdev->dev, "gpiochip_remove() failed.\n");
+
+	pci_release_region(pdev, GPIO_BAR);
+	gpio_pub_base = NULL;
+	pci_disable_device(pdev);
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

