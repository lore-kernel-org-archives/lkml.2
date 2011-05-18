Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331Ab1ERRKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 13:10:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24474 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab1ERRKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 13:10:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=guPx1n2S1ONpQcKGYgYOFX4B4ZxwxxFSURJJFMS1d0uVa8xAGvxBb5rhgznUPcOc2
	a24hTaKFMQqXBL7aqvpJw==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v2 3/3] sched: increase SCHED_LOAD_SCALE resolution
Date: Wed, 18 May 2011 10:09:40 -0700
Message-Id: <1305738580-9924-4-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1305738580-9924-1-git-send-email-ncrao@google.com>
References: <1305738580-9924-1-git-send-email-ncrao@google.com>
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
 include/linux/sched.h |   14 ++++++++++++--
 kernel/sched.c        |   27 +++++++++++++++++++--------
 2 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f2f4402..b7ecd61 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -788,9 +788,19 @@ enum cpu_idle_type {
 };
 
 /*
- * Increase resolution of nice-level calculations:
+ * Increase resolution of nice-level calculations for 64-bit architectures.
  */
-#define SCHED_LOAD_SHIFT	10
+#if BITS_PER_LONG > 32
+#define SCHED_LOAD_RESOLUTION	10
+#define scale_load(w)		(w << SCHED_LOAD_RESOLUTION)
+#define scale_load_down(w)	(w >> SCHED_LOAD_RESOLUTION)
+#else
+#define SCHED_LOAD_RESOLUTION	0
+#define scale_load(w)		w
+#define scale_load_down(w)	w
+#endif
+
+#define SCHED_LOAD_SHIFT	(10 + (SCHED_LOAD_RESOLUTION))
 #define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index 375e9c6..554d767 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -293,7 +293,7 @@ static DEFINE_SPINLOCK(task_group_lock);
  *  limitation from this.)
  */
 #define MIN_SHARES	2
-#define MAX_SHARES	(1UL << 18)
+#define MAX_SHARES	(1UL << (18 + SCHED_LOAD_RESOLUTION))
 
 static int root_task_group_load = ROOT_TASK_GROUP_LOAD;
 #endif
@@ -1330,13 +1330,24 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 {
 	u64 tmp;
 
-	tmp = (u64)delta_exec * weight;
+	/*
+	 * weight can be less than 2^SCHED_LOAD_RESOLUTION for task group sched
+	 * entities since MIN_SHARES = 2. Treat weight as 1 if less than
+	 * 2^SCHED_LOAD_RESOLUTION.
+	 */
+	if (likely(weight > (1UL << SCHED_LOAD_RESOLUTION)))
+		tmp = (u64)delta_exec * scale_load_down(weight);
+	else
+		tmp = (u64)delta_exec;
 
 	if (!lw->inv_weight) {
-		if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
+		unsigned long w = scale_load_down(lw->weight);
+		if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
 			lw->inv_weight = 1;
+		else if (unlikely(!w))
+			lw->inv_weight = WMULT_CONST;
 		else
-			lw->inv_weight = WMULT_CONST / lw->weight;
+			lw->inv_weight = WMULT_CONST / w;
 	}
 
 	/*
@@ -1785,12 +1796,12 @@ static void set_load_weight(struct task_struct *p)
 	 * SCHED_IDLE tasks get minimal weight:
 	 */
 	if (p->policy == SCHED_IDLE) {
-		load->weight = WEIGHT_IDLEPRIO;
+		load->weight = scale_load(WEIGHT_IDLEPRIO);
 		load->inv_weight = WMULT_IDLEPRIO;
 		return;
 	}
 
-	load->weight = prio_to_weight[prio];
+	load->weight = scale_load(prio_to_weight[prio]);
 	load->inv_weight = prio_to_wmult[prio];
 }
 
@@ -8809,14 +8820,14 @@ cpu_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
 static int cpu_shares_write_u64(struct cgroup *cgrp, struct cftype *cftype,
 				u64 shareval)
 {
-	return sched_group_set_shares(cgroup_tg(cgrp), shareval);
+	return sched_group_set_shares(cgroup_tg(cgrp), scale_load(shareval));
 }
 
 static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
 {
 	struct task_group *tg = cgroup_tg(cgrp);
 
-	return (u64) tg->shares;
+	return (u64) scale_load_down(tg->shares);
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-- 
1.7.3.1

