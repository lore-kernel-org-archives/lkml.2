Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab1DTUwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:52:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47444 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab1DTUwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:52:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=lTRGdl4I1AlUMVGfWIjJkfV+3MEhV2dkhq+zeISDlxWk4DLC9Xnw3scwIo9jQ+zbg
	MCU6BezHEE/dltFcHaBqg==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 11/18] sched: update update_sg_lb_stats() to use u64
Date: Wed, 20 Apr 2011 13:51:30 -0700
Message-Id: <1303332697-16426-12-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update variable types and 64-bit math in update_sg_lb_stats() to handle u64
weights.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched_fair.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 2b030f4..d5b1276 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2345,14 +2345,14 @@ struct sd_lb_stats {
  * sg_lb_stats - stats of a sched_group required for load_balancing
  */
 struct sg_lb_stats {
-	unsigned long avg_load; /*Avg load across the CPUs of the group */
-	unsigned long group_load; /* Total load over the CPUs of the group */
+	u64 avg_load;		/* Avg load across the CPUs of the group */
+	u64 group_load;		/* Total load over the CPUs of the group */
 	unsigned long sum_nr_running; /* Nr tasks running in the group */
-	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
+	u64 sum_weighted_load;	/* Weighted load of group's tasks */
 	unsigned long group_capacity;
 	unsigned long idle_cpus;
 	unsigned long group_weight;
-	int group_imb; /* Is there an imbalance in the group ? */
+	int group_imb;		/* Is there an imbalance in the group ? */
 	int group_has_capacity; /* Is there extra capacity in the group? */
 };
 
@@ -2679,7 +2679,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 			int local_group, const struct cpumask *cpus,
 			int *balance, struct sg_lb_stats *sgs)
 {
-	unsigned long load, max_cpu_load, min_cpu_load, max_nr_running;
+	u64 load, max_cpu_load, min_cpu_load;
+	unsigned long max_nr_running;
 	int i;
 	unsigned int balance_cpu = -1, first_idle_cpu = 0;
 	unsigned long avg_load_per_task = 0;
@@ -2689,7 +2690,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 
 	/* Tally up the load of all CPUs in the group */
 	max_cpu_load = 0;
-	min_cpu_load = ~0UL;
+	min_cpu_load = ~0ULL;
 	max_nr_running = 0;
 
 	for_each_cpu_and(i, sched_group_cpus(group), cpus) {
@@ -2735,7 +2736,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	}
 
 	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->cpu_power;
+	sgs->avg_load = div_u64(sgs->group_load * SCHED_POWER_SCALE,
+				group->cpu_power);
 
 	/*
 	 * Consider the group unbalanced when the imbalance is larger
@@ -2747,9 +2749,11 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	 *      the hierarchy?
 	 */
 	if (sgs->sum_nr_running)
-		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
+		avg_load_per_task = div_u64(sgs->sum_weighted_load,
+					    sgs->sum_nr_running);
 
-	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task && max_nr_running > 1)
+	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task &&
+			max_nr_running > 1)
 		sgs->group_imb = 1;
 
 	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power,
-- 
1.7.3.1

