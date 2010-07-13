Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0GMVvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 17:51:33 -0400
Received: from smtp-out.google.com ([74.125.121.35]:62357 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab0GMVvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 17:51:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=Fl97p6YAWMWsEErJmrKPcG9glpL3LhDTr//rTtXN4Og9PmOXOj+qWLEHw0CNsIVFd
	gnBvBcOfR8k0WW/M9Kdxg==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] sched: clear_buddies cleanup for hierarchical clearing
Date: Tue, 13 Jul 2010 14:50:56 -0700
Message-Id: <1279057856-7141-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* dequeue_entity is calling clear_buddies() and doing hierarchical clear, when
dequeue_entity itself gets called for each level from dequeue_task_fair. Move
clear_buddies to dequeue_task_fair instead.

* Similar problem in pick_next_entity. Convert the call to __clear_buddies().

Also, clear_buddies is not using cfs_rq parameter. Removing that would
probably make it more distinct from __clear_buddies.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched_fair.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a878b53..37901c7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -793,7 +793,7 @@ static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		cfs_rq->next = NULL;
 }
 
-static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static void clear_buddies(struct sched_entity *se)
 {
 	for_each_sched_entity(se)
 		__clear_buddies(cfs_rq_of(se), se);
@@ -821,8 +821,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 #endif
 	}
 
-	clear_buddies(cfs_rq, se);
-
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	account_entity_dequeue(cfs_rq, se);
@@ -853,7 +851,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		 * The current task ran long enough, ensure it doesn't get
 		 * re-elected due to buddy favours.
 		 */
-		clear_buddies(cfs_rq, curr);
+		clear_buddies(curr);
 		return;
 	}
 
@@ -924,7 +922,7 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
 		se = cfs_rq->last;
 
-	clear_buddies(cfs_rq, se);
+	__clear_buddies(cfs_rq, se);
 
 	return se;
 }
@@ -1068,6 +1066,8 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
 
+	clear_buddies(se);
+
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
@@ -1097,7 +1097,7 @@ static void yield_task_fair(struct rq *rq)
 	if (unlikely(cfs_rq->nr_running == 1))
 		return;
 
-	clear_buddies(cfs_rq, se);
+	clear_buddies(se);
 
 	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
 		update_rq_clock(rq);
-- 
1.7.1

