Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2LJI04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:26:56 -0500
Received: from mga14.intel.com ([143.182.124.37]:14834 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab2LJI0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:26:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,250,1355126400"; 
   d="scan'208";a="178808809"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, mingo@redhat.com, peterz@infradead.org
Cc: gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: [PATCH 18/18] sched: lazy powersaving balance
Date: Mon, 10 Dec 2012 16:22:34 +0800
Message-Id: <1355127754-8444-19-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When active task number in sched domain wave around the powersaving
scheduling creteria, scheduling will thresh between the powersaving
balance and performance balance, bring unnecessary task migration.
The typical benchmark generate the issue is 'make -j x'.

To remove such issue, introduce a u64 perf_lb_record variable to record
performance load balance history. If there is no performance LB for
continuing 32 times load balancing, or no LB for 8 times max_interval ms,
or only 4 times performance LB in last 64 times load balancing, then we
accept a powersaving LB. Otherwise, give up this power awareness
LB chance.

With this patch, the worst case for power scheduling -- kbuild, gets
similar even better performance/power value between balance and
performance policy, while powersaving is worse.

So, maybe we'd better to use 'balance' policy in general scenarios.

On my SNB EP 2 sockets machine with 8 cores * HT: 'make -j x' results:

		powersaving		balance		performance
x = 1    175.603 /417 13          175.220 /416 13        176.073 /407 13
x = 2    186.026 /246 21          190.182 /208 25        200.873 /210 23
x = 4    198.883 /145 34          204.856 /120 40        218.843 /116 39
x = 6    208.458 /106 45          214.981 /93 50         233.561 /86 49
x = 8    218.304 /86 53           223.527 /76 58         233.008 /75 57
x = 12   231.829 /71 60           268.98  /55 67         247.013 /60 67
x = 16   262.112 /53 71           267.898 /50 74         344.589 /41 70
x = 32   306.969 /36 90           310.774 /37 86         313.359 /38 83

data explains: 175.603 /417 13
	175.603: avagerage Watts
	417: seconds(compile time)
	13:  scaled performance/power = 1000000 / time / power

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched.h |    1 +
 kernel/sched/fair.c   |   66 ++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 62dbc74..b2837d5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -930,6 +930,7 @@ struct sched_domain {
 	unsigned long last_balance;	/* init to jiffies. units in jiffies */
 	unsigned int balance_interval;	/* initialise to 1. units in ms. */
 	unsigned int nr_balance_failed; /* initialise to 0 */
+	u64	perf_lb_record;	/* performance balance record */
 
 	u64 last_update;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e2ba22f..1cee892 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4231,6 +4231,58 @@ static inline void update_sd_lb_power_stats(struct lb_env *env,
 	}
 }
 
+#define PERF_LB_HH_MASK		0xffffffff00000000ULL
+#define PERF_LB_LH_MASK		0xffffffffULL
+
+/**
+ * need_perf_balance - Check if the performance load balance needed
+ * in the sched_domain.
+ *
+ * @env: The load balancing environment.
+ * @sds: Variable containing the statistics of the sched_domain
+ */
+static int need_perf_balance(struct lb_env *env, struct sd_lb_stats *sds)
+{
+	env->sd->perf_lb_record <<= 1;
+
+	if (env->perf_lb) {
+		env->sd->perf_lb_record |= 0x1;
+		return 1;
+	}
+
+	/*
+	 * The situtatoin isn't egligible for performance balance. If this_cpu
+	 * is not egligible or the timing is not suitable for lazy powersaving
+	 * balance, we will stop both powersaving and performance balance.
+	 */
+	if (env->power_lb && sds->this == sds->group_leader
+			&& sds->group_leader != sds->group_min) {
+		int interval;
+
+		/* powersaving balance interval set as 8 * max_interval */
+		interval = msecs_to_jiffies(8 * env->sd->max_interval);
+		if (time_after(jiffies, env->sd->last_balance + interval))
+			env->sd->perf_lb_record = 0;
+
+		/*
+		 * A eligible timing is no performance balance in last 32
+		 * balance and performance balance is no more than 4 times
+		 * in last 64 balance, or no balance in powersaving interval
+		 * time.
+		 */
+		if ((hweight64(env->sd->perf_lb_record & PERF_LB_HH_MASK ) <= 4)
+			&& !(env->sd->perf_lb_record & PERF_LB_LH_MASK)) {
+
+			env->imbalance = sds->min_load_per_task;
+			return 0;
+		}
+
+	}
+	env->power_lb = 0;
+	sds->group_min = NULL;
+	return 0;
+}
+
 /**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
@@ -4817,7 +4869,6 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 }
 
 /******* find_busiest_group() helpers end here *********************/
-
 /**
  * find_busiest_group - Returns the busiest group within the sched_domain
  * if there is an imbalance. If there isn't an imbalance, and
@@ -4850,17 +4901,8 @@ find_busiest_group(struct lb_env *env, int *balance)
 	 */
 	update_sd_lb_stats(env, balance, &sds);
 
-	if (!env->perf_lb && !env->power_lb)
-		return  NULL;
-
-	if (env->power_lb) {
-		if (sds.this == sds.group_leader &&
-				sds.group_leader != sds.group_min) {
-			env->imbalance = sds.min_load_per_task;
-			return sds.group_min;
-		}
-		env->power_lb = 0;
-		return NULL;
+	if (!need_perf_balance(env, &sds)) {
+		return sds.group_min;
 	}
 
 	/*
-- 
1.7.5.1

