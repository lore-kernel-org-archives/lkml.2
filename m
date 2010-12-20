Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab0LTPZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:25:32 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:54867 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526Ab0LTPZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:25:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HlnlJiX8VJ2vOzDYohCAR/BTloFoz0kLum+T3p6oEPwTqkruEZqGDrnkSGh81dNoJT
         VopjS4/MM1UZh1Q8DXH5f6ntR0B0CVl5vHiWuDCXlecGr59gkR1enrvJKVayBGzowZ3m
         RL04cvxqGWpUx28jmPaXW/JBwEdL5k0uj1a+U=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [RFC PATCH 14/15] nohz_task: Clear nohz task attribute on exit()
Date: Mon, 20 Dec 2010 16:24:21 +0100
Message-Id: <1292858662-5650-15-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear the nohz task attribute when a task exits, clear the cpu
mask and restart the tick if necessary.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 include/linux/tick.h     |    2 ++
 kernel/exit.c            |    3 +++
 kernel/time/tick-sched.c |   20 ++++++++++++++++++++
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index a704bb7..37af961 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -137,6 +137,7 @@ extern void tick_nohz_task_enter_kernel(void);
 extern void tick_nohz_task_exit_kernel(void);
 extern void tick_nohz_task_enter_exception(struct pt_regs *regs);
 extern void tick_nohz_task_exit_exception(struct pt_regs *regs);
+extern void tick_nohz_task_clear(void);
 extern int tick_nohz_task_mode(void);
 
 #else /* !NO_HZ_TASK */
@@ -144,6 +145,7 @@ static inline void tick_nohz_task_enter_kernel(void) { }
 static inline void tick_nohz_task_exit_kernel(void) { }
 static inline void tick_nohz_task_enter_exception(struct pt_regs *regs) { }
 static inline void tick_nohz_task_exit_exception(struct pt_regs *regs) { }
+static inline void tick_nohz_task_clear(void) { }
 static inline int tick_nohz_task_mode(void) { return 0; }
 #endif /* !NO_HZ_TASK */
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 676149a..250d832 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -51,6 +51,7 @@
 #include <trace/events/sched.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/oom.h>
+#include <linux/tick.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -1013,6 +1014,8 @@ NORET_TYPE void do_exit(long code)
 	 */
 	perf_event_exit_task(tsk);
 
+	tick_nohz_task_clear();
+
 	exit_notify(tsk, group_dead);
 #ifdef CONFIG_NUMA
 	task_lock(tsk);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9a4aa39..06379eb 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -720,6 +720,26 @@ void tick_check_idle(int cpu)
 }
 
 #ifdef CONFIG_NO_HZ_TASK
+void tick_nohz_task_clear(void)
+{
+	int cpu = raw_smp_processor_id();
+
+	if (!test_thread_flag(TIF_NOHZ))
+		return;
+
+	set_cpu_has_nohz_task(cpu, 0);
+	clear_tsk_thread_flag(current, TIF_NOHZ);
+
+	local_irq_disable();
+
+	if (__get_cpu_var(task_nohz_mode))
+		tick_nohz_restart_sched_tick();
+
+	__get_cpu_var(task_nohz_mode) = 0;
+
+	local_irq_enable();
+}
+
 DEFINE_PER_CPU(int, nohz_task_ext_qs);
 
 void tick_nohz_task_exit_kernel(void)
-- 
1.7.3.2

