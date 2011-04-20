Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab1DTUwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:52:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7862 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab1DTUwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:52:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=MXYIREV24rsdvvl+m9CKJ120hNvgirQSx5frKDGRViffZCijsr+ZgI8vqE1wC5OYV
	zqSxdEYYiuQjY+aEWRIZQ==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 14/18] sched: change type of imbalance to be u64
Date: Wed, 20 Apr 2011 13:51:33 -0700
Message-Id: <1303332697-16426-15-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the type of imbalance to be u64. With increased sched load
resolution, it is possible for a runqueue to have a sched weight of 2^32, and
imbalance needs to be updated to u64 to handle this case.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 include/linux/sched.h |    2 +-
 kernel/sched_fair.c   |   24 ++++++++++++------------
 kernel/sched_stats.h  |    2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 546a418..2d9689a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -945,10 +945,10 @@ struct sched_domain {
 
 #ifdef CONFIG_SCHEDSTATS
 	/* load_balance() stats */
+	u64 lb_imbalance[CPU_MAX_IDLE_TYPES];
 	unsigned int lb_count[CPU_MAX_IDLE_TYPES];
 	unsigned int lb_failed[CPU_MAX_IDLE_TYPES];
 	unsigned int lb_balanced[CPU_MAX_IDLE_TYPES];
-	unsigned int lb_imbalance[CPU_MAX_IDLE_TYPES];
 	unsigned int lb_gained[CPU_MAX_IDLE_TYPES];
 	unsigned int lb_hot_gained[CPU_MAX_IDLE_TYPES];
 	unsigned int lb_nobusyg[CPU_MAX_IDLE_TYPES];
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8478aac..ab2d1c9 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2497,7 +2497,7 @@ static inline void update_sd_power_savings_stats(struct sched_group *group,
  * Else returns 0.
  */
 static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
-					int this_cpu, unsigned long *imbalance)
+					int this_cpu, u64 *imbalance)
 {
 	if (!sds->power_savings_balance)
 		return 0;
@@ -2526,7 +2526,7 @@ static inline void update_sd_power_savings_stats(struct sched_group *group,
 }
 
 static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
-					int this_cpu, unsigned long *imbalance)
+					int this_cpu, u64 *imbalance)
 {
 	return 0;
 }
@@ -2916,7 +2916,7 @@ int __weak arch_sd_sibling_asym_packing(void)
  */
 static int check_asym_packing(struct sched_domain *sd,
 			      struct sd_lb_stats *sds,
-			      int this_cpu, unsigned long *imbalance)
+			      int this_cpu, u64 *imbalance)
 {
 	int busiest_cpu;
 
@@ -2943,8 +2943,8 @@ static int check_asym_packing(struct sched_domain *sd,
  * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
  * @imbalance: Variable to store the imbalance.
  */
-static inline void fix_small_imbalance(struct sd_lb_stats *sds,
-				int this_cpu, unsigned long *imbalance)
+static inline
+void fix_small_imbalance(struct sd_lb_stats *sds, int this_cpu, u64 *imbalance)
 {
 	u64 tmp, pwr_now = 0, pwr_move = 0;
 	unsigned int imbn = 2;
@@ -3014,8 +3014,8 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
  * @this_cpu: Cpu for which currently load balance is being performed.
  * @imbalance: The variable to store the imbalance.
  */
-static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
-		unsigned long *imbalance)
+static inline
+void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu, u64 *imbalance)
 {
 	u64 max_pull, load_above_capacity = ~0ULL;
 
@@ -3103,9 +3103,9 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
  *		   put to idle by rebalancing its tasks onto our group.
  */
 static struct sched_group *
-find_busiest_group(struct sched_domain *sd, int this_cpu,
-		   unsigned long *imbalance, enum cpu_idle_type idle,
-		   const struct cpumask *cpus, int *balance)
+find_busiest_group(struct sched_domain *sd, int this_cpu, u64 *imbalance,
+		   enum cpu_idle_type idle, const struct cpumask *cpus,
+		   int *balance)
 {
 	struct sd_lb_stats sds;
 
@@ -3202,7 +3202,7 @@ ret:
  */
 static struct rq *
 find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
-		   enum cpu_idle_type idle, unsigned long imbalance,
+		   enum cpu_idle_type idle, u64 imbalance,
 		   const struct cpumask *cpus)
 {
 	struct rq *busiest = NULL, *rq;
@@ -3308,7 +3308,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 {
 	int ld_moved, all_pinned = 0, active_balance = 0;
 	struct sched_group *group;
-	unsigned long imbalance;
+	u64 imbalance;
 	struct rq *busiest;
 	unsigned long flags;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 48ddf43..f44676c 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -46,7 +46,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
 			seq_printf(seq, "domain%d %s", dcount++, mask_str);
 			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
 					itype++) {
-				seq_printf(seq, " %u %u %u %u %u %u %u %u",
+				seq_printf(seq, " %u %u %u %llu %u %u %u %u",
 				    sd->lb_count[itype],
 				    sd->lb_balanced[itype],
 				    sd->lb_failed[itype],
-- 
1.7.3.1

