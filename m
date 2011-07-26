Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1GZL2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 07:28:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54477 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab1GZL2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 07:28:44 -0400
Subject: Re: [GIT PULL] core/printk changes for v3.1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        SergeySenozhatsky <sergey.senozhatsky@gmail.com>,
        DaveJones <davej@redhat.com>
In-Reply-To: <CACqU3MW-7_gCqNARdrPA5rZoZGLti+DMvkZsJN40VSDtU+VhpQ@mail.gmail.com>
References: <20110722125934.GA25433@elte.hu>
	 <CACqU3MW-7_gCqNARdrPA5rZoZGLti+DMvkZsJN40VSDtU+VhpQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Jul 2011 13:28:17 +0200
Message-ID: <1311679697.24752.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 14:20 -0400, Arnaud Lacombe wrote:

> > Peter Zijlstra (3):
> >      [...]
> >      lockdep: Fix trace_[soft,hard]irqs_[on,off]() recursion
> >
> This commit is triggering:
> 
> WARNING: at /src/linux/linux/kernel/lockdep.c:2529

Not actually having reproduced the problem, does the below cure things?

---
Subject: lockdep: Fix trace_hardirqs_on_caller()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Jul 26 13:13:44 CEST 2011

Commit dd4e5d3ac4a ("lockdep: Fix trace_[soft,hard]irqs_[on,off]()
recursion") made a bit of a mess of the various checks and error
conditions.

In particular it moved the check for !irqs_disabled() before the
spurious enable test, resulting in some warnings.

Reported-by: Arnaud Lacombe <lacombar@gmail.com>
Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2485,23 +2485,9 @@ static void __trace_hardirqs_on_caller(u
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
@@ -2529,9 +2515,25 @@ void trace_hardirqs_on_caller(unsigned l
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

