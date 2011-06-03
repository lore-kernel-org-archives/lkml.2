Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab1FCObE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:31:04 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:54977
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754797Ab1FCObB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:31:01 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz936eK1432N98dKzz1202hzz8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 3 Jun 2011 22:34:07 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Shawn Guo <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <patches@linaro.org>, <grant.likely@secretlab.ca>,
        <kernel@pengutronix.de>, <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/4] Move plat-mxc gpio driver into drivers/gpio
Message-ID: <20110603143406.GA19344@S2100-06.ap.freescale.net>
References: <1306985632-18820-1-git-send-email-shawn.guo@linaro.org>
 <20110603075201.GE10532@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110603075201.GE10532@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Fri, Jun 03, 2011 at 08:52:01AM +0100, Russell King - ARM Linux wrote:
> On Thu, Jun 02, 2011 at 11:33:48AM +0800, Shawn Guo wrote:
> >  arch/arm/plat-mxc/gpio.c                        |  361 -------------------
> >  drivers/gpio/gpio-mxc.c                         |  433 +++++++++++++++++++++++
>
My bad here.  I should have used 'git diff --stat -M' to show the
the following.
 
.../arm/plat-mxc/gpio.c => drivers/gpio/gpio-mxc.c |  216 +++++++++++++-------

> I'm wondering why just moving this driver into drivers/gpio has
> resulted in it growing by 72 lines - and it's not clear from the
> diffs why that is because of the way they're broken up.
> 
Yes, I agree.  But when I did something like that to ease the review,
people think it's not necessary :)

http://permalink.gmane.org/gmane.linux.kernel/1143257

> Would it not be better to have the first patch to merely move
> arch/arm/plat-mxc/gpio.c to drivers/gpio/gpio-mxc.c, making whatever
> config changes are necessary.  Then subsequent patches should change
> drivers/gpio/gpio-mxc.c as required - which means we can see what
> changes are being made.
> 
Yes, I agree this is the best practice.  Will do it in the future
posts.

To answer your question about 72 lines growing, here is what copied
from patch #1 commit message.

--- quote begins ---
Add gpio-mxc driver by copying arch/arm/plat-mxc/gpio.c into
drivers/gpio with the following changes.

 * Use readl/writel to replace mach-specific accessors
   __raw_readl/__raw_writel

 * Migrate to platform driver by adding .probe function

 * Add a list to save all mx2 ports references, so that
   mx2_gpio_irq_handler can walk through all interrupt status
   registers
--- quote ends ---

And the following is what the changes are exactly.

--- arch/arm/plat-mxc/gpio.c	2011-06-03 22:25:56.358274709 +0800
+++ drivers/gpio/gpio-mxc.c	2011-06-01 18:38:21.410182809 +0800
@@ -24,11 +24,28 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <mach/hardware.h>
 #include <asm-generic/bug.h>
 
-static struct mxc_gpio_port *mxc_gpio_ports;
-static int gpio_table_size;
+struct mxc_gpio_port {
+	struct list_head node;
+	void __iomem *base;
+	int irq;
+	int irq_high;
+	int virtual_irq_start;
+	struct gpio_chip chip;
+	u32 both_edges;
+	spinlock_t lock;
+};
+
+/*
+ * MX2 has one interrupt *for all* gpio ports. The list is used
+ * to save the references to all ports, so that mx2_gpio_irq_handler
+ * can walk through all interrupt status registers.
+ */
+static LIST_HEAD(mxc_gpio_ports);
 
 #define cpu_is_mx1_mx2()	(cpu_is_mx1() || cpu_is_mx2())
 
@@ -50,7 +67,7 @@ static int gpio_table_size;
 
 static void _clear_gpio_irqstatus(struct mxc_gpio_port *port, u32 index)
 {
-	__raw_writel(1 << index, port->base + GPIO_ISR);
+	writel(1 << index, port->base + GPIO_ISR);
 }
 
 static void _set_gpio_irqenable(struct mxc_gpio_port *port, u32 index,
@@ -58,27 +75,30 @@ static void _set_gpio_irqenable(struct m
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
@@ -86,7 +106,7 @@ static int mxc_gpio_get(struct gpio_chip
 static int gpio_set_irq_type(struct irq_data *d, u32 type)
 {
 	u32 gpio = irq_to_gpio(d->irq);
-	struct mxc_gpio_port *port = &mxc_gpio_ports[gpio / 32];
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
 	u32 bit, val;
 	int edge;
 	void __iomem *reg = port->base;
@@ -122,8 +142,8 @@ static int gpio_set_irq_type(struct irq_
 
 	reg += GPIO_ICR1 + ((gpio & 0x10) >> 2); /* lower or upper register */
 	bit = gpio & 0xf;
-	val = __raw_readl(reg) & ~(0x3 << (bit << 1));
-	__raw_writel(val | (edge << (bit << 1)), reg);
+	val = readl(reg) & ~(0x3 << (bit << 1));
+	writel(val | (edge << (bit << 1)), reg);
 	_clear_gpio_irqstatus(port, gpio & 0x1f);
 
 	return 0;
@@ -137,7 +157,7 @@ static void mxc_flip_edge(struct mxc_gpi
 
 	reg += GPIO_ICR1 + ((gpio & 0x10) >> 2); /* lower or upper register */
 	bit = gpio & 0xf;
-	val = __raw_readl(reg);
+	val = readl(reg);
 	edge = (val >> (bit << 1)) & 3;
 	val &= ~(0x3 << (bit << 1));
 	if (edge == GPIO_INT_HIGH_LEV) {
@@ -151,7 +171,7 @@ static void mxc_flip_edge(struct mxc_gpi
 		       gpio, edge);
 		return;
 	}
-	__raw_writel(val | (edge << (bit << 1)), reg);
+	writel(val | (edge << (bit << 1)), reg);
 }
 
 /* handle 32 interrupts in one status register */
@@ -177,8 +197,7 @@ static void mx3_gpio_irq_handler(u32 irq
 	u32 irq_stat;
 	struct mxc_gpio_port *port = irq_get_handler_data(irq);
 
-	irq_stat = __raw_readl(port->base + GPIO_ISR) &
-			__raw_readl(port->base + GPIO_IMR);
+	irq_stat = readl(port->base + GPIO_ISR) & readl(port->base + GPIO_IMR);
 
 	mxc_gpio_irq_handler(port, irq_stat);
 }
@@ -186,19 +205,18 @@ static void mx3_gpio_irq_handler(u32 irq
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
 
@@ -215,7 +233,7 @@ static int gpio_set_wake_irq(struct irq_
 {
 	u32 gpio = irq_to_gpio(d->irq);
 	u32 gpio_idx = gpio & 0x1F;
-	struct mxc_gpio_port *port = &mxc_gpio_ports[gpio / 32];
+	struct mxc_gpio_port *port = irq_data_get_irq_chip_data(d);
 
 	if (enable) {
 		if (port->irq_high && (gpio_idx >= 16))
@@ -250,12 +268,12 @@ static void _set_gpio_direction(struct g
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
 
@@ -268,8 +286,8 @@ static void mxc_gpio_set(struct gpio_chi
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
-	l = (__raw_readl(reg) & (~(1 << offset))) | (!!value << offset);
-	__raw_writel(l, reg);
+	l = (readl(reg) & (~(1 << offset))) | (!!value << offset);
+	writel(l, reg);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
@@ -278,7 +296,7 @@ static int mxc_gpio_get(struct gpio_chip
 	struct mxc_gpio_port *port =
 		container_of(chip, struct mxc_gpio_port, chip);
 
-	return (__raw_readl(port->base + GPIO_PSR) >> offset) & 1;
+	return (readl(port->base + GPIO_PSR) >> offset) & 1;
 }
 
 static int mxc_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
@@ -301,61 +319,115 @@ static int mxc_gpio_direction_output(str
  */
 static struct lock_class_key gpio_lock_class;
 
-int __init mxc_gpio_init(struct mxc_gpio_port *port, int cnt)
+static int __devinit mxc_gpio_probe(struct platform_device *pdev)
 {
-	int i, j;
+	struct mxc_gpio_port *port;
+	struct resource *iores;
+	int err, i;
+
+	port = kzalloc(sizeof(struct mxc_gpio_port), GFP_KERNEL);
+	if (!port)
+		return -ENOMEM;
+
+	port->virtual_irq_start = MXC_GPIO_IRQ_START + pdev->id * 32;
+
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iores) {
+		err = -ENODEV;
+		goto out_kfree;
+	}
 
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
+	if (!request_mem_region(iores->start, resource_size(iores),
+				pdev->name)) {
+		err = -EBUSY;
+		goto out_kfree;
+	}
 
-		/* register gpio chip */
-		port[i].chip.direction_input = mxc_gpio_direction_input;
-		port[i].chip.direction_output = mxc_gpio_direction_output;
-		port[i].chip.get = mxc_gpio_get;
-		port[i].chip.set = mxc_gpio_set;
-		port[i].chip.base = i * 32;
-		port[i].chip.ngpio = 32;
-
-		spin_lock_init(&port[i].lock);
-
-		/* its a serious configuration bug when it fails */
-		BUG_ON( gpiochip_add(&port[i].chip) < 0 );
-
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
Regards,
Shawn

