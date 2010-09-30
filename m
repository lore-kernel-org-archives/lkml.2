Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab0I3XP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:15:58 -0400
Received: from www.tglx.de ([62.245.132.106]:52472 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939Ab0I3XP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:15:56 -0400
Message-Id: <20100930221739.565114094@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:15:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 11/47] genirq: Provide default irq init flags
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline;
	filename=genirq-provide-default-irq-init-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arch code sets it's own irq_desc.status flags right after boot and for
dynamically allocated interrupts. That might involve iterating over a
huge array.

Allow ARCH_IRQ_INIT_FLAGS to set separate flags aside of IRQ_DISABLED
which is the default.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h  |    6 ++++++
 kernel/irq/chip.c    |    2 +-
 kernel/irq/irqdesc.c |    6 +++---
 3 files changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -281,6 +281,12 @@ extern struct irq_desc *irq_to_desc_allo
  */
 #include <asm/hw_irq.h>
 
+#ifndef ARCH_IRQ_INIT_FLAGS
+# define ARCH_IRQ_INIT_FLAGS	0
+#endif
+
+#define IRQ_DEFAULT_INIT_FLAGS	(IRQ_DISABLED | ARCH_IRQ_INIT_FLAGS)
+
 extern int setup_irq(unsigned int irq, struct irqaction *new);
 extern void remove_irq(unsigned int irq, struct irqaction *act);
 
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -31,7 +31,7 @@ static void dynamic_irq_init_x(unsigned 
 
 	/* Ensure we don't have left over values from a previous use of this irq */
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	desc->status = IRQ_DISABLED;
+	desc->status = IRQ_DEFAULT_INIT_FLAGS;
 	desc->chip = &no_irq_chip;
 	desc->irq_data.chip = &no_irq_chip;
 	desc->handle_irq = handle_bad_irq;
Index: linux-2.6-tip/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/irqdesc.c
+++ linux-2.6-tip/kernel/irq/irqdesc.c
@@ -40,7 +40,7 @@ EXPORT_SYMBOL_GPL(nr_irqs);
 
 static struct irq_desc irq_desc_init = {
 	.irq	    = -1,
-	.status	    = IRQ_DISABLED,
+	.status	    = IRQ_DEFAULT_INIT_FLAGS,
 	.chip	    = &no_irq_chip,
 	.handle_irq = handle_bad_irq,
 	.depth      = 1,
@@ -119,7 +119,7 @@ void replace_irq_desc(unsigned int irq, 
 static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS_LEGACY-1] = {
 		.irq	    = -1,
-		.status	    = IRQ_DISABLED,
+		.status	    = IRQ_DEFAULT_INIT_FLAGS,
 		.chip	    = &no_irq_chip,
 		.handle_irq = handle_bad_irq,
 		.depth	    = 1,
@@ -211,7 +211,7 @@ out_unlock:
 
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
-		.status = IRQ_DISABLED,
+		.status	= IRQ_DEFAULT_INIT_FLAGS,
 		.chip = &no_irq_chip,
 		.handle_irq = handle_bad_irq,
 		.depth = 1,


