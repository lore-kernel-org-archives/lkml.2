Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1EKU75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:59:57 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56583 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785Ab1EKU7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:59:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] rcu: Avoid acquiring rcu_node locks in timer functions
Date: Wed, 11 May 2011 13:59:37 -0700
Message-Id: <1305147577-1812-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110511205915.GA1731@linux.vnet.ibm.com>
References: <20110511205915.GA1731@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

This commit switches manipulations of the rcu_node ->wakemask field
to atomic operations, which allows rcu_cpu_kthread_timer() to avoid
acquiring the rcu_node lock.  This should avoid the following lockdep
splat:

[   12.872150] usb 1-4: new high speed USB device number 3 using ehci_hcd
[   12.986667] usb 1-4: New USB device found, idVendor=413c, idProduct=2513
[   12.986679] usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   12.987691] hub 1-4:1.0: USB hub found
[   12.987877] hub 1-4:1.0: 3 ports detected
[   12.996372] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input10
[   13.071471] udevadm used greatest stack depth: 3984 bytes left
[   13.172129]
[   13.172130] =======================================================
[   13.172425] [ INFO: possible circular locking dependency detected ]
[   13.172650] 2.6.39-rc6-mmotm0506 #1
[   13.172773] -------------------------------------------------------
[   13.172997] blkid/267 is trying to acquire lock:
[   13.173009]  (&p->pi_lock){-.-.-.}, at: [<ffffffff81032d8f>] try_to_wake_up+0x29/0x1aa
[   13.173009]
[   13.173009] but task is already holding lock:
[   13.173009]  (rcu_node_level_0){..-...}, at: [<ffffffff810901cc>] rcu_cpu_kthread_timer+0x27/0x58
[   13.173009]
[   13.173009] which lock already depends on the new lock.
[   13.173009]
[   13.173009]
[   13.173009] the existing dependency chain (in reverse order) is:
[   13.173009]
[   13.173009] -> #2 (rcu_node_level_0){..-...}:
[   13.173009]        [<ffffffff810679b9>] check_prevs_add+0x8b/0x104
[   13.173009]        [<ffffffff81067da1>] validate_chain+0x36f/0x3ab
[   13.173009]        [<ffffffff8106846b>] __lock_acquire+0x369/0x3e2
[   13.173009]        [<ffffffff81068a0f>] lock_acquire+0xfc/0x14c
[   13.173009]        [<ffffffff815697f1>] _raw_spin_lock+0x36/0x45
[   13.173009]        [<ffffffff81090794>] rcu_read_unlock_special+0x8c/0x1d5
[   13.173009]        [<ffffffff8109092c>] __rcu_read_unlock+0x4f/0xd7
[   13.173009]        [<ffffffff81027bd3>] rcu_read_unlock+0x21/0x23
[   13.173009]        [<ffffffff8102cc34>] cpuacct_charge+0x6c/0x75
[   13.173009]        [<ffffffff81030cc6>] update_curr+0x101/0x12e
[   13.173009]        [<ffffffff810311d0>] check_preempt_wakeup+0xf7/0x23b
[   13.173009]        [<ffffffff8102acb3>] check_preempt_curr+0x2b/0x68
[   13.173009]        [<ffffffff81031d40>] ttwu_do_wakeup+0x76/0x128
[   13.173009]        [<ffffffff81031e49>] ttwu_do_activate.constprop.63+0x57/0x5c
[   13.173009]        [<ffffffff81031e96>] scheduler_ipi+0x48/0x5d
[   13.173009]        [<ffffffff810177d5>] smp_reschedule_interrupt+0x16/0x18
[   13.173009]        [<ffffffff815710f3>] reschedule_interrupt+0x13/0x20
[   13.173009]        [<ffffffff810b66d1>] rcu_read_unlock+0x21/0x23
[   13.173009]        [<ffffffff810b739c>] find_get_page+0xa9/0xb9
[   13.173009]        [<ffffffff810b8b48>] filemap_fault+0x6a/0x34d
[   13.173009]        [<ffffffff810d1a25>] __do_fault+0x54/0x3e6
[   13.173009]        [<ffffffff810d447a>] handle_pte_fault+0x12c/0x1ed
[   13.173009]        [<ffffffff810d48f7>] handle_mm_fault+0x1cd/0x1e0
[   13.173009]        [<ffffffff8156cfee>] do_page_fault+0x42d/0x5de
[   13.173009]        [<ffffffff8156a75f>] page_fault+0x1f/0x30
[   13.173009]
[   13.173009] -> #1 (&rq->lock){-.-.-.}:
[   13.173009]        [<ffffffff810679b9>] check_prevs_add+0x8b/0x104
[   13.173009]        [<ffffffff81067da1>] validate_chain+0x36f/0x3ab
[   13.173009]        [<ffffffff8106846b>] __lock_acquire+0x369/0x3e2
[   13.173009]        [<ffffffff81068a0f>] lock_acquire+0xfc/0x14c
[   13.173009]        [<ffffffff815697f1>] _raw_spin_lock+0x36/0x45
[   13.173009]        [<ffffffff81027e19>] __task_rq_lock+0x8b/0xd3
[   13.173009]        [<ffffffff81032f7f>] wake_up_new_task+0x41/0x108
[   13.173009]        [<ffffffff810376c3>] do_fork+0x265/0x33f
[   13.173009]        [<ffffffff81007d02>] kernel_thread+0x6b/0x6d
[   13.173009]        [<ffffffff8153a9dd>] rest_init+0x21/0xd2
[   13.173009]        [<ffffffff81b1db4f>] start_kernel+0x3bb/0x3c6
[   13.173009]        [<ffffffff81b1d29f>] x86_64_start_reservations+0xaf/0xb3
[   13.173009]        [<ffffffff81b1d393>] x86_64_start_kernel+0xf0/0xf7
[   13.173009]
[   13.173009] -> #0 (&p->pi_lock){-.-.-.}:
[   13.173009]        [<ffffffff81067788>] check_prev_add+0x68/0x20e
[   13.173009]        [<ffffffff810679b9>] check_prevs_add+0x8b/0x104
[   13.173009]        [<ffffffff81067da1>] validate_chain+0x36f/0x3ab
[   13.173009]        [<ffffffff8106846b>] __lock_acquire+0x369/0x3e2
[   13.173009]        [<ffffffff81068a0f>] lock_acquire+0xfc/0x14c
[   13.173009]        [<ffffffff815698ea>] _raw_spin_lock_irqsave+0x44/0x57
[   13.173009]        [<ffffffff81032d8f>] try_to_wake_up+0x29/0x1aa
[   13.173009]        [<ffffffff81032f3c>] wake_up_process+0x10/0x12
[   13.173009]        [<ffffffff810901e9>] rcu_cpu_kthread_timer+0x44/0x58
[   13.173009]        [<ffffffff81045286>] call_timer_fn+0xac/0x1e9
[   13.173009]        [<ffffffff8104556d>] run_timer_softirq+0x1aa/0x1f2
[   13.173009]        [<ffffffff8103e487>] __do_softirq+0x109/0x26a
[   13.173009]        [<ffffffff8157144c>] call_softirq+0x1c/0x30
[   13.173009]        [<ffffffff81003207>] do_softirq+0x44/0xf1
[   13.173009]        [<ffffffff8103e8b9>] irq_exit+0x58/0xc8
[   13.173009]        [<ffffffff81017f5a>] smp_apic_timer_interrupt+0x79/0x87
[   13.173009]        [<ffffffff81570fd3>] apic_timer_interrupt+0x13/0x20
[   13.173009]        [<ffffffff810bd51a>] get_page_from_freelist+0x2aa/0x310
[   13.173009]        [<ffffffff810bdf03>] __alloc_pages_nodemask+0x178/0x243
[   13.173009]        [<ffffffff8101fe2f>] pte_alloc_one+0x1e/0x3a
[   13.173009]        [<ffffffff810d27fe>] __pte_alloc+0x22/0x14b
[   13.173009]        [<ffffffff810d48a8>] handle_mm_fault+0x17e/0x1e0
[   13.173009]        [<ffffffff8156cfee>] do_page_fault+0x42d/0x5de
[   13.173009]        [<ffffffff8156a75f>] page_fault+0x1f/0x30
[   13.173009]
[   13.173009] other info that might help us debug this:
[   13.173009]
[   13.173009] Chain exists of:
[   13.173009]   &p->pi_lock --> &rq->lock --> rcu_node_level_0
[   13.173009]
[   13.173009]  Possible unsafe locking scenario:
[   13.173009]
[   13.173009]        CPU0                    CPU1
[   13.173009]        ----                    ----
[   13.173009]   lock(rcu_node_level_0);
[   13.173009]                                lock(&rq->lock);
[   13.173009]                                lock(rcu_node_level_0);
[   13.173009]   lock(&p->pi_lock);
[   13.173009]
[   13.173009]  *** DEADLOCK ***
[   13.173009]
[   13.173009] 3 locks held by blkid/267:
[   13.173009]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8156cdb4>] do_page_fault+0x1f3/0x5de
[   13.173009]  #1:  (&yield_timer){+.-...}, at: [<ffffffff810451da>] call_timer_fn+0x0/0x1e9
[   13.173009]  #2:  (rcu_node_level_0){..-...}, at: [<ffffffff810901cc>] rcu_cpu_kthread_timer+0x27/0x58
[   13.173009]
[   13.173009] stack backtrace:
[   13.173009] Pid: 267, comm: blkid Not tainted 2.6.39-rc6-mmotm0506 #1
[   13.173009] Call Trace:
[   13.173009]  <IRQ>  [<ffffffff8154a529>] print_circular_bug+0xc8/0xd9
[   13.173009]  [<ffffffff81067788>] check_prev_add+0x68/0x20e
[   13.173009]  [<ffffffff8100c861>] ? save_stack_trace+0x28/0x46
[   13.173009]  [<ffffffff810679b9>] check_prevs_add+0x8b/0x104
[   13.173009]  [<ffffffff81067da1>] validate_chain+0x36f/0x3ab
[   13.173009]  [<ffffffff8106846b>] __lock_acquire+0x369/0x3e2
[   13.173009]  [<ffffffff81032d8f>] ? try_to_wake_up+0x29/0x1aa
[   13.173009]  [<ffffffff81068a0f>] lock_acquire+0xfc/0x14c
[   13.173009]  [<ffffffff81032d8f>] ? try_to_wake_up+0x29/0x1aa
[   13.173009]  [<ffffffff810901a5>] ? rcu_check_quiescent_state+0x82/0x82
[   13.173009]  [<ffffffff815698ea>] _raw_spin_lock_irqsave+0x44/0x57
[   13.173009]  [<ffffffff81032d8f>] ? try_to_wake_up+0x29/0x1aa
[   13.173009]  [<ffffffff81032d8f>] try_to_wake_up+0x29/0x1aa
[   13.173009]  [<ffffffff810901a5>] ? rcu_check_quiescent_state+0x82/0x82
[   13.173009]  [<ffffffff81032f3c>] wake_up_process+0x10/0x12
[   13.173009]  [<ffffffff810901e9>] rcu_cpu_kthread_timer+0x44/0x58
[   13.173009]  [<ffffffff810901a5>] ? rcu_check_quiescent_state+0x82/0x82
[   13.173009]  [<ffffffff81045286>] call_timer_fn+0xac/0x1e9
[   13.173009]  [<ffffffff810451da>] ? del_timer+0x75/0x75
[   13.173009]  [<ffffffff810901a5>] ? rcu_check_quiescent_state+0x82/0x82
[   13.173009]  [<ffffffff8104556d>] run_timer_softirq+0x1aa/0x1f2
[   13.173009]  [<ffffffff8103e487>] __do_softirq+0x109/0x26a
[   13.173009]  [<ffffffff8106365f>] ? tick_dev_program_event+0x37/0xf6
[   13.173009]  [<ffffffff810a0e4a>] ? time_hardirqs_off+0x1b/0x2f
[   13.173009]  [<ffffffff8157144c>] call_softirq+0x1c/0x30
[   13.173009]  [<ffffffff81003207>] do_softirq+0x44/0xf1
[   13.173009]  [<ffffffff8103e8b9>] irq_exit+0x58/0xc8
[   13.173009]  [<ffffffff81017f5a>] smp_apic_timer_interrupt+0x79/0x87
[   13.173009]  [<ffffffff81570fd3>] apic_timer_interrupt+0x13/0x20
[   13.173009]  <EOI>  [<ffffffff810bd384>] ? get_page_from_freelist+0x114/0x310
[   13.173009]  [<ffffffff810bd51a>] ? get_page_from_freelist+0x2aa/0x310
[   13.173009]  [<ffffffff812220e7>] ? clear_page_c+0x7/0x10
[   13.173009]  [<ffffffff810bd1ef>] ? prep_new_page+0x14c/0x1cd
[   13.173009]  [<ffffffff810bd51a>] get_page_from_freelist+0x2aa/0x310
[   13.173009]  [<ffffffff810bdf03>] __alloc_pages_nodemask+0x178/0x243
[   13.173009]  [<ffffffff810d46b9>] ? __pmd_alloc+0x87/0x99
[   13.173009]  [<ffffffff8101fe2f>] pte_alloc_one+0x1e/0x3a
[   13.173009]  [<ffffffff810d46b9>] ? __pmd_alloc+0x87/0x99
[   13.173009]  [<ffffffff810d27fe>] __pte_alloc+0x22/0x14b
[   13.173009]  [<ffffffff810d48a8>] handle_mm_fault+0x17e/0x1e0
[   13.173009]  [<ffffffff8156cfee>] do_page_fault+0x42d/0x5de
[   13.173009]  [<ffffffff810d915f>] ? sys_brk+0x32/0x10c
[   13.173009]  [<ffffffff810a0e4a>] ? time_hardirqs_off+0x1b/0x2f
[   13.173009]  [<ffffffff81065c4f>] ? trace_hardirqs_off_caller+0x3f/0x9c
[   13.173009]  [<ffffffff812235dd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   13.173009]  [<ffffffff8156a75f>] page_fault+0x1f/0x30
[   14.010075] usb 5-1: new full speed USB device number 2 using uhci_hcd

Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   13 +++++--------
 kernel/rcutree.h |    4 +++-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5616b17..5b0b482 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -36,7 +36,7 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/nmi.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/completion.h>
@@ -1525,13 +1525,10 @@ static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
  */
 static void rcu_cpu_kthread_timer(unsigned long arg)
 {
-	unsigned long flags;
 	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, arg);
 	struct rcu_node *rnp = rdp->mynode;
 
-	raw_spin_lock_irqsave(&rnp->lock, flags);
-	rnp->wakemask |= rdp->grpmask;
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	atomic_or(rdp->grpmask, &rnp->wakemask);
 	invoke_rcu_node_kthread(rnp);
 }
 
@@ -1679,11 +1676,11 @@ static int rcu_node_kthread(void *arg)
 
 	for (;;) {
 		rnp->node_kthread_status = RCU_KTHREAD_WAITING;
-		wait_event_interruptible(rnp->node_wq, rnp->wakemask != 0);
+		wait_event_interruptible(rnp->node_wq,
+					 atomic_read(&rnp->wakemask) != 0);
 		rnp->node_kthread_status = RCU_KTHREAD_RUNNING;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
-		mask = rnp->wakemask;
-		rnp->wakemask = 0;
+		mask = atomic_xchg(&rnp->wakemask, 0);
 		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
 		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1) {
 			if ((mask & 0x1) == 0)
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 93d4a1c..561dcb9 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -119,7 +119,9 @@ struct rcu_node {
 				/*  elements that need to drain to allow the */
 				/*  current expedited grace period to */
 				/*  complete (only for TREE_PREEMPT_RCU). */
-	unsigned long wakemask; /* CPUs whose kthread needs to be awakened. */
+	atomic_t wakemask;	/* CPUs whose kthread needs to be awakened. */
+				/*  Since this has meaning only for leaf */
+				/*  rcu_node structures, 32 bits suffices. */
 	unsigned long qsmaskinit;
 				/* Per-GP initial value for qsmask & expmask. */
 	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
-- 
1.7.3.2

