Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab2BCWfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 17:35:53 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:62787 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755426Ab2BCWfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 17:35:24 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, shawn.guo@linaro.org,
        b-cousson@ti.com, Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>
Subject: [PATCH v4 4/4] gpio: pl061: enable interrupts with DT style binding
Date: Fri,  3 Feb 2012 16:35:12 -0600
Message-Id: <1328308512-22594-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1328308512-22594-1-git-send-email-robherring2@gmail.com>
References: <1328308512-22594-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Enable DT interrupt binding support for pl061 gpio lines. If the gpio
node has an interrupt-controller property, then it will be setup to
handle interrupts on gpio lines.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>
---
 .../devicetree/bindings/gpio/pl061-gpio.txt        |   15 ++++++
 drivers/gpio/gpio-pl061.c                          |   48 ++++++++++---------
 2 files changed, 40 insertions(+), 23 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/pl061-gpio.txt b/Documentation/devicetree/bindings/gpio/pl061-gpio.txt
index a2c416b..9671d4e 100644
--- a/Documentation/devicetree/bindings/gpio/pl061-gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/pl061-gpio.txt
@@ -8,3 +8,18 @@ Required properties:
 - gpio-controller : Marks the device node as a GPIO controller.
 - interrupts : Interrupt mapping for GPIO IRQ.
 
+Optional properties:
+- interrupt-controller : Identifies the node as an interrupt controller. Must
+  be present if using gpios lines for interrupts.
+- #interrupt-cells : Specifies the number of cells needed to encode an
+  interrupt source.  The type shall be a <u32> and the value shall be 2.
+
+  The 1st cell contains the interrupt number 0-7 corresponding to the gpio
+  line.
+
+  The 2nd cell is the flags, encoding trigger type and level flags.
+	1 = low-to-high edge triggered
+	2 = high-to-low edge triggered
+	4 = active high level-sensitive
+	8 = active low level-sensitive
+
diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
index 77c9cc7..b271a17 100644
--- a/drivers/gpio/gpio-pl061.c
+++ b/drivers/gpio/gpio-pl061.c
@@ -15,6 +15,8 @@
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/of.h>
 #include <linux/bitops.h>
 #include <linux/workqueue.h>
 #include <linux/gpio.h>
@@ -56,7 +58,6 @@ struct pl061_gpio {
 	spinlock_t		lock;		/* GPIO registers */
 
 	void __iomem		*base;
-	int			irq_base;
 	struct irq_chip_generic	*irq_gc;
 	struct gpio_chip	gc;
 
@@ -126,18 +127,16 @@ static void pl061_set_value(struct gpio_chip *gc, unsigned offset, int value)
 static int pl061_to_irq(struct gpio_chip *gc, unsigned offset)
 {
 	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
-
-	if (chip->irq_base <= 0)
-		return -EINVAL;
-
-	return chip->irq_base + offset;
+	if (!chip->irq_gc)
+		return -ENXIO;
+	return irq_find_mapping(chip->irq_gc->domain, offset);
 }
 
 static int pl061_irq_type(struct irq_data *d, unsigned trigger)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct pl061_gpio *chip = gc->private;
-	int offset = d->irq - chip->irq_base;
+	int offset = d->hwirq;
 	unsigned long flags;
 	u8 gpiois, gpioibe, gpioiev;
 
@@ -197,30 +196,25 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 	chained_irq_exit(irqchip, desc);
 }
 
-static void __init pl061_init_gc(struct pl061_gpio *chip, int irq_base)
+static void __init pl061_init_gc(struct irq_chip_generic *gc)
 {
-	struct irq_chip_type *ct;
+	struct irq_chip_type *ct = gc->chip_types;
+	struct pl061_gpio *chip = gc->private;
 
-	chip->irq_gc = irq_alloc_generic_chip("gpio-pl061", 1, irq_base,
-					      chip->base, handle_simple_irq);
-	chip->irq_gc->private = chip;
+	chip->irq_gc = gc;
 
-	ct = chip->irq_gc->chip_types;
 	ct->chip.irq_mask = irq_gc_mask_clr_bit;
 	ct->chip.irq_unmask = irq_gc_mask_set_bit;
 	ct->chip.irq_set_type = pl061_irq_type;
 	ct->chip.irq_set_wake = irq_gc_set_wake;
 	ct->regs.mask = GPIOIE;
-
-	irq_setup_generic_chip(chip->irq_gc, IRQ_MSK(PL061_GPIO_NR),
-			       IRQ_GC_INIT_NESTED_LOCK, IRQ_NOREQUEST, 0);
 }
 
 static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
 {
 	struct pl061_platform_data *pdata;
 	struct pl061_gpio *chip;
-	int ret, irq, i;
+	int ret, irq, i, irq_base;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (chip == NULL)
@@ -229,10 +223,13 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
 	pdata = dev->dev.platform_data;
 	if (pdata) {
 		chip->gc.base = pdata->gpio_base;
-		chip->irq_base = pdata->irq_base;
+		irq_base = pdata->irq_base;
 	} else if (dev->dev.of_node) {
 		chip->gc.base = -1;
-		chip->irq_base = 0;
+		if (of_get_property(dev->dev.of_node, "interrupt-controller", NULL))
+			irq_base = -1;
+		else
+			irq_base = 0;
 	} else {
 		ret = -ENODEV;
 		goto free_mem;
@@ -267,13 +264,18 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
 		goto iounmap;
 
 	/*
-	 * irq_chip support
+	 * irq_chip support. If irq_base is 0, then we don't support interrupts
+	 * on gpio lines and just return now. Otherwise setup the interrupts.
 	 */
-
-	if (chip->irq_base <= 0)
+	if (!irq_base)
 		return 0;
 
-	pl061_init_gc(chip, chip->irq_base);
+	irq_setup_generic_chip_domain("gpio-pl061",
+				      of_node_get(dev->dev.of_node),
+				      1, irq_base, chip->base,
+				      handle_simple_irq,
+				      PL061_GPIO_NR, IRQ_GC_INIT_NESTED_LOCK,
+				      IRQ_NOREQUEST, 0, pl061_init_gc, chip);
 
 	writeb(0, chip->base + GPIOIE); /* disable irqs */
 	irq = dev->irq[0];
-- 
1.7.5.4

