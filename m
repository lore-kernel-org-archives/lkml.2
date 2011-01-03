Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab1ACRVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:21:21 -0500
Received: from smtp-out.google.com ([216.239.44.51]:61122 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab1ACRVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:21:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=s3QvEICA9n8SV/QWWosGsrW2SbGjhMUqnVKS3Cn9kiMneIbEeisYgWm9A52Td7FyCd
         x+fFzrNs/Q3G2QFQJLdg==
Message-ID: <4d22058b.cdace30a.4657.ffff95b1@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 3 Jan 2011 18:20:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Subject: [PATCH 1/5] perf_events: move code around to prepare for cgroup (v7)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In particular this patch move perf_event_exit_task() before
cgroup_exit() to allow for cgroup support. The cgroup_exit()
function detaches the cgroups attached to a task.

Other movements include hoisting some definitions and inlines
at the top of perf_event.c

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/kernel/exit.c b/kernel/exit.c
index 676149a..8cb8904 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -994,6 +994,15 @@ NORET_TYPE void do_exit(long code)
 	exit_fs(tsk);
 	check_stack_usage();
 	exit_thread();
+
+	/*
+	 * Flush inherited counters to the parent - before the parent
+	 * gets woken up by child-exit notifications.
+	 *
+	 * because of cgroup mode, must be called before cgroup_exit()
+	 */
+	perf_event_exit_task(tsk);
+
 	cgroup_exit(tsk, 1);
 
 	if (group_dead)
@@ -1007,11 +1016,6 @@ NORET_TYPE void do_exit(long code)
 	 * FIXME: do that only when needed, using sched_exit tracepoint
 	 */
 	flush_ptrace_hw_breakpoint(tsk);
-	/*
-	 * Flush inherited counters to the parent - before the parent
-	 * gets woken up by child-exit notifications.
-	 */
-	perf_event_exit_task(tsk);
 
 	exit_notify(tsk, group_dead);
 #ifdef CONFIG_NUMA
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 11847bf..2c14e3a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -38,6 +38,12 @@
 
 #include <asm/irq_regs.h>
 
+enum event_type_t {
+	EVENT_FLEXIBLE = 0x1,
+	EVENT_PINNED = 0x2,
+	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
+};
+
 atomic_t perf_task_events __read_mostly;
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
@@ -65,6 +71,12 @@ int sysctl_perf_event_sample_rate __read_mostly = 100000;
 
 static atomic64_t perf_event_id;
 
+static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
+			      enum event_type_t event_type);
+
+static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
+			     enum event_type_t event_type);
+
 void __weak perf_event_print_debug(void)	{ }
 
 extern __weak const char *perf_pmu_name(void)
@@ -72,6 +84,11 @@ extern __weak const char *perf_pmu_name(void)
 	return "pmu";
 }
 
+static inline u64 perf_clock(void)
+{
+	return local_clock();
+}
+
 void perf_pmu_disable(struct pmu *pmu)
 {
 	int *count = this_cpu_ptr(pmu->pmu_disable_count);
@@ -240,11 +257,6 @@ static void perf_unpin_context(struct perf_event_context *ctx)
 	put_ctx(ctx);
 }
 
-static inline u64 perf_clock(void)
-{
-	return local_clock();
-}
-
 /*
  * Update the record of the current time in a context.
  */
@@ -1193,12 +1205,6 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
 	return 0;
 }
 
-enum event_type_t {
-	EVENT_FLEXIBLE = 0x1,
-	EVENT_PINNED = 0x2,
-	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
-};
-
 static void ctx_sched_out(struct perf_event_context *ctx,
 			  struct perf_cpu_context *cpuctx,
 			  enum event_type_t event_type)
