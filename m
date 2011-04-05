Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1DFBEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 21:04:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:26274 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab1DFBEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 21:04:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,307,1299484800"; 
   d="scan'208";a="675687549"
From: Alex Shi <alex.shi@intel.com>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu,
        tim.c.chen@intel.com, shaohua.li@intel.com
Subject: [PATCH] sched: recover sched_yield task running time increase
Date: Wed,  6 Apr 2011 06:33:43 +0800
Message-Id: <1302042823-23022-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ac53db596cc08ecb8040c removed the sched_yield task running
time increase, so the yielded task get more opportunity to be launch
again. That may not the caller want to be. And this also causes
volano benchmark drop 50~80 percent performance on core2/NHM/WSM
machines. This patch recover the sched_yield task vruntime up.

Signed-off-by: alex.shi@intel.com
---
 kernel/sched_fair.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3f7ec9e..04d58bb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1956,7 +1956,7 @@ static void yield_task_fair(struct rq *rq)
 {
 	struct task_struct *curr = rq->curr;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
-	struct sched_entity *se = &curr->se;
+	struct sched_entity *se = &curr->se, *rightmost;
 
 	/*
 	 * Are we the only task in the tree?
@@ -1975,6 +1975,22 @@ static void yield_task_fair(struct rq *rq)
 	}
 
 	set_skip_buddy(se);
+	/*
+	 * Find the rightmost entry in the rbtree:
+	 */
+	rightmost = __pick_last_entity(cfs_rq);
+	/*
+	 * Already in the rightmost position?
+	 */
+	if (unlikely(!rightmost || entity_before(rightmost, se)))
+		return;
+
+	/*
+	 * Minimally necessary key value to be last in the tree:
+	 * Upon rescheduling, sched_class::put_prev_task() will place
+	 * 'current' within the tree based on its new key value.
+	 */
+	se->vruntime = rightmost->vruntime + 1;
 }
 
 static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preempt)
-- 
1.6.0

