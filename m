Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0G3FU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 01:20:56 -0400
Received: from smtp-out.google.com ([74.125.121.35]:22956 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab0G3FTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 01:19:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=tRyJ6SOz4X2OKdhCYiyJSlxdHDHgSgyYxX7PCJUisVIDmJ/GC3/ASc5sBCunPLU2M
	cBBMLY8J6WzCamLm0GmfQ==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Cc: Venkatesh Pallipadi <venki@google.com>, Ken Chen <kenchen@google.com>,
        Paul Turner <pjt@google.com>, Nikhil Rao <ncrao@google.com>
Subject: [PATCH 3/6] sched: add moving average of time spent servicing SCHED_NORMAL tasks
Date: Thu, 29 Jul 2010 22:19:03 -0700
Message-Id: <1280467146-32218-4-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280467146-32218-1-git-send-email-ncrao@google.com>
References: <1280467146-32218-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a moving average of time spent servicing SCHED_NORMAL tasks.
This metric is maintained at rq->norm_avg and is similar to rq->rt_avg. This is
metric is used to provide a measure of cpu power available to run SCHED_IDLE
tasks.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched.c      |   12 ++++++++++++
 kernel/sched_fair.c |    3 +++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 26e74e9..d037b6c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -514,6 +514,7 @@ struct rq {
 	unsigned long avg_load_per_task;
 
 	u64 rt_avg;
+	u64 norm_avg;
 	u64 age_stamp;
 	u64 idle_stamp;
 	u64 avg_idle;
@@ -1263,6 +1264,7 @@ static void sched_avg_update(struct rq *rq)
 		asm("" : "+rm" (rq->age_stamp));
 		rq->age_stamp += period;
 		rq->rt_avg /= 2;
+		rq->norm_avg /= 2;
 	}
 }
 
@@ -1272,6 +1274,12 @@ static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
 	sched_avg_update(rq);
 }
 
+static void sched_norm_avg_update(struct rq *rq, u64 norm_delta)
+{
+	rq->norm_avg += norm_delta;
+	sched_avg_update(rq);
+}
+
 #else /* !CONFIG_SMP */
 static void resched_task(struct task_struct *p)
 {
@@ -1282,6 +1290,10 @@ static void resched_task(struct task_struct *p)
 static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
 {
 }
+
+static void sched_norm_avg_update(struct rq *rq, u64 norm_delta)
+{
+}
 #endif /* CONFIG_SMP */
 
 #if BITS_PER_LONG == 32
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a878b53..0e25e51 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -543,6 +543,9 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
 		cpuacct_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
+
+		if (curtask->policy != SCHED_IDLE)
+			sched_norm_avg_update(task_rq(curtask), delta_exec);
 	}
 }
 
-- 
1.7.1

