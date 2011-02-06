Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab1BFWpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 17:45:44 -0500
Received: from www.tglx.de ([62.245.132.106]:59974 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab1BFWpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 17:45:42 -0500
Message-Id: <20110206224515.322707425@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 22:45:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>
Subject: [patch 3/4] um: Use proper accessors in show_interrupts()
References: <20110206224358.096841291@linutronix.de>
Content-Disposition: inline;
	filename=um-use-proper-accessors-in-show-interrupts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/um/kernel/irq.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-next/arch/um/kernel/irq.c
===================================================================
--- linux-next.orig/arch/um/kernel/irq.c
+++ linux-next/arch/um/kernel/irq.c
@@ -35,8 +35,10 @@ int show_interrupts(struct seq_file *p, 
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
 		seq_printf(p, "%3d: ",i);
@@ -46,7 +48,7 @@ int show_interrupts(struct seq_file *p, 
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %14s", irq_desc[i].chip->name);
+		seq_printf(p, " %14s", get_irq_desc_chip(desc)->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -54,7 +56,7 @@ int show_interrupts(struct seq_file *p, 
 
 		seq_putc(p, '\n');
 skip:
-		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == NR_IRQS)
 		seq_putc(p, '\n');
 


