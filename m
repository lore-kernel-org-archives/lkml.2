Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380Ab2IGOb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:31:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46536 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933283Ab2IGObW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:31:22 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com
Subject: [PATCH 2/3] perf: add sysctl control to adjust multiplexing interval
Date: Fri,  7 Sep 2012 16:29:28 +0200
Message-Id: <1347028169-1983-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347028169-1983-1-git-send-email-eranian@google.com>
References: <1347028169-1983-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add /proc/sys/kernel/perf_event_mux_interval_ms
entry to adjust the multiplexing period.

Unit is milliseconds.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h |    5 +++++
 kernel/events/core.c       |   43 ++++++++++++++++++++++++++++++++++++-------
 kernel/sysctl.c            |    8 ++++++++
 3 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index cc5e2cd..21c3bb0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1297,11 +1297,16 @@ static inline void perf_callchain_store(struct perf_callchain_entry *entry, u64
 extern int sysctl_perf_event_paranoid;
 extern int sysctl_perf_event_mlock;
 extern int sysctl_perf_event_sample_rate;
+extern int sysctl_perf_event_mux_interval_ms;
 
 extern int perf_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
+extern int perf_proc_mux_interval_ms_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
 static inline bool perf_paranoid_tracepoint_raw(void)
 {
 	return sysctl_perf_event_paranoid > -1;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index ab4ef10..fd53509 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -144,6 +144,13 @@ static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
 
+/*
+ * set default to be dependent on timer tick just
+ * like original code
+ */
+#define DEFAULT_MUX_INTERVAL_MS (1000 / HZ)
+static ktime_t perf_cpu_hrtimer_interval; /* mux interval in ktime_t */
+
 static LIST_HEAD(pmus);
 static DEFINE_MUTEX(pmus_lock);
 static struct srcu_struct pmus_srcu;
@@ -174,6 +181,10 @@ int sysctl_perf_event_mlock __read_mostly = 512 + (PAGE_SIZE / 1024); /* 'free'
  */
 #define DEFAULT_MAX_SAMPLE_RATE 100000
 int sysctl_perf_event_sample_rate __read_mostly = DEFAULT_MAX_SAMPLE_RATE;
+int sysctl_perf_event_mux_interval_ms __read_mostly = DEFAULT_MUX_INTERVAL_MS;
+
+static DEFINE_PER_CPU(struct list_head, rotation_list);
+
 static int max_samples_per_tick __read_mostly =
 	DIV_ROUND_UP(DEFAULT_MAX_SAMPLE_RATE, HZ);
 
@@ -193,6 +204,25 @@ int perf_proc_update_handler(struct ctl_table *table, int write,
 	return 0;
 }
 
+int perf_proc_mux_interval_ms_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (ret || !write)
+		return ret;
+
+	if (sysctl_perf_event_mux_interval_ms < 1)
+		return -EINVAL;
+
+	perf_cpu_hrtimer_interval =
+		ns_to_ktime(sysctl_perf_event_mux_interval_ms * NSEC_PER_MSEC);
+
+	return 0;
+}
+
 static atomic64_t perf_event_id;
 
 static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
@@ -636,11 +666,6 @@ perf_cgroup_mark_enabled(struct perf_event *event,
 }
 #endif
 
-/*
- * set default to be dependent on timer tick just
- * like original code
- */
-#define PERF_CPU_HRTIMER (1000 / HZ)
 static enum hrtimer_restart perf_cpu_hrtimer_handler(struct hrtimer *hr)
 {
 	struct perf_cpu_hrtimer *h = &__get_cpu_var(perf_cpu_hrtimer);
@@ -673,7 +698,7 @@ static enum hrtimer_restart perf_cpu_hrtimer_handler(struct hrtimer *hr)
 	 * arm timer if needed
 	 */
 	if (rotations) {
-		hrtimer_forward_now(hr, ns_to_ktime(PERF_CPU_HRTIMER));
+		hrtimer_forward_now(hr, perf_cpu_hrtimer_interval);
 		ret = HRTIMER_RESTART;
 	}
 end:
@@ -721,7 +746,7 @@ static void perf_cpu_hrtimer_restart(void)
 	h->active = 1;
 
 	if (!hrtimer_callback_running(hr))
-		__hrtimer_start_range_ns(hr, ns_to_ktime(PERF_CPU_HRTIMER),
+		__hrtimer_start_range_ns(hr, perf_cpu_hrtimer_interval,
 					 0, HRTIMER_MODE_REL_PINNED, 0);
 }
 
@@ -7517,6 +7542,10 @@ void __init perf_event_init(void)
 	/* do not patch jump label more than once per second */
 	jump_label_rate_limit(&perf_sched_events, HZ);
 
+	/* default multiplexing interval */
+	perf_cpu_hrtimer_interval =
+		ns_to_ktime(DEFAULT_MUX_INTERVAL_MS * NSEC_PER_MSEC);
+
 	/*
 	 * Build time assertion that we keep the data_head at the intended
 	 * location.  IOW, validation we got the __reserved[] size right.
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 81c7b1a..0d7b2c8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -981,6 +981,14 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= perf_proc_update_handler,
 	},
+	{
+		.procname	= "perf_event_mux_interval_ms",
+		.data		= &sysctl_perf_event_mux_interval_ms,
+		.maxlen		= sizeof(sysctl_perf_event_mux_interval_ms),
+		.mode		= 0644,
+		.proc_handler	= perf_proc_mux_interval_ms_handler,
+	},
+
 #endif
 #ifdef CONFIG_KMEMCHECK
 	{
-- 
1.7.5.4

