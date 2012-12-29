Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab2L2QoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 11:44:18 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:34717 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2L2QoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 11:44:13 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 25/27] rcu: Don't keep the tick for RCU while in userspace
Date: Sat, 29 Dec 2012 17:43:04 +0100
Message-Id: <1356799386-4212-26-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we are interrupting userspace, we don't need to keep
the tick for RCU: quiescent states don't need to be reported
because we soon run in userspace and local callbacks are handled
by the nocb threads.

CHECKME: Do the nocb threads actually handle the global
grace period completion for local callbacks?

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 0e1ebff..76d1b08 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/irq_work.h>
 #include <linux/posix-timers.h>
+#include <linux/context_tracking.h>
 
 #include <asm/irq_regs.h>
 
@@ -604,10 +605,9 @@ static bool can_stop_full_tick(int cpu)
 
 	/*
 	 * Keep the tick if we are asked to report a quiescent state.
-	 * This must be further optimized (avoid checks for local callbacks,
-	 * ignore RCU in userspace, etc...
+	 * This must be further optimized (avoid checks for local callbacks)
 	 */
-	if (rcu_pending(cpu)) {
+	if (!context_tracking_in_user() && rcu_pending(cpu)) {
 		trace_printk("Can't stop: RCU pending\n");
 		return false;
 	}
-- 
1.7.5.4

