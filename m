Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab2JANOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:14:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59072 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2JANOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:14:11 -0400
Date: Mon, 1 Oct 2012 15:14:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v3.7
Message-ID: <20121001131405.GA22480@gmail.com>
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

   HEAD: fdf9c356502ae02238efcdf90cefd7b473a63fd4 cputime: Make finegrained irqtime accounting generally available

Continued quest to clean up and enhance the cputime code by 
Frederic Weisbecker, in preparation for future tickless kernel 
features. Other than that, smallish changes.

 Thanks,

	Ingo

------------------>
Alex Shi (3):
      sched: recover SD_WAKE_AFFINE in select_task_rq_fair and code clean up
      tile: Remove SD_PREFER_LOCAL leftover
      sched/nohz: Clean up select_nohz_load_balancer()

Borislav Petkov (1):
      sched: Fix __sched_period comment

Frederic Weisbecker (10):
      cputime: Generalize CONFIG_VIRT_CPU_ACCOUNTING
      sched: Move cputime code to its own file
      cputime: Consolidate vtime handling on context switch
      s390: Remove leftover account_tick_vtime() header
      cputime: Use a proper subsystem naming for vtime related APIs
      vtime: Consolidate system/idle context detection
      ia64: Consolidate user vtime accounting
      ia64: Reuse system and user vtime accounting functions on task switch
      cputime: Gather time/stats accounting config options into a single menu
      cputime: Make finegrained irqtime accounting generally available

Michael Wang (2):
      sched: using dst_rq instead of this_rq during load balance
      sched: Remove useless code in yield_to()

Namhyung Kim (3):
      sched: Remove AFFINE_WAKEUPS feature flag
      sched/debug: Limit sd->*_idx range on sysctl
      sched: Add time unit suffix to sched sysctl knobs

Pekka Enberg (1):
      sched: Document schedule() entry points

Peter Zijlstra (2):
      sched: Remove __ARCH_WANT_INTERRUPTS_ON_CTXSW
      sched: Fix load avg vs. cpu-hotplug

Vincent Guittot (2):
      sched: Fix nohz_idle_balance()
      sched: cpu_power: enable ARCH_POWER


 Documentation/scheduler/sched-arch.txt |  10 -
 arch/Kconfig                           |   9 +
 arch/ia64/Kconfig                      |  12 +-
 arch/ia64/include/asm/switch_to.h      |   8 -
 arch/ia64/kernel/time.c                |  66 ++--
 arch/powerpc/include/asm/time.h        |   6 -
 arch/powerpc/kernel/process.c          |   3 -
 arch/powerpc/kernel/time.c             |  55 ++-
 arch/powerpc/platforms/Kconfig.cputype |  16 +-
 arch/s390/Kconfig                      |   5 +-
 arch/s390/include/asm/cputime.h        |   3 +
 arch/s390/include/asm/switch_to.h      |   4 -
 arch/s390/kernel/vtime.c               |   8 +-
 arch/tile/include/asm/topology.h       |   1 -
 arch/x86/Kconfig                       |  12 +-
 include/linux/hardirq.h                |   8 +-
 include/linux/kernel_stat.h            |   8 +
 include/linux/kvm_host.h               |   4 +-
 include/linux/sched.h                  |  10 +-
 include/linux/topology.h               |   2 -
 init/Kconfig                           | 157 +++++---
 kernel/fork.c                          |   4 -
 kernel/sched/Makefile                  |   2 +-
 kernel/sched/core.c                    | 677 +++------------------------------
 kernel/sched/cputime.c                 | 530 ++++++++++++++++++++++++++
 kernel/sched/fair.c                    |  81 ++--
 kernel/sched/features.h                |  10 +-
 kernel/sched/rt.c                      |   5 -
 kernel/sched/sched.h                   |  69 +++-
 kernel/softirq.c                       |   6 +-
 kernel/sysctl.c                        |   6 +-
 kernel/time/tick-sched.c               |   3 +-
 32 files changed, 894 insertions(+), 906 deletions(-)
 create mode 100644 kernel/sched/cputime.c

diff --git a/Documentation/scheduler/sched-arch.txt b/Documentation/scheduler/sched-arch.txt
index 28aa107..b1b8587 100644
--- a/Documentation/scheduler/sched-arch.txt
+++ b/Documentation/scheduler/sched-arch.txt
@@ -17,16 +17,6 @@ you must `#define __ARCH_WANT_UNLOCKED_CTXSW` in a header file
 Unlocked context switches introduce only a very minor performance
 penalty to the core scheduler implementation in the CONFIG_SMP case.
 
-2. Interrupt status
-By default, the switch_to arch function is called with interrupts
-disabled. Interrupts may be enabled over the call if it is likely to
-introduce a significant interrupt latency by adding the line
-`#define __ARCH_WANT_INTERRUPTS_ON_CTXSW` in the same place as for
-unlocked context switches. This define also implies
-`__ARCH_WANT_UNLOCKED_CTXSW`. See arch/arm/include/asm/system.h for an
-example.
-
-
 CPU idle
 ========
 Your cpu_idle routines need to obey the following rules:
diff --git a/arch/Kconfig b/arch/Kconfig
index 72f2fa1..101c31a 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -281,4 +281,13 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+config HAVE_VIRT_CPU_ACCOUNTING
+	bool
+
+config HAVE_IRQ_TIME_ACCOUNTING
+	bool
+	help
+	  Archs need to ensure they use a high enough resolution clock to
+	  support irq time accounting and then call enable_sched_clock_irqtime().
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 310cf57..3c720ef 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -25,6 +25,7 @@ config IA64
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
+	select HAVE_VIRT_CPU_ACCOUNTING
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
@@ -340,17 +341,6 @@ config FORCE_MAX_ZONEORDER
 	default "17" if HUGETLB_PAGE
 	default "11"
 
-config VIRT_CPU_ACCOUNTING
-	bool "Deterministic task and CPU time accounting"
-	default n
-	help
-	  Select this option to enable more accurate task and CPU time
-	  accounting.  This is done by reading a CPU counter on each
-	  kernel entry and exit and on transitions within the kernel
-	  between system, softirq and hardirq state, so there is a
-	  small performance impact.
-	  If in doubt, say N here.
-
 config SMP
 	bool "Symmetric multi-processing support"
 	select USE_GENERIC_SMP_HELPERS
diff --git a/arch/ia64/include/asm/switch_to.h b/arch/ia64/include/asm/switch_to.h
index cb2412f..d38c7ea 100644
--- a/arch/ia64/include/asm/switch_to.h
+++ b/arch/ia64/include/asm/switch_to.h
@@ -30,13 +30,6 @@ extern struct task_struct *ia64_switch_to (void *next_task);
 extern void ia64_save_extra (struct task_struct *task);
 extern void ia64_load_extra (struct task_struct *task);
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void ia64_account_on_switch (struct task_struct *prev, struct task_struct *next);
-# define IA64_ACCOUNT_ON_SWITCH(p,n) ia64_account_on_switch(p,n)
-#else
-# define IA64_ACCOUNT_ON_SWITCH(p,n)
-#endif
-
 #ifdef CONFIG_PERFMON
   DECLARE_PER_CPU(unsigned long, pfm_syst_info);
 # define PERFMON_IS_SYSWIDE() (__get_cpu_var(pfm_syst_info) & 0x1)
@@ -49,7 +42,6 @@ extern void ia64_account_on_switch (struct task_struct *prev, struct task_struct
 	 || PERFMON_IS_SYSWIDE())
 
 #define __switch_to(prev,next,last) do {							 \
-	IA64_ACCOUNT_ON_SWITCH(prev, next);							 \
 	if (IA64_HAS_EXTRA_STATE(prev))								 \
 		ia64_save_extra(prev);								 \
 	if (IA64_HAS_EXTRA_STATE(next))								 \
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index ecc904b..80ff9ac 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -83,32 +83,36 @@ static struct clocksource *itc_clocksource;
 
 extern cputime_t cycle_to_cputime(u64 cyc);
 
+static void vtime_account_user(struct task_struct *tsk)
+{
+	cputime_t delta_utime;
+	struct thread_info *ti = task_thread_info(tsk);
+
+	if (ti->ac_utime) {
+		delta_utime = cycle_to_cputime(ti->ac_utime);
+		account_user_time(tsk, delta_utime, delta_utime);
+		ti->ac_utime = 0;
+	}
+}
+
 /*
  * Called from the context switch with interrupts disabled, to charge all
  * accumulated times to the current process, and to prepare accounting on
  * the next process.
  */
-void ia64_account_on_switch(struct task_struct *prev, struct task_struct *next)
+void vtime_task_switch(struct task_struct *prev)
 {
 	struct thread_info *pi = task_thread_info(prev);
-	struct thread_info *ni = task_thread_info(next);
-	cputime_t delta_stime, delta_utime;
-	__u64 now;
+	struct thread_info *ni = task_thread_info(current);
 
-	now = ia64_get_itc();
-
-	delta_stime = cycle_to_cputime(pi->ac_stime + (now - pi->ac_stamp));
 	if (idle_task(smp_processor_id()) != prev)
-		account_system_time(prev, 0, delta_stime, delta_stime);
+		vtime_account_system(prev);
 	else
-		account_idle_time(delta_stime);
+		vtime_account_idle(prev);
 
-	if (pi->ac_utime) {
-		delta_utime = cycle_to_cputime(pi->ac_utime);
-		account_user_time(prev, delta_utime, delta_utime);
-	}
+	vtime_account_user(prev);
 
-	pi->ac_stamp = ni->ac_stamp = now;
+	pi->ac_stamp = ni->ac_stamp;
 	ni->ac_stime = ni->ac_utime = 0;
 }
 
@@ -116,29 +120,32 @@ void ia64_account_on_switch(struct task_struct *prev, struct task_struct *next)
  * Account time for a transition between system, hard irq or soft irq state.
  * Note that this function is called with interrupts enabled.
  */
-void account_system_vtime(struct task_struct *tsk)
+static cputime_t vtime_delta(struct task_struct *tsk)
 {
 	struct thread_info *ti = task_thread_info(tsk);
-	unsigned long flags;
 	cputime_t delta_stime;
 	__u64 now;
 
-	local_irq_save(flags);
-
 	now = ia64_get_itc();
 
 	delta_stime = cycle_to_cputime(ti->ac_stime + (now - ti->ac_stamp));
-	if (irq_count() || idle_task(smp_processor_id()) != tsk)
-		account_system_time(tsk, 0, delta_stime, delta_stime);
-	else
-		account_idle_time(delta_stime);
 	ti->ac_stime = 0;
-
 	ti->ac_stamp = now;
 
-	local_irq_restore(flags);
+	return delta_stime;
+}
+
+void vtime_account_system(struct task_struct *tsk)
+{
+	cputime_t delta = vtime_delta(tsk);
+
+	account_system_time(tsk, 0, delta, delta);
+}
+
+void vtime_account_idle(struct task_struct *tsk)
+{
+	account_idle_time(vtime_delta(tsk));
 }
-EXPORT_SYMBOL_GPL(account_system_vtime);
 
 /*
  * Called from the timer interrupt handler to charge accumulated user time
@@ -146,14 +153,7 @@ EXPORT_SYMBOL_GPL(account_system_vtime);
  */
 void account_process_tick(struct task_struct *p, int user_tick)
 {
-	struct thread_info *ti = task_thread_info(p);
-	cputime_t delta_utime;
-
-	if (ti->ac_utime) {
-		delta_utime = cycle_to_cputime(ti->ac_utime);
-		account_user_time(p, delta_utime, delta_utime);
-		ti->ac_utime = 0;
-	}
+	vtime_account_user(p);
 }
 
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 3b4b4a8..c1f2676 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -197,12 +197,6 @@ struct cpu_usage {
 
 DECLARE_PER_CPU(struct cpu_usage, cpu_usage_array);
 
-#if defined(CONFIG_VIRT_CPU_ACCOUNTING)
-#define account_process_vtime(tsk)		account_process_tick(tsk, 0)
-#else
-#define account_process_vtime(tsk)		do { } while (0)
-#endif
-
 extern void secondary_cpu_time_init(void);
 
 DECLARE_PER_CPU(u64, decrementers_next_tb);
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 710f400..d73fa99 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -514,9 +514,6 @@ struct task_struct *__switch_to(struct task_struct *prev,
 
 	local_irq_save(flags);
 
-	account_system_vtime(current);
-	account_process_vtime(current);
-
 	/*
 	 * We can't take a PMU exception inside _switch() since there is a
 	 * window where the kernel stack SLB and the kernel stack are out
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index be171ee..29b6d3e 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -291,13 +291,12 @@ static inline u64 calculate_stolen_time(u64 stop_tb)
  * Account time for a transition between system, hard irq
  * or soft irq state.
  */
-void account_system_vtime(struct task_struct *tsk)
+static u64 vtime_delta(struct task_struct *tsk,
+			u64 *sys_scaled, u64 *stolen)
 {
-	u64 now, nowscaled, delta, deltascaled;
-	unsigned long flags;
-	u64 stolen, udelta, sys_scaled, user_scaled;
+	u64 now, nowscaled, deltascaled;
+	u64 udelta, delta, user_scaled;
 
-	local_irq_save(flags);
 	now = mftb();
 	nowscaled = read_spurr(now);
 	get_paca()->system_time += now - get_paca()->starttime;
@@ -305,7 +304,7 @@ void account_system_vtime(struct task_struct *tsk)
 	deltascaled = nowscaled - get_paca()->startspurr;
 	get_paca()->startspurr = nowscaled;
 
-	stolen = calculate_stolen_time(now);
+	*stolen = calculate_stolen_time(now);
 
 	delta = get_paca()->system_time;
 	get_paca()->system_time = 0;
@@ -322,35 +321,45 @@ void account_system_vtime(struct task_struct *tsk)
 	 * the user ticks get saved up in paca->user_time_scaled to be
 	 * used by account_process_tick.
 	 */
-	sys_scaled = delta;
+	*sys_scaled = delta;
 	user_scaled = udelta;
 	if (deltascaled != delta + udelta) {
 		if (udelta) {
-			sys_scaled = deltascaled * delta / (delta + udelta);
-			user_scaled = deltascaled - sys_scaled;
+			*sys_scaled = deltascaled * delta / (delta + udelta);
+			user_scaled = deltascaled - *sys_scaled;
 		} else {
-			sys_scaled = deltascaled;
+			*sys_scaled = deltascaled;
 		}
 	}
 	get_paca()->user_time_scaled += user_scaled;
 
-	if (in_interrupt() || idle_task(smp_processor_id()) != tsk) {
-		account_system_time(tsk, 0, delta, sys_scaled);
-		if (stolen)
-			account_steal_time(stolen);
-	} else {
-		account_idle_time(delta + stolen);
-	}
-	local_irq_restore(flags);
+	return delta;
+}
+
+void vtime_account_system(struct task_struct *tsk)
+{
+	u64 delta, sys_scaled, stolen;
+
+	delta = vtime_delta(tsk, &sys_scaled, &stolen);
+	account_system_time(tsk, 0, delta, sys_scaled);
+	if (stolen)
+		account_steal_time(stolen);
+}
+
+void vtime_account_idle(struct task_struct *tsk)
+{
+	u64 delta, sys_scaled, stolen;
+
+	delta = vtime_delta(tsk, &sys_scaled, &stolen);
+	account_idle_time(delta + stolen);
 }
-EXPORT_SYMBOL_GPL(account_system_vtime);
 
 /*
  * Transfer the user and system times accumulated in the paca
  * by the exception entry and exit code to the generic process
  * user and system time records.
  * Must be called with interrupts disabled.
- * Assumes that account_system_vtime() has been called recently
+ * Assumes that vtime_account() has been called recently
  * (i.e. since the last entry from usermode) so that
  * get_paca()->user_time_scaled is up to date.
  */
@@ -366,6 +375,12 @@ void account_process_tick(struct task_struct *tsk, int user_tick)
 	account_user_time(tsk, utime, utimescaled);
 }
 
+void vtime_task_switch(struct task_struct *prev)
+{
+	vtime_account(prev);
+	account_process_tick(prev, 0);
+}
+
 #else /* ! CONFIG_VIRT_CPU_ACCOUNTING */
 #define calc_cputime_factors()
 #endif
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 30fd01d..72afd28 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -1,6 +1,7 @@
 config PPC64
 	bool "64-bit kernel"
 	default n
+	select HAVE_VIRT_CPU_ACCOUNTING
 	help
 	  This option selects whether a 32-bit or a 64-bit kernel
 	  will be built.
@@ -337,21 +338,6 @@ config PPC_MM_SLICES
 	default y if (!PPC_FSL_BOOK3E && PPC64 && HUGETLB_PAGE) || (PPC_STD_MMU_64 && PPC_64K_PAGES)
 	default n
 
-config VIRT_CPU_ACCOUNTING
-	bool "Deterministic task and CPU time accounting"
-	depends on PPC64
-	default y
-	help
-	  Select this option to enable more accurate task and CPU time
-	  accounting.  This is done by reading a CPU counter on each
-	  kernel entry and exit and on transitions within the kernel
-	  between system, softirq and hardirq state, so there is a
-	  small performance impact.  This also enables accounting of
-	  stolen time on logically-partitioned systems running on
-	  IBM POWER5-based machines.
-
-	  If in doubt, say Y here.
-
 config PPC_HAVE_PMU_SUPPORT
        bool
 
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 107610e..f5ab5433 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -49,9 +49,6 @@ config GENERIC_LOCKBREAK
 config PGSTE
 	def_bool y if KVM
 
-config VIRT_CPU_ACCOUNTING
-	def_bool y
-
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y
 
@@ -89,6 +86,8 @@ config S390
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_CMPXCHG_LOCAL
+	select HAVE_VIRT_CPU_ACCOUNTING
+	select VIRT_CPU_ACCOUNTING
 	select ARCH_DISCARD_MEMBLOCK
 	select BUILDTIME_EXTABLE_SORT
 	select ARCH_INLINE_SPIN_TRYLOCK
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index 8709bde..023d5ae 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -12,6 +12,9 @@
 #include <linux/spinlock.h>
 #include <asm/div64.h>
 
+
+#define __ARCH_HAS_VTIME_ACCOUNT
+
 /* We want to use full resolution of the CPU timer: 2**-12 micro-seconds. */
 
 typedef unsigned long long __nocast cputime_t;
diff --git a/arch/s390/include/asm/switch_to.h b/arch/s390/include/asm/switch_to.h
index f223068..314cc94 100644
--- a/arch/s390/include/asm/switch_to.h
+++ b/arch/s390/include/asm/switch_to.h
@@ -89,12 +89,8 @@ static inline void restore_access_regs(unsigned int *acrs)
 	prev = __switch_to(prev,next);					\
 } while (0)
 
-extern void account_vtime(struct task_struct *, struct task_struct *);
-extern void account_tick_vtime(struct task_struct *);
-
 #define finish_arch_switch(prev) do {					     \
 	set_fs(current->thread.mm_segment);				     \
-	account_vtime(prev, current);					     \
 } while (0)
 
 #endif /* __ASM_SWITCH_TO_H */
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 4fc97b4..cb5093c 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -99,7 +99,7 @@ static int do_account_vtime(struct task_struct *tsk, int hardirq_offset)
 	return virt_timer_forward(user + system);
 }
 
-void account_vtime(struct task_struct *prev, struct task_struct *next)
+void vtime_task_switch(struct task_struct *prev)
 {
 	struct thread_info *ti;
 
@@ -107,7 +107,7 @@ void account_vtime(struct task_struct *prev, struct task_struct *next)
 	ti = task_thread_info(prev);
 	ti->user_timer = S390_lowcore.user_timer;
 	ti->system_timer = S390_lowcore.system_timer;
-	ti = task_thread_info(next);
+	ti = task_thread_info(current);
 	S390_lowcore.user_timer = ti->user_timer;
 	S390_lowcore.system_timer = ti->system_timer;
 }
@@ -122,7 +122,7 @@ void account_process_tick(struct task_struct *tsk, int user_tick)
  * Update process times based on virtual cpu times stored by entry.S
  * to the lowcore fields user_timer, system_timer & steal_clock.
  */
-void account_system_vtime(struct task_struct *tsk)
+void vtime_account(struct task_struct *tsk)
 {
 	struct thread_info *ti = task_thread_info(tsk);
 	u64 timer, system;
@@ -138,7 +138,7 @@ void account_system_vtime(struct task_struct *tsk)
 
 	virt_timer_forward(system);
 }
-EXPORT_SYMBOL_GPL(account_system_vtime);
+EXPORT_SYMBOL_GPL(vtime_account);
 
 void __kprobes vtime_stop_cpu(void)
 {
diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
index 7a7ce39..d5e86c9 100644
--- a/arch/tile/include/asm/topology.h
+++ b/arch/tile/include/asm/topology.h
@@ -69,7 +69,6 @@ static inline const struct cpumask *cpumask_of_node(int node)
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 0*SD_WAKE_AFFINE			\
-				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..b86833a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -97,6 +97,7 @@ config X86
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select HAVE_IRQ_TIME_ACCOUNTING
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS || UPROBES)
@@ -796,17 +797,6 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
-config IRQ_TIME_ACCOUNTING
-	bool "Fine granularity task level IRQ time accounting"
-	default n
-	---help---
-	  Select this option to enable fine granularity task irq time
-	  accounting. This is done by reading a timestamp on each
-	  transitions between softirq and hardirq state, so there can be a
-	  small performance impact.
-
-	  If in doubt, say N here.
-
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 305f23c..cab3da3 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -132,11 +132,11 @@ extern void synchronize_irq(unsigned int irq);
 struct task_struct;
 
 #if !defined(CONFIG_VIRT_CPU_ACCOUNTING) && !defined(CONFIG_IRQ_TIME_ACCOUNTING)
-static inline void account_system_vtime(struct task_struct *tsk)
+static inline void vtime_account(struct task_struct *tsk)
 {
 }
 #else
-extern void account_system_vtime(struct task_struct *tsk);
+extern void vtime_account(struct task_struct *tsk);
 #endif
 
 #if defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
@@ -162,7 +162,7 @@ extern void rcu_nmi_exit(void);
  */
 #define __irq_enter()					\
 	do {						\
-		account_system_vtime(current);		\
+		vtime_account(current);		\
 		add_preempt_count(HARDIRQ_OFFSET);	\
 		trace_hardirq_enter();			\
 	} while (0)
@@ -178,7 +178,7 @@ extern void irq_enter(void);
 #define __irq_exit()					\
 	do {						\
 		trace_hardirq_exit();			\
-		account_system_vtime(current);		\
+		vtime_account(current);		\
 		sub_preempt_count(HARDIRQ_OFFSET);	\
 	} while (0)
 
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 2fbd905..36d12f0 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -130,4 +130,12 @@ extern void account_process_tick(struct task_struct *, int user);
 extern void account_steal_ticks(unsigned long ticks);
 extern void account_idle_ticks(unsigned long ticks);
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+extern void vtime_task_switch(struct task_struct *prev);
+extern void vtime_account_system(struct task_struct *tsk);
+extern void vtime_account_idle(struct task_struct *tsk);
+#else
+static inline void vtime_task_switch(struct task_struct *prev) { }
+#endif
+
 #endif /* _LINUX_KERNEL_STAT_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b70b48b..8a59e0a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -685,7 +685,7 @@ static inline int kvm_deassign_device(struct kvm *kvm,
 static inline void kvm_guest_enter(void)
 {
 	BUG_ON(preemptible());
-	account_system_vtime(current);
+	vtime_account(current);
 	current->flags |= PF_VCPU;
 	/* KVM does not hold any references to rcu protected data when it
 	 * switches CPU into a guest mode. In fact switching to a guest mode
@@ -699,7 +699,7 @@ static inline void kvm_guest_enter(void)
 
 static inline void kvm_guest_exit(void)
 {
-	account_system_vtime(current);
+	vtime_account(current);
 	current->flags &= ~PF_VCPU;
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b8c8664..8c38df0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -273,11 +273,11 @@ extern void init_idle_bootup_task(struct task_struct *idle);
 extern int runqueue_is_locked(int cpu);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
-extern void select_nohz_load_balancer(int stop_tick);
+extern void nohz_balance_enter_idle(int cpu);
 extern void set_cpu_sd_state_idle(void);
 extern int get_nohz_timer_target(void);
 #else
-static inline void select_nohz_load_balancer(int stop_tick) { }
+static inline void nohz_balance_enter_idle(int cpu) { }
 static inline void set_cpu_sd_state_idle(void) { }
 #endif
 
@@ -678,11 +678,6 @@ struct signal_struct {
 					 * (notably. ptrace) */
 };
 
-/* Context switch must be unlocked if interrupts are to be enabled */
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-# define __ARCH_WANT_UNLOCKED_CTXSW
-#endif
-
 /*
  * Bits in flags field of signal_struct.
  */
@@ -860,7 +855,6 @@ enum cpu_idle_type {
 #define SD_BALANCE_FORK		0x0008	/* Balance on fork, clone */
 #define SD_BALANCE_WAKE		0x0010  /* Balance on wakeup */
 #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
-#define SD_PREFER_LOCAL		0x0040  /* Prefer to keep tasks local to this domain */
 #define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
diff --git a/include/linux/topology.h b/include/linux/topology.h
index fec12d6..d3cf0d6 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -129,7 +129,6 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
@@ -160,7 +159,6 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
diff --git a/init/Kconfig b/init/Kconfig
index af6c7f8..1862c68 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -267,6 +267,106 @@ config POSIX_MQUEUE_SYSCTL
 	depends on SYSCTL
 	default y
 
+config FHANDLE
+	bool "open by fhandle syscalls"
+	select EXPORTFS
+	help
+	  If you say Y here, a user level program will be able to map
+	  file names to handle and then later use the handle for
+	  different file system operations. This is useful in implementing
+	  userspace file servers, which now track files using handles instead
+	  of names. The handle would remain the same even if file names
+	  get renamed. Enables open_by_handle_at(2) and name_to_handle_at(2)
+	  syscalls.
+
+config AUDIT
+	bool "Auditing support"
+	depends on NET
+	help
+	  Enable auditing infrastructure that can be used with another
+	  kernel subsystem, such as SELinux (which requires this for
+	  logging of avc messages output).  Does not do system-call
+	  auditing without CONFIG_AUDITSYSCALL.
+
+config AUDITSYSCALL
+	bool "Enable system-call auditing support"
+	depends on AUDIT && (X86 || PPC || S390 || IA64 || UML || SPARC64 || SUPERH || (ARM && AEABI && !OABI_COMPAT))
+	default y if SECURITY_SELINUX
+	help
+	  Enable low-overhead system-call auditing infrastructure that
+	  can be used independently or with another kernel subsystem,
+	  such as SELinux.
+
+config AUDIT_WATCH
+	def_bool y
+	depends on AUDITSYSCALL
+	select FSNOTIFY
+
+config AUDIT_TREE
+	def_bool y
+	depends on AUDITSYSCALL
+	select FSNOTIFY
+
+config AUDIT_LOGINUID_IMMUTABLE
+	bool "Make audit loginuid immutable"
+	depends on AUDIT
+	help
+	  The config option toggles if a task setting its loginuid requires
+	  CAP_SYS_AUDITCONTROL or if that task should require no special permissions
+	  but should instead only allow setting its loginuid if it was never
+	  previously set.  On systems which use systemd or a similar central
+	  process to restart login services this should be set to true.  On older
+	  systems in which an admin would typically have to directly stop and
+	  start processes this should be set to false.  Setting this to true allows
+	  one to drop potentially dangerous capabilites from the login tasks,
+	  but may not be backwards compatible with older init systems.
+
+source "kernel/irq/Kconfig"
+source "kernel/time/Kconfig"
+
+menu "CPU/Task time and stats accounting"
+
+choice
+	prompt "Cputime accounting"
+	default TICK_CPU_ACCOUNTING if !PPC64
+	default VIRT_CPU_ACCOUNTING if PPC64
+
+# Kind of a stub config for the pure tick based cputime accounting
+config TICK_CPU_ACCOUNTING
+	bool "Simple tick based cputime accounting"
+	depends on !S390
+	help
+	  This is the basic tick based cputime accounting that maintains
+	  statistics about user, system and idle time spent on per jiffies
+	  granularity.
+
+	  If unsure, say Y.
+
+config VIRT_CPU_ACCOUNTING
+	bool "Deterministic task and CPU time accounting"
+	depends on HAVE_VIRT_CPU_ACCOUNTING
+	help
+	  Select this option to enable more accurate task and CPU time
+	  accounting.  This is done by reading a CPU counter on each
+	  kernel entry and exit and on transitions within the kernel
+	  between system, softirq and hardirq state, so there is a
+	  small performance impact.  In the case of s390 or IBM POWER > 5,
+	  this also enables accounting of stolen time on logically-partitioned
+	  systems.
+
+config IRQ_TIME_ACCOUNTING
+	bool "Fine granularity task level IRQ time accounting"
+	depends on HAVE_IRQ_TIME_ACCOUNTING
+	help
+	  Select this option to enable fine granularity task irq time
+	  accounting. This is done by reading a timestamp on each
+	  transitions between softirq and hardirq state, so there can be a
+	  small performance impact.
+
+	  If in doubt, say N here.
+
+endchoice
+
 config BSD_PROCESS_ACCT
 	bool "BSD Process Accounting"
 	help
@@ -292,18 +392,6 @@ config BSD_PROCESS_ACCT_V3
 	  for processing it. A preliminary version of these tools is available
 	  at <http://www.gnu.org/software/acct/>.
 
-config FHANDLE
-	bool "open by fhandle syscalls"
-	select EXPORTFS
-	help
-	  If you say Y here, a user level program will be able to map
-	  file names to handle and then later use the handle for
-	  different file system operations. This is useful in implementing
-	  userspace file servers, which now track files using handles instead
-	  of names. The handle would remain the same even if file names
-	  get renamed. Enables open_by_handle_at(2) and name_to_handle_at(2)
-	  syscalls.
-
 config TASKSTATS
 	bool "Export task/process statistics through netlink (EXPERIMENTAL)"
 	depends on NET
@@ -346,50 +434,7 @@ config TASK_IO_ACCOUNTING
 
 	  Say N if unsure.
 
-config AUDIT
-	bool "Auditing support"
-	depends on NET
-	help
-	  Enable auditing infrastructure that can be used with another
-	  kernel subsystem, such as SELinux (which requires this for
-	  logging of avc messages output).  Does not do system-call
-	  auditing without CONFIG_AUDITSYSCALL.
-
-config AUDITSYSCALL
-	bool "Enable system-call auditing support"
-	depends on AUDIT && (X86 || PPC || S390 || IA64 || UML || SPARC64 || SUPERH || (ARM && AEABI && !OABI_COMPAT))
-	default y if SECURITY_SELINUX
-	help
-	  Enable low-overhead system-call auditing infrastructure that
-	  can be used independently or with another kernel subsystem,
-	  such as SELinux.
-
-config AUDIT_WATCH
-	def_bool y
-	depends on AUDITSYSCALL
-	select FSNOTIFY
-
-config AUDIT_TREE
-	def_bool y
-	depends on AUDITSYSCALL
-	select FSNOTIFY
-
-config AUDIT_LOGINUID_IMMUTABLE
-	bool "Make audit loginuid immutable"
-	depends on AUDIT
-	help
-	  The config option toggles if a task setting its loginuid requires
-	  CAP_SYS_AUDITCONTROL or if that task should require no special permissions
-	  but should instead only allow setting its loginuid if it was never
-	  previously set.  On systems which use systemd or a similar central
-	  process to restart login services this should be set to true.  On older
-	  systems in which an admin would typically have to directly stop and
-	  start processes this should be set to false.  Setting this to true allows
-	  one to drop potentially dangerous capabilites from the login tasks,
-	  but may not be backwards compatible with older init systems.
-
-source "kernel/irq/Kconfig"
-source "kernel/time/Kconfig"
+endmenu # "CPU/Task time and stats accounting"
 
 menu "RCU Subsystem"
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 2c8857e..743d48f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1280,11 +1280,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #endif
 #ifdef CONFIG_TRACE_IRQFLAGS
 	p->irq_events = 0;
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	p->hardirqs_enabled = 1;
-#else
 	p->hardirqs_enabled = 0;
-#endif
 	p->hardirq_enable_ip = 0;
 	p->hardirq_enable_event = 0;
 	p->hardirq_disable_ip = _THIS_IP_;
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 173ea52..f06d249 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -11,7 +11,7 @@ ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
 endif
 
-obj-y += core.o clock.o idle_task.o fair.o rt.o stop_task.o
+obj-y += core.o clock.o cputime.o idle_task.o fair.o rt.o stop_task.o
 obj-$(CONFIG_SMP) += cpupri.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a4ea245..21e4dcf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -740,126 +740,6 @@ void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 	dequeue_task(rq, p, flags);
 }
 
-#ifdef CONFIG_IRQ_TIME_ACCOUNTING
-
-/*
- * There are no locks covering percpu hardirq/softirq time.
- * They are only modified in account_system_vtime, on corresponding CPU
- * with interrupts disabled. So, writes are safe.
- * They are read and saved off onto struct rq in update_rq_clock().
- * This may result in other CPU reading this CPU's irq time and can
- * race with irq/account_system_vtime on this CPU. We would either get old
- * or new value with a side effect of accounting a slice of irq time to wrong
- * task when irq is in progress while we read rq->clock. That is a worthy
- * compromise in place of having locks on each irq in account_system_time.
- */
-static DEFINE_PER_CPU(u64, cpu_hardirq_time);
-static DEFINE_PER_CPU(u64, cpu_softirq_time);
-
-static DEFINE_PER_CPU(u64, irq_start_time);
-static int sched_clock_irqtime;
-
-void enable_sched_clock_irqtime(void)
-{
-	sched_clock_irqtime = 1;
-}
-
-void disable_sched_clock_irqtime(void)
-{
-	sched_clock_irqtime = 0;
-}
-
-#ifndef CONFIG_64BIT
-static DEFINE_PER_CPU(seqcount_t, irq_time_seq);
-
-static inline void irq_time_write_begin(void)
-{
-	__this_cpu_inc(irq_time_seq.sequence);
-	smp_wmb();
-}
-
-static inline void irq_time_write_end(void)
-{
-	smp_wmb();
-	__this_cpu_inc(irq_time_seq.sequence);
-}
-
-static inline u64 irq_time_read(int cpu)
-{
-	u64 irq_time;
-	unsigned seq;
-
-	do {
-		seq = read_seqcount_begin(&per_cpu(irq_time_seq, cpu));
-		irq_time = per_cpu(cpu_softirq_time, cpu) +
-			   per_cpu(cpu_hardirq_time, cpu);
-	} while (read_seqcount_retry(&per_cpu(irq_time_seq, cpu), seq));
-
-	return irq_time;
-}
-#else /* CONFIG_64BIT */
-static inline void irq_time_write_begin(void)
-{
-}
-
-static inline void irq_time_write_end(void)
-{
-}
-
-static inline u64 irq_time_read(int cpu)
-{
-	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
-}
-#endif /* CONFIG_64BIT */
-
-/*
- * Called before incrementing preempt_count on {soft,}irq_enter
- * and before decrementing preempt_count on {soft,}irq_exit.
- */
-void account_system_vtime(struct task_struct *curr)
-{
-	unsigned long flags;
-	s64 delta;
-	int cpu;
-
-	if (!sched_clock_irqtime)
-		return;
-
-	local_irq_save(flags);
-
-	cpu = smp_processor_id();
-	delta = sched_clock_cpu(cpu) - __this_cpu_read(irq_start_time);
-	__this_cpu_add(irq_start_time, delta);
-
-	irq_time_write_begin();
-	/*
-	 * We do not account for softirq time from ksoftirqd here.
-	 * We want to continue accounting softirq time to ksoftirqd thread
-	 * in that case, so as not to confuse scheduler with a special task
-	 * that do not consume any time, but still wants to run.
-	 */
-	if (hardirq_count())
-		__this_cpu_add(cpu_hardirq_time, delta);
-	else if (in_serving_softirq() && curr != this_cpu_ksoftirqd())
-		__this_cpu_add(cpu_softirq_time, delta);
-
-	irq_time_write_end();
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL_GPL(account_system_vtime);
-
-#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
-
-#ifdef CONFIG_PARAVIRT
-static inline u64 steal_ticks(u64 steal)
-{
-	if (unlikely(steal > NSEC_PER_SEC))
-		return div_u64(steal, TICK_NSEC);
-
-	return __iter_div_u64_rem(steal, TICK_NSEC, &steal);
-}
-#endif
-
 static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
 /*
@@ -920,43 +800,6 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 #endif
 }
 
-#ifdef CONFIG_IRQ_TIME_ACCOUNTING
-static int irqtime_account_hi_update(void)
-{
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-	unsigned long flags;
-	u64 latest_ns;
-	int ret = 0;
-
-	local_irq_save(flags);
-	latest_ns = this_cpu_read(cpu_hardirq_time);
-	if (nsecs_to_cputime64(latest_ns) > cpustat[CPUTIME_IRQ])
-		ret = 1;
-	local_irq_restore(flags);
-	return ret;
-}
-
-static int irqtime_account_si_update(void)
-{
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-	unsigned long flags;
-	u64 latest_ns;
-	int ret = 0;
-
-	local_irq_save(flags);
-	latest_ns = this_cpu_read(cpu_softirq_time);
-	if (nsecs_to_cputime64(latest_ns) > cpustat[CPUTIME_SOFTIRQ])
-		ret = 1;
-	local_irq_restore(flags);
-	return ret;
-}
-
-#else /* CONFIG_IRQ_TIME_ACCOUNTING */
-
-#define sched_clock_irqtime	(0)
-
-#endif
-
 void sched_set_stop_task(int cpu, struct task_struct *stop)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
@@ -1518,25 +1361,6 @@ static void ttwu_queue_remote(struct task_struct *p, int cpu)
 		smp_send_reschedule(cpu);
 }
 
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-static int ttwu_activate_remote(struct task_struct *p, int wake_flags)
-{
-	struct rq *rq;
-	int ret = 0;
-
-	rq = __task_rq_lock(p);
-	if (p->on_cpu) {
-		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
-		ttwu_do_wakeup(rq, p, wake_flags);
-		ret = 1;
-	}
-	__task_rq_unlock(rq);
-
-	return ret;
-
-}
-#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
-
 bool cpus_share_cache(int this_cpu, int that_cpu)
 {
 	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
@@ -1597,21 +1421,8 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	 * If the owning (remote) cpu is still in the middle of schedule() with
 	 * this task as prev, wait until its done referencing the task.
 	 */
-	while (p->on_cpu) {
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-		/*
-		 * In case the architecture enables interrupts in
-		 * context_switch(), we cannot busy wait, since that
-		 * would lead to deadlocks when an interrupt hits and
-		 * tries to wake up @prev. So bail and do a complete
-		 * remote wakeup.
-		 */
-		if (ttwu_activate_remote(p, wake_flags))
-			goto stat;
-#else
+	while (p->on_cpu)
 		cpu_relax();
-#endif
-	}
 	/*
 	 * Pairs with the smp_wmb() in finish_lock_switch().
 	 */
@@ -1953,14 +1764,9 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 *		Manfred Spraul <manfred@colorfullife.com>
 	 */
 	prev_state = prev->state;
+	vtime_task_switch(prev);
 	finish_arch_switch(prev);
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	local_irq_disable();
-#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	perf_event_task_sched_in(prev, current);
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	local_irq_enable();
-#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
 	finish_arch_post_lock_switch();
 
@@ -2809,404 +2615,6 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 	return ns;
 }
 
-#ifdef CONFIG_CGROUP_CPUACCT
-struct cgroup_subsys cpuacct_subsys;
-struct cpuacct root_cpuacct;
-#endif
-
-static inline void task_group_account_field(struct task_struct *p, int index,
-					    u64 tmp)
-{
-#ifdef CONFIG_CGROUP_CPUACCT
-	struct kernel_cpustat *kcpustat;
-	struct cpuacct *ca;
-#endif
-	/*
-	 * Since all updates are sure to touch the root cgroup, we
-	 * get ourselves ahead and touch it first. If the root cgroup
-	 * is the only cgroup, then nothing else should be necessary.
-	 *
-	 */
-	__get_cpu_var(kernel_cpustat).cpustat[index] += tmp;
-
-#ifdef CONFIG_CGROUP_CPUACCT
-	if (unlikely(!cpuacct_subsys.active))
-		return;
-
-	rcu_read_lock();
-	ca = task_ca(p);
-	while (ca && (ca != &root_cpuacct)) {
-		kcpustat = this_cpu_ptr(ca->cpustat);
-		kcpustat->cpustat[index] += tmp;
-		ca = parent_ca(ca);
-	}
-	rcu_read_unlock();
-#endif
-}
-
-
-/*
- * Account user cpu time to a process.
- * @p: the process that the cpu time gets accounted to
- * @cputime: the cpu time spent in user space since the last update
- * @cputime_scaled: cputime scaled by cpu frequency
- */
-void account_user_time(struct task_struct *p, cputime_t cputime,
-		       cputime_t cputime_scaled)
-{
-	int index;
-
-	/* Add user time to process. */
-	p->utime += cputime;
-	p->utimescaled += cputime_scaled;
-	account_group_user_time(p, cputime);
-
-	index = (TASK_NICE(p) > 0) ? CPUTIME_NICE : CPUTIME_USER;
-
-	/* Add user time to cpustat. */
-	task_group_account_field(p, index, (__force u64) cputime);
-
-	/* Account for user time used */
-	acct_update_integrals(p);
-}
-
-/*
- * Account guest cpu time to a process.
- * @p: the process that the cpu time gets accounted to
- * @cputime: the cpu time spent in virtual machine since the last update
- * @cputime_scaled: cputime scaled by cpu frequency
- */
-static void account_guest_time(struct task_struct *p, cputime_t cputime,
-			       cputime_t cputime_scaled)
-{
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-
-	/* Add guest time to process. */
-	p->utime += cputime;
-	p->utimescaled += cputime_scaled;
-	account_group_user_time(p, cputime);
-	p->gtime += cputime;
-
-	/* Add guest time to cpustat. */
-	if (TASK_NICE(p) > 0) {
-		cpustat[CPUTIME_NICE] += (__force u64) cputime;
-		cpustat[CPUTIME_GUEST_NICE] += (__force u64) cputime;
-	} else {
-		cpustat[CPUTIME_USER] += (__force u64) cputime;
-		cpustat[CPUTIME_GUEST] += (__force u64) cputime;
-	}
-}
-
-/*
- * Account system cpu time to a process and desired cpustat field
- * @p: the process that the cpu time gets accounted to
- * @cputime: the cpu time spent in kernel space since the last update
- * @cputime_scaled: cputime scaled by cpu frequency
- * @target_cputime64: pointer to cpustat field that has to be updated
- */
-static inline
-void __account_system_time(struct task_struct *p, cputime_t cputime,
-			cputime_t cputime_scaled, int index)
-{
-	/* Add system time to process. */
-	p->stime += cputime;
-	p->stimescaled += cputime_scaled;
-	account_group_system_time(p, cputime);
-
-	/* Add system time to cpustat. */
-	task_group_account_field(p, index, (__force u64) cputime);
-
-	/* Account for system time used */
-	acct_update_integrals(p);
-}
-
-/*
- * Account system cpu time to a process.
- * @p: the process that the cpu time gets accounted to
- * @hardirq_offset: the offset to subtract from hardirq_count()
- * @cputime: the cpu time spent in kernel space since the last update
- * @cputime_scaled: cputime scaled by cpu frequency
- */
-void account_system_time(struct task_struct *p, int hardirq_offset,
-			 cputime_t cputime, cputime_t cputime_scaled)
-{
-	int index;
-
-	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
-		account_guest_time(p, cputime, cputime_scaled);
-		return;
-	}
-
-	if (hardirq_count() - hardirq_offset)
-		index = CPUTIME_IRQ;
-	else if (in_serving_softirq())
-		index = CPUTIME_SOFTIRQ;
-	else
-		index = CPUTIME_SYSTEM;
-
-	__account_system_time(p, cputime, cputime_scaled, index);
-}
-
-/*
- * Account for involuntary wait time.
- * @cputime: the cpu time spent in involuntary wait
- */
-void account_steal_time(cputime_t cputime)
-{
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-
-	cpustat[CPUTIME_STEAL] += (__force u64) cputime;
-}
-
-/*
- * Account for idle time.
- * @cputime: the cpu time spent in idle wait
- */
-void account_idle_time(cputime_t cputime)
-{
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-	struct rq *rq = this_rq();
-
-	if (atomic_read(&rq->nr_iowait) > 0)
-		cpustat[CPUTIME_IOWAIT] += (__force u64) cputime;
-	else
-		cpustat[CPUTIME_IDLE] += (__force u64) cputime;
-}
-
-static __always_inline bool steal_account_process_tick(void)
-{
-#ifdef CONFIG_PARAVIRT
-	if (static_key_false(&paravirt_steal_enabled)) {
-		u64 steal, st = 0;
-
-		steal = paravirt_steal_clock(smp_processor_id());
-		steal -= this_rq()->prev_steal_time;
-
-		st = steal_ticks(steal);
-		this_rq()->prev_steal_time += st * TICK_NSEC;
-
-		account_steal_time(st);
-		return st;
-	}
-#endif
-	return false;
-}
-
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
-
-#ifdef CONFIG_IRQ_TIME_ACCOUNTING
-/*
- * Account a tick to a process and cpustat
- * @p: the process that the cpu time gets accounted to
- * @user_tick: is the tick from userspace
- * @rq: the pointer to rq
- *
- * Tick demultiplexing follows the order
- * - pending hardirq update
- * - pending softirq update
- * - user_time
- * - idle_time
- * - system time
- *   - check for guest_time
- *   - else account as system_time
- *
- * Check for hardirq is done both for system and user time as there is
- * no timer going off while we are on hardirq and hence we may never get an
- * opportunity to update it solely in system time.
- * p->stime and friends are only updated on system time and not on irq
- * softirq as those do not count in task exec_runtime any more.
- */
-static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
-						struct rq *rq)
-{
-	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-
-	if (steal_account_process_tick())
-		return;
-
-	if (irqtime_account_hi_update()) {
-		cpustat[CPUTIME_IRQ] += (__force u64) cputime_one_jiffy;
-	} else if (irqtime_account_si_update()) {
-		cpustat[CPUTIME_SOFTIRQ] += (__force u64) cputime_one_jiffy;
-	} else if (this_cpu_ksoftirqd() == p) {
-		/*
-		 * ksoftirqd time do not get accounted in cpu_softirq_time.
-		 * So, we have to handle it separately here.
-		 * Also, p->stime needs to be updated for ksoftirqd.
-		 */
-		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					CPUTIME_SOFTIRQ);
-	} else if (user_tick) {
-		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
-	} else if (p == rq->idle) {
-		account_idle_time(cputime_one_jiffy);
-	} else if (p->flags & PF_VCPU) { /* System time or guest time */
-		account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
-	} else {
-		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					CPUTIME_SYSTEM);
-	}
-}
-
-static void irqtime_account_idle_ticks(int ticks)
-{
-	int i;
-	struct rq *rq = this_rq();
-
-	for (i = 0; i < ticks; i++)
-		irqtime_account_process_tick(current, 0, rq);
-}
-#else /* CONFIG_IRQ_TIME_ACCOUNTING */
-static void irqtime_account_idle_ticks(int ticks) {}
-static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
-						struct rq *rq) {}
-#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
-
-/*
- * Account a single tick of cpu time.
- * @p: the process that the cpu time gets accounted to
- * @user_tick: indicates if the tick is a user or a system tick
- */
-void account_process_tick(struct task_struct *p, int user_tick)
-{
-	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
-	struct rq *rq = this_rq();
-
-	if (sched_clock_irqtime) {
-		irqtime_account_process_tick(p, user_tick, rq);
-		return;
-	}
-
-	if (steal_account_process_tick())
-		return;
-
-	if (user_tick)
-		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
-	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
-		account_system_time(p, HARDIRQ_OFFSET, cputime_one_jiffy,
-				    one_jiffy_scaled);
-	else
-		account_idle_time(cputime_one_jiffy);
-}
-
-/*
- * Account multiple ticks of steal time.
- * @p: the process from which the cpu time has been stolen
- * @ticks: number of stolen ticks
- */
-void account_steal_ticks(unsigned long ticks)
-{
-	account_steal_time(jiffies_to_cputime(ticks));
-}
-
-/*
- * Account multiple ticks of idle time.
- * @ticks: number of stolen ticks
- */
-void account_idle_ticks(unsigned long ticks)
-{
-
-	if (sched_clock_irqtime) {
-		irqtime_account_idle_ticks(ticks);
-		return;
-	}
-
-	account_idle_time(jiffies_to_cputime(ticks));
-}
-
-#endif
-
-/*
- * Use precise platform statistics if available:
- */
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
-{
-	*ut = p->utime;
-	*st = p->stime;
-}
-
-void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
-{
-	struct task_cputime cputime;
-
-	thread_group_cputime(p, &cputime);
-
-	*ut = cputime.utime;
-	*st = cputime.stime;
-}
-#else
-
-#ifndef nsecs_to_cputime
-# define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
-#endif
-
-static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
-{
-	u64 temp = (__force u64) rtime;
-
-	temp *= (__force u64) utime;
-
-	if (sizeof(cputime_t) == 4)
-		temp = div_u64(temp, (__force u32) total);
-	else
-		temp = div64_u64(temp, (__force u64) total);
-
-	return (__force cputime_t) temp;
-}
-
-void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
-{
-	cputime_t rtime, utime = p->utime, total = utime + p->stime;
-
-	/*
-	 * Use CFS's precise accounting:
-	 */
-	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
-
-	if (total)
-		utime = scale_utime(utime, rtime, total);
-	else
-		utime = rtime;
-
-	/*
-	 * Compare with previous values, to keep monotonicity:
-	 */
-	p->prev_utime = max(p->prev_utime, utime);
-	p->prev_stime = max(p->prev_stime, rtime - p->prev_utime);
-
-	*ut = p->prev_utime;
-	*st = p->prev_stime;
-}
-
-/*
- * Must be called with siglock held.
- */
-void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
-{
-	struct signal_struct *sig = p->signal;
-	struct task_cputime cputime;
-	cputime_t rtime, utime, total;
-
-	thread_group_cputime(p, &cputime);
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
-}
-#endif
-
 /*
  * This function gets called by the timer code, with HZ frequency.
  * We call it with interrupts disabled.
@@ -3367,6 +2775,40 @@ pick_next_task(struct rq *rq)
 
 /*
  * __schedule() is the main scheduler function.
+ *
+ * The main means of driving the scheduler and thus entering this function are:
+ *
+ *   1. Explicit blocking: mutex, semaphore, waitqueue, etc.
+ *
+ *   2. TIF_NEED_RESCHED flag is checked on interrupt and userspace return
+ *      paths. For example, see arch/x86/entry_64.S.
+ *
+ *      To drive preemption between tasks, the scheduler sets the flag in timer
+ *      interrupt handler scheduler_tick().
+ *
+ *   3. Wakeups don't really cause entry into schedule(). They add a
+ *      task to the run-queue and that's it.
+ *
+ *      Now, if the new task added to the run-queue preempts the current
+ *      task, then the wakeup sets TIF_NEED_RESCHED and schedule() gets
+ *      called on the nearest possible occasion:
+ *
+ *       - If the kernel is preemptible (CONFIG_PREEMPT=y):
+ *
+ *         - in syscall or exception context, at the next outmost
+ *           preempt_enable(). (this might be as soon as the wake_up()'s
+ *           spin_unlock()!)
+ *
+ *         - in IRQ context, return from interrupt-handler to
+ *           preemptible context
+ *
+ *       - If the kernel is not preemptible (CONFIG_PREEMPT is not set)
+ *         then at the next:
+ *
+ *          - cond_resched() call
+ *          - explicit schedule() call
+ *          - return from syscall or exception to user-space
+ *          - return from interrupt-handler to user-space
  */
 static void __sched __schedule(void)
 {
@@ -4868,13 +4310,6 @@ again:
 		 */
 		if (preempt && rq != p_rq)
 			resched_task(p_rq->curr);
-	} else {
-		/*
-		 * We might have set it in task_yield_fair(), but are
-		 * not going to schedule(), so don't want to skip
-		 * the next update.
-		 */
-		rq->skip_clock_update = 0;
 	}
 
 out:
@@ -5416,16 +4851,25 @@ static void sd_free_ctl_entry(struct ctl_table **tablep)
 	*tablep = NULL;
 }
 
+static int min_load_idx = 0;
+static int max_load_idx = CPU_LOAD_IDX_MAX;
+
 static void
 set_table_entry(struct ctl_table *entry,
 		const char *procname, void *data, int maxlen,
-		umode_t mode, proc_handler *proc_handler)
+		umode_t mode, proc_handler *proc_handler,
+		bool load_idx)
 {
 	entry->procname = procname;
 	entry->data = data;
 	entry->maxlen = maxlen;
 	entry->mode = mode;
 	entry->proc_handler = proc_handler;
+
+	if (load_idx) {
+		entry->extra1 = &min_load_idx;
+		entry->extra2 = &max_load_idx;
+	}
 }
 
 static struct ctl_table *
@@ -5437,30 +4881,30 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 		return NULL;
 
 	set_table_entry(&table[0], "min_interval", &sd->min_interval,
-		sizeof(long), 0644, proc_doulongvec_minmax);
+		sizeof(long), 0644, proc_doulongvec_minmax, false);
 	set_table_entry(&table[1], "max_interval", &sd->max_interval,
-		sizeof(long), 0644, proc_doulongvec_minmax);
+		sizeof(long), 0644, proc_doulongvec_minmax, false);
 	set_table_entry(&table[2], "busy_idx", &sd->busy_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[3], "idle_idx", &sd->idle_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[4], "newidle_idx", &sd->newidle_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[5], "wake_idx", &sd->wake_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[6], "forkexec_idx", &sd->forkexec_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[7], "busy_factor", &sd->busy_factor,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[8], "imbalance_pct", &sd->imbalance_pct,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[9], "cache_nice_tries",
 		&sd->cache_nice_tries,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[10], "flags", &sd->flags,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[11], "name", sd->name,
-		CORENAME_MAX_SIZE, 0444, proc_dostring);
+		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
 	/* &table[12] is terminator */
 
 	return table;
@@ -5604,7 +5048,9 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		migrate_tasks(cpu);
 		BUG_ON(rq->nr_running != 1); /* the migration thread */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		break;
 
+	case CPU_DEAD:
 		calc_load_migrate(rq);
 		break;
 #endif
@@ -6574,7 +6020,6 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 					| 0*SD_BALANCE_FORK
 					| 0*SD_BALANCE_WAKE
 					| 0*SD_WAKE_AFFINE
-					| 0*SD_PREFER_LOCAL
 					| 0*SD_SHARE_CPUPOWER
 					| 0*SD_SHARE_PKG_RESOURCES
 					| 1*SD_SERIALIZE
@@ -8372,6 +7817,8 @@ struct cgroup_subsys cpu_cgroup_subsys = {
  * (balbir@in.ibm.com).
  */
 
+struct cpuacct root_cpuacct;
+
 /* create a new cpu accounting group */
 static struct cgroup_subsys_state *cpuacct_create(struct cgroup *cgrp)
 {
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
new file mode 100644
index 0000000..81b763b
--- /dev/null
+++ b/kernel/sched/cputime.c
@@ -0,0 +1,530 @@
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/tsacct_kern.h>
+#include <linux/kernel_stat.h>
+#include <linux/static_key.h>
+#include "sched.h"
+
+
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+
+/*
+ * There are no locks covering percpu hardirq/softirq time.
+ * They are only modified in vtime_account, on corresponding CPU
+ * with interrupts disabled. So, writes are safe.
+ * They are read and saved off onto struct rq in update_rq_clock().
+ * This may result in other CPU reading this CPU's irq time and can
+ * race with irq/vtime_account on this CPU. We would either get old
+ * or new value with a side effect of accounting a slice of irq time to wrong
+ * task when irq is in progress while we read rq->clock. That is a worthy
+ * compromise in place of having locks on each irq in account_system_time.
+ */
+DEFINE_PER_CPU(u64, cpu_hardirq_time);
+DEFINE_PER_CPU(u64, cpu_softirq_time);
+
+static DEFINE_PER_CPU(u64, irq_start_time);
+static int sched_clock_irqtime;
+
+void enable_sched_clock_irqtime(void)
+{
+	sched_clock_irqtime = 1;
+}
+
+void disable_sched_clock_irqtime(void)
+{
+	sched_clock_irqtime = 0;
+}
+
+#ifndef CONFIG_64BIT
+DEFINE_PER_CPU(seqcount_t, irq_time_seq);
+#endif /* CONFIG_64BIT */
+
+/*
+ * Called before incrementing preempt_count on {soft,}irq_enter
+ * and before decrementing preempt_count on {soft,}irq_exit.
+ */
+void vtime_account(struct task_struct *curr)
+{
+	unsigned long flags;
+	s64 delta;
+	int cpu;
+
+	if (!sched_clock_irqtime)
+		return;
+
+	local_irq_save(flags);
+
+	cpu = smp_processor_id();
+	delta = sched_clock_cpu(cpu) - __this_cpu_read(irq_start_time);
+	__this_cpu_add(irq_start_time, delta);
+
+	irq_time_write_begin();
+	/*
+	 * We do not account for softirq time from ksoftirqd here.
+	 * We want to continue accounting softirq time to ksoftirqd thread
+	 * in that case, so as not to confuse scheduler with a special task
+	 * that do not consume any time, but still wants to run.
+	 */
+	if (hardirq_count())
+		__this_cpu_add(cpu_hardirq_time, delta);
+	else if (in_serving_softirq() && curr != this_cpu_ksoftirqd())
+		__this_cpu_add(cpu_softirq_time, delta);
+
+	irq_time_write_end();
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(vtime_account);
+
+static int irqtime_account_hi_update(void)
+{
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
+	unsigned long flags;
+	u64 latest_ns;
+	int ret = 0;
+
+	local_irq_save(flags);
+	latest_ns = this_cpu_read(cpu_hardirq_time);
+	if (nsecs_to_cputime64(latest_ns) > cpustat[CPUTIME_IRQ])
+		ret = 1;
+	local_irq_restore(flags);
+	return ret;
+}
+
+static int irqtime_account_si_update(void)
+{
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
+	unsigned long flags;
+	u64 latest_ns;
+	int ret = 0;
+
+	local_irq_save(flags);
+	latest_ns = this_cpu_read(cpu_softirq_time);
+	if (nsecs_to_cputime64(latest_ns) > cpustat[CPUTIME_SOFTIRQ])
+		ret = 1;
+	local_irq_restore(flags);
+	return ret;
+}
+
+#else /* CONFIG_IRQ_TIME_ACCOUNTING */
+
+#define sched_clock_irqtime	(0)
+
+#endif /* !CONFIG_IRQ_TIME_ACCOUNTING */
+
+static inline void task_group_account_field(struct task_struct *p, int index,
+					    u64 tmp)
+{
+#ifdef CONFIG_CGROUP_CPUACCT
+	struct kernel_cpustat *kcpustat;
+	struct cpuacct *ca;
+#endif
+	/*
+	 * Since all updates are sure to touch the root cgroup, we
+	 * get ourselves ahead and touch it first. If the root cgroup
+	 * is the only cgroup, then nothing else should be necessary.
+	 *
+	 */
+	__get_cpu_var(kernel_cpustat).cpustat[index] += tmp;
+
+#ifdef CONFIG_CGROUP_CPUACCT
+	if (unlikely(!cpuacct_subsys.active))
+		return;
+
+	rcu_read_lock();
+	ca = task_ca(p);
+	while (ca && (ca != &root_cpuacct)) {
+		kcpustat = this_cpu_ptr(ca->cpustat);
+		kcpustat->cpustat[index] += tmp;
+		ca = parent_ca(ca);
+	}
+	rcu_read_unlock();
+#endif
+}
+
+/*
+ * Account user cpu time to a process.
+ * @p: the process that the cpu time gets accounted to
+ * @cputime: the cpu time spent in user space since the last update
+ * @cputime_scaled: cputime scaled by cpu frequency
+ */
+void account_user_time(struct task_struct *p, cputime_t cputime,
+		       cputime_t cputime_scaled)
+{
+	int index;
+
+	/* Add user time to process. */
+	p->utime += cputime;
+	p->utimescaled += cputime_scaled;
+	account_group_user_time(p, cputime);
+
+	index = (TASK_NICE(p) > 0) ? CPUTIME_NICE : CPUTIME_USER;
+
+	/* Add user time to cpustat. */
+	task_group_account_field(p, index, (__force u64) cputime);
+
+	/* Account for user time used */
+	acct_update_integrals(p);
+}
+
+/*
+ * Account guest cpu time to a process.
+ * @p: the process that the cpu time gets accounted to
+ * @cputime: the cpu time spent in virtual machine since the last update
+ * @cputime_scaled: cputime scaled by cpu frequency
+ */
+static void account_guest_time(struct task_struct *p, cputime_t cputime,
+			       cputime_t cputime_scaled)
+{
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
+
+	/* Add guest time to process. */
+	p->utime += cputime;
+	p->utimescaled += cputime_scaled;
+	account_group_user_time(p, cputime);
+	p->gtime += cputime;
+
+	/* Add guest time to cpustat. */
+	if (TASK_NICE(p) > 0) {
+		cpustat[CPUTIME_NICE] += (__force u64) cputime;
+		cpustat[CPUTIME_GUEST_NICE] += (__force u64) cputime;
+	} else {
+		cpustat[CPUTIME_USER] += (__force u64) cputime;
+		cpustat[CPUTIME_GUEST] += (__force u64) cputime;
+	}
+}
+
+/*
+ * Account system cpu time to a process and desired cpustat field
+ * @p: the process that the cpu time gets accounted to
+ * @cputime: the cpu time spent in kernel space since the last update
+ * @cputime_scaled: cputime scaled by cpu frequency
+ * @target_cputime64: pointer to cpustat field that has to be updated
+ */
+static inline
+void __account_system_time(struct task_struct *p, cputime_t cputime,
+			cputime_t cputime_scaled, int index)
+{
+	/* Add system time to process. */
+	p->stime += cputime;
+	p->stimescaled += cputime_scaled;
+	account_group_system_time(p, cputime);
+
+	/* Add system time to cpustat. */
+	task_group_account_field(p, index, (__force u64) cputime);
+
+	/* Account for system time used */
+	acct_update_integrals(p);
+}
+
+/*
+ * Account system cpu time to a process.
+ * @p: the process that the cpu time gets accounted to
+ * @hardirq_offset: the offset to subtract from hardirq_count()
+ * @cputime: the cpu time spent in kernel space since the last update
+ * @cputime_scaled: cputime scaled by cpu frequency
+ */
+void account_system_time(struct task_struct *p, int hardirq_offset,
+			 cputime_t cputime, cputime_t cputime_scaled)
+{
+	int index;
+
+	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
+		account_guest_time(p, cputime, cputime_scaled);
+		return;
+	}
+
+	if (hardirq_count() - hardirq_offset)
+		index = CPUTIME_IRQ;
+	else if (in_serving_softirq())
+		index = CPUTIME_SOFTIRQ;
+	else
+		index = CPUTIME_SYSTEM;
+
+	__account_system_time(p, cputime, cputime_scaled, index);
+}
+
+/*
+ * Account for involuntary wait time.
+ * @cputime: the cpu time spent in involuntary wait
+ */
+void account_steal_time(cputime_t cputime)
+{
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
+
+	cpustat[CPUTIME_STEAL] += (__force u64) cputime;
+}
+
+/*
+ * Account for idle time.
+ * @cputime: the cpu time spent in idle wait
+ */
+void account_idle_time(cputime_t cputime)
+{
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
+	struct rq *rq = this_rq();
+
+	if (atomic_read(&rq->nr_iowait) > 0)
+		cpustat[CPUTIME_IOWAIT] += (__force u64) cputime;
+	else
+		cpustat[CPUTIME_IDLE] += (__force u64) cputime;
+}
+
+static __always_inline bool steal_account_process_tick(void)
+{
+#ifdef CONFIG_PARAVIRT
+	if (static_key_false(&paravirt_steal_enabled)) {
+		u64 steal, st = 0;
+
+		steal = paravirt_steal_clock(smp_processor_id());
+		steal -= this_rq()->prev_steal_time;
+
+		st = steal_ticks(steal);
+		this_rq()->prev_steal_time += st * TICK_NSEC;
+
+		account_steal_time(st);
+		return st;
+	}
+#endif
+	return false;
+}
+
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+/*
+ * Account a tick to a process and cpustat
+ * @p: the process that the cpu time gets accounted to
+ * @user_tick: is the tick from userspace
+ * @rq: the pointer to rq
+ *
+ * Tick demultiplexing follows the order
+ * - pending hardirq update
+ * - pending softirq update
+ * - user_time
+ * - idle_time
+ * - system time
+ *   - check for guest_time
+ *   - else account as system_time
+ *
+ * Check for hardirq is done both for system and user time as there is
+ * no timer going off while we are on hardirq and hence we may never get an
+ * opportunity to update it solely in system time.
+ * p->stime and friends are only updated on system time and not on irq
+ * softirq as those do not count in task exec_runtime any more.
+ */
+static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
+						struct rq *rq)
+{
+	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
+
+	if (steal_account_process_tick())
+		return;
+
+	if (irqtime_account_hi_update()) {
+		cpustat[CPUTIME_IRQ] += (__force u64) cputime_one_jiffy;
+	} else if (irqtime_account_si_update()) {
+		cpustat[CPUTIME_SOFTIRQ] += (__force u64) cputime_one_jiffy;
+	} else if (this_cpu_ksoftirqd() == p) {
+		/*
+		 * ksoftirqd time do not get accounted in cpu_softirq_time.
+		 * So, we have to handle it separately here.
+		 * Also, p->stime needs to be updated for ksoftirqd.
+		 */
+		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
+					CPUTIME_SOFTIRQ);
+	} else if (user_tick) {
+		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
+	} else if (p == rq->idle) {
+		account_idle_time(cputime_one_jiffy);
+	} else if (p->flags & PF_VCPU) { /* System time or guest time */
+		account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
+	} else {
+		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
+					CPUTIME_SYSTEM);
+	}
+}
+
+static void irqtime_account_idle_ticks(int ticks)
+{
+	int i;
+	struct rq *rq = this_rq();
+
+	for (i = 0; i < ticks; i++)
+		irqtime_account_process_tick(current, 0, rq);
+}
+#else /* CONFIG_IRQ_TIME_ACCOUNTING */
+static void irqtime_account_idle_ticks(int ticks) {}
+static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
+						struct rq *rq) {}
+#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+
+/*
+ * Account a single tick of cpu time.
+ * @p: the process that the cpu time gets accounted to
+ * @user_tick: indicates if the tick is a user or a system tick
+ */
+void account_process_tick(struct task_struct *p, int user_tick)
+{
+	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
+	struct rq *rq = this_rq();
+
+	if (sched_clock_irqtime) {
+		irqtime_account_process_tick(p, user_tick, rq);
+		return;
+	}
+
+	if (steal_account_process_tick())
+		return;
+
+	if (user_tick)
+		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
+	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
+		account_system_time(p, HARDIRQ_OFFSET, cputime_one_jiffy,
+				    one_jiffy_scaled);
+	else
+		account_idle_time(cputime_one_jiffy);
+}
+
+/*
+ * Account multiple ticks of steal time.
+ * @p: the process from which the cpu time has been stolen
+ * @ticks: number of stolen ticks
+ */
+void account_steal_ticks(unsigned long ticks)
+{
+	account_steal_time(jiffies_to_cputime(ticks));
+}
+
+/*
+ * Account multiple ticks of idle time.
+ * @ticks: number of stolen ticks
+ */
+void account_idle_ticks(unsigned long ticks)
+{
+
+	if (sched_clock_irqtime) {
+		irqtime_account_idle_ticks(ticks);
+		return;
+	}
+
+	account_idle_time(jiffies_to_cputime(ticks));
+}
+
+#endif
+
+/*
+ * Use precise platform statistics if available:
+ */
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+{
+	*ut = p->utime;
+	*st = p->stime;
+}
+
+void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+{
+	struct task_cputime cputime;
+
+	thread_group_cputime(p, &cputime);
+
+	*ut = cputime.utime;
+	*st = cputime.stime;
+}
+
+/*
+ * Archs that account the whole time spent in the idle task
+ * (outside irq) as idle time can rely on this and just implement
+ * vtime_account_system() and vtime_account_idle(). Archs that
+ * have other meaning of the idle time (s390 only includes the
+ * time spent by the CPU when it's in low power mode) must override
+ * vtime_account().
+ */
+#ifndef __ARCH_HAS_VTIME_ACCOUNT
+void vtime_account(struct task_struct *tsk)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	if (in_interrupt() || !is_idle_task(tsk))
+		vtime_account_system(tsk);
+	else
+		vtime_account_idle(tsk);
+
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(vtime_account);
+#endif /* __ARCH_HAS_VTIME_ACCOUNT */
+
+#else
+
+#ifndef nsecs_to_cputime
+# define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
+#endif
+
+static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
+{
+	u64 temp = (__force u64) rtime;
+
+	temp *= (__force u64) utime;
+
+	if (sizeof(cputime_t) == 4)
+		temp = div_u64(temp, (__force u32) total);
+	else
+		temp = div64_u64(temp, (__force u64) total);
+
+	return (__force cputime_t) temp;
+}
+
+void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+{
+	cputime_t rtime, utime = p->utime, total = utime + p->stime;
+
+	/*
+	 * Use CFS's precise accounting:
+	 */
+	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
+
+	if (total)
+		utime = scale_utime(utime, rtime, total);
+	else
+		utime = rtime;
+
+	/*
+	 * Compare with previous values, to keep monotonicity:
+	 */
+	p->prev_utime = max(p->prev_utime, utime);
+	p->prev_stime = max(p->prev_stime, rtime - p->prev_utime);
+
+	*ut = p->prev_utime;
+	*st = p->prev_stime;
+}
+
+/*
+ * Must be called with siglock held.
+ */
+void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+{
+	struct signal_struct *sig = p->signal;
+	struct task_cputime cputime;
+	cputime_t rtime, utime, total;
+
+	thread_group_cputime(p, &cputime);
+
+	total = cputime.utime + cputime.stime;
+	rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
+
+	if (total)
+		utime = scale_utime(cputime.utime, rtime, total);
+	else
+		utime = rtime;
+
+	sig->prev_utime = max(sig->prev_utime, utime);
+	sig->prev_stime = max(sig->prev_stime, rtime - sig->prev_utime);
+
+	*ut = sig->prev_utime;
+	*st = sig->prev_stime;
+}
+#endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 42d9df6..de596a2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -597,7 +597,7 @@ calc_delta_fair(unsigned long delta, struct sched_entity *se)
 /*
  * The idea is to set a period in which each task runs once.
  *
- * When there are too many tasks (sysctl_sched_nr_latency) we have to stretch
+ * When there are too many tasks (sched_nr_latency) we have to stretch
  * this period because otherwise the slices get too small.
  *
  * p = (nr <= nl) ? l : l*nr/nl
@@ -2686,7 +2686,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
 	int want_affine = 0;
-	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
 
 	if (p->nr_cpus_allowed == 1)
@@ -2704,48 +2703,21 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 			continue;
 
 		/*
-		 * If power savings logic is enabled for a domain, see if we
-		 * are not overloaded, if so, don't balance wider.
-		 */
-		if (tmp->flags & (SD_PREFER_LOCAL)) {
-			unsigned long power = 0;
-			unsigned long nr_running = 0;
-			unsigned long capacity;
-			int i;
-
-			for_each_cpu(i, sched_domain_span(tmp)) {
-				power += power_of(i);
-				nr_running += cpu_rq(i)->cfs.nr_running;
-			}
-
-			capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
-
-			if (nr_running < capacity)
-				want_sd = 0;
-		}
-
-		/*
 		 * If both cpu and prev_cpu are part of this domain,
 		 * cpu is a valid SD_WAKE_AFFINE target.
 		 */
 		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
 		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
 			affine_sd = tmp;
-			want_affine = 0;
-		}
-
-		if (!want_sd && !want_affine)
 			break;
+		}
 
-		if (!(tmp->flags & sd_flag))
-			continue;
-
-		if (want_sd)
+		if (tmp->flags & sd_flag)
 			sd = tmp;
 	}
 
 	if (affine_sd) {
-		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
+		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
 			prev_cpu = cpu;
 
 		new_cpu = select_idle_sibling(p, prev_cpu);
@@ -4281,7 +4253,7 @@ redo:
 		goto out_balanced;
 	}
 
-	BUG_ON(busiest == this_rq);
+	BUG_ON(busiest == env.dst_rq);
 
 	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
@@ -4302,7 +4274,7 @@ redo:
 		update_h_load(env.src_cpu);
 more_balance:
 		local_irq_save(flags);
-		double_rq_lock(this_rq, busiest);
+		double_rq_lock(env.dst_rq, busiest);
 
 		/*
 		 * cur_ld_moved - load moved in current iteration
@@ -4310,7 +4282,7 @@ more_balance:
 		 */
 		cur_ld_moved = move_tasks(&env);
 		ld_moved += cur_ld_moved;
-		double_rq_unlock(this_rq, busiest);
+		double_rq_unlock(env.dst_rq, busiest);
 		local_irq_restore(flags);
 
 		if (env.flags & LBF_NEED_BREAK) {
@@ -4346,8 +4318,7 @@ more_balance:
 		if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0 &&
 				lb_iterations++ < max_lb_iterations) {
 
-			this_rq		 = cpu_rq(env.new_dst_cpu);
-			env.dst_rq	 = this_rq;
+			env.dst_rq	 = cpu_rq(env.new_dst_cpu);
 			env.dst_cpu	 = env.new_dst_cpu;
 			env.flags	&= ~LBF_SOME_PINNED;
 			env.loop	 = 0;
@@ -4632,7 +4603,7 @@ static void nohz_balancer_kick(int cpu)
 	return;
 }
 
-static inline void clear_nohz_tick_stopped(int cpu)
+static inline void nohz_balance_exit_idle(int cpu)
 {
 	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))) {
 		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
@@ -4672,28 +4643,23 @@ void set_cpu_sd_state_idle(void)
 }
 
 /*
- * This routine will record that this cpu is going idle with tick stopped.
+ * This routine will record that the cpu is going idle with tick stopped.
  * This info will be used in performing idle load balancing in the future.
  */
-void select_nohz_load_balancer(int stop_tick)
+void nohz_balance_enter_idle(int cpu)
 {
-	int cpu = smp_processor_id();
-
 	/*
 	 * If this cpu is going down, then nothing needs to be done.
 	 */
 	if (!cpu_active(cpu))
 		return;
 
-	if (stop_tick) {
-		if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
-			return;
+	if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
+		return;
 
-		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
-		atomic_inc(&nohz.nr_cpus);
-		set_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
-	}
-	return;
+	cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
+	atomic_inc(&nohz.nr_cpus);
+	set_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
 }
 
 static int __cpuinit sched_ilb_notifier(struct notifier_block *nfb,
@@ -4701,7 +4667,7 @@ static int __cpuinit sched_ilb_notifier(struct notifier_block *nfb,
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DYING:
-		clear_nohz_tick_stopped(smp_processor_id());
+		nohz_balance_exit_idle(smp_processor_id());
 		return NOTIFY_OK;
 	default:
 		return NOTIFY_DONE;
@@ -4823,14 +4789,15 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 		if (need_resched())
 			break;
 
-		raw_spin_lock_irq(&this_rq->lock);
-		update_rq_clock(this_rq);
-		update_idle_cpu_load(this_rq);
-		raw_spin_unlock_irq(&this_rq->lock);
+		rq = cpu_rq(balance_cpu);
+
+		raw_spin_lock_irq(&rq->lock);
+		update_rq_clock(rq);
+		update_idle_cpu_load(rq);
+		raw_spin_unlock_irq(&rq->lock);
 
 		rebalance_domains(balance_cpu, CPU_IDLE);
 
-		rq = cpu_rq(balance_cpu);
 		if (time_after(this_rq->next_balance, rq->next_balance))
 			this_rq->next_balance = rq->next_balance;
 	}
@@ -4861,7 +4828,7 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	* busy tick after returning from idle, we will update the busy stats.
 	*/
 	set_cpu_sd_state_busy();
-	clear_nohz_tick_stopped(cpu);
+	nohz_balance_exit_idle(cpu);
 
 	/*
 	 * None are in tickless mode and hence no need for NOHZ idle load
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index de00a48..eebefca 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -12,14 +12,6 @@ SCHED_FEAT(GENTLE_FAIR_SLEEPERS, true)
 SCHED_FEAT(START_DEBIT, true)
 
 /*
- * Based on load and program behaviour, see if it makes sense to place
- * a newly woken task on the same cpu as the task that woke it --
- * improve cache locality. Typically used with SYNC wakeups as
- * generated by pipes and the like, see also SYNC_WAKEUPS.
- */
-SCHED_FEAT(AFFINE_WAKEUPS, true)
-
-/*
  * Prefer to schedule the task we woke last (assuming it failed
  * wakeup-preemption), since its likely going to consume data we
  * touched, increases cache locality.
@@ -42,7 +34,7 @@ SCHED_FEAT(CACHE_HOT_BUDDY, true)
 /*
  * Use arch dependent cpu power functions
  */
-SCHED_FEAT(ARCH_POWER, false)
+SCHED_FEAT(ARCH_POWER, true)
 
 SCHED_FEAT(HRTICK, false)
 SCHED_FEAT(DOUBLE_TICK, false)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index e0b7ba9..418feb0 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1632,11 +1632,6 @@ static int push_rt_task(struct rq *rq)
 	if (!next_task)
 		return 0;
 
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-       if (unlikely(task_running(rq, next_task)))
-               return 0;
-#endif
-
 retry:
 	if (unlikely(next_task == rq->curr)) {
 		WARN_ON(1);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0848fa3..7a7db09 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -737,11 +737,7 @@ static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 	 */
 	next->on_cpu = 1;
 #endif
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	raw_spin_unlock_irq(&rq->lock);
-#else
 	raw_spin_unlock(&rq->lock);
-#endif
 }
 
 static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
@@ -755,9 +751,7 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 	smp_wmb();
 	prev->on_cpu = 0;
 #endif
-#ifndef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 	local_irq_enable();
-#endif
 }
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
@@ -891,6 +885,9 @@ struct cpuacct {
 	struct kernel_cpustat __percpu *cpustat;
 };
 
+extern struct cgroup_subsys cpuacct_subsys;
+extern struct cpuacct root_cpuacct;
+
 /* return cpu accounting group corresponding to this container */
 static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
 {
@@ -917,6 +914,16 @@ extern void cpuacct_charge(struct task_struct *tsk, u64 cputime);
 static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
 #endif
 
+#ifdef CONFIG_PARAVIRT
+static inline u64 steal_ticks(u64 steal)
+{
+	if (unlikely(steal > NSEC_PER_SEC))
+		return div_u64(steal, TICK_NSEC);
+
+	return __iter_div_u64_rem(steal, TICK_NSEC, &steal);
+}
+#endif
+
 static inline void inc_nr_running(struct rq *rq)
 {
 	rq->nr_running++;
@@ -1156,3 +1163,53 @@ enum rq_nohz_flag_bits {
 
 #define nohz_flags(cpu)	(&cpu_rq(cpu)->nohz_flags)
 #endif
+
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+
+DECLARE_PER_CPU(u64, cpu_hardirq_time);
+DECLARE_PER_CPU(u64, cpu_softirq_time);
+
+#ifndef CONFIG_64BIT
+DECLARE_PER_CPU(seqcount_t, irq_time_seq);
+
+static inline void irq_time_write_begin(void)
+{
+	__this_cpu_inc(irq_time_seq.sequence);
+	smp_wmb();
+}
+
+static inline void irq_time_write_end(void)
+{
+	smp_wmb();
+	__this_cpu_inc(irq_time_seq.sequence);
+}
+
+static inline u64 irq_time_read(int cpu)
+{
+	u64 irq_time;
+	unsigned seq;
+
+	do {
+		seq = read_seqcount_begin(&per_cpu(irq_time_seq, cpu));
+		irq_time = per_cpu(cpu_softirq_time, cpu) +
+			   per_cpu(cpu_hardirq_time, cpu);
+	} while (read_seqcount_retry(&per_cpu(irq_time_seq, cpu), seq));
+
+	return irq_time;
+}
+#else /* CONFIG_64BIT */
+static inline void irq_time_write_begin(void)
+{
+}
+
+static inline void irq_time_write_end(void)
+{
+}
+
+static inline u64 irq_time_read(int cpu)
+{
+	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
+}
+#endif /* CONFIG_64BIT */
+#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+
diff --git a/kernel/softirq.c b/kernel/softirq.c
index b73e681..d55e315 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -220,7 +220,7 @@ asmlinkage void __do_softirq(void)
 	current->flags &= ~PF_MEMALLOC;
 
 	pending = local_softirq_pending();
-	account_system_vtime(current);
+	vtime_account(current);
 
 	__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
@@ -271,7 +271,7 @@ restart:
 
 	lockdep_softirq_exit();
 
-	account_system_vtime(current);
+	vtime_account(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
@@ -340,7 +340,7 @@ static inline void invoke_softirq(void)
  */
 void irq_exit(void)
 {
-	account_system_vtime(current);
+	vtime_account(current);
 	trace_hardirq_exit();
 	sub_preempt_count(IRQ_EXIT_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 87174ef..81c7b1a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -307,7 +307,7 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &max_sched_tunable_scaling,
 	},
 	{
-		.procname	= "sched_migration_cost",
+		.procname	= "sched_migration_cost_ns",
 		.data		= &sysctl_sched_migration_cost,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
@@ -321,14 +321,14 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
-		.procname	= "sched_time_avg",
+		.procname	= "sched_time_avg_ms",
 		.data		= &sysctl_sched_time_avg,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
 	{
-		.procname	= "sched_shares_window",
+		.procname	= "sched_shares_window_ns",
 		.data		= &sysctl_sched_shares_window,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3a9e5d5..1a5ee90 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -372,7 +372,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 		 * the scheduler tick in nohz_restart_sched_tick.
 		 */
 		if (!ts->tick_stopped) {
-			select_nohz_load_balancer(1);
+			nohz_balance_enter_idle(cpu);
 			calc_load_enter_idle();
 
 			ts->last_tick = hrtimer_get_expires(&ts->sched_timer);
@@ -569,7 +569,6 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 {
 	/* Update jiffies first */
-	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
 	update_cpu_load_nohz();
 
