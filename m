Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab0IWMCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 08:02:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53253 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab0IWMCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:02:14 -0400
Message-ID: <4C9B41A7.3010608@cn.fujitsu.com>
Date: Thu, 23 Sep 2010 20:01:43 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Ma Ling <ling.ma@intel.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] lib,x86_64: improve the performance of memcpy() for
 unaligned copy
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memcpy of x86_64 hasn't been optimized for the unaligned copy like other
architecture, this patch fixed this problem.

I have tested this patch by doing 500 bytes memory copy for 5,000,000 times
with various alignments and buffer sizes on my x86_64 box

Len	Src/Dest	Old memcpy	New memcpy
	alignment
---	---------	-------------	-------------
32	0/0		0s 59553us	0s 39597us
32	0/4		0s 37675us	0s 39583us
32	4/0		0s 35720us	0s 39568us
32	4/4		0s 35721us	0s 39564us
256	0/0		0s 88783us	0s 86759us
256	0/4		0s 182896us	0s 166298us
256	4/0		0s 209244us	0s 191853us
256	4/4		0s 262847us	0s 165768us
512	0/0		0s 156486us	0s 148370us
512	0/4		0s 318856us	0s 302365us
512	4/0		0s 412763us	0s 338468us
512	4/4		0s 518688us	0s 218969us
1024	0/0		0s 298076us	0s 268443us
1024	0/4		0s 592114us	0s 575168us
1024	4/0		0s 819969us	0s 654752us
1024	4/4		1s 16405us	0s 343318us

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 arch/x86/lib/memcpy_64.S |  134 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 134 insertions(+), 0 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 75ef61e..32dade1 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -49,6 +49,35 @@ ENTRY(memcpy)
 	jb .Lhandle_tail
 
 	/*
+	 * the code for unaligned copy is good for large-size copy(>80),
+	 * so if the size is small, we needn't check dst and src is aligned
+	 * or not.
+	 */
+	cmp $80, %edx
+	jbe .Lboth_aligned
+
+	/*
+	 * we found if src is aligned and dest is unaligned, using
+	 * both-aligned copy is better than unaligned copy. So if src is
+	 * aligned, we needn't check dest is aligned or not, just goto
+	 * both-aligned copy.
+	 */
+	movq %rsi, %rcx
+	andq $7, %rcx		/* src align check */
+	jz .Lboth_aligned
+
+	/* if dest and src both are unaligned, goto unaligned copy */
+	movq %rdi, %rcx
+	andq $7, %rcx		/* dst align check */
+	jnz .Ldst_unaligned
+
+	/* if src is unaligned and dest is aligned, goto unaligned copy */
+	movq %rsi, %rcx
+	andq $7, %rcx		/* src align check */
+	jnz .Lsrc_unaligned_dst_aligned
+
+.Lboth_aligned:
+	/*
 	 * We check whether memory false dependece could occur,
 	 * then jump to corresponding copy mode.
 	 */
@@ -166,6 +195,111 @@ ENTRY(memcpy)
 
 .Lend:
 	retq
+
+	.p2align 4
+.Ldst_unaligned:
+	negq %rcx
+	andq $7, %rcx
+	subq %rcx, %rdx
+
+	/* tune dst address */
+	movq (%rsi), %r8
+	movq %r8, (%rdi)
+	addq %rcx, %rdi
+	addq %rcx, %rsi
+
+	cmp $0x20, %rdx
+	jb .Lhandle_tail
+
+	movq %rsi, %rcx
+	andq $7, %rcx		/* src align check */
+	jz .Lboth_aligned
+
+	.p2align 4
+.Lsrc_unaligned_dst_aligned:
+	push %rbx
+	push %r12
+	push %r13
+	push %r14
+	push %r15
+	/*
+	 * Calculate how to shift a word read at the memory operation
+	 * aligned srcp to make it aligned for copy.
+	 */
+	movq %rsi, %r14
+	andq $7, %r14
+	shlq $3, %r14
+	
+	movq $64, %r15
+	subq %r14, %r15
+
+	andq $-8, %rsi		/* src aligned */
+	movq 0*8(%rsi), %r8
+
+	movq %rdx, %rbx
+	shrq $5, %rbx
+	jz .Lsrc_unaligned_less32
+
+	/*
+	 * %r8 : store src[0]
+	 * %r9 : store src[1]
+	 * %r10: store src[2]
+	 * %r11: store src[3]
+	 * %r12: store src[4]
+	 * %r13: store the tmp data
+	 */ 
+	.p2align 4
+.Lsrc_unaligned_loop32:
+	movq 1*8(%rsi), %r9
+	movq 2*8(%rsi), %r10
+	movq 3*8(%rsi), %r11
+	movq 4*8(%rsi), %r12
+
+	movq %r9, %r13
+	movb %r14b, %cl
+	shrq %cl, %r8
+	shrq %cl, %r13
+	movb %r15b, %cl
+	shlq  %cl, %r9
+	orq %r8, %r9
+	movq %r10, %r8
+	shlq  %cl, %r10
+	orq %r13, %r10
+
+	movq %r11, %r13
+	movb %r14b, %cl
+	shrq %cl, %r8
+	shrq %cl, %r13
+	movb %r15b, %cl
+	shlq  %cl, %r11
+	orq %r8, %r11	
+	movq %r12, %r8
+	shlq  %cl, %r12
+	orq %r13, %r12
+
+	movq %r9, 0*8(%rdi)
+	movq %r10, 1*8(%rdi)
+	movq %r11, 2*8(%rdi)
+	movq %r12, 3*8(%rdi)
+	
+	leaq 4*8(%rdi), %rdi
+	leaq 4*8(%rsi), %rsi
+	decq %rbx
+	jnz .Lsrc_unaligned_loop32
+
+	.p2align 4
+.Lsrc_unaligned_less32:
+	shrq $3, %r14
+	addq %r14, %rsi
+	pop %r15
+	pop %r14
+	pop %r13
+	pop %r12
+	pop %rbx
+	andq $31, %rdx
+	jnz .Lhandle_tail
+	retq
+	
 	CFI_ENDPROC
 ENDPROC(memcpy)
 ENDPROC(__memcpy)
-- 
1.7.0.1
