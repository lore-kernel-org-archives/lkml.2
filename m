Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab1DTUwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:52:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7890 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab1DTUwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:52:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=pT8OJo27xQasRygz1DcR7WXX1PJU87urYgLyX6AldqIUnu9Cml9ZPvf/vpqmI/dz6
	lOwgKhYOFqUjdc9fQ9vCw==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 02/18] sched: increase SCHED_LOAD_SCALE resolution
Date: Wed, 20 Apr 2011 13:51:21 -0700
Message-Id: <1303332697-16426-3-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
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
when accounting time to the sched entities.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 include/linux/sched.h |    3 ++-
 kernel/sched.c        |   18 ++++++++++--------
 2 files changed, 12 insertions(+), 9 deletions(-)

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
index 50f97cc..bfee8ff 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -293,7 +293,7 @@ static DEFINE_SPINLOCK(task_group_lock);
  *  limitation from this.)
  */
 #define MIN_SHARES	2
-#define MAX_SHARES	(1UL << 18)
+#define MAX_SHARES	(1UL << 28)
 
 static int root_task_group_load = ROOT_TASK_GROUP_LOAD;
 #endif
@@ -1308,11 +1308,11 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
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
 
 	tmp = (u64)delta_exec * weight;
@@ -1759,12 +1759,13 @@ static void set_load_weight(struct task_struct *p)
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
 
@@ -9130,14 +9131,15 @@ cpu_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
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

