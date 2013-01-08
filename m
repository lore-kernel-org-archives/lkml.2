Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3AHCI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:08:56 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:36278 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3AHCIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:08:53 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 04/33] cputime: Allow dynamic switch between tick/virtual based cputime accounting
Date: Tue,  8 Jan 2013 03:08:04 +0100
Message-Id: <1357610913-1080-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to dynamically switch between tick and virtual based cputime accounting.
This way we can provide a kind of "on-demand" virtual based cputime
accounting. In this mode, the kernel will rely on the user hooks
subsystem to dynamically hook on kernel boundaries.

This is in preparation for being able to stop the timer tick in
more places than just the idle state. Doing so will depend on
CONFIG_VIRT_CPU_ACCOUNTING which makes it possible to account the
cputime without the tick by hooking on kernel/user boundaries.

Depending whether the tick is stopped or not, we can switch between
tick and vtime based accounting anytime in order to minimize the
overhead associated to user hooks.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/kernel_stat.h |    2 +-
 include/linux/sched.h       |    4 +-
 include/linux/vtime.h       |    8 ++++++
 kernel/fork.c               |    2 +-
 kernel/sched/cputime.c      |   58 +++++++++++++++++++++++++++---------------
 kernel/time/tick-sched.c    |    5 +++-
 6 files changed, 53 insertions(+), 26 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 66b7078..ed5f6ed 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -127,7 +127,7 @@ extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t)
 extern void account_steal_time(cputime_t);
 extern void account_idle_time(cputime_t);
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 static inline void account_process_tick(struct task_struct *tsk, int user)
 {
 	vtime_account_user(tsk);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 206bb08..66b2344 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -605,7 +605,7 @@ struct signal_struct {
 	cputime_t utime, stime, cutime, cstime;
 	cputime_t gtime;
 	cputime_t cgtime;
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	struct cputime prev_cputime;
 #endif
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
@@ -1365,7 +1365,7 @@ struct task_struct {
 
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	struct cputime prev_cputime;
 #endif
 	unsigned long nvcsw, nivcsw; /* context switch counts */
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 21ef703..5368af9 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -10,12 +10,20 @@ extern void vtime_account_system_irqsafe(struct task_struct *tsk);
 extern void vtime_account_idle(struct task_struct *tsk);
 extern void vtime_account_user(struct task_struct *tsk);
 extern void vtime_account(struct task_struct *tsk);
+
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
+extern bool vtime_accounting_enabled(void);
 #else
+static inline bool vtime_accounting_enabled(void) { return true; }
+#endif
+
+#else /* !CONFIG_VIRT_CPU_ACCOUNTING */
 static inline void vtime_task_switch(struct task_struct *prev) { }
 static inline void vtime_account_system(struct task_struct *tsk) { }
 static inline void vtime_account_system_irqsafe(struct task_struct *tsk) { }
 static inline void vtime_account_user(struct task_struct *tsk) { }
 static inline void vtime_account(struct task_struct *tsk) { }
+static inline bool vtime_accounting_enabled(void) { return false; }
 #endif
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
diff --git a/kernel/fork.c b/kernel/fork.c
index 65ca6d2..81b5209 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1230,7 +1230,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	p->utime = p->stime = p->gtime = 0;
 	p->utimescaled = p->stimescaled = 0;
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	p->prev_cputime.utime = p->prev_cputime.stime = 0;
 #endif
 #if defined(SPLIT_RSS_COUNTING)
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 3749a0e..3ea4233 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -317,8 +317,6 @@ out:
 	rcu_read_unlock();
 }
 
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
-
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 /*
  * Account a tick to a process and cpustat
@@ -388,6 +386,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 						struct rq *rq) {}
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 /*
  * Account a single tick of cpu time.
  * @p: the process that the cpu time gets accounted to
@@ -398,6 +397,11 @@ void account_process_tick(struct task_struct *p, int user_tick)
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
 	struct rq *rq = this_rq();
 
+	if (vtime_accounting_enabled()) {
+		vtime_account_user(p);
+		return;
+	}
+
 	if (sched_clock_irqtime) {
 		irqtime_account_process_tick(p, user_tick, rq);
 		return;
@@ -439,29 +443,13 @@ void account_idle_ticks(unsigned long ticks)
 
 	account_idle_time(jiffies_to_cputime(ticks));
 }
-
 #endif
 
+
 /*
  * Use precise platform statistics if available:
  */
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
-void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
-{
-	*ut = p->utime;
-	*st = p->stime;
-}
-
-void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
-{
-	struct task_cputime cputime;
-
-	thread_group_cputime(p, &cputime);
-
-	*ut = cputime.utime;
-	*st = cputime.stime;
-}
-
 void vtime_account_system_irqsafe(struct task_struct *tsk)
 {
 	unsigned long flags;
@@ -517,8 +505,25 @@ void vtime_account(struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(vtime_account);
 #endif /* __ARCH_HAS_VTIME_ACCOUNT */
+#endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 
-#else
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
+void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
+{
+	*ut = p->utime;
+	*st = p->stime;
+}
+
+void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
+{
+	struct task_cputime cputime;
+
+	thread_group_cputime(p, &cputime);
+
+	*ut = cputime.utime;
+	*st = cputime.stime;
+}
+#else /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 #ifndef nsecs_to_cputime
 # define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
@@ -548,6 +553,12 @@ static void cputime_adjust(struct task_cputime *curr,
 {
 	cputime_t rtime, utime, total;
 
+	if (vtime_accounting_enabled()) {
+		*ut = curr->utime;
+		*st = curr->stime;
+		return;
+	}
+
 	utime = curr->utime;
 	total = utime + curr->stime;
 
@@ -601,7 +612,7 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
 	thread_group_cputime(p, &cputime);
 	cputime_adjust(&cputime, &p->signal->prev_cputime, ut, st);
 }
-#endif
+#endif /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 static DEFINE_PER_CPU(long, last_jiffies) = INITIAL_JIFFIES;
@@ -643,6 +654,11 @@ void vtime_account_idle(struct task_struct *tsk)
 	account_idle_time(delta_cpu);
 }
 
+bool vtime_accounting_enabled(void)
+{
+	return context_tracking_active();
+}
+
 static int __cpuinit vtime_cpu_notify(struct notifier_block *self,
 				      unsigned long action, void *hcpu)
 {
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index fb8e5e4..314b9ee 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -632,8 +632,11 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 
 static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
 {
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	unsigned long ticks;
+
+	if (vtime_accounting_enabled())
+		return;
 	/*
 	 * We stopped the tick in idle. Update process times would miss the
 	 * time we slept as update_process_times does only a 1 tick
-- 
1.7.5.4

