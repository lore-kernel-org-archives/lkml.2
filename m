Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab1EaUWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:22:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42629 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758190Ab1EaUWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:22:00 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 2/4] x86, asm: Flip SAVE_ARGS arguments logic
Date: Tue, 31 May 2011 22:21:52 +0200
Message-Id: <1306873314-32523-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.5.3.401.gfb674
In-Reply-To: <1306873314-32523-1-git-send-email-bp@alien8.de>
References: <1306873314-32523-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This saves us the else part of the conditional statement in the macro.

No functionality change.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/ia32/ia32entry.S      |    6 +++---
 arch/x86/include/asm/calling.h |    8 +++-----
 arch/x86/kernel/entry_64.S     |    2 +-
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index c1870dd..c5435dc 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -143,7 +143,7 @@ ENTRY(ia32_sysenter_target)
 	CFI_REL_OFFSET rip,0
 	pushq_cfi %rax
 	cld
-	SAVE_ARGS 0,0,1
+	SAVE_ARGS 0,1,0
  	/* no need to do an access_ok check here because rbp has been
  	   32bit zero extended */ 
 1:	movl	(%rbp),%ebp
@@ -289,7 +289,7 @@ ENTRY(ia32_cstar_target)
 	 * disabled irqs and here we enable it straight after entry:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	SAVE_ARGS 8,1,1
+	SAVE_ARGS 8,0,0
 	movl 	%eax,%eax	/* zero extension */
 	movq	%rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq	%rcx,RIP-ARGOFFSET(%rsp)
@@ -419,7 +419,7 @@ ENTRY(ia32_syscall)
 	cld
 	/* note the registers are not zero extended to the sf.
 	   this could be a problem. */
-	SAVE_ARGS 0,0,1
+	SAVE_ARGS 0,1,0
 	GET_THREAD_INFO(%r10)
 	orl   $TS_COMPAT,TI_status(%r10)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index b67e06c..b0b7d90 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -85,22 +85,20 @@ For 32-bit we have the following conventions - kernel is built with
 #define ARGOFFSET	R11
 #define SWFRAME		ORIG_RAX
 
-	.macro SAVE_ARGS addskip=0, norcx=0, nor891011=0
+	.macro SAVE_ARGS addskip=0, save_rcx=1, save_r891011=1
 	subq  $9*8+\addskip, %rsp
 	CFI_ADJUST_CFA_OFFSET	9*8+\addskip
 	movq_cfi rdi, 8*8
 	movq_cfi rsi, 7*8
 	movq_cfi rdx, 6*8
 
-	.if \norcx
-	.else
+	.if \save_rcx
 	movq_cfi rcx, 5*8
 	.endif
 
 	movq_cfi rax, 4*8
 
-	.if \nor891011
-	.else
+	.if \save_r891011
 	movq_cfi r8,  3*8
 	movq_cfi r9,  2*8
 	movq_cfi r10, 1*8
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8a445a0..e5ece6b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -473,7 +473,7 @@ ENTRY(system_call_after_swapgs)
 	 * and short:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	SAVE_ARGS 8,1
+	SAVE_ARGS 8,0
 	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
-- 
1.7.5.3.401.gfb674

