Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab0EJFyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:54:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:33870 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab0EJFya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:54:30 -0400
Date: Mon, 10 May 2010 05:54:01 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, arjan@linux.intel.com, riel@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: riel@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100509082523.284feab6@infradead.org>
References: <20100509082523.284feab6@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Intoduce get_cpu_iowait_time_us()
Message-ID: <tip-0224cf4c5ee0d7faec83956b8e21f7d89e3df3bd@git.kernel.org>
Git-Commit-ID: 0224cf4c5ee0d7faec83956b8e21f7d89e3df3bd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 May 2010 05:54:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0224cf4c5ee0d7faec83956b8e21f7d89e3df3bd
Gitweb:     http://git.kernel.org/tip/0224cf4c5ee0d7faec83956b8e21f7d89e3df3bd
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Sun, 9 May 2010 08:25:23 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 May 2010 19:35:27 +0200

sched: Intoduce get_cpu_iowait_time_us()

For the ondemand cpufreq governor, it is desired that the iowait
time is microaccounted in a similar way as idle time is.

This patch introduces the infrastructure to account and expose
this information via the get_cpu_iowait_time_us() function.

[akpm@linux-foundation.org: fix CONFIG_NO_HZ=n build]
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: davej@redhat.com
LKML-Reference: <20100509082523.284feab6@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/tick.h     |    4 ++++
 kernel/time/tick-sched.c |   28 ++++++++++++++++++++++++++++
 kernel/time/timer_list.c |    1 +
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 0343eed..b232ccc 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -42,6 +42,7 @@ enum tick_nohz_mode {
  * @idle_waketime:	Time when the idle was interrupted
  * @idle_exittime:	Time when the idle state was left
  * @idle_sleeptime:	Sum of the time slept in idle with sched tick stopped
+ * @iowait_sleeptime:	Sum of the time slept in idle with sched tick stopped, with IO outstanding
  * @sleep_length:	Duration of the current idle sleep
  * @do_timer_lst:	CPU was the last one doing do_timer before going idle
  */
@@ -60,6 +61,7 @@ struct tick_sched {
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
+	ktime_t				iowait_sleeptime;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
@@ -123,6 +125,7 @@ extern void tick_nohz_stop_sched_tick(int inidle);
 extern void tick_nohz_restart_sched_tick(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
+extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
 static inline void tick_nohz_stop_sched_tick(int inidle) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
@@ -133,6 +136,7 @@ static inline ktime_t tick_nohz_get_sleep_length(void)
 	return len;
 }
 static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
+static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !NO_HZ */
 
 #endif
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 50953f4..1d7b9bc 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -161,6 +161,8 @@ update_ts_time_stats(struct tick_sched *ts, ktime_t now, u64 *last_update_time)
 	if (ts->idle_active) {
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+		if (nr_iowait_cpu() > 0)
+			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
 		ts->idle_entrytime = now;
 	}
 
@@ -220,6 +222,32 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
+/*
+ * get_cpu_iowait_time_us - get the total iowait time of a cpu
+ * @cpu: CPU number to query
+ * @last_update_time: variable to store update time in
+ *
+ * Return the cummulative iowait time (since boot) for a given
+ * CPU, in microseconds.
+ *
+ * This time is measured via accounting rather than sampling,
+ * and is as accurate as ktime_get() is.
+ *
+ * This function returns -1 if NOHZ is not enabled.
+ */
+u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+
+	if (!tick_nohz_enabled)
+		return -1;
+
+	update_ts_time_stats(ts, ktime_get(), last_update_time);
+
+	return ktime_to_us(ts->iowait_sleeptime);
+}
+EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
+
 /**
  * tick_nohz_stop_sched_tick - stop the idle tick from the idle task
  *
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 1a4a7dd..ab8f5e3 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -176,6 +176,7 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 		P_ns(idle_waketime);
 		P_ns(idle_exittime);
 		P_ns(idle_sleeptime);
+		P_ns(iowait_sleeptime);
 		P(last_jiffies);
 		P(next_jiffies);
 		P_ns(idle_expires);
