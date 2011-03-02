Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab1CBRqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:46:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:45932 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab1CBRqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:46:50 -0500
Message-Id: <20110302174120.976363449@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 02 Mar 2011 18:38:41 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/22] sched: Deal with non-atomic min_vruntime reads on 32bits
References: <20110302173831.295031866@chello.nl>
Content-Disposition: inline; filename=sched-fair-fix-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid reading partial updated min_vruntime values on 32bit
implement a seqcount like solution.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched.c      |    3 +++
 kernel/sched_fair.c |   19 +++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -313,6 +313,9 @@ struct cfs_rq {
 
 	u64 exec_clock;
 	u64 min_vruntime;
+#ifndef CONFIG_64BIT
+	u64 min_vruntime_copy;
+#endif
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -365,6 +365,10 @@ static void update_min_vruntime(struct c
 	}
 
 	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
+#ifndef CONFIG_64BIT
+	smp_wmb();
+	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
+#endif
 }
 
 /*
@@ -1342,10 +1346,21 @@ static void task_waking_fair(struct task
 {
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	u64 min_vruntime;
 
-	lockdep_assert_held(&task_rq(p)->lock);
+#ifndef CONFIG_64BIT
+	u64 min_vruntime_copy;
 
-	se->vruntime -= cfs_rq->min_vruntime;
+	do {
+		min_vruntime_copy = cfs_rq->min_vruntime_copy;
+		smp_rmb();
+		min_vruntime = cfs_rq->min_vruntime;
+	} while (min_vruntime != min_vruntime_copy);
+#else
+	min_vruntime = cfs_rq->min_vruntime;
+#endif
+
+	se->vruntime -= min_vruntime;
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED


