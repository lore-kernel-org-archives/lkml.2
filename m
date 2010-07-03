Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab0GCQIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:08:25 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59201 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753686Ab0GCQIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:08:23 -0400
X-Sasl-enc: hVe+2ELwqc0RZ1dAi3875ZKzYs04uAqPTxkxDFbHSKu+ 1278173302
Date: Sat, 3 Jul 2010 13:08:20 -0300
From: Henrique de Moraes Holschuh <hmh@debian.org>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
       "Theodore Ts'o" <tytso@mit.edu>
Cc: Michael Biebl <biebl@debian.org>, 587665@bugs.debian.org,
       linux-kernel@vger.kernel.org, Petter Reinholdtsen <pere@hungry.com>
Subject: Re: [Pkg-sysvinit-devel] Bug#587665: Safety of early boot init of
 /dev/random seed
Message-ID: <20100703160819.GA12343@khazad-dum.debian.net>
References: <20100630184209.GA30971@khazad-dum.debian.net>
 <4C2BCE88.20004@debian.org>
 <20100630234016.GD18711@login1.uio.no>
 <4C2BDCF0.5080203@debian.org>
 <20100701141022.GA3811@login1.uio.no>
 <20100701171357.GE4789@khazad-dum.debian.net>
 <20100702064415.GE3811@login1.uio.no>
 <20100702232919.GA14437@login2.uio.no>
 <20100703012833.GA20929@khazad-dum.debian.net>
 <20100703151636.GB23648@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100703151636.GB23648@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Petter Reinholdtsen to CC, stupid MUA...)

On Sat, 03 Jul 2010, Henrique de Moraes Holschuh wrote:
> Hello,
> 
> We are trying to enhance the Debian support for /dev/random seeding at early
> boot, and we need some expert help to do it right.  Maybe some of you could
> give us some enlightenment on a few issues?
> 
> Apologies in advance if I got the list of Linux kernel maintainers wrong.  I
> have also copied LKML just in case.
> 
> A bit of context:  Debian tries to initialize /dev/random, by restoring the
> pool size and giving it some seed material (through a write to /dev/random)
> from saved state stored in /var.
> 
> Since we store the seed data in /var, that means we only feed it to
> /dev/random relatively late in the boot sequence, after remote filesystems
> are available.  Thus, anything that needs random numbers earlier than that
> point will run with whatever the kernel managed to harness without any sort
> of userspace help (which is probably not much, especially on platforms that
> clear RAM contents at reboot, or after a cold boot).
> 
> We take care of regenerating the stored seed data as soon as we use it, in
> order to avoid as much as possible the possibility of reuse of seed data.
> This means that we write the old seed data to /dev/random, and immediately
> copy poolsize bytes from /dev/urandom to the seed data file.
> 
> The seed data file is also regenerated prior to shutdown.
> 
> We would like to clarify some points, so as to know how safe they are on
> face of certain error modes, and also whether some of what we do is
> necessary at all.  Unfortunately, real answers require more intimate
> knowledge of the theory behind Linux' random pools than we have in the
> Debian initscripts team.
> 
> Here are our questions:
> 
> 1. How much data of unknown quality can we feed the random pool at boot,
>    before it causes damage (i.e. what is the threshold where we violate the
>    "you are not goint to be any worse than you were before" rule) ?
> 
> 2. How dangerous it is to feed the pool with stale seed data in the next
>    boot (i.e. in a failure mode where we do not regenerate the seed file) ?
> 
> 3. What is the optimal size of the seed data based on the pool size ?
> 
> 4. How dangerous it is to have functions that need randomness (like
>    encripted network and partitions, possibly encripted swap with an
>    ephemeral key), BEFORE initializing the random seed ?
> 
> 5. Is there an optimal size for the pool?  Does the quality of the randomness
>    one extracts from the pool increase or decrease with pool size?
> 
> Basically, we need these answers to find our way regarding the following
> decisions:
> 
> a) Is it better to seed the pool as early as possible and risk a larger time
>    window for problem (2) above, instead of the current behaviour where we
>    have a large time window where (4) above happens?
> 
> b) Is it worth the effort to base the seed file on the size of the pool,
>    instead of just using a constant size?  If a constant size is better,
>    which size would that be? 512 bytes? 4096 bytes? 16384 bytes?
> 
> c) What is the maximum seed file size we can allow (maybe based on size of
>    the pool) to try to avoid problem (1) above ?
> 
> We would be very grateful if you could help us find good answers to the
> questions above.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
