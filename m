Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2GaTqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 15:46:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37348 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab2GaTop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 15:44:45 -0400
Message-Id: <20120731192809.186113955@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 31 Jul 2012 21:12:18 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, riel@redhat.com, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 14/19] sched: Make find_busiest_queue() a method
References: <20120731191204.540691987@chello.nl>
Content-Disposition: inline; filename=sched-Make_find_busiest_queue_a_method.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its a bit awkward but it was the least painful means of modifying the
queue selection. Used in a later patch to conditionally use a random
queue.

Cc: Paul Turner <pjt@google.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/fair.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 22321db..9c4164e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3074,6 +3074,10 @@ struct lb_env {
 	unsigned int		loop;
 	unsigned int		loop_break;
 	unsigned int		loop_max;
+
+	struct rq *		(*find_busiest_queue)(struct lb_env *,
+						      struct sched_group *,
+						      const struct cpumask *);
 };
 
 /*
@@ -4246,12 +4250,13 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
 	struct lb_env env = {
-		.sd		= sd,
-		.dst_cpu	= this_cpu,
-		.dst_rq		= this_rq,
-		.dst_grpmask    = sched_group_cpus(sd->groups),
-		.idle		= idle,
-		.loop_break	= sched_nr_migrate_break,
+		.sd		    = sd,
+		.dst_cpu	    = this_cpu,
+		.dst_rq		    = this_rq,
+		.dst_grpmask	    = sched_group_cpus(sd->groups),
+		.idle		    = idle,
+		.loop_break	    = sched_nr_migrate_break,
+		.find_busiest_queue = find_busiest_queue,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
@@ -4270,7 +4275,7 @@ redo:
 		goto out_balanced;
 	}
 
-	busiest = find_busiest_queue(&env, group, cpus);
+	busiest = env.find_busiest_queue(&env, group, cpus);
 	if (!busiest) {
 		schedstat_inc(sd, lb_nobusyq[idle]);
 		goto out_balanced;
-- 
1.7.2.3



