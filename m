Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab0E1NNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:13:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0E1NNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:13:38 -0400
Subject: Re: [PATCH] sched_clock: Provide local_clock() and improve
 documentation
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100527113340.d4afb8fc.akpm@linux-foundation.org>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>
	 <20100526160252.325f8357.akpm@linux-foundation.org>
	 <1274942798.27810.3584.camel@twins>
	 <20100526235107.77e66ce0.akpm@linux-foundation.org>
	 <1274945751.27810.3765.camel@twins>
	 <20100527113340.d4afb8fc.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 15:13:34 +0200
Message-ID: <1275052414.1645.52.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 11:33 -0700, Andrew Morton wrote:

> Cool, thanks.  You didn't Cc a mailing list :(

Oops, must have managed to wreck the CC list somewhere, restored LKML.

How does the below look?


---
Subject: sched_clock: Add local_clock() and improve documentation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue May 25 10:48:51 CEST 2010

For people who otherwise get to write: cpu_clock(smp_processor_id()),
there is now: local_clock().

Also, as per suggestion from Andrew, provide some documentation on
the various clock interfaces, and minimize the unsigned long long vs
u64 mess.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/parisc/kernel/ftrace.c |    4 -
 include/linux/sched.h       |   37 +++++++++--------
 kernel/lockdep.c            |    2 
 kernel/perf_event.c         |    2 
 kernel/rcutorture.c         |    3 -
 kernel/sched.c              |    2 
 kernel/sched_clock.c        |   95 +++++++++++++++++++++++++++++++++++++++-----
 kernel/trace/trace_clock.c  |    2 
 8 files changed, 113 insertions(+), 34 deletions(-)

Index: linux-2.6/arch/parisc/kernel/ftrace.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/ftrace.c
+++ linux-2.6/arch/parisc/kernel/ftrace.c
@@ -82,7 +82,7 @@ unsigned long ftrace_return_to_handler(u
 	unsigned long ret;
 
 	pop_return_trace(&trace, &ret);
-	trace.rettime = cpu_clock(raw_smp_processor_id());
+	trace.rettime = local_clock();
 	ftrace_graph_return(&trace);
 
 	if (unlikely(!ret)) {
@@ -126,7 +126,7 @@ void prepare_ftrace_return(unsigned long
 		return;
 	}
 
-	calltime = cpu_clock(raw_smp_processor_id());
+	calltime = local_clock();
 
 	if (push_return_trace(old, calltime,
 				self_addr, &trace.depth) == -EBUSY) {
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1785,20 +1785,23 @@ static inline int set_cpus_allowed(struc
 #endif
 
 /*
- * Architectures can set this to 1 if they have specified
- * CONFIG_HAVE_UNSTABLE_SCHED_CLOCK in their arch Kconfig,
- * but then during bootup it turns out that sched_clock()
- * is reliable after all:
+ * Do not use outside of architecture code which knows its limitations.
+ *
+ * sched_clock() has no promise of monotonicity or bounded drift between
+ * CPUs, use (which you should not) requires disabling IRQs.
+ *
+ * Please use one of the three interfaces below.
  */
-#ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-extern int sched_clock_stable;
-#endif
-
-/* ftrace calls sched_clock() directly */
 extern unsigned long long notrace sched_clock(void);
+/*
+ * See the comment in kernel/sched_clock.c
+ */
+extern u64 cpu_clock(int cpu);
+extern u64 local_clock(void);
+extern u64 sched_clock_cpu(int cpu);
+
 
 extern void sched_clock_init(void);
-extern u64 sched_clock_cpu(int cpu);
 
 #ifndef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 static inline void sched_clock_tick(void)
@@ -1813,17 +1816,19 @@ static inline void sched_clock_idle_wake
 {
 }
 #else
+/*
+ * Architectures can set this to 1 if they have specified
+ * CONFIG_HAVE_UNSTABLE_SCHED_CLOCK in their arch Kconfig,
+ * but then during bootup it turns out that sched_clock()
+ * is reliable after all:
+ */
+extern int sched_clock_stable;
+
 extern void sched_clock_tick(void);
 extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 #endif
 
-/*
- * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
- * clock constructed from sched_clock():
- */
-extern unsigned long long cpu_clock(int cpu);
-
 extern unsigned long long
 task_sched_runtime(struct task_struct *task);
 extern unsigned long long thread_group_sched_runtime(struct task_struct *task);
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -146,7 +146,7 @@ static DEFINE_PER_CPU(struct lock_class_
 
 static inline u64 lockstat_clock(void)
 {
-	return cpu_clock(smp_processor_id());
+	return local_clock();
 }
 
 static int lock_point(unsigned long points[], unsigned long ip)
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -214,7 +214,7 @@ static void perf_unpin_context(struct pe
 
 static inline u64 perf_clock(void)
 {
-	return cpu_clock(raw_smp_processor_id());
+	return local_clock();
 }
 
 /*
Index: linux-2.6/kernel/rcutorture.c
===================================================================
--- linux-2.6.orig/kernel/rcutorture.c
+++ linux-2.6/kernel/rcutorture.c
@@ -239,8 +239,7 @@ static unsigned long
 rcu_random(struct rcu_random_state *rrsp)
 {
 	if (--rrsp->rrs_count < 0) {
-		rrsp->rrs_state +=
-			(unsigned long)cpu_clock(raw_smp_processor_id());
+		rrsp->rrs_state += (unsigned long)local_clock();
 		rrsp->rrs_count = RCU_RANDOM_REFRESH;
 	}
 	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1671,7 +1671,7 @@ static void update_shares(struct sched_d
 	if (root_task_group_empty())
 		return;
 
-	now = cpu_clock(raw_smp_processor_id());
+	now = local_clock();
 	elapsed = now - sd->last_update;
 
 	if (elapsed >= (s64)(u64)sysctl_sched_shares_ratelimit) {
Index: linux-2.6/kernel/sched_clock.c
===================================================================
--- linux-2.6.orig/kernel/sched_clock.c
+++ linux-2.6/kernel/sched_clock.c
@@ -10,19 +10,55 @@
  *   Ingo Molnar <mingo@redhat.com>
  *   Guillaume Chazarain <guichaz@gmail.com>
  *
- * Create a semi stable clock from a mixture of other events, including:
- *  - gtod
+ *
+ * What:
+ *
+ * cpu_clock(i) provides a fast (execution time) high resolution
+ * clock with bounded drift between CPUs. The value of cpu_clock(i)
+ * is monotonic for constant i. The timestamp returned is in nanoseconds.
+ *
+ * ************************* BIG FAT WARNING **************************
+ * * when comparing cpu_clock(i) to cpu_clock(j) for i != j, time can *
+ * * go backwards !!                                                  *
+ * ********************************************************************
+ *
+ * There is no strict promise about the base, although it tends to start
+ * at 0 on boot (but people really shouldn't rely on that).
+ *
+ * cpu_clock(i)       -- can be used from any context, including NMI.
+ * sched_clock_cpu(i) -- must be used with local IRQs disabled (implied by NMI)
+ * local_clock()      -- is cpu_clock() on the current cpu.
+ *
+ * How:
+ *
+ * The implementation either uses sched_clock() when
+ * !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK, which means in that case the
+ * sched_clock() is assumed to provide these properties (mostly it means
+ * the architecture provides a globally synchronized highres time source).
+ *
+ * Otherwise it tries to create a semi stable clock from a mixture of other
+ * clocks, including:
+ *
+ *  - GTOD (clock monotomic)
  *  - sched_clock()
  *  - explicit idle events
  *
- * We use gtod as base and the unstable clock deltas. The deltas are filtered,
- * making it monotonic and keeping it within an expected window.
+ * We use GTOD as base and use sched_clock() deltas to improve resolution. The
+ * deltas are filtered to provide monotonicity and keeping it within an
+ * expected window.
  *
  * Furthermore, explicit sleep and wakeup hooks allow us to account for time
  * that is otherwise invisible (TSC gets stopped).
  *
- * The clock: sched_clock_cpu() is monotonic per cpu, and should be somewhat
- * consistent between cpus (never more than 2 jiffies difference).
+ *
+ * Notes:
+ *
+ * The !IRQ-safetly of sched_clock() and sched_clock_cpu() comes from things
+ * like cpufreq interrupts that can change the base clock (TSC) multiplier
+ * and cause funny jumps in time -- although the filtering provided by
+ * sched_clock_cpu() should mitigate serious artifacts we cannot rely on it
+ * in general since for !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK we fully rely on
+ * sched_clock().
  */
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
@@ -170,6 +206,11 @@ again:
 	return val;
 }
 
+/*
+ * Similar to cpu_clock(), but requires local IRQs to be disabled.
+ *
+ * See cpu_clock().
+ */
 u64 sched_clock_cpu(int cpu)
 {
 	struct sched_clock_data *scd;
@@ -237,9 +278,19 @@ void sched_clock_idle_wakeup_event(u64 d
 }
 EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
 
-unsigned long long cpu_clock(int cpu)
+/*
+ * As outlined at the top, provides a fast, high resolution, nanosecond
+ * time source that is monotonic per cpu argument and has bounded drift
+ * between cpus.
+ *
+ * ************************* BIG FAT WARNING **************************
+ * * when comparing cpu_clock(i) to cpu_clock(j) for i != j, time can *
+ * * go backwards !!                                                  *
+ * ********************************************************************
+ */
+u64 cpu_clock(int cpu)
 {
-	unsigned long long clock;
+	u64 clock;
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -249,6 +300,25 @@ unsigned long long cpu_clock(int cpu)
 	return clock;
 }
 
+/*
+ * Similar to cpu_clock() for the current cpu. Time will only be observed
+ * to be monotonic if care is taken to only compare timestampt taken on the
+ * same CPU.
+ *
+ * See cpu_clock().
+ */
+u64 local_clock(void)
+{
+	u64 clock;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	clock = sched_clock_cpu(smp_processor_id());
+	local_irq_restore(flags);
+
+	return clock;
+}
+
 #else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 
 void sched_clock_init(void)
@@ -264,12 +334,17 @@ u64 sched_clock_cpu(int cpu)
 	return sched_clock();
 }
 
-
-unsigned long long cpu_clock(int cpu)
+u64 cpu_clock(int cpu)
 {
 	return sched_clock_cpu(cpu);
 }
 
+u64 local_clock(void)
+{
+	return sched_clock_cpu(0);
+}
+
 #endif /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 
 EXPORT_SYMBOL_GPL(cpu_clock);
+EXPORT_SYMBOL_GPL(local_clock);
Index: linux-2.6/kernel/trace/trace_clock.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_clock.c
+++ linux-2.6/kernel/trace/trace_clock.c
@@ -56,7 +56,7 @@ u64 notrace trace_clock_local(void)
  */
 u64 notrace trace_clock(void)
 {
-	return cpu_clock(raw_smp_processor_id());
+	return local_clock();
 }
 
 


