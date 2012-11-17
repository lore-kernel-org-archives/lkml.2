Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab2KQNF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 08:05:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:42654 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab2KQNFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 08:05:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,270,1352102400"; 
   d="scan'208";a="219067114"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, pjt@google.com,
        preeti@linux.vnet.ibm.com, vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/5] sched: consider runnable load average in wake_affine and move_tasks
Date: Sat, 17 Nov 2012 21:04:16 +0800
Message-Id: <1353157457-3649-5-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353157457-3649-1-git-send-email-alex.shi@intel.com>
References: <1353157457-3649-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Except using runnable load average in background, wake_affine and
move_tasks is also the key functions in load balance. We need consider
the runnable load average in them in order to the apple to apple load
comparison in load balance.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f918919..7064a13 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3164,8 +3164,10 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 		tg = task_group(current);
 		weight = current->se.load.weight;
 
-		this_load += effective_load(tg, this_cpu, -weight, -weight);
-		load += effective_load(tg, prev_cpu, 0, -weight);
+		this_load += effective_load(tg, this_cpu, -weight, -weight)
+				* cpu_rq(this_cpu)->avg.load_avg_contrib;
+		load += effective_load(tg, prev_cpu, 0, -weight)
+				* cpu_rq(prev_cpu)->avg.load_avg_contrib;
 	}
 
 	tg = task_group(p);
@@ -3185,12 +3187,14 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 		this_eff_load = 100;
 		this_eff_load *= power_of(prev_cpu);
-		this_eff_load *= this_load +
-			effective_load(tg, this_cpu, weight, weight);
+		this_eff_load *= (this_load +
+			effective_load(tg, this_cpu, weight, weight))
+				* cpu_rq(this_cpu)->avg.load_avg_contrib;
 
 		prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
 		prev_eff_load *= power_of(this_cpu);
-		prev_eff_load *= load + effective_load(tg, prev_cpu, 0, weight);
+		prev_eff_load *= (load + effective_load(tg, prev_cpu, 0, weight))
+				* cpu_rq(prev_cpu)->avg.load_avg_contrib;
 
 		balanced = this_eff_load <= prev_eff_load;
 	} else
@@ -4229,7 +4233,7 @@ static int move_tasks(struct lb_env *env)
 		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
 			goto next;
 
-		load = task_h_load(p);
+		load = task_h_load(p) * p->se.avg.load_avg_contrib;
 
 		if (sched_feat(LB_MIN) && load < 16 && !env->failed)
 			goto next;
-- 
1.7.5.4

