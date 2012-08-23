Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab2HWOQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:16:22 -0400
Received: from mail-fa0-f74.google.com ([209.85.161.74]:58480 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812Ab2HWOPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:15:32 -0400
Message-Id: <20120823141506.855074415@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 23 Aug 2012 07:14:30 -0700
From: pjt@google.com
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ben Segall <bsegall@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [patch 08/16] sched: compute load contribution by a group entity
References: <20120823141422.444396696@google.com>
Content-Disposition: inline; filename=sched-cfs_rq_contrib.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Turner <pjt@google.com>

Unlike task entities who have a fixed weight, group entities instead own a
fraction of their parenting task_group's shares as their contributed weight.

Compute this fraction so that we can correctly account hierarchies and shared
entity nodes.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/fair.c |   33 +++++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 40259cc..92ef5f1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1111,22 +1111,43 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 		cfs_rq->tg_load_contrib += tg_contrib;
 	}
 }
+
+static inline void __update_group_entity_contrib(struct sched_entity *se)
+{
+	struct cfs_rq *cfs_rq = group_cfs_rq(se);
+	struct task_group *tg = cfs_rq->tg;
+	u64 contrib;
+
+	contrib = cfs_rq->tg_load_contrib * tg->shares;
+	se->avg.load_avg_contrib = div64_u64(contrib,
+					     atomic64_read(&tg->load_avg) + 1);
+}
 #else
 static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 						 int force_update) {}
+static inline void __update_group_entity_contrib(struct sched_entity *se) {}
 #endif
 
+static inline void __update_task_entity_contrib(struct sched_entity *se)
+{
+	u32 contrib;
+
+	/* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
+	contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
+	contrib /= (se->avg.runnable_avg_period + 1);
+	se->avg.load_avg_contrib = scale_load(contrib);
+}
+
 /* Compute the current contribution to load_avg by se, return any delta */
 static long __update_entity_load_avg_contrib(struct sched_entity *se)
 {
 	long old_contrib = se->avg.load_avg_contrib;
 
-	if (!entity_is_task(se))
-		return 0;
-
-	se->avg.load_avg_contrib = div64_u64(se->avg.runnable_avg_sum *
-					     se->load.weight,
-					     se->avg.runnable_avg_period + 1);
+	if (entity_is_task(se)) {
+		__update_task_entity_contrib(se);
+	} else {
+		__update_group_entity_contrib(se);
+	}
 
 	return se->avg.load_avg_contrib - old_contrib;
 }


