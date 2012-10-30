Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760439Ab2J3Shz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:37:55 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45244 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488Ab2J3ShP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:37:15 -0400
From: Behan Webster <behanw@converseincode.com>
To: herbert@gondor.hengli.com.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        pageexec@freemail.hu, Behan Webster <behanw@converseincode.com>
Subject: [PATCH 1/2] Remove VLAIS usage from crypto/hmac.c
Date: Tue, 30 Oct 2012 14:37:28 -0400
Message-Id: <1351622249-18084-2-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351622249-18084-1-git-send-email-behanw@converseincode.com>
References: <1351622249-18084-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
precludes the use of compilers which don't implement VLAIS (for instance the
Clang compiler). This patch instead allocates the appropriate amount of memory
using an char array.

Patch from series at
http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
by PaX Team.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Cc: pageexec@freemail.hu
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 crypto/hmac.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 8d9544c..1061255 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -52,20 +52,19 @@ static int hmac_setkey(struct crypto_shash *parent,
 	struct hmac_ctx *ctx = align_ptr(opad + ss,
 					 crypto_tfm_ctx_alignment());
 	struct crypto_shash *hash = ctx->hash;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(hash)];
-	} desc;
+	char desc[sizeof(struct shash_desc) + crypto_shash_descsize(hash)
+		+ CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash = (struct shash_desc *)desc;
 	unsigned int i;
 
-	desc.shash.tfm = hash;
-	desc.shash.flags = crypto_shash_get_flags(parent) &
-			    CRYPTO_TFM_REQ_MAY_SLEEP;
+	shash->tfm = hash;
+	shash->flags = crypto_shash_get_flags(parent)
+		& CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	if (keylen > bs) {
 		int err;
 
-		err = crypto_shash_digest(&desc.shash, inkey, keylen, ipad);
+		err = crypto_shash_digest(shash, inkey, keylen, ipad);
 		if (err)
 			return err;
 
@@ -81,12 +80,12 @@ static int hmac_setkey(struct crypto_shash *parent,
 		opad[i] ^= 0x5c;
 	}
 
-	return crypto_shash_init(&desc.shash) ?:
-	       crypto_shash_update(&desc.shash, ipad, bs) ?:
-	       crypto_shash_export(&desc.shash, ipad) ?:
-	       crypto_shash_init(&desc.shash) ?:
-	       crypto_shash_update(&desc.shash, opad, bs) ?:
-	       crypto_shash_export(&desc.shash, opad);
+	return crypto_shash_init(shash) ?:
+	       crypto_shash_update(shash, ipad, bs) ?:
+	       crypto_shash_export(shash, ipad) ?:
+	       crypto_shash_init(shash) ?:
+	       crypto_shash_update(shash, opad, bs) ?:
+	       crypto_shash_export(shash, opad);
 }
 
 static int hmac_export(struct shash_desc *pdesc, void *out)
-- 
1.7.9.5

