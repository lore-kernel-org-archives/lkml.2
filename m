Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab1ENGVM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 02:21:12 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47694 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab1ENGVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 02:21:11 -0400
Message-ID: <4DCE1F12.6040609@linux.vnet.ibm.com>
Date: Sat, 14 May 2011 14:20:02 +0800
From: Cheng Xu <chengxu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mckenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] sched: rt_rq runtime leakage bug fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to fix the real-time scheduler bug reported at 
https://lkml.org/lkml/2011/4/26/13. That is, when running multiple real-time 
threads on every logical CPUs and then turning off one CPU, the kernel will 
bug at function __disable_runtime(). 

Function __disable_runtime() bugs and reports leakage of rt_rq runtime. The 
root cause is __disable_runtime() assumes it iterates through all the existing 
rt_rq's while walking rq->leaf_rt_rq_list, which actually contains only 
runnable rt_rq's. This problem also applies to __enable_runtime() and 
print_rt_stats(). 

The patch is based on above analysis, appears to fix the problem, but is only 
lightly tested. 

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Cheng Xu <chengxu@linux.vnet.ibm.com>
---
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
-- 
1.7.1

