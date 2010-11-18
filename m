Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab0KRON6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:13:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:52222 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758546Ab0KRON4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:13:56 -0500
Date: Thu, 18 Nov 2010 14:13:31 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101115234938.465521344@google.com>
References: <20101115234938.465521344@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Update tg->shares after cpu.shares write
Message-ID: <tip-9437178f623a19af5951808d880a8599f66ac150@git.kernel.org>
Git-Commit-ID: 9437178f623a19af5951808d880a8599f66ac150
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:13:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9437178f623a19af5951808d880a8599f66ac150
Gitweb:     http://git.kernel.org/tip/9437178f623a19af5951808d880a8599f66ac150
Author:     Paul Turner <pjt@google.com>
AuthorDate: Mon, 15 Nov 2010 15:47:10 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:27:50 +0100

sched: Update tg->shares after cpu.shares write

Formerly sched_group_set_shares would force a rebalance by overflowing domain
share sums.  Now that per-cpu averages are maintained we can set the true value
by issuing an update_cfs_shares() following a tg->shares update.

Also initialize tg se->load to 0 for consistency since we'll now set correct
weights on enqueue.

Signed-off-by: Paul Turner <pjt@google.com?>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101115234938.465521344@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   42 +++++++++++-------------------------------
 1 files changed, 11 insertions(+), 31 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e914a71..550cf3a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7646,7 +7646,7 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 		se->cfs_rq = parent->my_q;
 
 	se->my_q = cfs_rq;
-	update_load_set(&se->load, tg->shares);
+	update_load_set(&se->load, 0);
 	se->parent = parent;
 }
 #endif
@@ -8274,37 +8274,12 @@ void sched_move_task(struct task_struct *tsk)
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
@@ -8323,10 +8298,15 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 
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
