Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab1F0Us6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 16:48:58 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:52645 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab1F0Urz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 16:47:55 -0400
Date: Mon, 27 Jun 2011 22:38:50 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Herbert Xu <herbert@gondor.hengli.com.au>
cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Crypto: Don't use err uninitialized in
 algif_hash.c:hash_sendmsg()
In-Reply-To: <20110627065748.GA8770@gondor.apana.org.au>
Message-ID: <alpine.LNX.2.00.1106272237490.30245@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106262320530.26572@swampdragon.chaosbits.net> <20110627065748.GA8770@gondor.apana.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011, Herbert Xu wrote:

> On Sun, Jun 26, 2011 at 11:23:06PM +0200, Jesper Juhl wrote:
> > If af_alg_make_sg() returns <0 in hash_sendmsg() we'll jump to the
> > 'unlock' label without having set 'err' to anything. At the 'unlock'
> > label the value of 'err' is tested to determine return value of the
> > function - not good to base that on a uninitialized variable.
> > 
> > This patch sets 'err' to the return value of hash_sendmsg() before the
> > 'goto' when the value is less than zero, which seems to me to be the
> > proper thing to do.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Thanks for catching this!
> 
You're welcome.

> > diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
> > index 62122a1..1847544 100644
> > --- a/crypto/algif_hash.c
> > +++ b/crypto/algif_hash.c
> > @@ -68,9 +68,10 @@ static int hash_sendmsg(struct kiocb *unused, struct socket *sock,
> >  			int newlen;
> >  
> >  			newlen = af_alg_make_sg(&ctx->sgl, from, len, 0);
> > -			if (newlen < 0)
> > +			if (newlen < 0) {
> > +				err = newlen;
> >  				goto unlock;
> > -
> > +			}
> 
> This isn't quite what we want though.  The error from af_alg_make_sg
> should only be fatal if we haven't sent anything at all.  That is,
> it's OK to get an error on the second try.
> 
> So I'm going to tweak your patch a little bit and apply this:
> 

Ok. Guess I didn't quite understand what was going on there. Thank you for 
fixing it up.

> diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
> index 62122a1..ef5356c 100644
> --- a/crypto/algif_hash.c
> +++ b/crypto/algif_hash.c
> @@ -68,8 +68,10 @@ static int hash_sendmsg(struct kiocb *unused, struct socket *sock,
>  			int newlen;
>  
>  			newlen = af_alg_make_sg(&ctx->sgl, from, len, 0);
> -			if (newlen < 0)
> +			if (newlen < 0) {
> +				err = copied ? 0 : newlen;
>  				goto unlock;
> +			}
>  
>  			ahash_request_set_crypt(&ctx->req, ctx->sgl.sg, NULL,
>  						newlen);
> 
> Cheers,
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

