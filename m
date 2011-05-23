Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216Ab1EWWOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:14:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:63808 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852Ab1EWWOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:14:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,258,1304319600"; 
   d="scan'208";a="3540019"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        "Andi Kleen" <andi@firstfloor.org>, "Borislav Petkov" <bp@alien8.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
Subject: [RFC 7/9] MCE: Pass registers to work handlers
Date: Mon, 23 May 2011 15:14:38 -0700
Message-Id: <4ddadc4e1717078242@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

Pass the register context to the task work handler.
Needed for the next patch

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/mce.h       |    3 ++-
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++--
 arch/x86/kernel/signal.c         |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index eb16e94..66c41e0 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -195,7 +195,8 @@ enum mcp_flags {
 void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 
 int mce_notify_irq(void);
-void mce_notify_process(void);
+struct pt_regs;
+void mce_notify_process(struct pt_regs *regs);
 
 DECLARE_PER_CPU(struct mce, injectm);
 extern struct file_operations mce_chrdev_ops;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a9a0e25..6b2fa20 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1123,7 +1123,7 @@ void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
  * This is merely a fast path to expedite processing in some common
  * cases.
  */
-void mce_notify_process(void)
+void mce_notify_process(struct pt_regs *regs)
 {
 	unsigned long pfn;
 	mce_notify_irq();
@@ -1133,7 +1133,7 @@ void mce_notify_process(void)
 
 static void mce_process_work(struct work_struct *dummy)
 {
-	mce_notify_process();
+	mce_notify_process(NULL);
 }
 
 #ifdef CONFIG_X86_MCE_INTEL
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 4fd173c..3e6d421 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -841,7 +841,7 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 #ifdef CONFIG_X86_MCE
 	/* notify userspace of pending MCEs */
 	if (thread_info_flags & _TIF_MCE_NOTIFY)
-		mce_notify_process();
+		mce_notify_process(regs);
 #endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
 
 	/* deal with pending signal delivery */
-- 
1.7.3.1

