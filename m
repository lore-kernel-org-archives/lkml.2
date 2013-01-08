Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab3AHCJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:09:22 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:34184 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab3AHCJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:09:18 -0500
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
Subject: [PATCH 15/33] sched: Update rq clock on tickless CPUs before calling check_preempt_curr()
Date: Tue,  8 Jan 2013 03:08:15 +0100
Message-Id: <1357610913-1080-16-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_preempt_wakeup() of fair class needs an uptodate sched clock
value to update runtime stats of the current task.

When a task is woken up, activate_task() is usually called right before
ttwu_do_wakeup() unless the task is already in the runqueue. In this
case we need to update the rq clock manually in case the CPU runs
tickless because ttwu_do_wakeup() calls check_preempt_wakeup().

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
 kernel/sched/core.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2fcbb03..3c1a806 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1346,6 +1346,12 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 
 	rq = __task_rq_lock(p);
 	if (p->on_rq) {
+		/*
+		 * Ensure check_preempt_curr() won't deal with a stale value
+		 * of rq clock if the CPU is tickless. BTW do we actually need
+		 * check_preempt_curr() to be called here?
+		 */
+		update_nohz_rq_clock(rq);
 		ttwu_do_wakeup(rq, p, wake_flags);
 		ret = 1;
 	}
@@ -1523,8 +1529,17 @@ static void try_to_wake_up_local(struct task_struct *p)
 	if (!(p->state & TASK_NORMAL))
 		goto out;
 
-	if (!p->on_rq)
+	if (!p->on_rq) {
 		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
+	} else {
+		/*
+		 * Even if the task is on the runqueue we still
+		 * need to ensure check_preempt_curr() won't
+		 * deal with a stale rq clock value on a tickless
+		 * CPU
+		 */
+		update_nohz_rq_clock(rq);
+	}
 
 	ttwu_do_wakeup(rq, p, 0);
 	ttwu_stat(p, smp_processor_id(), 0);
-- 
1.7.5.4

