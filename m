Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab0CVNxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:53:33 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47015 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab0CVNxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=qwv8fevJwocnkxXXKgniGCC9E4bIF5fAaxwZKosy0prJ+Qi9RnyiKiNt9T2yj9z4Ob
         I/zUvFF/jLSg/oOJm/o9X8EriG1edYmoec/Vmdu/yr3peHgPbpJyp1MueB734ISI+TQH
         t9+jjB1Q3no8s214c3a7aepar8YyH66hnT9rQ=
Date: Mon, 22 Mar 2010 16:53:19 +0300
From: Dan Carpenter <error27@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] pcrypt: handle crypto_get_attr_type() errors
Message-ID: <20100322135319.GQ21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100321092847.GJ5331@bicker> <20100322132342.GJ20508@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322132342.GJ20508@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was concerned about the error handling for crypto_get_attr_type() in
pcrypt_alloc_aead().  Steffen Klassert pointed out that we could simply 
avoid calling crypto_get_attr_type() if we passed the type and mask as a 
parameter.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 8020124..e049388 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -315,13 +315,11 @@ out_free_inst:
 	goto out;
 }
 
-static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb)
+static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb,
+						 struct crypto_attr_type *algt)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
-	struct crypto_attr_type *algt;
-
-	algt = crypto_get_attr_type(tb);
 
 	alg = crypto_get_attr_alg(tb, algt->type,
 				  (algt->mask & CRYPTO_ALG_TYPE_MASK));
@@ -365,7 +363,7 @@ static struct crypto_instance *pcrypt_alloc(struct rtattr **tb)
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_AEAD:
-		return pcrypt_alloc_aead(tb);
+		return pcrypt_alloc_aead(tb, algt);
 	}
 
 	return ERR_PTR(-EINVAL);
