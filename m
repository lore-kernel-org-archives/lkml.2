Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab1HOPyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:54:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46598 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab1HOPx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:59 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 23/32] nohz/cpuset: Account user and system times in adaptive nohz mode
Date: Mon, 15 Aug 2011 17:52:20 +0200
Message-Id: <1313423549-27093-24-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we are not running the tick, we are not anymore regularly counting
the cputime at every jiffies.

Lay the ground to count that cputime from the points that require
it. Start by catching up from timer interrupts and when we schedule
out a process. We record the last jiffies and from which ring we saved
it and compute the difference later when we can catch up.

For now it assumes we haven't switched to another ring while we
were running nohz.

TODO: wrap operation on jiffies?

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 include/linux/kernel_stat.h |    2 ++
 include/linux/tick.h        |   11 +++++++++++
 kernel/sched.c              |   23 +++++++++++++++++++++++
 kernel/time/tick-sched.c    |   39 +++++++++++++++++++++++++++++++++++++++
 kernel/timer.c              |    6 ++++--
 5 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 0cce2db..14cfce4 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -114,7 +114,9 @@ static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
 extern unsigned long long task_delta_exec(struct task_struct *);
 
 extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
+extern void account_user_jiffies(struct task_struct *, unsigned long);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
+extern void account_system_jiffies(struct task_struct *, unsigned long);
 extern void account_steal_time(cputime_t);
 extern void account_idle_time(cputime_t);
 
diff --git a/include/linux/tick.h b/include/linux/tick.h
index cc4880e..ea6dfb7 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -26,6 +26,12 @@ enum tick_nohz_mode {
 	NOHZ_MODE_HIGHRES,
 };
 
+enum tick_saved_jiffies {
+	JIFFIES_SAVED_NONE,
+	JIFFIES_SAVED_USER,
+	JIFFIES_SAVED_SYS,
+};
+
 /**
  * struct tick_sched - sched tick emulation and no idle tick control/stats
  * @sched_timer:	hrtimer to schedule the periodic tick in high
@@ -60,6 +66,8 @@ struct tick_sched {
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
+	enum tick_saved_jiffies		saved_jiffies_whence;
+	unsigned long			saved_jiffies;
 	ktime_t				iowait_sleeptime;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
@@ -132,8 +140,11 @@ extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 DECLARE_PER_CPU(int, task_nohz_mode);
 
 extern int tick_nohz_adaptive_mode(void);
+extern bool tick_nohz_account_tick(void);
+extern void tick_nohz_flush_current_times(void);
 #else /* !CPUSETS_NO_HZ */
 static inline int tick_nohz_adaptive_mode(void) { return 0; }
+static inline bool tick_nohz_account_tick(void) { return false; }
 #endif /* CPUSETS_NO_HZ */
 
 # else /* !NO_HZ */
diff --git a/kernel/sched.c b/kernel/sched.c
index 75378be..a58f993 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2500,6 +2500,7 @@ bool cpuset_nohz_can_stop_tick(void)
 
 static void cpuset_nohz_restart_tick(void)
 {
+	tick_nohz_flush_current_times();
 	__get_cpu_var(task_nohz_mode) = 0;
 	tick_nohz_restart_sched_tick();
 }
@@ -3838,6 +3839,17 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	acct_update_integrals(p);
 }
 
+void account_user_jiffies(struct task_struct *p, unsigned long count)
+{
+	cputime_t delta_cputime, delta_scaled;
+
+	if (count) {
+		delta_cputime = jiffies_to_cputime(count);
+		delta_scaled = cputime_to_scaled(count);
+		account_user_time(p, delta_cputime, delta_scaled);
+	}
+}
+
 /*
  * Account guest cpu time to a process.
  * @p: the process that the cpu time gets accounted to
@@ -3922,6 +3934,17 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	__account_system_time(p, cputime, cputime_scaled, target_cputime64);
 }
 
+void account_system_jiffies(struct task_struct *p, unsigned long count)
+{
+	cputime_t delta_cputime, delta_scaled;
+
+	if (count) {
+		delta_cputime = jiffies_to_cputime(count);
+		delta_scaled = cputime_to_scaled(count);
+		account_system_time(p, 0, delta_cputime, delta_scaled);
+	}
+}
+
 /*
  * Account for involuntary wait time.
  * @cputime: the cpu time spent in involuntary wait
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9e450d8..c3a8f26 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -764,6 +764,8 @@ int tick_nohz_adaptive_mode(void)
 
 static void tick_nohz_cpuset_stop_tick(int user)
 {
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
 	if (!cpuset_adaptive_nohz() || tick_nohz_adaptive_mode())
 		return;
 
@@ -771,6 +773,13 @@ static void tick_nohz_cpuset_stop_tick(int user)
 		__get_cpu_var(task_nohz_mode) = 1;
 		/* Nohz mode must be visible to wake_up_nohz_cpu() */
 		smp_wmb();
+
+		WARN_ON_ONCE(ts->saved_jiffies_whence != JIFFIES_SAVED_NONE);
+		ts->saved_jiffies = jiffies;
+		if (user)
+			ts->saved_jiffies_whence = JIFFIES_SAVED_USER;
+		else
+			ts->saved_jiffies_whence = JIFFIES_SAVED_SYS;
 	}
 }
 
@@ -792,6 +801,36 @@ static void tick_do_timer_check_handler(int cpu)
 	}
 }
 
+bool tick_nohz_account_tick(void)
+{
+	struct tick_sched *ts;
+	unsigned long delta_jiffies;
+
+	if (!tick_nohz_adaptive_mode())
+		return false;
+
+	ts = &__get_cpu_var(tick_cpu_sched);
+
+	delta_jiffies = jiffies - ts->saved_jiffies;
+	if (ts->saved_jiffies_whence == JIFFIES_SAVED_SYS)
+		account_system_jiffies(current, delta_jiffies);
+	else
+		account_user_jiffies(current, delta_jiffies);
+
+	ts->saved_jiffies = jiffies;
+
+	return true;
+}
+
+void tick_nohz_flush_current_times(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	tick_nohz_account_tick();
+
+	ts->saved_jiffies_whence = JIFFIES_SAVED_NONE;
+}
+
 #else
 
 static void tick_nohz_cpuset_stop_tick(int user) { }
diff --git a/kernel/timer.c b/kernel/timer.c
index 8cdbd48..db984ff 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1288,8 +1288,10 @@ void update_process_times(int user_tick)
 	struct task_struct *p = current;
 	int cpu = smp_processor_id();
 
-	/* Note: this timer irq context must be accounted for as well. */
-	account_process_tick(p, user_tick);
+	if (!tick_nohz_account_tick()) {
+		/* Note: this timer irq context must be accounted for as well. */
+		account_process_tick(p, user_tick);
+	}
 	run_local_timers();
 	rcu_check_callbacks(cpu, user_tick);
 	printk_tick();
-- 
1.7.5.4

