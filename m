Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2KRBFO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 20:05:14 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42374 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab2KRBFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 20:05:08 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 5/9] irq_work: Don't stop the tick with pending works
Date: Sun, 18 Nov 2012 02:04:48 +0100
Message-Id: <1353200692-6039-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353200692-6039-1-git-send-email-fweisbec@gmail.com>
References: <1353200692-6039-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't stop the tick if we have pending irq works on the
queue, otherwise if the arch can't raise self-IPIs, we may not
find an opportunity to execute the pending works for a while.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/irq_work.h |    6 ++++++
 kernel/irq_work.c        |   11 +++++++++++
 kernel/time/tick-sched.c |    3 ++-
 3 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6a9e8f5..a69704f 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -20,4 +20,10 @@ bool irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
 
+#ifdef CONFIG_IRQ_WORK
+bool irq_work_needs_cpu(void);
+#else
+static bool irq_work_needs_cpu(void) { return false; }
+#endif
+
 #endif /* _LINUX_IRQ_WORK_H */
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 64eddd5..b3c113a 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -99,6 +99,17 @@ bool irq_work_queue(struct irq_work *work)
 }
 EXPORT_SYMBOL_GPL(irq_work_queue);
 
+bool irq_work_needs_cpu(void)
+{
+	struct llist_head *this_list;
+
+	this_list = &__get_cpu_var(irq_work_list);
+	if (llist_empty(this_list))
+		return false;
+
+	return true;
+}
+
 /*
  * Run the irq_work entries on this cpu. Requires to be ran from hardirq
  * context with local IRQs disabled.
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9e945aa..f249e8c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -20,6 +20,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/irq_work.h>
 
 #include <asm/irq_regs.h>
 
@@ -289,7 +290,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu)) {
+	    arch_needs_cpu(cpu) || irq_work_needs_cpu()) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {
-- 
1.7.5.4

