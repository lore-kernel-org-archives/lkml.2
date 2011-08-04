Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab1HDIfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:35:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:48567 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab1HDIer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:34:47 -0400
Date: Thu, 4 Aug 2011 08:34:24 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-7d36b26be0f3c6b86e3ab7e1539e42f3a3bc79ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, sergey.senozhatsky@gmail.com, davej@redhat.com,
        tglx@linutronix.de, lacombar@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, sergey.senozhatsky@gmail.com,
        tglx@linutronix.de, davej@redhat.com, lacombar@gmail.com,
        mingo@elte.hu
In-Reply-To: <1311679697.24752.28.camel@twins>
References: <1311679697.24752.28.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] lockdep: Fix trace_hardirqs_on_caller()
Git-Commit-ID: 7d36b26be0f3c6b86e3ab7e1539e42f3a3bc79ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Aug 2011 08:34:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d36b26be0f3c6b86e3ab7e1539e42f3a3bc79ca
Gitweb:     http://git.kernel.org/tip/7d36b26be0f3c6b86e3ab7e1539e42f3a3bc79ca
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 26 Jul 2011 13:13:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Aug 2011 10:17:36 +0200

lockdep: Fix trace_hardirqs_on_caller()

Commit dd4e5d3ac4a ("lockdep: Fix trace_[soft,hard]irqs_[on,off]()
recursion") made a bit of a mess of the various checks and error
conditions.

In particular it moved the check for !irqs_disabled() before the
spurious enable test, resulting in some warnings.

Reported-by: Arnaud Lacombe <lacombar@gmail.com>
Reported-by: Dave Jones <davej@redhat.com>
Reported-and-tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1311679697.24752.28.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3956f51..74ca247 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2485,23 +2485,9 @@ static void __trace_hardirqs_on_caller(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
-	if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
-		return;
-
-	if (unlikely(curr->hardirqs_enabled)) {
-		/*
-		 * Neither irq nor preemption are disabled here
-		 * so this is racy by nature but losing one hit
-		 * in a stat is not a big deal.
-		 */
-		__debug_atomic_inc(redundant_hardirqs_on);
-		return;
-	}
 	/* we'll do an OFF -> ON transition: */
 	curr->hardirqs_enabled = 1;
 
-	if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
-		return;
 	/*
 	 * We are going to turn hardirqs on, so set the
 	 * usage bit for all held locks:
@@ -2529,9 +2515,25 @@ void trace_hardirqs_on_caller(unsigned long ip)
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
+	if (unlikely(current->hardirqs_enabled)) {
+		/*
+		 * Neither irq nor preemption are disabled here
+		 * so this is racy by nature but losing one hit
+		 * in a stat is not a big deal.
+		 */
+		__debug_atomic_inc(redundant_hardirqs_on);
+		return;
+	}
+
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return;
 
+	if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
+		return;
+
+	if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
+		return;
+
 	current->lockdep_recursion = 1;
 	__trace_hardirqs_on_caller(ip);
 	current->lockdep_recursion = 0;
