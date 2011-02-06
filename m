Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1BFXEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:04:50 -0500
Received: from www.tglx.de ([62.245.132.106]:47666 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab1BFXEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:04:49 -0500
Message-Id: <20110206230415.671019942@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 23:04:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 2/3] tile: Use proper accessor functions in show_interrupt()
References: <20110206230305.461141290@linutronix.de>
Content-Disposition: inline; filename=tile-cleanup-sho-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/tile/kernel/irq.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-next/arch/tile/kernel/irq.c
===================================================================
--- linux-next.orig/arch/tile/kernel/irq.c
+++ linux-next/arch/tile/kernel/irq.c
@@ -277,8 +277,10 @@ int show_interrupts(struct seq_file *p, 
 	}
 
 	if (i < NR_IRQS) {
-		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_to_desc(i);
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ", i);
@@ -288,7 +290,7 @@ int show_interrupts(struct seq_file *p, 
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %14s", irq_desc[i].chip->name);
+		seq_printf(p, " %14s", get_irq_desc_chip(desc)->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action = action->next; action; action = action->next)
@@ -296,7 +298,7 @@ int show_interrupts(struct seq_file *p, 
 
 		seq_putc(p, '\n');
 skip:
-		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 	return 0;
 }


