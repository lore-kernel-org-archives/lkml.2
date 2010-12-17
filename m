Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0LQU4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:56:44 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33743 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab0LQUzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:55:12 -0500
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
Subject: [PATCH RFC tip/core/rcu 14/20] rcu: Stop chasing QS if another CPU did it for us
Date: Fri, 17 Dec 2010 12:54:45 -0800
Message-Id: <1292619291-2468-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20101217205433.GA10199@linux.vnet.ibm.com>
References: <20101217205433.GA10199@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

When a CPU is idle and others CPUs handled its extended
quiescent state to complete grace periods on its behalf,
it will catch up with completed grace periods numbers
when it wakes up.

But at this point there might be no more grace period to
complete, but still the woken CPU always keeps its stale
qs_pending value and will then continue to chase quiescent
states even if its not needed anymore.

This results in clusters of spurious softirqs until a new
real grace period is started. Because if we continue to
chase quiescent states but we have completed every grace
periods, rcu_report_qs_rdp() is puzzled and makes that
state run into infinite loops.

As suggested by Lai Jiangshan, just reset qs_pending if
someone completed every grace periods on our behalf.

Suggested-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 120820f..916f42b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -678,6 +678,14 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 
 		/* Remember that we saw this grace-period completion. */
 		rdp->completed = rnp->completed;
+
+		/*
+		 * If another CPU handled our extended quiescent states and
+		 * we have no more grace period to complete yet, then stop
+		 * chasing quiescent states.
+		 */
+		if (rdp->completed == rnp->gpnum)
+			rdp->qs_pending = 0;
 	}
 }
 
-- 
1.7.3.2

