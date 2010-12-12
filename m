Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab0LLXrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36310 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab0LLXrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:21 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: peterz@infradead.org, a.p.zijlstra@chello.nl, paulmck@linux.vnet.ibm.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [138/223] sched: fix RCU lockdep splat from task_group()
Message-Id: <20101212234720.A37A2B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Peter Zijlstra <peterz@infradead.org>

commit 6506cf6ce68d78a5470a8360c965dafe8e4b78e3 upstream.

This addresses the following RCU lockdep splat:

[0.051203] CPU0: AMD QEMU Virtual CPU version 0.12.4 stepping 03
[0.052999] lockdep: fixing up alternatives.
[0.054105]
[0.054106] ===================================================
[0.054999] [ INFO: suspicious rcu_dereference_check() usage. ]
[0.054999] ---------------------------------------------------
[0.054999] kernel/sched.c:616 invoked rcu_dereference_check() without protection!
[0.054999]
[0.054999] other info that might help us debug this:
[0.054999]
[0.054999]
[0.054999] rcu_scheduler_active = 1, debug_locks = 1
[0.054999] 3 locks held by swapper/1:
[0.054999]  #0:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff814be933>] cpu_up+0x42/0x6a
[0.054999]  #1:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff810400d8>] cpu_hotplug_begin+0x2a/0x51
[0.054999]  #2:  (&rq->lock){-.-...}, at: [<ffffffff814be2f7>] init_idle+0x2f/0x113
[0.054999]
[0.054999] stack backtrace:
[0.054999] Pid: 1, comm: swapper Not tainted 2.6.35 #1
[0.054999] Call Trace:
[0.054999]  [<ffffffff81068054>] lockdep_rcu_dereference+0x9b/0xa3
[0.054999]  [<ffffffff810325c3>] task_group+0x7b/0x8a
[0.054999]  [<ffffffff810325e5>] set_task_rq+0x13/0x40
[0.054999]  [<ffffffff814be39a>] init_idle+0xd2/0x113
[0.054999]  [<ffffffff814be78a>] fork_idle+0xb8/0xc7
[0.054999]  [<ffffffff81068717>] ? mark_held_locks+0x4d/0x6b
[0.054999]  [<ffffffff814bcebd>] do_fork_idle+0x17/0x2b
[0.054999]  [<ffffffff814bc89b>] native_cpu_up+0x1c1/0x724
[0.054999]  [<ffffffff814bcea6>] ? do_fork_idle+0x0/0x2b
[0.054999]  [<ffffffff814be876>] _cpu_up+0xac/0x127
[0.054999]  [<ffffffff814be946>] cpu_up+0x55/0x6a
[0.054999]  [<ffffffff81ab562a>] kernel_init+0xe1/0x1ff
[0.054999]  [<ffffffff81003854>] kernel_thread_helper+0x4/0x10
[0.054999]  [<ffffffff814c353c>] ? restore_args+0x0/0x30
[0.054999]  [<ffffffff81ab5549>] ? kernel_init+0x0/0x1ff
[0.054999]  [<ffffffff81003850>] ? kernel_thread_helper+0x0/0x10
[0.056074] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
[0.130045]  #2lockdep: fixing up alternatives.
[0.203089]  #3 Ok.
[0.275286] Brought up 4 CPUs
[0.276005] Total of 4 processors activated (16017.17 BogoMIPS).

The cgroup_subsys_state structures referenced by idle tasks are never
freed, because the idle tasks should be part of the root cgroup,
which is not removable.

The problem is that while we do in-fact hold rq->lock, the newly spawned
idle thread's cpu is not yet set to the correct cpu so the lockdep check
in task_group():

  lockdep_is_held(&task_rq(p)->lock)

will fail.

But this is a chicken and egg problem.  Setting the CPU's runqueue requires
that the CPU's runqueue already be set.  ;-)

So insert an RCU read-side critical section to avoid the complaint.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/sched.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -5157,7 +5157,19 @@ void __cpuinit init_idle(struct task_str
 	idle->se.exec_start = sched_clock();
 
 	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
+	/*
+	 * We're having a chicken and egg problem, even though we are
+	 * holding rq->lock, the cpu isn't yet set to this cpu so the
+	 * lockdep check in task_group() will fail.
+	 *
+	 * Similar case to sched_fork(). / Alternatively we could
+	 * use task_rq_lock() here and obtain the other rq->lock.
+	 *
+	 * Silence PROVE_RCU
+	 */
+	rcu_read_lock();
 	__set_task_cpu(idle, cpu);
+	rcu_read_unlock();
 
 	rq->curr = rq->idle = idle;
 #if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
