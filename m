Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab2IIVAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 17:00:10 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:51748 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751192Ab2IIVAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 17:00:08 -0400
Date: Sun, 9 Sep 2012 14:00:00 -0700
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Mathias Krause <minipli@googlemail.com>
Cc: Romain Francoise <romain@orebokech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Linux 3.6-rc5
Message-ID: <20120909210000.GA10293@gondor.apana.org.au>
References: <CA+55aFwnPfdyTTG6WTuhChomg=t9nSS18xracq3iQ3F5+PWOog@mail.gmail.com>
 <87har7h84h.fsf@silenus.orebokech.com>
 <20120909191958.GB9782@gondor.apana.org.au>
 <20120909200910.GA11919@r00tworld.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120909200910.GA11919@r00tworld.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2012 at 10:09:10PM +0200, Mathias Krause wrote:
>
> It happens with the C variants of SHA1 and AES, too. You can easily
> trigger the bug with Steffen's crconf[1]:
> 
> $ crconf add alg "authenc(hmac(sha1-generic),cbc(aes-generic))" type 3
> 
> So the problem is likely not related to sha1-ssse3.ko or aesni-intel.ko.

Thanks! I think this patch should fix the problem.  Can someone
please confirm this?

crypto: authenc - Fix crash with zero-length assoc data

The authenc code doesn't deal with zero-length associated data
correctly and ends up constructing a zero-length sg entry which
causes a crash when it's fed into the crypto system.

This patch fixes this by avoiding the code-path that triggers
the SG construction if we have no associated data.

This isn't the most optimal fix as it means that we'll end up
using the fallback code-path even when we could still execute
the digest function.  However, this isn't a big deal as nobody
but the test path would supply zero-length associated data.

Reported-by: Romain Francoise <romain@orebokech.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 5ef7ba6..d0583a4 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -336,7 +336,7 @@ static int crypto_authenc_genicv(struct aead_request *req, u8 *iv,
 		cryptlen += ivsize;
 	}
 
-	if (sg_is_last(assoc)) {
+	if (req->assoclen && sg_is_last(assoc)) {
 		authenc_ahash_fn = crypto_authenc_ahash;
 		sg_init_table(asg, 2);
 		sg_set_page(asg, sg_page(assoc), assoc->length, assoc->offset);
@@ -490,7 +490,7 @@ static int crypto_authenc_iverify(struct aead_request *req, u8 *iv,
 		cryptlen += ivsize;
 	}
 
-	if (sg_is_last(assoc)) {
+	if (req->assoclen && sg_is_last(assoc)) {
 		authenc_ahash_fn = crypto_authenc_ahash;
 		sg_init_table(asg, 2);
 		sg_set_page(asg, sg_page(assoc), assoc->length, assoc->offset);

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
