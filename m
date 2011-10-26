Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab1JZPOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:14:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35680 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933076Ab1JZPOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:14:03 -0400
Date: Wed, 26 Oct 2011 17:12:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm changes for v3.2
Message-ID: <20111026151221.GA26844@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asm-for-linus

 Thanks,

	Ingo

------------------>
Jan Beulich (2):
      x86-64: Don't apply destructive erratum workaround on unaffected CPUs
      x86-64: Fix CFI data for interrupt frames


 arch/x86/include/asm/dwarf2.h |    2 ++
 arch/x86/kernel/entry_64.S    |   14 +++++++++-----
 arch/x86/mm/fault.c           |    8 +++++++-
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index 3260991..f6f1598 100644
--- a/arch/x86/include/asm/dwarf2.h
+++ b/arch/x86/include/asm/dwarf2.h
@@ -27,6 +27,7 @@
 #define CFI_REMEMBER_STATE	.cfi_remember_state
 #define CFI_RESTORE_STATE	.cfi_restore_state
 #define CFI_UNDEFINED		.cfi_undefined
+#define CFI_ESCAPE		.cfi_escape
 
 #ifdef CONFIG_AS_CFI_SIGNAL_FRAME
 #define CFI_SIGNAL_FRAME	.cfi_signal_frame
@@ -68,6 +69,7 @@
 #define CFI_REMEMBER_STATE	cfi_ignore
 #define CFI_RESTORE_STATE	cfi_ignore
 #define CFI_UNDEFINED		cfi_ignore
+#define CFI_ESCAPE		cfi_ignore
 #define CFI_SIGNAL_FRAME	cfi_ignore
 
 #endif
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 6419bb0..faf8d5e 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -331,10 +331,15 @@ ENDPROC(native_usergs_sysret64)
 1:	incl PER_CPU_VAR(irq_count)
 	jne 2f
 	mov PER_CPU_VAR(irq_stack_ptr),%rsp
-	EMPTY_FRAME 0
+	CFI_DEF_CFA_REGISTER	rsi
 
 2:	/* Store previous stack value */
 	pushq %rsi
+	CFI_ESCAPE	0x0f /* DW_CFA_def_cfa_expression */, 6, \
+			0x77 /* DW_OP_breg7 */, 0, \
+			0x06 /* DW_OP_deref */, \
+			0x08 /* DW_OP_const1u */, SS+8-RBP, \
+			0x22 /* DW_OP_plus */
 	/* We entered an interrupt context - irqs are off: */
 	TRACE_IRQS_OFF
 	.endm
@@ -788,7 +793,6 @@ END(interrupt)
 	subq $ORIG_RAX-RBP, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-RBP
 	SAVE_ARGS_IRQ
-	PARTIAL_FRAME 0
 	call \func
 	.endm
 
@@ -813,10 +817,10 @@ ret_from_intr:
 
 	/* Restore saved previous stack */
 	popq %rsi
-	leaq 16(%rsi), %rsp
-
+	CFI_DEF_CFA_REGISTER	rsi
+	leaq ARGOFFSET-RBP(%rsi), %rsp
 	CFI_DEF_CFA_REGISTER	rsp
-	CFI_ADJUST_CFA_OFFSET	-16
+	CFI_ADJUST_CFA_OFFSET	RBP-ARGOFFSET
 
 exit_intr:
 	GET_THREAD_INFO(%rcx)
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 0d17c8c..9c7378d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -420,12 +420,14 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
 	return 0;
 }
 
+#ifdef CONFIG_CPU_SUP_AMD
 static const char errata93_warning[] =
 KERN_ERR 
 "******* Your BIOS seems to not contain a fix for K8 errata #93\n"
 "******* Working around it, but it may cause SEGVs or burn power.\n"
 "******* Please consider a BIOS update.\n"
 "******* Disabling USB legacy in the BIOS may also help.\n";
+#endif
 
 /*
  * No vm86 mode in 64-bit mode:
@@ -505,7 +507,11 @@ bad:
  */
 static int is_errata93(struct pt_regs *regs, unsigned long address)
 {
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && defined(CONFIG_CPU_SUP_AMD)
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD
+	    || boot_cpu_data.x86 != 0xf)
+		return 0;
+
 	if (address != regs->ip)
 		return 0;
 
