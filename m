Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab2JXKAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:00:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55085 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758108Ab2JXKAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:00:05 -0400
Date: Wed, 24 Oct 2012 02:58:38 -0700
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-e9c84cb8d5f1b1ea6fcbe6190d51dc84b6975938@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1341316406.23484.64.camel@twins>
References: <1341316406.23484.64.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Describe CFS load-balancer
Git-Commit-ID: e9c84cb8d5f1b1ea6fcbe6190d51dc84b6975938
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:58:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9c84cb8d5f1b1ea6fcbe6190d51dc84b6975938
Gitweb:     http://git.kernel.org/tip/e9c84cb8d5f1b1ea6fcbe6190d51dc84b6975938
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 3 Jul 2012 13:53:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:27:33 +0200

sched: Describe CFS load-balancer

Add some scribbles on how and why the load-balancer works..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1341316406.23484.64.camel@twins
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |  118 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3e6a353..a319d56c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3456,8 +3456,122 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
 
 #ifdef CONFIG_SMP
 /**************************************************
- * Fair scheduling class load-balancing methods:
- */
+ * Fair scheduling class load-balancing methods.
+ *
+ * BASICS
+ *
+ * The purpose of load-balancing is to achieve the same basic fairness the
+ * per-cpu scheduler provides, namely provide a proportional amount of compute
+ * time to each task. This is expressed in the following equation:
+ *
+ *   W_i,n/P_i == W_j,n/P_j for all i,j                               (1)
+ *
+ * Where W_i,n is the n-th weight average for cpu i. The instantaneous weight
+ * W_i,0 is defined as:
+ *
+ *   W_i,0 = \Sum_j w_i,j                                             (2)
+ *
+ * Where w_i,j is the weight of the j-th runnable task on cpu i. This weight
+ * is derived from the nice value as per prio_to_weight[].
+ *
+ * The weight average is an exponential decay average of the instantaneous
+ * weight:
+ *
+ *   W'_i,n = (2^n - 1) / 2^n * W_i,n + 1 / 2^n * W_i,0               (3)
+ *
+ * P_i is the cpu power (or compute capacity) of cpu i, typically it is the
+ * fraction of 'recent' time available for SCHED_OTHER task execution. But it
+ * can also include other factors [XXX].
+ *
+ * To achieve this balance we define a measure of imbalance which follows
+ * directly from (1):
+ *
+ *   imb_i,j = max{ avg(W/P), W_i/P_i } - min{ avg(W/P), W_j/P_j }    (4)
+ *
+ * We them move tasks around to minimize the imbalance. In the continuous
+ * function space it is obvious this converges, in the discrete case we get
+ * a few fun cases generally called infeasible weight scenarios.
+ *
+ * [XXX expand on:
+ *     - infeasible weights;
+ *     - local vs global optima in the discrete case. ]
+ *
+ *
+ * SCHED DOMAINS
+ *
+ * In order to solve the imbalance equation (4), and avoid the obvious O(n^2)
+ * for all i,j solution, we create a tree of cpus that follows the hardware
+ * topology where each level pairs two lower groups (or better). This results
+ * in O(log n) layers. Furthermore we reduce the number of cpus going up the
+ * tree to only the first of the previous level and we decrease the frequency
+ * of load-balance at each level inv. proportional to the number of cpus in
+ * the groups.
+ *
+ * This yields:
+ *
+ *     log_2 n     1     n
+ *   \Sum       { --- * --- * 2^i } = O(n)                            (5)
+ *     i = 0      2^i   2^i
+ *                               `- size of each group
+ *         |         |     `- number of cpus doing load-balance
+ *         |         `- freq
+ *         `- sum over all levels
+ *
+ * Coupled with a limit on how many tasks we can migrate every balance pass,
+ * this makes (5) the runtime complexity of the balancer.
+ *
+ * An important property here is that each CPU is still (indirectly) connected
+ * to every other cpu in at most O(log n) steps:
+ *
+ * The adjacency matrix of the resulting graph is given by:
+ *
+ *             log_2 n     
+ *   A_i,j = \Union     (i % 2^k == 0) && i / 2^(k+1) == j / 2^(k+1)  (6)
+ *             k = 0
+ *
+ * And you'll find that:
+ *
+ *   A^(log_2 n)_i,j != 0  for all i,j                                (7)
+ *
+ * Showing there's indeed a path between every cpu in at most O(log n) steps.
+ * The task movement gives a factor of O(m), giving a convergence complexity
+ * of:
+ *
+ *   O(nm log n),  n := nr_cpus, m := nr_tasks                        (8)
+ *
+ *
+ * WORK CONSERVING
+ *
+ * In order to avoid CPUs going idle while there's still work to do, new idle
+ * balancing is more aggressive and has the newly idle cpu iterate up the domain
+ * tree itself instead of relying on other CPUs to bring it work.
+ *
+ * This adds some complexity to both (5) and (8) but it reduces the total idle
+ * time.
+ *
+ * [XXX more?]
+ *
+ *
+ * CGROUPS
+ *
+ * Cgroups make a horror show out of (2), instead of a simple sum we get:
+ *
+ *                                s_k,i
+ *   W_i,0 = \Sum_j \Prod_k w_k * -----                               (9)
+ *                                 S_k
+ *
+ * Where
+ *
+ *   s_k,i = \Sum_j w_i,j,k  and  S_k = \Sum_i s_k,i                 (10)
+ *
+ * w_i,j,k is the weight of the j-th runnable task in the k-th cgroup on cpu i.
+ *
+ * The big problem is S_k, its a global sum needed to compute a local (W_i)
+ * property.
+ *
+ * [XXX write more on how we solve this.. _after_ merging pjt's patches that
+ *      rewrite all of this once again.]
+ */ 
 
 static unsigned long __read_mostly max_load_balance_interval = HZ/10;
 
