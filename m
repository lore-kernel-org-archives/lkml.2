Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1CYOVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:21:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:48788 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753252Ab1CYOVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:21:19 -0400
Message-Id: <20110325142049.536190130@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 14:21:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 2/2] tile: Use generic show_interupts()
References: <20110325141938.846639464@linutronix.de>
Content-Disposition: inline; filename=tile-use-show.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig      |    1 +
 arch/tile/kernel/irq.c |   41 -----------------------------------------
 2 files changed, 1 insertion(+), 41 deletions(-)

Index: linux-2.6-tip/arch/tile/Kconfig
===================================================================
--- linux-2.6-tip.orig/arch/tile/Kconfig
+++ linux-2.6-tip/arch/tile/Kconfig
@@ -12,6 +12,7 @@ config TILE
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_HARDIRQS_NO_DEPRECATED
+	select GENERIC_IRQ_SHOW
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
Index: linux-2.6-tip/arch/tile/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/tile/kernel/irq.c
+++ linux-2.6-tip/arch/tile/kernel/irq.c
@@ -262,47 +262,6 @@ void ack_bad_irq(unsigned int irq)
  * Generic, controller-independent functions:
  */
 
-int show_interrupts(struct seq_file *p, void *v)
-{
-	int i = *(loff_t *) v, j;
-	struct irqaction *action;
-	unsigned long flags;
-
-	if (i == 0) {
-		seq_printf(p, "           ");
-		for (j = 0; j < NR_CPUS; j++)
-			if (cpu_online(j))
-				seq_printf(p, "CPU%-8d", j);
-		seq_putc(p, '\n');
-	}
-
-	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_to_desc(i);
-
-		raw_spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
-		if (!action)
-			goto skip;
-		seq_printf(p, "%3d: ", i);
-#ifndef CONFIG_SMP
-		seq_printf(p, "%10u ", kstat_irqs(i));
-#else
-		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
-#endif
-		seq_printf(p, " %14s", irq_desc_get_chip(desc)->name);
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
 #if CHIP_HAS_IPI()
 int create_irq(void)
 {


