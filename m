Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0FIKOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:14:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:41285 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab0FIKOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:14:12 -0400
Date: Wed, 9 Jun 2010 10:13:02 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, tglx@linutronix.de, jaxboe@fusionio.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, tglx@linutronix.de, jaxboe@fusionio.com,
       mingo@elte.hu
In-Reply-To: <1275052414.1645.52.camel@laptop>
References: <1275052414.1645.52.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched_clock: Add local_clock() API and improve documentation
Message-ID: <tip-c676329abb2b8359d9a5d734dec0c81779823fd6@git.kernel.org>
Git-Commit-ID: c676329abb2b8359d9a5d734dec0c81779823fd6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:13:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c676329abb2b8359d9a5d734dec0c81779823fd6
Gitweb:     http://git.kernel.org/tip/c676329abb2b8359d9a5d734dec0c81779823fd6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 25 May 2010 10:48:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 10:34:49 +0200

sched_clock: Add local_clock() API and improve documentation

For people who otherwise get to write: cpu_clock(smp_processor_id()),
there is now: local_clock().

Also, as per suggestion from Andrew, provide some documentation on
the various clock interfaces, and minimize the unsigned long long vs
u64 mess.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jaxboe@fusionio.com>
LKML-Reference: <1275052414.1645.52.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/parisc/kernel/ftrace.c |    4 +-
 include/linux/sched.h       |   37 +++++++++-------
 kernel/lockdep.c            |    2 +-
 kernel/perf_event.c         |    2 +-
 kernel/rcutorture.c         |    3 +-
 kernel/sched.c              |    2 +-
 kernel/sched_clock.c        |   95 ++++++++++++++++++++++++++++++++++++++-----
 kernel/trace/trace_clock.c  |    2 +-
 8 files changed, 113 insertions(+), 34 deletions(-)

diff --git a/arch/parisc/kernel/ftrace.c b/arch/parisc/kernel/ftrace.c
index 9877372..5beb97b 100644
--- a/arch/parisc/kernel/ftrace.c
+++ b/arch/parisc/kernel/ftrace.c
@@ -82,7 +82,7 @@ unsigned long ftrace_return_to_handler(unsigned long retval0,
 	unsigned long ret;
 
 	pop_return_trace(&trace, &ret);
-	trace.rettime = cpu_clock(raw_smp_processor_id());
+	trace.rettime = local_clock();
 	ftrace_graph_return(&trace);
 
 	if (unlikely(!ret)) {
@@ -126,7 +126,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		return;
 	}
 
-	calltime = cpu_clock(raw_smp_processor_id());
+	calltime = local_clock();
 
 	if (push_return_trace(old, calltime,
 				self_addr, &trace.depth) == -EBUSY) {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index edc3dd1..c2d4316 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1791,20 +1791,23 @@ static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
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
@@ -1819,17 +1822,19 @@ static inline void sched_clock_idle_wakeup_event(u64 delta_ns)
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
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 5428679..f2852a5 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -146,7 +146,7 @@ static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS],
 
 static inline u64 lockstat_clock(void)
 {
-	return cpu_clock(smp_processor_id());
+	return local_clock();
 }
 
 static int lock_point(unsigned long points[], unsigned long ip)
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 31d6afe..109c5ec 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -214,7 +214,7 @@ static void perf_unpin_context(struct perf_event_context *ctx)
 
 static inline u64 perf_clock(void)
 {
-	return cpu_clock(raw_smp_processor_id());
+	return local_clock();
 }
 
 /*
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 6535ac8..2e2726d 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
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
diff --git a/kernel/sched.c b/kernel/sched.c
index 8f351c5..3abd8f7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1647,7 +1647,7 @@ static void update_shares(struct sched_domain *sd)
 	if (root_task_group_empty())
 		return;
 
-	now = cpu_clock(raw_smp_processor_id());
+	now = local_clock();
 	elapsed = now - sd->last_update;
 
 	if (elapsed >= (s64)(u64)sysctl_sched_shares_ratelimit) {
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 906a0f7..52f1a14 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
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
+ * ######################### BIG FAT WARNING ##########################
+ * # when comparing cpu_clock(i) to cpu_clock(j) for i != j, time can #
+ * # go backwards !!                                                  #
+ * ####################################################################
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
@@ -237,9 +278,19 @@ void sched_clock_idle_wakeup_event(u64 delta_ns)
 }
 EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
 
-unsigned long long cpu_clock(int cpu)
+/*
+ * As outlined at the top, provides a fast, high resolution, nanosecond
+ * time source that is monotonic per cpu argument and has bounded drift
+ * between cpus.
+ *
+ * ######################### BIG FAT WARNING ##########################
+ * # when comparing cpu_clock(i) to cpu_clock(j) for i != j, time can #
+ * # go backwards !!                                                  #
+ * ####################################################################
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
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 9d589d8..1723e2b 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -56,7 +56,7 @@ u64 notrace trace_clock_local(void)
  */
 u64 notrace trace_clock(void)
 {
-	return cpu_clock(raw_smp_processor_id());
+	return local_clock();
 }
 
 
