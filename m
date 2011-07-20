Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab1GTASf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 20:18:35 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38070 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1GTASd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 20:18:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, greearb@candelatech.com, edt@aei.ca,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 1/7] rcu: decrease rcu_report_exp_rnp coupling with scheduler
Date: Tue, 19 Jul 2011 17:18:17 -0700
Message-Id: <1311121103-16978-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110720001738.GA16369@linux.vnet.ibm.com>
References: <20110720001738.GA16369@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PREEMPT_RCU read-side critical sections blocking an expedited grace
period invoke rcu_report_exp_rnp().  When the last such critical section
has completed, rcu_report_exp_rnp() invokes the scheduler to wake up the
task that invoked synchronize_rcu_expedited() -- needlessly holding the
root rcu_node structure's lock while doing so, thus needlessly providing
a way for RCU and the scheduler to deadlock.

This commit therefore releases the root rcu_node structure's lock before
calling wake_up().

Reported-by: Ed Tomlinson <edt@aei.ca>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 75113cb..94a674e 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -696,8 +696,10 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	for (;;) {
 		if (!sync_rcu_preempt_exp_done(rnp))
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			break;
 		if (rnp->parent == NULL) {
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			wake_up(&sync_rcu_preempt_exp_wq);
 			break;
 		}
@@ -707,7 +709,6 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 		raw_spin_lock(&rnp->lock); /* irqs already disabled */
 		rnp->expmask &= ~mask;
 	}
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
-- 
1.7.3.2

