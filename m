Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2APJhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:37:11 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:50877 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab2APJhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:37:09 -0500
Message-ID: <4F13EFBE.1030002@linux.vnet.ibm.com>
Date: Mon, 16 Jan 2012 17:37:02 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: Accelerate "pick_next_entity" under special condition
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011600-3568-0000-0000-0000010FB57A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

We can avoid some useless operation in some special condition.

For example:
If we have "cfs_rq->next" and it can be use, we just return it directly.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 84adb2d..9fc2c3c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1295,6 +1295,8 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static int
 wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
 
+#define ENTITY_PREEMPT_ALLOWED(prev,next)	(wakeup_preempt_entity(prev, next) < 1)
+
 /*
  * Pick the next process, keeping these things in mind, in this order:
  * 1) keep things fair between processes/task groups
@@ -1308,29 +1310,33 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 	struct sched_entity *left = se;
 
 	/*
-	 * Avoid running the skip buddy, if running something else can
-	 * be done without getting too unfair.
+	 * Someone really wants this to run. If it's not unfair, run it.
 	 */
-	if (cfs_rq->skip == se) {
-		struct sched_entity *second = __pick_next_entity(se);
-		if (second && wakeup_preempt_entity(second, left) < 1)
-			se = second;
+	if (cfs_rq->next && ENTITY_PREEMPT_ALLOWED(cfs_rq->next, left)) {
+		se = cfs_rq->next;
+		goto out;
 	}
 
 	/*
 	 * Prefer last buddy, try to return the CPU to a preempted task.
 	 */
-	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
+	if (cfs_rq->last && ENTITY_PREEMPT_ALLOWED(cfs_rq->last, left)) {
 		se = cfs_rq->last;
+		goto out;
+	}
 
 	/*
-	 * Someone really wants this to run. If it's not unfair, run it.
+	 * Avoid running the skip buddy, if running something else can
+	 * be done without getting too unfair.
 	 */
-	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
-		se = cfs_rq->next;
+	if (cfs_rq->skip == se) {
+		struct sched_entity *second = __pick_next_entity(se);
+		if (second && ENTITY_PREEMPT_ALLOWED(second, left))
+			se = second;
+	}
 
+out:
 	clear_buddies(cfs_rq, se);
-
 	return se;
 }
 
-- 
1.7.4.1

