Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051Ab2J2N36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:29:58 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44308 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758625Ab2J2N2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:28:38 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 8/9] irq_work: Handle queuing without IPI support in dyntick idle mode
Date: Mon, 29 Oct 2012 14:28:15 +0100
Message-Id: <1351517296-9173-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
References: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we enqueue a work while in dyntick idle mode and the arch doesn't
have self-IPI support, we may not find an opportunity to run the work
before a while.

In this case, exit the idle loop to re-evaluate irq_work_needs_cpu()
and restart the tick.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/irq_work.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index ce72b20..b500271 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -76,6 +76,17 @@ static void __irq_work_queue(struct irq_work *work)
 		 */
 		if (!arch_irq_work_has_ipi() || tick_nohz_tick_stopped())
 			arch_irq_work_raise();
+
+		/*
+		 * If we rely on the timer tick or some obscure way to run the work
+		 * while the CPU is in dyntick idle mode, we may not have an opportunity
+		 * to do so before a while. Let's just exit the idle loop and hope we
+		 * haven't yet reached the last need_resched() check before the CPU goes
+		 * to low power mode.
+		 */
+		if (!arch_irq_work_has_ipi() && tick_nohz_tick_stopped()
+		    && is_idle_task(current))
+			set_need_resched();
 	}
 out:
 	preempt_enable();
-- 
1.7.5.4

