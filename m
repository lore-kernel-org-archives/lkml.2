Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab1COVBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:01:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55673 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758560Ab1COVBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:01:19 -0400
Date: Tue, 15 Mar 2011 22:01:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mem changes for v2.6.39
Message-ID: <20110315210107.GA7333@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mem-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mem-for-linus

 Thanks,

	Ingo

------------------>
Fenghua Yu (1):
      x86-64, mem: Convert memmove() to assembly file and fix return value bug


 arch/x86/kernel/x8664_ksyms_64.c |    1 +
 arch/x86/lib/memmove_64.S        |  197 ++++++++++++++++++++++++++++++++++++++
 arch/x86/lib/memmove_64.c        |  192 -------------------------------------
 3 files changed, 198 insertions(+), 192 deletions(-)
 create mode 100644 arch/x86/lib/memmove_64.S
 delete mode 100644 arch/x86/lib/memmove_64.c

diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 1b950d1..9796c2f 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -52,6 +52,7 @@ extern void *__memcpy(void *, const void *, __kernel_size_t);
 EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(__memcpy);
+EXPORT_SYMBOL(memmove);
 
 EXPORT_SYMBOL(empty_zero_page);
 #ifndef CONFIG_PARAVIRT
diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
new file mode 100644
index 0000000..0ecb843
--- /dev/null
+++ b/arch/x86/lib/memmove_64.S
@@ -0,0 +1,197 @@
+/*
+ * Normally compiler builtins are used, but sometimes the compiler calls out
+ * of line code. Based on asm-i386/string.h.
+ *
+ * This assembly file is re-written from memmove_64.c file.
+ *	- Copyright 2011 Fenghua Yu <fenghua.yu@intel.com>
+ */
+#define _STRING_C
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
+
+#undef memmove
+
+/*
+ * Implement memmove(). This can handle overlap between src and dst.
+ *
+ * Input:
+ * rdi: dest
+ * rsi: src
+ * rdx: count
+ *
+ * Output:
+ * rax: dest
+ */
+ENTRY(memmove)
+	CFI_STARTPROC
+	/* Handle more 32bytes in loop */
+	mov %rdi, %rax
+	cmp $0x20, %rdx
+	jb	1f
+
+	/* Decide forward/backward copy mode */
+	cmp %rdi, %rsi
+	jb	2f
+
+	/*
+	 * movsq instruction have many startup latency
+	 * so we handle small size by general register.
+	 */
+	cmp  $680, %rdx
+	jb	3f
+	/*
+	 * movsq instruction is only good for aligned case.
+	 */
+
+	cmpb %dil, %sil
+	je 4f
+3:
+	sub $0x20, %rdx
+	/*
+	 * We gobble 32byts forward in each loop.
+	 */
+5:
+	sub $0x20, %rdx
+	movq 0*8(%rsi), %r11
+	movq 1*8(%rsi), %r10
+	movq 2*8(%rsi), %r9
+	movq 3*8(%rsi), %r8
+	leaq 4*8(%rsi), %rsi
+
+	movq %r11, 0*8(%rdi)
+	movq %r10, 1*8(%rdi)
+	movq %r9, 2*8(%rdi)
+	movq %r8, 3*8(%rdi)
+	leaq 4*8(%rdi), %rdi
+	jae 5b
+	addq $0x20, %rdx
+	jmp 1f
+	/*
+	 * Handle data forward by movsq.
+	 */
+	.p2align 4
+4:
+	movq %rdx, %rcx
+	movq -8(%rsi, %rdx), %r11
+	lea -8(%rdi, %rdx), %r10
+	shrq $3, %rcx
+	rep movsq
+	movq %r11, (%r10)
+	jmp 13f
+	/*
+	 * Handle data backward by movsq.
+	 */
+	.p2align 4
+7:
+	movq %rdx, %rcx
+	movq (%rsi), %r11
+	movq %rdi, %r10
+	leaq -8(%rsi, %rdx), %rsi
+	leaq -8(%rdi, %rdx), %rdi
+	shrq $3, %rcx
+	std
+	rep movsq
+	cld
+	movq %r11, (%r10)
+	jmp 13f
+
+	/*
+	 * Start to prepare for backward copy.
+	 */
+	.p2align 4
+2:
+	cmp $680, %rdx
+	jb 6f
+	cmp %dil, %sil
+	je 7b
+6:
+	/*
+	 * Calculate copy position to tail.
+	 */
+	addq %rdx, %rsi
+	addq %rdx, %rdi
+	subq $0x20, %rdx
+	/*
+	 * We gobble 32byts backward in each loop.
+	 */
+8:
+	subq $0x20, %rdx
+	movq -1*8(%rsi), %r11
+	movq -2*8(%rsi), %r10
+	movq -3*8(%rsi), %r9
+	movq -4*8(%rsi), %r8
+	leaq -4*8(%rsi), %rsi
+
+	movq %r11, -1*8(%rdi)
+	movq %r10, -2*8(%rdi)
+	movq %r9, -3*8(%rdi)
+	movq %r8, -4*8(%rdi)
+	leaq -4*8(%rdi), %rdi
+	jae 8b
+	/*
+	 * Calculate copy position to head.
+	 */
+	addq $0x20, %rdx
+	subq %rdx, %rsi
+	subq %rdx, %rdi
+1:
+	cmpq $16, %rdx
+	jb 9f
+	/*
+	 * Move data from 16 bytes to 31 bytes.
+	 */
+	movq 0*8(%rsi), %r11
+	movq 1*8(%rsi), %r10
+	movq -2*8(%rsi, %rdx), %r9
+	movq -1*8(%rsi, %rdx), %r8
+	movq %r11, 0*8(%rdi)
+	movq %r10, 1*8(%rdi)
+	movq %r9, -2*8(%rdi, %rdx)
+	movq %r8, -1*8(%rdi, %rdx)
+	jmp 13f
+	.p2align 4
+9:
+	cmpq $8, %rdx
+	jb 10f
+	/*
+	 * Move data from 8 bytes to 15 bytes.
+	 */
+	movq 0*8(%rsi), %r11
+	movq -1*8(%rsi, %rdx), %r10
+	movq %r11, 0*8(%rdi)
+	movq %r10, -1*8(%rdi, %rdx)
+	jmp 13f
+10:
+	cmpq $4, %rdx
+	jb 11f
+	/*
+	 * Move data from 4 bytes to 7 bytes.
+	 */
+	movl (%rsi), %r11d
+	movl -4(%rsi, %rdx), %r10d
+	movl %r11d, (%rdi)
+	movl %r10d, -4(%rdi, %rdx)
+	jmp 13f
+11:
+	cmp $2, %rdx
+	jb 12f
+	/*
+	 * Move data from 2 bytes to 3 bytes.
+	 */
+	movw (%rsi), %r11w
+	movw -2(%rsi, %rdx), %r10w
+	movw %r11w, (%rdi)
+	movw %r10w, -2(%rdi, %rdx)
+	jmp 13f
+12:
+	cmp $1, %rdx
+	jb 13f
+	/*
+	 * Move data for 1 byte.
+	 */
+	movb (%rsi), %r11b
+	movb %r11b, (%rdi)
+13:
+	retq
+	CFI_ENDPROC
+ENDPROC(memmove)
diff --git a/arch/x86/lib/memmove_64.c b/arch/x86/lib/memmove_64.c
deleted file mode 100644
index 6d0f0ec..0000000
--- a/arch/x86/lib/memmove_64.c
+++ /dev/null
@@ -1,192 +0,0 @@
-/* Normally compiler builtins are used, but sometimes the compiler calls out
-   of line code. Based on asm-i386/string.h.
- */
-#define _STRING_C
-#include <linux/string.h>
-#include <linux/module.h>
-
-#undef memmove
-void *memmove(void *dest, const void *src, size_t count)
-{
-	unsigned long d0,d1,d2,d3,d4,d5,d6,d7;
-	char *ret;
-
-	__asm__ __volatile__(
-		/* Handle more 32bytes in loop */
-		"mov %2, %3\n\t"
-		"cmp $0x20, %0\n\t"
-		"jb	1f\n\t"
-
-		/* Decide forward/backward copy mode */
-		"cmp %2, %1\n\t"
-		"jb	2f\n\t"
-
-		/*
-		 * movsq instruction have many startup latency
-		 * so we handle small size by general register.
-		 */
-		"cmp  $680, %0\n\t"
-		"jb 3f\n\t"
-		/*
-		 * movsq instruction is only good for aligned case.
-		 */
-		"cmpb %%dil, %%sil\n\t"
-		"je 4f\n\t"
-		"3:\n\t"
-		"sub $0x20, %0\n\t"
-		/*
-		 * We gobble 32byts forward in each loop.
-		 */
-		"5:\n\t"
-		"sub $0x20, %0\n\t"
-		"movq 0*8(%1), %4\n\t"
-		"movq 1*8(%1), %5\n\t"
-		"movq 2*8(%1), %6\n\t"
-		"movq 3*8(%1), %7\n\t"
-		"leaq 4*8(%1), %1\n\t"
-
-		"movq %4, 0*8(%2)\n\t"
-		"movq %5, 1*8(%2)\n\t"
-		"movq %6, 2*8(%2)\n\t"
-		"movq %7, 3*8(%2)\n\t"
-		"leaq 4*8(%2), %2\n\t"
-		"jae 5b\n\t"
-		"addq $0x20, %0\n\t"
-		"jmp 1f\n\t"
-		/*
-		 * Handle data forward by movsq.
-		 */
-		".p2align 4\n\t"
-		"4:\n\t"
-		"movq %0, %8\n\t"
-		"movq -8(%1, %0), %4\n\t"
-		"lea -8(%2, %0), %5\n\t"
-		"shrq $3, %8\n\t"
-		"rep movsq\n\t"
-		"movq %4, (%5)\n\t"
-		"jmp 13f\n\t"
-		/*
-		 * Handle data backward by movsq.
-		 */
-		".p2align 4\n\t"
-		"7:\n\t"
-		"movq %0, %8\n\t"
-		"movq (%1), %4\n\t"
-		"movq %2, %5\n\t"
-		"leaq -8(%1, %0), %1\n\t"
-		"leaq -8(%2, %0), %2\n\t"
-		"shrq $3, %8\n\t"
-		"std\n\t"
-		"rep movsq\n\t"
-		"cld\n\t"
-		"movq %4, (%5)\n\t"
-		"jmp 13f\n\t"
-
-		/*
-		 * Start to prepare for backward copy.
-		 */
-		".p2align 4\n\t"
-		"2:\n\t"
-		"cmp $680, %0\n\t"
-		"jb 6f \n\t"
-		"cmp %%dil, %%sil\n\t"
-		"je 7b \n\t"
-		"6:\n\t"
-		/*
-		 * Calculate copy position to tail.
-		 */
-		"addq %0, %1\n\t"
-		"addq %0, %2\n\t"
-		"subq $0x20, %0\n\t"
-		/*
-		 * We gobble 32byts backward in each loop.
-		 */
-		"8:\n\t"
-		"subq $0x20, %0\n\t"
-		"movq -1*8(%1), %4\n\t"
-		"movq -2*8(%1), %5\n\t"
-		"movq -3*8(%1), %6\n\t"
-		"movq -4*8(%1), %7\n\t"
-		"leaq -4*8(%1), %1\n\t"
-
-		"movq %4, -1*8(%2)\n\t"
-		"movq %5, -2*8(%2)\n\t"
-		"movq %6, -3*8(%2)\n\t"
-		"movq %7, -4*8(%2)\n\t"
-		"leaq -4*8(%2), %2\n\t"
-		"jae 8b\n\t"
-		/*
-		 * Calculate copy position to head.
-		 */
-		"addq $0x20, %0\n\t"
-		"subq %0, %1\n\t"
-		"subq %0, %2\n\t"
-		"1:\n\t"
-		"cmpq $16, %0\n\t"
-		"jb 9f\n\t"
-		/*
-		 * Move data from 16 bytes to 31 bytes.
-		 */
-		"movq 0*8(%1), %4\n\t"
-		"movq 1*8(%1), %5\n\t"
-		"movq -2*8(%1, %0), %6\n\t"
-		"movq -1*8(%1, %0), %7\n\t"
-		"movq %4, 0*8(%2)\n\t"
-		"movq %5, 1*8(%2)\n\t"
-		"movq %6, -2*8(%2, %0)\n\t"
-		"movq %7, -1*8(%2, %0)\n\t"
-		"jmp 13f\n\t"
-		".p2align 4\n\t"
-		"9:\n\t"
-		"cmpq $8, %0\n\t"
-		"jb 10f\n\t"
-		/*
-		 * Move data from 8 bytes to 15 bytes.
-		 */
-		"movq 0*8(%1), %4\n\t"
-		"movq -1*8(%1, %0), %5\n\t"
-		"movq %4, 0*8(%2)\n\t"
-		"movq %5, -1*8(%2, %0)\n\t"
-		"jmp 13f\n\t"
-		"10:\n\t"
-		"cmpq $4, %0\n\t"
-		"jb 11f\n\t"
-		/*
-		 * Move data from 4 bytes to 7 bytes.
-		 */
-		"movl (%1), %4d\n\t"
-		"movl -4(%1, %0), %5d\n\t"
-		"movl %4d, (%2)\n\t"
-		"movl %5d, -4(%2, %0)\n\t"
-		"jmp 13f\n\t"
-		"11:\n\t"
-		"cmp $2, %0\n\t"
-		"jb 12f\n\t"
-		/*
-		 * Move data from 2 bytes to 3 bytes.
-		 */
-		"movw (%1), %4w\n\t"
-		"movw -2(%1, %0), %5w\n\t"
-		"movw %4w, (%2)\n\t"
-		"movw %5w, -2(%2, %0)\n\t"
-		"jmp 13f\n\t"
-		"12:\n\t"
-		"cmp $1, %0\n\t"
-		"jb 13f\n\t"
-		/*
-		 * Move data for 1 byte.
-		 */
-		"movb (%1), %4b\n\t"
-		"movb %4b, (%2)\n\t"
-		"13:\n\t"
-		: "=&d" (d0), "=&S" (d1), "=&D" (d2), "=&a" (ret) ,
-		  "=r"(d3), "=r"(d4), "=r"(d5), "=r"(d6), "=&c" (d7)
-		:"0" (count),
-		 "1" (src),
-		 "2" (dest)
-		:"memory");
-
-		return ret;
-
-}
-EXPORT_SYMBOL(memmove);
