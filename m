Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab2GKRjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 13:39:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab2GKRjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 13:39:02 -0400
Date: Wed, 11 Jul 2012 19:38:57 +0200
From: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo Mueller <tilo.mueller@informatik.uni-erlangen.de>
Subject: [PATCH 6/6] crypto: cast6 - add x86_64/avx assembler implementation
Message-ID: <7bb665a9ae4ca7c4db234f49d8e1bef1f9a3ac5f.1342027375.git.johannes@goetzfried-amberg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1342027375.git.johannes@goetzfried-amberg.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Provags-ID: V02:K0:TSQcpuVHREQ4uSk5uQzZ/AKyxCxTByc8gVjfXBb/MBt
 /lVQ+2JgswDQJzaHPfOks2maL+sG37yrhTJcIJPCzcihOm5i48
 WQPUnkdY9eOCO8+ctMUBmgLNuEQR/Efj1OMj+oR9gqyDOhVui+
 69rh3Jz1ohCi1nWVF9V8iP/L1nErsCC/nBg9mP13glLjBKGGOg
 XS0V87TQYDMm7gg9qwIDWU+7Tj6f6EFib21AYIFWbb9KCCU97f
 71Szd5mPN9PfWqibvKABahg9E8B5eYDUTZwmAjN7grWfEn4BHy
 NVMJsV7FAE6Luvh9IX/QPYWcV/mHJHzveCHzMviTuD1TBkzjYC
 AGdquY4EYqMK+evO5NpWaFb9G2kMkfN98iek0lf83LFIUxqN52
 kb4i3Xpgr71ioVSqRxxZtK+5uBgu43cMXvt3HAFEQseDnvdRJZ
 F/Q6q
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a x86_64/avx assembler implementation of the Cast6 block
cipher. The implementation processes eight blocks in parallel (two 4 block
chunk AVX operations). The table-lookups are done in general-purpose registers.
For small blocksizes the functions from the generic module are called. A good
performance increase is provided for blocksizes greater or equal to 128B.

Patch has been tested with tcrypt and automated filesystem tests.

Tcrypt benchmark results:

Intel Core i5-2500 CPU (fam:6, model:42, step:7)

cast6-avx-x86_64 vs. cast6-generic
128bit key:                                             (lrw:256bit)    (xts:256bit)
size    ecb-enc ecb-dec cbc-enc cbc-dec ctr-enc ctr-dec lrw-enc lrw-dec xts-enc xts-dec
16B     0.97x   1.00x   1.01x   1.01x   0.99x   0.97x   0.98x   1.01x   0.96x   0.98x
64B     0.98x   0.99x   1.02x   1.01x   0.99x   1.00x   1.01x   0.99x   1.00x   0.99x
256B    1.77x   1.84x   0.99x   1.85x   1.77x   1.77x   1.70x   1.74x   1.69x   1.72x
1024B   1.93x   1.95x   0.99x   1.96x   1.93x   1.93x   1.84x   1.85x   1.89x   1.87x
8192B   1.91x   1.95x   0.99x   1.97x   1.95x   1.91x   1.86x   1.87x   1.93x   1.90x

256bit key:                                             (lrw:384bit)    (xts:512bit)
size    ecb-enc ecb-dec cbc-enc cbc-dec ctr-enc ctr-dec lrw-enc lrw-dec xts-enc xts-dec
16B     0.97x   0.99x   1.02x   1.01x   0.98x   0.99x   1.00x   1.00x   0.98x   0.98x
64B     0.98x   0.99x   1.01x   1.00x   1.00x   1.00x   1.01x   1.01x   0.97x   1.00x
256B    1.77x   1.83x   1.00x   1.86x   1.79x   1.78x   1.70x   1.76x   1.71x   1.69x
1024B   1.92x   1.95x   0.99x   1.96x   1.93x   1.93x   1.83x   1.86x   1.89x   1.87x
8192B   1.94x   1.95x   0.99x   1.97x   1.95x   1.95x   1.87x   1.87x   1.93x   1.91x

Signed-off-by: Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
---
 arch/x86/crypto/Makefile                  |    2 +
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S |  336 +++++++++++++++
 arch/x86/crypto/cast6_avx_glue.c          |  648 +++++++++++++++++++++++++++++
 crypto/Kconfig                            |   17 +
 crypto/testmgr.c                          |   60 +++
 5 files changed, 1063 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/crypto/cast6-avx-x86_64-asm_64.S
 create mode 100644 arch/x86/crypto/cast6_avx_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 565e82b..5bacb4a 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_CRYPTO_SERPENT_SSE2_586) += serpent-sse2-i586.o
 obj-$(CONFIG_CRYPTO_AES_X86_64) += aes-x86_64.o
 obj-$(CONFIG_CRYPTO_CAMELLIA_X86_64) += camellia-x86_64.o
 obj-$(CONFIG_CRYPTO_CAST5_AVX_X86_64) += cast5-avx-x86_64.o
+obj-$(CONFIG_CRYPTO_CAST6_AVX_X86_64) += cast6-avx-x86_64.o
 obj-$(CONFIG_CRYPTO_BLOWFISH_X86_64) += blowfish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64_3WAY) += twofish-x86_64-3way.o
@@ -34,6 +35,7 @@ serpent-sse2-i586-y := serpent-sse2-i586-asm_32.o serpent_sse2_glue.o
 aes-x86_64-y := aes-x86_64-asm_64.o aes_glue.o
 camellia-x86_64-y := camellia-x86_64-asm_64.o camellia_glue.o
 cast5-avx-x86_64-y := cast5-avx-x86_64-asm_64.o cast5_avx_glue.o
+cast6-avx-x86_64-y := cast6-avx-x86_64-asm_64.o cast6_avx_glue.o
 blowfish-x86_64-y := blowfish-x86_64-asm_64.o blowfish_glue.o
 twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_glue.o
 twofish-x86_64-3way-y := twofish-x86_64-asm_64-3way.o twofish_glue_3way.o
diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
new file mode 100644
index 0000000..2e8cec19
--- /dev/null
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
@@ -0,0 +1,336 @@
+/*
+ * Cast6 Cipher 8-way parallel algorithm (AVX/x86_64)
+ *
+ * Copyright (C) 2012 Johannes Goetzfried
+ *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+ * USA
+ *
+ */
+
+.file "cast6-avx-x86_64-asm_64.S"
+.text
+
+.extern cast6_s1
+.extern cast6_s2
+.extern cast6_s3
+.extern cast6_s4
+
+/* structure of crypto context */
+#define km	0
+#define kr	(12*4*4)
+
+/* s-boxes */
+#define s1	cast6_s1
+#define s2	cast6_s2
+#define s3	cast6_s3
+#define s4	cast6_s4
+
+/**********************************************************************
+  8-way AVX cast6
+ **********************************************************************/
+#define CTX %rdi
+
+#define RA1 %xmm0
+#define RB1 %xmm1
+#define RC1 %xmm2
+#define RD1 %xmm3
+
+#define RA2 %xmm4
+#define RB2 %xmm5
+#define RC2 %xmm6
+#define RD2 %xmm7
+
+#define RX %xmm8
+
+#define RKM  %xmm9
+#define RKRF %xmm10
+#define RKRR %xmm11
+
+#define RTMP  %xmm12
+#define RMASK %xmm13
+#define R32   %xmm14
+
+#define RID1  %rax
+#define RID1b %al
+#define RID2  %rbx
+#define RID2b %bl
+
+#define RGI1   %rdx
+#define RGI1bl %dl
+#define RGI1bh %dh
+#define RGI2   %rcx
+#define RGI2bl %cl
+#define RGI2bh %ch
+
+#define RFS1  %r8
+#define RFS1d %r8d
+#define RFS2  %r9
+#define RFS2d %r9d
+#define RFS3  %r10
+#define RFS3d %r10d
+
+
+#define lookup_32bit(src, dst, op1, op2, op3) \
+	movb		src ## bl,     RID1b;    \
+	movb		src ## bh,     RID2b;    \
+	movl		s1(, RID1, 4), dst ## d; \
+	op1		s2(, RID2, 4), dst ## d; \
+	shrq $16,	src;                     \
+	movb		src ## bl,     RID1b;    \
+	movb		src ## bh,     RID2b;    \
+	op2		s3(, RID1, 4), dst ## d; \
+	op3		s4(, RID2, 4), dst ## d;
+
+#define F(a, x, op0, op1, op2, op3) \
+	op0	a,	RKM,  x;                 \
+	vpslld  RKRF,	x,    RTMP;              \
+	vpsrld  RKRR,	x,    x;                 \
+	vpor	RTMP,	x,    x;                 \
+	\
+	vpshufb	RMASK,	x,    x;                 \
+	vmovq		x,    RGI1;              \
+	vpsrldq $8,	x,    x;                 \
+	vmovq		x,    RGI2;              \
+	\
+	lookup_32bit(RGI1, RFS1, op1, op2, op3); \
+	shrq $16,	RGI1;                    \
+	lookup_32bit(RGI1, RFS2, op1, op2, op3); \
+	shlq $32,	RFS2;                    \
+	orq		RFS1, RFS2;              \
+	\
+	lookup_32bit(RGI2, RFS1, op1, op2, op3); \
+	shrq $16,	RGI2;                    \
+	lookup_32bit(RGI2, RFS3, op1, op2, op3); \
+	shlq $32,	RFS3;                    \
+	orq		RFS1, RFS3;              \
+	\
+	vmovq		RFS2, x;                 \
+	vpinsrq $1,	RFS3, x, x;
+
+#define F1(b, x) F(b, x, vpaddd, xorl, subl, addl)
+#define F2(b, x) F(b, x, vpxor,  subl, addl, xorl)
+#define F3(b, x) F(b, x, vpsubd, addl, xorl, subl)
+
+#define qop(in, out, x, f) \
+	F ## f(in ## 1, x);          \
+	vpxor out ## 1, x, out ## 1; \
+	F ## f(in ## 2, x);          \
+	vpxor out ## 2, x, out ## 2; \
+
+#define Q(n) \
+	vbroadcastss	(km+(4*(4*n+0)))(CTX), RKM;        \
+	vpinsrb $0,	(kr+(4*n+0))(CTX),     RKRF, RKRF; \
+	vpsubq		RKRF,                  R32,  RKRR; \
+	qop(RD, RC, RX, 1);                                \
+	\
+	vbroadcastss	(km+(4*(4*n+1)))(CTX), RKM;        \
+	vpinsrb $0,	(kr+(4*n+1))(CTX),     RKRF, RKRF; \
+	vpsubq		RKRF,                  R32,  RKRR; \
+	qop(RC, RB, RX, 2);                                \
+	\
+	vbroadcastss	(km+(4*(4*n+2)))(CTX), RKM;        \
+	vpinsrb $0,	(kr+(4*n+2))(CTX),     RKRF, RKRF; \
+	vpsubq		RKRF,                  R32,  RKRR; \
+	qop(RB, RA, RX, 3);                                \
+	\
+	vbroadcastss	(km+(4*(4*n+3)))(CTX), RKM;        \
+	vpinsrb $0,	(kr+(4*n+3))(CTX),     RKRF, RKRF; \
+	vpsubq		RKRF,                  R32,  RKRR; \
+	qop(RA, RD, RX, 1);
+
+#define QBAR(n) \
+	vbroadcastss	(km+(4*(4*n+3)))(CTX), RKM;        \
+	vpinsrb $0,	(kr+(4*n+3))(CTX),     RKRF, RKRF; \
+	vpsubq		RKRF,                  R32,  RKRR; \
+	qop(RA, RD, RX, 1);                                \
+	\
+	vbroadcastss	(km+(4*(4*n+2)))(CTX), RKM;        \
+	vpinsrb $0,	(kr+(4*n+2))(CTX),     RKRF, RKRF; \
+	vpsubq		RKRF,                  R32,  RKRR; \
+	qop(RB, RA, RX, 3);                                \
+	\
+	vbroadcastss	(km+(4*(4*n+1)))(CTX), RKM;        \
+	vpinsrb $0,	(kr+(4*n+1))(CTX),     RKRF, RKRF; \
+	vpsubq		RKRF,                  R32,  RKRR; \
+	qop(RC, RB, RX, 2);                                \
+	\
+	vbroadcastss	(km+(4*(4*n+0)))(CTX), RKM;        \
+	vpinsrb $0,	(kr+(4*n+0))(CTX),     RKRF, RKRF; \
+	vpsubq		RKRF,                  R32,  RKRR; \
+	qop(RD, RC, RX, 1);
+
+
+#define transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
+	vpunpckldq		x1, x0, t0; \
+	vpunpckhdq		x1, x0, t2; \
+	vpunpckldq		x3, x2, t1; \
+	vpunpckhdq		x3, x2, x3; \
+	\
+	vpunpcklqdq		t1, t0, x0; \
+	vpunpckhqdq		t1, t0, x1; \
+	vpunpcklqdq		x3, t2, x2; \
+	vpunpckhqdq		x3, t2, x3;
+
+#define inpack_blocks(in, x0, x1, x2, x3, t0, t1, t2) \
+	vmovdqu (0*4*4)(in),	x0; \
+	vmovdqu (1*4*4)(in),	x1; \
+	vmovdqu (2*4*4)(in),	x2; \
+	vmovdqu (3*4*4)(in),	x3; \
+	vpshufb RMASK, x0,	x0; \
+	vpshufb RMASK, x1,	x1; \
+	vpshufb RMASK, x2,	x2; \
+	vpshufb RMASK, x3,	x3; \
+	\
+	transpose_4x4(x0, x1, x2, x3, t0, t1, t2)
+
+#define outunpack_blocks(out, x0, x1, x2, x3, t0, t1, t2) \
+	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
+	\
+	vpshufb RMASK,		x0, x0;       \
+	vpshufb RMASK,		x1, x1;       \
+	vpshufb RMASK,		x2, x2;       \
+	vpshufb RMASK,		x3, x3;       \
+	vmovdqu x0,		(0*4*4)(out); \
+	vmovdqu	x1,		(1*4*4)(out); \
+	vmovdqu	x2,		(2*4*4)(out); \
+	vmovdqu	x3,		(3*4*4)(out);
+
+#define outunpack_xor_blocks(out, x0, x1, x2, x3, t0, t1, t2) \
+	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
+	\
+	vpshufb RMASK,		x0, x0;       \
+	vpshufb RMASK,		x1, x1;       \
+	vpshufb RMASK,		x2, x2;       \
+	vpshufb RMASK,		x3, x3;       \
+	vpxor (0*4*4)(out),	x0, x0;       \
+	vmovdqu	x0,		(0*4*4)(out); \
+	vpxor (1*4*4)(out),	x1, x1;       \
+	vmovdqu	x1,		(1*4*4)(out); \
+	vpxor (2*4*4)(out),	x2, x2;       \
+	vmovdqu x2,		(2*4*4)(out); \
+	vpxor (3*4*4)(out),	x3, x3;       \
+	vmovdqu x3,		(3*4*4)(out);
+
+.align 16
+.Lbswap_mask:
+	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
+.L32_mask:
+	.byte 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0
+
+.align 16
+.global __cast6_enc_blk_8way
+.type   __cast6_enc_blk_8way,@function;
+
+__cast6_enc_blk_8way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 *	%rcx: bool, if true: xor output
+	 */
+
+	pushq %rbx;
+	pushq %rcx;
+
+	vmovdqu .Lbswap_mask, RMASK;
+	vmovdqu .L32_mask, R32;
+	vpxor RKRF, RKRF, RKRF;
+
+	leaq (4*4*4)(%rdx), %rax;
+	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RTMP, RX, RKM);
+	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM);
+
+	xorq RID1, RID1;
+	xorq RID2, RID2;
+
+	Q(0);
+	Q(1);
+	Q(2);
+	Q(3);
+	Q(4);
+	Q(5);
+	QBAR(6);
+	QBAR(7);
+	QBAR(8);
+	QBAR(9);
+	QBAR(10);
+	QBAR(11);
+
+	popq %rcx;
+	popq %rbx;
+
+	leaq (4*4*4)(%rsi), %rax;
+
+	testb %cl, %cl;
+	jnz __enc_xor8;
+
+	outunpack_blocks(%rsi, RA1, RB1, RC1, RD1, RTMP, RX, RKM);
+	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM);
+
+	ret;
+
+__enc_xor8:
+	outunpack_xor_blocks(%rsi, RA1, RB1, RC1, RD1, RTMP, RX, RKM);
+	outunpack_xor_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM);
+
+	ret;
+
+.align 16
+.global cast6_dec_blk_8way
+.type   cast6_dec_blk_8way,@function;
+
+cast6_dec_blk_8way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	pushq %rbx;
+
+	vmovdqu .Lbswap_mask, RMASK;
+	vmovdqu .L32_mask, R32;
+	vpxor RKRF, RKRF, RKRF;
+
+	leaq (4*4*4)(%rdx), %rax;
+	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RTMP, RX, RKM);
+	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM);
+
+	xorq RID1, RID1;
+	xorq RID2, RID2;
+
+	Q(11);
+	Q(10);
+	Q(9);
+	Q(8);
+	Q(7);
+	Q(6);
+	QBAR(5);
+	QBAR(4);
+	QBAR(3);
+	QBAR(2);
+	QBAR(1);
+	QBAR(0);
+
+	popq %rbx;
+
+	leaq (4*4*4)(%rsi), %rax;
+	outunpack_blocks(%rsi, RA1, RB1, RC1, RD1, RTMP, RX, RKM);
+	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RTMP, RX, RKM);
+
+	ret;
+
diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
new file mode 100644
index 0000000..15e5f85
--- /dev/null
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -0,0 +1,648 @@
+/*
+ * Glue Code for the AVX assembler implemention of the Cast6 Cipher
+ *
+ * Copyright (C) 2012 Johannes Goetzfried
+ *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+ * USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/hardirq.h>
+#include <linux/types.h>
+#include <linux/crypto.h>
+#include <linux/err.h>
+#include <crypto/algapi.h>
+#include <crypto/cast6.h>
+#include <crypto/cryptd.h>
+#include <crypto/b128ops.h>
+#include <crypto/ctr.h>
+#include <crypto/lrw.h>
+#include <crypto/xts.h>
+#include <asm/xcr.h>
+#include <asm/xsave.h>
+#include <asm/crypto/ablk_helper.h>
+#include <asm/crypto/glue_helper.h>
+
+#define CAST6_PARALLEL_BLOCKS 8
+
+asmlinkage void __cast6_enc_blk_8way(struct cast6_ctx *ctx, u8 *dst,
+				     const u8 *src, bool xor);
+asmlinkage void cast6_dec_blk_8way(struct cast6_ctx *ctx, u8 *dst,
+				   const u8 *src);
+
+static inline void cast6_enc_blk_xway(struct cast6_ctx *ctx, u8 *dst,
+				      const u8 *src)
+{
+	__cast6_enc_blk_8way(ctx, dst, src, false);
+}
+
+static inline void cast6_enc_blk_xway_xor(struct cast6_ctx *ctx, u8 *dst,
+					  const u8 *src)
+{
+	__cast6_enc_blk_8way(ctx, dst, src, true);
+}
+
+static inline void cast6_dec_blk_xway(struct cast6_ctx *ctx, u8 *dst,
+				      const u8 *src)
+{
+	cast6_dec_blk_8way(ctx, dst, src);
+}
+
+
+static void cast6_decrypt_cbc_xway(void *ctx, u128 *dst, const u128 *src)
+{
+	u128 ivs[CAST6_PARALLEL_BLOCKS - 1];
+	unsigned int j;
+
+	for (j = 0; j < CAST6_PARALLEL_BLOCKS - 1; j++)
+		ivs[j] = src[j];
+
+	cast6_dec_blk_xway(ctx, (u8 *)dst, (u8 *)src);
+
+	for (j = 0; j < CAST6_PARALLEL_BLOCKS - 1; j++)
+		u128_xor(dst + (j + 1), dst + (j + 1), ivs + j);
+}
+
+static void cast6_crypt_ctr(void *ctx, u128 *dst, const u128 *src, u128 *iv)
+{
+	be128 ctrblk;
+
+	u128_to_be128(&ctrblk, iv);
+	u128_inc(iv);
+
+	__cast6_encrypt(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
+	u128_xor(dst, src, (u128 *)&ctrblk);
+}
+
+static void cast6_crypt_ctr_xway(void *ctx, u128 *dst, const u128 *src,
+				   u128 *iv)
+{
+	be128 ctrblks[CAST6_PARALLEL_BLOCKS];
+	unsigned int i;
+
+	for (i = 0; i < CAST6_PARALLEL_BLOCKS; i++) {
+		if (dst != src)
+			dst[i] = src[i];
+
+		u128_to_be128(&ctrblks[i], iv);
+		u128_inc(iv);
+	}
+
+	cast6_enc_blk_xway_xor(ctx, (u8 *)dst, (u8 *)ctrblks);
+}
+
+static const struct common_glue_ctx cast6_enc = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = CAST6_PARALLEL_BLOCKS,
+
+	.funcs = { {
+		.num_blocks = CAST6_PARALLEL_BLOCKS,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(cast6_enc_blk_xway) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(__cast6_encrypt) }
+	} }
+};
+
+static const struct common_glue_ctx cast6_ctr = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = CAST6_PARALLEL_BLOCKS,
+
+	.funcs = { {
+		.num_blocks = CAST6_PARALLEL_BLOCKS,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(cast6_crypt_ctr_xway) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(cast6_crypt_ctr) }
+	} }
+};
+
+static const struct common_glue_ctx cast6_dec = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = CAST6_PARALLEL_BLOCKS,
+
+	.funcs = { {
+		.num_blocks = CAST6_PARALLEL_BLOCKS,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(cast6_dec_blk_xway) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .ecb = GLUE_FUNC_CAST(__cast6_decrypt) }
+	} }
+};
+
+static const struct common_glue_ctx cast6_dec_cbc = {
+	.num_funcs = 2,
+	.fpu_blocks_limit = CAST6_PARALLEL_BLOCKS,
+
+	.funcs = { {
+		.num_blocks = CAST6_PARALLEL_BLOCKS,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(cast6_decrypt_cbc_xway) }
+	}, {
+		.num_blocks = 1,
+		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__cast6_decrypt) }
+	} }
+};
+
+static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_ecb_crypt_128bit(&cast6_enc, desc, dst, src, nbytes);
+}
+
+static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_ecb_crypt_128bit(&cast6_dec, desc, dst, src, nbytes);
+}
+
+static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_cbc_encrypt_128bit(GLUE_FUNC_CAST(__cast6_encrypt), desc,
+				       dst, src, nbytes);
+}
+
+static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_cbc_decrypt_128bit(&cast6_dec_cbc, desc, dst, src,
+				       nbytes);
+}
+
+static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		     struct scatterlist *src, unsigned int nbytes)
+{
+	return glue_ctr_crypt_128bit(&cast6_ctr, desc, dst, src, nbytes);
+}
+
+static inline bool cast6_fpu_begin(bool fpu_enabled, unsigned int nbytes)
+{
+	return glue_fpu_begin(CAST6_BLOCK_SIZE, CAST6_PARALLEL_BLOCKS,
+			      NULL, fpu_enabled, nbytes);
+}
+
+static inline void cast6_fpu_end(bool fpu_enabled)
+{
+	glue_fpu_end(fpu_enabled);
+}
+
+struct crypt_priv {
+	struct cast6_ctx *ctx;
+	bool fpu_enabled;
+};
+
+static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
+{
+	const unsigned int bsize = CAST6_BLOCK_SIZE;
+	struct crypt_priv *ctx = priv;
+	int i;
+
+	ctx->fpu_enabled = cast6_fpu_begin(ctx->fpu_enabled, nbytes);
+
+	if (nbytes == bsize * CAST6_PARALLEL_BLOCKS) {
+		cast6_enc_blk_xway(ctx->ctx, srcdst, srcdst);
+		return;
+	}
+
+	for (i = 0; i < nbytes / bsize; i++, srcdst += bsize)
+		__cast6_encrypt(ctx->ctx, srcdst, srcdst);
+}
+
+static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
+{
+	const unsigned int bsize = CAST6_BLOCK_SIZE;
+	struct crypt_priv *ctx = priv;
+	int i;
+
+	ctx->fpu_enabled = cast6_fpu_begin(ctx->fpu_enabled, nbytes);
+
+	if (nbytes == bsize * CAST6_PARALLEL_BLOCKS) {
+		cast6_dec_blk_xway(ctx->ctx, srcdst, srcdst);
+		return;
+	}
+
+	for (i = 0; i < nbytes / bsize; i++, srcdst += bsize)
+		__cast6_decrypt(ctx->ctx, srcdst, srcdst);
+}
+
+struct cast6_lrw_ctx {
+	struct lrw_table_ctx lrw_table;
+	struct cast6_ctx cast6_ctx;
+};
+
+static int lrw_cast6_setkey(struct crypto_tfm *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct cast6_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
+	int err;
+
+	err = __cast6_setkey(&ctx->cast6_ctx, key, keylen - CAST6_BLOCK_SIZE,
+			     &tfm->crt_flags);
+	if (err)
+		return err;
+
+	return lrw_init_table(&ctx->lrw_table, key + keylen - CAST6_BLOCK_SIZE);
+}
+
+static int lrw_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct cast6_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[CAST6_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->cast6_ctx,
+		.fpu_enabled = false,
+	};
+	struct lrw_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.table_ctx = &ctx->lrw_table,
+		.crypt_ctx = &crypt_ctx,
+		.crypt_fn = encrypt_callback,
+	};
+	int ret;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	ret = lrw_crypt(desc, dst, src, nbytes, &req);
+	cast6_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static int lrw_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct cast6_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[CAST6_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->cast6_ctx,
+		.fpu_enabled = false,
+	};
+	struct lrw_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.table_ctx = &ctx->lrw_table,
+		.crypt_ctx = &crypt_ctx,
+		.crypt_fn = decrypt_callback,
+	};
+	int ret;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	ret = lrw_crypt(desc, dst, src, nbytes, &req);
+	cast6_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static void lrw_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct cast6_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	lrw_free_table(&ctx->lrw_table);
+}
+
+struct cast6_xts_ctx {
+	struct cast6_ctx tweak_ctx;
+	struct cast6_ctx crypt_ctx;
+};
+
+static int xts_cast6_setkey(struct crypto_tfm *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct cast6_xts_ctx *ctx = crypto_tfm_ctx(tfm);
+	u32 *flags = &tfm->crt_flags;
+	int err;
+
+	/* key consists of keys of equal size concatenated, therefore
+	 * the length must be even
+	 */
+	if (keylen % 2) {
+		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	/* first half of xts-key is for crypt */
+	err = __cast6_setkey(&ctx->crypt_ctx, key, keylen / 2, flags);
+	if (err)
+		return err;
+
+	/* second half of xts-key is for tweak */
+	return __cast6_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2,
+			      flags);
+}
+
+static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct cast6_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[CAST6_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->crypt_ctx,
+		.fpu_enabled = false,
+	};
+	struct xts_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.tweak_ctx = &ctx->tweak_ctx,
+		.tweak_fn = XTS_TWEAK_CAST(__cast6_encrypt),
+		.crypt_ctx = &crypt_ctx,
+		.crypt_fn = encrypt_callback,
+	};
+	int ret;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	ret = xts_crypt(desc, dst, src, nbytes, &req);
+	cast6_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct cast6_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[CAST6_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->crypt_ctx,
+		.fpu_enabled = false,
+	};
+	struct xts_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.tweak_ctx = &ctx->tweak_ctx,
+		.tweak_fn = XTS_TWEAK_CAST(__cast6_encrypt),
+		.crypt_ctx = &crypt_ctx,
+		.crypt_fn = decrypt_callback,
+	};
+	int ret;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	ret = xts_crypt(desc, dst, src, nbytes, &req);
+	cast6_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static struct crypto_alg cast6_algs[10] = { {
+	.cra_name		= "__ecb-cast6-avx",
+	.cra_driver_name	= "__driver-ecb-cast6-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= CAST6_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct cast6_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= CAST6_MIN_KEY_SIZE,
+			.max_keysize	= CAST6_MAX_KEY_SIZE,
+			.setkey		= cast6_setkey,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__cbc-cast6-avx",
+	.cra_driver_name	= "__driver-cbc-cast6-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= CAST6_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct cast6_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= CAST6_MIN_KEY_SIZE,
+			.max_keysize	= CAST6_MAX_KEY_SIZE,
+			.setkey		= cast6_setkey,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__ctr-cast6-avx",
+	.cra_driver_name	= "__driver-ctr-cast6-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct cast6_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= CAST6_MIN_KEY_SIZE,
+			.max_keysize	= CAST6_MAX_KEY_SIZE,
+			.ivsize		= CAST6_BLOCK_SIZE,
+			.setkey		= cast6_setkey,
+			.encrypt	= ctr_crypt,
+			.decrypt	= ctr_crypt,
+		},
+	},
+}, {
+	.cra_name		= "__lrw-cast6-avx",
+	.cra_driver_name	= "__driver-lrw-cast6-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= CAST6_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct cast6_lrw_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_exit		= lrw_exit_tfm,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= CAST6_MIN_KEY_SIZE +
+					  CAST6_BLOCK_SIZE,
+			.max_keysize	= CAST6_MAX_KEY_SIZE +
+					  CAST6_BLOCK_SIZE,
+			.ivsize		= CAST6_BLOCK_SIZE,
+			.setkey		= lrw_cast6_setkey,
+			.encrypt	= lrw_encrypt,
+			.decrypt	= lrw_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__xts-cast6-avx",
+	.cra_driver_name	= "__driver-xts-cast6-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= CAST6_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct cast6_xts_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= CAST6_MIN_KEY_SIZE * 2,
+			.max_keysize	= CAST6_MAX_KEY_SIZE * 2,
+			.ivsize		= CAST6_BLOCK_SIZE,
+			.setkey		= xts_cast6_setkey,
+			.encrypt	= xts_encrypt,
+			.decrypt	= xts_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "ecb(cast6)",
+	.cra_driver_name	= "ecb-cast6-avx",
+	.cra_priority		= 200,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= CAST6_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= CAST6_MIN_KEY_SIZE,
+			.max_keysize	= CAST6_MAX_KEY_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "cbc(cast6)",
+	.cra_driver_name	= "cbc-cast6-avx",
+	.cra_priority		= 200,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= CAST6_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= CAST6_MIN_KEY_SIZE,
+			.max_keysize	= CAST6_MAX_KEY_SIZE,
+			.ivsize		= CAST6_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= __ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "ctr(cast6)",
+	.cra_driver_name	= "ctr-cast6-avx",
+	.cra_priority		= 200,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= CAST6_MIN_KEY_SIZE,
+			.max_keysize	= CAST6_MAX_KEY_SIZE,
+			.ivsize		= CAST6_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_encrypt,
+			.geniv		= "chainiv",
+		},
+	},
+}, {
+	.cra_name		= "lrw(cast6)",
+	.cra_driver_name	= "lrw-cast6-avx",
+	.cra_priority		= 200,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= CAST6_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= CAST6_MIN_KEY_SIZE +
+					  CAST6_BLOCK_SIZE,
+			.max_keysize	= CAST6_MAX_KEY_SIZE +
+					  CAST6_BLOCK_SIZE,
+			.ivsize		= CAST6_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "xts(cast6)",
+	.cra_driver_name	= "xts-cast6-avx",
+	.cra_priority		= 200,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= CAST6_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= CAST6_MIN_KEY_SIZE * 2,
+			.max_keysize	= CAST6_MAX_KEY_SIZE * 2,
+			.ivsize		= CAST6_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+} };
+
+static int __init cast6_init(void)
+{
+	u64 xcr0;
+
+	if (!cpu_has_avx || !cpu_has_osxsave) {
+		pr_info("AVX instructions are not detected.\n");
+		return -ENODEV;
+	}
+
+	xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
+	if ((xcr0 & (XSTATE_SSE | XSTATE_YMM)) != (XSTATE_SSE | XSTATE_YMM)) {
+		pr_info("AVX detected but unusable.\n");
+		return -ENODEV;
+	}
+
+	return crypto_register_algs(cast6_algs, ARRAY_SIZE(cast6_algs));
+}
+
+static void __exit cast6_exit(void)
+{
+	crypto_unregister_algs(cast6_algs, ARRAY_SIZE(cast6_algs));
+}
+
+module_init(cast6_init);
+module_exit(cast6_exit);
+
+MODULE_DESCRIPTION("Cast6 Cipher Algorithm, AVX optimized");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("cast6");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index cda97fc..fe8ed62 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -713,6 +713,23 @@ config CRYPTO_CAST6
 	  The CAST6 encryption algorithm (synonymous with CAST-256) is
 	  described in RFC2612.
 
+config CRYPTO_CAST6_AVX_X86_64
+	tristate "CAST6 (CAST-256) cipher algorithm (x86_64/AVX)"
+	depends on X86 && 64BIT
+	select CRYPTO_ALGAPI
+	select CRYPTO_CRYPTD
+	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_GLUE_HELPER_X86
+	select CRYPTO_CAST6
+	select CRYPTO_LRW
+	select CRYPTO_XTS
+	help
+	  The CAST6 encryption algorithm (synonymous with CAST-256) is
+	  described in RFC2612.
+
+	  This module provides the Cast6 cipher algorithm that processes
+	  eight blocks parallel using the AVX instruction set.
+
 config CRYPTO_DES
 	tristate "DES and Triple DES EDE cipher algorithms"
 	select CRYPTO_ALGAPI
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index cff3c1c..575b57c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1549,6 +1549,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "__cbc-cast6-avx",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
 		.alg = "__cbc-serpent-avx",
 		.test = alg_test_null,
 		.suite = {
@@ -1625,6 +1640,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "__driver-cbc-cast6-avx",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
 		.alg = "__driver-cbc-serpent-avx",
 		.test = alg_test_null,
 		.suite = {
@@ -1701,6 +1731,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "__driver-ecb-cast6-avx",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
 		.alg = "__driver-ecb-serpent-avx",
 		.test = alg_test_null,
 		.suite = {
@@ -2027,6 +2072,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "cryptd(__driver-ecb-cast6-avx)",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
 		.alg = "cryptd(__driver-ecb-serpent-avx)",
 		.test = alg_test_null,
 		.suite = {
-- 
1.7.2.5

