Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab1FGSsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:48:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56201 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143Ab1FGSsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:48:46 -0400
Date: Tue, 7 Jun 2011 20:48:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fixes
Message-ID: <20110607184841.GA32046@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-urgent-for-linus

 Thanks,

	Ingo

------------------>
Linus Walleij (1):
      genirq: Fix descriptor init on non-sparse IRQs

Mark Brown (1):
      genirq: Ensure we locate the passed IRQ in irq_alloc_descs()

Sebastian Andrzej Siewior (2):
      genirq: Print threaded handler in spurious debug output
      irq: Handle spurios irq detection for threaded irqs


 include/linux/irqreturn.h |    6 +++---
 kernel/irq/handle.c       |    6 ------
 kernel/irq/irqdesc.c      |   14 +++++++++-----
 kernel/irq/manage.c       |   24 ++++++++++++++++++------
 kernel/irq/spurious.c     |   31 +++++++++++++++++++++++--------
 5 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/include/linux/irqreturn.h b/include/linux/irqreturn.h
index 819acaa..714ba08 100644
--- a/include/linux/irqreturn.h
+++ b/include/linux/irqreturn.h
@@ -8,9 +8,9 @@
  * @IRQ_WAKE_THREAD	handler requests to wake the handler thread
  */
 enum irqreturn {
-	IRQ_NONE,
-	IRQ_HANDLED,
-	IRQ_WAKE_THREAD,
+	IRQ_NONE		= (0 << 0),
+	IRQ_HANDLED		= (1 << 0),
+	IRQ_WAKE_THREAD		= (1 << 1),
 };
 
 typedef enum irqreturn irqreturn_t;
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 90cb55f..470d08c 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -133,12 +133,6 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 		switch (res) {
 		case IRQ_WAKE_THREAD:
 			/*
-			 * Set result to handled so the spurious check
-			 * does not trigger.
-			 */
-			res = IRQ_HANDLED;
-
-			/*
 			 * Catch drivers which return WAKE_THREAD but
 			 * did not set up a thread function
 			 */
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 886e803..4c60a50 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -257,13 +257,11 @@ int __init early_irq_init(void)
 	count = ARRAY_SIZE(irq_desc);
 
 	for (i = 0; i < count; i++) {
-		desc[i].irq_data.irq = i;
-		desc[i].irq_data.chip = &no_irq_chip;
 		desc[i].kstat_irqs = alloc_percpu(unsigned int);
-		irq_settings_clr_and_set(desc, ~0, _IRQ_DEFAULT_INIT_FLAGS);
-		alloc_masks(desc + i, GFP_KERNEL, node);
-		desc_smp_init(desc + i, node);
+		alloc_masks(&desc[i], GFP_KERNEL, node);
+		raw_spin_lock_init(&desc[i].lock);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
+		desc_set_defaults(i, &desc[i], node);
 	}
 	return arch_early_irq_init();
 }
@@ -346,6 +344,12 @@ irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
 	if (!cnt)
 		return -EINVAL;
 
+	if (irq >= 0) {
+		if (from > irq)
+			return -EINVAL;
+		from = irq;
+	}
+
 	mutex_lock(&sparse_irq_lock);
 
 	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index f7ce002..d64bafb 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -723,13 +723,16 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action) { }
  * context. So we need to disable bh here to avoid deadlocks and other
  * side effects.
  */
-static void
+static irqreturn_t
 irq_forced_thread_fn(struct irq_desc *desc, struct irqaction *action)
 {
+	irqreturn_t ret;
+
 	local_bh_disable();
-	action->thread_fn(action->irq, action->dev_id);
+	ret = action->thread_fn(action->irq, action->dev_id);
 	irq_finalize_oneshot(desc, action, false);
 	local_bh_enable();
+	return ret;
 }
 
 /*
@@ -737,10 +740,14 @@ irq_forced_thread_fn(struct irq_desc *desc, struct irqaction *action)
  * preemtible - many of them need to sleep and wait for slow busses to
  * complete.
  */
-static void irq_thread_fn(struct irq_desc *desc, struct irqaction *action)
+static irqreturn_t irq_thread_fn(struct irq_desc *desc,
+		struct irqaction *action)
 {
-	action->thread_fn(action->irq, action->dev_id);
+	irqreturn_t ret;
+
+	ret = action->thread_fn(action->irq, action->dev_id);
 	irq_finalize_oneshot(desc, action, false);
+	return ret;
 }
 
 /*
@@ -753,7 +760,8 @@ static int irq_thread(void *data)
 	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
-	void (*handler_fn)(struct irq_desc *desc, struct irqaction *action);
+	irqreturn_t (*handler_fn)(struct irq_desc *desc,
+			struct irqaction *action);
 	int wake;
 
 	if (force_irqthreads & test_bit(IRQTF_FORCED_THREAD,
@@ -783,8 +791,12 @@ static int irq_thread(void *data)
 			desc->istate |= IRQS_PENDING;
 			raw_spin_unlock_irq(&desc->lock);
 		} else {
+			irqreturn_t action_ret;
+
 			raw_spin_unlock_irq(&desc->lock);
-			handler_fn(desc, action);
+			action_ret = handler_fn(desc, action);
+			if (!noirqdebug)
+				note_interrupt(action->irq, desc, action_ret);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index dfbd550..aa57d5d 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -167,6 +167,13 @@ out:
 		  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
 }
 
+static inline int bad_action_ret(irqreturn_t action_ret)
+{
+	if (likely(action_ret <= (IRQ_HANDLED | IRQ_WAKE_THREAD)))
+		return 0;
+	return 1;
+}
+
 /*
  * If 99,900 of the previous 100,000 interrupts have not been handled
  * then assume that the IRQ is stuck in some manner. Drop a diagnostic
@@ -182,7 +189,7 @@ __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 	struct irqaction *action;
 	unsigned long flags;
 
-	if (action_ret != IRQ_HANDLED && action_ret != IRQ_NONE) {
+	if (bad_action_ret(action_ret)) {
 		printk(KERN_ERR "irq event %d: bogus return value %x\n",
 				irq, action_ret);
 	} else {
@@ -201,10 +208,11 @@ __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	action = desc->action;
 	while (action) {
-		printk(KERN_ERR "[<%p>]", action->handler);
-		print_symbol(" (%s)",
-			(unsigned long)action->handler);
-		printk("\n");
+		printk(KERN_ERR "[<%p>] %pf", action->handler, action->handler);
+		if (action->thread_fn)
+			printk(KERN_CONT " threaded [<%p>] %pf",
+					action->thread_fn, action->thread_fn);
+		printk(KERN_CONT "\n");
 		action = action->next;
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
@@ -262,7 +270,16 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 	if (desc->istate & IRQS_POLL_INPROGRESS)
 		return;
 
-	if (unlikely(action_ret != IRQ_HANDLED)) {
+	/* we get here again via the threaded handler */
+	if (action_ret == IRQ_WAKE_THREAD)
+		return;
+
+	if (bad_action_ret(action_ret)) {
+		report_bad_irq(irq, desc, action_ret);
+		return;
+	}
+
+	if (unlikely(action_ret == IRQ_NONE)) {
 		/*
 		 * If we are seeing only the odd spurious IRQ caused by
 		 * bus asynchronicity then don't eventually trigger an error,
@@ -274,8 +291,6 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		else
 			desc->irqs_unhandled++;
 		desc->last_unhandled = jiffies;
-		if (unlikely(action_ret != IRQ_NONE))
-			report_bad_irq(irq, desc, action_ret);
 	}
 
 	if (unlikely(try_misrouted_irq(irq, desc, action_ret))) {
