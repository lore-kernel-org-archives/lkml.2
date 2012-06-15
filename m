Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab2FOVGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:06:47 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60890 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab2FOVGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:06:41 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/15] rcu: Remove unneeded __rcu_process_callbacks() argument
Date: Fri, 15 Jun 2012 14:06:07 -0700
Message-Id: <1339794370-28119-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061521-7606-0000-0000-000001295848
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

With the advent of __this_cpu_ptr(), it is no longer necessary to pass
both the rcu_state and rcu_data structures into __rcu_process_callbacks().
This commit therefore computes the rcu_data pointer from the rcu_state
pointer within __rcu_process_callbacks() so that callers can pass in
only the pointer to the rcu_state structure.  This paves the way for
linking the rcu_state structures together and iterating over them.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    8 ++++----
 kernel/rcutree_plugin.h |    3 +--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ebd5223..bd4e41c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1785,9 +1785,10 @@ unlock_fqs_ret:
  * whom the rdp belongs.
  */
 static void
-__rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
+__rcu_process_callbacks(struct rcu_state *rsp)
 {
 	unsigned long flags;
+	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
 
 	WARN_ON_ONCE(rdp->beenonline == 0);
 
@@ -1824,9 +1825,8 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	trace_rcu_utilization("Start RCU core");
-	__rcu_process_callbacks(&rcu_sched_state,
-				&__get_cpu_var(rcu_sched_data));
-	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
+	__rcu_process_callbacks(&rcu_sched_state);
+	__rcu_process_callbacks(&rcu_bh_state);
 	rcu_preempt_process_callbacks();
 	trace_rcu_utilization("End RCU core");
 }
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 6888706..686cb55 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -687,8 +687,7 @@ static void rcu_preempt_check_callbacks(int cpu)
  */
 static void rcu_preempt_process_callbacks(void)
 {
-	__rcu_process_callbacks(&rcu_preempt_state,
-				&__get_cpu_var(rcu_preempt_data));
+	__rcu_process_callbacks(&rcu_preempt_state);
 }
 
 #ifdef CONFIG_RCU_BOOST
-- 
1.7.8

