Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab2BPOOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:14:42 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50655 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2BPOOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:14:41 -0500
Message-ID: <4F3D0F41.1010205@linux.vnet.ibm.com>
Date: Thu, 16 Feb 2012 22:14:25 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.26) Gecko/20120131 Thunderbird/3.1.18
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4] sched: Avoid unnecessary work in reweight_entity
References: <4F2F9F6C.1090608@linux.vnet.ibm.com> <4F3089F9.6010609@linux.vnet.ibm.com> <4F308E25.7060101@linux.vnet.ibm.com> <4F31D9B2.5090501@linux.vnet.ibm.com>
In-Reply-To: <4F31D9B2.5090501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12021604-0260-0000-0000-0000008CE20C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

In original code, using account_entity_dequeue and account_entity_enqueue
as a pair will do some work unnecessary, such like remove node from list
and add it back again immediately.

And because there are no really enqueue and dequeue happen here, it is not
suitable to use account_entity_dequeue and account_entity_enqueue here.

This patch combine the work of them in order to save time.

v2:
	Add more description and revise wrong code.

v3:
	Mark add_cfs_task_weight and sub_add_cfs_task_weight as inline. 

v4:
	Now we invoke update_curr when really necessary. 

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c  |   27 +++++++++++++++++++++------
 kernel/sched/sched.h |    8 ++++++++
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c6414f..fda63ec 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -777,16 +777,28 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
  */
 
 #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
-static void
+static inline void
 add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
 {
 	cfs_rq->task_weight += weight;
 }
+
+static inline void
+sub_add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long sub, unsigned long add)
+{
+	cfs_rq->task_weight -= sub;
+	cfs_rq->task_weight += add;
+}
 #else
 static inline void
 add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
 {
 }
+
+static inline void
+sub_add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long sub, unsigned long add)
+{
+}
 #endif
 
 static void
@@ -938,6 +950,7 @@ static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
 {
 }
 # endif /* CONFIG_SMP */
+
 static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			    unsigned long weight)
 {
@@ -945,13 +958,15 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 		/* commit outstanding execution time */
 		if (cfs_rq->curr == se)
 			update_curr(cfs_rq);
-		account_entity_dequeue(cfs_rq, se);
+		update_load_sub_add(&cfs_rq->load, se->load.weight, weight);
+		if (!parent_entity(se)) {
+			update_load_sub_add(&rq_of(cfs_rq)->load, se->load.weight, weight);
+		}
+		if (entity_is_task(se)) {
+			sub_add_cfs_task_weight(cfs_rq, se->load.weight, weight);
+		}
 	}
-
 	update_load_set(&se->load, weight);
-
-	if (se->on_rq)
-		account_entity_enqueue(cfs_rq, se);
 }
 
 static void update_cfs_shares(struct cfs_rq *cfs_rq)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 98c0c26..ec4430f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -779,6 +779,14 @@ static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
 	lw->inv_weight = 0;
 }
 
+static inline void update_load_sub_add(struct load_weight *lw, unsigned long dec,
+					unsigned long inc)
+{
+	lw->weight -= dec;
+	lw->weight += inc;
+	lw->inv_weight = 0;
+}
+
 static inline void update_load_set(struct load_weight *lw, unsigned long w)
 {
 	lw->weight = w;
-- 
1.7.4.1

