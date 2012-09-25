Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab2IYPGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:06:46 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56768 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693Ab2IYPGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:06:32 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/6] vtime: Consolidate system/idle context detection
Date: Tue, 25 Sep 2012 17:06:03 +0200
Message-Id: <1348585567-2925-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348585567-2925-1-git-send-email-fweisbec@gmail.com>
References: <1348585567-2925-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the code that finds out to which context we account the
cputime into generic layer.

Archs that consider the whole time spent in the idle task as idle
time (ia64, powerpc) can rely on the generic vtime_account()
and implement vtime_account_system() and vtime_account_idle(),
letting the generic code to decide when to call which API.

Archs that have their own meaning of idle time, such as s390
that only considers the time spent in CPU low power mode as idle
time, can just override vtime_account().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/ia64/kernel/time.c         |   25 +++++++++++---------
 arch/powerpc/kernel/time.c      |   47 +++++++++++++++++++++++---------------
 arch/s390/include/asm/cputime.h |    3 ++
 include/linux/kernel_stat.h     |    2 +
 kernel/sched/cputime.c          |   26 +++++++++++++++++++++
 5 files changed, 73 insertions(+), 30 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 16bb6ed..01cd43e 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -116,29 +116,32 @@ void vtime_task_switch(struct task_struct *prev)
  * Account time for a transition between system, hard irq or soft irq state.
  * Note that this function is called with interrupts enabled.
  */
-void vtime_account(struct task_struct *tsk)
+static cputime_t vtime_delta(struct task_struct *tsk)
 {
 	struct thread_info *ti = task_thread_info(tsk);
-	unsigned long flags;
 	cputime_t delta_stime;
 	__u64 now;
 
-	local_irq_save(flags);
-
 	now = ia64_get_itc();
 
 	delta_stime = cycle_to_cputime(ti->ac_stime + (now - ti->ac_stamp));
-	if (irq_count() || idle_task(smp_processor_id()) != tsk)
-		account_system_time(tsk, 0, delta_stime, delta_stime);
-	else
-		account_idle_time(delta_stime);
 	ti->ac_stime = 0;
-
 	ti->ac_stamp = now;
 
-	local_irq_restore(flags);
+	return delta_stime;
+}
+
+void vtime_account_system(struct task_struct *tsk)
+{
+	cputime_t delta = vtime_delta(tsk);
+
+	account_system_time(tsk, 0, delta, delta);
+}
+
+void vtime_account_idle(struct task_struct *tsk)
+{
+	account_idle_time(vtime_delta(tsk));
 }
-EXPORT_SYMBOL_GPL(vtime_account);
 
 /*
  * Called from the timer interrupt handler to charge accumulated user time
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 39899d7..29b6d3e 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -291,13 +291,12 @@ static inline u64 calculate_stolen_time(u64 stop_tb)
  * Account time for a transition between system, hard irq
  * or soft irq state.
  */
-void vtime_account(struct task_struct *tsk)
+static u64 vtime_delta(struct task_struct *tsk,
+			u64 *sys_scaled, u64 *stolen)
 {
-	u64 now, nowscaled, delta, deltascaled;
-	unsigned long flags;
-	u64 stolen, udelta, sys_scaled, user_scaled;
+	u64 now, nowscaled, deltascaled;
+	u64 udelta, delta, user_scaled;
 
-	local_irq_save(flags);
 	now = mftb();
 	nowscaled = read_spurr(now);
 	get_paca()->system_time += now - get_paca()->starttime;
@@ -305,7 +304,7 @@ void vtime_account(struct task_struct *tsk)
 	deltascaled = nowscaled - get_paca()->startspurr;
 	get_paca()->startspurr = nowscaled;
 
-	stolen = calculate_stolen_time(now);
+	*stolen = calculate_stolen_time(now);
 
 	delta = get_paca()->system_time;
 	get_paca()->system_time = 0;
@@ -322,28 +321,38 @@ void vtime_account(struct task_struct *tsk)
 	 * the user ticks get saved up in paca->user_time_scaled to be
 	 * used by account_process_tick.
 	 */
-	sys_scaled = delta;
+	*sys_scaled = delta;
 	user_scaled = udelta;
 	if (deltascaled != delta + udelta) {
 		if (udelta) {
-			sys_scaled = deltascaled * delta / (delta + udelta);
-			user_scaled = deltascaled - sys_scaled;
+			*sys_scaled = deltascaled * delta / (delta + udelta);
+			user_scaled = deltascaled - *sys_scaled;
 		} else {
-			sys_scaled = deltascaled;
+			*sys_scaled = deltascaled;
 		}
 	}
 	get_paca()->user_time_scaled += user_scaled;
 
-	if (in_interrupt() || idle_task(smp_processor_id()) != tsk) {
-		account_system_time(tsk, 0, delta, sys_scaled);
-		if (stolen)
-			account_steal_time(stolen);
-	} else {
-		account_idle_time(delta + stolen);
-	}
-	local_irq_restore(flags);
+	return delta;
+}
+
+void vtime_account_system(struct task_struct *tsk)
+{
+	u64 delta, sys_scaled, stolen;
+
+	delta = vtime_delta(tsk, &sys_scaled, &stolen);
+	account_system_time(tsk, 0, delta, sys_scaled);
+	if (stolen)
+		account_steal_time(stolen);
+}
+
+void vtime_account_idle(struct task_struct *tsk)
+{
+	u64 delta, sys_scaled, stolen;
+
+	delta = vtime_delta(tsk, &sys_scaled, &stolen);
+	account_idle_time(delta + stolen);
 }
-EXPORT_SYMBOL_GPL(vtime_account);
 
 /*
  * Transfer the user and system times accumulated in the paca
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index 8709bde..023d5ae 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -12,6 +12,9 @@
 #include <linux/spinlock.h>
 #include <asm/div64.h>
 
+
+#define __ARCH_HAS_VTIME_ACCOUNT
+
 /* We want to use full resolution of the CPU timer: 2**-12 micro-seconds. */
 
 typedef unsigned long long __nocast cputime_t;
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index ca0944b..36d12f0 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -132,6 +132,8 @@ extern void account_idle_ticks(unsigned long ticks);
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 extern void vtime_task_switch(struct task_struct *prev);
+extern void vtime_account_system(struct task_struct *tsk);
+extern void vtime_account_idle(struct task_struct *tsk);
 #else
 static inline void vtime_task_switch(struct task_struct *prev) { }
 #endif
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 53f5b12..81b763b 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -432,6 +432,32 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	*ut = cputime.utime;
 	*st = cputime.stime;
 }
+
+/*
+ * Archs that account the whole time spent in the idle task
+ * (outside irq) as idle time can rely on this and just implement
+ * vtime_account_system() and vtime_account_idle(). Archs that
+ * have other meaning of the idle time (s390 only includes the
+ * time spent by the CPU when it's in low power mode) must override
+ * vtime_account().
+ */
+#ifndef __ARCH_HAS_VTIME_ACCOUNT
+void vtime_account(struct task_struct *tsk)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	if (in_interrupt() || !is_idle_task(tsk))
+		vtime_account_system(tsk);
+	else
+		vtime_account_idle(tsk);
+
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(vtime_account);
+#endif /* __ARCH_HAS_VTIME_ACCOUNT */
+
 #else
 
 #ifndef nsecs_to_cputime
-- 
1.7.5.4

