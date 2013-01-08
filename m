Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3AHCKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:10:04 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:58021 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3AHCJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:09:59 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 33/33] sched: Disable lb_bias feature for full dynticks
Date: Tue,  8 Jan 2013 03:08:33 +0100
Message-Id: <1357610913-1080-34-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we run in full dynticks mode, we have no way to
update the CPU load stats as typically done by
update_cpu_load_active().

Hence we need to force LB_BIAS sched feature to be off
because we can't rely on these statistics to measure a
CPU load in order to find a target for load balancing.

Instead, lets only rely on the current runqueue load
weight.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/fair.c     |   13 +++++++++++--
 kernel/sched/features.h |    3 +++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bd9113a..4a55e8a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2903,6 +2903,15 @@ static unsigned long weighted_cpuload(const int cpu)
 	return cpu_rq(cpu)->load.weight;
 }
 
+static inline int sched_lb_bias(void)
+{
+#ifndef CONFIG_NO_HZ_FULL
+	return sched_feat(LB_BIAS);
+#else
+	return 0;
+#endif
+}
+
 /*
  * Return a low guess at the load of a migration-source cpu weighted
  * according to the scheduling class and "nice" value.
@@ -2915,7 +2924,7 @@ static unsigned long source_load(int cpu, int type)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
-	if (type == 0 || !sched_feat(LB_BIAS))
+	if (type == 0 || !sched_lb_bias())
 		return total;
 
 	return min(rq->cpu_load[type-1], total);
@@ -2930,7 +2939,7 @@ static unsigned long target_load(int cpu, int type)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
-	if (type == 0 || !sched_feat(LB_BIAS))
+	if (type == 0 || !sched_lb_bias())
 		return total;
 
 	return max(rq->cpu_load[type-1], total);
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 1ad1d2b..4c8c113 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -43,7 +43,10 @@ SCHED_FEAT(ARCH_POWER, true)
 
 SCHED_FEAT(HRTICK, false)
 SCHED_FEAT(DOUBLE_TICK, false)
+
+#ifndef CONFIG_NO_HZ_FULL
 SCHED_FEAT(LB_BIAS, true)
+#endif
 
 /*
  * Spin-wait on mutex acquisition when the mutex owner is running on
-- 
1.7.5.4

