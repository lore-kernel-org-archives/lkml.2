Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab1D1Kvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:51:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53979 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1D1Kvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:51:46 -0400
Date: Thu, 28 Apr 2011 11:51:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110428105131.GD17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de> <20110427073514.GH17290@n2100.arm.linux.org.uk> <1303940271.2513.187.camel@pasglop> <20110428093741.GV17290@n2100.arm.linux.org.uk> <003e01cc058f$94beb490$be3c1db0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003e01cc058f$94beb490$be3c1db0$%szyprowski@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 12:32:32PM +0200, Marek Szyprowski wrote:
> On Thursday, April 28, 2011 11:38 AM Russell King - ARM Linux wrote:
> > > > > 2. Implement dma_alloc_noncoherent on ARM. Marek pointed out
> > > > >    that this is needed, and it currently is not implemented, with
> > > > >    an outdated comment explaining why it used to not be possible
> > > > >    to do it.
> > > >
> > > > dma_alloc_noncoherent is an entirely pointless API afaics.
> > >
> > > I was about to ask what the point is ... (what is the expected
> > > semantic ? Memory that is reachable but not necessarily cache
> > > coherent ?)
> > 
> > As far as I can see, dma_alloc_noncoherent() should just be a wrapper
> > around the normal page allocation function.  I don't see it ever needing
> > to do anything special - and the advantage of just being the normal
> > page allocation function is that its properties are well known and
> > architecture independent.
> 
> If there is IOMMU chip that supports pages larger than 4KiB then
> dma_alloc_noncoherent() might try to allocate such larger pages what will
> result in faster access to the buffer (lower iommu tlb miss ratio).
> For large buffers even 64KiB 'pages' gives a significant performance
> improvement.

The memory allocated by dma_alloc_noncoherent() (and dma_alloc_coherent())
has to be virtually contiguous, and DMA contiguous.  It is assumed by all
drivers that:

	virt = dma_alloc_foo(size, &dma);

	cpuaddr = virt + offset;
	dmaaddr = dma + offset;

results in the CPU and DMA seeing ultimately the same address for cpuaddr
and dmaaddr for 0 <= offset < size.

The standard alloc_pages() also ensures that if you ask for an order-N
page, you'll end up with that allocation being contiguous - so there's
no difference there.

What I'd suggest is that dma_alloc_noncoherent() should be architecture
independent, and should call into whatever iommu support the device has
to setup an approprite iommu mapping.  IOW, I don't see any need for
every architecture to provide its own dma_alloc_noncoherent() allocation
function - or indeed every iommu implementation to deal with the
allocation issues either.
