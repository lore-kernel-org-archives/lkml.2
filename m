Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab2H3VPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:15:46 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47845 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab2H3VO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:14:26 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/26] rcu: Settle config for userspace extended quiescent state
Date: Thu, 30 Aug 2012 14:05:21 -0700
Message-Id: <1346360743-3628-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-7606-0000-0000-00000334D212
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Create a new config option under the RCU menu that put
CPUs under RCU extended quiescent state (as in dynticks
idle mode) when they run in userspace. This require
some contribution from architectures to hook into kernel
and userspace boundaries.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/Kconfig             |   10 ++++++++++
 include/linux/rcupdate.h |    8 ++++++++
 init/Kconfig             |   10 ++++++++++
 kernel/rcutree.c         |    5 ++++-
 4 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 72f2fa1..1401a75 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -281,4 +281,14 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+config HAVE_RCU_USER_QS
+	bool
+	help
+	  Provide kernel entry/exit hooks necessary for userspace
+	  RCU extended quiescent state. Syscalls need to be wrapped inside
+	  rcu_user_exit()-rcu_user_enter() through the slow path using
+	  TIF_NOHZ flag. Exceptions handlers must be wrapped as well. Irqs
+	  are already protected inside rcu_irq_enter/rcu_irq_exit() but
+	  preemption or signal handling on irq exit still need to be protected.
+
 source "kernel/gcov/Kconfig"
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 81d3d5c..e411117 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -191,10 +191,18 @@ extern void rcu_idle_enter(void);
 extern void rcu_idle_exit(void);
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
+
+#ifdef CONFIG_RCU_USER_QS
 extern void rcu_user_enter(void);
 extern void rcu_user_exit(void);
 extern void rcu_user_enter_irq(void);
 extern void rcu_user_exit_irq(void);
+#else
+static inline void rcu_user_enter(void) { }
+static inline void rcu_user_exit(void) { }
+#endif /* CONFIG_RCU_USER_QS */
+
+
 extern void exit_rcu(void);
 
 /**
diff --git a/init/Kconfig b/init/Kconfig
index af6c7f8..f6a1830 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -441,6 +441,16 @@ config PREEMPT_RCU
 	  This option enables preemptible-RCU code that is common between
 	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
 
+config RCU_USER_QS
+	bool "Consider userspace as in RCU extended quiescent state"
+	depends on HAVE_RCU_USER_QS && SMP
+	help
+	  This option sets hooks on kernel / userspace boundaries and
+	  puts RCU in extended quiescent state when the CPU runs in
+	  userspace. It means that when a CPU runs in userspace, it is
+	  excluded from the global RCU state machine and thus doesn't
+	  to keep the timer tick on for RCU.
+
 config RCU_FANOUT
 	int "Tree-based hierarchical RCU fanout value"
 	range 2 64 if 64BIT
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 8fdea17..e287c4a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -424,6 +424,7 @@ void rcu_idle_enter(void)
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
+#ifdef CONFIG_RCU_USER_QS
 /**
  * rcu_user_enter - inform RCU that we are resuming userspace.
  *
@@ -438,7 +439,6 @@ void rcu_user_enter(void)
 }
 EXPORT_SYMBOL_GPL(rcu_user_enter);
 
-
 /**
  * rcu_user_enter_irq - inform RCU that we are going to resume userspace
  * after the current irq returns.
@@ -459,6 +459,7 @@ void rcu_user_enter_irq(void)
 	rdtp->dynticks_nesting = 1;
 	local_irq_restore(flags);
 }
+#endif
 
 /**
  * rcu_irq_exit - inform RCU that current CPU is exiting irq towards idle
@@ -562,6 +563,7 @@ void rcu_idle_exit(void)
 }
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
 
+#ifdef CONFIG_RCU_USER_QS
 /**
  * rcu_user_exit - inform RCU that we are exiting userspace.
  *
@@ -595,6 +597,7 @@ void rcu_user_exit_irq(void)
 	rdtp->dynticks_nesting += DYNTICK_TASK_EXIT_IDLE;
 	local_irq_restore(flags);
 }
+#endif
 
 /**
  * rcu_irq_enter - inform RCU that current CPU is entering irq away from idle
-- 
1.7.8

