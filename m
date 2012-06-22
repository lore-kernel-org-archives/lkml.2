Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab2FVPZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:25:31 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56337 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873Ab2FVPZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:25:29 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 21/22] rcu: Allow RCU grace-period cleanup to be preempted
Date: Fri, 22 Jun 2012 08:17:20 -0700
Message-Id: <1340378241-6458-21-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622151655.GA6249@linux.vnet.ibm.com>
 <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-5518-0000-0000-0000056D4B8D
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
index 4a3f6b0..d21c2d3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1160,7 +1160,7 @@ static int rcu_gp_kthread(void *arg)
 		 * completed.
 		 */
 		if (*rdp->nxttail[RCU_WAIT_TAIL] == NULL) {
-			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 			/*
 			 * Propagate new ->completed value to rcu_node
@@ -1169,14 +1169,13 @@ static int rcu_gp_kthread(void *arg)
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

