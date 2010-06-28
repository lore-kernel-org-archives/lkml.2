Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab0F1KJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 06:09:38 -0400
Received: from www.tglx.de ([62.245.132.106]:43215 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab0F1KJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 06:09:36 -0400
Date: Mon, 28 Jun 2010 12:09:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] core fixes for 2.6.35
Message-ID: <alpine.LFD.2.00.1006281208400.2530@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

Thanks,

	tglx

------------------>
Daniel J Blueman (1):
      rcu: apply RCU protection to wake_affine()

Paul E. McKenney (1):
      idr: fix RCU lockdep splat in idr_get_next()

Peter Zijlstra (1):
      sched: silence PROVE_RCU in sched_fork()


 kernel/sched.c      |    9 +++++++++
 kernel/sched_fair.c |    2 ++
 lib/idr.c           |    4 ++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f8b8996..a2d215d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2494,7 +2494,16 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	if (p->sched_class->task_fork)
 		p->sched_class->task_fork(p);
 
+	/*
+	 * The child is not yet in the pid-hash so no cgroup attach races,
+	 * and the cgroup is pinned to this child due to cgroup_fork()
+	 * is ran before sched_fork().
+	 *
+	 * Silence PROVE_RCU.
+	 */
+	rcu_read_lock();
 	set_task_cpu(p, cpu);
+	rcu_read_unlock();
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index eed35ed..a878b53 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1240,6 +1240,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 * effect of the currently running task from the load
 	 * of the current CPU:
 	 */
+	rcu_read_lock();
 	if (sync) {
 		tg = task_group(current);
 		weight = current->se.load.weight;
@@ -1275,6 +1276,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 		balanced = this_eff_load <= prev_eff_load;
 	} else
 		balanced = true;
+	rcu_read_unlock();
 
 	/*
 	 * If the currently running task will sleep within
diff --git a/lib/idr.c b/lib/idr.c
index c1a2069..7f1a4f0 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -602,7 +602,7 @@ void *idr_get_next(struct idr *idp, int *nextidp)
 	/* find first ent */
 	n = idp->layers * IDR_BITS;
 	max = 1 << n;
-	p = rcu_dereference(idp->top);
+	p = rcu_dereference_raw(idp->top);
 	if (!p)
 		return NULL;
 
@@ -610,7 +610,7 @@ void *idr_get_next(struct idr *idp, int *nextidp)
 		while (n > 0 && p) {
 			n -= IDR_BITS;
 			*paa++ = p;
-			p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
+			p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
 		}
 
 		if (p) {
