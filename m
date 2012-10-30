Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534Ab2J3PfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:35:12 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41569 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab2J3PfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:35:10 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/2] irq_work: Fix racy check on work pending flag
Date: Tue, 30 Oct 2012 16:35:00 +0100
Message-Id: <1351611301-3520-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Work claiming semantics require this operation
to be SMP-safe.

So we want a strict ordering between the data we
want the work to handle and the flags that describe
the work state such that either we claim and we enqueue
the work that will see our data or we fail the claim
but the CPU where the work is still pending will
see the data we prepared when it executes the work:

CPU 0                   CPU 1

data = something        claim work
smp_mb()                smp_mb()
try claim work          execute work (data)

The early check for the pending flag in irq_work_claim()
fails to meet this ordering requirement. As a result,
when we fail to claim a work, it may have been processed
by CPU that were previously owning it already, leaving
our data unprocessed.

Discussing this with Steven Rostedt, we can use memory
barriers to fix this or we can rely on cmpxchg() that
implies full barrier already.

To fix this, we start by speculating about the value we
wish to be in the work->flags but we only make any conclusion
after the value returned by the cmpxchg() call that either
claims the work or does the ordering such that the CPU
where the work is pending handles our data.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/irq_work.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 1588e3b..764240a 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -34,15 +34,27 @@ static DEFINE_PER_CPU(struct llist_head, irq_work_list);
  */
 static bool irq_work_claim(struct irq_work *work)
 {
-	unsigned long flags, nflags;
+	unsigned long flags, oflags, nflags;
 
+	/*
+	 * Can't check IRQ_WORK_PENDING bit right now because the work
+	 * can be running on another CPU and we need correct ordering
+	 * between work flags and data to compute in work execution
+	 * such that either we claim and we execute the work or the work
+	 * is still pending on another CPU but it's guaranteed it will see
+	 * our data when it executes the work.
+	 * Start with our best wish as a premise but only deal with
+	 * flags value for real after cmpxchg() ordering.
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

