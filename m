Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008Ab0EDMjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:39:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:51804 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758726Ab0EDMjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:39:44 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/12] perf: move sched perf functions on top of tracepoints
Date: Tue,  4 May 2010 14:38:44 +0200
Message-Id: <1272976724-14312-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1272976724-14312-1-git-send-email-tj@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 12:38:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all sched perf functions are colocated with tracepoints,
those perf functions can be moved on top of tracepoints instead of
being called directly.  After this patch, if both perf and tracepoints
are enabled, the four sched perf macros become noop and the backend
functions are defined static and registered as trace point probes on
demand.

The enable part is relatively simple.  Perf functions are registered
as tp probes.  sched_in is registered the last so that contexts don't
get scheduled in without all the functions active.

Disable is a bit more involved.  First, all probes other than
sched_out are unregistered and drained and online cpus are recorded in
a cpumask.  With zero nr_events, sched_out always switches out task
context and records that there's no task context for the cpu.  A
periodic timer is setup to watch the cpumask and when it sees that all
cpus have switched out their contexts, the sched_out probe is
unregistered.

The timer trick is necessary because unregistering a probe requires
thread context while neither workqueue nor tasklet can be directly
used from sched_out which is called under rq lock.

This results in reduced overhead when both tracepoints and perf are
enabled and opens up possibilities for further optimization.  Although
the sched functions are the frequently called ones, other perf
functions can also be converted to use TPs in similar manner.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |    2 +-
 kernel/perf_event.c        |  152 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 152 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0ad898b..66f2cba 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -745,7 +745,7 @@ struct perf_output_handle {
 	int				locked;
 };
 
-#ifdef CONFIG_PERF_EVENTS
+#if defined(CONFIG_PERF_EVENTS) && !defined(CONFIG_TRACEPOINTS)
 
 extern void perf_event_task_migrate_fn(struct task_struct *task, int new_cpu);
 extern void perf_event_task_sched_in_fn(struct task_struct *task);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 1c83dc6..1424aac 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -17,6 +17,7 @@
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/sysfs.h>
+#include <linux/timer.h>
 #include <linux/dcache.h>
 #include <linux/percpu.h>
 #include <linux/ptrace.h>
@@ -26,12 +27,15 @@
 #include <linux/rculist.h>
 #include <linux/uaccess.h>
 #include <linux/syscalls.h>
+#include <linux/workqueue.h>
 #include <linux/anon_inodes.h>
 #include <linux/kernel_stat.h>
 #include <linux/perf_event.h>
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
 
+#include <trace/events/sched.h>
+
 #include <asm/irq_regs.h>
 
 /*
@@ -76,6 +80,151 @@ static DEFINE_SPINLOCK(perf_resource_lock);
  */
 static DEFINE_MUTEX(perf_online_mutex);
 
+#ifdef CONFIG_TRACEPOINTS
+/*
+ * Tracepoints are enabled.  Some perf event functions (currently the
+ * sched related ones) are called via tracepoints.  The functions are
+ * registered to respective tracepoints when the first event is
+ * created and start to unregister after the last event is destroyed.
+ */
+
+/* won't be called directly, make them static and declare them */
+#define PE_STATIC static
+
+static void perf_event_task_migrate_fn(struct task_struct *task, int new_cpu);
+static void perf_event_task_sched_in_fn(struct task_struct *task);
+static void perf_event_task_sched_out_fn(struct rq *rq,
+					 struct task_struct *task,
+					 struct task_struct *next);
+static void perf_event_task_tick_fn(struct task_struct *task);
+
+/*
+ * After the last event is destroyed, all event functions except for
+ * sched_out are disabled.  With zero nr_events, sched_out will always
+ * switch out context and a timer is setup to periodically watch the
+ * perf_online_mask.  When all the cpus have seen NULL context at
+ * least once, the timer schedules perf_offline_work to unregister
+ * sched_out.
+ *
+ * The offline timer is necessary because sched_out is called under rq
+ * lock and no async mechanism other than SOFTIRQ can be scheduled
+ * from under there.  Although slightly convoluted, it's not really
+ * bad.  There's nothing urgent about unregistering sched_out anyway.
+ */
+static cpumask_t perf_online_mask;
+
+static void perf_offline_work_fn(struct work_struct *work)
+{
+	unregister_trace_sched_switch(perf_event_task_sched_out_fn);
+}
+static DECLARE_WORK(perf_offline_work, perf_offline_work_fn);
+
+static void perf_offline_timer_fn(unsigned long data);
+static DEFINE_TIMER(perf_offline_timer, perf_offline_timer_fn, 0, 0);
+
+static void perf_offline_timer_fn(unsigned long data)
+{
+	/*
+	 * We don't care about CPUs which have come up inbetween as
+	 * they would never have task context set, but need to
+	 * explicity ignore CPUs which went down inbetween.  Consider
+	 * draining done if there's no CPU left which was online when
+	 * nr_events hit zero and has stayed online.
+	 */
+	if (cpumask_any_and(&perf_online_mask, cpu_online_mask) >= nr_cpu_ids)
+		schedule_work(&perf_offline_work);
+	else
+		mod_timer(&perf_offline_timer, jiffies + HZ);
+}
+
+static int perf_inc_nr_events(void)
+{
+	int err = 0;
+
+	mutex_lock(&perf_online_mutex);
+
+	if (nr_events++)
+		goto out;
+
+	/* make sure nr_events > 0 is visible and cancel offline timer & work */
+	synchronize_sched();
+	del_timer_sync(&perf_offline_timer);
+	cancel_work_sync(&perf_offline_work);
+
+	/* first event, register probe functions */
+	err = register_trace_sched_migrate_task(perf_event_task_migrate_fn);
+	if (err && err != -EEXIST)
+		goto out;
+	err = register_trace_sched_tick(perf_event_task_tick_fn);
+	if (err && err != -EEXIST)
+		goto out;
+	err = register_trace_sched_switch(perf_event_task_sched_out_fn);
+	if (err && err != -EEXIST)
+		goto out;
+	/*
+	 * Register sched_in last so that contexts don't get scheduled
+	 * in with events partially enabled.  There already are enough
+	 * barriers to make this ordering effective.
+	 */
+	err = register_trace_sched_switch_in(perf_event_task_sched_in_fn);
+out:
+	if (err && err != -EEXIST) {
+		unregister_trace_sched_migrate_task(perf_event_task_migrate_fn);
+		unregister_trace_sched_tick(perf_event_task_tick_fn);
+		unregister_trace_sched_switch(perf_event_task_sched_out_fn);
+		nr_events--;
+	}
+	mutex_unlock(&perf_online_mutex);
+	return err;
+}
+
+static void perf_dec_nr_events(void)
+{
+	mutex_lock(&perf_online_mutex);
+	if (nr_events > 1) {
+		nr_events--;
+		goto out;
+	}
+
+	/* unregister anything other than sched_out */
+	unregister_trace_sched_migrate_task(perf_event_task_migrate_fn);
+	unregister_trace_sched_tick(perf_event_task_tick_fn);
+	unregister_trace_sched_switch_in(perf_event_task_sched_in_fn);
+
+	/* make sure probe functions are done */
+	synchronize_sched();
+
+	/*
+	 * Drain is complete when sched_out has seen NULL task context
+	 * at least once on all currently online CPUs after nr_events
+	 * hits zero.
+	 */
+	get_online_cpus();
+	cpumask_copy(&perf_online_mask, cpu_online_mask);
+	put_online_cpus();
+	smp_wmb();	/* online mask must be visible before zero nr_events */
+	nr_events--;	/* gogogo */
+
+	/* kick offline timer */
+	mod_timer(&perf_offline_timer, jiffies + HZ);
+out:
+	mutex_unlock(&perf_online_mutex);
+}
+
+static void perf_task_sched_out_done(struct perf_event_context *ctx)
+{
+	if (likely(nr_events) || ctx)
+		return;
+
+	smp_mb__before_clear_bit();	/* matches smp_wmb() in dec */
+	cpumask_clear_cpu(smp_processor_id(), &perf_online_mask);
+}
+
+#else
+/*
+ * Tracepoints not available.  Event functions are declared external
+ * and will be called directly.
+ */
 #define PE_STATIC
 
 static int perf_inc_nr_events(void)
@@ -96,6 +245,7 @@ static void perf_dec_nr_events(void)
 static void perf_task_sched_out_done(struct perf_event_context *ctx)
 {
 }
+#endif
 
 /*
  * Architecture provided APIs - weak aliases:
@@ -1254,7 +1404,7 @@ PE_STATIC void perf_event_task_sched_out_fn(struct rq *rq,
 	if (likely(!ctx || !cpuctx->task_ctx))
 		goto out;
 
-	if (perf_event_switch_clones(cpuctx, ctx, task, next))
+	if (nr_events && perf_event_switch_clones(cpuctx, ctx, task, next))
 		goto out;
 
 	ctx_sched_out(ctx, cpuctx, EVENT_ALL);
-- 
1.6.4.2

