Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab1FDKru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 06:47:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49360 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab1FDKrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 06:47:49 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v3 2/3] gpio: gpio-mxs: make it work for Freescale MXS architecture
Date: Sat,  4 Jun 2011 18:55:39 +0800
Message-Id: <1307184940-16291-3-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307184940-16291-1-git-send-email-shawn.guo@linaro.org>
References: <1307184940-16291-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch makes necessary changes as below to make gpio-mxs work
for i.MX23 and i.MX28.

* Use readl/writel to replace mach-specific accessors
  __raw_readl/__raw_writel

* Migrate to platform driver by adding .probe function

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/gpio/Makefile   |    1 +
 drivers/gpio/gpio-mxs.c |  227 +++++++++++++++++++++++++++-------------------
 2 files changed, 134 insertions(+), 94 deletions(-)

diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index b605f8e..bbab341 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -47,4 +47,5 @@ obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
 obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
 obj-$(CONFIG_AB8500_GPIO)       += ab8500-gpio.o
+obj-$(CONFIG_ARCH_MXS)		+= gpio-mxs.o
 obj-$(CONFIG_GPIO_TPS65910)	+= tps65910-gpio.o
diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
index 2c950fe..ab440ab 100644
--- a/drivers/gpio/gpio-mxs.c
+++ b/drivers/gpio/gpio-mxs.c
@@ -25,14 +25,21 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
-#include <mach/mx23.h>
-#include <mach/mx28.h>
-#include <asm-generic/bug.h>
-
-#include "gpio.h"
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
 
-static struct mxs_gpio_port *mxs_gpio_ports;
-static int gpio_table_size;
+#define MXS_SET		0x4
+#define MXS_CLR		0x8
 
 #define PINCTRL_DOUT(n)		((cpu_is_mx23() ? 0x0500 : 0x0700) + (n) * 0x10)
 #define PINCTRL_DIN(n)		((cpu_is_mx23() ? 0x0600 : 0x0900) + (n) * 0x10)
@@ -54,36 +61,42 @@ static int gpio_table_size;
 
 static void clear_gpio_irqstatus(struct mxs_gpio_port *port, u32 index)
 {
-	__mxs_clrl(1 << index, port->base + PINCTRL_IRQSTAT(port->id));
+	writel(1 << index, port->base + PINCTRL_IRQSTAT(port->id) + MXS_CLR);
 }
 
 static void set_gpio_irqenable(struct mxs_gpio_port *port, u32 index,
 				int enable)
 {
 	if (enable) {
-		__mxs_setl(1 << index, port->base + PINCTRL_IRQEN(port->id));
-		__mxs_setl(1 << index, port->base + PINCTRL_PIN2IRQ(port->id));
+		writel(1 << index,
+			port->base + PINCTRL_IRQEN(port->id) + MXS_SET);
+		writel(1 << index,
+			port->base + PINCTRL_PIN2IRQ(port->id) + MXS_SET);
 	} else {
-		__mxs_clrl(1 << index, port->base + PINCTRL_IRQEN(port->id));
+		writel(1 << index,
+			port->base + PINCTRL_IRQEN(port->id) + MXS_CLR);
 	}
 }
 
 static void mxs_gpio_ack_irq(struct irq_data *d)
 {
+	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
 	u32 gpio = irq_to_gpio(d->irq);
-	clear_gpio_irqstatus(&mxs_gpio_ports[gpio / 32], gpio & 0x1f);
+	clear_gpio_irqstatus(port, gpio & 0x1f);
 }
 
 static void mxs_gpio_mask_irq(struct irq_data *d)
 {
+	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
 	u32 gpio = irq_to_gpio(d->irq);
-	set_gpio_irqenable(&mxs_gpio_ports[gpio / 32], gpio & 0x1f, 0);
+	set_gpio_irqenable(port, gpio & 0x1f, 0);
 }
 
 static void mxs_gpio_unmask_irq(struct irq_data *d)
 {
+	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
 	u32 gpio = irq_to_gpio(d->irq);
-	set_gpio_irqenable(&mxs_gpio_ports[gpio / 32], gpio & 0x1f, 1);
+	set_gpio_irqenable(port, gpio & 0x1f, 1);
 }
 
 static int mxs_gpio_get(struct gpio_chip *chip, unsigned offset);
@@ -92,7 +105,7 @@ static int mxs_gpio_set_irq_type(struct irq_data *d, unsigned int type)
 {
 	u32 gpio = irq_to_gpio(d->irq);
 	u32 pin_mask = 1 << (gpio & 31);
-	struct mxs_gpio_port *port = &mxs_gpio_ports[gpio / 32];
+	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
 	void __iomem *pin_addr;
 	int edge;
 
@@ -116,16 +129,16 @@ static int mxs_gpio_set_irq_type(struct irq_data *d, unsigned int type)
 	/* set level or edge */
 	pin_addr = port->base + PINCTRL_IRQLEV(port->id);
 	if (edge & GPIO_INT_LEV_MASK)
-		__mxs_setl(pin_mask, pin_addr);
+		writel(pin_mask, pin_addr + MXS_SET);
 	else
-		__mxs_clrl(pin_mask, pin_addr);
+		writel(pin_mask, pin_addr + MXS_CLR);
 
 	/* set polarity */
 	pin_addr = port->base + PINCTRL_IRQPOL(port->id);
 	if (edge & GPIO_INT_POL_MASK)
-		__mxs_setl(pin_mask, pin_addr);
+		writel(pin_mask, pin_addr + MXS_SET);
 	else
-		__mxs_clrl(pin_mask, pin_addr);
+		writel(pin_mask, pin_addr + MXS_CLR);
 
 	clear_gpio_irqstatus(port, gpio & 0x1f);
 
@@ -136,13 +149,13 @@ static int mxs_gpio_set_irq_type(struct irq_data *d, unsigned int type)
 static void mxs_gpio_irq_handler(u32 irq, struct irq_desc *desc)
 {
 	u32 irq_stat;
-	struct mxs_gpio_port *port = (struct mxs_gpio_port *)irq_get_handler_data(irq);
+	struct mxs_gpio_port *port = irq_get_handler_data(irq);
 	u32 gpio_irq_no_base = port->virtual_irq_start;
 
 	desc->irq_data.chip->irq_ack(&desc->irq_data);
 
-	irq_stat = __raw_readl(port->base + PINCTRL_IRQSTAT(port->id)) &
-			__raw_readl(port->base + PINCTRL_IRQEN(port->id));
+	irq_stat = readl(port->base + PINCTRL_IRQSTAT(port->id)) &
+			readl(port->base + PINCTRL_IRQEN(port->id));
 
 	while (irq_stat != 0) {
 		int irqoffset = fls(irq_stat) - 1;
@@ -164,7 +177,7 @@ static int mxs_gpio_set_wake_irq(struct irq_data *d, unsigned int enable)
 {
 	u32 gpio = irq_to_gpio(d->irq);
 	u32 gpio_idx = gpio & 0x1f;
-	struct mxs_gpio_port *port = &mxs_gpio_ports[gpio / 32];
+	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
 
 	if (enable) {
 		if (port->irq_high && (gpio_idx >= 16))
@@ -198,9 +211,9 @@ static void mxs_set_gpio_direction(struct gpio_chip *chip, unsigned offset,
 	void __iomem *pin_addr = port->base + PINCTRL_DOE(port->id);
 
 	if (dir)
-		__mxs_setl(1 << offset, pin_addr);
+		writel(1 << offset, pin_addr + MXS_SET);
 	else
-		__mxs_clrl(1 << offset, pin_addr);
+		writel(1 << offset, pin_addr + MXS_CLR);
 }
 
 static int mxs_gpio_get(struct gpio_chip *chip, unsigned offset)
@@ -208,7 +221,7 @@ static int mxs_gpio_get(struct gpio_chip *chip, unsigned offset)
 	struct mxs_gpio_port *port =
 		container_of(chip, struct mxs_gpio_port, chip);
 
-	return (__raw_readl(port->base + PINCTRL_DIN(port->id)) >> offset) & 1;
+	return (readl(port->base + PINCTRL_DIN(port->id)) >> offset) & 1;
 }
 
 static void mxs_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
@@ -218,9 +231,9 @@ static void mxs_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	void __iomem *pin_addr = port->base + PINCTRL_DOUT(port->id);
 
 	if (value)
-		__mxs_setl(1 << offset, pin_addr);
+		writel(1 << offset, pin_addr + MXS_SET);
 	else
-		__mxs_clrl(1 << offset, pin_addr);
+		writel(1 << offset, pin_addr + MXS_CLR);
 }
 
 static int mxs_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
@@ -245,87 +258,113 @@ static int mxs_gpio_direction_output(struct gpio_chip *chip,
 	return 0;
 }
 
-int __init mxs_gpio_init(struct mxs_gpio_port *port, int cnt)
+static int __devinit mxs_gpio_probe(struct platform_device *pdev)
 {
-	int i, j;
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
 
-	/* save for local usage */
-	mxs_gpio_ports = port;
-	gpio_table_size = cnt;
+		if (!request_mem_region(iores->start, resource_size(iores),
+					pdev->name)) {
+			err = -EBUSY;
+			goto out_kfree;
+		}
 
-	pr_info("MXS GPIO hardware\n");
+		base = ioremap(iores->start, resource_size(iores));
+		if (!base) {
+			err = -ENOMEM;
+			goto out_release_mem;
+		}
+	}
+	port->base = base;
 
-	for (i = 0; i < cnt; i++) {
-		/* disable the interrupt and clear the status */
-		__raw_writel(0, port[i].base + PINCTRL_PIN2IRQ(i));
-		__raw_writel(0, port[i].base + PINCTRL_IRQEN(i));
+	port->irq = platform_get_irq(pdev, 0);
+	if (port->irq < 0) {
+		err = -EINVAL;
+		goto out_iounmap;
+	}
 
-		/* clear address has to be used to clear IRQSTAT bits */
-		__mxs_clrl(~0U, port[i].base + PINCTRL_IRQSTAT(i));
+	/* disable the interrupt and clear the status */
+	writel(0, port->base + PINCTRL_PIN2IRQ(port->id));
+	writel(0, port->base + PINCTRL_IRQEN(port->id));
 
-		for (j = port[i].virtual_irq_start;
-			j < port[i].virtual_irq_start + 32; j++) {
-			irq_set_chip_and_handler(j, &gpio_irq_chip,
-						 handle_level_irq);
-			set_irq_flags(j, IRQF_VALID);
-		}
+	/* clear address has to be used to clear IRQSTAT bits */
+	writel(~0U, port->base + PINCTRL_IRQSTAT(port->id) + MXS_CLR);
 
-		/* setup one handler for each entry */
-		irq_set_chained_handler(port[i].irq, mxs_gpio_irq_handler);
-		irq_set_handler_data(port[i].irq, &port[i]);
-
-		/* register gpio chip */
-		port[i].chip.direction_input = mxs_gpio_direction_input;
-		port[i].chip.direction_output = mxs_gpio_direction_output;
-		port[i].chip.get = mxs_gpio_get;
-		port[i].chip.set = mxs_gpio_set;
-		port[i].chip.to_irq = mxs_gpio_to_irq;
-		port[i].chip.base = i * 32;
-		port[i].chip.ngpio = 32;
-
-		/* its a serious configuration bug when it fails */
-		BUG_ON(gpiochip_add(&port[i].chip) < 0);
+	for (i = port->virtual_irq_start;
+		i < port->virtual_irq_start + 32; i++) {
+		irq_set_chip_and_handler(i, &gpio_irq_chip,
+					 handle_level_irq);
+		set_irq_flags(i, IRQF_VALID);
+		irq_set_chip_data(i, port);
 	}
 
-	return 0;
-}
+	/* setup one handler for each entry */
+	irq_set_chained_handler(port->irq, mxs_gpio_irq_handler);
+	irq_set_handler_data(port->irq, port);
 
-#define MX23_GPIO_BASE	MX23_IO_ADDRESS(MX23_PINCTRL_BASE_ADDR)
-#define MX28_GPIO_BASE	MX28_IO_ADDRESS(MX28_PINCTRL_BASE_ADDR)
+	/* register gpio chip */
+	port->chip.direction_input = mxs_gpio_direction_input;
+	port->chip.direction_output = mxs_gpio_direction_output;
+	port->chip.get = mxs_gpio_get;
+	port->chip.set = mxs_gpio_set;
+	port->chip.to_irq = mxs_gpio_to_irq;
+	port->chip.base = port->id * 32;
+	port->chip.ngpio = 32;
 
-#define DEFINE_MXS_GPIO_PORT(_base, _irq, _id)				\
-	{								\
-		.chip.label = "gpio-" #_id,				\
-		.id = _id,						\
-		.irq = _irq,						\
-		.base = _base,						\
-		.virtual_irq_start = MXS_GPIO_IRQ_START + (_id) * 32,	\
-	}
+	err = gpiochip_add(&port->chip);
+	if (err)
+		goto out_iounmap;
 
-#ifdef CONFIG_SOC_IMX23
-static struct mxs_gpio_port mx23_gpio_ports[] = {
-	DEFINE_MXS_GPIO_PORT(MX23_GPIO_BASE, MX23_INT_GPIO0, 0),
-	DEFINE_MXS_GPIO_PORT(MX23_GPIO_BASE, MX23_INT_GPIO1, 1),
-	DEFINE_MXS_GPIO_PORT(MX23_GPIO_BASE, MX23_INT_GPIO2, 2),
-};
+	return 0;
 
-int __init mx23_register_gpios(void)
-{
-	return mxs_gpio_init(mx23_gpio_ports, ARRAY_SIZE(mx23_gpio_ports));
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
 }
-#endif
-
-#ifdef CONFIG_SOC_IMX28
-static struct mxs_gpio_port mx28_gpio_ports[] = {
-	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO0, 0),
-	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO1, 1),
-	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO2, 2),
-	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO3, 3),
-	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO4, 4),
+
+static struct platform_driver mxs_gpio_driver = {
+	.driver		= {
+		.name	= "gpio-mxs",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= mxs_gpio_probe,
 };
 
-int __init mx28_register_gpios(void)
+static int __init mxs_gpio_init(void)
 {
-	return mxs_gpio_init(mx28_gpio_ports, ARRAY_SIZE(mx28_gpio_ports));
+	return platform_driver_register(&mxs_gpio_driver);
 }
-#endif
+postcore_initcall(mxs_gpio_init);
+
+MODULE_AUTHOR("Freescale Semiconductor, "
+	      "Daniel Mack <danielncaiaq.de>, "
+	      "Juergen Beisert <kernel@pengutronix.de>");
+MODULE_DESCRIPTION("Freescale MXS GPIO");
+MODULE_LICENSE("GPL");
-- 
1.7.4.1

