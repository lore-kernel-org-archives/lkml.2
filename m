Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab2H3Vre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:47:34 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40514 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab2H3Vnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:43:40 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/15] rcu: Pull TINY_RCU dyntick-idle tracing into non-idle region
Date: Thu, 30 Aug 2012 11:56:15 -0700
Message-Id: <1346352988-32444-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-4242-0000-0000-000002BA06FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Because TINY_RCU's idle detection keys directly off of the nesting
level, rather than from a separate variable as in TREE_RCU, the
TINY_RCU dyntick-idle tracing on transition to idle must happen
before the change to the nesting level.  This commit therefore makes
this change by passing the desired new value (rather than the old value)
of the nesting level in to rcu_idle_enter_common().

[ paulmck: Add fix for wrong-variable bug spotted by
  Michael Wang <wangyun@linux.vnet.ibm.com>. ]

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 547b1fe..e4163c5 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -56,24 +56,27 @@ static void __call_rcu(struct rcu_head *head,
 static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 
 /* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
-static void rcu_idle_enter_common(long long oldval)
+static void rcu_idle_enter_common(long long newval)
 {
-	if (rcu_dynticks_nesting) {
+	if (newval) {
 		RCU_TRACE(trace_rcu_dyntick("--=",
-					    oldval, rcu_dynticks_nesting));
+					    rcu_dynticks_nesting, newval));
+		rcu_dynticks_nesting = newval;
 		return;
 	}
-	RCU_TRACE(trace_rcu_dyntick("Start", oldval, rcu_dynticks_nesting));
+	RCU_TRACE(trace_rcu_dyntick("Start", rcu_dynticks_nesting, newval));
 	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
-					    oldval, rcu_dynticks_nesting));
+					    rcu_dynticks_nesting, newval));
 		ftrace_dump(DUMP_ALL);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
 	}
+	barrier();
+	rcu_dynticks_nesting = newval;
 	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
 }
 
@@ -84,17 +87,16 @@ static void rcu_idle_enter_common(long long oldval)
 void rcu_idle_enter(void)
 {
 	unsigned long flags;
-	long long oldval;
+	long long newval;
 
 	local_irq_save(flags);
-	oldval = rcu_dynticks_nesting;
 	WARN_ON_ONCE((rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK) == 0);
 	if ((rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK) ==
 	    DYNTICK_TASK_NEST_VALUE)
-		rcu_dynticks_nesting = 0;
+		newval = 0;
 	else
-		rcu_dynticks_nesting  -= DYNTICK_TASK_NEST_VALUE;
-	rcu_idle_enter_common(oldval);
+		newval = rcu_dynticks_nesting - DYNTICK_TASK_NEST_VALUE;
+	rcu_idle_enter_common(newval);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -105,13 +107,12 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
 void rcu_irq_exit(void)
 {
 	unsigned long flags;
-	long long oldval;
+	long long newval;
 
 	local_irq_save(flags);
-	oldval = rcu_dynticks_nesting;
-	rcu_dynticks_nesting--;
-	WARN_ON_ONCE(rcu_dynticks_nesting < 0);
-	rcu_idle_enter_common(oldval);
+	newval = rcu_dynticks_nesting - 1;
+	WARN_ON_ONCE(newval < 0);
+	rcu_idle_enter_common(newval);
 	local_irq_restore(flags);
 }
 
-- 
1.7.8

