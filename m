Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948Ab1DPKHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 06:07:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46614 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758554Ab1DPKHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 06:07:42 -0400
Date: Sat, 16 Apr 2011 12:07:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20110416100733.GA10363@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
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

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ken Chen (2):
      sched: Fix sched-domain avg_load calculation
      sched: Fix erroneous all_pinned logic


 kernel/sched_fair.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 7f00772..6fa833a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2104,21 +2104,20 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      enum cpu_idle_type idle, int *all_pinned,
 	      int *this_best_prio, struct cfs_rq *busiest_cfs_rq)
 {
-	int loops = 0, pulled = 0, pinned = 0;
+	int loops = 0, pulled = 0;
 	long rem_load_move = max_load_move;
 	struct task_struct *p, *n;
 
 	if (max_load_move == 0)
 		goto out;
 
-	pinned = 1;
-
 	list_for_each_entry_safe(p, n, &busiest_cfs_rq->tasks, se.group_node) {
 		if (loops++ > sysctl_sched_nr_migrate)
 			break;
 
 		if ((p->se.load.weight >> 1) > rem_load_move ||
-		    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned))
+		    !can_migrate_task(p, busiest, this_cpu, sd, idle,
+				      all_pinned))
 			continue;
 
 		pull_task(busiest, p, this_rq, this_cpu);
@@ -2153,9 +2152,6 @@ out:
 	 */
 	schedstat_add(sd, lb_gained[idle], pulled);
 
-	if (all_pinned)
-		*all_pinned = pinned;
-
 	return max_load_move - rem_load_move;
 }
 
@@ -3127,6 +3123,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
+	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
+
 	/*
 	 * If the busiest group is imbalanced the below checks don't
 	 * work because they assumes all things are equal, which typically
@@ -3151,7 +3149,6 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 * Don't pull any tasks if this group is already above the domain
 	 * average load.
 	 */
-	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
 	if (sds.this_load >= sds.avg_load)
 		goto out_balanced;
 
@@ -3340,6 +3337,7 @@ redo:
 		 * still unbalanced. ld_moved simply stays zero, so it is
 		 * correctly treated as an imbalance.
 		 */
+		all_pinned = 1;
 		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
 		ld_moved = move_tasks(this_rq, this_cpu, busiest,
