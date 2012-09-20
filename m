Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab2ITSxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:53:34 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44362 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab2ITStI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:49:08 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 18/23] rcu: Adjust for unconditional ->completed assignment
Date: Thu, 20 Sep 2012 11:48:14 -0700
Message-Id: <1348166900-18716-18-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120920184751.GA18657@linux.vnet.ibm.com>
 <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
x-cbid: 12092018-5806-0000-0000-000019D02DFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Now that the rcu_node structures' ->completed fields are unconditionally
assigned at grace-period cleanup time, they should already have the
correct value for the new grace period at grace-period initialization
time.  This commit therefore inserts a WARN_ON_ONCE() to verify this
invariant.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5cb003d..71ae31b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1078,6 +1078,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
+		WARN_ON_ONCE(rnp->completed != rsp->completed);
 		rnp->completed = rsp->completed;
 		if (rnp == rdp->mynode)
 			rcu_start_gp_per_cpu(rsp, rnp, rdp);
@@ -2775,7 +2776,8 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 			raw_spin_lock_init(&rnp->fqslock);
 			lockdep_set_class_and_name(&rnp->fqslock,
 						   &rcu_fqs_class[i], fqs[i]);
-			rnp->gpnum = 0;
+			rnp->gpnum = rsp->gpnum;
+			rnp->completed = rsp->completed;
 			rnp->qsmask = 0;
 			rnp->qsmaskinit = 0;
 			rnp->grplo = j * cpustride;
-- 
1.7.8

