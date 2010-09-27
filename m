Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab0I0MqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:46:05 -0400
Received: from www.tglx.de ([62.245.132.106]:48847 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759231Ab0I0MqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:46:01 -0400
Message-Id: <20100927121842.732894108@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:45:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 13/19] genirq; Provide compat handling for chip->set_affinity()
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=genirq-wrap-chip-set-affinity.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the old chip function set_affinity() until the migration is
complete and the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c      |    8 ++++++++
 kernel/irq/manage.c    |   11 ++++++-----
 kernel/irq/migration.c |    6 ++++--
 kernel/irq/proc.c      |    2 +-
 4 files changed, 19 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -373,6 +373,12 @@ static unsigned int compat_irq_startup(s
 	return irq_data_to_desc(data)->chip->startup(data->irq);
 }
 
+static int compat_irq_set_affinity(struct irq_data *data,
+				   const struct cpumask *dest, bool force)
+{
+	return irq_data_to_desc(data)->chip->set_affinity(data->irq, dest);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	irq_data_to_desc(data)->chip->bus_lock(data->irq);
@@ -439,6 +445,8 @@ void irq_chip_set_defaults(struct irq_ch
 		chip->irq_mask_ack = compat_irq_mask_ack;
 	if (chip->eoi)
 		chip->irq_eoi = compat_irq_eoi;
+	if (chip->set_affinity)
+		chip->irq_set_affinity = compat_irq_set_affinity;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc)
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -74,7 +74,7 @@ int irq_can_set_affinity(unsigned int ir
 	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (CHECK_IRQ_PER_CPU(desc->status) || !desc->chip ||
-	    !desc->chip->set_affinity)
+	    !desc->chip->irq_set_affinity)
 		return 0;
 
 	return 1;
@@ -109,16 +109,17 @@ void irq_set_thread_affinity(struct irq_
 int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_chip *chip = desc->chip;
 	unsigned long flags;
 
-	if (!desc->chip->set_affinity)
+	if (!chip->irq_set_affinity)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PCNTXT) {
-		if (!desc->chip->set_affinity(irq, cpumask)) {
+		if (!chip->irq_set_affinity(&desc->irq_data, cpumask, false)) {
 			cpumask_copy(desc->affinity, cpumask);
 			irq_set_thread_affinity(desc);
 		}
@@ -128,7 +129,7 @@ int irq_set_affinity(unsigned int irq, c
 		cpumask_copy(desc->pending_mask, cpumask);
 	}
 #else
-	if (!desc->chip->set_affinity(irq, cpumask)) {
+	if (!chip->irq_set_affinity(&dest->irq_data, cpumask, false)) {
 		cpumask_copy(desc->affinity, cpumask);
 		irq_set_thread_affinity(desc);
 	}
@@ -177,7 +178,7 @@ static int setup_affinity(unsigned int i
 
 	cpumask_and(desc->affinity, cpu_online_mask, irq_default_affinity);
 set_affinity:
-	desc->chip->set_affinity(irq, desc->affinity);
+	desc->chip->irq_set_affinity(&desc->irq_data, desc->affinity, false);
 
 	return 0;
 }
Index: linux-2.6-tip/kernel/irq/migration.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/migration.c
+++ linux-2.6-tip/kernel/irq/migration.c
@@ -7,6 +7,7 @@
 void move_masked_irq(int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_chip *chip = desc->chip;
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
@@ -24,7 +25,7 @@ void move_masked_irq(int irq)
 	if (unlikely(cpumask_empty(desc->pending_mask)))
 		return;
 
-	if (!desc->chip->set_affinity)
+	if (!chip->irq_set_affinity)
 		return;
 
 	assert_raw_spin_locked(&desc->lock);
@@ -43,7 +44,8 @@ void move_masked_irq(int irq)
 	 */
 	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
 		   < nr_cpu_ids))
-		if (!desc->chip->set_affinity(irq, desc->pending_mask)) {
+		if (!chip->irq_set_affinity(&desc->irq_data,
+					    desc->pending_mask, false)) {
 			cpumask_copy(desc->affinity, desc->pending_mask);
 			irq_set_thread_affinity(desc);
 		}
Index: linux-2.6-tip/kernel/irq/proc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/proc.c
+++ linux-2.6-tip/kernel/irq/proc.c
@@ -65,7 +65,7 @@ static ssize_t irq_affinity_proc_write(s
 	cpumask_var_t new_value;
 	int err;
 
-	if (!irq_to_desc(irq)->chip->set_affinity || no_irq_affinity ||
+	if (!irq_to_desc(irq)->chip->irq_set_affinity || no_irq_affinity ||
 	    irq_balancing_disabled(irq))
 		return -EIO;
 


