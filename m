Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694Ab2ERKb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:31:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42428 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab2ERKbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:31:53 -0400
Date: Fri, 18 May 2012 03:31:28 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-41h2mswllhkskd4bnxpoi388@git.kernel.org>
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
Subject: [tip:sched/numa] sched, mm: Introduce tsk_home_node()
Git-Commit-ID: 84213e2b6e2166083c3d06e91dcf54f8e136bd78
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:31:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84213e2b6e2166083c3d06e91dcf54f8e136bd78
Gitweb:     http://git.kernel.org/tip/84213e2b6e2166083c3d06e91dcf54f8e136bd78
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 3 Mar 2012 17:05:16 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:20 +0200

sched, mm: Introduce tsk_home_node()

Introduce the home-node concept for tasks. In order to keep memory
locality we need to have a something to stay local to, we define the
home-node of a task as the node we prefer to allocate memory from and
prefer to execute on.

These are no hard guarantees, merely preferences. This allows for
optimal resource usage, we can run a task away from the home-node, the
remote memory hit -- while expensive -- is less expensive than not
running at all, or very little, due to severe cpu overload.

Similarly, we can allocate memory from another node if our home-node
is depleted, again, some memory is better than no memory.

This patch merely introduces the basic infrastructure, all policy
comes later.

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
Link: http://lkml.kernel.org/n/tip-41h2mswllhkskd4bnxpoi388@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/init_task.h |    8 ++++++++
 include/linux/sched.h     |   10 ++++++++++
 kernel/sched/core.c       |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index e4baff5..d3029fa 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -134,6 +134,13 @@ extern struct cred init_cred;
 
 #define INIT_TASK_COMM "swapper"
 
+#ifdef CONFIG_NUMA
+# define INIT_TASK_NUMA(tsk)						\
+	.node = -1,
+#else
+# define INIT_TASK_NUMA(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -200,6 +207,7 @@ extern struct cred init_cred;
 	INIT_TRACE_RECURSION						\
 	INIT_TASK_RCU_PREEMPT(tsk)					\
 	INIT_CPUSET_SEQ							\
+	INIT_TASK_NUMA(tsk)						\
 }
 
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3d64480..49378f0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1505,6 +1505,7 @@ struct task_struct {
 	struct mempolicy *mempolicy;	/* Protected by alloc_lock */
 	short il_next;
 	short pref_node_fork;
+	int node;
 #endif
 	struct rcu_head rcu;
 
@@ -1575,6 +1576,15 @@ struct task_struct {
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
+static inline int tsk_home_node(struct task_struct *p)
+{
+#ifdef CONFIG_NUMA
+	return p->node;
+#else
+	return -1;
+#endif
+}
+
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
  * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index eb9bee9..8fd0325 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6279,6 +6279,38 @@ static struct sched_domain_topology_level *sched_domain_topology = default_topol
 
 #ifdef CONFIG_NUMA
 
+/*
+ * Requeues a task ensuring its on the right load-balance list so
+ * that it might get migrated to its new home.
+ *
+ * Note that we cannot actively migrate ourselves since our callers
+ * can be from atomic context. We rely on the regular load-balance
+ * mechanisms to move us around -- its all preference anyway.
+ */
+void sched_setnode(struct task_struct *p, int node)
+{
+	unsigned long flags;
+	int on_rq, running;
+	struct rq *rq;
+
+	rq = task_rq_lock(p, &flags);
+	on_rq = p->on_rq;
+	running = task_current(rq, p);
+
+	if (on_rq)
+		dequeue_task(rq, p, 0);
+	if (running)
+		p->sched_class->put_prev_task(rq, p);
+
+	p->node = node;
+
+	if (running)
+		p->sched_class->set_curr_task(rq);
+	if (on_rq)
+		enqueue_task(rq, p, 0);
+	task_rq_unlock(rq, p, &flags);
+}
+
 static int sched_domains_numa_levels;
 static int sched_domains_numa_scale;
 static int *sched_domains_numa_distance;
