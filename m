Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934285Ab1EWWPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:15:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:6208 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934179Ab1EWWPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:15:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,258,1304319600"; 
   d="scan'208";a="114657"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        "Andi Kleen" <andi@firstfloor.org>, "Borislav Petkov" <bp@alien8.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
Subject: [RFC 9/9] MCE: Add Action-Required support
Date: Mon, 23 May 2011 15:15:18 -0700
Message-Id: <4ddadc7617174ee802@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

Implement core MCA recovery. This is used for errors
that happen in the current execution context.

The kernel has to first pass the error information
to a function running on the current process stack.
This is done using a new work flag and then executing
the code after the exception through do_notify_resume.

Then hwpoison is allowed to sleep and can try to recover it.

To pass the information about the error around we need
to use a field in the current process. The old ways
to handle this (per cpu buffer) don't work because
a CPU could be switched before reaching the handler code.

For kernel recovery we only handle errors happening
during copy_*_user() exception tables and inject EFAULT.
When the tolerance level is sufficiently high also
a unsafe oops like do_exit() killing, which has some
deadlock potential.

FIXME: fix 386 handling of mce notify bit in entry_32.S after mce

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   35 ++++++-
 arch/x86/kernel/cpu/mcheck/mce.c          |  157 +++++++++++++++++++++++++++--
 include/linux/init_task.h                 |    7 ++
 include/linux/sched.h                     |    3 +
 4 files changed, 189 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 352d16a..fe8a28c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -13,6 +13,7 @@
 #include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/debugfs.h>
+#include <linux/module.h>
 #include <asm/mce.h>
 
 #include "mce-internal.h"
@@ -54,6 +55,9 @@ static struct severity {
 	{ .mcgmask = x, .mcgres = res, SEV(s), .msg = m, ## r }
 #define MASK(x, y, s, m, r...) \
 	{ .mask = x, .result = y, SEV(s), .msg = m, ## r }
+#define ARMASK(x, y, s, m, r...) \
+	{ .mcgmask = MCG_STATUS_RIPV, .mcgres = 0, \
+	  .mask = x, .result = y, SEV(s), .msg = m, ## r }
 #define MCI_UC_S (MCI_STATUS_UC|MCI_STATUS_S)
 #define MCI_UC_SAR (MCI_STATUS_UC|MCI_STATUS_S|MCI_STATUS_AR)
 #define MCACOD 0xffff
@@ -67,7 +71,7 @@ static struct severity {
 	MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0, PANIC,
 		"Neither restart nor error IP"),
 	MCGMASK(MCG_STATUS_RIPV, 0, PANIC, "In kernel and no restart IP",
-		KERNEL),
+		KERNEL, NOSER),
 	BITCLR(MCI_STATUS_UC, KEEP, "Corrected error", NOSER),
 
 	/* ignore OVER for UCNA */
@@ -77,10 +81,16 @@ static struct severity {
 	     "Illegal combination (UCNA with AR=1)", SER),
 	MASK(MCI_STATUS_S, 0, KEEP, "Non signalled machine check", SER),
 
-	/* AR add known MCACODs here */
 	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_SAR, PANIC,
 	     "Action required with lost events", SER),
-	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR, PANIC,
+
+	/* known AR MCACODs: */
+	ARMASK(MCI_UC_SAR|MCI_STATUS_OVER|0xffff, MCI_UC_SAR|0x134, AR,
+	     "Action required: data load error", SER),
+	ARMASK(MCI_UC_SAR|MCI_STATUS_OVER|0xffff, MCI_UC_SAR|0x150, AR,
+	     "Action required: instruction fetch error", SER),
+
+	ARMASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR, PANIC,
 	     "Action required; unknown MCACOD", SER),
 
 	/* known AO MCACODs: */
@@ -89,6 +99,7 @@ static struct severity {
 	MASK(MCI_UC_SAR|MCI_STATUS_OVER|MCACOD, MCI_UC_S|0x17a, AO,
 	     "Action optional: last level cache writeback error", SER),
 
+
 	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S, SOME,
 	     "Action optional unknown MCACOD", SER),
 	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S|MCI_STATUS_OVER, SOME,
@@ -110,6 +121,17 @@ static int error_context(struct mce *m)
 	return IN_KERNEL;
 }
 
+static int kernel_ar_recoverable(struct mce *m, int tolerant)
+{
+	if (tolerant >= 2)
+		return MCE_AR_SEVERITY;
+	if (!(m->mcgstatus & MCG_STATUS_EIPV) || !m->ip)
+		return MCE_PANIC_SEVERITY;
+	if (search_exception_tables(m->ip))
+		return MCE_AR_SEVERITY;
+	return MCE_PANIC_SEVERITY;
+}
+
 int mce_severity(struct mce *a, int tolerant, char **msg)
 {
 	enum context ctx = error_context(a);
@@ -129,9 +151,12 @@ int mce_severity(struct mce *a, int tolerant, char **msg)
 		if (msg)
 			*msg = s->msg;
 		s->covered = 1;
-		if (s->sev >= MCE_UC_SEVERITY && ctx == IN_KERNEL) {
-			if (panic_on_oops || tolerant < 1)
+		if (ctx == IN_KERNEL) {
+			if (s->sev >= MCE_UC_SEVERITY &&
+				(panic_on_oops || tolerant < 1))
 				return MCE_PANIC_SEVERITY;
+			if (s->sev == MCE_AR_SEVERITY)
+				return kernel_ar_recoverable(a, tolerant);
 		}
 		return s->sev;
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 7da4a75..9d5e679 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -960,6 +960,131 @@ static void mce_clear_state(unsigned long *toclear)
 	}
 }
 
+/* Stub when hwpoison is not compiled in */
+int __attribute__((weak)) __memory_failure(unsigned long pfn, int vector,
+					   int precount)
+{
+	return -1;
+}
+
+/*
+ * Uncorrected error for current process.
+ */
+static void mce_action_required(struct mce *m, char *msg, struct pt_regs *regs)
+{
+	if (!mce_usable_address(m))
+		mce_panic("No address for Action-Required Machine Check",
+			  m, msg);
+	if (!(m->mcgstatus & MCG_STATUS_EIPV))
+		mce_panic("No EIPV for Action-Required Machine Check",
+			  m, msg);
+
+	WARN_ON(current->mce_error_pfn != -1L);
+	current->mce_error_pfn = m->addr >> PAGE_SHIFT;
+	set_thread_flag(TIF_MCE_NOTIFY);
+}
+
+#undef pr_fmt
+#define pr_fmt(x) "MCE: %s:%d " x "\n", current->comm, current->pid
+#define PADDR(x) ((u64)(x) << PAGE_SHIFT)
+
+/*
+ * No successfull recovery. Make sure at least that there's
+ * a SIGBUS.
+ */
+static void ar_fallback(struct task_struct *me, unsigned long pfn)
+{
+	if (signal_pending(me) && sigismember(&me->pending.signal, SIGBUS))
+		return;
+
+	/*
+	 * For some reason hwpoison wasn't able to send a proper
+	 * SIGBUS.  Send a fallback signal. Unfortunately we don't
+	 * know the virtual address here, so can't tell the program
+	 * details.
+	 */
+	force_sig(SIGBUS, me);
+	pr_err("Killed due to action-required memory corruption");
+}
+
+/*
+ * Handle action-required on the process stack.  hwpoison does the
+ * bulk of the work and with some luck might even be able to fix the
+ * problem.
+ *
+ * Logic changes here should be reflected in kernel_ar_recoverable().
+ */
+static void handle_action_required(struct pt_regs *regs)
+{
+	struct task_struct *me = current;
+	unsigned long pfn = me->mce_error_pfn;
+	unsigned long pstack;
+
+	me->mce_error_pfn = -1L;
+
+	/*
+	 * User-mode:
+	 *
+	 * Guarantee of no kernel locks hold. Do full VM level
+	 * recovery. This will result either in a signal
+	 * or transparent recovery.
+	 */
+	if (user_mode(regs)) {
+		pr_err("Uncorrected hardware memory error in user-access at %llx",
+		       PADDR(pfn));
+		if (__memory_failure(pfn, MCE_VECTOR, 0) < 0) {
+			pr_err("Memory error not recovered");
+			ar_fallback(me, pfn);
+		} else
+			pr_err("Memory error recovered");
+		return;
+	}
+
+	/*
+	 * Kernel-mode:
+	 *
+	 * Recover from faults with exception tables.
+	 *
+	 * We can't use VM recovery here, because there's no
+	 * guarantee what locks are already hold in the code
+	 * interrupted and we don't have a virtual address.
+	 *
+	 * Simply EFAULT this case.
+	 */
+	pr_err("Hardware memory error in kernel context at %llx",
+	       PADDR(pfn));
+	if (fixup_exception(regs)) {
+		pr_err("Injecting EFAULT for kernel memory error");
+		return;
+	}
+
+	/*
+	 * Corruption in kernel code that is not protected by
+	 * a exception table.
+	 *
+	 * When the tolerance level is high enough treat like
+	 * an oops. Note this is not fully safe and might deadlock
+	 * when the current code path hold any locks taken by do_exit.
+	 *
+	 * Do various sanity checks to avoid looping etc.
+	 */
+	pstack = (unsigned long)task_thread_info(current);
+	if (tolerant >= 2 &&
+	    !(current->flags & PF_EXITING) &&
+	    current->pid &&
+	    !in_interrupt() &&
+	    regs->sp >= pstack && regs->sp <= pstack + THREAD_SIZE) {
+		pr_err("Unsafe killing of current process in kernel context");
+		do_exit(SIGBUS);
+	}
+
+	panic("Memory error machine check in kernel context at %llx",
+	      PADDR(pfn));
+}
+
+#undef pr_fmt
+#define pr_fmt(x) x
+
 /*
  * The actual machine check handler. This only handles real
  * exceptions when something got corrupted coming in through int 18.
@@ -1072,12 +1197,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 			continue;
 		}
 
-		/*
-		 * Kill on action required.
-		 */
-		if (severity == MCE_AR_SEVERITY)
-			kill_it = 1;
-
 		mce_read_aux(&m, i);
 
 		/*
@@ -1122,6 +1241,15 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		mce_panic("Fatal machine check on current CPU", &m, msg);
 
 	/*
+	 * Do recovery in current process if needed. This has to be delayed
+	 * until we're back on the process stack.
+	 */
+	if (worst == MCE_AR_SEVERITY) {
+		mce_action_required(&m, msg, regs);
+		kill_it = 0;
+	}
+
+	/*
 	 * If the error seems to be unrecoverable, something should be
 	 * done.  Try to kill as little as possible.  If we can kill just
 	 * one task, do that.  If the user has set the tolerance very
@@ -1136,6 +1264,18 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 	if (worst > 0)
 		mce_report_event(regs);
+
+	/*
+	 * We seem to be making TIF_MCE_NOTIFY serve two purposes:
+	 * 1: Get the log of this event moving
+	 * 2: Don't let us return to an "Action Required" user process.
+	 * But mce_report_event() may end up clearing the flag, so we
+	 * set it again here if needed to stop us returning to the
+	 * user code that triggered this machine check.
+	 */
+	if (worst == MCE_AR_SEVERITY)
+		set_thread_flag(TIF_MCE_NOTIFY);
+
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
 out:
 	atomic_dec(&mce_entry);
@@ -1157,8 +1297,6 @@ void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
  * per CPU.
  * Note we don't disable preemption, so this code might run on the wrong
  * CPU. In this case the event is picked up by the scheduled work queue.
- * This is merely a fast path to expedite processing in some common
- * cases.
  */
 void mce_notify_process(struct pt_regs *regs)
 {
@@ -1166,6 +1304,9 @@ void mce_notify_process(struct pt_regs *regs)
 	mce_notify_irq();
 	while (mce_ring_get(&pfn))
 		memory_failure(pfn, MCE_VECTOR);
+
+	if (regs && current->mce_error_pfn != -1L)
+		handle_action_required(regs);
 }
 
 static void mce_process_work(struct work_struct *dummy)
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index caa151f..16ab936 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -124,6 +124,12 @@ extern struct cred init_cred;
 # define INIT_PERF_EVENTS(tsk)
 #endif
 
+#ifdef CONFIG_X86_MCE
+#define INIT_MCE_ERROR_PFN .mce_error_pfn = -1L,
+#else
+#define INIT_MCE_ERROR_PFN
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -192,6 +198,7 @@ extern struct cred init_cred;
 	INIT_FTRACE_GRAPH						\
 	INIT_TRACE_RECURSION						\
 	INIT_TASK_RCU_PREEMPT(tsk)					\
+	INIT_MCE_ERROR_PFN						\
 }
 
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 781abd1..a72f3aa 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1540,6 +1540,9 @@ struct task_struct {
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 	atomic_t ptrace_bp_refcnt;
 #endif
+#ifdef CONFIG_X86_MCE
+	unsigned long mce_error_pfn;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
-- 
1.7.3.1

