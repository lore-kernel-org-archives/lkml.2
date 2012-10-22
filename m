Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab2JVSyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:54:07 -0400
Received: from flusers.ccur.com ([173.221.59.2]:30337 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755946Ab2JVSyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:54:04 -0400
X-Greylist: delayed 3627 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2012 14:54:03 EDT
Date: Mon, 22 Oct 2012 13:53:32 -0400
From: Joe Korty <joe.korty@ccur.com>
To: stasn77@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] jrcu-3.6-1
Message-ID: <20121022175332.GA13216@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Stas,
Here is the forward port to 3.6 of the LAG jRCU I promised.
I've only compiled and used it on a single x86_64 machine.
The 3.5 version though is getting heavy use on various
x86_64 and i386 machines in the lab.

Regards,
Joe


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="jrcu-3.6-1"

Joe's RCU for Linux-3.6, first cut.

jRCU is a tiny RCU best suited for small-SMP systems.
See Documentation/RCU/jrcu.txt for details.

Recent revision history:

   3.6-1: basic port from 3.5-2, no new functionality added.

   3.5-2: replaced the original lockless implementation with
   one based on locks. This makes the algorithm simplier to
   describe, as well as expand its uses beyond its original
   parameters (small SMP, large frame).  Rewrite based on
   comments from Andi Kleen on the 3.4-1 version last May.

   3.5-1: basic port from 3.4-1, no new functionality added.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- /dev/null
+++ b/kernel/jrcu.c
@@ -0,0 +1,781 @@
+/*
+ * Joe's tiny RCU, for small SMP systems.
+ *
+ * See Documentation/RCU/jrcu.txt for theory of operation and design details.
+ *
+ * Author: Joe Korty <joe.korty@ccur.com>
+ *
+ * Acknowledgements: Paul E. McKenney's 'TinyRCU for uniprocessors' inspired
+ * the thought that there could could be something similiarly simple for SMP.
+ * The rcu_list chain operators are from Jim Houston's Alternative RCU.
+ *
+ * Copyright Concurrent Computer Corporation, 2011-2012.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/bug.h>
+#include <linux/smp.h>
+#include <linux/slab.h>
+#include <linux/ctype.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/stddef.h>
+#include <linux/string.h>
+#include <linux/preempt.h>
+#include <linux/uaccess.h>
+#include <linux/compiler.h>
+#include <linux/irqflags.h>
+#include <linux/rcupdate.h>
+
+/*
+ * Define an rcu list type and operators.  This differs from linux/list.h
+ * in that an rcu list has only ->next pointers for the chain nodes; the
+ * list head however is special and has pointers to both the first and
+ * last nodes of the chain.  Tweaked so that null head, tail pointers can
+ * be used to signify an empty list.
+ */
+struct rcu_list {
+	struct rcu_head *head;
+	struct rcu_head **tail;
+	int count;		/* stats-n-debug */
+};
+
+static inline void rcu_list_init(struct rcu_list *l)
+{
+	l->head = NULL;
+	l->tail = NULL;
+	l->count = 0;
+}
+
+/*
+ * Add an element to the tail of an rcu list
+ */
+static inline void rcu_list_add(struct rcu_list *l, struct rcu_head *h)
+{
+	if (unlikely(l->tail == NULL))
+		l->tail = &l->head;
+	*l->tail = h;
+	l->tail = &h->next;
+	l->count++;
+	h->next = NULL;
+}
+
+/*
+ * Append the contents of one rcu list to another.  The 'from' list is left
+ * corrupted on exit; the caller must re-initialize it before it can be used
+ * again.
+ */
+static inline void rcu_list_join(struct rcu_list *to, struct rcu_list *from)
+{
+	if (from->head) {
+		if (unlikely(to->tail == NULL)) {
+			to->tail = &to->head;
+			to->count = 0;
+		}
+		*to->tail = from->head;
+		to->tail = from->tail;
+		to->count += from->count;
+	}
+}
+
+/* End of generic rcu list definitions, start of specific JRCU stuff */
+
+struct rcu_data {
+	u16 wait;		/* goes false when this cpu consents to
+				 * the retirement of the current batch */
+	struct rcu_list clist;	/* current callback list */
+	struct rcu_list plist;	/* previous callback list */
+	raw_spinlock_t lock;	/* protects the above callback lists */
+	s64 nqueued;		/* #callbacks queued (stats-n-debug) */
+} ____cacheline_aligned_in_smp;
+
+static struct rcu_data rcu_data[NR_CPUS];
+
+/* debug & statistics stuff */
+static struct rcu_stats {
+	unsigned npasses;	/* #passes made */
+	unsigned nlast;		/* #passes since last end-of-batch */
+	unsigned nbatches;	/* #end-of-batches (eobs) seen */
+	atomic_t nbarriers;	/* #rcu barriers processed */
+	atomic_t nsyncs;	/* #rcu syncs processed */
+	s64 ninvoked;		/* #invoked (ie, finished) callbacks */
+	unsigned nforced;	/* #forced eobs (should be zero) */
+} rcu_stats;
+
+#define RCU_HZ_DEFAULT			(20)
+#define RCU_HZ_EXPEDITED		(200)
+#define RCU_HZ_FASTEST			(210)
+
+static int rcu_period_us = USEC_PER_SEC / RCU_HZ_DEFAULT;
+static const int rcu_period_us_expedited = USEC_PER_SEC / RCU_HZ_EXPEDITED;
+static const int rcu_period_ns_min = NSEC_PER_SEC / RCU_HZ_FASTEST;
+
+int rcu_scheduler_active __read_mostly;
+
+static int rcu_wdog_ctr;	/* time since last end-of-batch, in usecs */
+static int rcu_wdog_lim = 2 * USEC_PER_SEC;	/* rcu watchdog interval */
+
+/*
+ * Invoke whenever the calling CPU consents to end-of-batch.  All CPUs
+ * must so consent before the batch is truly ended. xchg() forces the
+ * store through the write buffer to L1, where it can be snooped by
+ * the other cpus, before going on.
+ *
+ * @cpu - must be the invoking cpu.
+ */
+static inline void rcu_eob_cpu(int cpu)
+{
+	struct rcu_data *rd = &rcu_data[cpu];
+	xchg(&rd->wait, 0);
+}
+
+static inline void rcu_eob(void)
+{
+	rcu_eob_cpu(smp_processor_id());
+}
+
+void jrcu_read_unlock(void)
+{
+	if (preempt_count() == 1)
+		rcu_eob();
+	preempt_enable();
+}
+EXPORT_SYMBOL(jrcu_read_unlock);
+
+/*
+ * Tap into irq_exit.
+ *
+ * This marks the cpu as agreeing to end-of-batch if the code the interrupt
+ * driver is returning to is at a quiescent point.
+ */
+void rcu_irq_exit(void)
+{
+	int cpu = smp_processor_id();
+
+	/*
+	 * rcu_irq_exit is called with preemption blocked,
+	 * the -1, below, adjusts for this.  The test against
+	 * idle_cpu() is necessary because the idle task
+	 * runs in voluntary preemption mode (ie, its base
+	 * preempt count is '1' not '0').
+	 */
+	if ((preempt_count() - 1) <= idle_cpu(cpu))
+		rcu_eob_cpu(cpu);
+}
+
+void rcu_note_context_switch(int cpu)
+{
+	rcu_eob_cpu(cpu);
+}
+EXPORT_SYMBOL_GPL(rcu_note_context_switch);
+
+void rcu_note_might_resched(void)
+{
+	preempt_disable();
+	rcu_eob();
+	preempt_enable();
+}
+EXPORT_SYMBOL(rcu_note_might_resched);
+
+
+struct rcu_synchronize {
+	struct rcu_head head;
+	struct completion completion;
+};
+
+static void wakeme_after_rcu(struct rcu_head  *head)
+{
+	struct rcu_synchronize *rcu;
+
+	rcu = container_of(head, struct rcu_synchronize, head);
+	complete(&rcu->completion);
+}
+
+/*
+ * A pair of calls to mark regions in time where framing has to speed up.
+ * These calls nest.
+ */
+static atomic_t rcu_expedite;
+static struct task_struct *rcu_daemon;
+
+static void rcu_expedite_start(void)
+{
+	int new = atomic_inc_return(&rcu_expedite);
+	if (new == 1 && rcu_daemon)
+		wake_up_process(rcu_daemon);
+}
+
+static void rcu_expedite_stop(void)
+{
+	atomic_dec(&rcu_expedite);
+}
+
+static int rcu_frame_rate_usecs(void)
+{
+	return atomic_read(&rcu_expedite)
+		? rcu_period_us_expedited : rcu_period_us;
+}
+
+void synchronize_sched(void)
+{
+	struct rcu_synchronize rcu;
+
+	if (!rcu_scheduler_active)
+		return;
+
+	init_completion(&rcu.completion);
+	call_rcu_sched(&rcu.head, wakeme_after_rcu);
+	rcu_expedite_start();
+	wait_for_completion(&rcu.completion);
+	rcu_expedite_stop();
+	atomic_inc(&rcu_stats.nsyncs);
+
+}
+EXPORT_SYMBOL_GPL(synchronize_sched);
+
+void rcu_barrier(void)
+{
+	/*
+	 * A pair of synchronize_sched's works only because of a fluke
+	 * of implementation: no callback in some newer batch is retired
+	 * until all callbacks in earlier batches are retired.
+	 */
+	synchronize_sched();
+	synchronize_sched();
+	atomic_inc(&rcu_stats.nbarriers);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier);
+
+/*
+ * Insert an RCU callback onto the calling CPUs list of 'current batch'
+ * callbacks.
+ */
+void call_rcu_sched(struct rcu_head *cb, void (*func)(struct rcu_head *rcu))
+{
+	unsigned long flags;
+	struct rcu_data *rd;
+	struct rcu_list *clist;
+
+	cb->func = func;
+	cb->next = NULL;
+
+	raw_local_irq_save(flags);
+	rd = &rcu_data[smp_processor_id()];
+	raw_spin_lock(&rd->lock);
+
+	clist = &rd->clist;
+	rcu_list_add(clist, cb);
+	rd->nqueued++;
+	raw_spin_unlock(&rd->lock);
+	raw_local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(call_rcu_sched);
+
+/*
+ * Invoke all callbacks on the passed-in list.
+ */
+static void rcu_invoke_callbacks(struct rcu_list *pending)
+{
+	struct rcu_head *curr, *next;
+
+	for (curr = pending->head; curr;) {
+		unsigned long offset = (unsigned long)curr->func;
+		next = curr->next;
+		if (__is_kfree_rcu_offset(offset))
+			kfree((void *)curr - offset);
+		else
+			curr->func(curr);
+		curr = next;
+		rcu_stats.ninvoked++;
+	}
+}
+
+/*
+ * Check if the conditions for ending the current batch are true. If
+ * so then end it.
+ *
+ * Must be invoked periodically.  There are no restriction on how often
+ * other than considerations of efficiency.
+ */
+static void __rcu_delimit_batches(struct rcu_list *pending)
+{
+	struct rcu_data *rd;
+	struct rcu_list *clist, *plist;
+	int cpu, eob;
+
+	if (!rcu_scheduler_active)
+		return;
+
+	rcu_stats.nlast++;
+
+	/*
+	 * Find out if the current batch has ended.
+	 */
+	eob = 1; /* first assume that all cpus will allow end-of-batch */
+	for_each_online_cpu(cpu) {
+		rd = &rcu_data[cpu];
+
+		/* we've got nothing to do if this cpu allows end-of-batch */
+		smp_rmb();
+		if (rd->wait == 0)
+			continue;
+
+		/*
+		 * Cpu has not yet told us the batch can end.  That might be
+		 * because it is 100% idle or 100% in userspace, preventing
+		 * it from executing a tap.  Ask the cpu if it is busy or
+		 * quiescent right now.
+		 */
+		if (rcu_iscpu_busy(cpu)) {
+			/* a busy cpu forbids the batch to end right now */
+			eob = 0;
+			break;
+		}
+		/*
+		 * A quiescent cpu allows end-of-batch.	Remember for
+		 * later that this cpu said the current batch could end.
+		 * This is in case we come across some other cpu that
+		 * forbids the batch to end in this frame.
+		 */
+		xchg(&rd->wait, 0);
+	}
+
+	/*
+	 * Exit frame if batch has not ended.  But first, tickle all
+	 * non-cooperating CPUs if enough time has passed.  The tickle
+	 * consists of forcing each cpu to reschedule at the earliest
+	 * possible opportunity.
+	 */
+	if (eob == 0) {
+		if (rcu_wdog_ctr >= rcu_wdog_lim) {
+			rcu_wdog_ctr = 0;
+			rcu_stats.nforced++;
+			for_each_online_cpu(cpu) {
+				if (rcu_data[cpu].wait)
+					smp_send_reschedule(cpu);
+			}
+		}
+		rcu_wdog_ctr += rcu_frame_rate_usecs();
+		return;
+	}
+
+	/*
+	 * End the current RCU batch and start a new one.  This advances the
+	 * FIFO of batches one step.  Callbacks that drop off the end of the
+	 * FIFO are put (temporarily) into a single, global pending list.
+	 * We loop thru the present cpus (rather than the online cpus)
+	 * to clean up those cpus that have gone offline.
+	 */
+	for_each_present_cpu(cpu) {
+		rd = &rcu_data[cpu];
+		plist = &rd->plist;
+		clist = &rd->clist;
+		raw_spin_lock(&rd->lock);
+		/* chain previous batch of callbacks to the pending list */
+		if (plist->head) {
+			rcu_list_join(pending, plist);
+			rcu_list_init(plist);
+		}
+		/* chain the current batch of callbacks to the previous list */
+		if (clist->head) {
+			rcu_list_join(plist, clist);
+			rcu_list_init(clist);
+		}
+		raw_spin_unlock(&rd->lock);
+		/*
+		 * Mark this cpu as needing to pass thru a fresh quiescent
+		 * point. Offline cpus are considered permanently quiescent.
+		 */
+		xchg(&rd->wait, !!cpu_online(cpu));
+	}
+
+	rcu_stats.nbatches++;
+	rcu_stats.nlast = 0;
+	rcu_wdog_ctr = 0;
+}
+
+/*
+ * This is invoked periodically to mark frame boundaries.  It will,
+ * however, NOP (not mark a frame boundary) if it was called too soon
+ * after the previously established frame boundary.  This guarantees no
+ * frame is below a certain size.
+ *
+ * If this frame boundary is legit, then we go and check if this frame
+ * boundary should also be a batch boundary.  If so then we go off and
+ * do batch boundary processing -- push the current batch down into
+ * the FIFO and start a new, empty current batch, as described in
+ * Documentation/RCU/jrcu.txt.
+ */
+static void rcu_delimit_batches(void)
+{
+	unsigned long flags;
+	struct rcu_list pending;
+
+	raw_local_irq_save(flags);
+
+#ifndef CONFIG_JRCU_DEBUG
+	/*
+	 * Disable all limits on JRCU frame rate when running
+	 * in debug mode.
+	 */
+	if (1) {
+		static ktime_t rcu_prev;
+		ktime_t now, delta;
+
+		now = ktime_get();
+		delta = ktime_sub(now, rcu_prev);
+		if (ktime_to_ns(delta) < rcu_period_ns_min) {
+			raw_local_irq_restore(flags);
+			return;
+		}
+		rcu_prev = now;
+	}
+#endif
+
+	rcu_list_init(&pending);
+	rcu_stats.npasses++;
+
+	__rcu_delimit_batches(&pending);
+	raw_local_irq_restore(flags);
+
+	if (pending.head)
+		rcu_invoke_callbacks(&pending);
+}
+
+void rcu_init(void)
+{
+	int cpu;
+	for_each_possible_cpu(cpu)
+		raw_spin_lock_init(&rcu_data[cpu].lock);
+}
+
+/* ------------------ interrupt driver section ------------------ */
+
+/*
+ * We drive RCU from a periodic interrupt only during boot, or
+ * if the daemon goes away on us.  This is probably overkill.
+ */
+
+#include <linux/time.h>
+#include <linux/delay.h>
+#include <linux/hrtimer.h>
+#include <linux/interrupt.h>
+
+static struct hrtimer rcu_timer;
+
+static void rcu_softirq_func(struct softirq_action *h)
+{
+	rcu_delimit_batches();
+}
+
+static enum hrtimer_restart rcu_timer_func(struct hrtimer *t)
+{
+	ktime_t next;
+	int usecs = rcu_frame_rate_usecs();
+
+	raise_softirq(RCU_SOFTIRQ);
+
+	next = ktime_add_us(ktime_get(), usecs);
+	hrtimer_set_expires_range_ns(&rcu_timer, next, 0);
+	return HRTIMER_RESTART;
+}
+
+static void rcu_timer_start(void)
+{
+	int nsecs = rcu_period_us * NSEC_PER_USEC;
+	hrtimer_forward_now(&rcu_timer, ns_to_ktime(nsecs));
+	hrtimer_start_expires(&rcu_timer, HRTIMER_MODE_ABS);
+}
+
+static void rcu_timer_stop(void)
+{
+	hrtimer_cancel(&rcu_timer);
+}
+
+static __init void rcu_timer_init(void)
+{
+	open_softirq(RCU_SOFTIRQ, rcu_softirq_func);
+
+	hrtimer_init(&rcu_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	rcu_timer.function = rcu_timer_func;
+}
+
+void __init rcu_scheduler_starting(void)
+{
+	rcu_timer_init();
+	rcu_scheduler_active = 1;
+	rcu_timer_start();
+	pr_info("JRCU: callback processing via timer started.\n");
+}
+
+/* ------------------ daemon driver section --------------------- */
+
+/*
+ * During normal operation, JRCU state is advanced by this daemon. Using a
+ * daemon gives the administrator finer control over the cpu and priority
+ * of JRCU callback processing than is possible with an interrupt or
+ * softirq driver.
+ */
+#include <linux/err.h>
+#include <linux/param.h>
+#include <linux/kthread.h>
+
+static int rcu_priority;
+
+static int jrcu_set_priority(int priority)
+{
+	struct sched_param param;
+
+	if (priority == 0) {
+		set_user_nice(current, -19);
+		return 0;
+	}
+
+	if (priority < 0)
+		param.sched_priority = MAX_USER_RT_PRIO + priority;
+	else
+		param.sched_priority = priority;
+
+	sched_setscheduler_nocheck(current, SCHED_RR, &param);
+	return param.sched_priority;
+}
+
+static int jrcud_func(void *arg)
+{
+	current->flags |= PF_NOFREEZE;
+	rcu_priority = jrcu_set_priority(CONFIG_JRCU_DAEMON_PRIO);
+
+	rcu_timer_stop();
+	pr_info("JRCU: timer exiting, daemon-based processing started.\n");
+
+	while (!kthread_should_stop()) {
+		int usecs = rcu_frame_rate_usecs();
+		usleep_range_interruptible(usecs, usecs);
+		rcu_delimit_batches();
+	}
+
+	rcu_daemon = NULL;
+	rcu_timer_start();
+	pr_info("JRCU: daemon exiting, timer-based processing restarted.\n");
+	return 0;
+}
+
+static __init int rcu_start_daemon(void)
+{
+	struct task_struct *p;
+
+	p = kthread_run(jrcud_func, NULL, "jrcud");
+	if (IS_ERR(p)) {
+		pr_warn("JRCU: cannot replace callback timer with a daemon\n");
+		return -ENODEV;
+	}
+	rcu_daemon = p;
+	return 0;
+}
+subsys_initcall_sync(rcu_start_daemon);
+
+/* ------------------ debug and statistics section -------------- */
+
+#ifdef CONFIG_DEBUG_FS
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+static int rcu_hz = RCU_HZ_DEFAULT;
+
+static int rcu_debugfs_show(struct seq_file *m, void *unused)
+{
+	int cpu;
+	s64 nqueued;
+
+	nqueued = 0;
+	for_each_present_cpu(cpu)
+		nqueued += rcu_data[cpu].nqueued;
+
+	seq_printf(m, "%14u: hz, %s driven\n",
+		rcu_hz, rcu_daemon ? "daemon" : "hrtimer");
+	seq_printf(m, "%14u: #barriers\n",
+		atomic_read(&rcu_stats.nbarriers));
+	seq_printf(m, "%14u: #syncs\n",
+		atomic_read(&rcu_stats.nsyncs));
+
+	seq_printf(m, "\n");
+	seq_printf(m, "%14u: #passes\n",
+		rcu_stats.npasses);
+	seq_printf(m, "%14u: #passes resulting in end-of-batch\n",
+		rcu_stats.nbatches);
+	seq_printf(m, "%14u: #passes not resulting in end-of-batch\n",
+		rcu_stats.npasses - rcu_stats.nbatches);
+	seq_printf(m, "%14u: #passes forced (0 is best)\n",
+		rcu_stats.nforced);
+	seq_printf(m, "%14u: #secs before a pass is forced (wdog)\n",
+		rcu_wdog_lim / (int)USEC_PER_SEC);
+
+	seq_printf(m, "\n");
+	seq_printf(m, "%14llu: #callbacks invoked\n",
+		rcu_stats.ninvoked);
+	seq_printf(m, "%14d: #callbacks left to invoke\n",
+		(int)(nqueued - rcu_stats.ninvoked));
+	seq_printf(m, "\n");
+
+	for_each_online_cpu(cpu)
+		seq_printf(m, "%4d ", cpu);
+	seq_printf(m, "  CPU\n");
+
+	for_each_online_cpu(cpu) {
+		struct rcu_data *rd = &rcu_data[cpu];
+		seq_printf(m, "--%c%c ",
+			idle_cpu(cpu) ? 'I' : '-',
+			rd->wait ? 'W' : '-');
+	}
+	seq_printf(m, "  FLAGS\n");
+
+	for_each_online_cpu(cpu) {
+		struct rcu_data *rd = &rcu_data[cpu];
+		struct rcu_list *l = &rd->clist;
+		seq_printf(m, "%4d ", l->count);
+	}
+	seq_printf(m, "  curr Q\n");
+
+	for_each_online_cpu(cpu) {
+		struct rcu_data *rd = &rcu_data[cpu];
+		struct rcu_list *l = &rd->plist;
+		seq_printf(m, "%4d ", l->count);
+	}
+	seq_printf(m, "  prev Q\n");
+	seq_printf(m, "\nFLAGS: I - idle, W - waiting for end-of-batch\n");
+
+	return 0;
+}
+
+static ssize_t rcu_debugfs_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *ppos)
+{
+	int i, j, c;
+	char token[32];
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (count <= 0)
+		return count;
+
+	if (!access_ok(VERIFY_READ, buffer, count))
+		return -EFAULT;
+
+	i = 0;
+	if (__get_user(c, &buffer[i++]))
+		return -EFAULT;
+
+next:
+	/* Token extractor -- first, skip leading whitepace */
+	while (c && isspace(c) && i < count) {
+		if (__get_user(c, &buffer[i++]))
+			return -EFAULT;
+	}
+
+	if (i >= count || c == 0)
+		return count;	/* all done, no more tokens */
+
+	j = 0;
+	do {
+		if (j == (sizeof(token) - 1))
+			return -EINVAL;
+		token[j++] = c;
+		if (__get_user(c, &buffer[i++]))
+			return -EFAULT;
+	} while (c && !isspace(c) && i < count); /* extract next token */
+	token[j++] = 0;
+
+	if (!strncmp(token, "hz=", 3)) {
+		int rcu_hz_wanted = -1;
+		sscanf(&token[3], "%d", &rcu_hz_wanted);
+		if (rcu_hz_wanted < 1)
+			return -EINVAL;
+#ifndef CONFIG_JRCU_DEBUG
+		if (rcu_hz_wanted > 1000)
+			return -EINVAL;
+		if (USEC_PER_SEC / rcu_hz_wanted < rcu_period_us_expedited)
+			return -EINVAL;
+#endif
+		rcu_hz = rcu_hz_wanted;
+		rcu_period_us = USEC_PER_SEC / rcu_hz;
+	} else if (!strncmp(token, "wdog=", 5)) {
+		int wdog = -1;
+		sscanf(&token[5], "%d", &wdog);
+		if (wdog < 1 || wdog > 300)
+			return -EINVAL;
+		rcu_wdog_lim = wdog * USEC_PER_SEC;
+#ifdef CONFIG_JRCU_DEBUG
+	} else if (!strncmp(token, "test=", 5)) {
+		u64 start, nsecs;
+		int msecs = -1;
+		sscanf(&token[5], "%d", &msecs);
+		if (msecs < 0 || msecs > 3500)
+			return -EINVAL;
+		nsecs = msecs * NSEC_PER_MSEC;
+		preempt_disable();
+		start = sched_clock();
+		while ((sched_clock() - start) < nsecs)
+			cpu_relax();
+		preempt_enable();
+#endif
+	} else
+		return -EINVAL;
+	goto next;
+}
+
+static int rcu_debugfs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rcu_debugfs_show, NULL);
+}
+
+static const struct file_operations rcu_debugfs_fops = {
+	.owner = THIS_MODULE,
+	.open = rcu_debugfs_open,
+	.read = seq_read,
+	.write = rcu_debugfs_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static struct dentry *rcudir;
+
+static int __init rcu_debugfs_init(void)
+{
+	struct dentry *retval;
+
+	rcudir = debugfs_create_dir("rcu", NULL);
+	if (!rcudir)
+		goto error;
+
+	retval = debugfs_create_file("rcudata", 0644, rcudir,
+			NULL, &rcu_debugfs_fops);
+	if (!retval)
+		goto error;
+
+	return 0;
+
+error:
+	debugfs_remove_recursive(rcudir);
+	pr_warn("JRCU: Could not create debugfs files.\n");
+	return -ENOSYS;
+}
+late_initcall(rcu_debugfs_init);
+#endif /* CONFIG_DEBUG_FS */
Index: b/include/linux/jrcu.h
===================================================================
--- /dev/null
+++ b/include/linux/jrcu.h
@@ -0,0 +1,89 @@
+/*
+ * JRCU - An RCU suitable for small SMP systems.
+ *
+ * Author: Joe Korty <joe.korty@ccur.com>
+ * Copyright Concurrent Computer Corporation, 2011
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#ifndef __LINUX_JRCU_H
+#define __LINUX_JRCU_H
+
+#define __rcu_read_lock()			preempt_disable()
+#define __rcu_read_unlock()			jrcu_read_unlock()
+extern void jrcu_read_unlock(void);
+
+#define __rcu_read_lock_bh()			__rcu_read_lock()
+#define __rcu_read_unlock_bh()			__rcu_read_unlock()
+
+extern void call_rcu_sched(struct rcu_head *head,
+	void (*func)(struct rcu_head *rcu));
+
+#define call_rcu_bh				call_rcu_sched
+#define call_rcu				call_rcu_sched
+
+extern void rcu_barrier(void);
+
+#define rcu_barrier_sched			rcu_barrier
+#define rcu_barrier_bh				rcu_barrier
+
+extern void synchronize_sched(void);
+
+#define synchronize_rcu				synchronize_sched
+#define synchronize_rcu_bh			synchronize_sched
+#define synchronize_rcu_expedited		synchronize_sched
+#define synchronize_rcu_bh_expedited		synchronize_sched
+#define synchronize_sched_expedited		synchronize_sched
+
+extern void rcu_init(void);
+
+static inline void __rcu_check_callbacks(int cpu, int user) { }
+#define rcu_check_callbacks			__rcu_check_callbacks
+
+static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
+{
+	*delta_jiffies = ULONG_MAX;
+	return 0;
+}
+
+#define rcu_batches_completed()			(0)
+#define rcu_batches_completed_bh()		(0)
+#define rcu_preempt_depth()			(0)
+
+static inline void rcu_force_quiescent_state(void) { }
+
+#define rcu_sched_force_quiescent_state		rcu_force_quiescent_state
+#define rcu_bh_force_quiescent_state		rcu_force_quiescent_state
+
+#define rcu_enter_nohz()			do { } while (0)
+#define rcu_exit_nohz()				do { } while (0)
+
+extern void rcu_note_might_resched(void);
+extern void rcu_note_context_switch(int cpu);
+#define rcu_virt_note_context_switch		rcu_note_context_switch
+
+static inline void __rcu_bh_qs(int cpu)		{ }
+#define rcu_bh_qs				__rcu_bh_qs
+
+#define kfree_call_rcu				call_rcu
+
+#define rcu_cpu_stall_reset()			do { } while (0)
+
+extern void rcu_scheduler_starting(void);
+extern int rcu_scheduler_active __read_mostly;
+
+extern int rcu_iscpu_busy(int cpu);
+
+#endif /* __LINUX_JRCU_H */
Index: b/include/linux/rcupdate.h
===================================================================
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -187,10 +187,17 @@ extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_check_callbacks(int cpu, int user);
 struct notifier_block;
+#if defined(CONFIG_JRCU)
+static inline void rcu_idle_enter(void) { }
+static inline void rcu_idle_exit(void) { }
+static inline void rcu_irq_enter(void) { }
+extern void rcu_irq_exit(void);
+#else
 extern void rcu_idle_enter(void);
 extern void rcu_idle_exit(void);
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
+#endif
 extern void exit_rcu(void);
 
 /**
@@ -233,6 +240,8 @@ void wait_rcu_gp(call_rcu_func_t crf);
 #include <linux/rcutree.h>
 #elif defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
 #include <linux/rcutiny.h>
+#elif defined(CONFIG_JRCU)
+#include <linux/jrcu.h>
 #else
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif
Index: b/init/Kconfig
===================================================================
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -433,8 +433,49 @@ config TINY_PREEMPT_RCU
 	  for real-time UP systems.  This option greatly reduces the
 	  memory footprint of RCU.
 
+config JRCU
+	bool "An RCU suitable for small SMP systems"
+	depends on PREEMPT
+	help
+	  This option selects a time-efficient RCU optimized for small SMP
+	  systems  -- 'small' in this case meaning all but the largest
+	  NUMA systems.  It is not clear how big 'small' can be, but it
+	  is known to work well on NUMA platforms having 80 CPUs.
+
+	  jRCU is also a good choice for systems with low latency
+	  requirements.  It does RCU garbage collection from a single
+	  CPU rather than have each CPU do its own.  This frees up all
+	  but one CPU from interference by this periodic requirement.
+
 endchoice
 
+config JRCU_DAEMON_PRIO
+	int "JRCU Daemon priority"
+	depends on JRCU
+	default 0
+	help
+	  The JRCU daemon priority. If 0 then the daemon runs SCHED_OTHER.
+	  If >0 then the daemon runs SCHED_RR and its priority will be
+	  the value selected.  If <0 then SCHED_RR is again selected,
+	  but now its priority will be the biased downwards from the
+	  maximum possible Posix priority.
+
+	  If unsure, select 0.	The other values are useful only for those
+	  rare setups where 100% of every CPU's utilization will be spent in
+	  user SCHED_RR or SCHED_FIFO applications, for long periods of time.
+
+config JRCU_DEBUG
+	bool "JRCU Debug / Test components"
+	depends on JRCU
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  If Y then some extra facilities for testing JRCU correctness will
+	  be included in the kernel. These might be usable for a DoS attack,
+	  so unless you are testing JRCU you should say N here.
+
+	  If unsure, say N.
+
 config PREEMPT_RCU
 	def_bool ( TREE_PREEMPT_RCU || TINY_PREEMPT_RCU )
 	help
@@ -504,7 +545,7 @@ config RCU_FANOUT_EXACT
 
 config RCU_FAST_NO_HZ
 	bool "Accelerate last non-dyntick-idle CPU's grace periods"
-	depends on NO_HZ && SMP
+	depends on NO_HZ && SMP && !JRCU
 	default n
 	help
 	  This option causes RCU to attempt to accelerate grace periods
@@ -529,6 +570,7 @@ config TREE_RCU_TRACE
 config RCU_BOOST
 	bool "Enable RCU priority boosting"
 	depends on RT_MUTEXES && PREEMPT_RCU
+	depends on !JRCU
 	default n
 	help
 	  This option boosts the priority of preempted RCU readers that
Index: b/kernel/Makefile
===================================================================
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -85,6 +85,7 @@ obj-$(CONFIG_RCU_TORTURE_TEST) += rcutor
 obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
 obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
+obj-$(CONFIG_JRCU) += jrcu.o
 obj-$(CONFIG_TINY_RCU) += rcutiny.o
 obj-$(CONFIG_TINY_PREEMPT_RCU) += rcutiny.o
 obj-$(CONFIG_RELAY) += relay.o
Index: b/kernel/sched/core.c
===================================================================
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -645,6 +645,11 @@ void resched_task(struct task_struct *p)
 	assert_raw_spin_locked(&task_rq(p)->lock);
 	set_tsk_need_resched(p);
 }
+
+void force_cpu_resched(int cpu)
+{
+	set_need_resched();
+}
 #endif /* CONFIG_SMP */
 
 #if defined(CONFIG_RT_GROUP_SCHED) || (defined(CONFIG_FAIR_GROUP_SCHED) && \
@@ -1801,6 +1806,56 @@ void sched_fork(struct task_struct *p)
 	put_cpu();
 }
 
+#ifdef CONFIG_JRCU
+
+/*
+ * Return the preemption count of some remote cpu.
+ *
+ * Interrupts must be blocked and the remote cpu's rq lock must be held on
+ * entry. Only the pointers to preempt_count are protected by the lock. The
+ * value itself is serialized by xadd (for x86) or xchg (for all other
+ * archs) every where it updated or read remotely.
+ */
+static inline int preempt_count_cpu(int cpu)
+{
+	struct thread_info *ti;
+
+	ti = task_thread_info(cpu_curr(cpu));
+#ifdef CONFIG_X86
+	return xadd(&ti->preempt_count, 0);
+#else
+	/*
+	 * We don't dare xchg into a remote preempt_count. But we can do
+	 * an exchange to another variable in the same cache line to get
+	 * a (non-atomic) synchronization / update effect sufficient for
+	 * our needs.  Note the the returned preempt count will be stale,
+	 * but it will not come from the time period before the xchg().
+	 */
+	BUG_ON(xchg(&ti->cpu, cpu) != cpu);
+	return ti->preempt_count;
+#endif
+}
+
+/*
+ * Return TRUE if some remote CPU is currently busy.  Return FALSE if it
+ * is instead quiescent.  The value returned is stale.
+ *
+ * The idle_cpu() part of the test is needed because the idle task runs
+ * in voluntary preemption mode.  It implements voluntary preemption by
+ * running with a base preemption count of '1', not '0' as normal tasks do.
+ */
+int rcu_iscpu_busy(int cpu)
+{
+	int state;
+	struct rq *rq = cpu_rq(cpu);
+	raw_spin_lock(&rq->lock);
+	state = preempt_count_cpu(cpu) > idle_cpu(cpu);
+	raw_spin_unlock(&rq->lock);
+	return state;
+}
+
+#endif
+
 /*
  * wake_up_new_task - wake up a newly created task for the first time.
  *
@@ -3255,7 +3310,7 @@ void __kprobes add_preempt_count(int val
 	if (DEBUG_LOCKS_WARN_ON((preempt_count() < 0)))
 		return;
 #endif
-	preempt_count() += val;
+	__add_preempt_count(val);
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Spinlock count overflowing soon?
@@ -3286,7 +3341,7 @@ void __kprobes sub_preempt_count(int val
 
 	if (preempt_count() == val)
 		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
-	preempt_count() -= val;
+	__sub_preempt_count(val);
 }
 EXPORT_SYMBOL(sub_preempt_count);
 
Index: b/include/linux/preempt.h
===================================================================
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -10,12 +10,57 @@
 #include <linux/linkage.h>
 #include <linux/list.h>
 
+/*
+ * The JRCU daemon must be able see increases in a remote
+ * cpu's preemption count in a timely manner.  xadd / xchg
+ * makes the cpu wait until the preemption count memory
+ * location is owned by the invoking CPUs' L1 cache.
+ *
+ * JRCU is not sensitive to seeing _decreases_ in a timely
+ * manner, so don't bother with the xadd / xchg there.
+ */
+
+#ifndef CONFIG_JRCU
+
+# define __add_preempt_count(val) do { preempt_count() += (val); } while (0)
+# define __sub_preempt_count(val) do { preempt_count() -= (val); } while (0)
+
+#elif CONFIG_X86 /* JRCU && X86, all variants */
+
+# define __add_preempt_count(val) do { \
+	xadd(&preempt_count(), (val)); \
+} while (0)
+
+# define __sub_preempt_count(val) do { preempt_count() -= (val); } while (0)
+
+#else /* JRCU && ARM, etc */
+
+/*
+ * The way we use xchg is not atomic but that is OK -- any
+ * particular preempt count has only one writer.  The value
+ * of the xchg is that it will not return until the preempt
+ * count is loaded exclusive-use into the invoking CPU's
+ * L1 cache.
+ */
+static inline void modify_preempt_count_sync(int val)
+{
+	int *addr = &preempt_count();
+	xchg(addr, *addr + val);
+}
+
+# define __add_preempt_count(val) do { \
+	modify_preempt_count_sync(+(val)); \
+} while (0)
+
+# define __sub_preempt_count(val) do { preempt_count() -= (val); } while (0)
+#endif
+
 #if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
   extern void add_preempt_count(int val);
   extern void sub_preempt_count(int val);
 #else
-# define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
-# define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
+# define add_preempt_count(val) __add_preempt_count(val)
+# define sub_preempt_count(val) __sub_preempt_count(val)
 #endif
 
 #define inc_preempt_count() add_preempt_count(1)
Index: b/include/linux/hardirq.h
===================================================================
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -148,6 +148,15 @@ static inline void rcu_nmi_enter(void)
 static inline void rcu_nmi_exit(void)
 {
 }
+#elif defined(CONFIG_JRCU)
+
+static inline void rcu_nmi_enter(void)
+{
+}
+
+static inline void rcu_nmi_exit(void)
+{
+}
 
 #else
 extern void rcu_nmi_enter(void);
Index: b/include/linux/delay.h
===================================================================
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -46,7 +46,7 @@ void calibrate_delay(void);
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
 void usleep_range(unsigned long min, unsigned long max);
-
+int usleep_range_interruptible(unsigned long min, unsigned long max);
 static inline void ssleep(unsigned int seconds)
 {
 	msleep(seconds * 1000);
Index: b/kernel/timer.c
===================================================================
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1851,3 +1851,10 @@ void usleep_range(unsigned long min, uns
 	do_usleep_range(min, max);
 }
 EXPORT_SYMBOL(usleep_range);
+
+int usleep_range_interruptible(unsigned long min, unsigned long max)
+{
+	__set_current_state(TASK_INTERRUPTIBLE);
+	return do_usleep_range(min, max);
+}
+EXPORT_SYMBOL(usleep_range_interruptible);
Index: b/lib/Kconfig.debug
===================================================================
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -392,6 +392,7 @@ config DEBUG_OBJECTS_WORK
 config DEBUG_OBJECTS_RCU_HEAD
 	bool "Debug RCU callbacks objects"
 	depends on DEBUG_OBJECTS
+	depends on !JRCU
 	help
 	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).
 
@@ -606,6 +607,7 @@ config PROVE_LOCKING
 config PROVE_RCU
 	bool "RCU debugging: prove RCU correctness"
 	depends on PROVE_LOCKING
+	depends on !JRCU
 	default n
 	help
 	 This feature enables lockdep extensions that check for correct
@@ -631,6 +633,7 @@ config PROVE_RCU_REPEATEDLY
 
 config SPARSE_RCU_POINTER
 	bool "RCU debugging: sparse-based checks for pointer usage"
+	depends on !JRCU
 	default n
 	help
 	 This feature enables the __rcu sparse annotation for
@@ -914,6 +917,7 @@ config BOOT_PRINTK_DELAY
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
+	depends on !JRCU
 	default n
 	help
 	  This option provides a kernel module that runs torture tests
@@ -982,6 +986,7 @@ config RCU_CPU_STALL_INFO
 config RCU_TRACE
 	bool "Enable tracing for RCU"
 	depends on DEBUG_KERNEL
+	depends on !JRCU
 	help
 	  This option provides tracing in RCU which presents stats
 	  in debugfs for debugging RCU implementation.
Index: b/Documentation/RCU/jrcu.txt
===================================================================
--- /dev/null
+++ b/Documentation/RCU/jrcu.txt
@@ -0,0 +1,215 @@
+                  jRCU Theory of Operation
+                        Joe Korty
+			July 2012
+
+jRCU vs other RCUs (Rationale for Existance):
+
+  The main purpose of jRCU is to bring together and execute
+  on a single cpu the RCU end-of-batch operations of all
+  cpus. This relieves all but one cpu from this periodic
+  responsibility. This is important when the system has
+  user supplied realtime applications that require the
+  full use of cpus dedicated to those applications.
+
+  A secondary purpose is to come up with an RCU
+  implementation that is as simple as possible yet still
+  suitable for SMP platforms, at least the smaller ones.
+  In this regard it fills the gap between TinyRCU, which
+  runs on uniprocessors only, and TreeRCU, a deeply complex
+  implementation best suited for the largest NUMA boxes
+  on Earth.
+
+Operational Overview:
+
+  jRCU, like any RCU, is continually being given callbacks
+  (via call_rcu and family) which it is to invoke later,
+  at points in time that RCU has determined safe. For any
+  particular callback, its safe point is reached whenever
+  every cpu that was in an RCU protected region of code
+  at the point the callback was queued, has left that region.
+
+  RCU protected regions are bracketed by rcu_read_lock and
+  rcu_read_unlock. In jRCU, these map into preempt_disable
+  and preempt_enable; therefore, these can also be used
+  to delininate RCU protected regions.
+
+  In this document, we say that a cpu that is executing
+  code in an RCU-protected region is 'busy'. We say
+  that a cpu that is executing code outside of any RCU
+  protected region is 'quiescent'. And we say that a cpu
+  that has transitioned from an RCU-protected region
+  within some given period of time to have gone through a
+  'quiescent point' during that period.
+
+Organizational Overview:
+
+  jRCU consists of a daemon, which runs on a single cpu
+  and which periodically processes accumulated callbacks
+  across all cpus, and a function, call_rcu(), used by the
+  rest of the kernel for queueing locally the callbacks
+  that the daemon will be later processing.
+
+  All freshly queued callbacks go into the 'current batch'.
+  This is global concept but in terms of implemenation it
+  is fragmented into per-cpu parts.
+
+  The current batch remains open for new callbacks until
+  such time as the jRCU daemon detects that an end-of-batch
+  condition has occurred. At that point the current batch
+  is closed off and a new current batch is opened.
+
+  jRCU maintains a 2-stage FIFO of batches. At the
+  front is the above described current batch. Behind
+  it is the previous batch (also organized into per-cpu
+  fragments). Each time an end-of-batch operation occurs,
+  this FIFO is advanced one step. This advancement
+  consists of:
+
+    The contents of each cpu's previous batch fragment
+    is moved out of the FIFO and chained into a (global)
+    holding area, called the pending batch.
+
+    The contents of each cpu's current batch is moved into
+    that cpu's (now empty) previous batch.
+
+    A new, empty current batch is made available for new
+    callbacks made on on that cpu to be queued into.
+
+    Finally, the callbacks that were put in the pending
+    batch are processed (invoked and discarded).
+
+How jRCU detects when it is safe to end a batch:
+
+  jRCU is frame based. That is, the daemon periodically
+  wakes up and either ends the current batch or it NOPs.
+  For the batch to end, every cpu must have at at least
+  one period, however small, where it was in a quiescent
+  state, since the last time end-of-batch occured.
+
+  jRCU detects quiescent states primarily through the use
+  of taps. A tap is a little bit of code that, when
+  executed, marks that cpu has having passed through a
+  quiescent point. Taps are planted at strategic places
+  throughout the kernel known to be quiescent: the prime
+  example being the point where context switches are made.
+
+  At the start of batch, the daemon marks every cpu as
+  having not seen a quiescent point. As time goes forward,
+  these cpus will, one by one, pass through a tap and
+  when one does that cpu will be marked as having seen a
+  quiescent point.
+
+  Periodically, the jRCU daemon will wake up and look at
+  the accumulated tap results so far. Once it sees that
+  each and every cpu has executed a tap, the daemon ends
+  the current batch and starts a new one.
+
+  Note that, for efficiency, jRCU does not try to detect
+  every occasion where some cpu has passed through a
+  quiescent point. Rather it takes a statistical approach.
+  It is quite willing to miss many opportunities for
+  seeing a quiescent point if in so doing its impact on
+  the system is kept minimal.
+
+Idle cpus and userspace cpus:
+
+  Now, for those cpus which have not executed a tap, the
+  reason may be that the cpu is spending 100% of its time
+  in user space or spending 100% of its time undisturbed
+  in idle. Not only is this time potentially unbounded,
+  but by definition an idle cpu or a user space cpu is in
+  a quiescent state and so does not object to the current
+  batch ending. We would like to catch these cases, at
+  least statistically.
+
+  To find them, at the end of the frame the daemon
+  makes a snapshot read of the quiescent / busy state of
+  each cpu that it is concerned about. This value can
+  come from any point within the just completed frame. If
+  it says 'quiescent' then we know the cpu was in a state
+  of quiescence at at least one point during the frame
+  .. namely at the time of the snapshot. If it says
+  'busy' then we presume, but don't really know, that
+  that this cpu does not consent to end-of-batch now.
+  That is OK .. we will be trying this test again, at the
+  end of the next frame, for those cpus which continue to
+  fail to execute a tap.
+
+  In other words, we allow our snapshotted reading to be
+  stale. As long as it isn't so stale that it comes from
+  before the start of the current batch.
+
+  Now, one would think that reading the remote cpu's
+  preemption count would be sufficient. If the preemption
+  count is zero, it is quiescent, if it is > 0, it is busy.
+  But idle is special. When the idle task is running
+  the base preemption count is '1' not '0'. When a higher
+  priority task tries to preempt idle, rather than being
+  preempted, idle notices the attempt and voluntarily
+  relinquishes the cpu to that higher priority task.
+  Thus idle runs in 'voluntary multitasking mode'; all
+  other tasks run in 'preemptive multitasking mode'.
+
+  To account for this, the actual expression for
+  making a quiescent / busy snapshot of some cpu is:
+
+     preempt_count_cpu(cpu) > idle_cpu(cpu)
+
+  when this expression returns 'true', the cpu is busy.
+  When it is false, the cpu is quiescent.
+
+Races in the above expression
+
+  First, this expression is meaningful only for the case
+  where a cpu has been continuously idle or continuously
+  not idle since the beginning of the batch. If the cpu
+  has in fact not been continuously idle or non-idle, then
+  by definition it is doing context switches and therefore
+  it is allowed to end the current batch at this time, and
+  therefore can end it now, or not .. we can leave that
+  to chance.
+
+  Second, we always read idle_cpu() while holding the remote
+  cpu's rq lock. As this lock protects changes to the idle
+  state, we know that we are getting the current value of
+  that state.
+
+  Third, the rq lock also protects all the pointers to
+  the cpu's current preemption count. So we know that
+  the preemption count variable being pointed to will not
+  change on us while this lock is held.
+
+  However, the actual preemption count value is not
+  protected by any lock. Now, jRCU will work with stale
+  preemption counts but the value read must come from some
+  point in time after the start of the current batch. So
+  a mechanism is needed to insure that.
+
+  Therefore jRCU, for x86, uses xadd() to do all the
+  increments and decrements to the (local) preemption
+  count. xadd has the nice attribute that it does not
+  return until the modified preemption count is visible
+  to all cpus. That is, it will wait until the cache
+  coherency protocol has given the cpu exclusive access
+  to the cache-line-sized region of memory in which the
+  preempt_count value resides.
+
+  The penalty for using xadd is generally small. Most of
+  the time the value will already be in that cpu's L1
+  cache, where the time to fetch-n-update it approaches
+  that of a register access. On the down side, the xadd
+  will cause some serialization of the cpu's operations
+  that otherwise would not have occured. This serialization
+  can be viewed as a kind of processor slowdown.
+
+  The other architectures do not have xadd; for them we
+  have a more involved sequence using xchg(), which has
+  similar serialization properties to xadd(), and is
+  available on all architectures.
+
+  These hand shakes between cpus mean that the jRCU daemon
+  can be safely run at any frame rate, even 'infinity'
+  (no time gap between frames). In one test it was run at
+  a 55,000 Hz frame rate for a weekend on an 8-cpu system,
+  with a load consisting of a 'make -j11' of the kernel,
+  without sign of failure.
Index: b/include/linux/kernel.h
===================================================================
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -147,11 +147,22 @@ struct completion;
 struct pt_regs;
 struct user;
 
+#ifdef CONFIG_JRCU
+extern void rcu_note_might_resched(void);
+#else
+#define rcu_note_might_resched()
+#endif /*JRCU */
+
 #ifdef CONFIG_PREEMPT_VOLUNTARY
 extern int _cond_resched(void);
-# define might_resched() _cond_resched()
+# define might_resched() do { \
+	_cond_resched(); \
+	rcu_note_might_resched(); \
+} while (0)
 #else
-# define might_resched() do { } while (0)
+# define might_resched() do { \
+	rcu_note_might_resched(); \
+} while (0)
 #endif
 
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP

--Q68bSM7Ycu6FN28Q--
