Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620Ab1LQAOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 19:14:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:43830 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab1LQAO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 19:14:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103169725"
Message-Id: <2dbc04f425f55322b03f8eefd7cc9b1c07bf0b7e.1324079806.git.tony.luck@intel.com>
In-Reply-To: <CA+8MBbK6NdYtk4UOf1wrV-14kE2UXZO1VdCs3qfTqxAk4j4Tvw@mail.gmail.com>
From: Tony Luck <tony.luck@intel.com>
Date: Fri, 16 Dec 2011 15:36:18 -0800
Subject: [PATCH 5/6] x86, mce: handle "action required" errors (new version)
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All non-urgent actions (reporting low severity errors and handling
"action-optional" errors) are now handled by a work queue. This
means that TIF_MCE_NOTIFY can be used to block execution for a
thread experiencing an "action-required" fault until we get all
cpus out of the machine check handler (and the thread that hit
the fault into mce_notify_process().

We use the new mce_{save,find,clear}_info() API to get information
from do_machine_check() to mce_notify_process(), and then use the
newly improved memory_failure(..., MF_ACTION_REQUIRED) to handle
the error (possibly signalling the process).

Update some comments to make the new code flows clearer.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Included spelling fixes from Boris & Seto-san ... but the big
change here from last version is re-arranging the action code
as suggested by Seto-san ... to be suitably insane if "tolerant"
is set to 3.  This makes the code a little easier to read - merged
and updated the comments above this section to keep up with the
code changes.

In the final stretch? ... in case it makes things easier for anyone
to look at this, I pushed the current set of patches to:

 git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git mce-recovery-test

 arch/x86/kernel/cpu/mcheck/mce.c |   97 +++++++++++++++++++++----------------
 1 files changed, 55 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index e1579c5..f9e8d2a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -982,7 +982,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	barrier();
 
 	/*
-	 * When no restart IP must always kill or panic.
+	 * When no restart IP might need to kill or panic.
+	 * Assume the worst for now, but if we find the
+	 * severity is MCE_AR_SEVERITY we have other options.
 	 */
 	if (!(m.mcgstatus & MCG_STATUS_RIPV))
 		kill_it = 1;
@@ -1036,12 +1038,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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
@@ -1062,6 +1058,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		}
 	}
 
+	/* mce_clear_state will clear *final, save locally for use later */
+	m = *final;
+
 	if (!no_way_out)
 		mce_clear_state(toclear);
 
@@ -1073,27 +1072,22 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		no_way_out = worst >= MCE_PANIC_SEVERITY;
 
 	/*
-	 * If we have decided that we just CAN'T continue, and the user
-	 * has not set tolerant to an insane level, give up and die.
-	 *
-	 * This is mainly used in the case when the system doesn't
-	 * support MCE broadcasting or it has been disabled.
+	 * At insane "tolerant" levels we take no action. Otherwise
+	 * we only die if we have no other choice. For less serious
+	 * issues we try to recover, or limit damage to the current
+	 * process.
 	 */
-	if (no_way_out && tolerant < 3)
-		mce_panic("Fatal machine check on current CPU", final, msg);
-
-	/*
-	 * If the error seems to be unrecoverable, something should be
-	 * done.  Try to kill as little as possible.  If we can kill just
-	 * one task, do that.  If the user has set the tolerance very
-	 * high, don't try to do anything at all.
-	 */
-
-	if (kill_it && tolerant < 3)
-		force_sig(SIGBUS, current);
-
-	/* notify userspace ASAP */
-	set_thread_flag(TIF_MCE_NOTIFY);
+	if (tolerant < 3) {
+		if (no_way_out)
+			mce_panic("Fatal machine check on current CPU", &m, msg);
+		if (worst == MCE_AR_SEVERITY) {
+			/* schedule action before return to userland */
+			mce_save_info(m.addr);
+			set_thread_flag(TIF_MCE_NOTIFY);
+		} else if (kill_it) {
+			force_sig(SIGBUS, current);
+		}
+	}
 
 	if (worst > 0)
 		mce_report_event(regs);
@@ -1107,6 +1101,8 @@ EXPORT_SYMBOL_GPL(do_machine_check);
 #ifndef CONFIG_MEMORY_FAILURE
 int memory_failure(unsigned long pfn, int vector, int flags)
 {
+	if (flags & MF_ACTION_REQUIRED)
+		return -ENXIO; /* panic? */
 	printk(KERN_ERR "Uncorrected memory error in page 0x%lx ignored\n"
 		"Rebuild kernel with CONFIG_MEMORY_FAILURE=y for smarter handling\n", pfn);
 
@@ -1115,27 +1111,46 @@ int memory_failure(unsigned long pfn, int vector, int flags)
 #endif
 
 /*
- * Called after mce notification in process context. This code
- * is allowed to sleep. Call the high level VM handler to process
- * any corrupted pages.
- * Assume that the work queue code only calls this one at a time
- * per CPU.
- * Note we don't disable preemption, so this code might run on the wrong
- * CPU. In this case the event is picked up by the scheduled work queue.
- * This is merely a fast path to expedite processing in some common
- * cases.
+ * Called in process context that interrupted by MCE and marked with
+ * TIF_MCE_NOTIFY, just before returning to erroneous userland.
+ * This code is allowed to sleep.
+ * Attempt possible recovery such as calling the high level VM handler to
+ * process any corrupted pages, and kill/signal current process if required.
+ * Action required errors are handled here.
  */
 void mce_notify_process(void)
 {
 	unsigned long pfn;
-	mce_notify_irq();
-	while (mce_ring_get(&pfn))
-		memory_failure(pfn, MCE_VECTOR, 0);
+	struct mce_info *mi = mce_find_info();
+
+	if (!mi)
+		mce_panic("Lost physical address for unconsumed uncorrectable error", NULL, NULL);
+	pfn = mi->paddr >> PAGE_SHIFT;
+
+	clear_thread_flag(TIF_MCE_NOTIFY);
+
+	pr_err("Uncorrected hardware memory error in user-access at %llx",
+		 mi->paddr);
+	if (memory_failure(pfn, MCE_VECTOR, MF_ACTION_REQUIRED) < 0) {
+		pr_err("Memory error not recovered");
+		force_sig(SIGBUS, current);
+	} else {
+		pr_err("Memory error recovered");
+	}
+	mce_clear_info(mi);
 }
 
+/*
+ * Action optional processing happens here (picking up
+ * from the list of faulting pages that do_machine_check()
+ * placed into the "ring").
+ */
 static void mce_process_work(struct work_struct *dummy)
 {
-	mce_notify_process();
+	unsigned long pfn;
+
+	while (mce_ring_get(&pfn))
+		memory_failure(pfn, MCE_VECTOR, 0);
 }
 
 #ifdef CONFIG_X86_MCE_INTEL
@@ -1225,8 +1240,6 @@ int mce_notify_irq(void)
 	/* Not more than two messages every minute */
 	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
 
-	clear_thread_flag(TIF_MCE_NOTIFY);
-
 	if (test_and_clear_bit(0, &mce_need_notify)) {
 		/* wake processes polling /dev/mcelog */
 		wake_up_interruptible(&mce_chrdev_wait);
-- 
1.7.3.1

