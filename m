Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab1LMTO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 14:14:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:44935 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661Ab1LMTOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 14:14:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95755461"
Message-Id: <80cbf65ae6e4bd610523cc8568b0c2dcb8c629b6.1323803130.git.tony.luck@intel.com>
In-Reply-To: <cover.1323803130.git.tony.luck@intel.com>
References: <cover.1323803130.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Mon, 12 Dec 2011 13:47:45 -0800
Subject: [PATCH 5/6] x86, mce: handle "action required" errors
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
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

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   64 ++++++++++++++++++++++---------------
 1 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 9b83b7d..66e3bfb 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1044,12 +1044,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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
@@ -1070,6 +1064,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		}
 	}
 
+	m = *final;
+
 	if (!no_way_out)
 		mce_clear_state(toclear);
 
@@ -1088,7 +1084,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * support MCE broadcasting or it has been disabled.
 	 */
 	if (no_way_out && tolerant < 3)
-		mce_panic("Fatal machine check on current CPU", final, msg);
+		mce_panic("Fatal machine check on current CPU", &m, msg);
 
 	/*
 	 * If the error seems to be unrecoverable, something should be
@@ -1097,11 +1093,13 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * high, don't try to do anything at all.
 	 */
 
-	if (kill_it && tolerant < 3)
+	if (worst != MCE_AR_SEVERITY && kill_it && tolerant < 3)
 		force_sig(SIGBUS, current);
 
-	/* notify userspace ASAP */
-	set_thread_flag(TIF_MCE_NOTIFY);
+	if (worst == MCE_AR_SEVERITY) {
+		mce_save_info(m.addr);
+		set_thread_flag(TIF_MCE_NOTIFY);
+	}
 
 	if (worst > 0)
 		mce_report_event(regs);
@@ -1115,34 +1113,50 @@ EXPORT_SYMBOL_GPL(do_machine_check);
 #ifndef CONFIG_MEMORY_FAILURE
 int memory_failure(unsigned long pfn, int vector, int flags)
 {
-	printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);
+	if (flags & MF_ACTION_REQUIRED)
+		return -ENXIO; /* panic? */
+	else
+		printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);
 
 	return 0;
 }
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
+ * TIF_MCE_NOTFY, just before returning to errorneous userland.
+ * This code is allowed to sleep.
+ * Attempt possible recovery such as calling the high level VM handler to
+ * process any corrupted pages, and kill/signal current process if required.
  */
 void mce_notify_process(void)
 {
+	__u64	paddr = paddr;
 	unsigned long pfn;
-	mce_notify_irq();
-	while (mce_ring_get(&pfn))
-		memory_failure(pfn, MCE_VECTOR, 0);
+
+	if (!mce_find_info(&paddr))
+		mce_panic("Lost address", NULL, NULL);
+	pfn = paddr >> PAGE_SHIFT;
+
+	clear_thread_flag(TIF_MCE_NOTIFY);
+
+	pr_err("Uncorrected hardware memory error in user-access at %llx",
+		 paddr);
+	if (memory_failure(pfn, MCE_VECTOR, MF_ACTION_REQUIRED) < 0) {
+		pr_err("Memory error not recovered");
+		force_sig(SIGBUS, current);
+	} else {
+		pr_err("Memory error recovered");
+		mce_clear_info();
+	}
 }
 
 static void mce_process_work(struct work_struct *dummy)
 {
-	mce_notify_process();
+	unsigned long pfn;
+
+	while (mce_ring_get(&pfn))
+		memory_failure(pfn, MCE_VECTOR, 0);
 }
 
 #ifdef CONFIG_X86_MCE_INTEL
@@ -1232,8 +1246,6 @@ int mce_notify_irq(void)
 	/* Not more than two messages every minute */
 	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
 
-	clear_thread_flag(TIF_MCE_NOTIFY);
-
 	if (test_and_clear_bit(0, &mce_need_notify)) {
 		/* wake processes polling /dev/mcelog */
 		wake_up_interruptible(&mce_chrdev_wait);
-- 
1.7.3.1

