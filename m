Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1GXSC5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 14:02:57 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:35806 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1GXSCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 14:02:51 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
        Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH v2 1/2] crypto, sha1: export sha1_update for reuse
Date: Sun, 24 Jul 2011 19:53:13 +0200
Message-Id: <1311529994-7924-2-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1311529994-7924-1-git-send-email-minipli@googlemail.com>
References: <1311529994-7924-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the update function as crypto_sha1_update() to not have the need
to reimplement the same algorithm for each SHA-1 implementation. This
way the generic SHA-1 implementation can be used as fallback for other
implementations that fail to run under certain circumstances, like the
need for an FPU context while executing in IRQ context.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 crypto/sha1_generic.c |    9 +++++----
 include/crypto/sha.h  |    5 +++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 0416091..0b6d907 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -36,7 +36,7 @@ static int sha1_init(struct shash_desc *desc)
 	return 0;
 }
 
-static int sha1_update(struct shash_desc *desc, const u8 *data,
+int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
 {
 	struct sha1_state *sctx = shash_desc_ctx(desc);
@@ -70,6 +70,7 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 
 	return 0;
 }
+EXPORT_SYMBOL(crypto_sha1_update);
 
 
 /* Add padding and return the message digest. */
@@ -86,10 +87,10 @@ static int sha1_final(struct shash_desc *desc, u8 *out)
 	/* Pad out to 56 mod 64 */
 	index = sctx->count & 0x3f;
 	padlen = (index < 56) ? (56 - index) : ((64+56) - index);
-	sha1_update(desc, padding, padlen);
+	crypto_sha1_update(desc, padding, padlen);
 
 	/* Append length */
-	sha1_update(desc, (const u8 *)&bits, sizeof(bits));
+	crypto_sha1_update(desc, (const u8 *)&bits, sizeof(bits));
 
 	/* Store state in digest */
 	for (i = 0; i < 5; i++)
@@ -120,7 +121,7 @@ static int sha1_import(struct shash_desc *desc, const void *in)
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_init,
-	.update		=	sha1_update,
+	.update		=	crypto_sha1_update,
 	.final		=	sha1_final,
 	.export		=	sha1_export,
 	.import		=	sha1_import,
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 069e85b..7c46d0c 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -82,4 +82,9 @@ struct sha512_state {
 	u8 buf[SHA512_BLOCK_SIZE];
 };
 
+#if defined(CONFIG_CRYPTO_SHA1) || defined (CONFIG_CRYPTO_SHA1_MODULE)
+extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
+			      unsigned int len);
+#endif
+
 #endif
-- 
1.5.6.5

