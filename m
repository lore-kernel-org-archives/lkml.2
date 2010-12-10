Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0LJMeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 07:34:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:10662 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab0LJMeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 07:34:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,323,1288594800"; 
   d="scan'208,223";a="866733937"
Date: Fri, 10 Dec 2010 12:34:07 +0000
From: tadeusz.struk@intel.com
To: herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        akpm@linux-foundation.org, aidan.o.mahony@intel.com,
        gabriele.paoloni@intel.com, adrian.hoban@intel.com,
        tadeusz.struk@intel.com
Subject: [PATCH 2/3 v2] RFC4106 AES-GCM Driver Using Intel New
 Instructions - fixed build with binutils 2.16
Message-ID: <4d021e3f.GLP/bq7kQUH5U6yI%tadeusz.struk@intel.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From tadeusz.struk@intel.com Mon Sep 17 00:00:00 2001
From: root <root@tweedle-dum.ir.intel.com>
Date: Fri, 10 Dec 2010 12:10:57 +0000
Subject: [PATCH 2/3 v2] RFC4106 AES-GCM Driver Using Intel New Instructions - fixed build with binutils 2.16

Hi Herbert,
This patch fixes the problem with 2.16 binutils.
Regards,
Tadeusz

Signed-off-by: Aidan O'Mahony <aidan.o.mahony@intel.com>
Signed-off-by: Adrian Hoban <adrian.hoban@intel.com>
Signed-off-by: Gabriele Paoloni <gabriele.paoloni@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 arch/x86/crypto/aesni-intel_asm.S |  598 ++++++++++++++++++++++++++++++++-----
 1 files changed, 519 insertions(+), 79 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index d528fde..8fe2a49 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -204,9 +204,9 @@ enc:        .octa 0x2
 * arg1, %arg2, %arg3, %r14 are used as a pointer only, not modified
 */
 
-.macro INITIAL_BLOCKS num_initial_blocks TMP1 TMP2 TMP3 TMP4 TMP5 XMM0 XMM1 \
-XMM2 XMM3 XMM4 XMMDst TMP6 TMP7 i i_seq operation
 
+.macro INITIAL_BLOCKS_DEC num_initial_blocks TMP1 TMP2 TMP3 TMP4 TMP5 XMM0 XMM1 \
+XMM2 XMM3 XMM4 XMMDst TMP6 TMP7 i i_seq operation
 	mov	   arg7, %r10           # %r10 = AAD
 	mov	   arg8, %r12           # %r12 = aadLen
 	mov	   %r12, %r11
@@ -228,19 +228,25 @@ _get_AAD_loop2\num_initial_blocks\operation:
 	cmp	   %r11, %r12
 	jne	   _get_AAD_loop2\num_initial_blocks\operation
 _get_AAD_loop2_done\num_initial_blocks\operation:
-	pshufb	   SHUF_MASK(%rip), %xmm\i # byte-reflect the AAD data
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM   %xmm14, %xmm\i # byte-reflect the AAD data
+
 	xor	   %r11, %r11 # initialise the data pointer offset as zero
 
         # start AES for num_initial_blocks blocks
 
 	mov	   %arg5, %rax                      # %rax = *Y0
 	movdqu	   (%rax), \XMM0                    # XMM0 = Y0
-	pshufb	   SHUF_MASK(%rip), \XMM0
-.if \i_seq != 0
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM   %xmm14, \XMM0
+
+.if (\i == 5) || (\i == 6) || (\i == 7)
 .irpc index, \i_seq
 	paddd	   ONE(%rip), \XMM0                 # INCR Y0
 	movdqa	   \XMM0, %xmm\index
-	pshufb	   SHUF_MASK(%rip), %xmm\index      # perform a 16 byte swap
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM   %xmm14, %xmm\index      # perform a 16 byte swap
+
 .endr
 .irpc index, \i_seq
 	pxor	   16*0(%arg1), %xmm\index
@@ -291,10 +297,11 @@ _get_AAD_loop2_done\num_initial_blocks\operation:
 	movdqu	   %xmm\index, (%arg2 , %r11, 1)
 	# write back plaintext/ciphertext for num_initial_blocks
 	add	   $16, %r11
-.if \operation == dec
+
 	movdqa     \TMP1, %xmm\index
-.endif
-	pshufb	   SHUF_MASK(%rip), %xmm\index
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM	   %xmm14, %xmm\index
+
 		# prepare plaintext/ciphertext for GHASH computation
 .endr
 .endif
@@ -327,16 +334,24 @@ _get_AAD_loop2_done\num_initial_blocks\operation:
 */
 	paddd	   ONE(%rip), \XMM0              # INCR Y0
 	movdqa	   \XMM0, \XMM1
-	pshufb	   SHUF_MASK(%rip), \XMM1        # perform a 16 byte swap
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM  %xmm14, \XMM1        # perform a 16 byte swap
+
 	paddd	   ONE(%rip), \XMM0              # INCR Y0
 	movdqa	   \XMM0, \XMM2
-	pshufb	   SHUF_MASK(%rip), \XMM2        # perform a 16 byte swap
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM  %xmm14, \XMM2        # perform a 16 byte swap
+
 	paddd	   ONE(%rip), \XMM0              # INCR Y0
 	movdqa	   \XMM0, \XMM3
-	pshufb	   SHUF_MASK(%rip), \XMM3        # perform a 16 byte swap
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM %xmm14, \XMM3        # perform a 16 byte swap
+
 	paddd	   ONE(%rip), \XMM0              # INCR Y0
 	movdqa	   \XMM0, \XMM4
-	pshufb	   SHUF_MASK(%rip), \XMM4        # perform a 16 byte swap
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM %xmm14, \XMM4        # perform a 16 byte swap
+
 	pxor	   16*0(%arg1), \XMM1
 	pxor	   16*0(%arg1), \XMM2
 	pxor	   16*0(%arg1), \XMM3
@@ -385,41 +400,268 @@ _get_AAD_loop2_done\num_initial_blocks\operation:
 	AESENCLAST \TMP2, \XMM4
 	movdqu	   16*0(%arg3 , %r11 , 1), \TMP1
 	pxor	   \TMP1, \XMM1
-.if \operation == dec
 	movdqu	   \XMM1, 16*0(%arg2 , %r11 , 1)
 	movdqa     \TMP1, \XMM1
-.endif
 	movdqu	   16*1(%arg3 , %r11 , 1), \TMP1
 	pxor	   \TMP1, \XMM2
-.if \operation == dec
 	movdqu	   \XMM2, 16*1(%arg2 , %r11 , 1)
 	movdqa     \TMP1, \XMM2
-.endif
 	movdqu	   16*2(%arg3 , %r11 , 1), \TMP1
 	pxor	   \TMP1, \XMM3
-.if \operation == dec
 	movdqu	   \XMM3, 16*2(%arg2 , %r11 , 1)
 	movdqa     \TMP1, \XMM3
-.endif
 	movdqu	   16*3(%arg3 , %r11 , 1), \TMP1
 	pxor	   \TMP1, \XMM4
-.if \operation == dec
 	movdqu	   \XMM4, 16*3(%arg2 , %r11 , 1)
 	movdqa     \TMP1, \XMM4
-.else
+	add	   $64, %r11
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM %xmm14, \XMM1 # perform a 16 byte swap
+	pxor	   \XMMDst, \XMM1
+# combine GHASHed value with the corresponding ciphertext
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM %xmm14, \XMM2 # perform a 16 byte swap
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM %xmm14, \XMM3 # perform a 16 byte swap
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM %xmm14, \XMM4 # perform a 16 byte swap
+
+_initial_blocks_done\num_initial_blocks\operation:
+
+.endm
+
+
+/*
+* if a = number of total plaintext bytes
+* b = floor(a/16)
+* num_initial_blocks = b mod 4
+* encrypt the initial num_initial_blocks blocks and apply ghash on
+* the ciphertext
+* %r10, %r11, %r12, %rax, %xmm5, %xmm6, %xmm7, %xmm8, %xmm9 registers
+* are clobbered
+* arg1, %arg2, %arg3, %r14 are used as a pointer only, not modified
+*/
+
+
+.macro INITIAL_BLOCKS_ENC num_initial_blocks TMP1 TMP2 TMP3 TMP4 TMP5 XMM0 XMM1 \
+XMM2 XMM3 XMM4 XMMDst TMP6 TMP7 i i_seq operation
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
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM   %xmm14, %xmm\i # byte-reflect the AAD data
+
+	xor	   %r11, %r11 # initialise the data pointer offset as zero
+
+        # start AES for num_initial_blocks blocks
+
+	mov	   %arg5, %rax                      # %rax = *Y0
+	movdqu	   (%rax), \XMM0                    # XMM0 = Y0
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM   %xmm14, \XMM0
+
+.if (\i == 5) || (\i == 6) || (\i == 7)
+.irpc index, \i_seq
+	paddd	   ONE(%rip), \XMM0                 # INCR Y0
+	movdqa	   \XMM0, %xmm\index
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM   %xmm14, %xmm\index      # perform a 16 byte swap
+
+.endr
+.irpc index, \i_seq
+	pxor	   16*0(%arg1), %xmm\index
+.endr
+.irpc index, \i_seq
+	movaps 0x10(%rdi), \TMP1
+	AESENC     \TMP1, %xmm\index          # Round 1
+.endr
+.irpc index, \i_seq
+	movaps 0x20(%arg1), \TMP1
+	AESENC     \TMP1, %xmm\index          # Round 2
+.endr
+.irpc index, \i_seq
+	movaps 0x30(%arg1), \TMP1
+	AESENC     \TMP1, %xmm\index          # Round 2
+.endr
+.irpc index, \i_seq
+	movaps 0x40(%arg1), \TMP1
+	AESENC     \TMP1, %xmm\index          # Round 2
+.endr
+.irpc index, \i_seq
+	movaps 0x50(%arg1), \TMP1
+	AESENC     \TMP1, %xmm\index          # Round 2
+.endr
+.irpc index, \i_seq
+	movaps 0x60(%arg1), \TMP1
+	AESENC     \TMP1, %xmm\index          # Round 2
+.endr
+.irpc index, \i_seq
+	movaps 0x70(%arg1), \TMP1
+	AESENC     \TMP1, %xmm\index          # Round 2
+.endr
+.irpc index, \i_seq
+	movaps 0x80(%arg1), \TMP1
+	AESENC     \TMP1, %xmm\index          # Round 2
+.endr
+.irpc index, \i_seq
+	movaps 0x90(%arg1), \TMP1
+	AESENC     \TMP1, %xmm\index          # Round 2
+.endr
+.irpc index, \i_seq
+	movaps 0xa0(%arg1), \TMP1
+	AESENCLAST \TMP1, %xmm\index         # Round 10
+.endr
+.irpc index, \i_seq
+	movdqu	   (%arg3 , %r11, 1), \TMP1
+	pxor	   \TMP1, %xmm\index
+	movdqu	   %xmm\index, (%arg2 , %r11, 1)
+	# write back plaintext/ciphertext for num_initial_blocks
+	add	   $16, %r11
+
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM	   %xmm14, %xmm\index
+
+		# prepare plaintext/ciphertext for GHASH computation
+.endr
+.endif
+	GHASH_MUL  %xmm\i, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
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
+	jl	_initial_blocks_done\num_initial_blocks\operation
+	# no need for precomputed values
+/*
+*
+* Precomputations for HashKey parallel with encryption of first 4 blocks.
+* Haskey_i_k holds XORed values of the low and high parts of the Haskey_i
+*/
+	paddd	   ONE(%rip), \XMM0              # INCR Y0
+	movdqa	   \XMM0, \XMM1
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM  %xmm14, \XMM1        # perform a 16 byte swap
+
+	paddd	   ONE(%rip), \XMM0              # INCR Y0
+	movdqa	   \XMM0, \XMM2
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM  %xmm14, \XMM2        # perform a 16 byte swap
+
+	paddd	   ONE(%rip), \XMM0              # INCR Y0
+	movdqa	   \XMM0, \XMM3
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM %xmm14, \XMM3        # perform a 16 byte swap
+
+	paddd	   ONE(%rip), \XMM0              # INCR Y0
+	movdqa	   \XMM0, \XMM4
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM %xmm14, \XMM4        # perform a 16 byte swap
+
+	pxor	   16*0(%arg1), \XMM1
+	pxor	   16*0(%arg1), \XMM2
+	pxor	   16*0(%arg1), \XMM3
+	pxor	   16*0(%arg1), \XMM4
+	movdqa	   \TMP3, \TMP5
+	pshufd	   $78, \TMP3, \TMP1
+	pxor	   \TMP3, \TMP1
+	movdqa	   \TMP1, HashKey_k(%rsp)
+	GHASH_MUL  \TMP5, \TMP3, \TMP1, \TMP2, \TMP4, \TMP6, \TMP7
+# TMP5 = HashKey^2<<1 (mod poly)
+	movdqa	   \TMP5, HashKey_2(%rsp)
+# HashKey_2 = HashKey^2<<1 (mod poly)
+	pshufd	   $78, \TMP5, \TMP1
+	pxor	   \TMP5, \TMP1
+	movdqa	   \TMP1, HashKey_2_k(%rsp)
+.irpc index, 1234 # do 4 rounds
+	movaps 0x10*\index(%arg1), \TMP1
+	AESENC	   \TMP1, \XMM1
+	AESENC	   \TMP1, \XMM2
+	AESENC	   \TMP1, \XMM3
+	AESENC	   \TMP1, \XMM4
+.endr
+	GHASH_MUL  \TMP5, \TMP3, \TMP1, \TMP2, \TMP4, \TMP6, \TMP7
+# TMP5 = HashKey^3<<1 (mod poly)
+	movdqa	   \TMP5, HashKey_3(%rsp)
+	pshufd	   $78, \TMP5, \TMP1
+	pxor	   \TMP5, \TMP1
+	movdqa	   \TMP1, HashKey_3_k(%rsp)
+.irpc index, 56789 # do next 5 rounds
+	movaps 0x10*\index(%arg1), \TMP1
+	AESENC	   \TMP1, \XMM1
+	AESENC	   \TMP1, \XMM2
+	AESENC	   \TMP1, \XMM3
+	AESENC	   \TMP1, \XMM4
+.endr
+	GHASH_MUL  \TMP5, \TMP3, \TMP1, \TMP2, \TMP4, \TMP6, \TMP7
+# TMP5 = HashKey^3<<1 (mod poly)
+	movdqa	   \TMP5, HashKey_4(%rsp)
+	pshufd	   $78, \TMP5, \TMP1
+	pxor	   \TMP5, \TMP1
+	movdqa	   \TMP1, HashKey_4_k(%rsp)
+	movaps 0xa0(%arg1), \TMP2
+	AESENCLAST \TMP2, \XMM1
+	AESENCLAST \TMP2, \XMM2
+	AESENCLAST \TMP2, \XMM3
+	AESENCLAST \TMP2, \XMM4
+	movdqu	   16*0(%arg3 , %r11 , 1), \TMP1
+	pxor	   \TMP1, \XMM1
+	movdqu	   16*1(%arg3 , %r11 , 1), \TMP1
+	pxor	   \TMP1, \XMM2
+	movdqu	   16*2(%arg3 , %r11 , 1), \TMP1
+	pxor	   \TMP1, \XMM3
+	movdqu	   16*3(%arg3 , %r11 , 1), \TMP1
+	pxor	   \TMP1, \XMM4
 	movdqu     \XMM1, 16*0(%arg2 , %r11 , 1)
 	movdqu     \XMM2, 16*1(%arg2 , %r11 , 1)
 	movdqu     \XMM3, 16*2(%arg2 , %r11 , 1)
 	movdqu     \XMM4, 16*3(%arg2 , %r11 , 1)
-.endif
+
 	add	   $64, %r11
-	pshufb	   SHUF_MASK(%rip), \XMM1 # perform a 16 byte swap
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM %xmm14, \XMM1 # perform a 16 byte swap
 	pxor	   \XMMDst, \XMM1
 # combine GHASHed value with the corresponding ciphertext
-	pshufb	   SHUF_MASK(%rip), \XMM2 # perform a 16 byte swap
-	pshufb	   SHUF_MASK(%rip), \XMM3 # perform a 16 byte swap
-	pshufb	   SHUF_MASK(%rip), \XMM4 # perform a 16 byte swap
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM %xmm14, \XMM2 # perform a 16 byte swap
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM %xmm14, \XMM3 # perform a 16 byte swap
+        movdqa     SHUF_MASK(%rip), %xmm14
+	PSHUFB_XMM %xmm14, \XMM4 # perform a 16 byte swap
+
 _initial_blocks_done\num_initial_blocks\operation:
+
 .endm
 
 /*
@@ -428,7 +670,199 @@ _initial_blocks_done\num_initial_blocks\operation:
 * arg1, %arg2, %arg3 are used as pointers only, not modified
 * %r11 is the data offset value
 */
-.macro GHASH_4_ENCRYPT_4_PARALLEL TMP1 TMP2 TMP3 TMP4 TMP5 \
+.macro GHASH_4_ENCRYPT_4_PARALLEL_ENC TMP1 TMP2 TMP3 TMP4 TMP5 \
+TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
+
+	movdqa	  \XMM1, \XMM5
+	movdqa	  \XMM2, \XMM6
+	movdqa	  \XMM3, \XMM7
+	movdqa	  \XMM4, \XMM8
+
+        movdqa    SHUF_MASK(%rip), %xmm15
+        # multiply TMP5 * HashKey using karatsuba
+
+	movdqa	  \XMM5, \TMP4
+	pshufd	  $78, \XMM5, \TMP6
+	pxor	  \XMM5, \TMP6
+	paddd     ONE(%rip), \XMM0		# INCR CNT
+	movdqa	  HashKey_4(%rsp), \TMP5
+	PCLMULQDQ 0x11, \TMP5, \TMP4           # TMP4 = a1*b1
+	movdqa    \XMM0, \XMM1
+	paddd     ONE(%rip), \XMM0		# INCR CNT
+	movdqa    \XMM0, \XMM2
+	paddd     ONE(%rip), \XMM0		# INCR CNT
+	movdqa    \XMM0, \XMM3
+	paddd     ONE(%rip), \XMM0		# INCR CNT
+	movdqa    \XMM0, \XMM4
+	PSHUFB_XMM %xmm15, \XMM1	# perform a 16 byte swap
+	PCLMULQDQ 0x00, \TMP5, \XMM5           # XMM5 = a0*b0
+	PSHUFB_XMM %xmm15, \XMM2	# perform a 16 byte swap
+	PSHUFB_XMM %xmm15, \XMM3	# perform a 16 byte swap
+	PSHUFB_XMM %xmm15, \XMM4	# perform a 16 byte swap
+
+	pxor	  (%arg1), \XMM1
+	pxor	  (%arg1), \XMM2
+	pxor	  (%arg1), \XMM3
+	pxor	  (%arg1), \XMM4
+	movdqa	  HashKey_4_k(%rsp), \TMP5
+	PCLMULQDQ 0x00, \TMP5, \TMP6           # TMP6 = (a1+a0)*(b1+b0)
+	movaps 0x10(%arg1), \TMP1
+	AESENC	  \TMP1, \XMM1              # Round 1
+	AESENC	  \TMP1, \XMM2
+	AESENC	  \TMP1, \XMM3
+	AESENC	  \TMP1, \XMM4
+	movaps 0x20(%arg1), \TMP1
+	AESENC	  \TMP1, \XMM1              # Round 2
+	AESENC	  \TMP1, \XMM2
+	AESENC	  \TMP1, \XMM3
+	AESENC	  \TMP1, \XMM4
+	movdqa	  \XMM6, \TMP1
+	pshufd	  $78, \XMM6, \TMP2
+	pxor	  \XMM6, \TMP2
+	movdqa	  HashKey_3(%rsp), \TMP5
+	PCLMULQDQ 0x11, \TMP5, \TMP1           # TMP1 = a1 * b1
+	movaps 0x30(%arg1), \TMP3
+	AESENC    \TMP3, \XMM1              # Round 3
+	AESENC    \TMP3, \XMM2
+	AESENC    \TMP3, \XMM3
+	AESENC    \TMP3, \XMM4
+	PCLMULQDQ 0x00, \TMP5, \XMM6           # XMM6 = a0*b0
+	movaps 0x40(%arg1), \TMP3
+	AESENC	  \TMP3, \XMM1              # Round 4
+	AESENC	  \TMP3, \XMM2
+	AESENC	  \TMP3, \XMM3
+	AESENC	  \TMP3, \XMM4
+	movdqa	  HashKey_3_k(%rsp), \TMP5
+	PCLMULQDQ 0x00, \TMP5, \TMP2           # TMP2 = (a1+a0)*(b1+b0)
+	movaps 0x50(%arg1), \TMP3
+	AESENC	  \TMP3, \XMM1              # Round 5
+	AESENC	  \TMP3, \XMM2
+	AESENC	  \TMP3, \XMM3
+	AESENC	  \TMP3, \XMM4
+	pxor	  \TMP1, \TMP4
+# accumulate the results in TMP4:XMM5, TMP6 holds the middle part
+	pxor	  \XMM6, \XMM5
+	pxor	  \TMP2, \TMP6
+	movdqa	  \XMM7, \TMP1
+	pshufd	  $78, \XMM7, \TMP2
+	pxor	  \XMM7, \TMP2
+	movdqa	  HashKey_2(%rsp ), \TMP5
+
+        # Multiply TMP5 * HashKey using karatsuba
+
+	PCLMULQDQ 0x11, \TMP5, \TMP1           # TMP1 = a1*b1
+	movaps 0x60(%arg1), \TMP3
+	AESENC	  \TMP3, \XMM1              # Round 6
+	AESENC	  \TMP3, \XMM2
+	AESENC	  \TMP3, \XMM3
+	AESENC	  \TMP3, \XMM4
+	PCLMULQDQ 0x00, \TMP5, \XMM7           # XMM7 = a0*b0
+	movaps 0x70(%arg1), \TMP3
+	AESENC	  \TMP3, \XMM1             # Round 7
+	AESENC	  \TMP3, \XMM2
+	AESENC	  \TMP3, \XMM3
+	AESENC	  \TMP3, \XMM4
+	movdqa	  HashKey_2_k(%rsp), \TMP5
+	PCLMULQDQ 0x00, \TMP5, \TMP2           # TMP2 = (a1+a0)*(b1+b0)
+	movaps 0x80(%arg1), \TMP3
+	AESENC	  \TMP3, \XMM1             # Round 8
+	AESENC	  \TMP3, \XMM2
+	AESENC	  \TMP3, \XMM3
+	AESENC	  \TMP3, \XMM4
+	pxor	  \TMP1, \TMP4
+# accumulate the results in TMP4:XMM5, TMP6 holds the middle part
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
+	PCLMULQDQ 0x11, \TMP5, \TMP1          # TMP1 = a1*b1
+	movaps 0x90(%arg1), \TMP3
+	AESENC	  \TMP3, \XMM1            # Round 9
+	AESENC	  \TMP3, \XMM2
+	AESENC	  \TMP3, \XMM3
+	AESENC	  \TMP3, \XMM4
+	PCLMULQDQ 0x00, \TMP5, \XMM8          # XMM8 = a0*b0
+	movaps 0xa0(%arg1), \TMP3
+	AESENCLAST \TMP3, \XMM1           # Round 10
+	AESENCLAST \TMP3, \XMM2
+	AESENCLAST \TMP3, \XMM3
+	AESENCLAST \TMP3, \XMM4
+	movdqa    HashKey_k(%rsp), \TMP5
+	PCLMULQDQ 0x00, \TMP5, \TMP2          # TMP2 = (a1+a0)*(b1+b0)
+	movdqu	  (%arg3,%r11,1), \TMP3
+	pxor	  \TMP3, \XMM1                 # Ciphertext/Plaintext XOR EK
+	movdqu	  16(%arg3,%r11,1), \TMP3
+	pxor	  \TMP3, \XMM2                 # Ciphertext/Plaintext XOR EK
+	movdqu	  32(%arg3,%r11,1), \TMP3
+	pxor	  \TMP3, \XMM3                 # Ciphertext/Plaintext XOR EK
+	movdqu	  48(%arg3,%r11,1), \TMP3
+	pxor	  \TMP3, \XMM4                 # Ciphertext/Plaintext XOR EK
+        movdqu    \XMM1, (%arg2,%r11,1)        # Write to the ciphertext buffer
+        movdqu    \XMM2, 16(%arg2,%r11,1)      # Write to the ciphertext buffer
+        movdqu    \XMM3, 32(%arg2,%r11,1)      # Write to the ciphertext buffer
+        movdqu    \XMM4, 48(%arg2,%r11,1)      # Write to the ciphertext buffer
+	PSHUFB_XMM %xmm15, \XMM1        # perform a 16 byte swap
+	PSHUFB_XMM %xmm15, \XMM2	# perform a 16 byte swap
+	PSHUFB_XMM %xmm15, \XMM3	# perform a 16 byte swap
+	PSHUFB_XMM %xmm15, \XMM4	# perform a 16 byte swap
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
+	pxor	  \TMP2, \TMP1	  # accumulate the results in TMP1:XMM5
+
+        # first phase of reduction
+
+	movdqa    \XMM5, \TMP2
+	movdqa    \XMM5, \TMP3
+	movdqa    \XMM5, \TMP4
+# move XMM5 into TMP2, TMP3, TMP4 in order to perform shifts independently
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
+	movdqa    \XMM5,\TMP2 # make 3 copies of XMM5 into TMP2, TMP3, TMP4
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
+/*
+* decrypt 4 blocks at a time
+* ghash the 4 previously decrypted ciphertext blocks
+* arg1, %arg2, %arg3 are used as pointers only, not modified
+* %r11 is the data offset value
+*/
+.macro GHASH_4_ENCRYPT_4_PARALLEL_DEC TMP1 TMP2 TMP3 TMP4 TMP5 \
 TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 
 	movdqa	  \XMM1, \XMM5
@@ -436,6 +870,7 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 	movdqa	  \XMM3, \XMM7
 	movdqa	  \XMM4, \XMM8
 
+        movdqa    SHUF_MASK(%rip), %xmm15
         # multiply TMP5 * HashKey using karatsuba
 
 	movdqa	  \XMM5, \TMP4
@@ -451,11 +886,12 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 	movdqa    \XMM0, \XMM3
 	paddd     ONE(%rip), \XMM0		# INCR CNT
 	movdqa    \XMM0, \XMM4
-	pshufb	  SHUF_MASK(%rip), \XMM1	# perform a 16 byte swap
+	PSHUFB_XMM %xmm15, \XMM1	# perform a 16 byte swap
 	PCLMULQDQ 0x00, \TMP5, \XMM5           # XMM5 = a0*b0
-	pshufb	  SHUF_MASK(%rip), \XMM2	# perform a 16 byte swap
-	pshufb	  SHUF_MASK(%rip), \XMM3	# perform a 16 byte swap
-	pshufb	  SHUF_MASK(%rip), \XMM4	# perform a 16 byte swap
+	PSHUFB_XMM %xmm15, \XMM2	# perform a 16 byte swap
+	PSHUFB_XMM %xmm15, \XMM3	# perform a 16 byte swap
+	PSHUFB_XMM %xmm15, \XMM4	# perform a 16 byte swap
+
 	pxor	  (%arg1), \XMM1
 	pxor	  (%arg1), \XMM2
 	pxor	  (%arg1), \XMM3
@@ -553,37 +989,24 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 	PCLMULQDQ 0x00, \TMP5, \TMP2          # TMP2 = (a1+a0)*(b1+b0)
 	movdqu	  (%arg3,%r11,1), \TMP3
 	pxor	  \TMP3, \XMM1                 # Ciphertext/Plaintext XOR EK
-.if \operation == dec
 	movdqu	  \XMM1, (%arg2,%r11,1)        # Write to plaintext buffer
 	movdqa    \TMP3, \XMM1
-.endif
 	movdqu	  16(%arg3,%r11,1), \TMP3
 	pxor	  \TMP3, \XMM2                 # Ciphertext/Plaintext XOR EK
-.if \operation == dec
 	movdqu	  \XMM2, 16(%arg2,%r11,1)      # Write to plaintext buffer
 	movdqa    \TMP3, \XMM2
-.endif
 	movdqu	  32(%arg3,%r11,1), \TMP3
 	pxor	  \TMP3, \XMM3                 # Ciphertext/Plaintext XOR EK
-.if \operation == dec
 	movdqu	  \XMM3, 32(%arg2,%r11,1)      # Write to plaintext buffer
 	movdqa    \TMP3, \XMM3
-.endif
 	movdqu	  48(%arg3,%r11,1), \TMP3
 	pxor	  \TMP3, \XMM4                 # Ciphertext/Plaintext XOR EK
-.if \operation == dec
 	movdqu	  \XMM4, 48(%arg2,%r11,1)      # Write to plaintext buffer
 	movdqa    \TMP3, \XMM4
-.else
-    movdqu    \XMM1, (%arg2,%r11,1)        # Write to the ciphertext buffer
-    movdqu    \XMM2, 16(%arg2,%r11,1)      # Write to the ciphertext buffer
-    movdqu    \XMM3, 32(%arg2,%r11,1)      # Write to the ciphertext buffer
-    movdqu    \XMM4, 48(%arg2,%r11,1)      # Write to the ciphertext buffer
-.endif
-	pshufb	  SHUF_MASK(%rip), \XMM1       # perform a 16 byte swap
-	pshufb	  SHUF_MASK(%rip), \XMM2       # perform a 16 byte swap
-	pshufb	  SHUF_MASK(%rip), \XMM3       # perform a 16 byte swap
-	pshufb	  SHUF_MASK(%rip), \XMM4       # perform a 16 byte sway
+	PSHUFB_XMM %xmm15, \XMM1        # perform a 16 byte swap
+	PSHUFB_XMM %xmm15, \XMM2	# perform a 16 byte swap
+	PSHUFB_XMM %xmm15, \XMM3	# perform a 16 byte swap
+	PSHUFB_XMM %xmm15, \XMM4	# perform a 16 byte swap
 
 	pxor	  \TMP4, \TMP1
 	pxor	  \XMM8, \XMM5
@@ -853,7 +1276,9 @@ ENTRY(aesni_gcm_dec)
 	and	$~63, %rsp                        # align rsp to 64 bytes
 	mov	%arg6, %r12
 	movdqu	(%r12), %xmm13			  # %xmm13 = HashKey
-	pshufb	SHUF_MASK(%rip), %xmm13
+        movdqa  SHUF_MASK(%rip), %xmm2
+	PSHUFB_XMM %xmm2, %xmm13
+
 
 # Precompute HashKey<<1 (mod poly) from the hash key (required for GHASH)
 
@@ -885,22 +1310,22 @@ ENTRY(aesni_gcm_dec)
 	jb _initial_num_blocks_is_1_decrypt
 	je _initial_num_blocks_is_2_decrypt
 _initial_num_blocks_is_3_decrypt:
-	INITIAL_BLOCKS 3, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_DEC 3, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 5, 678, dec
 	sub	$48, %r13
 	jmp	_initial_blocks_decrypted
 _initial_num_blocks_is_2_decrypt:
-	INITIAL_BLOCKS	2, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_DEC	2, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 6, 78, dec
 	sub	$32, %r13
 	jmp	_initial_blocks_decrypted
 _initial_num_blocks_is_1_decrypt:
-	INITIAL_BLOCKS	1, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_DEC	1, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 7, 8, dec
 	sub	$16, %r13
 	jmp	_initial_blocks_decrypted
 _initial_num_blocks_is_0_decrypt:
-	INITIAL_BLOCKS	0, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_DEC	0, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 8, 0, dec
 _initial_blocks_decrypted:
 	cmp	$0, %r13
@@ -908,7 +1333,7 @@ _initial_blocks_decrypted:
 	sub	$64, %r13
 	je	_four_cipher_left_decrypt
 _decrypt_by_4:
-	GHASH_4_ENCRYPT_4_PARALLEL	%xmm9, %xmm10, %xmm11, %xmm12, %xmm13, \
+	GHASH_4_ENCRYPT_4_PARALLEL_DEC	%xmm9, %xmm10, %xmm11, %xmm12, %xmm13, \
 %xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, dec
 	add	$64, %r11
 	sub	$64, %r13
@@ -924,7 +1349,9 @@ _zero_cipher_left_decrypt:
         # Handle the last <16 byte block seperately
 
 	paddd ONE(%rip), %xmm0         # increment CNT to get Yn
-	pshufb SHUF_MASK(%rip), %xmm0
+        movdqa SHUF_MASK(%rip), %xmm10
+	PSHUFB_XMM %xmm10, %xmm0
+
 	ENCRYPT_SINGLE_BLOCK  %xmm0, %xmm1    # E(K, Yn)
 	sub $16, %r11
 	add %r13, %r11
@@ -934,14 +1361,17 @@ _zero_cipher_left_decrypt:
 # adjust the shuffle mask pointer to be able to shift 16-%r13 bytes
 # (%r13 is the number of bytes in plaintext mod 16)
 	movdqu (%r12), %xmm2           # get the appropriate shuffle mask
-	pshufb %xmm2, %xmm1            # right shift 16-%r13 butes
+	PSHUFB_XMM %xmm2, %xmm1            # right shift 16-%r13 butes
+
 	movdqa  %xmm1, %xmm2
 	pxor %xmm1, %xmm0            # Ciphertext XOR E(K, Yn)
 	movdqu ALL_F-SHIFT_MASK(%r12), %xmm1
 	# get the appropriate mask to mask out top 16-%r13 bytes of %xmm0
 	pand %xmm1, %xmm0            # mask out top 16-%r13 bytes of %xmm0
 	pand    %xmm1, %xmm2
-	pshufb SHUF_MASK(%rip),%xmm2
+        movdqa SHUF_MASK(%rip), %xmm10
+	PSHUFB_XMM %xmm10 ,%xmm2
+
 	pxor %xmm2, %xmm8
 	GHASH_MUL %xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
 	          # GHASH computation for the last <16 byte block
@@ -949,13 +1379,13 @@ _zero_cipher_left_decrypt:
 	add $16, %r11
 
         # output %r13 bytes
-	movq	%xmm0, %rax
+	MOVQ_R64_XMM	%xmm0, %rax
 	cmp	$8, %r13
 	jle	_less_than_8_bytes_left_decrypt
 	mov	%rax, (%arg2 , %r11, 1)
 	add	$8, %r11
 	psrldq	$8, %xmm0
-	movq	%xmm0, %rax
+	MOVQ_R64_XMM	%xmm0, %rax
 	sub	$8, %r13
 _less_than_8_bytes_left_decrypt:
 	mov	%al,  (%arg2, %r11, 1)
@@ -968,13 +1398,15 @@ _multiple_of_16_bytes_decrypt:
 	shl	$3, %r12		  # convert into number of bits
 	movd	%r12d, %xmm15		  # len(A) in %xmm15
 	shl	$3, %arg4		  # len(C) in bits (*128)
-	movq	%arg4, %xmm1
+	MOVQ_R64_XMM	%arg4, %xmm1
 	pslldq	$8, %xmm15		  # %xmm15 = len(A)||0x0000000000000000
 	pxor	%xmm1, %xmm15		  # %xmm15 = len(A)||len(C)
 	pxor	%xmm15, %xmm8
 	GHASH_MUL	%xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
 	         # final GHASH computation
-	pshufb	SHUF_MASK(%rip), %xmm8
+        movdqa SHUF_MASK(%rip), %xmm10
+	PSHUFB_XMM %xmm10, %xmm8
+
 	mov	%arg5, %rax		  # %rax = *Y0
 	movdqu	(%rax), %xmm0		  # %xmm0 = Y0
 	ENCRYPT_SINGLE_BLOCK	%xmm0,  %xmm1	  # E(K, Y0)
@@ -987,11 +1419,11 @@ _return_T_decrypt:
 	cmp	$12, %r11
 	je	_T_12_decrypt
 _T_8_decrypt:
-	movq	%xmm0, %rax
+	MOVQ_R64_XMM	%xmm0, %rax
 	mov	%rax, (%r10)
 	jmp	_return_T_done_decrypt
 _T_12_decrypt:
-	movq	%xmm0, %rax
+	MOVQ_R64_XMM	%xmm0, %rax
 	mov	%rax, (%r10)
 	psrldq	$8, %xmm0
 	movd	%xmm0, %eax
@@ -1103,7 +1535,9 @@ ENTRY(aesni_gcm_enc)
 	and	$~63, %rsp
 	mov	%arg6, %r12
 	movdqu	(%r12), %xmm13
-	pshufb	SHUF_MASK(%rip), %xmm13
+        movdqa  SHUF_MASK(%rip), %xmm2
+	PSHUFB_XMM %xmm2, %xmm13
+
 
 # precompute HashKey<<1 mod poly from the HashKey (required for GHASH)
 
@@ -1134,22 +1568,22 @@ ENTRY(aesni_gcm_enc)
 	jb	_initial_num_blocks_is_1_encrypt
 	je	_initial_num_blocks_is_2_encrypt
 _initial_num_blocks_is_3_encrypt:
-	INITIAL_BLOCKS	3, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_ENC	3, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 5, 678, enc
 	sub	$48, %r13
 	jmp	_initial_blocks_encrypted
 _initial_num_blocks_is_2_encrypt:
-	INITIAL_BLOCKS	2, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_ENC	2, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 6, 78, enc
 	sub	$32, %r13
 	jmp	_initial_blocks_encrypted
 _initial_num_blocks_is_1_encrypt:
-	INITIAL_BLOCKS	1, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_ENC	1, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 7, 8, enc
 	sub	$16, %r13
 	jmp	_initial_blocks_encrypted
 _initial_num_blocks_is_0_encrypt:
-	INITIAL_BLOCKS	0, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
+	INITIAL_BLOCKS_ENC	0, %xmm9, %xmm10, %xmm13, %xmm11, %xmm12, %xmm0, \
 %xmm1, %xmm2, %xmm3, %xmm4, %xmm8, %xmm5, %xmm6, 8, 0, enc
 _initial_blocks_encrypted:
 
@@ -1160,7 +1594,7 @@ _initial_blocks_encrypted:
 	sub	$64, %r13
 	je	_four_cipher_left_encrypt
 _encrypt_by_4_encrypt:
-	GHASH_4_ENCRYPT_4_PARALLEL	%xmm9, %xmm10, %xmm11, %xmm12, %xmm13, \
+	GHASH_4_ENCRYPT_4_PARALLEL_ENC	%xmm9, %xmm10, %xmm11, %xmm12, %xmm13, \
 %xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, enc
 	add	$64, %r11
 	sub	$64, %r13
@@ -1175,7 +1609,9 @@ _zero_cipher_left_encrypt:
 
          # Handle the last <16 Byte block seperately
 	paddd ONE(%rip), %xmm0                # INCR CNT to get Yn
-	pshufb SHUF_MASK(%rip), %xmm0
+        movdqa SHUF_MASK(%rip), %xmm10
+	PSHUFB_XMM %xmm10, %xmm0
+
 	ENCRYPT_SINGLE_BLOCK	%xmm0, %xmm1        # Encrypt(K, Yn)
 	sub $16, %r11
 	add %r13, %r11
@@ -1185,29 +1621,31 @@ _zero_cipher_left_encrypt:
 	# adjust the shuffle mask pointer to be able to shift 16-r13 bytes
 	# (%r13 is the number of bytes in plaintext mod 16)
 	movdqu	(%r12), %xmm2           # get the appropriate shuffle mask
-	pshufb	%xmm2, %xmm1            # shift right 16-r13 byte
+	PSHUFB_XMM	%xmm2, %xmm1            # shift right 16-r13 byte
 	pxor	%xmm1, %xmm0            # Plaintext XOR Encrypt(K, Yn)
 	movdqu	ALL_F-SHIFT_MASK(%r12), %xmm1
 	# get the appropriate mask to mask out top 16-r13 bytes of xmm0
 	pand	%xmm1, %xmm0            # mask out top 16-r13 bytes of xmm0
+        movdqa SHUF_MASK(%rip), %xmm10
+	PSHUFB_XMM %xmm10,%xmm0
 
-	pshufb	SHUF_MASK(%rip),%xmm0
 	pxor	%xmm0, %xmm8
 	GHASH_MUL %xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
 	# GHASH computation for the last <16 byte block
 	sub	%r13, %r11
 	add	$16, %r11
-	pshufb SHUF_MASK(%rip), %xmm0
+	PSHUFB_XMM %xmm10, %xmm1
+
 	# shuffle xmm0 back to output as ciphertext
 
         # Output %r13 bytes
-	movq %xmm0, %rax
+	MOVQ_R64_XMM %xmm0, %rax
 	cmp $8, %r13
 	jle _less_than_8_bytes_left_encrypt
 	mov %rax, (%arg2 , %r11, 1)
 	add $8, %r11
 	psrldq $8, %xmm0
-	movq %xmm0, %rax
+	MOVQ_R64_XMM %xmm0, %rax
 	sub $8, %r13
 _less_than_8_bytes_left_encrypt:
 	mov %al,  (%arg2, %r11, 1)
@@ -1220,14 +1658,15 @@ _multiple_of_16_bytes_encrypt:
 	shl	$3, %r12
 	movd	%r12d, %xmm15       # len(A) in %xmm15
 	shl	$3, %arg4               # len(C) in bits (*128)
-	movq	%arg4, %xmm1
+	MOVQ_R64_XMM	%arg4, %xmm1
 	pslldq	$8, %xmm15          # %xmm15 = len(A)||0x0000000000000000
 	pxor	%xmm1, %xmm15       # %xmm15 = len(A)||len(C)
 	pxor	%xmm15, %xmm8
 	GHASH_MUL	%xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
 	# final GHASH computation
+        movdqa SHUF_MASK(%rip), %xmm10
+	PSHUFB_XMM %xmm10, %xmm8         # perform a 16 byte swap
 
-	pshufb	SHUF_MASK(%rip), %xmm8         # perform a 16 byte swap
 	mov	%arg5, %rax		       # %rax  = *Y0
 	movdqu	(%rax), %xmm0		       # %xmm0 = Y0
 	ENCRYPT_SINGLE_BLOCK	%xmm0, %xmm15         # Encrypt(K, Y0)
@@ -1240,11 +1679,11 @@ _return_T_encrypt:
 	cmp	$12, %r11
 	je	_T_12_encrypt
 _T_8_encrypt:
-	movq	%xmm0, %rax
+	MOVQ_R64_XMM	%xmm0, %rax
 	mov	%rax, (%r10)
 	jmp	_return_T_done_encrypt
 _T_12_encrypt:
-	movq	%xmm0, %rax
+	MOVQ_R64_XMM	%xmm0, %rax
 	mov	%rax, (%r10)
 	psrldq	$8, %xmm0
 	movd	%xmm0, %eax
@@ -1258,6 +1697,7 @@ _return_T_done_encrypt:
 	pop	%r13
 	pop	%r12
 	ret
+
 #endif
 
 
-- 
1.6.4.2

--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


