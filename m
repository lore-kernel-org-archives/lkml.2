Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0GESki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 14:40:38 -0400
Received: from waste.org ([173.11.57.241]:60259 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab0GESkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 14:40:36 -0400
Subject: Re: [Pkg-sysvinit-devel] Bug#587665: Safety of early boot init of
 /dev/random seed
From: Matt Mackall <mpm@selenic.com>
To: Henrique de Moraes Holschuh <hmh@debian.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, "Theodore Ts'o" <tytso@mit.edu>,
       Michael Biebl <biebl@debian.org>, 587665@bugs.debian.org,
       linux-kernel@vger.kernel.org, Petter Reinholdtsen <pere@hungry.com>
In-Reply-To: <20100703160819.GA12343@khazad-dum.debian.net>
References: <20100630184209.GA30971@khazad-dum.debian.net>
	 <4C2BCE88.20004@debian.org> <20100630234016.GD18711@login1.uio.no>
	 <4C2BDCF0.5080203@debian.org> <20100701141022.GA3811@login1.uio.no>
	 <20100701171357.GE4789@khazad-dum.debian.net>
	 <20100702064415.GE3811@login1.uio.no>
	 <20100702232919.GA14437@login2.uio.no>
	 <20100703012833.GA20929@khazad-dum.debian.net>
	 <20100703151636.GB23648@khazad-dum.debian.net>
	 <20100703160819.GA12343@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 13:40:33 -0500
Message-ID: <1278355233.9937.21.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-03 at 13:08 -0300, Henrique de Moraes Holschuh wrote:
> (adding Petter Reinholdtsen to CC, stupid MUA...)
> 
> On Sat, 03 Jul 2010, Henrique de Moraes Holschuh wrote:
> > Hello,
> > 
> > We are trying to enhance the Debian support for /dev/random seeding at early
> > boot, and we need some expert help to do it right.  Maybe some of you could
> > give us some enlightenment on a few issues?
> > 
> > Apologies in advance if I got the list of Linux kernel maintainers wrong.  I
> > have also copied LKML just in case.
> > 
> > A bit of context:  Debian tries to initialize /dev/random, by restoring the
> > pool size and giving it some seed material (through a write to /dev/random)
> > from saved state stored in /var.
> > 
> > Since we store the seed data in /var, that means we only feed it to
> > /dev/random relatively late in the boot sequence, after remote filesystems
> > are available.  Thus, anything that needs random numbers earlier than that
> > point will run with whatever the kernel managed to harness without any sort
> > of userspace help (which is probably not much, especially on platforms that
> > clear RAM contents at reboot, or after a cold boot).
> > 
> > We take care of regenerating the stored seed data as soon as we use it, in
> > order to avoid as much as possible the possibility of reuse of seed data.
> > This means that we write the old seed data to /dev/random, and immediately
> > copy poolsize bytes from /dev/urandom to the seed data file.
> > 
> > The seed data file is also regenerated prior to shutdown.
> > 
> > We would like to clarify some points, so as to know how safe they are on
> > face of certain error modes, and also whether some of what we do is
> > necessary at all.  Unfortunately, real answers require more intimate
> > knowledge of the theory behind Linux' random pools than we have in the
> > Debian initscripts team.
> > 
> > Here are our questions:
> > 
> > 1. How much data of unknown quality can we feed the random pool at boot,
> >    before it causes damage (i.e. what is the threshold where we violate the
> >    "you are not goint to be any worse than you were before" rule) ?

There is no limit. The mixing operations are computationally reversible,
which guarantees that no unknown degrees of freedom are clobbered when
mixing known data.

> > 2. How dangerous it is to feed the pool with stale seed data in the next
> >    boot (i.e. in a failure mode where we do not regenerate the seed file) ?

Not at all.
 
> > 3. What is the optimal size of the seed data based on the pool size ?

1:1.

> > 4. How dangerous it is to have functions that need randomness (like
> >    encripted network and partitions, possibly encripted swap with an
> >    ephemeral key), BEFORE initializing the random seed ?

Depends on the platform. For instance, if you've got an unattended boot
off a Live CD on a machine with a predictable clock, you may get
duplicate outputs.

> > 5. Is there an optimal size for the pool?  Does the quality of the randomness
> >    one extracts from the pool increase or decrease with pool size?

Don't bother fiddling with the pool size.

> > Basically, we need these answers to find our way regarding the following
> > decisions:
> > 
> > a) Is it better to seed the pool as early as possible and risk a larger time
> >    window for problem (2) above, instead of the current behaviour where we
> >    have a large time window where (4) above happens?

Earlier is better.

> > b) Is it worth the effort to base the seed file on the size of the pool,
> >    instead of just using a constant size?  If a constant size is better,
> >    which size would that be? 512 bytes? 4096 bytes? 16384 bytes?

512 bytes is plenty.
 
> > c) What is the maximum seed file size we can allow (maybe based on size of
> >    the pool) to try to avoid problem (1) above ?

Anything larger than a sector is simply wasting CPU time, but is
otherwise harmless.

-- 
Mathematics is the supreme nostalgia of our time.


