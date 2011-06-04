Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab1FDLkE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 07:40:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44332 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab1FDLkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 07:40:02 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, olof@lixom.net,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v3 2/5] gpio: gpio-mxc: make it work for Freescale MXC architecture
Date: Sat,  4 Jun 2011 19:47:15 +0800
Message-Id: <1307188038-21225-3-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307188038-21225-1-git-send-email-shawn.guo@linaro.org>
References: <1307188038-21225-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch makes necessary changes as below to make gpio-mxc work
for Freescale MXC based SoCs.

 * Use readl/writel to replace mach-specific accessors
   __raw_readl/__raw_writel

 * Migrate to platform driver by adding .probe function

 * Add a list to save all mx2 ports references, so that
   mx2_gpio_irq_handler can walk through all interrupt status
   registers

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Olof Johansson <olof@lixom.net>
---
 arch/arm/plat-mxc/include/mach/gpio.h |    1 +
 drivers/gpio/Makefile                 |    1 +
 drivers/gpio/gpio-mxc.c               |  206 +++++++++++++++++++++------------
 3 files changed, 136 insertions(+), 72 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/gpio.h b/arch/arm/plat-mxc/include/mach/gpio.h
index a2747f1..f89252c 100644
--- a/arch/arm/plat-mxc/include/mach/gpio.h
+++ b/arch/arm/plat-mxc/include/mach/gpio.h
@@ -37,6 +37,7 @@
 #define irq_to_gpio(irq)	((irq) - MXC_GPIO_IRQ_START)
 
 struct mxc_gpio_port {
+	struct list_head node;
 	void __iomem *base;
 	int irq;
 	int irq_high;
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
index 6cd6d7f..0951983 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -24,11 +24,17 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <mach/hardware.h>
 #include <asm-generic/bug.h>
 
-static struct mxc_gpio_port *mxc_gpio_ports;
-static int gpio_table_size;
+/*
+ * MX2 has one interrupt *for all* gpio ports. The list is used
+ * to save the references to all ports, so that mx2_gpio_irq_handler
+ * can walk through all interrupt status registers.
+ */
+static LIST_HEAD(mxc_gpio_ports);
 
 #define cpu_is_mx1_mx2()	(cpu_is_mx1() || cpu_is_mx2())
 
@@ -50,7 +56,7 @@ static int gpio_table_size;
 
 static void _clear_gpio_irqstatus(struct mxc_gpio_port *port, u32 index)
 {
-	__raw_writel(1 << index, port->base + GPIO_ISR);
+	writel(1 << index, port->base + GPIO_ISR);
 }
 
 static void _set_gpio_irqenable(struct mxc_gpio_port *port, u32 index,
@@ -58,27 +64,30 @@ static void _set_gpio_irqenable(struct mxc_gpio_port *port, u32 index,
 {
 	u32 l;
 
-	l = __raw_readl(port->base + GPIO_IMR);
+	l = readl(port->base + GPIO_IMR);
 	l = (l & (~(1 << index))) | (!!enable << index);
-	__raw_writel(l, port->base + GPIO_IMR);
+	writel(l, port->base + GPIO_IMR);
 }
 
 static void gpio_ack_irq(struct irq_data *d)
 {
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
 	u32 gpio = irq_to_gpio(d->irq);
-	_clear_gpio_irqstatus(&mxc_gpio_ports[gpio / 32], gpio & 0x1f);
+	_clear_gpio_irqstatus(port, gpio & 0x1f);
 }
 
 static void gpio_mask_irq(struct irq_data *d)
 {
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
 	u32 gpio = irq_to_gpio(d->irq);
-	_set_gpio_irqenable(&mxc_gpio_ports[gpio / 32], gpio & 0x1f, 0);
+	_set_gpio_irqenable(port, gpio & 0x1f, 0);
 }
 
 static void gpio_unmask_irq(struct irq_data *d)
 {
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
 	u32 gpio = irq_to_gpio(d->irq);
-	_set_gpio_irqenable(&mxc_gpio_ports[gpio / 32], gpio & 0x1f, 1);
+	_set_gpio_irqenable(port, gpio & 0x1f, 1);
 }
 
 static int mxc_gpio_get(struct gpio_chip *chip, unsigned offset);
@@ -86,7 +95,7 @@ static int mxc_gpio_get(struct gpio_chip *chip, unsigned offset);
 static int gpio_set_irq_type(struct irq_data *d, u32 type)
 {
 	u32 gpio = irq_to_gpio(d->irq);
-	struct mxc_gpio_port *port = &mxc_gpio_ports[gpio / 32];
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
 	u32 bit, val;
 	int edge;
 	void __iomem *reg = port->base;
@@ -122,8 +131,8 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 
 	reg += GPIO_ICR1 + ((gpio & 0x10) >> 2); /* lower or upper register */
 	bit = gpio & 0xf;
-	val = __raw_readl(reg) & ~(0x3 << (bit << 1));
-	__raw_writel(val | (edge << (bit << 1)), reg);
+	val = readl(reg) & ~(0x3 << (bit << 1));
+	writel(val | (edge << (bit << 1)), reg);
 	_clear_gpio_irqstatus(port, gpio & 0x1f);
 
 	return 0;
@@ -137,7 +146,7 @@ static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
 
 	reg += GPIO_ICR1 + ((gpio & 0x10) >> 2); /* lower or upper register */
 	bit = gpio & 0xf;
-	val = __raw_readl(reg);
+	val = readl(reg);
 	edge = (val >> (bit << 1)) & 3;
 	val &= ~(0x3 << (bit << 1));
 	if (edge == GPIO_INT_HIGH_LEV) {
@@ -151,7 +160,7 @@ static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
 		       gpio, edge);
 		return;
 	}
-	__raw_writel(val | (edge << (bit << 1)), reg);
+	writel(val | (edge << (bit << 1)), reg);
 }
 
 /* handle 32 interrupts in one status register */
@@ -177,8 +186,7 @@ static void mx3_gpio_irq_handler(u32 irq, struct irq_desc *desc)
 	u32 irq_stat;
 	struct mxc_gpio_port *port = irq_get_handler_data(irq);
 
-	irq_stat = __raw_readl(port->base + GPIO_ISR) &
-			__raw_readl(port->base + GPIO_IMR);
+	irq_stat = readl(port->base + GPIO_ISR) & readl(port->base + GPIO_IMR);
 
 	mxc_gpio_irq_handler(port, irq_stat);
 }
@@ -186,19 +194,18 @@ static void mx3_gpio_irq_handler(u32 irq, struct irq_desc *desc)
 /* MX2 has one interrupt *for all* gpio ports */
 static void mx2_gpio_irq_handler(u32 irq, struct irq_desc *desc)
 {
-	int i;
 	u32 irq_msk, irq_stat;
-	struct mxc_gpio_port *port = irq_get_handler_data(irq);
+	struct mxc_gpio_port *port;
 
 	/* walk through all interrupt status registers */
-	for (i = 0; i < gpio_table_size; i++) {
-		irq_msk = __raw_readl(port[i].base + GPIO_IMR);
+	list_for_each_entry(port, &mxc_gpio_ports, node) {
+		irq_msk = readl(port->base + GPIO_IMR);
 		if (!irq_msk)
 			continue;
 
-		irq_stat = __raw_readl(port[i].base + GPIO_ISR) & irq_msk;
+		irq_stat = readl(port->base + GPIO_ISR) & irq_msk;
 		if (irq_stat)
-			mxc_gpio_irq_handler(&port[i], irq_stat);
+			mxc_gpio_irq_handler(port, irq_stat);
 	}
 }
 
@@ -215,7 +222,7 @@ static int gpio_set_wake_irq(struct irq_data *d, u32 enable)
 {
 	u32 gpio = irq_to_gpio(d->irq);
 	u32 gpio_idx = gpio & 0x1F;
-	struct mxc_gpio_port *port = &mxc_gpio_ports[gpio / 32];
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
 
 	if (enable) {
 		if (port->irq_high && (gpio_idx >= 16))
@@ -250,12 +257,12 @@ static void _set_gpio_direction(struct gpio_chip *chip, unsigned offset,
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
-	l = __raw_readl(port->base + GPIO_GDIR);
+	l = readl(port->base + GPIO_GDIR);
 	if (dir)
 		l |= 1 << offset;
 	else
 		l &= ~(1 << offset);
-	__raw_writel(l, port->base + GPIO_GDIR);
+	writel(l, port->base + GPIO_GDIR);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
@@ -268,8 +275,8 @@ static void mxc_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
-	l = (__raw_readl(reg) & (~(1 << offset))) | (!!value << offset);
-	__raw_writel(l, reg);
+	l = (readl(reg) & (~(1 << offset))) | (!!value << offset);
+	writel(l, reg);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
@@ -278,7 +285,7 @@ static int mxc_gpio_get(struct gpio_chip *chip, unsigned offset)
 	struct mxc_gpio_port *port =
 		container_of(chip, struct mxc_gpio_port, chip);
 
-	return (__raw_readl(port->base + GPIO_PSR) >> offset) & 1;
+	return (readl(port->base + GPIO_PSR) >> offset) & 1;
 }
 
 static int mxc_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
@@ -301,61 +308,116 @@ static int mxc_gpio_direction_output(struct gpio_chip *chip,
  */
 static struct lock_class_key gpio_lock_class;
 
-int __init mxc_gpio_init(struct mxc_gpio_port *port, int cnt)
+static int __devinit mxc_gpio_probe(struct platform_device *pdev)
 {
-	int i, j;
-
-	/* save for local usage */
-	mxc_gpio_ports = port;
-	gpio_table_size = cnt;
-
-	printk(KERN_INFO "MXC GPIO hardware\n");
-
-	for (i = 0; i < cnt; i++) {
-		/* disable the interrupt and clear the status */
-		__raw_writel(0, port[i].base + GPIO_IMR);
-		__raw_writel(~0, port[i].base + GPIO_ISR);
-		for (j = port[i].virtual_irq_start;
-			j < port[i].virtual_irq_start + 32; j++) {
-			irq_set_lockdep_class(j, &gpio_lock_class);
-			irq_set_chip_and_handler(j, &gpio_irq_chip,
-						 handle_level_irq);
-			set_irq_flags(j, IRQF_VALID);
-		}
+	struct mxc_gpio_port *port;
+	struct resource *iores;
+	int err, i;
 
-		/* register gpio chip */
-		port[i].chip.direction_input = mxc_gpio_direction_input;
-		port[i].chip.direction_output = mxc_gpio_direction_output;
-		port[i].chip.get = mxc_gpio_get;
-		port[i].chip.set = mxc_gpio_set;
-		port[i].chip.base = i * 32;
-		port[i].chip.ngpio = 32;
+	port = kzalloc(sizeof(struct mxc_gpio_port), GFP_KERNEL);
+	if (!port)
+		return -ENOMEM;
 
-		spin_lock_init(&port[i].lock);
+	port->virtual_irq_start = MXC_GPIO_IRQ_START + pdev->id * 32;
 
-		/* its a serious configuration bug when it fails */
-		BUG_ON( gpiochip_add(&port[i].chip) < 0 );
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iores) {
+		err = -ENODEV;
+		goto out_kfree;
+	}
 
-		if (cpu_is_mx1() || cpu_is_mx3() || cpu_is_mx25() || cpu_is_mx51()) {
-			/* setup one handler for each entry */
-			irq_set_chained_handler(port[i].irq,
-						mx3_gpio_irq_handler);
-			irq_set_handler_data(port[i].irq, &port[i]);
-			if (port[i].irq_high) {
-				/* setup handler for GPIO 16 to 31 */
-				irq_set_chained_handler(port[i].irq_high,
-							mx3_gpio_irq_handler);
-				irq_set_handler_data(port[i].irq_high,
-						     &port[i]);
-			}
-		}
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
 	}
 
 	if (cpu_is_mx2()) {
 		/* setup one handler for all GPIO interrupts */
-		irq_set_chained_handler(port[0].irq, mx2_gpio_irq_handler);
-		irq_set_handler_data(port[0].irq, port);
+		if (pdev->id == 0)
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
 	}
 
+	/* register gpio chip */
+	port->chip.direction_input = mxc_gpio_direction_input;
+	port->chip.direction_output = mxc_gpio_direction_output;
+	port->chip.get = mxc_gpio_get;
+	port->chip.set = mxc_gpio_set;
+	port->chip.base = pdev->id * 32;
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
 	return 0;
+
+out_iounmap:
+	iounmap(port->base);
+out_release_mem:
+	release_mem_region(iores->start, resource_size(iores));
+out_kfree:
+	kfree(port);
+	dev_info(&pdev->dev, "%s failed with errno %d\n", __func__, err);
+	return err;
 }
+
+static struct platform_driver mxc_gpio_driver = {
+	.driver		= {
+		.name	= "gpio-mxc",
+		.owner	= THIS_MODULE,
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

