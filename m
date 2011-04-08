Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab1DHTUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 15:20:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:9263 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516Ab1DHTUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 15:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fWMzdM+QYprYXgFYqWsZOVt2tZFxbSPzo6/578JQTBseMnDar7HOB7X5Oh1DghtvQH
         r96X6gIn+9tGg2ostwKA==
MIME-Version: 1.0
In-Reply-To: <1302263357.9086.138.camel@twins>
References: <20110408002420.3F3A912217F@elm.corp.google.com>
	<870910A1-62AF-412F-A989-1FA57B715E35@parallels.com>
	<1302263357.9086.138.camel@twins>
Date: Fri, 8 Apr 2011 12:20:16 -0700
Message-ID: <BANLkTi=ernzNawaR5tJZEsV_QVnfxqXmsQ@mail.gmail.com>
Subject: Re: Subject: [PATCH] sched: fixed erroneous all_pinned logic.
From: Ken Chen <kenchen@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vladimir Davydov <VDavydov@parallels.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 4:49 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> As far as I understand, this patch sets the all_pinned flag if and
>> only if we fail to move any tasks during the load balance. However,
>> the migration can fail because e.g. all tasks are cache hot on their
>> cpus (can_migrate_task() returns 0 in this case), and in this case we
>> shouldn't treat all tasks as cpu bound, should we?--
>
> Hmm, you've got a good point there... (that'll teach me to read email in
> date order).
>
> Ken would it work to only push the all_pinned = 1 higher and not also
> the all_pinned = 0?

OK.  That would work as well.  We just need to aggregate all_pinned at
level higher than task-group iterator so it collect status accross all
tasks, instead of just the last task group.  The following is the
revised patch and changelog.

-----
sched: fixed erroneous all_pinned logic.

The scheduler load balancer has specific code to deal with cases of
unbalanced system due to lots of unmovable tasks (for example because
of hard CPU affinity). In those situation, it exclude the busiest CPU
that has pinned tasks for load balance consideration such that it can
perform second 2nd load balance pass on the rest of the system.  This
all works as designed if there is only one cgroup in the system.

However, when we have multiple cgroups, this logic has false positive
and triggers multiple load balance passes despite there are actually
no pinned tasks at all.

The reason it has false positive is that the all pinned logic is deep
in the lowest function of can_migrate_task() and is too low level.
load_balance_fair() iterate each task group and calls balance_tasks()
to migrate target load.  Along the way, balance_tasks() will also set
a all_pinned variable.  Given that task-groups are iterated, this
all_pinned variable is essentially the status of last group in the
scanning process.  Task group can have number of reasons that no load
being migrated, none due to cpu affinity.  However, this status bit
is being propagated back up to the higher level load_balance(), which
incorrectly think that no tasks were moved.  It kick off the all pinned
logic and start multiple passes attempt to move load onto puller CPU.

Moved the all_pinned aggregation up at the iterator level. This ensures
that the status is aggregated over all task-groups, not just last one
in the list.

Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c46568a..bb7dba7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2104,21 +2104,20 @@ balance_tasks(
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
