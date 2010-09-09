Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab0IITxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:53:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:54414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515Ab0IITxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:53:47 -0400
Date: Thu, 9 Sep 2010 19:53:18 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, eranian@googlemail.com, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com, robert.richter@amd.com,
        fweisbec@gmail.com, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, eranian@googlemail.com,
        a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com,
        fweisbec@gmail.com, robert.richter@amd.com, ming.m.lin@intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Provide a separate task context for swevents
Message-ID: <tip-89a1e18731959e9953fae15ddc1a983eb15a4f19@git.kernel.org>
Git-Commit-ID: 89a1e18731959e9953fae15ddc1a983eb15a4f19
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:53:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89a1e18731959e9953fae15ddc1a983eb15a4f19
Gitweb:     http://git.kernel.org/tip/89a1e18731959e9953fae15ddc1a983eb15a4f19
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 7 Sep 2010 17:34:50 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:34 +0200

perf: Provide a separate task context for swevents

Since software events are always schedulable, mixing them up with
hardware events (who are not) can lead to funny scheduling oddities.

Giving them their own context solves this.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Yanmin <yanmin_zhang@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    9 +--------
 include/linux/sched.h      |    1 +
 kernel/hw_breakpoint.c     |    2 ++
 kernel/perf_event.c        |   40 +++++++++++++++++++++++++++++-----------
 4 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9ecfd85..c117352 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -952,14 +952,7 @@ extern int perf_event_overflow(struct perf_event *event, int nmi,
  */
 static inline int is_software_event(struct perf_event *event)
 {
-	switch (event->attr.type) {
-	case PERF_TYPE_SOFTWARE:
-	case PERF_TYPE_TRACEPOINT:
-	/* for now the breakpoint stuff also works as software event */
-	case PERF_TYPE_BREAKPOINT:
-		return 1;
-	}
-	return 0;
+	return event->pmu->task_ctx_nr == perf_sw_context;
 }
 
 extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 89d6023..eb3c1ce 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1163,6 +1163,7 @@ struct rcu_node;
 enum perf_event_task_context {
 	perf_invalid_context = -1,
 	perf_hw_context = 0,
+	perf_sw_context,
 	perf_nr_task_contexts,
 };
 
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 6f15009..3b2aaff 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -610,6 +610,8 @@ static void hw_breakpoint_stop(struct perf_event *bp, int flags)
 }
 
 static struct pmu perf_breakpoint = {
+	.task_ctx_nr	= perf_sw_context, /* could eventually get its own */
+
 	.event_init	= hw_breakpoint_event_init,
 	.add		= hw_breakpoint_add,
 	.del		= hw_breakpoint_del,
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 7223ea8..357ee8d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4709,6 +4709,8 @@ static int perf_swevent_init(struct perf_event *event)
 }
 
 static struct pmu perf_swevent = {
+	.task_ctx_nr	= perf_sw_context,
+
 	.event_init	= perf_swevent_init,
 	.add		= perf_swevent_add,
 	.del		= perf_swevent_del,
@@ -4800,6 +4802,8 @@ static int perf_tp_event_init(struct perf_event *event)
 }
 
 static struct pmu perf_tracepoint = {
+	.task_ctx_nr	= perf_sw_context,
+
 	.event_init	= perf_tp_event_init,
 	.add		= perf_trace_add,
 	.del		= perf_trace_del,
@@ -4988,6 +4992,8 @@ static int cpu_clock_event_init(struct perf_event *event)
 }
 
 static struct pmu perf_cpu_clock = {
+	.task_ctx_nr	= perf_sw_context,
+
 	.event_init	= cpu_clock_event_init,
 	.add		= cpu_clock_event_add,
 	.del		= cpu_clock_event_del,
@@ -5063,6 +5069,8 @@ static int task_clock_event_init(struct perf_event *event)
 }
 
 static struct pmu perf_task_clock = {
+	.task_ctx_nr	= perf_sw_context,
+
 	.event_init	= task_clock_event_init,
 	.add		= task_clock_event_add,
 	.del		= task_clock_event_del,
@@ -5490,6 +5498,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	struct perf_event_context *ctx;
 	struct file *event_file = NULL;
 	struct file *group_file = NULL;
+	struct pmu *pmu;
 	int event_fd;
 	int fput_needed = 0;
 	int err;
@@ -5522,20 +5531,11 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_fd;
 	}
 
-	/*
-	 * Get the target context (task or percpu):
-	 */
-	ctx = find_get_context(event->pmu, pid, cpu);
-	if (IS_ERR(ctx)) {
-		err = PTR_ERR(ctx);
-		goto err_alloc;
-	}
-
 	if (group_fd != -1) {
 		group_leader = perf_fget_light(group_fd, &fput_needed);
 		if (IS_ERR(group_leader)) {
 			err = PTR_ERR(group_leader);
-			goto err_context;
+			goto err_alloc;
 		}
 		group_file = group_leader->filp;
 		if (flags & PERF_FLAG_FD_OUTPUT)
@@ -5545,6 +5545,23 @@ SYSCALL_DEFINE5(perf_event_open,
 	}
 
 	/*
+	 * Special case software events and allow them to be part of
+	 * any hardware group.
+	 */
+	pmu = event->pmu;
+	if ((pmu->task_ctx_nr == perf_sw_context) && group_leader)
+		pmu = group_leader->pmu;
+
+	/*
+	 * Get the target context (task or percpu):
+	 */
+	ctx = find_get_context(pmu, pid, cpu);
+	if (IS_ERR(ctx)) {
+		err = PTR_ERR(ctx);
+		goto err_group_fd;
+	}
+
+	/*
 	 * Look up the group leader (we will attach this event to it):
 	 */
 	if (group_leader) {
@@ -5605,8 +5622,9 @@ SYSCALL_DEFINE5(perf_event_open,
 	return event_fd;
 
 err_context:
-	fput_light(group_file, fput_needed);
 	put_ctx(ctx);
+err_group_fd:
+	fput_light(group_file, fput_needed);
 err_alloc:
 	free_event(event);
 err_fd:
