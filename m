Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab2GCLyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:54:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:51843 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab2GCLyE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:54:04 -0400
Message-ID: <1341316406.23484.64.camel@twins>
Subject: Re: [PATCH 13/40] autonuma: CPU follow memory algorithm
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 03 Jul 2012 13:53:26 +0200
In-Reply-To: <1340894776.28750.44.camel@twins>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
	 <1340888180-15355-14-git-send-email-aarcange@redhat.com>
	 <1340894776.28750.44.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 16:46 +0200, Peter Zijlstra wrote:
> As it stands you wrote a lot of words.. but none of them were really
> helpful in understanding what you do. 

Can you write something like the below for autonuma?

That is, present what your balancing goals are and why and in what
measures and at what cost.

Present it in 'proper' math, not examples.

Don't try and make it perfect -- the below isn't, just try and make it a
coherent story.

As a side note, anybody has a good way to show 7 follows from 6 other
than waving hands? One has to show 6 is fully connected and that the max
path length is indeed log n. I spend an hour last night trying but I've
forgotten too much of graph theory to make it stick.

---
 kernel/sched/fair.c | 118 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 116 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3704ad3..2e44318 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3077,8 +3077,122 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
 
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
 

