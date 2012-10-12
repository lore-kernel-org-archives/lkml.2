Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085Ab2JLSJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:09:58 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37825 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760062Ab2JLSJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:09:51 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC PATCH 5/5] printk: Wake up klogd with irq_work on nohz CPU
Date: Fri, 12 Oct 2012 20:09:36 +0200
Message-Id: <1350065376-23353-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
References: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

klogd is woken up asynchronously from the tick in order
to do it safely.

However if printk is called when the tick is stopped, the reader
won't be woken up until the next interrupt, which might not fire
before a while. As a result, the user may miss some message.

To fix this we try to schedule the wake up into an irq work
when the tick is stopped and irq work is not implemented on top
of the tick.

Ideally we could always rely on irq work for this to simplify the
code. But this may result in too much interrupts in case we have
a lot of printk calls in a short period of time. So we do this when
the tick is stopped only.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/printk.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 66a2ea3..c8ab918 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -42,6 +42,8 @@
 #include <linux/notifier.h>
 #include <linux/rculist.h>
 #include <linux/poll.h>
+#include <linux/tick.h>
+#include <linux/irq_work.h>
 
 #include <asm/uaccess.h>
 
@@ -1976,10 +1978,50 @@ int printk_needs_cpu(int cpu)
 	return __this_cpu_read(printk_pending);
 }
 
+#ifdef CONFIG_IRQ_WORK
+static void wake_klogd_irq_work(struct irq_work *irq_work)
+{
+	printk_tick();
+}
+#endif
+
+/*
+ * When the tick is stopped, we need another way to wake up
+ * klogd safely.
+ */
+static void wake_up_klogd_nohz(void)
+{
+	/*
+	 * If irq work is not itself implemented using the tick
+	 * it's a safe and fast way to wake up the reader.
+	 */
+#ifdef CONFIG_IRQ_WORK
+	if (!arch_irq_work_use_tick()) {
+		static struct irq_work klogd_irq_work = {
+			.func = wake_klogd_irq_work
+		};
+
+		irq_work_queue(&klogd_irq_work);
+		return;
+	}
+#endif
+	/*
+	 * Our last resort in the case of idle is to bet
+	 * on the fact we haven't yet reached the last need_resched()
+	 * check before the CPU goes to halt. This way we go through
+	 * another idle loop to recheck printk_needs_cpu().
+	 */
+	if (is_idle_task(current))
+		set_need_resched();
+}
+
 void wake_up_klogd(void)
 {
 	if (waitqueue_active(&log_wait))
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
+
+	if (tick_nohz_tick_stopped())
+		wake_up_klogd_nohz();
 }
 
 static void console_cont_flush(char *text, size_t size)
-- 
1.7.5.4

