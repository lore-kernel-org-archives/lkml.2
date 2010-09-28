Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334Ab0I1AaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:30:22 -0400
Received: from smtp-out.google.com ([74.125.121.35]:63252 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760181Ab0I1AaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:30:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=wJaQD4LF49rlKOCC9i92P7zvaVOzMc0z4u6GOwSb/nDHaKvkrBe7R+YMEbknxwB4J
	RSxQGZl2AIXPvvEI8DELA==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH 1/3] sched: set group_imb only a task can be pulled from the busiest cpu
Date: Mon, 27 Sep 2010 17:29:56 -0700
Message-Id: <1285633798-26886-2-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285633798-26886-1-git-send-email-ncrao@google.com>
References: <1285633798-26886-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cycling through sched groups to determine the busiest group, set
group_imb only if the busiest cpu has more than 1 runnable task. This patch
fixes the case where two cpus in a group have one runnable task each, but there
is a large weight differential between these two tasks. The load balancer is
unable to migrate any task from this group, and hence do not consider this
group to be imbalanced.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched_fair.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a171138..de8a6a0 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2378,7 +2378,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 			int local_group, const struct cpumask *cpus,
 			int *balance, struct sg_lb_stats *sgs)
 {
-	unsigned long load, max_cpu_load, min_cpu_load;
+	unsigned long load, max_cpu_load, min_cpu_load, max_nr_running;
 	int i;
 	unsigned int balance_cpu = -1, first_idle_cpu = 0;
 	unsigned long avg_load_per_task = 0;
@@ -2389,6 +2389,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	/* Tally up the load of all CPUs in the group */
 	max_cpu_load = 0;
 	min_cpu_load = ~0UL;
+	max_nr_running = 0;
 
 	for_each_cpu_and(i, sched_group_cpus(group), cpus) {
 		struct rq *rq = cpu_rq(i);
@@ -2406,8 +2407,10 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
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
@@ -2447,7 +2450,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	if (sgs->sum_nr_running)
 		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
-	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
+	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task &&
+			max_nr_running > 1)
 		sgs->group_imb = 1;
 
 	sgs->group_capacity =
-- 
1.7.1

