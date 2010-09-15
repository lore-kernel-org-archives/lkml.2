Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab0IOJ1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:27:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:33305 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab0IOJ1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:27:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,370,1280732400"; 
   d="scan'208";a="607074791"
From: ling.ma@intel.com
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Ma Ling <ling.ma@intel.com>
Subject: 
Date: Wed, 15 Sep 2010 10:29:23 +0800
Message-Id: <1284517763-3228-1-git-send-email-ling.ma@intel.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ma Ling <ling.ma@intel.com>

memmove allow source and destination address to be overlap,
but no limitation for memcpy. So memmove use forward or
backward copy mode to handle src > dest and dest > src cases
respectively. However memcpy has not address overlap,
it may use any copy mode theoretically. Our original memmove
will call memcpy and assume it must use forward copy mode,
otherwise the system will crash, it is potential issue.
The patch based on tip/x86/mem avoids this assumption.

Signed-off-by: Ma Ling <ling.ma@intel.com>
---
In this version we optimized original 32 and 64bit memmove.
(Please use this to replace last one, thanks)

 arch/x86/lib/memcpy_32.c  |  199 +++++++++++++++++++++++++++++++++++++++++----
 arch/x86/lib/memmove_64.c |  191 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 364 insertions(+), 26 deletions(-)

diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
index 5415a9d..65f3b9a 100644
--- a/arch/x86/lib/memcpy_32.c
+++ b/arch/x86/lib/memcpy_32.c
@@ -22,22 +22,187 @@ EXPORT_SYMBOL(memset);
 
 void *memmove(void *dest, const void *src, size_t n)
 {
-	int d0, d1, d2;
-
-	if (dest < src) {
-		memcpy(dest, src, n);
-	} else {
-		__asm__ __volatile__(
-			"std\n\t"
-			"rep\n\t"
-			"movsb\n\t"
-			"cld"
-			: "=&c" (d0), "=&S" (d1), "=&D" (d2)
-			:"0" (n),
-			 "1" (n-1+src),
-			 "2" (n-1+dest)
-			:"memory");
-	}
-	return dest;
+
+	int d0,d1,d2,d3,d4,d5;
+	char *ret = dest;
+
+	__asm__ __volatile__(
+		/* Handle more 16bytes in loop */
+		"cmp $0x10, %0\n\t"
+		"jb	1f\n\t"
+
+		/* Decide forward/backward copy mode */
+		"cmp %2, %1\n\t"
+		"jb	2f\n\t"
+
+		/*
+		 * movs instruction have many startup latency
+		 * so we handle small size by general register.
+		 */
+		"cmp  $680, %0\n\t"
+		"jb 3f\n\t"
+		/*
+		 * movs instruction is only good for aligned case.
+		 */
+		"mov %1, %3\n\t"
+		"xor %2, %3\n\t"
+		"and $0xff, %3\n\t"
+		"jz 4f\n\t"
+		"3:\n\t"
+		"sub $0x10, %0\n\t"
+
+		/*
+		 * We gobble 16byts forward in each loop.
+		 */
+		"3:\n\t"
+		"sub $0x10, %0\n\t"
+		"mov 0*4(%1), %3\n\t"
+		"mov 1*4(%1), %4\n\t"
+		"mov  %3, 0*4(%2)\n\t"
+		"mov  %4, 1*4(%2)\n\t"
+		"mov 2*4(%1), %3\n\t"
+		"mov 3*4(%1), %4\n\t"
+		"mov  %3, 2*4(%2)\n\t"
+		"mov  %4, 3*4(%2)\n\t"
+		"lea  0x10(%1), %1\n\t"
+		"lea  0x10(%2), %2\n\t"
+		"jae 3b\n\t"
+		"add $0x10, %0\n\t"
+		"jmp 1f\n\t"
+
+		/*
+		 * Handle data forward by movs.
+		 */
+		".p2align 4\n\t"
+		"4:\n\t"
+		"mov -4(%1, %0), %3\n\t"
+		"lea -4(%2, %0), %4\n\t"
+		"shr $2, %0\n\t"
+		"rep movsl\n\t"
+		"mov %3, (%4)\n\t"
+		"jmp 11f\n\t"
+		/*
+		 * Handle data backward by movs.
+		 */
+		".p2align 4\n\t"
+		"6:\n\t"
+		"mov (%1), %3\n\t"
+		"mov %2, %4\n\t"
+		"lea -4(%1, %0), %1\n\t"
+		"lea -4(%2, %0), %2\n\t"
+		"shr $2, %0\n\t"
+		"std\n\t"
+		"rep movsl\n\t"
+		"mov %3,(%4)\n\t"
+		"cld\n\t"
+		"jmp 11f\n\t"
+
+		/*
+		 * Start to prepare for backward copy.
+		 */
+		".p2align 4\n\t"
+		"2:\n\t"
+		"cmp  $680, %0\n\t"
+		"jb 5f\n\t"
+		"mov %1, %3\n\t"
+		"xor %2, %3\n\t"
+		"and $0xff, %3\n\t"
+		"jz 6b\n\t"
+
+		/*
+		 * Calculate copy position to tail.
+		 */
+		"5:\n\t"
+		"add %0, %1\n\t"
+		"add %0, %2\n\t"
+		"sub $0x10, %0\n\t"
+
+		/*
+		 * We gobble 16byts backward in each loop.
+		 */
+		"7:\n\t"
+		"sub $0x10, %0\n\t"
+
+		"mov -1*4(%1), %3\n\t"
+		"mov -2*4(%1), %4\n\t"
+		"mov  %3, -1*4(%2)\n\t"
+		"mov  %4, -2*4(%2)\n\t"
+		"mov -3*4(%1), %3\n\t"
+		"mov -4*4(%1), %4\n\t"
+		"mov  %3, -3*4(%2)\n\t"
+		"mov  %4, -4*4(%2)\n\t"
+		"lea  -0x10(%1), %1\n\t"
+		"lea  -0x10(%2), %2\n\t"
+		"jae 7b\n\t"
+		/*
+		 * Calculate copy position to head.
+		 */
+		"add $0x10, %0\n\t"
+		"sub %0, %1\n\t"
+		"sub %0, %2\n\t"
+
+		/*
+		 * Move data from 8 bytes to 15 bytes.
+		 */
+		".p2align 4\n\t"
+		"1:\n\t"
+		"cmp $8, %0\n\t"
+		"jb 8f\n\t"
+		"mov 0*4(%1), %3\n\t"
+		"mov 1*4(%1), %4\n\t"
+		"mov -2*4(%1, %0), %5\n\t"
+		"mov -1*4(%1, %0), %1\n\t"
+
+		"mov  %3, 0*4(%2)\n\t"
+		"mov  %4, 1*4(%2)\n\t"
+		"mov  %5, -2*4(%2, %0)\n\t"
+		"mov  %1, -1*4(%2, %0)\n\t"
+		"jmp 11f\n\t"
+
+		/*
+		 * Move data from 4 bytes to 7 bytes.
+		 */
+		".p2align 4\n\t"
+		"8:\n\t"
+		"cmp $4, %0\n\t"
+		"jb 9f\n\t"
+		"mov 0*4(%1), %3\n\t"
+		"mov -1*4(%1, %0), %4\n\t"
+		"mov  %3, 0*4(%2)\n\t"
+		"mov  %4, -1*4(%2, %0)\n\t"
+		"jmp 11f\n\t"
+
+		/*
+		 * Move data from 2 bytes to 3 bytes.
+		 */
+		".p2align 4\n\t"
+		"9:\n\t"
+		"cmp $2, %0\n\t"
+		"jb 10f\n\t"
+		"movw 0*2(%1), %%dx\n\t"
+		"movw -1*2(%1, %0), %%bx\n\t"
+		"movw %%dx, 0*2(%2)\n\t"
+		"movw %%bx, -1*2(%2, %0)\n\t"
+		"jmp 11f\n\t"
+
+		/*
+		 * Move data for 1 byte.
+		 */
+		".p2align 4\n\t"
+		"10:\n\t"
+		"cmp $1, %0\n\t"
+		"jb 11f\n\t"
+		"movb (%1), %%cl\n\t"
+		"movb %%cl, (%2)\n\t"
+		".p2align 4\n\t"
+		"11:"
+		: "=&c" (d0), "=&S" (d1), "=&D" (d2),
+		  "=r" (d3),"=r" (d4), "=r"(d5)
+		:"0" (n),
+		 "1" (src),
+		 "2" (dest)
+		:"memory");
+
+
 }
 EXPORT_SYMBOL(memmove);
diff --git a/arch/x86/lib/memmove_64.c b/arch/x86/lib/memmove_64.c
index 0a33909..8ba623c 100644
--- a/arch/x86/lib/memmove_64.c
+++ b/arch/x86/lib/memmove_64.c
@@ -8,14 +8,187 @@
 #undef memmove
 void *memmove(void *dest, const void *src, size_t count)
 {
-	if (dest < src) {
-		return memcpy(dest, src, count);
-	} else {
-		char *p = dest + count;
-		const char *s = src + count;
-		while (count--)
-			*--p = *--s;
-	}
-	return dest;
+
+	unsigned long d0,d1,d2,d3,d4,d5,d6,d7;
+	char *ret;
+
+	__asm__ __volatile__(
+		/* Handle more 32bytes in loop */
+		"mov %2, %3\n\t"
+		"cmp $0x20, %0\n\t"
+		"jb	1f\n\t"
+
+		/* Decide forward/backward copy mode */
+		"cmp %2, %1\n\t"
+		"jb	2f\n\t"
+
+		/*
+		 * movsq instruction have many startup latency
+		 * so we handle small size by general register.
+		 */
+		"cmp  $680, %0\n\t"
+		"jb 3f\n\t"
+		/*
+		 * movsq instruction is only good for aligned case.
+		 */
+		"cmpb %%dil, %%sil\n\t"
+		"je 4f\n\t"
+		"3:\n\t"
+		"sub $0x20, %0\n\t"
+		/*
+		 * We gobble 32byts forward in each loop.
+		 */
+		"5:\n\t"
+		"sub $0x20, %0\n\t"
+		"movq 0*8(%1), %4\n\t"
+		"movq 1*8(%1), %5\n\t"
+		"movq 2*8(%1), %6\n\t"
+		"movq 3*8(%1), %7\n\t"
+		"leaq 4*8(%1), %1\n\t"
+
+		"movq %4, 0*8(%2)\n\t"
+		"movq %5, 1*8(%2)\n\t"
+		"movq %6, 2*8(%2)\n\t"
+		"movq %7, 3*8(%2)\n\t"
+		"leaq 4*8(%2), %2\n\t"
+		"jae 5b\n\t"
+		"addq $0x20, %0\n\t"
+		"jmp 1f\n\t"
+		/*
+		 * Handle data forward by movsq.
+		 */
+		".p2align 4\n\t"
+		"4:\n\t"
+		"movq %0, %8\n\t"
+		"movq -8(%1, %0), %4\n\t"
+		"lea -8(%2, %0), %5\n\t"
+		"shrq $3, %8\n\t"
+		"rep movsq\n\t"
+		"movq %4, (%5)\n\t"
+		"jmp 13f\n\t"
+		/*
+		 * Handle data backward by movsq.
+		 */
+		".p2align 4\n\t"
+		"7:\n\t"
+		"movq %0, %8\n\t"
+		"movq (%1), %4\n\t"
+		"movq %2, %5\n\t"
+		"leaq -8(%1, %0), %1\n\t"
+		"leaq -8(%2, %0), %2\n\t"
+		"shrq $3, %8\n\t"
+		"std\n\t"
+		"rep movsq\n\t"
+		"cld\n\t"
+		"movq %4, (%5)\n\t"
+		"jmp 13f\n\t"
+
+		/*
+		 * Start to prepare for backward copy.
+		 */
+		".p2align 4\n\t"
+		"2:\n\t"
+		"cmp $680, %0\n\t"
+		"jb 6f \n\t"
+		"cmp %%dil, %%sil\n\t"
+		"je 7b \n\t"
+		"6:\n\t"
+		/*
+		 * Calculate copy position to tail.
+		 */
+		"addq %0, %1\n\t"
+		"addq %0, %2\n\t"
+		"subq $0x20, %0\n\t"
+		/*
+		 * We gobble 32byts backward in each loop.
+		 */
+		"8:\n\t"
+		"subq $0x20, %0\n\t"
+		"movq -1*8(%1), %4\n\t"
+		"movq -2*8(%1), %5\n\t"
+		"movq -3*8(%1), %6\n\t"
+		"movq -4*8(%1), %7\n\t"
+		"leaq -4*8(%1), %1\n\t"
+
+		"movq %4, -1*8(%2)\n\t"
+		"movq %5, -2*8(%2)\n\t"
+		"movq %6, -3*8(%2)\n\t"
+		"movq %7, -4*8(%2)\n\t"
+		"leaq -4*8(%2), %2\n\t"
+		"jae 8b\n\t"
+		/*
+		 * Calculate copy position to head.
+		 */
+		"addq $0x20, %0\n\t"
+		"subq %0, %1\n\t"
+		"subq %0, %2\n\t"
+		"1:\n\t"
+		"cmpq $16, %0\n\t"
+		"jb 9f\n\t"
+		/*
+		 * Move data from 16 bytes to 31 bytes.
+		 */
+		"movq 0*8(%1), %4\n\t"
+		"movq 1*8(%1), %5\n\t"
+		"movq -2*8(%1, %0), %6\n\t"
+		"movq -1*8(%1, %0), %7\n\t"
+		"movq %4, 0*8(%2)\n\t"
+		"movq %5, 1*8(%2)\n\t"
+		"movq %6, -2*8(%2, %0)\n\t"
+		"movq %7, -1*8(%2, %0)\n\t"
+		"jmp 13f\n\t"
+		".p2align 4\n\t"
+		"9:\n\t"
+		"cmpq $8, %0\n\t"
+		"jb 10f\n\t"
+		/*
+		 * Move data from 8 bytes to 15 bytes.
+		 */
+		"movq 0*8(%1), %4\n\t"
+		"movq -1*8(%1, %0), %5\n\t"
+		"movq %4, 0*8(%2)\n\t"
+		"movq %5, -1*8(%2, %0)\n\t"
+		"jmp 13f\n\t"
+		"10:\n\t"
+		"cmpq $4, %0\n\t"
+		"jb 11f\n\t"
+		/*
+		 * Move data from 4 bytes to 7 bytes.
+		 */
+		"movl (%1), %4d\n\t"
+		"movl -4(%1, %0), %5d\n\t"
+		"movl %4d, (%2)\n\t"
+		"movl %5d, -4(%2, %0)\n\t"
+		"jmp 13f\n\t"
+		"11:\n\t"
+		"cmp $2, %0\n\t"
+		"jb 12f\n\t"
+		/*
+		 * Move data from 2 bytes to 3 bytes.
+		 */
+		"movw (%1), %4w\n\t"
+		"movw -2(%1, %0), %5w\n\t"
+		"movw %4w, (%2)\n\t"
+		"movw %5w, -2(%2, %0)\n\t"
+		"jmp 13f\n\t"
+		"12:\n\t"
+		"cmp $1, %0\n\t"
+		"jb 13f\n\t"
+		/*
+		 * Move data for 1 byte.
+		 */
+		"movb (%1), %4b\n\t"
+		"movb %4b, (%2)\n\t"
+		"13:\n\t"
+		: "=&d" (d0), "=&S" (d1), "=&D" (d2), "=&a" (ret) ,
+		  "=r"(d3), "=r"(d4), "=r"(d5), "=r"(d6), "=&c" (d7)
+		:"0" (count),
+		 "1" (src),
+		 "2" (dest)
+		:"memory");
+
+		return ret;
+
+
 }
 EXPORT_SYMBOL(memmove);
-- 
1.6.5.2

