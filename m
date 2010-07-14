Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab0GNUM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:12:59 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36558 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757552Ab0GNUKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:10:19 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 22/30] rcu: make CPU stall warning timeout configurable
Date: Wed, 14 Jul 2010 13:09:56 -0700
Message-Id: <1279138204-12849-22-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100714200945.GA10535@linux.vnet.ibm.com>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also set the default to 60 seconds, up from the previous hard-coded timeout
of 10 seconds.  This allows people who care to set short timeouts, while
avoiding people with unusual configurations (make randconfig!!!) from being
bothered with spurious CPU stall warnings.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.h  |    5 +++--
 lib/Kconfig.debug |   11 +++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 14c040b..5d68e17 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -254,9 +254,10 @@ struct rcu_data {
 #define RCU_STALL_DELAY_DELTA	       0
 #endif
 
-#define RCU_SECONDS_TILL_STALL_CHECK   (10 * HZ + RCU_STALL_DELAY_DELTA)
+#define RCU_SECONDS_TILL_STALL_CHECK   (CONFIG_RCU_CPU_STALL_TIMEOUT * HZ + \
+					RCU_STALL_DELAY_DELTA)
 						/* for rsp->jiffies_stall */
-#define RCU_SECONDS_TILL_STALL_RECHECK (30 * HZ + RCU_STALL_DELAY_DELTA)
+#define RCU_SECONDS_TILL_STALL_RECHECK (3 * RCU_SECONDS_TILL_STALL_CHECK + 30)
 						/* for rsp->jiffies_stall */
 #define RCU_STALL_RAT_DELAY		2	/* Allow other CPUs time */
 						/*  to take at least one */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a8a272a..af8b9c5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -821,6 +821,17 @@ config RCU_CPU_STALL_DETECTOR
 
 	  Say Y if you are unsure.
 
+config RCU_CPU_STALL_TIMEOUT
+	int "RCU CPU stall timeout in seconds"
+	depends on RCU_CPU_STALL_DETECTOR
+	range 3 300
+	default 60
+	help
+	  If a given RCU grace period extends more than the specified
+	  number of seconds, a CPU stall warning is printed.  If the
+	  RCU grace period persists, additional CPU stall warnings are
+	  printed at more widely spaced intervals.
+
 config RCU_CPU_STALL_VERBOSE
 	bool "Print additional per-task information for RCU_CPU_STALL_DETECTOR"
 	depends on RCU_CPU_STALL_DETECTOR && TREE_PREEMPT_RCU
-- 
1.7.0.6

