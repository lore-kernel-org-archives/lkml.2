Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab2FLOvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:51:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60948 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2FLOvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:51:20 -0400
Date: Tue, 12 Jun 2012 07:47:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sasha Levin <levinsasha928@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: rcu,sched: spinlock recursion on 3.5-rc2
Message-ID: <20120612144705.GB2423@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1339500907.4999.99.camel@lappy>
 <alpine.LFD.2.02.1206121535180.3086@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1206121535180.3086@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061214-7282-0000-0000-000009D76971
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 03:40:13PM +0200, Thomas Gleixner wrote:
> On Tue, 12 Jun 2012, Sasha Levin wrote:
> 
> > Hey all,
> > 
> > I've got the following splat while fuzzing with trinity in a KVM tools guest on 3.5-rc2:
> > 
> > [ 8110.274070] BUG: spinlock recursion on CPU#0, rcu_torture_rea/2658
> > [ 8110.275014]  lock: 0xffff88000d9d6140, .magic: dead4ead, .owner: rcu_torture_rea/2658, .owner_cpu: 0
> > [ 8110.275014] Pid: 2658, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376
> > [ 8110.275014] Call Trace:
> > [ 8110.275014]  [<ffffffff8197de38>] spin_dump+0x78/0xc0
> > [ 8110.275014]  [<ffffffff8197deab>] spin_bug+0x2b/0x40
> > [ 8110.275014]  [<ffffffff8197dfee>] do_raw_spin_lock+0x4e/0x140
> > [ 8110.275014]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
> > [ 8110.275014]  [<ffffffff8111d051>] ? rt_mutex_setprio+0x81/0x2c0
> > [ 8110.275014]  [<ffffffff8111d051>] rt_mutex_setprio+0x81/0x2c0
> > [ 8110.275014]  [<ffffffff81155160>] __rt_mutex_adjust_prio+0x20/0x30
> > [ 8110.275014]  [<ffffffff837c0164>] rt_mutex_slowunlock+0x104/0x130
> > [ 8110.275014]  [<ffffffff837c0199>] rt_mutex_unlock+0x9/0x10
> > [ 8110.275014]  [<ffffffff81193e30>] rcu_read_unlock_special+0x350/0x400
> > [ 8110.275014]  [<ffffffff8114841a>] ? get_lock_stats+0x2a/0x60
> > [ 8110.275014]  [<ffffffff811941aa>] rcu_preempt_note_context_switch+0x22a/0x300
> > [ 8110.275014]  [<ffffffff837bf8ca>] __schedule+0x76a/0x880
> > [ 8110.275014]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
> > [ 8110.275014]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
> > [ 8110.275014]  [<ffffffff837bff64>] preempt_schedule_irq+0x94/0xd0
> > [ 8110.275014]  [<ffffffff837c1da6>] retint_kernel+0x26/0x30
> > [ 8110.275014]  [<ffffffff81193ae1>] ? rcu_read_unlock_special+0x1/0x400
> > [ 8110.275014]  [<ffffffff81193f2d>] ? __rcu_read_unlock+0x4d/0xa0
> > [ 8110.275014]  [<ffffffff8118dc3d>] rcu_torture_read_unlock+0x5d/0x60
> > [ 8110.275014]  [<ffffffff8118dedd>] rcu_torture_reader+0x29d/0x380
> > [ 8110.275014]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
> > [ 8110.275014]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
> > [ 8110.275014]  [<ffffffff81106e32>] kthread+0xb2/0xc0
> > [ 8110.275014]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
> > [ 8110.275014]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
> > [ 8110.275014]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
> > [ 8110.275014]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
> 
> Ok, that's nasty.
> 
> The torture thread got preempted. rcu_preempt_note_context_switch()
> tries to unlock the boosting rt mutex.
> 
> Though rcu_preempt_note_context_switch() is called with rq lock
> held. So it's not a surprise that the code will dead lock.
> 
> My brain hurts already from looking, so Paul to the rescue!

My brain hurts from beating my head on my desk.  It seems that attempts
to enhance PREEMPT_RCU's read-side performance require even more paranoia
than I normally bring to bear.  :-/

Please see below for what I expect is the relevant revert.

							Thanx, Paul

------------------------------------------------------------------------

Revert "rcu: Move PREEMPT_RCU preemption to switch_to() invocation"

This reverts commit 616c310e83b872024271c915c1b9ab505b9efad9
(Move PREEMPT_RCU preemption to switch_to() invocation) which can
result in runqueue deadlock.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 88e466b..43b39d6 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -705,7 +705,6 @@ static void stack_proc(void *arg)
 	struct task_struct *from = current, *to = arg;
 
 	to->thread.saved_task = from;
-	rcu_switch_from(from);
 	switch_to(from, to, from);
 }
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 26d1a47..9cac722 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -184,7 +184,6 @@ static inline int rcu_preempt_depth(void)
 /* Internal to kernel */
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
-extern void rcu_preempt_note_context_switch(void);
 extern void rcu_check_callbacks(int cpu, int user);
 struct notifier_block;
 extern void rcu_idle_enter(void);
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index adb5e5a..148c6db 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -87,6 +87,10 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 
 #ifdef CONFIG_TINY_RCU
 
+static inline void rcu_preempt_note_context_switch(void)
+{
+}
+
 static inline int rcu_needs_cpu(int cpu)
 {
 	return 0;
@@ -94,6 +98,7 @@ static inline int rcu_needs_cpu(int cpu)
 
 #else /* #ifdef CONFIG_TINY_RCU */
 
+void rcu_preempt_note_context_switch(void);
 int rcu_preempt_needs_cpu(void);
 
 static inline int rcu_needs_cpu(int cpu)
@@ -106,6 +111,7 @@ static inline int rcu_needs_cpu(int cpu)
 static inline void rcu_note_context_switch(int cpu)
 {
 	rcu_sched_qs(cpu);
+	rcu_preempt_note_context_switch();
 }
 
 /*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4059c0f..06a4c5f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1871,22 +1871,12 @@ static inline void rcu_copy_process(struct task_struct *p)
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 }
 
-static inline void rcu_switch_from(struct task_struct *prev)
-{
-	if (prev->rcu_read_lock_nesting != 0)
-		rcu_preempt_note_context_switch();
-}
-
 #else
 
 static inline void rcu_copy_process(struct task_struct *p)
 {
 }
 
-static inline void rcu_switch_from(struct task_struct *prev)
-{
-}
-
 #endif
 
 #ifdef CONFIG_SMP
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0da7b88..d994530 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -201,6 +201,7 @@ void rcu_note_context_switch(int cpu)
 {
 	trace_rcu_utilization("Start context switch");
 	rcu_sched_qs(cpu);
+	rcu_preempt_note_context_switch(cpu);
 	trace_rcu_utilization("End context switch");
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 7f5d138..bd220db 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -430,6 +430,7 @@ DECLARE_PER_CPU(char, rcu_cpu_has_work);
 /* Forward declarations for rcutree_plugin.h */
 static void rcu_bootup_announce(void);
 long rcu_batches_completed(void);
+static void rcu_preempt_note_context_switch(int cpu);
 static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 2411000..fb6e07e 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -153,7 +153,7 @@ static void rcu_preempt_qs(int cpu)
  *
  * Caller must disable preemption.
  */
-void rcu_preempt_note_context_switch(void)
+static void rcu_preempt_note_context_switch(int cpu)
 {
 	struct task_struct *t = current;
 	unsigned long flags;
@@ -164,7 +164,7 @@ void rcu_preempt_note_context_switch(void)
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
-		rdp = __this_cpu_ptr(rcu_preempt_state.rda);
+		rdp = per_cpu_ptr(rcu_preempt_state.rda, cpu);
 		rnp = rdp->mynode;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
@@ -228,7 +228,7 @@ void rcu_preempt_note_context_switch(void)
 	 * means that we continue to block the current grace period.
 	 */
 	local_irq_save(flags);
-	rcu_preempt_qs(smp_processor_id());
+	rcu_preempt_qs(cpu);
 	local_irq_restore(flags);
 }
 
@@ -1002,6 +1002,14 @@ void rcu_force_quiescent_state(void)
 EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
 
 /*
+ * Because preemptible RCU does not exist, we never have to check for
+ * CPUs being in quiescent states.
+ */
+static void rcu_preempt_note_context_switch(int cpu)
+{
+}
+
+/*
  * Because preemptible RCU does not exist, there are never any preempted
  * RCU readers.
  */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d5594a4..eaead2d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2081,7 +2081,6 @@ context_switch(struct rq *rq, struct task_struct *prev,
 #endif
 
 	/* Here we just switch the register state and the stack. */
-	rcu_switch_from(prev);
 	switch_to(prev, next, prev);
 
 	barrier();

