Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2KTPm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:42:58 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40170 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2KTPmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:42:55 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 1/5] vtime: Remove the underscore prefix invasion
Date: Tue, 20 Nov 2012 16:42:37 +0100
Message-Id: <1353426161-18866-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353426161-18866-1-git-send-email-fweisbec@gmail.com>
References: <1353426161-18866-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepending irq-unsafe vtime APIs with underscores was actually
a bad idea as the result is a big mess in the API namespace that
is even waiting to be further extended. Also these helpers
are always called from irq safe callers except kvm. Just
provide a vtime_account_system_irqsafe() for this specific
case so that we can remove the underscore prefix on other
vtime functions.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
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
 arch/s390/kernel/vtime.c   |    4 ++--
 include/linux/kvm_host.h   |    4 ++--
 include/linux/vtime.h      |    8 ++++----
 kernel/sched/cputime.c     |   12 ++++++------
 6 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 5e48503..f638821 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -106,9 +106,9 @@ void vtime_task_switch(struct task_struct *prev)
 	struct thread_info *ni = task_thread_info(current);
 
 	if (idle_task(smp_processor_id()) != prev)
-		__vtime_account_system(prev);
+		vtime_account_system(prev);
 	else
-		__vtime_account_idle(prev);
+		vtime_account_idle(prev);
 
 	vtime_account_user(prev);
 
@@ -135,14 +135,14 @@ static cputime_t vtime_delta(struct task_struct *tsk)
 	return delta_stime;
 }
 
-void __vtime_account_system(struct task_struct *tsk)
+void vtime_account_system(struct task_struct *tsk)
 {
 	cputime_t delta = vtime_delta(tsk);
 
 	account_system_time(tsk, 0, delta, delta);
 }
 
-void __vtime_account_idle(struct task_struct *tsk)
+void vtime_account_idle(struct task_struct *tsk)
 {
 	account_idle_time(vtime_delta(tsk));
 }
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 0db456f..ce4cb77 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -336,7 +336,7 @@ static u64 vtime_delta(struct task_struct *tsk,
 	return delta;
 }
 
-void __vtime_account_system(struct task_struct *tsk)
+void vtime_account_system(struct task_struct *tsk)
 {
 	u64 delta, sys_scaled, stolen;
 
@@ -346,7 +346,7 @@ void __vtime_account_system(struct task_struct *tsk)
 		account_steal_time(stolen);
 }
 
-void __vtime_account_idle(struct task_struct *tsk)
+void vtime_account_idle(struct task_struct *tsk)
 {
 	u64 delta, sys_scaled, stolen;
 
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 783e988..80d1dbc 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -140,9 +140,9 @@ void vtime_account(struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(vtime_account);
 
-void __vtime_account_system(struct task_struct *tsk)
+void vtime_account_system(struct task_struct *tsk)
 __attribute__((alias("vtime_account")));
-EXPORT_SYMBOL_GPL(__vtime_account_system);
+EXPORT_SYMBOL_GPL(vtime_account_system);
 
 void __kprobes vtime_stop_cpu(void)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0e2212f..f17158b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -741,7 +741,7 @@ static inline void kvm_guest_enter(void)
 	 * This is running in ioctl context so we can avoid
 	 * the call to vtime_account() with its unnecessary idle check.
 	 */
-	vtime_account_system(current);
+	vtime_account_system_irqsafe(current);
 	current->flags |= PF_VCPU;
 	/* KVM does not hold any references to rcu protected data when it
 	 * switches CPU into a guest mode. In fact switching to a guest mode
@@ -759,7 +759,7 @@ static inline void kvm_guest_exit(void)
 	 * This is running in ioctl context so we can avoid
 	 * the call to vtime_account() with its unnecessary idle check.
 	 */
-	vtime_account_system(current);
+	vtime_account_system_irqsafe(current);
 	current->flags &= ~PF_VCPU;
 }
 
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 0c2a2d3..5ad13c3 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -5,14 +5,14 @@ struct task_struct;
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 extern void vtime_task_switch(struct task_struct *prev);
-extern void __vtime_account_system(struct task_struct *tsk);
 extern void vtime_account_system(struct task_struct *tsk);
-extern void __vtime_account_idle(struct task_struct *tsk);
+extern void vtime_account_system_irqsafe(struct task_struct *tsk);
+extern void vtime_account_idle(struct task_struct *tsk);
 extern void vtime_account(struct task_struct *tsk);
 #else
 static inline void vtime_task_switch(struct task_struct *prev) { }
-static inline void __vtime_account_system(struct task_struct *tsk) { }
 static inline void vtime_account_system(struct task_struct *tsk) { }
+static inline void vtime_account_system_irqsafe(struct task_struct *tsk) { }
 static inline void vtime_account(struct task_struct *tsk) { }
 #endif
 
@@ -40,7 +40,7 @@ static inline void vtime_account_irq_enter(struct task_struct *tsk)
 static inline void vtime_account_irq_exit(struct task_struct *tsk)
 {
 	/* On hard|softirq exit we always account to hard|softirq cputime */
-	__vtime_account_system(tsk);
+	vtime_account_system(tsk);
 	irqtime_account_irq(tsk);
 }
 
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 8d859da..c0aa1ba 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -433,20 +433,20 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	*st = cputime.stime;
 }
 
-void vtime_account_system(struct task_struct *tsk)
+void vtime_account_system_irqsafe(struct task_struct *tsk)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__vtime_account_system(tsk);
+	vtime_account_system(tsk);
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(vtime_account_system);
+EXPORT_SYMBOL_GPL(vtime_account_system_irqsafe);
 
 /*
  * Archs that account the whole time spent in the idle task
  * (outside irq) as idle time can rely on this and just implement
- * __vtime_account_system() and __vtime_account_idle(). Archs that
+ * vtime_account_system() and vtime_account_idle(). Archs that
  * have other meaning of the idle time (s390 only includes the
  * time spent by the CPU when it's in low power mode) must override
  * vtime_account().
@@ -459,9 +459,9 @@ void vtime_account(struct task_struct *tsk)
 	local_irq_save(flags);
 
 	if (in_interrupt() || !is_idle_task(tsk))
-		__vtime_account_system(tsk);
+		vtime_account_system(tsk);
 	else
-		__vtime_account_idle(tsk);
+		vtime_account_idle(tsk);
 
 	local_irq_restore(flags);
 }
-- 
1.7.5.4

