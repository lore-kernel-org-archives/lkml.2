Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1CYNup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:50:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:50884 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753317Ab1CYNum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:50:42 -0400
Message-Id: <20110325135033.068696457@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:50:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Subject: [patch 2/2] microblaze: Use generic show_interrupts()
References: <20110325134935.999574075@linutronix.de>
Content-Disposition: inline; filename=microblze-show-int.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/microblaze/Kconfig      |    1 +
 arch/microblaze/kernel/irq.c |   42 ------------------------------------------
 2 files changed, 1 insertion(+), 42 deletions(-)

Index: linux-2.6-tip/arch/microblaze/Kconfig
===================================================================
--- linux-2.6-tip.orig/arch/microblaze/Kconfig
+++ linux-2.6-tip/arch/microblaze/Kconfig
@@ -18,6 +18,7 @@ config MICROBLAZE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_HARDIRQS_NO_DEPRECATED
+	select GENERIC_IRQ_SHOW
 
 config SWAP
 	def_bool n
Index: linux-2.6-tip/arch/microblaze/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/microblaze/kernel/irq.c
+++ linux-2.6-tip/arch/microblaze/kernel/irq.c
@@ -47,48 +47,6 @@ next_irq:
 	trace_hardirqs_on();
 }
 
-int show_interrupts(struct seq_file *p, void *v)
-{
-	int i = *(loff_t *) v, j;
-	struct irq_desc *desc;
-	struct irqaction *action;
-	unsigned long flags;
-
-	if (i == 0) {
-		seq_printf(p, "		");
-		for_each_online_cpu(j)
-			seq_printf(p, "CPU%-8d", j);
-		seq_putc(p, '\n');
-	}
-
-	if (i < nr_irq) {
-		desc = irq_to_desc(i);
-		raw_spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
-		if (!action)
-			goto skip;
-		seq_printf(p, "%3d: ", i);
-#ifndef CONFIG_SMP
-		seq_printf(p, "%10u ", kstat_irqs(i));
-#else
-		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
-#endif
-		seq_printf(p, " %8s", desc->status &
-					IRQ_LEVEL ? "level" : "edge");
-		seq_printf(p, " %8s", desc->irq_data.chip->name);
-		seq_printf(p, "  %s", action->name);
-
-		for (action = action->next; action; action = action->next)
-			seq_printf(p, ", %s", action->name);
-
-		seq_putc(p, '\n');
-skip:
-		raw_spin_unlock_irqrestore(&desc->lock, flags);
-	}
-	return 0;
-}
-
 /* MS: There is no any advance mapping mechanism. We are using simple 32bit
   intc without any cascades or any connection that's why mapping is 1:1 */
 unsigned int irq_create_mapping(struct irq_host *host, irq_hw_number_t hwirq)


