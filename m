Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab1BRNkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 08:40:18 -0500
Received: from smtp-out.google.com ([216.239.44.51]:26882 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1BRNkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 08:40:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=UI9TpP3n1SgtWBm2vznyix4nwvERLgn8I6RGMObIuiXh7zaPcnQnagR17x6N+e6ZNV
         MslrjvqTXbCeg5XsCRog==
Message-ID: <4d5e76b8.815bdf0a.7ac3.774f@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Fri, 18 Feb 2011 14:40:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        linux-perf-users@vger.kernel.org
Subject: [PATCH] perf_events: fix rcu and locking issues with cgroup support
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches ensures that we do not end up calling
perf_cgroup_from_task() when there is no cgroup event.
This avoids potential RCU and locking issues.

The change in perf_cgroup_set_timestamp() ensures we
check against ctx->nr_cgroups. It also avoids calling
perf_clock() tiwce in a row. It also ensures we do need
to grab ctx->lock before calling the function.

We drop update_cgrp_time() from task_clock_event_read()
because it is not needed. This also avoids having to
deal with perf_cgroup_from_task().

Thanks to Peter Zijlstra for his help on this.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
---

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a0a6987..438d73a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -201,6 +201,11 @@ __get_cpu_context(struct perf_event_context *ctx)
 
 #ifdef CONFIG_CGROUP_PERF
 
+/*
+ * must ensure cgroup is pinned (css_get) before calling
+ * this function. In other words, we cannot call this function
+ * if there is no cgroup event for the current CPU context.
+ */
 static inline struct perf_cgroup *
 perf_cgroup_from_task(struct task_struct *task)
 {
@@ -268,28 +273,41 @@ static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx)
 
 static inline void update_cgrp_time_from_event(struct perf_event *event)
 {
-	struct perf_cgroup *cgrp = perf_cgroup_from_task(current);
+	struct perf_cgroup *cgrp;
+
 	/*
-	 * do not update time when cgroup is not active
+	 * ensure we access cgroup data only when needed and
+	 * when we know the cgroup is pinned (css_get)
 	 */
-	if (!event->cgrp || cgrp != event->cgrp)
+	if (!is_cgroup_event(event))
 		return;
 
-	__update_cgrp_time(event->cgrp);
+	cgrp = perf_cgroup_from_task(current);
+	/*
+	 * do not update time when cgroup is not active
+	 */
+	if (cgrp == event->cgrp)
+		__update_cgrp_time(event->cgrp);
 }
 
 static inline void
-perf_cgroup_set_timestamp(struct task_struct *task, u64 now)
+perf_cgroup_set_timestamp(struct task_struct *task,
+			  struct perf_event_context *ctx)
 {
 	struct perf_cgroup *cgrp;
 	struct perf_cgroup_info *info;
 
-	if (!task)
+	/*
+	 * ctx->lock held by caller
+	 * ensure we do not access cgroup data
+	 * unless we have the cgroup pinned (css_get)
+	 */
+	if (!task || !ctx->nr_cgroups)
 		return;
 
 	cgrp = perf_cgroup_from_task(task);
 	info = this_cpu_ptr(cgrp->info);
-	info->timestamp = now;
+	info->timestamp = ctx->timestamp;
 }
 
 #define PERF_CGROUP_SWOUT	0x1 /* cgroup switch out every event */
@@ -494,7 +512,8 @@ static inline int perf_cgroup_connect(pid_t pid, struct perf_event *event,
 }
 
 static inline void
-perf_cgroup_set_timestamp(struct task_struct *task, u64 now)
+perf_cgroup_set_timestamp(struct task_struct *task,
+			  struct perf_event_context *ctx)
 {
 }
 
@@ -1613,7 +1632,7 @@ static int __perf_event_enable(void *info)
 	/*
 	 * set current task's cgroup time reference point
 	 */
-	perf_cgroup_set_timestamp(current, perf_clock());
+	perf_cgroup_set_timestamp(current, ctx);
 
 	__perf_event_mark_enabled(event, ctx);
 
@@ -2048,7 +2067,7 @@ ctx_sched_in(struct perf_event_context *ctx,
 
 	now = perf_clock();
 	ctx->timestamp = now;
-	perf_cgroup_set_timestamp(task, now);
+	perf_cgroup_set_timestamp(task, ctx);
 	/*
 	 * First go through the list and put on any pinned groups
 	 * in order to give them the best chance of going on.
@@ -5795,7 +5814,6 @@ static void task_clock_event_read(struct perf_event *event)
 
 	if (!in_nmi()) {
 		update_context_time(event->ctx);
-		update_cgrp_time_from_event(event);
 		time = event->ctx->time;
 	} else {
 		u64 now = perf_clock();
