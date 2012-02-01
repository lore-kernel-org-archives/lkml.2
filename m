Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab2BATn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:43:58 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41202 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab2BATny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:43:54 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 17/41] rcu: Remove single-rcu_node optimization in rcu_start_gp()
Date: Wed,  1 Feb 2012 11:41:35 -0800
Message-Id: <1328125319-5205-17-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-1976-0000-0000-00000A09AD82
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The grace-period initialization sequence in rcu_start_gp() has a special
case for systems where the rcu_node tree is a single rcu_node structure.
This made sense some years ago when systems were smaller and up to 64
CPUs could share a single rcu_node structure, but now that large systems
are common and a given leaf rcu_node structure can support only 16 CPUs
(due to lock contention on the rcu_node's ->lock field), this optimization
is almost never taken.  And even the small mobile platforms that might
make use of it might rather have the kernel text reduction.

Therefore, this commit removes the check for single-rcu_node trees.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ee2009d..38d143b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -984,26 +984,8 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	rsp->fqs_state = RCU_GP_INIT; /* Hold off force_quiescent_state. */
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	record_gp_stall_check_time(rsp);
-
-	/* Special-case the common single-level case. */
-	if (NUM_RCU_NODES == 1) {
-		rcu_preempt_check_blocked_tasks(rnp);
-		rnp->qsmask = rnp->qsmaskinit;
-		rnp->gpnum = rsp->gpnum;
-		rnp->completed = rsp->completed;
-		rsp->fqs_state = RCU_SIGNAL_INIT; /* force_quiescent_state OK */
-		rcu_start_gp_per_cpu(rsp, rnp, rdp);
-		rcu_preempt_boost_start_gp(rnp);
-		trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
-					    rnp->level, rnp->grplo,
-					    rnp->grphi, rnp->qsmask);
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		return;
-	}
-
 	raw_spin_unlock(&rnp->lock);  /* leave irqs disabled. */
 
-
 	/* Exclude any concurrent CPU-hotplug operations. */
 	raw_spin_lock(&rsp->onofflock);  /* irqs already disabled. */
 
-- 
1.7.8

