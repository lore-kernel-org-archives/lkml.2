Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021Ab2EWVpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:45:01 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47008 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994Ab2EWVo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:44:58 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com
Subject: [PATCH 10/15] sched: add latency tracing for -deadline tasks.
Date: Wed, 23 May 2012 23:42:50 +0200
Message-Id: <1337809375-24295-11-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
References: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dario Faggioli <raistlin@linux.it>

It is very likely that systems that wants/needs to use the new
SCHED_DEADLINE policy also want to have the scheduling latency of
the -deadline tasks under control.

For this reason a new version of the scheduling wakeup latency,
called "wakeup_dl", is introduced.

As a consequence of applying this patch there will be three wakeup
latency tracer:
 * "wakeup", that deals with all tasks in the system;
 * "wakeup_rt", that deals with -rt and -deadline tasks only;
 * "wakeup_dl", that deals with -deadline tasks only.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 kernel/trace/trace_sched_wakeup.c |   44 +++++++++++++++++++++++++++++++++----
 kernel/trace/trace_selftest.c     |   30 +++++++++++++++----------
 2 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index ff791ea..e37da43 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -27,6 +27,7 @@ static int			wakeup_cpu;
 static int			wakeup_current_cpu;
 static unsigned			wakeup_prio = -1;
 static int			wakeup_rt;
+static int			wakeup_dl;
 
 static arch_spinlock_t wakeup_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
@@ -428,9 +429,17 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 	tracing_record_cmdline(p);
 	tracing_record_cmdline(current);
 
-	if ((wakeup_rt && !rt_task(p)) ||
-			p->prio >= wakeup_prio ||
-			p->prio >= current->prio)
+	/*
+	 * Semantic is like this:
+	 *  - wakeup tracer handles all tasks in the system, independently
+	 *    from their scheduling class;
+	 *  - wakeup_rt tracer handles tasks belonging to sched_dl and
+	 *    sched_rt class;
+	 *  - wakeup_dl handles tasks belonging to sched_dl class only.
+	 */
+	if ((wakeup_dl && !dl_task(p)) ||
+	    (wakeup_rt && !dl_task(p) && !rt_task(p)) ||
+	    (p->prio >= wakeup_prio || p->prio >= current->prio))
 		return;
 
 	pc = preempt_count();
@@ -442,7 +451,7 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 	arch_spin_lock(&wakeup_lock);
 
 	/* check for races. */
-	if (!tracer_enabled || p->prio >= wakeup_prio)
+	if (!tracer_enabled || (!dl_task(p) && p->prio >= wakeup_prio))
 		goto out_locked;
 
 	/* reset the trace */
@@ -550,16 +559,25 @@ static int __wakeup_tracer_init(struct trace_array *tr)
 
 static int wakeup_tracer_init(struct trace_array *tr)
 {
+	wakeup_dl = 0;
 	wakeup_rt = 0;
 	return __wakeup_tracer_init(tr);
 }
 
 static int wakeup_rt_tracer_init(struct trace_array *tr)
 {
+	wakeup_dl = 0;
 	wakeup_rt = 1;
 	return __wakeup_tracer_init(tr);
 }
 
+static int wakeup_dl_tracer_init(struct trace_array *tr)
+{
+	wakeup_dl = 1;
+	wakeup_rt = 0;
+	return __wakeup_tracer_init(tr);
+}
+
 static void wakeup_tracer_reset(struct trace_array *tr)
 {
 	stop_wakeup_tracer(tr);
@@ -622,6 +640,20 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 	.use_max_tr	= 1,
 };
 
+static struct tracer wakeup_dl_tracer __read_mostly =
+{
+	.name		= "wakeup_dl",
+	.init		= wakeup_dl_tracer_init,
+	.reset		= wakeup_tracer_reset,
+	.start		= wakeup_tracer_start,
+	.stop		= wakeup_tracer_stop,
+	.wait_pipe	= poll_wait_pipe,
+	.print_max	= 1,
+#ifdef CONFIG_FTRACE_SELFTEST
+	.selftest    = trace_selftest_startup_wakeup,
+#endif
+};
+
 __init static int init_wakeup_tracer(void)
 {
 	int ret;
@@ -634,6 +666,10 @@ __init static int init_wakeup_tracer(void)
 	if (ret)
 		return ret;
 
+	ret = register_tracer(&wakeup_dl_tracer);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 device_initcall(init_wakeup_tracer);
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 288541f..849063e 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -765,11 +765,17 @@ trace_selftest_startup_nop(struct tracer *trace, struct trace_array *tr)
 #ifdef CONFIG_SCHED_TRACER
 static int trace_wakeup_test_thread(void *data)
 {
-	/* Make this a RT thread, doesn't need to be too high */
-	static const struct sched_param param = { .sched_priority = 5 };
+	/* Make this a -deadline thread */
+	struct sched_param2 paramx = {
+		.sched_priority = 0,
+		.sched_runtime = 100000ULL,
+		.sched_deadline = 10000000ULL,
+		.sched_period = 10000000ULL
+		.sched_flags = 0
+	};
 	struct completion *x = data;
 
-	sched_setscheduler(current, SCHED_FIFO, &param);
+	sched_setscheduler2(current, SCHED_DEADLINE, &paramx);
 
 	/* Make it know we have a new prio */
 	complete(x);
@@ -781,8 +787,8 @@ static int trace_wakeup_test_thread(void *data)
 	/* we are awake, now wait to disappear */
 	while (!kthread_should_stop()) {
 		/*
-		 * This is an RT task, do short sleeps to let
-		 * others run.
+		 * This will likely be the system top priority
+		 * task, do short sleeps to let others run.
 		 */
 		msleep(100);
 	}
@@ -795,21 +801,21 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 {
 	unsigned long save_max = tracing_max_latency;
 	struct task_struct *p;
-	struct completion isrt;
+	struct completion is_ready;
 	unsigned long count;
 	int ret;
 
-	init_completion(&isrt);
+	init_completion(&is_ready);
 
-	/* create a high prio thread */
-	p = kthread_run(trace_wakeup_test_thread, &isrt, "ftrace-test");
+	/* create a -deadline thread */
+	p = kthread_run(trace_wakeup_test_thread, &is_ready, "ftrace-test");
 	if (IS_ERR(p)) {
 		printk(KERN_CONT "Failed to create ftrace wakeup test thread ");
 		return -1;
 	}
 
-	/* make sure the thread is running at an RT prio */
-	wait_for_completion(&isrt);
+	/* make sure the thread is running at -deadline policy */
+	wait_for_completion(&is_ready);
 
 	/* start the tracing */
 	ret = tracer_init(trace, tr);
@@ -821,7 +827,7 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 	/* reset the max latency */
 	tracing_max_latency = 0;
 
-	/* sleep to let the RT thread sleep too */
+	/* sleep to let the thread sleep too */
 	msleep(100);
 
 	/*
-- 
1.7.9.5

