Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab2LTSk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:40:28 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46974 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2LTSjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:39:49 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 12/24] sched: Update rq clock on nohz CPU before migrating tasks
Date: Thu, 20 Dec 2012 19:32:59 +0100
Message-Id: <1356028391-14427-13-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
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
Cc: Avi Kivity <avi@redhat.com>
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
index 02bd005..5d9060a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4832,6 +4832,12 @@ static void migrate_tasks(unsigned int dead_cpu)
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
index 5eca173..db3d4df 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3,6 +3,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
+#include <linux/tick.h>
 
 #include "cpupri.h"
 
@@ -951,6 +952,12 @@ static inline void dec_nr_running(struct rq *rq)
 
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

