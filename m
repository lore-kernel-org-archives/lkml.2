Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1CYO1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:27:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:51376 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753604Ab1CYO0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:26:44 -0400
Message-Id: <20110325142511.735713243@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 14:26:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [patch 2/2] unicore32: Use generic show_interrupts()
References: <20110325142344.058372664@linutronix.de>
Content-Disposition: inline; filename=unicore-show.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/unicore32/Kconfig      |    1 +
 arch/unicore32/kernel/irq.c |   42 ------------------------------------------
 2 files changed, 1 insertion(+), 42 deletions(-)

Index: linux-2.6-tip/arch/unicore32/Kconfig
===================================================================
--- linux-2.6-tip.orig/arch/unicore32/Kconfig
+++ linux-2.6-tip/arch/unicore32/Kconfig
@@ -11,6 +11,7 @@ config UNICORE32
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IRQ_PROBE
 	select GENERIC_HARDIRQS_NO_DEPRECATED
+	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_FRAME_POINTERS
 	help
 	  UniCore-32 is 32-bit Instruction Set Architecture,
Index: linux-2.6-tip/arch/unicore32/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/unicore32/kernel/irq.c
+++ linux-2.6-tip/arch/unicore32/kernel/irq.c
@@ -355,48 +355,6 @@ void __init init_IRQ(void)
 #endif
 }
 
-int show_interrupts(struct seq_file *p, void *v)
-{
-	int i = *(loff_t *) v, cpu;
-	struct irq_desc *desc;
-	struct irqaction *action;
-	unsigned long flags;
-
-	if (i == 0) {
-		char cpuname[12];
-
-		seq_printf(p, "    ");
-		for_each_present_cpu(cpu) {
-			sprintf(cpuname, "CPU%d", cpu);
-			seq_printf(p, " %10s", cpuname);
-		}
-		seq_putc(p, '\n');
-	}
-
-	if (i < nr_irqs) {
-		desc = irq_to_desc(i);
-		raw_spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
-		if (!action)
-			goto unlock;
-
-		seq_printf(p, "%3d: ", i);
-		for_each_present_cpu(cpu)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
-		seq_printf(p, " %10s", desc->irq_data.chip->name ? : "-");
-		seq_printf(p, "  %s", action->name);
-		for (action = action->next; action; action = action->next)
-			seq_printf(p, ", %s", action->name);
-
-		seq_putc(p, '\n');
-unlock:
-		raw_spin_unlock_irqrestore(&desc->lock, flags);
-	} else if (i == nr_irqs) {
-		seq_printf(p, "Error in interrupt!\n");
-	}
-	return 0;
-}
-
 /*
  * do_IRQ handles all hardware IRQ's.  Decoded IRQs should not
  * come via this function.  Instead, they should provide their


