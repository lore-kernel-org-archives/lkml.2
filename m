Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1AZMPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:15:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:45376 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab1AZMPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:15:11 -0500
Date: Wed, 26 Jan 2011 12:14:43 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Untangle cpu-load and timekeeping code
Message-ID: <tip-18a57c3b43781ea83c3bb21c3add84ba890d5fb3@git.kernel.org>
Git-Commit-ID: 18a57c3b43781ea83c3bb21c3add84ba890d5fb3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 12:14:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18a57c3b43781ea83c3bb21c3add84ba890d5fb3
Gitweb:     http://git.kernel.org/tip/18a57c3b43781ea83c3bb21c3add84ba890d5fb3
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 25 Jan 2011 11:30:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 12:33:23 +0100

sched: Untangle cpu-load and timekeeping code

Remove the calc_global_load() call from the timekeeping code and make
it local to the scheduler.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 --
 kernel/sched.c        |   22 ++++++++++++++++------
 kernel/timer.c        |    1 -
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0542774..738ec15 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -142,8 +142,6 @@ extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
 
-extern void calc_global_load(unsigned long ticks);
-
 extern unsigned long get_parent_ip(unsigned long addr);
 
 struct seq_file;
diff --git a/kernel/sched.c b/kernel/sched.c
index 78fa753..3fc5749 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3192,7 +3192,7 @@ calc_load_n(unsigned long load, unsigned long exp,
  * Once we've updated the global active value, we need to apply the exponential
  * weights adjusted to the number of cycles missed.
  */
-static void calc_global_nohz(unsigned long ticks)
+static void calc_global_nohz(void)
 {
 	long delta, active, n;
 
@@ -3212,8 +3212,9 @@ static void calc_global_nohz(unsigned long ticks)
 	/*
 	 * If we were idle for multiple load cycles, apply them.
 	 */
-	if (ticks >= LOAD_FREQ) {
-		n = ticks / LOAD_FREQ;
+	delta = jiffies - calc_load_update - 10;
+	if (delta >= LOAD_FREQ) {
+		n = delta / LOAD_FREQ;
 
 		active = atomic_long_read(&calc_load_tasks);
 		active = active > 0 ? active * FIXED_1 : 0;
@@ -3246,7 +3247,7 @@ static inline long calc_load_fold_idle(void)
 	return 0;
 }
 
-static void calc_global_nohz(unsigned long ticks)
+static void calc_global_nohz(void)
 {
 }
 #endif
@@ -3266,15 +3267,20 @@ void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
 	loads[2] = (avenrun[2] + offset) << shift;
 }
 
+static void calc_global_load(unsigned long __data);
+
+static struct timer_list global_load_timer =
+	TIMER_DEFERRED_INITIALIZER(calc_global_load, 0, 0);
+
 /*
  * calc_load - update the avenrun load estimates 10 ticks after the
  * CPUs have updated calc_load_tasks.
  */
-void calc_global_load(unsigned long ticks)
+static void calc_global_load(unsigned long __data)
 {
 	long active;
 
-	calc_global_nohz(ticks);
+	calc_global_nohz();
 
 	if (time_before(jiffies, calc_load_update + 10))
 		return;
@@ -3287,6 +3293,7 @@ void calc_global_load(unsigned long ticks)
 	avenrun[2] = calc_load(avenrun[2], EXP_15, active);
 
 	calc_load_update += LOAD_FREQ;
+	mod_timer(&global_load_timer, calc_load_update + 10);
 }
 
 /*
@@ -7898,11 +7905,13 @@ void __init sched_init_smp(void)
 	free_cpumask_var(non_isolated_cpus);
 
 	init_sched_rt_class();
+	mod_timer(&global_load_timer, calc_load_update + 10);
 }
 #else
 void __init sched_init_smp(void)
 {
 	sched_init_granularity();
+	mod_timer(&global_load_timer, calc_load_update + 10);
 }
 #endif /* CONFIG_SMP */
 
@@ -8172,6 +8181,7 @@ void __init sched_init(void)
 	init_idle(current, smp_processor_id());
 
 	calc_load_update = jiffies + LOAD_FREQ;
+	set_timer_slack(&global_load_timer, 0);
 
 	/*
 	 * During early bootup we pretend to be a normal task:
diff --git a/kernel/timer.c b/kernel/timer.c
index 43ca993..afdc13b 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1303,7 +1303,6 @@ void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_wall_time();
-	calc_global_load(ticks);
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM
