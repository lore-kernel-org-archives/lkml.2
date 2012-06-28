Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab2F1C7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:59:36 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:45962 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125Ab2F1C4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:56:25 -0400
Subject: [PATCH 08/16] sched: compute load contribution by a group entity
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 27 Jun 2012 19:24:14 -0700
Message-ID: <20120628022414.30496.3398.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike task entities who have a fixed weight, group entities instead own a
fraction of their parenting task_group's shares as their contributed weight.

Compute this fraction so that we can correctly account hierarchies and shared
entity nodes.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/fair.c |   33 +++++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fbb9686..a416296 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1116,22 +1116,43 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
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


