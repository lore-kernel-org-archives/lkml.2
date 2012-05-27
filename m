Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2E0OvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 10:51:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52688 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2E0OvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 10:51:19 -0400
Date: Sun, 27 May 2012 16:51:12 +0200
From: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?Q?M=FCller?= 
	<tilo.mueller@informatik.uni-erlangen.de>
Subject: [PATCH] crypto: serpent - add x86_64/avx assembler implementation
Message-ID: <20120527145112.GF17705@kronos.redsun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Provags-ID: V02:K0:P7wLqg/zTXbuslSBxjy1n3FA7c1pejG+9vPYqngVeok
 o0DuT+FSUFh1asI2GJSjdrftbIMquFdi+rm9/m7UQzcjsfE5yh
 hqh38dH4h9XxVxNCjOV44GV6dOCus1fF8UhV8+gg+rQ8sZTWRi
 5MAgAjvkj3y/0ifWKckPB5EB9lDZA2RguSL6Bbttsftt5mtaMu
 7+uHuUKJD/jtlZjgaafCRdmGIlzgmW4I0A7llQy2Zruw6uq/Xo
 pB3DUQhiu0ZFtoxZoj+xY9+Y7+JMasV/8wsn3hyVw9c7vcBV3A
 n8IqQ/bpMfShX0ZkhFNUIpZZd1XDO7dNOOgaZ5furUetT9Jejk
 L3GuojGFM7b/02J5nqPY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a x86_64/avx assembler implementation of the Serpent block
cipher. The implementation is very similar to the sse2 implementation and
processes eight blocks in parallel. Because of the new non-destructive three
operand syntax all move-instructions can be removed and therefore a little
performance increase is provided.

Patch has been tested with tcrypt and automated filesystem tests.

Tcrypt benchmark results:

Intel Core i5-2500 CPU (fam:6, model:42, step:7)

serpent-avx-x86_64 vs. serpent-sse2-x86_64
128bit key:                                             (lrw:256bit)    (xts:256bit)
size    ecb-enc ecb-dec cbc-enc cbc-dec ctr-enc ctr-dec lrw-enc lrw-dec xts-enc xts-dec
16B     1.03x   1.01x	1.01x   1.01x   1.00x   1.00x   1.00x   1.00x   1.00x   1.01x
64B     1.00x   1.00x   1.00x   1.00x   1.00x   0.99x   1.00x   1.01x   1.00x   1.00x
256B    1.05x   1.03x   1.00x   1.02x   1.05x   1.06x   1.05x   1.02x   1.05x   1.02x
1024B   1.05x   1.02x   1.00x   1.02x   1.05x   1.06x   1.05x   1.03x   1.05x   1.02x
8192B   1.05x   1.02x   1.00x   1.02x   1.06x   1.06x   1.04x   1.03x   1.04x   1.02x

256bit key:                                             (lrw:384bit)    (xts:512bit)
size    ecb-enc ecb-dec cbc-enc cbc-dec ctr-enc ctr-dec lrw-enc lrw-dec xts-enc xts-dec
16B     1.01x   1.00x   1.01x   1.01x   1.00x   1.00x   0.99x   1.03x   1.01x   1.01x
64B     1.00x   1.00x   1.00x   1.00x   1.00x   1.00x   1.00x   1.01x   1.00x   1.02x
256B    1.05x   1.02x   1.00x   1.02x   1.05x   1.02x   1.04x   1.05x   1.05x   1.02x
1024B   1.06x   1.02x   1.00x   1.02x   1.07x   1.06x   1.05x   1.04x   1.05x   1.02x
8192B   1.05x   1.02x   1.00x   1.02x   1.06x   1.06x   1.04x   1.05x   1.05x   1.02x

serpent-avx-x86_64 vs aes-asm (8kB block):
         128bit  256bit
ecb-enc  1.26x   1.73x
ecb-dec  1.20x   1.64x
cbc-enc  0.33x   0.45x
cbc-dec  1.24x   1.67x
ctr-enc  1.32x   1.76x
ctr-dec  1.32x   1.76x
lrw-enc  1.20x   1.60x
lrw-dec  1.15x   1.54x
xts-enc  1.22x   1.64x
xts-dec  1.17x   1.57x

Signed-off-by: Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
---
 arch/x86/crypto/Makefile                    |    2 +
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S |  704 ++++++++++++++++++++
 arch/x86/crypto/serpent_avx_glue.c          |  949 +++++++++++++++++++++++++++
 crypto/Kconfig                              |   20 +
 crypto/testmgr.c                            |   60 ++
 5 files changed, 1735 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/crypto/serpent-avx-x86_64-asm_64.S
 create mode 100644 arch/x86/crypto/serpent_avx_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index e191ac0..8ef7ba5 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64_3WAY) += twofish-x86_64-3way.o
 obj-$(CONFIG_CRYPTO_SALSA20_X86_64) += salsa20-x86_64.o
 obj-$(CONFIG_CRYPTO_SERPENT_SSE2_X86_64) += serpent-sse2-x86_64.o
+obj-$(CONFIG_CRYPTO_SERPENT_AVX_X86_64) += serpent-avx-x86_64.o
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 
@@ -32,6 +33,7 @@ twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_glue.o
 twofish-x86_64-3way-y := twofish-x86_64-asm_64-3way.o twofish_glue_3way.o
 salsa20-x86_64-y := salsa20-x86_64-asm_64.o salsa20_glue.o
 serpent-sse2-x86_64-y := serpent-sse2-x86_64-asm_64.o serpent_sse2_glue.o
+serpent-avx-x86_64-y := serpent-avx-x86_64-asm_64.o serpent_avx_glue.o
 
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
 
diff --git a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
new file mode 100644
index 0000000..0ed47a1
--- /dev/null
+++ b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
@@ -0,0 +1,704 @@
+/*
+ * Serpent Cipher 8-way parallel algorithm (x86_64/AVX)
+ *
+ * Copyright (C) 2012 Johannes Goetzfried
+ *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
+ *
+ * Based on arch/x86/crypto/serpent-sse2-x86_64-asm_64.S by
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
+.file "serpent-avx-x86_64-asm_64.S"
+.text
+
+#define CTX %rdi
+
+/**********************************************************************
+  8-way AVX serpent
+ **********************************************************************/
+#define RA1 %xmm0
+#define RB1 %xmm1
+#define RC1 %xmm2
+#define RD1 %xmm3
+#define RE1 %xmm4
+
+#define tp  %xmm5
+
+#define RA2 %xmm6
+#define RB2 %xmm7
+#define RC2 %xmm8
+#define RD2 %xmm9
+#define RE2 %xmm10
+
+#define RNOT %xmm11
+
+#define RK0 %xmm12
+#define RK1 %xmm13
+#define RK2 %xmm14
+#define RK3 %xmm15
+
+
+#define S0_1(x0, x1, x2, x3, x4)      \
+	vpor		x0,   x3, tp; \
+	vpxor		x3,   x0, x0; \
+	vpxor		x2,   x3, x4; \
+	vpxor		RNOT, x4, x4; \
+	vpxor		x1,   tp, x3; \
+	vpand		x0,   x1, x1; \
+	vpxor		x4,   x1, x1; \
+	vpxor		x0,   x2, x2;
+#define S0_2(x0, x1, x2, x3, x4)      \
+	vpxor		x3,   x0, x0; \
+	vpor		x0,   x4, x4; \
+	vpxor		x2,   x0, x0; \
+	vpand		x1,   x2, x2; \
+	vpxor		x2,   x3, x3; \
+	vpxor		RNOT, x1, x1; \
+	vpxor		x4,   x2, x2; \
+	vpxor		x2,   x1, x1;
+
+#define S1_1(x0, x1, x2, x3, x4)      \
+	vpxor		x0,   x1, tp; \
+	vpxor		x3,   x0, x0; \
+	vpxor		RNOT, x3, x3; \
+	vpand		tp,   x1, x4; \
+	vpor		tp,   x0, x0; \
+	vpxor		x2,   x3, x3; \
+	vpxor		x3,   x0, x0; \
+	vpxor		x3,   tp, x1;
+#define S1_2(x0, x1, x2, x3, x4)      \
+	vpxor		x4,   x3, x3; \
+	vpor		x4,   x1, x1; \
+	vpxor		x2,   x4, x4; \
+	vpand		x0,   x2, x2; \
+	vpxor		x1,   x2, x2; \
+	vpor		x0,   x1, x1; \
+	vpxor		RNOT, x0, x0; \
+	vpxor		x2,   x0, x0; \
+	vpxor		x1,   x4, x4;
+
+#define S2_1(x0, x1, x2, x3, x4)      \
+	vpxor		RNOT, x3, x3; \
+	vpxor		x0,   x1, x1; \
+	vpand		x2,   x0, tp; \
+	vpxor		x3,   tp, tp; \
+	vpor		x0,   x3, x3; \
+	vpxor		x1,   x2, x2; \
+	vpxor		x1,   x3, x3; \
+	vpand		tp,   x1, x1;
+#define S2_2(x0, x1, x2, x3, x4)      \
+	vpxor		x2,   tp, tp; \
+	vpand		x3,   x2, x2; \
+	vpor		x1,   x3, x3; \
+	vpxor		RNOT, tp, tp; \
+	vpxor		tp,   x3, x3; \
+	vpxor		tp,   x0, x4; \
+	vpxor		x2,   tp, x0; \
+	vpor		x2,   x1, x1;
+
+#define S3_1(x0, x1, x2, x3, x4)      \
+	vpxor		x3,   x1, tp; \
+	vpor		x0,   x3, x3; \
+	vpand		x0,   x1, x4; \
+	vpxor		x2,   x0, x0; \
+	vpxor		tp,   x2, x2; \
+	vpand		x3,   tp, x1; \
+	vpxor		x3,   x2, x2; \
+	vpor		x4,   x0, x0; \
+	vpxor		x3,   x4, x4;
+#define S3_2(x0, x1, x2, x3, x4)      \
+	vpxor		x0,   x1, x1; \
+	vpand		x3,   x0, x0; \
+	vpand		x4,   x3, x3; \
+	vpxor		x2,   x3, x3; \
+	vpor		x1,   x4, x4; \
+	vpand		x1,   x2, x2; \
+	vpxor		x3,   x4, x4; \
+	vpxor		x3,   x0, x0; \
+	vpxor		x2,   x3, x3;
+
+#define S4_1(x0, x1, x2, x3, x4)      \
+	vpand		x0,   x3, tp; \
+	vpxor		x3,   x0, x0; \
+	vpxor		x2,   tp, tp; \
+	vpor		x3,   x2, x2; \
+	vpxor		x1,   x0, x0; \
+	vpxor		tp,   x3, x4; \
+	vpor		x0,   x2, x2; \
+	vpxor		x1,   x2, x2;
+#define S4_2(x0, x1, x2, x3, x4)      \
+	vpand		x0,   x1, x1; \
+	vpxor		x4,   x1, x1; \
+	vpand		x2,   x4, x4; \
+	vpxor		tp,   x2, x2; \
+	vpxor		x0,   x4, x4; \
+	vpor		x1,   tp, x3; \
+	vpxor		RNOT, x1, x1; \
+	vpxor		x0,   x3, x3;
+
+#define S5_1(x0, x1, x2, x3, x4)      \
+	vpor		x0,   x1, tp; \
+	vpxor		tp,   x2, x2; \
+	vpxor		RNOT, x3, x3; \
+	vpxor		x0,   x1, x4; \
+	vpxor		x2,   x0, x0; \
+	vpand		x4,   tp, x1; \
+	vpor		x3,   x4, x4; \
+	vpxor		x0,   x4, x4;
+#define S5_2(x0, x1, x2, x3, x4)      \
+	vpand		x3,   x0, x0; \
+	vpxor		x3,   x1, x1; \
+	vpxor		x2,   x3, x3; \
+	vpxor		x1,   x0, x0; \
+	vpand		x4,   x2, x2; \
+	vpxor		x2,   x1, x1; \
+	vpand		x0,   x2, x2; \
+	vpxor		x2,   x3, x3;
+
+#define S6_1(x0, x1, x2, x3, x4)      \
+	vpxor		x0,   x3, x3; \
+	vpxor		x2,   x1, tp; \
+	vpxor		x0,   x2, x2; \
+	vpand		x3,   x0, x0; \
+	vpor		x3,   tp, tp; \
+	vpxor		RNOT, x1, x4; \
+	vpxor		tp,   x0, x0; \
+	vpxor		x2,   tp, x1;
+#define S6_2(x0, x1, x2, x3, x4)      \
+	vpxor		x4,   x3, x3; \
+	vpxor		x0,   x4, x4; \
+	vpand		x0,   x2, x2; \
+	vpxor		x1,   x4, x4; \
+	vpxor		x3,   x2, x2; \
+	vpand		x1,   x3, x3; \
+	vpxor		x0,   x3, x3; \
+	vpxor		x2,   x1, x1;
+
+#define S7_1(x0, x1, x2, x3, x4)      \
+	vpxor		RNOT, x1, tp; \
+	vpxor		RNOT, x0, x0; \
+	vpand		x2,   tp, x1; \
+	vpxor		x3,   x1, x1; \
+	vpor		tp,   x3, x3; \
+	vpxor		x2,   tp, x4; \
+	vpxor		x3,   x2, x2; \
+	vpxor		x0,   x3, x3; \
+	vpor		x1,   x0, x0;
+#define S7_2(x0, x1, x2, x3, x4)      \
+	vpand		x0,   x2, x2; \
+	vpxor		x4,   x0, x0; \
+	vpxor		x3,   x4, x4; \
+	vpand		x0,   x3, x3; \
+	vpxor		x1,   x4, x4; \
+	vpxor		x4,   x2, x2; \
+	vpxor		x1,   x3, x3; \
+	vpor		x0,   x4, x4; \
+	vpxor		x1,   x4, x4;
+
+#define SI0_1(x0, x1, x2, x3, x4)     \
+	vpxor		x0,   x1, x1; \
+	vpor		x1,   x3, tp; \
+	vpxor		x1,   x3, x4; \
+	vpxor		RNOT, x0, x0; \
+	vpxor		tp,   x2, x2; \
+	vpxor		x0,   tp, x3; \
+	vpand		x1,   x0, x0; \
+	vpxor		x2,   x0, x0;
+#define SI0_2(x0, x1, x2, x3, x4)     \
+	vpand		x3,   x2, x2; \
+	vpxor		x4,   x3, x3; \
+	vpxor		x3,   x2, x2; \
+	vpxor		x3,   x1, x1; \
+	vpand		x0,   x3, x3; \
+	vpxor		x0,   x1, x1; \
+	vpxor		x2,   x0, x0; \
+	vpxor		x3,   x4, x4;
+
+#define SI1_1(x0, x1, x2, x3, x4)     \
+	vpxor		x3,   x1, x1; \
+	vpxor		x2,   x0, tp; \
+	vpxor		RNOT, x2, x2; \
+	vpor		x1,   x0, x4; \
+	vpxor		x3,   x4, x4; \
+	vpand		x1,   x3, x3; \
+	vpxor		x2,   x1, x1; \
+	vpand		x4,   x2, x2;
+#define SI1_2(x0, x1, x2, x3, x4)     \
+	vpxor		x1,   x4, x4; \
+	vpor		x3,   x1, x1; \
+	vpxor		tp,   x3, x3; \
+	vpxor		tp,   x2, x2; \
+	vpor		x4,   tp, x0; \
+	vpxor		x4,   x2, x2; \
+	vpxor		x0,   x1, x1; \
+	vpxor		x1,   x4, x4;
+
+#define SI2_1(x0, x1, x2, x3, x4)     \
+	vpxor		x1,   x2, x2; \
+	vpxor		RNOT, x3, tp; \
+	vpor		x2,   tp, tp; \
+	vpxor		x3,   x2, x2; \
+	vpxor		x0,   x3, x4; \
+	vpxor		x1,   tp, x3; \
+	vpor		x2,   x1, x1; \
+	vpxor		x0,   x2, x2;
+#define SI2_2(x0, x1, x2, x3, x4)     \
+	vpxor		x4,   x1, x1; \
+	vpor		x3,   x4, x4; \
+	vpxor		x3,   x2, x2; \
+	vpxor		x2,   x4, x4; \
+	vpand		x1,   x2, x2; \
+	vpxor		x3,   x2, x2; \
+	vpxor		x4,   x3, x3; \
+	vpxor		x0,   x4, x4;
+
+#define SI3_1(x0, x1, x2, x3, x4)     \
+	vpxor		x1,   x2, x2; \
+	vpand		x2,   x1, tp; \
+	vpxor		x0,   tp, tp; \
+	vpor		x1,   x0, x0; \
+	vpxor		x3,   x1, x4; \
+	vpxor		x3,   x0, x0; \
+	vpor		tp,   x3, x3; \
+	vpxor		x2,   tp, x1;
+#define SI3_2(x0, x1, x2, x3, x4)     \
+	vpxor		x3,   x1, x1; \
+	vpxor		x2,   x0, x0; \
+	vpxor		x3,   x2, x2; \
+	vpand		x1,   x3, x3; \
+	vpxor		x0,   x1, x1; \
+	vpand		x2,   x0, x0; \
+	vpxor		x3,   x4, x4; \
+	vpxor		x0,   x3, x3; \
+	vpxor		x1,   x0, x0;
+
+#define SI4_1(x0, x1, x2, x3, x4)     \
+	vpxor		x3,   x2, x2; \
+	vpand		x1,   x0, tp; \
+	vpxor		x2,   tp, tp; \
+	vpor		x3,   x2, x2; \
+	vpxor		RNOT, x0, x4; \
+	vpxor		tp,   x1, x1; \
+	vpxor		x2,   tp, x0; \
+	vpand		x4,   x2, x2;
+#define SI4_2(x0, x1, x2, x3, x4)     \
+	vpxor		x0,   x2, x2; \
+	vpor		x4,   x0, x0; \
+	vpxor		x3,   x0, x0; \
+	vpand		x2,   x3, x3; \
+	vpxor		x3,   x4, x4; \
+	vpxor		x1,   x3, x3; \
+	vpand		x0,   x1, x1; \
+	vpxor		x1,   x4, x4; \
+	vpxor		x3,   x0, x0;
+
+#define SI5_1(x0, x1, x2, x3, x4)     \
+	vpor		x2,   x1, tp; \
+	vpxor		x1,   x2, x2; \
+	vpxor		x3,   tp, tp; \
+	vpand		x1,   x3, x3; \
+	vpxor		x3,   x2, x2; \
+	vpor		x0,   x3, x3; \
+	vpxor		RNOT, x0, x0; \
+	vpxor		x2,   x3, x3; \
+	vpor		x0,   x2, x2;
+#define SI5_2(x0, x1, x2, x3, x4)     \
+	vpxor		tp,   x1, x4; \
+	vpxor		x4,   x2, x2; \
+	vpand		x0,   x4, x4; \
+	vpxor		tp,   x0, x0; \
+	vpxor		x3,   tp, x1; \
+	vpand		x2,   x0, x0; \
+	vpxor		x3,   x2, x2; \
+	vpxor		x2,   x0, x0; \
+	vpxor		x4,   x2, x2; \
+	vpxor		x3,   x4, x4;
+
+#define SI6_1(x0, x1, x2, x3, x4)     \
+	vpxor		x2,   x0, x0; \
+	vpand		x3,   x0, tp; \
+	vpxor		x3,   x2, x2; \
+	vpxor		x2,   tp, tp; \
+	vpxor		x1,   x3, x3; \
+	vpor		x0,   x2, x2; \
+	vpxor		x3,   x2, x2; \
+	vpand		tp,   x3, x3;
+#define SI6_2(x0, x1, x2, x3, x4)     \
+	vpxor		RNOT, tp, tp; \
+	vpxor		x1,   x3, x3; \
+	vpand		x2,   x1, x1; \
+	vpxor		tp,   x0, x4; \
+	vpxor		x4,   x3, x3; \
+	vpxor		x2,   x4, x4; \
+	vpxor		x1,   tp, x0; \
+	vpxor		x0,   x2, x2;
+
+#define SI7_1(x0, x1, x2, x3, x4)     \
+	vpand		x0,   x3, tp; \
+	vpxor		x2,   x0, x0; \
+	vpor		x3,   x2, x2; \
+	vpxor		x1,   x3, x4; \
+	vpxor		RNOT, x0, x0; \
+	vpor		tp,   x1, x1; \
+	vpxor		x0,   x4, x4; \
+	vpand		x2,   x0, x0; \
+	vpxor		x1,   x0, x0;
+#define SI7_2(x0, x1, x2, x3, x4)     \
+	vpand		x2,   x1, x1; \
+	vpxor		x2,   tp, x3; \
+	vpxor		x3,   x4, x4; \
+	vpand		x3,   x2, x2; \
+	vpor		x0,   x3, x3; \
+	vpxor		x4,   x1, x1; \
+	vpxor		x4,   x3, x3; \
+	vpand		x0,   x4, x4; \
+	vpxor		x2,   x4, x4;
+
+#define get_key(i, j, t) \
+	vbroadcastss (4*(i)+(j))*4(CTX), t;
+
+#define K2(x0, x1, x2, x3, x4, i) \
+	get_key(i, 0, RK0); \
+	get_key(i, 1, RK1); \
+	get_key(i, 2, RK2); \
+	get_key(i, 3, RK3); \
+	vpxor RK0,	x0 ## 1, x0 ## 1; \
+	vpxor RK1,	x1 ## 1, x1 ## 1; \
+	vpxor RK2,	x2 ## 1, x2 ## 1; \
+	vpxor RK3,	x3 ## 1, x3 ## 1; \
+		vpxor RK0,	x0 ## 2, x0 ## 2; \
+		vpxor RK1,	x1 ## 2, x1 ## 2; \
+		vpxor RK2,	x2 ## 2, x2 ## 2; \
+		vpxor RK3,	x3 ## 2, x3 ## 2;
+
+#define LK2(x0, x1, x2, x3, x4, i) \
+	vpslld $13,		x0 ## 1, x4 ## 1;          \
+	vpsrld $(32 - 13),	x0 ## 1, x0 ## 1;          \
+	vpor			x4 ## 1, x0 ## 1, x0 ## 1; \
+	vpxor			x0 ## 1, x1 ## 1, x1 ## 1; \
+	vpslld $3,		x2 ## 1, x4 ## 1;          \
+	vpsrld $(32 - 3),	x2 ## 1, x2 ## 1;          \
+	vpor			x4 ## 1, x2 ## 1, x2 ## 1; \
+	vpxor			x2 ## 1, x1 ## 1, x1 ## 1; \
+		vpslld $13,		x0 ## 2, x4 ## 2;          \
+		vpsrld $(32 - 13),	x0 ## 2, x0 ## 2;          \
+		vpor			x4 ## 2, x0 ## 2, x0 ## 2; \
+		vpxor			x0 ## 2, x1 ## 2, x1 ## 2; \
+		vpslld $3,		x2 ## 2, x4 ## 2;          \
+		vpsrld $(32 - 3),	x2 ## 2, x2 ## 2;          \
+		vpor			x4 ## 2, x2 ## 2, x2 ## 2; \
+		vpxor			x2 ## 2, x1 ## 2, x1 ## 2; \
+	vpslld $1,		x1 ## 1, x4 ## 1;          \
+	vpsrld $(32 - 1),	x1 ## 1, x1 ## 1;          \
+	vpor			x4 ## 1, x1 ## 1, x1 ## 1; \
+	vpslld $3,		x0 ## 1, x4 ## 1;          \
+	vpxor			x2 ## 1, x3 ## 1, x3 ## 1; \
+	vpxor			x4 ## 1, x3 ## 1, x3 ## 1; \
+	get_key(i, 1, RK1); \
+		vpslld $1,		x1 ## 2, x4 ## 2;          \
+		vpsrld $(32 - 1),	x1 ## 2, x1 ## 2;          \
+		vpor			x4 ## 2, x1 ## 2, x1 ## 2; \
+		vpslld $3,		x0 ## 2, x4 ## 2;          \
+		vpxor			x2 ## 2, x3 ## 2, x3 ## 2; \
+		vpxor			x4 ## 2, x3 ## 2, x3 ## 2; \
+		get_key(i, 3, RK3); \
+	vpslld $7,		x3 ## 1, x4 ## 1;          \
+	vpsrld $(32 - 7),	x3 ## 1, x3 ## 1;          \
+	vpor			x4 ## 1, x3 ## 1, x3 ## 1; \
+	vpslld $7,		x1 ## 1, x4 ## 1;          \
+	vpxor			x1 ## 1, x0 ## 1, x0 ## 1; \
+	vpxor			x3 ## 1, x0 ## 1, x0 ## 1; \
+	vpxor			x3 ## 1, x2 ## 1, x2 ## 1; \
+	vpxor			x4 ## 1, x2 ## 1, x2 ## 1; \
+	get_key(i, 0, RK0); \
+		vpslld $7,		x3 ## 2, x4 ## 2;          \
+		vpsrld $(32 - 7),	x3 ## 2, x3 ## 2;          \
+		vpor			x4 ## 2, x3 ## 2, x3 ## 2; \
+		vpslld $7,		x1 ## 2, x4 ## 2;          \
+		vpxor			x1 ## 2, x0 ## 2, x0 ## 2; \
+		vpxor			x3 ## 2, x0 ## 2, x0 ## 2; \
+		vpxor			x3 ## 2, x2 ## 2, x2 ## 2; \
+		vpxor			x4 ## 2, x2 ## 2, x2 ## 2; \
+		get_key(i, 2, RK2); \
+	vpxor			RK1, x1 ## 1, x1 ## 1;     \
+	vpxor			RK3, x3 ## 1, x3 ## 1;     \
+	vpslld $5,		x0 ## 1, x4 ## 1;          \
+	vpsrld $(32 - 5),	x0 ## 1, x0 ## 1;          \
+	vpor			x4 ## 1, x0 ## 1, x0 ## 1; \
+	vpslld $22,		x2 ## 1, x4 ## 1;          \
+	vpsrld $(32 - 22),	x2 ## 1, x2 ## 1;          \
+	vpor			x4 ## 1, x2 ## 1, x2 ## 1; \
+	vpxor			RK0, x0 ## 1, x0 ## 1;     \
+	vpxor			RK2, x2 ## 1, x2 ## 1;     \
+		vpxor			RK1, x1 ## 2, x1 ## 2;     \
+		vpxor			RK3, x3 ## 2, x3 ## 2;     \
+		vpslld $5,		x0 ## 2, x4 ## 2;          \
+		vpsrld $(32 - 5),	x0 ## 2, x0 ## 2;          \
+		vpor			x4 ## 2, x0 ## 2, x0 ## 2; \
+		vpslld $22,		x2 ## 2, x4 ## 2;          \
+		vpsrld $(32 - 22),	x2 ## 2, x2 ## 2;          \
+		vpor			x4 ## 2, x2 ## 2, x2 ## 2; \
+		vpxor			RK0, x0 ## 2, x0 ## 2;     \
+		vpxor			RK2, x2 ## 2, x2 ## 2;
+
+#define KL2(x0, x1, x2, x3, x4, i) \
+	vpxor			RK0, x0 ## 1, x0 ## 1;     \
+	vpxor			RK2, x2 ## 1, x2 ## 1;     \
+	vpsrld $5,		x0 ## 1, x4 ## 1;          \
+	vpslld $(32 - 5),	x0 ## 1, x0 ## 1;          \
+	vpor			x4 ## 1, x0 ## 1, x0 ## 1; \
+	vpxor			RK3, x3 ## 1, x3 ## 1;     \
+	vpxor			RK1, x1 ## 1, x1 ## 1;     \
+	vpsrld $22,		x2 ## 1, x4 ## 1;          \
+	vpslld $(32 - 22),	x2 ## 1, x2 ## 1;          \
+	vpor			x4 ## 1, x2 ## 1, x2 ## 1; \
+	vpxor			x3 ## 1, x2 ## 1, x2 ## 1; \
+		vpxor			RK0, x0 ## 2, x0 ## 2;     \
+		vpxor			RK2, x2 ## 2, x2 ## 2;     \
+		vpsrld $5,		x0 ## 2, x4 ## 2;          \
+		vpslld $(32 - 5),	x0 ## 2, x0 ## 2;          \
+		vpor			x4 ## 2, x0 ## 2, x0 ## 2; \
+		vpxor			RK3, x3 ## 2, x3 ## 2;     \
+		vpxor			RK1, x1 ## 2, x1 ## 2;     \
+		vpsrld $22,		x2 ## 2, x4 ## 2;          \
+		vpslld $(32 - 22),	x2 ## 2, x2 ## 2;          \
+		vpor			x4 ## 2, x2 ## 2, x2 ## 2; \
+		vpxor			x3 ## 2, x2 ## 2, x2 ## 2; \
+	vpxor			x3 ## 1, x0 ## 1, x0 ## 1; \
+	vpslld $7,		x1 ## 1, x4 ## 1;          \
+	vpxor			x1 ## 1, x0 ## 1, x0 ## 1; \
+	vpxor			x4 ## 1, x2 ## 1, x2 ## 1; \
+	vpsrld $1,		x1 ## 1, x4 ## 1;          \
+	vpslld $(32 - 1),	x1 ## 1, x1 ## 1;          \
+	vpor			x4 ## 1, x1 ## 1, x1 ## 1; \
+		vpxor			x3 ## 2, x0 ## 2, x0 ## 2; \
+		vpslld $7,		x1 ## 2, x4 ## 2;          \
+		vpxor			x1 ## 2, x0 ## 2, x0 ## 2; \
+		vpxor			x4 ## 2, x2 ## 2, x2 ## 2; \
+		vpsrld $1,		x1 ## 2, x4 ## 2;          \
+		vpslld $(32 - 1),	x1 ## 2, x1 ## 2;          \
+		vpor			x4 ## 2, x1 ## 2, x1 ## 2; \
+	vpsrld $7,		x3 ## 1, x4 ## 1;          \
+	vpslld $(32 - 7),	x3 ## 1, x3 ## 1;          \
+	vpor			x4 ## 1, x3 ## 1, x3 ## 1; \
+	vpxor			x0 ## 1, x1 ## 1, x1 ## 1; \
+	vpslld $3,		x0 ## 1, x4 ## 1;          \
+	vpxor			x4 ## 1, x3 ## 1, x3 ## 1; \
+		vpsrld $7,		x3 ## 2, x4 ## 2;          \
+		vpslld $(32 - 7),	x3 ## 2, x3 ## 2;          \
+		vpor			x4 ## 2, x3 ## 2, x3 ## 2; \
+		vpxor			x0 ## 2, x1 ## 2, x1 ## 2; \
+		vpslld $3,		x0 ## 2, x4 ## 2;          \
+		vpxor			x4 ## 2, x3 ## 2, x3 ## 2; \
+	vpsrld $13,		x0 ## 1, x4 ## 1;          \
+	vpslld $(32 - 13),	x0 ## 1, x0 ## 1;          \
+	vpor			x4 ## 1, x0 ## 1, x0 ## 1; \
+	vpxor			x2 ## 1, x1 ## 1, x1 ## 1; \
+	vpxor			x2 ## 1, x3 ## 1, x3 ## 1; \
+	vpsrld $3,		x2 ## 1, x4 ## 1;          \
+	vpslld $(32 - 3),	x2 ## 1, x2 ## 1;          \
+	vpor			x4 ## 1, x2 ## 1, x2 ## 1; \
+		vpsrld $13,		x0 ## 2, x4 ## 2;          \
+		vpslld $(32 - 13),	x0 ## 2, x0 ## 2;          \
+		vpor			x4 ## 2, x0 ## 2, x0 ## 2; \
+		vpxor			x2 ## 2, x1 ## 2, x1 ## 2; \
+		vpxor			x2 ## 2, x3 ## 2, x3 ## 2; \
+		vpsrld $3,		x2 ## 2, x4 ## 2;          \
+		vpslld $(32 - 3),	x2 ## 2, x2 ## 2;          \
+		vpor			x4 ## 2, x2 ## 2, x2 ## 2;
+
+#define S(SBOX, x0, x1, x2, x3, x4) \
+	SBOX ## _1(x0 ## 1, x1 ## 1, x2 ## 1, x3 ## 1, x4 ## 1); \
+	SBOX ## _2(x0 ## 1, x1 ## 1, x2 ## 1, x3 ## 1, x4 ## 1); \
+	SBOX ## _1(x0 ## 2, x1 ## 2, x2 ## 2, x3 ## 2, x4 ## 2); \
+	SBOX ## _2(x0 ## 2, x1 ## 2, x2 ## 2, x3 ## 2, x4 ## 2);
+
+#define SP(SBOX, x0, x1, x2, x3, x4, i) \
+	get_key(i, 0, RK0); \
+	SBOX ## _1(x0 ## 1, x1 ## 1, x2 ## 1, x3 ## 1, x4 ## 1); \
+	get_key(i, 2, RK2); \
+	SBOX ## _2(x0 ## 1, x1 ## 1, x2 ## 1, x3 ## 1, x4 ## 1); \
+	get_key(i, 3, RK3); \
+	SBOX ## _1(x0 ## 2, x1 ## 2, x2 ## 2, x3 ## 2, x4 ## 2); \
+	get_key(i, 1, RK1); \
+	SBOX ## _2(x0 ## 2, x1 ## 2, x2 ## 2, x3 ## 2, x4 ## 2); \
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
+#define read_blocks(in, x0, x1, x2, x3, t0, t1, t2) \
+	vmovdqu (0*4*4)(in),	x0; \
+	vmovdqu (1*4*4)(in),	x1; \
+	vmovdqu (2*4*4)(in),	x2; \
+	vmovdqu (3*4*4)(in),	x3; \
+	\
+	transpose_4x4(x0, x1, x2, x3, t0, t1, t2)
+
+#define write_blocks(out, x0, x1, x2, x3, t0, t1, t2) \
+	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
+	\
+	vmovdqu x0,		(0*4*4)(out); \
+	vmovdqu x1,		(1*4*4)(out); \
+	vmovdqu x2,		(2*4*4)(out); \
+	vmovdqu x3,		(3*4*4)(out);
+
+#define xor_blocks(out, x0, x1, x2, x3, t0, t1, t2) \
+	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
+	\
+	vpxor (0*4*4)(out),	x0, x0;       \
+	vmovdqu x0,		(0*4*4)(out); \
+	vpxor (1*4*4)(out),	x1, x1;       \
+	vmovdqu x1,		(1*4*4)(out); \
+	vpxor (2*4*4)(out),	x2, x2;       \
+	vmovdqu x2,		(2*4*4)(out); \
+	vpxor (3*4*4)(out),	x3, x3;       \
+	vmovdqu x3,		(3*4*4)(out);
+
+.align 8
+.global __serpent_enc_blk_8way
+.type   __serpent_enc_blk_8way,@function;
+
+__serpent_enc_blk_8way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 *	%rcx: bool, if true: xor output
+	 */
+
+	vpcmpeqd RNOT, RNOT, RNOT;
+
+	leaq (4*4*4)(%rdx), %rax;
+	read_blocks(%rdx, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
+	read_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
+
+						 K2(RA, RB, RC, RD, RE, 0);
+	S(S0, RA, RB, RC, RD, RE);		LK2(RC, RB, RD, RA, RE, 1);
+	S(S1, RC, RB, RD, RA, RE);		LK2(RE, RD, RA, RC, RB, 2);
+	S(S2, RE, RD, RA, RC, RB);		LK2(RB, RD, RE, RC, RA, 3);
+	S(S3, RB, RD, RE, RC, RA);		LK2(RC, RA, RD, RB, RE, 4);
+	S(S4, RC, RA, RD, RB, RE);		LK2(RA, RD, RB, RE, RC, 5);
+	S(S5, RA, RD, RB, RE, RC);		LK2(RC, RA, RD, RE, RB, 6);
+	S(S6, RC, RA, RD, RE, RB);		LK2(RD, RB, RA, RE, RC, 7);
+	S(S7, RD, RB, RA, RE, RC);		LK2(RC, RA, RE, RD, RB, 8);
+	S(S0, RC, RA, RE, RD, RB);		LK2(RE, RA, RD, RC, RB, 9);
+	S(S1, RE, RA, RD, RC, RB);		LK2(RB, RD, RC, RE, RA, 10);
+	S(S2, RB, RD, RC, RE, RA);		LK2(RA, RD, RB, RE, RC, 11);
+	S(S3, RA, RD, RB, RE, RC);		LK2(RE, RC, RD, RA, RB, 12);
+	S(S4, RE, RC, RD, RA, RB);		LK2(RC, RD, RA, RB, RE, 13);
+	S(S5, RC, RD, RA, RB, RE);		LK2(RE, RC, RD, RB, RA, 14);
+	S(S6, RE, RC, RD, RB, RA);		LK2(RD, RA, RC, RB, RE, 15);
+	S(S7, RD, RA, RC, RB, RE);		LK2(RE, RC, RB, RD, RA, 16);
+	S(S0, RE, RC, RB, RD, RA);		LK2(RB, RC, RD, RE, RA, 17);
+	S(S1, RB, RC, RD, RE, RA);		LK2(RA, RD, RE, RB, RC, 18);
+	S(S2, RA, RD, RE, RB, RC);		LK2(RC, RD, RA, RB, RE, 19);
+	S(S3, RC, RD, RA, RB, RE);		LK2(RB, RE, RD, RC, RA, 20);
+	S(S4, RB, RE, RD, RC, RA);		LK2(RE, RD, RC, RA, RB, 21);
+	S(S5, RE, RD, RC, RA, RB);		LK2(RB, RE, RD, RA, RC, 22);
+	S(S6, RB, RE, RD, RA, RC);		LK2(RD, RC, RE, RA, RB, 23);
+	S(S7, RD, RC, RE, RA, RB);		LK2(RB, RE, RA, RD, RC, 24);
+	S(S0, RB, RE, RA, RD, RC);		LK2(RA, RE, RD, RB, RC, 25);
+	S(S1, RA, RE, RD, RB, RC);		LK2(RC, RD, RB, RA, RE, 26);
+	S(S2, RC, RD, RB, RA, RE);		LK2(RE, RD, RC, RA, RB, 27);
+	S(S3, RE, RD, RC, RA, RB);		LK2(RA, RB, RD, RE, RC, 28);
+	S(S4, RA, RB, RD, RE, RC);		LK2(RB, RD, RE, RC, RA, 29);
+	S(S5, RB, RD, RE, RC, RA);		LK2(RA, RB, RD, RC, RE, 30);
+	S(S6, RA, RB, RD, RC, RE);		LK2(RD, RE, RB, RC, RA, 31);
+	S(S7, RD, RE, RB, RC, RA);		 K2(RA, RB, RC, RD, RE, 32);
+
+	leaq (4*4*4)(%rsi), %rax;
+
+	testb %cl, %cl;
+	jnz __enc_xor8;
+
+	write_blocks(%rsi, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
+	write_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
+
+	ret;
+
+__enc_xor8:
+	xor_blocks(%rsi, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
+	xor_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
+
+	ret;
+
+.align 8
+.global serpent_dec_blk_8way
+.type   serpent_dec_blk_8way,@function;
+
+serpent_dec_blk_8way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	vpcmpeqd RNOT, RNOT, RNOT;
+
+	leaq (4*4*4)(%rdx), %rax;
+	read_blocks(%rdx, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
+	read_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
+
+						 K2(RA, RB, RC, RD, RE, 32);
+	SP(SI7, RA, RB, RC, RD, RE, 31);	KL2(RB, RD, RA, RE, RC, 31);
+	SP(SI6, RB, RD, RA, RE, RC, 30);	KL2(RA, RC, RE, RB, RD, 30);
+	SP(SI5, RA, RC, RE, RB, RD, 29);	KL2(RC, RD, RA, RE, RB, 29);
+	SP(SI4, RC, RD, RA, RE, RB, 28);	KL2(RC, RA, RB, RE, RD, 28);
+	SP(SI3, RC, RA, RB, RE, RD, 27);	KL2(RB, RC, RD, RE, RA, 27);
+	SP(SI2, RB, RC, RD, RE, RA, 26);	KL2(RC, RA, RE, RD, RB, 26);
+	SP(SI1, RC, RA, RE, RD, RB, 25);	KL2(RB, RA, RE, RD, RC, 25);
+	SP(SI0, RB, RA, RE, RD, RC, 24);	KL2(RE, RC, RA, RB, RD, 24);
+	SP(SI7, RE, RC, RA, RB, RD, 23);	KL2(RC, RB, RE, RD, RA, 23);
+	SP(SI6, RC, RB, RE, RD, RA, 22);	KL2(RE, RA, RD, RC, RB, 22);
+	SP(SI5, RE, RA, RD, RC, RB, 21);	KL2(RA, RB, RE, RD, RC, 21);
+	SP(SI4, RA, RB, RE, RD, RC, 20);	KL2(RA, RE, RC, RD, RB, 20);
+	SP(SI3, RA, RE, RC, RD, RB, 19);	KL2(RC, RA, RB, RD, RE, 19);
+	SP(SI2, RC, RA, RB, RD, RE, 18);	KL2(RA, RE, RD, RB, RC, 18);
+	SP(SI1, RA, RE, RD, RB, RC, 17);	KL2(RC, RE, RD, RB, RA, 17);
+	SP(SI0, RC, RE, RD, RB, RA, 16);	KL2(RD, RA, RE, RC, RB, 16);
+	SP(SI7, RD, RA, RE, RC, RB, 15);	KL2(RA, RC, RD, RB, RE, 15);
+	SP(SI6, RA, RC, RD, RB, RE, 14);	KL2(RD, RE, RB, RA, RC, 14);
+	SP(SI5, RD, RE, RB, RA, RC, 13);	KL2(RE, RC, RD, RB, RA, 13);
+	SP(SI4, RE, RC, RD, RB, RA, 12);	KL2(RE, RD, RA, RB, RC, 12);
+	SP(SI3, RE, RD, RA, RB, RC, 11);	KL2(RA, RE, RC, RB, RD, 11);
+	SP(SI2, RA, RE, RC, RB, RD, 10);	KL2(RE, RD, RB, RC, RA, 10);
+	SP(SI1, RE, RD, RB, RC, RA, 9);		KL2(RA, RD, RB, RC, RE, 9);
+	SP(SI0, RA, RD, RB, RC, RE, 8);		KL2(RB, RE, RD, RA, RC, 8);
+	SP(SI7, RB, RE, RD, RA, RC, 7);		KL2(RE, RA, RB, RC, RD, 7);
+	SP(SI6, RE, RA, RB, RC, RD, 6);		KL2(RB, RD, RC, RE, RA, 6);
+	SP(SI5, RB, RD, RC, RE, RA, 5);		KL2(RD, RA, RB, RC, RE, 5);
+	SP(SI4, RD, RA, RB, RC, RE, 4);		KL2(RD, RB, RE, RC, RA, 4);
+	SP(SI3, RD, RB, RE, RC, RA, 3);		KL2(RE, RD, RA, RC, RB, 3);
+	SP(SI2, RE, RD, RA, RC, RB, 2);		KL2(RD, RB, RC, RA, RE, 2);
+	SP(SI1, RD, RB, RC, RA, RE, 1);		KL2(RE, RB, RC, RA, RD, 1);
+	S(SI0, RE, RB, RC, RA, RD);		 K2(RC, RD, RB, RE, RA, 0);
+
+	leaq (4*4*4)(%rsi), %rax;
+	write_blocks(%rsi, RC1, RD1, RB1, RE1, RK0, RK1, RK2);
+	write_blocks(%rax, RC2, RD2, RB2, RE2, RK0, RK1, RK2);
+
+	ret;
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
new file mode 100644
index 0000000..85ef6e7
--- /dev/null
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -0,0 +1,949 @@
+/*
+ * Glue Code for AVX assembler versions of Serpent Cipher
+ *
+ * Copyright (C) 2012 Johannes Goetzfried
+ *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
+ *
+ * Glue code based on twofish_avx_glue.c by:
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
+#include <crypto/serpent.h>
+#include <crypto/cryptd.h>
+#include <crypto/b128ops.h>
+#include <crypto/ctr.h>
+#include <crypto/lrw.h>
+#include <crypto/xts.h>
+#include <asm/i387.h>
+#include <asm/xcr.h>
+#include <asm/xsave.h>
+#include <asm/serpent.h>
+#include <crypto/scatterwalk.h>
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+
+struct async_serpent_ctx {
+	struct cryptd_ablkcipher *cryptd_tfm;
+};
+
+static inline bool serpent_fpu_begin(bool fpu_enabled, unsigned int nbytes)
+{
+	if (fpu_enabled)
+		return true;
+
+	/* AVX is only used when chunk to be processed is large enough, so
+	 * do not enable FPU until it is necessary.
+	 */
+	if (nbytes < SERPENT_BLOCK_SIZE * SERPENT_PARALLEL_BLOCKS)
+		return false;
+
+	kernel_fpu_begin();
+	return true;
+}
+
+static inline void serpent_fpu_end(bool fpu_enabled)
+{
+	if (fpu_enabled)
+		kernel_fpu_end();
+}
+
+static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
+		     bool enc)
+{
+	bool fpu_enabled = false;
+	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = SERPENT_BLOCK_SIZE;
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
+		fpu_enabled = serpent_fpu_begin(fpu_enabled, nbytes);
+
+		/* Process multi-block batch */
+		if (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS) {
+			do {
+				if (enc)
+					serpent_enc_blk_xway(ctx, wdst, wsrc);
+				else
+					serpent_dec_blk_xway(ctx, wdst, wsrc);
+
+				wsrc += bsize * SERPENT_PARALLEL_BLOCKS;
+				wdst += bsize * SERPENT_PARALLEL_BLOCKS;
+				nbytes -= bsize * SERPENT_PARALLEL_BLOCKS;
+			} while (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS);
+
+			if (nbytes < bsize)
+				goto done;
+		}
+
+		/* Handle leftovers */
+		do {
+			if (enc)
+				__serpent_encrypt(ctx, wdst, wsrc);
+			else
+				__serpent_decrypt(ctx, wdst, wsrc);
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
+	serpent_fpu_end(fpu_enabled);
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
+	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = (u128 *)walk->src.virt.addr;
+	u128 *dst = (u128 *)walk->dst.virt.addr;
+	u128 *iv = (u128 *)walk->iv;
+
+	do {
+		u128_xor(dst, src, iv);
+		__serpent_encrypt(ctx, (u8 *)dst, (u8 *)dst);
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
+	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = (u128 *)walk->src.virt.addr;
+	u128 *dst = (u128 *)walk->dst.virt.addr;
+	u128 ivs[SERPENT_PARALLEL_BLOCKS - 1];
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
+	if (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS) {
+		do {
+			nbytes -= bsize * (SERPENT_PARALLEL_BLOCKS - 1);
+			src -= SERPENT_PARALLEL_BLOCKS - 1;
+			dst -= SERPENT_PARALLEL_BLOCKS - 1;
+
+			for (i = 0; i < SERPENT_PARALLEL_BLOCKS - 1; i++)
+				ivs[i] = src[i];
+
+			serpent_dec_blk_xway(ctx, (u8 *)dst, (u8 *)src);
+
+			for (i = 0; i < SERPENT_PARALLEL_BLOCKS - 1; i++)
+				u128_xor(dst + (i + 1), dst + (i + 1), ivs + i);
+
+			nbytes -= bsize;
+			if (nbytes < bsize)
+				goto done;
+
+			u128_xor(dst, dst, src - 1);
+			src -= 1;
+			dst -= 1;
+		} while (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Handle leftovers */
+	for (;;) {
+		__serpent_decrypt(ctx, (u8 *)dst, (u8 *)src);
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
+		fpu_enabled = serpent_fpu_begin(fpu_enabled, nbytes);
+		nbytes = __cbc_decrypt(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	serpent_fpu_end(fpu_enabled);
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
+	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	u8 *ctrblk = walk->iv;
+	u8 keystream[SERPENT_BLOCK_SIZE];
+	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
+	unsigned int nbytes = walk->nbytes;
+
+	__serpent_encrypt(ctx, keystream, ctrblk);
+	crypto_xor(keystream, src, nbytes);
+	memcpy(dst, keystream, nbytes);
+
+	crypto_inc(ctrblk, SERPENT_BLOCK_SIZE);
+}
+
+static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
+				struct blkcipher_walk *walk)
+{
+	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = (u128 *)walk->src.virt.addr;
+	u128 *dst = (u128 *)walk->dst.virt.addr;
+	u128 ctrblk;
+	be128 ctrblocks[SERPENT_PARALLEL_BLOCKS];
+	int i;
+
+	be128_to_u128(&ctrblk, (be128 *)walk->iv);
+
+	/* Process multi-block batch */
+	if (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS) {
+		do {
+			/* create ctrblks for parallel encrypt */
+			for (i = 0; i < SERPENT_PARALLEL_BLOCKS; i++) {
+				if (dst != src)
+					dst[i] = src[i];
+
+				u128_to_be128(&ctrblocks[i], &ctrblk);
+				u128_inc(&ctrblk);
+			}
+
+			serpent_enc_blk_xway_xor(ctx, (u8 *)dst,
+						 (u8 *)ctrblocks);
+
+			src += SERPENT_PARALLEL_BLOCKS;
+			dst += SERPENT_PARALLEL_BLOCKS;
+			nbytes -= bsize * SERPENT_PARALLEL_BLOCKS;
+		} while (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS);
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
+		__serpent_encrypt(ctx, (u8 *)ctrblocks, (u8 *)ctrblocks);
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
+	err = blkcipher_walk_virt_block(desc, &walk, SERPENT_BLOCK_SIZE);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	while ((nbytes = walk.nbytes) >= SERPENT_BLOCK_SIZE) {
+		fpu_enabled = serpent_fpu_begin(fpu_enabled, nbytes);
+		nbytes = __ctr_crypt(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	serpent_fpu_end(fpu_enabled);
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
+	struct serpent_ctx *ctx;
+	bool fpu_enabled;
+};
+
+static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
+{
+	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	struct crypt_priv *ctx = priv;
+	int i;
+
+	ctx->fpu_enabled = serpent_fpu_begin(ctx->fpu_enabled, nbytes);
+
+	if (nbytes == bsize * SERPENT_PARALLEL_BLOCKS) {
+		serpent_enc_blk_xway(ctx->ctx, srcdst, srcdst);
+		return;
+	}
+
+	for (i = 0; i < nbytes / bsize; i++, srcdst += bsize)
+		__serpent_encrypt(ctx->ctx, srcdst, srcdst);
+}
+
+static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
+{
+	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	struct crypt_priv *ctx = priv;
+	int i;
+
+	ctx->fpu_enabled = serpent_fpu_begin(ctx->fpu_enabled, nbytes);
+
+	if (nbytes == bsize * SERPENT_PARALLEL_BLOCKS) {
+		serpent_dec_blk_xway(ctx->ctx, srcdst, srcdst);
+		return;
+	}
+
+	for (i = 0; i < nbytes / bsize; i++, srcdst += bsize)
+		__serpent_decrypt(ctx->ctx, srcdst, srcdst);
+}
+
+struct serpent_lrw_ctx {
+	struct lrw_table_ctx lrw_table;
+	struct serpent_ctx serpent_ctx;
+};
+
+static int lrw_serpent_setkey(struct crypto_tfm *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct serpent_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
+	int err;
+
+	err = __serpent_setkey(&ctx->serpent_ctx, key, keylen -
+							SERPENT_BLOCK_SIZE);
+	if (err)
+		return err;
+
+	return lrw_init_table(&ctx->lrw_table, key + keylen -
+						SERPENT_BLOCK_SIZE);
+}
+
+static int lrw_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct serpent_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[SERPENT_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->serpent_ctx,
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
+	serpent_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static int lrw_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct serpent_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[SERPENT_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->serpent_ctx,
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
+	serpent_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static void lrw_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct serpent_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	lrw_free_table(&ctx->lrw_table);
+}
+
+struct serpent_xts_ctx {
+	struct serpent_ctx tweak_ctx;
+	struct serpent_ctx crypt_ctx;
+};
+
+static int xts_serpent_setkey(struct crypto_tfm *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct serpent_xts_ctx *ctx = crypto_tfm_ctx(tfm);
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
+	err = __serpent_setkey(&ctx->crypt_ctx, key, keylen / 2);
+	if (err)
+		return err;
+
+	/* second half of xts-key is for tweak */
+	return __serpent_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2);
+}
+
+static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct serpent_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[SERPENT_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->crypt_ctx,
+		.fpu_enabled = false,
+	};
+	struct xts_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.tweak_ctx = &ctx->tweak_ctx,
+		.tweak_fn = XTS_TWEAK_CAST(__serpent_encrypt),
+		.crypt_ctx = &crypt_ctx,
+		.crypt_fn = encrypt_callback,
+	};
+	int ret;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	ret = xts_crypt(desc, dst, src, nbytes, &req);
+	serpent_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static int xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct serpent_xts_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[SERPENT_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->crypt_ctx,
+		.fpu_enabled = false,
+	};
+	struct xts_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.tweak_ctx = &ctx->tweak_ctx,
+		.tweak_fn = XTS_TWEAK_CAST(__serpent_encrypt),
+		.crypt_ctx = &crypt_ctx,
+		.crypt_fn = decrypt_callback,
+	};
+	int ret;
+
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	ret = xts_crypt(desc, dst, src, nbytes, &req);
+	serpent_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
+			unsigned int key_len)
+{
+	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
+	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
+	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
+	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
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
+	struct async_serpent_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	cryptd_free_ablkcipher(ctx->cryptd_tfm);
+}
+
+static int ablk_init(struct crypto_tfm *tfm)
+{
+	struct async_serpent_ctx *ctx = crypto_tfm_ctx(tfm);
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
+static struct crypto_alg serpent_algs[10] = { {
+	.cra_name		= "__ecb-serpent-avx",
+	.cra_driver_name	= "__driver-ecb-serpent-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[0].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.setkey		= serpent_setkey,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__cbc-serpent-avx",
+	.cra_driver_name	= "__driver-cbc-serpent-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[1].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.setkey		= serpent_setkey,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__ctr-serpent-avx",
+	.cra_driver_name	= "__driver-ctr-serpent-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[2].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= serpent_setkey,
+			.encrypt	= ctr_crypt,
+			.decrypt	= ctr_crypt,
+		},
+	},
+}, {
+	.cra_name		= "__lrw-serpent-avx",
+	.cra_driver_name	= "__driver-lrw-serpent-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_lrw_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[3].cra_list),
+	.cra_exit		= lrw_exit_tfm,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE +
+					  SERPENT_BLOCK_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE +
+					  SERPENT_BLOCK_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= lrw_serpent_setkey,
+			.encrypt	= lrw_encrypt,
+			.decrypt	= lrw_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "__xts-serpent-avx",
+	.cra_driver_name	= "__driver-xts-serpent-avx",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_xts_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[4].cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE * 2,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE * 2,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= xts_serpent_setkey,
+			.encrypt	= xts_encrypt,
+			.decrypt	= xts_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "ecb(serpent)",
+	.cra_driver_name	= "ecb-serpent-avx",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[5].cra_list),
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "cbc(serpent)",
+	.cra_driver_name	= "cbc-serpent-avx",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[6].cra_list),
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= __ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "ctr(serpent)",
+	.cra_driver_name	= "ctr-serpent-avx",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[7].cra_list),
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_encrypt,
+			.geniv		= "chainiv",
+		},
+	},
+}, {
+	.cra_name		= "lrw(serpent)",
+	.cra_driver_name	= "lrw-serpent-avx",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[8].cra_list),
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE +
+					  SERPENT_BLOCK_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE +
+					  SERPENT_BLOCK_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "xts(serpent)",
+	.cra_driver_name	= "xts-serpent-avx",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(serpent_algs[9].cra_list),
+	.cra_init		= ablk_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE * 2,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE * 2,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+} };
+
+static int __init serpent_init(void)
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
+	return crypto_register_algs(serpent_algs, ARRAY_SIZE(serpent_algs));
+}
+
+static void __exit serpent_exit(void)
+{
+	crypto_unregister_algs(serpent_algs, ARRAY_SIZE(serpent_algs));
+}
+
+module_init(serpent_init);
+module_exit(serpent_exit);
+
+MODULE_DESCRIPTION("Serpent Cipher Algorithm, AVX optimized");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("serpent");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8e84225..3f18b97 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -821,6 +821,26 @@ config CRYPTO_SERPENT_SSE2_586
 	  See also:
 	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
 
+config CRYPTO_SERPENT_AVX_X86_64
+	tristate "Serpent cipher algorithm (x86_64/AVX)"
+	depends on X86 && 64BIT
+	select CRYPTO_ALGAPI
+	select CRYPTO_CRYPTD
+	select CRYPTO_SERPENT
+	select CRYPTO_LRW
+	select CRYPTO_XTS
+	help
+	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
+
+	  Keys are allowed to be from 0 to 256 bits in length, in steps
+	  of 8 bits.
+
+	  This module provides the Serpent cipher algorithm that processes
+	  eight blocks parallel using the AVX instruction set.
+
+	  See also:
+	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
+
 config CRYPTO_TEA
 	tristate "TEA, XTEA and XETA cipher algorithms"
 	select CRYPTO_ALGAPI
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5674878..7e24341 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1534,6 +1534,21 @@ static int alg_test_null(const struct alg_test_desc *desc,
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
 	{
+		.alg = "__cbc-serpent-avx",
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
 		.alg = "__cbc-serpent-sse2",
 		.test = alg_test_null,
 		.suite = {
@@ -1564,6 +1579,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "__driver-cbc-serpent-avx",
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
 		.alg = "__driver-cbc-serpent-sse2",
 		.test = alg_test_null,
 		.suite = {
@@ -1594,6 +1624,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "__driver-ecb-serpent-avx",
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
 		.alg = "__driver-ecb-serpent-sse2",
 		.test = alg_test_null,
 		.suite = {
@@ -1791,6 +1836,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "cryptd(__driver-ecb-serpent-avx)",
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
 		.alg = "cryptd(__driver-ecb-serpent-sse2)",
 		.test = alg_test_null,
 		.suite = {
-- 
1.7.2.5

