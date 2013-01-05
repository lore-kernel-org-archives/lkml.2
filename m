Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3AERuh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:50:37 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:50217 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab3AERtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:49:21 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/14] rcu: Export RCU_FAST_NO_HZ parameters to sysfs
Date: Sat,  5 Jan 2013 09:48:56 -0800
Message-Id: <1357408144-15830-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130105174844.GA14172@linux.vnet.ibm.com>
 <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-7606-0000-0000-00000726CA5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

RCU_FAST_NO_HZ operation is controlled by four compile-time C-preprocessor
macros, but some use cases benefit greatly from runtime adjustment,
particularly when tuning devices.  This commit therefore creates the
corresponding sysfs entries.

Reported-by: Robin Randhawa <robin.randhawa@arm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ab1bdde..0997e9f 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1617,6 +1617,15 @@ static void rcu_idle_count_callbacks_posted(void)
 #define RCU_IDLE_GP_DELAY 4		/* Roughly one grace period. */
 #define RCU_IDLE_LAZY_GP_DELAY (6 * HZ)	/* Roughly six seconds. */
 
+static int rcu_idle_flushes = RCU_IDLE_FLUSHES;
+module_param(rcu_idle_flushes, int, 0644);
+static int rcu_idle_opt_flushes = RCU_IDLE_OPT_FLUSHES;
+module_param(rcu_idle_opt_flushes, int, 0644);
+static int rcu_idle_gp_delay = RCU_IDLE_GP_DELAY;
+module_param(rcu_idle_gp_delay, int, 0644);
+static int rcu_idle_lazy_gp_delay = RCU_IDLE_LAZY_GP_DELAY;
+module_param(rcu_idle_lazy_gp_delay, int, 0644);
+
 extern int tick_nohz_enabled;
 
 /*
@@ -1696,10 +1705,10 @@ int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 	}
 	/* Set up for the possibility that RCU will post a timer. */
 	if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
-		*delta_jiffies = round_up(RCU_IDLE_GP_DELAY + jiffies,
-					  RCU_IDLE_GP_DELAY) - jiffies;
+		*delta_jiffies = round_up(rcu_idle_gp_delay + jiffies,
+					  rcu_idle_gp_delay) - jiffies;
 	} else {
-		*delta_jiffies = jiffies + RCU_IDLE_LAZY_GP_DELAY;
+		*delta_jiffies = jiffies + rcu_idle_lazy_gp_delay;
 		*delta_jiffies = round_jiffies(*delta_jiffies) - jiffies;
 	}
 	return 0;
@@ -1805,11 +1814,11 @@ static void rcu_prepare_for_idle(int cpu)
 		if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
 			trace_rcu_prep_idle("User dyntick with callbacks");
 			rdtp->idle_gp_timer_expires =
-				round_up(jiffies + RCU_IDLE_GP_DELAY,
-					 RCU_IDLE_GP_DELAY);
+				round_up(jiffies + rcu_idle_gp_delay,
+					 rcu_idle_gp_delay);
 		} else if (rcu_cpu_has_callbacks(cpu)) {
 			rdtp->idle_gp_timer_expires =
-				round_jiffies(jiffies + RCU_IDLE_LAZY_GP_DELAY);
+				round_jiffies(jiffies + rcu_idle_lazy_gp_delay);
 			trace_rcu_prep_idle("User dyntick with lazy callbacks");
 		} else {
 			return;
@@ -1861,8 +1870,8 @@ static void rcu_prepare_for_idle(int cpu)
 	/* Check and update the ->dyntick_drain sequencing. */
 	if (rdtp->dyntick_drain <= 0) {
 		/* First time through, initialize the counter. */
-		rdtp->dyntick_drain = RCU_IDLE_FLUSHES;
-	} else if (rdtp->dyntick_drain <= RCU_IDLE_OPT_FLUSHES &&
+		rdtp->dyntick_drain = rcu_idle_flushes;
+	} else if (rdtp->dyntick_drain <= rcu_idle_opt_flushes &&
 		   !rcu_pending(cpu) &&
 		   !local_softirq_pending()) {
 		/* Can we go dyntick-idle despite still having callbacks? */
@@ -1871,11 +1880,11 @@ static void rcu_prepare_for_idle(int cpu)
 		if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
 			trace_rcu_prep_idle("Dyntick with callbacks");
 			rdtp->idle_gp_timer_expires =
-				round_up(jiffies + RCU_IDLE_GP_DELAY,
-					 RCU_IDLE_GP_DELAY);
+				round_up(jiffies + rcu_idle_gp_delay,
+					 rcu_idle_gp_delay);
 		} else {
 			rdtp->idle_gp_timer_expires =
-				round_jiffies(jiffies + RCU_IDLE_LAZY_GP_DELAY);
+				round_jiffies(jiffies + rcu_idle_lazy_gp_delay);
 			trace_rcu_prep_idle("Dyntick with lazy callbacks");
 		}
 		tp = &rdtp->idle_gp_timer;
-- 
1.7.8

