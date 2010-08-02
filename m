Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0HBEwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 00:52:23 -0400
Received: from waste.org ([173.11.57.241]:34444 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab0HBEwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 00:52:22 -0400
Subject: Re: [Pkg-sysvinit-devel] Bug#587665: Safety of early boot init of
 /dev/random seed
From: Matt Mackall <mpm@selenic.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Henrique de Moraes Holschuh <hmh@debian.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <1280703171.10108.35.camel@fermat.scientia.net>
References: <20100630184209.GA30971@khazad-dum.debian.net>
	 <4C2BCE88.20004@debian.org> <20100630234016.GD18711@login1.uio.no>
	 <4C2BDCF0.5080203@debian.org> <20100701141022.GA3811@login1.uio.no>
	 <20100701171357.GE4789@khazad-dum.debian.net>
	 <20100702064415.GE3811@login1.uio.no>
	 <20100702232919.GA14437@login2.uio.no>
	 <20100703012833.GA20929@khazad-dum.debian.net>
	 <20100703151636.GB23648@khazad-dum.debian.net>
	 <20100703160819.GA12343@khazad-dum.debian.net>
	 <1278355233.9937.21.camel@calx>
	 <1280703171.10108.35.camel@fermat.scientia.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Aug 2010 23:52:12 -0500
Message-ID: <1280724732.18586.28.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 00:52 +0200, Christoph Anton Mitterer wrote:
> Hey Matt...
> 
> May I ask you a follow-up question on that,... which is however not so
> much Debian-init-related, I guess.
> 
> 
> On Mon, 2010-07-05 at 13:40 -0500, Matt Mackall wrote:
> > > > 1. How much data of unknown quality can we feed the random pool at boot,
> > > >    before it causes damage (i.e. what is the threshold where we violate the
> > > >    "you are not goint to be any worse than you were before" rule) ?
> > 
> > There is no limit. The mixing operations are computationally reversible,
> > which guarantees that no unknown degrees of freedom are clobbered when
> > mixing known data.
> > 
> > > > 2. How dangerous it is to feed the pool with stale seed data in the next
> > > >    boot (i.e. in a failure mode where we do not regenerate the seed file) ?
> > 
> > Not at all.
> 
> Are the above to statements also true for possibly "evil" random data?

Yes. Mixing in known values will not cause the contents of the pool to
become 'more known'. This is what I mean about reversible mixing
(without getting too technical): you can mix in a billion known values,
then mathematically reverse the billion mixing operations to return to
the original unknown state. Which means that the state after a billion
operations has just as much unknown-ness as it did when it started.

Here's the simplest version: consider that you've got a single unknown
bit X. Then you "mix" in Y1...Y9999 with X'=X^Y (reversible with
X=X'^Y). Because you don't know anything about X beforehand, no number
or pattern of bits Yn is going to improve your guess of the final value
of X - after each operation, it's still exactly as unguessable as
before.

Crucially, though, if you start with a _known_ value and mix in
_unknowns_ (what you're usually trying to do), the resulting state's
unknown-ness increases. With a good mixing function (and ours is pretty
decent), repeated addition of unknown values rapidly saturates the
unknown-ness of the pool.

-- 
Mathematics is the supreme nostalgia of our time.


