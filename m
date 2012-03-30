Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965001Ab2C3WSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:18:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:41595 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935761Ab2C3WSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 18:18:10 -0400
Date: Sat, 31 Mar 2012 00:18:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [GIT pull] genirq updates for 3.4
Message-ID: <alpine.LFD.2.02.1203310015180.2542@ionos>
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

please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus

Thanks,

	tglx

------------------>
Alexander Gordeev (2):
      genirq: Minor readablity improvement in irq_wake_thread()
      genirq: Get rid of unneeded force parameter in irq_finalize_oneshot()

Jiang Liu (1):
      genirq: Adjust irq thread affinity on IRQ_SET_MASK_OK_NOCOPY return value

Prarit Bhargava (1):
      genirq: Respect NUMA node affinity in setup_irq_irq affinity()


 kernel/irq/handle.c    |   16 ++++++++++------
 kernel/irq/manage.c    |   19 +++++++++++++------
 kernel/irq/migration.c |   10 +++++++---
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 6ff84e6..bdb1803 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -54,14 +54,18 @@ static void warn_no_thread(unsigned int irq, struct irqaction *action)
 static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 {
 	/*
-	 * Wake up the handler thread for this action. In case the
-	 * thread crashed and was killed we just pretend that we
-	 * handled the interrupt. The hardirq handler has disabled the
-	 * device interrupt, so no irq storm is lurking. If the
+	 * In case the thread crashed and was killed we just pretend that
+	 * we handled the interrupt. The hardirq handler has disabled the
+	 * device interrupt, so no irq storm is lurking.
+	 */
+	if (action->thread->flags & PF_EXITING)
+		return;
+
+	/*
+	 * Wake up the handler thread for this action. If the
 	 * RUNTHREAD bit is already set, nothing to do.
 	 */
-	if ((action->thread->flags & PF_EXITING) ||
-	    test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+	if (test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
 		return;
 
 	/*
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index b0ccd1a..89a3ea8 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -282,7 +282,7 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 {
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	struct cpumask *set = irq_default_affinity;
-	int ret;
+	int ret, node = desc->irq_data.node;
 
 	/* Excludes PER_CPU and NO_BALANCE interrupts */
 	if (!irq_can_set_affinity(irq))
@@ -301,6 +301,13 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 	}
 
 	cpumask_and(mask, cpu_online_mask, set);
+	if (node != NUMA_NO_NODE) {
+		const struct cpumask *nodemask = cpumask_of_node(node);
+
+		/* make sure at least one of the cpus in nodemask is online */
+		if (cpumask_intersects(mask, nodemask))
+			cpumask_and(mask, mask, nodemask);
+	}
 	ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
@@ -645,7 +652,7 @@ static int irq_wait_for_interrupt(struct irqaction *action)
  * is marked MASKED.
  */
 static void irq_finalize_oneshot(struct irq_desc *desc,
-				 struct irqaction *action, bool force)
+				 struct irqaction *action)
 {
 	if (!(desc->istate & IRQS_ONESHOT))
 		return;
@@ -679,7 +686,7 @@ again:
 	 * we would clear the threads_oneshot bit of this thread which
 	 * was just set.
 	 */
-	if (!force && test_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+	if (test_bit(IRQTF_RUNTHREAD, &action->thread_flags))
 		goto out_unlock;
 
 	desc->threads_oneshot &= ~action->thread_mask;
@@ -739,7 +746,7 @@ irq_forced_thread_fn(struct irq_desc *desc, struct irqaction *action)
 
 	local_bh_disable();
 	ret = action->thread_fn(action->irq, action->dev_id);
-	irq_finalize_oneshot(desc, action, false);
+	irq_finalize_oneshot(desc, action);
 	local_bh_enable();
 	return ret;
 }
@@ -755,7 +762,7 @@ static irqreturn_t irq_thread_fn(struct irq_desc *desc,
 	irqreturn_t ret;
 
 	ret = action->thread_fn(action->irq, action->dev_id);
-	irq_finalize_oneshot(desc, action, false);
+	irq_finalize_oneshot(desc, action);
 	return ret;
 }
 
@@ -844,7 +851,7 @@ void exit_irq_thread(void)
 		wake_threads_waitq(desc);
 
 	/* Prevent a stale desc->threads_oneshot */
-	irq_finalize_oneshot(desc, action, true);
+	irq_finalize_oneshot(desc, action);
 }
 
 static void irq_setup_forced_threading(struct irqaction *new)
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 4742090..c3c8975 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -43,12 +43,16 @@ void irq_move_masked_irq(struct irq_data *idata)
 	 * masking the irqs.
 	 */
 	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
-		   < nr_cpu_ids))
-		if (!chip->irq_set_affinity(&desc->irq_data,
-					    desc->pending_mask, false)) {
+		   < nr_cpu_ids)) {
+		int ret = chip->irq_set_affinity(&desc->irq_data,
+						 desc->pending_mask, false);
+		switch (ret) {
+		case IRQ_SET_MASK_OK:
 			cpumask_copy(desc->irq_data.affinity, desc->pending_mask);
+		case IRQ_SET_MASK_OK_NOCOPY:
 			irq_set_thread_affinity(desc);
 		}
+	}
 
 	cpumask_clear(desc->pending_mask);
 }
