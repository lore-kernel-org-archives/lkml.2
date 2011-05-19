Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934675Ab1ESU1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:27:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54203 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934624Ab1ESU1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:27:50 -0400
Date: Thu, 19 May 2011 22:27:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes for v2.6.40
Message-ID: <20110519202735.GA18355@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-urgent-for-linus

This is the sched/urgent queue left over from the v2.6.39 cycle.

 Thanks,

	Ingo

------------------>
Cheng Xu (1):
      sched: Fix rt_rq runtime leakage bug


 kernel/sched_rt.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index e7cebdc..f8fcf82 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -183,6 +183,14 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 	return ktime_to_ns(rt_rq->tg->rt_bandwidth.rt_period);
 }
 
+typedef struct task_group *rt_rq_iter_t;
+
+#define for_each_rt_rq(rt_rq, iter, rq) \
+	for (iter = list_entry_rcu(task_groups.next, typeof(*iter), list); \
+	     (&iter->list != &task_groups) && \
+	     (rt_rq = iter->rt_rq[cpu_of(rq)]); \
+	     iter = list_entry_rcu(iter->list.next, typeof(*iter), list))
+
 static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
 {
 	list_add_rcu(&rt_rq->leaf_rt_rq_list,
@@ -288,6 +296,11 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 	return ktime_to_ns(def_rt_bandwidth.rt_period);
 }
 
+typedef struct rt_rq *rt_rq_iter_t;
+
+#define for_each_rt_rq(rt_rq, iter, rq) \
+	for ((void) iter, rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
+
 static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
 {
 }
@@ -402,12 +415,13 @@ next:
 static void __disable_runtime(struct rq *rq)
 {
 	struct root_domain *rd = rq->rd;
+	rt_rq_iter_t iter;
 	struct rt_rq *rt_rq;
 
 	if (unlikely(!scheduler_running))
 		return;
 
-	for_each_leaf_rt_rq(rt_rq, rq) {
+	for_each_rt_rq(rt_rq, iter, rq) {
 		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 		s64 want;
 		int i;
@@ -487,6 +501,7 @@ static void disable_runtime(struct rq *rq)
 
 static void __enable_runtime(struct rq *rq)
 {
+	rt_rq_iter_t iter;
 	struct rt_rq *rt_rq;
 
 	if (unlikely(!scheduler_running))
@@ -495,7 +510,7 @@ static void __enable_runtime(struct rq *rq)
 	/*
 	 * Reset each runqueue's bandwidth settings
 	 */
-	for_each_leaf_rt_rq(rt_rq, rq) {
+	for_each_rt_rq(rt_rq, iter, rq) {
 		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 
 		raw_spin_lock(&rt_b->rt_runtime_lock);
@@ -1796,10 +1811,11 @@ extern void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq);
 
 static void print_rt_stats(struct seq_file *m, int cpu)
 {
+	rt_rq_iter_t iter;
 	struct rt_rq *rt_rq;
 
 	rcu_read_lock();
-	for_each_leaf_rt_rq(rt_rq, cpu_rq(cpu))
+	for_each_rt_rq(rt_rq, iter, cpu_rq(cpu))
 		print_rt_rq(m, cpu, rt_rq);
 	rcu_read_unlock();
 }
