Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab0IITvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:51:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:33157 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab0IITvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:51:17 -0400
Date: Thu, 9 Sep 2010 19:50:50 GMT
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
Subject: [tip:perf/core] perf: Separate find_get_context() from event initialization
Message-ID: <tip-c3f00c70276d8ae82578c8b773e2db657f69a478@git.kernel.org>
Git-Commit-ID: c3f00c70276d8ae82578c8b773e2db657f69a478
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:50:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3f00c70276d8ae82578c8b773e2db657f69a478
Gitweb:     http://git.kernel.org/tip/c3f00c70276d8ae82578c8b773e2db657f69a478
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 18 Aug 2010 14:37:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:31 +0200

perf: Separate find_get_context() from event initialization

Separate find_get_context() from the event allocation and
initialization so that we may make find_get_context() depend
on the event pmu in a later patch.

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
 kernel/perf_event.c |   73 ++++++++++++++++++++++++--------------------------
 1 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8462e69..a3c86a8 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -827,6 +827,8 @@ perf_install_in_context(struct perf_event_context *ctx,
 {
 	struct task_struct *task = ctx->task;
 
+	event->ctx = ctx;
+
 	if (!task) {
 		/*
 		 * Per cpu events are installed via an smp call and
@@ -5038,20 +5040,17 @@ struct pmu *perf_init_event(struct perf_event *event)
  * Allocate and initialize a event structure
  */
 static struct perf_event *
-perf_event_alloc(struct perf_event_attr *attr,
-		   int cpu,
-		   struct perf_event_context *ctx,
+perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		   struct perf_event *group_leader,
 		   struct perf_event *parent_event,
-		   perf_overflow_handler_t overflow_handler,
-		   gfp_t gfpflags)
+		   perf_overflow_handler_t overflow_handler)
 {
 	struct pmu *pmu;
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
 	long err;
 
-	event = kzalloc(sizeof(*event), gfpflags);
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
 	if (!event)
 		return ERR_PTR(-ENOMEM);
 
@@ -5076,7 +5075,6 @@ perf_event_alloc(struct perf_event_attr *attr,
 	event->attr		= *attr;
 	event->group_leader	= group_leader;
 	event->pmu		= NULL;
-	event->ctx		= ctx;
 	event->oncpu		= -1;
 
 	event->parent		= parent_event;
@@ -5321,20 +5319,26 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (event_fd < 0)
 		return event_fd;
 
+	event = perf_event_alloc(&attr, cpu, group_leader, NULL, NULL);
+	if (IS_ERR(event)) {
+		err = PTR_ERR(event);
+		goto err_fd;
+	}
+
 	/*
 	 * Get the target context (task or percpu):
 	 */
 	ctx = find_get_context(pid, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
-		goto err_fd;
+		goto err_alloc;
 	}
 
 	if (group_fd != -1) {
 		group_leader = perf_fget_light(group_fd, &fput_needed);
 		if (IS_ERR(group_leader)) {
 			err = PTR_ERR(group_leader);
-			goto err_put_context;
+			goto err_context;
 		}
 		group_file = group_leader->filp;
 		if (flags & PERF_FLAG_FD_OUTPUT)
@@ -5354,37 +5358,30 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * becoming part of another group-sibling):
 		 */
 		if (group_leader->group_leader != group_leader)
-			goto err_put_context;
+			goto err_context;
 		/*
 		 * Do not allow to attach to a group in a different
 		 * task or CPU context:
 		 */
 		if (group_leader->ctx != ctx)
-			goto err_put_context;
+			goto err_context;
 		/*
 		 * Only a group leader can be exclusive or pinned
 		 */
 		if (attr.exclusive || attr.pinned)
-			goto err_put_context;
-	}
-
-	event = perf_event_alloc(&attr, cpu, ctx, group_leader,
-				     NULL, NULL, GFP_KERNEL);
-	if (IS_ERR(event)) {
-		err = PTR_ERR(event);
-		goto err_put_context;
+			goto err_context;
 	}
 
 	if (output_event) {
 		err = perf_event_set_output(event, output_event);
 		if (err)
-			goto err_free_put_context;
+			goto err_context;
 	}
 
 	event_file = anon_inode_getfile("[perf_event]", &perf_fops, event, O_RDWR);
 	if (IS_ERR(event_file)) {
 		err = PTR_ERR(event_file);
-		goto err_free_put_context;
+		goto err_context;
 	}
 
 	event->filp = event_file;
@@ -5410,11 +5407,11 @@ SYSCALL_DEFINE5(perf_event_open,
 	fd_install(event_fd, event_file);
 	return event_fd;
 
-err_free_put_context:
-	free_event(event);
-err_put_context:
+err_context:
 	fput_light(group_file, fput_needed);
 	put_ctx(ctx);
+err_alloc:
+	free_event(event);
 err_fd:
 	put_unused_fd(event_fd);
 	return err;
@@ -5432,25 +5429,24 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 				 pid_t pid,
 				 perf_overflow_handler_t overflow_handler)
 {
-	struct perf_event *event;
 	struct perf_event_context *ctx;
+	struct perf_event *event;
 	int err;
 
 	/*
 	 * Get the target context (task or percpu):
 	 */
 
+	event = perf_event_alloc(attr, cpu, NULL, NULL, overflow_handler);
+	if (IS_ERR(event)) {
+		err = PTR_ERR(event);
+		goto err;
+	}
+
 	ctx = find_get_context(pid, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
-		goto err_exit;
-	}
-
-	event = perf_event_alloc(attr, cpu, ctx, NULL,
-				 NULL, overflow_handler, GFP_KERNEL);
-	if (IS_ERR(event)) {
-		err = PTR_ERR(event);
-		goto err_put_context;
+		goto err_free;
 	}
 
 	event->filp = NULL;
@@ -5468,9 +5464,9 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 
 	return event;
 
- err_put_context:
-	put_ctx(ctx);
- err_exit:
+err_free:
+	free_event(event);
+err:
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
@@ -5498,9 +5494,9 @@ inherit_event(struct perf_event *parent_event,
 		parent_event = parent_event->parent;
 
 	child_event = perf_event_alloc(&parent_event->attr,
-					   parent_event->cpu, child_ctx,
+					   parent_event->cpu,
 					   group_leader, parent_event,
-					   NULL, GFP_KERNEL);
+					   NULL);
 	if (IS_ERR(child_event))
 		return child_event;
 	get_ctx(child_ctx);
@@ -5525,6 +5521,7 @@ inherit_event(struct perf_event *parent_event,
 		local64_set(&hwc->period_left, sample_period);
 	}
 
+	child_event->ctx = child_ctx;
 	child_event->overflow_handler = parent_event->overflow_handler;
 
 	/*
