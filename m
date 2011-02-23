Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab1BWMHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:07:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:56506 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab1BWMG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:06:59 -0500
Date: Wed, 23 Feb 2011 12:06:27 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        eranian@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, eranian@gmail.com, mingo@elte.hu
In-Reply-To: <4d5e76b8.815bdf0a.7ac3.774f@mx.google.com>
References: <4d5e76b8.815bdf0a.7ac3.774f@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix rcu and locking issues with cgroup support
Message-ID: <tip-3f7cce3c18188a067d463749168bdda5abc5b0f7@git.kernel.org>
Git-Commit-ID: 3f7cce3c18188a067d463749168bdda5abc5b0f7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 12:06:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f7cce3c18188a067d463749168bdda5abc5b0f7
Gitweb:     http://git.kernel.org/tip/3f7cce3c18188a067d463749168bdda5abc5b0f7
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 18 Feb 2011 14:40:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Feb 2011 11:35:46 +0100

perf_events: Fix rcu and locking issues with cgroup support

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4d5e76b8.815bdf0a.7ac3.774f@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   40 +++++++++++++++++++++++++++++-----------
 1 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a0a6987..dadeaea 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -201,6 +201,11 @@ __get_cpu_context(struct perf_event_context *ctx)
 
 #ifdef CONFIG_CGROUP_PERF
 
+/*
+ * Must ensure cgroup is pinned (css_get) before calling
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
+	 * Do not update time when cgroup is not active
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
