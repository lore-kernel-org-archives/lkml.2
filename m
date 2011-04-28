Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579Ab1D1OaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:30:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63960 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760512Ab1D1OaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:30:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Date: Thu, 28 Apr 2011 16:29:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201104212129.17013.arnd@arndb.de> <201104281428.56780.arnd@arndb.de> <20110428131531.GK17290@n2100.arm.linux.org.uk>
In-Reply-To: <20110428131531.GK17290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104281629.52863.arnd@arndb.de>
X-Provags-ID: V02:K0:XJ18rcplWcZsWWtQ/Oi7RIy7x6WP2E6m4D81DF9b+QY
 kY75/2z2/QhE9ezAu99Hv7W11Zvo7ggObnUcNHPx0CbEquXX5e
 zTBWgDfGc6ynL1dVX5+h/3msnJqIrLclsbM/QVntQBSFrcBRTi
 v+DWY9OyfDFQ6hQiO1JIsvT0NO12bRz42meXs8Q4a3PkpHoNzg
 sxrQwiVX/PlrpM0ov4SLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 April 2011, Russell King - ARM Linux wrote:
> On Thu, Apr 28, 2011 at 02:28:56PM +0200, Arnd Bergmann wrote:
> > On Thursday 28 April 2011, Russell King - ARM Linux wrote:
> > > What I'd suggest is that dma_alloc_noncoherent() should be architecture
> > > independent, and should call into whatever iommu support the device has
> > > to setup an approprite iommu mapping.  IOW, I don't see any need for
> > > every architecture to provide its own dma_alloc_noncoherent() allocation
> > > function - or indeed every iommu implementation to deal with the
> > > allocation issues either.
> > 
> > Almost all architectures today define dma_alloc_noncoherent to
> > dma_alloc_coherent, which is totally fine on architectures
> > where cacheable coherent mappings are the default or where
> > we don't need to flush individual cache lines for dma_sync_*.
> 
> However, dma_alloc_coherent() memory can't be used with the dma_sync_*
> API as its return address (unlike other architectures) is not in the
> kernel direct mapped memory range.

Right, because ARM does not fit in the two categories I listed
above: the regular DMA is not cache coherent and we need to flush
the cache lines for the data we want to access in dma_sync_*.

> The only thing valid for dma_sync_* are buffers which have been passed
> to the dma_map_* APIs.
> 
> Instead, I think what you're referring to is dma_cache_sync(), which is
> the API to be used with dma_alloc_noncoherent(), which we don't
> implement.
> 
> As we have problems with some SMP implementations, and the noncoherent
> API doesn't have the idea of buffer ownership, it's rather hard to deal
> with the DMA cache implications with the existing API, especially with
> the issues of speculative prefetching.  The current usage (looking at
> drivers/scsi/53c700.c) doesn't cater for speculative prefetch as the
> dma_cache_sync(,,,DMA_FROM_DEVICE) is done well in advance of the DMA
> actually happening.
> 
> So all in all, I think the noncoherent API is broken as currently
> designed - and until we have devices on ARM which use it, I don't see
> much point into trying to fix the current thing especially as we'd be
> unable to test.

I agree that dma_cache_sync() is totally unusable on ARM, I thought we
had killed that off and replaced it with dma_sync_*. Unfortunately,
I was mistaken there: all drivers that use dma_alloc_noncoherent
either use dma_cache_sync() or they do something that is more broken,
but they don't do dma_sync_*.

Given that people still want to have an interface that does what I
though this one did, I guess we have two options:

* Kill off dma_cache_sync and replace it with calls to dma_sync_*
  so we can start using dma_alloc_noncoherent on ARM

* Introduce a new interface

	Arnd
