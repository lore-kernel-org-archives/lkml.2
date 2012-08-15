Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2HORed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:34:33 -0400
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:34042 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab2HOReb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:34:31 -0400
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler implementation
To: Borislav Petkov <bp@alien8.de>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?utf-8?q?M=C3=BCller?= 
	<tilo.mueller@informatik.uni-erlangen.de>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Wed, 15 Aug 2012 20:34:25 +0300
Message-ID: <20120815172653.31045.42867.stgit@localhost6.localdomain6>
In-Reply-To: <20120815140331.GB4103@x1.osrc.amd.com>
References: <20120815140331.GB4103@x1.osrc.amd.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Borislav Petkov <bp@alien8.de>:

> On Wed, Aug 15, 2012 at 05:22:03PM +0300, Jussi Kivilinna wrote:
>
>> Patch replaces 'movb' instructions with 'movzbl' to break false
>> register dependencies and interleaves instructions better for
>> out-of-order scheduling.
>>
>> Also move common round code to separate function to reduce object
>> size.
>
> Ok, redid the first test
>

Thanks.

> $ modprobe twofish-avx-x86_64
> $ modprobe tcrypt mode=504 sec=1
>
> and from quickly juxtaposing the two results, I'd say the patch makes
> things slightly worse but you'd need to run your scripts on it to get
> the accurate results:
>

About ~5% slower, probably because I was tuning for sandy-bridge and introduced
more FPU<=>CPU register moves.

Here's new version of patch, with FPU<=>CPU moves from original implementation.

(Note: also changes encryption function to inline all code in to main function,
decryption still places common code to separate function to reduce object size.
This is to measure the difference.)

-Jussi

---
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S |  124 +++++++++++++++++----------
 1 file changed, 77 insertions(+), 47 deletions(-)

diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
index 35f4557..d331ab8 100644
--- a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
@@ -47,15 +47,22 @@
 #define RC2 %xmm6
 #define RD2 %xmm7
 
-#define RX %xmm8
-#define RY %xmm9
+#define RX0 %xmm8
+#define RY0 %xmm9
 
-#define RK1 %xmm10
-#define RK2 %xmm11
+#define RX1 %xmm10
+#define RY1 %xmm11
+
+#define RK1 %xmm12
+#define RK2 %xmm13
+
+#define RT %xmm14
 
 #define RID1  %rax
+#define RID1d %eax
 #define RID1b %al
 #define RID2  %rbx
+#define RID2d %ebx
 #define RID2b %bl
 
 #define RGI1   %rdx
@@ -73,40 +80,48 @@
 #define RGS3d %r10d
 
 
-#define lookup_32bit(t0, t1, t2, t3, src, dst) \
-	movb		src ## bl,        RID1b;     \
-	movb		src ## bh,        RID2b;     \
+#define lookup_32bit(t0, t1, t2, t3, src, dst, interleave_op, il_reg) \
+	movzbl		src ## bl,        RID1d;     \
+	movzbl		src ## bh,        RID2d;     \
+	shrq $16,	src;                         \
 	movl		t0(CTX, RID1, 4), dst ## d;  \
 	xorl		t1(CTX, RID2, 4), dst ## d;  \
-	shrq $16,	src;                         \
-	movb		src ## bl,        RID1b;     \
-	movb		src ## bh,        RID2b;     \
+	movzbl		src ## bl,        RID1d;     \
+	movzbl		src ## bh,        RID2d;     \
+	interleave_op(il_reg);			     \
 	xorl		t2(CTX, RID1, 4), dst ## d;  \
 	xorl		t3(CTX, RID2, 4), dst ## d;
 
+#define dummy(d) /* do nothing */
+
+#define shr_next(reg) \
+	shrq $16,	reg;
+
 #define G(a, x, t0, t1, t2, t3) \
-	vmovq		a,    RGI1;               \
-	vpsrldq $8,	a,    x;                  \
-	vmovq		x,    RGI2;               \
+	vmovq		a, RGI1;                  \
+	vpextrq $1,	a, RGI2;                  \
 	\
-	lookup_32bit(t0, t1, t2, t3, RGI1, RGS1); \
-	shrq $16,	RGI1;                     \
-	lookup_32bit(t0, t1, t2, t3, RGI1, RGS2); \
+	lookup_32bit(t0, t1, t2, t3, RGI1, RGS1, shr_next, RGI1); \
+	lookup_32bit(t0, t1, t2, t3, RGI1, RGS2, dummy, none); \
 	shlq $32,	RGS2;                     \
 	orq		RGS1, RGS2;               \
 	\
-	lookup_32bit(t0, t1, t2, t3, RGI2, RGS1); \
-	shrq $16,	RGI2;                     \
-	lookup_32bit(t0, t1, t2, t3, RGI2, RGS3); \
-	shlq $32,	RGS3;                     \
+	lookup_32bit(t0, t1, t2, t3, RGI2, RGS3, shr_next, RGI2); \
+	lookup_32bit(t0, t1, t2, t3, RGI2, RGS1, dummy, none); \
+	shlq $32,	RGS1;                     \
 	orq		RGS1, RGS3;               \
 	\
 	vmovq		RGS2, x;                  \
 	vpinsrq $1,	RGS3, x, x;
 
-#define encround(a, b, c, d, x, y) \
-	G(a, x, s0, s1, s2, s3);           \
-	G(b, y, s1, s2, s3, s0);           \
+#define encround_g1g2(a, b, c, d, x, y) \
+	G(a, x, s0, s1, s2, s3); \
+	G(b, y, s1, s2, s3, s0);
+
+#define encround_end(a, b, c, d, x, y) \
+	vpslld $1,		d, RT;     \
+	vpsrld $(32 - 1),	d, d;      \
+	vpor			d, RT,  d; \
 	vpaddd			x, y,   x; \
 	vpaddd			y, x,   y; \
 	vpaddd			x, RK1, x; \
@@ -115,14 +130,16 @@
 	vpsrld $1,		c, x;      \
 	vpslld $(32 - 1),	c, c;      \
 	vpor			c, x,   c; \
-	vpslld $1,		d, x;      \
-	vpsrld $(32 - 1),	d, d;      \
-	vpor			d, x,   d; \
 	vpxor			d, y,   d;
 
-#define decround(a, b, c, d, x, y) \
-	G(a, x, s0, s1, s2, s3);           \
-	G(b, y, s1, s2, s3, s0);           \
+#define decround_g1g2(a, b, c, d, x, y) \
+	G(a, x, s0, s1, s2, s3); \
+	G(b, y, s1, s2, s3, s0);
+
+#define decround_end(a, b, c, d, x, y) \
+	vpslld $1,		c, RT;     \
+	vpsrld $(32 - 1),	c, c;      \
+	vpor			c, RT,  c; \
 	vpaddd			x, y,   x; \
 	vpaddd			y, x,   y; \
 	vpaddd			y, RK2, y; \
@@ -130,23 +147,37 @@
 	vpsrld $1,		d, y;      \
 	vpslld $(32 - 1),	d, d;      \
 	vpor			d, y,   d; \
-	vpslld $1,		c, y;      \
-	vpsrld $(32 - 1),	c, c;      \
-	vpor			c, y,   c; \
 	vpaddd			x, RK1, x; \
 	vpxor			x, c,   c;
 
 #define encrypt_round(n, a, b, c, d) \
 	vbroadcastss (k+4*(2*(n)))(CTX),   RK1;           \
 	vbroadcastss (k+4*(2*(n)+1))(CTX), RK2;           \
-	encround(a ## 1, b ## 1, c ## 1, d ## 1, RX, RY); \
-	encround(a ## 2, b ## 2, c ## 2, d ## 2, RX, RY);
+	encround_g1g2(a ## 1, b ## 1, c ## 1, d ## 1, RX0, RY0); \
+	encround_g1g2(a ## 2, b ## 2, c ## 2, d ## 2, RX1, RY1); \
+	encround_end(a ## 1, b ## 1, c ## 1, d ## 1, RX0, RY0); \
+	encround_end(a ## 2, b ## 2, c ## 2, d ## 2, RX1, RY1);
+
+.align 4
+decround_RARBRCRD:
+	decround_g1g2(RA1, RB1, RC1, RD1, RX0, RY0);
+	decround_g1g2(RA2, RB2, RC2, RD2, RX1, RY1);
+	decround_end(RA1, RB1, RC1, RD1, RX0, RY0);
+	decround_end(RA2, RB2, RC2, RD2, RX1, RY1);
+	ret;
+
+.align 4
+decround_RCRDRARB:
+	decround_g1g2(RC1, RD1, RA1, RB1, RX0, RY0);
+	decround_g1g2(RC2, RD2, RA2, RB2, RX1, RY1);
+	decround_end(RC1, RD1, RA1, RB1, RX0, RY0);
+	decround_end(RC2, RD2, RA2, RB2, RX1, RY1);
+	ret;
 
 #define decrypt_round(n, a, b, c, d) \
 	vbroadcastss (k+4*(2*(n)))(CTX),   RK1;           \
 	vbroadcastss (k+4*(2*(n)+1))(CTX), RK2;           \
-	decround(a ## 1, b ## 1, c ## 1, d ## 1, RX, RY); \
-	decround(a ## 2, b ## 2, c ## 2, d ## 2, RX, RY);
+	call decround_ ## a ## b ## c ## d;
 
 #define encrypt_cycle(n) \
 	encrypt_round((2*n), RA, RB, RC, RD);       \
@@ -156,7 +187,6 @@
 	decrypt_round(((2*n) + 1), RC, RD, RA, RB); \
 	decrypt_round((2*n), RA, RB, RC, RD);
 
-
 #define transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
 	vpunpckldq		x1, x0, t0; \
 	vpunpckhdq		x1, x0, t2; \
@@ -222,8 +252,8 @@ __twofish_enc_blk_8way:
 	vmovdqu w(CTX), RK1;
 
 	leaq (4*4*4)(%rdx), %rax;
-	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RK1, RX, RY, RK2);
-	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RK1, RX, RY, RK2);
+	inpack_blocks(%rdx, RA1, RB1, RC1, RD1, RK1, RX0, RY0, RK2);
+	inpack_blocks(%rax, RA2, RB2, RC2, RD2, RK1, RX0, RY0, RK2);
 
 	xorq RID1, RID1;
 	xorq RID2, RID2;
@@ -247,14 +277,14 @@ __twofish_enc_blk_8way:
 	testb %cl, %cl;
 	jnz __enc_xor8;
 
-	outunpack_blocks(%rsi, RC1, RD1, RA1, RB1, RK1, RX, RY, RK2);
-	outunpack_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX, RY, RK2);
+	outunpack_blocks(%rsi, RC1, RD1, RA1, RB1, RK1, RX0, RY0, RK2);
+	outunpack_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX0, RY0, RK2);
 
 	ret;
 
 __enc_xor8:
-	outunpack_xor_blocks(%rsi, RC1, RD1, RA1, RB1, RK1, RX, RY, RK2);
-	outunpack_xor_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX, RY, RK2);
+	outunpack_xor_blocks(%rsi, RC1, RD1, RA1, RB1, RK1, RX0, RY0, RK2);
+	outunpack_xor_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX0, RY0, RK2);
 
 	ret;
 
@@ -274,8 +304,8 @@ twofish_dec_blk_8way:
 	vmovdqu (w+4*4)(CTX), RK1;
 
 	leaq (4*4*4)(%rdx), %rax;
-	inpack_blocks(%rdx, RC1, RD1, RA1, RB1, RK1, RX, RY, RK2);
-	inpack_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX, RY, RK2);
+	inpack_blocks(%rdx, RC1, RD1, RA1, RB1, RK1, RX0, RY0, RK2);
+	inpack_blocks(%rax, RC2, RD2, RA2, RB2, RK1, RX0, RY0, RK2);
 
 	xorq RID1, RID1;
 	xorq RID2, RID2;
@@ -294,7 +324,7 @@ twofish_dec_blk_8way:
 	popq %rbx;
 
 	leaq (4*4*4)(%rsi), %rax;
-	outunpack_blocks(%rsi, RA1, RB1, RC1, RD1, RK1, RX, RY, RK2);
-	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RK1, RX, RY, RK2);
+	outunpack_blocks(%rsi, RA1, RB1, RC1, RD1, RK1, RX0, RY0, RK2);
+	outunpack_blocks(%rax, RA2, RB2, RC2, RD2, RK1, RX0, RY0, RK2);
 
 	ret;

