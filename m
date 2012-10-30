Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797Ab2J3PfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:35:19 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35365 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758983Ab2J3PfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:35:12 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 2/2] irq_work: Fix racy IRQ_WORK_BUSY flag setting
Date: Tue, 30 Oct 2012 16:35:01 +0100
Message-Id: <1351611301-3520-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IRQ_WORK_BUSY flag is set right before we execute the
work. Once this flag value is set, the work enters a
claimable state again.

This is necessary because if we want to enqueue a work but we
fail the claim, we want to ensure that the CPU where that work
is still pending will see and handle the data we expected the
work to compute.

This might not work as expected though because IRQ_WORK_BUSY
isn't set atomically. By the time a CPU fails a work claim,
this work may well have been already executed by the CPU where
it was previously pending.

Due to the lack of appropriate memory barrier, the IRQ_WORK_BUSY
flag value may not be visible by the CPU trying to claim while
the work is executing, and that until we clear the busy bit in
the work flags using cmpxchg() that implies the full barrier.

One solution could involve a full barrier between setting
IRQ_WORK_BUSY flag and the work execution. This way we
ensure that the work execution site sees the expected data
and the claim site sees the IRQ_WORK_BUSY:

CPU 0                                 CPU 1

data = something                     flags = IRQ_WORK_BUSY
smp_mb() (implicit with cmpxchg      smp_mb()
          on flags in claim)         execute_work (sees data from CPU 0)
try to claim

As a shortcut, let's just use xchg() that implies a full memory
barrier.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/irq_work.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 764240a..ea79365 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -130,9 +130,12 @@ void irq_work_run(void)
 
 		/*
 		 * Clear the PENDING bit, after this point the @work
-		 * can be re-used.
+		 * can be re-used. Use xchg to force ordering against
+		 * data to process, such that if claiming fails on
+		 * another CPU, we see and handle the data it wants
+		 * us to process on the work.
 		 */
-		work->flags = IRQ_WORK_BUSY;
+		xchg(&work->flags, IRQ_WORK_BUSY);
 		work->func(work);
 		/*
 		 * Clear the BUSY bit and return to the free state if
-- 
1.7.5.4

