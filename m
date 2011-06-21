Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab1FUPl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:41:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:41578 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab1FUPkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:40:36 -0400
Message-Id: <20110621153806.185242734@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 21 Jun 2011 17:17:27 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, efault@gmx.de,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4] lockdep: Fix trace_{soft,hard}irqs_{on,off}() recursion
References: <20110621151725.705140475@chello.nl>
Content-Disposition: inline; filename=lockdep-trace_irq-recursion.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1efc5da3 explains the reason for having raw_local_irq_*() and
lockdep_off() in printk(). Instead of working around the broken
recursion detection of interrupt state tracking, fix it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2478,15 +2478,10 @@ mark_held_locks(struct task_struct *curr
 /*
  * Hardirqs will be enabled:
  */
-void trace_hardirqs_on_caller(unsigned long ip)
+static void __trace_hardirqs_on_caller(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
-	time_hardirqs_on(CALLER_ADDR0, ip);
-
-	if (unlikely(!debug_locks || current->lockdep_recursion))
-		return;
-
 	if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
 		return;
 
@@ -2502,8 +2497,6 @@ void trace_hardirqs_on_caller(unsigned l
 	/* we'll do an OFF -> ON transition: */
 	curr->hardirqs_enabled = 1;
 
-	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
-		return;
 	if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
 		return;
 	/*
@@ -2525,6 +2518,21 @@ void trace_hardirqs_on_caller(unsigned l
 	curr->hardirq_enable_event = ++curr->irq_events;
 	debug_atomic_inc(hardirqs_on_events);
 }
+
+void trace_hardirqs_on_caller(unsigned long ip)
+{
+	time_hardirqs_on(CALLER_ADDR0, ip);
+
+	if (unlikely(!debug_locks || current->lockdep_recursion))
+		return;
+
+	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
+		return;
+
+	current->lockdep_recursion = 1;
+	__trace_hardirqs_on_caller(ip);
+	current->lockdep_recursion = 0;
+}
 EXPORT_SYMBOL(trace_hardirqs_on_caller);
 
 void trace_hardirqs_on(void)
@@ -2574,7 +2582,7 @@ void trace_softirqs_on(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
-	if (unlikely(!debug_locks))
+	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
@@ -2585,6 +2593,7 @@ void trace_softirqs_on(unsigned long ip)
 		return;
 	}
 
+	current->lockdep_recursion = 1;
 	/*
 	 * We'll do an OFF -> ON transition:
 	 */
@@ -2599,6 +2608,7 @@ void trace_softirqs_on(unsigned long ip)
 	 */
 	if (curr->hardirqs_enabled)
 		mark_held_locks(curr, SOFTIRQ);
+	current->lockdep_recursion = 0;
 }
 
 /*
@@ -2608,7 +2618,7 @@ void trace_softirqs_off(unsigned long ip
 {
 	struct task_struct *curr = current;
 
-	if (unlikely(!debug_locks))
+	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))


