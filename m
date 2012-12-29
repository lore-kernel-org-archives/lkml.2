Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2L2Qqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 11:46:36 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44985 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2L2Qnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 11:43:50 -0500
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
Subject: [PATCH 16/27] sched: Update clock of nohz busiest rq before balancing
Date: Sat, 29 Dec 2012 17:42:55 +0100
Message-Id: <1356799386-4212-17-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
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
index 3d65ac7..e78d81104 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5002,6 +5002,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 {
 	int ld_moved, cur_ld_moved, active_balance = 0;
 	int lb_iterations, max_lb_iterations;
+	int clock_updated;
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
@@ -5045,6 +5046,7 @@ redo:
 
 	ld_moved = 0;
 	lb_iterations = 1;
+	clock_updated = 0;
 	if (busiest->nr_running > 1) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
@@ -5068,6 +5070,14 @@ more_balance:
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
 
@@ -5163,6 +5173,13 @@ more_balance:
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

