Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab0ESBwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:52:17 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:58186 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752338Ab0ESBwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:52:14 -0400
Date: Wed, 19 May 2010 11:51:54 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Cc: Matt Mackall <mpm@selenic.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
       michael-dev@fami-braun.de, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [BUG] SLOB breaks Crypto
Message-ID: <20100519015154.GA19450@gondor.apana.org.au>
References: <4B9E38AF.70309@fami-braun.de> <84144f021003180930s44e239dfmb38183096f07c8a8@mail.gmail.com> <4BA29A19.2050307@fami-braun.de> <20100319003351.GC20227@gondor.apana.org.au> <AANLkTilPEnh3ewTb-KDsReBpjcszh1wkbfZohIaPXBKe@mail.gmail.com> <4BF1BA0E.4010402@codelabs.ch> <1274135869.11603.473.camel@calx> <4BF24D1F.6010005@codelabs.ch> <20100518102701.GA7293@gondor.apana.org.au> <4BF2EB66.4020207@codelabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF2EB66.4020207@codelabs.ch>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 09:32:54PM +0200, Adrian-Ken Rueegsegger wrote:
> 
> When doing the revert it is necessary to either have
> ARCH_KMALLOC_MINALIGN defined or explicitly define CRYPTO_MINALIGN in
> the case where it is not. Otherwise shash compilation fails because it
> needs CRYPTO_MINALIGN.

I've added the following patch.  Thanks!

commit 18eb8ea6ee4cc9ed39b45f95b734f523bcfb586b
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed May 19 11:50:58 2010 +1000

    crypto: shash - Remove usage of CRYPTO_MINALIGN
    
    The macro CRYPTO_MINALIGN is not meant to be used directly.  This
    patch replaces it with crypto_tfm_ctx_alignment.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/shash.c b/crypto/shash.c
index 91f7b9d..22fd943 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -37,7 +37,7 @@ static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
 	u8 *buffer, *alignbuffer;
 	int err;
 
-	absize = keylen + (alignmask & ~(CRYPTO_MINALIGN - 1));
+	absize = keylen + (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
 	buffer = kmalloc(absize, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;

-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
