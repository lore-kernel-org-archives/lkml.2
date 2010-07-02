Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab0GBHUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:20:39 -0400
Received: from www.tglx.de ([62.245.132.106]:36799 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850Ab0GBHU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:20:28 -0400
Date: Fri, 2 Jul 2010 09:20:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] scheduler fixes for 2.6.35
Message-ID: <alpine.LFD.2.00.1007020919120.4507@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

Thanks,

	tglx

------------------>
Peter Zijlstra (3):
      init, sched: Fix race between init and kthreadd
      init: Fix comment
      sched: Cure nr_iowait_cpu() users


 drivers/cpuidle/governors/menu.c |    4 ++--
 include/linux/sched.h            |    2 +-
 init/main.c                      |   12 ++++++++++++
 kernel/sched.c                   |    4 ++--
 kernel/time/tick-sched.c         |   16 ++++++++--------
 5 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 52ff8aa..1b12870 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -143,7 +143,7 @@ static inline int which_bucket(unsigned int duration)
 	 * This allows us to calculate
 	 * E(duration)|iowait
 	 */
-	if (nr_iowait_cpu())
+	if (nr_iowait_cpu(smp_processor_id()))
 		bucket = BUCKETS/2;
 
 	if (duration < 10)
@@ -175,7 +175,7 @@ static inline int performance_multiplier(void)
 	mult += 2 * get_loadavg();
 
 	/* for IO wait tasks (per cpu!) we add 5x each */
-	mult += 10 * nr_iowait_cpu();
+	mult += 10 * nr_iowait_cpu(smp_processor_id());
 
 	return mult;
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f118809..747fcae 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -139,7 +139,7 @@ extern int nr_processes(void);
 extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_iowait(void);
-extern unsigned long nr_iowait_cpu(void);
+extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
 
diff --git a/init/main.c b/init/main.c
index 3bdb152..1692df3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -422,18 +422,26 @@ static void __init setup_command_line(char *command_line)
  * gcc-3.4 accidentally inlines this function, so use noinline.
  */
 
+static __initdata DECLARE_COMPLETION(kthreadd_done);
+
 static noinline void __init_refok rest_init(void)
 	__releases(kernel_lock)
 {
 	int pid;
 
 	rcu_scheduler_starting();
+	/*
+	 * We need to spawn init first so that it obtains pid 1, however
+	 * the init task will end up wanting to create kthreads, which, if
+	 * we schedule it before we create kthreadd, will OOPS.
+	 */
 	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
 	rcu_read_lock();
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
 	rcu_read_unlock();
+	complete(&kthreadd_done);
 	unlock_kernel();
 
 	/*
@@ -855,6 +863,10 @@ static noinline int init_post(void)
 
 static int __init kernel_init(void * unused)
 {
+	/*
+	 * Wait until kthreadd is all set-up.
+	 */
+	wait_for_completion(&kthreadd_done);
 	lock_kernel();
 
 	/*
diff --git a/kernel/sched.c b/kernel/sched.c
index a24d6d5..f87abe3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2864,9 +2864,9 @@ unsigned long nr_iowait(void)
 	return sum;
 }
 
-unsigned long nr_iowait_cpu(void)
+unsigned long nr_iowait_cpu(int cpu)
 {
-	struct rq *this = this_rq();
+	struct rq *this = cpu_rq(cpu);
 	return atomic_read(&this->nr_iowait);
 }
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 1d7b9bc..1a6f828 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -154,14 +154,14 @@ static void tick_nohz_update_jiffies(ktime_t now)
  * Updates the per cpu time idle statistics counters
  */
 static void
-update_ts_time_stats(struct tick_sched *ts, ktime_t now, u64 *last_update_time)
+update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now, u64 *last_update_time)
 {
 	ktime_t delta;
 
 	if (ts->idle_active) {
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-		if (nr_iowait_cpu() > 0)
+		if (nr_iowait_cpu(cpu) > 0)
 			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
 		ts->idle_entrytime = now;
 	}
@@ -175,19 +175,19 @@ static void tick_nohz_stop_idle(int cpu, ktime_t now)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 
-	update_ts_time_stats(ts, now, NULL);
+	update_ts_time_stats(cpu, ts, now, NULL);
 	ts->idle_active = 0;
 
 	sched_clock_idle_wakeup_event(0);
 }
 
-static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
+static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 {
 	ktime_t now;
 
 	now = ktime_get();
 
-	update_ts_time_stats(ts, now, NULL);
+	update_ts_time_stats(cpu, ts, now, NULL);
 
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
@@ -216,7 +216,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 	if (!tick_nohz_enabled)
 		return -1;
 
-	update_ts_time_stats(ts, ktime_get(), last_update_time);
+	update_ts_time_stats(cpu, ts, ktime_get(), last_update_time);
 
 	return ktime_to_us(ts->idle_sleeptime);
 }
@@ -242,7 +242,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 	if (!tick_nohz_enabled)
 		return -1;
 
-	update_ts_time_stats(ts, ktime_get(), last_update_time);
+	update_ts_time_stats(cpu, ts, ktime_get(), last_update_time);
 
 	return ktime_to_us(ts->iowait_sleeptime);
 }
@@ -284,7 +284,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	 */
 	ts->inidle = 1;
 
-	now = tick_nohz_start_idle(ts);
+	now = tick_nohz_start_idle(cpu, ts);
 
 	/*
 	 * If this cpu is offline and it is the one which updates
