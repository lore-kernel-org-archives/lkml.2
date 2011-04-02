Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab1DBKbc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 06:31:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51644 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab1DBKbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 06:31:31 -0400
Date: Sat, 2 Apr 2011 12:31:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20110402103125.GA18746@elte.hu>
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

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      sched, doc: Beef up load balancing description

Dario Faggioli (1):
      sched: Leave sched_setscheduler() earlier if possible, do not disturb SCHED_FIFO tasks

Sisir Koppaka (1):
      sched: Fix rebalance interval calculation


 Documentation/scheduler/sched-domains.txt |   32 ++++++++++++++++++++--------
 kernel/sched.c                            |   11 ++++++++++
 kernel/sched_fair.c                       |    5 ++-
 3 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/Documentation/scheduler/sched-domains.txt b/Documentation/scheduler/sched-domains.txt
index 373ceac..b7ee379 100644
--- a/Documentation/scheduler/sched-domains.txt
+++ b/Documentation/scheduler/sched-domains.txt
@@ -1,8 +1,7 @@
-Each CPU has a "base" scheduling domain (struct sched_domain). These are
-accessed via cpu_sched_domain(i) and this_sched_domain() macros. The domain
+Each CPU has a "base" scheduling domain (struct sched_domain). The domain
 hierarchy is built from these base domains via the ->parent pointer. ->parent
-MUST be NULL terminated, and domain structures should be per-CPU as they
-are locklessly updated.
+MUST be NULL terminated, and domain structures should be per-CPU as they are
+locklessly updated.
 
 Each scheduling domain spans a number of CPUs (stored in the ->span field).
 A domain's span MUST be a superset of it child's span (this restriction could
@@ -26,11 +25,26 @@ is treated as one entity. The load of a group is defined as the sum of the
 load of each of its member CPUs, and only when the load of a group becomes
 out of balance are tasks moved between groups.
 
-In kernel/sched.c, rebalance_tick is run periodically on each CPU. This
-function takes its CPU's base sched domain and checks to see if has reached
-its rebalance interval. If so, then it will run load_balance on that domain.
-rebalance_tick then checks the parent sched_domain (if it exists), and the
-parent of the parent and so forth.
+In kernel/sched.c, trigger_load_balance() is run periodically on each CPU
+through scheduler_tick(). It raises a softirq after the next regularly scheduled
+rebalancing event for the current runqueue has arrived. The actual load
+balancing workhorse, run_rebalance_domains()->rebalance_domains(), is then run
+in softirq context (SCHED_SOFTIRQ).
+
+The latter function takes two arguments: the current CPU and whether it was idle
+at the time the scheduler_tick() happened and iterates over all sched domains
+our CPU is on, starting from its base domain and going up the ->parent chain.
+While doing that, it checks to see if the current domain has exhausted its
+rebalance interval. If so, it runs load_balance() on that domain. It then checks
+the parent sched_domain (if it exists), and the parent of the parent and so
+forth.
+
+Initially, load_balance() finds the busiest group in the current sched domain.
+If it succeeds, it looks for the busiest runqueue of all the CPUs' runqueues in
+that group. If it manages to find such a runqueue, it locks both our initial
+CPU's runqueue and the newly found busiest one and starts moving tasks from it
+to our runqueue. The exact number of tasks amounts to an imbalance previously
+computed while iterating over this sched domain's groups.
 
 *** Implementing sched domains ***
 The "base" domain will "span" the first level of the hierarchy. In the case
diff --git a/kernel/sched.c b/kernel/sched.c
index f592ce6..a884551 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5011,6 +5011,17 @@ recheck:
 		return -EINVAL;
 	}
 
+	/*
+	 * If not changing anything there's no need to proceed further:
+	 */
+	if (unlikely(policy == p->policy && (!rt_policy(policy) ||
+			param->sched_priority == p->rt_priority))) {
+
+		__task_rq_unlock(rq);
+		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		return 0;
+	}
+
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (user) {
 		/*
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3f7ec9e..c7ec5c8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -22,6 +22,7 @@
 
 #include <linux/latencytop.h>
 #include <linux/sched.h>
+#include <linux/cpumask.h>
 
 /*
  * Targeted preemption latency for CPU-bound tasks:
@@ -3850,8 +3851,8 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		interval = msecs_to_jiffies(interval);
 		if (unlikely(!interval))
 			interval = 1;
-		if (interval > HZ*NR_CPUS/10)
-			interval = HZ*NR_CPUS/10;
+		if (interval > HZ*num_online_cpus()/10)
+			interval = HZ*num_online_cpus()/10;
 
 		need_serialize = sd->flags & SD_SERIALIZE;
 
