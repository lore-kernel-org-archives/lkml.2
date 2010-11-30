Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab0K3SWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:22:00 -0500
Received: from smtp-out.google.com ([74.125.121.35]:6833 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab0K3SV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:21:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=Art9gbMMpZQC2Z+XS2OuBNFe4glgNEPl10NzEvrl0u5WZmD2c1cTnx7Kp1RasKM49k
         X6QKbThKWcyzcn8/rniQ==
Message-ID: <4cf540c1.04e7d80a.303b.2352@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 30 Nov 2010 19:20:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Subject: [PATCH 1/5] perf_events: move code around to prepare for cgroup (v6)
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
index 21aa7b3..7132a37 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -985,6 +985,15 @@ NORET_TYPE void do_exit(long code)
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
@@ -998,11 +1007,6 @@ NORET_TYPE void do_exit(long code)
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
index 04e8291..84dc7f6 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -35,6 +35,12 @@
 
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
@@ -62,6 +68,12 @@ int sysctl_perf_event_sample_rate __read_mostly = 100000;
 
 static atomic64_t perf_event_id;
 
+static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
+			      enum event_type_t event_type);
+
+static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
+			     enum event_type_t event_type);
+
 void __weak perf_event_print_debug(void)	{ }
 
 extern __weak const char *perf_pmu_name(void)
@@ -69,6 +81,11 @@ extern __weak const char *perf_pmu_name(void)
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
@@ -215,11 +232,6 @@ static void perf_unpin_context(struct perf_event_context *ctx)
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
@@ -1082,12 +1094,6 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
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
