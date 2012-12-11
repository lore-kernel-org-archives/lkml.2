Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2LKJlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:41:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55640 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2LKJlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:41:37 -0500
Date: Tue, 11 Dec 2012 10:41:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v3.8
Message-ID: <20121211094130.GA23683@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

   HEAD: c1ad41f1f7270c1956da13fa8fd59d8d5929d56e Revert "sched/autogroup: Fix crash on reboot when autogroup is disabled"

The biggest change affects group scheduling: we now track the 
runnable average on a per-task entity basis, allowing a 
smoother, exponential decay average based load/weight estimation 
instead of the previous binary on-the-runqueue/off-the-runqueue 
load weight method.

This will inevitably disturb workloads that were in some sort of 
borderline balancing state or unstable equilibrium, so an eye 
has to be kept on regressions.

For that reason the new load average is only limited to group 
scheduling (shares distribution) at the moment (which was also 
hurting the most from the prior, crude weight calculation and 
whose scheduling quality wins most from this change) - but we 
plan to extend this to regular SMP balancing as well in the 
future, which will simplify and speed up things a bit.

Other changes involve ongoing preparatory work to extend NOHZ to 
the scheduler as well, eventually allowing completely irq-free 
user-space execution.

 Thanks,

	Ingo

------------------>
Ben Segall (1):
      sched: Maintain per-rq runnable averages

Frederic Weisbecker (14):
      vtime: Gather vtime declarations to their own header file
      vtime: Make vtime_account_system() irqsafe
      kvm: Directly account vtime to system on guest switch
      cputime: Specialize irq vtime hooks
      cputime: Separate irqtime accounting from generic vtime
      vtime: Remove the underscore prefix invasion
      vtime: Explicitly account pending user time on process tick
      vtime: Consolidate a bit the ctx switch code
      vtime: No need to disable irqs on vtime_account()
      vtime: Warn if irqs aren't disabled on system time accounting APIs
      cputime: Move thread_group_cputime() to sched code
      cputime: Rename thread_group_times to thread_group_cputime_adjusted
      cputime: Consolidate cputime adjustment code
      cputime: Comment cputime's adjusting code

Ingo Molnar (2):
      sched: Add WAKEUP_PREEMPTION feature flag, on by default
      Revert "sched/autogroup: Fix crash on reboot when autogroup is disabled"

Mike Galbraith (1):
      sched/autogroup: Fix crash on reboot when autogroup is disabled

Paul Turner (14):
      sched: Track the runnable average on a per-task entity basis
      sched: Aggregate load contributed by task entities on parenting cfs_rq
      sched: Maintain the load contribution of blocked entities
      sched: Add an rq migration call-back to sched_class
      sched: Account for blocked load waking back up
      sched: Aggregate total task_group load
      sched: Compute load contribution by a group entity
      sched: Normalize tg load contributions against runnable time
      sched: Maintain runnable averages across throttled periods
      sched: Replace update_shares weight distribution with per-entity computation
      sched: Refactor update_shares_cpu() -> update_blocked_avgs()
      sched: Update_cfs_shares at period edge
      sched: Make __update_entity_runnable_avg() fast
      sched: Introduce temporary FAIR_GROUP_SCHED dependency for load-tracking

Peter Zijlstra (1):
      sched: Describe CFS load-balancer


 arch/ia64/include/asm/cputime.h    |   2 +
 arch/ia64/kernel/time.c            |  22 +-
 arch/powerpc/include/asm/cputime.h |   2 +
 arch/powerpc/kernel/time.c         |  20 +-
 arch/s390/include/asm/cputime.h    |   1 +
 arch/s390/kernel/vtime.c           |  13 +-
 arch/s390/kvm/kvm-s390.c           |   4 -
 fs/proc/array.c                    |   4 +-
 include/linux/hardirq.h            |  15 +-
 include/linux/kernel_stat.h        |  17 +-
 include/linux/kvm_host.h           |  12 +-
 include/linux/sched.h              |  49 +-
 include/linux/vtime.h              |  48 ++
 kernel/exit.c                      |   4 +-
 kernel/fork.c                      |   2 +-
 kernel/posix-cpu-timers.c          |  24 -
 kernel/sched/auto_group.c          |   4 +
 kernel/sched/auto_group.h          |   5 +
 kernel/sched/core.c                |  11 +
 kernel/sched/cputime.c             | 131 ++++--
 kernel/sched/debug.c               |  36 +-
 kernel/sched/fair.c                | 914 ++++++++++++++++++++++++++++++-------
 kernel/sched/features.h            |   5 +
 kernel/sched/sched.h               |  60 ++-
 kernel/softirq.c                   |   6 +-
 kernel/sys.c                       |   6 +-
 26 files changed, 1082 insertions(+), 335 deletions(-)
 create mode 100644 include/linux/vtime.h

diff --git a/arch/ia64/include/asm/cputime.h b/arch/ia64/include/asm/cputime.h
index 3deac95..7fcf7f0 100644
--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@ -103,5 +103,7 @@ static inline void cputime_to_timeval(const cputime_t ct, struct timeval *val)
 #define cputime64_to_clock_t(__ct)	\
 	cputime_to_clock_t((__force cputime_t)__ct)
 
+extern void arch_vtime_task_switch(struct task_struct *tsk);
+
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 #endif /* __IA64_CPUTIME_H */
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index f638821..b1995ef 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -83,7 +83,7 @@ static struct clocksource *itc_clocksource;
 
 extern cputime_t cycle_to_cputime(u64 cyc);
 
-static void vtime_account_user(struct task_struct *tsk)
+void vtime_account_user(struct task_struct *tsk)
 {
 	cputime_t delta_utime;
 	struct thread_info *ti = task_thread_info(tsk);
@@ -100,18 +100,11 @@ static void vtime_account_user(struct task_struct *tsk)
  * accumulated times to the current process, and to prepare accounting on
  * the next process.
  */
-void vtime_task_switch(struct task_struct *prev)
+void arch_vtime_task_switch(struct task_struct *prev)
 {
 	struct thread_info *pi = task_thread_info(prev);
 	struct thread_info *ni = task_thread_info(current);
 
-	if (idle_task(smp_processor_id()) != prev)
-		vtime_account_system(prev);
-	else
-		vtime_account_idle(prev);
-
-	vtime_account_user(prev);
-
 	pi->ac_stamp = ni->ac_stamp;
 	ni->ac_stime = ni->ac_utime = 0;
 }
@@ -126,6 +119,8 @@ static cputime_t vtime_delta(struct task_struct *tsk)
 	cputime_t delta_stime;
 	__u64 now;
 
+	WARN_ON_ONCE(!irqs_disabled());
+
 	now = ia64_get_itc();
 
 	delta_stime = cycle_to_cputime(ti->ac_stime + (now - ti->ac_stamp));
@@ -147,15 +142,6 @@ void vtime_account_idle(struct task_struct *tsk)
 	account_idle_time(vtime_delta(tsk));
 }
 
-/*
- * Called from the timer interrupt handler to charge accumulated user time
- * to the current process.  Must be called with interrupts disabled.
- */
-void account_process_tick(struct task_struct *p, int user_tick)
-{
-	vtime_account_user(p);
-}
-
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 
 static irqreturn_t
diff --git a/arch/powerpc/include/asm/cputime.h b/arch/powerpc/include/asm/cputime.h
index 487d46f..483733b 100644
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -228,6 +228,8 @@ static inline cputime_t clock_t_to_cputime(const unsigned long clk)
 
 #define cputime64_to_clock_t(ct)	cputime_to_clock_t((cputime_t)(ct))
 
+static inline void arch_vtime_task_switch(struct task_struct *tsk) { }
+
 #endif /* __KERNEL__ */
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 #endif /* __POWERPC_CPUTIME_H */
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index ce4cb77..b3b1435 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -297,6 +297,8 @@ static u64 vtime_delta(struct task_struct *tsk,
 	u64 now, nowscaled, deltascaled;
 	u64 udelta, delta, user_scaled;
 
+	WARN_ON_ONCE(!irqs_disabled());
+
 	now = mftb();
 	nowscaled = read_spurr(now);
 	get_paca()->system_time += now - get_paca()->starttime;
@@ -355,15 +357,15 @@ void vtime_account_idle(struct task_struct *tsk)
 }
 
 /*
- * Transfer the user and system times accumulated in the paca
- * by the exception entry and exit code to the generic process
- * user and system time records.
+ * Transfer the user time accumulated in the paca
+ * by the exception entry and exit code to the generic
+ * process user time records.
  * Must be called with interrupts disabled.
- * Assumes that vtime_account() has been called recently
- * (i.e. since the last entry from usermode) so that
+ * Assumes that vtime_account_system/idle() has been called
+ * recently (i.e. since the last entry from usermode) so that
  * get_paca()->user_time_scaled is up to date.
  */
-void account_process_tick(struct task_struct *tsk, int user_tick)
+void vtime_account_user(struct task_struct *tsk)
 {
 	cputime_t utime, utimescaled;
 
@@ -375,12 +377,6 @@ void account_process_tick(struct task_struct *tsk, int user_tick)
 	account_user_time(tsk, utime, utimescaled);
 }
 
-void vtime_task_switch(struct task_struct *prev)
-{
-	vtime_account(prev);
-	account_process_tick(prev, 0);
-}
-
 #else /* ! CONFIG_VIRT_CPU_ACCOUNTING */
 #define calc_cputime_factors()
 #endif
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index 023d5ae..d2ff4137 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -14,6 +14,7 @@
 
 
 #define __ARCH_HAS_VTIME_ACCOUNT
+#define __ARCH_HAS_VTIME_TASK_SWITCH
 
 /* We want to use full resolution of the CPU timer: 2**-12 micro-seconds. */
 
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 7903344..e84b8b6 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -112,7 +112,12 @@ void vtime_task_switch(struct task_struct *prev)
 	S390_lowcore.system_timer = ti->system_timer;
 }
 
-void account_process_tick(struct task_struct *tsk, int user_tick)
+/*
+ * In s390, accounting pending user time also implies
+ * accounting system time in order to correctly compute
+ * the stolen time accounting.
+ */
+void vtime_account_user(struct task_struct *tsk)
 {
 	if (do_account_vtime(tsk, HARDIRQ_OFFSET))
 		virt_timer_expire();
@@ -127,6 +132,8 @@ void vtime_account(struct task_struct *tsk)
 	struct thread_info *ti = task_thread_info(tsk);
 	u64 timer, system;
 
+	WARN_ON_ONCE(!irqs_disabled());
+
 	timer = S390_lowcore.last_update_timer;
 	S390_lowcore.last_update_timer = get_vtimer();
 	S390_lowcore.system_timer += timer - S390_lowcore.last_update_timer;
@@ -140,6 +147,10 @@ void vtime_account(struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(vtime_account);
 
+void vtime_account_system(struct task_struct *tsk)
+__attribute__((alias("vtime_account")));
+EXPORT_SYMBOL_GPL(vtime_account_system);
+
 void __kprobes vtime_stop_cpu(void)
 {
 	struct s390_idle_data *idle = &__get_cpu_var(s390_idle);
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ecced9d..d91a955 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -608,9 +608,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		kvm_s390_deliver_pending_interrupts(vcpu);
 
 	vcpu->arch.sie_block->icptcode = 0;
-	local_irq_disable();
 	kvm_guest_enter();
-	local_irq_enable();
 	VCPU_EVENT(vcpu, 6, "entering sie flags %x",
 		   atomic_read(&vcpu->arch.sie_block->cpuflags));
 	trace_kvm_s390_sie_enter(vcpu,
@@ -629,9 +627,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	VCPU_EVENT(vcpu, 6, "exit sie icptcode %d",
 		   vcpu->arch.sie_block->icptcode);
 	trace_kvm_s390_sie_exit(vcpu, vcpu->arch.sie_block->icptcode);
-	local_irq_disable();
 	kvm_guest_exit();
-	local_irq_enable();
 
 	memcpy(&vcpu->run->s.regs.gprs[14], &vcpu->arch.sie_block->gg14, 16);
 	return rc;
diff --git a/fs/proc/array.c b/fs/proc/array.c
index c1c207c..d369670 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -438,7 +438,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_times(task, &utime, &stime);
+			thread_group_cputime_adjusted(task, &utime, &stime);
 			gtime += sig->gtime;
 		}
 
@@ -454,7 +454,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	if (!whole) {
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
-		task_times(task, &utime, &stime);
+		task_cputime_adjusted(task, &utime, &stime);
 		gtime = task->gtime;
 	}
 
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index cab3da3..624ef3f 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -4,6 +4,7 @@
 #include <linux/preempt.h>
 #include <linux/lockdep.h>
 #include <linux/ftrace_irq.h>
+#include <linux/vtime.h>
 #include <asm/hardirq.h>
 
 /*
@@ -129,16 +130,6 @@ extern void synchronize_irq(unsigned int irq);
 # define synchronize_irq(irq)	barrier()
 #endif
 
-struct task_struct;
-
-#if !defined(CONFIG_VIRT_CPU_ACCOUNTING) && !defined(CONFIG_IRQ_TIME_ACCOUNTING)
-static inline void vtime_account(struct task_struct *tsk)
-{
-}
-#else
-extern void vtime_account(struct task_struct *tsk);
-#endif
-
 #if defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
 
 static inline void rcu_nmi_enter(void)
@@ -162,7 +153,7 @@ extern void rcu_nmi_exit(void);
  */
 #define __irq_enter()					\
 	do {						\
-		vtime_account(current);		\
+		vtime_account_irq_enter(current);	\
 		add_preempt_count(HARDIRQ_OFFSET);	\
 		trace_hardirq_enter();			\
 	} while (0)
@@ -178,7 +169,7 @@ extern void irq_enter(void);
 #define __irq_exit()					\
 	do {						\
 		trace_hardirq_exit();			\
-		vtime_account(current);		\
+		vtime_account_irq_exit(current);	\
 		sub_preempt_count(HARDIRQ_OFFSET);	\
 	} while (0)
 
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 36d12f0..66b7078 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -7,6 +7,7 @@
 #include <linux/cpumask.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
+#include <linux/vtime.h>
 #include <asm/irq.h>
 #include <asm/cputime.h>
 
@@ -126,16 +127,16 @@ extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t)
 extern void account_steal_time(cputime_t);
 extern void account_idle_time(cputime_t);
 
-extern void account_process_tick(struct task_struct *, int user);
-extern void account_steal_ticks(unsigned long ticks);
-extern void account_idle_ticks(unsigned long ticks);
-
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void vtime_task_switch(struct task_struct *prev);
-extern void vtime_account_system(struct task_struct *tsk);
-extern void vtime_account_idle(struct task_struct *tsk);
+static inline void account_process_tick(struct task_struct *tsk, int user)
+{
+	vtime_account_user(tsk);
+}
 #else
-static inline void vtime_task_switch(struct task_struct *prev) { }
+extern void account_process_tick(struct task_struct *, int user);
 #endif
 
+extern void account_steal_ticks(unsigned long ticks);
+extern void account_idle_ticks(unsigned long ticks);
+
 #endif /* _LINUX_KERNEL_STAT_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ecc5543..d5cddd8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -726,7 +726,11 @@ static inline int kvm_deassign_device(struct kvm *kvm,
 static inline void kvm_guest_enter(void)
 {
 	BUG_ON(preemptible());
-	vtime_account(current);
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system_irqsafe(current);
 	current->flags |= PF_VCPU;
 	/* KVM does not hold any references to rcu protected data when it
 	 * switches CPU into a guest mode. In fact switching to a guest mode
@@ -740,7 +744,11 @@ static inline void kvm_guest_enter(void)
 
 static inline void kvm_guest_exit(void)
 {
-	vtime_account(current);
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system_irqsafe(current);
 	current->flags &= ~PF_VCPU;
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0dd42a0..5dafac3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -434,13 +434,28 @@ struct cpu_itimer {
 };
 
 /**
+ * struct cputime - snaphsot of system and user cputime
+ * @utime: time spent in user mode
+ * @stime: time spent in system mode
+ *
+ * Gathers a generic snapshot of user and system time.
+ */
+struct cputime {
+	cputime_t utime;
+	cputime_t stime;
+};
+
+/**
  * struct task_cputime - collected CPU time counts
  * @utime:		time spent in user mode, in &cputime_t units
  * @stime:		time spent in kernel mode, in &cputime_t units
  * @sum_exec_runtime:	total time spent on the CPU, in nanoseconds
  *
- * This structure groups together three kinds of CPU time that are
- * tracked for threads and thread groups.  Most things considering
+ * This is an extension of struct cputime that includes the total runtime
+ * spent by the task from the scheduler point of view.
+ *
+ * As a result, this structure groups together three kinds of CPU time
+ * that are tracked for threads and thread groups.  Most things considering
  * CPU time want to group these counts together and treat all three
  * of them in parallel.
  */
@@ -581,7 +596,7 @@ struct signal_struct {
 	cputime_t gtime;
 	cputime_t cgtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
-	cputime_t prev_utime, prev_stime;
+	struct cputime prev_cputime;
 #endif
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
@@ -1061,6 +1076,7 @@ struct sched_class {
 
 #ifdef CONFIG_SMP
 	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
+	void (*migrate_task_rq)(struct task_struct *p, int next_cpu);
 
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
@@ -1095,6 +1111,18 @@ struct load_weight {
 	unsigned long weight, inv_weight;
 };
 
+struct sched_avg {
+	/*
+	 * These sums represent an infinite geometric series and so are bound
+	 * above by 1024/(1-y).  Thus we only need a u32 to store them for for all
+	 * choices of y < 1-2^(-32)*1024.
+	 */
+	u32 runnable_avg_sum, runnable_avg_period;
+	u64 last_runnable_update;
+	s64 decay_count;
+	unsigned long load_avg_contrib;
+};
+
 #ifdef CONFIG_SCHEDSTATS
 struct sched_statistics {
 	u64			wait_start;
@@ -1155,6 +1183,15 @@ struct sched_entity {
 	/* rq "owned" by this entity/group: */
 	struct cfs_rq		*my_q;
 #endif
+/*
+ * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
+ * removed when useful for applications beyond shares distribution (e.g.
+ * load-balance).
+ */
+#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+	/* Per-entity load-tracking */
+	struct sched_avg	avg;
+#endif
 };
 
 struct sched_rt_entity {
@@ -1318,7 +1355,7 @@ struct task_struct {
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
-	cputime_t prev_utime, prev_stime;
+	struct cputime prev_cputime;
 #endif
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
@@ -1729,8 +1766,8 @@ static inline void put_task_struct(struct task_struct *t)
 		__put_task_struct(t);
 }
 
-extern void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
-extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
+extern void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
+extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 
 /*
  * Per process flags
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
new file mode 100644
index 0000000..ae30ab5
--- /dev/null
+++ b/include/linux/vtime.h
@@ -0,0 +1,48 @@
+#ifndef _LINUX_KERNEL_VTIME_H
+#define _LINUX_KERNEL_VTIME_H
+
+struct task_struct;
+
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+extern void vtime_task_switch(struct task_struct *prev);
+extern void vtime_account_system(struct task_struct *tsk);
+extern void vtime_account_system_irqsafe(struct task_struct *tsk);
+extern void vtime_account_idle(struct task_struct *tsk);
+extern void vtime_account_user(struct task_struct *tsk);
+extern void vtime_account(struct task_struct *tsk);
+#else
+static inline void vtime_task_switch(struct task_struct *prev) { }
+static inline void vtime_account_system(struct task_struct *tsk) { }
+static inline void vtime_account_system_irqsafe(struct task_struct *tsk) { }
+static inline void vtime_account(struct task_struct *tsk) { }
+#endif
+
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+extern void irqtime_account_irq(struct task_struct *tsk);
+#else
+static inline void irqtime_account_irq(struct task_struct *tsk) { }
+#endif
+
+static inline void vtime_account_irq_enter(struct task_struct *tsk)
+{
+	/*
+	 * Hardirq can interrupt idle task anytime. So we need vtime_account()
+	 * that performs the idle check in CONFIG_VIRT_CPU_ACCOUNTING.
+	 * Softirq can also interrupt idle task directly if it calls
+	 * local_bh_enable(). Such case probably don't exist but we never know.
+	 * Ksoftirqd is not concerned because idle time is flushed on context
+	 * switch. Softirqs in the end of hardirqs are also not a problem because
+	 * the idle time is flushed on hardirq time already.
+	 */
+	vtime_account(tsk);
+	irqtime_account_irq(tsk);
+}
+
+static inline void vtime_account_irq_exit(struct task_struct *tsk)
+{
+	/* On hard|softirq exit we always account to hard|softirq cputime */
+	vtime_account_system(tsk);
+	irqtime_account_irq(tsk);
+}
+
+#endif /* _LINUX_KERNEL_VTIME_H */
diff --git a/kernel/exit.c b/kernel/exit.c
index 346616c..618f7ee 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1186,11 +1186,11 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		 * as other threads in the parent group can be right
 		 * here reaping other children at the same time.
 		 *
-		 * We use thread_group_times() to get times for the thread
+		 * We use thread_group_cputime_adjusted() to get times for the thread
 		 * group, which consolidates times for all threads in the
 		 * group including the group leader.
 		 */
-		thread_group_times(p, &tgutime, &tgstime);
+		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
diff --git a/kernel/fork.c b/kernel/fork.c
index 8b20ab7..0e7cdb9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1222,7 +1222,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->utime = p->stime = p->gtime = 0;
 	p->utimescaled = p->stimescaled = 0;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
-	p->prev_utime = p->prev_stime = 0;
+	p->prev_cputime.utime = p->prev_cputime.stime = 0;
 #endif
 #if defined(SPLIT_RSS_COUNTING)
 	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 125cb67..d738402 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -217,30 +217,6 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 	return 0;
 }
 
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
-{
-	struct signal_struct *sig = tsk->signal;
-	struct task_struct *t;
-
-	times->utime = sig->utime;
-	times->stime = sig->stime;
-	times->sum_exec_runtime = sig->sum_sched_runtime;
-
-	rcu_read_lock();
-	/* make sure we can trust tsk->thread_group list */
-	if (!likely(pid_alive(tsk)))
-		goto out;
-
-	t = tsk;
-	do {
-		times->utime += t->utime;
-		times->stime += t->stime;
-		times->sum_exec_runtime += task_sched_runtime(t);
-	} while_each_thread(tsk, t);
-out:
-	rcu_read_unlock();
-}
-
 static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
 {
 	if (b->utime > a->utime)
diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index 15f60d0..0984a21 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -143,11 +143,15 @@ autogroup_move_group(struct task_struct *p, struct autogroup *ag)
 
 	p->signal->autogroup = autogroup_kref_get(ag);
 
+	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
+		goto out;
+
 	t = p;
 	do {
 		sched_move_task(t);
 	} while_each_thread(p, t);
 
+out:
 	unlock_task_sighand(p, &flags);
 	autogroup_kref_put(prev);
 }
diff --git a/kernel/sched/auto_group.h b/kernel/sched/auto_group.h
index 443232e..8bd0471 100644
--- a/kernel/sched/auto_group.h
+++ b/kernel/sched/auto_group.h
@@ -4,6 +4,11 @@
 #include <linux/rwsem.h>
 
 struct autogroup {
+	/*
+	 * reference doesn't mean how many thread attach to this
+	 * autogroup now. It just stands for the number of task
+	 * could use this autogroup.
+	 */
 	struct kref		kref;
 	struct task_group	*tg;
 	struct rw_semaphore	lock;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d8927f..5dae0d2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -952,6 +952,8 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	trace_sched_migrate_task(p, new_cpu);
 
 	if (task_cpu(p) != new_cpu) {
+		if (p->sched_class->migrate_task_rq)
+			p->sched_class->migrate_task_rq(p, new_cpu);
 		p->se.nr_migrations++;
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, NULL, 0);
 	}
@@ -1524,6 +1526,15 @@ static void __sched_fork(struct task_struct *p)
 	p->se.vruntime			= 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
+/*
+ * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
+ * removed when useful for applications beyond shares distribution (e.g.
+ * load-balance).
+ */
+#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+	p->se.avg.runnable_avg_period = 0;
+	p->se.avg.runnable_avg_sum = 0;
+#endif
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 81b763b..293b202 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -43,7 +43,7 @@ DEFINE_PER_CPU(seqcount_t, irq_time_seq);
  * Called before incrementing preempt_count on {soft,}irq_enter
  * and before decrementing preempt_count on {soft,}irq_exit.
  */
-void vtime_account(struct task_struct *curr)
+void irqtime_account_irq(struct task_struct *curr)
 {
 	unsigned long flags;
 	s64 delta;
@@ -73,7 +73,7 @@ void vtime_account(struct task_struct *curr)
 	irq_time_write_end();
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(vtime_account);
+EXPORT_SYMBOL_GPL(irqtime_account_irq);
 
 static int irqtime_account_hi_update(void)
 {
@@ -288,6 +288,34 @@ static __always_inline bool steal_account_process_tick(void)
 	return false;
 }
 
+/*
+ * Accumulate raw cputime values of dead tasks (sig->[us]time) and live
+ * tasks (sum on group iteration) belonging to @tsk's group.
+ */
+void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
+{
+	struct signal_struct *sig = tsk->signal;
+	struct task_struct *t;
+
+	times->utime = sig->utime;
+	times->stime = sig->stime;
+	times->sum_exec_runtime = sig->sum_sched_runtime;
+
+	rcu_read_lock();
+	/* make sure we can trust tsk->thread_group list */
+	if (!likely(pid_alive(tsk)))
+		goto out;
+
+	t = tsk;
+	do {
+		times->utime += t->utime;
+		times->stime += t->stime;
+		times->sum_exec_runtime += task_sched_runtime(t);
+	} while_each_thread(tsk, t);
+out:
+	rcu_read_unlock();
+}
+
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
@@ -417,13 +445,13 @@ void account_idle_ticks(unsigned long ticks)
  * Use precise platform statistics if available:
  */
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
-void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
 	*ut = p->utime;
 	*st = p->stime;
 }
 
-void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
 	struct task_cputime cputime;
 
@@ -433,6 +461,29 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	*st = cputime.stime;
 }
 
+void vtime_account_system_irqsafe(struct task_struct *tsk)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	vtime_account_system(tsk);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(vtime_account_system_irqsafe);
+
+#ifndef __ARCH_HAS_VTIME_TASK_SWITCH
+void vtime_task_switch(struct task_struct *prev)
+{
+	if (is_idle_task(prev))
+		vtime_account_idle(prev);
+	else
+		vtime_account_system(prev);
+
+	vtime_account_user(prev);
+	arch_vtime_task_switch(prev);
+}
+#endif
+
 /*
  * Archs that account the whole time spent in the idle task
  * (outside irq) as idle time can rely on this and just implement
@@ -444,16 +495,10 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 #ifndef __ARCH_HAS_VTIME_ACCOUNT
 void vtime_account(struct task_struct *tsk)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-
 	if (in_interrupt() || !is_idle_task(tsk))
 		vtime_account_system(tsk);
 	else
 		vtime_account_idle(tsk);
-
-	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(vtime_account);
 #endif /* __ARCH_HAS_VTIME_ACCOUNT */
@@ -478,14 +523,30 @@ static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
 	return (__force cputime_t) temp;
 }
 
-void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+/*
+ * Adjust tick based cputime random precision against scheduler
+ * runtime accounting.
+ */
+static void cputime_adjust(struct task_cputime *curr,
+			   struct cputime *prev,
+			   cputime_t *ut, cputime_t *st)
 {
-	cputime_t rtime, utime = p->utime, total = utime + p->stime;
+	cputime_t rtime, utime, total;
+
+	utime = curr->utime;
+	total = utime + curr->stime;
 
 	/*
-	 * Use CFS's precise accounting:
+	 * Tick based cputime accounting depend on random scheduling
+	 * timeslices of a task to be interrupted or not by the timer.
+	 * Depending on these circumstances, the number of these interrupts
+	 * may be over or under-optimistic, matching the real user and system
+	 * cputime with a variable precision.
+	 *
+	 * Fix this by scaling these tick based values against the total
+	 * runtime accounted by the CFS scheduler.
 	 */
-	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
+	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
 
 	if (total)
 		utime = scale_utime(utime, rtime, total);
@@ -493,38 +554,36 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 		utime = rtime;
 
 	/*
-	 * Compare with previous values, to keep monotonicity:
+	 * If the tick based count grows faster than the scheduler one,
+	 * the result of the scaling may go backward.
+	 * Let's enforce monotonicity.
 	 */
-	p->prev_utime = max(p->prev_utime, utime);
-	p->prev_stime = max(p->prev_stime, rtime - p->prev_utime);
+	prev->utime = max(prev->utime, utime);
+	prev->stime = max(prev->stime, rtime - prev->utime);
 
-	*ut = p->prev_utime;
-	*st = p->prev_stime;
+	*ut = prev->utime;
+	*st = prev->stime;
+}
+
+void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
+{
+	struct task_cputime cputime = {
+		.utime = p->utime,
+		.stime = p->stime,
+		.sum_exec_runtime = p->se.sum_exec_runtime,
+	};
+
+	cputime_adjust(&cputime, &p->prev_cputime, ut, st);
 }
 
 /*
  * Must be called with siglock held.
  */
-void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
-	struct signal_struct *sig = p->signal;
 	struct task_cputime cputime;
-	cputime_t rtime, utime, total;
 
 	thread_group_cputime(p, &cputime);
-
-	total = cputime.utime + cputime.stime;
-	rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
-
-	if (total)
-		utime = scale_utime(cputime.utime, rtime, total);
-	else
-		utime = rtime;
-
-	sig->prev_utime = max(sig->prev_utime, utime);
-	sig->prev_stime = max(sig->prev_stime, rtime - sig->prev_utime);
-
-	*ut = sig->prev_utime;
-	*st = sig->prev_stime;
+	cputime_adjust(&cputime, &p->signal->prev_cputime, ut, st);
 }
 #endif
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 6f79596..2cd3c1b 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -61,14 +61,20 @@ static unsigned long nsec_low(unsigned long long nsec)
 static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group *tg)
 {
 	struct sched_entity *se = tg->se[cpu];
-	if (!se)
-		return;
 
 #define P(F) \
 	SEQ_printf(m, "  .%-30s: %lld\n", #F, (long long)F)
 #define PN(F) \
 	SEQ_printf(m, "  .%-30s: %lld.%06ld\n", #F, SPLIT_NS((long long)F))
 
+	if (!se) {
+		struct sched_avg *avg = &cpu_rq(cpu)->avg;
+		P(avg->runnable_avg_sum);
+		P(avg->runnable_avg_period);
+		return;
+	}
+
+
 	PN(se->exec_start);
 	PN(se->vruntime);
 	PN(se->sum_exec_runtime);
@@ -85,6 +91,12 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 	P(se->statistics.wait_count);
 #endif
 	P(se->load.weight);
+#ifdef CONFIG_SMP
+	P(se->avg.runnable_avg_sum);
+	P(se->avg.runnable_avg_period);
+	P(se->avg.load_avg_contrib);
+	P(se->avg.decay_count);
+#endif
 #undef PN
 #undef P
 }
@@ -206,14 +218,18 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
-	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "load_avg",
-			SPLIT_NS(cfs_rq->load_avg));
-	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "load_period",
-			SPLIT_NS(cfs_rq->load_period));
-	SEQ_printf(m, "  .%-30s: %ld\n", "load_contrib",
-			cfs_rq->load_contribution);
-	SEQ_printf(m, "  .%-30s: %d\n", "load_tg",
-			atomic_read(&cfs_rq->tg->load_weight));
+	SEQ_printf(m, "  .%-30s: %lld\n", "runnable_load_avg",
+			cfs_rq->runnable_load_avg);
+	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
+			cfs_rq->blocked_load_avg);
+	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
+			atomic64_read(&cfs_rq->tg->load_avg));
+	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
+			cfs_rq->tg_load_contrib);
+	SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
+			cfs_rq->tg_runnable_contrib);
+	SEQ_printf(m, "  .%-30s: %d\n", "tg->runnable_avg",
+			atomic_read(&cfs_rq->tg->runnable_avg));
 #endif
 
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6b800a1..59e072b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -259,6 +259,9 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
 	return grp->my_q;
 }
 
+static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
+				       int force_update);
+
 static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	if (!cfs_rq->on_list) {
@@ -278,6 +281,8 @@ static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 		}
 
 		cfs_rq->on_list = 1;
+		/* We should have no load, but we need to update last_decay. */
+		update_cfs_rq_blocked_load(cfs_rq, 0);
 	}
 }
 
@@ -653,9 +658,6 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
-static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update);
-static void update_cfs_shares(struct cfs_rq *cfs_rq);
-
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -675,10 +677,6 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 
 	curr->vruntime += delta_exec_weighted;
 	update_min_vruntime(cfs_rq);
-
-#if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
-	cfs_rq->load_unacc_exec_time += delta_exec;
-#endif
 }
 
 static void update_curr(struct cfs_rq *cfs_rq)
@@ -801,72 +799,7 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-/* we need this in update_cfs_load and load-balance functions below */
-static inline int throttled_hierarchy(struct cfs_rq *cfs_rq);
 # ifdef CONFIG_SMP
-static void update_cfs_rq_load_contribution(struct cfs_rq *cfs_rq,
-					    int global_update)
-{
-	struct task_group *tg = cfs_rq->tg;
-	long load_avg;
-
-	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
-	load_avg -= cfs_rq->load_contribution;
-
-	if (global_update || abs(load_avg) > cfs_rq->load_contribution / 8) {
-		atomic_add(load_avg, &tg->load_weight);
-		cfs_rq->load_contribution += load_avg;
-	}
-}
-
-static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
-{
-	u64 period = sysctl_sched_shares_window;
-	u64 now, delta;
-	unsigned long load = cfs_rq->load.weight;
-
-	if (cfs_rq->tg == &root_task_group || throttled_hierarchy(cfs_rq))
-		return;
-
-	now = rq_of(cfs_rq)->clock_task;
-	delta = now - cfs_rq->load_stamp;
-
-	/* truncate load history at 4 idle periods */
-	if (cfs_rq->load_stamp > cfs_rq->load_last &&
-	    now - cfs_rq->load_last > 4 * period) {
-		cfs_rq->load_period = 0;
-		cfs_rq->load_avg = 0;
-		delta = period - 1;
-	}
-
-	cfs_rq->load_stamp = now;
-	cfs_rq->load_unacc_exec_time = 0;
-	cfs_rq->load_period += delta;
-	if (load) {
-		cfs_rq->load_last = now;
-		cfs_rq->load_avg += delta * load;
-	}
-
-	/* consider updating load contribution on each fold or truncate */
-	if (global_update || cfs_rq->load_period > period
-	    || !cfs_rq->load_period)
-		update_cfs_rq_load_contribution(cfs_rq, global_update);
-
-	while (cfs_rq->load_period > period) {
-		/*
-		 * Inline assembly required to prevent the compiler
-		 * optimising this loop into a divmod call.
-		 * See __iter_div_u64_rem() for another example of this.
-		 */
-		asm("" : "+rm" (cfs_rq->load_period));
-		cfs_rq->load_period /= 2;
-		cfs_rq->load_avg /= 2;
-	}
-
-	if (!cfs_rq->curr && !cfs_rq->nr_running && !cfs_rq->load_avg)
-		list_del_leaf_cfs_rq(cfs_rq);
-}
-
 static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
 {
 	long tg_weight;
@@ -876,8 +809,8 @@ static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
 	 * to gain a more accurate current total weight. See
 	 * update_cfs_rq_load_contribution().
 	 */
-	tg_weight = atomic_read(&tg->load_weight);
-	tg_weight -= cfs_rq->load_contribution;
+	tg_weight = atomic64_read(&tg->load_avg);
+	tg_weight -= cfs_rq->tg_load_contrib;
 	tg_weight += cfs_rq->load.weight;
 
 	return tg_weight;
@@ -901,27 +834,11 @@ static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 
 	return shares;
 }
-
-static void update_entity_shares_tick(struct cfs_rq *cfs_rq)
-{
-	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
-		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq);
-	}
-}
 # else /* CONFIG_SMP */
-static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
-{
-}
-
 static inline long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 {
 	return tg->shares;
 }
-
-static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
-{
-}
 # endif /* CONFIG_SMP */
 static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			    unsigned long weight)
@@ -939,6 +856,8 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 		account_entity_enqueue(cfs_rq, se);
 }
 
+static inline int throttled_hierarchy(struct cfs_rq *cfs_rq);
+
 static void update_cfs_shares(struct cfs_rq *cfs_rq)
 {
 	struct task_group *tg;
@@ -958,18 +877,478 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq)
 	reweight_entity(cfs_rq_of(se), se, shares);
 }
 #else /* CONFIG_FAIR_GROUP_SCHED */
-static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
+static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 {
 }
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 
-static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
+/* Only depends on SMP, FAIR_GROUP_SCHED may be removed when useful in lb */
+#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+/*
+ * We choose a half-life close to 1 scheduling period.
+ * Note: The tables below are dependent on this value.
+ */
+#define LOAD_AVG_PERIOD 32
+#define LOAD_AVG_MAX 47742 /* maximum possible load avg */
+#define LOAD_AVG_MAX_N 345 /* number of full periods to produce LOAD_MAX_AVG */
+
+/* Precomputed fixed inverse multiplies for multiplication by y^n */
+static const u32 runnable_avg_yN_inv[] = {
+	0xffffffff, 0xfa83b2da, 0xf5257d14, 0xefe4b99a, 0xeac0c6e6, 0xe5b906e6,
+	0xe0ccdeeb, 0xdbfbb796, 0xd744fcc9, 0xd2a81d91, 0xce248c14, 0xc9b9bd85,
+	0xc5672a10, 0xc12c4cc9, 0xbd08a39e, 0xb8fbaf46, 0xb504f333, 0xb123f581,
+	0xad583ee9, 0xa9a15ab4, 0xa5fed6a9, 0xa2704302, 0x9ef5325f, 0x9b8d39b9,
+	0x9837f050, 0x94f4efa8, 0x91c3d373, 0x8ea4398a, 0x8b95c1e3, 0x88980e80,
+	0x85aac367, 0x82cd8698,
+};
+
+/*
+ * Precomputed \Sum y^k { 1<=k<=n }.  These are floor(true_value) to prevent
+ * over-estimates when re-combining.
+ */
+static const u32 runnable_avg_yN_sum[] = {
+	    0, 1002, 1982, 2941, 3880, 4798, 5697, 6576, 7437, 8279, 9103,
+	 9909,10698,11470,12226,12966,13690,14398,15091,15769,16433,17082,
+	17718,18340,18949,19545,20128,20698,21256,21802,22336,22859,23371,
+};
+
+/*
+ * Approximate:
+ *   val * y^n,    where y^32 ~= 0.5 (~1 scheduling period)
+ */
+static __always_inline u64 decay_load(u64 val, u64 n)
 {
+	unsigned int local_n;
+
+	if (!n)
+		return val;
+	else if (unlikely(n > LOAD_AVG_PERIOD * 63))
+		return 0;
+
+	/* after bounds checking we can collapse to 32-bit */
+	local_n = n;
+
+	/*
+	 * As y^PERIOD = 1/2, we can combine
+	 *    y^n = 1/2^(n/PERIOD) * k^(n%PERIOD)
+	 * With a look-up table which covers k^n (n<PERIOD)
+	 *
+	 * To achieve constant time decay_load.
+	 */
+	if (unlikely(local_n >= LOAD_AVG_PERIOD)) {
+		val >>= local_n / LOAD_AVG_PERIOD;
+		local_n %= LOAD_AVG_PERIOD;
+	}
+
+	val *= runnable_avg_yN_inv[local_n];
+	/* We don't use SRR here since we always want to round down. */
+	return val >> 32;
 }
 
-static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
+/*
+ * For updates fully spanning n periods, the contribution to runnable
+ * average will be: \Sum 1024*y^n
+ *
+ * We can compute this reasonably efficiently by combining:
+ *   y^PERIOD = 1/2 with precomputed \Sum 1024*y^n {for  n <PERIOD}
+ */
+static u32 __compute_runnable_contrib(u64 n)
 {
+	u32 contrib = 0;
+
+	if (likely(n <= LOAD_AVG_PERIOD))
+		return runnable_avg_yN_sum[n];
+	else if (unlikely(n >= LOAD_AVG_MAX_N))
+		return LOAD_AVG_MAX;
+
+	/* Compute \Sum k^n combining precomputed values for k^i, \Sum k^j */
+	do {
+		contrib /= 2; /* y^LOAD_AVG_PERIOD = 1/2 */
+		contrib += runnable_avg_yN_sum[LOAD_AVG_PERIOD];
+
+		n -= LOAD_AVG_PERIOD;
+	} while (n > LOAD_AVG_PERIOD);
+
+	contrib = decay_load(contrib, n);
+	return contrib + runnable_avg_yN_sum[n];
 }
-#endif /* CONFIG_FAIR_GROUP_SCHED */
+
+/*
+ * We can represent the historical contribution to runnable average as the
+ * coefficients of a geometric series.  To do this we sub-divide our runnable
+ * history into segments of approximately 1ms (1024us); label the segment that
+ * occurred N-ms ago p_N, with p_0 corresponding to the current period, e.g.
+ *
+ * [<- 1024us ->|<- 1024us ->|<- 1024us ->| ...
+ *      p0            p1           p2
+ *     (now)       (~1ms ago)  (~2ms ago)
+ *
+ * Let u_i denote the fraction of p_i that the entity was runnable.
+ *
+ * We then designate the fractions u_i as our co-efficients, yielding the
+ * following representation of historical load:
+ *   u_0 + u_1*y + u_2*y^2 + u_3*y^3 + ...
+ *
+ * We choose y based on the with of a reasonably scheduling period, fixing:
+ *   y^32 = 0.5
+ *
+ * This means that the contribution to load ~32ms ago (u_32) will be weighted
+ * approximately half as much as the contribution to load within the last ms
+ * (u_0).
+ *
+ * When a period "rolls over" and we have new u_0`, multiplying the previous
+ * sum again by y is sufficient to update:
+ *   load_avg = u_0` + y*(u_0 + u_1*y + u_2*y^2 + ... )
+ *            = u_0 + u_1*y + u_2*y^2 + ... [re-labeling u_i --> u_{i+1}]
+ */
+static __always_inline int __update_entity_runnable_avg(u64 now,
+							struct sched_avg *sa,
+							int runnable)
+{
+	u64 delta, periods;
+	u32 runnable_contrib;
+	int delta_w, decayed = 0;
+
+	delta = now - sa->last_runnable_update;
+	/*
+	 * This should only happen when time goes backwards, which it
+	 * unfortunately does during sched clock init when we swap over to TSC.
+	 */
+	if ((s64)delta < 0) {
+		sa->last_runnable_update = now;
+		return 0;
+	}
+
+	/*
+	 * Use 1024ns as the unit of measurement since it's a reasonable
+	 * approximation of 1us and fast to compute.
+	 */
+	delta >>= 10;
+	if (!delta)
+		return 0;
+	sa->last_runnable_update = now;
+
+	/* delta_w is the amount already accumulated against our next period */
+	delta_w = sa->runnable_avg_period % 1024;
+	if (delta + delta_w >= 1024) {
+		/* period roll-over */
+		decayed = 1;
+
+		/*
+		 * Now that we know we're crossing a period boundary, figure
+		 * out how much from delta we need to complete the current
+		 * period and accrue it.
+		 */
+		delta_w = 1024 - delta_w;
+		if (runnable)
+			sa->runnable_avg_sum += delta_w;
+		sa->runnable_avg_period += delta_w;
+
+		delta -= delta_w;
+
+		/* Figure out how many additional periods this update spans */
+		periods = delta / 1024;
+		delta %= 1024;
+
+		sa->runnable_avg_sum = decay_load(sa->runnable_avg_sum,
+						  periods + 1);
+		sa->runnable_avg_period = decay_load(sa->runnable_avg_period,
+						     periods + 1);
+
+		/* Efficiently calculate \sum (1..n_period) 1024*y^i */
+		runnable_contrib = __compute_runnable_contrib(periods);
+		if (runnable)
+			sa->runnable_avg_sum += runnable_contrib;
+		sa->runnable_avg_period += runnable_contrib;
+	}
+
+	/* Remainder of delta accrued against u_0` */
+	if (runnable)
+		sa->runnable_avg_sum += delta;
+	sa->runnable_avg_period += delta;
+
+	return decayed;
+}
+
+/* Synchronize an entity's decay with its parenting cfs_rq.*/
+static inline u64 __synchronize_entity_decay(struct sched_entity *se)
+{
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	u64 decays = atomic64_read(&cfs_rq->decay_counter);
+
+	decays -= se->avg.decay_count;
+	if (!decays)
+		return 0;
+
+	se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
+	se->avg.decay_count = 0;
+
+	return decays;
+}
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
+						 int force_update)
+{
+	struct task_group *tg = cfs_rq->tg;
+	s64 tg_contrib;
+
+	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
+	tg_contrib -= cfs_rq->tg_load_contrib;
+
+	if (force_update || abs64(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
+		atomic64_add(tg_contrib, &tg->load_avg);
+		cfs_rq->tg_load_contrib += tg_contrib;
+	}
+}
+
+/*
+ * Aggregate cfs_rq runnable averages into an equivalent task_group
+ * representation for computing load contributions.
+ */
+static inline void __update_tg_runnable_avg(struct sched_avg *sa,
+						  struct cfs_rq *cfs_rq)
+{
+	struct task_group *tg = cfs_rq->tg;
+	long contrib;
+
+	/* The fraction of a cpu used by this cfs_rq */
+	contrib = div_u64(sa->runnable_avg_sum << NICE_0_SHIFT,
+			  sa->runnable_avg_period + 1);
+	contrib -= cfs_rq->tg_runnable_contrib;
+
+	if (abs(contrib) > cfs_rq->tg_runnable_contrib / 64) {
+		atomic_add(contrib, &tg->runnable_avg);
+		cfs_rq->tg_runnable_contrib += contrib;
+	}
+}
+
+static inline void __update_group_entity_contrib(struct sched_entity *se)
+{
+	struct cfs_rq *cfs_rq = group_cfs_rq(se);
+	struct task_group *tg = cfs_rq->tg;
+	int runnable_avg;
+
+	u64 contrib;
+
+	contrib = cfs_rq->tg_load_contrib * tg->shares;
+	se->avg.load_avg_contrib = div64_u64(contrib,
+					     atomic64_read(&tg->load_avg) + 1);
+
+	/*
+	 * For group entities we need to compute a correction term in the case
+	 * that they are consuming <1 cpu so that we would contribute the same
+	 * load as a task of equal weight.
+	 *
+	 * Explicitly co-ordinating this measurement would be expensive, but
+	 * fortunately the sum of each cpus contribution forms a usable
+	 * lower-bound on the true value.
+	 *
+	 * Consider the aggregate of 2 contributions.  Either they are disjoint
+	 * (and the sum represents true value) or they are disjoint and we are
+	 * understating by the aggregate of their overlap.
+	 *
+	 * Extending this to N cpus, for a given overlap, the maximum amount we
+	 * understand is then n_i(n_i+1)/2 * w_i where n_i is the number of
+	 * cpus that overlap for this interval and w_i is the interval width.
+	 *
+	 * On a small machine; the first term is well-bounded which bounds the
+	 * total error since w_i is a subset of the period.  Whereas on a
+	 * larger machine, while this first term can be larger, if w_i is the
+	 * of consequential size guaranteed to see n_i*w_i quickly converge to
+	 * our upper bound of 1-cpu.
+	 */
+	runnable_avg = atomic_read(&tg->runnable_avg);
+	if (runnable_avg < NICE_0_LOAD) {
+		se->avg.load_avg_contrib *= runnable_avg;
+		se->avg.load_avg_contrib >>= NICE_0_SHIFT;
+	}
+}
+#else
+static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
+						 int force_update) {}
+static inline void __update_tg_runnable_avg(struct sched_avg *sa,
+						  struct cfs_rq *cfs_rq) {}
+static inline void __update_group_entity_contrib(struct sched_entity *se) {}
+#endif
+
+static inline void __update_task_entity_contrib(struct sched_entity *se)
+{
+	u32 contrib;
+
+	/* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
+	contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
+	contrib /= (se->avg.runnable_avg_period + 1);
+	se->avg.load_avg_contrib = scale_load(contrib);
+}
+
+/* Compute the current contribution to load_avg by se, return any delta */
+static long __update_entity_load_avg_contrib(struct sched_entity *se)
+{
+	long old_contrib = se->avg.load_avg_contrib;
+
+	if (entity_is_task(se)) {
+		__update_task_entity_contrib(se);
+	} else {
+		__update_tg_runnable_avg(&se->avg, group_cfs_rq(se));
+		__update_group_entity_contrib(se);
+	}
+
+	return se->avg.load_avg_contrib - old_contrib;
+}
+
+static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
+						 long load_contrib)
+{
+	if (likely(load_contrib < cfs_rq->blocked_load_avg))
+		cfs_rq->blocked_load_avg -= load_contrib;
+	else
+		cfs_rq->blocked_load_avg = 0;
+}
+
+static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq);
+
+/* Update a sched_entity's runnable average */
+static inline void update_entity_load_avg(struct sched_entity *se,
+					  int update_cfs_rq)
+{
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	long contrib_delta;
+	u64 now;
+
+	/*
+	 * For a group entity we need to use their owned cfs_rq_clock_task() in
+	 * case they are the parent of a throttled hierarchy.
+	 */
+	if (entity_is_task(se))
+		now = cfs_rq_clock_task(cfs_rq);
+	else
+		now = cfs_rq_clock_task(group_cfs_rq(se));
+
+	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq))
+		return;
+
+	contrib_delta = __update_entity_load_avg_contrib(se);
+
+	if (!update_cfs_rq)
+		return;
+
+	if (se->on_rq)
+		cfs_rq->runnable_load_avg += contrib_delta;
+	else
+		subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
+}
+
+/*
+ * Decay the load contributed by all blocked children and account this so that
+ * their contribution may appropriately discounted when they wake up.
+ */
+static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
+{
+	u64 now = cfs_rq_clock_task(cfs_rq) >> 20;
+	u64 decays;
+
+	decays = now - cfs_rq->last_decay;
+	if (!decays && !force_update)
+		return;
+
+	if (atomic64_read(&cfs_rq->removed_load)) {
+		u64 removed_load = atomic64_xchg(&cfs_rq->removed_load, 0);
+		subtract_blocked_load_contrib(cfs_rq, removed_load);
+	}
+
+	if (decays) {
+		cfs_rq->blocked_load_avg = decay_load(cfs_rq->blocked_load_avg,
+						      decays);
+		atomic64_add(decays, &cfs_rq->decay_counter);
+		cfs_rq->last_decay = now;
+	}
+
+	__update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
+	update_cfs_shares(cfs_rq);
+}
+
+static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
+{
+	__update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable);
+	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
+}
+
+/* Add the load generated by se into cfs_rq's child load-average */
+static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
+						  struct sched_entity *se,
+						  int wakeup)
+{
+	/*
+	 * We track migrations using entity decay_count <= 0, on a wake-up
+	 * migration we use a negative decay count to track the remote decays
+	 * accumulated while sleeping.
+	 */
+	if (unlikely(se->avg.decay_count <= 0)) {
+		se->avg.last_runnable_update = rq_of(cfs_rq)->clock_task;
+		if (se->avg.decay_count) {
+			/*
+			 * In a wake-up migration we have to approximate the
+			 * time sleeping.  This is because we can't synchronize
+			 * clock_task between the two cpus, and it is not
+			 * guaranteed to be read-safe.  Instead, we can
+			 * approximate this using our carried decays, which are
+			 * explicitly atomically readable.
+			 */
+			se->avg.last_runnable_update -= (-se->avg.decay_count)
+							<< 20;
+			update_entity_load_avg(se, 0);
+			/* Indicate that we're now synchronized and on-rq */
+			se->avg.decay_count = 0;
+		}
+		wakeup = 0;
+	} else {
+		__synchronize_entity_decay(se);
+	}
+
+	/* migrated tasks did not contribute to our blocked load */
+	if (wakeup) {
+		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
+		update_entity_load_avg(se, 0);
+	}
+
+	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
+	/* we force update consideration on load-balancer moves */
+	update_cfs_rq_blocked_load(cfs_rq, !wakeup);
+}
+
+/*
+ * Remove se's load from this cfs_rq child load-average, if the entity is
+ * transitioning to a blocked state we track its projected decay using
+ * blocked_load_avg.
+ */
+static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
+						  struct sched_entity *se,
+						  int sleep)
+{
+	update_entity_load_avg(se, 1);
+	/* we force update consideration on load-balancer moves */
+	update_cfs_rq_blocked_load(cfs_rq, !sleep);
+
+	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
+	if (sleep) {
+		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
+		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
+	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
+}
+#else
+static inline void update_entity_load_avg(struct sched_entity *se,
+					  int update_cfs_rq) {}
+static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
+static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
+					   struct sched_entity *se,
+					   int wakeup) {}
+static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
+					   struct sched_entity *se,
+					   int sleep) {}
+static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
+					      int force_update) {}
+#endif
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
@@ -1096,9 +1475,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	update_cfs_load(cfs_rq, 0);
 	account_entity_enqueue(cfs_rq, se);
-	update_cfs_shares(cfs_rq);
+	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
 
 	if (flags & ENQUEUE_WAKEUP) {
 		place_entity(cfs_rq, se, 0);
@@ -1190,9 +1568,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
-	se->on_rq = 0;
-	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
+	dequeue_entity_load_avg(cfs_rq, se, flags & DEQUEUE_SLEEP);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
@@ -1206,7 +1583,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	return_cfs_rq_runtime(cfs_rq);
 
 	update_min_vruntime(cfs_rq);
-	update_cfs_shares(cfs_rq);
+	se->on_rq = 0;
 }
 
 /*
@@ -1340,6 +1717,8 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 		update_stats_wait_start(cfs_rq, prev);
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
+		/* in !on_rq case, update occurred at dequeue */
+		update_entity_load_avg(prev, 1);
 	}
 	cfs_rq->curr = NULL;
 }
@@ -1353,9 +1732,10 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	update_curr(cfs_rq);
 
 	/*
-	 * Update share accounting for long-running entities.
+	 * Ensure that runnable average is periodically updated.
 	 */
-	update_entity_shares_tick(cfs_rq);
+	update_entity_load_avg(curr, 1);
+	update_cfs_rq_blocked_load(cfs_rq, 1);
 
 #ifdef CONFIG_SCHED_HRTICK
 	/*
@@ -1448,6 +1828,15 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 	return &tg->cfs_bandwidth;
 }
 
+/* rq->task_clock normalized against any time this cfs_rq has spent throttled */
+static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
+{
+	if (unlikely(cfs_rq->throttle_count))
+		return cfs_rq->throttled_clock_task;
+
+	return rq_of(cfs_rq)->clock_task - cfs_rq->throttled_clock_task_time;
+}
+
 /* returns 0 on failure to allocate runtime */
 static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
@@ -1592,14 +1981,9 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
 	cfs_rq->throttle_count--;
 #ifdef CONFIG_SMP
 	if (!cfs_rq->throttle_count) {
-		u64 delta = rq->clock_task - cfs_rq->load_stamp;
-
-		/* leaving throttled state, advance shares averaging windows */
-		cfs_rq->load_stamp += delta;
-		cfs_rq->load_last += delta;
-
-		/* update entity weight now that we are on_rq again */
-		update_cfs_shares(cfs_rq);
+		/* adjust cfs_rq_clock_task() */
+		cfs_rq->throttled_clock_task_time += rq->clock_task -
+					     cfs_rq->throttled_clock_task;
 	}
 #endif
 
@@ -1611,9 +1995,9 @@ static int tg_throttle_down(struct task_group *tg, void *data)
 	struct rq *rq = data;
 	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu_of(rq)];
 
-	/* group is entering throttled state, record last load */
+	/* group is entering throttled state, stop time */
 	if (!cfs_rq->throttle_count)
-		update_cfs_load(cfs_rq, 0);
+		cfs_rq->throttled_clock_task = rq->clock_task;
 	cfs_rq->throttle_count++;
 
 	return 0;
@@ -1628,7 +2012,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
-	/* account load preceding throttle */
+	/* freeze hierarchy runnable averages while throttled */
 	rcu_read_lock();
 	walk_tg_tree_from(cfs_rq->tg, tg_throttle_down, tg_nop, (void *)rq);
 	rcu_read_unlock();
@@ -1652,7 +2036,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 		rq->nr_running -= task_delta;
 
 	cfs_rq->throttled = 1;
-	cfs_rq->throttled_timestamp = rq->clock;
+	cfs_rq->throttled_clock = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
 	raw_spin_unlock(&cfs_b->lock);
@@ -1670,10 +2054,9 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 
 	cfs_rq->throttled = 0;
 	raw_spin_lock(&cfs_b->lock);
-	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_timestamp;
+	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_clock;
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
-	cfs_rq->throttled_timestamp = 0;
 
 	update_rq_clock(rq);
 	/* update hierarchical throttle state */
@@ -2073,8 +2456,13 @@ static void unthrottle_offline_cfs_rqs(struct rq *rq)
 }
 
 #else /* CONFIG_CFS_BANDWIDTH */
-static __always_inline
-void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec) {}
+static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
+{
+	return rq_of(cfs_rq)->clock_task;
+}
+
+static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
+				     unsigned long delta_exec) {}
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
@@ -2207,12 +2595,14 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
-		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq);
+		update_entity_load_avg(se, 1);
+		update_cfs_rq_blocked_load(cfs_rq, 0);
 	}
 
-	if (!se)
+	if (!se) {
+		update_rq_runnable_avg(rq, rq->nr_running);
 		inc_nr_running(rq);
+	}
 	hrtick_update(rq);
 }
 
@@ -2266,12 +2656,14 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
-		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq);
+		update_entity_load_avg(se, 1);
+		update_cfs_rq_blocked_load(cfs_rq, 0);
 	}
 
-	if (!se)
+	if (!se) {
 		dec_nr_running(rq);
+		update_rq_runnable_avg(rq, 1);
+	}
 	hrtick_update(rq);
 }
 
@@ -2781,6 +3173,37 @@ unlock:
 
 	return new_cpu;
 }
+
+/*
+ * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
+ * removed when useful for applications beyond shares distribution (e.g.
+ * load-balance).
+ */
+#ifdef CONFIG_FAIR_GROUP_SCHED
+/*
+ * Called immediately before a task is migrated to a new cpu; task_cpu(p) and
+ * cfs_rq_of(p) references at time of call are still valid and identify the
+ * previous cpu.  However, the caller only guarantees p->pi_lock is held; no
+ * other assumptions, including the state of rq->lock, should be made.
+ */
+static void
+migrate_task_rq_fair(struct task_struct *p, int next_cpu)
+{
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+	/*
+	 * Load tracking: accumulate removed load so that it can be processed
+	 * when we next update owning cfs_rq under rq->lock.  Tasks contribute
+	 * to blocked load iff they have a positive decay-count.  It can never
+	 * be negative here since on-rq tasks have decay-count == 0.
+	 */
+	if (se->avg.decay_count) {
+		se->avg.decay_count = -__synchronize_entity_decay(se);
+		atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
+	}
+}
+#endif
 #endif /* CONFIG_SMP */
 
 static unsigned long
@@ -2907,7 +3330,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	 * Batch and idle tasks do not preempt non-idle tasks (their preemption
 	 * is driven by the tick):
 	 */
-	if (unlikely(p->policy != SCHED_NORMAL))
+	if (unlikely(p->policy != SCHED_NORMAL) || !sched_feat(WAKEUP_PREEMPTION))
 		return;
 
 	find_matching_se(&se, &pse);
@@ -3033,8 +3456,122 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
 
 #ifdef CONFIG_SMP
 /**************************************************
- * Fair scheduling class load-balancing methods:
- */
+ * Fair scheduling class load-balancing methods.
+ *
+ * BASICS
+ *
+ * The purpose of load-balancing is to achieve the same basic fairness the
+ * per-cpu scheduler provides, namely provide a proportional amount of compute
+ * time to each task. This is expressed in the following equation:
+ *
+ *   W_i,n/P_i == W_j,n/P_j for all i,j                               (1)
+ *
+ * Where W_i,n is the n-th weight average for cpu i. The instantaneous weight
+ * W_i,0 is defined as:
+ *
+ *   W_i,0 = \Sum_j w_i,j                                             (2)
+ *
+ * Where w_i,j is the weight of the j-th runnable task on cpu i. This weight
+ * is derived from the nice value as per prio_to_weight[].
+ *
+ * The weight average is an exponential decay average of the instantaneous
+ * weight:
+ *
+ *   W'_i,n = (2^n - 1) / 2^n * W_i,n + 1 / 2^n * W_i,0               (3)
+ *
+ * P_i is the cpu power (or compute capacity) of cpu i, typically it is the
+ * fraction of 'recent' time available for SCHED_OTHER task execution. But it
+ * can also include other factors [XXX].
+ *
+ * To achieve this balance we define a measure of imbalance which follows
+ * directly from (1):
+ *
+ *   imb_i,j = max{ avg(W/P), W_i/P_i } - min{ avg(W/P), W_j/P_j }    (4)
+ *
+ * We them move tasks around to minimize the imbalance. In the continuous
+ * function space it is obvious this converges, in the discrete case we get
+ * a few fun cases generally called infeasible weight scenarios.
+ *
+ * [XXX expand on:
+ *     - infeasible weights;
+ *     - local vs global optima in the discrete case. ]
+ *
+ *
+ * SCHED DOMAINS
+ *
+ * In order to solve the imbalance equation (4), and avoid the obvious O(n^2)
+ * for all i,j solution, we create a tree of cpus that follows the hardware
+ * topology where each level pairs two lower groups (or better). This results
+ * in O(log n) layers. Furthermore we reduce the number of cpus going up the
+ * tree to only the first of the previous level and we decrease the frequency
+ * of load-balance at each level inv. proportional to the number of cpus in
+ * the groups.
+ *
+ * This yields:
+ *
+ *     log_2 n     1     n
+ *   \Sum       { --- * --- * 2^i } = O(n)                            (5)
+ *     i = 0      2^i   2^i
+ *                               `- size of each group
+ *         |         |     `- number of cpus doing load-balance
+ *         |         `- freq
+ *         `- sum over all levels
+ *
+ * Coupled with a limit on how many tasks we can migrate every balance pass,
+ * this makes (5) the runtime complexity of the balancer.
+ *
+ * An important property here is that each CPU is still (indirectly) connected
+ * to every other cpu in at most O(log n) steps:
+ *
+ * The adjacency matrix of the resulting graph is given by:
+ *
+ *             log_2 n     
+ *   A_i,j = \Union     (i % 2^k == 0) && i / 2^(k+1) == j / 2^(k+1)  (6)
+ *             k = 0
+ *
+ * And you'll find that:
+ *
+ *   A^(log_2 n)_i,j != 0  for all i,j                                (7)
+ *
+ * Showing there's indeed a path between every cpu in at most O(log n) steps.
+ * The task movement gives a factor of O(m), giving a convergence complexity
+ * of:
+ *
+ *   O(nm log n),  n := nr_cpus, m := nr_tasks                        (8)
+ *
+ *
+ * WORK CONSERVING
+ *
+ * In order to avoid CPUs going idle while there's still work to do, new idle
+ * balancing is more aggressive and has the newly idle cpu iterate up the domain
+ * tree itself instead of relying on other CPUs to bring it work.
+ *
+ * This adds some complexity to both (5) and (8) but it reduces the total idle
+ * time.
+ *
+ * [XXX more?]
+ *
+ *
+ * CGROUPS
+ *
+ * Cgroups make a horror show out of (2), instead of a simple sum we get:
+ *
+ *                                s_k,i
+ *   W_i,0 = \Sum_j \Prod_k w_k * -----                               (9)
+ *                                 S_k
+ *
+ * Where
+ *
+ *   s_k,i = \Sum_j w_i,j,k  and  S_k = \Sum_i s_k,i                 (10)
+ *
+ * w_i,j,k is the weight of the j-th runnable task in the k-th cgroup on cpu i.
+ *
+ * The big problem is S_k, its a global sum needed to compute a local (W_i)
+ * property.
+ *
+ * [XXX write more on how we solve this.. _after_ merging pjt's patches that
+ *      rewrite all of this once again.]
+ */ 
 
 static unsigned long __read_mostly max_load_balance_interval = HZ/10;
 
@@ -3300,52 +3837,58 @@ next:
 /*
  * update tg->load_weight by folding this cpu's load_avg
  */
-static int update_shares_cpu(struct task_group *tg, int cpu)
+static void __update_blocked_averages_cpu(struct task_group *tg, int cpu)
 {
-	struct cfs_rq *cfs_rq;
-	unsigned long flags;
-	struct rq *rq;
-
-	if (!tg->se[cpu])
-		return 0;
-
-	rq = cpu_rq(cpu);
-	cfs_rq = tg->cfs_rq[cpu];
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
+	struct sched_entity *se = tg->se[cpu];
+	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu];
 
-	update_rq_clock(rq);
-	update_cfs_load(cfs_rq, 1);
+	/* throttled entities do not contribute to load */
+	if (throttled_hierarchy(cfs_rq))
+		return;
 
-	/*
-	 * We need to update shares after updating tg->load_weight in
-	 * order to adjust the weight of groups with long running tasks.
-	 */
-	update_cfs_shares(cfs_rq);
+	update_cfs_rq_blocked_load(cfs_rq, 1);
 
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-
-	return 0;
+	if (se) {
+		update_entity_load_avg(se, 1);
+		/*
+		 * We pivot on our runnable average having decayed to zero for
+		 * list removal.  This generally implies that all our children
+		 * have also been removed (modulo rounding error or bandwidth
+		 * control); however, such cases are rare and we can fix these
+		 * at enqueue.
+		 *
+		 * TODO: fix up out-of-order children on enqueue.
+		 */
+		if (!se->avg.runnable_avg_sum && !cfs_rq->nr_running)
+			list_del_leaf_cfs_rq(cfs_rq);
+	} else {
+		struct rq *rq = rq_of(cfs_rq);
+		update_rq_runnable_avg(rq, rq->nr_running);
+	}
 }
 
-static void update_shares(int cpu)
+static void update_blocked_averages(int cpu)
 {
-	struct cfs_rq *cfs_rq;
 	struct rq *rq = cpu_rq(cpu);
+	struct cfs_rq *cfs_rq;
+	unsigned long flags;
 
-	rcu_read_lock();
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	update_rq_clock(rq);
 	/*
 	 * Iterates the task_group tree in a bottom up fashion, see
 	 * list_add_leaf_cfs_rq() for details.
 	 */
 	for_each_leaf_cfs_rq(rq, cfs_rq) {
-		/* throttled entities do not contribute to load */
-		if (throttled_hierarchy(cfs_rq))
-			continue;
-
-		update_shares_cpu(cfs_rq->tg, cpu);
+		/*
+		 * Note: We may want to consider periodically releasing
+		 * rq->lock about these updates so that creating many task
+		 * groups does not result in continually extending hold time.
+		 */
+		__update_blocked_averages_cpu(cfs_rq->tg, rq->cpu);
 	}
-	rcu_read_unlock();
+
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 /*
@@ -3397,7 +3940,7 @@ static unsigned long task_h_load(struct task_struct *p)
 	return load;
 }
 #else
-static inline void update_shares(int cpu)
+static inline void update_blocked_averages(int cpu)
 {
 }
 
@@ -4457,12 +5000,14 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
 
+	update_rq_runnable_avg(this_rq, 1);
+
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
 	 */
 	raw_spin_unlock(&this_rq->lock);
 
-	update_shares(this_cpu);
+	update_blocked_averages(this_cpu);
 	rcu_read_lock();
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
@@ -4717,7 +5262,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	int update_next_balance = 0;
 	int need_serialize;
 
-	update_shares(cpu);
+	update_blocked_averages(cpu);
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
@@ -4954,6 +5499,8 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 		cfs_rq = cfs_rq_of(se);
 		entity_tick(cfs_rq, se, queued);
 	}
+
+	update_rq_runnable_avg(rq, 1);
 }
 
 /*
@@ -5046,6 +5593,20 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 		place_entity(cfs_rq, se, 0);
 		se->vruntime -= cfs_rq->min_vruntime;
 	}
+
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+	/*
+	* Remove our load from contribution when we leave sched_fair
+	* and ensure we don't carry in an old decay_count if we
+	* switch back.
+	*/
+	if (p->se.avg.decay_count) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(&p->se);
+		__synchronize_entity_decay(&p->se);
+		subtract_blocked_load_contrib(cfs_rq,
+				p->se.avg.load_avg_contrib);
+	}
+#endif
 }
 
 /*
@@ -5092,11 +5653,16 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifndef CONFIG_64BIT
 	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
 #endif
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+	atomic64_set(&cfs_rq->decay_counter, 1);
+	atomic64_set(&cfs_rq->removed_load, 0);
+#endif
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void task_move_group_fair(struct task_struct *p, int on_rq)
 {
+	struct cfs_rq *cfs_rq;
 	/*
 	 * If the task was not on the rq at the time of this cgroup movement
 	 * it must have been asleep, sleeping tasks keep their ->vruntime
@@ -5128,8 +5694,19 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	if (!on_rq)
 		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
 	set_task_rq(p, task_cpu(p));
-	if (!on_rq)
-		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
+	if (!on_rq) {
+		cfs_rq = cfs_rq_of(&p->se);
+		p->se.vruntime += cfs_rq->min_vruntime;
+#ifdef CONFIG_SMP
+		/*
+		 * migrate_task_rq_fair() will have removed our previous
+		 * contribution, but we must synchronize for ongoing future
+		 * decay.
+		 */
+		p->se.avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
+		cfs_rq->blocked_load_avg += p->se.avg.load_avg_contrib;
+#endif
+	}
 }
 
 void free_fair_sched_group(struct task_group *tg)
@@ -5214,10 +5791,6 @@ void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 
 	cfs_rq->tg = tg;
 	cfs_rq->rq = rq;
-#ifdef CONFIG_SMP
-	/* allow initial update_cfs_load() to truncate */
-	cfs_rq->load_stamp = 1;
-#endif
 	init_cfs_rq_runtime(cfs_rq);
 
 	tg->cfs_rq[cpu] = cfs_rq;
@@ -5264,8 +5837,11 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 		se = tg->se[i];
 		/* Propagate contribution to hierarchy */
 		raw_spin_lock_irqsave(&rq->lock, flags);
-		for_each_sched_entity(se)
+		for_each_sched_entity(se) {
 			update_cfs_shares(group_cfs_rq(se));
+			/* update contribution to parent */
+			update_entity_load_avg(se, 1);
+		}
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
 
@@ -5319,7 +5895,9 @@ const struct sched_class fair_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_fair,
-
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	.migrate_task_rq	= migrate_task_rq_fair,
+#endif
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
 
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index eebefca..e68e69a 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -32,6 +32,11 @@ SCHED_FEAT(LAST_BUDDY, true)
 SCHED_FEAT(CACHE_HOT_BUDDY, true)
 
 /*
+ * Allow wakeup-time preemption of the current task:
+ */
+SCHED_FEAT(WAKEUP_PREEMPTION, true)
+
+/*
  * Use arch dependent cpu power functions
  */
 SCHED_FEAT(ARCH_POWER, true)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7a7db09..5eca173 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -112,6 +112,8 @@ struct task_group {
 	unsigned long shares;
 
 	atomic_t load_weight;
+	atomic64_t load_avg;
+	atomic_t runnable_avg;
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -222,22 +224,29 @@ struct cfs_rq {
 	unsigned int nr_spread_over;
 #endif
 
+#ifdef CONFIG_SMP
+/*
+ * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
+ * removed when useful for applications beyond shares distribution (e.g.
+ * load-balance).
+ */
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
-
 	/*
-	 * leaf cfs_rqs are those that hold tasks (lowest schedulable entity in
-	 * a hierarchy). Non-leaf lrqs hold other higher schedulable entities
-	 * (like users, containers etc.)
-	 *
-	 * leaf_cfs_rq_list ties together list of leaf cfs_rq's in a cpu. This
-	 * list is used during load balance.
+	 * CFS Load tracking
+	 * Under CFS, load is tracked on a per-entity basis and aggregated up.
+	 * This allows for the description of both thread and group usage (in
+	 * the FAIR_GROUP_SCHED case).
 	 */
-	int on_list;
-	struct list_head leaf_cfs_rq_list;
-	struct task_group *tg;	/* group that "owns" this runqueue */
+	u64 runnable_load_avg, blocked_load_avg;
+	atomic64_t decay_counter, removed_load;
+	u64 last_decay;
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+/* These always depend on CONFIG_FAIR_GROUP_SCHED */
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	u32 tg_runnable_contrib;
+	u64 tg_load_contrib;
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 
-#ifdef CONFIG_SMP
 	/*
 	 *   h_load = weight * f(tg)
 	 *
@@ -245,26 +254,30 @@ struct cfs_rq {
 	 * this group.
 	 */
 	unsigned long h_load;
+#endif /* CONFIG_SMP */
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
 
 	/*
-	 * Maintaining per-cpu shares distribution for group scheduling
+	 * leaf cfs_rqs are those that hold tasks (lowest schedulable entity in
+	 * a hierarchy). Non-leaf lrqs hold other higher schedulable entities
+	 * (like users, containers etc.)
 	 *
-	 * load_stamp is the last time we updated the load average
-	 * load_last is the last time we updated the load average and saw load
-	 * load_unacc_exec_time is currently unaccounted execution time
+	 * leaf_cfs_rq_list ties together list of leaf cfs_rq's in a cpu. This
+	 * list is used during load balance.
 	 */
-	u64 load_avg;
-	u64 load_period;
-	u64 load_stamp, load_last, load_unacc_exec_time;
+	int on_list;
+	struct list_head leaf_cfs_rq_list;
+	struct task_group *tg;	/* group that "owns" this runqueue */
 
-	unsigned long load_contribution;
-#endif /* CONFIG_SMP */
 #ifdef CONFIG_CFS_BANDWIDTH
 	int runtime_enabled;
 	u64 runtime_expires;
 	s64 runtime_remaining;
 
-	u64 throttled_timestamp;
+	u64 throttled_clock, throttled_clock_task;
+	u64 throttled_clock_task_time;
 	int throttled, throttle_count;
 	struct list_head throttled_list;
 #endif /* CONFIG_CFS_BANDWIDTH */
@@ -467,6 +480,8 @@ struct rq {
 #ifdef CONFIG_SMP
 	struct llist_head wake_list;
 #endif
+
+	struct sched_avg avg;
 };
 
 static inline int cpu_of(struct rq *rq)
@@ -1212,4 +1227,3 @@ static inline u64 irq_time_read(int cpu)
 }
 #endif /* CONFIG_64BIT */
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
-
diff --git a/kernel/softirq.c b/kernel/softirq.c
index cc96bdc..ed567ba 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -221,7 +221,7 @@ asmlinkage void __do_softirq(void)
 	current->flags &= ~PF_MEMALLOC;
 
 	pending = local_softirq_pending();
-	vtime_account(current);
+	vtime_account_irq_enter(current);
 
 	__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
@@ -272,7 +272,7 @@ restart:
 
 	lockdep_softirq_exit();
 
-	vtime_account(current);
+	vtime_account_irq_exit(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
@@ -341,7 +341,7 @@ static inline void invoke_softirq(void)
  */
 void irq_exit(void)
 {
-	vtime_account(current);
+	vtime_account_irq_exit(current);
 	trace_hardirq_exit();
 	sub_preempt_count(IRQ_EXIT_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
diff --git a/kernel/sys.c b/kernel/sys.c
index e6e0ece..265b376 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1046,7 +1046,7 @@ void do_sys_times(struct tms *tms)
 	cputime_t tgutime, tgstime, cutime, cstime;
 
 	spin_lock_irq(&current->sighand->siglock);
-	thread_group_times(current, &tgutime, &tgstime);
+	thread_group_cputime_adjusted(current, &tgutime, &tgstime);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
 	spin_unlock_irq(&current->sighand->siglock);
@@ -1704,7 +1704,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 	utime = stime = 0;
 
 	if (who == RUSAGE_THREAD) {
-		task_times(current, &utime, &stime);
+		task_cputime_adjusted(current, &utime, &stime);
 		accumulate_thread_rusage(p, r);
 		maxrss = p->signal->maxrss;
 		goto out;
@@ -1730,7 +1730,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 				break;
 
 		case RUSAGE_SELF:
-			thread_group_times(p, &tgutime, &tgstime);
+			thread_group_cputime_adjusted(p, &tgutime, &tgstime);
 			utime += tgutime;
 			stime += tgstime;
 			r->ru_nvcsw += p->signal->nvcsw;
