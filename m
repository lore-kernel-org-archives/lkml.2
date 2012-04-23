Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab2DWQQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:16:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54759 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2DWQQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:16:51 -0400
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
Subject: [PATCH RFC tip/core/rcu 2/4] rcu: Make RCU_FAST_NO_HZ use timer rather than hrtimer
Date: Mon, 23 Apr 2012 09:15:59 -0700
Message-Id: <1335197761-6577-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120423161539.GA6467@linux.vnet.ibm.com>
 <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042316-1780-0000-0000-000004FADF3E
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000271; HX=3.00000187; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00133422; UDB=6.00031284; UTC=2012-04-23
 16:16:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The RCU_FAST_NO_HZ facility uses an hrtimer to wake up a CPU when
it is allowed to go into dyntick-idle mode, which is almost always
cancelled soon after.  This is not what hrtimers are good at, so
this commit switches to the timer wheel.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   40 ++++++++++++----------------------------
 1 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 1e561ab..0f007b3 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1980,9 +1980,7 @@ static void rcu_prepare_for_idle(int cpu)
 
 static DEFINE_PER_CPU(int, rcu_dyntick_drain);
 static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
-static DEFINE_PER_CPU(struct hrtimer, rcu_idle_gp_timer);
-static ktime_t rcu_idle_gp_wait;	/* If some non-lazy callbacks. */
-static ktime_t rcu_idle_lazy_gp_wait;	/* If only lazy callbacks. */
+static DEFINE_PER_CPU(struct timer_list, rcu_idle_gp_timer);
 
 /*
  * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
@@ -2051,10 +2049,9 @@ static bool rcu_cpu_has_nonlazy_callbacks(int cpu)
  * real work is done upon re-entry to idle, or by the next scheduling-clock
  * interrupt should idle not be re-entered.
  */
-static enum hrtimer_restart rcu_idle_gp_timer_func(struct hrtimer *hrtp)
+static void rcu_idle_gp_timer_func(unsigned long unused)
 {
 	trace_rcu_prep_idle("Timer");
-	return HRTIMER_NORESTART;
 }
 
 /*
@@ -2062,19 +2059,8 @@ static enum hrtimer_restart rcu_idle_gp_timer_func(struct hrtimer *hrtp)
  */
 static void rcu_prepare_for_idle_init(int cpu)
 {
-	static int firsttime = 1;
-	struct hrtimer *hrtp = &per_cpu(rcu_idle_gp_timer, cpu);
-
-	hrtimer_init(hrtp, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hrtp->function = rcu_idle_gp_timer_func;
-	if (firsttime) {
-		unsigned int upj = jiffies_to_usecs(RCU_IDLE_GP_DELAY);
-
-		rcu_idle_gp_wait = ns_to_ktime(upj * (u64)1000);
-		upj = jiffies_to_usecs(RCU_IDLE_LAZY_GP_DELAY);
-		rcu_idle_lazy_gp_wait = ns_to_ktime(upj * (u64)1000);
-		firsttime = 0;
-	}
+	setup_timer(&per_cpu(rcu_idle_gp_timer, cpu),
+		    rcu_idle_gp_timer_func, 0);
 }
 
 /*
@@ -2084,7 +2070,7 @@ static void rcu_prepare_for_idle_init(int cpu)
  */
 static void rcu_cleanup_after_idle(int cpu)
 {
-	hrtimer_cancel(&per_cpu(rcu_idle_gp_timer, cpu));
+	del_timer(&per_cpu(rcu_idle_gp_timer, cpu));
 	trace_rcu_prep_idle("Cleanup after idle");
 }
 
@@ -2141,11 +2127,11 @@ static void rcu_prepare_for_idle(int cpu)
 		per_cpu(rcu_dyntick_drain, cpu) = 0;
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
 		if (rcu_cpu_has_nonlazy_callbacks(cpu))
-			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
-				      rcu_idle_gp_wait, HRTIMER_MODE_REL);
+			mod_timer(&per_cpu(rcu_idle_gp_timer, cpu),
+					   jiffies + RCU_IDLE_GP_DELAY);
 		else
-			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
-				      rcu_idle_lazy_gp_wait, HRTIMER_MODE_REL);
+			mod_timer(&per_cpu(rcu_idle_gp_timer, cpu),
+					   jiffies + RCU_IDLE_LAZY_GP_DELAY);
 		return; /* Nothing more to do immediately. */
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
@@ -2193,14 +2179,12 @@ static void rcu_prepare_for_idle(int cpu)
 
 static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
 {
-	struct hrtimer *hrtp = &per_cpu(rcu_idle_gp_timer, cpu);
+	struct timer_list *tltp = &per_cpu(rcu_idle_gp_timer, cpu);
 
-	sprintf(cp, "drain=%d %c timer=%lld",
+	sprintf(cp, "drain=%d %c timer=%lu",
 		per_cpu(rcu_dyntick_drain, cpu),
 		per_cpu(rcu_dyntick_holdoff, cpu) == jiffies ? 'H' : '.',
-		hrtimer_active(hrtp)
-			? ktime_to_us(hrtimer_get_remaining(hrtp))
-			: -1);
+		timer_pending(tltp) ? tltp->expires - jiffies : -1);
 }
 
 #else /* #ifdef CONFIG_RCU_FAST_NO_HZ */
-- 
1.7.8

