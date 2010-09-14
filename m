Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0INQ4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 12:56:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab0INQ4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 12:56:52 -0400
Subject: Re: [RFC][PATCH 00/19] perf pmu interface changes -v4
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
        Michael Cree <mcree@orcon.net.nz>, linux-kernel@vger.kernel.org
In-Reply-To: <20100910043952.GA9100@drongo>
References: <20100907164633.879932949@chello.nl>
	 <20100910043952.GA9100@drongo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Sep 2010 18:56:32 +0200
Message-ID: <1284483392.2275.540.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 14:39 +1000, Paul Mackerras wrote:
> On Tue, Sep 07, 2010 at 06:46:33PM +0200, Peter Zijlstra wrote:
> 
> > These patches prepare the perf code for multiple PMUs.
> > 
> > About the first half of these patches deals with removing all the weak
> > functions, the second half provides per pmu contexts.
> > 
> > New to the first half is Alpha, which got merged into mainline recently.
> > 
> > The second half is completely new and lightly tested, one known breakage is
> > that it currently doesn't allow to mix software and hardware events into a
> > single group (should be fixed soon).
> 
> I see Ingo committed this series into the tip perf/core branch.  Did
> this problem get fixed before that, or does it still need to be fixed?

I was thinking something like the below, except I obviously need to sort
that XXX thing.


---
 kernel/perf_event.c |   48 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -494,7 +494,7 @@ static void __perf_event_remove_from_con
 
 	raw_spin_lock(&ctx->lock);
 
-	event_sched_out(event, cpuctx, ctx);
+	group_sched_out(event, cpuctx, ctx);
 
 	list_del_event(event, ctx);
 
@@ -5522,9 +5522,10 @@ SYSCALL_DEFINE5(perf_event_open,
 	struct perf_event_context *ctx;
 	struct file *event_file = NULL;
 	struct file *group_file = NULL;
-	struct task_struct *task;
+	struct task_struct *task = NULL;
 	struct pmu *pmu;
 	int event_fd;
+	int move_group_leader = 0;
 	int fput_needed = 0;
 	int err;
 
@@ -5574,15 +5575,34 @@ SYSCALL_DEFINE5(perf_event_open,
 	 * any hardware group.
 	 */
 	pmu = event->pmu;
-	if ((pmu->task_ctx_nr == perf_sw_context) && group_leader)
-		pmu = group_leader->pmu;
+
+	if (group_leader &&
+	    (is_software_event(event) != is_software_event(group_leader))) {
+		if (is_software_event(event)) {
+			/*
+			 * If event and group_leader are not both a software
+			 * event, and event it, then group leader is not.
+			 *
+			 * Allow the addition of software events to !software
+			 * groups, this is safe because software events never
+			 * fail to schedule.
+			 */
+			pmu = group_leader->pmu;
+		} else if (is_software_event(group_leader) &&
+		    (group_leader->group_flags & PERF_GROUP_SOFTWARE)) {
+			/*
+			 * In case the group is a pure software group, and we
+			 * try to add a hardware event, move the whole group to
+			 * the hardware context.
+			 */
+			move_group_leader = 1;
+		}
+	}
 
 	/*
 	 * Get the target context (task or percpu):
 	 */
-	if (pid == -1 && cpu != -1)
-		task = NULL;
-	else
+	if (!(pid == -1 && cpu != -1))
 		task = find_lively_task_by_vpid(pid);
 
 	ctx = find_get_context(pmu, task, cpu);
@@ -5606,8 +5626,10 @@ SYSCALL_DEFINE5(perf_event_open,
 		/*
 		 * Do not allow to attach to a group in a different
 		 * task or CPU context:
+		 *
+		 * XXX fix the task vs cpu context thing for move_group_leader
 		 */
-		if (group_leader->ctx != ctx)
+		if (!move_group_leader && group_leader->ctx != ctx)
 			goto err_context;
 		/*
 		 * Only a group leader can be exclusive or pinned
@@ -5628,9 +5650,19 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_context;
 	}
 
+	if (move_group_leader) {
+		struct perf_event_context *gctx = group_leader->ctx;
+
+		mutex_lock(&gctx->mutex);
+		perf_event_remove_from_context(group_leader);
+		mutex_unlock(&gctx->mutex);
+	}
+
 	event->filp = event_file;
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
+	if (move_group_leader)
+		perf_install_in_context(ctx, group_leader, cpu);
 	perf_install_in_context(ctx, event, cpu);
 	++ctx->generation;
 	mutex_unlock(&ctx->mutex);

