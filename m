Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab0JHH2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:28:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50699 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab0JHH2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:28:32 -0400
Message-ID: <4CAEC81C.1070108@cn.fujitsu.com>
Date: Fri, 08 Oct 2010 15:28:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Ma Ling <ling.ma@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, ykzhao <yakui.zhao@intel.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 -tip] lib,x86_64: improve the performance of memcpy() for
 unaligned copy
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memcpy of x86_64 hasn't been optimized for the unaligned copy like other
architecture, this patch fixed this problem.

I have tested this patch by my benchmark tool(doing 500 bytes memory copy
for 5,000,000 times)with various alignments and buffer sizes on my Core2
box.

Len	Src/Dst	Old memcpy	New memcpy
	align
---	-------	-------------	-------------
1	0/0	0s 47015us	0s 28265us
1	0/4	0s 28201us	0s 28199us
1	4/0	0s 28200us	0s 28199us
1	4/4	0s 28199us	0s 28206us
7	0/0	0s 24441us	0s 24438us
7	0/4	0s 24439us	0s 24438us
7	4/0	0s 24439us	0s 24438us
7	4/4	0s 24439us	0s 24439us
8	0/0	0s 20699us	0s 20687us
8	0/4	0s 20689us	0s 20901us
8	4/0	0s 20692us	0s 20679us
8	4/4	0s 20679us	0s 20679us
16	0/0	0s 18807us	0s 18802us
16	0/4	0s 26319us	0s 18800us
16	4/0	0s 18800us	0s 18806us
16	4/4	0s 26317us	0s 18803us
32	0/0	0s 35728us	0s 18800us
32	0/4	0s 35716us	0s 18800us
32	4/0	0s 35717us	0s 18800us
32	4/4	0s 35724us	0s 18803us
48	0/0	0s 26897us	0s 30080us
48	0/4	0s 33837us	0s 33838us
48	4/0	0s 27600us	0s 30079us
48	4/4	0s 30087us	0s 33854us
64	0/0	0s 41369us	0s 45115us
64	0/4	0s 62042us	0s 65800us
64	4/0	0s 56400us	0s 58278us
64	4/4	0s 84596us	0s 84606us
80	0/0	0s 35877us	0s 37611us
80	0/4	0s 77083us	0s 56404us
80	4/0	0s 52652us	0s 55611us
80	4/4	0s 75200us	0s 78968us
128	0/0	0s 52642us	0s 56403us
128	0/4	0s 95883us	0s 95891us
128	4/0	0s 114683us	0s 108511us
128	4/4	0s 144780us	0s 110927us
256	0/0	0s 80832us	0s 86489us
256	0/4	0s 178586us	0s 163562us
256	4/0	0s 208670us	0s 181719us
256	4/4	0s 270705us	0s 148525us
512	0/0	0s 156049us	0s 148348us
512	0/4	0s 313933us	0s 298908us
512	4/0	0s 411671us	0s 329025us
512	4/4	0s 516971us	0s 208746us
1024	0/0	0s 297067us	0s 274019us
1024	0/4	0s 584703us	0s 569604us
1024	4/0	0s 818104us	0s 616419us
1024	4/4	1s 22839us	0s 328953us
2048	0/0	0s 577077us	0s 524148us
2048	0/4	1s 125953us	1s 111258us
2048	4/0	1s 894000us	1s 202724us
2048	4/4	2s 331807us	0s 822437us
4096	0/0	1s 25881us	1s 34128us
4096	0/4	2s 619273us	2s 606489us
4096	4/0	3s 553989us	2s 390272us
4096	4/4	4s 737789us	1s 433213us

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 arch/x86/lib/memcpy_64.S |  135 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 134 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 75ef61e..b0224f8 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -46,9 +46,39 @@ ENTRY(memcpy)
 	 * Use 32bit CMP here to avoid long NOP padding.
 	 */
 	cmp  $0x20, %edx
-	jb .Lhandle_tail
+	jbe .Lhandle_tail
 
 	/*
+	 * the code for unaligned copy is good for large-size copy(>100),
+	 * so if the size is small, we needn't check dst and src is aligned
+	 * or not.
+	 */
+	cmp $100, %edx
+	jb .Lboth_aligned
+
+	/*
+	 * unaligned access always leads to bad performance, so in order to
+	 * avoid unaligned access, we align the address(both src and dest)
+	 * first, and then copy from a aligned src to an aligned dst by using
+	 * shifts.
+	 * But we found if src is aligned, although dest is unaligned, the
+	 * performance of generic memory copy (That is reading data aligned
+	 * from the source and writing data unaligned to the dest) is better
+	 * than the one that uses shifts to avoid unaligned access.
+	 * So if src is aligned, we needn't check dest is aligned or not, just
+	 * goto .Lboth_aligned
+	 */
+	test $7, %esi		/* src align check */
+	jz .Lboth_aligned
+
+	/* if dest and src both are unaligned, goto unaligned copy */
+	test $7, %edi
+	jnz .Ldst_unaligned
+
+	jmp .Lsrc_unaligned_dst_aligned
+
+.Lboth_aligned:
+	/*
 	 * We check whether memory false dependece could occur,
 	 * then jump to corresponding copy mode.
 	 */
@@ -166,6 +196,109 @@ ENTRY(memcpy)
 
 .Lend:
 	retq
+
+	.p2align 4
+.Ldst_unaligned:
+	movq %rdi, %rcx
+	andq $7, %rcx		/* Align the destination */
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
+	test $7, %esi		/* src align check */
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
