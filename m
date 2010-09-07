Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab0IGQ5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:57:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32874 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109Ab0IGQ4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:56:54 -0400
Message-Id: <20100907165011.831212702@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 18:46:44 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 11/19] perf: Separate find_get_context() from event initialization
References: <20100907164633.879932949@chello.nl>
Content-Disposition: inline; filename=perf-pmu-context.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate find_get_context() from the event allocation and initialization
so that we may make find_get_context() depend on the event pmu in a later
patch.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   73 ++++++++++++++++++++++++----------------------------
 1 file changed, 35 insertions(+), 38 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -827,6 +827,8 @@ perf_install_in_context(struct perf_even
 {
 	struct task_struct *task = ctx->task;
 
+	event->ctx = ctx;
+
 	if (!task) {
 		/*
 		 * Per cpu events are installed via an smp call and
@@ -5037,20 +5039,17 @@ struct pmu *perf_init_event(struct perf_
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
 
@@ -5075,7 +5074,6 @@ perf_event_alloc(struct perf_event_attr 
 	event->attr		= *attr;
 	event->group_leader	= group_leader;
 	event->pmu		= NULL;
-	event->ctx		= ctx;
 	event->oncpu		= -1;
 
 	event->parent		= parent_event;
@@ -5320,20 +5318,26 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -5353,37 +5357,30 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -5409,11 +5406,11 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -5431,25 +5428,24 @@ perf_event_create_kernel_counter(struct 
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
@@ -5467,9 +5463,9 @@ perf_event_create_kernel_counter(struct 
 
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
@@ -5497,9 +5493,9 @@ inherit_event(struct perf_event *parent_
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
@@ -5524,6 +5520,7 @@ inherit_event(struct perf_event *parent_
 		local64_set(&hwc->period_left, sample_period);
 	}
 
+	child_event->ctx = child_ctx;
 	child_event->overflow_handler = parent_event->overflow_handler;
 
 	/*


