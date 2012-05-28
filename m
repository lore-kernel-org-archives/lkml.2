Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab2E1Nye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 09:54:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2E1Nyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 09:54:32 -0400
Date: Mon, 28 May 2012 15:54:24 +0200
From: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?Q?M=FCller?= 
	<Tilo.Mueller@informatik.uni-erlangen.de>
Subject: [PATCH] crypto: twofish - add x86_64/avx assembler implementation
Message-ID: <20120528135424.GI17705@kronos.redsun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Provags-ID: V02:K0:JTd2wLz2+LrQ7TSlzE3yFeQk40WbmVBDjeNvf7bi9qX
 lT6jujiGQ5zOLYAHgkIHO9oJgeYdxPz+aP5t6rv/Rs7M0zK/mS
 rG2YLckvlZ6Lfamu2gAk7zpCJUd8DYqqiarvkhtEcsY36GfeRc
 CaM9L/tNR5uTjlXPxZwV4QTkzhvTuFMaeqXukcrWwzZkzkoXGF
 o+FjMsSY2CgAY/pDU/WG1JKzuZ8FoNjlk+LtrwfVv7gcCegAQe
 g9/P7q/TJ4nnBAgelar8yN2Mk/SGhnGLOHi7ZY+ARCZFpgy02t
 PQEURSY2/7GE1ps9wvaebsxYG6zie3+bbAJyX4AGp0U+Quh5l3
 No85vNyn9rxtDJeNSQr0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a x86_64/avx assembler implementation of the Twofish block
cipher. The implementation processes eight blocks in parallel (two 4 block
chunk AVX operations). The table-lookups are done in general-purpose registers.
For small blocksizes the 3way-parallel functions from the twofish-x86_64-3way
module are called. A good performance increase is provided for blocksizes
greater or equal to 128B.

Patch has been tested with tcrypt and automated filesystem tests.

Tcrypt benchmark results:

Intel Core i5-2500 CPU (fam:6, model:42, step:7)

twofish-avx-x86_64 vs. twofish-x86_64-3way
128bit key:                                             (lrw:256bit)    (xts:256bit)
size    ecb-enc ecb-dec cbc-enc cbc-dec ctr-enc ctr-dec lrw-enc lrw-dec xts-enc xts-dec
16B     0.96x   0.97x   1.00x   0.95x   0.97x   0.97x   0.96x   0.95x   0.95x   0.98x
64B     0.99x   0.99x   1.00x   0.99x   0.98x   0.98x   0.99x   0.98x   0.99x   0.98x
256B    1.20x   1.21x   1.00x   1.19x   1.15x   1.14x   1.19x   1.20x   1.18x   1.19x
1024B   1.29x   1.30x   1.00x   1.28x   1.23x   1.24x   1.26x   1.28x   1.26x   1.27x
8192B   1.31x   1.32x   1.00x   1.31x   1.25x   1.25x   1.28x   1.29x   1.28x   1.30x

256bit key:                                             (lrw:384bit)    (xts:512bit)
size    ecb-enc ecb-dec cbc-enc cbc-dec ctr-enc ctr-dec lrw-enc lrw-dec xts-enc xts-dec
16B     0.96x   0.96x   1.00x   0.96x   0.97x   0.98x   0.95x   0.95x   0.95x   0.96x
64B     1.00x   0.99x   1.00x   0.98x   0.98x   1.01x   0.98x   0.98x   0.98x   0.98x
256B    1.20x   1.21x   1.00x   1.21x   1.15x   1.15x   1.19x   1.20x   1.18x   1.19x
1024B   1.29x   1.30x   1.00x   1.28x   1.23x   1.23x   1.26x   1.27x   1.26x   1.27x
8192B   1.31x   1.33x   1.00x   1.31x   1.26x   1.26x   1.29x   1.29x   1.28x   1.30x

twofish-avx-x86_64 vs aes-asm (8kB block):
         128bit  256bit
ecb-enc  1.19x   1.63x
ecb-dec  1.18x   1.62x
cbc-enc  0.75x   1.03x
cbc-dec  1.23x   1.67x
ctr-enc  1.24x   1.65x
ctr-dec  1.24x   1.65x
lrw-enc  1.15x   1.53x
lrw-dec  1.14x   1.52x
xts-enc  1.16x   1.56x
xts-dec  1.16x   1.56x

Signed-off-by: Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
---
 arch/x86/crypto/Makefile                    |    2 +
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S |  302 ++++++++
 arch/x86/crypto/twofish_avx_glue.c          | 1086 +++++++++++++++++++++++++++
 arch/x86/crypto/twofish_glue_3way.c         |    2 +
 crypto/Kconfig                              |   24 +
 crypto/tcrypt.c                             |   23 +
 crypto/testmgr.c                            |   60 ++
 7 files changed, 1499 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/crypto/twofish-avx-x86_64-asm_64.S
 create mode 100644 arch/x86/crypto/twofish_avx_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index e191ac0..b02a73e 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_CRYPTO_CAMELLIA_X86_64) += camellia-x86_64.o
 obj-$(CONFIG_CRYPTO_BLOWFISH_X86_64) += blowfish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64_3WAY) += twofish-x86_64-3way.o
+obj-$(CONFIG_CRYPTO_TWOFISH_AVX_X86_64) += twofish-avx-x86_64.o
 obj-$(CONFIG_CRYPTO_SALSA20_X86_64) += salsa20-x86_64.o
 obj-$(CONFIG_CRYPTO_SERPENT_SSE2_X86_64) += serpent-sse2-x86_64.o
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
@@ -30,6 +31,7 @@ camellia-x86_64-y := camellia-x86_64-asm_64.o camellia_glue.o
 blowfish-x86_64-y := blowfish-x86_64-asm_64.o blowfish_glue.o
 twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_glue.o
 twofish-x86_64-3way-y := twofish-x86_64-asm_64-3way.o twofish_glue_3way.o
+twofish-avx-x86_64-y := twofish-avx-x86_64-asm_64.o twofish_avx_glue.o
 salsa20-x86_64-y := salsa20-x86_64-asm_64.o salsa20_glue.o
 serpent-sse2-x86_64-y := serpent-sse2-x86_64-asm_64.o serpent_sse2_glue.o
 
diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
new file mode 100644
index 0000000..daf070a
--- /dev/null
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
@@ -0,0 +1,302 @@
+/*
+ * Twofish Cipher 8-way parallel algorithm (AVX/x86_64)
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
+.file "twofish-avx-x86_64-asm_64.S"
+.text
+
+/* structure of crypto context */
+#define s0	0
+#define s1	1024
+#define s2	2048
+#define s3	3072
+#define w	4096
+#define k	4128
+
+/**********************************************************************
+  8-way AVX twofish
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
+#define RY %xmm9
+
+#define RK1 %xmm10
+#define RK2 %xmm11
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
+#define RGS1  %r8
+#define RGS1d %r8d
+#define RGS2  %r9
+#define RGS2d %r9d
+#define RGS3  %r10
+#define RGS3d %r10d
+
+
+#define lookup_32bit(t0, t1, t2, t3, src, dst) \
+	movb		src ## bl,        RID1b;     \
+	movb		src ## bh,        RID2b;     \
+	movl		t0(CTX, RID1, 4), dst ## d;  \
+	xorl		t1(CTX, RID2, 4), dst ## d;  \
+	shrq $16,	src;                         \
+	movb		src ## bl,        RID1b;     \
+	movb		src ## bh,        RID2b;     \
+	xorl		t2(CTX, RID1, 4), dst ## d;  \
+	xorl		t3(CTX, RID2, 4), dst ## d;
+
+#define G(a, x, t0, t1, t2, t3) \
+	vmovq		a,    RGI1;               \
+	vpsrldq $8,	a,    x;                  \
+	vmovq		x,    RGI2;               \
+	\
+	lookup_32bit(t0, t1, t2, t3, RGI1, RGS1); \
+	shrq $16,	RGI1;                     \
+	lookup_32bit(t0, t1, t2, t3, RGI1, RGS2); \
+	shlq $32,	RGS2;                     \
+	orq		RGS1, RGS2;               \
+	\
+	lookup_32bit(t0, t1, t2, t3, RGI2, RGS1); \
+	shrq $16,	RGI2;                     \
+	lookup_32bit(t0, t1, t2, t3, RGI2, RGS3); \
+	shlq $32,	RGS3;                     \
+	orq		RGS1, RGS3;               \
+	\
+	vmovq		RGS2, x;                  \
+	vpinsrq $1,	RGS3, x, x;
+
+#define encround(a, b, c, d, x, y) \
+	G(a, x, s0, s1, s2, s3);           \
+	G(b, y, s1, s2, s3, s0);           \
+	vpaddd			x, y,   x; \
+	vpaddd			y, x,   y; \
+	vpaddd			x, RK1, x; \
+	vpaddd			y, RK2, y; \
+	vpxor			x, c,   c; \
+	vpsrld $1,		c, x;      \
+	vpslld $(32 - 1),	c, c;      \
+	vpor			c, x,   c; \
+	vpslld $1,		d, x;      \
+	vpsrld $(32 - 1),	d, d;      \
+	vpor			d, x,   d; \
+	vpxor			d, y,   d;
+
+#define decround(a, b, c, d, x, y) \
+	G(a, x, s0, s1, s2, s3);           \
+	G(b, y, s1, s2, s3, s0);           \
+	vpaddd			x, y,   x; \
+	vpaddd			y, x,   y; \
+	vpaddd			y, RK2, y; \
+	vpxor			d, y,   d; \
+	vpsrld $1,		d, y;      \
+	vpslld $(32 - 1),	d, d;      \
+	vpor			d, y,   d; \
+	vpslld $1,		c, y;      \
+	vpsrld $(32 - 1),	c, c;      \
+	vpor			c, y,   c; \
+	vpaddd			x, RK1, x; \
+	vpxor			x, c,   c;
+
+#define encrypt_round(n, a, b, c, d) \
+	vbroadcastss (k+4*(2*(n)))(CTX),   RK1;           \
+	vbroadcastss (k+4*(2*(n)+1))(CTX), RK2;           \
+	encround(a ## 1, b ## 1, c ## 1, d ## 1, RX, RY); \
+	encround(a ## 2, b ## 2, c ## 2, d ## 2, RX, RY);
+
+#define decrypt_round(n, a, b, c, d) \
+	vbroadcastss (k+4*(2*(n)))(CTX),   RK1;           \
+	vbroadcastss (k+4*(2*(n)+1))(CTX), RK2;           \
+	decround(a ## 1, b ## 1, c ## 1, d ## 1, RX, RY); \
+	decround(a ## 2, b ## 2, c ## 2, d ## 2, RX, RY);
+
+#define encrypt_cycle(n) \
+	encrypt_round((2*n), RA, RB, RC, RD);       \
+	encrypt_round(((2*n) + 1), RC, RD, RA, RB);
+
+#define decrypt_cycle(n) \
+	decrypt_round(((2*n) + 1), RC, RD, RA, RB); \
+	decrypt_round((2*n), RA, RB, RC, RD);
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
+#define inpack_blocks(in, x0, x1, x2, x3, wkey, t0, t1, t2) \
+	vpxor (0*4*4)(in),	wkey, x0; \
+	vpxor (1*4*4)(in),	wkey, x1; \
+	vpxor (2*4*4)(in),	wkey, x2; \
+	vpxor (3*4*4)(in),	wkey, x3; \
+	\
+	transpose_4x4(x0, x1, x2, x3, t0, t1, t2)
+
+#define outunpack_blocks(out, x0, x1, x2, x3, wkey, t0, t1, t2) \
+	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
+	\
+	vpxor		x0, wkey, x0;     \
+	vmovdqu 	x0, (0*4*4)(out); \
+	vpxor		x1, wkey, x1;     \
+	vmovdqu		x1, (1*4*4)(out); \
+	vpxor		x2, wkey, x2;     \
+	vmovdqu		x2, (2*4*4)(out); \
+	vpxor		x3, wkey, x3;     \
+	vmovdqu		x3, (3*4*4)(out);
+
+#define outunpack_xor_blocks(out, x0, x1, x2, x3, wkey, t0, t1, t2) \
+	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
+	\
+	vpxor		x0, wkey, x0;         \
+	vpxor		(0*4*4)(out), x0, x0; \
+	vmovdqu 	x0, (0*4*4)(out);     \
+	vpxor		x1, wkey, x1;         \
+	vpxor		(1*4*4)(out), x1, x1; \
+	vmovdqu	        x1, (1*4*4)(out);     \
+	vpxor		x2, wkey, x2;         \
+	vpxor           (2*4*4)(out), x2, x2; \
+	vmovdqu		x2, (2*4*4)(out);     \
+	vpxor		x3, wkey, x3;         \
+	vpxor           (3*4*4)(out), x3, x3; \
+	vmovdqu		x3, (3*4*4)(out);
+
+.align 8
+.global __twofish_enc_blk_8way
+.type   __twofish_enc_blk_8way,@function;
+
+__twofish_enc_blk_8way:
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
+	vmovdqu w(CTX), RK1;
+
+	leaq (4*4*4)(%rdx), %rax;
+	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RK1, RX, RY, RK2);
+	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RK1, RX, RY, RK2);
+
+	xorq RID1, RID1;
+	xorq RID2, RID2;
+
+	encrypt_cycle(0);
+	encrypt_cycle(1);
+	encrypt_cycle(2);
+	encrypt_cycle(3);
+	encrypt_cycle(4);
+	encrypt_cycle(5);
+	encrypt_cycle(6);
+	encrypt_cycle(7);
+
+	vmovdqu (w+4*4)(CTX), RK1;
+
+	popq %rcx;
+	popq %rbx;
+
+	leaq (4*4*4)(%rsi), %rax;
+	leaq (4*4*4)(%rax), %rdx;
+
+	testb %cl, %cl;
+	jnz __enc_xor8;
+
+	outunpack_blocks(%rsi, RC1, RD1, RA1, RB1, RK1, RX, RY, RK2);
+	outunpack_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX, RY, RK2);
+
+	ret;
+
+__enc_xor8:
+	outunpack_xor_blocks(%rsi, RC1, RD1, RA1, RB1, RK1, RX, RY, RK2);
+	outunpack_xor_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX, RY, RK2);
+
+	ret;
+
+.align 8
+.global twofish_dec_blk_8way
+.type   twofish_dec_blk_8way,@function;
+
+twofish_dec_blk_8way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	pushq %rbx;
+
+	vmovdqu (w+4*4)(CTX), RK1;
+
+	leaq (4*4*4)(%rdx), %rax;
+	inpack_blocks(%rdx, RC1, RD1, RA1, RB1, RK1, RX, RY, RK2);
+	inpack_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX, RY, RK2);
+
+	xorq RID1, RID1;
+	xorq RID2, RID2;
+
+	decrypt_cycle(7);
+	decrypt_cycle(6);
+	decrypt_cycle(5);
+	decrypt_cycle(4);
+	decrypt_cycle(3);
+	decrypt_cycle(2);
+	decrypt_cycle(1);
+	decrypt_cycle(0);
+
+	vmovdqu (w)(CTX), RK1;
+
+	popq %rbx;
+
+	leaq (4*4*4)(%rsi), %rax;
+	outunpack_blocks(%rsi, RA1, RB1, RC1, RD1, RK1, RX, RY, RK2);
+	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RK1, RX, RY, RK2);
+
+	ret;
+
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
new file mode 100644
index 0000000..599f19e
--- /dev/null
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -0,0 +1,1086 @@
+/*
+ * Glue Code for AVX assembler version of Twofish Cipher
+ *
+ * Copyright (C) 2012 Johannes Goetzfried
+ *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
+ *
+ * Glue code based on serpent_sse2_glue.c by:
+ *  Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
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
+#include <crypto/twofish.h>
+#include <crypto/cryptd.h>
+#include <crypto/b128ops.h>
+#include <crypto/ctr.h>
+#include <crypto/lrw.h>
+#include <crypto/xts.h>
+#include <asm/i387.h>
+#include <asm/xcr.h>
+#include <asm/xsave.h>
+#include <crypto/scatterwalk.h>
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+
+
+#define TWOFISH_PARALLEL_BLOCKS 8
+
+/* regular block cipher functions from twofish_x86_64 module */
+asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
+				const u8 *src);
+asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
+				const u8 *src);
+
+/* 3-way parallel cipher functions from twofish_x86_64-3way module */
+asmlinkage void __twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
+				       const u8 *src, bool xor);
+asmlinkage void twofish_dec_blk_3way(struct twofish_ctx *ctx, u8 *dst,
+				     const u8 *src);
+
+static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
+					const u8 *src)
+{
+	__twofish_enc_blk_3way(ctx, dst, src, false);
+}
+
+static inline void twofish_enc_blk_3way_xor(struct twofish_ctx *ctx, u8 *dst,
+					    const u8 *src)
+{
+	__twofish_enc_blk_3way(ctx, dst, src, true);
+}
+
+/* 8-way parallel cipher functions */
+asmlinkage void __twofish_enc_blk_8way(struct twofish_ctx *ctx, u8 *dst,
+				       const u8 *src, bool xor);
+asmlinkage void twofish_dec_blk_8way(struct twofish_ctx *ctx, u8 *dst,
+				     const u8 *src);
+
+static inline void twofish_enc_blk_xway(struct twofish_ctx *ctx, u8 *dst,
+					const u8 *src)
+{
+	__twofish_enc_blk_8way(ctx, dst, src, false);
+}
+
+static inline void twofish_enc_blk_xway_xor(struct twofish_ctx *ctx, u8 *dst,
+					    const u8 *src)
+{
+	__twofish_enc_blk_8way(ctx, dst, src, true);
+}
+
+static inline void twofish_dec_blk_xway(struct twofish_ctx *ctx, u8 *dst,
+					const u8 *src)
+{
+	twofish_dec_blk_8way(ctx, dst, src);
+}
+
+
+
+struct async_twofish_ctx {
+	struct cryptd_ablkcipher *cryptd_tfm;
+};
+
+static inline bool twofish_fpu_begin(bool fpu_enabled, unsigned int nbytes)
+{
+	if (fpu_enabled)
+		return true;
+
+	/* AVX is only used when chunk to be processed is large enough, so
+	 * do not enable FPU until it is necessary.
+	 */
+	if (nbytes < TF_BLOCK_SIZE * TWOFISH_PARALLEL_BLOCKS)
+		return false;
+
+	kernel_fpu_begin();
+	return true;
+}
+
+static inline void twofish_fpu_end(bool fpu_enabled)
+{
+	if (fpu_enabled)
+		kernel_fpu_end();
+}
+
+static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
+		     bool enc)
+{
+	bool fpu_enabled = false;
+	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = TF_BLOCK_SIZE;
+	unsigned int nbytes;
+	int err;
+
+	err = blkcipher_walk_virt(desc, walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	while ((nbytes = walk->nbytes)) {
+		u8 *wsrc = walk->src.virt.addr;
+		u8 *wdst = walk->dst.virt.addr;
+
+		fpu_enabled = twofish_fpu_begin(fpu_enabled, nbytes);
+
+		/* Process multi-block batch */
+		if (nbytes >= bsize * TWOFISH_PARALLEL_BLOCKS) {
+			do {
+				if (enc)
+					twofish_enc_blk_xway(ctx, wdst, wsrc);
+				else
+					twofish_dec_blk_xway(ctx, wdst, wsrc);
+
+				wsrc += bsize * TWOFISH_PARALLEL_BLOCKS;
+				wdst += bsize * TWOFISH_PARALLEL_BLOCKS;
+				nbytes -= bsize * TWOFISH_PARALLEL_BLOCKS;
+			} while (nbytes >= bsize * TWOFISH_PARALLEL_BLOCKS);
+
+			if (nbytes < bsize)
+				goto done;
+		}
+
+		/* Process three block batch */
+		if (nbytes >= bsize * 3) {
+			do {
+				if (enc)
+					twofish_enc_blk_3way(ctx, wdst, wsrc);
+				else
+					twofish_dec_blk_3way(ctx, wdst, wsrc);
+
+				wsrc += bsize * 3;
+				wdst += bsize * 3;
+				nbytes -= bsize * 3;
+			} while (nbytes >= bsize * 3);
+
+			if (nbytes < bsize)
+				goto done;
+		}
+
+		/* Handle leftovers */
+		do {
+			if (enc)
+				twofish_enc_blk(ctx, wdst, wsrc);
+			else
+				twofish_dec_blk(ctx, wdst, wsrc);
+
+			wsrc += bsize;
+			wdst += bsize;
+			nbytes -= bsize;
+		} while (nbytes >= bsize);
+
+done:
+		err = blkcipher_walk_done(desc, walk, nbytes);
+	}
+
+	twofish_fpu_end(fpu_enabled);
+	return err;
+}
+
+static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ecb_crypt(desc, &walk, true);
+}
+
+static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ecb_crypt(desc, &walk, false);
+}
+
+static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
+				  struct blkcipher_walk *walk)
+{
+	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = TF_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = (u128 *)walk->src.virt.addr;
+	u128 *dst = (u128 *)walk->dst.virt.addr;
+	u128 *iv = (u128 *)walk->iv;
+
+	do {
+		u128_xor(dst, src, iv);
+		twofish_enc_blk(ctx, (u8 *)dst, (u8 *)dst);
+		iv = dst;
+
+		src += 1;
+		dst += 1;
+		nbytes -= bsize;
+	} while (nbytes >= bsize);
+
+	u128_xor((u128 *)walk->iv, (u128 *)walk->iv, iv);
+	return nbytes;
+}
+
+static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		nbytes = __cbc_encrypt(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static unsigned int __cbc_decrypt(struct blkcipher_desc *desc,
+				  struct blkcipher_walk *walk)
+{
+	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = TF_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = (u128 *)walk->src.virt.addr;
+	u128 *dst = (u128 *)walk->dst.virt.addr;
+	u128 ivs[TWOFISH_PARALLEL_BLOCKS - 1];
+	u128 last_iv;
+	int i;
+
+	/* Start of the last block. */
+	src += nbytes / bsize - 1;
+	dst += nbytes / bsize - 1;
+
+	last_iv = *src;
+
+	/* Process multi-block batch */
+	if (nbytes >= bsize * TWOFISH_PARALLEL_BLOCKS) {
+		do {
+			nbytes -= bsize * (TWOFISH_PARALLEL_BLOCKS - 1);
+			src -= TWOFISH_PARALLEL_BLOCKS - 1;
+			dst -= TWOFISH_PARALLEL_BLOCKS - 1;
+
+			for (i = 0; i < TWOFISH_PARALLEL_BLOCKS - 1; i++)
+				ivs[i] = src[i];
+
+			twofish_dec_blk_xway(ctx, (u8 *)dst, (u8 *)src);
+
+			for (i = 0; i < TWOFISH_PARALLEL_BLOCKS - 1; i++)
+				u128_xor(dst + (i + 1), dst + (i + 1), ivs + i);
+
+			nbytes -= bsize;
+			if (nbytes < bsize)
+				goto done;
+
+			u128_xor(dst, dst, src - 1);
+			src -= 1;
+			dst -= 1;
+		} while (nbytes >= bsize * TWOFISH_PARALLEL_BLOCKS);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Process three block batch */
+	if (nbytes >= bsize * 3) {
+		do {
+			nbytes -= bsize * (3 - 1);
+			src -= 3 - 1;
+			dst -= 3 - 1;
+
+			ivs[0] = src[0];
+			ivs[1] = src[1];
+
+			twofish_dec_blk_3way(ctx, (u8 *)dst, (u8 *)src);
+
+			u128_xor(dst + 1, dst + 1, ivs + 0);
+			u128_xor(dst + 2, dst + 2, ivs + 1);
+
+			nbytes -= bsize;
+			if (nbytes < bsize)
+				goto done;
+
+			u128_xor(dst, dst, src - 1);
+			src -= 1;
+			dst -= 1;
+		} while (nbytes >= bsize * 3);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Handle leftovers */
+	for (;;) {
+		twofish_dec_blk(ctx, (u8 *)dst, (u8 *)src);
+
+		nbytes -= bsize;
+		if (nbytes < bsize)
+			break;
+
+		u128_xor(dst, dst, src - 1);
+		src -= 1;
+		dst -= 1;
+	}
+
+done:
+	u128_xor(dst, dst, (u128 *)walk->iv);
+	*(u128 *)walk->iv = last_iv;
+
+	return nbytes;
+}
+
+static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	bool fpu_enabled = false;
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	while ((nbytes = walk.nbytes)) {
+		fpu_enabled = twofish_fpu_begin(fpu_enabled, nbytes);
+		nbytes = __cbc_decrypt(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	twofish_fpu_end(fpu_enabled);
+	return err;
+}
+
+static inline void u128_to_be128(be128 *dst, const u128 *src)
+{
+	dst->a = cpu_to_be64(src->a);
+	dst->b = cpu_to_be64(src->b);
+}
+
+static inline void be128_to_u128(u128 *dst, const be128 *src)
+{
+	dst->a = be64_to_cpu(src->a);
+	dst->b = be64_to_cpu(src->b);
+}
+
+static inline void u128_inc(u128 *i)
+{
+	i->b++;
+	if (!i->b)
+		i->a++;
+}
+
+static void ctr_crypt_final(struct blkcipher_desc *desc,
+			    struct blkcipher_walk *walk)
+{
+	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	u8 *ctrblk = walk->iv;
+	u8 keystream[TF_BLOCK_SIZE];
+	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
+	unsigned int nbytes = walk->nbytes;
+
+	twofish_enc_blk(ctx, keystream, ctrblk);
+	crypto_xor(keystream, src, nbytes);
+	memcpy(dst, keystream, nbytes);
+
+	crypto_inc(ctrblk, TF_BLOCK_SIZE);
+}
+
+static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
+				struct blkcipher_walk *walk)
+{
+	struct twofish_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = TF_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = (u128 *)walk->src.virt.addr;
+	u128 *dst = (u128 *)walk->dst.virt.addr;
+	u128 ctrblk;
+	be128 ctrblocks[TWOFISH_PARALLEL_BLOCKS];
+	int i;
+
+	be128_to_u128(&ctrblk, (be128 *)walk->iv);
+
+	/* Process multi-block batch */
+	if (nbytes >= bsize * TWOFISH_PARALLEL_BLOCKS) {
+		do {
+			/* create ctrblks for parallel encrypt */
+			for (i = 0; i < TWOFISH_PARALLEL_BLOCKS; i++) {
+				if (dst != src)
+					dst[i] = src[i];
+
+				u128_to_be128(&ctrblocks[i], &ctrblk);
+				u128_inc(&ctrblk);
+			}
+
+			twofish_enc_blk_xway_xor(ctx, (u8 *)dst,
+						 (u8 *)ctrblocks);
+
+			src += TWOFISH_PARALLEL_BLOCKS;
+			dst += TWOFISH_PARALLEL_BLOCKS;
+			nbytes -= bsize * TWOFISH_PARALLEL_BLOCKS;
+		} while (nbytes >= bsize * TWOFISH_PARALLEL_BLOCKS);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Process three block batch */
+	if (nbytes >= bsize * 3) {
+		do {
+			if (dst != src) {
+				dst[0] = src[0];
+				dst[1] = src[1];
+				dst[2] = src[2];
+			}
+
+			/* create ctrblks for parallel encrypt */
+			u128_to_be128(&ctrblocks[0], &ctrblk);
+			u128_inc(&ctrblk);
+			u128_to_be128(&ctrblocks[1], &ctrblk);
+			u128_inc(&ctrblk);
+			u128_to_be128(&ctrblocks[2], &ctrblk);
+			u128_inc(&ctrblk);
+
+			twofish_enc_blk_3way_xor(ctx, (u8 *)dst,
+						 (u8 *)ctrblocks);
+
+			src += 3;
+			dst += 3;
+			nbytes -= bsize * 3;
+		} while (nbytes >= bsize * 3);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Handle leftovers */
+	do {
+		if (dst != src)
+			*dst = *src;
+
+		u128_to_be128(&ctrblocks[0], &ctrblk);
+		u128_inc(&ctrblk);
+
+		twofish_enc_blk(ctx, (u8 *)ctrblocks, (u8 *)ctrblocks);
+		u128_xor(dst, dst, (u128 *)ctrblocks);
+
+		src += 1;
+		dst += 1;
+		nbytes -= bsize;
+	} while (nbytes >= bsize);
+
+done:
+	u128_to_be128((be128 *)walk->iv, &ctrblk);
+	return nbytes;
+}
+
+static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		     struct scatterlist *src, unsigned int nbytes)
+{
+	bool fpu_enabled = false;
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt_block(desc, &walk, TF_BLOCK_SIZE);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	while ((nbytes = walk.nbytes) >= TF_BLOCK_SIZE) {
+		fpu_enabled = twofish_fpu_begin(fpu_enabled, nbytes);
+		nbytes = __ctr_crypt(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	twofish_fpu_end(fpu_enabled);
+
+	if (walk.nbytes) {
+		ctr_crypt_final(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, 0);
+	}
+
+	return err;
+}
+
+struct crypt_priv {
+	struct twofish_ctx *ctx;
+	bool fpu_enabled;
+};
+
+static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
+{
+	const unsigned int bsize = TF_BLOCK_SIZE;
+	struct crypt_priv *ctx = priv;
+	int i;
+
+	ctx->fpu_enabled = twofish_fpu_begin(ctx->fpu_enabled, nbytes);
+
+	if (nbytes == bsize * TWOFISH_PARALLEL_BLOCKS) {
+		twofish_enc_blk_xway(ctx->ctx, srcdst, srcdst);
+		return;
+	}
+
+	for (i = 0; i < nbytes / (bsize * 3); i++, srcdst += bsize * 3)
+		twofish_enc_blk_3way(ctx->ctx, srcdst, srcdst);
+
+	nbytes %= bsize * 3;
+
+	for (i = 0; i < nbytes / bsize; i++, srcdst += bsize)
+		twofish_enc_blk(ctx->ctx, srcdst, srcdst);
+}
+
+static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
+{
+	const unsigned int bsize = TF_BLOCK_SIZE;
+	struct crypt_priv *ctx = priv;
+	int i;
+
+	ctx->fpu_enabled = twofish_fpu_begin(ctx->fpu_enabled, nbytes);
+
+	if (nbytes == bsize * TWOFISH_PARALLEL_BLOCKS) {
+		twofish_dec_blk_xway(ctx->ctx, srcdst, srcdst);
+		return;
+	}
+
+	for (i = 0; i < nbytes / (bsize * 3); i++, srcdst += bsize * 3)
+		twofish_dec_blk_3way(ctx->ctx, srcdst, srcdst);
+
+	nbytes %= bsize * 3;
+
+	for (i = 0; i < nbytes / bsize; i++, srcdst += bsize)
+		twofish_dec_blk(ctx->ctx, srcdst, srcdst);
+}
+
+struct twofish_lrw_ctx {
+	struct lrw_table_ctx lrw_table;
+	struct twofish_ctx twofish_ctx;
+};
+
+static int lrw_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct twofish_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
+	int err;
+
+	err = __twofish_setkey(&ctx->twofish_ctx, key,
+				keylen - TF_BLOCK_SIZE, &tfm->crt_flags);
+	if (err)
+		return err;
+
+	return lrw_init_table(&ctx->lrw_table, key + keylen -
+						TF_BLOCK_SIZE);
+}
+
+static int lrw_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct twofish_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[TWOFISH_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->twofish_ctx,
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
+	twofish_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static int lrw_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct twofish_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[TWOFISH_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->twofish_ctx,
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
+	twofish_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static void lrw_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct twofish_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	lrw_free_table(&ctx->lrw_table);
+}
+
+struct twofish_xts_ctx {
+	struct twofish_ctx tweak_ctx;
+	struct twofish_ctx crypt_ctx;
+};
+
+static int xts_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct twofish_xts_ctx *ctx = crypto_tfm_ctx(tfm);
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
+	err = __twofish_setkey(&ctx->crypt_ctx, key, keylen / 2, flags);
+	if (err)
+		return err;
+
+	/* second half of xts-key is for tweak */
+	return __twofish_setkey(&ctx->tweak_ctx,
+				key + keylen / 2, keylen / 2, flags);
+}
+
+static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct twofish_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[TWOFISH_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->crypt_ctx,
+		.fpu_enabled = false,
+	};
+	struct xts_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.tweak_ctx = &ctx->tweak_ctx,
+		.tweak_fn = XTS_TWEAK_CAST(twofish_enc_blk),
+		.crypt_ctx = &crypt_ctx,
+		.crypt_fn = encrypt_callback,
+	};
+	int ret;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	ret = xts_crypt(desc, dst, src, nbytes, &req);
+	twofish_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct twofish_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[TWOFISH_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->crypt_ctx,
+		.fpu_enabled = false,
+	};
+	struct xts_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.tweak_ctx = &ctx->tweak_ctx,
+		.tweak_fn = XTS_TWEAK_CAST(twofish_enc_blk),
+		.crypt_ctx = &crypt_ctx,
+		.crypt_fn = decrypt_callback,
+	};
+	int ret;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	ret = xts_crypt(desc, dst, src, nbytes, &req);
+	twofish_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
+			unsigned int key_len)
+{
+	struct async_twofish_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct crypto_ablkcipher *child = &ctx->cryptd_tfm->base;
+	int err;
+
+	crypto_ablkcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_ablkcipher_set_flags(child, crypto_ablkcipher_get_flags(tfm)
+				    & CRYPTO_TFM_REQ_MASK);
+	err = crypto_ablkcipher_setkey(child, key, key_len);
+	crypto_ablkcipher_set_flags(tfm, crypto_ablkcipher_get_flags(child)
+				    & CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static int __ablk_encrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct async_twofish_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct blkcipher_desc desc;
+
+	desc.tfm = cryptd_ablkcipher_child(ctx->cryptd_tfm);
+	desc.info = req->info;
+	desc.flags = 0;
+
+	return crypto_blkcipher_crt(desc.tfm)->encrypt(
+		&desc, req->dst, req->src, req->nbytes);
+}
+
+static int ablk_encrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct async_twofish_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+
+	if (!irq_fpu_usable()) {
+		struct ablkcipher_request *cryptd_req =
+			ablkcipher_request_ctx(req);
+
+		memcpy(cryptd_req, req, sizeof(*req));
+		ablkcipher_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
+
+		return crypto_ablkcipher_encrypt(cryptd_req);
+	} else {
+		return __ablk_encrypt(req);
+	}
+}
+
+static int ablk_decrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct async_twofish_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+
+	if (!irq_fpu_usable()) {
+		struct ablkcipher_request *cryptd_req =
+			ablkcipher_request_ctx(req);
+
+		memcpy(cryptd_req, req, sizeof(*req));
+		ablkcipher_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
+
+		return crypto_ablkcipher_decrypt(cryptd_req);
+	} else {
+		struct blkcipher_desc desc;
+
+		desc.tfm = cryptd_ablkcipher_child(ctx->cryptd_tfm);
+		desc.info = req->info;
+		desc.flags = 0;
+
+		return crypto_blkcipher_crt(desc.tfm)->decrypt(
+			&desc, req->dst, req->src, req->nbytes);
+	}
+}
+
+static void ablk_exit(struct crypto_tfm *tfm)
+{
+	struct async_twofish_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	cryptd_free_ablkcipher(ctx->cryptd_tfm);
+}
+
+static int ablk_init(struct crypto_tfm *tfm)
+{
+	struct async_twofish_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct cryptd_ablkcipher *cryptd_tfm;
+	char drv_name[CRYPTO_MAX_ALG_NAME];
+
+	snprintf(drv_name, sizeof(drv_name), "__driver-%s",
+					crypto_tfm_alg_driver_name(tfm));
+
+	cryptd_tfm = cryptd_alloc_ablkcipher(drv_name, 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+
+	ctx->cryptd_tfm = cryptd_tfm;
+	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
+		crypto_ablkcipher_reqsize(&cryptd_tfm->base);
+
+	return 0;
+}
+
+static struct crypto_alg twofish_algs[10] = { {
+	.cra_name		= "__ecb-twofish-avx",
+	.cra_driver_name	= "__driver-ecb-twofish-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(twofish_algs[0].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.setkey		= twofish_setkey,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__cbc-twofish-avx",
+	.cra_driver_name	= "__driver-cbc-twofish-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(twofish_algs[1].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.setkey		= twofish_setkey,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__ctr-twofish-avx",
+	.cra_driver_name	= "__driver-ctr-twofish-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(twofish_algs[2].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= twofish_setkey,
+			.encrypt	= ctr_crypt,
+			.decrypt	= ctr_crypt,
+		},
+	},
+}, {
+	.cra_name		= "__lrw-twofish-avx",
+	.cra_driver_name	= "__driver-lrw-twofish-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_lrw_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(twofish_algs[3].cra_list),
+	.cra_exit		= lrw_exit_tfm,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE +
+					  TF_BLOCK_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE +
+					  TF_BLOCK_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= lrw_twofish_setkey,
+			.encrypt	= lrw_encrypt,
+			.decrypt	= lrw_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__xts-twofish-avx",
+	.cra_driver_name	= "__driver-xts-twofish-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_xts_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(twofish_algs[4].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE * 2,
+			.max_keysize	= TF_MAX_KEY_SIZE * 2,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= xts_twofish_setkey,
+			.encrypt	= xts_encrypt,
+			.decrypt	= xts_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "ecb(twofish)",
+	.cra_driver_name	= "ecb-twofish-avx",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(twofish_algs[5].cra_list),
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "cbc(twofish)",
+	.cra_driver_name	= "cbc-twofish-avx",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(twofish_algs[6].cra_list),
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= __ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "ctr(twofish)",
+	.cra_driver_name	= "ctr-twofish-avx",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct async_twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(twofish_algs[7].cra_list),
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_encrypt,
+			.geniv		= "chainiv",
+		},
+	},
+}, {
+	.cra_name		= "lrw(twofish)",
+	.cra_driver_name	= "lrw-twofish-avx",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(twofish_algs[8].cra_list),
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE +
+					  TF_BLOCK_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE +
+					  TF_BLOCK_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "xts(twofish)",
+	.cra_driver_name	= "xts-twofish-avx",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_twofish_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(twofish_algs[9].cra_list),
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE * 2,
+			.max_keysize	= TF_MAX_KEY_SIZE * 2,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+} };
+
+static int __init twofish_init(void)
+{
+	u64 xcr0;
+
+	if (!cpu_has_avx || !cpu_has_osxsave) {
+		printk(KERN_INFO "AVX instructions are not detected.\n");
+		return -ENODEV;
+	}
+
+	xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
+	if ((xcr0 & (XSTATE_SSE | XSTATE_YMM)) != (XSTATE_SSE | XSTATE_YMM)) {
+		printk(KERN_INFO "AVX detected but unusable.\n");
+		return -ENODEV;
+	}
+
+	return crypto_register_algs(twofish_algs, ARRAY_SIZE(twofish_algs));
+}
+
+static void __exit twofish_exit(void)
+{
+	crypto_unregister_algs(twofish_algs, ARRAY_SIZE(twofish_algs));
+}
+
+module_init(twofish_init);
+module_exit(twofish_exit);
+
+MODULE_DESCRIPTION("Twofish Cipher Algorithm, AVX optimized");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("twofish");
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 922ab24..77e4e55 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -45,8 +45,10 @@ asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
 /* 3-way parallel cipher functions */
 asmlinkage void __twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
 				       const u8 *src, bool xor);
+EXPORT_SYMBOL_GPL(__twofish_enc_blk_3way);
 asmlinkage void twofish_dec_blk_3way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src);
+EXPORT_SYMBOL_GPL(twofish_dec_blk_3way);
 
 static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
 					const u8 *src)
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8e84225..e00a4e4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -913,6 +913,30 @@ config CRYPTO_TWOFISH_X86_64_3WAY
 	  See also:
 	  <http://www.schneier.com/twofish.html>
 
+config CRYPTO_TWOFISH_AVX_X86_64
+	tristate "Twofish cipher algorithm (x86_64/AVX)"
+	depends on X86 && 64BIT
+	select CRYPTO_ALGAPI
+	select CRYPTO_CRYPTD
+	select CRYPTO_TWOFISH_COMMON
+	select CRYPTO_TWOFISH_X86_64
+	select CRYPTO_TWOFISH_X86_64_3WAY
+	select CRYPTO_LRW
+	select CRYPTO_XTS
+	help
+	  Twofish cipher algorithm (x86_64/AVX).
+
+	  Twofish was submitted as an AES (Advanced Encryption Standard)
+	  candidate cipher by researchers at CounterPane Systems.  It is a
+	  16 round block cipher supporting key sizes of 128, 192, and 256
+	  bits.
+
+	  This module provides the Twofish cipher algorithm that processes
+	  eight blocks parallel using the AVX Instruction Set.
+
+	  See also:
+	  <http://www.schneier.com/twofish.html>
+
 comment "Compression"
 
 config CRYPTO_DEFLATE
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 8f147bf..69b6fb1 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1563,6 +1563,29 @@ static int do_test(int m)
 				   speed_template_32_64);
 		break;
 
+	case 504:
+		test_acipher_speed("ecb(twofish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("ecb(twofish)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("cbc(twofish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("cbc(twofish)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("ctr(twofish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("ctr(twofish)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("lrw(twofish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_40_48);
+		test_acipher_speed("lrw(twofish)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_40_48);
+		test_acipher_speed("xts(twofish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_48_64);
+		test_acipher_speed("xts(twofish)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_48_64);
+		break;
+
 	case 1000:
 		test_available();
 		break;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5674878..29aadd8 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1549,6 +1549,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "__cbc-twofish-avx",
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
 		.alg = "__driver-cbc-aes-aesni",
 		.test = alg_test_null,
 		.suite = {
@@ -1579,6 +1594,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "__driver-cbc-twofish-avx",
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
 		.alg = "__driver-ecb-aes-aesni",
 		.test = alg_test_null,
 		.suite = {
@@ -1609,6 +1639,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "__driver-ecb-twofish-avx",
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
 		.alg = "__ghash-pclmulqdqni",
 		.test = alg_test_null,
 		.suite = {
@@ -1806,6 +1851,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "cryptd(__driver-ecb-twofish-avx)",
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
 		.alg = "cryptd(__ghash-pclmulqdqni)",
 		.test = alg_test_null,
 		.suite = {
-- 
1.7.2.5

