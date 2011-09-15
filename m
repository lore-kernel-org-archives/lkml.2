Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab1IOIJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 04:09:22 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:21794 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab1IOIJU convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:4:1>);
	Thu, 15 Sep 2011 04:09:20 -0400
Message-Id: <4E71CECC020000780005637C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 15 Sep 2011 09:09:16 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Frederic Weisbecker" <fweisbec@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix CFI data for interrupt frames
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch titled "x86: Don't use frame pointer to save old stack on irq
entry" did not properly adjust CFI directives, so this patch is a
follow-up to that one.

With the old stack pointer no longer stored in a callee-saved register
(plus some offset), we now have to use a CFA expression to describe the
memory location where it is being found. This requires the use of
.cfi_escape (allowing arbitrary byte streams to be emitted into
.eh_frame), as there is no .cfi_def_cfa_expression (which also cannot
reasonably be expected, as it would require a full expression parser).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>

---
 arch/x86/include/asm/dwarf2.h |    2 ++
 arch/x86/kernel/entry_64.S    |   14 +++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

--- 3.1-rc6/arch/x86/include/asm/dwarf2.h
+++ 3.1-rc6-x86_64-unwind-through-interrupts/arch/x86/include/asm/dwarf2.h
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
--- 3.1-rc6/arch/x86/kernel/entry_64.S
+++ 3.1-rc6-x86_64-unwind-through-interrupts/arch/x86/kernel/entry_64.S
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



