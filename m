Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab1K1Xe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:34:59 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37014 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab1K1Xd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:33:59 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 06/13] rcu: Go dyntick-idle more quickly if CPU has serviced current grace period
Date: Mon, 28 Nov 2011 15:32:58 -0800
Message-Id: <1322523185-456-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111128233212.GA32279@linux.vnet.ibm.com>
References: <20111128233212.GA32279@linux.vnet.ibm.com>
x-cbid: 11112823-8974-0000-0000-000003806466
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The earlier version would attempt to push callbacks through five times
before going into dyntick-idle mode if callbacks remained, but the CPU
had done all that it needed to do for the current RCU grace periods.
This is wasteful:  In most cases, once the CPU has done all that it
needs to for the current RCU grace periods, it will make no further
progress on the callbacks no matter how many times it loops through
the RCU core processing and the idle-entry code.

This commit therefore goes to dyntick-idle mode whenever the current
CPU has done all it can for the current grace period.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 6467f56..45790bf 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2028,12 +2028,29 @@ static void rcu_prepare_for_idle(int cpu)
 {
 	int c = 0;
 
-	/* If no callbacks or in the holdoff period, enter dyntick-idle. */
+	/*
+	 * If there are no callbacks on this CPU or if RCU has no further
+	 * need for this CPU at the moment, enter dyntick-idle mode.
+	 * Also reset state so as to not prejudice later attempts.
+	 */
 	if (!rcu_cpu_has_callbacks(cpu)) {
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
+		per_cpu(rcu_dyntick_drain, cpu) = 0;
 		trace_rcu_prep_idle("No callbacks");
 		return;
 	}
+	if (!rcu_pending(cpu)) {
+		trace_rcu_prep_idle("Dyntick with callbacks");
+		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
+		per_cpu(rcu_dyntick_drain, cpu) = 0;
+		per_cpu(rcu_awake_at_gp_end, cpu) = 1;
+		return;  /* Nothing to do immediately. */
+	}
+
+	/*
+	 * If in holdoff mode, just return.  We will presumably have
+	 * refrained from disabling the scheduling-clock tick.
+	 */
 	if (per_cpu(rcu_dyntick_holdoff, cpu) == jiffies) {
 		trace_rcu_prep_idle("In holdoff");
 		return;
@@ -2046,11 +2063,6 @@ static void rcu_prepare_for_idle(int cpu)
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
-		if (!rcu_pending(cpu)) {
-			trace_rcu_prep_idle("Dyntick with callbacks");
-			per_cpu(rcu_awake_at_gp_end, cpu) = 1;
-			return;  /* Nothing to do immediately. */
-		}
 		trace_rcu_prep_idle("Begin holdoff");
 		invoke_rcu_core();  /* Force the CPU out of dyntick-idle. */
 		return;
-- 
1.7.3.2

