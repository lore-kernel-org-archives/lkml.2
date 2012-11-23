Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab2KWPTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:19:17 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37287 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab2KWPTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:19:16 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, viresh.kumar@linaro.org,
        Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/1] gpio: Provide the STMPE GPIO driver with its own IRQ Domain
Date: Fri, 23 Nov 2012 15:19:09 +0000
Message-Id: <1353683949-9275-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The STMPE GPIO driver can be used as an IRQ controller by some
related devices. Here we provide it with its very own IRQ Domain
so that IRQs can be issued dynamically. This will stand the
driver in good stead when it is enabled for Device Tree, as this
it a prerequisite.

Cc: Grant Likely <grant.likely@secretlab.ca>
Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/gpio/gpio-stmpe.c |   67 +++++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 26 deletions(-)

diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
index dce3472..5a87ed6 100644
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/gpio.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/stmpe.h>
 
@@ -28,6 +29,7 @@ struct stmpe_gpio {
 	struct stmpe *stmpe;
 	struct device *dev;
 	struct mutex irq_lock;
+	struct irq_domain *domain;
 
 	int irq_base;
 	unsigned norequest_mask;
@@ -267,38 +269,55 @@ static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-static int __devinit stmpe_gpio_irq_init(struct stmpe_gpio *stmpe_gpio)
+int stmpe_gpio_irq_map(struct irq_domain *d, unsigned int virq,
+		       irq_hw_number_t hwirq)
 {
-	int base = stmpe_gpio->irq_base;
-	int irq;
+	struct stmpe_gpio *stmpe_gpio = d->host_data;
+
+	if (!stmpe_gpio)
+		return -EINVAL;
 
-	for (irq = base; irq < base + stmpe_gpio->chip.ngpio; irq++) {
-		irq_set_chip_data(irq, stmpe_gpio);
-		irq_set_chip_and_handler(irq, &stmpe_gpio_irq_chip,
-					 handle_simple_irq);
-		irq_set_nested_thread(irq, 1);
+	irq_set_chip_data(hwirq, stmpe_gpio);
+	irq_set_chip_and_handler(hwirq, &stmpe_gpio_irq_chip,
+				 handle_simple_irq);
+	irq_set_nested_thread(hwirq, 1);
 #ifdef CONFIG_ARM
-		set_irq_flags(irq, IRQF_VALID);
+	set_irq_flags(hwirq, IRQF_VALID);
 #else
-		irq_set_noprobe(irq);
+	irq_set_noprobe(hwirq);
 #endif
-	}
 
 	return 0;
 }
 
-static void stmpe_gpio_irq_remove(struct stmpe_gpio *stmpe_gpio)
+void stmpe_gpio_irq_unmap(struct irq_domain *d, unsigned int virq)
 {
-	int base = stmpe_gpio->irq_base;
-	int irq;
-
-	for (irq = base; irq < base + stmpe_gpio->chip.ngpio; irq++) {
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
+static const struct irq_domain_ops stmpe_gpio_irq_simple_ops = {
+	.unmap = stmpe_gpio_irq_unmap,
+	.map = stmpe_gpio_irq_map,
+	.xlate = irq_domain_xlate_twocell,
+};
+
+static int __devinit stmpe_gpio_irq_init(struct stmpe_gpio *stmpe_gpio)
+{
+	int base = stmpe_gpio->irq_base;
+
+	stmpe_gpio->domain = irq_domain_add_simple(NULL,
+				stmpe_gpio->chip.ngpio, base,
+				&stmpe_gpio_irq_simple_ops, stmpe_gpio);
+	if (!stmpe_gpio->domain) {
+		dev_err(stmpe_gpio->dev, "failed to create irqdomain\n");
+		return -ENOSYS;
 	}
+
+	return 0;
 }
 
 static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
@@ -348,7 +367,7 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
 				IRQF_ONESHOT, "stmpe-gpio", stmpe_gpio);
 		if (ret) {
 			dev_err(&pdev->dev, "unable to get irq: %d\n", ret);
-			goto out_removeirq;
+			goto out_disable;
 		}
 	}
 
@@ -368,9 +387,6 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
 out_freeirq:
 	if (irq >= 0)
 		free_irq(irq, stmpe_gpio);
-out_removeirq:
-	if (irq >= 0)
-		stmpe_gpio_irq_remove(stmpe_gpio);
 out_disable:
 	stmpe_disable(stmpe, STMPE_BLOCK_GPIO);
 out_free:
@@ -398,10 +414,9 @@ static int __devexit stmpe_gpio_remove(struct platform_device *pdev)
 
 	stmpe_disable(stmpe, STMPE_BLOCK_GPIO);
 
-	if (irq >= 0) {
+	if (irq >= 0)
 		free_irq(irq, stmpe_gpio);
-		stmpe_gpio_irq_remove(stmpe_gpio);
-	}
+
 	platform_set_drvdata(pdev, NULL);
 	kfree(stmpe_gpio);
 
-- 
1.7.9.5

