Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab1CBRqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:46:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:59221 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1CBRqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:46:21 -0500
Message-Id: <20110302174120.903791269@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 02 Mar 2011 18:38:40 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/22] sched: Remove rq argument to sched_class::task_waking()
References: <20110302173831.295031866@chello.nl>
Content-Disposition: inline; filename=sched-task_waking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation of calling this without rq->lock held, remove the
dependency on the rq argument.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 include/linux/sched.h |   10 +++++++---
 kernel/sched.c        |    2 +-
 kernel/sched_fair.c   |    4 +++-
 3 files changed, 11 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1045,8 +1045,12 @@ struct sched_domain;
 #define WF_FORK		0x02		/* child wakeup after fork */
 
 #define ENQUEUE_WAKEUP		1
-#define ENQUEUE_WAKING		2
-#define ENQUEUE_HEAD		4
+#define ENQUEUE_HEAD		2
+#ifdef CONFIG_SMP
+#define ENQUEUE_WAKING		4	/* sched_class::task_waking was called */
+#else
+#define ENQUEUE_WAKING		0
+#endif
 
 #define DEQUEUE_SLEEP		1
 
@@ -1067,7 +1071,7 @@ struct sched_class {
 
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
-	void (*task_waking) (struct rq *this_rq, struct task_struct *task);
+	void (*task_waking) (struct task_struct *task);
 	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
 
 	void (*set_cpus_allowed)(struct task_struct *p,
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2481,7 +2481,7 @@ static int try_to_wake_up(struct task_st
 	p->state = TASK_WAKING;
 
 	if (p->sched_class->task_waking) {
-		p->sched_class->task_waking(rq, p);
+		p->sched_class->task_waking(p);
 		en_flags |= ENQUEUE_WAKING;
 	}
 
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1338,11 +1338,13 @@ static void yield_task_fair(struct rq *r
 
 #ifdef CONFIG_SMP
 
-static void task_waking_fair(struct rq *rq, struct task_struct *p)
+static void task_waking_fair(struct task_struct *p)
 {
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
+	lockdep_assert_held(&task_rq(p)->lock);
+
 	se->vruntime -= cfs_rq->min_vruntime;
 }
 


