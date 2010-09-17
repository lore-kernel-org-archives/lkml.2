Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab0IQL2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 07:28:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:60817 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab0IQL2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 07:28:46 -0400
Date: Fri, 17 Sep 2010 11:28:14 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        robert.richter@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, robert.richter@amd.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100917093009.410784731@chello.nl>
References: <20100917093009.410784731@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Complete software pmu grouping
Message-ID: <tip-b04243ef7006cda301819f54ee7ce0a3632489e3@git.kernel.org>
Git-Commit-ID: b04243ef7006cda301819f54ee7ce0a3632489e3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Sep 2010 11:28:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b04243ef7006cda301819f54ee7ce0a3632489e3
Gitweb:     http://git.kernel.org/tip/b04243ef7006cda301819f54ee7ce0a3632489e3
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 17 Sep 2010 11:28:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Sep 2010 12:48:48 +0200

perf: Complete software pmu grouping

Aside from allowing software events into a !software group,
allow adding !software events to pure software groups.

Once we've moved the software group and attached the first
!software event, the group will no longer be a pure software
group and hence no longer be eligible for movement, at which
point the straight ctx comparison is correct again.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20100917093009.410784731@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    6 ++++
 kernel/perf_event.c        |   65 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 39d8860..165287f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -804,12 +804,18 @@ struct perf_event {
 #endif /* CONFIG_PERF_EVENTS */
 };
 
+enum perf_event_context_type {
+	task_context,
+	cpu_context,
+};
+
 /**
  * struct perf_event_context - event context structure
  *
  * Used as a container for task events and CPU events as well:
  */
 struct perf_event_context {
+	enum perf_event_context_type	type;
 	struct pmu			*pmu;
 	/*
 	 * Protect the states of the events in the list,
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index ce95617..6d7eef5 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5184,6 +5184,7 @@ int perf_pmu_register(struct pmu *pmu)
 
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 		__perf_event_init_context(&cpuctx->ctx);
+		cpuctx->ctx.type = cpu_context;
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->timer_interval = TICK_NSEC;
 		hrtimer_init(&cpuctx->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
@@ -5517,7 +5518,8 @@ SYSCALL_DEFINE5(perf_event_open,
 		struct perf_event_attr __user *, attr_uptr,
 		pid_t, pid, int, cpu, int, group_fd, unsigned long, flags)
 {
-	struct perf_event *event, *group_leader = NULL, *output_event = NULL;
+	struct perf_event *group_leader = NULL, *output_event = NULL;
+	struct perf_event *event, *sibling;
 	struct perf_event_attr attr;
 	struct perf_event_context *ctx;
 	struct file *event_file = NULL;
@@ -5525,6 +5527,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	struct task_struct *task = NULL;
 	struct pmu *pmu;
 	int event_fd;
+	int move_group = 0;
 	int fput_needed = 0;
 	int err;
 
@@ -5574,8 +5577,29 @@ SYSCALL_DEFINE5(perf_event_open,
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
+			 * event, and event is, then group leader is not.
+			 *
+			 * Allow the addition of software events to !software
+			 * groups, this is safe because software events never
+			 * fail to schedule.
+			 */
+			pmu = group_leader->pmu;
+		} else if (is_software_event(group_leader) &&
+			   (group_leader->group_flags & PERF_GROUP_SOFTWARE)) {
+			/*
+			 * In case the group is a pure software group, and we
+			 * try to add a hardware event, move the whole group to
+			 * the hardware context.
+			 */
+			move_group = 1;
+		}
+	}
 
 	if (pid != -1)
 		task = find_lively_task_by_vpid(pid);
@@ -5605,8 +5629,14 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * Do not allow to attach to a group in a different
 		 * task or CPU context:
 		 */
-		if (group_leader->ctx != ctx)
-			goto err_context;
+		if (move_group) {
+			if (group_leader->ctx->type != ctx->type)
+				goto err_context;
+		} else {
+			if (group_leader->ctx != ctx)
+				goto err_context;
+		}
+
 		/*
 		 * Only a group leader can be exclusive or pinned
 		 */
@@ -5626,9 +5656,34 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_context;
 	}
 
+	if (move_group) {
+		struct perf_event_context *gctx = group_leader->ctx;
+
+		mutex_lock(&gctx->mutex);
+		perf_event_remove_from_context(group_leader);
+		list_for_each_entry(sibling, &group_leader->sibling_list,
+				    group_entry) {
+			perf_event_remove_from_context(sibling);
+			put_ctx(gctx);
+		}
+		mutex_unlock(&gctx->mutex);
+		put_ctx(gctx);
+	}
+
 	event->filp = event_file;
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
+
+	if (move_group) {
+		perf_install_in_context(ctx, group_leader, cpu);
+		get_ctx(ctx);
+		list_for_each_entry(sibling, &group_leader->sibling_list,
+				    group_entry) {
+			perf_install_in_context(ctx, sibling, cpu);
+			get_ctx(ctx);
+		}
+	}
+
 	perf_install_in_context(ctx, event, cpu);
 	++ctx->generation;
 	mutex_unlock(&ctx->mutex);
