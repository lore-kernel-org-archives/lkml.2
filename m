Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab0JOUNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:13:16 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37014 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568Ab0JOUMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:12:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=yRJHkA++JafOrW+hyp/tjZyv2bBCXEqivVk5u+d+QkZzRdVt7Rokvi3ozUAFbn2ks
	PvFlWqu6bTGfPU45E8YoA==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH 4/4] sched: drop group_capacity to 1 only if local group has extra capacity
Date: Fri, 15 Oct 2010 13:12:30 -0700
Message-Id: <1287173550-30365-5-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287173550-30365-1-git-send-email-ncrao@google.com>
References: <1287173550-30365-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/sched_fair.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 7d8ed95..098283a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2556,9 +2556,14 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		/*
 		 * In case the child domain prefers tasks go to siblings
 		 * first, lower the sg capacity to one so that we'll try
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
-- 
1.7.1

