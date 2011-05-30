Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab1E3Gj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 02:39:29 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:35787 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab1E3Gj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 02:39:28 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <grant.likely@secretlab.ca>
Cc: <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] gpio/spear-plgpio: Add plgpio driver for SPEAr platform
Date: Mon, 30 May 2011 12:09:02 +0530
Message-ID: <385c65f02831af2a16bcd4ea56c22ce6d8747ef0.1306737135.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1306737135.git.viresh.kumar@st.com>
References: <cover.1306737135.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Plgpio pads on few spear machines can be configured as gpios. This patch adds
support for configuring these PLGPIOs.

This was earlier posted & reviewed as part of arch/arm/plat-spear/ code.

Reviewed-by: Stanley Miao <stanley.miao@windriver.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 MAINTAINERS                  |    7 +
 drivers/gpio/Kconfig         |    7 +
 drivers/gpio/Makefile        |    1 +
 drivers/gpio/spear-plgpio.c  |  490 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/spear-plgpio.h |   69 ++++++
 5 files changed, 574 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/spear-plgpio.c
 create mode 100644 include/linux/spear-plgpio.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 29801f7..48b0a4f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5978,6 +5978,13 @@ F:	arch/arm/mach-spear3xx/spear3*0_evb.c
 F:	arch/arm/mach-spear6xx/spear600.c
 F:	arch/arm/mach-spear6xx/spear600_evb.c
 
+SPEAR PLGPIO SUPPORT
+M:	Viresh Kumar <viresh.kumar@st.com>
+W:	http://www.st.com/spear
+S:	Maintained
+F:	drivers/gpio/spear-plgpio.c
+F:	include/linux/spear-plgpio.h
+
 SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
 S:	Orphan
 F:	Documentation/serial/specialix.txt
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 4a7f631..227d2e7 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -164,6 +164,13 @@ config GPIO_VX855
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
+config SPEAR_PLGPIO
+	bool "ST Micro SPEAr PLGPIO"
+	depends on PLAT_SPEAR
+	help
+	  This enables support for the PLGPIOs found on the ST Microelectronics
+	  SPEAr platform
+
 comment "I2C GPIO expanders:"
 
 config GPIO_MAX7300
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index b605f8e..2d325b0 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -48,3 +48,4 @@ obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
 obj-$(CONFIG_AB8500_GPIO)       += ab8500-gpio.o
 obj-$(CONFIG_GPIO_TPS65910)	+= tps65910-gpio.o
+obj-$(CONFIG_SPEAR_PLGPIO)	+= spear-plgpio.o
diff --git a/drivers/gpio/spear-plgpio.c b/drivers/gpio/spear-plgpio.c
new file mode 100644
index 0000000..885c0da
--- /dev/null
+++ b/drivers/gpio/spear-plgpio.c
@@ -0,0 +1,490 @@
+/*
+ * drivers/gpio/spear-plgpio.c
+ *
+ * SPEAr platform PLGPIO driver source file
+ *
+ * Copyright (C) 2010-2011 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/bitops.h>
+#include <linux/compiler.h>
+#include <linux/errno.h>
+#include <linux/gpio.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/spear-plgpio.h>
+#include <linux/spinlock.h>
+
+#define MAX_GPIO_PER_REG		32
+#define PIN_OFFSET(pin)			(pin % MAX_GPIO_PER_REG)
+#define REG_OFFSET(base, reg, pin)	(base + reg + (pin / MAX_GPIO_PER_REG)\
+		* sizeof(int *))
+
+/*
+ * struct plgpio: plgpio driver specific structure
+ *
+ * lock: lock for guarding gpio registers
+ * base: base address of plgpio block
+ * irq_base: irq number of plgpio0
+ * chip: gpio framework specific chip information structure
+ * p2o: function ptr for pin to offset conversion. This is required only for
+ * machines where mapping b/w pin and offset is not 1-to-1.
+ * o2p: function ptr for offset to pin conversion. This is required only for
+ * machines where mapping b/w pin and offset is not 1-to-1.
+ * p2o_regs: mask of registers for which p2o and o2p are applicable
+ * regs: register offsets
+ * irq_trigger_type: irq type supported
+ */
+struct plgpio {
+	spinlock_t		lock;
+	void __iomem		*base;
+	unsigned		irq_base;
+	struct gpio_chip	chip;
+	int			(*p2o)(int pin);	/* pin_to_offset */
+	int			(*o2p)(int offset);	/* offset_to_pin */
+	unsigned		p2o_regs;
+	struct plgpio_regs	regs;
+	unsigned		irq_trigger_type;
+};
+
+/* register manipulation inline functions */
+static inline u32 is_plgpio_set(void __iomem *base, u32 pin, u32 reg)
+{
+	u32 offset = PIN_OFFSET(pin);
+	void __iomem *reg_off = REG_OFFSET(base, reg, pin);
+	u32 val = readl(reg_off);
+
+	return val & (1 << offset);
+}
+
+static inline void plgpio_reg_set(void __iomem *base, u32 pin, u32 reg)
+{
+	u32 offset = PIN_OFFSET(pin);
+	void __iomem *reg_off = REG_OFFSET(base, reg, pin);
+	u32 val = readl(reg_off);
+
+	writel(val | (1 << offset), reg_off);
+}
+
+static inline void plgpio_reg_reset(void __iomem *base, u32 pin, u32 reg)
+{
+	u32 offset = PIN_OFFSET(pin);
+	void __iomem *reg_off = REG_OFFSET(base, reg, pin);
+	u32 val = readl(reg_off);
+
+	writel(val & ~(1 << offset), reg_off);
+}
+
+/* gpio framework specific routines */
+static int plgpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct plgpio *plgpio = container_of(chip, struct plgpio, chip);
+	unsigned long flags;
+
+	if (offset >= chip->ngpio)
+		return -EINVAL;
+
+	/* get correct offset for "offset" pin */
+	if (plgpio->p2o && (plgpio->p2o_regs & PTO_DIR_REG)) {
+		offset = plgpio->p2o(offset);
+		if (offset == -1)
+			return -EINVAL;
+	}
+
+	spin_lock_irqsave(&plgpio->lock, flags);
+	plgpio_reg_set(plgpio->base, offset, plgpio->regs.dir);
+	spin_unlock_irqrestore(&plgpio->lock, flags);
+
+	return 0;
+}
+
+static int plgpio_direction_output(struct gpio_chip *chip, unsigned offset,
+		int value)
+{
+	struct plgpio *plgpio = container_of(chip, struct plgpio, chip);
+	unsigned long flags;
+	unsigned dir_offset = offset, wdata_offset = offset, tmp;
+
+	if (offset >= chip->ngpio)
+		return -EINVAL;
+
+	/* get correct offset for "offset" pin */
+	if (plgpio->p2o && (plgpio->p2o_regs & (PTO_DIR_REG | PTO_WDATA_REG))) {
+		tmp = plgpio->p2o(offset);
+		if (tmp == -1)
+			return -EINVAL;
+
+		if (plgpio->p2o_regs & PTO_DIR_REG)
+			dir_offset = tmp;
+		if (plgpio->p2o_regs & PTO_WDATA_REG)
+			wdata_offset = tmp;
+	}
+
+	spin_lock_irqsave(&plgpio->lock, flags);
+	plgpio_reg_reset(plgpio->base, dir_offset, plgpio->regs.dir);
+	if (value)
+		plgpio_reg_set(plgpio->base, wdata_offset,
+				plgpio->regs.wdata);
+	else
+		plgpio_reg_reset(plgpio->base, wdata_offset,
+				plgpio->regs.wdata);
+	spin_unlock_irqrestore(&plgpio->lock, flags);
+
+	return 0;
+}
+
+static int plgpio_get_value(struct gpio_chip *chip, unsigned offset)
+{
+	struct plgpio *plgpio = container_of(chip, struct plgpio, chip);
+
+	if (offset >= chip->ngpio)
+		return -EINVAL;
+
+	/* get correct offset for "offset" pin */
+	if (plgpio->p2o && (plgpio->p2o_regs & PTO_RDATA_REG)) {
+		offset = plgpio->p2o(offset);
+		if (offset == -1)
+			return -EINVAL;
+	}
+
+	return is_plgpio_set(plgpio->base, offset, plgpio->regs.rdata);
+}
+
+static void plgpio_set_value(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct plgpio *plgpio = container_of(chip, struct plgpio, chip);
+
+	if (offset >= chip->ngpio)
+		return;
+
+	/* get correct offset for "offset" pin */
+	if (plgpio->p2o && (plgpio->p2o_regs & PTO_WDATA_REG)) {
+		offset = plgpio->p2o(offset);
+		if (offset == -1)
+			return;
+	}
+
+	if (value)
+		plgpio_reg_set(plgpio->base, offset, plgpio->regs.wdata);
+	else
+		plgpio_reg_reset(plgpio->base, offset, plgpio->regs.wdata);
+}
+
+static int plgpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	struct plgpio *plgpio = container_of(chip, struct plgpio, chip);
+	unsigned long flags;
+	int ret = 0;
+
+	if (offset >= chip->ngpio)
+		return -EINVAL;
+
+	/*
+	 * put gpio in IN mode before enabling it. This make enabling gpio safe
+	 */
+	ret = plgpio_direction_input(chip, offset);
+	if (ret)
+		return ret;
+
+	/* get correct offset for "offset" pin */
+	if (plgpio->p2o && (plgpio->p2o_regs & PTO_ENB_REG)) {
+		offset = plgpio->p2o(offset);
+		if (offset == -1)
+			return -EINVAL;
+	}
+
+	spin_lock_irqsave(&plgpio->lock, flags);
+	plgpio_reg_set(plgpio->base, offset, plgpio->regs.enb);
+	spin_unlock_irqrestore(&plgpio->lock, flags);
+
+	return 0;
+}
+
+static void plgpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	struct plgpio *plgpio = container_of(chip, struct plgpio, chip);
+	unsigned long flags;
+
+	if (offset >= chip->ngpio)
+		return;
+
+	/* get correct offset for "offset" pin */
+	if (plgpio->p2o && (plgpio->p2o_regs & PTO_ENB_REG)) {
+		offset = plgpio->p2o(offset);
+		if (offset == -1)
+			return;
+	}
+
+	spin_lock_irqsave(&plgpio->lock, flags);
+	plgpio_reg_reset(plgpio->base, offset, plgpio->regs.enb);
+	spin_unlock_irqrestore(&plgpio->lock, flags);
+}
+
+static int plgpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct plgpio *plgpio = container_of(chip, struct plgpio, chip);
+
+	if (plgpio->irq_base == (unsigned) -1)
+		return -EINVAL;
+
+	return plgpio->irq_base + offset;
+}
+
+/* PLGPIO IRQ */
+static void plgpio_irq_mask(struct irq_data *d)
+{
+	struct plgpio *plgpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - plgpio->irq_base;
+	unsigned long flags;
+
+	/* get correct offset for "offset" pin */
+	if (plgpio->p2o && (plgpio->p2o_regs & PTO_IE_REG)) {
+		offset = plgpio->p2o(offset);
+		if (offset == -1)
+			return;
+	}
+
+	spin_lock_irqsave(&plgpio->lock, flags);
+	plgpio_reg_set(plgpio->base, offset, plgpio->regs.ie);
+	spin_unlock_irqrestore(&plgpio->lock, flags);
+}
+
+static void plgpio_irq_unmask(struct irq_data *d)
+{
+	struct plgpio *plgpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - plgpio->irq_base;
+	unsigned long flags;
+
+	/* get correct offset for "offset" pin */
+	if (plgpio->p2o && (plgpio->p2o_regs & PTO_IE_REG)) {
+		offset = plgpio->p2o(offset);
+		if (offset == -1)
+			return;
+	}
+
+	spin_lock_irqsave(&plgpio->lock, flags);
+	plgpio_reg_reset(plgpio->base, offset, plgpio->regs.ie);
+	spin_unlock_irqrestore(&plgpio->lock, flags);
+}
+
+static int plgpio_irq_type(struct irq_data *d, unsigned trigger)
+{
+	struct plgpio *plgpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - plgpio->irq_base;
+
+	if (!(plgpio->irq_trigger_type & trigger))
+		return -EINVAL;
+	if (offset >= plgpio->chip.ngpio)
+		return -EINVAL;
+
+	/*
+	 * Currently we only need to configure register in case of edge
+	 * interrupt
+	 */
+	if (plgpio->irq_trigger_type == (IRQ_TYPE_EDGE_RISING |
+				IRQ_TYPE_EDGE_FALLING)) {
+		void __iomem *reg_off = REG_OFFSET(plgpio->base,
+				plgpio->regs.eit, offset);
+		u32 val = readl(reg_off);
+
+		offset = PIN_OFFSET(offset);
+		if (trigger == IRQ_TYPE_EDGE_RISING)
+			writel(val | (1 << offset), reg_off);
+		else
+			writel(val & ~(1 << offset), reg_off);
+	}
+
+	return 0;
+}
+
+static struct irq_chip plgpio_irqchip = {
+	.name		= "PLGPIO",
+	.irq_mask	= plgpio_irq_mask,
+	.irq_unmask	= plgpio_irq_unmask,
+	.irq_set_type	= plgpio_irq_type,
+};
+
+static void plgpio_irq_handler(unsigned irq, struct irq_desc *desc)
+{
+	struct plgpio *plgpio = irq_get_handler_data(irq);
+	int regs_count = DIV_ROUND_UP(plgpio->chip.ngpio, MAX_GPIO_PER_REG),
+	    count, pin, offset, i = 0;
+	unsigned long pending;
+
+	desc->irq_data.chip->irq_ack(&desc->irq_data);
+	/* check all plgpio MIS registers for a possible interrupt */
+	for (; i < regs_count; i++) {
+		pending = readl(plgpio->base + plgpio->regs.mis +
+				i * sizeof(int *));
+		if (!pending)
+			continue;
+
+		/* clear interrupts */
+		writel(~pending, plgpio->base + plgpio->regs.mis +
+				i * sizeof(int *));
+		/*
+		 * clear extra bits in last register having gpios < MAX/REG
+		 * ex: Suppose there are max 102 plgpios. then last register
+		 * must have only (102 - MAX_GPIO_PER_REG * 3) = 6 relevant bits
+		 * so, we must not take other 28 bits into consideration for
+		 * checking interrupt. so clear those bits.
+		 */
+		count = plgpio->chip.ngpio - i * MAX_GPIO_PER_REG;
+		if (count < MAX_GPIO_PER_REG)
+			pending &= (1 << count) - 1;
+
+		for_each_set_bit(offset, &pending, MAX_GPIO_PER_REG) {
+			/* get correct pin for "offset" */
+			if (plgpio->o2p && (plgpio->p2o_regs & PTO_MIS_REG)) {
+				pin = plgpio->o2p(offset);
+				if (pin == -1)
+					continue;
+			} else
+				pin = offset;
+
+			generic_handle_irq(plgpio_to_irq(&plgpio->chip,
+						i * MAX_GPIO_PER_REG + pin));
+		}
+	}
+	desc->irq_data.chip->irq_unmask(&desc->irq_data);
+}
+
+static int __devinit plgpio_probe(struct platform_device *pdev)
+{
+	struct spear_plgpio_pdata *pdata;
+	struct plgpio *plgpio;
+	int ret, irq, i;
+	struct resource *res;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		ret = -ENODEV;
+		dev_dbg(&pdev->dev, "invalid platform data\n");
+		goto fail;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		ret = -EBUSY;
+		dev_dbg(&pdev->dev, "invalid IORESOURCE_MEM\n");
+		goto fail;
+	}
+
+	if (!request_mem_region(res->start, resource_size(res), "plgpio")) {
+		ret = -EBUSY;
+		dev_dbg(&pdev->dev, "request mem region fail\n");
+		goto fail;
+	}
+
+	plgpio = kzalloc(sizeof(*plgpio), GFP_KERNEL);
+	if (!plgpio) {
+		ret = -ENOMEM;
+		dev_dbg(&pdev->dev, "memory allocation fail\n");
+		goto release_region;
+	}
+
+	plgpio->base = ioremap(res->start, resource_size(res));
+	if (!plgpio->base) {
+		ret = -ENOMEM;
+		dev_dbg(&pdev->dev, "ioremap fail\n");
+		goto kfree;
+	}
+
+	spin_lock_init(&plgpio->lock);
+
+	plgpio->chip.request = plgpio_request;
+	plgpio->chip.free = plgpio_free;
+	plgpio->chip.direction_input = plgpio_direction_input;
+	plgpio->chip.direction_output = plgpio_direction_output;
+	plgpio->chip.get = plgpio_get_value;
+	plgpio->chip.set = plgpio_set_value;
+	plgpio->chip.to_irq = plgpio_to_irq;
+	plgpio->chip.base = pdata->gpio_base;
+	plgpio->chip.ngpio = pdata->gpio_count;
+	plgpio->chip.label = dev_name(&pdev->dev);
+	plgpio->chip.dev = &pdev->dev;
+	plgpio->chip.owner = THIS_MODULE;
+	plgpio->irq_base = pdata->irq_base;
+	plgpio->p2o = pdata->p2o;
+	plgpio->o2p = pdata->o2p;
+	plgpio->p2o_regs = pdata->p2o_regs;
+	plgpio->regs.enb = pdata->regs.enb;
+	plgpio->regs.wdata = pdata->regs.wdata;
+	plgpio->regs.dir = pdata->regs.dir;
+	plgpio->regs.ie = pdata->regs.ie;
+	plgpio->regs.rdata = pdata->regs.rdata;
+	plgpio->regs.mis = pdata->regs.mis;
+	plgpio->irq_trigger_type = pdata->irq_trigger_type;
+
+	ret = gpiochip_add(&plgpio->chip);
+	if (ret) {
+		dev_dbg(&pdev->dev, "unable to add gpio chip\n");
+		goto iounmap;
+	}
+
+	/* irq_chip support */
+	if (pdata->irq_base == (unsigned) -1) {
+		dev_info(&pdev->dev, "Successfully registered without irqs\n");
+		return 0;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		ret = -ENODEV;
+		dev_dbg(&pdev->dev, "invalid irq number\n");
+		goto remove_gpiochip;
+	}
+
+	irq_set_chained_handler(irq, plgpio_irq_handler);
+	for (i = 0; i < pdata->gpio_count; i++) {
+		irq_set_chip_and_handler(i+plgpio->irq_base, &plgpio_irqchip,
+				handle_simple_irq);
+		set_irq_flags(i+plgpio->irq_base, IRQF_VALID);
+		irq_set_chip_data(i+plgpio->irq_base, plgpio);
+	}
+	irq_set_handler_data(irq, plgpio);
+	dev_info(&pdev->dev, "Successfully registered with irqs\n");
+
+	return 0;
+
+remove_gpiochip:
+	if (gpiochip_remove(&plgpio->chip))
+		dev_dbg(&pdev->dev, "unable to remove gpiochip\n");
+iounmap:
+	iounmap(plgpio->base);
+kfree:
+	kfree(plgpio);
+release_region:
+	release_mem_region(res->start, resource_size(res));
+fail:
+	dev_err(&pdev->dev, "probe fail: %d\n", ret);
+	return ret;
+}
+
+static struct platform_driver plgpio_driver = {
+	.probe		= plgpio_probe,
+	.driver		= {
+		.name	= "spear-plgpio",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init plgpio_init(void)
+{
+	return platform_driver_register(&plgpio_driver);
+}
+subsys_initcall(plgpio_init);
+
+MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_DESCRIPTION("SPEAr PLGPIO driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/spear-plgpio.h b/include/linux/spear-plgpio.h
new file mode 100644
index 0000000..a04986a
--- /dev/null
+++ b/include/linux/spear-plgpio.h
@@ -0,0 +1,69 @@
+/*
+ * include/linux/spear-plgpio.h
+ *
+ * SPEAr platform PLGPIO driver header file
+ *
+ * Copyright (C) 2010-2011 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __SPEAR_PLGPIO_H
+#define __SPEAR_PLGPIO_H
+
+#include <linux/types.h>
+
+/* plgpio driver declarations */
+/*
+ * plgpio pins in all machines are not one to one mapped, bitwise with
+ * registers bits. These set of macros define register masks for which below
+ * functions (pin_to_offset and offset_to_pin) are required to be called.
+ */
+#define PTO_ENB_REG		0x001
+#define PTO_WDATA_REG		0x002
+#define PTO_DIR_REG		0x004
+#define PTO_IE_REG		0x008
+#define PTO_RDATA_REG		0x010
+#define PTO_MIS_REG		0x020
+
+/* plgpio registers */
+struct plgpio_regs {
+	u32 enb;		/* enable register */
+	u32 wdata;		/* write data register */
+	u32 dir;		/* direction set register */
+	u32 rdata;		/* read data register */
+	u32 ie;			/* interrupt enable register */
+	u32 mis;		/* mask interrupt status register */
+	u32 eit;		/* edge interrupt type */
+};
+
+/**
+ * struct spear_plgpio_pdata: plgpio driver platform data
+ *
+ * gpio_base: gpio start number of plgpios
+ * irq_base: irq number of plgpio0
+ * gpio_count: total count of plgpios
+ * p2o: function ptr for pin to offset conversion. This is required only for
+ * machines where mapping b/w pin and offset is not 1-to-1.
+ * o2p: function ptr for offset to pin conversion. This is required only for
+ * machines where mapping b/w pin and offset is not 1-to-1.
+ * p2o_regs: mask of registers for which p2o and o2p are applicable
+ * regs: register offsets
+ * irq_trigger_type: irq type supported
+ */
+struct spear_plgpio_pdata {
+	u32		gpio_base;
+	u32		irq_base;
+	u32		gpio_count;
+	int		(*p2o)(int pin);	/* pin_to_offset */
+	int		(*o2p)(int offset);	/* offset_to_pin */
+	u32		p2o_regs;
+	struct		plgpio_regs regs;
+	unsigned	irq_trigger_type;
+};
+
+#endif /* __SPEAR_PLGPIO_H */
+
-- 
1.7.2.2

