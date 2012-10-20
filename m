Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2JTQXx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:23:53 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:59192 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab2JTQXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:23:02 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 6/8] irq_work: Handle queuing without IPI support in dyntick idle mode
Date: Sat, 20 Oct 2012 12:22:45 -0400
Message-Id: <1350750167-14263-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
References: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
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
index 19f537b..f3bdcf4 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -71,6 +71,17 @@ static void __irq_work_queue(struct irq_work *work, bool ipi)
 		 */
 		if (ipi || !arch_irq_work_has_ipi() || tick_nohz_tick_stopped())
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
 	preempt_enable();
 }
-- 
1.7.5.4

