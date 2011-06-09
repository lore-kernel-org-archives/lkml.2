Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab1FIVfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:35:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:54281 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab1FIVfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:35:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,343,1304319600"; 
   d="scan'208";a="10301471"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Borislav Petkov" <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
        "Avi Kivity" <avi@redhat.com>
In-Reply-To: <4df13a522720782e51@agluck-desktop.sc.intel.com>
Subject: [PATCH 07/10] MCE: replace mce.c use of TIF_MCE_NOTIFY with user_return_notifier
Date: Thu, 09 Jun 2011 14:35:42 -0700
Message-Id: <4df13cae2729896ba5@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

Ingo wrote:
> We already have a generic facility to do such things at
> return-to-userspace: _TIF_USER_RETURN_NOTIFY.

This just a proof of concept patch ... before this can become
real the user-return-notifier code would have to be made NMI
safe (currently it uses hlist_add_head/hlist_del, which would
need to be changed to Ying's NMI-safe single threaded lists).

Reviewed-by: Avi Kivity <avi@redhat.com>
NOT-Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/Kconfig                 |    1 +
 arch/x86/kernel/cpu/mcheck/mce.c |   47 +++++++++++++++++++++++++++----------
 arch/x86/kernel/signal.c         |    6 -----
 3 files changed, 35 insertions(+), 19 deletions(-)

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
index ffc8d11..28d223e 100644
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
@@ -947,6 +957,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	int i;
 	int worst = 0;
 	int severity;
+	struct mce_notify *np;
 	/*
 	 * Establish sequential order between the CPUs entering the machine
 	 * check handler.
@@ -1099,7 +1110,12 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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
@@ -1116,28 +1132,35 @@ void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
 	printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);
 }
 
+static void mce_process_ring(void)
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
@@ -1218,8 +1241,6 @@ int mce_notify_irq(void)
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
-- 
1.7.3.1

