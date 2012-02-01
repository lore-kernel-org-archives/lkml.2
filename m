Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab2BATmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:42:52 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46862 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754Ab2BATms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:42:48 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 28/41] rcu: Set RCU CPU stall times via sysfs
Date: Wed,  1 Feb 2012 11:41:46 -0800
Message-Id: <1328125319-5205-28-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-7182-0000-0000-000000A329E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The default CONFIG_RCU_CPU_STALL_TIMEOUT value of 60 seconds has served
Linux users well for production use for quite some time.  However, for
debugging, there will be more than three minutes between subsequent
stall-warning messages.  This can be an annoyingly long wait if you
are trying to work out where the offending infinite loop is hiding.

Therefore, this commit provides a rcu_cpu_stall_timeout sysfs
parameter that may be adjusted at boot time and at runtime to speed
up debugging.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   31 ++++++++++++++++++++++++++-----
 kernel/rcutree.h |    6 ------
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ee45ae7..e82e505 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -208,8 +208,11 @@ module_param(blimit, int, 0);
 module_param(qhimark, int, 0);
 module_param(qlowmark, int, 0);
 
-int rcu_cpu_stall_suppress __read_mostly;
+int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
+int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
+
 module_param(rcu_cpu_stall_suppress, int, 0644);
+module_param(rcu_cpu_stall_timeout, int, 0644);
 
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
 static int rcu_pending(int cpu);
@@ -648,10 +651,28 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 	return rcu_implicit_offline_qs(rdp);
 }
 
+static int jiffies_till_stall_check(void)
+{
+	int till_stall_check = ACCESS_ONCE(rcu_cpu_stall_timeout);
+
+	/*
+	 * Limit check must be consistent with the Kconfig limits
+	 * for CONFIG_RCU_CPU_STALL_TIMEOUT.
+	 */
+	if (till_stall_check < 3) {
+		ACCESS_ONCE(rcu_cpu_stall_timeout) = 3;
+		till_stall_check = 3;
+	} else if (till_stall_check > 300) {
+		ACCESS_ONCE(rcu_cpu_stall_timeout) = 300;
+		till_stall_check = 300;
+	}
+	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;
+}
+
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
 	rsp->gp_start = jiffies;
-	rsp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_CHECK;
+	rsp->jiffies_stall = jiffies + jiffies_till_stall_check();
 }
 
 static void print_other_cpu_stall(struct rcu_state *rsp)
@@ -670,7 +691,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
-	rsp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
+	rsp->jiffies_stall = jiffies + 3 * jiffies_till_stall_check() + 3;
 
 	/*
 	 * Now rat on any tasks that got kicked up to the root rcu_node
@@ -729,8 +750,8 @@ static void print_cpu_stall(struct rcu_state *rsp)
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	if (ULONG_CMP_GE(jiffies, rsp->jiffies_stall))
-		rsp->jiffies_stall =
-			jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
+		rsp->jiffies_stall = jiffies +
+				     3 * jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	set_need_resched();  /* kick ourselves to get things going. */
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 58c9fc3..0328a53 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -314,12 +314,6 @@ struct rcu_data {
 #else
 #define RCU_STALL_DELAY_DELTA	       0
 #endif
-
-#define RCU_SECONDS_TILL_STALL_CHECK   (CONFIG_RCU_CPU_STALL_TIMEOUT * HZ + \
-					RCU_STALL_DELAY_DELTA)
-						/* for rsp->jiffies_stall */
-#define RCU_SECONDS_TILL_STALL_RECHECK (3 * RCU_SECONDS_TILL_STALL_CHECK + 30)
-						/* for rsp->jiffies_stall */
 #define RCU_STALL_RAT_DELAY		2	/* Allow other CPUs time */
 						/*  to take at least one */
 						/*  scheduling clock irq */
-- 
1.7.8

