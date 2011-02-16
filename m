Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783Ab1BPB5C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:57:02 -0500
Received: from kroah.org ([198.145.64.141]:49247 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758579Ab1BPBvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:51:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:03 2011
Message-Id: <20110216014703.742949985@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:46:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nikhil Rao <ncrao@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
Subject: [095/115] sched: Set group_imb only a task can be pulled from the busiest cpu
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

Commit: 2582f0eba54066b5e98ff2b27ef0cfa833b59f54 upstream

When cycling through sched groups to determine the busiest group, set
group_imb only if the busiest cpu has more than 1 runnable task. This patch
fixes the case where two cpus in a group have one runnable task each, but there
is a large weight differential between these two tasks. The load balancer is
unable to migrate any task from this group, and hence do not consider this
group to be imbalanced.

Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1286996978-7007-3-git-send-email-ncrao@google.com>
[ small code readability edits ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3745,7 +3745,7 @@ static inline void update_sg_lb_stats(st
 			int local_group, const struct cpumask *cpus,
 			int *balance, struct sg_lb_stats *sgs)
 {
-	unsigned long load, max_cpu_load, min_cpu_load;
+	unsigned long load, max_cpu_load, min_cpu_load, max_nr_running;
 	int i;
 	unsigned int balance_cpu = -1, first_idle_cpu = 0;
 	unsigned long avg_load_per_task = 0;
@@ -3759,6 +3759,7 @@ static inline void update_sg_lb_stats(st
 	/* Tally up the load of all CPUs in the group */
 	max_cpu_load = 0;
 	min_cpu_load = ~0UL;
+	max_nr_running = 0;
 
 	for_each_cpu_and(i, sched_group_cpus(group), cpus) {
 		struct rq *rq = cpu_rq(i);
@@ -3776,8 +3777,10 @@ static inline void update_sg_lb_stats(st
 			load = target_load(i, load_idx);
 		} else {
 			load = source_load(i, load_idx);
-			if (load > max_cpu_load)
+			if (load > max_cpu_load) {
 				max_cpu_load = load;
+				max_nr_running = rq->nr_running;
+			}
 			if (min_cpu_load > load)
 				min_cpu_load = load;
 		}
@@ -3815,11 +3818,10 @@ static inline void update_sg_lb_stats(st
 	if (sgs->sum_nr_running)
 		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
-	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
+	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task && max_nr_running > 1)
 		sgs->group_imb = 1;
 
-	sgs->group_capacity =
-		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
+	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
 }
 
 /**


