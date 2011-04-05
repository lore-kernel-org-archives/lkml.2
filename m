Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1DEPgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:36:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:60414 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1DEPb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:31:29 -0400
Message-Id: <20110405152729.556674812@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 05 Apr 2011 17:23:59 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 21/21] sched: Remove need_migrate_task()
References: <20110405152338.692966333@chello.nl>
Content-Disposition: inline; filename=sched-opt-need_migrate_task.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg noticed that need_migrate_task() doesn't need the ->on_cpu check
now that ttwu() doesn't do remote enqueues for !->on_rq && ->on_cpu,
so remove the helper and replace the single instance with a direct
->on_rq test.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
---
 kernel/sched.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2139,21 +2139,6 @@ struct migration_arg {
 static int migration_cpu_stop(void *data);
 
 /*
- * The task's runqueue lock must be held.
- * Returns true if you have to wait for migration thread.
- */
-static bool need_migrate_task(struct task_struct *p)
-{
-	/*
-	 * If the task is not on a runqueue (and not running), then
-	 * the next wake-up will properly place the task.
-	 */
-	bool running = p->on_rq || p->on_cpu;
-	smp_rmb(); /* finish_lock_switch() */
-	return running;
-}
-
-/*
  * wait_task_inactive - wait for a thread to unschedule.
  *
  * If @match_state is nonzero, it's the @p->state value just checked and
@@ -5734,7 +5719,7 @@ int set_cpus_allowed_ptr(struct task_str
 		goto out;
 
 	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
-	if (need_migrate_task(p)) {
+	if (p->on_rq) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, p, &flags);


