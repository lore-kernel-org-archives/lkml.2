Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab1BJMY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:24:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:33735 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287Ab1BJMYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:24:55 -0500
From: stable-bot-for Nikhil Rao <ncrao@google.com>
Date: Thu, 10 Feb 2011 10:23:25 +0100
Subject: [PATCH 10/28] sched: Set group_imb only a task can be pulled from
 the busiest cpu
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340643.5512.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: 2582f0eba54066b5e98ff2b27ef0cfa833b59f54 upstream
Author: Nikhil Rao <ncrao@google.com>
AuthorDate: Wed Oct 13 12:09:36 2010 -0700

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
---
 kernel/sched.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0a1fb24..d985956 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3745,7 +3745,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 			int local_group, const struct cpumask *cpus,
 			int *balance, struct sg_lb_stats *sgs)
 {
-	unsigned long load, max_cpu_load, min_cpu_load;
+	unsigned long load, max_cpu_load, min_cpu_load, max_nr_running;
 	int i;
 	unsigned int balance_cpu = -1, first_idle_cpu = 0;
 	unsigned long avg_load_per_task = 0;
@@ -3759,6 +3759,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	/* Tally up the load of all CPUs in the group */
 	max_cpu_load = 0;
 	min_cpu_load = ~0UL;
+	max_nr_running = 0;
 
 	for_each_cpu_and(i, sched_group_cpus(group), cpus) {
 		struct rq *rq = cpu_rq(i);
@@ -3776,8 +3777,10 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
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
@@ -3815,11 +3818,10 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
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
-- 
1.7.4


