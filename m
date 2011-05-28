Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab1E1AgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 20:36:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:45439 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757549Ab1E1AgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 20:36:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,283,1304319600"; 
   d="scan'208";a="10186183"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, avi@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [POC] mce: replace TIF_MCE_NOTIFY with TIF_USER_RETURN_NOTIFY
Date: Fri, 27 May 2011 17:35:48 -0700
Message-Id: <4de043641213294e72@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Oops - forgot to Cc: LKML!]
Ingo wrote:
> We already have a generic facility to do such things at
> return-to-userspace: _TIF_USER_RETURN_NOTIFY.

This is what it might look like if we replaced the current use
of TIF_MCE_NOTIFY with TIF_USER_RETURN_NOTIFY in mce.c

Question: the notifier can potentially send signals to the current
process - so should the check for _TIF_USER_RETURN_NOTIFY in do_notify_resume
be moved before the check for _TIF_SIGPENDING?  Would doing do be a problem
for the existing user of user-return-notifiers (kvm)?

Note1 - this is a backport of a version that I wrote and tested on
top of my mce-recovery patch set - since I had a debug environment
set up to test it there ... the backport was relatively painless,
but this version has only been compile tested.

Note2 - I didn't delete the TIF_MCE_NOTIFY definition - I'd like
to keep bit 10 available for a _TIF_USER_RETURN_NOTIFY_TASK feature
that would be run in the context of a specific task (on any cpu)
rather than on a specific cpu (in any task context).

-Tony

---

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..054e127 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -845,6 +845,7 @@ config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 
 config X86_MCE
 	bool "Machine Check / overheating reporting"
+	select USER_RETURN_NOTIFIER
 	---help---
 	  Machine Check support allows the processor to notify the
 	  kernel if it detects a problem (e.g. overheating, data corruption).
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 3385ea2..10b3dbe 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -38,6 +38,7 @@
 #include <linux/mm.h>
 #include <linux/debugfs.h>
 #include <linux/edac_mce.h>
+#include <linux/user-return-notifier.h>
 
 #include <asm/processor.h>
 #include <asm/hw_irq.h>
@@ -69,6 +70,15 @@ atomic_t mce_entry;
 
 DEFINE_PER_CPU(unsigned, mce_exception_count);
 
+struct mce_notify {
+	struct user_return_notifier urn;
+	bool registered;
+};
+
+static void mce_do_notify(struct user_return_notifier *urn);
+
+static DEFINE_PER_CPU(struct mce_notify, mce_notify);
+
 /*
  * Tolerant levels:
  *   0: always panic on uncorrected errors, log corrected errors
@@ -923,6 +933,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	int i;
 	int worst = 0;
 	int severity;
+	struct mce_notify *np;
 	/*
 	 * Establish sequential order between the CPUs entering the machine
 	 * check handler.
@@ -1077,7 +1088,12 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		force_sig(SIGBUS, current);
 
 	/* notify userspace ASAP */
-	set_thread_flag(TIF_MCE_NOTIFY);
+	np = &__get_cpu_var(mce_notify);
+	if (np->registered == 0) {
+		np->urn.on_user_return = mce_do_notify;
+		user_return_notifier_register(&np->urn);
+		np->registered = 1;
+	}
 
 	if (worst > 0)
 		mce_report_event(regs);
@@ -1094,28 +1110,35 @@ void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
 	printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);
 }
 
+void mce_process_ring(void)
+{
+	unsigned long pfn;
+
+	mce_notify_irq();
+	while (mce_ring_get(&pfn))
+		memory_failure(pfn, MCE_VECTOR);
+}
+
 /*
  * Called after mce notification in process context. This code
  * is allowed to sleep. Call the high level VM handler to process
  * any corrupted pages.
  * Assume that the work queue code only calls this one at a time
  * per CPU.
- * Note we don't disable preemption, so this code might run on the wrong
- * CPU. In this case the event is picked up by the scheduled work queue.
- * This is merely a fast path to expedite processing in some common
- * cases.
  */
-void mce_notify_process(void)
+static void mce_do_notify(struct user_return_notifier *urn)
 {
-	unsigned long pfn;
-	mce_notify_irq();
-	while (mce_ring_get(&pfn))
-		memory_failure(pfn, MCE_VECTOR);
+	struct mce_notify *np = container_of(urn, struct mce_notify, urn);
+
+	user_return_notifier_unregister(urn);
+	np->registered = 0;
+
+	mce_process_ring();
 }
 
 static void mce_process_work(struct work_struct *dummy)
 {
-	mce_notify_process();
+	mce_process_ring();
 }
 
 #ifdef CONFIG_X86_MCE_INTEL
@@ -1196,8 +1219,6 @@ int mce_notify_irq(void)
 	/* Not more than two messages every minute */
 	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
 
-	clear_thread_flag(TIF_MCE_NOTIFY);
-
 	if (test_and_clear_bit(0, &mce_need_notify)) {
 		wake_up_interruptible(&mce_wait);
 
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 4fd173c..44efc22 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -838,12 +838,6 @@ static void do_signal(struct pt_regs *regs)
 void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
-#ifdef CONFIG_X86_MCE
-	/* notify userspace of pending MCEs */
-	if (thread_info_flags & _TIF_MCE_NOTIFY)
-		mce_notify_process();
-#endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
-
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
