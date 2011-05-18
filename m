Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab1ERViP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:38:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5674 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab1ERViO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:38:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=I5FRoCNzlSE9Km7UeSZjAIe/0wODH/Vp/an1P3mwN/YwQpXgUK16kg6S/m+bKjBC4
	KraBRPql+rzt904eHrVPg==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v3 3/3] sched: increase SCHED_LOAD_SCALE resolution
Date: Wed, 18 May 2011 14:37:48 -0700
Message-Id: <1305754668-18792-1-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <20110518212246.GD28476@elte.hu>
References: <20110518212246.GD28476@elte.hu>
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

Below is some analysis of the performance costs/improvements of this patch.

1. Micro-arch performance costs:

Experiment was to run Ingo's pipe_test_100k 200 times with the task pinned to
one cpu. I measured instruction, cycles and stalled-cycles for the runs. See
http://thread.gmane.org/gmane.linux.kernel/1129232/focus=1129389 for more info.

-tip (baseline):

 Performance counter stats for '/root/load-scale/pipe-test-100k' (200 runs):

       964,991,769 instructions             #    0.82  insns per cycle
                                            #    0.33  stalled cycles per insn
                                            #    ( +-  0.05% )
     1,171,186,635 cycles                   #    0.000 GHz                      ( +-  0.08% )
       306,373,664 stalled-cycles-backend   #   26.16% backend  cycles idle     ( +-  0.28% )
       314,933,621 stalled-cycles-frontend  #   26.89% frontend cycles idle     ( +-  0.34% )

        1.122405684  seconds time elapsed  ( +-  0.05% )

-tip+patches:

 Performance counter stats for './load-scale/pipe-test-100k' (200 runs):

       963,624,821 instructions             #    0.82  insns per cycle
                                            #    0.33  stalled cycles per insn
                                            #    ( +-  0.04% )
     1,175,215,649 cycles                   #    0.000 GHz                      ( +-  0.08% )
       315,321,126 stalled-cycles-backend   #   26.83% backend  cycles idle     ( +-  0.28% )
       316,835,873 stalled-cycles-frontend  #   26.96% frontend cycles idle     ( +-  0.29% )

        1.122238659  seconds time elapsed  ( +-  0.06% )

With this patch, instructions decrease by ~0.10% and cycles increase by 0.27%.
This doesn't look statistically significant. The number of stalled cycles in
the backend increased from 26.16% to 26.83%. This can be attributed to the
shifts we do in c_d_m() and other places. The fraction of stalled cycles in the
frontend remains about the same, at 26.96% compared to 26.89% in -tip.

2. Balancing low-weight task groups

Test setup: run 50 tasks with random sleep/busy times (biased around 100ms) in
a low weight container (with cpu.shares = 2). Measure %idle as reported by
mpstat over a 10s window.

-tip (baseline):

06:47:48 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle    intr/s
06:47:49 PM  all   94.32    0.00    0.06    0.00    0.00    0.00    0.00    0.00    5.62  15888.00
06:47:50 PM  all   94.57    0.00    0.62    0.00    0.00    0.00    0.00    0.00    4.81  16180.00
06:47:51 PM  all   94.69    0.00    0.06    0.00    0.00    0.00    0.00    0.00    5.25  15966.00
06:47:52 PM  all   95.81    0.00    0.00    0.00    0.00    0.00    0.00    0.00    4.19  16053.00
06:47:53 PM  all   94.88    0.06    0.00    0.00    0.00    0.00    0.00    0.00    5.06  15984.00
06:47:54 PM  all   93.31    0.00    0.00    0.00    0.00    0.00    0.00    0.00    6.69  15806.00
06:47:55 PM  all   94.19    0.00    0.06    0.00    0.00    0.00    0.00    0.00    5.75  15896.00
06:47:56 PM  all   92.87    0.00    0.00    0.00    0.00    0.00    0.00    0.00    7.13  15716.00
06:47:57 PM  all   94.88    0.00    0.00    0.00    0.00    0.00    0.00    0.00    5.12  15982.00
06:47:58 PM  all   95.44    0.00    0.00    0.00    0.00    0.00    0.00    0.00    4.56  16075.00
Average:     all   94.49    0.01    0.08    0.00    0.00    0.00    0.00    0.00    5.42  15954.60

-tip+patches:

06:47:03 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle    intr/s
06:47:04 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  16630.00
06:47:05 PM  all   99.69    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.31  16580.20
06:47:06 PM  all   99.69    0.00    0.06    0.00    0.00    0.00    0.00    0.00    0.25  16596.00
06:47:07 PM  all   99.20    0.00    0.74    0.00    0.00    0.06    0.00    0.00    0.00  17838.61
06:47:08 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  16540.00
06:47:09 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  16575.00
06:47:10 PM  all  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  16614.00
06:47:11 PM  all   99.94    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.06  16588.00
06:47:12 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00    0.00  16593.00
06:47:13 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00    0.00  16551.00
Average:     all   99.84    0.00    0.09    0.00    0.00    0.01    0.00    0.00    0.06  16711.58

We see an improvement in idle% on the system (drops from 5.42% on -tip to 0.06%
with the patches).

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 include/linux/sched.h |   23 +++++++++++++++++++++--
 kernel/sched.c        |   28 ++++++++++++++++++++--------
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f2f4402..c34a718 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -788,9 +788,28 @@ enum cpu_idle_type {
 };
 
 /*
- * Increase resolution of nice-level calculations:
+ * Increase resolution of nice-level calculations for 64-bit architectures.
+ * The extra resolution improves shares distribution and load balancing of
+ * low-weight task groups (eg. nice +19 on an autogroup), deeper taskgroup
+ * hierarchies, especially on larger systems. This is not a user-visible change
+ * and does not change the user-interface for setting shares/weights.
+ *
+ * We increase resolution only if we have enough bits to allow this increased
+ * resolution (i.e. BITS_PER_LONG > 32). The costs for increasing resolution
+ * when BITS_PER_LONG <= 32 are pretty high and the returns do not justify the
+ * increased costs.
  */
-#define SCHED_LOAD_SHIFT	10
+#if BITS_PER_LONG > 32
+# define SCHED_LOAD_RESOLUTION	10
+# define scale_load(w)		((w) << SCHED_LOAD_RESOLUTION)
+# define scale_load_down(w)	((w) >> SCHED_LOAD_RESOLUTION)
+#else
+# define SCHED_LOAD_RESOLUTION	0
+# define scale_load(w)		(w)
+# define scale_load_down(w)	(w)
+#endif
+
+#define SCHED_LOAD_SHIFT	(10 + SCHED_LOAD_RESOLUTION)
 #define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index 375e9c6..bb504e1 100644
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
@@ -1330,13 +1330,25 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
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
+
+		if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
 			lw->inv_weight = 1;
+		else if (unlikely(!w))
+			lw->inv_weight = WMULT_CONST;
 		else
-			lw->inv_weight = WMULT_CONST / lw->weight;
+			lw->inv_weight = WMULT_CONST / w;
 	}
 
 	/*
@@ -1785,12 +1797,12 @@ static void set_load_weight(struct task_struct *p)
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
 
@@ -8809,14 +8821,14 @@ cpu_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
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

