Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab0IHMaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 08:30:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:33881 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856Ab0IHM3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 08:29:47 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org
Cc: peterz@infradead.org, Sven-Thorsten Dietrich <sdietrich@novell.com>,
        Michael Galbraith <MGalbraith@novell.com>,
        Jan Blunck <jblunck@suse.de>
Subject: [RFC 4/4] ftrace: Add argument to tick start/stop tracing
Date: Wed,  8 Sep 2010 14:29:24 +0200
Message-Id: <1283948964-6418-5-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1283948964-6418-1-git-send-email-jblunck@suse.de>
References: <1283948964-6418-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch it is possible to differentiate the idle tick stop from
the SCHED_FIFO tick stop.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 include/linux/tick.h         |   14 ++++++++++++--
 include/trace/events/sched.h |   22 ++++++++++++++--------
 kernel/sched_rt.c            |    4 ++--
 kernel/softirq.c             |    2 +-
 kernel/time/tick-sched.c     |   20 +++++++++++---------
 5 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b232ccc..37b3d78 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -121,13 +121,23 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
 # ifdef CONFIG_NO_HZ
-extern void tick_nohz_stop_sched_tick(int inidle);
-extern void tick_nohz_restart_sched_tick(void);
+extern void __tick_nohz_stop_sched_tick(int inidle, int insched);
+static inline void tick_nohz_stop_sched_tick(int inidle)
+{
+	__tick_nohz_stop_sched_tick(inidle, 0);
+}
+extern void __tick_nohz_restart_sched_tick(int insched);
+static inline void tick_nohz_restart_sched_tick(void)
+{
+	__tick_nohz_restart_sched_tick(0);
+}
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
+static inline void __tick_nohz_stop_sched_tick(int inidle, int insched) { }
 static inline void tick_nohz_stop_sched_tick(int inidle) { }
+static inline void __tick_nohz_restart_sched_tick(int insched) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
 static inline ktime_t tick_nohz_get_sleep_length(void)
 {
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 36385b6..fd4307e 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -382,41 +382,47 @@ TRACE_EVENT(sched_stat_runtime,
 
 TRACE_EVENT(sched_tick_start,
 
-	TP_PROTO(ktime_t *now),
+	TP_PROTO(ktime_t *now, int sched_rt),
 
-	TP_ARGS(now),
+	TP_ARGS(now, sched_rt),
 
 	TP_STRUCT__entry(
 		__field(s64, tv64)
+		__field(int, sched_rt)
 		),
 
 	TP_fast_assign(
 		__entry->tv64 = now->tv64;
+		__entry->sched_rt = sched_rt;
 		),
-	TP_printk("now=%ld",
-		(long)__entry->tv64)
+	TP_printk("now=%ld%s",
+		(long)__entry->tv64,
+		__entry->sched_rt ? ", SCHED_FIFO" : "")
 
 );
 
 TRACE_EVENT(sched_tick_stop,
 
-	TP_PROTO(ktime_t *expires, int idle),
+	TP_PROTO(ktime_t *expires, int idle, int sched_rt),
 
-	TP_ARGS(expires, idle),
+	TP_ARGS(expires, idle, sched_rt),
 
 	TP_STRUCT__entry(
 		__field(s64, tv64)
 		__field(int, idle)
+		__field(int, sched_rt)
 		),
 
 	TP_fast_assign(
 		__entry->tv64 = expires->tv64;
 		__entry->idle = idle;
+		__entry->sched_rt = sched_rt;
 		),
-	TP_printk("idle=%d, expires=%ld%s",
+	TP_printk("idle=%d, expires=%ld%s%s",
 		__entry->idle,
 		(long)__entry->tv64,
-		(__entry->tv64 == KTIME_MAX) ? " (KTIME_MAX)" : "" )
+		(__entry->tv64 == KTIME_MAX) ? " (KTIME_MAX)" : "",
+		__entry->sched_rt ? ", SCHED_FIFO" : "" )
 
 );
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 3879ca1..c9386da 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1486,7 +1486,7 @@ static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 	/* Enable sched_tick again before we schedule */
 	if (unlikely(rt_task(prev)) && !(prev->flags & PF_KTHREAD) &&
 		(prev->policy == SCHED_FIFO)) {
-		tick_nohz_restart_sched_tick();
+		__tick_nohz_restart_sched_tick(1);
 
 		/* Disable tick in post_schedule if we don't switch */
 		rq->post_schedule = 1;
@@ -1502,7 +1502,7 @@ static void post_schedule_rt(struct rq *rq)
 	    unlikely(!local_softirq_pending()) &&
 	    !(rq->curr->flags & PF_KTHREAD) &&
 	    (rq->curr->policy == SCHED_FIFO))
-		tick_nohz_stop_sched_tick(1);
+		__tick_nohz_stop_sched_tick(1, 1);
 }
 
 /*
diff --git a/kernel/softirq.c b/kernel/softirq.c
index ff05f6a..f0973be 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -311,7 +311,7 @@ void irq_exit(void)
 	/* Disable tick if the current task is FIFO */
 	if (unlikely(rt_task(current) && !(current->flags & PF_KTHREAD) &&
 			current->policy == SCHED_FIFO))
-		tick_nohz_stop_sched_tick(1);
+		__tick_nohz_stop_sched_tick(1, 1);
 #endif
 	preempt_enable_no_resched();
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 567110d..2a3bd0a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -257,7 +257,7 @@ EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
  * Called either from the idle loop or from irq_exit() when an idle period was
  * just interrupted by an interrupt which did not cause a reschedule.
  */
-void tick_nohz_stop_sched_tick(int inidle)
+void __tick_nohz_stop_sched_tick(int inidle, int insched)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
 	struct tick_sched *ts;
@@ -432,7 +432,8 @@ void tick_nohz_stop_sched_tick(int inidle)
 		 */
 		if (unlikely(expires.tv64 == KTIME_MAX)) {
 			if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
-				trace_sched_tick_stop(&expires, inidle);
+				trace_sched_tick_stop(&expires, inidle,
+						insched);
 				hrtimer_cancel(&ts->sched_timer);
 			}
 			goto out;
@@ -443,11 +444,12 @@ void tick_nohz_stop_sched_tick(int inidle)
 				      HRTIMER_MODE_ABS_PINNED);
 			/* Check, if the timer was already in the past */
 			if (hrtimer_active(&ts->sched_timer)) {
-				trace_sched_tick_stop(&expires, inidle);
+				trace_sched_tick_stop(&expires, inidle,
+						insched);
 				goto out;
 			}
 		} else if (!tick_program_event(expires, 0)) {
-			trace_sched_tick_stop(&expires, inidle);
+			trace_sched_tick_stop(&expires, inidle, insched);
 			goto out;
 		}
 
@@ -480,7 +482,7 @@ ktime_t tick_nohz_get_sleep_length(void)
 	return ts->sleep_length;
 }
 
-static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
+static void tick_nohz_restart(struct tick_sched *ts, ktime_t now, int insched)
 {
 	hrtimer_cancel(&ts->sched_timer);
 	hrtimer_set_expires(&ts->sched_timer, ts->idle_tick);
@@ -505,7 +507,7 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 		now = ktime_get();
 	}
 
-	trace_sched_tick_start(&now);
+	trace_sched_tick_start(&now, insched);
 }
 
 /**
@@ -513,7 +515,7 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
  *
  * Restart the idle tick when the CPU is woken up from idle
  */
-void tick_nohz_restart_sched_tick(void)
+void __tick_nohz_restart_sched_tick(int insched)
 {
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
@@ -566,7 +568,7 @@ void tick_nohz_restart_sched_tick(void)
 	ts->tick_stopped  = 0;
 	ts->idle_exittime = now;
 
-	tick_nohz_restart(ts, now);
+	tick_nohz_restart(ts, now, insched);
 
 	local_irq_restore(flags);
 }
@@ -691,7 +693,7 @@ static void tick_nohz_kick_tick(int cpu, ktime_t now)
 	if (delta.tv64 <= tick_period.tv64)
 		return;
 
-	tick_nohz_restart(ts, now);
+	tick_nohz_restart(ts, now, 0);
 #endif
 }
 
-- 
1.6.4.2

