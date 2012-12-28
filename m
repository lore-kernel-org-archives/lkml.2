Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2L1KBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 05:01:34 -0500
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:59937 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156Ab2L1KBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 05:01:30 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Neil Zhang <zhangwm@marvell.com>,
        bitbucket@online.de
Subject: [PATCH] sched: remove redundant update_runtime notifier
Date: Fri, 28 Dec 2012 18:00:26 +0800
Message-Id: <1356688826-23158-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.4.1
X-OriginalArrivalTime: 28 Dec 2012 10:00:41.0850 (UTC) FILETIME=[3222DDA0:01CDE4E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

migration_call() will do all the things that update_runtime() does.
So it seems update_runtime() is a redundant notifier, remove it.

Furthermore, there is potential risk that the current code will catch
BUG_ON at line 687 of rt.c when do cpu hotplug while there are realtime
threads running because of enable runtime twice.

Cc: bitbucket@online.de
Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 kernel/sched/core.c  |    3 ---
 kernel/sched/rt.c    |   40 ----------------------------------------
 kernel/sched/sched.h |    1 -
 3 files changed, 0 insertions(+), 44 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 257002c..7b6a4d8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6779,9 +6779,6 @@ void __init sched_init_smp(void)
 	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
 	hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
 
-	/* RT runtime code needs to handle some hotplug events */
-	hotcpu_notifier(update_runtime, 0);
-
 	init_hrtick();
 
 	/* Move init over to a non-isolated CPU */
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 418feb0..1a499d2 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -697,15 +697,6 @@ balanced:
 	}
 }
 
-static void disable_runtime(struct rq *rq)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	__disable_runtime(rq);
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-}
-
 static void __enable_runtime(struct rq *rq)
 {
 	rt_rq_iter_t iter;
@@ -730,37 +721,6 @@ static void __enable_runtime(struct rq *rq)
 	}
 }
 
-static void enable_runtime(struct rq *rq)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	__enable_runtime(rq);
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-}
-
-int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu)
-{
-	int cpu = (int)(long)hcpu;
-
-	switch (action) {
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		disable_runtime(cpu_rq(cpu));
-		return NOTIFY_OK;
-
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		enable_runtime(cpu_rq(cpu));
-		return NOTIFY_OK;
-
-	default:
-		return NOTIFY_DONE;
-	}
-}
-
 static int balance_runtime(struct rt_rq *rt_rq)
 {
 	int more = 0;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc88644..16d18a1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -890,7 +890,6 @@ extern void sysrq_sched_debug_show(void);
 extern void sched_init_granularity(void);
 extern void update_max_interval(void);
 extern void update_group_power(struct sched_domain *sd, int cpu);
-extern int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu);
 extern void init_sched_rt_class(void);
 extern void init_sched_fair_class(void);
 
-- 
1.7.4.1

