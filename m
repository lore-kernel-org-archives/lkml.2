Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2KTPnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:43:47 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40170 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2KTPnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:43:00 -0500
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
Subject: [PATCH 3/5] vtime: Consolidate a bit the ctx switch code
Date: Tue, 20 Nov 2012 16:42:39 +0100
Message-Id: <1353426161-18866-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353426161-18866-1-git-send-email-fweisbec@gmail.com>
References: <1353426161-18866-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ia64 and powerpc, vtime context switch only consists
in flushing system and user pending time, plus a few
arch housekeeping.

Consolidate that into a generic implementation. s390 is
a special case because pending user and system time accounting
there is hard to dissociate. So it's keeping its own implementation.

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
 arch/ia64/include/asm/cputime.h    |    2 ++
 arch/ia64/kernel/time.c            |    9 +--------
 arch/powerpc/include/asm/cputime.h |    2 ++
 arch/powerpc/kernel/time.c         |    6 ------
 arch/s390/include/asm/cputime.h    |    1 +
 kernel/sched/cputime.c             |   13 +++++++++++++
 6 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/ia64/include/asm/cputime.h b/arch/ia64/include/asm/cputime.h
index 3deac95..7fcf7f0 100644
--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@ -103,5 +103,7 @@ static inline void cputime_to_timeval(const cputime_t ct, struct timeval *val)
 #define cputime64_to_clock_t(__ct)	\
 	cputime_to_clock_t((__force cputime_t)__ct)
 
+extern void arch_vtime_task_switch(struct task_struct *tsk);
+
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 #endif /* __IA64_CPUTIME_H */
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 834c78b..c9a7d2e 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -100,18 +100,11 @@ void vtime_account_user(struct task_struct *tsk)
  * accumulated times to the current process, and to prepare accounting on
  * the next process.
  */
-void vtime_task_switch(struct task_struct *prev)
+void arch_vtime_task_switch(struct task_struct *prev)
 {
 	struct thread_info *pi = task_thread_info(prev);
 	struct thread_info *ni = task_thread_info(current);
 
-	if (idle_task(smp_processor_id()) != prev)
-		vtime_account_system(prev);
-	else
-		vtime_account_idle(prev);
-
-	vtime_account_user(prev);
-
 	pi->ac_stamp = ni->ac_stamp;
 	ni->ac_stime = ni->ac_utime = 0;
 }
diff --git a/arch/powerpc/include/asm/cputime.h b/arch/powerpc/include/asm/cputime.h
index 487d46f..483733b 100644
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -228,6 +228,8 @@ static inline cputime_t clock_t_to_cputime(const unsigned long clk)
 
 #define cputime64_to_clock_t(ct)	cputime_to_clock_t((cputime_t)(ct))
 
+static inline void arch_vtime_task_switch(struct task_struct *tsk) { }
+
 #endif /* __KERNEL__ */
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 #endif /* __POWERPC_CPUTIME_H */
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index a667aaf..3486cfa 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -375,12 +375,6 @@ void vtime_account_user(struct task_struct *tsk)
 	account_user_time(tsk, utime, utimescaled);
 }
 
-void vtime_task_switch(struct task_struct *prev)
-{
-	vtime_account(prev);
-	vtime_account_user(prev);
-}
-
 #else /* ! CONFIG_VIRT_CPU_ACCOUNTING */
 #define calc_cputime_factors()
 #endif
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index 023d5ae..d2ff4137 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -14,6 +14,7 @@
 
 
 #define __ARCH_HAS_VTIME_ACCOUNT
+#define __ARCH_HAS_VTIME_TASK_SWITCH
 
 /* We want to use full resolution of the CPU timer: 2**-12 micro-seconds. */
 
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index c0aa1ba..2e8d34a 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -443,6 +443,19 @@ void vtime_account_system_irqsafe(struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(vtime_account_system_irqsafe);
 
+#ifndef __ARCH_HAS_VTIME_TASK_SWITCH
+void vtime_task_switch(struct task_struct *prev)
+{
+	if (is_idle_task(prev))
+		vtime_account_idle(prev);
+	else
+		vtime_account_system(prev);
+
+	vtime_account_user(prev);
+	arch_vtime_task_switch(prev);
+}
+#endif
+
 /*
  * Archs that account the whole time spent in the idle task
  * (outside irq) as idle time can rely on this and just implement
-- 
1.7.5.4

