Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab2FMRDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 13:03:23 -0400
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:53074 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab2FMRDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 13:03:21 -0400
Message-ID: <20120613200317.20733xjrnmv47y04@www.81.fi>
Date: Wed, 13 Jun 2012 20:03:17 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Subject: Re: linux-next: Tree for Jun 13 (crypto)
References: <20120613155440.14672516ffaf5b01f91bb0a2@canb.auug.org.au>
 <4FD8BB95.4000307@xenotime.net>
In-Reply-To: <4FD8BB95.4000307@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_3um5luhlc0qo"
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format.

--=_3um5luhlc0qo
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Quoting Randy Dunlap <rdunlap@xenotime.net>:

> On 06/12/2012 10:54 PM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120612:
>>
>
>
>
> on x86_64:
>
> arch/x86/crypto/serpent-avx-x86_64.o: In function `serpent_xts_decrypt':
> (.text+0x856c): multiple definition of `serpent_xts_decrypt'
> arch/x86/crypto/serpent-sse2-x86_64.o:(.text+0xae8): first defined here

Reverting commit e2f4d85d5b2049a90859aa10de914ed31a4f17a4, "crypto:  
serpent - add common glue code for avx and sse2 implementation",  
should help for most.

> arch/x86/crypto/serpent-avx-x86_64.o: In function `serpent_dec_blk_8way':
> (.text+0x3d70): multiple definition of `serpent_dec_blk_8way'
> arch/x86/crypto/serpent-avx-x86_64.o: In function `__serpent_enc_blk_8way':
> (.text+0x0): multiple definition of `__serpent_enc_blk_8way'

Attached patch should solve these (patch depends on above revert).

-Jussi

--=_3um5luhlc0qo
Content-Type: text/x-patch;
 charset=ISO-8859-1;
 name="01-serpent-sse2-avx-allow-both-to-be-built-into-kernel.patch"
Content-Disposition: attachment;
 filename="01-serpent-sse2-avx-allow-both-to-be-built-into-kernel.patch"
Content-Transfer-Encoding: 7bit

crypto: serpent-sse2/avx - allow both to be built into kernel

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Rename serpent-avx assembler functions so that they do not collide with
serpent-sse2 assembler functions when linking both versions in to same
kernel image.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S |   12 +++--
 arch/x86/crypto/serpent_avx_glue.c          |    2 -
 arch/x86/crypto/serpent_sse2_glue.c         |    2 -
 arch/x86/include/asm/serpent-avx.h          |   32 ++++++++++++++
 arch/x86/include/asm/serpent-sse2.h         |   63 +++++++++++++++++++++++++++
 arch/x86/include/asm/serpent.h              |   63 ---------------------------
 6 files changed, 103 insertions(+), 71 deletions(-)
 create mode 100644 arch/x86/include/asm/serpent-avx.h
 create mode 100644 arch/x86/include/asm/serpent-sse2.h
 delete mode 100644 arch/x86/include/asm/serpent.h

diff --git a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
index 0ed47a1..504106b 100644
--- a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
@@ -579,10 +579,10 @@
 	vmovdqu x3,		(3*4*4)(out);
 
 .align 8
-.global __serpent_enc_blk_8way
-.type   __serpent_enc_blk_8way,@function;
+.global __serpent_enc_blk_8way_avx
+.type   __serpent_enc_blk_8way_avx,@function;
 
-__serpent_enc_blk_8way:
+__serpent_enc_blk_8way_avx:
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
@@ -647,10 +647,10 @@ __enc_xor8:
 	ret;
 
 .align 8
-.global serpent_dec_blk_8way
-.type   serpent_dec_blk_8way,@function;
+.global serpent_dec_blk_8way_avx
+.type   serpent_dec_blk_8way_avx,@function;
 
-serpent_dec_blk_8way:
+serpent_dec_blk_8way_avx:
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 0dc7a26..dd81bab 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -39,7 +39,7 @@
 #include <asm/i387.h>
 #include <asm/xcr.h>
 #include <asm/xsave.h>
-#include <asm/serpent.h>
+#include <asm/serpent-avx.h>
 #include <crypto/scatterwalk.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 4b21be8..deecd25 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -42,7 +42,7 @@
 #include <crypto/lrw.h>
 #include <crypto/xts.h>
 #include <asm/i387.h>
-#include <asm/serpent.h>
+#include <asm/serpent-sse2.h>
 #include <crypto/scatterwalk.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
diff --git a/arch/x86/include/asm/serpent-avx.h b/arch/x86/include/asm/serpent-avx.h
new file mode 100644
index 0000000..432deed
--- /dev/null
+++ b/arch/x86/include/asm/serpent-avx.h
@@ -0,0 +1,32 @@
+#ifndef ASM_X86_SERPENT_AVX_H
+#define ASM_X86_SERPENT_AVX_H
+
+#include <linux/crypto.h>
+#include <crypto/serpent.h>
+
+#define SERPENT_PARALLEL_BLOCKS 8
+
+asmlinkage void __serpent_enc_blk_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+					   const u8 *src, bool xor);
+asmlinkage void serpent_dec_blk_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+					 const u8 *src);
+
+static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
+				   const u8 *src)
+{
+	__serpent_enc_blk_8way_avx(ctx, dst, src, false);
+}
+
+static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
+				       const u8 *src)
+{
+	__serpent_enc_blk_8way_avx(ctx, dst, src, true);
+}
+
+static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
+				   const u8 *src)
+{
+	serpent_dec_blk_8way_avx(ctx, dst, src);
+}
+
+#endif
diff --git a/arch/x86/include/asm/serpent-sse2.h b/arch/x86/include/asm/serpent-sse2.h
new file mode 100644
index 0000000..e6e77df
--- /dev/null
+++ b/arch/x86/include/asm/serpent-sse2.h
@@ -0,0 +1,63 @@
+#ifndef ASM_X86_SERPENT_SSE2_H
+#define ASM_X86_SERPENT_SSE2_H
+
+#include <linux/crypto.h>
+#include <crypto/serpent.h>
+
+#ifdef CONFIG_X86_32
+
+#define SERPENT_PARALLEL_BLOCKS 4
+
+asmlinkage void __serpent_enc_blk_4way(struct serpent_ctx *ctx, u8 *dst,
+				       const u8 *src, bool xor);
+asmlinkage void serpent_dec_blk_4way(struct serpent_ctx *ctx, u8 *dst,
+				     const u8 *src);
+
+static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
+					const u8 *src)
+{
+	__serpent_enc_blk_4way(ctx, dst, src, false);
+}
+
+static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
+					    const u8 *src)
+{
+	__serpent_enc_blk_4way(ctx, dst, src, true);
+}
+
+static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
+					const u8 *src)
+{
+	serpent_dec_blk_4way(ctx, dst, src);
+}
+
+#else
+
+#define SERPENT_PARALLEL_BLOCKS 8
+
+asmlinkage void __serpent_enc_blk_8way(struct serpent_ctx *ctx, u8 *dst,
+				       const u8 *src, bool xor);
+asmlinkage void serpent_dec_blk_8way(struct serpent_ctx *ctx, u8 *dst,
+				     const u8 *src);
+
+static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
+				   const u8 *src)
+{
+	__serpent_enc_blk_8way(ctx, dst, src, false);
+}
+
+static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
+				       const u8 *src)
+{
+	__serpent_enc_blk_8way(ctx, dst, src, true);
+}
+
+static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
+				   const u8 *src)
+{
+	serpent_dec_blk_8way(ctx, dst, src);
+}
+
+#endif
+
+#endif
diff --git a/arch/x86/include/asm/serpent.h b/arch/x86/include/asm/serpent.h
deleted file mode 100644
index d3ef63f..0000000
--- a/arch/x86/include/asm/serpent.h
+++ /dev/null
@@ -1,63 +0,0 @@
-#ifndef ASM_X86_SERPENT_H
-#define ASM_X86_SERPENT_H
-
-#include <linux/crypto.h>
-#include <crypto/serpent.h>
-
-#ifdef CONFIG_X86_32
-
-#define SERPENT_PARALLEL_BLOCKS 4
-
-asmlinkage void __serpent_enc_blk_4way(struct serpent_ctx *ctx, u8 *dst,
-				       const u8 *src, bool xor);
-asmlinkage void serpent_dec_blk_4way(struct serpent_ctx *ctx, u8 *dst,
-				     const u8 *src);
-
-static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-					const u8 *src)
-{
-	__serpent_enc_blk_4way(ctx, dst, src, false);
-}
-
-static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
-					    const u8 *src)
-{
-	__serpent_enc_blk_4way(ctx, dst, src, true);
-}
-
-static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-					const u8 *src)
-{
-	serpent_dec_blk_4way(ctx, dst, src);
-}
-
-#else
-
-#define SERPENT_PARALLEL_BLOCKS 8
-
-asmlinkage void __serpent_enc_blk_8way(struct serpent_ctx *ctx, u8 *dst,
-				       const u8 *src, bool xor);
-asmlinkage void serpent_dec_blk_8way(struct serpent_ctx *ctx, u8 *dst,
-				     const u8 *src);
-
-static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-				   const u8 *src)
-{
-	__serpent_enc_blk_8way(ctx, dst, src, false);
-}
-
-static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
-				       const u8 *src)
-{
-	__serpent_enc_blk_8way(ctx, dst, src, true);
-}
-
-static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-				   const u8 *src)
-{
-	serpent_dec_blk_8way(ctx, dst, src);
-}
-
-#endif
-
-#endif

--=_3um5luhlc0qo--

