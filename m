Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab1CYNV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:21:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:34595 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751926Ab1CYNVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:21:55 -0400
Message-Id: <20110325132047.644977678@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:21:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 03/23] arm: Use genirq lockdep helper to set lock class
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=genirq-use-lockdep-helper.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the open coded access to irq_desc which will fail on sparse irq
and use the proper wrappers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-at91/gpio.c  |    2 +-
 arch/arm/mach-tegra/gpio.c |    2 +-
 arch/arm/plat-omap/gpio.c  |    4 +---
 3 files changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/arch/arm/mach-at91/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-at91/gpio.c
+++ linux-2.6-tip/arch/arm/mach-at91/gpio.c
@@ -518,7 +518,7 @@ void __init at91_gpio_irq_setup(void)
 		__raw_writel(~0, this->regbase + PIO_IDR);
 
 		for (i = 0, pin = this->chip.base; i < 32; i++, pin++) {
-			lockdep_set_class(&irq_desc[pin].lock, &gpio_lock_class);
+			irq_set_lockdep_class(pin, &gpio_lock_class);
 
 			/*
 			 * Can use the "simple" and not "edge" handler since it's
Index: linux-2.6-tip/arch/arm/mach-tegra/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-tegra/gpio.c
+++ linux-2.6-tip/arch/arm/mach-tegra/gpio.c
@@ -296,7 +296,7 @@ static int __init tegra_gpio_init(void)
 	for (i = INT_GPIO_BASE; i < (INT_GPIO_BASE + TEGRA_NR_GPIOS); i++) {
 		bank = &tegra_gpio_banks[GPIO_BANK(irq_to_gpio(i))];
 
-		lockdep_set_class(&irq_desc[i].lock, &gpio_lock_class);
+		irq_set_lockdep_class(i, &gpio_lock_class);
 		set_irq_chip_data(i, bank);
 		set_irq_chip(i, &tegra_gpio_irq_chip);
 		set_irq_handler(i, handle_simple_irq);
Index: linux-2.6-tip/arch/arm/plat-omap/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-omap/gpio.c
+++ linux-2.6-tip/arch/arm/plat-omap/gpio.c
@@ -1672,9 +1672,7 @@ static void __init omap_gpio_chip_init(s
 
 	for (j = bank->virtual_irq_start;
 		     j < bank->virtual_irq_start + bank_width; j++) {
-		struct irq_desc *d = irq_to_desc(j);
-
-		lockdep_set_class(&d->lock, &gpio_lock_class);
+		irq_set_lockdep_class(j, &gpio_lock_class);
 		set_irq_chip_data(j, bank);
 		if (bank_is_mpuio(bank))
 			set_irq_chip(j, &mpuio_irq_chip);


