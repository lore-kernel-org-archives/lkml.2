Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992537Ab2JYRtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:49:15 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37029 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934845Ab2JYRsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:48:18 -0400
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
Subject: [PATCH 2/5] vtime: Make vtime_account_system() irqsafe
Date: Thu, 25 Oct 2012 19:48:00 +0200
Message-Id: <1351187283-20715-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351187283-20715-1-git-send-email-fweisbec@gmail.com>
References: <1351187283-20715-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vtime_account_system() currently has only one caller with
vtime_account() which is irq safe.

Now we are going to call it from other places like kvm where
irqs are not always disabled by the time we account the cputime.

So let's make it irqsafe. The arch implementation part is now
prefixed with "__".

vtime_account_idle() arch implementation is prefixed accordingly
to stay consistent.

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
 arch/ia64/kernel/time.c    |    8 ++++----
 arch/powerpc/kernel/time.c |    4 ++--
 arch/s390/kernel/vtime.c   |    4 ++++
 include/linux/vtime.h      |    4 +++-
 kernel/sched/cputime.c     |   16 +++++++++++++---
 5 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index f638821..5e48503 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -106,9 +106,9 @@ void vtime_task_switch(struct task_struct *prev)
 	struct thread_info *ni = task_thread_info(current);
 
 	if (idle_task(smp_processor_id()) != prev)
-		vtime_account_system(prev);
+		__vtime_account_system(prev);
 	else
-		vtime_account_idle(prev);
+		__vtime_account_idle(prev);
 
 	vtime_account_user(prev);
 
@@ -135,14 +135,14 @@ static cputime_t vtime_delta(struct task_struct *tsk)
 	return delta_stime;
 }
 
-void vtime_account_system(struct task_struct *tsk)
+void __vtime_account_system(struct task_struct *tsk)
 {
 	cputime_t delta = vtime_delta(tsk);
 
 	account_system_time(tsk, 0, delta, delta);
 }
 
-void vtime_account_idle(struct task_struct *tsk)
+void __vtime_account_idle(struct task_struct *tsk)
 {
 	account_idle_time(vtime_delta(tsk));
 }
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index ce4cb77..0db456f 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -336,7 +336,7 @@ static u64 vtime_delta(struct task_struct *tsk,
 	return delta;
 }
 
-void vtime_account_system(struct task_struct *tsk)
+void __vtime_account_system(struct task_struct *tsk)
 {
 	u64 delta, sys_scaled, stolen;
 
@@ -346,7 +346,7 @@ void vtime_account_system(struct task_struct *tsk)
 		account_steal_time(stolen);
 }
 
-void vtime_account_idle(struct task_struct *tsk)
+void __vtime_account_idle(struct task_struct *tsk)
 {
 	u64 delta, sys_scaled, stolen;
 
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 7903344..783e988 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -140,6 +140,10 @@ void vtime_account(struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(vtime_account);
 
+void __vtime_account_system(struct task_struct *tsk)
+__attribute__((alias("vtime_account")));
+EXPORT_SYMBOL_GPL(__vtime_account_system);
+
 void __kprobes vtime_stop_cpu(void)
 {
 	struct s390_idle_data *idle = &__get_cpu_var(s390_idle);
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 7199c24..b9fc4f9 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -5,10 +5,12 @@ struct task_struct;
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 extern void vtime_task_switch(struct task_struct *prev);
+extern void __vtime_account_system(struct task_struct *tsk);
 extern void vtime_account_system(struct task_struct *tsk);
-extern void vtime_account_idle(struct task_struct *tsk);
+extern void __vtime_account_idle(struct task_struct *tsk);
 #else
 static inline void vtime_task_switch(struct task_struct *prev) { }
+static inline void vtime_account_system(struct task_struct *tsk) { }
 #endif
 
 #if !defined(CONFIG_VIRT_CPU_ACCOUNTING) && !defined(CONFIG_IRQ_TIME_ACCOUNTING)
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 81b763b..0359f47 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -433,10 +433,20 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	*st = cputime.stime;
 }
 
+void vtime_account_system(struct task_struct *tsk)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__vtime_account_system(tsk);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(vtime_account_system);
+
 /*
  * Archs that account the whole time spent in the idle task
  * (outside irq) as idle time can rely on this and just implement
- * vtime_account_system() and vtime_account_idle(). Archs that
+ * __vtime_account_system() and __vtime_account_idle(). Archs that
  * have other meaning of the idle time (s390 only includes the
  * time spent by the CPU when it's in low power mode) must override
  * vtime_account().
@@ -449,9 +459,9 @@ void vtime_account(struct task_struct *tsk)
 	local_irq_save(flags);
 
 	if (in_interrupt() || !is_idle_task(tsk))
-		vtime_account_system(tsk);
+		__vtime_account_system(tsk);
 	else
-		vtime_account_idle(tsk);
+		__vtime_account_idle(tsk);
 
 	local_irq_restore(flags);
 }
-- 
1.7.5.4

