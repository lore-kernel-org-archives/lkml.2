Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab0EDRt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:49:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54013 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756941Ab0EDRt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:49:58 -0400
Date: Tue, 4 May 2010 19:49:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] core fixes
Message-ID: <20100504174946.GA11738@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Benjamin Herrenschmidt (1):
      mutex: Don't spin when the owner CPU is offline or other weird cases

Paul E. McKenney (1):
      rcu: Fix RCU lockdep splat on freezer_fork path

Peter Zijlstra (1):
      rcu: Fix RCU lockdep splat in set_task_cpu on fork path


 kernel/cgroup_freezer.c |    5 ++++-
 kernel/sched.c          |   18 ++++++++++++++----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index da5e139..e5c0244 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -205,9 +205,12 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	 * No lock is needed, since the task isn't on tasklist yet,
 	 * so it can't be moved to another cgroup, which means the
 	 * freezer won't be removed and will be valid during this
-	 * function call.
+	 * function call.  Nevertheless, apply RCU read-side critical
+	 * section to suppress RCU lockdep false positives.
 	 */
+	rcu_read_lock();
 	freezer = task_freezer(task);
+	rcu_read_unlock();
 
 	/*
 	 * The root cgroup is non-freezable, so we can skip the
diff --git a/kernel/sched.c b/kernel/sched.c
index 6af210a..3c2a54f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -323,6 +323,15 @@ static inline struct task_group *task_group(struct task_struct *p)
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
+	/*
+	 * Strictly speaking this rcu_read_lock() is not needed since the
+	 * task_group is tied to the cgroup, which in turn can never go away
+	 * as long as there are tasks attached to it.
+	 *
+	 * However since task_group() uses task_subsys_state() which is an
+	 * rcu_dereference() user, this quiets CONFIG_PROVE_RCU.
+	 */
+	rcu_read_lock();
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
 	p->se.parent = task_group(p)->se[cpu];
@@ -332,6 +341,7 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
 	p->rt.parent = task_group(p)->rt_se[cpu];
 #endif
+	rcu_read_unlock();
 }
 
 #else
@@ -3780,7 +3790,7 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 	 * the mutex owner just released it and exited.
 	 */
 	if (probe_kernel_address(&owner->cpu, cpu))
-		goto out;
+		return 0;
 #else
 	cpu = owner->cpu;
 #endif
@@ -3790,14 +3800,14 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 	 * the cpu field may no longer be valid.
 	 */
 	if (cpu >= nr_cpumask_bits)
-		goto out;
+		return 0;
 
 	/*
 	 * We need to validate that we can do a
 	 * get_cpu() and that we have the percpu area.
 	 */
 	if (!cpu_online(cpu))
-		goto out;
+		return 0;
 
 	rq = cpu_rq(cpu);
 
@@ -3816,7 +3826,7 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 
 		cpu_relax();
 	}
-out:
+
 	return 1;
 }
 #endif
