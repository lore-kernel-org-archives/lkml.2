Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab2EYRM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:12:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886Ab2EYRD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:03:26 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
        Christoph Lameter <cl@linux.com>
Subject: [PATCH 18/35] autonuma: alloc/free/init sched_autonuma
Date: Fri, 25 May 2012 19:02:22 +0200
Message-Id: <1337965359-29725-19-git-send-email-aarcange@redhat.com>
In-Reply-To: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is where the dynamically allocated sched_autonuma structure is
being handled.

The reason for keeping this outside of the task_struct besides not
using too much kernel stack, is to only allocate it on NUMA
hardware. So the not NUMA hardware only pays the memory of a pointer
in the kernel stack (which remains NULL at all times in that case).

If the kernel is compiled with CONFIG_AUTONUMA=n, not even the pointer
is allocated on the kernel stack of course.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 kernel/fork.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 237c34e..d323eb1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -206,6 +206,7 @@ static void account_kernel_stack(struct thread_info *ti, int account)
 void free_task(struct task_struct *tsk)
 {
 	account_kernel_stack(tsk->stack, -1);
+	free_sched_autonuma(tsk);
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
@@ -260,6 +261,8 @@ void __init fork_init(unsigned long mempages)
 	/* do the arch specific task caches init */
 	arch_task_cache_init();
 
+	sched_autonuma_init();
+
 	/*
 	 * The default maximum number of threads is set to a safe
 	 * value: the thread structures can take up at most half
@@ -292,21 +295,21 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	struct thread_info *ti;
 	unsigned long *stackend;
 	int node = tsk_fork_get_node(orig);
-	int err;
 
 	tsk = alloc_task_struct_node(node);
-	if (!tsk)
+	if (unlikely(!tsk))
 		return NULL;
 
 	ti = alloc_thread_info_node(tsk, node);
-	if (!ti) {
-		free_task_struct(tsk);
-		return NULL;
-	}
+	if (unlikely(!ti))
+		goto out_task_struct;
 
-	err = arch_dup_task_struct(tsk, orig);
-	if (err)
-		goto out;
+	if (unlikely(arch_dup_task_struct(tsk, orig)))
+		goto out_thread_info;
+
+	if (unlikely(alloc_sched_autonuma(tsk, orig, node)))
+		/* free_thread_info() undoes arch_dup_task_struct() too */
+		goto out_thread_info;
 
 	tsk->stack = ti;
 
@@ -334,8 +337,9 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 
 	return tsk;
 
-out:
+out_thread_info:
 	free_thread_info(ti);
+out_task_struct:
 	free_task_struct(tsk);
 	return NULL;
 }
