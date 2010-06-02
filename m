Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab0FBFOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:14:11 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:34433 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751128Ab0FBFOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:14:09 -0400
Date: Wed, 2 Jun 2010 15:14:03 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Message-ID: <20100602051403.GA5784@gondor.apana.org.au>
References: <20100531160425.GA20344@basil.fritz.box> <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com> <20100601043901.GA25693@gondor.apana.org.au> <Pine.LNX.4.64.1006020051540.22695@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1006020051540.22695@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 01:10:00AM -0400, Mikulas Patocka wrote:
>
> And how can I use pcrypt for dm-crypt? After a quick look at pcrypt 
> sources, it seems to be dependent on aead and not useable for general 
> encryption algorithms at all.

You instantiate a pcrypt variant of whatever algorithm that you're
using.  For example, if you're using XTS then you should instantiate
pcrypt(xts(aes)).  Currently you must use tcrypt to instantiate.

> I tried cryptd --- in theory it should work by requesting the algorithm 
> like cryptd(cbc(aes)) --- but if I replace "%s(%s)" with "cryptd(%s(%s))" 
> in dm-crypt sources it locks up and doesn't work.

cryptd is something else altogether.  However, it certainly should
not lock up.  What kernel version is this?

> > This would be inappropriate for upper layer code as they do not
> > know whether the underlying algorithm should be parallelised,
> > e.g., a PCI offload board certainly should not be parallelised.
> 
> The upper layer should ideally request "cbc(aes)" and the crypto routine 
> should select the most efficient implementation --- sync on single-core 
> system, async with cryptd on multi-core system and async with hardware 
> implementation if you have HIFN crypto card.

That's exactly what will happen when the admin instantiates pcrypt.
dm-crypt simply needs to specify cbc(aes) and it will get pcrypt
automatically.

The point is that on a modern processor like Nehalem you don't need
pcrypt.
 
> It is pointless to track the submitting CPU.

No you are wrong.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
