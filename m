Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2F2RXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 13:23:31 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37606 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab2F2RXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 13:23:30 -0400
Date: Fri, 29 Jun 2012 10:23:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: rcu: BUG: spinlock recursion on CPU#3, trinity-child19/5970
Message-ID: <20120629172320.GA2416@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1340964584.2936.40.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340964584.2936.40.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12062917-3534-0000-0000-000009F2DBCD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 12:09:44PM +0200, Sasha Levin wrote:
> Hi Paul,
> 
> I think I've stumbled on another bug that will increase your paranoia levels even further.
> 
> I got the following lockup when fuzzing with trinity inside a KVM tools guest, using latest linux-next.
> 
> It appears that it was caused by a03d6178 ("rcu: Move RCU grace-period cleanup into kthread"). This issue doesn't reproduce easily though, it took some fuzzing before hitting it.

Hmmm...  If the preemption at that point in __rcu_read_unlock() is
required to make this happen, then it would be pretty hard to hit.
I suspect that you can make it reproduce more quickly by putting
a udelay(10) or similar right after the assignment of INT_MIN to
t->rcu_read_lock_nesting in __rcu_read_unlock() in kernel/rcupdate.c.
Can this be reproduced while running with lockdep enabled?

Please see below for an untested patch that gets RCU out of this loop,
but it is quite possible that something else is involved here, so it would
be very good to get a lockdep run, if possible.  My concern stems from the
fact that interrupts were enabled during the call to __rcu_read_unlock()
-- otherwise it would not have been preempted -- so the runqueue locks
were presumably not held on entry to __rcu_read_unlock().

							Thanx, Paul

------------------------------------------------------------------------

rcu: Avoid grace-period kthread wakeups from unsafe environments

A soft lockup involving the run-queue locks involved the wakeup of
the grace-period kthread.  This commit therefore defers the wakeup
to softirq context.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c0e0454..cd0076e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1262,6 +1262,15 @@ static int rcu_gp_kthread(void *arg)
 }
 
 /*
+ * Signal the RCU core to wake up the grace-period kthread, as we might
+ * not be in a context where it is safe to do the wakeup directly.
+ */
+static void rcu_wake_gp_kthread(struct rcu_state *rsp)
+{
+	ACCESS_ONCE(rsp->wake_gp_kthread) = 1;
+}
+
+/*
  * Start a new RCU grace period if warranted, re-initializing the hierarchy
  * in preparation for detecting the next grace period.  The caller must hold
  * the root node's ->lock, which is released before return.  Hard irqs must
@@ -1291,7 +1300,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 
 	rsp->gp_flags = 1;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	wake_up(&rsp->gp_wq);
+	rcu_wake_gp_kthread(rsp);
 }
 
 /*
@@ -1306,7 +1315,7 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 {
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 	raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
-	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
+	rcu_wake_gp_kthread(rsp); /* smp_mb() implied by wakeup. */
 }
 
 /*
@@ -1889,6 +1898,12 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 
 	WARN_ON_ONCE(rdp->beenonline == 0);
 
+	/* Awaken the grace-period kthread if needed. */
+	if (ACCESS_ONCE(rsp->wake_gp_kthread)) {
+		if (xchg(&rsp->wake_gp_kthread, 0)) /* Prevent wakeup storms. */
+			wake_up(&rsp->gp_wq);
+	}
+
 	/*
 	 * Advance callbacks in response to end of earlier grace
 	 * period that some other CPU ended.
@@ -2304,6 +2319,12 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 		return 1;
 	}
 
+	/* Does the grace-period kthread need to be awakened? */
+	if (ACCESS_ONCE(rsp->wake_gp_kthread)) {
+		rdp->n_wake_gp_kthread++;
+		return 1;
+	}
+
 	/* nothing to do */
 	rdp->n_rp_need_nothing++;
 	return 0;
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 280ad7c..89a190c 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -313,6 +313,7 @@ struct rcu_data {
 	unsigned long n_rp_cpu_needs_gp;
 	unsigned long n_rp_gp_completed;
 	unsigned long n_rp_gp_started;
+	unsigned long n_wake_gp_kthread;
 	unsigned long n_rp_need_nothing;
 
 	/* 6) _rcu_barrier() callback. */
@@ -381,6 +382,7 @@ struct rcu_state {
 	struct task_struct *gp_kthread;		/* Task for grace periods. */
 	wait_queue_head_t gp_wq;		/* Where GP task waits. */
 	int gp_flags;				/* Commands for GP task. */
+	int wake_gp_kthread;			/* Awaken GP task? */
 
 	/* End of fields guarded by root rcu_node's lock. */
 

