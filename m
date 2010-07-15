Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935026Ab0GOXdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 19:33:12 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52505 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934995Ab0GOXdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 19:33:10 -0400
X-Sasl-enc: Y7fM+HCDiLb1p46/s8bS/GpR0MFkTWm4wY9smcHxR6hM 1279236788
Date: Thu, 15 Jul 2010 20:33:05 -0300
From: Henrique de Moraes Holschuh <hmh@debian.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, "Theodore Ts'o" <tytso@mit.edu>,
        Michael Biebl <biebl@debian.org>, 587665@bugs.debian.org,
        linux-kernel@vger.kernel.org, Petter Reinholdtsen <pere@hungry.com>
Subject: Re: [Pkg-sysvinit-devel] Bug#587665: Safety of early boot init of
 /dev/random seed
Message-ID: <20100715233305.GF27512@khazad-dum.debian.net>
References: <20100630234016.GD18711@login1.uio.no>
 <4C2BDCF0.5080203@debian.org>
 <20100701141022.GA3811@login1.uio.no>
 <20100701171357.GE4789@khazad-dum.debian.net>
 <20100702064415.GE3811@login1.uio.no>
 <20100702232919.GA14437@login2.uio.no>
 <20100703012833.GA20929@khazad-dum.debian.net>
 <20100703151636.GB23648@khazad-dum.debian.net>
 <20100703160819.GA12343@khazad-dum.debian.net>
 <1278355233.9937.21.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278355233.9937.21.camel@calx>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jul 2010, Matt Mackall wrote:
> > > Here are our questions:
> > > 
> > > 1. How much data of unknown quality can we feed the random pool at boot,
> > >    before it causes damage (i.e. what is the threshold where we violate the
> > >    "you are not goint to be any worse than you were before" rule) ?
> 
> There is no limit. The mixing operations are computationally reversible,
> which guarantees that no unknown degrees of freedom are clobbered when
> mixing known data.

Good.  So, whatever we do, we are never worse off than we were before we did
it, at least by design.

> > > 2. How dangerous it is to feed the pool with stale seed data in the next
> > >    boot (i.e. in a failure mode where we do not regenerate the seed file) ?
> 
> Not at all.
>  
> > > 3. What is the optimal size of the seed data based on the pool size ?
> 
> 1:1.

We shall try to keep it at 1:1, then.

> > > 4. How dangerous it is to have functions that need randomness (like
> > >    encripted network and partitions, possibly encripted swap with an
> > >    ephemeral key), BEFORE initializing the random seed ?
> 
> Depends on the platform. For instance, if you've got an unattended boot
> off a Live CD on a machine with a predictable clock, you may get
> duplicate outputs.

I.e. it is somewhat dangerous, and we should try to avoid it by design, so
we should try to init it as early as possible.  Very well.

> > > 5. Is there an optimal size for the pool?  Does the quality of the randomness
> > >    one extracts from the pool increase or decrease with pool size?
> 
> Don't bother fiddling with the pool size.

We don't, but local admins often do, probably in an attempt to better handle
bursts of entropy drainage.  So, we do want to properly support non-standard
pool sizes in Debian if we can.

> > > Basically, we need these answers to find our way regarding the following
> > > decisions:
> > > 
> > > a) Is it better to seed the pool as early as possible and risk a larger time
> > >    window for problem (2) above, instead of the current behaviour where we
> > >    have a large time window where (4) above happens?
> 
> Earlier is better.
> 
> > > b) Is it worth the effort to base the seed file on the size of the pool,
> > >    instead of just using a constant size?  If a constant size is better,
> > >    which size would that be? 512 bytes? 4096 bytes? 16384 bytes?
> 
> 512 bytes is plenty.
>
> > > c) What is the maximum seed file size we can allow (maybe based on size of
> > >    the pool) to try to avoid problem (1) above ?
> 
> Anything larger than a sector is simply wasting CPU time, but is
> otherwise harmless.

Well, a filesystem block is usually 1024 bytes, and a sector is 4096 bytes
nowadays... :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
