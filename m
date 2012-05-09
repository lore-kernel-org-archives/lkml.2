Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2EIO1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:27:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40955 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab2EIO1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:27:33 -0400
Date: Wed, 9 May 2012 07:27:21 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-vqh9ai6s0ewmeakjz80w4qz6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Add some serialization to the sched_domain load-balance walk
Git-Commit-ID: 0ce90475dcdbe90affc218e9688c8401e468e84d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:27:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ce90475dcdbe90affc218e9688c8401e468e84d
Gitweb:     http://git.kernel.org/tip/0ce90475dcdbe90affc218e9688c8401e468e84d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 25 Apr 2012 00:30:36 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:00:53 +0200

sched/fair: Add some serialization to the sched_domain load-balance walk

Since the sched_domain walk is completely unserialized (!SD_SERIALIZE)
it is possible that multiple cpus in the group get elected to do the
next level. Avoid this by adding some serialization.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-vqh9ai6s0ewmeakjz80w4qz6@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |    2 ++
 kernel/sched/fair.c   |    9 +++++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4a559bf..3cbfb55 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -927,6 +927,7 @@ struct sched_group_power {
 struct sched_group {
 	struct sched_group *next;	/* Must be a circular list */
 	atomic_t ref;
+	int balance_cpu;
 
 	unsigned int group_weight;
 	struct sched_group_power *sgp;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0533a68..6001e5c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6060,6 +6060,7 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 
 		sg->sgp = *per_cpu_ptr(sdd->sgp, cpumask_first(sg_span));
 		atomic_inc(&sg->sgp->ref);
+		sg->balance_cpu = -1;
 
 		if (cpumask_test_cpu(cpu, sg_span))
 			groups = sg;
@@ -6135,6 +6136,7 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 
 		cpumask_clear(sched_group_cpus(sg));
 		sg->sgp->power = 0;
+		sg->balance_cpu = -1;
 
 		for_each_cpu(j, span) {
 			if (get_group(j, sdd, NULL) != group)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 968ffee..cf86f74 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3828,7 +3828,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	 */
 	if (local_group) {
 		if (idle != CPU_NEWLY_IDLE) {
-			if (balance_cpu != this_cpu) {
+			if (balance_cpu != this_cpu ||
+			    cmpxchg(&group->balance_cpu, -1, balance_cpu) != -1) {
 				*balance = 0;
 				return;
 			}
@@ -4929,7 +4930,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	int balance = 1;
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long interval;
-	struct sched_domain *sd;
+	struct sched_domain *sd, *last = NULL;
 	/* Earliest time when we have to do rebalance again */
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
@@ -4939,6 +4940,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
+		last = sd;
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
@@ -4983,6 +4985,9 @@ out:
 		if (!balance)
 			break;
 	}
+	for (sd = last; sd; sd = sd->child)
+		(void)cmpxchg(&sd->groups->balance_cpu, cpu, -1);
+
 	rcu_read_unlock();
 
 	/*
