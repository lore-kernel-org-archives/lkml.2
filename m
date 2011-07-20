Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab1GTVFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 17:05:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47058 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1GTVFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 17:05:52 -0400
Date: Wed, 20 Jul 2011 23:04:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ben Greear <greearb@candelatech.com>, Ed Tomlinson <edt@aei.ca>,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, edward.tomlinson@aero.bombardier.com,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: [GIT PULL] RCU fixes for v3.0
Message-ID: <20110720210426.GA30743@elte.hu>
References: <CA+55aFyaCY=qzFKswi2NR097KZtb5x98sba3rHJ7B0rchtzm2g@mail.gmail.com>
 <20110720133443.GG2400@linux.vnet.ibm.com>
 <4E270A0E.6090902@candelatech.com>
 <20110720171532.GB2313@linux.vnet.ibm.com>
 <20110720184413.GD17977@elte.hu>
 <1311187978.29152.58.camel@twins>
 <CA+55aFyuKTj3zEvWJEx4_RDzLQ+ipJ58UWFYH84nmcwGF_c4aA@mail.gmail.com>
 <20110720192949.GM2313@linux.vnet.ibm.com>
 <20110720193925.GB7910@elte.hu>
 <20110720195742.GA14671@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720195742.GA14671@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Having put some testing into your rcu/urgent branch today i'd feel 
> more comfortable with taking this plus perhaps an RCU_BOOST 
> disabling patch. That makes it all fundamentally tested by a number 
> of people (including those who reported/reproduced the problems).
> 
> Linus, would that approach be fine with you? I'll send an RFC pull 
> request for the 6 patches as a reply to this mail, in a couple of 
> minutes.

here it is:

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-urgent-for-linus

In addition to the testing Paul & co has performed i have boot tested 
x86 defconfig/allno/allyes/allmod and a fair number of randconfigs, 
and i build tested a dozen architecture defconfigs, amongst them the 
key ones.

( We could also mark RCU_BOOST in init/Kconfig as EXPERIMENTAL, to
  further de-risk it - but that change is not part of this pull
  request. )

 Thanks,

	Ingo

------------------>
Paul E. McKenney (5):
      rcu: decrease rcu_report_exp_rnp coupling with scheduler
      rcu: Fix RCU_BOOST race handling current->rcu_read_unlock_special
      rcu: Streamline code produced by __rcu_read_unlock()
      rcu: protect __rcu_read_unlock() against scheduler-using irq handlers
      signal: align __lock_task_sighand() irq disabling and RCU

Peter Zijlstra (2):
      sched: Add irq_{enter,exit}() to scheduler_ipi()
      softirq,rcu: Inform RCU of irq_exit() activity


 include/linux/sched.h   |    3 ++
 kernel/rcutree_plugin.h |   53 ++++++++++++++++++++++++++++++++++------------
 kernel/sched.c          |   44 +++++++++++++++++++++++++++++++++-----
 kernel/signal.c         |   19 +++++++++++-----
 kernel/softirq.c        |   12 ++++++++-
 5 files changed, 103 insertions(+), 28 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 496770a..76676a4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1254,6 +1254,9 @@ struct task_struct {
 #ifdef CONFIG_PREEMPT_RCU
 	int rcu_read_lock_nesting;
 	char rcu_read_unlock_special;
+#if defined(CONFIG_RCU_BOOST) && defined(CONFIG_TREE_PREEMPT_RCU)
+	int rcu_boosted;
+#endif /* #if defined(CONFIG_RCU_BOOST) && defined(CONFIG_TREE_PREEMPT_RCU) */
 	struct list_head rcu_node_entry;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
 #ifdef CONFIG_TREE_PREEMPT_RCU
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 75113cb..8aafbb8 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -68,6 +68,7 @@ struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
 static struct rcu_state *rcu_state = &rcu_preempt_state;
 
+static void rcu_read_unlock_special(struct task_struct *t);
 static int rcu_preempted_readers_exp(struct rcu_node *rnp);
 
 /*
@@ -147,7 +148,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
 
-	if (t->rcu_read_lock_nesting &&
+	if (t->rcu_read_lock_nesting > 0 &&
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
@@ -190,6 +191,14 @@ static void rcu_preempt_note_context_switch(int cpu)
 				rnp->gp_tasks = &t->rcu_node_entry;
 		}
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	} else if (t->rcu_read_lock_nesting < 0 &&
+		   t->rcu_read_unlock_special) {
+
+		/*
+		 * Complete exit from RCU read-side critical section on
+		 * behalf of preempted instance of __rcu_read_unlock().
+		 */
+		rcu_read_unlock_special(t);
 	}
 
 	/*
@@ -284,7 +293,7 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t,
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-static void rcu_read_unlock_special(struct task_struct *t)
+static noinline void rcu_read_unlock_special(struct task_struct *t)
 {
 	int empty;
 	int empty_exp;
@@ -309,7 +318,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 	}
 
 	/* Hardware IRQ handlers cannot block. */
-	if (in_irq()) {
+	if (in_irq() || in_serving_softirq()) {
 		local_irq_restore(flags);
 		return;
 	}
@@ -342,6 +351,11 @@ static void rcu_read_unlock_special(struct task_struct *t)
 #ifdef CONFIG_RCU_BOOST
 		if (&t->rcu_node_entry == rnp->boost_tasks)
 			rnp->boost_tasks = np;
+		/* Snapshot and clear ->rcu_boosted with rcu_node lock held. */
+		if (t->rcu_boosted) {
+			special |= RCU_READ_UNLOCK_BOOSTED;
+			t->rcu_boosted = 0;
+		}
 #endif /* #ifdef CONFIG_RCU_BOOST */
 		t->rcu_blocked_node = NULL;
 
@@ -358,7 +372,6 @@ static void rcu_read_unlock_special(struct task_struct *t)
 #ifdef CONFIG_RCU_BOOST
 		/* Unboost if we were boosted. */
 		if (special & RCU_READ_UNLOCK_BOOSTED) {
-			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BOOSTED;
 			rt_mutex_unlock(t->rcu_boost_mutex);
 			t->rcu_boost_mutex = NULL;
 		}
@@ -387,13 +400,22 @@ void __rcu_read_unlock(void)
 	struct task_struct *t = current;
 
 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
-	--t->rcu_read_lock_nesting;
-	barrier();  /* decrement before load of ->rcu_read_unlock_special */
-	if (t->rcu_read_lock_nesting == 0 &&
-	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
-		rcu_read_unlock_special(t);
+	if (t->rcu_read_lock_nesting != 1)
+		--t->rcu_read_lock_nesting;
+	else {
+		t->rcu_read_lock_nesting = INT_MIN;
+		barrier();  /* assign before ->rcu_read_unlock_special load */
+		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
+			rcu_read_unlock_special(t);
+		barrier();  /* ->rcu_read_unlock_special load before assign */
+		t->rcu_read_lock_nesting = 0;
+	}
 #ifdef CONFIG_PROVE_LOCKING
-	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
+	{
+		int rrln = ACCESS_ONCE(t->rcu_read_lock_nesting);
+
+		WARN_ON_ONCE(rrln < 0 && rrln > INT_MIN / 2);
+	}
 #endif /* #ifdef CONFIG_PROVE_LOCKING */
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
@@ -589,7 +611,8 @@ static void rcu_preempt_check_callbacks(int cpu)
 		rcu_preempt_qs(cpu);
 		return;
 	}
-	if (per_cpu(rcu_preempt_data, cpu).qs_pending)
+	if (t->rcu_read_lock_nesting > 0 &&
+	    per_cpu(rcu_preempt_data, cpu).qs_pending)
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
 }
 
@@ -695,9 +718,12 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	for (;;) {
-		if (!sync_rcu_preempt_exp_done(rnp))
+		if (!sync_rcu_preempt_exp_done(rnp)) {
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			break;
+		}
 		if (rnp->parent == NULL) {
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			wake_up(&sync_rcu_preempt_exp_wq);
 			break;
 		}
@@ -707,7 +733,6 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 		raw_spin_lock(&rnp->lock); /* irqs already disabled */
 		rnp->expmask &= ~mask;
 	}
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -1174,7 +1199,7 @@ static int rcu_boost(struct rcu_node *rnp)
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
 	t->rcu_boost_mutex = &mtx;
-	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
+	t->rcu_boosted = 1;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
diff --git a/kernel/sched.c b/kernel/sched.c
index 3dc716f..31e92ae 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2544,13 +2544,9 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 }
 
 #ifdef CONFIG_SMP
-static void sched_ttwu_pending(void)
+static void sched_ttwu_do_pending(struct task_struct *list)
 {
 	struct rq *rq = this_rq();
-	struct task_struct *list = xchg(&rq->wake_list, NULL);
-
-	if (!list)
-		return;
 
 	raw_spin_lock(&rq->lock);
 
@@ -2563,9 +2559,45 @@ static void sched_ttwu_pending(void)
 	raw_spin_unlock(&rq->lock);
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+static void sched_ttwu_pending(void)
+{
+	struct rq *rq = this_rq();
+	struct task_struct *list = xchg(&rq->wake_list, NULL);
+
+	if (!list)
+		return;
+
+	sched_ttwu_do_pending(list);
+}
+
+#endif /* CONFIG_HOTPLUG_CPU */
+
 void scheduler_ipi(void)
 {
-	sched_ttwu_pending();
+	struct rq *rq = this_rq();
+	struct task_struct *list = xchg(&rq->wake_list, NULL);
+
+	if (!list)
+		return;
+
+	/*
+	 * Not all reschedule IPI handlers call irq_enter/irq_exit, since
+	 * traditionally all their work was done from the interrupt return
+	 * path. Now that we actually do some work, we need to make sure
+	 * we do call them.
+	 *
+	 * Some archs already do call them, luckily irq_enter/exit nest
+	 * properly.
+	 *
+	 * Arguably we should visit all archs and update all handlers,
+	 * however a fair share of IPIs are still resched only so this would
+	 * somewhat pessimize the simple resched case.
+	 */
+	irq_enter();
+	sched_ttwu_do_pending(list);
+	irq_exit();
 }
 
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
diff --git a/kernel/signal.c b/kernel/signal.c
index ff76786..415d85d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1178,18 +1178,25 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 {
 	struct sighand_struct *sighand;
 
-	rcu_read_lock();
 	for (;;) {
+		local_irq_save(*flags);
+		rcu_read_lock();
 		sighand = rcu_dereference(tsk->sighand);
-		if (unlikely(sighand == NULL))
+		if (unlikely(sighand == NULL)) {
+			rcu_read_unlock();
+			local_irq_restore(*flags);
 			break;
+		}
 
-		spin_lock_irqsave(&sighand->siglock, *flags);
-		if (likely(sighand == tsk->sighand))
+		spin_lock(&sighand->siglock);
+		if (likely(sighand == tsk->sighand)) {
+			rcu_read_unlock();
 			break;
-		spin_unlock_irqrestore(&sighand->siglock, *flags);
+		}
+		spin_unlock(&sighand->siglock);
+		rcu_read_unlock();
+		local_irq_restore(*flags);
 	}
-	rcu_read_unlock();
 
 	return sighand;
 }
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 40cf63d..fca82c3 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -315,16 +315,24 @@ static inline void invoke_softirq(void)
 {
 	if (!force_irqthreads)
 		__do_softirq();
-	else
+	else {
+		__local_bh_disable((unsigned long)__builtin_return_address(0),
+				SOFTIRQ_OFFSET);
 		wakeup_softirqd();
+		__local_bh_enable(SOFTIRQ_OFFSET);
+	}
 }
 #else
 static inline void invoke_softirq(void)
 {
 	if (!force_irqthreads)
 		do_softirq();
-	else
+	else {
+		__local_bh_disable((unsigned long)__builtin_return_address(0),
+				SOFTIRQ_OFFSET);
 		wakeup_softirqd();
+		__local_bh_enable(SOFTIRQ_OFFSET);
+	}
 }
 #endif
 
