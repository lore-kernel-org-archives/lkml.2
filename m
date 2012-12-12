Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab2LLNdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 08:33:16 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38156 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab2LLNce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 08:32:34 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com
Cc: alex.shi@intel.com, preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, viresh.kumar@linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC PATCH v2 4/6] sched: secure access to other CPU statistics
Date: Wed, 12 Dec 2012 14:31:30 +0100
Message-Id: <1355319092-30980-5-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355319092-30980-1-git-send-email-vincent.guittot@linaro.org>
References: <1355319092-30980-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a CPU accesses the runnable_avg_sum and runnable_avg_period fields of its
buddy CPU while the latter updates it, it can get the new version of a field
and the old version of the other one. This can generate erroneous decisions.
We don't want to use a lock mechanism for ensuring the coherency because of
the overhead in this critical path. The previous attempt can't ensure
coherency of both fields for 100% of the platform and use case as it will
depend of the toolchain and the platform architecture.
The runnable_avg_period of a runqueue tends to the max value in less than
345ms after plugging a CPU, which implies that we could use the max value
instead of reading runnable_avg_period after 345ms. During the starting phase,
we must ensure a minimum of coherency between the fields. A simple rule is
runnable_avg_sum <= runnable_avg_period.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fc93d96..f1a4c24 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5153,13 +5153,16 @@ static bool numa_allow_migration(struct task_struct *p, int prev_cpu, int new_cp
 static bool is_buddy_busy(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
+	u32 sum = rq->avg.runnable_avg_sum;
+	u32 period = rq->avg.runnable_avg_period;
+
+	sum = min(sum, period);
 
 	/*
 	 * A busy buddy is a CPU with a high load or a small load with a lot of
 	 * running tasks.
 	 */
-	return ((rq->avg.runnable_avg_sum << rq->nr_running) >
-			rq->avg.runnable_avg_period);
+	return ((sum << rq->nr_running) > period);
 }
 
 static bool is_light_task(struct task_struct *p)
-- 
1.7.9.5

