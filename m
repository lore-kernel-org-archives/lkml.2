Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2AZViY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:38:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40284 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab2AZViX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:38:23 -0500
Date: Thu, 26 Jan 2012 13:38:01 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-2ab560911a427fdc73bfd3a7d2944d8ee0ca6db8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, jbeulich@suse.com, JBeulich@suse.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, JBeulich@suse.com, jbeulich@suse.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4F21846F020000780006F3FA@nat28.tlf.novell.com>
References: <4F21846F020000780006F3FA@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Fix memcpy()
  to support sizes of 4Gb and above
Git-Commit-ID: 2ab560911a427fdc73bfd3a7d2944d8ee0ca6db8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 13:38:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ab560911a427fdc73bfd3a7d2944d8ee0ca6db8
Gitweb:     http://git.kernel.org/tip/2ab560911a427fdc73bfd3a7d2944d8ee0ca6db8
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 26 Jan 2012 15:50:55 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 21:19:18 +0100

x86-64: Fix memcpy() to support sizes of 4Gb and above

While currently there doesn't appear to be any reachable in-tree
case where such large memory blocks may be passed to memcpy(),
we already had hit the problem in our Xen kernels. Just like
done recently for mmeset(), rather than working around it,
prevent others from falling into the same trap by fixing this
long standing limitation.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/4F21846F020000780006F3FA@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/memcpy_64.S |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index efbf2a0..1235b04 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -27,9 +27,8 @@
 	.section .altinstr_replacement, "ax", @progbits
 .Lmemcpy_c:
 	movq %rdi, %rax
-
-	movl %edx, %ecx
-	shrl $3, %ecx
+	movq %rdx, %rcx
+	shrq $3, %rcx
 	andl $7, %edx
 	rep movsq
 	movl %edx, %ecx
@@ -48,8 +47,7 @@
 	.section .altinstr_replacement, "ax", @progbits
 .Lmemcpy_c_e:
 	movq %rdi, %rax
-
-	movl %edx, %ecx
+	movq %rdx, %rcx
 	rep movsb
 	ret
 .Lmemcpy_e_e:
@@ -60,10 +58,7 @@ ENTRY(memcpy)
 	CFI_STARTPROC
 	movq %rdi, %rax
 
-	/*
-	 * Use 32bit CMP here to avoid long NOP padding.
-	 */
-	cmp  $0x20, %edx
+	cmpq $0x20, %rdx
 	jb .Lhandle_tail
 
 	/*
@@ -72,7 +67,7 @@ ENTRY(memcpy)
 	 */
 	cmp  %dil, %sil
 	jl .Lcopy_backward
-	subl $0x20, %edx
+	subq $0x20, %rdx
 .Lcopy_forward_loop:
 	subq $0x20,	%rdx
 
@@ -91,7 +86,7 @@ ENTRY(memcpy)
 	movq %r11,	3*8(%rdi)
 	leaq 4*8(%rdi),	%rdi
 	jae  .Lcopy_forward_loop
-	addq $0x20,	%rdx
+	addl $0x20,	%edx
 	jmp  .Lhandle_tail
 
 .Lcopy_backward:
@@ -123,11 +118,11 @@ ENTRY(memcpy)
 	/*
 	 * Calculate copy position to head.
 	 */
-	addq $0x20,	%rdx
+	addl $0x20,	%edx
 	subq %rdx,	%rsi
 	subq %rdx,	%rdi
 .Lhandle_tail:
-	cmpq $16,	%rdx
+	cmpl $16,	%edx
 	jb   .Lless_16bytes
 
 	/*
@@ -144,7 +139,7 @@ ENTRY(memcpy)
 	retq
 	.p2align 4
 .Lless_16bytes:
-	cmpq $8,	%rdx
+	cmpl $8,	%edx
 	jb   .Lless_8bytes
 	/*
 	 * Move data from 8 bytes to 15 bytes.
@@ -156,7 +151,7 @@ ENTRY(memcpy)
 	retq
 	.p2align 4
 .Lless_8bytes:
-	cmpq $4,	%rdx
+	cmpl $4,	%edx
 	jb   .Lless_3bytes
 
 	/*
