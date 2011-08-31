Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1HaWZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:25:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:37883 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714Ab1HaWZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:25:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="44161506"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, "Borislav Petkov" <bp@amd64.org>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <4e5eb3f12101199595@agluck-desktop.sc.intel.com>
Subject: [PATCH 1/5] x86, mce: rework use of TIF_MCE_NOTIFY
Date: Wed, 31 Aug 2011 15:25:34 -0700
Message-Id: <4e5eb4de21045898f1@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

The basic flow of MCE handler is summarized as follows:
 1) from NMI context:
	check hardware error registers, determine error severity,
	and then panic or request non-NMI context by irq_work() to
	continue the system.
 2) from (irq) context:
	call non-NMI safe functions,
	wake up loggers and schedule work if required
 3) from worker thread:
	process some time-consuming works like memory poisoning.

TIF_MCE_NOTIFY flag is relatively legacy and have used to do tasks of
2) and 3) on the thread context that interrupted by MCE.  However now
use of irq_work() and work-queue is enough for these tasks, so this
patch removes duplicated tasks in mce_notify_process().

As the result there is no task to be done in the interrupted context,
but soon if SRAR is supported there would be some thread-specific thing
for action required.  So keep the flag for such possible future use,
until better mechanism is introduced.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---

This is the combination of two patches by Seto-san - with Boris'
suggestion to not create a 2-line function mce_memory_failure_process()
but to leave those inline.
Message-ID: <4DFB1476.40804@jp.fujitsu.com>
[PATCH 6/8] x86, mce: introduce mce_memory_failure_process()
Message-ID: <4DFB1509.7020402@jp.fujitsu.com>
[PATCH 7/8] x86, mce: rework use of TIF_MCE_NOTIFY

 arch/x86/kernel/cpu/mcheck/mce.c |   35 ++++++++++++++++-------------------
 1 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 08363b0..91bb983 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1037,8 +1037,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	if (kill_it && tolerant < 3)
 		force_sig(SIGBUS, current);
 
-	/* notify userspace ASAP */
-	set_thread_flag(TIF_MCE_NOTIFY);
+	/* Trap this thread before returning to user, for action required */
+	if (worst == MCE_AR_SEVERITY)
+		set_thread_flag(TIF_MCE_NOTIFY);
 
 	if (worst > 0)
 		mce_report_event(regs);
@@ -1052,31 +1053,29 @@ EXPORT_SYMBOL_GPL(do_machine_check);
 /* dummy to break dependency. actual code is in mm/memory-failure.c */
 void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
 {
-	printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);
+	pr_err("Action optional memory failure at %lx ignored\n", pfn);
 }
 
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
-	unsigned long pfn;
-	mce_notify_irq();
-	while (mce_ring_get(&pfn))
-		memory_failure(pfn, MCE_VECTOR);
+	clear_thread_flag(TIF_MCE_NOTIFY);
+
+	/* TBD: do recovery for action required event */
 }
 
 static void mce_process_work(struct work_struct *dummy)
 {
-	mce_notify_process();
+	unsigned long pfn;
+
+	while (mce_ring_get(&pfn))
+		memory_failure(pfn, MCE_VECTOR);
 }
 
 #ifdef CONFIG_X86_MCE_INTEL
@@ -1157,8 +1156,6 @@ int mce_notify_irq(void)
 	/* Not more than two messages every minute */
 	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
 
-	clear_thread_flag(TIF_MCE_NOTIFY);
-
 	if (test_and_clear_bit(0, &mce_need_notify)) {
 		/* wake processes polling /dev/mcelog */
 		wake_up_interruptible(&mce_chrdev_wait);
-- 
1.7.3.1

