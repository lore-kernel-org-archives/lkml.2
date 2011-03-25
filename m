Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1CYOQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:16:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:36994 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752607Ab1CYOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:16:56 -0400
Message-Id: <20110325141647.066138827@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 14:16:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Subject: [patch 1/4] score: Convert irq_chip to new functions
References: <20110325141528.825456671@linutronix.de>
Content-Disposition: inline;
	filename=score-convert-irq_chip-to-new-functions.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the proper accessor functions in show_interrupts() while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chen Liqin <liqin.chen@sunplusct.com>

---
 arch/score/kernel/irq.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/score/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/score/kernel/irq.c
+++ linux-2.6/arch/score/kernel/irq.c
@@ -52,9 +52,9 @@ asmlinkage void do_IRQ(int irq)
 	irq_exit();
 }
 
-static void score_mask(unsigned int irq_nr)
+static void score_mask(struct irq_data *d)
 {
-	unsigned int irq_source = 63 - irq_nr;
+	unsigned int irq_source = 63 - d->irq;
 
 	if (irq_source < 32)
 		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKL) | \
@@ -64,9 +64,9 @@ static void score_mask(unsigned int irq_
 			(1 << (irq_source - 32))), SCORE_PIC + INT_MASKH);
 }
 
-static void score_unmask(unsigned int irq_nr)
+static void score_unmask(struct irq_data *d)
 {
-	unsigned int irq_source = 63 - irq_nr;
+	unsigned int irq_source = 63 - d->irq;
 
 	if (irq_source < 32)
 		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKL) & \
@@ -78,9 +78,9 @@ static void score_unmask(unsigned int ir
 
 struct irq_chip score_irq_chip = {
 	.name		= "Score7-level",
-	.mask		= score_mask,
-	.mask_ack	= score_mask,
-	.unmask		= score_unmask,
+	.irq_mask	= score_mask,
+	.irq_mask_ack	= score_mask,
+	.irq_unmask	= score_unmask,
 };
 
 /*
@@ -127,21 +127,23 @@ int show_interrupts(struct seq_file *p, 
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_to_desc(i);
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto unlock;
 
 		seq_printf(p, "%3d: ", i);
 		seq_printf(p, "%10u ", kstat_irqs(i));
-		seq_printf(p, " %8s", irq_desc[i].chip->name ? : "-");
+		seq_printf(p, " %8s", get_irq_desc_chip(desc)->name ? : "-");
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
 			seq_printf(p, ", %s", action->name);
 
 		seq_putc(p, '\n');
 unlock:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
 	return 0;


