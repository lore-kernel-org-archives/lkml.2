Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2DWQRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:17:23 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36992 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab2DWQRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:17:20 -0400
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
Subject: [PATCH RFC tip/core/rcu 4/4] rcu: Ensure that RCU_FAST_NO_HZ timers expire on correct CPU
Date: Mon, 23 Apr 2012 09:16:01 -0700
Message-Id: <1335197761-6577-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120423161539.GA6467@linux.vnet.ibm.com>
 <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042316-5112-0000-0000-00000756476B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Timers are subject to migration, which can lead to the following
system-hang scenario when CONFIG_RCU_FAST_NO_HZ=y:

1.	CPU 0 executes synchronize_rcu(), which posts an RCU callback.

2.	CPU 0 then goes idle.  It cannot immediately invoke the callback,
	but there is nothing RCU needs from ti, so it enters dyntick-idle
	mode after posting a timer.

3.	The timer gets migrated to CPU 1.

4.	CPU 0 never wakes up, so the synchronize_rcu() never returns, so
	the system hangs.

This commit fixes this problem by using add_timer_on() to ensure that
the timer remains on the CPU that posted it.

Reported-by: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 50c1797..90b3de5 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2109,6 +2109,8 @@ static void rcu_cleanup_after_idle(int cpu)
  */
 static void rcu_prepare_for_idle(int cpu)
 {
+	struct timer_list *tp;
+
 	/*
 	 * If this is an idle re-entry, for example, due to use of
 	 * RCU_NONIDLE() or the new idle-loop tracing API within the idle
@@ -2120,9 +2122,11 @@ static void rcu_prepare_for_idle(int cpu)
 	if (!per_cpu(rcu_idle_first_pass, cpu) &&
 	    (per_cpu(rcu_nonlazy_posted, cpu) ==
 	     per_cpu(rcu_nonlazy_posted_snap, cpu))) {
-		if (rcu_cpu_has_callbacks(cpu))
-			mod_timer(&per_cpu(rcu_idle_gp_timer, cpu),
-				  per_cpu(rcu_idle_gp_timer_expires, cpu));
+		if (rcu_cpu_has_callbacks(cpu)) {
+			tp = &per_cpu(rcu_idle_gp_timer, cpu);
+			tp->expires = per_cpu(rcu_idle_gp_timer_expires, cpu);
+			add_timer_on(tp, cpu);
+		}
 		return;
 	}
 	per_cpu(rcu_idle_first_pass, cpu) = 0;
@@ -2166,8 +2170,9 @@ static void rcu_prepare_for_idle(int cpu)
 		else
 			per_cpu(rcu_idle_gp_timer_expires, cpu) =
 					   jiffies + RCU_IDLE_LAZY_GP_DELAY;
-		mod_timer(&per_cpu(rcu_idle_gp_timer, cpu),
-			  per_cpu(rcu_idle_gp_timer_expires, cpu));
+		tp = &per_cpu(rcu_idle_gp_timer, cpu);
+		tp->expires = per_cpu(rcu_idle_gp_timer_expires, cpu);
+		add_timer_on(tp, cpu);
 		per_cpu(rcu_nonlazy_posted_snap, cpu) =
 			per_cpu(rcu_nonlazy_posted, cpu);
 		return; /* Nothing more to do immediately. */
-- 
1.7.8

