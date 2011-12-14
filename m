Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab1LNPas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:30:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36263 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab1LNPap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:30:45 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>, shawn.guo@freescale.com,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 8/9] gpio: pl061: enable interrupts with DT style binding
Date: Wed, 14 Dec 2011 09:28:57 -0600
Message-Id: <1323876538-20406-9-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
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
 .../devicetree/bindings/gpio/pl061-gpio.txt        |   15 ++++++++++
 drivers/gpio/gpio-pl061.c                          |   29 +++++++++++--------
 2 files changed, 32 insertions(+), 12 deletions(-)

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
index 4a1874f..0151798 100644
--- a/drivers/gpio/gpio-pl061.c
+++ b/drivers/gpio/gpio-pl061.c
@@ -16,6 +16,8 @@
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/of.h>
 #include <linux/bitops.h>
 #include <linux/workqueue.h>
 #include <linux/gpio.h>
@@ -52,7 +54,7 @@ struct pl061_gpio {
 	spinlock_t		lock;		/* GPIO registers */
 
 	void __iomem		*base;
-	int			irq_base;
+	struct irq_domain	*irq_domain;
 	struct gpio_chip	gc;
 };
 
@@ -117,18 +119,16 @@ static void pl061_set_value(struct gpio_chip *gc, unsigned offset, int value)
 static int pl061_to_irq(struct gpio_chip *gc, unsigned offset)
 {
 	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
-
-	if (chip->irq_base <= 0)
-		return -EINVAL;
-
-	return chip->irq_base + offset;
+	if (!chip->irq_domain)
+		return -ENXIO;
+	return irq_domain_to_irq(chip->irq_domain, offset);
 }
 
 static int pl061_irq_type(struct irq_data *d, unsigned trigger)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct pl061_gpio *chip = gc->private;
-	int offset = d->irq - chip->irq_base;
+	int offset = d->hwirq;
 	unsigned long flags;
 	u8 gpiois, gpioibe, gpioiev;
 
@@ -212,6 +212,7 @@ static void __init pl061_init_gc(struct pl061_gpio *chip, int irq_base)
 
 	irq_setup_generic_chip(gc, IRQ_MSK(PL061_GPIO_NR),
 			       IRQ_GC_INIT_NESTED_LOCK, IRQ_NOREQUEST, 0);
+	chip->irq_domain = gc->domain;
 }
 
 static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
@@ -219,7 +220,7 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
 	struct pl061_platform_data *pdata;
 	struct pl061_gpio *chip;
 	struct list_head *chip_list;
-	int ret, irq, i;
+	int ret, irq, i, irq_base;
 	static DECLARE_BITMAP(init_irq, NR_IRQS);
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
@@ -229,10 +230,13 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
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
@@ -271,10 +275,11 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
 	 * irq_chip support
 	 */
 
-	if (chip->irq_base <= 0)
+	if (!irq_base)
 		return 0;
 
-	pl061_init_gc(chip, chip->irq_base);
+	pl061_init_gc(chip, irq_base);
+	chip->irq_domain->of_node = of_node_get(dev->dev.of_node);
 
 	writeb(0, chip->base + GPIOIE); /* disable irqs */
 	irq = dev->irq[0];
-- 
1.7.5.4

