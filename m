Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab2JXM5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:57:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56649 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab2JXM5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:57:38 -0400
Date: Wed, 24 Oct 2012 05:56:25 -0700
From: tip-bot for Ma Ling <ling.ma@intel.com>
Message-ID: <tip-269833bd5a0f4443873da358b71675a890b47c3c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ling.ma@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ling.ma@intel.com, tglx@linutronix.de
In-Reply-To: <1350503565-19167-1-git-send-email-ling.ma@intel.com>
References: <1350503565-19167-1-git-send-email-ling.ma@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/asm: Clean up copy_page_*() comments and code
Git-Commit-ID: 269833bd5a0f4443873da358b71675a890b47c3c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 05:56:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  269833bd5a0f4443873da358b71675a890b47c3c
Gitweb:     http://git.kernel.org/tip/269833bd5a0f4443873da358b71675a890b47c3c
Author:     Ma Ling <ling.ma@intel.com>
AuthorDate: Thu, 18 Oct 2012 03:52:45 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 12:42:47 +0200

x86/asm: Clean up copy_page_*() comments and code

Modern CPUs use fast-string instruction to accelerate copy
performance, by combining data into 128 bit chunks.

Modify comments and coding style to match it.

Signed-off-by: Ma Ling <ling.ma@intel.com>
Cc: iant@google.com
Link: http://lkml.kernel.org/r/1350503565-19167-1-git-send-email-ling.ma@intel.com
[ Cleaned up the clean up. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/lib/copy_page_64.S |  120 +++++++++++++++++++++----------------------
 1 files changed, 59 insertions(+), 61 deletions(-)

diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index 6b34d04..176cca6 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -5,91 +5,89 @@
 #include <asm/alternative-asm.h>
 
 	ALIGN
-copy_page_c:
+copy_page_rep:
 	CFI_STARTPROC
-	movl $4096/8,%ecx
-	rep movsq
+	movl	$4096/8, %ecx
+	rep	movsq
 	ret
 	CFI_ENDPROC
-ENDPROC(copy_page_c)
+ENDPROC(copy_page_rep)
 
-/* Don't use streaming store because it's better when the target
-   ends up in cache. */
-	    
-/* Could vary the prefetch distance based on SMP/UP */
+/*
+ *  Don't use streaming copy unless the CPU indicates X86_FEATURE_REP_GOOD.
+ *  Could vary the prefetch distance based on SMP/UP.
+*/
 
 ENTRY(copy_page)
 	CFI_STARTPROC
-	subq	$2*8,%rsp
+	subq	$2*8,	%rsp
 	CFI_ADJUST_CFA_OFFSET 2*8
-	movq	%rbx,(%rsp)
+	movq	%rbx,	(%rsp)
 	CFI_REL_OFFSET rbx, 0
-	movq	%r12,1*8(%rsp)
+	movq	%r12,	1*8(%rsp)
 	CFI_REL_OFFSET r12, 1*8
 
-	movl	$(4096/64)-5,%ecx
+	movl	$(4096/64)-5,	%ecx
 	.p2align 4
 .Loop64:
-  	dec     %rcx
-
-	movq        (%rsi), %rax
-	movq      8 (%rsi), %rbx
-	movq     16 (%rsi), %rdx
-	movq     24 (%rsi), %r8
-	movq     32 (%rsi), %r9
-	movq     40 (%rsi), %r10
-	movq     48 (%rsi), %r11
-	movq     56 (%rsi), %r12
+	dec	%rcx
+	movq	0x8*0(%rsi), %rax
+	movq	0x8*1(%rsi), %rbx
+	movq	0x8*2(%rsi), %rdx
+	movq	0x8*3(%rsi), %r8
+	movq	0x8*4(%rsi), %r9
+	movq	0x8*5(%rsi), %r10
+	movq	0x8*6(%rsi), %r11
+	movq	0x8*7(%rsi), %r12
 
 	prefetcht0 5*64(%rsi)
 
-	movq     %rax,    (%rdi)
-	movq     %rbx,  8 (%rdi)
-	movq     %rdx, 16 (%rdi)
-	movq     %r8,  24 (%rdi)
-	movq     %r9,  32 (%rdi)
-	movq     %r10, 40 (%rdi)
-	movq     %r11, 48 (%rdi)
-	movq     %r12, 56 (%rdi)
+	movq	%rax, 0x8*0(%rdi)
+	movq	%rbx, 0x8*1(%rdi)
+	movq	%rdx, 0x8*2(%rdi)
+	movq	%r8,  0x8*3(%rdi)
+	movq	%r9,  0x8*4(%rdi)
+	movq	%r10, 0x8*5(%rdi)
+	movq	%r11, 0x8*6(%rdi)
+	movq	%r12, 0x8*7(%rdi)
 
-	leaq    64 (%rsi), %rsi
-	leaq    64 (%rdi), %rdi
+	leaq	64 (%rsi), %rsi
+	leaq	64 (%rdi), %rdi
 
-	jnz     .Loop64
+	jnz	.Loop64
 
-	movl	$5,%ecx
+	movl	$5, %ecx
 	.p2align 4
 .Loop2:
-	decl   %ecx
-
-	movq        (%rsi), %rax
-	movq      8 (%rsi), %rbx
-	movq     16 (%rsi), %rdx
-	movq     24 (%rsi), %r8
-	movq     32 (%rsi), %r9
-	movq     40 (%rsi), %r10
-	movq     48 (%rsi), %r11
-	movq     56 (%rsi), %r12
-
-	movq     %rax,    (%rdi)
-	movq     %rbx,  8 (%rdi)
-	movq     %rdx, 16 (%rdi)
-	movq     %r8,  24 (%rdi)
-	movq     %r9,  32 (%rdi)
-	movq     %r10, 40 (%rdi)
-	movq     %r11, 48 (%rdi)
-	movq     %r12, 56 (%rdi)
-
-	leaq	64(%rdi),%rdi
-	leaq	64(%rsi),%rsi
-
+	decl	%ecx
+
+	movq	0x8*0(%rsi), %rax
+	movq	0x8*1(%rsi), %rbx
+	movq	0x8*2(%rsi), %rdx
+	movq	0x8*3(%rsi), %r8
+	movq	0x8*4(%rsi), %r9
+	movq	0x8*5(%rsi), %r10
+	movq	0x8*6(%rsi), %r11
+	movq	0x8*7(%rsi), %r12
+
+	movq	%rax, 0x8*0(%rdi)
+	movq	%rbx, 0x8*1(%rdi)
+	movq	%rdx, 0x8*2(%rdi)
+	movq	%r8,  0x8*3(%rdi)
+	movq	%r9,  0x8*4(%rdi)
+	movq	%r10, 0x8*5(%rdi)
+	movq	%r11, 0x8*6(%rdi)
+	movq	%r12, 0x8*7(%rdi)
+
+	leaq	64(%rdi), %rdi
+	leaq	64(%rsi), %rsi
 	jnz	.Loop2
 
-	movq	(%rsp),%rbx
+	movq	(%rsp), %rbx
 	CFI_RESTORE rbx
-	movq	1*8(%rsp),%r12
+	movq	1*8(%rsp), %r12
 	CFI_RESTORE r12
-	addq	$2*8,%rsp
+	addq	$2*8, %rsp
 	CFI_ADJUST_CFA_OFFSET -2*8
 	ret
 .Lcopy_page_end:
@@ -103,7 +101,7 @@ ENDPROC(copy_page)
 
 	.section .altinstr_replacement,"ax"
 1:	.byte 0xeb					/* jmp <disp8> */
-	.byte (copy_page_c - copy_page) - (2f - 1b)	/* offset */
+	.byte (copy_page_rep - copy_page) - (2f - 1b)	/* offset */
 2:
 	.previous
 	.section .altinstructions,"a"
