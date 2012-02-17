Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab2BQGEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 01:04:34 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:40925 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2BQGEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 01:04:33 -0500
Message-ID: <4F3DEDC3.4010004@linux.vnet.ibm.com>
Date: Fri, 17 Feb 2012 14:03:47 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.26) Gecko/20120131 Thunderbird/3.1.18
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v5] sched: Avoid unnecessary work in reweight_entity
References: <4F2F9F6C.1090608@linux.vnet.ibm.com> <4F3089F9.6010609@linux.vnet.ibm.com> <4F308E25.7060101@linux.vnet.ibm.com> <4F31D9B2.5090501@linux.vnet.ibm.com> <4F3D0F41.1010205@linux.vnet.ibm.com> <1329402561.2293.225.camel@twins>
In-Reply-To: <1329402561.2293.225.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12021620-3568-0000-0000-00000139D969
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

since v1:
	Add more description.
	Mark add_cfs_task_weight as inline. 
	correct useless and wrong code. 
	Add check point for the case there is no change on weight.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c6414f..20aa355 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -777,7 +777,7 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
  */
 
 #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
-static void
+static inline void
 add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
 {
 	cfs_rq->task_weight += weight;
@@ -938,20 +938,24 @@ static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
 {
 }
 # endif /* CONFIG_SMP */
+
 static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			    unsigned long weight)
 {
+	if (weight == se->load.weight)
+		return;
+
 	if (se->on_rq) {
 		/* commit outstanding execution time */
 		if (cfs_rq->curr == se)
 			update_curr(cfs_rq);
-		account_entity_dequeue(cfs_rq, se);
+		update_load_add(&cfs_rq->load, weight - se->load.weight);
+		if (!parent_entity(se))
+			update_load_add(&rq_of(cfs_rq)->load, weight - se->load.weight);
+		if (entity_is_task(se))
+			add_cfs_task_weight(cfs_rq, weight - se->load.weight);
 	}
-
 	update_load_set(&se->load, weight);
-
-	if (se->on_rq)
-		account_entity_enqueue(cfs_rq, se);
 }
 
 static void update_cfs_shares(struct cfs_rq *cfs_rq)
-- 
1.7.4.1

