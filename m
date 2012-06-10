Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab2FJVrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 17:47:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44416 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab2FJVrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 17:47:31 -0400
Date: Sun, 10 Jun 2012 23:47:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
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
Subject: [PATCH v2] rcu: Allow calls to rcu_exit_user_irq from nesting irqs
Message-ID: <20120610214722.GE31957@somewhere.redhat.com>
References: <1338811708-18819-1-git-send-email-fweisbec@gmail.com>
 <20120604181313.GL2490@linux.vnet.ibm.com>
 <CAFTL4hzqa1z4icSBwEqZXLjCrVsG+axm2TaGSaaMXkjazT0Qfw@mail.gmail.com>
 <20120604210709.GO2490@linux.vnet.ibm.com>
 <20120605103055.GA4553@somewhere.redhat.com>
 <20120605234640.GY2388@linux.vnet.ibm.com>
 <20120609225550.GB31957@somewhere.redhat.com>
 <20120610180659.GD2425@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120610180659.GD2425@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sat, 9 Jun 2012 14:06:30 +0200
Subject: [PATCH] rcu: Allow calls to rcu_exit_user_irq from nesting irqs

rcu_exit_user_irq() which exits RCU idle mode after the current
irq returns has been designed to be called from non nesting irqs
only.

However the IPI that restarts the tick and exits RCU user-idle mode
in nohz cpusets can happen anytime. For example it can be a nesting
irq by interrupting a softirq. In this case the stack of RCU API
calls becomes:

==> IRQ
    rcu_irq_enter()
    ....
    do_softirq {
===== > IRQ (restart tick IPI)
        rcu_irq_enter()
        rcu_exit_user_irq()
        rcu_irq_exit()
<=====
    }
    rcu_irq_exit();

Hence we need to make rcu_exit_user_irq() callable from any nesting
level of interrupt.

v2: rcu_user_enter_irq() is only called from non nesting irqs though so
the change doesn't need to be propagated to it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/rcutree.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1b0dca2..7a54265 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -619,12 +619,12 @@ void rcu_user_exit(void)
 
 /**
  * rcu_user_exit_irq - inform RCU that we won't resume to userspace
- * idle mode after the current irq returns.
+ * idle mode after the current non-nesting irq returns.
  *
- * This is similar to rcu_user_exit() but in the context of a non
- * nesting irq. This is called when the irq has interrupted a userspace
- * RCU idle mode context. When the interrupt returns after this call,
- * the CPU won't restore the RCU idle mode.
+ * This is similar to rcu_user_exit() but in the context of an
+ * irq. This is called when the irq has interrupted a userspace
+ * RCU idle mode context. When the current non-nesting interrupt
+ * returns after this call, the CPU won't restore the RCU idle mode.
  */
 void rcu_user_exit_irq(void)
 {
@@ -633,12 +633,9 @@ void rcu_user_exit_irq(void)
 
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	/*
-	 * Ensure this irq is a non-nesting one interrupting
-	 * an RCU idle mode.
-	 */
-	WARN_ON_ONCE(rdtp->dynticks_nesting != 1);
-	rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE + 1;
+	/* Ensure we are interrupting an RCU idle mode. */
+	WARN_ON_ONCE(rdtp->dynticks_nesting & DYNTICK_TASK_NEST_MASK);
+	rdtp->dynticks_nesting += DYNTICK_TASK_EXIT_IDLE;
 	local_irq_restore(flags);
 }
 
-- 
1.7.0.4

