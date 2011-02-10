Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab1BJXjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:39:18 -0500
Received: from www.tglx.de ([62.245.132.106]:44635 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411Ab1BJXjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:39:14 -0500
Message-Id: <20110210223301.435978979@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 74/75] x86: Use generic show_interrupts
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=x86-use-generic-show-interrupts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig      |    1 
 arch/x86/kernel/irq.c |   57 +-------------------------------------------------
 2 files changed, 3 insertions(+), 55 deletions(-)

Index: linux-2.6-tip/arch/x86/Kconfig
===================================================================
--- linux-2.6-tip.orig/arch/x86/Kconfig
+++ linux-2.6-tip/arch/x86/Kconfig
@@ -66,6 +66,7 @@ config X86
 	select HAVE_SPARSE_IRQ
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
+	select GENERIC_IRQ_SHOW
 	select USE_GENERIC_SMP_HELPERS if SMP
 
 config INSTRUCTION_DECODER
Index: linux-2.6-tip/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/irq.c
+++ linux-2.6-tip/arch/x86/kernel/irq.c
@@ -44,9 +44,9 @@ void ack_bad_irq(unsigned int irq)
 
 #define irq_stats(x)		(&per_cpu(irq_stat, x))
 /*
- * /proc/interrupts printing:
+ * /proc/interrupts printing for arch specific interrupts
  */
-static int show_other_interrupts(struct seq_file *p, int prec)
+int arch_show_interrupts(struct seq_file *p, int prec)
 {
 	int j;
 
@@ -122,59 +122,6 @@ static int show_other_interrupts(struct 
 	return 0;
 }
 
-int show_interrupts(struct seq_file *p, void *v)
-{
-	unsigned long flags, any_count = 0;
-	int i = *(loff_t *) v, j, prec;
-	struct irqaction *action;
-	struct irq_desc *desc;
-
-	if (i > nr_irqs)
-		return 0;
-
-	for (prec = 3, j = 1000; prec < 10 && j <= nr_irqs; ++prec)
-		j *= 10;
-
-	if (i == nr_irqs)
-		return show_other_interrupts(p, prec);
-
-	/* print header */
-	if (i == 0) {
-		seq_printf(p, "%*s", prec + 8, "");
-		for_each_online_cpu(j)
-			seq_printf(p, "CPU%-8d", j);
-		seq_putc(p, '\n');
-	}
-
-	desc = irq_to_desc(i);
-	if (!desc)
-		return 0;
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	for_each_online_cpu(j)
-		any_count |= kstat_irqs_cpu(i, j);
-	action = desc->action;
-	if (!action && !any_count)
-		goto out;
-
-	seq_printf(p, "%*d: ", prec, i);
-	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
-	seq_printf(p, " %8s", desc->irq_data.chip->name);
-	seq_printf(p, "-%-8s", desc->name);
-
-	if (action) {
-		seq_printf(p, "  %s", action->name);
-		while ((action = action->next) != NULL)
-			seq_printf(p, ", %s", action->name);
-	}
-
-	seq_putc(p, '\n');
-out:
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	return 0;
-}
-
 /*
  * /proc/stat helpers
  */


