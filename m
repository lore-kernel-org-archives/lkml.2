Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3AHCJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:09:54 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:65391 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab3AHCJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:09:52 -0500
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
Subject: [PATCH 30/33] sched: Debug nohz rq clock
Date: Tue,  8 Jan 2013 03:08:30 +0100
Message-Id: <1357610913-1080-31-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The runqueue clock is supposed to be periodically updated by the
tick. On full dynticks CPU we call update_nohz_rq_clock() before
reading it. Now the scheduler code is complicated enough that we
may miss some update_nohz_rq_clock() calls before reading the
runqueue clock.

This therefore introduce a new debugging feature that detects
when the rq clock is stale due to missing updates on full
dynticks CPUs.

This can be later expanded to debug stale clocks on dynticks-idle
CPUs.

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
 kernel/sched/sched.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e1bac76..0fef0b3 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -502,16 +502,39 @@ DECLARE_PER_CPU(struct rq, runqueues);
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
+static inline void rq_clock_check(struct rq *rq)
+{
+#if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_NO_HZ_FULL)
+	unsigned long long clock;
+	unsigned long flags;
+	int cpu;
+
+	cpu = cpu_of(rq);
+	if (!tick_nohz_full_cpu(cpu) || rq->curr == rq->idle)
+		return;
+
+	local_irq_save(flags);
+	clock = sched_clock_cpu(cpu_of(rq));
+	local_irq_restore(flags);
+
+	if (abs(clock - rq->clock) > (TICK_NSEC * 3))
+		WARN_ON_ONCE(1);
+#endif
+}
+
 static inline u64 rq_clock(struct rq *rq)
 {
+	rq_clock_check(rq);
 	return rq->clock;
 }
 
 static inline u64 rq_clock_task(struct rq *rq)
 {
+	rq_clock_check(rq);
 	return rq->clock_task;
 }
 
+
 #ifdef CONFIG_SMP
 
 #define rcu_dereference_check_sched_domain(p) \
-- 
1.7.5.4

