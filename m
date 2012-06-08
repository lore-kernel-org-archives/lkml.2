Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab2FHE1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 00:27:46 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45616 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2FHE1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 00:27:07 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH rcu 4/8] rcu: Precompute RCU_FAST_NO_HZ timer offsets
Date: Thu,  7 Jun 2012 21:26:51 -0700
Message-Id: <1339129615-1795-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339129615-1795-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120608042632.GA1250@linux.vnet.ibm.com>
 <1339129615-1795-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060804-6148-0000-0000-00000685AAA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

When a CPU is entering dyntick-idle mode, tick_nohz_stop_sched_tick()
calls rcu_needs_cpu() see if RCU needs that CPU, and, if not, computes the
next wakeup time based on the timer wheels.  Only later, when actually
entering the idle loop, rcu_prepare_for_idle() will be invoked.  In some
cases, rcu_prepare_for_idle() will post timers to wake the CPU back up.
But all for naught: The next wakeup time for the CPU has already been
computed, and posting a timer afterwards does not force that wakeup
time to be recomputed.  This means that rcu_prepare_for_idle()'s have
no effect.

This is not a problem on a busy system because something else will wake
up the CPU soon enough.  However, on lightly loaded systems, the CPU
might stay asleep for a considerable length of time.  If that CPU has
a callback that the rest of the system is waiting on, the system might
run very slowly or (in theory) even hang.

This commit avoids this problem by having rcu_needs_cpu() give
tick_nohz_stop_sched_tick() an estimate of when RCU will need the CPU
to wake back up, which tick_nohz_stop_sched_tick() takes into account
when programming the CPU's wakeup time.  An alternative approach is
for rcu_prepare_for_idle() to use hrtimers instead of normal timers,
but timers are much more efficient than are hrtimers for frequently
and repeatedly posting and cancelling a given timer, which is exactly
what RCU_FAST_NO_HZ does.

Reported-by: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
---
 include/linux/rcutiny.h  |    6 +++-
 include/linux/rcutree.h  |    2 +-
 kernel/rcutree_plugin.h  |   66 ++++++++++++++++++++++++++++++----------------
 kernel/time/tick-sched.c |    7 ++++-
 4 files changed, 54 insertions(+), 27 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index adb5e5a..854dc4c 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -87,8 +87,9 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 
 #ifdef CONFIG_TINY_RCU
 
-static inline int rcu_needs_cpu(int cpu)
+static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
+	*delta_jiffies = ULONG_MAX;
 	return 0;
 }
 
@@ -96,8 +97,9 @@ static inline int rcu_needs_cpu(int cpu)
 
 int rcu_preempt_needs_cpu(void);
 
-static inline int rcu_needs_cpu(int cpu)
+static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
+	*delta_jiffies = ULONG_MAX;
 	return rcu_preempt_needs_cpu();
 }
 
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 3c6083c..952b793 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -32,7 +32,7 @@
 
 extern void rcu_init(void);
 extern void rcu_note_context_switch(int cpu);
-extern int rcu_needs_cpu(int cpu);
+extern int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies);
 extern void rcu_cpu_stall_reset(void);
 
 /*
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 6bd9637..5271a02 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1886,8 +1886,9 @@ static void __cpuinit rcu_prepare_kthreads(int cpu)
  * Because we not have RCU_FAST_NO_HZ, just check whether this CPU needs
  * any flavor of RCU.
  */
-int rcu_needs_cpu(int cpu)
+int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
+	*delta_jiffies = ULONG_MAX;
 	return rcu_cpu_has_callbacks(cpu);
 }
 
@@ -1963,28 +1964,6 @@ static void rcu_idle_count_callbacks_posted(void)
 #define RCU_IDLE_LAZY_GP_DELAY (6 * HZ)	/* Roughly six seconds. */
 
 /*
- * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
- * callbacks on this CPU, (2) this CPU has not yet attempted to enter
- * dyntick-idle mode, or (3) this CPU is in the process of attempting to
- * enter dyntick-idle mode.  Otherwise, if we have recently tried and failed
- * to enter dyntick-idle mode, we refuse to try to enter it.  After all,
- * it is better to incur scheduling-clock interrupts than to spin
- * continuously for the same time duration!
- */
-int rcu_needs_cpu(int cpu)
-{
-	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
-
-	/* Flag a new idle sojourn to the idle-entry state machine. */
-	rdtp->idle_first_pass = 1;
-	/* If no callbacks, RCU doesn't need the CPU. */
-	if (!rcu_cpu_has_callbacks(cpu))
-		return 0;
-	/* Otherwise, RCU needs the CPU only if it recently tried and failed. */
-	return rdtp->dyntick_holdoff == jiffies;
-}
-
-/*
  * Does the specified flavor of RCU have non-lazy callbacks pending on
  * the specified CPU?  Both RCU flavor and CPU are specified by the
  * rcu_data structure.
@@ -2027,6 +2006,47 @@ static bool rcu_cpu_has_nonlazy_callbacks(int cpu)
 }
 
 /*
+ * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
+ * callbacks on this CPU, (2) this CPU has not yet attempted to enter
+ * dyntick-idle mode, or (3) this CPU is in the process of attempting to
+ * enter dyntick-idle mode.  Otherwise, if we have recently tried and failed
+ * to enter dyntick-idle mode, we refuse to try to enter it.  After all,
+ * it is better to incur scheduling-clock interrupts than to spin
+ * continuously for the same time duration!
+ *
+ * The delta_jiffies argument is used to store the time when RCU is
+ * going to need the CPU again if it still has callbacks.  The reason
+ * for this is that rcu_prepare_for_idle() might need to post a timer,
+ * but if so, it will do so after tick_nohz_stop_sched_tick() has set
+ * the wakeup time for this CPU.  This means that RCU's timer can be
+ * delayed until the wakeup time, which defeats the purpose of posting
+ * a timer.
+ */
+int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
+{
+	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+
+	/* Flag a new idle sojourn to the idle-entry state machine. */
+	rdtp->idle_first_pass = 1;
+	/* If no callbacks, RCU doesn't need the CPU. */
+	if (!rcu_cpu_has_callbacks(cpu)) {
+		*delta_jiffies = ULONG_MAX;
+		return 0;
+	}
+	if (rdtp->dyntick_holdoff == jiffies) {
+		/* RCU recently tried and failed, so don't try again. */
+		*delta_jiffies = 1;
+		return 1;
+	}
+	/* Set up for the possibility that RCU will post a timer. */
+	if (rcu_cpu_has_nonlazy_callbacks(cpu))
+		*delta_jiffies = RCU_IDLE_GP_DELAY;
+	else
+		*delta_jiffies = RCU_IDLE_LAZY_GP_DELAY;
+	return 0;
+}
+
+/*
  * Handler for smp_call_function_single().  The only point of this
  * handler is to wake the CPU up, so the handler does only tracing.
  */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6a3a5b9..52f5ebb 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -274,6 +274,7 @@ EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 static void tick_nohz_stop_sched_tick(struct tick_sched *ts)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
+	unsigned long rcu_delta_jiffies;
 	ktime_t last_update, expires, now;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	u64 time_delta;
@@ -322,7 +323,7 @@ static void tick_nohz_stop_sched_tick(struct tick_sched *ts)
 		time_delta = timekeeping_max_deferment();
 	} while (read_seqretry(&xtime_lock, seq));
 
-	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
+	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) || printk_needs_cpu(cpu) ||
 	    arch_needs_cpu(cpu)) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
@@ -330,6 +331,10 @@ static void tick_nohz_stop_sched_tick(struct tick_sched *ts)
 		/* Get the next timer wheel timer */
 		next_jiffies = get_next_timer_interrupt(last_jiffies);
 		delta_jiffies = next_jiffies - last_jiffies;
+		if (rcu_delta_jiffies < delta_jiffies) {
+			next_jiffies = last_jiffies + rcu_delta_jiffies;
+			delta_jiffies = rcu_delta_jiffies;
+		}
 	}
 	/*
 	 * Do not stop the tick, if we are only one off
-- 
1.7.8

