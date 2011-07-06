Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab1GFPta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:49:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43338 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab1GFPt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:49:28 -0400
Date: Wed, 6 Jul 2011 16:48:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>, "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8] drivers: add Contiguous Memory Allocator
Message-ID: <20110706154857.GG8286@n2100.arm.linux.org.uk>
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <201107061609.29996.arnd@arndb.de> <20110706142345.GC8286@n2100.arm.linux.org.uk> <201107061651.49824.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107061651.49824.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 04:51:49PM +0200, Arnd Bergmann wrote:
> On Wednesday 06 July 2011, Russell King - ARM Linux wrote:
> > On Wed, Jul 06, 2011 at 04:09:29PM +0200, Arnd Bergmann wrote:
> > > Maybe you can simply adapt the default location of the contiguous memory
> > > are like this:
> > > - make CONFIG_CMA depend on CONFIG_HIGHMEM on ARM, at compile time
> > > - if ZONE_HIGHMEM exist during boot, put the CMA area in there
> > > - otherwise, put the CMA area at the top end of lowmem, and change
> > >   the zone sizes so ZONE_HIGHMEM stretches over all of the CMA memory.
> > 
> > One of the requirements of the allocator is that the returned memory
> > should be zero'd (because it can be exposed to userspace via ALSA
> > and frame buffers.)
> > 
> > Zeroing the memory from all the contexts which dma_alloc_coherent
> > is called from is a trivial matter if its in lowmem, but highmem is
> > harder.
> 
> I don't see how. The pages get allocated from an unmapped area
> or memory, mapped into the kernel address space as uncached or wc
> and then cleared. This should be the same for lowmem or highmem
> pages.

You don't want to clear them via their uncached or WC mapping, but via
their cached mapping _before_ they get their alternative mapping, and
flush any cached out of that mapping - both L1 and L2 caches.

For lowmem pages, that's easy.  For highmem pages, they need to be
individually kmap'd to zero them etc.  (alloc_pages() warns on
GFP_HIGHMEM + GFP_ZERO from atomic contexts - and dma_alloc_coherent
must be callable from such contexts.)

That may be easier now that we don't have the explicit indicies for
kmap_atomics, but at that time it wasn't easily possible.

> > Another issue is that when a platform has restricted DMA regions,
> > they typically don't fall into the highmem zone.  As the dmabounce
> > code allocates from the DMA coherent allocator to provide it with
> > guaranteed DMA-able memory, that would be rather inconvenient.
> 
> True. The dmabounce code would consequently have to allocate
> the memory through an internal function that avoids the
> contiguous allocation area and goes straight to ZONE_DMA memory
> as it does today.

CMA's whole purpose for existing is to provide _dma-able_ contiguous
memory for things like cameras and such like found on crippled non-
scatter-gather hardware.  If that memory is not DMA-able what's the
point?
