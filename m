Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab2JLIyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 04:54:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35974 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab2JLIxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 04:53:55 -0400
Date: Fri, 12 Oct 2012 10:53:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU fixes
Message-ID: <20121012085350.GA31140@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

   HEAD: c1f8d901d828da1df6d384780829952e7912aeba Merge branch 'rcu/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

This tree includes a shutdown/cpu-hotplug deadlock fix and a 
documentation fix.

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      rcu: Advise most users not to enable RCU user mode

Paul E. McKenney (1):
      rcu: Grace-period initialization excludes only RCU notifier


 init/Kconfig     | 12 ++++++++++++
 kernel/rcutree.c | 21 ++++++++++-----------
 kernel/rcutree.h |  6 ++++++
 3 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index c26b8a1..89093e1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -451,6 +451,12 @@ config RCU_USER_QS
 	  excluded from the global RCU state machine and thus doesn't
 	  to keep the timer tick on for RCU.
 
+	  Unless you want to hack and help the development of the full
+	  tickless feature, you shouldn't enable this option. It adds
+	  unnecessary overhead.
+
+	  If unsure say N
+
 config RCU_USER_QS_FORCE
 	bool "Force userspace extended QS by default"
 	depends on RCU_USER_QS
@@ -459,6 +465,12 @@ config RCU_USER_QS_FORCE
 	  test this feature that treats userspace as an extended quiescent
 	  state until we have a real user like a full adaptive nohz option.
 
+	  Unless you want to hack and help the development of the full
+	  tickless feature, you shouldn't enable this option. It adds
+	  unnecessary overhead.
+
+	  If unsure say N
+
 config RCU_FANOUT
 	int "Tree-based hierarchical RCU fanout value"
 	range 2 64 if 64BIT
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 4fb2376..74df86b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -74,6 +74,7 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
 	.orphan_nxttail = &sname##_state.orphan_nxtlist, \
 	.orphan_donetail = &sname##_state.orphan_donelist, \
 	.barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
+	.onoff_mutex = __MUTEX_INITIALIZER(sname##_state.onoff_mutex), \
 	.name = #sname, \
 }
 
@@ -1197,7 +1198,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	raw_spin_unlock_irq(&rnp->lock);
 
 	/* Exclude any concurrent CPU-hotplug operations. */
-	get_online_cpus();
+	mutex_lock(&rsp->onoff_mutex);
 
 	/*
 	 * Set the quiescent-state-needed bits in all the rcu_node
@@ -1234,7 +1235,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 		cond_resched();
 	}
 
-	put_online_cpus();
+	mutex_unlock(&rsp->onoff_mutex);
 	return 1;
 }
 
@@ -1700,6 +1701,7 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	/* Remove the dead CPU from the bitmasks in the rcu_node hierarchy. */
 
 	/* Exclude any attempts to start a new grace period. */
+	mutex_lock(&rsp->onoff_mutex);
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
 
 	/* Orphan the dead CPU's callbacks, and adopt them if appropriate. */
@@ -1744,6 +1746,7 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	init_callback_list(rdp);
 	/* Disallow further callbacks on this CPU. */
 	rdp->nxttail[RCU_NEXT_TAIL] = NULL;
+	mutex_unlock(&rsp->onoff_mutex);
 }
 
 #else /* #ifdef CONFIG_HOTPLUG_CPU */
@@ -2648,6 +2651,9 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	/* Exclude new grace periods. */
+	mutex_lock(&rsp->onoff_mutex);
+
 	/* Set up local state, ensuring consistent view of global state. */
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rdp->beenonline = 1;	 /* We have now been online. */
@@ -2662,14 +2668,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	rcu_prepare_for_idle_init(cpu);
 	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
-	/*
-	 * A new grace period might start here.  If so, we won't be part
-	 * of it, but that is OK, as we are currently in a quiescent state.
-	 */
-
-	/* Exclude any attempts to start a new GP on large systems. */
-	raw_spin_lock(&rsp->onofflock);		/* irqs already disabled. */
-
 	/* Add CPU to rcu_node bitmasks. */
 	rnp = rdp->mynode;
 	mask = rdp->grpmask;
@@ -2693,8 +2691,9 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 		raw_spin_unlock(&rnp->lock); /* irqs already disabled. */
 		rnp = rnp->parent;
 	} while (rnp != NULL && !(rnp->qsmaskinit & mask));
+	local_irq_restore(flags);
 
-	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
+	mutex_unlock(&rsp->onoff_mutex);
 }
 
 static void __cpuinit rcu_prepare_cpu(int cpu)
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 5faf05d..a240f03 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -394,11 +394,17 @@ struct rcu_state {
 	struct rcu_head **orphan_donetail;	/* Tail of above. */
 	long qlen_lazy;				/* Number of lazy callbacks. */
 	long qlen;				/* Total number of callbacks. */
+	/* End of fields guarded by onofflock. */
+
+	struct mutex onoff_mutex;		/* Coordinate hotplug & GPs. */
+
 	struct mutex barrier_mutex;		/* Guards barrier fields. */
 	atomic_t barrier_cpu_count;		/* # CPUs waiting on. */
 	struct completion barrier_completion;	/* Wake at barrier end. */
 	unsigned long n_barrier_done;		/* ++ at start and end of */
 						/*  _rcu_barrier(). */
+	/* End of fields guarded by barrier_mutex. */
+
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
 	unsigned long n_force_qs;		/* Number of calls to */
