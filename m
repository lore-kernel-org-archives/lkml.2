Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab2JYNJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:09:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:51601 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759487Ab2JYNJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:09:56 -0400
Message-Id: <20121025124832.545895263@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 25 Oct 2012 14:16:18 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 01/31] sched, numa, mm: Make find_busiest_queue() a method
References: <20121025121617.617683848@chello.nl>
Content-Disposition: inline; filename=0001-sched-numa-mm-Make-find_busiest_queue-a-method.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its a bit awkward but it was the least painful means of modifying the
queue selection. Used in a later patch to conditionally use a random
queue.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

Index: tip/kernel/sched/fair.c
===================================================================
--- tip.orig/kernel/sched/fair.c
+++ tip/kernel/sched/fair.c
@@ -3063,6 +3063,9 @@ struct lb_env {
 	unsigned int		loop;
 	unsigned int		loop_break;
 	unsigned int		loop_max;
+
+	struct rq *		(*find_busiest_queue)(struct lb_env *,
+						      struct sched_group *);
 };
 
 /*
@@ -4236,13 +4239,14 @@ static int load_balance(int this_cpu, st
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
 	struct lb_env env = {
-		.sd		= sd,
-		.dst_cpu	= this_cpu,
-		.dst_rq		= this_rq,
-		.dst_grpmask    = sched_group_cpus(sd->groups),
-		.idle		= idle,
-		.loop_break	= sched_nr_migrate_break,
-		.cpus		= cpus,
+		.sd		    = sd,
+		.dst_cpu	    = this_cpu,
+		.dst_rq		    = this_rq,
+		.dst_grpmask        = sched_group_cpus(sd->groups),
+		.idle		    = idle,
+		.loop_break	    = sched_nr_migrate_break,
+		.cpus		    = cpus,
+		.find_busiest_queue = find_busiest_queue,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
@@ -4261,7 +4265,7 @@ redo:
 		goto out_balanced;
 	}
 
-	busiest = find_busiest_queue(&env, group);
+	busiest = env.find_busiest_queue(&env, group);
 	if (!busiest) {
 		schedstat_inc(sd, lb_nobusyq[idle]);
 		goto out_balanced;


