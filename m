Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0GHG1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 02:27:38 -0400
Received: from mail.openrapids.net ([64.15.138.104]:41493 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752838Ab0GHG1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 02:27:36 -0400
Date: Thu, 8 Jul 2010 02:27:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "mingo@elte.hu" <mingo@elte.hu>
Cc: "Ma, Ling" <ling.ma@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH -tip] Revert x86, mem: Optimize memcpy by avoiding memory
	false dependece
Message-ID: <20100708062733.GA24740@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 02:07:05 up 166 days,  8:44,  4 users,  load average: 0.35, 0.16,
	0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ma, Ling (ling.ma@intel.com) wrote:
> Hi Mathieu
> 
> I did git revert as bellow
>     Revert "x86, mem: Optimize memcpy by avoiding memory false dependece"
> 
>     This reverts commit 77ff5e49c20bb72a99a12bfb00dbf90b2302f087.
> And I found the machine will crash with your config file
> 
> Could you revert the patch : 77ff5e49c20bb72a99a12bfb00dbf90b2302f087 on your
> machine, and check it again ?

Hi Ling,

I just successfully booted my machine 3 times in a row with a revert of commit
a1e5278e40f16a4611264f8da9e557c16cb6f6ed from -tip. This is actually the same as
reverting commit 77ff5e49c20bb72a99a12bfb00dbf90b2302f087, as
a1e5278e40f16a4611264f8da9e557c16cb6f6ed is simply a merge of that commit (the
diffs are exactly the same).

Without this revert, the machine gets to:

Loading Linux 2.6.35-rc4-tip-trace+ ...

and reboots all by itself. I've let it reboot 3 times in a row just to make
sure.

So I am therefore certain that the faulty commit is
"x86, mem: Optimize memcpy by avoiding memory false dependece"
identified by commit id 77ff5e49c20bb72a99a12bfb00dbf90b2302f087, merged by
commit a1e5278e40f16a4611264f8da9e557c16cb6f6ed into -tip.

For the sake of the commit log, the affected machine is an Intel Xeon E5405.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Ma, Ling" <ling.ma@intel.com>
CC: "mingo@elte.hu" <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/lib/memcpy_64.S |  156 ++++++++++++++++-------------------------------
 1 file changed, 54 insertions(+), 102 deletions(-)

Index: linux.trees.git/arch/x86/lib/memcpy_64.S
===================================================================
--- linux.trees.git.orig/arch/x86/lib/memcpy_64.S	2010-07-08 02:11:58.000000000 -0400
+++ linux.trees.git/arch/x86/lib/memcpy_64.S	2010-07-08 02:20:48.000000000 -0400
@@ -40,132 +40,84 @@
 ENTRY(__memcpy)
 ENTRY(memcpy)
 	CFI_STARTPROC
-	movq %rdi, %rax
 
 	/*
-	 * Use 32bit CMP here to avoid long NOP padding.
+	 * Put the number of full 64-byte blocks into %ecx.
+	 * Tail portion is handled at the end:
 	 */
-	cmp  $0x20, %edx
-	jb .Lhandle_tail
+	movq %rdi, %rax
+	movl %edx, %ecx
+	shrl   $6, %ecx
+	jz .Lhandle_tail
 
+	.p2align 4
+.Lloop_64:
 	/*
-	 * We check whether memory false dependece could occur,
-	 * then jump to corresponding copy mode.
+	 * We decrement the loop index here - and the zero-flag is
+	 * checked at the end of the loop (instructions inbetween do
+	 * not change the zero flag):
 	 */
-	cmp  %dil, %sil
-	jl .Lcopy_backward
-	subl $0x20, %edx
-.Lcopy_forward_loop:
-	subq $0x20,	%rdx
+	decl %ecx
 
 	/*
-	 * Move in blocks of 4x8 bytes:
+	 * Move in blocks of 4x16 bytes:
 	 */
-	movq 0*8(%rsi),	%r8
-	movq 1*8(%rsi),	%r9
-	movq 2*8(%rsi),	%r10
-	movq 3*8(%rsi),	%r11
-	leaq 4*8(%rsi),	%rsi
-
-	movq %r8,	0*8(%rdi)
-	movq %r9,	1*8(%rdi)
-	movq %r10,	2*8(%rdi)
-	movq %r11,	3*8(%rdi)
-	leaq 4*8(%rdi),	%rdi
-	jae  .Lcopy_forward_loop
-	addq $0x20,	%rdx
-	jmp  .Lhandle_tail
+	movq 0*8(%rsi),		%r11
+	movq 1*8(%rsi),		%r8
+	movq %r11,		0*8(%rdi)
+	movq %r8,		1*8(%rdi)
 
-.Lcopy_backward:
-	/*
-	 * Calculate copy position to tail.
-	 */
-	addq %rdx,	%rsi
-	addq %rdx,	%rdi
-	subq $0x20,	%rdx
-	/*
-	 * At most 3 ALU operations in one cycle,
-	 * so append NOPS in the same 16bytes trunk.
-	 */
-	.p2align 4
-.Lcopy_backward_loop:
-	subq $0x20,	%rdx
-	movq -1*8(%rsi),	%r8
-	movq -2*8(%rsi),	%r9
-	movq -3*8(%rsi),	%r10
-	movq -4*8(%rsi),	%r11
-	leaq -4*8(%rsi),	%rsi
-	movq %r8,		-1*8(%rdi)
-	movq %r9,		-2*8(%rdi)
-	movq %r10,		-3*8(%rdi)
-	movq %r11,		-4*8(%rdi)
-	leaq -4*8(%rdi),	%rdi
-	jae  .Lcopy_backward_loop
+	movq 2*8(%rsi),		%r9
+	movq 3*8(%rsi),		%r10
+	movq %r9,		2*8(%rdi)
+	movq %r10,		3*8(%rdi)
+
+	movq 4*8(%rsi),		%r11
+	movq 5*8(%rsi),		%r8
+	movq %r11,		4*8(%rdi)
+	movq %r8,		5*8(%rdi)
+
+	movq 6*8(%rsi),		%r9
+	movq 7*8(%rsi),		%r10
+	movq %r9,		6*8(%rdi)
+	movq %r10,		7*8(%rdi)
+
+	leaq 64(%rsi), %rsi
+	leaq 64(%rdi), %rdi
+
+	jnz  .Lloop_64
 
-	/*
-	 * Calculate copy position to head.
-	 */
-	addq $0x20,	%rdx
-	subq %rdx,	%rsi
-	subq %rdx,	%rdi
 .Lhandle_tail:
-	cmpq $16,	%rdx
-	jb   .Lless_16bytes
+	movl %edx, %ecx
+	andl  $63, %ecx
+	shrl   $3, %ecx
+	jz   .Lhandle_7
 
-	/*
-	 * Move data from 16 bytes to 31 bytes.
-	 */
-	movq 0*8(%rsi), %r8
-	movq 1*8(%rsi),	%r9
-	movq -2*8(%rsi, %rdx),	%r10
-	movq -1*8(%rsi, %rdx),	%r11
-	movq %r8,	0*8(%rdi)
-	movq %r9,	1*8(%rdi)
-	movq %r10,	-2*8(%rdi, %rdx)
-	movq %r11,	-1*8(%rdi, %rdx)
-	retq
 	.p2align 4
-.Lless_16bytes:
-	cmpq $8,	%rdx
-	jb   .Lless_8bytes
-	/*
-	 * Move data from 8 bytes to 15 bytes.
-	 */
-	movq 0*8(%rsi),	%r8
-	movq -1*8(%rsi, %rdx),	%r9
-	movq %r8,	0*8(%rdi)
-	movq %r9,	-1*8(%rdi, %rdx)
-	retq
-	.p2align 4
-.Lless_8bytes:
-	cmpq $4,	%rdx
-	jb   .Lless_3bytes
+.Lloop_8:
+	decl %ecx
+	movq (%rsi),		%r8
+	movq %r8,		(%rdi)
+	leaq 8(%rdi),		%rdi
+	leaq 8(%rsi),		%rsi
+	jnz  .Lloop_8
+
+.Lhandle_7:
+	movl %edx, %ecx
+	andl $7, %ecx
+	jz .Lend
 
-	/*
-	 * Move data from 4 bytes to 7 bytes.
-	 */
-	movl (%rsi), %ecx
-	movl -4(%rsi, %rdx), %r8d
-	movl %ecx, (%rdi)
-	movl %r8d, -4(%rdi, %rdx)
-	retq
 	.p2align 4
-.Lless_3bytes:
-	cmpl $0, %edx
-	je .Lend
-	/*
-	 * Move data from 1 bytes to 3 bytes.
-	 */
 .Lloop_1:
 	movb (%rsi), %r8b
 	movb %r8b, (%rdi)
 	incq %rdi
 	incq %rsi
-	decl %edx
+	decl %ecx
 	jnz .Lloop_1
 
 .Lend:
-	retq
+	ret
 	CFI_ENDPROC
 ENDPROC(memcpy)
 ENDPROC(__memcpy)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
