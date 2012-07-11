Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab2GKS1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:27:00 -0400
Received: from mail-yw0-f52.google.com ([209.85.213.52]:36788 "EHLO
	mail-yw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab2GKS04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:26:56 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 01/11] rcu: Settle config for userspace extended quiescent state
Date: Wed, 11 Jul 2012 20:26:30 +0200
Message-Id: <1342031200-22731-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
References: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/Kconfig             |   10 ++++++++++
 include/linux/rcupdate.h |    8 ++++++++
 init/Kconfig             |   10 ++++++++++
 kernel/rcutree.c         |    5 ++++-
 4 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 8c3d957..1c7c9be 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -274,4 +274,14 @@ config SECCOMP_FILTER
 
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
index 148f381..a72f25e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -192,10 +192,18 @@ extern void rcu_idle_enter(void);
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
index d07dcf9..3a4af8f 100644
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
index 5541a07..efa5983 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -423,6 +423,7 @@ void rcu_idle_enter(void)
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
+#ifdef CONFIG_RCU_USER_QS
 /**
  * rcu_user_enter - inform RCU that we are resuming userspace.
  *
@@ -437,7 +438,6 @@ void rcu_user_enter(void)
 }
 EXPORT_SYMBOL_GPL(rcu_user_enter);
 
-
 /**
  * rcu_user_enter_irq - inform RCU that we are going to resume userspace
  * after the current irq returns.
@@ -458,6 +458,7 @@ void rcu_user_enter_irq(void)
 	rdtp->dynticks_nesting = 1;
 	local_irq_restore(flags);
 }
+#endif
 
 /**
  * rcu_irq_exit - inform RCU that current CPU is exiting irq towards idle
@@ -561,6 +562,7 @@ void rcu_idle_exit(void)
 }
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
 
+#ifdef CONFIG_RCU_USER_QS
 /**
  * rcu_user_exit - inform RCU that we are exiting userspace.
  *
@@ -594,6 +596,7 @@ void rcu_user_exit_irq(void)
 	rdtp->dynticks_nesting += DYNTICK_TASK_EXIT_IDLE;
 	local_irq_restore(flags);
 }
+#endif
 
 /**
  * rcu_irq_enter - inform RCU that current CPU is entering irq away from idle
-- 
1.7.5.4

