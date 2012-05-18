Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762736Ab2ERKkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:40:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42625 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760701Ab2ERKkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:40:03 -0400
Date: Fri, 18 May 2012 03:39:38 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-zm9pzuxeiebax9vrhx9bbt3i@git.kernel.org>
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
Subject: [tip:sched/numa] sched/numa: Add {mems,cpus}_allowed tests
Git-Commit-ID: 42cfa9f3166fe9eb5a8b31ca01cdfd2c275161f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:39:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42cfa9f3166fe9eb5a8b31ca01cdfd2c275161f8
Gitweb:     http://git.kernel.org/tip/42cfa9f3166fe9eb5a8b31ca01cdfd2c275161f8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 8 May 2012 13:12:07 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:25 +0200

sched/numa: Add {mems,cpus}_allowed tests

Make the NUMA balancer respect task_struct::{mems,cpus}_allowed.

Since these are per task we require all tasks in the process/group
to allow the target node otherwise we fail the migration.

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
Link: http://lkml.kernel.org/n/tip-zm9pzuxeiebax9vrhx9bbt3i@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/numa.c |   51 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/kernel/sched/numa.c b/kernel/sched/numa.c
index 7712744..1d2837d 100644
--- a/kernel/sched/numa.c
+++ b/kernel/sched/numa.c
@@ -27,7 +27,7 @@ struct numa_ops {
 	void		(*mem_migrate)(struct numa_entity *ne, int node);
 	void		(*cpu_migrate)(struct numa_entity *ne, int node);
 
-	u64		(*cpu_runtime)(struct numa_entity *ne);
+	bool		(*can_migrate)(struct numa_entity *ne, int node);
 
 	bool		(*tryget)(struct numa_entity *ne);
 	void		(*put)(struct numa_entity *ne);
@@ -210,19 +210,41 @@ static void process_mem_migrate(struct numa_entity *ne, int node)
 	lazy_migrate_process(ne_mm(ne), node);
 }
 
-static u64 process_cpu_runtime(struct numa_entity *ne)
+static bool __task_can_migrate(struct task_struct *t, u64 *runtime, int node)
+{
+#ifdef CONFIG_CPUSETS
+	if (!node_isset(node, t->mems_allowed))
+		return false;
+#endif
+
+	if (!cpumask_intersects(cpumask_of_node(node), tsk_cpus_allowed(t)))
+		return false;
+
+	*runtime += t->se.sum_exec_runtime; // @#$#@ 32bit
+
+	return true;
+}
+
+static bool process_can_migrate(struct numa_entity *ne, int node)
 {
 	struct task_struct *p, *t;
+	bool allowed = false;
 	u64 runtime = 0;
 
 	rcu_read_lock();
 	t = p = ne_owner(ne);
 	if (p) do {
-		runtime += t->se.sum_exec_runtime; // @#$#@ 32bit
+		allowed = __task_can_migrate(t, &runtime, node);
+		if (!allowed)
+			break;
 	} while ((t = next_thread(t)) != p);
 	rcu_read_unlock();
 
-	return runtime;
+	/*
+	 * Don't bother migrating memory if there's less than 1 second
+	 * of runtime on the tasks.
+	 */
+	return allowed && runtime > NSEC_PER_SEC;
 }
 
 static bool process_tryget(struct numa_entity *ne)
@@ -248,7 +270,7 @@ static const struct numa_ops process_numa_ops = {
 	.mem_migrate	= process_mem_migrate,
 	.cpu_migrate	= process_cpu_migrate,
 
-	.cpu_runtime	= process_cpu_runtime,
+	.can_migrate	= process_can_migrate,
 
 	.tryget		= process_tryget,
 	.put		= process_put,
@@ -624,23 +646,6 @@ calc_imb:
 	return node;
 }
 
-static bool can_move_ne(struct numa_entity *ne)
-{
-	/*
-	 * XXX: consider mems_allowed, stinking cpusets has mems_allowed
-	 * per task and it can actually differ over a whole process, la-la-la.
-	 */
-
-	/*
-	 * Don't bother migrating memory if there's less than 1 second
-	 * of runtime on the tasks.
-	 */
-	if (ne->nops->cpu_runtime(ne) < NSEC_PER_SEC)
-		return false;
-
-	return true;
-}
-
 static void move_processes(struct node_queue *busiest_nq,
 			   struct node_queue *this_nq,
 			   struct numa_imbalance *imb)
@@ -679,7 +684,7 @@ static void move_processes(struct node_queue *busiest_nq,
 				goto next;
 		}
 
-		if (!can_move_ne(ne))
+		if (!ne->nops->can_migrate(ne, this_nq->node))
 			goto next;
 
 		__dequeue_ne(busiest_nq, ne);
