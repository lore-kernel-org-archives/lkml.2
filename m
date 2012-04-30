Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab2D3X6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 19:58:13 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:33065 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab2D3X6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 19:58:09 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 34/41] sched: Update clock of nohz busiest rq before balancing
Date: Tue,  1 May 2012 01:55:08 +0200
Message-Id: <1335830115-14335-35-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
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
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/fair.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 42a87d7..eff80e0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4455,6 +4455,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			int *balance)
 {
 	int ld_moved, lb_flags = 0, active_balance = 0;
+	int clock_updated;
 	struct sched_group *group;
 	unsigned long imbalance;
 	struct rq *busiest;
@@ -4488,6 +4489,7 @@ redo:
 	schedstat_add(sd, lb_imbalance[idle], imbalance);
 
 	ld_moved = 0;
+	clock_updated = 0;
 	if (busiest->nr_running > 1) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
@@ -4498,6 +4500,12 @@ redo:
 		lb_flags |= LBF_ALL_PINNED;
 		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
+		/*
+		 * Move tasks may end up calling can_migrate_task() which
+		 * requires an uptodate value of the rq clock.
+		 */
+		update_nohz_rq_clock(busiest);
+		clock_updated = 1;
 		ld_moved = move_tasks(this_rq, this_cpu, busiest,
 				      imbalance, sd, idle, &lb_flags);
 		double_rq_unlock(this_rq, busiest);
@@ -4563,6 +4571,13 @@ redo:
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

