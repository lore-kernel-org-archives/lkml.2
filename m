Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab2FOUQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:16:55 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34134 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886Ab2FOUNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:13:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/14] rcu: Consolidate duplicate callback-list initialization
Date: Fri, 15 Jun 2012 13:13:03 -0700
Message-Id: <1339791195-26389-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061520-7282-0000-0000-000009F3A8A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

There are a couple of open-coded initializations of the rcu_data
structure's RCU callback list.  This commit therefore consolidates
them into a new init_callback_list() function.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0f04480..d938671 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -936,6 +936,18 @@ check_for_new_grace_period(struct rcu_state *rsp, struct rcu_data *rdp)
 }
 
 /*
+ * Initialize the specified rcu_data structure's callback list to empty.
+ */
+static void init_callback_list(struct rcu_data *rdp)
+{
+	int i;
+
+	rdp->nxtlist = NULL;
+	for (i = 0; i < RCU_NEXT_SIZE; i++)
+		rdp->nxttail[i] = &rdp->nxtlist;
+}
+
+/*
  * Advance this CPU's callbacks, but only if the current grace period
  * has ended.  This may be called only from the CPU to whom the rdp
  * belongs.  In addition, the corresponding leaf rcu_node structure's
@@ -1327,8 +1339,6 @@ static void
 rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
 			  struct rcu_node *rnp, struct rcu_data *rdp)
 {
-	int i;
-
 	/*
 	 * Orphan the callbacks.  First adjust the counts.  This is safe
 	 * because ->onofflock excludes _rcu_barrier()'s adoption of
@@ -1368,9 +1378,7 @@ rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
 	}
 
 	/* Finally, initialize the rcu_data structure's list to empty.  */
-	rdp->nxtlist = NULL;
-	for (i = 0; i < RCU_NEXT_SIZE; i++)
-		rdp->nxttail[i] = &rdp->nxtlist;
+	init_callback_list(rdp);
 }
 
 /*
@@ -2404,16 +2412,13 @@ static void __init
 rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
-	int i;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Set up local state, ensuring consistent view of global state. */
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
-	rdp->nxtlist = NULL;
-	for (i = 0; i < RCU_NEXT_SIZE; i++)
-		rdp->nxttail[i] = &rdp->nxtlist;
+	init_callback_list(rdp);
 	rdp->qlen_lazy = 0;
 	rdp->qlen = 0;
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
-- 
1.7.8

