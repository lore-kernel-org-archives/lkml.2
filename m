Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2H3VoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:44:05 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33282 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2H3VoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:44:00 -0400
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
Subject: [PATCH tip/core/rcu 01/15] rcu: Add PROVE_RCU_DELAY to provoke difficult races
Date: Thu, 30 Aug 2012 11:56:14 -0700
Message-Id: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20120830185607.GA32148@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-1780-0000-0000-000008E024FA
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000293; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00169896; UDB=6.00038517; UTC=2012-08-30
 21:43:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

There have been some recent bugs that were triggered only when
preemptible RCU's __rcu_read_unlock() was preempted just after setting
->rcu_read_lock_nesting to INT_MIN, which is a low-probability event.
Therefore, reproducing those bugs (to say nothing of gaining confidence
in alleged fixes) was quite difficult.  This commit therefore creates
a new debug-only RCU kernel config option that forces a short delay
in __rcu_read_unlock() to increase the probability of those sorts of
bugs occurring.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcupdate.c |    4 ++++
 lib/Kconfig.debug |   14 ++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 4e6a61b..29ca1c6 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -45,6 +45,7 @@
 #include <linux/mutex.h>
 #include <linux/export.h>
 #include <linux/hardirq.h>
+#include <linux/delay.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/rcu.h>
@@ -81,6 +82,9 @@ void __rcu_read_unlock(void)
 	} else {
 		barrier();  /* critical section before exit code. */
 		t->rcu_read_lock_nesting = INT_MIN;
+#ifdef CONFIG_PROVE_RCU_DELAY
+		udelay(10); /* Make preemption more probable. */
+#endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
 		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
 			rcu_read_unlock_special(t);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2403a63..dacbbe4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -629,6 +629,20 @@ config PROVE_RCU_REPEATEDLY
 
 	 Say N if you are unsure.
 
+config PROVE_RCU_DELAY
+	bool "RCU debugging: preemptible RCU race provocation"
+	depends on DEBUG_KERNEL && PREEMPT_RCU
+	default n
+	help
+	 There is a class of races that involve an unlikely preemption
+	 of __rcu_read_unlock() just after ->rcu_read_lock_nesting has
+	 been set to INT_MIN.  This feature inserts a delay at that
+	 point to increase the probability of these races.
+
+	 Say Y to increase probability of preemption of __rcu_read_unlock().
+
+	 Say N if you are unsure.
+
 config SPARSE_RCU_POINTER
 	bool "RCU debugging: sparse-based checks for pointer usage"
 	default n
-- 
1.7.8

