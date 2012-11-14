Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161287Ab2KNQ1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:27:15 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39817 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161278Ab2KNQ1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:27:09 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 2/4] vtime: Explicitly account pending user time on process tick
Date: Wed, 14 Nov 2012 17:26:51 +0100
Message-Id: <1352910413-10759-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1352910413-10759-1-git-send-email-fweisbec@gmail.com>
References: <1352910413-10759-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All vtime implementations just flush the user time on process
tick. Consolidate that in generic code by calling a user time
accounting helper. This avoids an indirect call in ia64 and
prepare to also consolidate vtime context switch code.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/ia64/kernel/time.c     |   11 +----------
 arch/powerpc/kernel/time.c  |   14 +++++++-------
 arch/s390/kernel/vtime.c    |    7 ++++++-
 include/linux/kernel_stat.h |    8 ++++++++
 include/linux/vtime.h       |    1 +
 5 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index f638821..834c78b 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -83,7 +83,7 @@ static struct clocksource *itc_clocksource;
 
 extern cputime_t cycle_to_cputime(u64 cyc);
 
-static void vtime_account_user(struct task_struct *tsk)
+void vtime_account_user(struct task_struct *tsk)
 {
 	cputime_t delta_utime;
 	struct thread_info *ti = task_thread_info(tsk);
@@ -147,15 +147,6 @@ void vtime_account_idle(struct task_struct *tsk)
 	account_idle_time(vtime_delta(tsk));
 }
 
-/*
- * Called from the timer interrupt handler to charge accumulated user time
- * to the current process.  Must be called with interrupts disabled.
- */
-void account_process_tick(struct task_struct *p, int user_tick)
-{
-	vtime_account_user(p);
-}
-
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 
 static irqreturn_t
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index ce4cb77..a667aaf 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -355,15 +355,15 @@ void vtime_account_idle(struct task_struct *tsk)
 }
 
 /*
- * Transfer the user and system times accumulated in the paca
- * by the exception entry and exit code to the generic process
- * user and system time records.
+ * Transfer the user time accumulated in the paca
+ * by the exception entry and exit code to the generic
+ * process user time records.
  * Must be called with interrupts disabled.
- * Assumes that vtime_account() has been called recently
- * (i.e. since the last entry from usermode) so that
+ * Assumes that vtime_account_system/idle() has been called
+ * recently (i.e. since the last entry from usermode) so that
  * get_paca()->user_time_scaled is up to date.
  */
-void account_process_tick(struct task_struct *tsk, int user_tick)
+void vtime_account_user(struct task_struct *tsk)
 {
 	cputime_t utime, utimescaled;
 
@@ -378,7 +378,7 @@ void account_process_tick(struct task_struct *tsk, int user_tick)
 void vtime_task_switch(struct task_struct *prev)
 {
 	vtime_account(prev);
-	account_process_tick(prev, 0);
+	vtime_account_user(prev);
 }
 
 #else /* ! CONFIG_VIRT_CPU_ACCOUNTING */
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 80d1dbc..7c6d861 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -112,7 +112,12 @@ void vtime_task_switch(struct task_struct *prev)
 	S390_lowcore.system_timer = ti->system_timer;
 }
 
-void account_process_tick(struct task_struct *tsk, int user_tick)
+/*
+ * In s390, accounting pending user time also implies
+ * accounting system time in order to correctly compute
+ * the stolen time accounting.
+ */
+void vtime_account_user(struct task_struct *tsk)
 {
 	if (do_account_vtime(tsk, HARDIRQ_OFFSET))
 		virt_timer_expire();
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 1865b1f..66b7078 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -127,7 +127,15 @@ extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t)
 extern void account_steal_time(cputime_t);
 extern void account_idle_time(cputime_t);
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+static inline void account_process_tick(struct task_struct *tsk, int user)
+{
+	vtime_account_user(tsk);
+}
+#else
 extern void account_process_tick(struct task_struct *, int user);
+#endif
+
 extern void account_steal_ticks(unsigned long ticks);
 extern void account_idle_ticks(unsigned long ticks);
 
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 5ad13c3..ae30ab5 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -8,6 +8,7 @@ extern void vtime_task_switch(struct task_struct *prev);
 extern void vtime_account_system(struct task_struct *tsk);
 extern void vtime_account_system_irqsafe(struct task_struct *tsk);
 extern void vtime_account_idle(struct task_struct *tsk);
+extern void vtime_account_user(struct task_struct *tsk);
 extern void vtime_account(struct task_struct *tsk);
 #else
 static inline void vtime_task_switch(struct task_struct *prev) { }
-- 
1.7.5.4

