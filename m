Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab1DEPg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:36:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:60413 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab1DEPb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:31:29 -0400
Message-Id: <20110405152729.394638826@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 05 Apr 2011 17:23:55 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 17/21] sched: Remove rq argument from ttwu_stat()
References: <20110405152338.692966333@chello.nl>
Content-Disposition: inline; filename=sched-ttwu_stat-rq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to call ttwu_stat() without holding rq->lock we must remove
its rq argument. Since we need to change rq stats, account to the
local rq instead of the task rq, this is safe since we have IRQs
disabled.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
---
 kernel/sched.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2413,10 +2413,11 @@ static void update_avg(u64 *avg, u64 sam
 #endif
 
 static void
-ttwu_stat(struct rq *rq, struct task_struct *p, int cpu, int wake_flags)
+ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 {
 #ifdef CONFIG_SCHEDSTATS
 	int this_cpu = smp_processor_id();
+	struct rq *rq = this_rq();
 
 	schedstat_inc(rq, ttwu_count);
 	schedstat_inc(p, se.statistics.nr_wakeups);
@@ -2555,9 +2556,10 @@ try_to_wake_up(struct task_struct *p, un
 	p->on_rq = 1;
 out_running:
 	ttwu_post_activation(p, rq, wake_flags);
-	ttwu_stat(rq, p, cpu, wake_flags);
 	success = 1;
 	__task_rq_unlock(rq);
+
+	ttwu_stat(p, cpu, wake_flags);
 out:
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 	put_cpu();
@@ -2591,7 +2593,7 @@ static void try_to_wake_up_local(struct 
 		activate_task(rq, p, ENQUEUE_WAKEUP);
 
 	ttwu_post_activation(p, rq, 0);
-	ttwu_stat(rq, p, smp_processor_id(), 0);
+	ttwu_stat(p, smp_processor_id(), 0);
 out:
 	raw_spin_unlock(&p->pi_lock);
 }


