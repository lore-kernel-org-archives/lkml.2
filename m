Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab0JLKmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 06:42:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60812 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757179Ab0JLKmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 06:42:17 -0400
Message-ID: <4CB43B85.1090203@cn.fujitsu.com>
Date: Tue, 12 Oct 2010 18:42:13 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Ma Ling <ling.ma@intel.com>,
        ykzhao <yakui.zhao@intel.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86_64,lib: improve the performance of memmove() for
 unaligned copy
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves the performance of memmove() on x86_64.

I have tested this patch by my benchmark tool(doing 500 bytes memory copy
for 5,000,000 times)with various alignments and buffer sizes on my
Xeon X5260 box.

Len	Src/Dst	Old memmove	New memmove
	align
---	-------	-----------	-----------
1	0\0	0s 42626us	0s 42619us
1	0\4	0s 25592us	0s 25568us
1	4\0	0s 25569us	0s 25568us
1	4\4	0s 25572us	0s 25567us
7	0\0	0s 24065us	0s 24063us
7	0\4	0s 24064us	0s 24065us
7	4\0	0s 24064us	0s 24064us
7	4\4	0s 24064us	0s 24065us
8	0\0	0s 19553us	0s 19552us
8	0\4	0s 19551us	0s 19554us
8	4\0	0s 19553us	0s 19553us
8	4\4	0s 19552us	0s 19552us
16	0\0	0s 18048us	0s 18048us
16	0\4	0s 18049us	0s 19302us
16	4\0	0s 18048us	0s 18049us
16	4\4	0s 18049us	0s 18199us
32	0\0	0s 36094us	0s 18049us
32	0\4	0s 36094us	0s 18048us
32	4\0	0s 36093us	0s 18048us
32	4\4	0s 36096us	0s 18049us
48	0\0	0s 25567us	0s 28577us
48	0\4	0s 28576us	0s 28577us
48	4\0	0s 25568us	0s 28576us
48	4\4	0s 28575us	0s 28577us
64	0\0	0s 40605us	0s 40606us
64	0\4	0s 54139us	0s 51134us
64	4\0	0s 49628us	0s 49633us
64	4\4	0s 75195us	0s 67673us
80	0\0	0s 30080us	0s 34589us
80	0\4	0s 63164us	0s 66169us
80	4\0	0s 46621us	0s 49602us
80	4\4	0s 64670us	0s 64667us
128	0\0	0s 51134us	0s 54142us
128	0\4	0s 81219us	0s 87227us
128	4\0	0s 90235us	0s 87225us
128	4\4	0s 114292us	0s 88728us
256	0\0	0s 75192us	0s 72938us
256	0\4	0s 163173us	0s 148879us
256	4\0	0s 171439us	0s 151286us
256	4\4	0s 231589us	0s 121813us
512	0\0	0s 123312us	0s 123320us
512	0\4	0s 282730us	0s 269169us
512	4\0	0s 333846us	0s 273690us
512	4\4	0s 427102us	0s 179015us
1024	0\0	0s 305278us	0s 308288us
1024	0\4	0s 524829us	0s 513555us
1024	4\0	0s 658767us	0s 514297us
1024	4\4	0s 945909us	0s 309789us
2048	0\0	0s 521826us	0s 524835us
2048	0\4	1s 6060us	0s 999261us
2048	4\0	1s 521880us	0s 997025us
2048	4\4	2s 374336us	0s 762446us
4096	0\0	0s 954902us	0s 958599us
4096	0\4	2s 380401us	2s 300792us
4096	4\0	2s 854379us	1s 986522us
4096	4\4	4s 634707us	1s 270715us

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 arch/x86/lib/memmove_64.c |  270 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 252 insertions(+), 18 deletions(-)

diff --git a/arch/x86/lib/memmove_64.c b/arch/x86/lib/memmove_64.c
index 6d0f0ec..4f9ce9c 100644
--- a/arch/x86/lib/memmove_64.c
+++ b/arch/x86/lib/memmove_64.c
@@ -15,28 +15,41 @@ void *memmove(void *dest, const void *src, size_t count)
 		/* Handle more 32bytes in loop */
 		"mov %2, %3\n\t"
 		"cmp $0x20, %0\n\t"
-		"jb	1f\n\t"
+		"jbe	1f\n\t"
 
 		/* Decide forward/backward copy mode */
 		"cmp %2, %1\n\t"
 		"jb	2f\n\t"
 
 		/*
+		 * the code for unaligned copy is good for large-size copy
+		 * (>100), so if the size is small, we needn't check dst and
+		 * src is aligned or not.
+		 */
+		"cmp $100, %0\n\t"
+		"jb 14f\n\t"
+
+		/* dst align check */
+		"test $7, %2\n\t"
+		"jnz 15f\n\t"
+
+		/* src align check */
+		"test $7, %1\n\t"
+		"jnz 20f\n\t"
+
+		"14:\n\t"
+		/*
 		 * movsq instruction have many startup latency
 		 * so we handle small size by general register.
 		 */
 		"cmp  $680, %0\n\t"
-		"jb 3f\n\t"
-		/*
-		 * movsq instruction is only good for aligned case.
-		 */
-		"cmpb %%dil, %%sil\n\t"
-		"je 4f\n\t"
-		"3:\n\t"
+		"jae 4f\n\t"
+
 		"sub $0x20, %0\n\t"
 		/*
 		 * We gobble 32byts forward in each loop.
 		 */
+		".p2align 4\n\t"
 		"5:\n\t"
 		"sub $0x20, %0\n\t"
 		"movq 0*8(%1), %4\n\t"
@@ -54,6 +67,106 @@ void *memmove(void *dest, const void *src, size_t count)
 		"addq $0x20, %0\n\t"
 		"jmp 1f\n\t"
 		/*
+		 * handle data forword for unaligned src
+		 */
+		".p2align 4\n\t"
+		"15:\n\t"
+		/* align dst address */
+		"movq %2, %8\n\t"
+		"andq $7, %8\n\t"
+		"negq %8\n\t"
+		"andq $7, %8\n\t"
+		"subq %8, %0\n\t"
+		"movq (%1), %4\n\t"
+		"movq %4, (%2)\n\t"
+		"addq %8, %2\n\t"
+		"addq %8, %1\n\t"
+
+		/* src align check */
+		"test $7, %1\n\t"
+		"jz 14b\n\t"
+
+		"20:\n\t"
+		"push %%r12\n\t"
+		"push %%r13\n\t"
+		"push %%r14\n\t"
+		"push %%r15\n\t"
+
+		/*
+		 * Calculate how to shift a word read at the memory operation
+		 * aligned srcp to make it aligned for copy.
+		 */
+		"movq %1, %%r14\n\t"
+		"andq $7, %%r14\n\t"
+		"shlq $3, %%r14\n\t"
+	
+		"movq $64, %%r15\n\t"
+		"subq %%r14, %%r15\n\t"
+
+		"andq $-8, %1\n\t"		/* src aligned */
+		"movq 0*8(%1), %%r12\n\t"
+
+		"subq $0x20, %0\n\t"
+
+		/*
+		 * %r12: store src[0]
+		 * %r8 : store src[1]
+		 * %r9 : store src[2]
+		 * %r10: store src[3]
+		 * %r11: store src[4]
+		 * %r13: store the tmp data
+		 */ 
+		".p2align 4\n\t"
+		"16:\n\t"
+		"movq 1*8(%1), %4\n\t"
+		"movq 2*8(%1), %5\n\t"
+		"movq 3*8(%1), %6\n\t"
+		"movq 4*8(%1), %7\n\t"
+
+		"movq %4, %%r13\n\t"
+		"movb %%r14b, %%cl\n\t"
+		"shrq %%cl, %%r12\n\t"
+		"shrq %%cl, %%r13\n\t"
+		"movb %%r15b, %%cl\n\t"
+		"shlq %%cl, %4\n\t"
+		"orq %%r12, %4\n\t"
+		"movq %5, %%r12\n\t"
+		"shlq  %%cl, %5\n\t"
+		"orq %%r13, %5\n\t"
+
+		"movq %6, %%r13\n\t"
+		"movb %%r14b, %%cl\n\t"
+		"shrq %%cl, %%r12\n\t"
+		"shrq %%cl, %%r13\n\t"
+		"movb %%r15b, %%cl\n\t"
+		"shlq %%cl, %6\n\t"
+		"orq %%r12, %6\n\t"
+		"movq %7, %%r12\n\t"
+		"shlq %%cl, %7\n\t"
+		"orq %%r13, %7\n\t"
+
+		"movq %4, 0*8(%2)\n\t"
+		"movq %5, 1*8(%2)\n\t"
+		"movq %6, 2*8(%2)\n\t"
+		"movq %7, 3*8(%2)\n\t"
+	
+		"leaq 4*8(%2), %2\n\t"
+		"leaq 4*8(%1), %1\n\t"
+		"subq $0x20, %0\n\t"
+		"jae 16b\n\t"
+
+		"addq $0x20, %0\n\t"
+		"shrq $3, %%r14\n\t"
+		"addq %%r14, %1\n\t"
+		"pop %%r15\n\t"
+		"pop %%r14\n\t"
+		"pop %%r13\n\t"
+		"pop %%r12\n\t"
+		"cmp $0, %0\n\t"
+		"je 13f\n\t"
+		"jmp 1f\n\t"
+
+		/*
 		 * Handle data forward by movsq.
 		 */
 		".p2align 4\n\t"
@@ -71,15 +184,14 @@ void *memmove(void *dest, const void *src, size_t count)
 		".p2align 4\n\t"
 		"7:\n\t"
 		"movq %0, %8\n\t"
-		"movq (%1), %4\n\t"
-		"movq %2, %5\n\t"
-		"leaq -8(%1, %0), %1\n\t"
-		"leaq -8(%2, %0), %2\n\t"
+		"movq (%5), %4\n\t"
+		"leaq -8(%1), %1\n\t"
+		"leaq -8(%2), %2\n\t"
 		"shrq $3, %8\n\t"
 		"std\n\t"
 		"rep movsq\n\t"
 		"cld\n\t"
-		"movq %4, (%5)\n\t"
+		"movq %4, (%3)\n\t"
 		"jmp 13f\n\t"
 
 		/*
@@ -87,20 +199,39 @@ void *memmove(void *dest, const void *src, size_t count)
 		 */
 		".p2align 4\n\t"
 		"2:\n\t"
-		"cmp $680, %0\n\t"
-		"jb 6f \n\t"
-		"cmp %%dil, %%sil\n\t"
-		"je 7b \n\t"
-		"6:\n\t"
+		/* store the src address to %5, we may use it later. */ 
+		"movq %1, %5\n\t"
 		/*
 		 * Calculate copy position to tail.
 		 */
 		"addq %0, %1\n\t"
 		"addq %0, %2\n\t"
+
+		/*
+		 * the code for unaligned copy is good for large-size copy
+		 * (>100), so if the size is small, we needn't check dst and
+		 * src is aligned or not.
+		 */
+		"cmp $100, %0\n\t"
+		"jb 17f\n\t"
+
+		/* dst align check */
+		"test $7, %2\n\t"
+		"jnz 18f\n\t"
+
+		/* src align check */
+		"test $7, %1\n\t"
+		"jnz 21f\n\t"
+
+		"17:\n\t"
+		"cmp $680, %0\n\t"
+		"jae 7b \n\t"
+
 		"subq $0x20, %0\n\t"
 		/*
 		 * We gobble 32byts backward in each loop.
 		 */
+		".p2align 4\n\t"
 		"8:\n\t"
 		"subq $0x20, %0\n\t"
 		"movq -1*8(%1), %4\n\t"
@@ -121,6 +252,109 @@ void *memmove(void *dest, const void *src, size_t count)
 		"addq $0x20, %0\n\t"
 		"subq %0, %1\n\t"
 		"subq %0, %2\n\t"
+		"andq $31, %0\n\t"
+		"jnz 1f\n\t"
+		"jmp 13f\n\t"
+		/*
+		 * handle data backword for unaligned src
+		 */
+		".p2align 4\n\t"
+		"18:\n\t"
+		/* align dst address */
+		"movq %2, %8\n\t"
+		"andq $7, %8\n\t"
+		"subq %8, %0\n\t"
+		"movq -1*8(%1), %4\n\t"
+		"movq %4, -1*8(%2)\n\t"
+		"subq %8, %2\n\t"
+		"subq %8, %1\n\t"
+
+		/* src align check */
+		"test $7, %1\n\t"
+		"jz 17b\n\t"
+
+		"21:\n\t"
+		"push %%r12\n\t"
+		"push %%r13\n\t"
+		"push %%r14\n\t"
+		"push %%r15\n\t"
+
+		/*
+		 * Calculate how to shift a word read at the memory operation
+		 * aligned srcp to make it aligned for copy.
+		 */
+		"movq %1, %%r14\n\t"
+		"andq $7, %%r14\n\t"
+		"shlq $3, %%r14\n\t"
+	
+		"movq $64, %%r15\n\t"
+		"subq %%r14, %%r15\n\t"
+
+		"andq $-8, %1\n\t"		/* src aligned */
+		"movq 0*8(%1), %%r12\n\t"
+
+		"subq $0x20, %0\n\t"
+
+		/*
+		 * %r12: store src[0]
+		 * %r8 : store src[1]
+		 * %r9 : store src[2]
+		 * %r10: store src[3]
+		 * %r11: store src[4]
+		 * %r13: store the tmp data
+		 */ 
+		".p2align 4\n\t"
+		"19:\n\t"
+		"movq -1*8(%1), %4\n\t"
+		"movq -2*8(%1), %5\n\t"
+		"movq -3*8(%1), %6\n\t"
+		"movq -4*8(%1), %7\n\t"
+
+		"movq %4, %%r13\n\t"
+		"movb %%r15b, %%cl\n\t"
+		"shlq %%cl, %%r12\n\t"
+		"shlq %%cl, %%r13\n\t"
+		"movb %%r14b, %%cl\n\t"
+		"shrq %%cl, %4\n\t"
+		"orq %%r12, %4\n\t"
+		"movq %5, %%r12\n\t"
+		"shrq  %%cl, %5\n\t"
+		"orq %%r13, %5\n\t"
+
+		"movq %6, %%r13\n\t"
+		"movb %%r15b, %%cl\n\t"
+		"shlq %%cl, %%r12\n\t"
+		"shlq %%cl, %%r13\n\t"
+		"movb %%r14b, %%cl\n\t"
+		"shrq %%cl, %6\n\t"
+		"orq %%r12, %6\n\t"
+		"movq %7, %%r12\n\t"
+		"shrq %%cl, %7\n\t"
+		"orq %%r13, %7\n\t"
+
+		"movq %4, -1*8(%2)\n\t"
+		"movq %5, -2*8(%2)\n\t"
+		"movq %6, -3*8(%2)\n\t"
+		"movq %7, -4*8(%2)\n\t"
+	
+		"leaq -4*8(%2), %2\n\t"
+		"leaq -4*8(%1), %1\n\t"
+		"subq $0x20, %0\n\t"
+		"jae 19b\n\t"
+
+		"addq $0x20, %0\n\t"
+		"shrq $3, %%r14\n\t"
+		"addq %%r14, %1\n\t"
+		"pop %%r15\n\t"
+		"pop %%r14\n\t"
+		"pop %%r13\n\t"
+		"pop %%r12\n\t"
+		"cmp $0, %0\n\t"
+		"je 13f\n\t"
+		"subq %0, %1\n\t"
+		"subq %0, %2\n\t"
+
+		".p2align 4\n\t"
 		"1:\n\t"
 		"cmpq $16, %0\n\t"
 		"jb 9f\n\t"
-- 
1.7.0.1
