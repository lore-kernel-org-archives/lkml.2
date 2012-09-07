Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509Ab2IGLPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:15:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41152 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760460Ab2IGLPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:15:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 18/19] gpio: Provide the tc3589x GPIO expander driver with an IRQ domain
Date: Fri,  7 Sep 2012 12:14:58 +0100
Message-Id: <1347016499-29354-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for Device Tree enablement all IRQ controllers
should control their own IRQ domain. This patch provides just
that for the tc3589x GPIO expander.

CC: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/gpio/gpio-tc3589x.c |   98 ++++++++++++++++++++++++++++++-------------
 1 file changed, 70 insertions(+), 28 deletions(-)

diff --git a/drivers/gpio/gpio-tc3589x.c b/drivers/gpio/gpio-tc3589x.c
index 2a82e89..6e89009 100644
--- a/drivers/gpio/gpio-tc3589x.c
+++ b/drivers/gpio/gpio-tc3589x.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/gpio.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/tc3589x.h>
 
@@ -29,6 +30,7 @@ struct tc3589x_gpio {
 	struct tc3589x *tc3589x;
 	struct device *dev;
 	struct mutex irq_lock;
+	struct irq_domain *domain;
 
 	int irq_base;
 
@@ -92,11 +94,28 @@ static int tc3589x_gpio_direction_input(struct gpio_chip *chip,
 	return tc3589x_set_bits(tc3589x, reg, 1 << pos, 0);
 }
 
+/**
+ * tc3589x_gpio_irq_get_virq(): Map an interrupt on a chip to a virtual IRQ
+ *
+ * @tc3589x_gpio: tc3589x_gpio_irq controller to operate on.
+ * @irq: index of the interrupt requested in the chip IRQs
+ *
+ * Useful for drivers to request their own IRQs.
+ */
+static int tc3589x_gpio_irq_get_virq(struct tc3589x_gpio *tc3589x_gpio,
+				     int irq)
+{
+	if (!tc3589x_gpio)
+		return -EINVAL;
+
+	return irq_create_mapping(tc3589x_gpio->domain, irq);
+}
+
 static int tc3589x_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
 	struct tc3589x_gpio *tc3589x_gpio = to_tc3589x_gpio(chip);
 
-	return tc3589x_gpio->irq_base + offset;
+	return tc3589x_gpio_irq_get_virq(tc3589x_gpio, offset);
 }
 
 static struct gpio_chip template_chip = {
@@ -113,7 +132,7 @@ static struct gpio_chip template_chip = {
 static int tc3589x_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	struct tc3589x_gpio *tc3589x_gpio = irq_data_get_irq_chip_data(d);
-	int offset = d->irq - tc3589x_gpio->irq_base;
+	int offset = d->hwirq;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -175,7 +194,7 @@ static void tc3589x_gpio_irq_sync_unlock(struct irq_data *d)
 static void tc3589x_gpio_irq_mask(struct irq_data *d)
 {
 	struct tc3589x_gpio *tc3589x_gpio = irq_data_get_irq_chip_data(d);
-	int offset = d->irq - tc3589x_gpio->irq_base;
+	int offset = d->hwirq;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -185,7 +204,7 @@ static void tc3589x_gpio_irq_mask(struct irq_data *d)
 static void tc3589x_gpio_irq_unmask(struct irq_data *d)
 {
 	struct tc3589x_gpio *tc3589x_gpio = irq_data_get_irq_chip_data(d);
-	int offset = d->irq - tc3589x_gpio->irq_base;
+	int offset = d->hwirq;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -222,8 +241,9 @@ static irqreturn_t tc3589x_gpio_irq(int irq, void *dev)
 		while (stat) {
 			int bit = __ffs(stat);
 			int line = i * 8 + bit;
+			int virq = tc3589x_gpio_irq_get_virq(tc3589x_gpio, line);
 
-			handle_nested_irq(tc3589x_gpio->irq_base + line);
+			handle_nested_irq(virq);
 			stat &= ~(1 << bit);
 		}
 
@@ -233,38 +253,60 @@ static irqreturn_t tc3589x_gpio_irq(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-static int tc3589x_gpio_irq_init(struct tc3589x_gpio *tc3589x_gpio)
+static int tc3589x_gpio_irq_map(struct irq_domain *d, unsigned int virq,
+				irq_hw_number_t hwirq)
 {
-	int base = tc3589x_gpio->irq_base;
-	int irq;
+	struct tc3589x *tc3589x_gpio = d->host_data;
 
-	for (irq = base; irq < base + tc3589x_gpio->chip.ngpio; irq++) {
-		irq_set_chip_data(irq, tc3589x_gpio);
-		irq_set_chip_and_handler(irq, &tc3589x_gpio_irq_chip,
-					 handle_simple_irq);
-		irq_set_nested_thread(irq, 1);
+	irq_set_chip_data(virq, tc3589x_gpio);
+	irq_set_chip_and_handler(virq, &tc3589x_gpio_irq_chip,
+				handle_simple_irq);
+	irq_set_nested_thread(virq, 1);
 #ifdef CONFIG_ARM
-		set_irq_flags(irq, IRQF_VALID);
+	set_irq_flags(virq, IRQF_VALID);
 #else
-		irq_set_noprobe(irq);
+	irq_set_noprobe(virq);
 #endif
-	}
 
 	return 0;
 }
 
-static void tc3589x_gpio_irq_remove(struct tc3589x_gpio *tc3589x_gpio)
+static void tc3589x_gpio_irq_unmap(struct irq_domain *d, unsigned int virq)
 {
-	int base = tc3589x_gpio->irq_base;
-	int irq;
-
-	for (irq = base; irq < base + tc3589x_gpio->chip.ngpio; irq++) {
 #ifdef CONFIG_ARM
-		set_irq_flags(irq, 0);
+	set_irq_flags(virq, 0);
 #endif
-		irq_set_chip_and_handler(irq, NULL, NULL);
-		irq_set_chip_data(irq, NULL);
+	irq_set_chip_and_handler(virq, NULL, NULL);
+	irq_set_chip_data(virq, NULL);
+}
+
+static struct irq_domain_ops tc3589x_irq_ops = {
+        .map    = tc3589x_gpio_irq_map,
+        .unmap  = tc3589x_gpio_irq_unmap,
+        .xlate  = irq_domain_xlate_twocell,
+};
+
+static int tc3589x_gpio_irq_init(struct tc3589x_gpio *tc3589x_gpio)
+{
+	int base = tc3589x_gpio->irq_base;
+
+	if (base) {
+		tc3589x_gpio->domain = irq_domain_add_legacy(
+			NULL, tc3589x_gpio->chip.ngpio, base,
+			0, &tc3589x_irq_ops, tc3589x_gpio);
 	}
+	else {
+		tc3589x_gpio->domain = irq_domain_add_linear(
+			NULL, tc3589x_gpio->chip.ngpio,
+			&tc3589x_irq_ops, tc3589x_gpio);
+	}
+
+	if (!tc3589x_gpio->domain) {
+		dev_err(tc3589x_gpio->dev, "Failed to create irqdomain\n");
+		return -ENOSYS;
+	}
+
+	return 0;
 }
 
 static int __devinit tc3589x_gpio_probe(struct platform_device *pdev)
@@ -299,6 +341,9 @@ static int __devinit tc3589x_gpio_probe(struct platform_device *pdev)
 
 	tc3589x_gpio->irq_base = tc3589x->irq_base + TC3589x_INT_GPIO(0);
 
+	tc3589x_gpio->irq_base = tc3589x->irq_base ?
+		tc3589x->irq_base + TC3589x_INT_GPIO(0) : 0;
+
 	/* Bring the GPIO module out of reset */
 	ret = tc3589x_set_bits(tc3589x, TC3589x_RSTCTRL,
 			       TC3589x_RSTCTRL_GPIRST, 0);
@@ -313,7 +358,7 @@ static int __devinit tc3589x_gpio_probe(struct platform_device *pdev)
 				   "tc3589x-gpio", tc3589x_gpio);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to get irq: %d\n", ret);
-		goto out_removeirq;
+		goto out_free;
 	}
 
 	ret = gpiochip_add(&tc3589x_gpio->chip);
@@ -331,8 +376,6 @@ static int __devinit tc3589x_gpio_probe(struct platform_device *pdev)
 
 out_freeirq:
 	free_irq(irq, tc3589x_gpio);
-out_removeirq:
-	tc3589x_gpio_irq_remove(tc3589x_gpio);
 out_free:
 	kfree(tc3589x_gpio);
 	return ret;
@@ -357,7 +400,6 @@ static int __devexit tc3589x_gpio_remove(struct platform_device *pdev)
 	}
 
 	free_irq(irq, tc3589x_gpio);
-	tc3589x_gpio_irq_remove(tc3589x_gpio);
 
 	platform_set_drvdata(pdev, NULL);
 	kfree(tc3589x_gpio);
-- 
1.7.9.5

