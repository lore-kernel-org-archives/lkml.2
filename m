Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030348Ab2GFMAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:00:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47279 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030335Ab2GFMAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:00:31 -0400
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
Subject: [PATCH 1/6] rcu: Settle config for userspace extended quiescent state
Date: Fri,  6 Jul 2012 14:00:13 +0200
Message-Id: <1341576018-10721-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
References: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
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
 arch/Kconfig     |   13 +++++++++++++
 init/Kconfig     |   10 ++++++++++
 kernel/rcutree.c |    4 ++++
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 8c3d957..c2e0ce4 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -274,4 +274,17 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+config HAVE_RCU_USER_QS
+	bool
+	help
+	  Provide kernel entry/exit hooks necessary for userspace
+	  RCU extended quiescent state. Syscalls and exceptions
+	  low level handlers must be wrapped with a call to rcu_user_exit()
+	  on entry and rcu_user_enter() before resuming userspace. Irqs
+	  entry don't need to call rcu_user_exit() because their high level
+	  handlers are protected inside rcu_irq_enter/rcu_irq_exit() but
+	  preemption or signal handling on irq exit still need to be protected
+	  with a call to rcu_user_exit(). rcu_user_enter() must then be
+	  called back on irq exit when the preempted task is back on the CPU.
+
 source "kernel/gcov/Kconfig"
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
+	  need to keep the timer tick on for RCU.
+
 config RCU_FANOUT
 	int "Tree-based hierarchical RCU fanout value"
 	range 2 64 if 64BIT
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5541a07..64fc2cd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -423,6 +423,7 @@ void rcu_idle_enter(void)
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
+#ifdef CONFIG_RCU_USER_QS
 /**
  * rcu_user_enter - inform RCU that we are resuming userspace.
  *
@@ -436,6 +437,7 @@ void rcu_user_enter(void)
 	rcu_eqs_enter(1);
 }
 EXPORT_SYMBOL_GPL(rcu_user_enter);
+#endif
 
 
 /**
@@ -561,6 +563,7 @@ void rcu_idle_exit(void)
 }
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
 
+#ifdef CONFIG_RCU_USER_QS
 /**
  * rcu_user_exit - inform RCU that we are exiting userspace.
  *
@@ -572,6 +575,7 @@ void rcu_user_exit(void)
 	rcu_eqs_exit(1);
 }
 EXPORT_SYMBOL_GPL(rcu_user_exit);
+#endif
 
 /**
  * rcu_user_exit_irq - inform RCU that we won't resume to userspace
-- 
1.7.5.4

