Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab0H1QGY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:06:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47822 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab0H1QGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:06:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NbZmBYu5aRzTmgAEb4vDi3bbdi9DUTS5ezH35y8JJK2o+8RXezpI9KfAgmJNWqucdi
         6epnGrR/fLWfWxP9E3lQJnPCGWwjUKSSGOdkpe4AvOEnJ9795CZUU0pG/YVPQoTDws3U
         OeVjgOHWSqWoe20ltkHinvYhkXxE/g71X9oK4=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] x86: Merge fpu_init()
Date: Sat, 28 Aug 2010 12:04:29 -0400
Message-Id: <1283011478-27237-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make fpu_init() handle 32-bit setup.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/cpu/common.c |    7 -------
 arch/x86/kernel/i387.c       |   27 ++++++++++++---------------
 arch/x86/kernel/traps.c      |   12 ------------
 3 files changed, 12 insertions(+), 34 deletions(-)

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
index a46cb35..c795675 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -80,7 +80,6 @@ static void __cpuinit init_thread_xstate(void)
 #endif
 }
 
-#ifdef CONFIG_X86_64
 /*
  * Called at bootup to set up the initial FPU state that is later cloned
  * into all processes.
@@ -88,12 +87,20 @@ static void __cpuinit init_thread_xstate(void)
 
 void __cpuinit fpu_init(void)
 {
-	unsigned long oldcr0 = read_cr0();
+	unsigned long cr0;
+	unsigned long cr4_mask = 0;
 
-	set_in_cr4(X86_CR4_OSFXSR);
-	set_in_cr4(X86_CR4_OSXMMEXCPT);
+	if (cpu_has_fxsr)
+		cr4_mask |= X86_CR4_OSFXSR;
+	if (cpu_has_xmm)
+		cr4_mask |= X86_CR4_OSXMMEXCPT;
+	set_in_cr4(cr4_mask);
 
-	write_cr0(oldcr0 & ~(X86_CR0_TS|X86_CR0_EM)); /* clear TS and EM */
+	cr0 = read_cr0();
+	cr0 &= ~(X86_CR0_TS|X86_CR0_EM); /* clear TS and EM */
+	if (!HAVE_HWFP)
+		cr0 |= X86_CR0_EM;
+	write_cr0(cr0);
 
 	if (!smp_processor_id())
 		init_thread_xstate();
@@ -104,16 +111,6 @@ void __cpuinit fpu_init(void)
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
-- 
1.7.2.2

