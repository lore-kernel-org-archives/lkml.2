Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1DSUXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:23:25 -0400
Received: from kroah.org ([198.145.64.141]:35641 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab1DSURa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:30 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:48 2011
Message-Id: <20110419201048.166112266@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ken Chen <kenchen@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [47/70] sched: Fix erroneous all_pinned logic
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ken Chen <kenchen@google.com>

commit b30aef17f71cf9e24b10c11cbb5e5f0ebe8a85ab upstream.

The scheduler load balancer has specific code to deal with cases of
unbalanced system due to lots of unmovable tasks (for example because of
hard CPU affinity). In those situation, it excludes the busiest CPU that
has pinned tasks for load balance consideration such that it can perform
second 2nd load balance pass on the rest of the system.

This all works as designed if there is only one cgroup in the system.

However, when we have multiple cgroups, this logic has false positives and
triggers multiple load balance passes despite there are actually no pinned
tasks at all.

The reason it has false positives is that the all pinned logic is deep in
the lowest function of can_migrate_task() and is too low level:

load_balance_fair() iterates each task group and calls balance_tasks() to
migrate target load. Along the way, balance_tasks() will also set a
all_pinned variable. Given that task-groups are iterated, this all_pinned
variable is essentially the status of last group in the scanning process.
Task group can have number of reasons that no load being migrated, none
due to cpu affinity. However, this status bit is being propagated back up
to the higher level load_balance(), which incorrectly think that no tasks
were moved.  It kick off the all pinned logic and start multiple passes
attempt to move load onto puller CPU.

To fix this, move the all_pinned aggregation up at the iterator level.
This ensures that the status is aggregated over all task-groups, not just
last one in the list.

Signed-off-by: Ken Chen <kenchen@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/BANLkTi=ernzNawaR5tJZEsV_QVnfxqXmsQ@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched_fair.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2043,21 +2043,20 @@ balance_tasks(struct rq *this_rq, int th
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
@@ -2092,9 +2091,6 @@ out:
 	 */
 	schedstat_add(sd, lb_gained[idle], pulled);
 
-	if (all_pinned)
-		*all_pinned = pinned;
-
 	return max_load_move - rem_load_move;
 }
 
@@ -3297,6 +3293,7 @@ redo:
 		 * still unbalanced. ld_moved simply stays zero, so it is
 		 * correctly treated as an imbalance.
 		 */
+		all_pinned = 1;
 		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
 		ld_moved = move_tasks(this_rq, this_cpu, busiest,


