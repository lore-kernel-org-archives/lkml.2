Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab2BATuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:50:21 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51040 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235Ab2BATuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:50:19 -0500
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
Subject: [PATCH RFC tip/core/rcu 14/41] rcu: Limit lazy-callback duration
Date: Wed,  1 Feb 2012 11:41:32 -0800
Message-Id: <1328125319-5205-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-6078-0000-0000-0000075A453F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Currently, a given CPU is permitted to remain in dyntick-idle mode
indefinitely if it has only lazy RCU callbacks queued.  This is vulnerable
to corner cases in NUMA systems, so limit the time to six seconds by
default.  (Currently controlled by a cpp macro.)

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 2b183ab..2fde647 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2049,6 +2049,9 @@ static void rcu_prepare_for_idle(int cpu)
  *	number, be warned: Setting RCU_IDLE_GP_DELAY too high can hang your
  *	system.  And if you are -that- concerned about energy efficiency,
  *	just power the system down and be done with it!
+ * RCU_IDLE_LAZY_GP_DELAY gives the number of jiffies that a CPU is
+ *	permitted to sleep in dyntick-idle mode with only lazy RCU
+ *	callbacks pending.  Setting this too high can OOM your system.
  *
  * The values below work well in practice.  If future workloads require
  * adjustment, they can be converted into kernel config parameters, though
@@ -2057,11 +2060,13 @@ static void rcu_prepare_for_idle(int cpu)
 #define RCU_IDLE_FLUSHES 5		/* Number of dyntick-idle tries. */
 #define RCU_IDLE_OPT_FLUSHES 3		/* Optional dyntick-idle tries. */
 #define RCU_IDLE_GP_DELAY 6		/* Roughly one grace period. */
+#define RCU_IDLE_LAZY_GP_DELAY (6 * HZ)	/* Roughly six seconds. */
 
 static DEFINE_PER_CPU(int, rcu_dyntick_drain);
 static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
 static DEFINE_PER_CPU(struct hrtimer, rcu_idle_gp_timer);
-static ktime_t rcu_idle_gp_wait;
+static ktime_t rcu_idle_gp_wait;	/* If some non-lazy callbacks. */
+static ktime_t rcu_idle_lazy_gp_wait;	/* If only lazy callbacks. */
 
 /*
  * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
@@ -2150,6 +2155,8 @@ static void rcu_prepare_for_idle_init(int cpu)
 		unsigned int upj = jiffies_to_usecs(RCU_IDLE_GP_DELAY);
 
 		rcu_idle_gp_wait = ns_to_ktime(upj * (u64)1000);
+		upj = jiffies_to_usecs(6 * HZ);
+		rcu_idle_lazy_gp_wait = ns_to_ktime(upj * (u64)1000);
 		firsttime = 0;
 	}
 }
@@ -2224,6 +2231,9 @@ static void rcu_prepare_for_idle(int cpu)
 		if (rcu_cpu_has_nonlazy_callbacks(cpu))
 			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
 				      rcu_idle_gp_wait, HRTIMER_MODE_REL);
+		else
+			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
+				      rcu_idle_lazy_gp_wait, HRTIMER_MODE_REL);
 		return; /* Nothing more to do immediately. */
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
-- 
1.7.8

