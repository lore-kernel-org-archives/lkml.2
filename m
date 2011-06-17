Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab1FQIts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:49:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34466 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab1FQItp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:49:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFB1509.7020402@jp.fujitsu.com>
Date: Fri, 17 Jun 2011 17:49:13 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>
Subject: [PATCH 7/8] x86, mce: rework use of TIF_MCE_NOTIFY
References: <4DFB1242.90404@jp.fujitsu.com>
In-Reply-To: <4DFB1242.90404@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
for action required.  So (even if it will be removed soon) keep the flag
for such possible future use, until better mechanism is introduced.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a118496..bc8a02c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1053,8 +1053,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	if (kill_it && tolerant < 3)
 		force_sig(SIGBUS, current);
 
-	/* notify userspace ASAP */
-	set_thread_flag(TIF_MCE_NOTIFY);
+	/* Trap this thread before returning to user, for action required */
+	if (worst == MCE_AR_SEVERITY)
+		set_thread_flag(TIF_MCE_NOTIFY);
 
 	if (worst > 0)
 		mce_report_event(regs);
@@ -1066,25 +1067,22 @@ out:
 EXPORT_SYMBOL_GPL(do_machine_check);
 
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
+ * TIF_MCE_NOTFY, just before returning to erroneous userland.
+ * This code is allowed to sleep.
+ * Attempt possible recovery such as calling the high level VM handler to
+ * process any corrupted pages, and kill/signal current process if required.
  */
 void mce_notify_process(void)
 {
-	mce_notify_irq();
-	mce_memory_failure_process();
+	clear_thread_flag(TIF_MCE_NOTIFY);
+
+	/* TBD: do recovery for action required event */
 }
 
 static void mce_process_work(struct work_struct *dummy)
 {
-	mce_notify_process();
+	mce_memory_failure_process();
 }
 
 #ifdef CONFIG_X86_MCE_INTEL
@@ -1187,8 +1185,6 @@ int mce_notify_irq(void)
 	/* Not more than two messages every minute */
 	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
 
-	clear_thread_flag(TIF_MCE_NOTIFY);
-
 	if (test_and_clear_bit(0, &mce_need_notify)) {
 		/* wake processes polling /dev/mcelog */
 		wake_up_interruptible(&mce_chrdev_wait);
-- 
1.7.1


