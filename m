Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab0HIWPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:15:31 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49294 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757199Ab0HIWPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:15:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/10] rcu: Allow RCU CPU stall warnings to be off at boot, but manually enablable
Date: Mon,  9 Aug 2010 15:15:07 -0700
Message-Id: <1281392111-25060-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100809221447.GA24358@linux.vnet.ibm.com>
References: <20100809221447.GA24358@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if RCU CPU stall warnings are enabled, they are enabled
immediately upon boot.  They can be manually disabled via /sys (and
also re-enabled via /sys), and are automatically disabled upon panic.
However, some users need RCU CPU stalls to be disabled at boot time,
but to be enabled without rebuilding/rebooting.  For example, someone
running a real-time application in production might not want the
additional latency of RCU CPU stall detection in normal operation, but
might need to enable it at any point for fault isolation purposes.

This commit therefore provides a new CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE
kernel configuration parameter that maintains the current behavior
(enable at boot) by default, but allows a kernel to be configured
with RCU CPU stall detection built into the kernel, but disabled at
boot time.

Requested-by: Clark Williams <williams@redhat.com>
Requested-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c  |    2 +-
 kernel/rcutree.h  |    6 ++++++
 lib/Kconfig.debug |   13 +++++++++++++
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5d910be..5aab7da 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -144,7 +144,7 @@ module_param(qhimark, int, 0);
 module_param(qlowmark, int, 0);
 
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-int rcu_cpu_stall_suppress __read_mostly;
+int rcu_cpu_stall_suppress __read_mostly = RCU_CPU_STALL_SUPPRESS_INIT;
 module_param(rcu_cpu_stall_suppress, int, 0644);
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 183ebf4..bb4d086 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -264,6 +264,12 @@ struct rcu_data {
 						/*  scheduling clock irq */
 						/*  before ratting on them. */
 
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE
+#define RCU_CPU_STALL_SUPPRESS_INIT 0
+#else
+#define RCU_CPU_STALL_SUPPRESS_INIT 1
+#endif
+
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index af8b9c5..adfc9f1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -832,6 +832,19 @@ config RCU_CPU_STALL_TIMEOUT
 	  RCU grace period persists, additional CPU stall warnings are
 	  printed at more widely spaced intervals.
 
+config RCU_CPU_STALL_DETECTOR_RUNNABLE
+	bool "RCU CPU stall checking starts automatically at boot"
+	depends on RCU_CPU_STALL_DETECTOR
+	default y
+	help
+	  If set, start checking for RCU CPU stalls immediately on
+	  boot.  Otherwise, RCU CPU stall checking must be manually
+	  enabled.
+
+	  Say Y if you are unsure.
+
+	  Say N if you wish to suppress RCU CPU stall checking during boot.
+
 config RCU_CPU_STALL_VERBOSE
 	bool "Print additional per-task information for RCU_CPU_STALL_DETECTOR"
 	depends on RCU_CPU_STALL_DETECTOR && TREE_PREEMPT_RCU
-- 
1.7.0.6

