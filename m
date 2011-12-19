Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab1LSIeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 03:34:05 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:51097 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1LSIeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 03:34:03 -0500
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: [RFC PATCH 4/4] sched:Implement set_gang_buddy
To: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Date: Mon, 19 Dec 2011 14:05:13 +0530
Message-ID: <20111219083504.32311.85836.stgit@abhimanyu.in.ibm.com>
In-Reply-To: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11121908-8878-0000-0000-0000009F55E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_next_buddy does not guarantee the pickup of the gang task because of the
preempt check. This sometimes hurts gang scheduling. Introducing
set_gang_buddy api to pick up gang tasks unconditionally.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
---

 kernel/sched/fair.c  |   31 ++++++++++++++++++++++++++++++-
 kernel/sched/sched.h |    2 +-
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9a2f291..38f97b6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1165,6 +1165,17 @@ static void __clear_buddies_skip(struct sched_entity *se)
 	}
 }
 
+static void __clear_buddies_gang(struct sched_entity *se)
+{
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		if (cfs_rq->gang == se)
+			cfs_rq->gang = NULL;
+		else
+			break;
+	}
+}
+
 static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	if (cfs_rq->last == se)
@@ -1175,6 +1186,9 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 	if (cfs_rq->skip == se)
 		__clear_buddies_skip(se);
+
+	if (cfs_rq->gang == se)
+		__clear_buddies_gang(se);
 }
 
 static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
@@ -1331,6 +1345,12 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
 		se = cfs_rq->next;
 
+	/*
+	 * Gang buddy, lets be unfair here
+	 */
+	if (cfs_rq->gang)
+		se = cfs_rq->gang;
+
 	clear_buddies(cfs_rq, se);
 
 	return se;
@@ -2929,6 +2949,15 @@ static void set_skip_buddy(struct sched_entity *se)
 		cfs_rq_of(se)->skip = se;
 }
 
+static void set_gang_buddy(struct sched_entity *se)
+{
+	if (entity_is_task(se) && unlikely(task_of(se)->policy == SCHED_IDLE))
+		return;
+
+	for_each_sched_entity(se)
+		cfs_rq_of(se)->gang = se;
+}
+
 /*
  * Preempt the current task with a newly woken task if needed:
  */
@@ -5521,7 +5550,7 @@ static void gang_sched_member(void *info)
 		struct sched_entity *se = tg->se[cpu];
 
 		/* Make the parent favourable */
-		set_next_buddy(se);
+		set_gang_buddy(se);
 		set_tsk_need_resched(current);
 	}
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index db8369f..a96731f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -226,7 +226,7 @@ struct cfs_rq {
 	 * 'curr' points to currently running entity on this cfs_rq.
 	 * It is set to NULL otherwise (i.e when none are currently running).
 	 */
-	struct sched_entity *curr, *next, *last, *skip;
+	struct sched_entity *curr, *next, *last, *skip, *gang;
 
 #ifdef	CONFIG_SCHED_DEBUG
 	unsigned int nr_spread_over;

