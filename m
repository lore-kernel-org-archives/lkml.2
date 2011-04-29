Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab1D2WrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:47:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:35753 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab1D2WrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:47:13 -0400
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110429092712.5bbd6948@jbarnes-desktop>
References: <201104212129.17013.arnd@arndb.de>
	 <201104281428.56780.arnd@arndb.de>
	 <20110428131531.GK17290@n2100.arm.linux.org.uk>
	 <201104281629.52863.arnd@arndb.de>
	 <20110428143440.GP17290@n2100.arm.linux.org.uk>
	 <BANLkTinhm7ar1mf1D-dSMiLtw5hRNY36RA@mail.gmail.com>
	 <1304036962.2513.202.camel@pasglop> <4DBA5194.7080609@vmware.com>
	 <1304062523.2513.235.camel@pasglop>
	 <20110429092712.5bbd6948@jbarnes-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Apr 2011 08:46:54 +1000
Message-ID: <1304117214.2513.262.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 09:27 -0700, Jesse Barnes wrote:

> You must be making it sound worse than it really is, otherwise how
> would an embedded platform like the above deal with a display engine
> that needed a large, contiguous chunk of uncached memory for the
> display buffer?  If the CPU is actively speculating into it and
> overwriting blits etc it would never work...  Or do you do such
> reservations up front at 1G granularity??

Such embedded platforms have not been used with GPUs so far and our only
implementation of 64-bit BookE is fortunately also completely cache
coherent :-)

The good thing on ppc is that so far there is no new design coming from
us or FSL that isn't cache coherent. The bad thing is that people seem
to still try to pump out things using old 44x which isn't and somewhat
seem to also want to use GPUs on them :-)

The 44x is a case where I have a small (64 entries) SW loaded TLB and I
bolt the first 768M of the linear mapping (lowmem) using 3x256M entries.
What "saves" it is that it's also an ancient design with essentially a
busted prefetch engine that will thus cope with aliases as long as we
don't explicitely access the cached and non-cached aliases
simultaneously. 

The nasty cases I have never really dealt with properly are the Apple
machines and their non coherent AGP. Those processors were really not
designed with the idea that one would do non-coherent DMA, especially
the 970 (G5) and our Linux code really don't like it.

Things tend to "work" with DRI 1 because we allocate the AGP memory once
in one big chunk (it's pages but they are allocated together and thus
tend to be contiguous) so the possible issues with prefetch are so rare,
I think we end up being lucky. With DRI 2 dynamically mapping things
in/out, we have a bigger problem and I don't know how to solve it other
than forcing the DRM to allocate graphic objects in reserved areas of
memory made of 16M pools that I unmap from the linear mapping.... (since
I use 16M pages to map the linear mapping). 

For ppc32 laptops it's even worse as I use 256MB BATs (block address
translation, kind of special registers to create large static mappings)
to map the linear mapping, which brings me back to the 44x case to some
extent. I can't really do without at the moment, at the very least I
require the kernel text / data / bss to be covered by BATs.

> > Right. We should still shoot HW designers who give up coherency for the
> > sake of 3D benchmarks. It's insanely stupid.
> 
> Ah if it were that simple. :)  There are big costs to implementing full
> coherency for all your devices, as you well know, so it's just not a
> question of benchmark optimization.

But it -is- that simple.

You do have to deal with coherency anyways for your PHB unless you start
advocating that we should make everything else non coherent as well. So
you have the logic. Just make your GPU operate on the same protocol.

It's really only a perf tradeoff I believe. And a bad one.

Cheers,
Ben.

