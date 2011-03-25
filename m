Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab1CYNXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:23:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:34690 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752711Ab1CYNWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:12 -0400
Message-Id: <20110325132049.188961484@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:22:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 19/23] arm: dove: Use proper irq accessor functions
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-mach-dove.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the obsolete desc_handle_irq() helper.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/include/asm/hw_irq.h |    8 --------
 arch/arm/mach-dove/irq.c      |    5 ++---
 2 files changed, 2 insertions(+), 11 deletions(-)

Index: linux-2.6-tip/arch/arm/include/asm/hw_irq.h
===================================================================
--- linux-2.6-tip.orig/arch/arm/include/asm/hw_irq.h
+++ linux-2.6-tip/arch/arm/include/asm/hw_irq.h
@@ -10,14 +10,6 @@ static inline void ack_bad_irq(int irq)
 	irq_err_count++;
 }
 
-/*
- * Obsolete inline function for calling irq descriptor handlers.
- */
-static inline void desc_handle_irq(unsigned int irq, struct irq_desc *desc)
-{
-	desc->handle_irq(irq, desc);
-}
-
 void set_irq_flags(unsigned int irq, unsigned int flags);
 
 #define IRQF_VALID	(1 << 0)
Index: linux-2.6-tip/arch/arm/mach-dove/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-dove/irq.c
+++ linux-2.6-tip/arch/arm/mach-dove/irq.c
@@ -86,8 +86,7 @@ static void pmu_irq_handler(unsigned int
 		if (!(cause & (1 << irq)))
 			continue;
 		irq = pmu_to_irq(irq);
-		desc = irq_desc + irq;
-		desc_handle_irq(irq, desc);
+		generic_handle_irq(irq);
 	}
 }
 
@@ -124,7 +123,7 @@ void __init dove_init_irq(void)
 	for (i = IRQ_DOVE_PMU_START; i < NR_IRQS; i++) {
 		set_irq_chip(i, &pmu_irq_chip);
 		set_irq_handler(i, handle_level_irq);
-		irq_desc[i].status |= IRQ_LEVEL;
+		irq_set_status_flags(i, IRQ_LEVEL);
 		set_irq_flags(i, IRQF_VALID);
 	}
 	set_irq_chained_handler(IRQ_DOVE_PMU, pmu_irq_handler);


