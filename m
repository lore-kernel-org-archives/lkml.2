Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab1F0G73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 02:59:29 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:39034 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab1F0G5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 02:57:52 -0400
Date: Mon, 27 Jun 2011 14:57:48 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Crypto: Don't use err uninitialized in
	algif_hash.c:hash_sendmsg()
Message-ID: <20110627065748.GA8770@gondor.apana.org.au>
References: <alpine.LNX.2.00.1106262320530.26572@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106262320530.26572@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 11:23:06PM +0200, Jesper Juhl wrote:
> If af_alg_make_sg() returns <0 in hash_sendmsg() we'll jump to the
> 'unlock' label without having set 'err' to anything. At the 'unlock'
> label the value of 'err' is tested to determine return value of the
> function - not good to base that on a uninitialized variable.
> 
> This patch sets 'err' to the return value of hash_sendmsg() before the
> 'goto' when the value is less than zero, which seems to me to be the
> proper thing to do.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Thanks for catching this!

> diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
> index 62122a1..1847544 100644
> --- a/crypto/algif_hash.c
> +++ b/crypto/algif_hash.c
> @@ -68,9 +68,10 @@ static int hash_sendmsg(struct kiocb *unused, struct socket *sock,
>  			int newlen;
>  
>  			newlen = af_alg_make_sg(&ctx->sgl, from, len, 0);
> -			if (newlen < 0)
> +			if (newlen < 0) {
> +				err = newlen;
>  				goto unlock;
> -
> +			}

This isn't quite what we want though.  The error from af_alg_make_sg
should only be fatal if we haven't sent anything at all.  That is,
it's OK to get an error on the second try.

So I'm going to tweak your patch a little bit and apply this:

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 62122a1..ef5356c 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -68,8 +68,10 @@ static int hash_sendmsg(struct kiocb *unused, struct socket *sock,
 			int newlen;
 
 			newlen = af_alg_make_sg(&ctx->sgl, from, len, 0);
-			if (newlen < 0)
+			if (newlen < 0) {
+				err = copied ? 0 : newlen;
 				goto unlock;
+			}
 
 			ahash_request_set_crypt(&ctx->req, ctx->sgl.sg, NULL,
 						newlen);

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
