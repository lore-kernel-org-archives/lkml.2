Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab2JTQX0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:23:26 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36196 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab2JTQXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:23:04 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 8/8] printk: Wake up klogd using irq_work
Date: Sat, 20 Oct 2012 12:22:47 -0400
Message-Id: <1350750167-14263-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
References: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

klogd is woken up asynchronously from the tick in order
to do it safely.

However if printk is called when the tick is stopped, the reader
won't be woken up until the next interrupt, which might not fire
before a while. As a result, the user may miss some message.

To fix this, lets implement the printk tick using irq work.
This subsystem takes care of the timer tick state and can
fix up accordingly.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/printk.h   |    3 ---
 init/Kconfig             |    1 +
 kernel/printk.c          |   14 +++++++-------
 kernel/time/tick-sched.c |    2 +-
 kernel/timer.c           |    1 -
 5 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 9afc01e..86c4b62 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -98,9 +98,6 @@ int no_printk(const char *fmt, ...)
 extern asmlinkage __printf(1, 2)
 void early_printk(const char *fmt, ...);
 
-extern int printk_needs_cpu(int cpu);
-extern void printk_tick(void);
-
 #ifdef CONFIG_PRINTK
 asmlinkage __printf(5, 0)
 int vprintk_emit(int facility, int level,
diff --git a/init/Kconfig b/init/Kconfig
index 8ba9fc3..9c42e6a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1184,6 +1184,7 @@ config HOTPLUG
 config PRINTK
 	default y
 	bool "Enable support for printk" if EXPERT
+	select IRQ_WORK
 	help
 	  This option enables normal printk support. Removing it
 	  eliminates most of the message strings from the kernel image
diff --git a/kernel/printk.c b/kernel/printk.c
index 66a2ea3..721f760 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -42,6 +42,7 @@
 #include <linux/notifier.h>
 #include <linux/rculist.h>
 #include <linux/poll.h>
+#include <linux/irq_work.h>
 
 #include <asm/uaccess.h>
 
@@ -1956,7 +1957,7 @@ int is_console_locked(void)
 static DEFINE_PER_CPU(int, printk_pending);
 static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
 
-void printk_tick(void)
+static void wake_up_klogd_work_func(struct irq_work *irq_work)
 {
 	if (__this_cpu_read(printk_pending)) {
 		int pending = __this_cpu_xchg(printk_pending, 0);
@@ -1969,17 +1970,16 @@ void printk_tick(void)
 	}
 }
 
-int printk_needs_cpu(int cpu)
-{
-	if (cpu_is_offline(cpu))
-		printk_tick();
-	return __this_cpu_read(printk_pending);
-}
+static struct irq_work wake_up_klogd_work = {
+		.func = wake_up_klogd_work_func
+};
 
 void wake_up_klogd(void)
 {
 	if (waitqueue_active(&log_wait))
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
+
+	irq_work_queue(&wake_up_klogd_work, false);
 }
 
 static void console_cont_flush(char *text, size_t size)
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 5f87bb5..04dd027 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -288,7 +288,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 		time_delta = timekeeping_max_deferment();
 	} while (read_seqretry(&xtime_lock, seq));
 
-	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) || printk_needs_cpu(cpu) ||
+	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
 	    arch_needs_cpu(cpu) || irq_work_needs_cpu()) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
diff --git a/kernel/timer.c b/kernel/timer.c
index d5de1b2..5d6d0f1 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1349,7 +1349,6 @@ void update_process_times(int user_tick)
 	account_process_tick(p, user_tick);
 	run_local_timers();
 	rcu_check_callbacks(cpu, user_tick);
-	printk_tick();
 #ifdef CONFIG_IRQ_WORK
 	if (in_irq())
 		irq_work_run();
-- 
1.7.5.4

