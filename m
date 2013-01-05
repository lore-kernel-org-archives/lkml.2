Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3AEIl5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:41:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:44979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301Ab3AEIhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:37:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,415,1355126400"; 
   d="scan'208";a="270210093"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        alex.shi@intel.com
Subject: [PATCH v3 09/22] sched: compute runnable load avg in cpu_load and cpu_avg_load_per_task
Date: Sat,  5 Jan 2013 16:37:38 +0800
Message-Id: <1357375071-11793-10-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are the base values in load balance, update them with rq runnable
load average, then the load balance will consider runnable load avg
naturally.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c | 8 ++++++++
 kernel/sched/fair.c | 4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 06d27af..5feed5e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2544,7 +2544,11 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 void update_idle_cpu_load(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
+#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+	unsigned long load = (unsigned long)this_rq->cfs.runnable_load_avg;
+#else
 	unsigned long load = this_rq->load.weight;
+#endif
 	unsigned long pending_updates;
 
 	/*
@@ -2594,7 +2598,11 @@ static void update_cpu_load_active(struct rq *this_rq)
 	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
+#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+	__update_cpu_load(this_rq, this_rq->cfs.runnable_load_avg, 1);
+#else
 	__update_cpu_load(this_rq, this_rq->load.weight, 1);
+#endif
 
 	calc_load_account_active(this_rq);
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5c545e4..84a6517 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2906,7 +2906,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->load.weight;
+	return (unsigned long)cpu_rq(cpu)->cfs.runnable_load_avg;
 }
 
 /*
@@ -2953,7 +2953,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
 
 	if (nr_running)
-		return rq->load.weight / nr_running;
+		return (unsigned long)rq->cfs.runnable_load_avg / nr_running;
 
 	return 0;
 }
-- 
1.7.12

