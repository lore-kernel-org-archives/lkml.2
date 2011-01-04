Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1ADPMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:12:23 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54904 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab1ADPMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:12:18 -0500
Message-Id: <20110104150102.961618351@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jan 2011 15:59:42 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 13/18] sched: Drop rq->lock from sched_exec()
References: <20110104145929.772813816@chello.nl>
Content-Disposition: inline; filename=sched-exec.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we can now call select_task_rq() and set_task_cpu() with only
p->pi_lock held, and sched_exec() load-balancing has always been
optimistic, drop all rq->lock usage.

Oleg also noted that need_migrate_task() will always be true for
current, so don't bother calling that at all.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3412,27 +3412,22 @@ void sched_exec(void)
 {
 	struct task_struct *p = current;
 	unsigned long flags;
-	struct rq *rq;
 	int dest_cpu;
 
-	rq = task_rq_lock(p, &flags);
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == smp_processor_id())
 		goto unlock;
 
-	/*
-	 * select_task_rq() can race against ->cpus_allowed
-	 */
-	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
-	    likely(cpu_active(dest_cpu)) && need_migrate_task(p)) {
+	if (likely(cpu_active(dest_cpu))) {
 		struct migration_arg arg = { p, dest_cpu };
 
-		task_rq_unlock(rq, &flags);
-		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
+		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		stop_one_cpu(task_cpu(p), migration_cpu_stop, &arg);
 		return;
 	}
 unlock:
-	task_rq_unlock(rq, &flags);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 }
 
 #endif


