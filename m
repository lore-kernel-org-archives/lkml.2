Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab1D1O6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:58:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58722 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab1D1O6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:58:37 -0400
Date: Thu, 28 Apr 2011 15:58:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110428145816.GR17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de> <201104281629.52863.arnd@arndb.de> <20110428143440.GP17290@n2100.arm.linux.org.uk> <201104281640.00107.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104281640.00107.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 04:39:59PM +0200, Arnd Bergmann wrote:
> On Thursday 28 April 2011, Russell King - ARM Linux wrote:
> > On Thu, Apr 28, 2011 at 04:29:52PM +0200, Arnd Bergmann wrote:
> > > Given that people still want to have an interface that does what I
> > > though this one did, I guess we have two options:
> > > 
> > > * Kill off dma_cache_sync and replace it with calls to dma_sync_*
> > >   so we can start using dma_alloc_noncoherent on ARM
> > 
> > I don't think this is an option as dma_sync_*() is part of the streaming
> > DMA mapping API (dma_map_*) which participates in the idea of buffer
> > ownership, which the noncoherent API doesn't appear to.
> 
> I thought the problem was in fact that the noncoherent API cannot be
> implemented on architectures like ARM specifically because there is
> no concept of buffer ownership. The obvious way to fix that would
> be to redefine the API. What am I missing?

You are partially correct.  With the streaming interface, we're fairly
strict with the buffer ownership stuff, as the most effective way to
implement it across all our CPUs is to deal with the mapping, sync and
unmapping in terms of buffers being passed from CPU control to DMA device
control and back again.

With the noncoherent interface, there is less of a buffer ownership idea.
For instance, to read from a noncoherent buffer, the following is required
(in order, I'm not considering the effects of weakly ordered stuff):

	/* dma happens, signalled complete */
	dma_cache_invalidate(buffer, size);
	/* cpu can now see up to date data */
	message = *buffer;

Unlike the streaming API, we don't need to hand the buffer back to the
device before the CPU can repeat the above code sequence.

If we want to write to a noncoherent buffer, then we need:

	*buffer = value;
	dma_cache_writeback(buffer, size);
	/* dma can only now see new value */

and again, the same thing applies.

There is an additional problem lurking in amongst this though - a buffer
which is both read and written by the CPU has to be extremely careful of
cache writebacks - this for instance would not be legal:

	*buffer = value;
	...
	/* dma from device */
	dma_cache_invalidate(buffer, size);
	message = *buffer;

as it is not predictable whether we'll see 'value' or the DMA data - that
depends on the relative ordering of the DMA writing to RAM vs the cache
eviction of the CPU write.

So, there is a kind of buffer ownership here:

	/* cpu owns */
	dma_cache_writeback(buffer, size);
	/* dma owns */
	dma_cache_invalidate(buffer, size);
	/* cpu owns */

but as shown above it doesn't need to be as strict as the streaming API.

Also note that there's a problem lurking here with DMA cache line size:

| int
| dma_get_cache_alignment(void)
| 
| Returns the processor cache alignment.  This is the absolute minimum
| alignment *and* width that you must observe when either mapping
| memory or doing partial flushes.
| 
| Notes: This API may return a number *larger* than the actual cache
| line, but it will guarantee that one or more cache lines fit exactly
| into the width returned by this call.  It will also always be a power
| of two for easy alignment.

$ grep -L dma_get_cache_alignment $(grep dma_alloc_noncoherent drivers/ -lr)
drivers/base/dma-mapping.c
drivers/scsi/sgiwd93.c
drivers/scsi/53c700.c
drivers/net/au1000_eth.c
drivers/net/sgiseeq.c
drivers/net/lasi_82596.c
drivers/video/au1200fb.c

so we have a bunch of drivers which presumably don't take any notice of
the DMA cache line size, which may be very important.  53c700 for instance
aligns its buffers using L1_CACHE_ALIGN(), which may be smaller than
what's actually required...
