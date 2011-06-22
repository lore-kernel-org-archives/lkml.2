Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab1FVPN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:13:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:38778 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab1FVPN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:13:56 -0400
Date: Wed, 22 Jun 2011 15:13:41 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-dd4e5d3ac4a76b868daf30e35bd572def96c30ed@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110621153806.185242734@chello.nl>
References: <20110621153806.185242734@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/printk] lockdep: Fix trace_[soft,hard]irqs_[on,off]() recursion
Git-Commit-ID: dd4e5d3ac4a76b868daf30e35bd572def96c30ed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Jun 2011 15:13:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd4e5d3ac4a76b868daf30e35bd572def96c30ed
Gitweb:     http://git.kernel.org/tip/dd4e5d3ac4a76b868daf30e35bd572def96c30ed
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 21 Jun 2011 17:17:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Jun 2011 11:39:34 +0200

lockdep: Fix trace_[soft,hard]irqs_[on,off]() recursion

Commit:

  1efc5da3cf56: [PATCH] order of lockdep off/on in vprintk() should be changed

explains the reason for having raw_local_irq_*() and lockdep_off()
in printk(). Instead of working around the broken recursion detection
of interrupt state tracking, fix it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: efault@gmx.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110621153806.185242734@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 63437d0..81968a0 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2478,15 +2478,10 @@ mark_held_locks(struct task_struct *curr, enum mark_type mark)
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
 
@@ -2502,8 +2497,6 @@ void trace_hardirqs_on_caller(unsigned long ip)
 	/* we'll do an OFF -> ON transition: */
 	curr->hardirqs_enabled = 1;
 
-	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
-		return;
 	if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
 		return;
 	/*
@@ -2525,6 +2518,21 @@ void trace_hardirqs_on_caller(unsigned long ip)
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
@@ -2608,7 +2618,7 @@ void trace_softirqs_off(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
-	if (unlikely(!debug_locks))
+	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
