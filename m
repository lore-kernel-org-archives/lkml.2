Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab1BPB4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:56:37 -0500
Received: from kroah.org ([198.145.64.141]:49305 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758582Ab1BPBvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:51:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:04 2011
Message-Id: <20110216014703.957477574@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:46:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nikhil Rao <ncrao@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
Subject: [097/115] sched: Drop group_capacity to 1 only if local group has extra capacity
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

Commit: 75dd321d79d495a0ee579e6249ebc38ddbb2667f upstream

When SD_PREFER_SIBLING is set on a sched domain, drop group_capacity to 1
only if the local group has extra capacity. The extra check prevents the case
where you always pull from the heaviest group when it is already under-utilized
(possible with a large weight task outweighs the tasks on the system).

For example, consider a 16-cpu quad-core quad-socket machine with MC and NUMA
scheduling domains. Let's say we spawn 15 nice0 tasks and one nice-15 task,
and each task is running on one core. In this case, we observe the following
events when balancing at the NUMA domain:

- find_busiest_group() will always pick the sched group containing the niced
  task to be the busiest group.
- find_busiest_queue() will then always pick one of the cpus running the
  nice0 task (never picks the cpu with the nice -15 task since
  weighted_cpuload > imbalance).
- The load balancer fails to migrate the task since it is the running task
  and increments sd->nr_balance_failed.
- It repeats the above steps a few more times until sd->nr_balance_failed > 5,
  at which point it kicks off the active load balancer, wakes up the migration
  thread and kicks the nice 0 task off the cpu.

The load balancer doesn't stop until we kick out all nice 0 tasks from
the sched group, leaving you with 3 idle cpus and one cpu running the
nice -15 task.

When balancing at the NUMA domain, we drop sgs.group_capacity to 1 if the child
domain (in this case MC) has SD_PREFER_SIBLING set.  Subsequent load checks are
not relevant because the niced task has a very large weight.

In this patch, we add an extra condition to the "if(prefer_sibling)" check in
update_sd_lb_stats(). We drop the capacity of a group only if the local group
has extra capacity, ie. nr_running < group_capacity. This patch preserves the
original intent of the prefer_siblings check (to spread tasks across the system
in low utilization scenarios) and fixes the case above.

It helps in the following ways:
- In low utilization cases (where nr_tasks << nr_cpus), we still drop
  group_capacity down to 1 if we prefer siblings.
- On very busy systems (where nr_tasks >> nr_cpus), sgs.nr_running will most
  likely be > sgs.group_capacity.
- When balancing large weight tasks, if the local group does not have extra
  capacity, we do not pick the group with the niced task as the busiest group.
  This prevents failed balances, active migration and the under-utilization
  described above.

Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1287173550-30365-5-git-send-email-ncrao@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3878,9 +3878,14 @@ static inline void update_sd_lb_stats(st
 		/*
 		 * In case the child domain prefers tasks go to siblings
 		 * first, lower the group capacity to one so that we'll try
-		 * and move all the excess tasks away.
+		 * and move all the excess tasks away. We lower the capacity
+		 * of a group only if the local group has the capacity to fit
+		 * these excess tasks, i.e. nr_running < group_capacity. The
+		 * extra check prevents the case where you always pull from the
+		 * heaviest group when it is already under-utilized (possible
+		 * with a large weight task outweighs the tasks on the system).
 		 */
-		if (prefer_sibling)
+		if (prefer_sibling && !local_group && sds->this_has_capacity)
 			sgs.group_capacity = min(sgs.group_capacity, 1UL);
 
 		if (local_group) {


