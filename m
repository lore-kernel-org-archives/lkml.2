Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1AFWau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:30:50 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:33221 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab1AFWas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:30:48 -0500
Date: Fri, 7 Jan 2011 09:30:42 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 2.6.38
Message-ID: <20110106223042.GA27080@gondor.apana.org.au>
References: <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au> <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au> <20110106000157.GA16089@gondor.apana.org.au> <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com> <20110106211645.GA26184@gondor.apana.org.au> <AANLkTimwaJCUxvMLoeS5Cpmu7FX3y=coeSdkPrrL4zcr@mail.gmail.com> <20110106213932.GA26538@gondor.apana.org.au> <AANLkTi=fggNhMm1LpOzzZ0_ofaU6w=ahX8SMGgFkHCui@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=fggNhMm1LpOzzZ0_ofaU6w=ahX8SMGgFkHCui@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 02:13:17PM -0800, Linus Torvalds wrote:
> 
> But I'm still missing the part where you show that there is any actual
> use case that makes sense, and that actually improves performance.
> Maybe it's been posted somewhere else, but the thing is, you're asking
> _me_ to pull, and as a result you need to convince _me_ that this is a
> good idea. So if it's been posted/discussed extensively elsewhere,
> please point to those discussions.

The main use-case is bulk encryption/hashing in user-space.  For
example, on Sparc Niagara2 you need to use SPU (Stream Processing
Unit) in order to do crypto at 10Gb/s over the network.  Because
of the hardware design, it is difficult to make use of the SPU
directly in user-space, unless you dedicate the SPU to one single
thread/user.

That is why we need a crypto driver in the kernel as well as a
user-space interface exporting it, to make available a single
piece of hardware resource so that it may be used by multiple
users in user-space.

The same applies to most of the drivers in drivers/crypto, e.g.,
omap provides ARM crypto acceleration providing crypto throughput
that simply cannot be achieved by the CPU itself.

The actual encryption in user-space would be anything that is
done in bulk, such as SSH or SSL.  In fact, the intention is
to implement it just once in a library such as libssl where it
could then be used automatically by all appliations.

> But in your example, it looks like you just give it the key. Which to
> me means that you're totally missing one of the major reasons for
> having a separate protection domain.

Providing such separation is not the primary objective of this API,
which is providing user-space access to off-chip crypto hardware.

However, this is something that has been considered and can be
easily added.  The idea is to first add symmetric key storage
capability to the existing in-kernel keyring API.  Once that is
done we can easily add a new setsockopt to the crypto user-interface
that retrieves the key from the kernel keyring instead of getting
it directly from user-space.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
