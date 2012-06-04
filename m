Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847Ab2FDMJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:09:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56199 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab2FDMJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:09:18 -0400
From: fweisbec@gmail.com
To: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] rcu: New rcu_user_enter_irq() and rcu_user_exit_irq() APIs
Date: Mon,  4 Jun 2012 14:08:28 +0200
Message-Id: <1338811708-18819-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1338811708-18819-1-git-send-email-fweisbec@gmail.com>
References: <1338811708-18819-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

A CPU running in adaptive tickless mode wants to enter into
RCU extended quiescent state while running in userspace. This
way we can shut down the tick that is usually needed on each
CPU for the needs of RCU.

Typically, RCU enters the extended quiescent state when we resume
to userspace through a syscall or exception exit, this is done
using rcu_user_enter(). Then RCU exit this state by calling
rcu_user_exit() from syscall or exception entry.

However there are two other points where we may want to enter
or exit this state. Some remote CPU may require a tickless CPU
to restart its tick for any reason and send it an IPI for
this purpose. As we restart the tick, we don't want to resume
from the IPI in RCU extended quiescent state anymore.
Similarly we may stop the tick from an interrupt in userspace and
we need to be able to enter RCU extended quiescent state when we
resume from this interrupt to userspace.

To these ends, we provide two new APIs:

- rcu_user_enter_irq(). This must be called from a non-nesting
interrupt betwenn rcu_irq_enter() and rcu_irq_exit().
After the irq calls rcu_irq_exit(), we'll run into RCU extended
quiescent state.

- rcu_user_exit_irq(). This must be called from a non-nesting
interrupt, interrupting an RCU extended quiescent state, and
between rcu_irq_enter() and rcu_irq_exit(). After the irq calls
rcu_irq_exit(), we'll prevent from resuming the RCU extended
quiescent.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/rcupdate.h |    2 +
 kernel/rcutree.c         |   49 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index e8323df..c0280ce 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -193,6 +193,8 @@ extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
 extern void rcu_user_enter(void);
 extern void rcu_user_exit(void);
+extern void rcu_user_enter_irq(void);
+extern void rcu_user_exit_irq(void);
 extern void exit_rcu(void);
 
 /**
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 59ac305..28e542c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -463,6 +463,30 @@ void rcu_user_enter(void)
 }
 
 /**
+ * rcu_user_enter_irq - inform RCU that we are going to resume userspace
+ * after the current irq returns.
+ *
+ * This is similar to rcu_user_enter() but in the context of a non
+ * nesting irq. After this call, RCU enters into idle mode when the
+ * interrupt returns.
+ */
+void rcu_user_enter_irq(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	/*
+	 * Ensure this irq is a non nesting one interrupting
+	 * a non-idle RCU state.
+	 */
+	WARN_ON_ONCE(rdtp->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE + 1);
+	rdtp->dynticks_nesting = 1;
+	local_irq_restore(flags);
+}
+
+/**
  * rcu_irq_exit - inform RCU that current CPU is exiting irq towards idle
  *
  * Exit from an interrupt handler, which might possibly result in entering
@@ -596,6 +620,31 @@ void rcu_user_exit(void)
 }
 
 /**
+ * rcu_user_exit_irq - inform RCU that we won't resume to userspace
+ * idle mode after the current irq returns.
+ *
+ * This is similar to rcu_user_exit() but in the context of a non
+ * nesting irq. This is called when the irq has interrupted a userspace
+ * RCU idle mode context. When the interrupt returns after this call,
+ * the CPU won't restore the RCU idle mode.
+ */
+void rcu_user_exit_irq(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	/*
+	 * Ensure this irq is a non-nesting one interrupting
+	 * an RCU idle mode.
+	 */
+	WARN_ON_ONCE(rdtp->dynticks_nesting != 1);
+	rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE + 1;
+	local_irq_restore(flags);
+}
+
+/**
  * rcu_irq_enter - inform RCU that current CPU is entering irq away from idle
  *
  * Enter an interrupt handler, which might possibly result in exiting
-- 
1.7.5.4

