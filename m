Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab1BJXi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:38:29 -0500
Received: from www.tglx.de ([62.245.132.106]:44473 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366Ab1BJXiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:21 -0500
Message-Id: <20110210223300.086945047@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:38:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 60/75] genirq: Force wrapped access to desc->status in core
	code
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-protect-tglx-even-more.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Force the usage of wrappers by another nasty CPP substitution.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/handle.c   |    6 +++---
 kernel/irq/irqdesc.c  |    4 ++--
 kernel/irq/settings.h |    3 +++
 3 files changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -55,7 +55,7 @@ irqreturn_t
 handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 {
 	irqreturn_t ret, retval = IRQ_NONE;
-	unsigned int status = 0, irq = desc->irq_data.irq;
+	unsigned int random = 0, irq = desc->irq_data.irq;
 
 	do {
 		trace_irq_handler_entry(irq, action);
@@ -98,7 +98,7 @@ handle_irq_event_percpu(struct irq_desc 
 
 			/* Fall through to add to randomness */
 		case IRQ_HANDLED:
-			status |= action->flags;
+			random |= action->flags;
 			break;
 
 		default:
@@ -109,7 +109,7 @@ handle_irq_event_percpu(struct irq_desc 
 		action = action->next;
 	} while (action);
 
-	if (status & IRQF_SAMPLE_RANDOM)
+	if (random & IRQF_SAMPLE_RANDOM)
 		add_interrupt_randomness(irq);
 
 	if (!noirqdebug)
Index: linux-2.6-tip/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/irqdesc.c
+++ linux-2.6-tip/kernel/irq/irqdesc.c
@@ -79,7 +79,7 @@ static void desc_set_defaults(unsigned i
 	desc->irq_data.chip_data = NULL;
 	desc->irq_data.handler_data = NULL;
 	desc->irq_data.msi_desc = NULL;
-	desc->status = _IRQ_DEFAULT_INIT_FLAGS;
+	irq_settings_clr_and_set(desc, ~0, _IRQ_DEFAULT_INIT_FLAGS);
 	desc->istate = IRQS_DISABLED;
 	desc->handle_irq = handle_bad_irq;
 	desc->depth = 1;
@@ -230,7 +230,6 @@ int __init early_irq_init(void)
 
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
-		.status		= _IRQ_DEFAULT_INIT_FLAGS,
 		.istate		= IRQS_DISABLED,
 		.handle_irq	= handle_bad_irq,
 		.depth		= 1,
@@ -254,6 +253,7 @@ int __init early_irq_init(void)
 		desc[i].irq_data.irq = i;
 		desc[i].irq_data.chip = &no_irq_chip;
 		desc[i].kstat_irqs = alloc_percpu(unsigned int);
+		irq_settings_clr_and_set(desc, ~0, _IRQ_DEFAULT_INIT_FLAGS);
 		alloc_masks(desc + i, GFP_KERNEL, node);
 		desc_smp_init(desc + i, node);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
Index: linux-2.6-tip/kernel/irq/settings.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/settings.h
+++ linux-2.6-tip/kernel/irq/settings.h
@@ -140,3 +140,6 @@ static inline bool irq_settings_can_auto
 {
 	return !(desc->status & _IRQ_NOAUTOEN);
 }
+
+/* Nothing should touch desc->status from now on */
+#define status		USE_THE_PROPER_WRAPPERS_YOU_MORON


