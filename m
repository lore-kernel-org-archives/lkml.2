Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725Ab2ERKig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:38:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42578 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760701Ab2ERKie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:38:34 -0400
Date: Fri, 18 May 2012 03:37:57 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-edy9lbaowd8f3sud2xf656wg@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        bharata.rao@gmail.com, aarcange@redhat.com, Lee.Schermerhorn@hp.com,
        suresh.b.siddha@intel.com, danms@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa:
  Abstract out the struct numa_entity some more
Git-Commit-ID: f9c57f07a41a259aa5b6185e962572330cd31fbf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:38:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9c57f07a41a259aa5b6185e962572330cd31fbf
Gitweb:     http://git.kernel.org/tip/f9c57f07a41a259aa5b6185e962572330cd31fbf
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 5 Mar 2012 13:24:34 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:24 +0200

sched/numa: Abstract out the struct numa_entity some more

In order to prepare the NUMA balancer for non-process entities, add
further abstraction to the thing.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-edy9lbaowd8f3sud2xf656wg@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mm_types.h |    5 ++-
 kernel/sched/numa.c      |   85 +++++++++++++++++++++++++++++-----------------
 2 files changed, 57 insertions(+), 33 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6a85ad7..9b98193 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -287,8 +287,9 @@ struct mm_rss_stat {
 
 struct numa_entity {
 #ifdef CONFIG_NUMA
-	int		 node;		/* home node */
-	struct list_head numa_entry;	/* balance list */
+	int			node;		/* home node */
+	struct list_head	numa_entry;	/* balance list */
+	const struct numa_ops	*nops;
 #endif
 };
 
diff --git a/kernel/sched/numa.c b/kernel/sched/numa.c
index 99585d5..6088165 100644
--- a/kernel/sched/numa.c
+++ b/kernel/sched/numa.c
@@ -20,6 +20,17 @@
 
 static const int numa_balance_interval = 2 * HZ; /* 2 seconds */
 
+struct numa_ops {
+	unsigned long	(*mem_load)(struct numa_entity *ne);
+	unsigned long	(*cpu_load)(struct numa_entity *ne);
+
+	void		(*mem_migrate)(struct numa_entity *ne, int node);
+	void		(*cpu_migrate)(struct numa_entity *ne, int node);
+
+	bool		(*tryget)(struct numa_entity *ne);
+	void		(*put)(struct numa_entity *ne);
+};
+
 struct numa_cpu_load {
 	unsigned long	remote; /* load of tasks running away from their home node */
 	unsigned long	all;	/* load of tasks that should be running on this node */
@@ -160,6 +171,26 @@ static inline struct task_struct *ne_owner(struct numa_entity *ne)
 	return rcu_dereference(ne_mm(ne)->owner);
 }
 
+static unsigned long process_cpu_load(struct numa_entity *ne)
+{
+	unsigned long load = 0;
+	struct task_struct *t, *p;
+
+	rcu_read_lock();
+	t = p = ne_owner(ne);
+	if (p) do {
+		load += t->numa_contrib;
+	} while ((t = next_thread(t)) != p);
+	rcu_read_unlock();
+
+	return load;
+}
+
+static unsigned long process_mem_load(struct numa_entity *ne)
+{
+	return get_mm_counter(ne_mm(ne), MM_ANONPAGES);
+}
+
 static void process_cpu_migrate(struct numa_entity *ne, int node)
 {
 	struct task_struct *p, *t;
@@ -177,7 +208,7 @@ static void process_mem_migrate(struct numa_entity *ne, int node)
 	lazy_migrate_process(ne_mm(ne), node);
 }
 
-static int process_tryget(struct numa_entity *ne)
+static bool process_tryget(struct numa_entity *ne)
 {
 	/*
 	 * This is possible when we hold &nq_of(ne->node)->lock since then
@@ -193,6 +224,17 @@ static void process_put(struct numa_entity *ne)
 	mmput(ne_mm(ne));
 }
 
+static const struct numa_ops process_numa_ops = {
+	.mem_load	= process_mem_load,
+	.cpu_load	= process_cpu_load,
+
+	.mem_migrate	= process_mem_migrate,
+	.cpu_migrate	= process_cpu_migrate,
+
+	.tryget		= process_tryget,
+	.put		= process_put,
+};
+
 static struct node_queue *lock_ne_nq(struct numa_entity *ne)
 {
 	struct node_queue *nq;
@@ -252,8 +294,8 @@ static void enqueue_ne(struct numa_entity *ne, int node)
 
 	BUG_ON(ne->node != -1);
 
-	process_cpu_migrate(ne, node);
-	process_mem_migrate(ne, node);
+	ne->nops->cpu_migrate(ne, node);
+	ne->nops->mem_migrate(ne, node);
 
 	spin_lock(&nq->lock);
 	__enqueue_ne(nq, ne);
@@ -273,14 +315,15 @@ static void dequeue_ne(struct numa_entity *ne)
 	spin_unlock(&nq->lock);
 }
 
-static void init_ne(struct numa_entity *ne)
+static void init_ne(struct numa_entity *ne, const struct numa_ops *nops)
 {
 	ne->node = -1;
+	ne->nops = nops;
 }
 
 void mm_init_numa(struct mm_struct *mm)
 {
-	init_ne(&mm->numa);
+	init_ne(&mm->numa, &process_numa_ops);
 }
 
 void exit_numa(struct mm_struct *mm)
@@ -467,26 +510,6 @@ struct numa_imbalance {
 	enum numa_balance_type type;
 };
 
-static unsigned long process_cpu_load(struct numa_entity *ne)
-{
-	unsigned long load = 0;
-	struct task_struct *t, *p;
-
-	rcu_read_lock();
-	t = p = ne_owner(ne);
-	if (p) do {
-		load += t->numa_contrib;
-	} while ((t = next_thread(t)) != p);
-	rcu_read_unlock();
-
-	return load;
-}
-
-static unsigned long process_mem_load(struct numa_entity *ne)
-{
-	return get_mm_counter(ne_mm(ne), MM_ANONPAGES);
-}
-
 static int find_busiest_node(int this_node, struct numa_imbalance *imb)
 {
 	unsigned long cpu_load, mem_load;
@@ -608,8 +631,8 @@ static void move_processes(struct node_queue *busiest_nq,
 				     struct numa_entity,
 				     numa_entry);
 
-		ne_cpu = process_cpu_load(ne);
-		ne_mem = process_mem_load(ne);
+		ne_cpu = ne->nops->cpu_load(ne);
+		ne_mem = ne->nops->mem_load(ne);
 
 		if (sched_feat(NUMA_BALANCE_FILTER)) {
 			/*
@@ -634,13 +657,13 @@ static void move_processes(struct node_queue *busiest_nq,
 
 		__dequeue_ne(busiest_nq, ne);
 		__enqueue_ne(this_nq, ne);
-		if (process_tryget(ne)) {
+		if (ne->nops->tryget(ne)) {
 			double_unlock_nq(this_nq, busiest_nq);
 
-			process_cpu_migrate(ne, this_nq->node);
-			process_mem_migrate(ne, this_nq->node);
+			ne->nops->cpu_migrate(ne, this_nq->node);
+			ne->nops->mem_migrate(ne, this_nq->node);
+			ne->nops->put(ne);
 
-			process_put(ne);
 			double_lock_nq(this_nq, busiest_nq);
 		}
 
