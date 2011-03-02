Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab1CBRq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:46:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:59238 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab1CBRq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:46:26 -0500
Message-Id: <20110302174121.342846338@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 02 Mar 2011 18:38:46 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 15/22] sched: Drop rq->lock from sched_exec()
References: <20110302173831.295031866@chello.nl>
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
LKML-Reference: <new-submission>
---
 kernel/sched.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3454,27 +3454,22 @@ void sched_exec(void)
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
 
-		task_rq_unlock(rq, p, &flags);
-		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
+		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		stop_one_cpu(task_cpu(p), migration_cpu_stop, &arg);
 		return;
 	}
 unlock:
-	task_rq_unlock(rq, p, &flags);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 }
 
 #endif


