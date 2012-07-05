Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab2GEWhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 18:37:42 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:44073 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182Ab2GEWhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 18:37:40 -0400
Date: Thu, 5 Jul 2012 15:37:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu] Make RCU_FAST_NO_HZ respect nohz= boot parameter
Message-ID: <20120705223731.GA27608@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070522-7606-0000-0000-000001C54CDF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the nohz= boot parameter disables nohz, then RCU_FAST_NO_HZ needs to
also disable itself.  This commit therefore checks for tick_nohz_enabled
being zero, disabling rcu_prepare_for_idle() if so.  This patch assumes
that tick_nohz_enabled can change at runtime: If this is not the case,
then a simpler approach suffices.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 19b61ac..e978845 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -97,6 +97,7 @@ struct rcu_dynticks {
 				    /* # times non-lazy CBs posted to CPU. */
 	unsigned long nonlazy_posted_snap;
 				    /* idle-period nonlazy_posted snapshot. */
+	int tick_nohz_enabled_snap; /* Previously seen value from sysfs. */
 #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
 };
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c28d255..3508000 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1971,6 +1971,8 @@ static void rcu_idle_count_callbacks_posted(void)
 #define RCU_IDLE_GP_DELAY 4		/* Roughly one grace period. */
 #define RCU_IDLE_LAZY_GP_DELAY (6 * HZ)	/* Roughly six seconds. */
 
+extern int tick_nohz_enabled;
+
 /*
  * Does the specified flavor of RCU have non-lazy callbacks pending on
  * the specified CPU?  Both RCU flavor and CPU are specified by the
@@ -2112,6 +2114,7 @@ static void rcu_cleanup_after_idle(int cpu)
 
 	del_timer(&rdtp->idle_gp_timer);
 	trace_rcu_prep_idle("Cleanup after idle");
+	rdtp->tick_nohz_enabled_snap = ACCESS_ONCE(tick_nohz_enabled);
 }
 
 /*
@@ -2137,6 +2140,18 @@ static void rcu_prepare_for_idle(int cpu)
 {
 	struct timer_list *tp;
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+	int tne;
+
+	/* Handle nohz enablement switches conservatively. */
+	tne = ACCESS_ONCE(tick_nohz_enabled);
+	if (tne != rdtp->tick_nohz_enabled_snap) {
+		if (rcu_cpu_has_callbacks(cpu))
+			invoke_rcu_core(); /* force nohz to see update. */
+		rdtp->tick_nohz_enabled_snap = tne;
+		return;
+	}
+	if (!tne)
+		return;
 
 	/*
 	 * If this is an idle re-entry, for example, due to use of
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 8699978..66ff07f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -105,7 +105,7 @@ static ktime_t tick_init_jiffy_update(void)
 /*
  * NO HZ enabled ?
  */
-static int tick_nohz_enabled __read_mostly  = 1;
+int tick_nohz_enabled __read_mostly  = 1;
 
 /*
  * Enable / Disable tickless mode

