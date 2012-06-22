Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762379Ab2FVPpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:45:08 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54278 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2FVPpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:45:05 -0400
Date: Fri, 22 Jun 2012 08:37:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/urgent] rcu: Stop rcu_do_batch() from multiplexing
 the "count" variable
Message-ID: <20120622153738.GA6800@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-6148-0000-0000-000006F61238
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b1420f1c (Make rcu_barrier() less disruptive) rearranged the
code in rcu_do_batch(), moving the ->qlen manipulation to follow
the requeueing of the callbacks.  Unfortunately, this rearrangement
clobbered the value of the "count" local variable before the value
of rdp->qlen was adjusted, resulting in the value of rdp->qlen being
inaccurate.  This commit therefore introduces an index variable "i",
avoiding the inadvertent multiplexing.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 2f34d02..2001d38 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1593,7 +1593,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list, **tail;
-	int bl, count, count_lazy;
+	int bl, count, count_lazy, i;
 
 	/* If no callbacks are ready, just return.*/
 	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
@@ -1616,9 +1616,9 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
 	*rdp->nxttail[RCU_DONE_TAIL] = NULL;
 	tail = rdp->nxttail[RCU_DONE_TAIL];
-	for (count = RCU_NEXT_SIZE - 1; count >= 0; count--)
-		if (rdp->nxttail[count] == rdp->nxttail[RCU_DONE_TAIL])
-			rdp->nxttail[count] = &rdp->nxtlist;
+	for (i = RCU_NEXT_SIZE - 1; i >= 0; i--)
+		if (rdp->nxttail[i] == rdp->nxttail[RCU_DONE_TAIL])
+			rdp->nxttail[i] = &rdp->nxtlist;
 	local_irq_restore(flags);
 
 	/* Invoke callbacks. */
@@ -1646,9 +1646,9 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	if (list != NULL) {
 		*tail = rdp->nxtlist;
 		rdp->nxtlist = list;
-		for (count = 0; count < RCU_NEXT_SIZE; count++)
-			if (&rdp->nxtlist == rdp->nxttail[count])
-				rdp->nxttail[count] = tail;
+		for (i = 0; i < RCU_NEXT_SIZE; i++)
+			if (&rdp->nxtlist == rdp->nxttail[i])
+				rdp->nxttail[i] = tail;
 			else
 				break;
 	}

