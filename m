Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab1EaUWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:22:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42634 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758396Ab1EaUWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:22:00 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 3/4] x86, asm: Flip RESTORE_ARGS arguments logic
Date: Tue, 31 May 2011 22:21:53 +0200
Message-Id: <1306873314-32523-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.5.3.401.gfb674
In-Reply-To: <1306873314-32523-1-git-send-email-bp@alien8.de>
References: <1306873314-32523-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... thus getting rid of the "else" part of the conditional statement in
the macro.

No functionality change.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/ia32/ia32entry.S      |    4 ++--
 arch/x86/include/asm/calling.h |   21 ++++++++-------------
 arch/x86/kernel/entry_64.S     |    4 ++--
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index c5435dc..a0e866d 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -173,7 +173,7 @@ sysexit_from_sys_call:
 	andl  $~0x200,EFLAGS-R11(%rsp) 
 	movl	RIP-R11(%rsp),%edx		/* User %eip */
 	CFI_REGISTER rip,rdx
-	RESTORE_ARGS 1,24,1,1,1,1
+	RESTORE_ARGS 0,24,0,0,0,0
 	xorq	%r8,%r8
 	xorq	%r9,%r9
 	xorq	%r10,%r10
@@ -328,7 +328,7 @@ cstar_dispatch:
 	jnz sysretl_audit
 sysretl_from_sys_call:
 	andl $~TS_COMPAT,TI_status(%r10)
-	RESTORE_ARGS 1,-ARG_SKIP,1,1,1
+	RESTORE_ARGS 0,-ARG_SKIP,0,0,0
 	movl RIP-ARGOFFSET(%rsp),%ecx
 	CFI_REGISTER rip,rcx
 	movl EFLAGS-ARGOFFSET(%rsp),%r11d	
diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index b0b7d90..a9e3a74 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -109,32 +109,27 @@ For 32-bit we have the following conventions - kernel is built with
 
 #define ARG_SKIP	(9*8)
 
-	.macro RESTORE_ARGS skiprax=0, addskip=0, skiprcx=0, skipr11=0, \
-			    skipr8910=0, skiprdx=0
-	.if \skipr11
-	.else
+	.macro RESTORE_ARGS rstor_rax=1, addskip=0, rstor_rcx=1, rstor_r11=1, \
+			    rstor_r8910=1, rstor_rdx=1
+	.if \rstor_r11
 	movq_cfi_restore 0*8, r11
 	.endif
 
-	.if \skipr8910
-	.else
+	.if \rstor_r8910
 	movq_cfi_restore 1*8, r10
 	movq_cfi_restore 2*8, r9
 	movq_cfi_restore 3*8, r8
 	.endif
 
-	.if \skiprax
-	.else
+	.if \rstor_rax
 	movq_cfi_restore 4*8, rax
 	.endif
 
-	.if \skiprcx
-	.else
+	.if \rstor_rcx
 	movq_cfi_restore 5*8, rcx
 	.endif
 
-	.if \skiprdx
-	.else
+	.if \rstor_rdx
 	movq_cfi_restore 6*8, rdx
 	.endif
 
@@ -193,7 +188,7 @@ For 32-bit we have the following conventions - kernel is built with
 
 	.macro RESTORE_ALL addskip=0
 	RESTORE_REST
-	RESTORE_ARGS 0, \addskip
+	RESTORE_ARGS 1, \addskip
 	.endm
 
 	.macro icebp
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e5ece6b..0412bcb 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -508,7 +508,7 @@ sysret_check:
 	TRACE_IRQS_ON
 	movq RIP-ARGOFFSET(%rsp),%rcx
 	CFI_REGISTER	rip,rcx
-	RESTORE_ARGS 0,-ARG_SKIP,1
+	RESTORE_ARGS 1,-ARG_SKIP,0
 	/*CFI_REGISTER	rflags,r11*/
 	movq	PER_CPU_VAR(old_rsp), %rsp
 	USERGS_SYSRET64
@@ -858,7 +858,7 @@ retint_restore_args:	/* return to kernel space */
 	 */
 	TRACE_IRQS_IRETQ
 restore_args:
-	RESTORE_ARGS 0,8,0
+	RESTORE_ARGS 1,8,1
 
 irq_return:
 	INTERRUPT_RETURN
-- 
1.7.5.3.401.gfb674

