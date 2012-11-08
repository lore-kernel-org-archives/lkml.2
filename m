Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab2KHNPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:15:12 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51151 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab2KHNPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:15:08 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anish Kumar <anish198519851985@gmail.com>
Subject: [PATCH 1/7] irq_work: Fix racy IRQ_WORK_BUSY flag setting
Date: Thu,  8 Nov 2012 14:14:52 +0100
Message-Id: <1352380498-23132-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1352380498-23132-1-git-send-email-fweisbec@gmail.com>
References: <1352380498-23132-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IRQ_WORK_BUSY flag is set right before we execute the
work. Once this flag value is set, the work enters a
claimable state again.

So if we have specific data to compute in our work, we ensure it's
either handled by another CPU or locally by enqueuing the work again.
This state machine is guanranteed by atomic operations on the flags.

So when we set IRQ_WORK_BUSY without using an xchg-like operation,
we break this guarantee as in the following summarized scenario:

        CPU 1                                   CPU 2
        -----                                   -----
                                                (flags = 0)
                                                old_flags = flags;
        (flags = 0)
        cmpxchg(flags, old_flags,
                old_flags | IRQ_WORK_FLAGS)
        (flags = 3)
        [...]
        flags = IRQ_WORK_BUSY
        (flags = 2)
        func()
                                                (sees flags = 3)
                                                cmpxchg(flags, old_flags,
                                                        old_flags | IRQ_WORK_FLAGS)
                                                (give up)

        cmpxchg(flags, 2, 0);
        (flags = 0)

CPU 1 claims a work and executes it, so it sets IRQ_WORK_BUSY and
the work is again in a claimable state. Now CPU 2 has new data to process
and try to claim that work but it may see a stale value of the flags
and think the work is still pending somewhere that will handle our data.
This is because CPU 1 doesn't set IRQ_WORK_BUSY atomically.

As a result, the data expected to be handle by CPU 2 won't get handled.

To fix this, use xchg() to set IRQ_WORK_BUSY, this way we ensure the CPU 2
will see the correct value with cmpxchg() using the expected ordering.

Changelog-heavily-inspired-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Anish Kumar <anish198519851985@gmail.com>
---
 kernel/irq_work.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 1588e3b..57be1a6 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -119,8 +119,11 @@ void irq_work_run(void)
 		/*
 		 * Clear the PENDING bit, after this point the @work
 		 * can be re-used.
+		 * Make it immediately visible so that other CPUs trying
+		 * to claim that work don't rely on us to handle their data
+		 * while we are in the middle of the func.
 		 */
-		work->flags = IRQ_WORK_BUSY;
+		xchg(&work->flags, IRQ_WORK_BUSY);
 		work->func(work);
 		/*
 		 * Clear the BUSY bit and return to the free state if
-- 
1.7.5.4

