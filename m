Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab1GXSDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 14:03:16 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:35805 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab1GXSCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 14:02:51 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jul 2011 14:02:50 EDT
From: Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
        Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH v2 2/2] crypto, x86: SSSE3 based SHA1 implementation for x86-64
Date: Sun, 24 Jul 2011 19:53:14 +0200
Message-Id: <1311529994-7924-3-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1311529994-7924-1-git-send-email-minipli@googlemail.com>
References: <1311529994-7924-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an assembler implementation of the SHA1 algorithm using the
Supplemental SSE3 (SSSE3) instructions or, when available, the
Advanced Vector Extensions (AVX).

Testing with the tcrypt module shows the raw hash performance is up to
2.3 times faster than the C implementation, using 8k data blocks on a
Core 2 Duo T5500. For the smalest data set (16 byte) it is still 25%
faster.

Since this implementation uses SSE/YMM registers it cannot safely be
used in every situation, e.g. while an IRQ interrupts a kernel thread.
The implementation falls back to the generic SHA1 variant, if using
the SSE/YMM registers is not possible.

With this algorithm I was able to increase the throughput of a single
IPsec link from 344 Mbit/s to 464 Mbit/s on a Core 2 Quad CPU using
the SSSE3 variant -- a speedup of +34.8%.

Saving and restoring SSE/YMM state might make the actual throughput
fluctuate when there are FPU intensive userland applications running.
For example, meassuring the performance using iperf2 directly on the
machine under test gives wobbling numbers because iperf2 uses the FPU
for each packet to check if the reporting interval has expired (in the
above test I got min/max/avg: 402/484/464 MBit/s).

Using this algorithm on a IPsec gateway gives much more reasonable and
stable numbers, albeit not as high as in the directly connected case.
Here is the result from an RFC 2544 test run with a EXFO Packet Blazer
FTB-8510:

 frame size    sha1-generic     sha1-ssse3    delta
    64 byte     37.5 MBit/s    37.5 MBit/s     0.0%
   128 byte     56.3 MBit/s    62.5 MBit/s   +11.0%
   256 byte     87.5 MBit/s   100.0 MBit/s   +14.3%
   512 byte    131.3 MBit/s   150.0 MBit/s   +14.2%
  1024 byte    162.5 MBit/s   193.8 MBit/s   +19.3%
  1280 byte    175.0 MBit/s   212.5 MBit/s   +21.4%
  1420 byte    175.0 MBit/s   218.7 MBit/s   +25.0%
  1518 byte    150.0 MBit/s   181.2 MBit/s   +20.8%

The throughput for the largest frame size is lower than for the
previous size because the IP packets need to be fragmented in this
case to make there way through the IPsec tunnel.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Maxim Locktyukhin <maxim.locktyukhin@intel.com>
---
 arch/x86/crypto/Makefile          |    8 +
 arch/x86/crypto/sha1_ssse3_asm.S  |  558 +++++++++++++++++++++++++++++++++++++
 arch/x86/crypto/sha1_ssse3_glue.c |  240 ++++++++++++++++
 arch/x86/include/asm/cpufeature.h |    3 +
 crypto/Kconfig                    |   10 +
 5 files changed, 819 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/crypto/sha1_ssse3_asm.S
 create mode 100644 arch/x86/crypto/sha1_ssse3_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index c04f1b7..57c7f7b 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 
 obj-$(CONFIG_CRYPTO_CRC32C_INTEL) += crc32c-intel.o
+obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
 
 aes-i586-y := aes-i586-asm_32.o aes_glue.o
 twofish-i586-y := twofish-i586-asm_32.o twofish_glue.o
@@ -25,3 +26,10 @@ salsa20-x86_64-y := salsa20-x86_64-asm_64.o salsa20_glue.o
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
 
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
+
+# enable AVX support only when $(AS) can actually assemble the instructions
+ifeq ($(call as-instr,vpxor %xmm0$(comma)%xmm1$(comma)%xmm2,yes,no),yes)
+AFLAGS_sha1_ssse3_asm.o += -DSHA1_ENABLE_AVX_SUPPORT
+CFLAGS_sha1_ssse3_glue.o += -DSHA1_ENABLE_AVX_SUPPORT
+endif
+sha1-ssse3-y := sha1_ssse3_asm.o sha1_ssse3_glue.o
diff --git a/arch/x86/crypto/sha1_ssse3_asm.S b/arch/x86/crypto/sha1_ssse3_asm.S
new file mode 100644
index 0000000..b2c2f57
--- /dev/null
+++ b/arch/x86/crypto/sha1_ssse3_asm.S
@@ -0,0 +1,558 @@
+/*
+ * This is a SIMD SHA-1 implementation. It requires the Intel(R) Supplemental
+ * SSE3 instruction set extensions introduced in Intel Core Microarchitecture
+ * processors. CPUs supporting Intel(R) AVX extensions will get an additional
+ * boost.
+ *
+ * This work was inspired by the vectorized implementation of Dean Gaudet.
+ * Additional information on it can be found at:
+ *    http://www.arctic.org/~dean/crypto/sha1.html
+ *
+ * It was improved upon with more efficient vectorization of the message
+ * scheduling. This implementation has also been optimized for all current and
+ * several future generations of Intel CPUs.
+ *
+ * See this article for more information about the implementation details:
+ *   http://software.intel.com/en-us/articles/improving-the-performance-of-the-secure-hash-algorithm-1/
+ *
+ * Copyright (C) 2010, Intel Corp.
+ *   Authors: Maxim Locktyukhin <maxim.locktyukhin@intel.com>
+ *            Ronen Zohar <ronen.zohar@intel.com>
+ *
+ * Converted to AT&T syntax and adapted for inclusion in the Linux kernel:
+ *   Author: Mathias Krause <minipli@googlemail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#define CTX	%rdi	// arg1
+#define BUF	%rsi	// arg2
+#define CNT	%rdx	// arg3
+
+#define REG_A	%ecx
+#define REG_B	%esi
+#define REG_C	%edi
+#define REG_D	%ebp
+#define REG_E	%edx
+
+#define REG_T1	%eax
+#define REG_T2	%ebx
+
+#define K_BASE		%r8
+#define HASH_PTR	%r9
+#define BUFFER_PTR	%r10
+#define BUFFER_END	%r11
+
+#define W_TMP1	%xmm0
+#define W_TMP2	%xmm9
+
+#define W0	%xmm1
+#define W4	%xmm2
+#define W8	%xmm3
+#define W12	%xmm4
+#define W16	%xmm5
+#define W20	%xmm6
+#define W24	%xmm7
+#define W28	%xmm8
+
+#define XMM_SHUFB_BSWAP	%xmm10
+
+/* we keep window of 64 w[i]+K pre-calculated values in a circular buffer */
+#define WK(t)	(((t) & 15) * 4)(%rsp)
+#define W_PRECALC_AHEAD	16
+
+/*
+ * This macro implements the SHA-1 function's body for single 64-byte block
+ * param: function's name
+ */
+.macro SHA1_VECTOR_ASM  name
+	.global	\name
+	.type	\name, @function
+	.align 32
+\name:
+	push	%rbx
+	push	%rbp
+	push	%r12
+
+	mov	%rsp, %r12
+	sub	$64, %rsp		# allocate workspace
+	and	$~15, %rsp		# align stack
+
+	mov	CTX, HASH_PTR
+	mov	BUF, BUFFER_PTR
+
+	shl	$6, CNT			# multiply by 64
+	add	BUF, CNT
+	mov	CNT, BUFFER_END
+
+	lea	K_XMM_AR(%rip), K_BASE
+	xmm_mov	BSWAP_SHUFB_CTL(%rip), XMM_SHUFB_BSWAP
+
+	SHA1_PIPELINED_MAIN_BODY
+
+	# cleanup workspace
+	mov	$8, %ecx
+	mov	%rsp, %rdi
+	xor	%rax, %rax
+	rep stosq
+
+	mov	%r12, %rsp		# deallocate workspace
+
+	pop	%r12
+	pop	%rbp
+	pop	%rbx
+	ret
+
+	.size	\name, .-\name
+.endm
+
+/*
+ * This macro implements 80 rounds of SHA-1 for one 64-byte block
+ */
+.macro SHA1_PIPELINED_MAIN_BODY
+	INIT_REGALLOC
+
+	mov	  (HASH_PTR), A
+	mov	 4(HASH_PTR), B
+	mov	 8(HASH_PTR), C
+	mov	12(HASH_PTR), D
+	mov	16(HASH_PTR), E
+
+  .set i, 0
+  .rept W_PRECALC_AHEAD
+	W_PRECALC i
+    .set i, (i+1)
+  .endr
+
+.align 4
+1:
+	RR F1,A,B,C,D,E,0
+	RR F1,D,E,A,B,C,2
+	RR F1,B,C,D,E,A,4
+	RR F1,E,A,B,C,D,6
+	RR F1,C,D,E,A,B,8
+
+	RR F1,A,B,C,D,E,10
+	RR F1,D,E,A,B,C,12
+	RR F1,B,C,D,E,A,14
+	RR F1,E,A,B,C,D,16
+	RR F1,C,D,E,A,B,18
+
+	RR F2,A,B,C,D,E,20
+	RR F2,D,E,A,B,C,22
+	RR F2,B,C,D,E,A,24
+	RR F2,E,A,B,C,D,26
+	RR F2,C,D,E,A,B,28
+
+	RR F2,A,B,C,D,E,30
+	RR F2,D,E,A,B,C,32
+	RR F2,B,C,D,E,A,34
+	RR F2,E,A,B,C,D,36
+	RR F2,C,D,E,A,B,38
+
+	RR F3,A,B,C,D,E,40
+	RR F3,D,E,A,B,C,42
+	RR F3,B,C,D,E,A,44
+	RR F3,E,A,B,C,D,46
+	RR F3,C,D,E,A,B,48
+
+	RR F3,A,B,C,D,E,50
+	RR F3,D,E,A,B,C,52
+	RR F3,B,C,D,E,A,54
+	RR F3,E,A,B,C,D,56
+	RR F3,C,D,E,A,B,58
+
+	add	$64, BUFFER_PTR		# move to the next 64-byte block
+	cmp	BUFFER_END, BUFFER_PTR	# if the current is the last one use
+	cmovae	K_BASE, BUFFER_PTR	# dummy source to avoid buffer overrun
+
+	RR F4,A,B,C,D,E,60
+	RR F4,D,E,A,B,C,62
+	RR F4,B,C,D,E,A,64
+	RR F4,E,A,B,C,D,66
+	RR F4,C,D,E,A,B,68
+
+	RR F4,A,B,C,D,E,70
+	RR F4,D,E,A,B,C,72
+	RR F4,B,C,D,E,A,74
+	RR F4,E,A,B,C,D,76
+	RR F4,C,D,E,A,B,78
+
+	UPDATE_HASH   (HASH_PTR), A
+	UPDATE_HASH  4(HASH_PTR), B
+	UPDATE_HASH  8(HASH_PTR), C
+	UPDATE_HASH 12(HASH_PTR), D
+	UPDATE_HASH 16(HASH_PTR), E
+
+	RESTORE_RENAMED_REGS
+	cmp	K_BASE, BUFFER_PTR	# K_BASE means, we reached the end
+	jne	1b
+.endm
+
+.macro INIT_REGALLOC
+  .set A, REG_A
+  .set B, REG_B
+  .set C, REG_C
+  .set D, REG_D
+  .set E, REG_E
+  .set T1, REG_T1
+  .set T2, REG_T2
+.endm
+
+.macro RESTORE_RENAMED_REGS
+	# order is important (REG_C is where it should be)
+	mov	B, REG_B
+	mov	D, REG_D
+	mov	A, REG_A
+	mov	E, REG_E
+.endm
+
+.macro SWAP_REG_NAMES  a, b
+  .set _T, \a
+  .set \a, \b
+  .set \b, _T
+.endm
+
+.macro F1  b, c, d
+	mov	\c, T1
+	SWAP_REG_NAMES \c, T1
+	xor	\d, T1
+	and	\b, T1
+	xor	\d, T1
+.endm
+
+.macro F2  b, c, d
+	mov	\d, T1
+	SWAP_REG_NAMES \d, T1
+	xor	\c, T1
+	xor	\b, T1
+.endm
+
+.macro F3  b, c ,d
+	mov	\c, T1
+	SWAP_REG_NAMES \c, T1
+	mov	\b, T2
+	or	\b, T1
+	and	\c, T2
+	and	\d, T1
+	or	T2, T1
+.endm
+
+.macro F4  b, c, d
+	F2 \b, \c, \d
+.endm
+
+.macro UPDATE_HASH  hash, val
+	add	\hash, \val
+	mov	\val, \hash
+.endm
+
+/*
+ * RR does two rounds of SHA-1 back to back with W[] pre-calc
+ *   t1 = F(b, c, d);   e += w(i)
+ *   e += t1;           b <<= 30;   d  += w(i+1);
+ *   t1 = F(a, b, c);
+ *   d += t1;           a <<= 5;
+ *   e += a;
+ *   t1 = e;            a >>= 7;
+ *   t1 <<= 5;
+ *   d += t1;
+ */
+.macro RR  F, a, b, c, d, e, round
+	add	WK(\round), \e
+	\F   \b, \c, \d		# t1 = F(b, c, d);
+	W_PRECALC (\round + W_PRECALC_AHEAD)
+	rol	$30, \b
+	add	T1, \e
+	add	WK(\round + 1), \d
+
+	\F   \a, \b, \c
+	W_PRECALC (\round + W_PRECALC_AHEAD + 1)
+	rol	$5, \a
+	add	\a, \e
+	add	T1, \d
+	ror	$7, \a		# (a <<r 5) >>r 7) => a <<r 30)
+
+	mov	\e, T1
+	SWAP_REG_NAMES \e, T1
+
+	rol	$5, T1
+	add	T1, \d
+
+	# write:  \a, \b
+	# rotate: \a<=\d, \b<=\e, \c<=\a, \d<=\b, \e<=\c
+.endm
+
+.macro W_PRECALC  r
+  .set i, \r
+
+  .if (i < 20)
+    .set K_XMM, 0
+  .elseif (i < 40)
+    .set K_XMM, 16
+  .elseif (i < 60)
+    .set K_XMM, 32
+  .elseif (i < 80)
+    .set K_XMM, 48
+  .endif
+
+  .if ((i < 16) || ((i >= 80) && (i < (80 + W_PRECALC_AHEAD))))
+    .set i, ((\r) % 80)	    # pre-compute for the next iteration
+    .if (i == 0)
+	W_PRECALC_RESET
+    .endif
+	W_PRECALC_00_15
+  .elseif (i<32)
+	W_PRECALC_16_31
+  .elseif (i < 80)   // rounds 32-79
+	W_PRECALC_32_79
+  .endif
+.endm
+
+.macro W_PRECALC_RESET
+  .set W,          W0
+  .set W_minus_04, W4
+  .set W_minus_08, W8
+  .set W_minus_12, W12
+  .set W_minus_16, W16
+  .set W_minus_20, W20
+  .set W_minus_24, W24
+  .set W_minus_28, W28
+  .set W_minus_32, W
+.endm
+
+.macro W_PRECALC_ROTATE
+  .set W_minus_32, W_minus_28
+  .set W_minus_28, W_minus_24
+  .set W_minus_24, W_minus_20
+  .set W_minus_20, W_minus_16
+  .set W_minus_16, W_minus_12
+  .set W_minus_12, W_minus_08
+  .set W_minus_08, W_minus_04
+  .set W_minus_04, W
+  .set W,          W_minus_32
+.endm
+
+.macro W_PRECALC_SSSE3
+
+.macro W_PRECALC_00_15
+	W_PRECALC_00_15_SSSE3
+.endm
+.macro W_PRECALC_16_31
+	W_PRECALC_16_31_SSSE3
+.endm
+.macro W_PRECALC_32_79
+	W_PRECALC_32_79_SSSE3
+.endm
+
+/* message scheduling pre-compute for rounds 0-15 */
+.macro W_PRECALC_00_15_SSSE3
+  .if ((i & 3) == 0)
+	movdqu	(i*4)(BUFFER_PTR), W_TMP1
+  .elseif ((i & 3) == 1)
+	pshufb	XMM_SHUFB_BSWAP, W_TMP1
+	movdqa	W_TMP1, W
+  .elseif ((i & 3) == 2)
+	paddd	(K_BASE), W_TMP1
+  .elseif ((i & 3) == 3)
+	movdqa  W_TMP1, WK(i&~3)
+	W_PRECALC_ROTATE
+  .endif
+.endm
+
+/* message scheduling pre-compute for rounds 16-31
+ *
+ * - calculating last 32 w[i] values in 8 XMM registers
+ * - pre-calculate K+w[i] values and store to mem, for later load by ALU add
+ *   instruction
+ *
+ * some "heavy-lifting" vectorization for rounds 16-31 due to w[i]->w[i-3]
+ * dependency, but improves for 32-79
+ */
+.macro W_PRECALC_16_31_SSSE3
+  # blended scheduling of vector and scalar instruction streams, one 4-wide
+  # vector iteration / 4 scalar rounds
+  .if ((i & 3) == 0)
+	movdqa	W_minus_12, W
+	palignr	$8, W_minus_16, W	# w[i-14]
+	movdqa	W_minus_04, W_TMP1
+	psrldq	$4, W_TMP1		# w[i-3]
+	pxor	W_minus_08, W
+  .elseif ((i & 3) == 1)
+	pxor	W_minus_16, W_TMP1
+	pxor	W_TMP1, W
+	movdqa	W, W_TMP2
+	movdqa	W, W_TMP1
+	pslldq	$12, W_TMP2
+  .elseif ((i & 3) == 2)
+	psrld	$31, W
+	pslld	$1, W_TMP1
+	por	W, W_TMP1
+	movdqa	W_TMP2, W
+	psrld	$30, W_TMP2
+	pslld	$2, W
+  .elseif ((i & 3) == 3)
+	pxor	W, W_TMP1
+	pxor	W_TMP2, W_TMP1
+	movdqa	W_TMP1, W
+	paddd	K_XMM(K_BASE), W_TMP1
+	movdqa	W_TMP1, WK(i&~3)
+	W_PRECALC_ROTATE
+  .endif
+.endm
+
+/* message scheduling pre-compute for rounds 32-79
+ *
+ * in SHA-1 specification: w[i] = (w[i-3] ^ w[i-8]  ^ w[i-14] ^ w[i-16]) rol 1
+ * instead we do equal:    w[i] = (w[i-6] ^ w[i-16] ^ w[i-28] ^ w[i-32]) rol 2
+ * allows more efficient vectorization since w[i]=>w[i-3] dependency is broken
+ */
+.macro W_PRECALC_32_79_SSSE3
+  .if ((i & 3) == 0)
+	movdqa	W_minus_04, W_TMP1
+	pxor	W_minus_28, W		# W is W_minus_32 before xor
+	palignr	$8, W_minus_08, W_TMP1
+  .elseif ((i & 3) == 1)
+	pxor	W_minus_16, W
+	pxor	W_TMP1, W
+	movdqa	W, W_TMP1
+  .elseif ((i & 3) == 2)
+	psrld	$30, W
+	pslld	$2, W_TMP1
+	por	W, W_TMP1
+  .elseif ((i & 3) == 3)
+	movdqa	W_TMP1, W
+	paddd	K_XMM(K_BASE), W_TMP1
+	movdqa	W_TMP1, WK(i&~3)
+	W_PRECALC_ROTATE
+  .endif
+.endm
+
+.endm		// W_PRECALC_SSSE3
+
+
+#define K1	0x5a827999
+#define K2	0x6ed9eba1
+#define K3	0x8f1bbcdc
+#define K4	0xca62c1d6
+
+.section .rodata
+.align 16
+
+K_XMM_AR:
+	.long K1, K1, K1, K1
+	.long K2, K2, K2, K2
+	.long K3, K3, K3, K3
+	.long K4, K4, K4, K4
+
+BSWAP_SHUFB_CTL:
+	.long 0x00010203
+	.long 0x04050607
+	.long 0x08090a0b
+	.long 0x0c0d0e0f
+
+
+.section .text
+
+W_PRECALC_SSSE3
+.macro xmm_mov a, b
+	movdqu	\a,\b
+.endm
+
+/* SSSE3 optimized implementation:
+ *  extern "C" void sha1_transform_ssse3(u32 *digest, const char *data, u32 *ws,
+ *                                       unsigned int rounds);
+ */
+SHA1_VECTOR_ASM     sha1_transform_ssse3
+
+#ifdef SHA1_ENABLE_AVX_SUPPORT
+
+.macro W_PRECALC_AVX
+
+.purgem W_PRECALC_00_15
+.macro  W_PRECALC_00_15
+    W_PRECALC_00_15_AVX
+.endm
+.purgem W_PRECALC_16_31
+.macro  W_PRECALC_16_31
+    W_PRECALC_16_31_AVX
+.endm
+.purgem W_PRECALC_32_79
+.macro  W_PRECALC_32_79
+    W_PRECALC_32_79_AVX
+.endm
+
+.macro W_PRECALC_00_15_AVX
+  .if ((i & 3) == 0)
+	vmovdqu	(i*4)(BUFFER_PTR), W_TMP1
+  .elseif ((i & 3) == 1)
+	vpshufb	XMM_SHUFB_BSWAP, W_TMP1, W
+  .elseif ((i & 3) == 2)
+	vpaddd	(K_BASE), W, W_TMP1
+  .elseif ((i & 3) == 3)
+	vmovdqa	W_TMP1, WK(i&~3)
+	W_PRECALC_ROTATE
+  .endif
+.endm
+
+.macro W_PRECALC_16_31_AVX
+  .if ((i & 3) == 0)
+	vpalignr $8, W_minus_16, W_minus_12, W	# w[i-14]
+	vpsrldq	$4, W_minus_04, W_TMP1		# w[i-3]
+	vpxor	W_minus_08, W, W
+	vpxor	W_minus_16, W_TMP1, W_TMP1
+  .elseif ((i & 3) == 1)
+	vpxor	W_TMP1, W, W
+	vpslldq	$12, W, W_TMP2
+	vpslld	$1, W, W_TMP1
+  .elseif ((i & 3) == 2)
+	vpsrld	$31, W, W
+	vpor	W, W_TMP1, W_TMP1
+	vpslld	$2, W_TMP2, W
+	vpsrld	$30, W_TMP2, W_TMP2
+  .elseif ((i & 3) == 3)
+	vpxor	W, W_TMP1, W_TMP1
+	vpxor	W_TMP2, W_TMP1, W
+	vpaddd	K_XMM(K_BASE), W, W_TMP1
+	vmovdqu	W_TMP1, WK(i&~3)
+	W_PRECALC_ROTATE
+  .endif
+.endm
+
+.macro W_PRECALC_32_79_AVX
+  .if ((i & 3) == 0)
+	vpalignr $8, W_minus_08, W_minus_04, W_TMP1
+	vpxor	W_minus_28, W, W		# W is W_minus_32 before xor
+  .elseif ((i & 3) == 1)
+	vpxor	W_minus_16, W_TMP1, W_TMP1
+	vpxor	W_TMP1, W, W
+  .elseif ((i & 3) == 2)
+	vpslld	$2, W, W_TMP1
+	vpsrld	$30, W, W
+	vpor	W, W_TMP1, W
+  .elseif ((i & 3) == 3)
+	vpaddd	K_XMM(K_BASE), W, W_TMP1
+	vmovdqu	W_TMP1, WK(i&~3)
+	W_PRECALC_ROTATE
+  .endif
+.endm
+
+.endm    // W_PRECALC_AVX
+
+W_PRECALC_AVX
+.purgem xmm_mov
+.macro xmm_mov a, b
+	vmovdqu	\a,\b
+.endm
+
+
+/* AVX optimized implementation:
+ *  extern "C" void sha1_transform_avx(u32 *digest, const char *data, u32 *ws,
+ *                                     unsigned int rounds);
+ */
+SHA1_VECTOR_ASM     sha1_transform_avx
+
+#endif
diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
new file mode 100644
index 0000000..f916499
--- /dev/null
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -0,0 +1,240 @@
+/*
+ * Cryptographic API.
+ *
+ * Glue code for the SHA1 Secure Hash Algorithm assembler implementation using
+ * Supplemental SSE3 instructions.
+ *
+ * This file is based on sha1_generic.c
+ *
+ * Copyright (c) Alan Smithee.
+ * Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
+ * Copyright (c) Jean-Francois Dive <jef@linuxbe.org>
+ * Copyright (c) Mathias Krause <minipli@googlemail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <crypto/internal/hash.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/cryptohash.h>
+#include <linux/types.h>
+#include <crypto/sha.h>
+#include <asm/byteorder.h>
+#include <asm/i387.h>
+#include <asm/xcr.h>
+#include <asm/xsave.h>
+
+
+asmlinkage void sha1_transform_ssse3(u32 *digest, const char *data,
+				     unsigned int rounds);
+#ifdef SHA1_ENABLE_AVX_SUPPORT
+asmlinkage void sha1_transform_avx(u32 *digest, const char *data,
+				   unsigned int rounds);
+#endif
+
+static asmlinkage void (*sha1_transform_asm)(u32 *, const char *, unsigned int);
+
+
+static int sha1_ssse3_init(struct shash_desc *desc)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+
+	*sctx = (struct sha1_state){
+		.state = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
+	};
+
+	return 0;
+}
+
+static int __sha1_ssse3_update(struct shash_desc *desc, const u8 *data,
+			       unsigned int len, unsigned int partial)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	unsigned int done = 0;
+
+	sctx->count += len;
+
+	if (partial) {
+		done = SHA1_BLOCK_SIZE - partial;
+		memcpy(sctx->buffer + partial, data, done);
+		sha1_transform_asm(sctx->state, sctx->buffer, 1);
+	}
+
+	if (len - done >= SHA1_BLOCK_SIZE) {
+		const unsigned int rounds = (len - done) / SHA1_BLOCK_SIZE;
+
+		sha1_transform_asm(sctx->state, data + done, rounds);
+		done += rounds * SHA1_BLOCK_SIZE;
+	}
+
+	memcpy(sctx->buffer, data + done, len - done);
+
+	return 0;
+}
+
+static int sha1_ssse3_update(struct shash_desc *desc, const u8 *data,
+			     unsigned int len)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	unsigned int partial = sctx->count % SHA1_BLOCK_SIZE;
+	int res;
+
+	/* Handle the fast case right here */
+	if (partial + len < SHA1_BLOCK_SIZE) {
+		sctx->count += len;
+		memcpy(sctx->buffer + partial, data, len);
+
+		return 0;
+	}
+
+	if (!irq_fpu_usable()) {
+		res = crypto_sha1_update(desc, data, len);
+	} else {
+		kernel_fpu_begin();
+		res = __sha1_ssse3_update(desc, data, len, partial);
+		kernel_fpu_end();
+	}
+
+	return res;
+}
+
+
+/* Add padding and return the message digest. */
+static int sha1_ssse3_final(struct shash_desc *desc, u8 *out)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	unsigned int i, index, padlen;
+	__be32 *dst = (__be32 *)out;
+	__be64 bits;
+	static const u8 padding[SHA1_BLOCK_SIZE] = { 0x80, };
+
+	bits = cpu_to_be64(sctx->count << 3);
+
+	/* Pad out to 56 mod 64 and append length */
+	index = sctx->count % SHA1_BLOCK_SIZE;
+	padlen = (index < 56) ? (56 - index) : ((SHA1_BLOCK_SIZE+56) - index);
+	if (!irq_fpu_usable()) {
+		crypto_sha1_update(desc, padding, padlen);
+		crypto_sha1_update(desc, (const u8 *)&bits, sizeof(bits));
+	} else {
+		kernel_fpu_begin();
+		/* We need to fill a whole block for __sha1_ssse3_update() */
+		if (padlen <= 56) {
+			sctx->count += padlen;
+			memcpy(sctx->buffer + index, padding, padlen);
+		} else {
+			__sha1_ssse3_update(desc, padding, padlen, index);
+		}
+		__sha1_ssse3_update(desc, (const u8 *)&bits, sizeof(bits), 56);
+		kernel_fpu_end();
+	}
+
+	/* Store state in digest */
+	for (i = 0; i < 5; i++)
+		dst[i] = cpu_to_be32(sctx->state[i]);
+
+	/* Wipe context */
+	memset(sctx, 0, sizeof(*sctx));
+
+	return 0;
+}
+
+static int sha1_ssse3_export(struct shash_desc *desc, void *out)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, sctx, sizeof(*sctx));
+
+	return 0;
+}
+
+static int sha1_ssse3_import(struct shash_desc *desc, const void *in)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx, in, sizeof(*sctx));
+
+	return 0;
+}
+
+static struct shash_alg alg = {
+	.digestsize	=	SHA1_DIGEST_SIZE,
+	.init		=	sha1_ssse3_init,
+	.update		=	sha1_ssse3_update,
+	.final		=	sha1_ssse3_final,
+	.export		=	sha1_ssse3_export,
+	.import		=	sha1_ssse3_import,
+	.descsize	=	sizeof(struct sha1_state),
+	.statesize	=	sizeof(struct sha1_state),
+	.base		=	{
+		.cra_name	=	"sha1",
+		.cra_driver_name=	"sha1-ssse3",
+		.cra_priority	=	150,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA1_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+#ifdef SHA1_ENABLE_AVX_SUPPORT
+static bool __init avx_usable(void)
+{
+	u64 xcr0;
+
+	if (!cpu_has_avx || !cpu_has_osxsave)
+		return false;
+
+	xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
+	if ((xcr0 & (XSTATE_SSE | XSTATE_YMM)) != (XSTATE_SSE | XSTATE_YMM)) {
+		pr_info("AVX detected but unusable.\n");
+
+		return false;
+	}
+
+	return true;
+}
+#endif
+
+static int __init sha1_ssse3_mod_init(void)
+{
+	/* test for SSSE3 first */
+	if (cpu_has_ssse3)
+		sha1_transform_asm = sha1_transform_ssse3;
+
+#ifdef SHA1_ENABLE_AVX_SUPPORT
+	/* allow AVX to override SSSE3, it's a little faster */
+	if (avx_usable())
+		sha1_transform_asm = sha1_transform_avx;
+#endif
+
+	if (sha1_transform_asm) {
+		pr_info("Using %s optimized SHA-1 implementation\n",
+		        sha1_transform_asm == sha1_transform_ssse3 ? "SSSE3"
+		                                                   : "AVX");
+		return crypto_register_shash(&alg);
+	}
+	pr_info("Neither AVX nor SSSE3 is available/usable.\n");
+
+	return -ENODEV;
+}
+
+static void __exit sha1_ssse3_mod_fini(void)
+{
+	crypto_unregister_shash(&alg);
+}
+
+module_init(sha1_ssse3_mod_init);
+module_exit(sha1_ssse3_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SHA1 Secure Hash Algorithm, Supplemental SSE3 accelerated");
+
+MODULE_ALIAS("sha1");
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 71cc380..a72bce3 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -257,7 +257,9 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_xmm		boot_cpu_has(X86_FEATURE_XMM)
 #define cpu_has_xmm2		boot_cpu_has(X86_FEATURE_XMM2)
 #define cpu_has_xmm3		boot_cpu_has(X86_FEATURE_XMM3)
+#define cpu_has_ssse3		boot_cpu_has(X86_FEATURE_SSSE3)
 #define cpu_has_aes		boot_cpu_has(X86_FEATURE_AES)
+#define cpu_has_avx		boot_cpu_has(X86_FEATURE_AVX)
 #define cpu_has_ht		boot_cpu_has(X86_FEATURE_HT)
 #define cpu_has_mp		boot_cpu_has(X86_FEATURE_MP)
 #define cpu_has_nx		boot_cpu_has(X86_FEATURE_NX)
@@ -285,6 +287,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_xmm4_2		boot_cpu_has(X86_FEATURE_XMM4_2)
 #define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
+#define cpu_has_osxsave		boot_cpu_has(X86_FEATURE_OSXSAVE)
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
 #define cpu_has_perfctr_core	boot_cpu_has(X86_FEATURE_PERFCTR_CORE)
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 87b22ca..6ccec3b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -407,6 +407,16 @@ config CRYPTO_SHA1
 	help
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
 
+config CRYPTO_SHA1_SSSE3
+	tristate "SHA1 digest algorithm (SSSE3/AVX)"
+	depends on X86 && 64BIT
+	select CRYPTO_SHA1
+	select CRYPTO_HASH
+	help
+	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
+	  using Supplemental SSE3 (SSSE3) instructions or Advanced Vector
+	  Extensions (AVX), when available.
+
 config CRYPTO_SHA256
 	tristate "SHA224 and SHA256 digest algorithm"
 	select CRYPTO_HASH
-- 
1.5.6.5

