Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2BBBpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:45:38 -0500
Received: from mail-gy0-f202.google.com ([209.85.160.202]:34764 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab2BBBnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:43:22 -0500
Subject: [RFC PATCH 07/14] sched: compute load contribution by a group entity
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 01 Feb 2012 17:38:26 -0800
Message-ID: <20120202013826.20844.90160.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
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
 kernel/sched/fair.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7771003..6d8af5e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1096,17 +1096,34 @@ static inline u64 __synchronize_entity_decay(struct sched_entity *se)
 	return decays;
 }
 
+static inline void __update_task_entity_contrib(struct sched_entity *se)
+{
+	se->avg.load_avg_contrib = div64_u64(se->avg.runnable_avg_sum *
+					     se->load.weight,
+					     se->avg.runnable_avg_period + 1);
+}
+
+static inline void __update_group_entity_contrib(struct sched_entity *se)
+{
+	struct cfs_rq *cfs_rq = group_cfs_rq(se);
+	struct task_group *tg = cfs_rq->tg;
+
+	se->avg.load_avg_contrib = (cfs_rq->tg_load_contrib * tg->shares);
+	se->avg.load_avg_contrib /= atomic64_read(&tg->load_avg) + 1;
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
+		if (!se->on_rq)
+			__synchronize_entity_decay(se);
+		__update_group_entity_contrib(se);
+	}
 
 	return se->avg.load_avg_contrib - old_contrib;
 }


