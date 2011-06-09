Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab1FIVir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:38:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:2312 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab1FIVin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:38:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,343,1304319600"; 
   d="scan'208";a="12190868"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Borislav Petkov" <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
        "Avi Kivity" <avi@redhat.com>
In-Reply-To: <4df13a522720782e51@agluck-desktop.sc.intel.com>
Subject: [PATCH 10/10] MCE: Add Action-Required support
Date: Thu, 09 Jun 2011 14:38:43 -0700
Message-Id: <4df13d6327307cf53@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

Implement core MCA recovery. This is used for errors
that happen in the current execution context.

The kernel has to first pass the error information
to a function running on the current process stack.
This is done using task_return_notifier_register().

Just handle errors in user mode for now. Later we
may be able to handle some kernel cases (e.g. when
kernel is in copy_*_user())

Based on some original code by Andi Kleen.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   35 +++++++-
 arch/x86/kernel/cpu/mcheck/mce.c          |  118 +++++++++++++++++++++++++++--
 2 files changed, 142 insertions(+), 11 deletions(-)

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
index 9c72245..a7a8c53 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -80,6 +80,20 @@ static void mce_do_notify(struct user_return_notifier *urn);
 static DEFINE_PER_CPU(struct mce_notify, mce_notify);
 
 /*
+ * Task return notifiers are used for "action required"
+ * recovery of tasks - i.e. we prevent return to the task
+ * that encountered the machine check, but we ensure that
+ * we process the error in task context.
+ */
+struct task_notify {
+	struct user_return_notifier urn;
+	unsigned	long pfn;
+	atomic_t	inuse;
+};
+static struct task_notify task_notifier[NR_CPUS];
+static void mce_do_task(struct user_return_notifier *urn);
+
+/*
  * Tolerant levels:
  *   0: always panic on uncorrected errors, log corrected errors
  *   1: panic or SIGBUS on uncorrected errors, log corrected errors
@@ -975,6 +989,84 @@ static void mce_clear_state(unsigned long *toclear)
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
+	int	i;
+
+	if (!mce_usable_address(m))
+		mce_panic("No address for Action-Required Machine Check",
+			  m, msg);
+	if (!(m->mcgstatus & MCG_STATUS_EIPV))
+		mce_panic("No EIPV for Action-Required Machine Check",
+			  m, msg);
+
+	for (i = 0; i < NR_CPUS; i++)
+		if (!atomic_cmpxchg(&task_notifier[i].inuse, 0, 1))
+			break;
+	if (i == NR_CPUS)
+		mce_panic("Too many concurrent errors", m, msg);
+
+	task_notifier[i].urn.on_user_return = mce_do_task;
+	task_notifier[i].pfn = m->addr >> PAGE_SHIFT;
+	task_return_notifier_register(&task_notifier[i].urn);
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
+static void handle_action_required(unsigned long pfn)
+{
+	struct task_struct *me = current;
+
+	pr_err("Uncorrected hardware memory error in user-access at %llx",
+	       PADDR(pfn));
+	if (__memory_failure(pfn, MCE_VECTOR, 0) < 0) {
+		pr_err("Memory error not recovered");
+		ar_fallback(me, pfn);
+	} else
+		pr_err("Memory error recovered");
+}
+
+#undef pr_fmt
+#define pr_fmt(x) x
+
 /*
  * The actual machine check handler. This only handles real
  * exceptions when something got corrupted coming in through int 18.
@@ -1086,12 +1178,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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
@@ -1136,6 +1222,15 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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
@@ -1194,6 +1289,17 @@ static void mce_do_notify(struct user_return_notifier *urn)
 	mce_process_ring();
 }
 
+static void mce_do_task(struct user_return_notifier *urn)
+{
+	struct task_notify *np = container_of(urn, struct task_notify, urn);
+	unsigned long pfn = np->pfn;
+
+	task_return_notifier_unregister(urn);
+	atomic_set(&np->inuse, 0);
+
+	handle_action_required(pfn);
+}
+
 static void mce_process_work(struct work_struct *dummy)
 {
 	mce_process_ring();
-- 
1.7.3.1

