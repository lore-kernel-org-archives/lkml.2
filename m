Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab0ERTGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 15:06:33 -0400
Received: from waste.org ([173.11.57.241]:56648 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757602Ab0ERTG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 15:06:29 -0400
Subject: Re: [BUG] SLOB breaks Crypto
From: Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Adrian-Ken Rueegsegger <ken@codelabs.ch>,
       Geert Uytterhoeven <geert@linux-m68k.org>, michael-dev@fami-braun.de,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20100518102701.GA7293@gondor.apana.org.au>
References: <4B9E38AF.70309@fami-braun.de>
	 <84144f021003180930s44e239dfmb38183096f07c8a8@mail.gmail.com>
	 <4BA29A19.2050307@fami-braun.de>
	 <20100319003351.GC20227@gondor.apana.org.au>
	 <AANLkTilPEnh3ewTb-KDsReBpjcszh1wkbfZohIaPXBKe@mail.gmail.com>
	 <4BF1BA0E.4010402@codelabs.ch> <1274135869.11603.473.camel@calx>
	 <4BF24D1F.6010005@codelabs.ch>  <20100518102701.GA7293@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 14:06:20 -0500
Message-ID: <1274209580.11603.1198.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 20:27 +1000, Herbert Xu wrote:
> On Tue, May 18, 2010 at 10:17:35AM +0200, Adrian-Ken Rueegsegger wrote:
> > 
> > As noted in my other mail [1] it seems like the HMAC tests trigger these
> > errors.
> 
> Thanks for all the detective work!
> 
> I think the problem is this changeset:
> 
> commit 6eb7228421c01ba48a6a88a7a5b3e71cfb70d4a9
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Tue Jan 8 17:16:44 2008 +1100
> 
>     [CRYPTO] api: Set default CRYPTO_MINALIGN to unsigned long long
>     
>     Thanks to David Miller for pointing out that the SLAB (or SLOB/SLUB)
>     cache uses the alignment of unsigned long long if the architecture
>     kmalloc/slab alignment macros are not defined.
>     
>     This patch changes the CRYPTO_MINALIGN so that it uses the same default
>     value.
>     
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 0aba104..5e02d1b 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -90,13 +90,11 @@
>  #define CRYPTO_MINALIGN ARCH_KMALLOC_MINALIGN
>  #elif defined(ARCH_SLAB_MINALIGN)
>  #define CRYPTO_MINALIGN ARCH_SLAB_MINALIGN
> +#else
> +#define CRYPTO_MINALIGN __alignof__(unsigned long long)
>  #endif
>  
> -#ifdef CRYPTO_MINALIGN
>  #define CRYPTO_MINALIGN_ATTR __attribute__ ((__aligned__(CRYPTO_MINALIGN)))
> -#else
> -#define CRYPTO_MINALIGN_ATTR
> -#endif
>  
>  struct scatterlist;
>  struct crypto_ablkcipher;
> 
> So evidently the assumption made in this change does not work on
> SLOB since it only guarantees __alignof__(unsigned long).

Bingo. Feel free to stick this on your revert:

Acked-by: Matt Mackall <mpm@selenic.com>

Looks like we should ensure that ARCH_KMALLOC_MINALIGN is always
defined.

-- 
Mathematics is the supreme nostalgia of our time.


