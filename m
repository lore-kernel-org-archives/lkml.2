Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab1KXV4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 16:56:55 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:19118 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab1KXV4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 16:56:54 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, robherring2@gmail.com,
        grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        plagnioj@jcrosoft.com, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/3] ARM: at91/gpio: add irqdomain to gpio interrupts
Date: Thu, 24 Nov 2011 22:56:28 +0100
Message-Id: <edeb4da00527914f0e1038461539843c46ab0b50.1322171620.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <167b5ccfc31d9637186c5201cd83cb62df81fc0f.1322171620.git.nicolas.ferre@atmel.com>
References: <167b5ccfc31d9637186c5201cd83cb62df81fc0f.1322171620.git.nicolas.ferre@atmel.com>
In-Reply-To: <167b5ccfc31d9637186c5201cd83cb62df81fc0f.1322171620.git.nicolas.ferre@atmel.com>
References: <167b5ccfc31d9637186c5201cd83cb62df81fc0f.1322171620.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 arch/arm/mach-at91/gpio.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
index 74d6783..45a39d0 100644
--- a/arch/arm/mach-at91/gpio.c
+++ b/arch/arm/mach-at91/gpio.c
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/io.h>
+#include <linux/irqdomain.h>
 
 #include <mach/hardware.h>
 #include <mach/at91_pio.h>
@@ -32,6 +33,7 @@ struct at91_gpio_chip {
 	int			id;		/* ID of register bank */
 	void __iomem		*regbase;	/* Base of register bank */
 	struct clk		*clock;		/* associated clock */
+	struct irq_domain	domain;		/* associated irq domain */
 };
 
 #define to_at91_gpio_chip(c) container_of(c, struct at91_gpio_chip, chip)
@@ -483,6 +485,20 @@ postcore_initcall(at91_gpio_debugfs_init);
 /*--------------------------------------------------------------------------*/
 
 /*
+ * irqdomain initialization: pile up irqdomains on top of AIC range
+ */
+static void __init at91_gpio_irqdomain(struct at91_gpio_chip *at91_gpio)
+{
+	struct irq_domain	*gpio_irq_d = &at91_gpio->domain;
+
+	gpio_irq_d->irq_base =
+		gpio_irq_d->hwirq_base = gpio_to_irq(at91_gpio->chip.base);
+	gpio_irq_d->nr_irq = at91_gpio->chip.ngpio;
+	gpio_irq_d->ops = &irq_domain_simple_ops;
+	irq_domain_add(gpio_irq_d);
+}
+
+/*
  * This lock class tells lockdep that GPIO irqs are in a different
  * category than their parents, so it won't report false recursion.
  */
@@ -517,6 +533,9 @@ void __init at91_gpio_irq_setup(void)
 			set_irq_flags(irq, IRQF_VALID);
 		}
 
+		/* setup irq domain for this GPIO controller */
+		at91_gpio_irqdomain(this);
+
 		/* The toplevel handler handles one bank of GPIOs, except
 		 * AT91SAM9263_ID_PIOCDE handles three... PIOC is first in
 		 * the list, so we only set up that handler.
-- 
1.7.5.4

