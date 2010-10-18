Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab0JRTYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:24:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:35229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab0JRTYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:24:39 -0400
Date: Mon, 18 Oct 2010 19:24:13 GMT
From: tip-bot for Nikhil Rao <ncrao@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, ncrao@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ncrao@google.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1287173550-30365-5-git-send-email-ncrao@google.com>
References: <1287173550-30365-5-git-send-email-ncrao@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Drop group_capacity to 1 only if local group has extra capacity
Message-ID: <tip-75dd321d79d495a0ee579e6249ebc38ddbb2667f@git.kernel.org>
Git-Commit-ID: 75dd321d79d495a0ee579e6249ebc38ddbb2667f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:24:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75dd321d79d495a0ee579e6249ebc38ddbb2667f
Gitweb:     http://git.kernel.org/tip/75dd321d79d495a0ee579e6249ebc38ddbb2667f
Author:     Nikhil Rao <ncrao@google.com>
AuthorDate: Fri, 15 Oct 2010 13:12:30 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 20:52:19 +0200

sched: Drop group_capacity to 1 only if local group has extra capacity

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
---
 kernel/sched_fair.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 032b548..f1c615f 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2554,9 +2554,14 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
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
