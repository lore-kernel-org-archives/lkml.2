Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0FMPcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:32:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:37767 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab0FMPcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:32:17 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/12] irq: implement IRQ watching
Date: Sun, 13 Jun 2010 17:31:34 +0200
Message-Id: <1276443098-20653-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276443098-20653-1-git-send-email-tj@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 13 Jun 2010 15:31:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements IRQ watching, which is a simple polling
mechanism drivers can use to work around lost and/or misrouted IRQs.
IRQ watching is enabled by driver calling watch_irq(irq, dev_id).
After that, it polls the irqaction for certain amount of time (1min)
and keeps track of whether IRQ delivery is actually working.  If the
irqaction is serviced by poll, it's considered to be a possible
indication of IRQ misdelivery.

The watch polling starts slowly at 1HZ and speeds up to 100HZ when it
sees a possible bad delivery.  After collecting stats for a while, it
determines whether the IRQ delivery is working for the irqaction.  If
so or it can't be determined, it steps out.  If not working, IRQ
polling continues till the irqaction is unregistered.

This can be used by drivers which don't know when to expect the next
IRQ.  Just by calling watch_irq() after irqaction is registered or a
timeout, most IRQ misrouting problems can be worked around.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/interrupt.h |   12 +++
 include/linux/irq.h       |    2 +
 kernel/irq/handle.c       |    1 +
 kernel/irq/spurious.c     |  209 ++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 221 insertions(+), 3 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index b20bd65..bc0cdbc 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -88,6 +88,14 @@ enum {
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
+struct irq_watch {
+	irqreturn_t		last_ret;
+	unsigned int		flags;
+	unsigned long		started;
+	unsigned int		nr_samples;
+	unsigned int		nr_polled;
+};
+
 /**
  * struct irqaction - per interrupt action descriptor
  * @handler:	interrupt handler function
@@ -100,6 +108,7 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
  * @thread_fn:	interupt handler function for threaded interrupts
  * @thread:	thread pointer for threaded interrupts
  * @thread_flags:	flags related to @thread
+ * @watch:	data for irq watching
  */
 struct irqaction {
 	irq_handler_t		handler;
@@ -112,6 +121,7 @@ struct irqaction {
 	irq_handler_t		thread_fn;
 	struct task_struct	*thread;
 	unsigned long		thread_flags;
+	struct irq_watch	watch;
 };
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
@@ -184,6 +194,8 @@ devm_request_irq(struct device *dev, unsigned int irq, irq_handler_t handler,
 
 extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
 
+extern void watch_irq(unsigned int irq, void *dev_id);
+
 /*
  * On lockdep we dont want to enable hardirqs in hardirq
  * context. Use local_irq_enable_in_hardirq() to annotate
diff --git a/include/linux/irq.h b/include/linux/irq.h
index b2f73ba..e31954f 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -72,6 +72,7 @@ typedef	void (*irq_flow_handler_t)(unsigned int irq,
 #define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
 #define IRQ_ONESHOT		0x08000000	/* IRQ is not unmasked after hardirq */
 #define IRQ_NESTED_THREAD	0x10000000	/* IRQ is nested into another, no own handler thread */
+#define IRQ_CHECK_WATCHES	0x40000000	/* IRQ watch enabled */
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
@@ -214,6 +215,7 @@ struct irq_desc {
 
 	struct irq_spr		spr;
 	struct timer_list	poll_timer;
+	bool			poll_warned;
 
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*dir;
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 3ae50bf..685c3b3 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -416,6 +416,7 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 		}
 
 		retval |= ret;
+		action->watch.last_ret = ret;
 		action = action->next;
 	} while (action);
 
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 3948666..6f2ea3b 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -23,11 +23,51 @@ enum {
 	IRQFIXUP_POLL			= 2,		/* enable polling by default */
 
 	/* IRQ polling common parameters */
+	IRQ_POLL_SLOW_INTV		= 3 * HZ,	/* not too slow for ppl, slow enough for machine */
 	IRQ_POLL_INTV			= HZ / 100,	/* from the good ol' 100HZ tick */
 
+	IRQ_POLL_SLOW_SLACK		= HZ,
 	IRQ_POLL_SLACK			= HZ / 1000,	/* 10% slack */
 
 	/*
+	 * IRQ watch parameters.
+	 *
+	 * As IRQ watching has much less information about what's
+	 * going on, the parameters are more conservative.  It will
+	 * terminate unless it can reliably determine that IRQ
+	 * delivery isn't working.
+	 *
+	 * IRQs are watched in timed intervals which is BASE_PERIOD
+	 * long by default.  Polling interval starts at BASE_INTV and
+	 * grows upto SLOW_INTV if no bad delivery is detected.
+	 *
+	 * If a period contains zero sample and no bad delivery was
+	 * seen since watch started, watch terminates.
+	 *
+	 * If a period contains >=1 but <MIN_SAMPLES deliveries,
+	 * collected samples are inherited to the next period.
+	 *
+	 * If it contains enough samples, the ratio between good and
+	 * bad deliveries are examined, if >=BAD_PCT% are bad, the
+	 * irqaction is tagged bad and watched indefinitely.  if
+	 * BAD_PCT% > nr_bad >= WARY_PCT%, WARY_PERIOD is used instead
+	 * of BASE_PERIOD and the whole process is restarted.  If
+	 * <WARY_PCT% are bad, watch terminates.
+	 */
+	IRQ_WAT_MIN_SAMPLES		= 10,
+	IRQ_WAT_BASE_INTV		= HZ / 2,
+	IRQ_WAT_BASE_PERIOD		= 60 * HZ,
+	IRQ_WAT_WARY_PERIOD		= 600 * HZ,
+	IRQ_WAT_WARY_PCT		= 1,
+	IRQ_WAT_BAD_PCT			= 10,
+
+	/* IRQ watch flags */
+	IRQ_WATCHING			= (1 << 0),
+	IRQ_WAT_POLLED			= (1 << 1),
+	IRQ_WAT_WARY			= (1 << 2),
+	IRQ_WAT_BAD			= (1 << 3),
+
+	/*
 	 * Spurious IRQ handling parameters.
 	 *
 	 * As this per-IRQ spurious handling is cheaper than the
@@ -62,6 +102,16 @@ enum {
 int noirqdebug __read_mostly;
 static int irqfixup __read_mostly = IRQFIXUP_SPURIOUS;
 
+static struct irqaction *find_irq_action(struct irq_desc *desc, void *dev_id)
+{
+	struct irqaction *act;
+
+	for (act = desc->action; act; act = act->next)
+		if (act->dev_id == dev_id)
+			return act;
+	return NULL;
+}
+
 static void print_irq_handlers(struct irq_desc *desc)
 {
 	struct irqaction *action;
@@ -77,9 +127,25 @@ static void print_irq_handlers(struct irq_desc *desc)
 	}
 }
 
+static void warn_irq_poll(struct irq_desc *desc, struct irqaction *act)
+{
+	if (desc->poll_warned)
+		return;
+
+	desc->poll_warned = true;
+
+	printk(KERN_WARNING "IRQ %u: %s: can't verify IRQ, will keep polling\n",
+	       desc->irq, act->name);
+	printk(KERN_WARNING "IRQ %u: %s: system performance may be affected\n",
+	       desc->irq, act->name);
+}
+
 static unsigned long irq_poll_slack(unsigned long intv)
 {
-	return IRQ_POLL_SLACK;
+	if (intv >= IRQ_POLL_SLOW_INTV)
+		return IRQ_POLL_SLOW_SLACK;
+	else
+		return IRQ_POLL_SLACK;
 }
 
 /**
@@ -109,6 +175,119 @@ static void irq_schedule_poll(struct irq_desc *desc, unsigned long intv)
 	mod_timer(&desc->poll_timer, expires);
 }
 
+/**
+ * irq_update_watch - IRQ handled, update watch state
+ * @desc: IRQ desc of interest
+ * @act: IRQ action of interest
+ * @via_poll: IRQ was handled via poll
+ *
+ * Called after IRQ is successfully delievered or polled.  Updates
+ * watch state accordingly and determines which watch interval to use.
+ *
+ * CONTEXT:
+ * desc->lock
+ *
+ * RETURNS:
+ * Watch poll interval to use, MAX_JIFFY_OFFSET if watch polling isn't
+ * necessary.
+ */
+static unsigned long irq_update_watch(struct irq_desc *desc,
+				      struct irqaction *act, bool via_poll)
+{
+	struct irq_watch *wat = &act->watch;
+	unsigned long period = wat->flags & IRQ_WAT_WARY ?
+		IRQ_WAT_WARY_PERIOD : IRQ_WAT_BASE_PERIOD;
+
+	/* if not watching or already determined to be bad, it's easy */
+	if (!(wat->flags & IRQ_WATCHING))
+		return MAX_JIFFY_OFFSET;
+	if (wat->flags & IRQ_WAT_BAD)
+		return IRQ_POLL_INTV;
+
+	/* don't expire watch period while spurious polling is in effect */
+	if (desc->spr.poll_rem) {
+		wat->started = jiffies;
+		return IRQ_POLL_INTV;
+	}
+
+	/* IRQ was handled, record whether it was a good or bad delivery */
+	if (wat->last_ret == IRQ_HANDLED) {
+		wat->nr_samples++;
+		if (via_poll) {
+			wat->nr_polled++;
+			wat->flags |= IRQ_WAT_POLLED;
+		}
+	}
+
+	/* is this watch period over? */
+	if (time_after(jiffies, wat->started + period)) {
+		unsigned int wry_thr = wat->nr_samples * IRQ_WAT_WARY_PCT / 100;
+		unsigned int bad_thr = wat->nr_samples * IRQ_WAT_BAD_PCT / 100;
+
+		if (wat->nr_samples >= IRQ_WAT_MIN_SAMPLES) {
+			/* have enough samples, determine what to do */
+			if (wat->nr_polled <= wry_thr)
+				wat->flags &= ~IRQ_WATCHING;
+			else if (wat->nr_polled <= bad_thr)
+				wat->flags |= IRQ_WAT_WARY;
+			else {
+				warn_irq_poll(desc, act);
+				wat->flags |= IRQ_WAT_BAD;
+			}
+			wat->nr_samples = 0;
+			wat->nr_polled = 0;
+		} else if (!wat->nr_samples || !(wat->flags & IRQ_WAT_POLLED)) {
+			/* not sure but let's not hold onto it */
+			wat->flags &= ~IRQ_WATCHING;
+		}
+
+		wat->started = jiffies;
+	}
+
+	if (!(wat->flags & IRQ_WATCHING))
+		return MAX_JIFFY_OFFSET;
+	if (wat->flags & IRQ_WAT_POLLED)
+		return IRQ_POLL_INTV;
+	/* every delivery upto this point has been successful, grow interval */
+	return clamp_t(unsigned long, jiffies - wat->started,
+		       IRQ_WAT_BASE_INTV, IRQ_POLL_SLOW_INTV);
+}
+
+/**
+ * watch_irq - watch an irqaction
+ * @irq: IRQ the irqaction to watch belongs to
+ * @dev_id: dev_id for the irqaction to watch
+ *
+ * LOCKING:
+ * Grabs and releases desc->lock.
+ */
+void watch_irq(unsigned int irq, void *dev_id)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irqaction *act;
+	unsigned long flags;
+
+	if (WARN_ON_ONCE(!desc))
+		return;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+
+	act = find_irq_action(desc, dev_id);
+	if (!WARN_ON_ONCE(!act)) {
+		struct irq_watch *wat = &act->watch;
+
+		wat->flags |= IRQ_WATCHING;
+		wat->started = jiffies;
+		wat->nr_samples = 0;
+		wat->nr_polled = 0;
+		desc->status |= IRQ_CHECK_WATCHES;
+		irq_schedule_poll(desc, IRQ_WAT_BASE_INTV);
+	}
+
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+}
+EXPORT_SYMBOL_GPL(watch_irq);
+
 /* start a new spurious handling period */
 static void irq_spr_new_period(struct irq_spr *spr)
 {
@@ -151,8 +330,9 @@ static int try_one_irq(int irq, struct irq_desc *desc)
 	while (action) {
 		/* Only shared IRQ handlers are safe to call */
 		if (action->flags & IRQF_SHARED) {
-			if (action->handler(irq, action->dev_id) ==
-				IRQ_HANDLED)
+			action->watch.last_ret =
+				action->handler(irq, action->dev_id);
+			if (action->watch.last_ret == IRQ_HANDLED)
 				ok = 1;
 		}
 		action = action->next;
@@ -219,6 +399,24 @@ void __note_interrupt(unsigned int irq, struct irq_desc *desc,
 	unsigned int cnt, abbr;
 	char unit = 'k';
 
+	/* first, take care of IRQ watches */
+	if (unlikely(desc->status & IRQ_CHECK_WATCHES)) {
+		unsigned long intv = MAX_JIFFY_OFFSET;
+		struct irqaction *act;
+
+		raw_spin_lock(&desc->lock);
+
+		for (act = desc->action; act; act = act->next)
+			intv = min(intv, irq_update_watch(desc, act, false));
+
+		if (intv < MAX_JIFFY_OFFSET)
+			irq_schedule_poll(desc, intv);
+		else
+			desc->status &= ~IRQ_CHECK_WATCHES;
+
+		raw_spin_unlock(&desc->lock);
+	}
+
 	/*
 	 * Account for unhandled interrupt.  We don't care whether
 	 * spurious accounting update races with irq open/close and
@@ -313,6 +511,7 @@ void poll_irq(unsigned long arg)
 	struct irq_spr *spr = &desc->spr;
 	unsigned long intv = MAX_JIFFY_OFFSET;
 	bool reenable_irq = false;
+	struct irqaction *act;
 
 	raw_spin_lock_irq(&desc->lock);
 
@@ -331,6 +530,10 @@ void poll_irq(unsigned long arg)
 	if (!spr->poll_rem)
 		reenable_irq = desc->status & IRQ_SPURIOUS_DISABLED;
 
+	/* take care of watches */
+	for (act = desc->action; act; act = act->next)
+		intv = min(irq_update_watch(desc, act, true), intv);
+
 	/* need to poll again? */
 	if (intv < MAX_JIFFY_OFFSET)
 		irq_schedule_poll(desc, intv);
-- 
1.6.4.2

