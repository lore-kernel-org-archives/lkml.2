Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab0GWRpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:45:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56384 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab0GWRpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:45:13 -0400
Date: Fri, 23 Jul 2010 13:32:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        linux-kernel@vger.kernel.org
Subject: Re: b43 wireless driver inhibits access to /dev/hwrng
Message-ID: <20100723173246.GC2426@tuxdriver.com>
References: <20100722225212.GA19361@darkside.kls.lan>
 <20100723143219.GA2426@tuxdriver.com>
 <20100723153101.GA12795@darkside.kls.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723153101.GA12795@darkside.kls.lan>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 05:31:02PM +0200, Mario 'BitKoenig' Holbe wrote:
> On Fri, Jul 23, 2010 at 10:32:19AM -0400, John W. Linville wrote:
> > The hwrng driver is provided by the b43 hardware, which is shutdown
> > when the network interface is down.  I'm not sure how one could expect
> > this to work.
> 
> Nope. It's provided by the VIA PadLock hardware (through the via-rng
> driver). I'm not sure how one could expect this not to work when the
> network interface provided by the b43 driver is down.

Alright, sorry I overlooked that.  Although it still looks to me like
your current_rng must be the b43-provided one, or else you wouldn't
be experiencing this issue.

> Well, maybe let's try to become a bit less offensive... :)
> Probably there are two Hardware RNGs on that machine: one provided by
> VIA PadLock through via-rng, one provided by BCM4312 through b43:
> 	hw_random/via-rng.c:    err = hwrng_register(&via_rng);
> 	b43/main.c: err = hwrng_register(&wl->rng);
> 
> But at least now it's a bit more likely that the problem is located in
> the rng core which should not render /dev/hwrng inaccessible when only
> one of the RNGs unregisters.
> 
> However, what I don't fully understand is: I find only one way where b43
> unregisters its RNG, which is via
> 	b43_remove() -> b43_rng_exit() -> hwrng_unregister()
> And, I'm really not sure if I got this right, but... I guess,
> b43_remove() is only called when the module is removed from the kernel
> and not when the network interface is shut down.
> 
> So, maybe it's not really rng core's fault?
> I guess, b43 just stops delivering data through b43_rng_read() when the
> hardware is shut down and instead returns ENODEV (which is btw. what I
> get when I'm trying to read /dev/hwrng while b43 is down), and the rng
> core just delivers this error up when it's trying to deliver the read
> request to the b43 RNG.

Yes, I believe this is what the b43 hwrng is doing.  I suspect you
need/want a way to influence current_rng to favor via-rng.  You may
want to reference Documentation/hw_random.txt for further information.

Good luck!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
