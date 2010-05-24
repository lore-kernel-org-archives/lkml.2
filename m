Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab0EXXYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:24:53 -0400
Received: from kroah.org ([198.145.64.141]:59538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691Ab0EXXX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:58 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:16 2010
Message-Id: <20100524231816.694687412@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [39/39] crypto: authenc - Add EINPROGRESS check
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

commit 180ce7e81030e1ef763d58f97f9ab840ff57d848 upstream.

When Steffen originally wrote the authenc async hash patch, he
correctly had EINPROGRESS checks in place so that we did not invoke
the original completion handler with it.

Unfortuantely I told him to remove it before the patch was applied.

As only MAY_BACKLOG request completion handlers are required to
handle EINPROGRESS completions, those checks are really needed.

This patch restores them.

Reported-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/authenc.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -46,6 +46,12 @@ struct authenc_request_ctx {
 	char tail[];
 };
 
+static void authenc_request_complete(struct aead_request *req, int err)
+{
+	if (err != -EINPROGRESS)
+		aead_request_complete(req, err);
+}
+
 static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 				 unsigned int keylen)
 {
@@ -142,7 +148,7 @@ static void authenc_geniv_ahash_update_d
 				 crypto_aead_authsize(authenc), 1);
 
 out:
-	aead_request_complete(req, err);
+	authenc_request_complete(req, err);
 }
 
 static void authenc_geniv_ahash_done(struct crypto_async_request *areq, int err)
@@ -208,7 +214,7 @@ static void authenc_verify_ahash_update_
 	err = crypto_ablkcipher_decrypt(abreq);
 
 out:
-	aead_request_complete(req, err);
+	authenc_request_complete(req, err);
 }
 
 static void authenc_verify_ahash_done(struct crypto_async_request *areq,
@@ -245,7 +251,7 @@ static void authenc_verify_ahash_done(st
 	err = crypto_ablkcipher_decrypt(abreq);
 
 out:
-	aead_request_complete(req, err);
+	authenc_request_complete(req, err);
 }
 
 static u8 *crypto_authenc_ahash_fb(struct aead_request *req, unsigned int flags)
@@ -379,7 +385,7 @@ static void crypto_authenc_encrypt_done(
 		err = crypto_authenc_genicv(areq, iv, 0);
 	}
 
-	aead_request_complete(areq, err);
+	authenc_request_complete(areq, err);
 }
 
 static int crypto_authenc_encrypt(struct aead_request *req)
@@ -418,7 +424,7 @@ static void crypto_authenc_givencrypt_do
 		err = crypto_authenc_genicv(areq, greq->giv, 0);
 	}
 
-	aead_request_complete(areq, err);
+	authenc_request_complete(areq, err);
 }
 
 static int crypto_authenc_givencrypt(struct aead_givcrypt_request *req)


