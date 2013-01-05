Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab3AERud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:50:33 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51344 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab3AERtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:49:21 -0500
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
Subject: [PATCH tip/core/rcu 10/14] rcu: Repurpose no-CBs event tracing to future-GP events
Date: Sat,  5 Jan 2013 09:49:00 -0800
Message-Id: <1357408144-15830-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130105174844.GA14172@linux.vnet.ibm.com>
 <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-5518-0000-0000-00000A80A7E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Dyntick-idle CPUs need to be able to pre-announce their need for grace
periods.  This can be done using something similar to the mechanism used
by no-CB CPUs to announce their need for grace periods.  This commit
moves in this direction by renaming the no-CBs grace-period event tracing
to suit the new future-grace-period needs.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |   16 +++++-----
 kernel/rcutree_plugin.h    |   62 ++++++++++++++++++++++---------------------
 2 files changed, 40 insertions(+), 38 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index ef0bf31..0dc0177 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -72,10 +72,10 @@ TRACE_EVENT(rcu_grace_period,
 );
 
 /*
- * Tracepoint for no-callbacks grace-period events.  The caller should
- * pull the data from the rcu_node structure, other than rcuname, which
- * comes from the rcu_state structure, and event, which is one of the
- * following:
+ * Tracepoint for future grace-period events, including those for no-callbacks
+ * CPUs.  The caller should pull the data from the rcu_node structure,
+ * other than rcuname, which comes from the rcu_state structure, and event,
+ * which is one of the following:
  *
  * "Startleaf": Request a nocb grace period based on leaf-node data.
  * "Startedleaf": Leaf-node start proved sufficient.
@@ -87,7 +87,7 @@ TRACE_EVENT(rcu_grace_period,
  * "Cleanup": Clean up rcu_node structure after previous GP.
  * "CleanupMore": Clean up, and another no-CB GP is needed.
  */
-TRACE_EVENT(rcu_nocb_grace_period,
+TRACE_EVENT(rcu_future_grace_period,
 
 	TP_PROTO(char *rcuname, unsigned long gpnum, unsigned long completed,
 		 unsigned long c, u8 level, int grplo, int grphi,
@@ -645,9 +645,9 @@ TRACE_EVENT(rcu_barrier,
 #define trace_rcu_grace_period(rcuname, gpnum, gpevent) do { } while (0)
 #define trace_rcu_grace_period_init(rcuname, gpnum, level, grplo, grphi, \
 				    qsmask) do { } while (0)
-#define trace_rcu_nocb_grace_period(rcuname, gpnum, completed, c, \
-				    level, grplo, grphi, event) \
-				    do { } while (0)
+#define trace_rcu_future_grace_period(rcuname, gpnum, completed, c, \
+				      level, grplo, grphi, event) \
+				      do { } while (0)
 #define trace_rcu_preempt_task(rcuname, pid, gpnum) do { } while (0)
 #define trace_rcu_unlock_preempted_task(rcuname, gpnum, pid) do { } while (0)
 #define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, \
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 9371bdd..d09acdf 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2073,9 +2073,9 @@ static int rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 	wake_up_all(&rnp->nocb_gp_wq[c & 0x1]);
 	rnp->n_nocb_gp_requests[c & 0x1] = 0;
 	needmore = rnp->n_nocb_gp_requests[(c + 1) & 0x1];
-	trace_rcu_nocb_grace_period(rsp->name, rnp->gpnum, rnp->completed,
-				    c, rnp->level, rnp->grplo, rnp->grphi,
-				    needmore ? "CleanupMore" : "Cleanup");
+	trace_rcu_future_grace_period(rsp->name, rnp->gpnum, rnp->completed,
+				      c, rnp->level, rnp->grplo, rnp->grphi,
+				      needmore ? "CleanupMore" : "Cleanup");
 	return needmore;
 }
 
@@ -2222,9 +2222,9 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 
 	/* Count our request for a grace period. */
 	rnp->n_nocb_gp_requests[c & 0x1]++;
-	trace_rcu_nocb_grace_period(rdp->rsp->name, rnp->gpnum, rnp->completed,
-				    c, rnp->level, rnp->grplo, rnp->grphi,
-				    "Startleaf");
+	trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
+				      rnp->completed, c, rnp->level,
+				      rnp->grplo, rnp->grphi, "Startleaf");
 
 	if (rnp->gpnum != rnp->completed) {
 
@@ -2233,10 +2233,10 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 		 * is in progress, so we are done.  When this grace
 		 * period ends, our request will be acted upon.
 		 */
-		trace_rcu_nocb_grace_period(rdp->rsp->name,
-					    rnp->gpnum, rnp->completed, c,
-					    rnp->level, rnp->grplo, rnp->grphi,
-					    "Startedleaf");
+		trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
+					      rnp->completed, c, rnp->level,
+					      rnp->grplo, rnp->grphi,
+					      "Startedleaf");
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	} else {
@@ -2248,11 +2248,12 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 		if (rnp != rnp_root)
 			raw_spin_lock(&rnp_root->lock); /* irqs disabled. */
 		if (rnp_root->gpnum != rnp_root->completed) {
-			trace_rcu_nocb_grace_period(rdp->rsp->name,
-						    rnp->gpnum, rnp->completed,
-						    c, rnp->level,
-						    rnp->grplo, rnp->grphi,
-						    "Startedleafroot");
+			trace_rcu_future_grace_period(rdp->rsp->name,
+						      rnp->gpnum,
+						      rnp->completed,
+						      c, rnp->level,
+						      rnp->grplo, rnp->grphi,
+						      "Startedleafroot");
 			raw_spin_unlock(&rnp_root->lock); /* irqs disabled. */
 		} else {
 
@@ -2268,11 +2269,12 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 			c = rnp_root->completed + 1;
 			rnp->n_nocb_gp_requests[c & 0x1]++;
 			rnp_root->n_nocb_gp_requests[c & 0x1]++;
-			trace_rcu_nocb_grace_period(rdp->rsp->name,
-						    rnp->gpnum, rnp->completed,
-						    c, rnp->level,
-						    rnp->grplo, rnp->grphi,
-						    "Startedroot");
+			trace_rcu_future_grace_period(rdp->rsp->name,
+						      rnp->gpnum,
+						      rnp->completed,
+						      c, rnp->level,
+						      rnp->grplo, rnp->grphi,
+						      "Startedroot");
 			local_save_flags(flags1);
 			rcu_start_gp(rdp->rsp, flags1); /* Rlses ->lock. */
 		}
@@ -2288,9 +2290,9 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 	 * Wait for the grace period.  Do so interruptibly to avoid messing
 	 * up the load average.
 	 */
-	trace_rcu_nocb_grace_period(rdp->rsp->name, rnp->gpnum, rnp->completed,
-				    c, rnp->level, rnp->grplo, rnp->grphi,
-				    "StartWait");
+	trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
+				      rnp->completed, c, rnp->level,
+				      rnp->grplo, rnp->grphi, "StartWait");
 	for (;;) {
 		wait_event_interruptible(
 			rnp->nocb_gp_wq[c & 0x1],
@@ -2298,14 +2300,14 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 		if (likely(d))
 			break;
 		flush_signals(current);
-		trace_rcu_nocb_grace_period(rdp->rsp->name,
-					    rnp->gpnum, rnp->completed, c,
-					    rnp->level, rnp->grplo, rnp->grphi,
-					    "ResumeWait");
+		trace_rcu_future_grace_period(rdp->rsp->name,
+					      rnp->gpnum, rnp->completed, c,
+					      rnp->level, rnp->grplo,
+					      rnp->grphi, "ResumeWait");
 	}
-	trace_rcu_nocb_grace_period(rdp->rsp->name, rnp->gpnum, rnp->completed,
-				    c, rnp->level, rnp->grplo, rnp->grphi,
-				    "EndWait");
+	trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
+				      rnp->completed, c, rnp->level,
+				      rnp->grplo, rnp->grphi, "EndWait");
 	smp_mb(); /* Ensure that CB invocation happens after GP end. */
 }
 
-- 
1.7.8

