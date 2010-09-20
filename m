Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab0ITLW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 07:22:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:56364 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab0ITLWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 07:22:54 -0400
Content-Type: multipart/mixed; boundary="===============0195476355=="
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,392,1280732400"; 
   d="p7s'?scan'208";a="839183740"
From: "Struk, Tadeusz" <tadeusz.struk@intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: "Hoban, Adrian" <adrian.hoban@intel.com>,
        "Paoloni, Gabriele" <gabriele.paoloni@intel.com>,
        "Struk, Tadeusz" <tadeusz.struk@intel.com>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 20 Sep 2010 12:21:54 +0100
Subject: RE: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Thread-Topic: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Thread-Index: ActYn3pqeAXUqw4BQ7mO33PPijXvsgAEnQ4A
Message-ID: <24483BA4C9F69C43A7379639D35543D7B6E12F4C@irsmsx502.ger.corp.intel.com>
References: <CFBC532374C38D45810FA00BC2D2C2040120CA815D@irsmsx502.ger.corp.intel.com>
	<20100920080752.GA972@gondor.apana.org.au>
 <AANLkTim_gVO2tHUw+vFC9vXRh8Dtv7N38HTCMUZ7LmNg@mail.gmail.com>
In-Reply-To: <AANLkTim_gVO2tHUw+vFC9vXRh8Dtv7N38HTCMUZ7LmNg@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0195476355==
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_007E_01CB58BE.69599460"

------=_NextPart_000_007E_01CB58BE.69599460
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello Herbert,
I've reworked the patch 2/3 and successfully applied all of them.
The problem was spaces at EOL.
Please find the reworked patch below.

>From 06444d8a95458d807ae14699e557739281d0b026 Mon Sep 17 00:00:00 2001
From: Adrian Hoban <ahoban@allen.ir.intel.com>
Date: Fri, 10 Sep 2010 18:08:45 +0100
Subject: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions

This patch adds an optimized RFC4106 AES-GCM implementation for 64-bit
kernels. It supports 128-bit AES key size. This leverages the crypto
AEAD interface type to facilitate a combined AES & GCM operation to
be implemented in assembly code. The assembly code leverages Intel(R)
AES New Instructions and the PCLMULQDQ instruction.

Signed-off-by: Adrian Hoban <adrian.hoban@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
Signed-off-by: Gabriele Paoloni <gabriele.paoloni@intel.com>
Signed-off-by: Aidan O'Mahony <aidan.o.mahony@intel.com>
Signed-off-by: Erdinc Ozturk <erdinc.ozturk@intel.com>
Signed-off-by: James Guilford <james.guilford@intel.com>
Signed-off-by: Wajdi Feghali <wajdi.k.feghali@intel.com>
---
 arch/x86/crypto/aesni-intel_asm.S  | 1112
+++++++++++++++++++++++++++++++++++-
 arch/x86/crypto/aesni-intel_glue.c |  518 +++++++++++++++++-
 2 files changed, 1627 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S
b/arch/x86/crypto/aesni-intel_asm.S
index ff16756..3950769 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -8,6 +8,17 @@
  *    Author: Huang Ying <ying.huang@intel.com>
  *            Vinodh Gopal <vinodh.gopal@intel.com>
  *            Kahraman Akdemir
+ *
+ * Added RFC4106 AES-GCM support for 128-bit keys under the AEAD
+ * interface for 64-bit kernels.
+ *    Authors: Erdinc Ozturk (erdinc.ozturk@intel.com)
+ *             Aidan O'Mahony (aidan.o.mahony@intel.com)
+ *             Adrian Hoban <adrian.hoban@intel.com>
+ *             James Guilford (james.guilford@intel.com)
+ *             Gabriele Paoloni <gabriele.paoloni@intel.com>
+ *             Tadeusz Struk (tadeusz.struk@intel.com)
+ *             Wajdi Feghali (wajdi.k.feghali@intel.com)
+ *    Copyright (c) 2010, Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -16,9 +27,50 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/inst.h>
+
+
+.data
+POLY:   .octa 0xC2000000000000000000000000000001
+TWOONE: .octa 0x00000001000000000000000000000001
+
+# order of these constants should not change.
+# more specifically, ALL_F should follow SHIFT_MASK, and ZERO should follow
ALL_F
+
+SHUF_MASK:  .octa 0x000102030405060708090A0B0C0D0E0F
+MASK1:      .octa 0x0000000000000000ffffffffffffffff
+MASK2:      .octa 0xffffffffffffffff0000000000000000
+SHIFT_MASK: .octa 0x0f0e0d0c0b0a09080706050403020100
+ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
+ZERO:       .octa 0x00000000000000000000000000000000
+ONE:        .octa 0x00000000000000000000000000000001
+F_MIN_MASK: .octa 0xf1f2f3f4f5f6f7f8f9fafbfcfdfeff0
+dec:        .octa 0x1
+enc:        .octa 0x2
+
 
 .text
+#define	STACK_OFFSET    8*3
+#define	HashKey		16*0	// store HashKey <<1 mod poly here
+#define	HashKey_2	16*1	// store HashKey^2 <<1 mod poly here
+#define	HashKey_3	16*2	// store HashKey^3 <<1 mod poly here
+#define	HashKey_4	16*3	// store HashKey^4 <<1 mod poly here
+#define	HashKey_k	16*4	// store XOR of High 64 bits and Low
64 bits of  HashKey <<1 mod poly here (for Karatsuba purposes)
+#define	HashKey_2_k	16*5	// store XOR of High 64 bits and Low
64 bits of  HashKey^2 <<1 mod poly here (for Karatsuba purposes)
+#define	HashKey_3_k	16*6	// store XOR of High 64 bits and Low
64 bits of  HashKey^3 <<1 mod poly here (for Karatsuba purposes)
+#define	HashKey_4_k	16*7	// store XOR of High 64 bits and Low
64 bits of  HashKey^4 <<1 mod poly here (for Karatsuba purposes)
+#define	VARIABLE_OFFSET	16*8
+
+#define arg1 rdi
+#define arg2 rsi
+#define arg3 rdx
+#define arg4 rcx
+#define arg5 r8
+#define arg6 r9
+#define arg7 STACK_OFFSET+8(%r14)
+#define arg8 STACK_OFFSET+16(%r14)
+#define arg9 STACK_OFFSET+24(%r14)
+#define arg10 STACK_OFFSET+32(%r14)
+
 
 #define STATE1	%xmm0
 #define STATE2	%xmm4
@@ -47,6 +99,1064 @@
 #define T2	%r11
 #define TCTR_LOW T2
 
+
+/* GHASH_MUL MACRO to implement: Data*HashKey mod (128,127,126,121,0)
+*
+*
+* Input: A and B (128-bits each, bit-reflected)
+* Output: C = A*B*x mod poly, (i.e. >>1 )
+* To compute GH = GH*HashKey mod poly, give HK = HashKey<<1 mod poly as
input
+* GH = GH * HK * x mod poly which is equivalent to GH*HashKey mod poly.
+*
+*/
+.macro	GHASH_MUL GH HK TMP1 TMP2 TMP3 TMP4 TMP5
+	movdqa	  \GH, \TMP1
+	pshufd	  $78, \GH, \TMP2
+	pshufd	  $78, \HK, \TMP3
+	pxor	  \GH, \TMP2            # TMP2 = a1+a0
+	pxor	  \HK, \TMP3            # TMP3 = b1+b0
+	pclmulqdq $0x11, \HK, \TMP1     # TMP1 = a1*b1
+	pclmulqdq $0x00, \HK, \GH       # GH = a0*b0
+	pclmulqdq $0x00, \TMP3, \TMP2   # TMP2 = (a0+a1)*(b1+b0)
+	pxor	  \GH, \TMP2
+	pxor	  \TMP1, \TMP2          # TMP2 = (a0*b0)+(a1*b0)
+	movdqa	  \TMP2, \TMP3
+	pslldq	  $8, \TMP3             # left shift TMP3 2 DWs
+	psrldq	  $8, \TMP2             # right shift TMP2 2 DWs
+	pxor	  \TMP3, \GH
+	pxor	  \TMP2, \TMP1          # TMP2:GH holds the result of GH*HK
+
+        # first phase of the reduction
+
+	movdqa    \GH, \TMP2
+	movdqa    \GH, \TMP3
+	movdqa    \GH, \TMP4            # copy GH into TMP2,TMP3 and TMP4 in
in order to perform independent shifts
+	pslld     $31, \TMP2            # packed right shift <<31
+	pslld     $30, \TMP3            # packed right shift <<30
+	pslld     $25, \TMP4            # packed right shift <<25
+	pxor      \TMP3, \TMP2          # xor the shifted versions
+	pxor      \TMP4, \TMP2
+	movdqa    \TMP2, \TMP5
+	psrldq    $4, \TMP5             # right shift TMP5 1 DW
+	pslldq    $12, \TMP2            # left shift TMP2 3 DWs
+	pxor      \TMP2, \GH
+
+        # second phase of the reduction
+
+	movdqa    \GH,\TMP2             # copy GH into TMP2,TMP3 and TMP4 in
in order to perform independent shifts
+	movdqa    \GH,\TMP3
+	movdqa    \GH,\TMP4
+	psrld     $1,\TMP2              # packed left shift >>1
+	psrld     $2,\TMP3              # packed left shift >>2
+	psrld     $7,\TMP4              # packed left shift >>7
+	pxor      \TMP3,\TMP2		# xor the shifted versions
+	pxor      \TMP4,\TMP2
+	pxor      \TMP5, \TMP2
+	pxor      \TMP2, \GH
+	pxor      \TMP1, \GH            # result is in TMP1
+.endm
+
+/*
+* if a = number of total plaintext bytes
+* b = floor(a/16)
+* num_initial_blocks = b mod 4
+* encrypt the initial num_initial_blocks blocks and apply ghash on the
ciphertext
+* %r10, %r11, %r12, %rax, %xmm5, %xmm6, %xmm7, %xmm8, %xmm9 registers are
clobbered
+* arg1, %arg2, %arg3, %r14 are used as a pointer only, not modified
+*/
+
+.macro INITIAL_BLOCKS num_initial_blocks TMP1 TMP2 TMP3 TMP4 TMP5 XMM0 XMM1
XMM2 XMM3 XMM4 XMMDst TMP6 TMP7 i i_seq operation
+
+	mov	   arg7, %r10           # %r10 = AAD
+	mov	   arg8, %r12           # %r12 = aadLen
+	mov	   %r12, %r11
+	pxor	   %xmm\i, %xmm\i
+_get_AAD_loop\num_initial_blocks\operation:
+	movd	   (%r10), \TMP1
+	pslldq	   $12, \TMP1
+	psrldq	   $4, %xmm\i
+	pxor	   \TMP1, %xmm\i
+	add	   $4, %r10
+	sub	   $4, %r12
+	jne	   _get_AAD_loop\num_initial_blocks\operation
+	cmp	   $16, %r11
+	je	   _get_AAD_loop2_done\num_initial_blocks\operation
+	mov	   $16, %r12
+_get_AAD_loop2\num_initial_blocks\operation:
+	psrldq	   $4, %xmm\i
+	sub	   $4, %r12
+	cmp	   %r11, %r12
+	jne	   _get_AAD_loop2\num_initial_blocks\operation
+_get_AAD_loop2_done\num_initial_blocks\operation:
+	pshufb	   SHUF_MASK(%rip), %xmm\i          # byte-reflect the AAD
data
+	xor	   %r11, %r11                       # initialise the data
pointer offset as zero
+
+
+        # start AES for num_initial_blocks blocks
+
+	mov	   %arg5, %rax                      # %rax = *Y0
+	movdqu	   (%rax), \XMM0                    # XMM0 = Y0
+	pshufb	   SHUF_MASK(%rip), \XMM0
+.if \i_seq != 0
+.irpc index, \i_seq
+	paddd	   ONE(%rip), \XMM0                 # INCR Y0
+	movdqa	   \XMM0, %xmm\index
+	pshufb	   SHUF_MASK(%rip), %xmm\index      # perform a 16 byte swap
+.endr
+.irpc index, \i_seq
+	pxor	   16*0(%arg1), %xmm\index
+.endr
+.irpc index, \i_seq
+	aesenc     16*1(%rdi), %xmm\index          # Round 1
+.endr
+.irpc index, \i_seq
+	aesenc     16*2(%arg1), %xmm\index          # Round 2
+.endr
+.irpc index, \i_seq
+	aesenc     16*3(%arg1), %xmm\index          # Round 3
+.endr
+.irpc index, \i_seq
+	aesenc     16*4(%arg1), %xmm\index          # Round 4
+.endr
+.irpc index, \i_seq
+	aesenc     16*5(%arg1), %xmm\index          # Round 5
+.endr
+.irpc index, \i_seq
+	aesenc     16*6(%arg1), %xmm\index          # Round 6
+.endr
+.irpc index, \i_seq
+	aesenc     16*7(%arg1), %xmm\index          # Round 7
+.endr
+.irpc index, \i_seq
+	aesenc     16*8(%arg1), %xmm\index          # Round 8
+.endr
+.irpc index, \i_seq
+	aesenc     16*9(%arg1), %xmm\index          # Round 9
+.endr
+.irpc index, \i_seq
+	aesenclast 16*10(%arg1), %xmm\index         # Round 10
+.endr
+.irpc index, \i_seq
+	movdqu	   (%arg3 , %r11, 1), \TMP1
+	pxor	   \TMP1, %xmm\index
+	movdqu	   %xmm\index, (%arg2 , %r11, 1)    # write back
plaintext/ciphertext for num_initial_blocks
+	add	   $16, %r11
+.if \operation == dec
+	movdqa     \TMP1, %xmm\index
+.endif
+	pshufb	   SHUF_MASK(%rip), %xmm\index      # prepare
plaintext/ciphertext for GHASH computation
+.endr
+.endif
+	GHASH_MUL  %xmm\i, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
+
+        # apply GHASH on num_initial_blocks blocks
+
+.if \i == 5
+        pxor       %xmm5, %xmm6
+	GHASH_MUL  %xmm6, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
+        pxor       %xmm6, %xmm7
+	GHASH_MUL  %xmm7, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
+        pxor       %xmm7, %xmm8
+	GHASH_MUL  %xmm8, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
+.elseif \i == 6
+        pxor       %xmm6, %xmm7
+	GHASH_MUL  %xmm7, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
+        pxor       %xmm7, %xmm8
+	GHASH_MUL  %xmm8, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
+.elseif \i == 7
+        pxor       %xmm7, %xmm8
+	GHASH_MUL  %xmm8, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
+.endif
+	cmp	   $64, %r13
+	jl	_initial_blocks_done\num_initial_blocks\operation   # no
need for precomputed values
+/*
+*
+* Precomputations for HashKey parallel with encryption of first 4 blocks.
+* Haskey_i_k holds XORed values of the low and high parts of the Haskey_i
+*/
+	paddd	   ONE(%rip), \XMM0              # INCR Y0
+	movdqa	   \XMM0, \XMM1
+	pshufb	   SHUF_MASK(%rip), \XMM1        # perform a 16 byte swap
+	paddd	   ONE(%rip), \XMM0              # INCR Y0
+	movdqa	   \XMM0, \XMM2
+	pshufb	   SHUF_MASK(%rip), \XMM2        # perform a 16 byte swap
+	paddd	   ONE(%rip), \XMM0              # INCR Y0
+	movdqa	   \XMM0, \XMM3
+	pshufb	   SHUF_MASK(%rip), \XMM3        # perform a 16 byte swap
+	paddd	   ONE(%rip), \XMM0              # INCR Y0
+	movdqa	   \XMM0, \XMM4
+	pshufb	   SHUF_MASK(%rip), \XMM4        # perform a 16 byte swap
+	pxor	   16*0(%arg1), \XMM1
+	pxor	   16*0(%arg1), \XMM2
+	pxor	   16*0(%arg1), \XMM3
+	pxor	   16*0(%arg1), \XMM4
+	movdqa	   \TMP3, \TMP5
+	pshufd	   $78, \TMP3, \TMP1
+	pxor	   \TMP3, \TMP1
+	movdqa	   \TMP1, HashKey_k(%rsp)
+	GHASH_MUL  \TMP5, \TMP3, \TMP1, \TMP2, \TMP4, \TMP6, \TMP7  # TMP5 =
HashKey^2<<1 (mod poly)
+	movdqa	   \TMP5, HashKey_2(%rsp)                           #
HashKey_2 = HashKey^2<<1 (mod poly)
+	pshufd	   $78, \TMP5, \TMP1
+	pxor	   \TMP5, \TMP1
+	movdqa	   \TMP1, HashKey_2_k(%rsp)
+.irpc index, 1234 # do 4 rounds
+	aesenc	   16*\index(%arg1), \XMM1
+	aesenc	   16*\index(%arg1), \XMM2
+	aesenc	   16*\index(%arg1), \XMM3
+	aesenc	   16*\index(%arg1), \XMM4
+.endr
+	GHASH_MUL  \TMP5, \TMP3, \TMP1, \TMP2, \TMP4, \TMP6, \TMP7  # TMP5 =
HashKey^3<<1 (mod poly)
+	movdqa	   \TMP5, HashKey_3(%rsp)
+	pshufd	   $78, \TMP5, \TMP1
+	pxor	   \TMP5, \TMP1
+	movdqa	   \TMP1, HashKey_3_k(%rsp)
+.irpc index, 56789 # do next 5 rounds
+	aesenc	   16*\index(%arg1), \XMM1
+	aesenc	   16*\index(%arg1), \XMM2
+	aesenc	   16*\index(%arg1), \XMM3
+	aesenc	   16*\index(%arg1), \XMM4
+.endr
+	GHASH_MUL  \TMP5, \TMP3, \TMP1, \TMP2, \TMP4, \TMP6, \TMP7  # TMP5 =
HashKey^3<<1 (mod poly)
+	movdqa	   \TMP5, HashKey_4(%rsp)
+	pshufd	   $78, \TMP5, \TMP1
+	pxor	   \TMP5, \TMP1
+	movdqa	   \TMP1, HashKey_4_k(%rsp)
+	aesenclast 160(%arg1), \XMM1
+	aesenclast 160(%arg1), \XMM2
+	aesenclast 160(%arg1), \XMM3
+	aesenclast 160(%arg1), \XMM4
+	movdqu	   16*0(%arg3 , %r11 , 1), \TMP1
+	pxor	   \TMP1, \XMM1
+.if \operation == dec
+	movdqu	   \XMM1, 16*0(%arg2 , %r11 , 1)
+	movdqa     \TMP1, \XMM1
+.endif
+	movdqu	   16*1(%arg3 , %r11 , 1), \TMP1
+	pxor	   \TMP1, \XMM2
+.if \operation == dec
+	movdqu	   \XMM2, 16*1(%arg2 , %r11 , 1)
+	movdqa     \TMP1, \XMM2
+.endif
+	movdqu	   16*2(%arg3 , %r11 , 1), \TMP1
+	pxor	   \TMP1, \XMM3
+.if \operation == dec
+	movdqu	   \XMM3, 16*2(%arg2 , %r11 , 1)
+	movdqa     \TMP1, \XMM3
+.endif
+	movdqu	   16*3(%arg3 , %r11 , 1), \TMP1
+	pxor	   \TMP1, \XMM4
+.if \operation == dec
+	movdqu	   \XMM4, 16*3(%arg2 , %r11 , 1)
+	movdqa     \TMP1, \XMM4
+.else
+	movdqu     \XMM1, 16*0(%arg2 , %r11 , 1)
+	movdqu     \XMM2, 16*1(%arg2 , %r11 , 1)
+	movdqu     \XMM3, 16*2(%arg2 , %r11 , 1)
+	movdqu     \XMM4, 16*3(%arg2 , %r11 , 1)
+.endif
+	add	   $64, %r11
+	pshufb	   SHUF_MASK(%rip), \XMM1 # perform a 16 byte swap
+	pxor	   \XMMDst, \XMM1         # combine GHASHed value with the
corresponding ciphertext
+	pshufb	   SHUF_MASK(%rip), \XMM2 # perform a 16 byte swap
+	pshufb	   SHUF_MASK(%rip), \XMM3 # perform a 16 byte swap
+	pshufb	   SHUF_MASK(%rip), \XMM4 # perform a 16 byte swap
+_initial_blocks_done\num_initial_blocks\operation:
+.endm
+
+/*
+* encrypt 4 blocks at a time
+* ghash the 4 previously encrypted ciphertext blocks
+* arg1, %arg2, %arg3 are used as pointers only, not modified
+* %r11 is the data offset value
+*/
+.macro GHASH_4_ENCRYPT_4_PARALLEL TMP1 TMP2 TMP3 TMP4 TMP5 TMP6 XMM0 XMM1
XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
+
+	movdqa	  \XMM1, \XMM5
+	movdqa	  \XMM2, \XMM6
+	movdqa	  \XMM3, \XMM7
+	movdqa	  \XMM4, \XMM8
+
+        # multiply TMP5 * HashKey using karatsuba
+
+	movdqa	  \XMM5, \TMP4
+	pshufd	  $78, \XMM5, \TMP6
+	pxor	  \XMM5, \TMP6
+	paddd     ONE(%rip), \XMM0		# INCR CNT
+	movdqa	  HashKey_4(%rsp), \TMP5
+	pclmulqdq $0x11, \TMP5, \TMP4           # TMP4 = a1*b1
+	movdqa    \XMM0, \XMM1
+	paddd     ONE(%rip), \XMM0		# INCR CNT
+	movdqa    \XMM0, \XMM2
+	paddd     ONE(%rip), \XMM0		# INCR CNT
+	movdqa    \XMM0, \XMM3
+	paddd     ONE(%rip), \XMM0		# INCR CNT
+	movdqa    \XMM0, \XMM4
+	pshufb	  SHUF_MASK(%rip), \XMM1	# perform a 16 byte swap
+	pclmulqdq $0x00, \TMP5, \XMM5           # XMM5 = a0*b0
+	pshufb	  SHUF_MASK(%rip), \XMM2	# perform a 16 byte swap
+	pshufb	  SHUF_MASK(%rip), \XMM3	# perform a 16 byte swap
+	pshufb	  SHUF_MASK(%rip), \XMM4	# perform a 16 byte swap
+	pxor	  (%arg1), \XMM1
+	pxor	  (%arg1), \XMM2
+	pxor	  (%arg1), \XMM3
+	pxor	  (%arg1), \XMM4
+	movdqa	  HashKey_4_k(%rsp), \TMP5
+	pclmulqdq $0x00, \TMP5, \TMP6           # TMP6 = (a1+a0)*(b1+b0)
+	aesenc	  16(%arg1), \XMM1              # Round 1
+	aesenc	  16(%arg1), \XMM2
+	aesenc	  16(%arg1), \XMM3
+	aesenc	  16(%arg1), \XMM4
+	aesenc	  32(%arg1), \XMM1              # Round 2
+	aesenc	  32(%arg1), \XMM2
+	aesenc	  32(%arg1), \XMM3
+	aesenc	  32(%arg1), \XMM4
+	movdqa	  \XMM6, \TMP1
+	pshufd	  $78, \XMM6, \TMP2
+	pxor	  \XMM6, \TMP2
+	movdqa	  HashKey_3(%rsp), \TMP5
+	pclmulqdq $0x11, \TMP5, \TMP1           # TMP1 = a1 * b1
+	aesenc    48(%arg1), \XMM1              # Round 3
+	aesenc    48(%arg1), \XMM2
+	aesenc    48(%arg1), \XMM3
+	aesenc    48(%arg1), \XMM4
+	pclmulqdq $0x00, \TMP5, \XMM6           # XMM6 = a0*b0
+	aesenc	  64(%arg1), \XMM1              # Round 4
+	aesenc	  64(%arg1), \XMM2
+	aesenc	  64(%arg1), \XMM3
+	aesenc	  64(%arg1), \XMM4
+	movdqa	  HashKey_3_k(%rsp), \TMP5
+	pclmulqdq $0x00, \TMP5, \TMP2           # TMP2 = (a1+a0)*(b1+b0)
+	aesenc	  80(%arg1), \XMM1              # Round 5
+	aesenc	  80(%arg1), \XMM2
+	aesenc	  80(%arg1), \XMM3
+	aesenc	  80(%arg1), \XMM4
+	pxor	  \TMP1, \TMP4			# accumulate the results in
TMP4:XMM5, TMP6 holds the middle part
+	pxor	  \XMM6, \XMM5
+	pxor	  \TMP2, \TMP6
+	movdqa	  \XMM7, \TMP1
+	pshufd	  $78, \XMM7, \TMP2
+	pxor	  \XMM7, \TMP2
+	movdqa	  HashKey_2(%rsp ), \TMP5
+
+        # Multiply TMP5 * HashKey using karatsuba
+
+	pclmulqdq $0x11, \TMP5, \TMP1           # TMP1 = a1*b1
+	aesenc	  96(%arg1), \XMM1              # Round 6
+	aesenc	  96(%arg1), \XMM2
+	aesenc	  96(%arg1), \XMM3
+	aesenc	  96(%arg1), \XMM4
+	pclmulqdq $0x00, \TMP5, \XMM7           # XMM7 = a0*b0
+	aesenc	  112(%arg1), \XMM1             # Round 7
+	aesenc	  112(%arg1), \XMM2
+	aesenc	  112(%arg1), \XMM3
+	aesenc	  112(%arg1), \XMM4
+	movdqa	  HashKey_2_k(%rsp), \TMP5
+	pclmulqdq $0x00, \TMP5, \TMP2           # TMP2 = (a1+a0)*(b1+b0)
+	aesenc	  128(%arg1), \XMM1             # Round 8
+	aesenc	  128(%arg1), \XMM2
+	aesenc	  128(%arg1), \XMM3
+	aesenc	  128(%arg1), \XMM4
+	pxor	  \TMP1, \TMP4			# accumulate the results in
TMP4:XMM5, TMP6 holds the middle part
+	pxor	  \XMM7, \XMM5
+	pxor	  \TMP2, \TMP6
+
+        # Multiply XMM8 * HashKey
+        # XMM8 and TMP5 hold the values for the two operands
+
+	movdqa	  \XMM8, \TMP1
+	pshufd	  $78, \XMM8, \TMP2
+	pxor	  \XMM8, \TMP2
+	movdqa	  HashKey(%rsp), \TMP5
+	pclmulqdq $0x11, \TMP5, \TMP1          # TMP1 = a1*b1
+	aesenc	  144(%arg1), \XMM1            # Round 9
+	aesenc	  144(%arg1), \XMM2
+	aesenc	  144(%arg1), \XMM3
+	aesenc	  144(%arg1), \XMM4
+	pclmulqdq $0x00, \TMP5, \XMM8          # XMM8 = a0*b0
+	aesenclast 160(%arg1), \XMM1           # Round 10
+	aesenclast 160(%arg1), \XMM2
+	aesenclast 160(%arg1), \XMM3
+	aesenclast 160(%arg1), \XMM4
+	movdqa    HashKey_k(%rsp), \TMP5
+	pclmulqdq $0x00, \TMP5, \TMP2          # TMP2 = (a1+a0)*(b1+b0)
+	movdqu	  (%arg3,%r11,1), \TMP3
+	pxor	  \TMP3, \XMM1                 # Ciphertext/Plaintext XOR EK
+.if \operation == dec
+	movdqu	  \XMM1, (%arg2,%r11,1)        # Write to plaintext buffer
+	movdqa    \TMP3, \XMM1
+.endif
+	movdqu	  16(%arg3,%r11,1), \TMP3
+	pxor	  \TMP3, \XMM2                 # Ciphertext/Plaintext XOR EK
+.if \operation == dec
+	movdqu	  \XMM2, 16(%arg2,%r11,1)      # Write to plaintext buffer
+	movdqa    \TMP3, \XMM2
+.endif
+	movdqu	  32(%arg3,%r11,1), \TMP3
+	pxor	  \TMP3, \XMM3                 # Ciphertext/Plaintext XOR EK
+.if \operation == dec
+	movdqu	  \XMM3, 32(%arg2,%r11,1)      # Write to plaintext buffer
+	movdqa    \TMP3, \XMM3
+.endif
+	movdqu	  48(%arg3,%r11,1), \TMP3
+	pxor	  \TMP3, \XMM4                 # Ciphertext/Plaintext XOR EK
+.if \operation == dec
+	movdqu	  \XMM4, 48(%arg2,%r11,1)      # Write to plaintext buffer
+	movdqa    \TMP3, \XMM4
+.else
+        movdqu    \XMM1, (%arg2,%r11,1)        # Write to the ciphertext
buffer
+        movdqu    \XMM2, 16(%arg2,%r11,1)      # Write to the ciphertext
buffer
+        movdqu    \XMM3, 32(%arg2,%r11,1)      # Write to the ciphertext
buffer
+        movdqu    \XMM4, 48(%arg2,%r11,1)      # Write to the ciphertext
buffer
+.endif
+	pshufb	  SHUF_MASK(%rip), \XMM1       # perform a 16 byte swap
+	pshufb	  SHUF_MASK(%rip), \XMM2       # perform a 16 byte swap
+	pshufb	  SHUF_MASK(%rip), \XMM3       # perform a 16 byte swap
+	pshufb	  SHUF_MASK(%rip), \XMM4       # perform a 16 byte sway
+
+	pxor	  \TMP4, \TMP1
+	pxor	  \XMM8, \XMM5
+	pxor	  \TMP6, \TMP2
+	pxor	  \TMP1, \TMP2
+	pxor	  \XMM5, \TMP2
+	movdqa	  \TMP2, \TMP3
+	pslldq	  $8, \TMP3                    # left shift TMP3 2 DWs
+	psrldq	  $8, \TMP2                    # right shift TMP2 2 DWs
+	pxor	  \TMP3, \XMM5
+	pxor	  \TMP2, \TMP1		       # accumulate the results in
TMP1:XMM5
+
+        # first phase of reduction
+
+	movdqa    \XMM5, \TMP2
+	movdqa    \XMM5, \TMP3
+	movdqa    \XMM5, \TMP4		       # move XMM5 into TMP2, TMP3,
TMP4 in order to perform shifts independently
+	pslld     $31, \TMP2                   # packed right shift << 31
+	pslld     $30, \TMP3                   # packed right shift << 30
+	pslld     $25, \TMP4                   # packed right shift << 25
+	pxor      \TMP3, \TMP2	               # xor the shifted versions
+	pxor      \TMP4, \TMP2
+	movdqa    \TMP2, \TMP5
+	psrldq    $4, \TMP5                    # right shift T5 1 DW
+	pslldq    $12, \TMP2                   # left shift T2 3 DWs
+	pxor      \TMP2, \XMM5
+
+        # second phase of reduction
+
+	movdqa    \XMM5,\TMP2		       # make 3 copies of XMM5 into
TMP2, TMP3, TMP4
+	movdqa    \XMM5,\TMP3
+	movdqa    \XMM5,\TMP4
+	psrld     $1, \TMP2                    # packed left shift >>1
+	psrld     $2, \TMP3                    # packed left shift >>2
+	psrld     $7, \TMP4                    # packed left shift >>7
+	pxor      \TMP3,\TMP2		       # xor the shifted versions
+	pxor      \TMP4,\TMP2
+	pxor      \TMP5, \TMP2
+	pxor      \TMP2, \XMM5
+	pxor      \TMP1, \XMM5                 # result is in TMP1
+
+	pxor	  \XMM5, \XMM1
+.endm
+
+/* GHASH the last 4 ciphertext blocks. */
+.macro	GHASH_LAST_4 TMP1 TMP2 TMP3 TMP4 TMP5 TMP6 TMP7 XMM1 XMM2 XMM3 XMM4
XMMDst
+
+        # Multiply TMP6 * HashKey (using Karatsuba)
+
+	movdqa	  \XMM1, \TMP6
+	pshufd	  $78, \XMM1, \TMP2
+	pxor	  \XMM1, \TMP2
+	movdqa	  HashKey_4(%rsp), \TMP5
+	pclmulqdq $0x11, \TMP5, \TMP6       # TMP6 = a1*b1
+	pclmulqdq $0x00, \TMP5, \XMM1       # XMM1 = a0*b0
+	movdqa	  HashKey_4_k(%rsp), \TMP4
+	pclmulqdq $0x00, \TMP4, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
+	movdqa	  \XMM1, \XMMDst
+	movdqa	  \TMP2, \XMM1              # result in TMP6, XMMDst, XMM1
+
+        # Multiply TMP1 * HashKey (using Karatsuba)
+
+	movdqa	  \XMM2, \TMP1
+	pshufd	  $78, \XMM2, \TMP2
+	pxor	  \XMM2, \TMP2
+	movdqa	  HashKey_3(%rsp), \TMP5
+	pclmulqdq $0x11, \TMP5, \TMP1       # TMP1 = a1*b1
+	pclmulqdq $0x00, \TMP5, \XMM2       # XMM2 = a0*b0
+	movdqa	  HashKey_3_k(%rsp), \TMP4
+	pclmulqdq $0x00, \TMP4, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
+	pxor	  \TMP1, \TMP6
+	pxor	  \XMM2, \XMMDst
+	pxor	  \TMP2, \XMM1              # results accumulated in TMP6,
XMMDst, XMM1
+
+        # Multiply TMP1 * HashKey (using Karatsuba)
+
+	movdqa	  \XMM3, \TMP1
+	pshufd	  $78, \XMM3, \TMP2
+	pxor	  \XMM3, \TMP2
+	movdqa	  HashKey_2(%rsp), \TMP5
+	pclmulqdq $0x11, \TMP5, \TMP1       # TMP1 = a1*b1
+	pclmulqdq $0x00, \TMP5, \XMM3       # XMM3 = a0*b0
+	movdqa	  HashKey_2_k(%rsp), \TMP4
+	pclmulqdq $0x00, \TMP4, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
+	pxor	  \TMP1, \TMP6
+	pxor	  \XMM3, \XMMDst
+	pxor	  \TMP2, \XMM1              # results accumulated in TMP6,
XMMDst, XMM1
+
+        # Multiply TMP1 * HashKey (using Karatsuba)
+
+	movdqa	  \XMM4, \TMP1
+	pshufd	  $78, \XMM4, \TMP2
+	pxor	  \XMM4, \TMP2
+	movdqa	  HashKey(%rsp), \TMP5
+	pclmulqdq $0x11, \TMP5, \TMP1	    # TMP1 = a1*b1
+	pclmulqdq $0x00, \TMP5, \XMM4       # XMM4 = a0*b0
+	movdqa	  HashKey_k(%rsp), \TMP4
+	pclmulqdq $0x00, \TMP4, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
+	pxor	  \TMP1, \TMP6
+	pxor	  \XMM4, \XMMDst
+	pxor	  \XMM1, \TMP2
+	pxor	  \TMP6, \TMP2
+	pxor	  \XMMDst, \TMP2            # middle section of the temp
results combined as in karatsuba algorithm
+	movdqa	  \TMP2, \TMP4
+	pslldq	  $8, \TMP4                 # left shift TMP4 2 DWs
+	psrldq	  $8, \TMP2                 # right shift TMP2 2 DWs
+	pxor	  \TMP4, \XMMDst
+	pxor	  \TMP2, \TMP6              # TMP6:XMMDst holds the result
of the accumulated carry-less multiplications
+
+        # first phase of the reduction
+
+	movdqa    \XMMDst, \TMP2
+	movdqa    \XMMDst, \TMP3
+	movdqa    \XMMDst, \TMP4            # move XMMDst into TMP2, TMP3,
TMP4 in order to perform 3 shifts independently
+	pslld     $31, \TMP2                # packed right shifting << 31
+	pslld     $30, \TMP3                # packed right shifting << 30
+	pslld     $25, \TMP4                # packed right shifting << 25
+	pxor      \TMP3, \TMP2              # xor the shifted versions
+	pxor      \TMP4, \TMP2
+	movdqa    \TMP2, \TMP7
+	psrldq    $4, \TMP7                 # right shift TMP7 1 DW
+	pslldq    $12, \TMP2                # left shift TMP2 3 DWs
+	pxor      \TMP2, \XMMDst
+
+        # second phase of the reduction
+
+	movdqa    \XMMDst, \TMP2            # make 3 copies of XMMDst for
doing 3 shift operations
+	movdqa    \XMMDst, \TMP3
+	movdqa    \XMMDst, \TMP4
+	psrld     $1, \TMP2                 # packed left shift >> 1
+	psrld     $2, \TMP3                 # packed left shift >> 2
+	psrld     $7, \TMP4                 # packed left shift >> 7
+	pxor      \TMP3, \TMP2              # xor the shifted versions
+	pxor      \TMP4, \TMP2
+	pxor      \TMP7, \TMP2
+	pxor      \TMP2, \XMMDst
+	pxor      \TMP6, \XMMDst            # reduced result is in XMMDst
+.endm
+
+/* Encryption of a single block done*/
+.macro ENCRYPT_SINGLE_BLOCK XMM0
+
+	pxor	(%arg1), \XMM0
+	aesenc	16(%arg1), \XMM0
+	aesenc	32(%arg1), \XMM0
+	aesenc	48(%arg1), \XMM0
+	aesenc	64(%arg1), \XMM0
+	aesenc	80(%arg1), \XMM0
+	aesenc	96(%arg1), \XMM0
+	aesenc	112(%arg1), \XMM0
+	aesenc	128(%arg1), \XMM0
+	aesenc	144(%arg1), \XMM0
+	aesenclast 160(%arg1), \XMM0
+.endm
+
+
+/**************************************************************************
********************
+*void aesni_gcm_dec(void *aes_ctx,               // AES Key schedule.
Starts on a 16 byte boundary.
+*                   u8 *out,                     // Plaintext output.
Encrypt in-place is allowed.
+*                   const u8 *in,                // Ciphertext input
+*                   u64 plaintext_len,           // Length of data in bytes
for decryption.
+*                   u8 *iv,                      // Pre-counter block j0: 4
byte salt (from Security Association)
+*                                                // concatenated with 8
byte Initialisation Vector (from IPSec ESP Payload)
+*                                                // concatenated with
0x00000001. 16-byte aligned pointer.
+*                   u8 *hash_subkey,             // H, the Hash sub key
input. Data starts on a 16-byte boundary.
+*                   const u8 *aad,               // Additional
Authentication Data (AAD)
+*                   u64 aad_len,                 // Length of AAD in bytes.
With RFC4106 this is going to be 8 or 12 bytes
+*                   u8  *auth_tag,               // Authenticated Tag
output. The driver will compare this to the
+*                                                // given authentication
tag and only return the plaintext if they match.
+*                   u64 auth_tag_len);           // Authenticated Tag
Length in bytes. Valid values are 16 (most likely), 12 or 8.
+*
+*
+*
+* Assumptions:
+*
+* keys:
+*       keys are pre-expanded and aligned to 16 bytes. we are using the
first set of 11 keys in the data structure void *aes_ctx
+*
+*
+* iv:
+*       0                   1                   2                   3
+*       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                             Salt  (From the SA)               |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                     Initialization Vector                     |
+*       |         (This is the sequence number from IPSec header)       |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                              0x1                              |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*
+*
+*
+* AAD:
+*       AAD padded to 128 bits with 0
+*       for example, assume AAD is a u32 vector
+*
+*       if AAD is 8 bytes:
+*       AAD[3] = {A0, A1};
+*       padded AAD in xmm register = {A1 A0 0 0}
+*
+*       0                   1                   2                   3
+*       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                               SPI (A1)                        |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                     32-bit Sequence Number (A0)               |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                              0x0                              |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*
+*                                       AAD Format with 32-bit Sequence
Number
+*
+*       if AAD is 12 bytes:
+*       AAD[3] = {A0, A1, A2};
+*       padded AAD in xmm register = {A2 A1 A0 0}
+*
+*       0                   1                   2                   3
+*       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                               SPI (A2)                        |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                 64-bit Extended Sequence Number {A1,A0}       |
+*       |                                                               |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                              0x0                              |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*
+*                                       AAD Format with 64-bit Extended
Sequence Number
+*
+*
+* aadLen:
+*       from the definition of the spec, aadLen can only be 8 or 12 bytes.
The code supports 16 too but for other sizes, the code will fail.
+*
+* TLen:
+*       from the definition of the spec, TLen can only be 8, 12 or 16
bytes. For other sizes, the code will fail.
+*
+* poly = x^128 + x^127 + x^126 + x^121 + 1
+*
+***************************************************************************
****************/
+
+ENTRY(aesni_gcm_dec)
+	push	%r12
+	push	%r13
+	push	%r14
+	mov	%rsp, %r14
+/*
+* states of %xmm registers %xmm6:%xmm15 not saved
+* all %xmm registers are clobbered
+*/
+	sub	$VARIABLE_OFFSET, %rsp
+	and	$~63, %rsp                        # align rsp to 64 bytes
+	mov	%arg6, %r12
+	movdqu	(%r12), %xmm13			  # %xmm13 = HashKey
+	pshufb	SHUF_MASK(%rip), %xmm13
+
+        # Precompute HashKey<<1 (mod poly) from the hash key (this is
required for GHASH)
+
+	movdqa	%xmm13, %xmm2
+	psllq	$1, %xmm13
+	psrlq	$63, %xmm2
+	movdqa	%xmm2, %xmm1
+	pslldq	$8, %xmm2
+	psrldq	$8, %xmm1
+	por	%xmm2, %xmm13
+
+        # Reduction
+
+	pshufd	$0x24, %xmm1, %xmm2
+	pcmpeqd TWOONE(%rip), %xmm2
+	pand	POLY(%rip), %xmm2
+	pxor	%xmm2, %xmm13			# %xmm13 holds the
HashKey<<1 (mod poly)
+
+
+        # Decrypt first few blocks
+
+	movdqa	%xmm13, HashKey(%rsp)           # store HashKey<<1 (mod
poly)
+	mov	%arg4, %r13                     # save the number of bytes
of plaintext/ciphertext
+	and	$-16, %r13                      # %r13 = %r13 - (%r13 mod
16)
+	mov	%r13, %r12
+	and	$(3<<4), %r12
+	jz	_initial_num_blocks_is_0_decrypt
+	cmp	$(2<<4), %r12
+	jb	_initial_num_blocks_is_1_decrypt
+	je	_initial_num_blocks_is_2_decrypt
+_initial_num_blocks_is_3_decrypt:
+	INITIAL_BLOCKS	3, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0,
%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 5, 678, dec
+	sub	$48, %r13
+	jmp	_initial_blocks_decrypted
+_initial_num_blocks_is_2_decrypt:
+	INITIAL_BLOCKS	2, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0,
%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 6, 78, dec
+	sub	$32, %r13
+	jmp	_initial_blocks_decrypted
+_initial_num_blocks_is_1_decrypt:
+	INITIAL_BLOCKS	1, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0,
%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 7, 8, dec
+	sub	$16, %r13
+	jmp	_initial_blocks_decrypted
+_initial_num_blocks_is_0_decrypt:
+	INITIAL_BLOCKS	0, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0,
%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 8, 0, dec
+_initial_blocks_decrypted:
+	cmp	$0, %r13
+	je	_zero_cipher_left_decrypt
+	sub	$64, %r13
+	je	_four_cipher_left_decrypt
+_decrypt_by_4:
+	GHASH_4_ENCRYPT_4_PARALLEL	%xmm9, %xmm10, %xmm11, %xmm12,
%xmm13, %xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
%xmm8, dec
+	add	$64, %r11
+	sub	$64, %r13
+	jne	_decrypt_by_4
+_four_cipher_left_decrypt:
+	GHASH_LAST_4	%xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
%xmm15, %xmm1, %xmm2, %xmm3, %xmm4, %xmm8
+_zero_cipher_left_decrypt:
+	mov	%arg4, %r13
+	and	$15, %r13				# %r13 = arg4 (mod
16)
+	je	_multiple_of_16_bytes_decrypt
+
+        # Handle the last <16 byte block seperately
+
+	paddd	ONE(%rip), %xmm0                        # increment CNT to
get Yn
+	pshufb	SHUF_MASK(%rip), %xmm0
+	ENCRYPT_SINGLE_BLOCK 	%xmm0			# E(K, Yn)
+	sub	$16, %r11
+	add	%r13, %r11
+	movdqu	(%arg3,%r11,1), %xmm1			# recieve the last
<16 byte block
+	lea	SHIFT_MASK+16(%rip), %r12
+	sub	%r13, %r12				# adjust the shuffle
mask pointer to be able to shift 16-%r13 bytes
+							# (%r13 is the
number of bytes in plaintext mod 16)
+	movdqu	(%r12), %xmm2				# get the
appropriate shuffle mask
+	pshufb	%xmm2, %xmm1				# right shift
16-%r13 butes
+	movdqa  %xmm1, %xmm2
+	pxor	%xmm1, %xmm0				# Ciphertext XOR
E(K, Yn)
+	movdqu	ALL_F-SHIFT_MASK(%r12), %xmm1           # get the
appropriate mask to mask out top 16-%r13 bytes of %xmm0
+	pand	%xmm1, %xmm0				# mask out top
16-%r13 bytes of %xmm0
+	pand    %xmm1, %xmm2
+	pshufb	SHUF_MASK(%rip),%xmm2
+	pxor	%xmm2, %xmm8
+	GHASH_MUL	%xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
# GHASH computation for the last <16 byte block
+	sub	%r13, %r11
+	add	$16, %r11
+
+        # output %r13 bytes
+
+	movq	%xmm0, %rax
+	cmp	$8, %r13
+	jle	_less_than_8_bytes_left_decrypt
+	mov	%rax, (%arg2 , %r11, 1)
+	add	$8, %r11
+	psrldq	$8, %xmm0
+	movq	%xmm0, %rax
+	sub	$8, %r13
+_less_than_8_bytes_left_decrypt:
+	mov	%al,  (%arg2, %r11, 1)
+	add	$1, %r11
+	shr	$8, %rax
+	sub	$1, %r13
+	jne	_less_than_8_bytes_left_decrypt
+_multiple_of_16_bytes_decrypt:
+	mov	arg8, %r12		  # %r13 = aadLen (number of bytes)
+	shl	$3, %r12		  # convert into number of bits
+	movd	%r12d, %xmm15		  # len(A) in %xmm15
+	shl	$3, %arg4		  # len(C) in bits (*128)
+	movq	%arg4, %xmm1
+	pslldq	$8, %xmm15		  # %xmm15 =
len(A)||0x0000000000000000
+	pxor	%xmm1, %xmm15		  # %xmm15 = len(A)||len(C)
+	pxor	%xmm15, %xmm8
+	GHASH_MUL	%xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
# final GHASH computation
+	pshufb	SHUF_MASK(%rip), %xmm8
+	mov	%arg5, %rax		  # %rax = *Y0
+	movdqu	(%rax), %xmm0		  # %xmm0 = Y0
+	ENCRYPT_SINGLE_BLOCK	%xmm0 	  # E(K, Y0)
+	pxor	%xmm8, %xmm0
+_return_T_decrypt:
+	mov	arg9, %r10                # %r10 = authTag
+	mov	arg10, %r11               # %r11 = auth_tag_len
+	cmp	$16, %r11
+	je	_T_16_decrypt
+	cmp	$12, %r11
+	je	_T_12_decrypt
+_T_8_decrypt:
+	movq	%xmm0, %rax
+	mov	%rax, (%r10)
+	jmp	_return_T_done_decrypt
+_T_12_decrypt:
+	movq	%xmm0, %rax
+	mov	%rax, (%r10)
+	psrldq	$8, %xmm0
+	movd	%xmm0, %eax
+	mov	%eax, 8(%r10)
+	jmp	_return_T_done_decrypt
+_T_16_decrypt:
+	movdqu	%xmm0, (%r10)
+_return_T_done_decrypt:
+	mov	%r14, %rsp
+	pop	%r14
+	pop	%r13
+	pop	%r12
+	ret
+
+
+/**************************************************************************
*************************
+* void aesni_gcm_enc(void *aes_ctx,               // AES Key schedule.
Starts on a 16 byte boundary.
+*                    u8 *out,                    // Ciphertext output.
Encrypt in-place is allowed.
+*                    const u8 *in,               // Plaintext input
+*                    u64 plaintext_len,          // Length of data in bytes
for encryption.
+*                    u8 *iv,                     // Pre-counter block j0: 4
byte salt (from Security Association)
+*                                                // concatenated with 8
byte Initialisation Vector (from IPSec ESP Payload)
+*                                                // concatenated with
0x00000001. 16-byte aligned pointer.
+*                    u8 *hash_subkey,            // H, the Hash sub key
input. Data starts on a 16-byte boundary.
+*                    const u8 *aad,              // Additional
Authentication Data (AAD)
+*                    u64 aad_len,                // Length of AAD in bytes.
With RFC4106 this is going to be 8 or 12 bytes
+*                    u8 *auth_tag,               // Authenticated Tag
output.
+*                    u64 auth_tag_len);          // Authenticated Tag
Length in bytes. Valid values are 16 (most likely), 12 or 8.
+*
+*
+*
+* Assumptions:
+*
+* keys:
+*       keys are pre-expanded and aligned to 16 bytes. we are using the
first set of 11 keys in the data structure void *aes_ctx
+*
+*
+* iv:
+*       0                   1                   2                   3
+*       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                             Salt  (From the SA)               |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                     Initialization Vector                     |
+*       |         (This is the sequence number from IPSec header)       |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                              0x1                              |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*
+*
+*
+* AAD:
+*       AAD padded to 128 bits with 0
+*       for example, assume AAD is a u32 vector
+*
+*       if AAD is 8 bytes:
+*       AAD[3] = {A0, A1};
+*       padded AAD in xmm register = {A1 A0 0 0}
+*
+*       0                   1                   2                   3
+*       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                               SPI (A1)                        |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                     32-bit Sequence Number (A0)               |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                              0x0                              |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*
+*                                       AAD Format with 32-bit Sequence
Number
+*
+*       if AAD is 12 bytes:
+*       AAD[3] = {A0, A1, A2};
+*       padded AAD in xmm register = {A2 A1 A0 0}
+*
+*       0                   1                   2                   3
+*       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                               SPI (A2)                        |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                 64-bit Extended Sequence Number {A1,A0}       |
+*       |                                                               |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*       |                              0x0                              |
+*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+*
+*                                       AAD Format with 64-bit Extended
Sequence Number
+*
+*
+* aadLen:
+*       from the definition of the spec, aadLen can only be 8 or 12 bytes.
The code supports 16 too but for other sizes, the code will fail.
+*
+* TLen:
+*       from the definition of the spec, TLen can only be 8, 12 or 16
bytes. For other sizes, the code will fail.
+*
+* poly = x^128 + x^127 + x^126 + x^121 + 1
+***************************************************************************
***********************************************/
+ENTRY(aesni_gcm_enc)
+	push	%r12
+	push	%r13
+	push	%r14
+	mov	%rsp, %r14
+#
+# states of %xmm registers %xmm6:%xmm15 not saved
+# all %xmm registers are clobbered
+#
+	sub	$VARIABLE_OFFSET, %rsp
+	and	$~63, %rsp
+	mov	%arg6, %r12
+	movdqu	(%r12), %xmm13
+	pshufb	SHUF_MASK(%rip), %xmm13
+
+        # precompute HashKey<<1 mod poly from the HashKey (required for
GHASH)
+
+	movdqa	%xmm13, %xmm2
+	psllq	$1, %xmm13
+	psrlq	$63, %xmm2
+	movdqa	%xmm2, %xmm1
+	pslldq	$8, %xmm2
+	psrldq	$8, %xmm1
+	por	%xmm2, %xmm13
+
+        # reduce HashKey<<1
+
+	pshufd	$0x24, %xmm1, %xmm2
+	pcmpeqd TWOONE(%rip), %xmm2
+	pand	POLY(%rip), %xmm2
+	pxor	%xmm2, %xmm13
+	movdqa	%xmm13, HashKey(%rsp)
+	mov	%arg4, %r13               # %xmm13 holds HashKey<<1 (mod
poly)
+	and	$-16, %r13
+	mov	%r13, %r12
+
+        # Encrypt first few blocks
+
+	and	$(3<<4), %r12
+	jz	_initial_num_blocks_is_0_encrypt
+	cmp	$(2<<4), %r12
+	jb	_initial_num_blocks_is_1_encrypt
+	je	_initial_num_blocks_is_2_encrypt
+_initial_num_blocks_is_3_encrypt:
+	INITIAL_BLOCKS	3, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0,
%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 5, 678, enc
+	sub	$48, %r13
+	jmp	_initial_blocks_encrypted
+_initial_num_blocks_is_2_encrypt:
+	INITIAL_BLOCKS	2, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0,
%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 6, 78, enc
+	sub	$32, %r13
+	jmp	_initial_blocks_encrypted
+_initial_num_blocks_is_1_encrypt:
+	INITIAL_BLOCKS	1, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0,
%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 7, 8, enc
+	sub	$16, %r13
+	jmp	_initial_blocks_encrypted
+_initial_num_blocks_is_0_encrypt:
+	INITIAL_BLOCKS	0, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0,
%xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 8, 0, enc
+_initial_blocks_encrypted:
+
+        # Main loop - Encrypt remaining blocks
+
+	cmp	$0, %r13
+	je	_zero_cipher_left_encrypt
+	sub	$64, %r13
+	je	_four_cipher_left_encrypt
+_encrypt_by_4_encrypt:
+	GHASH_4_ENCRYPT_4_PARALLEL	%xmm9, %xmm10, %xmm11, %xmm12,
%xmm13, %xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
%xmm8, enc
+	add	$64, %r11
+	sub	$64, %r13
+	jne	_encrypt_by_4_encrypt
+_four_cipher_left_encrypt:
+	GHASH_LAST_4	%xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
%xmm15, %xmm1, %xmm2, %xmm3, %xmm4, %xmm8
+_zero_cipher_left_encrypt:
+	mov	%arg4, %r13
+	and	$15, %r13			# %r13 = arg4 (mod 16)
+	je	_multiple_of_16_bytes_encrypt
+
+         # Handle the last <16 Byte block seperately
+
+	paddd	ONE(%rip), %xmm0                # INCR CNT to get Yn
+	pshufb	SHUF_MASK(%rip), %xmm0
+	ENCRYPT_SINGLE_BLOCK	%xmm0 		# Encrypt(K, Yn)
+	sub	$16, %r11
+	add	%r13, %r11
+	movdqu	(%arg3,%r11,1), %xmm1		# recieve the last <16 byte
blocks
+	lea	SHIFT_MASK+16(%rip), %r12
+	sub	%r13, %r12			# adjust the shuffle mask
pointer to be able to shift 16-r13 bytes
+                                                # (%r13 is the number of
bytes in plaintext mod 16)
+	movdqu	(%r12), %xmm2			# get the appropriate
shuffle mask
+	pshufb	%xmm2, %xmm1			# shift right 16-r13 byte
+	pxor	%xmm1, %xmm0			# Plaintext XOR Encrypt(K,
Yn)
+	movdqu	ALL_F-SHIFT_MASK(%r12), %xmm1   # get the appropriate mask
to mask out top 16-r13 bytes of xmm0
+	pand	%xmm1, %xmm0			# mask out top 16-r13 bytes
of xmm0
+
+	pshufb	SHUF_MASK(%rip),%xmm0
+	pxor	%xmm0, %xmm8
+	GHASH_MUL %xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6	#
GHASH computation for the last <16 byte block
+	sub	%r13, %r11
+	add	$16, %r11
+	pshufb	SHUF_MASK(%rip), %xmm0          # shuffle xmm0 back to
output as ciphertext
+
+        # Output %r13 bytes
+
+	movq	%xmm0, %rax
+	cmp	$8, %r13
+	jle	_less_than_8_bytes_left_encrypt
+	mov	%rax, (%arg2 , %r11, 1)
+	add	$8, %r11
+	psrldq	$8, %xmm0
+	movq	%xmm0, %rax
+	sub	$8, %r13
+_less_than_8_bytes_left_encrypt:
+	mov	%al,  (%arg2, %r11, 1)
+	add	$1, %r11
+	shr	$8, %rax
+	sub	$1, %r13
+	jne	_less_than_8_bytes_left_encrypt
+_multiple_of_16_bytes_encrypt:
+	mov	arg8, %r12	               # %r12 = addLen (number of
bytes)
+	shl	$3, %r12
+	movd	%r12d, %xmm15	               # len(A) in %xmm15
+	shl	$3, %arg4	               # len(C) in bits (*128)
+	movq	%arg4, %xmm1
+	pslldq	$8, %xmm15	               # %xmm15 =
len(A)||0x0000000000000000
+	pxor	%xmm1, %xmm15	               # %xmm15 = len(A)||len(C)
+	pxor	%xmm15, %xmm8
+	GHASH_MUL	%xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
# final GHASH computation
+
+	pshufb	SHUF_MASK(%rip), %xmm8         # perform a 16 byte swap
+	mov	%arg5, %rax		       # %rax  = *Y0
+	movdqu	(%rax), %xmm0		       # %xmm0 = Y0
+	ENCRYPT_SINGLE_BLOCK	%xmm0          # Encrypt(K, Y0)
+	pxor	%xmm8, %xmm0
+_return_T_encrypt:
+	mov	arg9, %r10                     # %r10 = authTag
+	mov	arg10, %r11                    # %r11 = auth_tag_len
+	cmp	$16, %r11
+	je	_T_16_encrypt
+	cmp	$12, %r11
+	je	_T_12_encrypt
+_T_8_encrypt:
+	movq	%xmm0, %rax
+	mov	%rax, (%r10)
+	jmp	_return_T_done_encrypt
+_T_12_encrypt:
+	movq	%xmm0, %rax
+	mov	%rax, (%r10)
+	psrldq	$8, %xmm0
+	movd	%xmm0, %eax
+	mov	%eax, 8(%r10)
+	jmp	_return_T_done_encrypt
+_T_16_encrypt:
+	movdqu	%xmm0, (%r10)
+_return_T_done_encrypt:
+	mov	%r14, %rsp
+	pop	%r14
+	pop	%r13
+	pop	%r12
+	ret
+
+#include <asm/inst.h>
+
 _key_expansion_128:
 _key_expansion_256a:
 	pshufd $0b11111111, %xmm1, %xmm1
diff --git a/arch/x86/crypto/aesni-intel_glue.c
b/arch/x86/crypto/aesni-intel_glue.c
index 2cb3dcc..f0b0a6f 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -5,6 +5,14 @@
  * Copyright (C) 2008, Intel Corp.
  *    Author: Huang Ying <ying.huang@intel.com>
  *
+ * Added RFC4106 AES-GCM support for 128-bit keys under the AEAD
+ * interface for 64-bit kernels.
+ *    Authors: Adrian Hoban <adrian.hoban@intel.com>
+ *             Gabriele Paoloni <gabriele.paoloni@intel.com>
+ *             Tadeusz Struk (tadeusz.struk@intel.com)
+ *             Aidan O'Mahony (aidan.o.mahony@intel.com)
+ *    Copyright (c) 2010, Intel Corporation.
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -21,6 +29,10 @@
 #include <crypto/ctr.h>
 #include <asm/i387.h>
 #include <asm/aes.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/internal/aead.h>
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
 
 #if defined(CONFIG_CRYPTO_CTR) || defined(CONFIG_CRYPTO_CTR_MODULE)
 #define HAS_CTR
@@ -42,8 +54,31 @@ struct async_aes_ctx {
 	struct cryptd_ablkcipher *cryptd_tfm;
 };
 
-#define AESNI_ALIGN	16
+/* This data is stored at the end of the crypto_tfm struct.
+ * It's a type of per "session" data storage location.
+ * This needs to be 16 byte aligned.
+ */
+struct aesni_rfc4106_gcm_ctx {
+	u8 hash_subkey[16];
+	struct crypto_aes_ctx aes_key_expanded;
+	u8 nonce[4];
+	struct cryptd_aead *cryptd_tfm;
+};
+
+struct aesni_gcm_set_hash_subkey_result {
+	int err;
+	struct completion completion;
+};
+
+struct aesni_hash_subkey_req_data {
+	u8 iv[16];
+	struct aesni_gcm_set_hash_subkey_result result;
+	struct scatterlist sg;
+};
+
+#define AESNI_ALIGN	(16)
 #define AES_BLOCK_MASK	(~(AES_BLOCK_SIZE-1))
+#define RFC4106_HASH_SUBKEY_SIZE 16
 
 asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 			     unsigned int key_len);
@@ -62,6 +97,57 @@ asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx,
u8 *out,
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
+/* asmlinkage void aesni_gcm_enc()
+ * void *ctx,  AES Key schedule. Starts on a 16 byte boundary.
+ * u8 *out, Ciphertext output. Encrypt in-place is allowed.
+ * const u8 *in, Plaintext input
+ * unsigned long plaintext_len, Length of data in bytes for encryption.
+ * u8 *iv, Pre-counter block j0: 4 byte salt (from Security Association)
+ *         concatenated with 8 byte Initialisation Vector (from IPSec ESP
+ *         Payload) concatenated with 0x00000001. 16-byte aligned pointer.
+ * u8 *hash_subkey, the Hash sub key input. Data starts on a 16-byte
boundary.
+ * const u8 *aad, Additional Authentication Data (AAD)
+ * unsigned long aad_len, Length of AAD in bytes. With RFC4106 this
+ *          is going to be 8 or 12 bytes
+ * u8 *auth_tag, Authenticated Tag output.
+ * unsigned long auth_tag_len), Authenticated Tag Length in bytes.
+ *          Valid values are 16 (most likely), 12 or 8.
+ */
+asmlinkage void aesni_gcm_enc(void *ctx, u8 *out,
+			const u8 *in, unsigned long plaintext_len, u8 *iv,
+			u8 *hash_subkey, const u8 *aad, unsigned long
aad_len,
+			u8 *auth_tag, unsigned long auth_tag_len);
+
+/* asmlinkage void aesni_gcm_dec()
+ * void *ctx, AES Key schedule. Starts on a 16 byte boundary.
+ * u8 *out, Plaintext output. Decrypt in-place is allowed.
+ * const u8 *in, Ciphertext input
+ * unsigned long ciphertext_len, Length of data in bytes for decryption.
+ * u8 *iv, Pre-counter block j0: 4 byte salt (from Security Association)
+ *         concatenated with 8 byte Initialisation Vector (from IPSec ESP
+ *         Payload) concatenated with 0x00000001. 16-byte aligned pointer.
+ * u8 *hash_subkey, the Hash sub key input. Data starts on a 16-byte
boundary.
+ * const u8 *aad, Additional Authentication Data (AAD)
+ * unsigned long aad_len, Length of AAD in bytes. With RFC4106 this is
going
+ * to be 8 or 12 bytes
+ * u8 *auth_tag, Authenticated Tag output.
+ * unsigned long auth_tag_len) Authenticated Tag Length in bytes.
+ * Valid values are 16 (most likely), 12 or 8.
+ */
+asmlinkage void aesni_gcm_dec(void *ctx, u8 *out,
+			const u8 *in, unsigned long ciphertext_len, u8 *iv,
+			u8 *hash_subkey, const u8 *aad, unsigned long
aad_len,
+			u8 *auth_tag, unsigned long auth_tag_len);
+
+static inline struct
+aesni_rfc4106_gcm_ctx *aesni_rfc4106_gcm_ctx_get(struct crypto_aead *tfm)
+{
+	return
+		(struct aesni_rfc4106_gcm_ctx *)
+		PTR_ALIGN((u8 *)
+		crypto_tfm_ctx(crypto_aead_tfm(tfm)), AESNI_ALIGN);
+}
+
 static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
 {
 	unsigned long addr = (unsigned long)raw_ctx;
@@ -730,6 +816,422 @@ static struct crypto_alg ablk_xts_alg = {
 };
 #endif
 
+static int rfc4106_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_aead *cryptd_tfm;
+	struct aesni_rfc4106_gcm_ctx *ctx = (struct aesni_rfc4106_gcm_ctx *)
+		PTR_ALIGN((u8 *)crypto_tfm_ctx(tfm), AESNI_ALIGN);
+	cryptd_tfm = cryptd_alloc_aead("__driver-gcm-aes-aesni", 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ctx->cryptd_tfm = cryptd_tfm;
+	tfm->crt_aead.reqsize = sizeof(struct aead_request)
+		+ crypto_aead_reqsize(&cryptd_tfm->base);
+	return 0;
+}
+
+static void rfc4106_exit(struct crypto_tfm *tfm)
+{
+	struct aesni_rfc4106_gcm_ctx *ctx =
+		(struct aesni_rfc4106_gcm_ctx *)
+		PTR_ALIGN((u8 *)crypto_tfm_ctx(tfm), AESNI_ALIGN);
+	if (!IS_ERR(ctx->cryptd_tfm))
+		cryptd_free_aead(ctx->cryptd_tfm);
+	return;
+}
+
+static void
+rfc4106_set_hash_subkey_done(struct crypto_async_request *req, int err)
+{
+	struct aesni_gcm_set_hash_subkey_result *result = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+	result->err = err;
+	complete(&result->completion);
+}
+
+static int
+rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int
key_len)
+{
+	struct crypto_ablkcipher *ctr_tfm;
+	struct ablkcipher_request *req;
+	int ret = -EINVAL;
+	struct aesni_hash_subkey_req_data *req_data;
+
+	ctr_tfm = crypto_alloc_ablkcipher("ctr(aes)", 0, 0);
+	if (IS_ERR(ctr_tfm))
+		return PTR_ERR(ctr_tfm);
+
+	crypto_ablkcipher_clear_flags(ctr_tfm, ~0);
+
+	ret = crypto_ablkcipher_setkey(ctr_tfm, key, key_len);
+	if (ret) {
+		crypto_free_ablkcipher(ctr_tfm);
+		return ret;
+	}
+
+	req = ablkcipher_request_alloc(ctr_tfm, GFP_KERNEL);
+	if (!req) {
+		crypto_free_ablkcipher(ctr_tfm);
+		return -EINVAL;
+	}
+
+	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
+	if (!req_data) {
+		crypto_free_ablkcipher(ctr_tfm);
+		return -ENOMEM;
+	}
+	memset(req_data->iv, 0, sizeof(req_data->iv));
+
+	/* Clear the data in the hash sub key container to zero.*/
+	/* We want to cipher all zeros to create the hash sub key. */
+	memset(hash_subkey, 0, RFC4106_HASH_SUBKEY_SIZE);
+
+	init_completion(&req_data->result.completion);
+	sg_init_one(&req_data->sg, hash_subkey, RFC4106_HASH_SUBKEY_SIZE);
+	ablkcipher_request_set_tfm(req, ctr_tfm);
+	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
+					CRYPTO_TFM_REQ_MAY_BACKLOG,
+					rfc4106_set_hash_subkey_done,
+					&req_data->result);
+
+	ablkcipher_request_set_crypt(req, &req_data->sg,
+		&req_data->sg, RFC4106_HASH_SUBKEY_SIZE, req_data->iv);
+
+	ret = crypto_ablkcipher_encrypt(req);
+	if (ret == -EINPROGRESS || ret == -EBUSY) {
+		ret = wait_for_completion_interruptible
+			(&req_data->result.completion);
+		if (!ret)
+			ret = req_data->result.err;
+	}
+	ablkcipher_request_free(req);
+	kfree(req_data);
+	crypto_free_ablkcipher(ctr_tfm);
+	return ret;
+}
+
+static int rfc4106_set_key(struct crypto_aead *parent, const u8 *key,
+						   unsigned int key_len)
+{
+	int ret = 0;
+	struct crypto_tfm *tfm = crypto_aead_tfm(parent);
+	struct aesni_rfc4106_gcm_ctx *ctx =
aesni_rfc4106_gcm_ctx_get(parent);
+	u8 *new_key_mem = NULL;
+
+	if (key_len < 4) {
+		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	/*Account for 4 byte nonce at the end.*/
+	key_len -= 4;
+	if (key_len != AES_KEYSIZE_128) {
+		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	memcpy(ctx->nonce, key + key_len, sizeof(ctx->nonce));
+	/*This must be on a 16 byte boundary!*/
+	if ((unsigned long)(&(ctx->aes_key_expanded.key_enc[0])) %
AESNI_ALIGN)
+		return -EINVAL;
+
+	if ((unsigned long)key % AESNI_ALIGN) {
+		/*key is not aligned: use an auxuliar aligned pointer*/
+		new_key_mem = kmalloc(key_len+AESNI_ALIGN, GFP_KERNEL);
+		if (!new_key_mem)
+			return -ENOMEM;
+
+		new_key_mem = PTR_ALIGN(new_key_mem, AESNI_ALIGN);
+		memcpy(new_key_mem, key, key_len);
+		key = new_key_mem;
+	}
+
+	if (!irq_fpu_usable())
+		ret = crypto_aes_expand_key(&(ctx->aes_key_expanded),
+		key, key_len);
+	else {
+		kernel_fpu_begin();
+		ret = aesni_set_key(&(ctx->aes_key_expanded), key, key_len);
+		kernel_fpu_end();
+	}
+	/*This must be on a 16 byte boundary!*/
+	if ((unsigned long)(&(ctx->hash_subkey[0])) % AESNI_ALIGN) {
+		ret = -EINVAL;
+		goto exit;
+	}
+	ret = rfc4106_set_hash_subkey(ctx->hash_subkey, key, key_len);
+exit:
+	kfree(new_key_mem);
+	return ret;
+}
+
+/* This is the Integrity Check Value (aka the authentication tag length and
can
+ * be 8, 12 or 16 bytes long. */
+static int rfc4106_set_authsize(struct crypto_aead *parent,
+				unsigned int authsize)
+{
+	struct aesni_rfc4106_gcm_ctx *ctx =
aesni_rfc4106_gcm_ctx_get(parent);
+	struct crypto_aead *cryptd_child =
cryptd_aead_child(ctx->cryptd_tfm);
+
+	switch (authsize) {
+	case 8:
+	case 12:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+	crypto_aead_crt(parent)->authsize = authsize;
+	crypto_aead_crt(cryptd_child)->authsize = authsize;
+	return 0;
+}
+
+static int rfc4106_encrypt(struct aead_request *req)
+{
+	int ret;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
+	struct crypto_aead *cryptd_child =
cryptd_aead_child(ctx->cryptd_tfm);
+
+	if (!irq_fpu_usable()) {
+		struct aead_request *cryptd_req =
+			(struct aead_request *) aead_request_ctx(req);
+		memcpy(cryptd_req, req, sizeof(*req));
+		aead_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
+		return crypto_aead_encrypt(cryptd_req);
+	} else {
+		kernel_fpu_begin();
+		ret = cryptd_child->base.crt_aead.encrypt(req);
+		kernel_fpu_end();
+		return ret;
+	}
+}
+
+static int rfc4106_decrypt(struct aead_request *req)
+{
+	int ret;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
+	struct crypto_aead *cryptd_child =
cryptd_aead_child(ctx->cryptd_tfm);
+
+	if (!irq_fpu_usable()) {
+		struct aead_request *cryptd_req =
+			(struct aead_request *) aead_request_ctx(req);
+		memcpy(cryptd_req, req, sizeof(*req));
+		aead_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
+		return crypto_aead_decrypt(cryptd_req);
+	} else {
+		kernel_fpu_begin();
+		ret = cryptd_child->base.crt_aead.decrypt(req);
+		kernel_fpu_end();
+		return ret;
+	}
+}
+
+static struct crypto_alg rfc4106_alg = {
+	.cra_name = "rfc4106(gcm(aes))",
+	.cra_driver_name = "rfc4106-gcm-aesni",
+	.cra_priority = 400,
+	.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = 1,
+	.cra_ctxsize = sizeof(struct aesni_rfc4106_gcm_ctx) + AESNI_ALIGN,
+	.cra_alignmask = 0,
+	.cra_type = &crypto_nivaead_type,
+	.cra_module = THIS_MODULE,
+	.cra_list = LIST_HEAD_INIT(rfc4106_alg.cra_list),
+	.cra_init = rfc4106_init,
+	.cra_exit = rfc4106_exit,
+	.cra_u = {
+		.aead = {
+			.setkey = rfc4106_set_key,
+			.setauthsize = rfc4106_set_authsize,
+			.encrypt = rfc4106_encrypt,
+			.decrypt = rfc4106_decrypt,
+			.geniv = "seqiv",
+			.ivsize = 8,
+			.maxauthsize = 16,
+		},
+	},
+};
+
+static int __driver_rfc4106_encrypt(struct aead_request *req)
+{
+	u8 one_entry_in_sg = 0;
+	u8 *src, *dst, *assoc;
+	__be32 counter = cpu_to_be32(1);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
+	void *aes_ctx = &(ctx->aes_key_expanded);
+	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
+	u8 iv_tab[16+AESNI_ALIGN];
+	u8* iv = (u8 *) PTR_ALIGN((u8 *)iv_tab, AESNI_ALIGN);
+	struct scatter_walk src_sg_walk;
+	struct scatter_walk assoc_sg_walk;
+	struct scatter_walk dst_sg_walk;
+	unsigned int i;
+
+	/* Assuming we are supporting rfc4106 64-bit extended */
+	/* sequence numbers We need to have the AAD length equal */
+	/* to 8 or 12 bytes */
+	if (unlikely(req->assoclen != 8 && req->assoclen != 12))
+		return -EINVAL;
+	/* IV below built */
+	for (i = 0; i < 4; i++)
+		*(iv+i) = ctx->nonce[i];
+	for (i = 0; i < 8; i++)
+		*(iv+4+i) = req->iv[i];
+	*((__be32 *)(iv+12)) = counter;
+
+	if ((sg_is_last(req->src)) && (sg_is_last(req->assoc))) {
+		one_entry_in_sg = 1;
+		scatterwalk_start(&src_sg_walk, req->src);
+		scatterwalk_start(&assoc_sg_walk, req->assoc);
+		src = scatterwalk_map(&src_sg_walk, 0);
+		assoc = scatterwalk_map(&assoc_sg_walk, 0);
+		dst = src;
+		if (unlikely(req->src != req->dst)) {
+			scatterwalk_start(&dst_sg_walk, req->dst);
+			dst = scatterwalk_map(&dst_sg_walk, 0);
+		}
+
+	} else {
+		/* Allocate memory for src, dst, assoc */
+		src = kmalloc(req->cryptlen + auth_tag_len + req->assoclen,
+			GFP_ATOMIC);
+		if (unlikely(!src))
+			return -ENOMEM;
+		assoc = (src + req->cryptlen + auth_tag_len);
+		scatterwalk_map_and_copy(src, req->src, 0, req->cryptlen,
0);
+		scatterwalk_map_and_copy(assoc, req->assoc, 0,
+					req->assoclen, 0);
+		dst = src;
+	}
+
+	aesni_gcm_enc(aes_ctx, dst, src, (unsigned long)req->cryptlen, iv,
+		ctx->hash_subkey, assoc, (unsigned long)req->assoclen, dst
+		+ ((unsigned long)req->cryptlen), auth_tag_len);
+
+	/* The authTag (aka the Integrity Check Value) needs to be written
+	 * back to the packet. */
+	if (one_entry_in_sg) {
+		if (unlikely(req->src != req->dst)) {
+			scatterwalk_unmap(dst, 0);
+			scatterwalk_done(&dst_sg_walk, 0, 0);
+		}
+		scatterwalk_unmap(src, 0);
+		scatterwalk_unmap(assoc, 0);
+		scatterwalk_done(&src_sg_walk, 0, 0);
+		scatterwalk_done(&assoc_sg_walk, 0, 0);
+	} else {
+		scatterwalk_map_and_copy(dst, req->dst, 0,
+			req->cryptlen + auth_tag_len, 1);
+		kfree(src);
+	}
+	return 0;
+}
+
+static int __driver_rfc4106_decrypt(struct aead_request *req)
+{
+	u8 one_entry_in_sg = 0;
+	u8 *src, *dst, *assoc;
+	unsigned long tempCipherLen = 0;
+	__be32 counter = cpu_to_be32(1);
+	int retval = 0;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
+	void *aes_ctx = &(ctx->aes_key_expanded);
+	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
+	u8 iv_and_authTag[32+AESNI_ALIGN];
+	u8 *iv = (u8 *) PTR_ALIGN((u8 *)iv_and_authTag, AESNI_ALIGN);
+	u8 *authTag = iv + 16;
+	struct scatter_walk src_sg_walk;
+	struct scatter_walk assoc_sg_walk;
+	struct scatter_walk dst_sg_walk;
+	unsigned int i;
+
+	if (unlikely((req->cryptlen < auth_tag_len) ||
+		(req->assoclen != 8 && req->assoclen != 12)))
+		return -EINVAL;
+	/* Assuming we are supporting rfc4106 64-bit extended */
+	/* sequence numbers We need to have the AAD length */
+	/* equal to 8 or 12 bytes */
+
+	tempCipherLen = (unsigned long)(req->cryptlen - auth_tag_len);
+	/* IV below built */
+	for (i = 0; i < 4; i++)
+		*(iv+i) = ctx->nonce[i];
+	for (i = 0; i < 8; i++)
+		*(iv+4+i) = req->iv[i];
+	*((__be32 *)(iv+12)) = counter;
+
+	if ((sg_is_last(req->src)) && (sg_is_last(req->assoc))) {
+		one_entry_in_sg = 1;
+		scatterwalk_start(&src_sg_walk, req->src);
+		scatterwalk_start(&assoc_sg_walk, req->assoc);
+		src = scatterwalk_map(&src_sg_walk, 0);
+		assoc = scatterwalk_map(&assoc_sg_walk, 0);
+		dst = src;
+		if (unlikely(req->src != req->dst)) {
+			scatterwalk_start(&dst_sg_walk, req->dst);
+			dst = scatterwalk_map(&dst_sg_walk, 0);
+		}
+
+	} else {
+		/* Allocate memory for src, dst, assoc */
+		src = kmalloc(req->cryptlen + req->assoclen, GFP_ATOMIC);
+		if (!src)
+			return -ENOMEM;
+		assoc = (src + req->cryptlen + auth_tag_len);
+		scatterwalk_map_and_copy(src, req->src, 0, req->cryptlen,
0);
+		scatterwalk_map_and_copy(assoc, req->assoc, 0,
+			req->assoclen, 0);
+		dst = src;
+	}
+
+	aesni_gcm_dec(aes_ctx, dst, src, tempCipherLen, iv,
+		ctx->hash_subkey, assoc, (unsigned long)req->assoclen,
+		authTag, auth_tag_len);
+
+	/* Compare generated tag with passed in tag. */
+	retval = memcmp(src + tempCipherLen, authTag, auth_tag_len) ?
+		-EBADMSG : 0;
+
+	if (one_entry_in_sg) {
+		if (unlikely(req->src != req->dst)) {
+			scatterwalk_unmap(dst, 0);
+			scatterwalk_done(&dst_sg_walk, 0, 0);
+		}
+		scatterwalk_unmap(src, 0);
+		scatterwalk_unmap(assoc, 0);
+		scatterwalk_done(&src_sg_walk, 0, 0);
+		scatterwalk_done(&assoc_sg_walk, 0, 0);
+	} else {
+		scatterwalk_map_and_copy(dst, req->dst, 0, req->cryptlen,
1);
+		kfree(src);
+	}
+	return retval;
+}
+
+static struct crypto_alg __rfc4106_alg = {
+	.cra_name		= "__gcm-aes-aesni",
+	.cra_driver_name	= "__driver-gcm-aes-aesni",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_AEAD,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct aesni_rfc4106_gcm_ctx) +
AESNI_ALIGN,
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_aead_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(__rfc4106_alg.cra_list),
+	.cra_u = {
+		.aead = {
+			.encrypt	= __driver_rfc4106_encrypt,
+			.decrypt	= __driver_rfc4106_decrypt,
+		},
+	},
+};
+
 static int __init aesni_init(void)
 {
 	int err;
@@ -738,6 +1240,7 @@ static int __init aesni_init(void)
 		printk(KERN_INFO "Intel AES-NI instructions are not
detected.\n");
 		return -ENODEV;
 	}
+
 	if ((err = crypto_register_alg(&aesni_alg)))
 		goto aes_err;
 	if ((err = crypto_register_alg(&__aesni_alg)))
@@ -770,10 +1273,19 @@ static int __init aesni_init(void)
 	if ((err = crypto_register_alg(&ablk_xts_alg)))
 		goto ablk_xts_err;
 #endif
-
+	err = crypto_register_alg(&__rfc4106_alg);
+	if (err)
+		goto __aead_gcm_err;
+	err = crypto_register_alg(&rfc4106_alg);
+	if (err)
+		goto aead_gcm_err;
 	return err;
 
+aead_gcm_err:
+	crypto_unregister_alg(&__rfc4106_alg);
+__aead_gcm_err:
 #ifdef HAS_XTS
+	crypto_unregister_alg(&ablk_xts_alg);
 ablk_xts_err:
 #endif
 #ifdef HAS_PCBC
@@ -809,6 +1321,8 @@ aes_err:
 
 static void __exit aesni_exit(void)
 {
+	crypto_unregister_alg(&__rfc4106_alg);
+	crypto_unregister_alg(&rfc4106_alg);
 #ifdef HAS_XTS
 	crypto_unregister_alg(&ablk_xts_alg);
 #endif
-- 
1.5.3.rc5

On Mon, Sep 20, 2010 at 9:07 AM, Herbert Xu <herbert@gondor.apana.org.au>
wrote:
> On Fri, Sep 10, 2010 at 06:36:24PM +0100, Hoban, Adrian wrote:
>> This patch adds an optimized RFC4106 AES-GCM implementation for 64-bit
>> kernels. It supports 128-bit AES key size. This leverages the crypto
>> AEAD interface type to facilitate a combined AES & GCM operation to
>> be implemented in assembly code. The assembly code leverages Intel(R)
>> AES New Instructions and the PCLMULQDQ instruction.
>>
>> Signed-off-by: Adrian Hoban <adrian.hoban@intel.com>
>> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
>> Signed-off-by: Gabriele Paoloni <gabriele.paoloni@intel.com>
>> Signed-off-by: Aidan O'Mahony <aidan.o.mahony@intel.com>
>> Signed-off-by: Erdinc Ozturk <erdinc.ozturk@intel.com>
>> Signed-off-by: James Guilford <james.guilford@intel.com>
>> Signed-off-by: Edward Clinton <edward.clinton@intel.com>
>> Signed-off-by: Wajdi Feghali <wajdi.k.feghali@intel.com>
>
> I've applied patch 1/3 but 2/3 does not apply because you've
> converted the tabs to spaces.
>
> Please resend patches 2/3 and 3/3 with a cc to yourself and
> double-check that you can still apply the received version.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

------=_NextPart_000_007E_01CB58BE.69599460
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIYITCCAyAw
ggKJoAMCAQICBDXe9M8wDQYJKoZIhvcNAQEFBQAwTjELMAkGA1UEBhMCVVMxEDAOBgNVBAoTB0Vx
dWlmYXgxLTArBgNVBAsTJEVxdWlmYXggU2VjdXJlIENlcnRpZmljYXRlIEF1dGhvcml0eTAeFw05
ODA4MjIxNjQxNTFaFw0xODA4MjIxNjQxNTFaME4xCzAJBgNVBAYTAlVTMRAwDgYDVQQKEwdFcXVp
ZmF4MS0wKwYDVQQLEyRFcXVpZmF4IFNlY3VyZSBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkwgZ8wDQYJ
KoZIhvcNAQEBBQADgY0AMIGJAoGBAMFdsVhnCGLuoJotHwhtkRRomAoe/toEbxOEYiHD0XzOnwXg
uAHwTjTs4oqVBGSs8WtTXwWzy2eAv0ICjv7dAQns4QAUT/z78AzdQ7pbK+EfgHCZFVeTFvEPl2q3
wmgjHMxNWTCsUR47ryvW7mNFe8XZX1DS41APOojnvxT94Me5AgMBAAGjggEJMIIBBTBwBgNVHR8E
aTBnMGWgY6BhpF8wXTELMAkGA1UEBhMCVVMxEDAOBgNVBAoTB0VxdWlmYXgxLTArBgNVBAsTJEVx
dWlmYXggU2VjdXJlIENlcnRpZmljYXRlIEF1dGhvcml0eTENMAsGA1UEAxMEQ1JMMTAaBgNVHRAE
EzARgQ8yMDE4MDgyMjE2NDE1MVowCwYDVR0PBAQDAgEGMB8GA1UdIwQYMBaAFEjmaPkr0rKV10fY
IyAQTzOYkJ/UMB0GA1UdDgQWBBRI5mj5K9KylddH2CMgEE8zmJCf1DAMBgNVHRMEBTADAQH/MBoG
CSqGSIb2fQdBAAQNMAsbBVYzLjBjAwIGwDANBgkqhkiG9w0BAQUFAAOBgQBYzinq/Pfetc4CuRe1
hdG54+CVzCUxDQCmkm5/tpJjnlCV0Zpv5BHeY4VumO6o/1rI01WyZnFX3sAh6z0qpyNJAQSGQnv8
7n+iFlK1Z2fTQNs7JliyKHc9rhR3Ydb6KmYnoA36p3Nc6nDxlCFlRF/6/O8paKmih3nvee9PrAd3
ODCCAz0wggKmoAMCAQICAwWw/zANBgkqhkiG9w0BAQUFADBOMQswCQYDVQQGEwJVUzEQMA4GA1UE
ChMHRXF1aWZheDEtMCsGA1UECxMkRXF1aWZheCBTZWN1cmUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5
MB4XDTA2MDIxNjE4MDEzMFoXDTE2MDIxOTE4MDEzMFowUjELMAkGA1UEBhMCVVMxGjAYBgNVBAoT
EUludGVsIENvcnBvcmF0aW9uMScwJQYDVQQDEx5JbnRlbCBFeHRlcm5hbCBCYXNpYyBQb2xpY3kg
Q0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDBpd/XOb9QVqEZ8mQ1042TdOIq3ATD
IsV2xDyt30yLyMR5Wjtus0bn3B+he89BiNO/LP6+rFzEwlD55PlX+HLGIKeNNG97dqyc30FElEUj
ZzTZFq2N4e3kVJ/XAEEgANzV8v9qp7qWwxugPgfc3z9BkYot+CifozexHLb/hEZj+yISCU61kRZv
uSQ0E11yYL4dRgcglJeaHo3oX57rvIckaLsYV5/1Aj+R8DM1Ppk965XQAKsHfnyT7C4S50T4lVn4
lz36wOdNZn/zegG1zp41lnoTFfT4KuKVJH5x7YD1p6KbgJCKLovnujGuohquBNfdXKpZkvz6pGv+
iC1HawJdAgMBAAGjgaAwgZ0wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBQaxgxKxEdvqNutK/D0
Vgaj7TdUDDA6BgNVHR8EMzAxMC+gLaArhilodHRwOi8vY3JsLmdlb3RydXN0LmNvbS9jcmxzL3Nl
Y3VyZWNhLmNybDAfBgNVHSMEGDAWgBRI5mj5K9KylddH2CMgEE8zmJCf1DAPBgNVHRMBAf8EBTAD
AQH/MA0GCSqGSIb3DQEBBQUAA4GBABMQOK2kVKVIlUWwLTdywJ+e2O+PC/uQltK2F3lRyrPfBn69
tOkIP4SgDJOfsxyobIrPLe75kBLw+Dom13OBDp/EMZJZ1CglQfVV8co9mT3aZMjSGGQiMgkJLR3j
Mfr900fXZKj5XeqCJ+JP0mEhJGEdVCY+FFlksJjV86fDrq1QMIIFYzCCBEugAwIBAgIKYSyl/gAA
AAAABjANBgkqhkiG9w0BAQUFADBSMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9y
YXRpb24xJzAlBgNVBAMTHkludGVsIEV4dGVybmFsIEJhc2ljIFBvbGljeSBDQTAeFw0wNjAzMjIy
MjIyNDdaFw0xMjAzMjIyMjMyNDdaMFYxCzAJBgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBDb3Jw
b3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQjCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMDoHJYUGvcdR4k0Qv8/RrwNX4+vEe5PN2LnGn4x
fIWwdUbk5+zvrRy1HjoKdG/AShZfxAuFoVyNIah5GJLpiS/vGbsDYKK+EZcIcmtPfvbB9Yg09EnQ
0OpsZ2ORRd5lYUfMUU+zkpgL96vKFdkiG+eeHEwnSS3VikGVrF7UDdKfvxZwRwQCx6rEHAFPCjBD
VfGYZuYT1EDhSDvzEiU7KzBsxrdBCFU4RYL7kh+do+vyMDlBzpw3WKvMVbf3s5lxYiY7AjEhU8OS
yZEQlgtK8PNyifHjmyrSaeJrPshM3PuLFG4d3gm1UJEiGNzxcHGb6YLP29IQAwY5mAk8j+UOVcsC
AwEAAaOCAjUwggIxMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFG/DcREooZ0ZV/VnV8/ZKSaI
1aWiMAsGA1UdDwQEAwIBhjAQBgkrBgEEAYI3FQEEAwIBADAZBgkrBgEEAYI3FAIEDB4KAFMAdQBi
AEMAQTAfBgNVHSMEGDAWgBQaxgxKxEdvqNutK/D0Vgaj7TdUDDCBvQYDVR0fBIG1MIGyMIGvoIGs
oIGphk5odHRwOi8vd3d3LmludGVsLmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFs
JTIwQmFzaWMlMjBQb2xpY3klMjBDQS5jcmyGV2h0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29t
L3JlcG9zaXRvcnkvQ1JML0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNy
bDCB4wYIKwYBBQUHAQEEgdYwgdMwYwYIKwYBBQUHMAKGV2h0dHA6Ly93d3cuaW50ZWwuY29tL3Jl
cG9zaXRvcnkvY2VydGlmaWNhdGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUy
MENBLmNydDBsBggrBgEFBQcwAoZgaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3Np
dG9yeS9jZXJ0aWZpY2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwUG9saWN5JTIwQ0Eu
Y3J0MA0GCSqGSIb3DQEBBQUAA4IBAQBAiWWHL6T21QXFZDyaUIye0jh7f40GXqi75Ro5JbpROtlZ
BqyRq6oPMAG6Igxd5Bd9TMtNkOvguknFnK1y17UdMhLOl+FuInE+FAWk803aRW27OsX+ot0KmPio
KnZ3L1K5qcQS3tp6or7AaZzd0w0qFitm4UfP9nnTXQtY9XM5QJ07IKFDE3tlOlamKhjbiJV3FKig
CVesPZSx9h2G7Ve4irEfz915Vks26AJHGZagEHNxM9exkgem4ENsG+t0vYqn9x7YsqJ6fmbOSyrz
jzb3CYeEfyE5SL+f3Vx9uMsQDyb8LVCDBXQtxLEHnFEBPrRSSF9kPmyjavx4UqFdPEyCMIIGAzCC
BOugAwIBAgIKZw1HXAAAAAAjxTANBgkqhkiG9w0BAQUFADBWMQswCQYDVQQGEwJVUzEaMBgGA1UE
ChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3Vp
bmcgQ0EgM0IwHhcNMDgwMTEwMTcyNzE4WhcNMTEwMTA5MTcyNzE4WjBBMRcwFQYDVQQDEw5TdHJ1
aywgVGFkZXVzejEmMCQGCSqGSIb3DQEJARYXdGFkZXVzei5zdHJ1a0BpbnRlbC5jb20wggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQClqSXlOFL/ggjqlQPgWQfbGoOT4yENVEwzZuvK4PeK
OXroeIoKcXFEoprX78QTrkYLDKB61GQk3NJSa2dTS4WAouEJvVEQu0s0E+Y4nTuaXz2SocnNZ/6j
CCOrzel1Ka5F97VDsbySdFsX352mupb7RWS2oFkLDV1uibKQRlBJcwlqDaEJ3lhUhmDMbF3QV6Ub
CJX+Gf43gGbS58QwUCXW2wvWBi/WYtr75OfvxJQt0+OyKz220C6DETxmICrehWb+JXKdQonW95uT
XoSV4dTX+rgVy/nm9QxV8BPU9HtGTE+x56ljiVFo1mXoq1p8NUN5ByAN9k8M4vb9D6u6V/s/AgMB
AAGjggLmMIIC4jALBgNVHQ8EBAMCB4AwHQYDVR0OBBYEFC0UqLUaXF/uJUZuopNj4kJ+HGrvMDwG
CSsGAQQBgjcVBwQvMC0GJSsGAQQBgjcVCIbDjHWEmeVRg/2BKIWOn1OCkcAJZ4HevTmV8EMCAWQC
AQUwHwYDVR0jBBgwFoAUb8NxESihnRlX9WdXz9kpJojVpaIwgckGA1UdHwSBwTCBvjCBu6CBuKCB
tYZUaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwvSW50ZWwlMjBFeHRlcm5hbCUy
MEJhc2ljJTIwSXNzdWluZyUyMENBJTIwM0IuY3Jshl1odHRwOi8vY2VydGlmaWNhdGVzLmludGVs
LmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIw
Q0ElMjAzQi5jcmwwge8GCCsGAQUFBwEBBIHiMIHfMGkGCCsGAQUFBzAChl1odHRwOi8vd3d3Lmlu
dGVsLmNvbS9yZXBvc2l0b3J5L2NlcnRpZmljYXRlcy9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMl
MjBJc3N1aW5nJTIwQ0ElMjAzQi5jcnQwcgYIKwYBBQUHMAKGZmh0dHA6Ly9jZXJ0aWZpY2F0ZXMu
aW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlmaWNhdGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNp
YyUyMElzc3VpbmclMjBDQSUyMDNCLmNydDAfBgNVHSUEGDAWBggrBgEFBQcDBAYKKwYBBAGCNwoD
DDApBgkrBgEEAYI3FQoEHDAaMAoGCCsGAQUFBwMEMAwGCisGAQQBgjcKAwwwSwYDVR0RBEQwQqAn
BgorBgEEAYI3FAIDoBkMF3RhZGV1c3ouc3RydWtAaW50ZWwuY29tgRd0YWRldXN6LnN0cnVrQGlu
dGVsLmNvbTANBgkqhkiG9w0BAQUFAAOCAQEAI92sQcvy3gnSPur4tntIcowUmIUXYCfLBz4kY/Ll
7hnXFWcWPUuocRfveYFGMc6dklCxkQTpJpZ5uTc39GBllWyGvbrC+CcMkDrzTeeSWIdW1qxmXlk1
5vySOVRyP8HmrhQbUIXZwqPx6CwlPu5FRHhxhNMbjWjPgTSHvGTBzcJ4BEHwBwlfb6rOww3v+FNx
UozHcoRpBz9Z1eD1GxjsdqokqTUw3jbEdh8r6U2lLrVIPs2KX5ggoKenHx/y+zEKgtOmHnx74Q17
LiCkMNhMomCmAxh6jAD+0gYkyyGNW4rBbjrd1x+yPNWXDkIveVIpG2+ItvvAOOcyu7Mk3CtrcTCC
BkowggUyoAMCAQICCmsY2okAAAAAI9YwDQYJKoZIhvcNAQEFBQAwVjELMAkGA1UEBhMCVVMxGjAY
BgNVBAoTEUludGVsIENvcnBvcmF0aW9uMSswKQYDVQQDEyJJbnRlbCBFeHRlcm5hbCBCYXNpYyBJ
c3N1aW5nIENBIDNCMB4XDTA4MDExMTEyMTgyMFoXDTExMDExMDEyMTgyMFowQTEXMBUGA1UEAxMO
U3RydWssIFRhZGV1c3oxJjAkBgkqhkiG9w0BCQEWF3RhZGV1c3ouc3RydWtAaW50ZWwuY29tMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnYPdO/c4AwR6kFsc+VmfTh3XklKcIqYwdAl/
g/gZP6QRAufJkBK90/g4Lx/hVwZQQ5itD7Hg1VnJ2GmMibZYeko6w47JX/xTNEl3Qb54xjjI3oG7
E8EQOt6chxIrQvrADY6HtS0e0GvR7KU8lVgpDzmmhtdGM3KfSAWPddKDHonY2nW8UNQRbxlHOVi5
/Buyg1/uZTvAU4j24EyluT92di7m3WfVuNGljAIJdvCvafgHuctaKw30zhLRKddT028bCyzH3rOE
45zV1f1xV6y1WfpvtB3OeD6SsmvWHnkhhTQb5ha3wlncmkFji6xgsbL0e4HHD7DKDGWLupQ/aJQJ
LQIDAQABo4IDLTCCAykwCwYDVR0PBAQDAgQwMEQGCSqGSIb3DQEJDwQ3MDUwDgYIKoZIhvcNAwIC
AgCAMA4GCCqGSIb3DQMEAgIAgDAHBgUrDgMCBzAKBggqhkiG9w0DBzAdBgNVHQ4EFgQUxFOVRH5a
3yrmo/bmsTy+YoXSZQIwPQYJKwYBBAGCNxUHBDAwLgYmKwYBBAGCNxUIhsOMdYSZ5VGD/YEohY6f
U4KRwAlnhLnZQYeE/04CAWQCAQkwHwYDVR0jBBgwFoAUb8NxESihnRlX9WdXz9kpJojVpaIwgckG
A1UdHwSBwTCBvjCBu6CBuKCBtYZUaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwv
SW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwM0IuY3Jshl1odHRwOi8v
Y2VydGlmaWNhdGVzLmludGVsLmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIw
QmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQi5jcmwwge8GCCsGAQUFBwEBBIHiMIHfMGkGCCsGAQUF
BzAChl1odHRwOi8vd3d3LmludGVsLmNvbS9yZXBvc2l0b3J5L2NlcnRpZmljYXRlcy9JbnRlbCUy
MEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQi5jcnQwcgYIKwYBBQUHMAKGZmh0
dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlmaWNhdGVzL0ludGVs
JTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUyMDNCLmNydDAfBgNVHSUEGDAWBggr
BgEFBQcDBAYKKwYBBAGCNwoDBDApBgkrBgEEAYI3FQoEHDAaMAoGCCsGAQUFBwMEMAwGCisGAQQB
gjcKAwQwSwYDVR0RBEQwQqAnBgorBgEEAYI3FAIDoBkMF3RhZGV1c3ouc3RydWtAaW50ZWwuY29t
gRd0YWRldXN6LnN0cnVrQGludGVsLmNvbTANBgkqhkiG9w0BAQUFAAOCAQEArsRWL+cURG5dEUkU
dY8MLw2a7l2jDkqeoqandVwUdHxNTGz2mInJKZixCCCZKlDxnt/D11N+FNVFmK4FA6r3Eht2xZCZ
/uOXlsBkD4i2YbfZlcgRuvCbJMb8Hx3ioFrgszavij5/A+z0TwIAMY1lkJAZlTHjbfmAjPF43eiR
UWV9yoJecQi9Afcmei7E/zi77ob8Xi7HYZPcpQ2WKORCrTYwk+VphDwyDx12vdpaYVtUKpvzGdRw
5rT9Ma9N7EajhMbbCxFA3os83GHF1eLdQclsMbn1o3+J5KHr0rFaPcrFwEGhKsRgYr3Tgc9rU23r
9C+5RJzJWhAVS12PknyQaTGCA0EwggM9AgEBMGQwVjELMAkGA1UEBhMCVVMxGjAYBgNVBAoTEUlu
dGVsIENvcnBvcmF0aW9uMSswKQYDVQQDEyJJbnRlbCBFeHRlcm5hbCBCYXNpYyBJc3N1aW5nIENB
IDNCAgpnDUdcAAAAACPFMAkGBSsOAwIaBQCgggGyMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEw
HAYJKoZIhvcNAQkFMQ8XDTEwMDkyMDExMjE1NFowIwYJKoZIhvcNAQkEMRYEFEKSsIAbP3iLEOQH
7to9JVN6jHN3MGcGCSqGSIb3DQEJDzFaMFgwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0G
CCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMAcGBSsOAwIaMAoGCCqGSIb3DQIF
MHMGCSsGAQQBgjcQBDFmMGQwVjELMAkGA1UEBhMCVVMxGjAYBgNVBAoTEUludGVsIENvcnBvcmF0
aW9uMSswKQYDVQQDEyJJbnRlbCBFeHRlcm5hbCBCYXNpYyBJc3N1aW5nIENBIDNCAgprGNqJAAAA
ACPWMHUGCyqGSIb3DQEJEAILMWagZDBWMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29y
cG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0EgM0ICCmsY
2okAAAAAI9YwDQYJKoZIhvcNAQEBBQAEggEAdrYpIYO6HBvsztd3Azj20cRth7SbecTfe5uobmXJ
SHk54164WCd/zyQSvQdKcEqWIWYkCJBirVBg7oxG1HwpZBAsdQzQui6MSEIdsrenznSfKkfWe5cW
7k3JVtLXeAdzWRTODE07ZKYeboAUTzZi/kJQzABcrOLgkEjlD2+4JXEzknm4uYI1mXxO2v4u9fFc
gXc6DUaIS/9tBNF/Ad9eaOeUkgqq/GvFL9P/M7xVW/cGxEMZpwMRm6kdbBs0Z2YAvJTu6eoHiR+z
HsLaeDC9qUeP7kUtfnK7HbZPcM/Bvkr1B97z8aWN/9RxvylYFdVhxkONDteYFtKTzieFk/EttwAA
AAAAAA==

------=_NextPart_000_007E_01CB58BE.69599460--
--===============0195476355==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the s=
ole use of the intended recipient(s). Any review or distribution by others =
is strictly prohibited. If you are not the intended recipient, please conta=
ct the sender and delete all copies.


--===============0195476355==--
