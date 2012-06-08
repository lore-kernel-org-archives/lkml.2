Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab2FHE1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 00:27:40 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58418 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab2FHE1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 00:27:06 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH rcu 2/8] rcu: Update RCU_FAST_NO_HZ tracing for lazy callbacks
Date: Thu,  7 Jun 2012 21:26:49 -0700
Message-Id: <1339129615-1795-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339129615-1795-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120608042632.GA1250@linux.vnet.ibm.com>
 <1339129615-1795-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060804-7282-0000-0000-000009B85806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

In the current code, a short dyntick-idle interval (where there is
at least one non-lazy callback on the CPU) and a long dyntick-idle
interval (where there are only lazy callbacks on the CPU) are traced
identically, which can be less than helpful.  This commit therefore
emits different event traces in these two cases.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
---
 include/trace/events/rcu.h |    1 +
 kernel/rcutree_plugin.h    |    8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 1480900..d274734 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -289,6 +289,7 @@ TRACE_EVENT(rcu_dyntick,
  *	"In holdoff": Nothing to do, holding off after unsuccessful attempt.
  *	"Begin holdoff": Attempt failed, don't retry until next jiffy.
  *	"Dyntick with callbacks": Entering dyntick-idle despite callbacks.
+ *	"Dyntick with lazy callbacks": Entering dyntick-idle w/lazy callbacks.
  *	"More callbacks": Still more callbacks, try again to clear them out.
  *	"Callbacks drained": All callbacks processed, off to dyntick idle!
  *	"Timer": Timer fired to cause CPU to continue processing callbacks.
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 2411000..5449f02 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2165,15 +2165,17 @@ static void rcu_prepare_for_idle(int cpu)
 		   !rcu_pending(cpu) &&
 		   !local_softirq_pending()) {
 		/* Can we go dyntick-idle despite still having callbacks? */
-		trace_rcu_prep_idle("Dyntick with callbacks");
 		per_cpu(rcu_dyntick_drain, cpu) = 0;
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
-		if (rcu_cpu_has_nonlazy_callbacks(cpu))
+		if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
+			trace_rcu_prep_idle("Dyntick with callbacks");
 			per_cpu(rcu_idle_gp_timer_expires, cpu) =
 					   jiffies + RCU_IDLE_GP_DELAY;
-		else
+		} else {
 			per_cpu(rcu_idle_gp_timer_expires, cpu) =
 					   jiffies + RCU_IDLE_LAZY_GP_DELAY;
+			trace_rcu_prep_idle("Dyntick with lazy callbacks");
+		}
 		tp = &per_cpu(rcu_idle_gp_timer, cpu);
 		mod_timer_pinned(tp, per_cpu(rcu_idle_gp_timer_expires, cpu));
 		per_cpu(rcu_nonlazy_posted_snap, cpu) =
-- 
1.7.8

