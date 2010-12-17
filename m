Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab0LQU5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:57:01 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33725 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224Ab0LQUzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:55:10 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH RFC tip/core/rcu 15/20] rcu: Keep gpnum and completed fields synchronized
Date: Fri, 17 Dec 2010 12:54:46 -0800
Message-Id: <1292619291-2468-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20101217205433.GA10199@linux.vnet.ibm.com>
References: <20101217205433.GA10199@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

When a CPU that was in an extended quiescent state wakes
up and catches up with grace periods that remote CPUs
completed on its behalf, we update the completed field
but not the gpnum that keeps a stale value of a backward
grace period ID.

Later, note_new_gpnum() will interpret the shift between
the local CPU and the node grace period ID as some new grace
period to handle and will then start to hunt quiescent state.

But if every grace periods have already been completed, this
interpretation becomes broken. And we'll be stuck in clusters
of spurious softirqs because rcu_report_qs_rdp() will make
this broken state run into infinite loop.

The solution, as suggested by Lai Jiangshan, is to ensure that
the gpnum and completed fields are well synchronized when we catch
up with completed grace periods on their behalf by other cpus.
This way we won't start noting spurious new grace periods.

Suggested-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 916f42b..8105271 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -680,6 +680,15 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 		rdp->completed = rnp->completed;
 
 		/*
+		 * If we were in an extended quiescent state, we may have
+		 * missed some grace periods that others CPUs took care on
+		 * our behalf. Catch up with this state to avoid noting
+		 * spurious new grace periods.
+		 */
+		if (rdp->completed > rdp->gpnum)
+			rdp->gpnum = rdp->completed;
+
+		/*
 		 * If another CPU handled our extended quiescent states and
 		 * we have no more grace period to complete yet, then stop
 		 * chasing quiescent states.
-- 
1.7.3.2

