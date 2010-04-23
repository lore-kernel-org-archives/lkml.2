Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab0DWKuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:50:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:40702 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757149Ab0DWKuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:50:37 -0400
Date: Fri, 23 Apr 2010 10:50:16 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
       davem@davemloft.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, davem@davemloft.net,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Pre-compute cpumask_weight(sched_domain_span(sd))
Message-ID: <tip-669c55e9f99b90e46eaa0f98a67ec53d46dc969a@git.kernel.org>
Git-Commit-ID: 669c55e9f99b90e46eaa0f98a67ec53d46dc969a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Apr 2010 10:50:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  669c55e9f99b90e46eaa0f98a67ec53d46dc969a
Gitweb:     http://git.kernel.org/tip/669c55e9f99b90e46eaa0f98a67ec53d46dc969a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 16 Apr 2010 14:59:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Apr 2010 11:02:02 +0200

sched: Pre-compute cpumask_weight(sched_domain_span(sd))

Dave reported that his large SPARC machines spend lots of time in
hweight64(), try and optimize some of those needless cpumask_weight()
invocations (esp. with the large offstack cpumasks these are very
expensive indeed).

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |    3 +++
 kernel/sched_fair.c   |   12 +++++-------
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e3e900f..dfea405 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -960,6 +960,7 @@ struct sched_domain {
 	char *name;
 #endif
 
+	unsigned int span_weight;
 	/*
 	 * Span of all CPUs in this domain.
 	 *
diff --git a/kernel/sched.c b/kernel/sched.c
index 0cc913a..4956ed0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6271,6 +6271,9 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	struct sched_domain *tmp;
 
+	for (tmp = sd; tmp; tmp = tmp->parent)
+		tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
+
 	/* Remove the sched domains which do not contribute to scheduling. */
 	for (tmp = sd; tmp; ) {
 		struct sched_domain *parent = tmp->parent;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 88d3053..0a413c7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1508,9 +1508,7 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 		 * Pick the largest domain to update shares over
 		 */
 		tmp = sd;
-		if (affine_sd && (!tmp ||
-				  cpumask_weight(sched_domain_span(affine_sd)) >
-				  cpumask_weight(sched_domain_span(sd))))
+		if (affine_sd && (!tmp || affine_sd->span_weight > sd->span_weight))
 			tmp = affine_sd;
 
 		if (tmp) {
@@ -1554,10 +1552,10 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 
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
@@ -2243,7 +2241,7 @@ unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
 
 unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
 {
-	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long weight = sd->span_weight;
 	unsigned long smt_gain = sd->smt_gain;
 
 	smt_gain /= weight;
@@ -2276,7 +2274,7 @@ unsigned long scale_rt_power(int cpu)
 
 static void update_cpu_power(struct sched_domain *sd, int cpu)
 {
-	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long weight = sd->span_weight;
 	unsigned long power = SCHED_LOAD_SCALE;
 	struct sched_group *sdg = sd->groups;
 
