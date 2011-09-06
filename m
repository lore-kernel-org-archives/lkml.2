Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab1IGGYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:24:40 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38194 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757Ab1IGGVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:04 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 40/55] rcu: Avoid having just-onlined CPU resched itself when RCU is idle
Date: Tue,  6 Sep 2011 11:00:34 -0700
Message-Id: <1315332049-2604-40-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUs set rdp->qs_pending when coming online to resolve races with
grace-period start.  However, this means that if RCU is idle, the
just-onlined CPU might needlessly send itself resched IPIs.  Adjust
the online-CPU initialization to avoid this, and also to correctly
cause the CPU to respond to the current grace period if needed.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ade7883..c95fa89 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1911,8 +1911,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 
 	/* Set up local state, ensuring consistent view of global state. */
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	rdp->passed_quiesce = 0;  /* We could be racing with new GP, */
-	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
 	rdp->beenonline = 1;	 /* We have now been online. */
 	rdp->preemptible = preemptible;
 	rdp->qlen_last_fqs_check = 0;
@@ -1937,8 +1935,15 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 		rnp->qsmaskinit |= mask;
 		mask = rnp->grpmask;
 		if (rnp == rdp->mynode) {
-			rdp->gpnum = rnp->completed; /* if GP in progress... */
+			/*
+			 * If there is a grace period in progress, we will
+			 * set up to wait for it next time we run the
+			 * RCU core code.
+			 */
+			rdp->gpnum = rnp->completed;
 			rdp->completed = rnp->completed;
+			rdp->passed_quiesce = 0;
+			rdp->qs_pending = 0;
 			rdp->passed_quiesce_gpnum = rnp->gpnum - 1;
 			trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpuonl");
 		}
-- 
1.7.3.2

