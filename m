Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab1CYNW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:22:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:34696 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752750Ab1CYNWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:13 -0400
Message-Id: <20110325132049.288372222@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:22:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 20/23] arm: Use generic show_interrupts()
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-use-generic-show-interrupts.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic version and just keep the arch specific output.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/Kconfig      |    1 
 arch/arm/kernel/irq.c |   55 ++++----------------------------------------------
 2 files changed, 6 insertions(+), 50 deletions(-)

Index: linux-2.6-tip/arch/arm/Kconfig
===================================================================
--- linux-2.6-tip.orig/arch/arm/Kconfig
+++ linux-2.6-tip/arch/arm/Kconfig
@@ -28,6 +28,7 @@ config ARM
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
+	select GENERIC_IRQ_SHOW
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
Index: linux-2.6-tip/arch/arm/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/kernel/irq.c
+++ linux-2.6-tip/arch/arm/kernel/irq.c
@@ -51,63 +51,18 @@
 
 unsigned long irq_err_count;
 
-int show_interrupts(struct seq_file *p, void *v)
+int arch_show_interrupts(struct seq_file *p, int prec)
 {
-	int i = *(loff_t *) v, cpu;
-	struct irq_desc *desc;
-	struct irqaction * action;
-	unsigned long flags;
-	int prec, n;
-
-	for (prec = 3, n = 1000; prec < 10 && n <= nr_irqs; prec++)
-		n *= 10;
-
-#ifdef CONFIG_SMP
-	if (prec < 4)
-		prec = 4;
-#endif
-
-	if (i == 0) {
-		char cpuname[12];
-
-		seq_printf(p, "%*s ", prec, "");
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
-		seq_printf(p, "%*d: ", prec, i);
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
 #ifdef CONFIG_FIQ
-		show_fiq_list(p, prec);
+	show_fiq_list(p, prec);
 #endif
 #ifdef CONFIG_SMP
-		show_ipi_list(p, prec);
+	show_ipi_list(p, prec);
 #endif
 #ifdef CONFIG_LOCAL_TIMERS
-		show_local_irqs(p, prec);
+	show_local_irqs(p, prec);
 #endif
-		seq_printf(p, "%*s: %10lu\n", prec, "Err", irq_err_count);
-	}
+	seq_printf(p, "%*s: %10lu\n", prec, "Err", irq_err_count);
 	return 0;
 }
 


