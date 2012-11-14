Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab2KNUiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:38:04 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52548 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933098Ab2KNUh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:37:59 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anish Kumar <anish198519851985@gmail.com>
Subject: [PATCH 2/7] irq_work: Fix racy check on work pending flag
Date: Wed, 14 Nov 2012 21:37:32 +0100
Message-Id: <1352925457-15700-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1352925457-15700-1-git-send-email-fweisbec@gmail.com>
References: <1352925457-15700-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Work claiming wants to be SMP-safe.

And by the time we try to claim a work, if it is already executing
concurrently on another CPU, we want to succeed the claiming and queue
the work again because the other CPU may have missed the data we wanted
to handle in our work if it's about to complete there.

This scenario is summarized below:

        CPU 1                                   CPU 2
        -----                                   -----
        (flags = 0)
        cmpxchg(flags, 0, IRQ_WORK_FLAGS)
        (flags = 3)
        [...]
        xchg(flags, IRQ_WORK_BUSY)
        (flags = 2)
        func()
                                                if (flags & IRQ_WORK_PENDING)
                                                        (not true)
                                                cmpxchg(flags, flags, IRQ_WORK_FLAGS)
                                                (flags = 3)
                                                [...]
        cmpxchg(flags, IRQ_WORK_BUSY, 0);
        (fail, pending on CPU 2)

This state machine is synchronized using [cmp]xchg() on the flags.
As such, the early IRQ_WORK_PENDING check in CPU 2 above is racy.
By the time we check it, we may be dealing with a stale value because
we aren't using an atomic accessor. As a result, CPU 2 may "see"
that the work is still pending on another CPU while it may be
actually completing the work function exection already, leaving
our data unprocessed.

To fix this, we start by speculating about the value we wish to be
in the work->flags but we only make any conclusion after the value
returned by the cmpxchg() call that either claims the work or let
the current owner handle the pending work for us.

Changelog-heavily-inspired-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Anish Kumar <anish198519851985@gmail.com>
---
 kernel/irq_work.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 57be1a6..64eddd5 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -34,15 +34,21 @@ static DEFINE_PER_CPU(struct llist_head, irq_work_list);
  */
 static bool irq_work_claim(struct irq_work *work)
 {
-	unsigned long flags, nflags;
+	unsigned long flags, oflags, nflags;
 
+	/*
+	 * Start with our best wish as a premise but only trust any
+	 * flag value after cmpxchg() result.
+	 */
+	flags = work->flags & ~IRQ_WORK_PENDING;
 	for (;;) {
-		flags = work->flags;
-		if (flags & IRQ_WORK_PENDING)
-			return false;
 		nflags = flags | IRQ_WORK_FLAGS;
-		if (cmpxchg(&work->flags, flags, nflags) == flags)
+		oflags = cmpxchg(&work->flags, flags, nflags);
+		if (oflags == flags)
 			break;
+		if (oflags & IRQ_WORK_PENDING)
+			return false;
+		flags = oflags;
 		cpu_relax();
 	}
 
-- 
1.7.5.4

