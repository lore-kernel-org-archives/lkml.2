Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab2KCQKq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 12:10:46 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:43958 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab2KCQJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:09:57 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] cputime: Allow dynamic switch between tick/virtual based cputime accounting
Date: Sat,  3 Nov 2012 17:09:42 +0100
Message-Id: <1351958983-31355-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351958983-31355-1-git-send-email-fweisbec@gmail.com>
References: <1351958983-31355-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to dynamically switch between tick and virtual based cputime accounting.
This way we can provide a kind of "on-demand" virtual based cputime
accounting. In this mode, the kernel will rely on the user hooks
subsystem to dynamically hook on kernel boundaries.

This is in preparation for beeing able to stop the timer tick further
idle. Doing so will depend on CONFIG_VIRT_CPU_ACCOUNTING which makes
it possible to account the cputime without the tick by hooking on
kernel/user boundaries.

Depending whether the tick is stopped or not, we can switch between
tick and vtime based accounting anytime in order to minimize the
overhead associated to user hooks.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/include/asm/cputime.h    |    5 ++++
 arch/ia64/kernel/time.c            |    2 +-
 arch/powerpc/include/asm/cputime.h |    5 ++++
 arch/powerpc/kernel/time.c         |    2 +-
 arch/s390/include/asm/cputime.h    |    5 ++++
 arch/s390/kernel/vtime.c           |    2 +-
 include/linux/sched.h              |    5 +---
 include/linux/vtime.h              |    7 ++++++
 kernel/fork.c                      |    3 +-
 kernel/sched/cputime.c             |   40 ++++++++++++++++-------------------
 kernel/time/tick-sched.c           |    5 ++-
 11 files changed, 48 insertions(+), 33 deletions(-)

diff --git a/arch/ia64/include/asm/cputime.h b/arch/ia64/include/asm/cputime.h
index 3deac95..49782fe 100644
--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@ -103,5 +103,10 @@ static inline void cputime_to_timeval(const cputime_t ct, struct timeval *val)
 #define cputime64_to_clock_t(__ct)	\
 	cputime_to_clock_t((__force cputime_t)__ct)
 
+static inline bool vtime_accounting(void)
+{
+	return true;
+}
+
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 #endif /* __IA64_CPUTIME_H */
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 5e48503..7b1fa3d 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -151,7 +151,7 @@ void __vtime_account_idle(struct task_struct *tsk)
  * Called from the timer interrupt handler to charge accumulated user time
  * to the current process.  Must be called with interrupts disabled.
  */
-void account_process_tick(struct task_struct *p, int user_tick)
+void vtime_account_process_tick(struct task_struct *p, int user_tick)
 {
 	vtime_account_user(p);
 }
diff --git a/arch/powerpc/include/asm/cputime.h b/arch/powerpc/include/asm/cputime.h
index 487d46f..e84c2b3 100644
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -228,6 +228,11 @@ static inline cputime_t clock_t_to_cputime(const unsigned long clk)
 
 #define cputime64_to_clock_t(ct)	cputime_to_clock_t((cputime_t)(ct))
 
+static inline bool vtime_accounting(void)
+{
+	return true;
+}
+
 #endif /* __KERNEL__ */
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 #endif /* __POWERPC_CPUTIME_H */
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 0db456f..1c9a3b8 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -363,7 +363,7 @@ void __vtime_account_idle(struct task_struct *tsk)
  * (i.e. since the last entry from usermode) so that
  * get_paca()->user_time_scaled is up to date.
  */
-void account_process_tick(struct task_struct *tsk, int user_tick)
+void vtime_account_process_tick(struct task_struct *tsk, int user_tick)
 {
 	cputime_t utime, utimescaled;
 
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index 023d5ae..a96161b 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -191,4 +191,9 @@ static inline int s390_nohz_delay(int cpu)
 
 #define arch_needs_cpu(cpu) s390_nohz_delay(cpu)
 
+static inline bool vtime_accounting(void)
+{
+	return true;
+}
+
 #endif /* _S390_CPUTIME_H */
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 783e988..ab180de 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -112,7 +112,7 @@ void vtime_task_switch(struct task_struct *prev)
 	S390_lowcore.system_timer = ti->system_timer;
 }
 
-void account_process_tick(struct task_struct *tsk, int user_tick)
+void vtime_account_process_tick(struct task_struct *tsk, int user_tick)
 {
 	if (do_account_vtime(tsk, HARDIRQ_OFFSET))
 		virt_timer_expire();
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6c13fe3..2f9bba0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -580,9 +580,7 @@ struct signal_struct {
 	cputime_t utime, stime, cutime, cstime;
 	cputime_t gtime;
 	cputime_t cgtime;
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	cputime_t prev_utime, prev_stime;
-#endif
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
@@ -1339,9 +1337,8 @@ struct task_struct {
 
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	cputime_t prev_utime, prev_stime;
-#endif
+
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
 	struct timespec real_start_time;	/* boot based time */
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 0c2a2d3..85a1f0f 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -8,12 +8,19 @@ extern void vtime_task_switch(struct task_struct *prev);
 extern void __vtime_account_system(struct task_struct *tsk);
 extern void vtime_account_system(struct task_struct *tsk);
 extern void __vtime_account_idle(struct task_struct *tsk);
+extern void vtime_account_process_tick(struct task_struct *tsk,
+				       int user_tick);
 extern void vtime_account(struct task_struct *tsk);
 #else
 static inline void vtime_task_switch(struct task_struct *prev) { }
 static inline void __vtime_account_system(struct task_struct *tsk) { }
 static inline void vtime_account_system(struct task_struct *tsk) { }
+
+static inline void
+vtime_account_process_tick(struct task_struct *tsk, int user_tick) { }
+
 static inline void vtime_account(struct task_struct *tsk) { }
+static inline bool vtime_accounting(void) { return false; }
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
diff --git a/kernel/fork.c b/kernel/fork.c
index 8b20ab7..66bf627 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1221,9 +1221,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	p->utime = p->stime = p->gtime = 0;
 	p->utimescaled = p->stimescaled = 0;
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	p->prev_utime = p->prev_stime = 0;
-#endif
+
 #if defined(SPLIT_RSS_COUNTING)
 	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
 #endif
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 8d859da..ff608f6 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -288,8 +288,6 @@ static __always_inline bool steal_account_process_tick(void)
 	return false;
 }
 
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
-
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 /*
  * Account a tick to a process and cpustat
@@ -369,6 +367,11 @@ void account_process_tick(struct task_struct *p, int user_tick)
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
 	struct rq *rq = this_rq();
 
+	if (vtime_accounting()) {
+		vtime_account_process_tick(p, user_tick);
+		return;
+	}
+
 	if (sched_clock_irqtime) {
 		irqtime_account_process_tick(p, user_tick, rq);
 		return;
@@ -411,28 +414,11 @@ void account_idle_ticks(unsigned long ticks)
 	account_idle_time(jiffies_to_cputime(ticks));
 }
 
-#endif
 
 /*
  * Use precise platform statistics if available:
  */
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
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
-
 void vtime_account_system(struct task_struct *tsk)
 {
 	unsigned long flags;
@@ -467,8 +453,7 @@ void vtime_account(struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(vtime_account);
 #endif /* __ARCH_HAS_VTIME_ACCOUNT */
-
-#else
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 
 #ifndef nsecs_to_cputime
 # define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
@@ -492,6 +477,12 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
 	cputime_t rtime, utime = p->utime, total = utime + p->stime;
 
+	if (vtime_accounting()) {
+		*ut = p->utime;
+		*st = p->stime;
+		return;
+	}
+
 	/*
 	 * Use CFS's precise accounting:
 	 */
@@ -523,6 +514,12 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 
 	thread_group_cputime(p, &cputime);
 
+	if (vtime_accounting()) {
+		*ut = cputime.utime;
+		*st = cputime.stime;
+		return;
+	}
+
 	total = cputime.utime + cputime.stime;
 	rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
 
@@ -537,4 +534,3 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	*ut = sig->prev_utime;
 	*st = sig->prev_stime;
 }
-#endif
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a402608..2c82751 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -586,8 +586,10 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 
 static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
 {
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	unsigned long ticks;
+
+	if (vtime_accounting())
+		return;
 	/*
 	 * We stopped the tick in idle. Update process times would miss the
 	 * time we slept as update_process_times does only a 1 tick
@@ -599,7 +601,6 @@ static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
 	 */
 	if (ticks && ticks < LONG_MAX)
 		account_idle_ticks(ticks);
-#endif
 }
 
 /**
-- 
1.7.5.4

