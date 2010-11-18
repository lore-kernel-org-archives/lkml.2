Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab0KROMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:12:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:52100 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756999Ab0KROMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:12:21 -0500
Date: Thu, 18 Nov 2010 14:11:58 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101115234938.022488865@google.com>
References: <20101115234938.022488865@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Introduce hierarchal order on shares update list
Message-ID: <tip-67e86250f8ea7b8f7da53ac25ea73c6bd71f5cd9@git.kernel.org>
Git-Commit-ID: 67e86250f8ea7b8f7da53ac25ea73c6bd71f5cd9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:11:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67e86250f8ea7b8f7da53ac25ea73c6bd71f5cd9
Gitweb:     http://git.kernel.org/tip/67e86250f8ea7b8f7da53ac25ea73c6bd71f5cd9
Author:     Paul Turner <pjt@google.com>
AuthorDate: Mon, 15 Nov 2010 15:47:05 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:27:48 +0100

sched: Introduce hierarchal order on shares update list

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101115234938.022488865@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a543a5b..b320753 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -146,8 +146,20 @@ static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
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
@@ -2016,7 +2028,7 @@ out:
 /*
  * update tg->load_weight by folding this cpu's load_avg
  */
-static int tg_shares_up(struct task_group *tg, int cpu)
+static int update_shares_cpu(struct task_group *tg, int cpu)
 {
 	struct cfs_rq *cfs_rq;
 	unsigned long flags;
@@ -2056,14 +2068,8 @@ static void update_shares(int cpu)
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
 
