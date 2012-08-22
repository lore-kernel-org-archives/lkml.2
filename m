Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab2HVPBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:01:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555Ab2HVPBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:01:10 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
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
Subject: [PATCH 15/36] autonuma: alloc/free/init task_autonuma
Date: Wed, 22 Aug 2012 16:58:59 +0200
Message-Id: <1345647560-30387-16-git-send-email-aarcange@redhat.com>
In-Reply-To: <1345647560-30387-1-git-send-email-aarcange@redhat.com>
References: <1345647560-30387-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is where the dynamically allocated task_autonuma structure is
being handled.

This is the structure holding the per-thread NUMA statistics generated
by the NUMA hinting page faults. This per-thread NUMA statistical
information is needed by sched_autonuma_balance to make optimal NUMA
balancing decisions.

It also contains the task_selected_nid which hints the stock CPU
scheduler on the best NUMA node to schedule this thread on (as decided
by sched_autonuma_balance).

The reason for keeping this outside of the task_struct besides not
using too much kernel stack, is to only allocate it on NUMA
hardware. So the non NUMA hardware only pays the memory of a pointer
in the kernel stack (which remains NULL at all times in that case).

If the kernel is compiled with CONFIG_AUTONUMA=n, not even the pointer
is allocated on the kernel stack of course.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 kernel/fork.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index fbc67ee..9ba6e9b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -209,6 +209,7 @@ void free_task(struct task_struct *tsk)
 {
 	account_kernel_stack(tsk->stack, -1);
 	arch_release_thread_info(tsk->stack);
+	free_task_autonuma(tsk);
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
@@ -264,6 +265,9 @@ void __init fork_init(unsigned long mempages)
 	/* do the arch specific task caches init */
 	arch_task_cache_init();
 
+	/* prepare task_autonuma for alloc_task_autonuma/free_task_autonuma */
+	task_autonuma_init();
+
 	/*
 	 * The default maximum number of threads is set to a safe
 	 * value: the thread structures can take up at most half
@@ -310,6 +314,10 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	if (err)
 		goto free_ti;
 
+	if (unlikely(alloc_task_autonuma(tsk, orig, node)))
+		/* free_thread_info() undoes arch_dup_task_struct() too */
+		goto free_ti;
+
 	tsk->stack = ti;
 
 	setup_thread_stack(tsk, orig);
