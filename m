Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab2ITStg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:49:36 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33875 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab2ITStd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:49:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/23] rcu: Allow RCU grace-period cleanup to be preempted
Date: Thu, 20 Sep 2012 11:48:01 -0700
Message-Id: <1348166900-18716-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120920184751.GA18657@linux.vnet.ibm.com>
 <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092018-2398-0000-0000-00000B351899
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00175813; UDB=6.00039806; UTC=2012-09-20
 18:49:29
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

Updated to replace uses of spin_lock_irqsave() with spin_lock_irq(), as
suggested by Peter Zijlstra.

Reported-by: Mike Galbraith <mgalbraith@suse.de>
Reported-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3cd18ea..fa11e54 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1128,7 +1128,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			flush_signals(current);
 		}
 
-		raw_spin_lock_irqsave(&rnp->lock, flags);
+		raw_spin_lock_irq(&rnp->lock);
 		gp_duration = jiffies - rsp->gp_start;
 		if (gp_duration > rsp->gp_max)
 			rsp->gp_max = gp_duration;
@@ -1149,7 +1149,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 		 * completed.
 		 */
 		if (*rdp->nxttail[RCU_WAIT_TAIL] == NULL) {
-			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			raw_spin_unlock_irq(&rnp->lock);
 
 			/*
 			 * Propagate new ->completed value to rcu_node
@@ -1158,14 +1158,13 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			 * to process their callbacks.
 			 */
 			rcu_for_each_node_breadth_first(rsp, rnp) {
-				/* irqs already disabled. */
-				raw_spin_lock(&rnp->lock);
+				raw_spin_lock_irq(&rnp->lock);
 				rnp->completed = rsp->gpnum;
-				/* irqs remain disabled. */
-				raw_spin_unlock(&rnp->lock);
+				raw_spin_unlock_irq(&rnp->lock);
+				cond_resched();
 			}
 			rnp = rcu_get_root(rsp);
-			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+			raw_spin_lock_irq(&rnp->lock);
 		}
 
 		rsp->completed = rsp->gpnum; /* Declare grace period done. */
@@ -1173,7 +1172,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 		rsp->fqs_state = RCU_GP_IDLE;
 		if (cpu_needs_another_gp(rsp, rdp))
 			rsp->gp_flags = 1;
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irq(&rnp->lock);
 	}
 }
 
-- 
1.7.8

