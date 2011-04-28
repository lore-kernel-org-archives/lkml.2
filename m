Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab1D1NQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:16:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40298 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1D1NQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:16:09 -0400
Date: Thu, 28 Apr 2011 14:15:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110428131531.GK17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de> <003e01cc058f$94beb490$be3c1db0$%szyprowski@samsung.com> <20110428105131.GD17290@n2100.arm.linux.org.uk> <201104281428.56780.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104281428.56780.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 02:28:56PM +0200, Arnd Bergmann wrote:
> On Thursday 28 April 2011, Russell King - ARM Linux wrote:
> > What I'd suggest is that dma_alloc_noncoherent() should be architecture
> > independent, and should call into whatever iommu support the device has
> > to setup an approprite iommu mapping.  IOW, I don't see any need for
> > every architecture to provide its own dma_alloc_noncoherent() allocation
> > function - or indeed every iommu implementation to deal with the
> > allocation issues either.
> 
> Almost all architectures today define dma_alloc_noncoherent to
> dma_alloc_coherent, which is totally fine on architectures
> where cacheable coherent mappings are the default or where
> we don't need to flush individual cache lines for dma_sync_*.

However, dma_alloc_coherent() memory can't be used with the dma_sync_*
API as its return address (unlike other architectures) is not in the
kernel direct mapped memory range.

The only thing valid for dma_sync_* are buffers which have been passed
to the dma_map_* APIs.

Instead, I think what you're referring to is dma_cache_sync(), which is
the API to be used with dma_alloc_noncoherent(), which we don't
implement.

As we have problems with some SMP implementations, and the noncoherent
API doesn't have the idea of buffer ownership, it's rather hard to deal
with the DMA cache implications with the existing API, especially with
the issues of speculative prefetching.  The current usage (looking at
drivers/scsi/53c700.c) doesn't cater for speculative prefetch as the
dma_cache_sync(,,,DMA_FROM_DEVICE) is done well in advance of the DMA
actually happening.

So all in all, I think the noncoherent API is broken as currently
designed - and until we have devices on ARM which use it, I don't see
much point into trying to fix the current thing especially as we'd be
unable to test.
