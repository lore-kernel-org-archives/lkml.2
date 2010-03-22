Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab0CVP25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:28:57 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:32892 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab0CVP2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Aa2FlVT+Ma2KJCb1KXt1nGW58xgtlupAsPmvGJ0yj5W/X2Dk/hNKYjnLY0HzWg69pU
         eZQyiXftiGWJGXFuci5Smsxq8yPIZoLc5VOs2ZhzQYIB8lpaFcDdBEM8l9GoZA7Pnpo8
         wUAmVZ9N3KdfJgwkiSx3rZwJ/MFlULz5HE0YA=
Date: Mon, 22 Mar 2010 18:28:45 +0300
From: Dan Carpenter <error27@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v3] pcrypt: handle crypto_get_attr_type() errors
Message-ID: <20100322152845.GT21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100321092847.GJ5331@bicker> <20100322132342.GJ20508@secunet.com> <20100322135319.GQ21571@bicker> <20100322145357.GK20508@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322145357.GK20508@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was concerned about the error handling for crypto_get_attr_type() in
pcrypt_alloc_aead().  Steffen Klassert pointed out that we could simply
avoid calling crypto_get_attr_type() if we passed the type and mask as a
parameters.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
All three versions have basically been the same except for style issues.
I will confess that this (hopefully final :P) version looks much nicer 
than the earlier ones.

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 8020124..247178c 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -315,16 +315,13 @@ out_free_inst:
 	goto out;
 }
 
-static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb)
+static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb,
+						 u32 type, u32 mask)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
-	struct crypto_attr_type *algt;
-
-	algt = crypto_get_attr_type(tb);
 
-	alg = crypto_get_attr_alg(tb, algt->type,
-				  (algt->mask & CRYPTO_ALG_TYPE_MASK));
+	alg = crypto_get_attr_alg(tb, type, (mask & CRYPTO_ALG_TYPE_MASK));
 	if (IS_ERR(alg))
 		return ERR_CAST(alg);
 
@@ -365,7 +362,7 @@ static struct crypto_instance *pcrypt_alloc(struct rtattr **tb)
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_AEAD:
-		return pcrypt_alloc_aead(tb);
+		return pcrypt_alloc_aead(tb, algt->type, algt->mask);
 	}
 
 	return ERR_PTR(-EINVAL);
