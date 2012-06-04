Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767Ab2FDPOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:14:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:41922 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760405Ab2FDPOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:14:15 -0400
Date: Mon, 4 Jun 2012 17:14:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] irq updates for 3.5
Message-ID: <alpine.LFD.2.02.1206041713230.3086@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

Just a cleanup patch with no functional change and a fix for suspend issues.

Thanks,

	tglx

------------------>
Jiang Liu (1):
      genirq: Introduce irq_do_set_affinity() to reduce duplicated code

Ning Jiang (1):
      genirq: Add IRQS_PENDING for nested and simple irq


 kernel/irq/chip.c      |    8 ++++++--
 kernel/irq/internals.h |    3 +++
 kernel/irq/manage.c    |   39 ++++++++++++++++++++++-----------------
 kernel/irq/migration.c |   13 ++-----------
 4 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index fc275e4..eebd6d5 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -275,8 +275,10 @@ void handle_nested_irq(unsigned int irq)
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	action = desc->action;
-	if (unlikely(!action || irqd_irq_disabled(&desc->irq_data)))
+	if (unlikely(!action || irqd_irq_disabled(&desc->irq_data))) {
+		desc->istate |= IRQS_PENDING;
 		goto out_unlock;
+	}
 
 	irqd_set(&desc->irq_data, IRQD_IRQ_INPROGRESS);
 	raw_spin_unlock_irq(&desc->lock);
@@ -324,8 +326,10 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
 
-	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data)))
+	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
+		desc->istate |= IRQS_PENDING;
 		goto out_unlock;
+	}
 
 	handle_irq_event(desc);
 
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 8e5c56b..001fa5b 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -101,6 +101,9 @@ extern int irq_select_affinity_usr(unsigned int irq, struct cpumask *mask);
 
 extern void irq_set_thread_affinity(struct irq_desc *desc);
 
+extern int irq_do_set_affinity(struct irq_data *data,
+			       const struct cpumask *dest, bool force);
+
 /* Inline functions for support of irq chips on slow busses */
 static inline void chip_bus_lock(struct irq_desc *desc)
 {
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index bb32326..a1b9033 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -139,6 +139,25 @@ static inline void
 irq_get_pending(struct cpumask *mask, struct irq_desc *desc) { }
 #endif
 
+int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
+			bool force)
+{
+	struct irq_desc *desc = irq_data_to_desc(data);
+	struct irq_chip *chip = irq_data_get_irq_chip(data);
+	int ret;
+
+	ret = chip->irq_set_affinity(data, mask, false);
+	switch (ret) {
+	case IRQ_SET_MASK_OK:
+		cpumask_copy(data->affinity, mask);
+	case IRQ_SET_MASK_OK_NOCOPY:
+		irq_set_thread_affinity(desc);
+		ret = 0;
+	}
+
+	return ret;
+}
+
 int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 {
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
@@ -149,14 +168,7 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 		return -EINVAL;
 
 	if (irq_can_move_pcntxt(data)) {
-		ret = chip->irq_set_affinity(data, mask, false);
-		switch (ret) {
-		case IRQ_SET_MASK_OK:
-			cpumask_copy(data->affinity, mask);
-		case IRQ_SET_MASK_OK_NOCOPY:
-			irq_set_thread_affinity(desc);
-			ret = 0;
-		}
+		ret = irq_do_set_affinity(data, mask, false);
 	} else {
 		irqd_set_move_pending(data);
 		irq_copy_pending(desc, mask);
@@ -280,9 +292,8 @@ EXPORT_SYMBOL_GPL(irq_set_affinity_notifier);
 static int
 setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 {
-	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct cpumask *set = irq_default_affinity;
-	int ret, node = desc->irq_data.node;
+	int node = desc->irq_data.node;
 
 	/* Excludes PER_CPU and NO_BALANCE interrupts */
 	if (!irq_can_set_affinity(irq))
@@ -308,13 +319,7 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 		if (cpumask_intersects(mask, nodemask))
 			cpumask_and(mask, mask, nodemask);
 	}
-	ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
-	switch (ret) {
-	case IRQ_SET_MASK_OK:
-		cpumask_copy(desc->irq_data.affinity, mask);
-	case IRQ_SET_MASK_OK_NOCOPY:
-		irq_set_thread_affinity(desc);
-	}
+	irq_do_set_affinity(&desc->irq_data, mask, false);
 	return 0;
 }
 #else
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index c3c8975..ca3f4aa 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -42,17 +42,8 @@ void irq_move_masked_irq(struct irq_data *idata)
 	 * For correct operation this depends on the caller
 	 * masking the irqs.
 	 */
-	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
-		   < nr_cpu_ids)) {
-		int ret = chip->irq_set_affinity(&desc->irq_data,
-						 desc->pending_mask, false);
-		switch (ret) {
-		case IRQ_SET_MASK_OK:
-			cpumask_copy(desc->irq_data.affinity, desc->pending_mask);
-		case IRQ_SET_MASK_OK_NOCOPY:
-			irq_set_thread_affinity(desc);
-		}
-	}
+	if (cpumask_any_and(desc->pending_mask, cpu_online_mask) < nr_cpu_ids)
+		irq_do_set_affinity(&desc->irq_data, desc->pending_mask, false);
 
 	cpumask_clear(desc->pending_mask);
 }
