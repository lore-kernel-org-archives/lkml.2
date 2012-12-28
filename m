Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2L1MrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 07:47:20 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:53520 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab2L1MrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 07:47:19 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <viro@ZenIV.linux.org.uk>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 1/2] ARC: [Review] Preparing to fix incorrect syscall restarts due to signals
Date: Fri, 28 Dec 2012 18:12:36 +0530
Message-ID: <1356698557-9000-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <50DD91C1.3000809@synopsys.com>
References: <50DD91C1.3000809@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid multiple syscall restarts (multiple signals) or no restart at
all (sigreturn), we need just an extra bit of state "literally 1 bit" in
struct pt_regs. orig_r8 is the best place to do this, however given the
way it is encoded currently, we can't add anything simplistically.

Current orig_r8:
* syscalls   -> 1 to NR_SYSCALLS
* Exceptions -> NR_SYSCALLS + 1
* Break-point-> NR_SYSCALLS + 2

In new scheme it is a bit-field
* lower short word contains the  exact event type (and a new bit to represent
   restart semantics : if syscall was already / can't be restarted)
* upper short word optionally containing the syscall num - needed by
  likes of tracehooks etc

This change only changes the value orig_r8 is organised and nothing
should change behaviourily.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/entry.h  |   31 ++++++++++++++++++-------------
 arch/arc/include/asm/ptrace.h |   17 ++++++++++++-----
 arch/arc/kernel/entry.S       |   10 +++++-----
 3 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/arch/arc/include/asm/entry.h b/arch/arc/include/asm/entry.h
index 4b8619e..414007a 100644
--- a/arch/arc/include/asm/entry.h
+++ b/arch/arc/include/asm/entry.h
@@ -415,18 +415,12 @@
  *-------------------------------------------------------------*/
 .macro SAVE_ALL_EXCEPTION   marker
 
+	st      \marker, [sp, 8]
+	st      r0, [sp, 4]    /* orig_r0, needed only for sys calls */
+
 	/* Restore r9 used to code the early prologue */
 	EXCPN_PROLOG_RESTORE_REG  r9
 
-	/* Save the complete regfile now */
-
-	/* orig_r8 marker:
-	 * syscalls   -> 1 to NR_SYSCALLS
-	 * Exceptions -> NR_SYSCALLS + 1
-	 * Break-point-> NR_SYSCALLS + 2
-	 */
-	st      \marker, [sp, 8]
-	st      r0, [sp, 4]    /* orig_r0, needed only for sys calls */
 	SAVE_CALLER_SAVED
 	st.a    r26, [sp, -4]   /* gp */
 	st.a    fp, [sp, -4]
@@ -456,14 +450,25 @@
  * Save scratch regs for exceptions
  *-------------------------------------------------------------*/
 .macro SAVE_ALL_SYS
-	SAVE_ALL_EXCEPTION  (NR_syscalls + 1)
+	SAVE_ALL_EXCEPTION  orig_r8_IS_EXCPN
 .endm
 
 /*--------------------------------------------------------------
  * Save scratch regs for sys calls
  *-------------------------------------------------------------*/
 .macro SAVE_ALL_TRAP
-	SAVE_ALL_EXCEPTION  r8
+	/*
+	 * Encode syscall number (r8) in upper short word of event type (r9)
+	 * (r9 is already clobbered when we land here)
+	 */
+#ifndef CONFIG_CPU_BIG_ENDIAN
+	lsl  r9, r8, 16
+	or   r9, r9, orig_r8_IS_SCALL
+#else
+	lsl  r9, orig_r8_IS_SCALL, 16
+	or   r9, r9, r8
+#endif
+	SAVE_ALL_EXCEPTION  r9
 .endm
 
 /*--------------------------------------------------------------
@@ -518,7 +523,7 @@
 #endif
 
 	/* now we are ready to save the remaining context :) */
-	st     -1, [sp, 8]    /* orig_r8, -1 for interuppt level one */
+	st      orig_r8_IS_IRQ1, [sp, 8]    /* Event Type */
 	st      0, [sp, 4]    /* orig_r0 , N/A for IRQ */
 	SAVE_CALLER_SAVED
 	st.a    r26, [sp, -4]   /* gp */
@@ -553,7 +558,7 @@
 	ld  r9, [@int2_saved_reg]
 
 	/* now we are ready to save the remaining context :) */
-	st     -2, [sp, 8]    /* orig_r8, -2 for interrupt level 2 */
+	st      orig_r8_IS_IRQ2, [sp, 8]    /* Event Type */
 	st      0, [sp, 4]    /* orig_r0 , N/A for IRQ */
 	SAVE_CALLER_SAVED
 	st.a    r26, [sp, -4]   /* gp */
diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
index f38580c..7daa3a6 100644
--- a/arch/arc/include/asm/ptrace.h
+++ b/arch/arc/include/asm/ptrace.h
@@ -50,7 +50,8 @@ struct pt_regs {
 	long r0;
 	long sp;	/* user/kernel sp depending on where we came from  */
 	long orig_r0;
-	long orig_r8;	/*to distinguish bet excp, sys call, int1 or int2 */
+	/*to distinguish bet excp, syscall, irq */
+	unsigned long event_type:16, orig_r8:16;
 };
 
 /* Callee saved registers - need to be saved only when you are scheduled out */
@@ -89,9 +90,8 @@ struct user_regs_struct {
 /* return 1 if PC in delay slot */
 #define delay_mode(regs) ((regs->status32 & STATUS_DE_MASK) == STATUS_DE_MASK)
 
-/* return 1 if in syscall, 0 if Intr or Exception */
-#define in_syscall(regs) (((regs->orig_r8) >= 0 && \
-			   (regs->orig_r8 <= NR_syscalls)) ? 1 : 0)
+#define in_syscall(regs) (regs->orig_r8 & orig_r8_IS_SCALL)
+#define in_brkpt_trap(regs) (regs->orig_r8 & orig_r8_IS_BRKPT)
 
 #define current_pt_regs()					\
 ({								\
@@ -101,7 +101,6 @@ struct user_regs_struct {
 	(struct pt_regs *)(pg_start + THREAD_SIZE - 4) - 1;	\
 })
 
-#define in_brkpt_trap(regs) (((regs->orig_r8) == (NR_syscalls + 2)) ? 1 : 0)
 
 #define user_stack_pointer(regs)\
 ({  unsigned int sp;		\
@@ -112,6 +111,14 @@ struct user_regs_struct {
 	sp;			\
 })
 
+
 #endif /* !__ASSEMBLY__ */
 
+#define orig_r8_IS_SCALL		0x0001
+#define orig_r8_IS_SCALL_RESTARTED	0x0002
+#define orig_r8_IS_BRKPT		0x0004
+#define orig_r8_IS_EXCPN		0x0004
+#define orig_r8_IS_IRQ1			0x0010
+#define orig_r8_IS_IRQ2			0x0020
+
 #endif /* __ASM_PTRACE_H */
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 365a01b..f509306 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -500,8 +500,8 @@ tracesys_exit:
 
 trap_with_param:
 
-	;make sure orig_r8 is a positive value
-	st  NR_syscalls + 2, [sp, PT_orig_r8]
+	; stop_pc info by gdb needs this info
+	st  orig_r8_IS_BRKPT, [sp, PT_orig_r8]
 
 	mov r0, r12
 	lr  r1, [efa]
@@ -727,10 +727,10 @@ not_exception:
 	;----------------------------------------------------------------
 
 	ld r9, [sp, PT_orig_r8]        ; get orig_r8 to make sure it is
-	brne r9, -2, 149f              ; infact a L2 ISR ret path
+	brne r9, orig_r8_IS_IRQ2, 149f ; infact a L2 ISR ret path
 
-	ld r9, [sp, PT_status32]        ; get statu32_l2 (saved in pt_regs)
-	bbit0 r9, STATUS_A1_BIT, 149f     ; L1 not active when L2 IRQ, so normal
+	ld r9, [sp, PT_status32]       ; get statu32_l2 (saved in pt_regs)
+	bbit0 r9, STATUS_A1_BIT, 149f  ; L1 not active when L2 IRQ, so normal
 
 	; A1 is set in status32_l2
 	; decrement thread_info->preempt_count (re-enable preemption)
-- 
1.7.4.1

