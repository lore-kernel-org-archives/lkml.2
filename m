Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1IVLqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 07:46:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48283 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab1IVLqb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 07:46:31 -0400
Subject: Re: rt14: strace ->  migrate_disable_atomic imbalance
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>, mingo <mingo@redhat.com>
Date: Thu, 22 Sep 2011 13:46:06 +0200
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
	 <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins>
	 <1315927699.6445.6.camel@marge.simson.net> <1315930430.5977.21.camel@twins>
	 <1316600230.6628.6.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316691967.31429.9.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 13:31 +0200, Peter Zijlstra wrote:
> On Thu, 2011-09-22 at 12:00 +0200, Peter Zijlstra wrote:
> > OK, this one seems to be better.. But its quite vile, not sure I
> > actually like it anymore.
> > 
> There's also a small matter of it actually being slower than what we had
> when tested with: strace hackbench > /dev/null 2>&1.
> 
> curses.. even adding a busy wait on p->on_cpu in front.

Gah, its one of those benchmarks where if you rebuild+reboot the numbers
change. Latest patch here..

---
Subject: sched: Rewrite wait_task_inactive()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Sep 21 21:34:05 CEST 2011

Instead of using a combination of busy-waits and sleeps to poll a
task's state, ensure we get a notification and properly block.

This makes preempt notifiers unconditional, but since pretty much
everybody already has those enabled in their config it shouldn't be a
big deal (I hope).

The notification is somewhat horrid since the sched_out notifier is
called with rq->lock held and interrupts disabled, so we can't
actually do the wakeup from there. However the sched_in notifier is
called without holding rq->lock and with interrupts enable.

So what we do is we register a preempt notifier on the task we want,
that notifier will move itself to the next task passed into the
sched_out function, the sched_in notification of the next task, will do
the actual work... most horrid.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/ia64/kvm/Kconfig    |    1 
 arch/powerpc/kvm/Kconfig |    1 
 arch/s390/kvm/Kconfig    |    1 
 arch/tile/kvm/Kconfig    |    1 
 arch/x86/kvm/Kconfig     |    1 
 include/linux/kvm_host.h |    2 
 include/linux/preempt.h  |    4 
 include/linux/sched.h    |    2 
 init/Kconfig             |    3 
 kernel/sched.c           |  191 +++++++++++++++++++++--------------------------
 10 files changed, 86 insertions(+), 121 deletions(-)
Index: linux-2.6/arch/ia64/kvm/Kconfig
===================================================================
--- linux-2.6.orig/arch/ia64/kvm/Kconfig
+++ linux-2.6/arch/ia64/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	depends on HAVE_KVM && MODULES && EXPERIMENTAL
 	# for device assignment:
 	depends on PCI
-	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
 	select KVM_APIC_ARCHITECTURE
Index: linux-2.6/arch/powerpc/kvm/Kconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/kvm/Kconfig
+++ linux-2.6/arch/powerpc/kvm/Kconfig
@@ -18,7 +18,6 @@ if VIRTUALIZATION
 
 config KVM
 	bool
-	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 
 config KVM_BOOK3S_HANDLER
Index: linux-2.6/arch/s390/kvm/Kconfig
===================================================================
--- linux-2.6.orig/arch/s390/kvm/Kconfig
+++ linux-2.6/arch/s390/kvm/Kconfig
@@ -19,7 +19,6 @@ config KVM
 	def_tristate y
 	prompt "Kernel-based Virtual Machine (KVM) support"
 	depends on HAVE_KVM && EXPERIMENTAL
-	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	---help---
 	  Support hosting paravirtualized guest machines using the SIE
Index: linux-2.6/arch/tile/kvm/Kconfig
===================================================================
--- linux-2.6.orig/arch/tile/kvm/Kconfig
+++ linux-2.6/arch/tile/kvm/Kconfig
@@ -19,7 +19,6 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on HAVE_KVM && MODULES && EXPERIMENTAL
-	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	---help---
 	  Support hosting paravirtualized guest machines.
Index: linux-2.6/arch/x86/kvm/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/kvm/Kconfig
+++ linux-2.6/arch/x86/kvm/Kconfig
@@ -24,7 +24,6 @@ config KVM
 	depends on PCI
 	# for TASKSTATS/TASK_DELAY_ACCT:
 	depends on NET
-	select PREEMPT_NOTIFIERS
 	select MMU_NOTIFIER
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
Index: linux-2.6/include/linux/kvm_host.h
===================================================================
--- linux-2.6.orig/include/linux/kvm_host.h
+++ linux-2.6/include/linux/kvm_host.h
@@ -111,9 +111,7 @@ enum {
 
 struct kvm_vcpu {
 	struct kvm *kvm;
-#ifdef CONFIG_PREEMPT_NOTIFIERS
 	struct preempt_notifier preempt_notifier;
-#endif
 	int cpu;
 	int vcpu_id;
 	int srcu_idx;
Index: linux-2.6/include/linux/preempt.h
===================================================================
--- linux-2.6.orig/include/linux/preempt.h
+++ linux-2.6/include/linux/preempt.h
@@ -101,8 +101,6 @@ do { \
 
 #endif /* CONFIG_PREEMPT_COUNT */
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-
 struct preempt_notifier;
 
 /**
@@ -147,6 +145,4 @@ static inline void preempt_notifier_init
 	notifier->ops = ops;
 }
 
-#endif
-
 #endif /* __LINUX_PREEMPT_H */
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1236,10 +1236,8 @@ struct task_struct {
 	struct sched_entity se;
 	struct sched_rt_entity rt;
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
 	struct hlist_head preempt_notifiers;
-#endif
 
 	/*
 	 * fpu_counter contains the number of consecutive context switches
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -1403,9 +1403,6 @@ config STOP_MACHINE
 
 source "block/Kconfig"
 
-config PREEMPT_NOTIFIERS
-	bool
-
 config PADATA
 	depends on SMP
 	bool
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2387,6 +2387,54 @@ struct migration_arg {
 
 static int migration_cpu_stop(void *data);
 
+struct wait_task_inactive_blocked {
+	struct preempt_notifier notifier;
+	struct task_struct *waiter;
+};
+
+static void wait_task_inactive_sched_in(struct preempt_notifier *n, int cpu)
+{
+	struct task_struct *p;
+	struct wait_task_inactive_blocked *blocked =
+		container_of(n, struct wait_task_inactive_blocked, notifier);
+
+	hlist_del(&n->link);
+
+	p = ACCESS_ONCE(blocked->waiter);
+	blocked->waiter = NULL;
+	wake_up_process(p);
+}
+
+static void
+preempt_ops_sched_out_nop(struct preempt_notifier *n, struct task_struct *next)
+{
+}
+
+static struct preempt_ops wait_task_inactive_ops_post = {
+	.sched_in = wait_task_inactive_sched_in,
+	.sched_out = preempt_ops_sched_out_nop,
+};
+
+static void preempt_ops_sched_in_nop(struct preempt_notifier *n, int cpu)
+{
+}
+
+static void
+wait_task_inactive_sched_out(struct preempt_notifier *n, struct task_struct *next)
+{
+	if (current->on_rq) /* we're not inactive yet */
+		return;
+
+	hlist_del(&n->link);
+	n->ops = &wait_task_inactive_ops_post;
+	hlist_add_head(&n->link, &next->preempt_notifiers);
+}
+
+static struct preempt_ops wait_task_inactive_ops_pre = {
+	.sched_in = preempt_ops_sched_in_nop,
+	.sched_out = wait_task_inactive_sched_out,
+};
+
 /*
  * wait_task_inactive - wait for a thread to unschedule.
  *
@@ -2405,93 +2453,49 @@ static int migration_cpu_stop(void *data
  */
 unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 {
+	unsigned long ncsw = 0;
 	unsigned long flags;
-	int running, on_rq;
-	unsigned long ncsw;
 	struct rq *rq;
 
-	for (;;) {
-		/*
-		 * We do the initial early heuristics without holding
-		 * any task-queue locks at all. We'll only try to get
-		 * the runqueue lock when things look like they will
-		 * work out!
-		 */
-		rq = task_rq(p);
-
-		/*
-		 * If the task is actively running on another CPU
-		 * still, just relax and busy-wait without holding
-		 * any locks.
-		 *
-		 * NOTE! Since we don't hold any locks, it's not
-		 * even sure that "rq" stays as the right runqueue!
-		 * But we don't care, since "task_running()" will
-		 * return false if the runqueue has changed and p
-		 * is actually now running somewhere else!
-		 */
-		while (task_running(rq, p)) {
-			if (match_state && unlikely(p->state != match_state))
-				return 0;
-			cpu_relax();
-		}
-
-		/*
-		 * Ok, time to look more closely! We need the rq
-		 * lock now, to be *sure*. If we're wrong, we'll
-		 * just go back and repeat.
-		 */
-		rq = task_rq_lock(p, &flags);
-		trace_sched_wait_task(p);
-		running = task_running(rq, p);
-		on_rq = p->on_rq;
-		ncsw = 0;
-		if (!match_state || p->state == match_state)
-			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
-		task_rq_unlock(rq, p, &flags);
-
-		/*
-		 * If it changed from the expected state, bail out now.
-		 */
-		if (unlikely(!ncsw))
-			break;
+	struct wait_task_inactive_blocked blocked = {
+		.notifier = {
+			.ops = &wait_task_inactive_ops_pre,
+		},
+		.waiter = current,
+	};
 
-		/*
-		 * Was it really running after all now that we
-		 * checked with the proper locks actually held?
-		 *
-		 * Oops. Go back and try again..
-		 */
-		if (unlikely(running)) {
-			cpu_relax();
-			continue;
-		}
+	/*
+	 * Busy wait for the task to stop running, the caller promised it
+	 * wouldn't be long.
+	 */
+	while (p->on_cpu) {
+		/* if we don't match the expected state, bail */
+		if (match_state && unlikely(p->state != match_state))
+			return 0;
+		cpu_relax();
+	}
 
-		/*
-		 * It's not enough that it's not actively running,
-		 * it must be off the runqueue _entirely_, and not
-		 * preempted!
-		 *
-		 * So if it was still runnable (but just not actively
-		 * running right now), it's preempted, and we should
-		 * yield - it could be a while.
-		 */
-		if (unlikely(on_rq)) {
-			ktime_t to = ktime_set(0, NSEC_PER_SEC/HZ);
+	rq = task_rq_lock(p, &flags);
+	trace_sched_wait_task(p);
+	if (!p->on_rq) /* we're already blocked */
+		goto done;
 
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_hrtimeout(&to, HRTIMER_MODE_REL);
-			continue;
-		}
+	hlist_add_head(&blocked.notifier.link, &p->preempt_notifiers);
+	task_rq_unlock(rq, p, &flags);
 
-		/*
-		 * Ahh, all good. It wasn't running, and it wasn't
-		 * runnable, which means that it will never become
-		 * running in the future either. We're all done!
-		 */
-		break;
+	for (;;) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (!blocked.waiter)
+			break;
+		schedule();
 	}
+	__set_current_state(TASK_RUNNING);
 
+	rq = task_rq_lock(p, &flags);
+done:
+	if (!match_state || p->state == match_state)
+		ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
+	task_rq_unlock(rq, p, &flags);
 	return ncsw;
 }
 
@@ -2519,9 +2523,7 @@ void kick_process(struct task_struct *p)
 	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(kick_process);
-#endif /* CONFIG_SMP */
 
-#ifdef CONFIG_SMP
 /*
  * ->cpus_allowed is protected by both rq->lock and p->pi_lock
  */
@@ -2967,10 +2969,7 @@ static void __sched_fork(struct task_str
 #endif
 
 	INIT_LIST_HEAD(&p->rt.run_list);
-
-#ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
-#endif
 }
 
 /*
@@ -3084,8 +3083,6 @@ void wake_up_new_task(struct task_struct
 	task_rq_unlock(rq, p, &flags);
 }
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-
 /**
  * preempt_notifier_register - tell me when current is being preempted & rescheduled
  * @notifier: notifier struct to register
@@ -3111,9 +3108,9 @@ EXPORT_SYMBOL_GPL(preempt_notifier_unreg
 static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
 {
 	struct preempt_notifier *notifier;
-	struct hlist_node *node;
+	struct hlist_node *node, *n;
 
-	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
+	hlist_for_each_entry_safe(notifier, node, n, &curr->preempt_notifiers, link)
 		notifier->ops->sched_in(notifier, raw_smp_processor_id());
 }
 
@@ -3122,26 +3119,12 @@ fire_sched_out_preempt_notifiers(struct 
 				 struct task_struct *next)
 {
 	struct preempt_notifier *notifier;
-	struct hlist_node *node;
+	struct hlist_node *node, *n;
 
-	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
+	hlist_for_each_entry_safe(notifier, node, n, &curr->preempt_notifiers, link)
 		notifier->ops->sched_out(notifier, next);
 }
 
-#else /* !CONFIG_PREEMPT_NOTIFIERS */
-
-static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
-{
-}
-
-static void
-fire_sched_out_preempt_notifiers(struct task_struct *curr,
-				 struct task_struct *next)
-{
-}
-
-#endif /* CONFIG_PREEMPT_NOTIFIERS */
-
 /**
  * prepare_task_switch - prepare to switch tasks
  * @rq: the runqueue preparing to switch
@@ -8312,9 +8295,7 @@ void __init sched_init(void)
 
 	set_load_weight(&init_task);
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&init_task.preempt_notifiers);
-#endif
 
 #ifdef CONFIG_SMP
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);

