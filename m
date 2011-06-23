Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934276Ab1FWSSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:18:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:34292 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253Ab1FWRgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 084/247] sched: Move sched_avg_update() to update_cpu_load()
Date: Thu, 23 Jun 2011 13:32:32 -0400
Message-Id: <1308850515-15242-25-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit da2b71edd8a7db44fe1746261410a981f3e03632 upstream.

Currently sched_avg_update() (which updates rt_avg stats in the rq)
is getting called from scale_rt_power() (in the load balance context)
which doesn't take rq->lock.

Fix it by moving the sched_avg_update() to more appropriate
update_cpu_load() where the CFS load gets updated as well.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1282596171.2694.3.camel@sbsiddha-MOBL3>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched.c      |    6 ++++++
 kernel/sched_fair.c |    2 --
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 12ee156..c3e891f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1269,6 +1269,10 @@ static void resched_task(struct task_struct *p)
 static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
 {
 }
+
+static void sched_avg_update(struct rq *rq)
+{
+}
 #endif /* CONFIG_SMP */
 
 #if BITS_PER_LONG == 32
@@ -3102,6 +3106,8 @@ static void update_cpu_load(struct rq *this_rq)
 		this_rq->calc_load_update += LOAD_FREQ;
 		calc_load_account_active(this_rq);
 	}
+
+	sched_avg_update(this_rq);
 }
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 72eb9a6..3a0f7ba 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2337,8 +2337,6 @@ unsigned long scale_rt_power(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	u64 total, available;
 
-	sched_avg_update(rq);
-
 	total = sched_avg_period() + (rq->clock - rq->age_stamp);
 	available = total - rq->rt_avg;
 
-- 
1.7.4.4

