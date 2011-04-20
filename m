Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1DTUwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:52:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7870 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab1DTUwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:52:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=p9DoGobSgUNzNBybRKwFP5awN2eluweCsP/pAyHD8ltZW0CikWjvjoeWGhLiDUhEK
	CTLHEKqy9AWU58QgAkmBQ==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 13/18] sched: update f_b_g() to use u64 for weights
Date: Wed, 20 Apr 2011 13:51:32 -0700
Message-Id: <1303332697-16426-14-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates f_b_g() and helper functions to use u64 to handle the
increased sched load resolution.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched_fair.c |   51 +++++++++++++++++++++++++++------------------------
 1 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 12b25b7..8478aac 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2946,12 +2946,13 @@ static int check_asym_packing(struct sched_domain *sd,
 static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 				int this_cpu, unsigned long *imbalance)
 {
-	unsigned long tmp, pwr_now = 0, pwr_move = 0;
+	u64 tmp, pwr_now = 0, pwr_move = 0;
 	unsigned int imbn = 2;
 	unsigned long scaled_busy_load_per_task;
 
 	if (sds->this_nr_running) {
-		sds->this_load_per_task /= sds->this_nr_running;
+		sds->this_load_per_task = div_u64(sds->this_load_per_task,
+						  sds->this_nr_running);
 		if (sds->busiest_load_per_task >
 				sds->this_load_per_task)
 			imbn = 1;
@@ -2959,9 +2960,9 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 		sds->this_load_per_task =
 			cpu_avg_load_per_task(this_cpu);
 
-	scaled_busy_load_per_task = sds->busiest_load_per_task
-					 * SCHED_POWER_SCALE;
-	scaled_busy_load_per_task /= sds->busiest->cpu_power;
+	scaled_busy_load_per_task =
+		div_u64(sds->busiest_load_per_task * SCHED_POWER_SCALE,
+			sds->busiest->cpu_power);
 
 	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
 			(scaled_busy_load_per_task * imbn)) {
@@ -2979,11 +2980,11 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 			min(sds->busiest_load_per_task, sds->max_load);
 	pwr_now += sds->this->cpu_power *
 			min(sds->this_load_per_task, sds->this_load);
-	pwr_now /= SCHED_POWER_SCALE;
+	pwr_now = div_u64(pwr_now, SCHED_POWER_SCALE);
 
 	/* Amount of load we'd subtract */
-	tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
-		sds->busiest->cpu_power;
+	tmp = div_u64(sds->busiest_load_per_task * SCHED_POWER_SCALE,
+		      sds->busiest->cpu_power);
 	if (sds->max_load > tmp)
 		pwr_move += sds->busiest->cpu_power *
 			min(sds->busiest_load_per_task, sds->max_load - tmp);
@@ -2991,14 +2992,15 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 	/* Amount of load we'd add */
 	if (sds->max_load * sds->busiest->cpu_power <
 		sds->busiest_load_per_task * SCHED_POWER_SCALE)
-		tmp = (sds->max_load * sds->busiest->cpu_power) /
-			sds->this->cpu_power;
+		tmp = div_u64(sds->max_load * sds->busiest->cpu_power,
+			      sds->this->cpu_power);
 	else
-		tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
-			sds->this->cpu_power;
+		tmp = div_u64(sds->busiest_load_per_task * SCHED_POWER_SCALE,
+			      sds->this->cpu_power);
+
 	pwr_move += sds->this->cpu_power *
 			min(sds->this_load_per_task, sds->this_load + tmp);
-	pwr_move /= SCHED_POWER_SCALE;
+	pwr_move = div_u64(pwr_move, SCHED_POWER_SCALE);
 
 	/* Move if we gain throughput */
 	if (pwr_move > pwr_now)
@@ -3015,9 +3017,10 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 		unsigned long *imbalance)
 {
-	unsigned long max_pull, load_above_capacity = ~0UL;
+	u64 max_pull, load_above_capacity = ~0ULL;
 
-	sds->busiest_load_per_task /= sds->busiest_nr_running;
+	sds->busiest_load_per_task = div_u64(sds->busiest_load_per_task,
+					     sds->busiest_nr_running);
 	if (sds->group_imb) {
 		sds->busiest_load_per_task =
 			min(sds->busiest_load_per_task, sds->avg_load);
@@ -3034,15 +3037,15 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 	}
 
 	if (!sds->group_imb) {
+		unsigned long imb_capacity = (sds->busiest_nr_running -
+					      sds->busiest_group_capacity);
 		/*
 		 * Don't want to pull so many tasks that a group would go idle.
 		 */
-		load_above_capacity = (sds->busiest_nr_running -
-						sds->busiest_group_capacity);
-
-		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
-
-		load_above_capacity /= sds->busiest->cpu_power;
+		load_above_capacity = NICE_0_LOAD * imb_capacity;
+		load_above_capacity =
+			div_u64(load_above_capacity * SCHED_POWER_SCALE,
+				sds->busiest->cpu_power);
 	}
 
 	/*
@@ -3059,8 +3062,8 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 
 	/* How much load to actually move to equalise the imbalance */
 	*imbalance = min(max_pull * sds->busiest->cpu_power,
-		(sds->avg_load - sds->this_load) * sds->this->cpu_power)
-			/ SCHED_POWER_SCALE;
+			(sds->avg_load - sds->this_load)*sds->this->cpu_power);
+	*imbalance = div_u64(*imbalance, SCHED_POWER_SCALE);
 
 	/*
 	 * if *imbalance is less than the average load per runnable task
@@ -3129,7 +3132,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
-	sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;
+	sds.avg_load = div_u64(sds.total_load*SCHED_POWER_SCALE, sds.total_pwr);
 
 	/*
 	 * If the busiest group is imbalanced the below checks don't
-- 
1.7.3.1

