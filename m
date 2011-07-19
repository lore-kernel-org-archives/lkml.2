Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab1GSDse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 23:48:34 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40224 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab1GSDsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 23:48:32 -0400
Date: Mon, 18 Jul 2011 20:46:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: current_thread_info() vs task_thread_info(current)
Message-ID: <20110719034658.GA8290@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1310988183.13765.56.camel@twins>
 <1310990097.25044.307.camel@pasglop>
 <20110718143731.GA2312@linux.vnet.ibm.com>
 <1311024983.25044.325.camel@pasglop>
 <20110719003930.GF2312@linux.vnet.ibm.com>
 <1311037057.25044.346.camel@pasglop>
 <20110719030404.GA2355@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110719030404.GA2355@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 08:04:04PM -0700, Paul E. McKenney wrote:
> On Tue, Jul 19, 2011 at 10:57:37AM +1000, Benjamin Herrenschmidt wrote:
> > On Mon, 2011-07-18 at 17:39 -0700, Paul E. McKenney wrote:
> > > > Hrm, no I don't see that happening no. The preempt count when
> > > exiting an
> > > > irq or softirq stack should be the exact same as when entering it,
> > > which
> > > > is why we don't bother copying it over. Do you see any case where
> > > that
> > > > wouldn't hold ?
> > > 
> > > Nope, other than seeing preempt_count() transition from zero to three
> > > across a spin_unlock_irqrestore() for no good reason that I could see.
> > 
> > Do you have a nice repro-case ? :-)
> > 
> > That sounds really nasty ... smells really like something bad's
> > happening from an interrupt, but we don't copy back the preempt-count
> > from the interrupt stacks at all, so that's really really odd.
> 
> Good question...  The system I reproduced on four times over the
> weekend is out of commission.  Trying the same test on another system
> with a minimal patch -- will let you know how it goes.

OK, the ABAT system trillian reproduces this.  Here is the repeat-by:

1.	Apply the patch shown below to 3.0-rc7.

2.	Build the system with the following config:

	CONFIG_RCU_TRACE=n
	CONFIG_NO_HZ=n
	CONFIG_SMP=y
	CONFIG_RCU_FANOUT=4
	CONFIG_NR_CPUS=8
	CONFIG_RCU_FANOUT_EXACT=n
	CONFIG_HOTPLUG_CPU=n
	CONFIG_SUSPEND=n
	CONFIG_HIBERNATION=n
	CONFIG_PREEMPT_NONE=n
	CONFIG_PREEMPT_VOLUNTARY=n
	CONFIG_PREEMPT=y
	#CHECK#CONFIG_TREE_PREEMPT_RCU=y
	CONFIG_RCU_TORTURE_TEST=m
	CONFIG_MODULE_UNLOAD=y
	CONFIG_SYSFS_DEPRECATED_V2=y
	CONFIG_IKCONFIG=y
	CONFIG_IKCONFIG_PROC=y
	CONFIG_PRINTK_TIME=y

3.	Boot the system and do the following:

	modprobe rcutorture torture_type=rcu_expedited stat_interval=30 test_no_idle_hz

4.	Within a few seconds (12.7 milliseconds on trillian), you
	should get something like the following in dmesg:

	rcu_expedited-torture:--- Start of test: nreaders=16 nfakewriters=4 stat_interval=30 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
	BUG: kernel/rcutree_plugin.h:802: preemption disabled
	BUG: scheduling while atomic: rcu_torture_fak/9422/0x00000003//825
	Modules linked in: rcutorture [last unloaded: scsi_wait_scan]
	Call Trace:
	[c0000000bdc93940] [c000000000015104] .show_stack+0x74/0x1c0 (unreliable)
	[c0000000bdc939f0] [c00000000007b1d8] .__schedule_bug+0x88/0x90
	[c0000000bdc93a70] [c000000000687f2c] .schedule+0x94c/0xa80
	[c0000000bdc93d30] [c000000000105e04] .synchronize_rcu_expedited+0x3a4/0x550
	[c0000000bdc93e20] [d000000001511a08] .rcu_torture_fakewriter+0xc8/0x190 [rcutorture]
	[c0000000bdc93ed0] [c0000000000b49dc] .kthread+0xbc/0xd0
	[c0000000bdc93f90] [c000000000021fe4] .kernel_thread+0x54/0x70

Lines 802 of kernel/rcutree_plugin.h is the one marked below with
/*-----*/:

	current->rcu_debug_loc = __LINE__;
	rcu_check_preempt(__LINE__);
	synchronize_sched_expedited();
	rcu_check_preempt(__LINE__);

	raw_spin_lock_irqsave(&rsp->onofflock, flags);

	/* Initialize ->expmask for all non-leaf rcu_node structures. */
	current->rcu_debug_loc = __LINE__;
	rcu_check_preempt(__LINE__);  /*-----*/
	rcu_for_each_nonleaf_node_breadth_first(rsp, rnp) {
		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
		rnp->expmask = rnp->qsmaskinit;
		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
	}

So preempt_count() was zero just before the raw_spin_lock_irqsave()
and 3 just after.  The scheduling-while-atomic bug is from the
wait_event() a few lines further down.

							Thanx, Paul

------------------------------------------------------------------------

rcu: decrease rcu_report_exp_rnp coupling with scheduler

PREEMPT_RCU read-side critical sections blocking an expedited grace
period invoke rcu_report_exp_rnp().  When the last such critical section
has completed, rcu_report_exp_rnp() invokes the scheduler to wake up the
task that invoked synchronize_rcu_expedited() -- needlessly holding the
root rcu_node structure's lock while doing so, thus needlessly providing
a way for RCU and the scheduler to deadlock.

This commit therefore releases the root rcu_node structure's lock before
calling wake_up().  And also adds a bunch of diagnostics.

Reported-by: Ed Tomlinson <edt@aei.ca>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 496770a..3501f3f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1258,6 +1258,7 @@ struct task_struct {
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	struct rcu_node *rcu_blocked_node;
+	int rcu_debug_loc;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 #ifdef CONFIG_RCU_BOOST
 	struct rt_mutex *rcu_boost_mutex;
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 14dc7dd..e182224 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -696,8 +696,10 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	for (;;) {
 		if (!sync_rcu_preempt_exp_done(rnp))
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			break;
 		if (rnp->parent == NULL) {
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			wake_up(&sync_rcu_preempt_exp_wq);
 			break;
 		}
@@ -707,7 +709,6 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 		raw_spin_lock(&rnp->lock); /* irqs already disabled */
 		rnp->expmask &= ~mask;
 	}
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -735,6 +736,19 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 		rcu_report_exp_rnp(rsp, rnp);
 }
 
+static inline void rcu_check_preempt(int lineno)
+{
+	static int warned;
+
+	if (warned)
+		return;
+	if (preempt_count() != 0) {
+		warned = 1;
+		printk(KERN_ERR "BUG: %s:%d: preemption disabled\n",
+		       __FILE__, lineno);
+	}
+}
+
 /*
  * Wait for an rcu-preempt grace period, but expedite it.  The basic idea
  * is to invoke synchronize_sched_expedited() to push all the tasks to
@@ -748,10 +762,13 @@ void synchronize_rcu_expedited(void)
 	long snap;
 	int trycount = 0;
 
+	rcu_check_preempt(__LINE__);
 	smp_mb(); /* Caller's modifications seen first by other CPUs. */
 	snap = ACCESS_ONCE(sync_rcu_preempt_exp_count) + 1;
 	smp_mb(); /* Above access cannot bleed into critical section. */
 
+	current->rcu_debug_loc = __LINE__;
+
 	/*
 	 * Acquire lock, falling back to synchronize_rcu() if too many
 	 * lock-acquisition failures.  Of course, if someone does the
@@ -761,6 +778,8 @@ void synchronize_rcu_expedited(void)
 		if (trycount++ < 10)
 			udelay(trycount * num_online_cpus());
 		else {
+			rcu_check_preempt(__LINE__);
+			current->rcu_debug_loc = __LINE__;
 			synchronize_rcu();
 			return;
 		}
@@ -771,27 +790,39 @@ void synchronize_rcu_expedited(void)
 		goto unlock_mb_ret; /* Others did our work for us. */
 
 	/* force all RCU readers onto ->blkd_tasks lists. */
+	current->rcu_debug_loc = __LINE__;
+	rcu_check_preempt(__LINE__);
 	synchronize_sched_expedited();
+	rcu_check_preempt(__LINE__);
 
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
 
 	/* Initialize ->expmask for all non-leaf rcu_node structures. */
+	current->rcu_debug_loc = __LINE__;
+	rcu_check_preempt(__LINE__);
 	rcu_for_each_nonleaf_node_breadth_first(rsp, rnp) {
 		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
 		rnp->expmask = rnp->qsmaskinit;
 		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 	}
+	rcu_check_preempt(__LINE__);
 
 	/* Snapshot current state of ->blkd_tasks lists. */
+	current->rcu_debug_loc = __LINE__;
+	rcu_check_preempt(__LINE__);
 	rcu_for_each_leaf_node(rsp, rnp)
 		sync_rcu_preempt_exp_init(rsp, rnp);
+	rcu_check_preempt(__LINE__);
 	if (NUM_RCU_NODES > 1)
 		sync_rcu_preempt_exp_init(rsp, rcu_get_root(rsp));
+	rcu_check_preempt(__LINE__);
 
 	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 
 	/* Wait for snapshotted ->blkd_tasks lists to drain. */
+	rcu_check_preempt(__LINE__);
 	rnp = rcu_get_root(rsp);
+	current->rcu_debug_loc = __LINE__;
 	wait_event(sync_rcu_preempt_exp_wq,
 		   sync_rcu_preempt_exp_done(rnp));
 
@@ -802,6 +833,7 @@ unlock_mb_ret:
 	mutex_unlock(&sync_rcu_preempt_exp_mutex);
 mb_ret:
 	smp_mb(); /* ensure subsequent action seen after grace period. */
+	current->rcu_debug_loc = 0;
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 9769c75..a37c9bf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4135,6 +4135,8 @@ EXPORT_SYMBOL(sub_preempt_count);
 
 #endif
 
+DECLARE_PER_CPU(int, rcu_debug_loc);
+
 /*
  * Print scheduling while atomic bug:
  */
@@ -4142,8 +4144,9 @@ static noinline void __schedule_bug(struct task_struct *prev)
 {
 	struct pt_regs *regs = get_irq_regs();
 
-	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
-		prev->comm, prev->pid, preempt_count());
+	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x//%d\n",
+		prev->comm, prev->pid, preempt_count(),
+		current->rcu_debug_loc);
 
 	debug_show_held_locks(prev);
 	print_modules();
