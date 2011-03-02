Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1CBRqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:46:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:59222 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab1CBRqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:46:21 -0500
Message-Id: <20110302174121.488815361@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 02 Mar 2011 18:38:48 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 17/22] sched: Remove rq argument from ttwu_stat()
References: <20110302173831.295031866@chello.nl>
Content-Disposition: inline; filename=sched-ttwu_stat-rq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to call ttwu_stat() without holding rq->lock we must remove
its rq argument. Since we need to change rq stats, account to the
local rq instead of the task rq, this is safe since we have IRQs
disabled.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2367,10 +2367,11 @@ static void update_avg(u64 *avg, u64 sam
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
@@ -2491,9 +2492,10 @@ try_to_wake_up(struct task_struct *p, un
 	activate_task(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
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
@@ -2527,7 +2529,7 @@ static void try_to_wake_up_local(struct 
 		activate_task(rq, p, ENQUEUE_WAKEUP);
 
 	ttwu_post_activation(p, rq, 0);
-	ttwu_stat(rq, p, smp_processor_id(), 0);
+	ttwu_stat(p, smp_processor_id(), 0);
 out:
 	raw_spin_unlock(&p->pi_lock);
 }


