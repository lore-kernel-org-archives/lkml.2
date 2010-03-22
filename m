Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab0CVTTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:19:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:36505 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab0CVTSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:18:22 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/8] kgdb: eliminate kgdb_wait(), all cpus enter the same way
Date: Mon, 22 Mar 2010 14:17:24 -0500
Message-Id: <1269285449-1424-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1269285449-1424-3-git-send-email-jason.wessel@windriver.com>
References: <1269285449-1424-1-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-2-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Mar 2010 19:17:38.0143 (UTC) FILETIME=[55C186F0:01CAC9F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a kgdb architectural change to have all the cpus (master or
slave) enter the same function.

A cpu that hits an exception (wants to be the master cpu) will call
kgdb_handle_exception() from the trap handler and then invoke a
kgdb_roundup_cpu() to synchronize the other cpus and bring them into
the kgdb_handle_exception() as well.

A slave cpu will enter kgdb_handle_exception() from the
kgdb_nmicallback() and set the exception state to note that the
processor is a slave.

Previously the salve cpu would have called kgdb_wait().  This change
allows the debug core to change cpus without resuming the system in
order to inspect arch specific cpu information.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c |  158 +++++++++++++++++++++-----------------------
 kernel/debug/debug_core.h |    7 ++
 2 files changed, 82 insertions(+), 83 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index ad3caaa..91286e8 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -215,49 +215,6 @@ void __weak kgdb_disable_hw_debug(struct pt_regs *regs)
 }
 
 /*
- * CPU debug state control:
- */
-
-#ifdef CONFIG_SMP
-static void kgdb_wait(struct pt_regs *regs)
-{
-	unsigned long flags;
-	int cpu;
-
-	local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	kgdb_info[cpu].debuggerinfo = regs;
-	kgdb_info[cpu].task = current;
-	/*
-	 * Make sure the above info reaches the primary CPU before
-	 * our cpu_in_kgdb[] flag setting does:
-	 */
-	smp_wmb();
-	atomic_set(&cpu_in_kgdb[cpu], 1);
-
-	/* Disable any cpu specific hw breakpoints */
-	kgdb_disable_hw_debug(regs);
-
-	/* Wait till primary CPU is done with debugging */
-	while (atomic_read(&passive_cpu_wait[cpu]))
-		cpu_relax();
-
-	kgdb_info[cpu].debuggerinfo = NULL;
-	kgdb_info[cpu].task = NULL;
-
-	/* fix up hardware debug registers on local cpu */
-	if (arch_kgdb_ops.correct_hw_break)
-		arch_kgdb_ops.correct_hw_break();
-
-	/* Signal the primary CPU that we are done: */
-	atomic_set(&cpu_in_kgdb[cpu], 0);
-	touch_softlockup_watchdog_sync();
-	clocksource_touch_watchdog();
-	local_irq_restore(flags);
-}
-#endif
-
-/*
  * Some architectures need cache flushes when we set/clear a
  * breakpoint:
  */
@@ -486,34 +443,12 @@ static int kgdb_reenter_check(struct kgdb_state *ks)
 	return 1;
 }
 
-/*
- * kgdb_handle_exception() - main entry point from a kernel exception
- *
- * Locking hierarchy:
- *	interface locks, if any (begin_session)
- *	kgdb lock (kgdb_active)
- */
-int
-kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
+static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs)
 {
-	struct kgdb_state kgdb_var;
-	struct kgdb_state *ks = &kgdb_var;
 	unsigned long flags;
 	int sstep_tries = 100;
 	int error = 0;
 	int i, cpu;
-
-	ks->cpu			= raw_smp_processor_id();
-	ks->ex_vector		= evector;
-	ks->signo		= signo;
-	ks->ex_vector		= evector;
-	ks->err_code		= ecode;
-	ks->kgdb_usethreadid	= 0;
-	ks->linux_regs		= regs;
-
-	if (kgdb_reenter_check(ks))
-		return 0; /* Ouch, double exception ! */
-
 acquirelock:
 	/*
 	 * Interrupts will be restored by the 'trap return' code, except when
@@ -521,13 +456,42 @@ acquirelock:
 	 */
 	local_irq_save(flags);
 
-	cpu = raw_smp_processor_id();
+	cpu = ks->cpu;
+	kgdb_info[cpu].debuggerinfo = regs;
+	kgdb_info[cpu].task = current;
+	/*
+	 * Make sure the above info reaches the primary CPU before
+	 * our cpu_in_kgdb[] flag setting does:
+	 */
+	smp_wmb();
+	atomic_set(&cpu_in_kgdb[cpu], 1);
 
 	/*
-	 * Acquire the kgdb_active lock:
+	 * CPU will loop if it is a slave or request to become a kgdb
+	 * master cpu and acquire the kgdb_active lock:
 	 */
-	while (atomic_cmpxchg(&kgdb_active, -1, cpu) != -1)
+	while (1) {
+		if (kgdb_info[cpu].exception_state & DCPU_WANT_MASTER) {
+			if (atomic_cmpxchg(&kgdb_active, -1, cpu) == cpu)
+				break;
+		} else if (kgdb_info[cpu].exception_state & DCPU_IS_SLAVE) {
+			if (!atomic_read(&passive_cpu_wait[cpu]))
+				goto return_normal;
+		} else {
+return_normal:
+			/* Return to normal operation by executing any
+			 * hw breakpoint fixup.
+			 */
+			if (arch_kgdb_ops.correct_hw_break)
+				arch_kgdb_ops.correct_hw_break();
+			atomic_set(&cpu_in_kgdb[cpu], 0);
+			touch_softlockup_watchdog_sync();
+			clocksource_touch_watchdog();
+			local_irq_restore(flags);
+			return 0;
+		}
 		cpu_relax();
+	}
 
 	/*
 	 * For single stepping, try to only enter on the processor
@@ -561,9 +525,6 @@ acquirelock:
 	if (dbg_io_ops->pre_exception)
 		dbg_io_ops->pre_exception();
 
-	kgdb_info[ks->cpu].debuggerinfo = ks->linux_regs;
-	kgdb_info[ks->cpu].task = current;
-
 	kgdb_disable_hw_debug(ks->linux_regs);
 
 	/*
@@ -575,12 +536,6 @@ acquirelock:
 			atomic_set(&passive_cpu_wait[i], 1);
 	}
 
-	/*
-	 * spin_lock code is good enough as a barrier so we don't
-	 * need one here:
-	 */
-	atomic_set(&cpu_in_kgdb[ks->cpu], 1);
-
 #ifdef CONFIG_SMP
 	/* Signal the other CPUs to enter kgdb_wait() */
 	if ((!kgdb_single_step) && kgdb_do_roundup)
@@ -612,8 +567,6 @@ acquirelock:
 	if (dbg_io_ops->post_exception)
 		dbg_io_ops->post_exception();
 
-	kgdb_info[ks->cpu].debuggerinfo = NULL;
-	kgdb_info[ks->cpu].task = NULL;
 	atomic_set(&cpu_in_kgdb[ks->cpu], 0);
 
 	if (!kgdb_single_step) {
@@ -646,13 +599,52 @@ kgdb_restore:
 	return error;
 }
 
+/*
+ * kgdb_handle_exception() - main entry point from a kernel exception
+ *
+ * Locking hierarchy:
+ *	interface locks, if any (begin_session)
+ *	kgdb lock (kgdb_active)
+ */
+int
+kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
+{
+	struct kgdb_state kgdb_var;
+	struct kgdb_state *ks = &kgdb_var;
+	int ret;
+
+	ks->cpu			= raw_smp_processor_id();
+	ks->ex_vector		= evector;
+	ks->signo		= signo;
+	ks->ex_vector		= evector;
+	ks->err_code		= ecode;
+	ks->kgdb_usethreadid	= 0;
+	ks->linux_regs		= regs;
+
+	if (kgdb_reenter_check(ks))
+		return 0; /* Ouch, double exception ! */
+	kgdb_info[ks->cpu].exception_state |= DCPU_WANT_MASTER;
+	ret = kgdb_cpu_enter(ks, regs);
+	kgdb_info[ks->cpu].exception_state &= ~DCPU_WANT_MASTER;
+	return ret;
+}
+
 int kgdb_nmicallback(int cpu, void *regs)
 {
 #ifdef CONFIG_SMP
+	struct kgdb_state kgdb_var;
+	struct kgdb_state *ks = &kgdb_var;
+
+	memset(ks, 0, sizeof(struct kgdb_state));
+	ks->cpu			= cpu;
+	ks->linux_regs		= regs;
+
 	if (!atomic_read(&cpu_in_kgdb[cpu]) &&
-			atomic_read(&kgdb_active) != cpu &&
-			atomic_read(&cpu_in_kgdb[atomic_read(&kgdb_active)])) {
-		kgdb_wait((struct pt_regs *)regs);
+	    atomic_read(&kgdb_active) != -1 &&
+	    atomic_read(&kgdb_active) != cpu) {
+		kgdb_info[cpu].exception_state |= DCPU_IS_SLAVE;
+		kgdb_cpu_enter(ks, regs);
+		kgdb_info[cpu].exception_state &= ~DCPU_IS_SLAVE;
 		return 0;
 	}
 #endif
diff --git a/kernel/debug/debug_core.h b/kernel/debug/debug_core.h
index 4b9d512..9825c5e 100644
--- a/kernel/debug/debug_core.h
+++ b/kernel/debug/debug_core.h
@@ -28,9 +28,16 @@ struct kgdb_state {
 	struct pt_regs		*linux_regs;
 };
 
+/* Exception state values */
+#define DCPU_WANT_MASTER 0x1 /* Waiting to become a master kgdb cpu */
+#define DCPU_NEXT_MASTER 0x2 /* Transition from one master cpu to another */
+#define DCPU_IS_SLAVE    0x4 /* Slave cpu enter exception */
+#define DCPU_SSTEP       0x8 /* CPU is single stepping */
+
 struct debuggerinfo_struct {
 	void			*debuggerinfo;
 	struct task_struct	*task;
+	int exception_state;
 };
 
 extern struct debuggerinfo_struct kgdb_info[];
-- 
1.6.4.rc1

