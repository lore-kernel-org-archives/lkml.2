Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab0KLDcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:32:54 -0500
Received: from smtp-out.google.com ([216.239.44.51]:3914 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab0KLDcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:32:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
	b=az5lxlz2ZjDTDLTHiMaafYrXEGqNtn2nJ4HwHnx1YpMfDtzl8qCk8n3MPZTjjOzgY
	Nlc/oTn0DU5W5EpgS+PCg==
Message-Id: <20101112032701.790605539@google.com>
References: <20101112032405.657789056@google.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Nov 2010 19:24:11 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Subject: [tg_shares_up rewrite v3 06/11] sched: hierarchal order on shares update list
Content-Disposition: inline; filename=sched-tg-order-ondemand-list.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid duplicate shares update calls by ensuring children always appear before
parents in rq->leaf_cfs_rq_list.

This allows us to do a single in-order traversal for update_shares().

Since we always enqueue in bottom-up order this reduces to 2 cases:
1) Our parent is already in the list, e.g.

   root
     \
      b
      /\
      c d* (root->b->c already enqueued)

Since d's parent is enqueued we push it to the head of the list, implicitly ahead of b.

2) Our parent does not appear in the list (or we have no parent)
In this case we enqueue to the tail of the list, if our parent is subsequently enqueued 
(bottom-up) it will appear to our right by the same rule.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched_fair.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

Index: kernel/sched_fair.c
===================================================================
--- kernel/sched_fair.c.orig
+++ kernel/sched_fair.c
@@ -146,8 +146,20 @@ static inline struct cfs_rq *cpu_cfs_rq(
 static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	if (!cfs_rq->on_list) {
-		list_add_rcu(&cfs_rq->leaf_cfs_rq_list,
+		/*
+		 * Ensure we either appear before our parent (if already
+		 * enqueued) or force our parent to appear after us when it is
+		 * enqueued.  The fact that we always enqueue bottom-up
+		 * reduces this to two cases.
+		 */
+		if (cfs_rq->tg->parent &&
+		    cfs_rq->tg->parent->cfs_rq[cpu_of(rq_of(cfs_rq))]->on_list) {
+			list_add_rcu(&cfs_rq->leaf_cfs_rq_list,
+				&rq_of(cfs_rq)->leaf_cfs_rq_list);
+		} else {
+			list_add_tail_rcu(&cfs_rq->leaf_cfs_rq_list,
 				&rq_of(cfs_rq)->leaf_cfs_rq_list);
+		}
 
 		cfs_rq->on_list = 1;
 	}
@@ -2009,7 +2021,7 @@ out:
 /*
  * update tg->load_weight by folding this cpu's load_avg
  */
-static int tg_shares_up(struct task_group *tg, int cpu)
+static int update_shares_cpu(struct task_group *tg, int cpu)
 {
 	struct cfs_rq *cfs_rq;
 	unsigned long flags;
@@ -2049,14 +2061,8 @@ static void update_shares(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 
 	rcu_read_lock();
-	for_each_leaf_cfs_rq(rq, cfs_rq) {
-		struct task_group *tg = cfs_rq->tg;
-
-		do {
-			tg_shares_up(tg, cpu);
-			tg = tg->parent;
-		} while (tg);
-	}
+	for_each_leaf_cfs_rq(rq, cfs_rq)
+		update_shares_cpu(cfs_rq->tg, cpu);
 	rcu_read_unlock();
 }
 

-- 

