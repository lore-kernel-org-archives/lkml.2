Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915Ab2J2Uul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:50:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18478 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab2J2Uit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:38:49 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=lFMzH8akVbcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Jsxs859dUmIA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=9AzMRrQhAAAA:8 a=NufY4J3AAAAA:8 a=KKAkSRfTAAAA:8 a=JfrnYn6hAAAA:8 a=ftUzEednAAAA:8 a=sozttTNsAAAA:8 a=EUspDBNiAAAA:8 a=VnNF1IyMAAAA:8 a=fh4mg5NFAAAA:8 a=oPCjUyzrKdeZKcRahVEA:9 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=SxxB86fLhQ4A:10 a=re9sYKne76oA:10 a=WwgC8nHKvroA:10 a=3Rfx1nUSh_UA:10 a=QwxQZocgbLcA:10 a=x2szoZtqnggA:10 a=IG2fH9E8heMA:10 a=Im-eZXwrtqoA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=R6HudSRVP_SnQ8CK:21 a=sgghzxaCWWObm3Wt:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121029203847.391136599@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Oct 2012 16:27:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: [PATCH 05/32] nohz: Adaptive tick stop and restart on nohz cpuset
References: <20121029202711.062749374@goodmis.org>
Content-Disposition: inline; filename=0005-nohz-Adaptive-tick-stop-and-restart-on-nohz-cpuset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

When a CPU is included in a nohz cpuset, try to switch
it to nohz mode from the interrupt exit path if it is running
a single non-idle task.

Then restart the tick if necessary if we are enqueuing a
second task while the timer is stopped, so that the scheduler
tick is rearmed.

[TODO: Handle the many things done from scheduler_tick()]

[ Included build fix from Geoff Levand ]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/smp.c    |    2 ++
 include/linux/sched.h    |    6 ++++
 include/linux/tick.h     |   11 +++++-
 init/Kconfig             |    2 +-
 kernel/sched/core.c      |   24 +++++++++++++
 kernel/sched/sched.h     |   12 +++++++
 kernel/softirq.c         |    6 ++--
 kernel/time/tick-sched.c |   86 +++++++++++++++++++++++++++++++++++++++++-----
 8 files changed, 137 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 4c0b7d2..0bad72d 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/gfp.h>
+#include <linux/tick.h>
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
@@ -275,6 +276,7 @@ void smp_cpuset_update_nohz_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	irq_enter();
+	tick_nohz_check_adaptive();
 	inc_irq_stat(irq_call_count);
 	irq_exit();
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0dd42a0..749752e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2753,6 +2753,12 @@ static inline void inc_syscw(struct task_struct *tsk)
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+extern bool sched_can_stop_tick(void);
+#else
+static inline bool sched_can_stop_tick(void) { return false; }
+#endif
+
 #ifdef CONFIG_MM_OWNER
 extern void mm_update_next_owner(struct mm_struct *mm);
 extern void mm_init_owner(struct mm_struct *mm, struct task_struct *p);
diff --git a/include/linux/tick.h b/include/linux/tick.h
index f37fceb..9b66fd3 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -124,11 +124,12 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 # ifdef CONFIG_NO_HZ
 extern void tick_nohz_idle_enter(void);
 extern void tick_nohz_idle_exit(void);
+extern void tick_nohz_restart_sched_tick(void);
 extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
-# else
+# else /* !NO_HZ */
 static inline void tick_nohz_idle_enter(void) { }
 static inline void tick_nohz_idle_exit(void) { }
 
@@ -142,4 +143,12 @@ static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
 static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !NO_HZ */
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+extern void tick_nohz_check_adaptive(void);
+extern void tick_nohz_post_schedule(void);
+#else /* !CPUSETS_NO_HZ */
+static inline void tick_nohz_check_adaptive(void) { }
+static inline void tick_nohz_post_schedule(void) { }
+#endif /* CPUSETS_NO_HZ */
+
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index ffdeeab..418e078 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -751,7 +751,7 @@ config PROC_PID_CPUSET
 
 config CPUSETS_NO_HZ
        bool "Tickless cpusets"
-       depends on CPUSETS && HAVE_CPUSETS_NO_HZ
+       depends on CPUSETS && HAVE_CPUSETS_NO_HZ && NO_HZ && HIGH_RES_TIMERS
        help
          This options let you apply a nohz property to a cpuset such
 	 that the periodic timer tick tries to be avoided when possible on
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d8927f..2716b79 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1196,6 +1196,29 @@ static void update_avg(u64 *avg, u64 sample)
 }
 #endif
 
+#ifdef CONFIG_CPUSETS_NO_HZ
+bool sched_can_stop_tick(void)
+{
+	struct rq *rq;
+
+	rq = this_rq();
+
+	/*
+	 * This is called right after cpuset_adaptive_nohz() that
+	 * uses atomic_add_return() so that we are ordered against
+	 * cpu_adaptive_nohz_ref. When inc_nr_running() sends an
+	 * IPI to this CPU, we are guaranteed to see the update on
+	 * nr_running.
+	 */
+
+	/* More than one running task need preemption */
+	if (rq->nr_running > 1)
+		return false;
+
+	return true;
+}
+#endif
+
 static void
 ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 {
@@ -1897,6 +1920,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 * frame will be invalid.
 	 */
 	finish_task_switch(this_rq(), prev);
+	tick_nohz_post_schedule();
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7a7db09..c6cd9ec 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1,6 +1,7 @@
 
 #include <linux/sched.h>
 #include <linux/mutex.h>
+#include <linux/cpuset.h>
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
 
@@ -927,6 +928,17 @@ static inline u64 steal_ticks(u64 steal)
 static inline void inc_nr_running(struct rq *rq)
 {
 	rq->nr_running++;
+
+	if (rq->nr_running == 2) {
+		/*
+		 * cpuset_cpu_adaptive_nohz() uses atomic_add_return()
+		 * to order against rq->nr_running updates. This way
+		 * the CPU that receives the IPI is guaranteed to see
+		 * the update on nr_running without the rq->lock.
+		 */
+		if (cpuset_cpu_adaptive_nohz(rq->cpu))
+			smp_cpuset_update_nohz(rq->cpu);
+	}
 }
 
 static inline void dec_nr_running(struct rq *rq)
diff --git a/kernel/softirq.c b/kernel/softirq.c
index cc96bdc..e06b8eb 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -25,6 +25,7 @@
 #include <linux/smp.h>
 #include <linux/smpboot.h>
 #include <linux/tick.h>
+#include <linux/cpuset.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/irq.h>
@@ -307,7 +308,8 @@ void irq_enter(void)
 	int cpu = smp_processor_id();
 
 	rcu_irq_enter();
-	if (is_idle_task(current) && !in_interrupt()) {
+
+	if ((is_idle_task(current) || cpuset_adaptive_nohz()) && !in_interrupt()) {
 		/*
 		 * Prevent raise_softirq from needlessly waking up ksoftirqd
 		 * here, as softirq will be serviced on return from interrupt.
@@ -349,7 +351,7 @@ void irq_exit(void)
 
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
-	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
+	if (!in_interrupt())
 		tick_nohz_irq_exit();
 #endif
 	rcu_irq_exit();
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index c7a78c6..35047b2 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -512,6 +512,24 @@ void tick_nohz_idle_enter(void)
 	local_irq_enable();
 }
 
+static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts)
+{
+#ifdef CONFIG_CPUSETS_NO_HZ
+	int cpu = smp_processor_id();
+
+	if (!cpuset_adaptive_nohz() || is_idle_task(current))
+		return;
+
+	if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
+		return;
+
+	if (!sched_can_stop_tick())
+		return;
+
+	tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
+#endif
+}
+
 /**
  * tick_nohz_irq_exit - update next tick event from interrupt exit
  *
@@ -524,10 +542,12 @@ void tick_nohz_irq_exit(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
-	if (!ts->inidle)
-		return;
-
-	__tick_nohz_idle_enter(ts);
+	if (ts->inidle) {
+		if (!need_resched())
+			__tick_nohz_idle_enter(ts);
+	} else {
+		tick_nohz_cpuset_stop_tick(ts);
+	}
 }
 
 /**
@@ -568,7 +588,7 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 	}
 }
 
-static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
+static void __tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 {
 	/* Update jiffies first */
 	tick_do_update_jiffies64(now);
@@ -584,6 +604,31 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 	tick_nohz_restart(ts, now);
 }
 
+/**
+ * tick_nohz_restart_sched_tick - restart the tick for a tickless CPU
+ *
+ * Restart the tick when the CPU is in adaptive tickless mode.
+ */
+void tick_nohz_restart_sched_tick(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	unsigned long flags;
+	ktime_t now;
+
+	local_irq_save(flags);
+
+	if (!ts->tick_stopped) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	now = ktime_get();
+	__tick_nohz_restart_sched_tick(ts, now);
+
+	local_irq_restore(flags);
+}
+
+
 static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
 {
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
@@ -630,7 +675,7 @@ void tick_nohz_idle_exit(void)
 	if (ts->tick_stopped) {
 		nohz_balance_enter_idle(cpu);
 		calc_load_exit_idle();
-		tick_nohz_restart_sched_tick(ts, now);
+		__tick_nohz_restart_sched_tick(ts, now);
 		tick_nohz_account_idle_ticks(ts);
 	}
 
@@ -791,7 +836,6 @@ void tick_check_idle(int cpu)
 }
 
 #ifdef CONFIG_CPUSETS_NO_HZ
-
 /*
  * Take the timer duty if nobody is taking care of it.
  * If a CPU already does and and it's in a nohz cpuset,
@@ -810,6 +854,31 @@ static void tick_do_timer_check_handler(int cpu)
 	}
 }
 
+void tick_nohz_check_adaptive(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	if (cpuset_adaptive_nohz()) {
+		if (ts->tick_stopped && !is_idle_task(current)) {
+			if (!sched_can_stop_tick())
+				tick_nohz_restart_sched_tick();
+		}
+	}
+}
+
+void tick_nohz_post_schedule(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	/*
+	 * No need to disable irqs here. The worst that can happen
+	 * is an irq that comes and restart the tick before us.
+	 * tick_nohz_restart_sched_tick() is irq safe.
+	 */
+	if (ts->tick_stopped)
+		tick_nohz_restart_sched_tick();
+}
+
 #else
 
 static void tick_do_timer_check_handler(int cpu)
@@ -856,6 +925,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	 * no valid regs pointer
 	 */
 	if (regs) {
+		int user = user_mode(regs);
 		/*
 		 * When we are idle and the tick is stopped, we have to touch
 		 * the watchdog as we might not schedule for a really long
@@ -869,7 +939,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 			if (is_idle_task(current))
 				ts->idle_jiffies++;
 		}
-		update_process_times(user_mode(regs));
+		update_process_times(user);
 		profile_tick(CPU_PROFILING);
 	}
 
-- 
1.7.10.4


