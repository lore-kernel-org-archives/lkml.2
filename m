Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab0FMPc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:32:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:37778 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135Ab0FMPcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:32:22 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/12] irq: implement IRQ expecting
Date: Sun, 13 Jun 2010 17:31:35 +0200
Message-Id: <1276443098-20653-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276443098-20653-1-git-send-email-tj@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 13 Jun 2010 15:31:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements IRQ expecting, which can be used when a driver
can anticipate the controller to raise an interrupt in relatively
immediate future.  A driver needs to allocate an irq expect token
using init_irq_expect() to use it.  expect_irq() should be called when
an operation which will be followed by an interrupt is started.
unexpect_irq() when the operation finished or timed out.

This allows IRQ subsystem closely monitor the IRQ and react quickly if
the expected IRQ doesn't happen for whatever reason.  The
[un]expect_irq() functions are fairly light weight and any real driver
which accesses hardware controller should be able to use them for each
operation without adding noticeable overhead.

This is most useful for drivers which have to deal with hardware which
is inherently unreliable in dealing with interrupts.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/interrupt.h |    7 +
 include/linux/irq.h       |    1 +
 kernel/irq/spurious.c     |  276 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 281 insertions(+), 3 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index bc0cdbc..8bbd9dc 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -88,6 +88,8 @@ enum {
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
+struct irq_expect;
+
 struct irq_watch {
 	irqreturn_t		last_ret;
 	unsigned int		flags;
@@ -109,6 +111,7 @@ struct irq_watch {
  * @thread:	thread pointer for threaded interrupts
  * @thread_flags:	flags related to @thread
  * @watch:	data for irq watching
+ * @expects:	data for irq expecting
  */
 struct irqaction {
 	irq_handler_t		handler;
@@ -122,6 +125,7 @@ struct irqaction {
 	struct task_struct	*thread;
 	unsigned long		thread_flags;
 	struct irq_watch	watch;
+	struct irq_expect	*expects;
 };
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
@@ -194,6 +198,9 @@ devm_request_irq(struct device *dev, unsigned int irq, irq_handler_t handler,
 
 extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
 
+extern struct irq_expect *init_irq_expect(unsigned int irq, void *dev_id);
+extern void expect_irq(struct irq_expect *exp);
+extern void unexpect_irq(struct irq_expect *exp, bool timedout);
 extern void watch_irq(unsigned int irq, void *dev_id);
 
 /*
diff --git a/include/linux/irq.h b/include/linux/irq.h
index e31954f..98530ef 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -72,6 +72,7 @@ typedef	void (*irq_flow_handler_t)(unsigned int irq,
 #define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
 #define IRQ_ONESHOT		0x08000000	/* IRQ is not unmasked after hardirq */
 #define IRQ_NESTED_THREAD	0x10000000	/* IRQ is nested into another, no own handler thread */
+#define IRQ_IN_POLLING		0x20000000	/* IRQ polling in progress */
 #define IRQ_CHECK_WATCHES	0x40000000	/* IRQ watch enabled */
 
 #ifdef CONFIG_IRQ_PER_CPU
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 6f2ea3b..2d92113 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -13,6 +13,7 @@
 #include <linux/kallsyms.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
+#include <linux/slab.h>
 
 #include "internals.h"
 
@@ -25,9 +26,43 @@ enum {
 	/* IRQ polling common parameters */
 	IRQ_POLL_SLOW_INTV		= 3 * HZ,	/* not too slow for ppl, slow enough for machine */
 	IRQ_POLL_INTV			= HZ / 100,	/* from the good ol' 100HZ tick */
+	IRQ_POLL_QUICK_INTV		= HZ / 1000,	/* pretty quick but not too taxing */
 
 	IRQ_POLL_SLOW_SLACK		= HZ,
 	IRQ_POLL_SLACK			= HZ / 1000,	/* 10% slack */
+	IRQ_POLL_QUICK_SLACK		= HZ / 10000,	/* 10% slack */
+
+	/*
+	 * IRQ expect parameters.
+	 *
+	 * Because IRQ expecting is tightly coupled with the actual
+	 * activity of the controller, we can be slightly aggressive
+	 * and try to minimize the effect of lost interrupts.
+	 *
+	 * An irqaction must accumulate VERIFY_GOAL good deliveries,
+	 * where one bad delivery (delivered by polling) costs
+	 * BAD_FACTOR good ones, before reaching the verified state.
+	 *
+	 * QUICK_SAMPLES IRQ deliveries are examined and if
+	 * >=QUICK_THRESHOLD of them are polled on the first poll, the
+	 * IRQ is considered to be quick and QUICK_INTV is used
+	 * instead.
+	 *
+	 * Keep QUICK_SAMPLES much higher than VERIFY_GOAL so that
+	 * quick polling doesn't interfact with the initial
+	 * verification attempt (quicker polling increases the chance
+	 * of polled deliveries).
+	 */
+	IRQ_EXP_BAD_FACTOR		= 10,
+	IRQ_EXP_VERIFY_GOAL		= 256,
+	IRQ_EXP_QUICK_SAMPLES		= IRQ_EXP_VERIFY_GOAL * 4,
+	IRQ_EXP_QUICK_THRESHOLD		= IRQ_EXP_QUICK_SAMPLES * 8 / 10,
+
+	/* IRQ expect flags */
+	IRQ_EXPECTING			= (1 << 0),	/* expecting in progress */
+	IRQ_EXP_VERIFIED		= (1 << 1),	/* delivery verified, use slow interval */
+	IRQ_EXP_QUICK			= (1 << 2),	/* quick polling enabled */
+	IRQ_EXP_WARNED			= (1 << 3),	/* already whined */
 
 	/*
 	 * IRQ watch parameters.
@@ -99,6 +134,18 @@ enum {
 	IRQ_SPR_POLL_CNT_MAX_DEC_SHIFT	= BITS_PER_BYTE * sizeof(int) / 4,
 };
 
+struct irq_expect {
+	struct irq_expect	*next;
+	struct irq_desc		*desc;		/* the associated IRQ desc */
+	struct irqaction	*act;		/* the associated IRQ action */
+
+	unsigned int		flags;		/* IRQ_EXP_* flags */
+	unsigned int		nr_samples;	/* nr of collected samples in this period */
+	unsigned int		nr_quick;	/* nr of polls completed after single attempt */
+	unsigned int		nr_good;	/* nr of good IRQ deliveries */
+	unsigned long		started;	/* when this period started */
+};
+
 int noirqdebug __read_mostly;
 static int irqfixup __read_mostly = IRQFIXUP_SPURIOUS;
 
@@ -144,8 +191,10 @@ static unsigned long irq_poll_slack(unsigned long intv)
 {
 	if (intv >= IRQ_POLL_SLOW_INTV)
 		return IRQ_POLL_SLOW_SLACK;
-	else
+	else if (intv >= IRQ_POLL_INTV)
 		return IRQ_POLL_SLACK;
+	else
+		return IRQ_POLL_QUICK_SLACK;
 }
 
 /**
@@ -175,6 +224,206 @@ static void irq_schedule_poll(struct irq_desc *desc, unsigned long intv)
 	mod_timer(&desc->poll_timer, expires);
 }
 
+static unsigned long irq_exp_intv(struct irq_expect *exp)
+{
+	if (!(exp->flags & IRQ_EXPECTING))
+		return MAX_JIFFY_OFFSET;
+	if (exp->flags & IRQ_EXP_VERIFIED)
+		return IRQ_POLL_SLOW_INTV;
+	if (exp->flags & IRQ_EXP_QUICK)
+		return IRQ_POLL_QUICK_INTV;
+	return IRQ_POLL_INTV;
+}
+
+/**
+ * init_irq_expect - initialize IRQ expecting
+ * @irq: IRQ to expect
+ * @dev_id: dev_id of the irqaction to expect
+ *
+ * Initializes IRQ expecting and returns expect token to use.  This
+ * function can be called multiple times for the same irqaction and
+ * each token can be used independently.
+ *
+ * CONTEXT:
+ * Does GFP_KERNEL allocation.
+ *
+ * RETURNS:
+ * irq_expect token to use on success, %NULL on failure.
+ */
+struct irq_expect *init_irq_expect(unsigned int irq, void *dev_id)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irqaction *act;
+	struct irq_expect *exp;
+	unsigned long flags;
+
+	if (noirqdebug || WARN_ON_ONCE(!desc))
+		return NULL;
+
+	exp = kzalloc(sizeof(*exp), GFP_KERNEL);
+	if (!exp) {
+		printk(KERN_WARNING "IRQ %u: failed to initialize IRQ expect, "
+		       "allocation failed\n", irq);
+		return NULL;
+	}
+
+	exp->desc = desc;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+
+	act = find_irq_action(desc, dev_id);
+	if (!WARN_ON_ONCE(!act)) {
+		exp->act = act;
+		exp->next = act->expects;
+		act->expects = exp;
+	} else {
+		kfree(exp);
+		exp = NULL;
+	}
+
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	return exp;
+}
+EXPORT_SYMBOL_GPL(init_irq_expect);
+
+/**
+ * expect_irq - expect IRQ
+ * @exp: expect token acquired from init_irq_expect(), %NULL is allowed
+ *
+ * Tell IRQ subsystem to expect an IRQ.  The IRQ might be polled until
+ * unexpect_irq() is called on @exp.  If @exp is %NULL, this function
+ * becomes noop.
+ *
+ * This function is fairly cheap and drivers can call it for each
+ * interrupt driven operation without adding noticeable overhead in
+ * most cases.
+ *
+ * CONTEXT:
+ * Don't care.  The caller is responsible for ensuring
+ * [un]expect_irq() calls don't overlap.  Overlapping may lead to
+ * unexpected polling behaviors but won't directly cause a failure.
+ */
+void expect_irq(struct irq_expect *exp)
+{
+	struct irq_desc *desc;
+	unsigned long intv, deadline;
+	unsigned long flags;
+
+	/* @exp is NULL if noirqdebug */
+	if (unlikely(!exp))
+		return;
+
+	desc = exp->desc;
+	exp->flags |= IRQ_EXPECTING;
+
+	/*
+	 * Paired with mb in poll_irq().  Either we see timer pending
+	 * cleared or poll_irq() sees IRQ_EXPECTING.
+	 */
+	smp_mb();
+
+	exp->started = jiffies;
+	intv = irq_exp_intv(exp);
+	deadline = exp->started + intv + irq_poll_slack(intv);
+
+	/*
+	 * poll_timer is never explicitly killed unless there's no
+	 * action left on the irq; also, while it's online, timer
+	 * duration is only shortened, which means that if we see
+	 * ->expires in the future and not later than our deadline,
+	 * the timer is guaranteed to fire before it.
+	 */
+	if (!timer_pending(&desc->poll_timer) ||
+	    time_after_eq(jiffies, desc->poll_timer.expires) ||
+	    time_before(deadline, desc->poll_timer.expires)) {
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		irq_schedule_poll(desc, intv);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
+}
+EXPORT_SYMBOL_GPL(expect_irq);
+
+/**
+ * unexpect_irq - unexpect IRQ
+ * @exp: expect token acquired from init_irq_expect(), %NULL is allowed
+ * @timedout: did the IRQ timeout?
+ *
+ * Tell IRQ subsystem to stop expecting an IRQ.  Set @timedout to
+ * %true if the expected IRQ never arrived.  If @exp is %NULL, this
+ * function becomes noop.
+ *
+ * This function is fairly cheap and drivers can call it for each
+ * interrupt driven operation without adding noticeable overhead in
+ * most cases.
+ *
+ * CONTEXT:
+ * Don't care.  The caller is responsible for ensuring
+ * [un]expect_irq() calls don't overlap.  Overlapping may lead to
+ * unexpected polling behaviors but won't directly cause a failure.
+ */
+void unexpect_irq(struct irq_expect *exp, bool timedout)
+{
+	struct irq_desc *desc;
+
+	/* @exp is NULL if noirqdebug */
+	if (unlikely(!exp) || (!(exp->flags & IRQ_EXPECTING) && !timedout))
+		return;
+
+	desc = exp->desc;
+	exp->flags &= ~IRQ_EXPECTING;
+
+	/* succesful completion from IRQ? */
+	if (likely(!(desc->status & IRQ_IN_POLLING) && !timedout)) {
+		/*
+		 * IRQ seems a bit more trustworthy.  Allow nr_good to
+		 * increase till VERIFY_GOAL + BAD_FACTOR - 1 so that
+		 * single succesful delivery can recover verified
+		 * state after an accidental polling hit.
+		 */
+		if (unlikely(exp->nr_good <
+			     IRQ_EXP_VERIFY_GOAL + IRQ_EXP_BAD_FACTOR - 1) &&
+		    ++exp->nr_good >= IRQ_EXP_VERIFY_GOAL) {
+			exp->flags |= IRQ_EXP_VERIFIED;
+			exp->nr_samples = 0;
+			exp->nr_quick = 0;
+		}
+		return;
+	}
+
+	/* timedout or polled */
+	if (timedout) {
+		exp->nr_good = 0;
+	} else {
+		exp->nr_good -= min_t(unsigned int,
+				      exp->nr_good, IRQ_EXP_BAD_FACTOR);
+
+		if (time_before_eq(jiffies, exp->started + IRQ_POLL_INTV))
+			exp->nr_quick++;
+
+		if (++exp->nr_samples >= IRQ_EXP_QUICK_SAMPLES) {
+			/*
+			 * Use quick sampling checkpoints as warning
+			 * checkpoints too.
+			 */
+			if (!(exp->flags & IRQ_EXP_WARNED) &&
+			    !desc->spr.poll_rem) {
+				warn_irq_poll(desc, exp->act);
+				exp->flags |= IRQ_EXP_WARNED;
+			}
+
+			exp->flags &= ~IRQ_EXP_QUICK;
+			if (exp->nr_quick >= IRQ_EXP_QUICK_THRESHOLD)
+				exp->flags |= IRQ_EXP_QUICK;
+			exp->nr_samples = 0;
+			exp->nr_quick = 0;
+		}
+	}
+
+	exp->flags &= ~IRQ_EXP_VERIFIED;
+}
+EXPORT_SYMBOL_GPL(unexpect_irq);
+
 /**
  * irq_update_watch - IRQ handled, update watch state
  * @desc: IRQ desc of interest
@@ -512,11 +761,14 @@ void poll_irq(unsigned long arg)
 	unsigned long intv = MAX_JIFFY_OFFSET;
 	bool reenable_irq = false;
 	struct irqaction *act;
+	struct irq_expect *exp;
 
 	raw_spin_lock_irq(&desc->lock);
 
 	/* poll the IRQ */
+	desc->status |= IRQ_IN_POLLING;
 	try_one_irq(desc->irq, desc);
+	desc->status &= ~IRQ_IN_POLLING;
 
 	/* take care of spurious handling */
 	if (spr->poll_rem) {
@@ -530,9 +782,19 @@ void poll_irq(unsigned long arg)
 	if (!spr->poll_rem)
 		reenable_irq = desc->status & IRQ_SPURIOUS_DISABLED;
 
-	/* take care of watches */
-	for (act = desc->action; act; act = act->next)
+	/*
+	 * Paired with mb in expect_irq() so that either they see
+	 * timer pending cleared or irq_exp_intv() below sees
+	 * IRQ_EXPECTING.
+	 */
+	smp_mb();
+
+	/* take care of expects and watches */
+	for (act = desc->action; act; act = act->next) {
 		intv = min(irq_update_watch(desc, act, true), intv);
+		for (exp = act->expects; exp; exp = exp->next)
+			intv = min(irq_exp_intv(exp), intv);
+	}
 
 	/* need to poll again? */
 	if (intv < MAX_JIFFY_OFFSET)
@@ -583,6 +845,7 @@ void irq_poll_action_added(struct irq_desc *desc, struct irqaction *action)
 void irq_poll_action_removed(struct irq_desc *desc, struct irqaction *action)
 {
 	bool irq_enabled = false, timer_killed = false;
+	struct irq_expect *exp, *next;
 	unsigned long flags;
 	int rc;
 
@@ -625,6 +888,13 @@ void irq_poll_action_removed(struct irq_desc *desc, struct irqaction *action)
 		       timer_killed && irq_enabled ? " and" : "",
 		       irq_enabled ? " IRQ reenabled" : "");
 
+	/* free expect tokens */
+	for (exp = action->expects; exp; exp = next) {
+		next = exp->next;
+		kfree(exp);
+	}
+	action->expects = NULL;
+
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
-- 
1.6.4.2

