Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab1CYNZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:25:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:34641 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752569Ab1CYNWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:03 -0400
Message-Id: <20110325132048.417348749@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:22:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 11/23] arm: msm: Use proper irq accessor functions
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-msm.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-msm/gpio-v2.c |    4 ++--
 arch/arm/mach-msm/gpio.c    |    4 ++--
 arch/arm/mach-msm/irq-vic.c |    4 ++--
 arch/arm/mach-msm/irq.c     |    4 ++--
 arch/arm/mach-msm/sirc.c    |    4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6-tip/arch/arm/mach-msm/gpio-v2.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/gpio-v2.c
+++ linux-2.6-tip/arch/arm/mach-msm/gpio-v2.c
@@ -275,14 +275,14 @@ static int msm_gpio_irq_set_type(struct 
 
 	if (flow_type & IRQ_TYPE_EDGE_BOTH) {
 		bits |= BIT(INTR_DECT_CTL);
-		irq_desc[irq].handle_irq = handle_edge_irq;
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
 		if ((flow_type & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH)
 			__set_bit(gpio, msm_gpio.dual_edge_irqs);
 		else
 			__clear_bit(gpio, msm_gpio.dual_edge_irqs);
 	} else {
 		bits &= ~BIT(INTR_DECT_CTL);
-		irq_desc[irq].handle_irq = handle_level_irq;
+		__irq_set_handler_locked(d->irq, handle_level_irq);
 		__clear_bit(gpio, msm_gpio.dual_edge_irqs);
 	}
 
Index: linux-2.6-tip/arch/arm/mach-msm/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/gpio.c
+++ linux-2.6-tip/arch/arm/mach-msm/gpio.c
@@ -293,10 +293,10 @@ static int msm_gpio_irq_set_type(struct 
 	val = readl(msm_chip->regs.int_edge);
 	if (flow_type & IRQ_TYPE_EDGE_BOTH) {
 		writel(val | mask, msm_chip->regs.int_edge);
-		irq_desc[d->irq].handle_irq = handle_edge_irq;
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
 	} else {
 		writel(val & ~mask, msm_chip->regs.int_edge);
-		irq_desc[d->irq].handle_irq = handle_level_irq;
+		__irq_set_handler_locked(d->irq, handle_level_irq);
 	}
 	if ((flow_type & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH) {
 		msm_chip->both_edge_detect |= mask;
Index: linux-2.6-tip/arch/arm/mach-msm/irq-vic.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/irq-vic.c
+++ linux-2.6-tip/arch/arm/mach-msm/irq-vic.c
@@ -313,11 +313,11 @@ static int msm_irq_set_type(struct irq_d
 	type = msm_irq_shadow_reg[index].int_type;
 	if (flow_type & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING)) {
 		type |= b;
-		irq_desc[d->irq].handle_irq = handle_edge_irq;
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
 	}
 	if (flow_type & (IRQF_TRIGGER_HIGH | IRQF_TRIGGER_LOW)) {
 		type &= ~b;
-		irq_desc[d->irq].handle_irq = handle_level_irq;
+		__irq_set_handler_locked(d->irq, handle_level_irq);
 	}
 	writel(type, treg);
 	msm_irq_shadow_reg[index].int_type = type;
Index: linux-2.6-tip/arch/arm/mach-msm/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/irq.c
+++ linux-2.6-tip/arch/arm/mach-msm/irq.c
@@ -100,11 +100,11 @@ static int msm_irq_set_type(struct irq_d
 
 	if (flow_type & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING)) {
 		writel(readl(treg) | b, treg);
-		irq_desc[d->irq].handle_irq = handle_edge_irq;
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
 	}
 	if (flow_type & (IRQF_TRIGGER_HIGH | IRQF_TRIGGER_LOW)) {
 		writel(readl(treg) & (~b), treg);
-		irq_desc[d->irq].handle_irq = handle_level_irq;
+		__irq_set_handler_locked(d->irq, handle_level_irq);
 	}
 	return 0;
 }
Index: linux-2.6-tip/arch/arm/mach-msm/sirc.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-msm/sirc.c
+++ linux-2.6-tip/arch/arm/mach-msm/sirc.c
@@ -105,10 +105,10 @@ static int sirc_irq_set_type(struct irq_
 	val = readl(sirc_regs.int_type);
 	if (flow_type & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING)) {
 		val |= mask;
-		irq_desc[d->irq].handle_irq = handle_edge_irq;
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
 	} else {
 		val &= ~mask;
-		irq_desc[d->irq].handle_irq = handle_level_irq;
+		__irq_set_handler_locked(d->irq, handle_level_irq);
 	}
 
 	writel(val, sirc_regs.int_type);


