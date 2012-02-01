Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2BATvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:51:35 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42059 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813Ab2BATvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:51:33 -0500
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
Subject: [PATCH RFC tip/core/rcu 16/41] rcu: Don't make callbacks go through second full grace period
Date: Wed,  1 Feb 2012 11:41:34 -0800
Message-Id: <1328125319-5205-16-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-3534-0000-0000-0000051ACA77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

RCU's current CPU-offline code path dumps all of the outgoing CPU's
callbacks onto the RCU_NEXT_TAIL portion of the surviving CPU's
callback list.  This means that all the ready-to-invoke callbacks from
the outgoing CPU must wait for another full RCU grace period.  This was
just fine when CPU-hotplug events were rare, but there is increasing
evidence that users are planning to make increasing use of CPU hotplug.

Therefore, this commit changes the callback-dumping procedure so that
callbacks that are ready to invoke are moved to the RCU_DONE_TAIL
portion of the surviving CPU's callback list.  This avoids running
these callbacks through a second unnecessary grace period.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 03c0d5f..ee2009d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1270,24 +1270,64 @@ static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 	struct rcu_data *receive_rdp = per_cpu_ptr(rsp->rda, receive_cpu);
 	struct rcu_node *rnp = rdp->mynode; /* For dying CPU. */
 
-	/* Move callbacks to some other CPU. */
+	/* First, adjust the counts. */
+	if (rdp->nxtlist != NULL) {
+		receive_rdp->qlen_lazy += rdp->qlen_lazy;
+		receive_rdp->qlen += rdp->qlen;
+		rdp->qlen_lazy = 0;
+		rdp->qlen = 0;
+	}
+
+	/*
+	 * Next, move ready-to-invoke callbacks to be invoked on some
+	 * other CPU.  These will not be required to pass through another
+	 * grace period:  They are done, regardless of CPU.
+	 */
+	if (rdp->nxtlist != NULL &&
+	    rdp->nxttail[RCU_DONE_TAIL] != &rdp->nxtlist) {
+		struct rcu_head *oldhead;
+		struct rcu_head **oldtail;
+		struct rcu_head **newtail;
+
+		oldhead = rdp->nxtlist;
+		oldtail = receive_rdp->nxttail[RCU_DONE_TAIL];
+		rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
+		*rdp->nxttail[RCU_DONE_TAIL] = *oldtail;
+		*receive_rdp->nxttail[RCU_DONE_TAIL] = oldhead;
+		newtail = rdp->nxttail[RCU_DONE_TAIL];
+		for (i = RCU_DONE_TAIL; i < RCU_NEXT_SIZE; i++) {
+			if (receive_rdp->nxttail[i] == oldtail)
+				receive_rdp->nxttail[i] = newtail;
+			if (rdp->nxttail[i] == newtail)
+				rdp->nxttail[i] = &rdp->nxtlist;
+		}
+	}
+
+	/*
+	 * Finally, put the rest of the callbacks at the end of the list.
+	 * The ones that made it partway through get to start over:  We
+	 * cannot assume that grace periods are synchronized across CPUs.
+	 * (We could splice RCU_WAIT_TAIL into RCU_NEXT_READY_TAIL, but
+	 * this does not seem compelling.  Not yet, anyway.)
+	 */
 	if (rdp->nxtlist != NULL) {
 		*receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
 		receive_rdp->nxttail[RCU_NEXT_TAIL] =
 				rdp->nxttail[RCU_NEXT_TAIL];
-		receive_rdp->qlen_lazy += rdp->qlen_lazy;
-		receive_rdp->qlen += rdp->qlen;
 		receive_rdp->n_cbs_adopted += rdp->qlen;
 		rdp->n_cbs_orphaned += rdp->qlen;
 
 		rdp->nxtlist = NULL;
 		for (i = 0; i < RCU_NEXT_SIZE; i++)
 			rdp->nxttail[i] = &rdp->nxtlist;
-		rdp->qlen_lazy = 0;
-		rdp->qlen = 0;
 	}
 
-	/* Record a quiescent state for the dying CPU. */
+	/*
+	 * Record a quiescent state for the dying CPU.  This is safe
+	 * only because we have already cleared out the callbacks.
+	 * (Otherwise, the RCU core might try to schedule the invocation
+	 * of callbacks on this now-offline CPU, which would be bad.)
+	 */
 	mask = rdp->grpmask;	/* rnp->grplo is constant. */
 	trace_rcu_grace_period(rsp->name,
 			       rnp->gpnum + 1 - !!(rnp->qsmask & mask),
-- 
1.7.8

