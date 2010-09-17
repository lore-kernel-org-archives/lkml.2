Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab0IQB6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 21:58:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30925 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab0IQB50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 21:57:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=imcccFbjUrMO5jGMh5FIfgrcerwFD5Fb/a408gy2D3fiZAh9PPp6YYR6f2M8mav+A
	G0mcRA/ciRHwKu6d3k4Ow==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 5/6] sched: Remove irq time from available CPU power
Date: Thu, 16 Sep 2010 18:56:35 -0700
Message-Id: <1284688596-6731-6-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284688596-6731-1-git-send-email-venki@google.com>
References: <1284688596-6731-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea suggested by Peter Zijlstra here.
http://marc.info/?l=linux-kernel&m=127476934517534&w=2

irq time is technically not available to the tasks running on the CPU.
This patch removes irq time from CPU power piggybacking on
sched_rt_avg_update().

Tested this by keeping CPU X busy with 75% irq processing (hard+soft) on
an 4-way system. And start 7 cycle soakers on the system. Without this change,
there will be 2 tasks on each CPU. With this change, there is still a
single task on irq busy CPU and remaining 7 tasks are spread around among
other 3 CPUs.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched.c          |   14 ++++++++++++++
 kernel/sched_fair.c     |    3 +++
 kernel/sched_features.h |    5 +++++
 3 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f36697b..8ac5389 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2025,6 +2025,18 @@ static u64 unaccount_irq_delta(u64 delta, int cpu, u64 *saved_irq_time)
 #define unaccount_irq_delta_rt(delta, cpu, class_rq)		 \
 		unaccount_irq_delta(delta, cpu, &(class_rq)->saved_irq_time)
 
+static void sched_irq_power_update_fair(int cpu, struct cfs_rq *cfs_rq,
+			struct rq* rq)
+{
+	if (!sched_clock_irqtime)
+		return;
+
+	if (likely(rq->total_irq_time > cfs_rq->saved_irq_time)) {
+		sched_rt_avg_update(rq,
+				rq->total_irq_time - cfs_rq->saved_irq_time);
+	}
+}
+
 #else
 
 #define update_irq_time(cpu, crq)		do { } while (0)
@@ -2042,6 +2054,8 @@ static u64 unaccount_irq_delta_rt(u64 delta_exec, int cpu, struct rt_rq *rt_rq)
 	return delta_exec;
 }
 
+#define sched_irq_power_update_fair(cpu, crq, rq)	do { } while (0)
+
 #endif
 
 #include "sched_idletask.c"
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a64fdaf..937fded 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -526,6 +526,9 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	if (unlikely(!curr))
 		return;
 
+	if (sched_feat(NONIRQ_POWER) && entity_is_task(curr))
+		sched_irq_power_update_fair(cpu, cfs_rq, rq_of(cfs_rq));
+
 	/*
 	 * Get the amount of time the current task was running
 	 * since the last time we changed load (this cannot
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 83c66e8..185f920 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -61,3 +61,8 @@ SCHED_FEAT(ASYM_EFF_LOAD, 1)
  * release the lock. Decreases scheduling overhead.
  */
 SCHED_FEAT(OWNER_SPIN, 1)
+
+/*
+ * Decrement CPU power based on irq activity
+ */
+SCHED_FEAT(NONIRQ_POWER, 1)
-- 
1.7.1

