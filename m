Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1ABH6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:58:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:35283 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab1ABHXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:05 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 094/260] sched: Pre-compute cpumask_weight(sched_domain_span(sd))
Date: Sun,  2 Jan 2011 02:16:30 -0500
Message-Id: <1293952756-15010-95-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:53.0227 (UTC) FILETIME=[BABBE1B0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 669c55e9f99b90e46eaa0f98a67ec53d46dc969a upstream.

Dave reported that his large SPARC machines spend lots of time in
hweight64(), try and optimize some of those needless cpumask_weight()
invocations (esp. with the large offstack cpumasks these are very
expensive indeed).

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |    3 +++
 kernel/sched_fair.c   |   12 +++++-------
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f9669..89e0fee 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -954,6 +954,7 @@ struct sched_domain {
 	char *name;
 #endif
 
+	unsigned int span_weight;
 	/*
 	 * Span of all CPUs in this domain.
 	 *
diff --git a/kernel/sched.c b/kernel/sched.c
index 074c4d8..b741de5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6296,6 +6296,9 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	struct sched_domain *tmp;
 
+	for (tmp = sd; tmp; tmp = tmp->parent)
+		tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
+
 	/* Remove the sched domains which do not contribute to scheduling. */
 	for (tmp = sd; tmp; ) {
 		struct sched_domain *parent = tmp->parent;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ae4d842..a29df86 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1542,9 +1542,7 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 		 * Pick the largest domain to update shares over
 		 */
 		tmp = sd;
-		if (affine_sd && (!tmp ||
-				  cpumask_weight(sched_domain_span(affine_sd)) >
-				  cpumask_weight(sched_domain_span(sd))))
+		if (affine_sd && (!tmp || affine_sd->span_weight > sd->span_weight))
 			tmp = affine_sd;
 
 		if (tmp) {
@@ -1588,10 +1586,10 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 
 		/* Now try balancing at a lower domain level of new_cpu */
 		cpu = new_cpu;
-		weight = cpumask_weight(sched_domain_span(sd));
+		weight = sd->span_weight;
 		sd = NULL;
 		for_each_domain(cpu, tmp) {
-			if (weight <= cpumask_weight(sched_domain_span(tmp)))
+			if (weight <= tmp->span_weight)
 				break;
 			if (tmp->flags & sd_flag)
 				sd = tmp;
@@ -2323,7 +2321,7 @@ unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
 
 unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
 {
-	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long weight = sd->span_weight;
 	unsigned long smt_gain = sd->smt_gain;
 
 	smt_gain /= weight;
@@ -2356,7 +2354,7 @@ unsigned long scale_rt_power(int cpu)
 
 static void update_cpu_power(struct sched_domain *sd, int cpu)
 {
-	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long weight = sd->span_weight;
 	unsigned long power = SCHED_LOAD_SCALE;
 	struct sched_group *sdg = sd->groups;
 
-- 
1.7.3.3

