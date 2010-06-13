Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0FMPdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:33:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:37764 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab0FMPcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:32:14 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/12] irq: improve spurious IRQ handling
Date: Sun, 13 Jun 2010 17:31:33 +0200
Message-Id: <1276443098-20653-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276443098-20653-1-git-send-email-tj@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 13 Jun 2010 15:31:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, once spurious polling is enabled, it's never disabled and
to avoid enaling it unnecessarily, the condition for kicking in is
very conservative.  Now that spurious polling is per-IRQ, it can be
made more adaptive without adding overhead to the fast path.

This patch improves spurious handling such that the spurious IRQ
polling kicks in earlier and it disables itself after polling certain
number of times which is automatically adjusted according to whether
and when spurious IRQ happens again.

This allows the system to work around temporary IRQ glitches without
paying unnecessary long term overhead.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/irq.h    |   19 ++-
 kernel/irq/chip.c      |    2 -
 kernel/irq/internals.h |    2 +-
 kernel/irq/manage.c    |    4 -
 kernel/irq/proc.c      |    5 +-
 kernel/irq/spurious.c  |  292 ++++++++++++++++++++++++++++++++++--------------
 6 files changed, 226 insertions(+), 98 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 50a77f9..b2f73ba 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -145,6 +145,17 @@ struct irq_chip {
 
 struct timer_rand_state;
 struct irq_2_iommu;
+
+/* spurious IRQ tracking and handling */
+struct irq_spr {
+	unsigned long		last_bad;	/* when was the last bad? */
+	unsigned long		period_start;	/* period start jiffies */
+	unsigned int		nr_samples;	/* nr of irqs in this period */
+	unsigned int		nr_bad;		/* nr of bad deliveries */
+	unsigned int		poll_cnt;	/* nr to poll once activated */
+	unsigned int		poll_rem;	/* how many polls are left? */
+};
+
 /**
  * struct irq_desc - interrupt descriptor
  * @irq:		interrupt number for this descriptor
@@ -161,15 +172,13 @@ struct irq_2_iommu;
  * @status:		status information
  * @depth:		disable-depth, for nested irq_disable() calls
  * @wake_depth:		enable depth, for multiple set_irq_wake() callers
- * @irq_count:		stats field to detect stalled irqs
- * @last_unhandled:	aging timer for unhandled count
- * @irqs_unhandled:	stats field for spurious unhandled interrupts
  * @lock:		locking for SMP
  * @affinity:		IRQ affinity on SMP
  * @node:		node index useful for balancing
  * @pending_mask:	pending rebalanced interrupts
  * @threads_active:	number of irqaction threads currently running
  * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
+ * @spr:		data for spurious IRQ handling
  * @poll_timer:		timer for IRQ polling
  * @dir:		/proc/irq/ procfs entry
  * @name:		flow handler name for /proc/interrupts output
@@ -191,9 +200,6 @@ struct irq_desc {
 
 	unsigned int		depth;		/* nested irq disables */
 	unsigned int		wake_depth;	/* nested wake enables */
-	unsigned int		irq_count;	/* For detecting broken IRQs */
-	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
-	unsigned int		irqs_unhandled;
 	raw_spinlock_t		lock;
 #ifdef CONFIG_SMP
 	cpumask_var_t		affinity;
@@ -206,6 +212,7 @@ struct irq_desc {
 	atomic_t		threads_active;
 	wait_queue_head_t       wait_for_threads;
 
+	struct irq_spr		spr;
 	struct timer_list	poll_timer;
 
 #ifdef CONFIG_PROC_FS
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index db26ff0..45a87f5 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -40,8 +40,6 @@ static void dynamic_irq_init_x(unsigned int irq, bool keep_chip_data)
 	if (!keep_chip_data)
 		desc->chip_data = NULL;
 	desc->action = NULL;
-	desc->irq_count = 0;
-	desc->irqs_unhandled = 0;
 #ifdef CONFIG_SMP
 	cpumask_setall(desc->affinity);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 088e5d6..1b24309 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -68,7 +68,7 @@ static inline void chip_bus_sync_unlock(unsigned int irq, struct irq_desc *desc)
 static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
 {
 	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
-		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
+		irq, desc, desc->depth, desc->spr.nr_samples, desc->spr.nr_bad);
 	printk("->handle_irq():  %p, ", desc->handle_irq);
 	print_symbol("%s\n", (unsigned long)desc->handle_irq);
 	printk("->chip(): %p, ", desc->chip);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index cf9ab65..5862bfc 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -801,10 +801,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	new->irq = irq;
 	*old_ptr = new;
 
-	/* Reset broken irq detection when installing new handler */
-	desc->irq_count = 0;
-	desc->irqs_unhandled = 0;
-
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	irq_poll_action_added(desc, new);
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 09a2ee5..b072460 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -205,10 +205,11 @@ static const struct file_operations irq_node_proc_fops = {
 static int irq_spurious_proc_show(struct seq_file *m, void *v)
 {
 	struct irq_desc *desc = irq_to_desc((long) m->private);
+	struct irq_spr *spr = &desc->spr;
 
 	seq_printf(m, "count %u\n" "unhandled %u\n" "last_unhandled %u ms\n",
-		   desc->irq_count, desc->irqs_unhandled,
-		   jiffies_to_msecs(desc->last_unhandled));
+		   spr->nr_samples, spr->nr_bad,
+		   jiffies_to_msecs(spr->last_bad));
 	return 0;
 }
 
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 0b8fd0a..3948666 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -8,6 +8,7 @@
 
 #include <linux/jiffies.h>
 #include <linux/irq.h>
+#include <linux/log2.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/interrupt.h>
@@ -25,6 +26,37 @@ enum {
 	IRQ_POLL_INTV			= HZ / 100,	/* from the good ol' 100HZ tick */
 
 	IRQ_POLL_SLACK			= HZ / 1000,	/* 10% slack */
+
+	/*
+	 * Spurious IRQ handling parameters.
+	 *
+	 * As this per-IRQ spurious handling is cheaper than the
+	 * previous system wide spurious handling, it can afford to
+	 * use more responsive settings but these parameters are still
+	 * pretty conservative.  If ever necessary, making it more
+	 * responsive shouldn't cause any problem.
+	 *
+	 * Spurious IRQs are monitored in segments of PERIOD_SAMPLES
+	 * IRQs which can stretch PERIOD_DURATION at maximum.  If
+	 * there are less than PERIOD_SAMPLES IRQs per
+	 * PERIOD_DURATION, the period is considered good.
+	 *
+	 * If >=BAD_THRESHOLD IRQs are bad ones, the period is
+	 * considered bad and spurious IRQ handling kicks in - the IRQ
+	 * is disabled and polled.  The IRQ is given another shot
+	 * after certain number IRQs are handled, which is at minimum
+	 * POLL_CNT_MIN, increased by 1 << POLL_CNT_INC_SHIFT times
+	 * after each bad period and decreased by factor of
+	 * POLL_CNT_INC_DEC_SHIFT after each good one.
+	 */
+	IRQ_SPR_PERIOD_DURATION		= 10 * HZ,
+	IRQ_SPR_PERIOD_SAMPLES		= 10000,
+	IRQ_SPR_BAD_THRESHOLD		= 9900,
+	IRQ_SPR_POLL_CNT_MIN		= 10000,
+	IRQ_SPR_POLL_CNT_INF		= UINT_MAX,
+	IRQ_SPR_POLL_CNT_INC_SHIFT	= 3,
+	IRQ_SPR_POLL_CNT_DEC_SHIFT	= 1,
+	IRQ_SPR_POLL_CNT_MAX_DEC_SHIFT	= BITS_PER_BYTE * sizeof(int) / 4,
 };
 
 int noirqdebug __read_mostly;
@@ -77,8 +109,24 @@ static void irq_schedule_poll(struct irq_desc *desc, unsigned long intv)
 	mod_timer(&desc->poll_timer, expires);
 }
 
+/* start a new spurious handling period */
+static void irq_spr_new_period(struct irq_spr *spr)
+{
+	spr->period_start = jiffies;
+	spr->nr_samples = 0;
+	spr->nr_bad = 0;
+}
+
+/* Reset spurious handling.  After this, poll_timer will offline itself soon. */
+static void irq_spr_reset(struct irq_spr *spr)
+{
+	irq_spr_new_period(spr);
+	spr->poll_cnt = IRQ_SPR_POLL_CNT_MIN;
+	spr->poll_rem = 0;
+}
+
 /*
- * Recovery handler for misrouted interrupts.
+ * Perform an actual poll.
  */
 static int try_one_irq(int irq, struct irq_desc *desc)
 {
@@ -161,91 +209,99 @@ static int misrouted_irq(int irq)
 }
 
 /*
- * If 99,900 of the previous 100,000 interrupts have not been handled
- * then assume that the IRQ is stuck in some manner. Drop a diagnostic
- * and try to turn the IRQ off.
- *
- * (The other 100-of-100,000 interrupts may have been a correctly
- *  functioning device sharing an IRQ with the failing one)
- *
- * Called under desc->lock
+ * IRQ delivery notification function.  Called after each IRQ delivery.
  */
-
-static void
-__report_bad_irq(unsigned int irq, struct irq_desc *desc,
-		 irqreturn_t action_ret)
-{
-	if (action_ret != IRQ_HANDLED && action_ret != IRQ_NONE) {
-		printk(KERN_ERR "irq event %d: bogus return value %x\n",
-				irq, action_ret);
-	} else {
-		printk(KERN_ERR "irq %d: nobody cared (try booting with "
-				"the \"irqpoll\" option)\n", irq);
-	}
-	dump_stack();
-	print_irq_handlers(desc);
-}
-
-static void
-report_bad_irq(unsigned int irq, struct irq_desc *desc, irqreturn_t action_ret)
-{
-	static int count = 100;
-
-	if (count > 0) {
-		count--;
-		__report_bad_irq(irq, desc, action_ret);
-	}
-}
-
 void __note_interrupt(unsigned int irq, struct irq_desc *desc,
 		      irqreturn_t action_ret)
 {
-	if (unlikely(action_ret != IRQ_HANDLED)) {
-		/*
-		 * If we are seeing only the odd spurious IRQ caused by
-		 * bus asynchronicity then don't eventually trigger an error,
-		 * otherwise the counter becomes a doomsday timer for otherwise
-		 * working systems
-		 */
-		if (time_after(jiffies, desc->last_unhandled + HZ/10))
-			desc->irqs_unhandled = 1;
-		else
-			desc->irqs_unhandled++;
-		desc->last_unhandled = jiffies;
-		if (unlikely(action_ret != IRQ_NONE))
-			report_bad_irq(irq, desc, action_ret);
-	}
+	struct irq_spr *spr = &desc->spr;
+	unsigned long dur;
+	unsigned int cnt, abbr;
+	char unit = 'k';
 
-	if (unlikely(irqfixup >= IRQFIXUP_MISROUTED &&
-		     action_ret == IRQ_NONE)) {
-		int ok = misrouted_irq(irq);
-		if (action_ret == IRQ_NONE)
-			desc->irqs_unhandled -= ok;
+	/*
+	 * Account for unhandled interrupt.  We don't care whether
+	 * spurious accounting update races with irq open/close and
+	 * gets some values wrong.  Do it w/o locking.
+	 */
+	if (unlikely(action_ret != IRQ_HANDLED)) {
+		static int bogus_count = 100;
+
+		spr->last_bad = jiffies - INITIAL_JIFFIES;
+		spr->nr_bad++;
+		if (likely(action_ret == IRQ_NONE)) {
+			if (unlikely(irqfixup >= IRQFIXUP_MISROUTED &&
+				     misrouted_irq(irq)))
+				spr->nr_bad--;
+		} else if (bogus_count > 0) {
+			bogus_count--;
+			printk(KERN_ERR "IRQ %u: bogus return value %x\n",
+			       irq, action_ret);
+			dump_stack();
+			print_irq_handlers(desc);
+		}
 	}
 
-	desc->irq_count++;
-	if (likely(desc->irq_count < 100000))
+	/* did we finish this spurious period? */
+	spr->nr_samples++;
+	if (likely(spr->nr_samples < IRQ_SPR_PERIOD_SAMPLES))
 		return;
 
-	desc->irq_count = 0;
-	if (unlikely(desc->irqs_unhandled > 99900)) {
+	/* if so, was it a good one? */
+	dur = jiffies - spr->period_start;
+	if (likely(spr->nr_bad < IRQ_SPR_BAD_THRESHOLD ||
+		   dur > IRQ_SPR_PERIOD_DURATION)) {
 		/*
-		 * The interrupt is stuck
+		 * If longer than PERIOD_DURATION has passed, consider
+		 * multiple good periods have happened.
 		 */
-		__report_bad_irq(irq, desc, action_ret);
-		/*
-		 * Now kill the IRQ
-		 */
-		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
-		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
-		desc->depth++;
-		desc->chip->disable(irq);
+		int sft = IRQ_SPR_POLL_CNT_DEC_SHIFT *
+			(dur >> order_base_2(IRQ_SPR_PERIOD_DURATION));
 
-		raw_spin_lock(&desc->lock);
-		irq_schedule_poll(desc, IRQ_POLL_INTV);
-		raw_spin_unlock(&desc->lock);
+		/* but don't kill poll_cnt at once */
+		sft = clamp(sft, 1, IRQ_SPR_POLL_CNT_MAX_DEC_SHIFT);
+
+		spr->poll_cnt >>= sft;
+		irq_spr_new_period(spr);
+		return;
 	}
-	desc->irqs_unhandled = 0;
+
+	/*
+	 * It was a bad one, start polling.  This is a slow path and
+	 * we're gonna be changing states which require proper
+	 * synchronization, grab desc->lock.
+	 */
+	raw_spin_lock(&desc->lock);
+
+	irq_spr_new_period(spr);
+
+	/* update spr_poll_cnt considering the lower and upper bounds */
+	cnt = max_t(unsigned int, spr->poll_cnt, IRQ_SPR_POLL_CNT_MIN);
+	spr->poll_cnt = cnt << IRQ_SPR_POLL_CNT_INC_SHIFT;
+	if (spr->poll_cnt < cnt)	/* did it overflow? */
+		spr->poll_cnt = IRQ_SPR_POLL_CNT_INF;
+
+	/* whine, plug IRQ and kick poll timer */
+	abbr = cnt / 1000;
+	if (abbr > 1000) {
+		abbr /= 1000;
+		unit = 'm';
+	}
+	printk(KERN_ERR "IRQ %u: too many spurious IRQs, disabling and "
+	       "polling for %u%c %umsec intervals.\n",
+	       desc->irq, abbr, unit, jiffies_to_msecs(IRQ_POLL_INTV));
+	printk(KERN_ERR "IRQ %u: system performance may be affected\n",
+	       desc->irq);
+	print_irq_handlers(desc);
+
+	desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
+	desc->depth++;
+	desc->chip->disable(desc->irq);
+
+	spr->poll_rem = cnt;
+	irq_schedule_poll(desc, IRQ_POLL_INTV);
+
+	raw_spin_unlock(&desc->lock);
 }
 
 /*
@@ -254,48 +310,118 @@ void __note_interrupt(unsigned int irq, struct irq_desc *desc,
 void poll_irq(unsigned long arg)
 {
 	struct irq_desc *desc = (void *)arg;
+	struct irq_spr *spr = &desc->spr;
+	unsigned long intv = MAX_JIFFY_OFFSET;
+	bool reenable_irq = false;
 
 	raw_spin_lock_irq(&desc->lock);
+
+	/* poll the IRQ */
 	try_one_irq(desc->irq, desc);
-	irq_schedule_poll(desc, IRQ_POLL_INTV);
+
+	/* take care of spurious handling */
+	if (spr->poll_rem) {
+		if (spr->poll_rem != IRQ_SPR_POLL_CNT_INF)
+			spr->poll_rem--;
+		if (spr->poll_rem)
+			intv = IRQ_POLL_INTV;
+		else
+			irq_spr_new_period(spr);
+	}
+	if (!spr->poll_rem)
+		reenable_irq = desc->status & IRQ_SPURIOUS_DISABLED;
+
+	/* need to poll again? */
+	if (intv < MAX_JIFFY_OFFSET)
+		irq_schedule_poll(desc, intv);
+
+	raw_spin_unlock_irq(&desc->lock);
+
+	if (!reenable_irq)
+		return;
+
+	/* need to do locking dance for chip_bus_lock() to reenable IRQ */
+	chip_bus_lock(desc->irq, desc);
+	raw_spin_lock_irq(&desc->lock);
+
+	/* make sure we haven't raced with anyone inbetween */
+	if (!spr->poll_rem && (desc->status & IRQ_SPURIOUS_DISABLED)) {
+		printk(KERN_INFO "IRQ %u: spurious polling finished, "
+		       "reenabling IRQ\n", desc->irq);
+		__enable_irq(desc, desc->irq, false);
+		desc->status &= ~IRQ_SPURIOUS_DISABLED;
+	}
+
 	raw_spin_unlock_irq(&desc->lock);
+	chip_bus_sync_unlock(desc->irq, desc);
 }
 
 void irq_poll_action_added(struct irq_desc *desc, struct irqaction *action)
 {
+	struct irq_spr *spr = &desc->spr;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
-	/* if the interrupt was killed before, give it one more chance */
-	if (desc->status & IRQ_SPURIOUS_DISABLED) {
-		desc->status &= ~IRQ_SPURIOUS_DISABLED;
-		__enable_irq(desc, desc->irq, false);
-	}
-
-	if ((action->flags & IRQF_SHARED) && irqfixup >= IRQFIXUP_POLL)
+	if ((action->flags & IRQF_SHARED) && irqfixup >= IRQFIXUP_POLL) {
+		if (!spr->poll_rem)
+			printk(KERN_INFO "IRQ %u: starting IRQFIXUP_POLL\n",
+			       desc->irq);
+		spr->poll_rem = IRQ_SPR_POLL_CNT_INF;
 		irq_schedule_poll(desc, IRQ_POLL_INTV);
+	} else {
+		/* new irqaction registered, give the IRQ another chance */
+		irq_spr_reset(spr);
+	}
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 void irq_poll_action_removed(struct irq_desc *desc, struct irqaction *action)
 {
+	bool irq_enabled = false, timer_killed = false;
 	unsigned long flags;
+	int rc;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
+	/* give the IRQ another chance */
+	if (irqfixup < IRQFIXUP_POLL)
+		irq_spr_reset(&desc->spr);
+
 	/*
 	 * Make sure the timer is offline if no irqaction is left as
 	 * the irq_desc will be reinitialized when the next irqaction
-	 * is added.
+	 * is added; otherwise, the timer can be left alone.  It will
+	 * offline itself if no longer necessary.
 	 */
-	while (!desc->action && try_to_del_timer_sync(&desc->poll_timer) < 0) {
+	while (!desc->action) {
+		rc = try_to_del_timer_sync(&desc->poll_timer);
+		if (rc >= 0) {
+			timer_killed = rc > 0;
+			break;
+		}
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 		cpu_relax();
 		raw_spin_lock_irqsave(&desc->lock, flags);
 	}
 
+	/*
+	 * If the timer was forcefully shut down, it might not have
+	 * had the chance to reenable IRQ.  Make sure it's enabled.
+	 */
+	if (timer_killed && (desc->status & IRQ_SPURIOUS_DISABLED)) {
+		__enable_irq(desc, desc->irq, false);
+		desc->status &= ~IRQ_SPURIOUS_DISABLED;
+		irq_enabled = true;
+	}
+
+	if (timer_killed || irq_enabled)
+		printk(KERN_INFO "IRQ %u:%s%s%s\n", desc->irq,
+		       timer_killed ? " polling stopped" : "",
+		       timer_killed && irq_enabled ? " and" : "",
+		       irq_enabled ? " IRQ reenabled" : "");
+
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
-- 
1.6.4.2

