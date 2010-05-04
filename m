Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab0EDMlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:41:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:51777 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758579Ab0EDMjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:39:17 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/12] perf: move perf_event_task_sched_in() next to fire_sched_notifiers_in()
Date: Tue,  4 May 2010 14:38:37 +0200
Message-Id: <1272976724-14312-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1272976724-14312-1-git-send-email-tj@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 12:38:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move perf_event_task_sched_in() after finish_lock_switch() right
before fire_sched_notifiers_in().  This costs an extra pair of irq
enable/disable when switching in a perf task context but allows
unifying event functions in a more flexible position (irq enabled, rq
lock released).

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/perf_event.c |    9 +++++++--
 kernel/sched.c      |    8 +-------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 73e2c1c..295699f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1369,14 +1369,17 @@ static void task_ctx_sched_in(struct task_struct *task,
  */
 void perf_event_task_sched_in(struct task_struct *task)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event_context *ctx = task->perf_event_ctxp;
+	struct perf_cpu_context *cpuctx;
 
 	if (likely(!ctx))
 		return;
 
+	local_irq_disable();
+
+	cpuctx = &__get_cpu_var(perf_cpu_context);
 	if (cpuctx->task_ctx == ctx)
-		return;
+		goto out_enable;
 
 	/*
 	 * We want to keep the following priority order:
@@ -1390,6 +1393,8 @@ void perf_event_task_sched_in(struct task_struct *task)
 	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
 
 	cpuctx->task_ctx = ctx;
+out_enable:
+	local_irq_enable();
 }
 
 #define MAX_INTERRUPTS (~0ULL)
diff --git a/kernel/sched.c b/kernel/sched.c
index 4c5e4c9..df6e0af 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2794,15 +2794,9 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 */
 	prev_state = prev->state;
 	finish_arch_switch(prev);
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	local_irq_disable();
-#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
-	perf_event_task_sched_in(current);
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	local_irq_enable();
-#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
 
+	perf_event_task_sched_in(current);
 	fire_sched_notifiers_in(current);
 	if (mm)
 		mmdrop(mm);
-- 
1.6.4.2

