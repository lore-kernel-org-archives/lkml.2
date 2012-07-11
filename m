Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab2GKRhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 13:37:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65017 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab2GKRhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 13:37:42 -0400
Date: Wed, 11 Jul 2012 19:37:37 +0200
From: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo Mueller <tilo.mueller@informatik.uni-erlangen.de>
Subject: [PATCH 3/6] crypto: cast5 - add x86_64/avx assembler implementation
Message-ID: <12709467413e5203c750482d9aed7a6c525c5f7c.1342027375.git.johannes@goetzfried-amberg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1342027375.git.johannes@goetzfried-amberg.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Provags-ID: V02:K0:WewALgorHvTG6ZESDiy2oVxvPSyTcEIMZ7qyp6LDGg3
 NuZfpVOv8HiH5nAME0FPFVUu+jlLd8yZVYC9KHZKFAaKLCs+Ft
 KUC33g1A/QPG3Vvu2XvrRzfF+DRjDQZfJmE1YSyoBZ6U8fxn5h
 ZkHi3PX1uQFVVvT6gDwVEQEzMnlxdJSncoBPsliOwSuy9S7Pvo
 EU3e1bxm4wB7GvX8azr6tSxsEft2ExubcIOmke3ZEok+Ffjn5Y
 MVTVWMz6bCiROfAYDSmIEjj6v68nEEKad1BrGCwNQS8rzlBc5m
 iVjVqri7lBZNcsqcNx/DIpuaDZWeQEWgjceK9i8Gr7L6c82r9j
 w3vhnRiJ8/93MhGUul2xy4Ziyb9WH+M8Ap0DzTlYZyyuiUPG2L
 4d37DmbBu7QlmEZp0vTDC63wLCAzMkf9GpGaRsBE6eXCPm9gzA
 bkAox
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a x86_64/avx assembler implementation of the Cast5 block
cipher. The implementation processes sixteen blocks in parallel (four 4 block
chunk AVX operations). The table-lookups are done in general-purpose registers.
For small blocksizes the functions from the generic module are called. A good
performance increase is provided for blocksizes greater or equal to 128B.

Patch has been tested with tcrypt and automated filesystem tests.

Tcrypt benchmark results:

Intel Core i5-2500 CPU (fam:6, model:42, step:7)

cast5-avx-x86_64 vs. cast5-generic
64bit key:
size    ecb-enc ecb-dec cbc-enc cbc-dec ctr-enc ctr-dec
16B     0.99x   0.99x   1.00x   1.00x   1.02x   1.01x
64B     1.00x   1.00x   0.98x   1.00x   1.01x   1.02x
256B    2.03x   2.01x   0.95x   2.11x   2.12x   2.13x
1024B   2.30x   2.24x   0.95x   2.29x   2.35x   2.35x
8192B   2.31x   2.27x   0.95x   2.31x   2.39x   2.39x

128bit key:
size    ecb-enc ecb-dec cbc-enc cbc-dec ctr-enc ctr-dec
16B     0.99x   0.99x   1.00x   1.00x   1.01x   1.01x
64B     1.00x   1.00x   0.98x   1.01x   1.02x   1.01x
256B    2.17x   2.13x   0.96x   2.19x   2.19x   2.19x
1024B   2.29x   2.32x   0.95x   2.34x   2.37x   2.38x
8192B   2.35x   2.32x   0.95x   2.35x   2.39x   2.39x

Signed-off-by: Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
---
 arch/x86/crypto/Makefile                  |    2 +
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S |  323 ++++++++++++++++++
 arch/x86/crypto/cast5_avx_glue.c          |  530 +++++++++++++++++++++++++++++
 crypto/Kconfig                            |   14 +
 crypto/testmgr.c                          |   60 ++++
 5 files changed, 929 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/crypto/cast5-avx-x86_64-asm_64.S
 create mode 100644 arch/x86/crypto/cast5_avx_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index e908e5d..565e82b 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_CRYPTO_SERPENT_SSE2_586) += serpent-sse2-i586.o
 
 obj-$(CONFIG_CRYPTO_AES_X86_64) += aes-x86_64.o
 obj-$(CONFIG_CRYPTO_CAMELLIA_X86_64) += camellia-x86_64.o
+obj-$(CONFIG_CRYPTO_CAST5_AVX_X86_64) += cast5-avx-x86_64.o
 obj-$(CONFIG_CRYPTO_BLOWFISH_X86_64) += blowfish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64_3WAY) += twofish-x86_64-3way.o
@@ -32,6 +33,7 @@ serpent-sse2-i586-y := serpent-sse2-i586-asm_32.o serpent_sse2_glue.o
 
 aes-x86_64-y := aes-x86_64-asm_64.o aes_glue.o
 camellia-x86_64-y := camellia-x86_64-asm_64.o camellia_glue.o
+cast5-avx-x86_64-y := cast5-avx-x86_64-asm_64.o cast5_avx_glue.o
 blowfish-x86_64-y := blowfish-x86_64-asm_64.o blowfish_glue.o
 twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_glue.o
 twofish-x86_64-3way-y := twofish-x86_64-asm_64-3way.o twofish_glue_3way.o
diff --git a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
new file mode 100644
index 0000000..df06735
--- /dev/null
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
@@ -0,0 +1,323 @@
+/*
+ * Cast5 Cipher 16-way parallel algorithm (AVX/x86_64)
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
+.file "cast5-avx-x86_64-asm_64.S"
+.text
+
+.extern cast5_s1
+.extern cast5_s2
+.extern cast5_s3
+.extern cast5_s4
+
+/* structure of crypto context */
+#define km	0
+#define kr	(16*4)
+#define rr	((16*4)+16)
+
+/* s-boxes */
+#define s1	cast5_s1
+#define s2	cast5_s2
+#define s3	cast5_s3
+#define s4	cast5_s4
+
+/**********************************************************************
+  16-way AVX cast5
+ **********************************************************************/
+#define CTX %rdi
+
+#define RL1 %xmm0
+#define RR1 %xmm1
+#define RL2 %xmm2
+#define RR2 %xmm3
+#define RL3 %xmm4
+#define RR3 %xmm5
+#define RL4 %xmm6
+#define RR4 %xmm7
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
+#define subround(a, b, x, n, f) \
+	F ## f(b, x);  \
+	vpxor a, x, a;
+
+#define round(l, r, n, f) \
+	vbroadcastss 	(km+(4*n))(CTX), RKM;        \
+	vpinsrb $0,	(kr+n)(CTX),     RKRF, RKRF; \
+	vpsubq		RKRF,            R32,  RKRR; \
+	subround(l ## 1, r ## 1, RX, n, f);          \
+	subround(l ## 2, r ## 2, RX, n, f);          \
+	subround(l ## 3, r ## 3, RX, n, f);          \
+	subround(l ## 4, r ## 4, RX, n, f);
+
+
+#define transpose_2x4(x0, x1, t0, t1) \
+	vpunpckldq		x1, x0, t0; \
+	vpunpckhdq		x1, x0, t1; \
+	\
+	vpunpcklqdq		t1, t0, x0; \
+	vpunpckhqdq		t1, t0, x1;
+
+#define inpack_blocks(in, x0, x1, t0, t1) \
+	vmovdqu (0*4*4)(in),	x0; \
+	vmovdqu (1*4*4)(in),	x1; \
+	vpshufb RMASK, x0,	x0; \
+	vpshufb RMASK, x1,	x1; \
+	\
+	transpose_2x4(x0, x1, t0, t1)
+
+#define outunpack_blocks(out, x0, x1, t0, t1) \
+	transpose_2x4(x0, x1, t0, t1) \
+	\
+	vpshufb RMASK,	x0, x0;           \
+	vpshufb RMASK,	x1, x1;           \
+	vmovdqu 	x0, (0*4*4)(out); \
+	vmovdqu		x1, (1*4*4)(out);
+
+#define outunpack_xor_blocks(out, x0, x1, t0, t1) \
+	transpose_2x4(x0, x1, t0, t1) \
+	\
+	vpshufb RMASK,	x0, x0;               \
+	vpshufb RMASK,	x1, x1;               \
+	vpxor		(0*4*4)(out), x0, x0; \
+	vmovdqu 	x0, (0*4*4)(out);     \
+	vpxor		(1*4*4)(out), x1, x1; \
+	vmovdqu	        x1, (1*4*4)(out);
+
+.align 16
+.Lbswap_mask:
+	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
+.L32_mask:
+	.byte 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0
+
+.align 16
+.global __cast5_enc_blk_16way
+.type   __cast5_enc_blk_16way,@function;
+
+__cast5_enc_blk_16way:
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
+	inpack_blocks(%rdx, RL1, RR1, RTMP, RX);
+	leaq (2*4*4)(%rdx), %rax;
+	inpack_blocks(%rax, RL2, RR2, RTMP, RX);
+	leaq (2*4*4)(%rax), %rax;
+	inpack_blocks(%rax, RL3, RR3, RTMP, RX);
+	leaq (2*4*4)(%rax), %rax;
+	inpack_blocks(%rax, RL4, RR4, RTMP, RX);
+
+	xorq RID1, RID1;
+	xorq RID2, RID2;
+
+	round(RL, RR, 0, 1);
+	round(RR, RL, 1, 2);
+	round(RL, RR, 2, 3);
+	round(RR, RL, 3, 1);
+	round(RL, RR, 4, 2);
+	round(RR, RL, 5, 3);
+	round(RL, RR, 6, 1);
+	round(RR, RL, 7, 2);
+	round(RL, RR, 8, 3);
+	round(RR, RL, 9, 1);
+	round(RL, RR, 10, 2);
+	round(RR, RL, 11, 3);
+
+	movb rr(CTX), %al;
+	testb %al, %al;
+	jnz __skip_enc;
+
+	round(RL, RR, 12, 1);
+	round(RR, RL, 13, 2);
+	round(RL, RR, 14, 3);
+	round(RR, RL, 15, 1);
+
+__skip_enc:
+	popq %rcx;
+	popq %rbx;
+
+	testb %cl, %cl;
+	jnz __enc_xor16;
+
+	outunpack_blocks(%rsi, RR1, RL1, RTMP, RX);
+	leaq (2*4*4)(%rsi), %rax;
+	outunpack_blocks(%rax, RR2, RL2, RTMP, RX);
+	leaq (2*4*4)(%rax), %rax;
+	outunpack_blocks(%rax, RR3, RL3, RTMP, RX);
+	leaq (2*4*4)(%rax), %rax;
+	outunpack_blocks(%rax, RR4, RL4, RTMP, RX);
+
+	ret;
+
+__enc_xor16:
+	outunpack_xor_blocks(%rsi, RR1, RL1, RTMP, RX);
+	leaq (2*4*4)(%rsi), %rax;
+	outunpack_xor_blocks(%rax, RR2, RL2, RTMP, RX);
+	leaq (2*4*4)(%rax), %rax;
+	outunpack_xor_blocks(%rax, RR3, RL3, RTMP, RX);
+	leaq (2*4*4)(%rax), %rax;
+	outunpack_xor_blocks(%rax, RR4, RL4, RTMP, RX);
+
+	ret;
+
+.align 16
+.global cast5_dec_blk_16way
+.type   cast5_dec_blk_16way,@function;
+
+cast5_dec_blk_16way:
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
+	inpack_blocks(%rdx, RL1, RR1, RTMP, RX);
+	leaq (2*4*4)(%rdx), %rax;
+	inpack_blocks(%rax, RL2, RR2, RTMP, RX);
+	leaq (2*4*4)(%rax), %rax;
+	inpack_blocks(%rax, RL3, RR3, RTMP, RX);
+	leaq (2*4*4)(%rax), %rax;
+	inpack_blocks(%rax, RL4, RR4, RTMP, RX);
+
+	xorq RID1, RID1;
+	xorq RID2, RID2;
+
+	movb rr(CTX), %al;
+	testb %al, %al;
+	jnz __skip_dec;
+
+	round(RL, RR, 15, 1);
+	round(RR, RL, 14, 3);
+	round(RL, RR, 13, 2);
+	round(RR, RL, 12, 1);
+
+__skip_dec:
+	round(RL, RR, 11, 3);
+	round(RR, RL, 10, 2);
+	round(RL, RR, 9, 1);
+	round(RR, RL, 8, 3);
+	round(RL, RR, 7, 2);
+	round(RR, RL, 6, 1);
+	round(RL, RR, 5, 3);
+	round(RR, RL, 4, 2);
+	round(RL, RR, 3, 1);
+	round(RR, RL, 2, 3);
+	round(RL, RR, 1, 2);
+	round(RR, RL, 0, 1);
+
+	popq %rbx;
+
+	outunpack_blocks(%rsi, RR1, RL1, RTMP, RX);
+	leaq (2*4*4)(%rsi), %rax;
+	outunpack_blocks(%rax, RR2, RL2, RTMP, RX);
+	leaq (2*4*4)(%rax), %rax;
+	outunpack_blocks(%rax, RR3, RL3, RTMP, RX);
+	leaq (2*4*4)(%rax), %rax;
+	outunpack_blocks(%rax, RR4, RL4, RTMP, RX);
+
+	ret;
+
diff --git a/arch/x86/crypto/cast5_avx_glue.c b/arch/x86/crypto/cast5_avx_glue.c
new file mode 100644
index 0000000..445aab0
--- /dev/null
+++ b/arch/x86/crypto/cast5_avx_glue.c
@@ -0,0 +1,530 @@
+/*
+ * Glue Code for the AVX assembler implemention of the Cast5 Cipher
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
+#include <crypto/cast5.h>
+#include <crypto/cryptd.h>
+#include <crypto/ctr.h>
+#include <asm/xcr.h>
+#include <asm/xsave.h>
+#include <asm/crypto/ablk_helper.h>
+#include <asm/crypto/glue_helper.h>
+
+#define CAST5_PARALLEL_BLOCKS 16
+
+asmlinkage void __cast5_enc_blk_16way(struct cast5_ctx *ctx, u8 *dst,
+				      const u8 *src, bool xor);
+asmlinkage void cast5_dec_blk_16way(struct cast5_ctx *ctx, u8 *dst,
+				    const u8 *src);
+
+static inline void cast5_enc_blk_xway(struct cast5_ctx *ctx, u8 *dst,
+				      const u8 *src)
+{
+	__cast5_enc_blk_16way(ctx, dst, src, false);
+}
+
+static inline void cast5_enc_blk_xway_xor(struct cast5_ctx *ctx, u8 *dst,
+					  const u8 *src)
+{
+	__cast5_enc_blk_16way(ctx, dst, src, true);
+}
+
+static inline void cast5_dec_blk_xway(struct cast5_ctx *ctx, u8 *dst,
+				      const u8 *src)
+{
+	cast5_dec_blk_16way(ctx, dst, src);
+}
+
+
+static inline bool cast5_fpu_begin(bool fpu_enabled, unsigned int nbytes)
+{
+	return glue_fpu_begin(CAST5_BLOCK_SIZE, CAST5_PARALLEL_BLOCKS,
+			      NULL, fpu_enabled, nbytes);
+}
+
+static inline void cast5_fpu_end(bool fpu_enabled)
+{
+	return glue_fpu_end(fpu_enabled);
+}
+
+static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
+		     bool enc)
+{
+	bool fpu_enabled = false;
+	struct cast5_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = CAST5_BLOCK_SIZE;
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
+		fpu_enabled = cast5_fpu_begin(fpu_enabled, nbytes);
+
+		/* Process multi-block batch */
+		if (nbytes >= bsize * CAST5_PARALLEL_BLOCKS) {
+			do {
+				if (enc)
+					cast5_enc_blk_xway(ctx, wdst, wsrc);
+				else
+					cast5_dec_blk_xway(ctx, wdst, wsrc);
+
+				wsrc += bsize * CAST5_PARALLEL_BLOCKS;
+				wdst += bsize * CAST5_PARALLEL_BLOCKS;
+				nbytes -= bsize * CAST5_PARALLEL_BLOCKS;
+			} while (nbytes >= bsize * CAST5_PARALLEL_BLOCKS);
+
+			if (nbytes < bsize)
+				goto done;
+		}
+
+		/* Handle leftovers */
+		do {
+			if (enc)
+				__cast5_encrypt(ctx, wdst, wsrc);
+			else
+				__cast5_decrypt(ctx, wdst, wsrc);
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
+	cast5_fpu_end(fpu_enabled);
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
+	struct cast5_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = CAST5_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u64 *src = (u64 *)walk->src.virt.addr;
+	u64 *dst = (u64 *)walk->dst.virt.addr;
+	u64 *iv = (u64 *)walk->iv;
+
+	do {
+		*dst = *src ^ *iv;
+		__cast5_encrypt(ctx, (u8 *)dst, (u8 *)dst);
+		iv = dst;
+
+		src += 1;
+		dst += 1;
+		nbytes -= bsize;
+	} while (nbytes >= bsize);
+
+	*(u64 *)walk->iv ^= *iv;
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
+	struct cast5_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = CAST5_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u64 *src = (u64 *)walk->src.virt.addr;
+	u64 *dst = (u64 *)walk->dst.virt.addr;
+	u64 ivs[CAST5_PARALLEL_BLOCKS - 1];
+	u64 last_iv;
+	int i;
+
+	/* Start of the last block. */
+	src += nbytes / bsize - 1;
+	dst += nbytes / bsize - 1;
+
+	last_iv = *src;
+
+	/* Process multi-block batch */
+	if (nbytes >= bsize * CAST5_PARALLEL_BLOCKS) {
+		do {
+			nbytes -= bsize * (CAST5_PARALLEL_BLOCKS - 1);
+			src -= CAST5_PARALLEL_BLOCKS - 1;
+			dst -= CAST5_PARALLEL_BLOCKS - 1;
+
+			for (i = 0; i < CAST5_PARALLEL_BLOCKS - 1; i++)
+				ivs[i] = src[i];
+
+			cast5_dec_blk_xway(ctx, (u8 *)dst, (u8 *)src);
+
+			for (i = 0; i < CAST5_PARALLEL_BLOCKS - 1; i++)
+				*(dst + (i + 1)) ^= *(ivs + i);
+
+			nbytes -= bsize;
+			if (nbytes < bsize)
+				goto done;
+
+			*dst ^= *(src - 1);
+			src -= 1;
+			dst -= 1;
+		} while (nbytes >= bsize * CAST5_PARALLEL_BLOCKS);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Handle leftovers */
+	for (;;) {
+		__cast5_decrypt(ctx, (u8 *)dst, (u8 *)src);
+
+		nbytes -= bsize;
+		if (nbytes < bsize)
+			break;
+
+		*dst ^= *(src - 1);
+		src -= 1;
+		dst -= 1;
+	}
+
+done:
+	*dst ^= *(u64 *)walk->iv;
+	*(u64 *)walk->iv = last_iv;
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
+		fpu_enabled = cast5_fpu_begin(fpu_enabled, nbytes);
+		nbytes = __cbc_decrypt(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	cast5_fpu_end(fpu_enabled);
+	return err;
+}
+
+static void ctr_crypt_final(struct blkcipher_desc *desc,
+			    struct blkcipher_walk *walk)
+{
+	struct cast5_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	u8 *ctrblk = walk->iv;
+	u8 keystream[CAST5_BLOCK_SIZE];
+	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
+	unsigned int nbytes = walk->nbytes;
+
+	__cast5_encrypt(ctx, keystream, ctrblk);
+	crypto_xor(keystream, src, nbytes);
+	memcpy(dst, keystream, nbytes);
+
+	crypto_inc(ctrblk, CAST5_BLOCK_SIZE);
+}
+
+static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
+				struct blkcipher_walk *walk)
+{
+	struct cast5_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = CAST5_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u64 *src = (u64 *)walk->src.virt.addr;
+	u64 *dst = (u64 *)walk->dst.virt.addr;
+	u64 ctrblk = be64_to_cpu(*(__be64 *)walk->iv);
+	__be64 ctrblocks[CAST5_PARALLEL_BLOCKS];
+	int i;
+
+	/* Process multi-block batch */
+	if (nbytes >= bsize * CAST5_PARALLEL_BLOCKS) {
+		do {
+			/* create ctrblks for parallel encrypt */
+			for (i = 0; i < CAST5_PARALLEL_BLOCKS; i++) {
+				if (dst != src)
+					dst[i] = src[i];
+
+				ctrblocks[i] = cpu_to_be64(ctrblk++);
+			}
+
+			cast5_enc_blk_xway_xor(ctx, (u8 *)dst,
+					       (u8 *)ctrblocks);
+
+			src += CAST5_PARALLEL_BLOCKS;
+			dst += CAST5_PARALLEL_BLOCKS;
+			nbytes -= bsize * CAST5_PARALLEL_BLOCKS;
+		} while (nbytes >= bsize * CAST5_PARALLEL_BLOCKS);
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
+		ctrblocks[0] = cpu_to_be64(ctrblk++);
+
+		__cast5_encrypt(ctx, (u8 *)ctrblocks, (u8 *)ctrblocks);
+		*dst ^= ctrblocks[0];
+
+		src += 1;
+		dst += 1;
+		nbytes -= bsize;
+	} while (nbytes >= bsize);
+
+done:
+	*(__be64 *)walk->iv = cpu_to_be64(ctrblk);
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
+	err = blkcipher_walk_virt_block(desc, &walk, CAST5_BLOCK_SIZE);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	while ((nbytes = walk.nbytes) >= CAST5_BLOCK_SIZE) {
+		fpu_enabled = cast5_fpu_begin(fpu_enabled, nbytes);
+		nbytes = __ctr_crypt(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	cast5_fpu_end(fpu_enabled);
+
+	if (walk.nbytes) {
+		ctr_crypt_final(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, 0);
+	}
+
+	return err;
+}
+
+
+static struct crypto_alg cast5_algs[6] = { {
+	.cra_name		= "__ecb-cast5-avx",
+	.cra_driver_name	= "__driver-ecb-cast5-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= CAST5_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct cast5_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= CAST5_MIN_KEY_SIZE,
+			.max_keysize	= CAST5_MAX_KEY_SIZE,
+			.setkey		= cast5_setkey,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__cbc-cast5-avx",
+	.cra_driver_name	= "__driver-cbc-cast5-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= CAST5_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct cast5_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= CAST5_MIN_KEY_SIZE,
+			.max_keysize	= CAST5_MAX_KEY_SIZE,
+			.setkey		= cast5_setkey,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__ctr-cast5-avx",
+	.cra_driver_name	= "__driver-ctr-cast5-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct cast5_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= CAST5_MIN_KEY_SIZE,
+			.max_keysize	= CAST5_MAX_KEY_SIZE,
+			.ivsize		= CAST5_BLOCK_SIZE,
+			.setkey		= cast5_setkey,
+			.encrypt	= ctr_crypt,
+			.decrypt	= ctr_crypt,
+		},
+	},
+}, {
+	.cra_name		= "ecb(cast5)",
+	.cra_driver_name	= "ecb-cast5-avx",
+	.cra_priority		= 200,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= CAST5_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= CAST5_MIN_KEY_SIZE,
+			.max_keysize	= CAST5_MAX_KEY_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "cbc(cast5)",
+	.cra_driver_name	= "cbc-cast5-avx",
+	.cra_priority		= 200,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= CAST5_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_helper_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= CAST5_MIN_KEY_SIZE,
+			.max_keysize	= CAST5_MAX_KEY_SIZE,
+			.ivsize		= CAST5_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= __ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "ctr(cast5)",
+	.cra_driver_name	= "ctr-cast5-avx",
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
+			.min_keysize	= CAST5_MIN_KEY_SIZE,
+			.max_keysize	= CAST5_MAX_KEY_SIZE,
+			.ivsize		= CAST5_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_encrypt,
+			.geniv		= "chainiv",
+		},
+	},
+} };
+
+static int __init cast5_init(void)
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
+	return crypto_register_algs(cast5_algs, ARRAY_SIZE(cast5_algs));
+}
+
+static void __exit cast5_exit(void)
+{
+	crypto_unregister_algs(cast5_algs, ARRAY_SIZE(cast5_algs));
+}
+
+module_init(cast5_init);
+module_exit(cast5_exit);
+
+MODULE_DESCRIPTION("Cast5 Cipher Algorithm, AVX optimized");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("cast5");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index a323805..cda97fc 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -692,6 +692,20 @@ config CRYPTO_CAST5
 	  The CAST5 encryption algorithm (synonymous with CAST-128) is
 	  described in RFC2144.
 
+config CRYPTO_CAST5_AVX_X86_64
+	tristate "CAST5 (CAST-128) cipher algorithm (x86_64/AVX)"
+	depends on X86 && 64BIT
+	select CRYPTO_ALGAPI
+	select CRYPTO_CRYPTD
+	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_CAST5
+	help
+	  The CAST5 encryption algorithm (synonymous with CAST-128) is
+	  described in RFC2144.
+
+	  This module provides the Cast5 cipher algorithm that processes
+	  sixteen blocks parallel using the AVX instruction set.
+
 config CRYPTO_CAST6
 	tristate "CAST6 (CAST-256) cipher algorithm"
 	select CRYPTO_ALGAPI
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 7a91e54..def0f43 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1534,6 +1534,21 @@ static int alg_test_null(const struct alg_test_desc *desc,
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
 	{
+		.alg = "__cbc-cast5-avx",
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
@@ -1595,6 +1610,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "__driver-cbc-cast5-avx",
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
@@ -1656,6 +1686,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "__driver-ecb-cast5-avx",
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
@@ -1952,6 +1997,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "cryptd(__driver-ecb-cast5-avx)",
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

