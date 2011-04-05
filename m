Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab1DEPbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:31:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58018 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab1DEPbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:31:36 -0400
Message-Id: <20110405152729.151523907@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 05 Apr 2011 17:23:49 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 11/21] sched: Delay task_contributes_to_load() 
References: <20110405152338.692966333@chello.nl>
Content-Disposition: inline; filename=sched-ttwu-contribute-to-load.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In prepratation of having to call task_contributes_to_load() without
holding rq->lock, we need to store the result until we do and can
update the rq accounting accordingly.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   16 ++++------------
 2 files changed, 5 insertions(+), 12 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1264,6 +1264,7 @@ struct task_struct {
 
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
+	unsigned sched_contributes_to_load:1;
 
 	pid_t pid;
 	pid_t tgid;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2467,18 +2467,7 @@ static int try_to_wake_up(struct task_st
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
 
-	/*
-	 * In order to handle concurrent wakeups and release the rq->lock
-	 * we put the task in TASK_WAKING state.
-	 *
-	 * First fix up the nr_uninterruptible count:
-	 */
-	if (task_contributes_to_load(p)) {
-		if (likely(cpu_online(orig_cpu)))
-			rq->nr_uninterruptible--;
-		else
-			this_rq()->nr_uninterruptible--;
-	}
+	p->sched_contributes_to_load = !!task_contributes_to_load(p);
 	p->state = TASK_WAKING;
 
 	if (p->sched_class->task_waking) {
@@ -2503,6 +2492,9 @@ static int try_to_wake_up(struct task_st
 	WARN_ON(task_cpu(p) != cpu);
 	WARN_ON(p->state != TASK_WAKING);
 
+	if (p->sched_contributes_to_load)
+		rq->nr_uninterruptible--;
+
 out_activate:
 #endif /* CONFIG_SMP */
 	activate_task(rq, p, en_flags);


