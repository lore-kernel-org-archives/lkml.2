Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab2H3STr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:19:47 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59459 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab2H3STp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:19:45 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/23] rcu: Allow RCU grace-period cleanup to be preempted
Date: Thu, 30 Aug 2012 11:18:19 -0700
Message-Id: <1346350718-30937-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-5806-0000-0000-000018FC3E19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

RCU grace-period cleanup is currently carried out with interrupts
disabled, which can result in excessive latency spikes on large systems
(many hundreds or thousands of CPUs).  This patch therefore makes the
RCU grace-period cleanup be preemptible, including voluntary preemption
points, which should eliminate those latency spikes.  Similar spikes from
forcing of quiescent states will be dealt with similarly by later patches.

Reported-by: Mike Galbraith <mgalbraith@suse.de>
Reported-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 9fad21c..300aba6 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1170,7 +1170,7 @@ static int rcu_gp_kthread(void *arg)
 		 * completed.
 		 */
 		if (*rdp->nxttail[RCU_WAIT_TAIL] == NULL) {
-			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 			/*
 			 * Propagate new ->completed value to rcu_node
@@ -1179,14 +1179,13 @@ static int rcu_gp_kthread(void *arg)
 			 * to process their callbacks.
 			 */
 			rcu_for_each_node_breadth_first(rsp, rnp) {
-				/* irqs already disabled. */
-				raw_spin_lock(&rnp->lock);
+				raw_spin_lock_irqsave(&rnp->lock, flags);
 				rnp->completed = rsp->gpnum;
-				/* irqs remain disabled. */
-				raw_spin_unlock(&rnp->lock);
+				raw_spin_unlock_irqrestore(&rnp->lock, flags);
+				cond_resched();
 			}
 			rnp = rcu_get_root(rsp);
-			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+			raw_spin_lock_irqsave(&rnp->lock, flags);
 		}
 
 		rsp->completed = rsp->gpnum; /* Declare grace period done. */
-- 
1.7.8

