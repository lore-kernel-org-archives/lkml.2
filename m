Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab0LQU4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:56:21 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45605 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240Ab0LQUzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:55:13 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 16/20] rcu: fine-tune grace-period begin/end checks
Date: Fri, 17 Dec 2010 12:54:47 -0800
Message-Id: <1292619291-2468-16-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20101217205433.GA10199@linux.vnet.ibm.com>
References: <20101217205433.GA10199@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the CPU's bit in rnp->qsmask to determine whether or not the CPU
should try to report a quiescent state.  Handle overflow in the check
for rdp->gpnum having fallen behind.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 8105271..c39ec5b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -617,9 +617,17 @@ static void __init check_cpu_stall_init(void)
 static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
 {
 	if (rdp->gpnum != rnp->gpnum) {
-		rdp->qs_pending = 1;
-		rdp->passed_quiesc = 0;
+		/*
+		 * If the current grace period is waiting for this CPU,
+		 * set up to detect a quiescent state, otherwise don't
+		 * go looking for one.
+		 */
 		rdp->gpnum = rnp->gpnum;
+		if (rnp->qsmask & rdp->grpmask) {
+			rdp->qs_pending = 1;
+			rdp->passed_quiesc = 0;
+		} else
+			rdp->qs_pending = 0;
 	}
 }
 
@@ -681,19 +689,20 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 
 		/*
 		 * If we were in an extended quiescent state, we may have
-		 * missed some grace periods that others CPUs took care on
+		 * missed some grace periods that others CPUs handled on
 		 * our behalf. Catch up with this state to avoid noting
-		 * spurious new grace periods.
+		 * spurious new grace periods.  If another grace period
+		 * has started, then rnp->gpnum will have advanced, so
+		 * we will detect this later on.
 		 */
-		if (rdp->completed > rdp->gpnum)
+		if (ULONG_CMP_LT(rdp->gpnum, rdp->completed))
 			rdp->gpnum = rdp->completed;
 
 		/*
-		 * If another CPU handled our extended quiescent states and
-		 * we have no more grace period to complete yet, then stop
-		 * chasing quiescent states.
+		 * If RCU does not need a quiescent state from this CPU,
+		 * then make sure that this CPU doesn't go looking for one.
 		 */
-		if (rdp->completed == rnp->gpnum)
+		if ((rnp->qsmask & rdp->grpmask) == 0)
 			rdp->qs_pending = 0;
 	}
 }
-- 
1.7.3.2

