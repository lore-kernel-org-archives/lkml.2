Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1K1Xfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:35:46 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43344 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab1K1XfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:35:23 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 13/13] rcu: Permit dyntick-idle with callbacks pending
Date: Mon, 28 Nov 2011 15:33:05 -0800
Message-Id: <1322523185-456-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111128233212.GA32279@linux.vnet.ibm.com>
References: <20111128233212.GA32279@linux.vnet.ibm.com>
x-cbid: 11112823-5112-0000-0000-0000028618EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The current implementation of RCU_FAST_NO_HZ prevents CPUs from entering
dyntick-idle state if they have RCU callbacks pending.  Unfortunately,
this has the side-effect of often preventing them from entering this
state, especially if at least one other CPU is not in dyntick-idle state.
However, the resulting per-tick wakeup is wasteful in many cases: if the
CPU has already fully responded to the current RCU grace period, there
will be nothing for it to do until this grace period ends, which will
frequently take several jiffies.

This commit therefore permits a CPU that has done everything that the
current grace period has asked of it (rcu_pending() == 0) even if it
still as RCU callbacks pending.  However, such a CPU posts a timer to
wake it up several jiffies later (6 jiffies, based on experience with
grace-period lengths).  This wakeup is required to handle situations
that can result in all CPUs being in dyntick-idle mode, thus failing
to ever complete the current grace period.  If a CPU wakes up before
the timer goes off, then it cancels that timer, thus avoiding spurious
wakeups.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |    3 +-
 kernel/rcutree.c           |    3 ++
 kernel/rcutree.h           |    2 +
 kernel/rcutree_plugin.h    |   75 +++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 8dd6fcb..c75418c 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -288,9 +288,10 @@ TRACE_EVENT(rcu_dyntick,
  *	"No callbacks": Nothing to do, no callbacks on this CPU.
  *	"In holdoff": Nothing to do, holding off after unsuccessful attempt.
  *	"Begin holdoff": Attempt failed, don't retry until next jiffy.
+ *	"Dyntick with callbacks": Entering dyntick-idle despite callbacks.
  *	"More callbacks": Still more callbacks, try again to clear them out.
  *	"Callbacks drained": All callbacks processed, off to dyntick idle!
- *	"CPU awakened at GP end":
+ *	"Timer": Timer fired to cause CPU to continue processing callbacks.
  */
 TRACE_EVENT(rcu_prep_idle,
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 69bb372..bf085d7 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -448,6 +448,7 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
 	smp_mb__after_atomic_inc();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+	rcu_cleanup_after_idle(smp_processor_id());
 	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
 	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
@@ -2057,6 +2058,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_NESTING;
 	atomic_set(&rdp->dynticks->dynticks,
 		   (atomic_read(&rdp->dynticks->dynticks) & ~0x1) + 1);
+	rcu_prepare_for_idle_init(cpu);
 	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
 	/*
@@ -2138,6 +2140,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		rcu_send_cbs_to_online(&rcu_bh_state);
 		rcu_send_cbs_to_online(&rcu_sched_state);
 		rcu_preempt_send_cbs_to_online();
+		rcu_cleanup_after_idle(cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 70d8a55..9bcfbc9 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -467,6 +467,8 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 static void rcu_cpu_kthread_setrt(int cpu, int to_rt);
 static void __cpuinit rcu_prepare_kthreads(int cpu);
+static void rcu_prepare_for_idle_init(int cpu);
+static void rcu_cleanup_after_idle(int cpu);
 static void rcu_prepare_for_idle(int cpu);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 42ca5a4..dbcea6b 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1947,9 +1947,8 @@ EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
  * 1 if so.  This function is part of the RCU implementation; it is -not-
  * an exported member of the RCU API.
  *
- * Because we have preemptible RCU, just check whether this CPU needs
- * any flavor of RCU.  Do not chew up lots of CPU cycles with preemption
- * disabled in a most-likely vain attempt to cause RCU not to need this CPU.
+ * Because we not have RCU_FAST_NO_HZ, just check whether this CPU needs
+ * any flavor of RCU.
  */
 int rcu_needs_cpu(int cpu)
 {
@@ -1957,6 +1956,21 @@ int rcu_needs_cpu(int cpu)
 }
 
 /*
+ * Because we do not have RCU_FAST_NO_HZ, don't bother initializing for it.
+ */
+static void rcu_prepare_for_idle_init(int cpu)
+{
+}
+
+/*
+ * Because we do not have RCU_FAST_NO_HZ, don't bother cleaning up
+ * after it.
+ */
+static void rcu_cleanup_after_idle(int cpu)
+{
+}
+
+/*
  * Do the idle-entry grace-period work, which, because CONFIG_RCU_FAST_NO_HZ=y,
  * is nothing.
  */
@@ -1966,9 +1980,12 @@ static void rcu_prepare_for_idle(int cpu)
 
 #else /* #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
-#define RCU_NEEDS_CPU_FLUSHES 5
+#define RCU_NEEDS_CPU_FLUSHES 5		/* Allow for callback self-repost. */
+#define RCU_IDLE_GP_DELAY 6		/* Roughly one grace period. */
 static DEFINE_PER_CPU(int, rcu_dyntick_drain);
 static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
+static DEFINE_PER_CPU(struct hrtimer, rcu_idle_gp_timer);
+static ktime_t rcu_idle_gp_wait;
 
 /*
  * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
@@ -1989,6 +2006,47 @@ int rcu_needs_cpu(int cpu)
 }
 
 /*
+ * Timer handler used to force CPU to start pushing its remaining RCU
+ * callbacks in the case where it entered dyntick-idle mode with callbacks
+ * pending.  The hander doesn't really need to do anything because the
+ * real work is done upon re-entry to idle, or by the next scheduling-clock
+ * interrupt should idle not be re-entered.
+ */
+static enum hrtimer_restart rcu_idle_gp_timer_func(struct hrtimer *hrtp)
+{
+	trace_rcu_prep_idle("Timer");
+	return HRTIMER_NORESTART;
+}
+
+/*
+ * Initialize the timer used to pull CPUs out of dyntick-idle mode.
+ */
+static void rcu_prepare_for_idle_init(int cpu)
+{
+	static int firsttime = 1;
+	struct hrtimer *hrtp = &per_cpu(rcu_idle_gp_timer, cpu);
+
+	hrtimer_init(hrtp, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtp->function = rcu_idle_gp_timer_func;
+	if (firsttime) {
+		unsigned int upj = jiffies_to_usecs(RCU_IDLE_GP_DELAY);
+
+		rcu_idle_gp_wait = ns_to_ktime(upj * (u64)1000);
+		firsttime = 0;
+	}
+}
+
+/*
+ * Clean up for exit from idle.  Because we are exiting from idle, there
+ * is no longer any point to rcu_idle_gp_timer, so cancel it.  This will
+ * do nothing if this timer is not active, so just cancel it unconditionally.
+ */
+static void rcu_cleanup_after_idle(int cpu)
+{
+	hrtimer_cancel(&per_cpu(rcu_idle_gp_timer, cpu));
+}
+
+/*
  * Check to see if any RCU-related work can be done by the current CPU,
  * and if so, schedule a softirq to get it done.  This function is part
  * of the RCU implementation; it is -not- an exported member of the RCU API.
@@ -2040,6 +2098,15 @@ static void rcu_prepare_for_idle(int cpu)
 		/* First time through, initialize the counter. */
 		per_cpu(rcu_dyntick_drain, cpu) = RCU_NEEDS_CPU_FLUSHES;
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
+		/* Can we go dyntick-idle despite still having callbacks? */
+		if (!rcu_pending(cpu)) {
+			trace_rcu_prep_idle("Dyntick with callbacks");
+			per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
+			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
+				      rcu_idle_gp_wait, HRTIMER_MODE_REL);
+			return; /* Nothing more to do immediately. */
+		}
+
 		/* We have hit the limit, so time to give up. */
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
 		local_irq_restore(flags);
-- 
1.7.3.2

