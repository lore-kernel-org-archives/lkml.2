Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab1EKSho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 14:37:44 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40319 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab1EKShn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 14:37:43 -0400
Message-ID: <4DCA3C0C.3080901@linux.vnet.ibm.com>
Date: Wed, 11 May 2011 15:34:36 +0800
From: Cheng Xu <chengxu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Paul Mckenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: rt_rq runtime leakage bug fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to fix bug report https://lkml.org/lkml/2011/4/26/13

Function __disable_runtime() reports leakage of rt_rq runtime. The root cause is __disable_runtime() assumes it iterates through all the existing rt_rq's while walking rq->leaf_rt_rq_list, which actually contains only runnable rt_rq's. This problem also applies to __enable_runtime() and print_rt_stats().

The patch is based on above analysis, appears to fix the problem, but is only lightly tested.


Signed-off-by: Cheng Xu <chengxu@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

---
 kernel/sched_rt.c |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index e7cebdc..7f478ff 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -183,6 +183,13 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 	return ktime_to_ns(rt_rq->tg->rt_bandwidth.rt_period);
 }
 
+#define rt_rq_of_rq_decls(name) struct task_group *name
+
+#define list_for_rt_rq_of_rq(iterator, rq) \
+	list_for_each_entry_rcu(iterator, &task_groups, list)
+
+#define rt_rq_of_rq_deref(iterator, rq) (iterator->rt_rq[cpu_of(rq)])
+
 static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
 {
 	list_add_rcu(&rt_rq->leaf_rt_rq_list,
@@ -288,6 +295,13 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 	return ktime_to_ns(def_rt_bandwidth.rt_period);
 }
 
+#define rt_rq_of_rq_decls(name) struct rt_rq *name
+
+#define list_for_rt_rq_of_rq(iterator, rq) \
+	for (iterator = &rq->rt; iterator; iterator = NULL)
+
+#define rt_rq_of_rq_deref(iterator, rq) (iterator)
+
 static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
 {
 }
@@ -402,12 +416,13 @@ next:
 static void __disable_runtime(struct rq *rq)
 {
 	struct root_domain *rd = rq->rd;
-	struct rt_rq *rt_rq;
+	rt_rq_of_rq_decls(iterator);
 
 	if (unlikely(!scheduler_running))
 		return;
 
-	for_each_leaf_rt_rq(rt_rq, rq) {
+	list_for_rt_rq_of_rq(iterator, rq) {
+		struct rt_rq *rt_rq = rt_rq_of_rq_deref(iterator, rq);
 		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 		s64 want;
 		int i;
@@ -487,7 +502,7 @@ static void disable_runtime(struct rq *rq)
 
 static void __enable_runtime(struct rq *rq)
 {
-	struct rt_rq *rt_rq;
+	rt_rq_of_rq_decls(iterator);
 
 	if (unlikely(!scheduler_running))
 		return;
@@ -495,7 +510,8 @@ static void __enable_runtime(struct rq *rq)
 	/*
 	 * Reset each runqueue's bandwidth settings
 	 */
-	for_each_leaf_rt_rq(rt_rq, rq) {
+	list_for_rt_rq_of_rq(iterator, rq) {
+		struct rt_rq *rt_rq = rt_rq_of_rq_deref(iterator, rq);
 		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 
 		raw_spin_lock(&rt_b->rt_runtime_lock);
@@ -1796,11 +1812,12 @@ extern void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq);
 
 static void print_rt_stats(struct seq_file *m, int cpu)
 {
-	struct rt_rq *rt_rq;
+	rt_rq_of_rq_decls(iterator);
+	struct rq *rq = cpu_rq(cpu);
 
 	rcu_read_lock();
-	for_each_leaf_rt_rq(rt_rq, cpu_rq(cpu))
-		print_rt_rq(m, cpu, rt_rq);
+	list_for_rt_rq_of_rq(iterator, rq)
+		print_rt_rq(m, cpu, rt_rq_of_rq_deref(iterator, rq));
 	rcu_read_unlock();
 }
 #endif /* CONFIG_SCHED_DEBUG */
-- 
1.7.1



