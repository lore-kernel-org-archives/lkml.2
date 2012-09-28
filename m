Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2I1H5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:57:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37998 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2I1H5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:57:06 -0400
Date: Fri, 28 Sep 2012 00:56:41 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-ii8j8cp87cgctecfqp2ib6rn@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com, tglx@linutronix.de
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        Lee.Schermerhorn@hp.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched, mm: Introduce tsk_home_node()
Git-Commit-ID: 56c12cdbeaaaf38fbbfd4de355ea146ce52d8194
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 00:56:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56c12cdbeaaaf38fbbfd4de355ea146ce52d8194
Gitweb:     http://git.kernel.org/tip/56c12cdbeaaaf38fbbfd4de355ea146ce52d8194
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 3 Mar 2012 17:05:16 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Sep 2012 14:46:02 +0200

sched, mm: Introduce tsk_home_node()

Introduce the home-node concept for tasks. In order to keep memory
locality we need to have a something to stay local to, we define the
home-node of a task as the node we prefer to allocate memory from and
prefer to execute on.

These are no hard guarantees, merely soft preferences. This allows for
optimal resource usage, we can run a task away from the home-node, the
remote memory hit -- while expensive -- is less expensive than not
running at all, or very little, due to severe cpu overload.

Similarly, we can allocate memory from another node if our home-node
is depleted, again, some memory is better than no memory.

This patch merely introduces the basic infrastructure, all policy
comes later.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-ii8j8cp87cgctecfqp2ib6rn@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/sh/mm/Kconfig        |    1 +
 include/linux/init_task.h |    8 ++++++++
 include/linux/sched.h     |   12 ++++++++++++
 init/Kconfig              |   11 +++++++++++
 kernel/sched/core.c       |   36 ++++++++++++++++++++++++++++++++++++
 5 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/arch/sh/mm/Kconfig b/arch/sh/mm/Kconfig
index cb8f992..1210cc7 100644
--- a/arch/sh/mm/Kconfig
+++ b/arch/sh/mm/Kconfig
@@ -111,6 +111,7 @@ config VSYSCALL
 config NUMA
 	bool "Non Uniform Memory Access (NUMA) Support"
 	depends on MMU && SYS_SUPPORTS_NUMA && EXPERIMENTAL
+	select EMBEDDED_NUMA
 	default n
 	help
 	  Some SH systems have many various memories scattered around
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 89f1cb1..18906c1 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -143,6 +143,13 @@ extern struct task_group root_task_group;
 
 #define INIT_TASK_COMM "swapper"
 
+#ifdef CONFIG_SCHED_NUMA
+# define INIT_TASK_NUMA(tsk)						\
+	.node = -1,
+#else
+# define INIT_TASK_NUMA(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -210,6 +217,7 @@ extern struct task_group root_task_group;
 	INIT_TRACE_RECURSION						\
 	INIT_TASK_RCU_PREEMPT(tsk)					\
 	INIT_CPUSET_SEQ							\
+	INIT_TASK_NUMA(tsk)						\
 }
 
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8c38df0..d28ff49 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1518,6 +1518,9 @@ struct task_struct {
 	short il_next;
 	short pref_node_fork;
 #endif
+#ifdef CONFIG_SCHED_NUMA
+	int node;
+#endif
 	struct rcu_head rcu;
 
 	/*
@@ -1589,6 +1592,15 @@ struct task_struct {
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
+static inline int tsk_home_node(struct task_struct *p)
+{
+#ifdef CONFIG_SCHED_NUMA
+	return p->node;
+#else
+	return -1;
+#endif
+}
+
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
  * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
diff --git a/init/Kconfig b/init/Kconfig
index c40d0fb..beee6d5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -634,6 +634,17 @@ config LOG_BUF_SHIFT
 config HAVE_UNSTABLE_SCHED_CLOCK
 	bool
 
+#
+# For architectures that (ab)use NUMA to represent different memory regions
+# all cpu-local but of different latencies, such as SuperH.
+#
+config EMBEDDED_NUMA
+	bool
+
+config SCHED_NUMA
+	def_bool y
+	depends on SMP && NUMA && MIGRATION && !EMBEDDED_NUMA
+
 menuconfig CGROUPS
 	boolean "Control Group support"
 	depends on EVENTFD
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ba144b1..a64c43b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5979,6 +5979,42 @@ static struct sched_domain_topology_level default_topology[] = {
 
 static struct sched_domain_topology_level *sched_domain_topology = default_topology;
 
+#ifdef CONFIG_SCHED_NUMA
+
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
+#endif /* CONFIG_SCHED_NUMA */
+
 #ifdef CONFIG_NUMA
 
 static int sched_domains_numa_levels;
