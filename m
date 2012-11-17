Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab2KQNFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 08:05:05 -0500
Received: from mga14.intel.com ([143.182.124.37]:25469 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab2KQNFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 08:05:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,270,1352102400"; 
   d="scan'208";a="219067097"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, pjt@google.com,
        preeti@linux.vnet.ibm.com, vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/5] sched: update rq runnable load average in time
Date: Sat, 17 Nov 2012 21:04:14 +0800
Message-Id: <1353157457-3649-3-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353157457-3649-1-git-send-email-alex.shi@intel.com>
References: <1353157457-3649-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have rq runnable load average value, and prepare to use it in rq
cpu_load[] updating.

So we want to make sure rq cup_load[] updating is using the latest
data. The update_cpu_load_active(rq) was put after task_tick() is for
this purpose.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c |    2 +-
 kernel/sched/fair.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9dbbe45..bacfee0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2657,8 +2657,8 @@ void scheduler_tick(void)
 
 	raw_spin_lock(&rq->lock);
 	update_rq_clock(rq);
-	update_cpu_load_active(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
+	update_cpu_load_active(rq);
 	raw_spin_unlock(&rq->lock);
 
 	perf_event_task_tick();
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bc60e43..44c07ed 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6011,6 +6011,7 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 
 		raw_spin_lock_irq(&rq->lock);
 		update_rq_clock(rq);
+		update_rq_runnable_avg(rq, rq->nr_running);
 		update_idle_cpu_load(rq);
 		raw_spin_unlock_irq(&rq->lock);
 
-- 
1.7.5.4

