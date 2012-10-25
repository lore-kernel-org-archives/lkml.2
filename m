Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab2JYK1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:27:52 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:60142 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965531Ab2JYK0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:26:52 -0400
Subject: [RFC PATCH 07/13] sched: Change move_tasks to use PJT's metric
To: svaidy@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: mingo@kernel.org, venki@google.com, robin.randhawa@arm.com,
        linaro-dev@lists.linaro.org, a.p.zijlstra@chello.nl,
        mjg59@srcf.ucam.org, viresh.kumar@linaro.org,
        akpm@linux-foundation.org, amit.kucheria@linaro.org,
        deepthi@linux.vnet.ibm.com, paul.mckenney@linaro.org,
        arjan@linux.intel.com, paulmck@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        tglx@linutronix.de, Arvind.Chauhan@arm.com, pjt@google.com,
        Morten.Rasmussen@arm.com, linux-arm-kernel@lists.infradead.org,
        suresh.b.siddha@intel.com
Date: Thu, 25 Oct 2012 15:55:43 +0530
Message-ID: <20121025102543.21022.97196.stgit@preeti.in.ibm.com>
In-Reply-To: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
References: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12102510-8878-0000-0000-0000048204C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make decisions based on PJT's metrics and the dependent metrics
about which tasks to move to reduce the imbalance.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bb1c71b..bd7b69d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3957,7 +3957,7 @@ static int move_tasks(struct lb_env *env)
 	unsigned long load;
 	int pulled = 0;
 
-	if (env->imbalance <= 0)
+	if (env->load_imbalance <= 0)
 		return 0;
 
 again:
@@ -3984,7 +3984,8 @@ again:
 		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
 			goto next;
 
-		if ((load / 2) > env->imbalance)
+		/* The below being changed to use the PJT's metric */
+		if ((load / 2) > env->load_imbalance)
 			goto next;
 
 		if (!can_migrate_task(p, env))
@@ -3992,7 +3993,8 @@ again:
 
 		move_task(p, env);
 		pulled++;
-		env->imbalance -= load;
+		/* Using PJT's metric */
+		env->load_imbalance -= load;
 
 #ifdef CONFIG_PREEMPT
 		/*
@@ -4007,8 +4009,9 @@ again:
 		/*
 		 * We only want to steal up to the prescribed amount of
 		 * weighted load.
+		 * But the below modification is to use PJT's metric
 		 */
-		if (env->imbalance <= 0)
+		if (env->load_imbalance <= 0)
 			goto out;
 
 		continue;
@@ -4145,7 +4148,8 @@ static inline void update_h_load(long cpu)
 
 static unsigned long task_h_load(struct task_struct *p)
 {
-	return p->se.load.weight;
+	/* The below is changed to use PJT's metric*/
+	return p->se.avg.load_avg_contrib;
 }
 #endif
 

