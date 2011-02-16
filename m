Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1BPQ5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:57:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:54288 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab1BPQ5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:57:45 -0500
Subject: Re: [tip:perf/core] perf: Add cgroup support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25@git.kernel.org>
References: <4d590250.114ddf0a.689e.4482@mx.google.com>
	 <tip-e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Feb 2011 17:57:32 +0100
Message-ID: <1297875452.2413.453.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-16 at 13:46 +0000, tip-bot for Stephane Eranian wrote:
> +static inline struct perf_cgroup *
> +perf_cgroup_from_task(struct task_struct *task)
> +{
> +       return container_of(task_subsys_state(task, perf_subsys_id),
> +                       struct perf_cgroup, css);
> +} 

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
include/linux/cgroup.h:547 invoked rcu_dereference_check() without protection!
other info that might help us debug this:
rcu_scheduler_active = 1, debug_locks = 1
1 lock held by perf/1774:
 #0:  (&ctx->lock){......}, at: [<ffffffff810afb91>] ctx_sched_in+0x2a/0x37b
stack backtrace:
Pid: 1774, comm: perf Not tainted 2.6.38-rc5-tip+ #94017
Call Trace:
 [<ffffffff81070932>] ? lockdep_rcu_dereference+0x9d/0xa5
 [<ffffffff810afc4e>] ? ctx_sched_in+0xe7/0x37b
 [<ffffffff810aff37>] ? perf_event_context_sched_in+0x55/0xa3
 [<ffffffff810b0203>] ? __perf_event_task_sched_in+0x20/0x5b
 [<ffffffff81035714>] ? finish_task_switch+0x49/0xf4
 [<ffffffff81340d60>] ? schedule+0x9cc/0xa85
 [<ffffffff8110a84c>] ? vfsmount_lock_global_unlock_online+0x9e/0xb0
 [<ffffffff8110b556>] ? mntput_no_expire+0x4e/0xc1
 [<ffffffff8110b5ef>] ? mntput+0x26/0x28
 [<ffffffff810f2add>] ? fput+0x1a0/0x1af
 [<ffffffff81002eb9>] ? int_careful+0xb/0x2c
 [<ffffffff813432bf>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81002ec7>] ? int_careful+0x19/0x2c


The simple fix seemed to be to add:

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a0a6987..e739e6f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -204,7 +204,8 @@ __get_cpu_context(struct perf_event_context *ctx)
 static inline struct perf_cgroup *
 perf_cgroup_from_task(struct task_struct *task)
 {
-	return container_of(task_subsys_state(task, perf_subsys_id),
+	return container_of(task_subsys_state_check(task, perf_subsys_id,
+				lockdep_is_held(&ctx->lock)),
 			struct perf_cgroup, css);
 }

For all callers _should_ hold ctx->lock and ctx->lock is acquired during
->attach/->exit so holding that lock will pin the cgroup.

However, not all update_context_time()/update_cgrp_time_from_event()
callers actually hold ctx->lock, which is a bug because that lock also
serializes the timestamps.

Most notably, task_clock_event_read(), which leads us to:

@@ -5794,9 +5795,14 @@ static void task_clock_event_read(struct perf_event *event)
        u64 time;
 
        if (!in_nmi()) {
-               update_context_time(event->ctx);
+               struct perf_event_context *ctx = event->ctx;
+               unsigned long flags;
+
+               spin_lock_irqsave(&ctx->lock, flags);
+               update_context_time(ctx);
                update_cgrp_time_from_event(event);
-               time = event->ctx->time;
+               time = ctx->time;
+               spin_unlock_irqrestore(&ctx->lock, flags);
        } else {
                u64 now = perf_clock();
                u64 delta = now - event->ctx->timestamp;


I then realized that the events themselves pin the cgroup, so its all
cosmetic at best, but then I already had the below patch...

Thoughts?

---
 kernel/perf_event.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a0a6987..810ee49 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -202,9 +202,10 @@ __get_cpu_context(struct perf_event_context *ctx)
 #ifdef CONFIG_CGROUP_PERF
 
 static inline struct perf_cgroup *
-perf_cgroup_from_task(struct task_struct *task)
+perf_cgroup_from_task(struct task_struct *task, struct perf_event_context *ctx)
 {
-	return container_of(task_subsys_state(task, perf_subsys_id),
+	return container_of(task_subsys_state_check(task, perf_subsys_id,
+				lockdep_is_held(&ctx->lock)),
 			struct perf_cgroup, css);
 }
 
@@ -268,7 +269,7 @@ static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx)
 
 static inline void update_cgrp_time_from_event(struct perf_event *event)
 {
-	struct perf_cgroup *cgrp = perf_cgroup_from_task(current);
+	struct perf_cgroup *cgrp = perf_cgroup_from_task(current, event->ctx);
 	/*
 	 * do not update time when cgroup is not active
 	 */
@@ -279,7 +280,7 @@ static inline void update_cgrp_time_from_event(struct perf_event *event)
 }
 
 static inline void
-perf_cgroup_set_timestamp(struct task_struct *task, u64 now)
+perf_cgroup_set_timestamp(struct task_struct *task, struct perf_event_context *ctx)
 {
 	struct perf_cgroup *cgrp;
 	struct perf_cgroup_info *info;
@@ -287,9 +288,9 @@ perf_cgroup_set_timestamp(struct task_struct *task, u64 now)
 	if (!task)
 		return;
 
-	cgrp = perf_cgroup_from_task(task);
+	cgrp = perf_cgroup_from_task(task, ctx);
 	info = this_cpu_ptr(cgrp->info);
-	info->timestamp = now;
+	info->timestamp = ctx->timestamp;
 }
 
 #define PERF_CGROUP_SWOUT	0x1 /* cgroup switch out every event */
@@ -349,7 +350,7 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 				 * allow event_filter_match() to not
 				 * have to pass task around
 				 */
-				cpuctx->cgrp = perf_cgroup_from_task(task);
+				cpuctx->cgrp = perf_cgroup_from_task(task, &cpuctx->ctx);
 				cpu_ctx_sched_in(cpuctx, EVENT_ALL, task);
 			}
 		}
@@ -494,7 +495,7 @@ static inline int perf_cgroup_connect(pid_t pid, struct perf_event *event,
 }
 
 static inline void
-perf_cgroup_set_timestamp(struct task_struct *task, u64 now)
+perf_cgroup_set_timestamp(struct task_struct *task, struct perf_event_context *ctx)
 {
 }
 
@@ -1613,7 +1614,7 @@ static int __perf_event_enable(void *info)
 	/*
 	 * set current task's cgroup time reference point
 	 */
-	perf_cgroup_set_timestamp(current, perf_clock());
+	perf_cgroup_set_timestamp(current, ctx);
 
 	__perf_event_mark_enabled(event, ctx);
 
@@ -2048,7 +2049,7 @@ ctx_sched_in(struct perf_event_context *ctx,
 
 	now = perf_clock();
 	ctx->timestamp = now;
-	perf_cgroup_set_timestamp(task, now);
+	perf_cgroup_set_timestamp(task, ctx);
 	/*
 	 * First go through the list and put on any pinned groups
 	 * in order to give them the best chance of going on.
@@ -5794,9 +5795,14 @@ static void task_clock_event_read(struct perf_event *event)
 	u64 time;
 
 	if (!in_nmi()) {
-		update_context_time(event->ctx);
+		struct perf_event_context *ctx = event->ctx;
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->lock, flags);
+		update_context_time(ctx);
 		update_cgrp_time_from_event(event);
-		time = event->ctx->time;
+		time = ctx->time;
+		spin_unlock_irqrestore(&ctx->lock, flags);
 	} else {
 		u64 now = perf_clock();
 		u64 delta = now - event->ctx->timestamp;

