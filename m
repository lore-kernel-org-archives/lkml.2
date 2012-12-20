Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab2LTSkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:40:12 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:50808 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2LTSkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:40:00 -0500
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
Subject: [PATCH 16/24] sched: Update clock of nohz busiest rq before balancing
Date: Thu, 20 Dec 2012 19:33:03 +0100
Message-Id: <1356028391-14427-17-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move_tasks() and active_load_balance_cpu_stop() both need
to have the busiest rq clock uptodate because they may end
up calling can_migrate_task() that uses rq->clock_task
to determine if the task running in the busiest runqueue
is cache hot.

Hence if the busiest runqueue is tickless, update its clock
before reading it.

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
[ Forward port conflicts ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/fair.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b31f7ca..347dd3f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4774,6 +4774,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 {
 	int ld_moved, cur_ld_moved, active_balance = 0;
 	int lb_iterations, max_lb_iterations;
+	int clock_updated;
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
@@ -4817,6 +4818,7 @@ redo:
 
 	ld_moved = 0;
 	lb_iterations = 1;
+	clock_updated = 0;
 	if (busiest->nr_running > 1) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
@@ -4840,6 +4842,14 @@ more_balance:
 		 */
 		cur_ld_moved = move_tasks(&env);
 		ld_moved += cur_ld_moved;
+
+		/*
+		 * Move tasks may end up calling can_migrate_task() which
+		 * requires an uptodate value of the rq clock.
+		 */
+		update_nohz_rq_clock(busiest);
+		clock_updated = 1;
+
 		double_rq_unlock(env.dst_rq, busiest);
 		local_irq_restore(flags);
 
@@ -4935,6 +4945,13 @@ more_balance:
 				busiest->active_balance = 1;
 				busiest->push_cpu = this_cpu;
 				active_balance = 1;
+				/*
+				 * active_load_balance_cpu_stop may end up calling
+				 * can_migrate_task() which requires an uptodate
+				 * value of the rq clock.
+				 */
+				if (!clock_updated)
+					update_nohz_rq_clock(busiest);
 			}
 			raw_spin_unlock_irqrestore(&busiest->lock, flags);
 
-- 
1.7.5.4

