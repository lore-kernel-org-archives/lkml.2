Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0IJBrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:47:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:54055 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865Ab0IJBrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:47:47 -0400
Date: Fri, 10 Sep 2010 01:46:31 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1283563039-3466-3-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-3-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: Merge fpu_init()
Message-ID: <tip-6ac8bac2684235f4caf22a410549c582aa7327d6@git.kernel.org>
Git-Commit-ID: 6ac8bac2684235f4caf22a410549c582aa7327d6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 01:46:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ac8bac2684235f4caf22a410549c582aa7327d6
Gitweb:     http://git.kernel.org/tip/6ac8bac2684235f4caf22a410549c582aa7327d6
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 3 Sep 2010 21:17:09 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 9 Sep 2010 14:16:20 -0700

x86, fpu: Merge fpu_init()

Make fpu_init() handle 32-bit setup.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1283563039-3466-3-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/common.c |    7 -------
 arch/x86/kernel/i387.c       |   30 ++++++++++++++----------------
 arch/x86/kernel/traps.c      |   12 ------------
 3 files changed, 14 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 490dac6..f9e23e8 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1264,13 +1264,6 @@ void __cpuinit cpu_init(void)
 	clear_all_debug_regs();
 	dbg_restore_debug_regs();
 
-	/*
-	 * Force FPU initialization:
-	 */
-	current_thread_info()->status = 0;
-	clear_used_math();
-	mxcsr_feature_mask_init();
-
 	fpu_init();
 	xsave_init();
 }
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 2605c50..8216651 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -85,7 +85,6 @@ static void __cpuinit init_thread_xstate(void)
 #endif
 }
 
-#ifdef CONFIG_X86_64
 /*
  * Called at bootup to set up the initial FPU state that is later cloned
  * into all processes.
@@ -93,12 +92,21 @@ static void __cpuinit init_thread_xstate(void)
 
 void __cpuinit fpu_init(void)
 {
-	unsigned long oldcr0 = read_cr0();
-
-	set_in_cr4(X86_CR4_OSFXSR);
-	set_in_cr4(X86_CR4_OSXMMEXCPT);
+	unsigned long cr0;
+	unsigned long cr4_mask = 0;
 
-	write_cr0(oldcr0 & ~(X86_CR0_TS|X86_CR0_EM)); /* clear TS and EM */
+	if (cpu_has_fxsr)
+		cr4_mask |= X86_CR4_OSFXSR;
+	if (cpu_has_xmm)
+		cr4_mask |= X86_CR4_OSXMMEXCPT;
+	if (cr4_mask)
+		set_in_cr4(cr4_mask);
+
+	cr0 = read_cr0();
+	cr0 &= ~(X86_CR0_TS|X86_CR0_EM); /* clear TS and EM */
+	if (!HAVE_HWFP)
+		cr0 |= X86_CR0_EM;
+	write_cr0(cr0);
 
 	if (!smp_processor_id())
 		init_thread_xstate();
@@ -109,16 +117,6 @@ void __cpuinit fpu_init(void)
 	clear_used_math();
 }
 
-#else	/* CONFIG_X86_64 */
-
-void __cpuinit fpu_init(void)
-{
-	if (!smp_processor_id())
-		init_thread_xstate();
-}
-
-#endif	/* CONFIG_X86_32 */
-
 void fpu_finit(struct fpu *fpu)
 {
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 60788de..d0029eb 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -881,18 +881,6 @@ void __init trap_init(void)
 #endif
 
 #ifdef CONFIG_X86_32
-	if (cpu_has_fxsr) {
-		printk(KERN_INFO "Enabling fast FPU save and restore... ");
-		set_in_cr4(X86_CR4_OSFXSR);
-		printk("done.\n");
-	}
-	if (cpu_has_xmm) {
-		printk(KERN_INFO
-			"Enabling unmasked SIMD FPU exception support... ");
-		set_in_cr4(X86_CR4_OSXMMEXCPT);
-		printk("done.\n");
-	}
-
 	set_system_trap_gate(SYSCALL_VECTOR, &system_call);
 	set_bit(SYSCALL_VECTOR, used_vectors);
 #endif
