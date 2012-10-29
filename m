Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab2J2N20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:28:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44308 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854Ab2J2N2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:28:24 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 1/9] irq_work: Fix racy check on work pending flag
Date: Mon, 29 Oct 2012 14:28:08 +0100
Message-Id: <1351517296-9173-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
References: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Context requirements on irq work claim are not entirely
clear. But it appears that we can try to claim a work that
may be already claimed by another CPU.

If so then the early check on IRQ_WORK_PENDING in
irq_work_claim() is racy because another CPU may be
changing the flags concurrently and we have nothing
to synchronize against that. So the value we deal with
may be stale for a while already.

To fix this, start with our best wish as the initial
value for the work flags and feed cmpxchg with it. But
only do the check against IRQ_WORK_PENDING flag with the
cmpxchg result.

Nonetheless, if the work is not pending but our best wish
was wrong, restart with the old value returned by cmpxchg.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/irq_work.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 1588e3b..679c13e 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -34,15 +34,22 @@ static DEFINE_PER_CPU(struct llist_head, irq_work_list);
  */
 static bool irq_work_claim(struct irq_work *work)
 {
-	unsigned long flags, nflags;
+	unsigned long flags, oflags, nflags;
 
+	/*
+	 * Can't check IRQ_WORK_PENDING bit right now because the work
+	 * can be running on another CPU and we are not sync with its
+	 * changes to work flags. Only cmpxchg can reliably check for us.
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

