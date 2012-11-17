Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab2KQNFE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 08:05:04 -0500
Received: from mga03.intel.com ([143.182.124.21]:42654 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab2KQNFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 08:05:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,270,1352102400"; 
   d="scan'208";a="219067104"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, pjt@google.com,
        preeti@linux.vnet.ibm.com, vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/5] sched: using runnable load avg in cpu_load and cpu_avg_load_per_task
Date: Sat, 17 Nov 2012 21:04:15 +0800
Message-Id: <1353157457-3649-4-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353157457-3649-1-git-send-email-alex.shi@intel.com>
References: <1353157457-3649-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are the base values in load balance, update them with rq runnable
load average, then the load balance will consider runnable load avg
naturally.

The base idea of runnable load avg usage is just cosider the runnable
load coefficient in direct load balance process, like load comparison
between cpus.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c |    4 ++--
 kernel/sched/fair.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bacfee0..ee6d765 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2501,7 +2501,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 void update_idle_cpu_load(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-	unsigned long load = this_rq->load.weight;
+	unsigned long load = this_rq->avg.load_avg_contrib;
 	unsigned long pending_updates;
 
 	/*
@@ -2551,7 +2551,7 @@ static void update_cpu_load_active(struct rq *this_rq)
 	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
-	__update_cpu_load(this_rq, this_rq->load.weight, 1);
+	__update_cpu_load(this_rq, this_rq->avg.load_avg_contrib, 1);
 
 	calc_load_account_active(this_rq);
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 44c07ed..f918919 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2950,7 +2950,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->load.weight;
+	return cpu_rq(cpu)->avg.load_avg_contrib;
 }
 
 /*
@@ -2997,7 +2997,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
 
 	if (nr_running)
-		return rq->load.weight / nr_running;
+		return rq->avg.load_avg_contrib / nr_running;
 
 	return 0;
 }
-- 
1.7.5.4

