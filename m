Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab1DKKrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 06:47:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:48236 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab1DKKrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 06:47:14 -0400
Date: Mon, 11 Apr 2011 10:46:51 GMT
From: tip-bot for Ken Chen <kenchen@google.com>
Message-ID: <tip-b30aef17f71cf9e24b10c11cbb5e5f0ebe8a85ab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, kenchen@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, kenchen@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <BANLkTi=ernzNawaR5tJZEsV_QVnfxqXmsQ@mail.gmail.com>
References: <BANLkTi=ernzNawaR5tJZEsV_QVnfxqXmsQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix erroneous all_pinned logic
Git-Commit-ID: b30aef17f71cf9e24b10c11cbb5e5f0ebe8a85ab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 10:46:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b30aef17f71cf9e24b10c11cbb5e5f0ebe8a85ab
Gitweb:     http://git.kernel.org/tip/b30aef17f71cf9e24b10c11cbb5e5f0ebe8a85ab
Author:     Ken Chen <kenchen@google.com>
AuthorDate: Fri, 8 Apr 2011 12:20:16 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 11:08:54 +0200

sched: Fix erroneous all_pinned logic

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
Cc: stable@kernel.org
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/BANLkTi=ernzNawaR5tJZEsV_QVnfxqXmsQ@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 60f9d40..6fa833a 100644
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
 
@@ -3341,6 +3337,7 @@ redo:
 		 * still unbalanced. ld_moved simply stays zero, so it is
 		 * correctly treated as an imbalance.
 		 */
+		all_pinned = 1;
 		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
 		ld_moved = move_tasks(this_rq, this_cpu, busiest,
