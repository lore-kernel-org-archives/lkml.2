Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab3AERuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:50:21 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36373 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab3AERtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:49:23 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 14/14] rcu: Make rcu_accelerate_cbs() note need for future grace periods
Date: Sat,  5 Jan 2013 09:49:04 -0800
Message-Id: <1357408144-15830-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130105174844.GA14172@linux.vnet.ibm.com>
 <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-2398-0000-0000-00000FBC8433
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Now that rcu_start_future_gp() has been abstracted from
rcu_nocb_wait_gp(), rcu_accelerate_cbs() can invoke rcu_start_future_gp()
so as to register the need for any future grace periods needed by a
CPU about to enter dyntick-idle mode.  This commit makes this change.
Note that some refactoring of rcu_start_gp() is carried out to avoid
recursion and subsequent self-deadlocks.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   50 ++++++++++++++++++++++++++++++++------------------
 1 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index bd42feb..f7399b4 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -230,7 +230,8 @@ static ulong jiffies_till_next_fqs = RCU_JIFFIES_TILL_FORCE_QS;
 module_param(jiffies_till_first_fqs, ulong, 0644);
 module_param(jiffies_till_next_fqs, ulong, 0644);
 
-static void rcu_start_gp(struct rcu_state *rsp);
+static void rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
+				  struct rcu_data *rdp);
 static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *));
 static void force_quiescent_state(struct rcu_state *rsp);
 static int rcu_pending(int cpu);
@@ -1200,7 +1201,7 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp)
 		trace_rcu_future_gp(rnp, rdp, c, "Startedleafroot");
 	} else {
 		trace_rcu_future_gp(rnp, rdp, c, "Startedroot");
-		rcu_start_gp(rdp->rsp);
+		rcu_start_gp_advanced(rdp->rsp, rnp_root, rdp);
 	}
 unlock_out:
 	if (rnp != rnp_root)
@@ -1286,6 +1287,8 @@ static void rcu_accelerate_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
 		rdp->nxttail[i] = rdp->nxttail[RCU_NEXT_TAIL];
 		rdp->nxtcompleted[i] = c;
 	}
+	/* Record any needed additional grace periods. */
+	rcu_start_future_gp(rnp, rdp);
 
 	/* Trace depending on how much we were able to accelerate. */
 	if (!*rdp->nxttail[RCU_WAIT_TAIL])
@@ -1647,20 +1650,9 @@ static int __noreturn rcu_gp_kthread(void *arg)
  * quiescent state.
  */
 static void
-rcu_start_gp(struct rcu_state *rsp)
+rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
+		      struct rcu_data *rdp)
 {
-	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
-	struct rcu_node *rnp = rcu_get_root(rsp);
-
-	/*
-	 * If there is no grace period in progress right now, any
-	 * callbacks we have up to this point will be satisfied by the
-	 * next grace period.  Also, advancing the callbacks reduces the
-	 * probability of false positives from cpu_needs_another_gp()
-	 * resulting in pointless grace periods.  So, advance callbacks!
-	 */
-	rcu_advance_cbs(rsp, rnp, rdp);
-
 	if (!rsp->gp_kthread || !cpu_needs_another_gp(rsp, rdp)) {
 		/*
 		 * Either we have not yet spawned the grace-period
@@ -1672,14 +1664,36 @@ rcu_start_gp(struct rcu_state *rsp)
 	}
 	rsp->gp_flags = RCU_GP_FLAG_INIT;
 
-	/* Ensure that CPU is aware of completion of last grace period. */
-	__rcu_process_gp_end(rsp, rdp->mynode, rdp);
-
 	/* Wake up rcu_gp_kthread() to start the grace period. */
 	wake_up(&rsp->gp_wq);
 }
 
 /*
+ * Similar to rcu_start_gp_advanced(), but also advance the calling CPU's
+ * callbacks.  Note that rcu_start_gp_advanced() cannot do this because it
+ * is invoked indirectly from rcu_advance_cbs(), which would result in
+ * endless recursion -- or would do so if it wasn't for the self-deadlock
+ * that is encountered beforehand.
+ */
+static void
+rcu_start_gp(struct rcu_state *rsp)
+{
+	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	/*
+	 * If there is no grace period in progress right now, any
+	 * callbacks we have up to this point will be satisfied by the
+	 * next grace period.  Also, advancing the callbacks reduces the
+	 * probability of false positives from cpu_needs_another_gp()
+	 * resulting in pointless grace periods.  So, advance callbacks
+	 * then start the grace period!
+	 */
+	rcu_advance_cbs(rsp, rnp, rdp);
+	rcu_start_gp_advanced(rsp, rnp, rdp);
+}
+
+/*
  * Report a full set of quiescent states to the specified rcu_state
  * data structure.  This involves cleaning up after the prior grace
  * period and letting rcu_start_gp() start up the next grace period
-- 
1.7.8

