Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1CYN0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:26:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:34622 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752500Ab1CYNV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:21:59 -0400
Message-Id: <20110325132048.035414815@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:21:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 07/23] arm: plat-samsung: Use proper irq accessor functions
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-samsung.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/plat-samsung/irq-uart.c      |    5 ++---
 arch/arm/plat-samsung/irq-vic-timer.c |   13 +++++--------
 arch/arm/plat-samsung/wakeup-mask.c   |    8 ++++----
 3 files changed, 11 insertions(+), 15 deletions(-)

Index: linux-2.6-tip/arch/arm/plat-samsung/irq-uart.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-samsung/irq-uart.c
+++ linux-2.6-tip/arch/arm/plat-samsung/irq-uart.c
@@ -107,7 +107,6 @@ static struct irq_chip s3c_irq_uart = {
 
 static void __init s3c_init_uart_irq(struct s3c_uart_irq *uirq)
 {
-	struct irq_desc *desc = irq_to_desc(uirq->parent_irq);
 	void __iomem *reg_base = uirq->regs;
 	unsigned int irq;
 	int offs;
@@ -124,8 +123,8 @@ static void __init s3c_init_uart_irq(str
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
-	desc->irq_data.handler_data = uirq;
-	set_irq_chained_handler(uirq->parent_irq, s3c_irq_demux_uart);
+	irq_set_handler_data(uirq->parent_irq, uirq);
+	irq_set_chained_handler(uirq->parent_irq, s3c_irq_demux_uart);
 }
 
 /**
Index: linux-2.6-tip/arch/arm/plat-samsung/irq-vic-timer.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-samsung/irq-vic-timer.c
+++ linux-2.6-tip/arch/arm/plat-samsung/irq-vic-timer.c
@@ -77,14 +77,11 @@ static struct irq_chip s3c_irq_timer = {
 void __init s3c_init_vic_timer_irq(unsigned int parent_irq,
 				   unsigned int timer_irq)
 {
-	struct irq_desc *desc = irq_to_desc(parent_irq);
 
-	set_irq_chained_handler(parent_irq, s3c_irq_demux_vic_timer);
+	irq_set_chained_handler(parent_irq, s3c_irq_demux_vic_timer);
+	irq_set_irq_handler_data(parent_irq, (void *)timer_irq);
 
-	set_irq_chip(timer_irq, &s3c_irq_timer);
-	set_irq_chip_data(timer_irq, (void *)(1 << (timer_irq - IRQ_TIMER0)));
-	set_irq_handler(timer_irq, handle_level_irq);
-	set_irq_flags(timer_irq, IRQF_VALID);
-
-	desc->irq_data.handler_data = (void *)timer_irq;
+	irq_set_chip_and_handler(timer_irq, &s3c_irq_timer, handle_level_irq);
+	irq_set_chip_data(timer_irq, (void *)(1 << (timer_irq - IRQ_TIMER0)));
+	irq_set_flags(timer_irq, IRQF_VALID);
 }
Index: linux-2.6-tip/arch/arm/plat-samsung/wakeup-mask.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-samsung/wakeup-mask.c
+++ linux-2.6-tip/arch/arm/plat-samsung/wakeup-mask.c
@@ -22,7 +22,7 @@
 void samsung_sync_wakemask(void __iomem *reg,
 			   struct samsung_wakeup_mask *mask, int nr_mask)
 {
-	struct irq_desc *desc;
+	struct irq_data *data;
 	u32 val;
 
 	val = __raw_readl(reg);
@@ -33,10 +33,10 @@ void samsung_sync_wakemask(void __iomem 
 			continue;
 		}
 
-		desc = irq_to_desc(mask->irq);
+		data = irq_get_irq_data(mask->irq);
 
-		/* bit of a liberty to read this directly from irq_desc. */
-		if (desc->wake_depth > 0)
+		/* bit of a liberty to read this directly from irq_data. */
+		if (irqd_is_wakeup_set(d))
 			val &= ~mask->bit;
 		else
 			val |= mask->bit;


