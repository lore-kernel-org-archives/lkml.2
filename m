Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab1EPKhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:37:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:50337 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab1EPKhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:37:17 -0400
Date: Mon, 16 May 2011 10:37:00 GMT
From: tip-bot for Cheng Xu <chengxu@linux.vnet.ibm.com>
Message-ID: <tip-ec514c487c3d4b652943da7b0afbc094eee08cfa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, chengxu@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, chengxu@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <4DCE1F12.6040609@linux.vnet.ibm.com>
References: <4DCE1F12.6040609@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix rt_rq runtime leakage bug
Git-Commit-ID: ec514c487c3d4b652943da7b0afbc094eee08cfa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 May 2011 10:37:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec514c487c3d4b652943da7b0afbc094eee08cfa
Gitweb:     http://git.kernel.org/tip/ec514c487c3d4b652943da7b0afbc094eee08cfa
Author:     Cheng Xu <chengxu@linux.vnet.ibm.com>
AuthorDate: Sat, 14 May 2011 14:20:02 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 May 2011 11:00:54 +0200

sched: Fix rt_rq runtime leakage bug

This patch is to fix the real-time scheduler bug reported at:

  https://lkml.org/lkml/2011/4/26/13

That is, when running multiple real-time threads on every logical CPUs
and then turning off one CPU, the kernel will bug at function
__disable_runtime().

Function __disable_runtime() bugs and reports leakage of rt_rq runtime.
The root cause is __disable_runtime() assumes it iterates through all
the existing rt_rq's while walking rq->leaf_rt_rq_list, which actually
contains only runnable rt_rq's. This problem also applies to
__enable_runtime() and print_rt_stats().

The patch is based on above analysis, appears to fix the problem, but is
only lightly tested.

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Cheng Xu <chengxu@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4DCE1F12.6040609@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
