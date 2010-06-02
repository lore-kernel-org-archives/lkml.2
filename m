Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab0FBFZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:25:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab0FBFZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:25:45 -0400
Date: Wed, 2 Jun 2010 01:25:11 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Herbert Xu <herbert@gondor.hengli.com.au>
cc: device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
In-Reply-To: <20100602051403.GA5784@gondor.apana.org.au>
Message-ID: <Pine.LNX.4.64.1006020119540.22695@hs20-bc2-1.build.redhat.com>
References: <20100531160425.GA20344@basil.fritz.box>
 <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com>
 <20100601043901.GA25693@gondor.apana.org.au>
 <Pine.LNX.4.64.1006020051540.22695@hs20-bc2-1.build.redhat.com>
 <20100602051403.GA5784@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jun 2010, Herbert Xu wrote:

> On Wed, Jun 02, 2010 at 01:10:00AM -0400, Mikulas Patocka wrote:
> >
> > And how can I use pcrypt for dm-crypt? After a quick look at pcrypt 
> > sources, it seems to be dependent on aead and not useable for general 
> > encryption algorithms at all.
> 
> You instantiate a pcrypt variant of whatever algorithm that you're
> using.  For example, if you're using XTS then you should instantiate
> pcrypt(xts(aes)).  Currently you must use tcrypt to instantiate.

I tried "pcrypt(%s(%s))" in dm-crypt and I get "table: 253:0: crypt: Error 
allocating crypto tfm"

Are you sure that you know what you're talking about? pcrypt_alloc 
contains this:
switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
case CRYPTO_ALG_TYPE_AEAD:
        return pcrypt_alloc_aead(tb);
}

return ERR_PTR(-EINVAL);
--- so for anything other byt AEAD it returns -EINVAL.

> > I tried cryptd --- in theory it should work by requesting the algorithm 
> > like cryptd(cbc(aes)) --- but if I replace "%s(%s)" with "cryptd(%s(%s))" 
> > in dm-crypt sources it locks up and doesn't work.
> 
> cryptd is something else altogether.  However, it certainly should
> not lock up.  What kernel version is this?

2.6.34 and cryptsetup 1.1.2. It is a soft lockup interruptible with 
Ctrl-C.

> > > This would be inappropriate for upper layer code as they do not
> > > know whether the underlying algorithm should be parallelised,
> > > e.g., a PCI offload board certainly should not be parallelised.
> > 
> > The upper layer should ideally request "cbc(aes)" and the crypto routine 
> > should select the most efficient implementation --- sync on single-core 
> > system, async with cryptd on multi-core system and async with hardware 
> > implementation if you have HIFN crypto card.
> 
> That's exactly what will happen when the admin instantiates pcrypt.
> dm-crypt simply needs to specify cbc(aes) and it will get pcrypt
> automatically.
> 
> The point is that on a modern processor like Nehalem you don't need
> pcrypt.
>  
> > It is pointless to track the submitting CPU.
> 
> No you are wrong.

For what? For avoiding cache bounces? But the encrypting is 
order-of-magnitude slower than memory speed.

Mikulas
