Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab1BGSJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:09:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62871 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab1BGSJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:09:44 -0500
From: Michal Simek <monstr@monstr.eu>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH v2] microblaze: Convert irq_chip to new functions
Date: Mon,  7 Feb 2011 19:09:36 +0100
Message-Id: <1297102176-20768-2-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1297102176-20768-1-git-send-email-monstr@monstr.eu>
References: <1297102176-20768-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Use proper irq_desc wrappers while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/intc.c |   38 +++++++++++++++++++-------------------
 arch/microblaze/kernel/irq.c  |   12 +++++++-----
 2 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
index bff99d1..e466128 100644
--- a/arch/microblaze/kernel/intc.c
+++ b/arch/microblaze/kernel/intc.c
@@ -40,46 +40,46 @@ unsigned int nr_irq;
 #define MER_ME (1<<0)
 #define MER_HIE (1<<1)
 
-static void intc_enable_or_unmask(unsigned int irq)
+static void intc_enable_or_unmask(struct irq_data *d)
 {
-	unsigned long mask = 1 << irq;
-	pr_debug("enable_or_unmask: %d\n", irq);
+	unsigned long mask = 1 << d->irq;
+	pr_debug("enable_or_unmask: %d\n", d->irq);
 	out_be32(INTC_BASE + SIE, mask);
 
 	/* ack level irqs because they can't be acked during
 	 * ack function since the handle_level_irq function
 	 * acks the irq before calling the interrupt handler
 	 */
-	if (irq_desc[irq].status & IRQ_LEVEL)
+	if (irq_to_desc(d->irq)->status & IRQ_LEVEL)
 		out_be32(INTC_BASE + IAR, mask);
 }
 
-static void intc_disable_or_mask(unsigned int irq)
+static void intc_disable_or_mask(struct irq_data *d)
 {
-	pr_debug("disable: %d\n", irq);
-	out_be32(INTC_BASE + CIE, 1 << irq);
+	pr_debug("disable: %d\n", d->irq);
+	out_be32(INTC_BASE + CIE, 1 << d->irq);
 }
 
-static void intc_ack(unsigned int irq)
+static void intc_ack(struct irq_data *d)
 {
-	pr_debug("ack: %d\n", irq);
-	out_be32(INTC_BASE + IAR, 1 << irq);
+	pr_debug("ack: %d\n", d->irq);
+	out_be32(INTC_BASE + IAR, 1 << d->irq);
 }
 
-static void intc_mask_ack(unsigned int irq)
+static void intc_mask_ack(struct irq_data *d)
 {
-	unsigned long mask = 1 << irq;
-	pr_debug("disable_and_ack: %d\n", irq);
+	unsigned long mask = 1 << d->irq;
+	pr_debug("disable_and_ack: %d\n", d->irq);
 	out_be32(INTC_BASE + CIE, mask);
 	out_be32(INTC_BASE + IAR, mask);
 }
 
 static struct irq_chip intc_dev = {
 	.name = "Xilinx INTC",
-	.unmask = intc_enable_or_unmask,
-	.mask = intc_disable_or_mask,
-	.ack = intc_ack,
-	.mask_ack = intc_mask_ack,
+	.irq_unmask = intc_enable_or_unmask,
+	.irq_mask = intc_disable_or_mask,
+	.irq_ack = intc_ack,
+	.irq_mask_ack = intc_mask_ack,
 };
 
 unsigned int get_irq(struct pt_regs *regs)
@@ -159,11 +159,11 @@ void __init init_IRQ(void)
 		if (intr_type & (0x00000001 << i)) {
 			set_irq_chip_and_handler_name(i, &intc_dev,
 				handle_edge_irq, intc_dev.name);
-			irq_desc[i].status &= ~IRQ_LEVEL;
+			irq_clear_status_flags(i, IRQ_LEVEL);
 		} else {
 			set_irq_chip_and_handler_name(i, &intc_dev,
 				handle_level_irq, intc_dev.name);
-			irq_desc[i].status |= IRQ_LEVEL;
+			irq_set_status_flags(i, IRQ_LEVEL);
 		}
 	}
 }
diff --git a/arch/microblaze/kernel/irq.c b/arch/microblaze/kernel/irq.c
index a9345fb..0988224 100644
--- a/arch/microblaze/kernel/irq.c
+++ b/arch/microblaze/kernel/irq.c
@@ -50,6 +50,7 @@ next_irq:
 int show_interrupts(struct seq_file *p, void *v)
 {
 	int i = *(loff_t *) v, j;
+	struct irq_desc *desc;
 	struct irqaction *action;
 	unsigned long flags;
 
@@ -61,8 +62,9 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < nr_irq) {
-		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		desc = irq_to_desc(i);
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ", i);
@@ -72,9 +74,9 @@ int show_interrupts(struct seq_file *p, void *v)
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
-		seq_printf(p, " %8s", irq_desc[i].status &
+		seq_printf(p, " %8s", desc->status &
 					IRQ_LEVEL ? "level" : "edge");
-		seq_printf(p, " %8s", irq_desc[i].chip->name);
+		seq_printf(p, " %8s", desc->irq_data.chip->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action = action->next; action; action = action->next)
@@ -82,7 +84,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
 skip:
-		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 	return 0;
 }
-- 
1.5.5.6

