Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935581Ab1ETJpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:45:04 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:45199 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935503Ab1ETJpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:45:00 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 4/4] gpio: gpio-mxs: add gpio driver for Freescale MXS architecture
Date: Fri, 20 May 2011 17:51:29 +0800
Message-Id: <1305885089-27343-5-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305885089-27343-1-git-send-email-shawn.guo@linaro.org>
References: <1305885089-27343-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpio-mxs driver by moving arch/arm/mach-mxs/gpio.c into
drivers/gpio.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/gpio/Kconfig    |    3 +
 drivers/gpio/Makefile   |    1 +
 drivers/gpio/gpio-mxs.c |  168 ++++++++++++++++++++++++++++++++++-------------
 3 files changed, 125 insertions(+), 47 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d3b2953..ccca658 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -81,6 +81,9 @@ config GPIO_IT8761E
 	help
 	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
 
+config GPIO_MXS
+	bool
+
 config GPIO_PL061
 	bool "PrimeCell PL061 GPIO support"
 	depends on ARM_AMBA
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index becef59..b06a335 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
 obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
 obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
+obj-$(CONFIG_GPIO_MXS)		+= gpio-mxs.o
 obj-$(CONFIG_GPIO_74X164)	+= 74x164.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
index 6a59bf2..b33b2bc 100644
--- a/drivers/gpio/gpio-mxs.c
+++ b/drivers/gpio/gpio-mxs.c
@@ -25,14 +25,18 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
-#include <mach/mx23.h>
-#include <mach/mx28.h>
-#include <asm-generic/bug.h>
-
-#include "gpio.h"
-
-static struct mxs_gpio_port *mxs_gpio_ports;
-static int gpio_table_size;
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
 
 #define MXS_SET		0x4
 #define MXS_CLR		0x8
@@ -76,20 +80,23 @@ static void set_gpio_irqenable(struct mxs_gpio_port *port, u32 index,
 
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
@@ -98,7 +105,7 @@ static int mxs_gpio_set_irq_type(struct irq_data *d, unsigned int type)
 {
 	u32 gpio = irq_to_gpio(d->irq);
 	u32 pin_mask = 1 << (gpio & 31);
-	struct mxs_gpio_port *port = &mxs_gpio_ports[gpio / 32];
+	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
 	void __iomem *pin_addr;
 	int edge;
 
@@ -142,7 +149,7 @@ static int mxs_gpio_set_irq_type(struct irq_data *d, unsigned int type)
 static void mxs_gpio_irq_handler(u32 irq, struct irq_desc *desc)
 {
 	u32 irq_stat;
-	struct mxs_gpio_port *port = (struct mxs_gpio_port *)irq_get_handler_data(irq);
+	struct mxs_gpio_port *port = irq_get_handler_data(irq);
 	u32 gpio_irq_no_base = port->virtual_irq_start;
 
 	desc->irq_data.chip->irq_ack(&desc->irq_data);
@@ -170,7 +177,7 @@ static int mxs_gpio_set_wake_irq(struct irq_data *d, unsigned int enable)
 {
 	u32 gpio = irq_to_gpio(d->irq);
 	u32 gpio_idx = gpio & 0x1f;
-	struct mxs_gpio_port *port = &mxs_gpio_ports[gpio / 32];
+	struct mxs_gpio_port *port = irq_data_get_irq_chip_data(d);
 
 	if (enable) {
 		if (port->irq_high && (gpio_idx >= 16))
@@ -251,47 +258,114 @@ static int mxs_gpio_direction_output(struct gpio_chip *chip,
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
-		writel(0, port[i].base + PINCTRL_PIN2IRQ(i));
-		writel(0, port[i].base + PINCTRL_IRQEN(i));
+	port->irq = platform_get_irq(pdev, 0);
+	if (port->irq < 0) {
+		err = -EINVAL;
+		goto out_iounmap;
+	}
 
-		/* clear address has to be used to clear IRQSTAT bits */
-		writel(~0U, port[i].base + PINCTRL_IRQSTAT(i) + MXS_CLR);
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
 	return 0;
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
+		.name	= "mxs-gpio",
+	},
+	.probe		= mxs_gpio_probe,
+};
+
+static int __init mxs_gpio_init(void)
+{
+	return platform_driver_register(&mxs_gpio_driver);
 }
+postcore_initcall(mxs_gpio_init);
+
+MODULE_AUTHOR("Freescale Semiconductor, "
+	      "Daniel Mack <danielncaiaq.de>, "
+	      "Juergen Beisert <kernel@pengutronix.de>");
+MODULE_DESCRIPTION("Freescale MXS GPIO");
+MODULE_LICENSE("GPL");
-- 
1.7.4.1

