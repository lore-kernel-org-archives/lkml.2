Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab1CYNWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:22:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:34709 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752854Ab1CYNW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:28 -0400
Message-Id: <20110325132049.487773096@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:22:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 22/23] arm: Reorder irq_set_ function calls
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-flip-chip-data-handler.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder 
irq_set_chip()
irq_set_chip_data()
irq_set_handler()

to

irq_set_chip()
irq_set_handler()
irq_set_chip_data()

so the next patch can combine irq_set_chip() and irq_set_handler() to
irq_set_chip_and_handler().

Automated conversion with coccinelle.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/common/gic.c                |    2 +-
 arch/arm/common/locomo.c             |    2 +-
 arch/arm/common/sa1111.c             |    4 ++--
 arch/arm/common/vic.c                |    2 +-
 arch/arm/mach-exynos4/irq-combiner.c |    2 +-
 arch/arm/mach-pxa/irq.c              |    4 ++--
 arch/arm/mach-s3c64xx/irq-eint.c     |    2 +-
 arch/arm/plat-orion/irq.c            |    2 +-
 arch/arm/plat-samsung/irq-uart.c     |    2 +-
 9 files changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6-tip/arch/arm/common/gic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/common/gic.c
+++ linux-2.6-tip/arch/arm/common/gic.c
@@ -320,8 +320,8 @@ static void __init gic_dist_init(struct 
 	 */
 	for (i = irq_start; i < irq_limit; i++) {
 		irq_set_chip(i, &gic_chip);
-		irq_set_chip_data(i, gic);
 		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_data(i, gic);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/common/locomo.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/common/locomo.c
+++ linux-2.6-tip/arch/arm/common/locomo.c
@@ -204,8 +204,8 @@ static void locomo_setup_irq(struct loco
 	/* Install handlers for IRQ_LOCOMO_* */
 	for ( ; irq <= lchip->irq_base + 3; irq++) {
 		irq_set_chip(irq, &locomo_chip);
-		irq_set_chip_data(irq, lchip);
 		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_data(irq, lchip);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 }
Index: linux-2.6-tip/arch/arm/common/sa1111.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/common/sa1111.c
+++ linux-2.6-tip/arch/arm/common/sa1111.c
@@ -473,15 +473,15 @@ static void sa1111_setup_irq(struct sa11
 
 	for (irq = IRQ_GPAIN0; irq <= SSPROR; irq++) {
 		irq_set_chip(irq, &sa1111_low_chip);
-		irq_set_chip_data(irq, sachip);
 		irq_set_handler(irq, handle_edge_irq);
+		irq_set_chip_data(irq, sachip);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
 	for (irq = AUDXMTDMADONEA; irq <= IRQ_S1_BVD1_STSCHG; irq++) {
 		irq_set_chip(irq, &sa1111_high_chip);
-		irq_set_chip_data(irq, sachip);
 		irq_set_handler(irq, handle_edge_irq);
+		irq_set_chip_data(irq, sachip);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
Index: linux-2.6-tip/arch/arm/common/vic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/common/vic.c
+++ linux-2.6-tip/arch/arm/common/vic.c
@@ -306,8 +306,8 @@ static void __init vic_set_irq_sources(v
 			unsigned int irq = irq_start + i;
 
 			irq_set_chip(irq, &vic_chip);
-			irq_set_chip_data(irq, base);
 			irq_set_handler(irq, handle_level_irq);
+			irq_set_chip_data(irq, base);
 			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 		}
 	}
Index: linux-2.6-tip/arch/arm/mach-exynos4/irq-combiner.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-exynos4/irq-combiner.c
+++ linux-2.6-tip/arch/arm/mach-exynos4/irq-combiner.c
@@ -120,8 +120,8 @@ void __init combiner_init(unsigned int c
 	for (i = irq_start; i < combiner_data[combiner_nr].irq_offset
 				+ MAX_IRQ_IN_COMBINER; i++) {
 		irq_set_chip(i, &combiner_chip);
-		irq_set_chip_data(i, &combiner_data[combiner_nr]);
 		irq_set_handler(i, handle_level_irq);
+		irq_set_chip_data(i, &combiner_data[combiner_nr]);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 }
Index: linux-2.6-tip/arch/arm/mach-pxa/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-pxa/irq.c
+++ linux-2.6-tip/arch/arm/mach-pxa/irq.c
@@ -138,8 +138,8 @@ static void __init pxa_init_low_gpio_irq
 
 	for (irq = IRQ_GPIO0; irq <= IRQ_GPIO1; irq++) {
 		irq_set_chip(irq, &pxa_low_gpio_chip);
-		irq_set_chip_data(irq, irq_base(0));
 		irq_set_handler(irq, handle_edge_irq);
+		irq_set_chip_data(irq, irq_base(0));
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
@@ -166,8 +166,8 @@ void __init pxa_init_irq(int irq_nr, set
 
 			irq = PXA_IRQ(i);
 			irq_set_chip(irq, &pxa_internal_irq_chip);
-			irq_set_chip_data(irq, base);
 			irq_set_handler(irq, handle_level_irq);
+			irq_set_chip_data(irq, base);
 			set_irq_flags(irq, IRQF_VALID);
 		}
 	}
Index: linux-2.6-tip/arch/arm/mach-s3c64xx/irq-eint.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-s3c64xx/irq-eint.c
+++ linux-2.6-tip/arch/arm/mach-s3c64xx/irq-eint.c
@@ -198,8 +198,8 @@ static int __init s3c64xx_init_irq_eint(
 
 	for (irq = IRQ_EINT(0); irq <= IRQ_EINT(27); irq++) {
 		irq_set_chip(irq, &s3c_irq_eint);
-		irq_set_chip_data(irq, (void *)eint_irq_to_bit(irq));
 		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_data(irq, (void *)eint_irq_to_bit(irq));
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
Index: linux-2.6-tip/arch/arm/plat-orion/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-orion/irq.c
+++ linux-2.6-tip/arch/arm/plat-orion/irq.c
@@ -57,8 +57,8 @@ void __init orion_irq_init(unsigned int 
 		unsigned int irq = irq_start + i;
 
 		irq_set_chip(irq, &orion_irq_chip);
-		irq_set_chip_data(irq, maskaddr);
 		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_data(irq, maskaddr);
 		irq_set_status_flags(irq, IRQ_LEVEL);
 		set_irq_flags(irq, IRQF_VALID);
 	}
Index: linux-2.6-tip/arch/arm/plat-samsung/irq-uart.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-samsung/irq-uart.c
+++ linux-2.6-tip/arch/arm/plat-samsung/irq-uart.c
@@ -118,8 +118,8 @@ static void __init s3c_init_uart_irq(str
 		irq = uirq->base_irq + offs;
 
 		irq_set_chip(irq, &s3c_irq_uart);
-		irq_set_chip_data(irq, uirq);
 		irq_set_handler(irq, handle_level_irq);
+		irq_set_chip_data(irq, uirq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 


