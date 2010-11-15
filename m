Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab0KOXw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:52:59 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37265 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758871Ab0KOXw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:52:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=sBXwSbOXsMfx1rQSysN5FGcFpPtife3rec+Z80c+tOzCqnYVGpQt9a5h3MJK0NUO7
	xye1nmlFhR80RF5CBre0w==
Message-Id: <20101115234938.465521344@google.com>
User-Agent: quilt/0.48-1
Date: Mon, 15 Nov 2010 15:47:10 -0800
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
Subject: [tg_shares_up rewrite v4 11/11] sched: update tg->shares after cpu.shares write
References: <20101115234659.610333554@google.com>
Content-Disposition: inline; filename=sched-tg-fix_group_set_shares.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Formerly sched_group_set_shares would force a rebalance by overflowing domain
share sums.  Now that per-cpu averages are maintained we can set the true value
by issuing an update_cfs_shares() following a tg->shares update.

Also initialize tg se->load to 0 for consistency since we'll now set correct
weights on enqueue.

Signed-off-by: Paul Turner <pjt@google.com?>

---
 kernel/sched.c |   42 +++++++++++-------------------------------
 1 file changed, 11 insertions(+), 31 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -7747,7 +7747,7 @@ static void init_tg_cfs_entry(struct tas
 		se->cfs_rq = parent->my_q;
 
 	se->my_q = cfs_rq;
-	update_load_set(&se->load, tg->shares);
+	update_load_set(&se->load, 0);
 	se->parent = parent;
 }
 #endif
@@ -8375,37 +8375,12 @@ void sched_move_task(struct task_struct 
 #endif /* CONFIG_CGROUP_SCHED */
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void __set_se_shares(struct sched_entity *se, unsigned long shares)
-{
-	struct cfs_rq *cfs_rq = se->cfs_rq;
-	int on_rq;
-
-	on_rq = se->on_rq;
-	if (on_rq)
-		dequeue_entity(cfs_rq, se, 0);
-
-	update_load_set(&se->load, shares);
-
-	if (on_rq)
-		enqueue_entity(cfs_rq, se, 0);
-}
-
-static void set_se_shares(struct sched_entity *se, unsigned long shares)
-{
-	struct cfs_rq *cfs_rq = se->cfs_rq;
-	struct rq *rq = cfs_rq->rq;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	__set_se_shares(se, shares);
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-}
-
 static DEFINE_MUTEX(shares_mutex);
 
 int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 {
 	int i;
+	unsigned long flags;
 
 	/*
 	 * We can't change the weight of the root cgroup.
@@ -8424,10 +8399,15 @@ int sched_group_set_shares(struct task_g
 
 	tg->shares = shares;
 	for_each_possible_cpu(i) {
-		/*
-		 * force a rebalance
-		 */
-		set_se_shares(tg->se[i], shares);
+		struct rq *rq = cpu_rq(i);
+		struct sched_entity *se;
+
+		se = tg->se[i];
+		/* Propagate contribution to hierarchy */
+		raw_spin_lock_irqsave(&rq->lock, flags);
+		for_each_sched_entity(se)
+			update_cfs_shares(group_cfs_rq(se), 0);
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
 
 done:


