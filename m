Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2ITStF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:49:05 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38823 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab2ITSs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:48:59 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/23] rcu: Prevent initialization-time quiescent-state race
Date: Thu, 20 Sep 2012 11:47:58 -0700
Message-Id: <1348166900-18716-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120920184751.GA18657@linux.vnet.ibm.com>
 <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092018-4242-0000-0000-000002F74F12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The next step in reducing RCU's grace-period initialization latency on
large systems will make this initialization preemptible.  Unfortunately,
making the grace-period initialization subject to interrupts (let alone
preemption) exposes the following race on systems whose rcu_node tree
contains more than one node:

1.	CPU 31 starts initializing the grace period, including the
    	first leaf rcu_node structures, and is then preempted.

2.	CPU 0 refers to the first leaf rcu_node structure, and notes
    	that a new grace period has started.  It passes through a
    	quiescent state shortly thereafter, and informs the RCU core
    	of this rite of passage.

3.	CPU 0 enters an RCU read-side critical section, acquiring
    	a pointer to an RCU-protected data item.

4.	CPU 31 takes an interrupt whose handler removes the data item
	referenced by CPU 0 from the data structure, and registers an
	RCU callback in order to free it.

5.	CPU 31 resumes initializing the grace period, including its
    	own rcu_node structure.  In invokes rcu_start_gp_per_cpu(),
    	which advances all callbacks, including the one registered
    	in #4 above, to be handled by the current grace period.

6.	The remaining CPUs pass through quiescent states and inform
    	the RCU core, but CPU 0 remains in its RCU read-side critical
    	section, still referencing the now-removed data item.

7.	The grace period completes and all the callbacks are invoked,
    	including the one that frees the data item that CPU 0 is still
    	referencing.  Oops!!!

One way to avoid this race is to remove grace-period acceleration from
rcu_start_gp_per_cpu().  Now, the only reason for this acceleration was
to allow CPUs bringing RCU out of idle state to have their callbacks
invoked after only one grace period, rather than the two grace periods
that would otherwise be required.  But this acceleration does not
work when RCU grace-period initialization is moved to a kthread because
the CPU posting the callback is no longer necessarily the CPU that is
initializing the resulting grace period.

This commit therefore removes this now-pointless (and soon to be dangerous)
grace-period acceleration, thus avoiding the above race.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5b4b093..0df9aaa 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1021,20 +1021,6 @@ rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 	/* Prior grace period ended, so advance callbacks for current CPU. */
 	__rcu_process_gp_end(rsp, rnp, rdp);
 
-	/*
-	 * Because this CPU just now started the new grace period, we know
-	 * that all of its callbacks will be covered by this upcoming grace
-	 * period, even the ones that were registered arbitrarily recently.
-	 * Therefore, advance all outstanding callbacks to RCU_WAIT_TAIL.
-	 *
-	 * Other CPUs cannot be sure exactly when the grace period started.
-	 * Therefore, their recently registered callbacks must pass through
-	 * an additional RCU_NEXT_READY stage, so that they will be handled
-	 * by the next RCU grace period.
-	 */
-	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-
 	/* Set state so that this CPU will detect the next quiescent state. */
 	__note_new_gpnum(rsp, rnp, rdp);
 }
-- 
1.7.8

