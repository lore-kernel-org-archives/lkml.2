Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1CYORr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:17:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:37004 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753008Ab1CYOQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:16:57 -0400
Message-Id: <20110325141647.354463173@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 14:16:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Subject: [patch 4/4] score: Use generic show_interrupts()
References: <20110325141528.825456671@linutronix.de>
Content-Disposition: inline; filename=score-use-show.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/Kconfig      |    1 +
 arch/score/kernel/irq.c |   39 ---------------------------------------
 2 files changed, 1 insertion(+), 39 deletions(-)

Index: linux-2.6-tip/arch/score/Kconfig
===================================================================
--- linux-2.6-tip.orig/arch/score/Kconfig
+++ linux-2.6-tip/arch/score/Kconfig
@@ -4,6 +4,7 @@ config SCORE
        def_bool y
        select HAVE_GENERIC_HARDIRQS
        select GENERIC_HARDIRQS_NO_DEPRECATED
+       select GENERIC_IRQ_SHOW
 
 choice
 	prompt "System type"
Index: linux-2.6-tip/arch/score/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/score/kernel/irq.c
+++ linux-2.6-tip/arch/score/kernel/irq.c
@@ -109,42 +109,3 @@ void __init init_IRQ(void)
 		: : "r" (EXCEPTION_VECTOR_BASE_ADDR | \
 			VECTOR_ADDRESS_OFFSET_MODE16));
 }
-
-/*
- * Generic, controller-independent functions:
- */
-int show_interrupts(struct seq_file *p, void *v)
-{
-	int i = *(loff_t *)v, cpu;
-	struct irqaction *action;
-	unsigned long flags;
-
-	if (i == 0) {
-		seq_puts(p, "           ");
-		for_each_online_cpu(cpu)
-			seq_printf(p, "CPU%d       ", cpu);
-		seq_putc(p, '\n');
-	}
-
-	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_to_desc(i);
-
-		raw_spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
-		if (!action)
-			goto unlock;
-
-		seq_printf(p, "%3d: ", i);
-		seq_printf(p, "%10u ", kstat_irqs(i));
-		seq_printf(p, " %8s", irq_desc_get_chip(desc)->name ? : "-");
-		seq_printf(p, "  %s", action->name);
-		for (action = action->next; action; action = action->next)
-			seq_printf(p, ", %s", action->name);
-
-		seq_putc(p, '\n');
-unlock:
-		raw_spin_unlock_irqrestore(&desc->lock, flags);
-	}
-
-	return 0;
-}


