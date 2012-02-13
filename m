Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab2BMOoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:44:07 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:60227 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2BMOoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:44:06 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Cc: tglx@linutronix.de, devicetree-discuss@lists.ozlabs.org,
        avictor.za@gmail.com, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 4/9] ARM: at91/gpio: change comments and one variable name
Date: Mon, 13 Feb 2012 15:43:04 +0100
Message-Id: <032e5eba814724ec4f14c6b26bb2fa8556595efe.1329139662.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <2fd1ebedc5ad5ac7aeb15c590c4400212a3b06cf.1329139662.git.nicolas.ferre@atmel.com>
References: <2fd1ebedc5ad5ac7aeb15c590c4400212a3b06cf.1329139662.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What was true only on at91sam9263 about the sharing of a single AIC
IRQ line for several GPIO banks is now used by several Atmel SoCs.

Change a variable name to allow better understanding while
introducing IRQ domains in following patches.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 arch/arm/mach-at91/gpio.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
index 74d6783..b762afc 100644
--- a/arch/arm/mach-at91/gpio.c
+++ b/arch/arm/mach-at91/gpio.c
@@ -29,8 +29,8 @@
 struct at91_gpio_chip {
 	struct gpio_chip	chip;
 	struct at91_gpio_chip	*next;		/* Bank sharing same clock */
-	int			id;		/* ID of register bank */
-	void __iomem		*regbase;	/* Base of register bank */
+	int			pioc_hwirq;	/* PIO bank interrupt identifier on AIC */
+	void __iomem		*regbase;	/* PIO bank virtual address */
 	struct clk		*clock;		/* associated clock */
 };
 
@@ -285,7 +285,7 @@ static int gpio_irq_set_wake(struct irq_data *d, unsigned state)
 	else
 		wakeups[bank] &= ~mask;
 
-	irq_set_irq_wake(gpio_chip[bank].id, state);
+	irq_set_irq_wake(gpio_chip[bank].pioc_hwirq, state);
 
 	return 0;
 }
@@ -499,7 +499,7 @@ void __init at91_gpio_irq_setup(void)
 	for (pioc = 0, this = gpio_chip, prev = NULL;
 			pioc++ < gpio_banks;
 			prev = this, this++) {
-		unsigned	id = this->id;
+		unsigned	pioc_hwirq = this->pioc_hwirq;
 		unsigned	i;
 
 		__raw_writel(~0, this->regbase + PIO_IDR);
@@ -518,14 +518,14 @@ void __init at91_gpio_irq_setup(void)
 		}
 
 		/* The toplevel handler handles one bank of GPIOs, except
-		 * AT91SAM9263_ID_PIOCDE handles three... PIOC is first in
-		 * the list, so we only set up that handler.
+		 * on some SoC it can handles up to three...
+		 * We only set up the handler for the first of the list.
 		 */
 		if (prev && prev->next == this)
 			continue;
 
-		irq_set_chip_data(id, this);
-		irq_set_chained_handler(id, gpio_irq_handler);
+		irq_set_chip_data(pioc_hwirq, this);
+		irq_set_chained_handler(pioc_hwirq, gpio_irq_handler);
 	}
 	pr_info("AT91: %d gpio irqs in %d banks\n", irq - gpio_to_irq(0), gpio_banks);
 }
@@ -615,7 +615,7 @@ void __init at91_gpio_init(struct at91_gpio_bank *data, int nr_banks)
 	for (i = 0; i < nr_banks; i++) {
 		at91_gpio = &gpio_chip[i];
 
-		at91_gpio->id = data[i].id;
+		at91_gpio->pioc_hwirq = data[i].pioc_hwirq;
 		at91_gpio->chip.base = i * 32;
 
 		at91_gpio->regbase = ioremap(data[i].regbase, 512);
@@ -633,8 +633,11 @@ void __init at91_gpio_init(struct at91_gpio_bank *data, int nr_banks)
 		/* enable PIO controller's clock */
 		clk_enable(at91_gpio->clock);
 
-		/* AT91SAM9263_ID_PIOCDE groups PIOC, PIOD, PIOE */
-		if (last && last->id == at91_gpio->id)
+		/*
+		 * GPIO controller are grouped on some SoC:
+		 * PIOC, PIOD and PIOE can share the same IRQ line
+		 */
+		if (last && last->pioc_hwirq == at91_gpio->pioc_hwirq)
 			last->next = at91_gpio;
 		last = at91_gpio;
 
-- 
1.7.9

