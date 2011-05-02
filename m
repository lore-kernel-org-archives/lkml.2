Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab1EBBTy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 21:19:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54512 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab1EBBTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 21:19:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=YSS5UtF3V2KHOVLwoaWCVv37JvlPJ0qsQ04ftAbDuaaCpAy8ocwVIriyqr8lsoHBU
	PwjLpDGrZIh7UVJVQkvOw==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v1 02/19] sched: increase SCHED_LOAD_SCALE resolution
Date: Sun,  1 May 2011 18:19:00 -0700
Message-Id: <1304299157-25769-3-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1304299157-25769-1-git-send-email-ncrao@google.com>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce SCHED_LOAD_RESOLUTION, which scales is added to SCHED_LOAD_SHIFT and
increases the resolution of SCHED_LOAD_SCALE. This patch sets the value of
SCHED_LOAD_RESOLUTION to 10, scaling up the weights for all sched entities by
a factor of 1024. With this extra resolution, we can handle deeper cgroup
hiearchies and the scheduler can do better shares distribution and load
load balancing on larger systems (especially for low weight task groups).

This does not change the existing user interface, the scaled weights are only
used internally. We do not modify prio_to_weight values or inverses, but use
the original weights when calculating the inverse which is used to scale
execution time delta in calc_delta_mine(). This ensures we do not lose accuracy
when accounting time to the sched entities. Thanks to Nikunj Dadhania for fixing
an bug in c_d_m() that broken fairness.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 include/linux/sched.h |    3 ++-
 kernel/sched.c        |   20 +++++++++++---------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8d1ff2b..d2c3bab 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -794,7 +794,8 @@ enum cpu_idle_type {
 /*
  * Increase resolution of nice-level calculations:
  */
-#define SCHED_LOAD_SHIFT	10
+#define SCHED_LOAD_RESOLUTION	10
+#define SCHED_LOAD_SHIFT	(10 + SCHED_LOAD_RESOLUTION)
 #define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index f4b4679..05e3fe2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -293,7 +293,7 @@ static DEFINE_SPINLOCK(task_group_lock);
  *  limitation from this.)
  */
 #define MIN_SHARES	2
-#define MAX_SHARES	(1UL << 18)
+#define MAX_SHARES	(1UL << 18 + SCHED_LOAD_RESOLUTION)
 
 static int root_task_group_load = ROOT_TASK_GROUP_LOAD;
 #endif
@@ -1307,14 +1307,14 @@ calc_delta_mine(unsigned long delta_exec, u64 weight, struct load_weight *lw)
 	u64 tmp;
 
 	if (!lw->inv_weight) {
-		if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
+		unsigned long w = lw->weight >> SCHED_LOAD_RESOLUTION;
+		if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
 			lw->inv_weight = 1;
 		else
-			lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)
-				/ (lw->weight+1);
+			lw->inv_weight = 1 + (WMULT_CONST - w/2) / (w + 1);
 	}
 
-	tmp = (u64)delta_exec * weight;
+	tmp = (u64)delta_exec * ((weight >> SCHED_LOAD_RESOLUTION) + 1);
 	/*
 	 * Check whether we'd overflow the 64-bit multiplication:
 	 */
@@ -1758,12 +1758,13 @@ static void set_load_weight(struct task_struct *p)
 	 * SCHED_IDLE tasks get minimal weight:
 	 */
 	if (p->policy == SCHED_IDLE) {
-		p->se.load.weight = WEIGHT_IDLEPRIO;
+		p->se.load.weight = WEIGHT_IDLEPRIO << SCHED_LOAD_RESOLUTION;
 		p->se.load.inv_weight = WMULT_IDLEPRIO;
 		return;
 	}
 
-	p->se.load.weight = prio_to_weight[p->static_prio - MAX_RT_PRIO];
+	p->se.load.weight = prio_to_weight[p->static_prio - MAX_RT_PRIO]
+				<< SCHED_LOAD_RESOLUTION;
 	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
 }
 
@@ -9129,14 +9130,15 @@ cpu_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
 static int cpu_shares_write_u64(struct cgroup *cgrp, struct cftype *cftype,
 				u64 shareval)
 {
-	return sched_group_set_shares(cgroup_tg(cgrp), shareval);
+	return sched_group_set_shares(cgroup_tg(cgrp),
+				      shareval << SCHED_LOAD_RESOLUTION);
 }
 
 static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
 {
 	struct task_group *tg = cgroup_tg(cgrp);
 
-	return (u64) tg->shares;
+	return (u64) tg->shares >> SCHED_LOAD_RESOLUTION;
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-- 
1.7.3.1

