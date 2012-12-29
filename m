Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2L2Qnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 11:43:47 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:65359 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab2L2Qnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 11:43:42 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 12/27] sched: Update rq clock on nohz CPU before migrating tasks
Date: Sat, 29 Dec 2012 17:42:51 +0100
Message-Id: <1356799386-4212-13-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the sched_class::put_prev_task() callback of rt and fair
classes are referring to the rq clock to update their runtime
statistics. A CPU running in tickless mode may carry a stale value.
We need to update it there.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c  |    6 ++++++
 kernel/sched/sched.h |    7 +++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bfac40f..2fcbb03 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4894,6 +4894,12 @@ static void migrate_tasks(unsigned int dead_cpu)
 	 */
 	rq->stop = NULL;
 
+	/*
+	 * ->put_prev_task() need to have an up-to-date value
+	 * of rq->clock[_task]
+	 */
+	update_nohz_rq_clock(rq);
+
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc88644..f24d91e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3,6 +3,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
+#include <linux/tick.h>
 
 #include "cpupri.h"
 
@@ -963,6 +964,12 @@ static inline void dec_nr_running(struct rq *rq)
 
 extern void update_rq_clock(struct rq *rq);
 
+static inline void update_nohz_rq_clock(struct rq *rq)
+{
+	if (tick_nohz_full_cpu(cpu_of(rq)))
+		update_rq_clock(rq);
+}
+
 extern void activate_task(struct rq *rq, struct task_struct *p, int flags);
 extern void deactivate_task(struct rq *rq, struct task_struct *p, int flags);
 
-- 
1.7.5.4

