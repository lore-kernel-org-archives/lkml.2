Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1I3HBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:01:46 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:18919 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397Ab1I3HBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 03:01:45 -0400
Message-ID: <4E8568E8.1070800@vmware.com>
Date: Fri, 30 Sep 2011 08:59:52 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, j.glisse@redhat.com, thomas@shipmail.org,
        airlied@redhat.com, airlied@linux.ie, alexdeucher@gmail.com,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH] TTM DMA pool v1.8
References: <1317328432-25620-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1317328432-25620-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad,

I'm really sorry for taking so long to review this.

I'd like to go through a couple of high-level things first before 
reviewing the coding itself.

The page_alloc_func structure looks nice, but I'd like to have it per 
ttm backend,
we would just need to make sure that the backend is alive when we alloc 
/ free pages.
The reason for this is that there may be backends that want to allocate 
dma memory running simultaneously with those who don't. When the backend 
fires up, it can determine whether to use DMA memory or not.

This also eliminates the need for patch 3/9. and is in line with patch 8/9.

2) Memory accounting: If the number DMA pages are limited in a way that 
the ttm memory global routines are not aware of. How do we handle memory 
accounting? (How do we avoid exhausting IOMMU space)?

3) Page swapping. Currently we just copy pages to shmem pages and then 
free device pages. In the future we'd probably like to insert non-dma 
pages directly into the swap cache. Is it possible to differentiate dma 
pages from pages that are directly insertable?

Thanks
Thomas



On 09/29/2011 10:33 PM, Konrad Rzeszutek Wilk wrote:
> [.. and this is what I said in v1 post]:
>
> Way back in January this patchset:
> http://lists.freedesktop.org/archives/dri-devel/2011-January/006905.html
> was merged in, but pieces of it had to be reverted b/c they did not
> work properly under PowerPC, ARM, and when swapping out pages to disk.
>
> After a bit of discussion on the mailing list
> http://marc.info/?i=4D769726.2030307@shipmail.org I started working on it, but
> got waylaid by other things .. and finally I am able to post the RFC patches.
>
> There was a lot of discussion about it and I am not sure if I captured
> everybody's thoughts - if I did not - that is _not_ intentional - it has just
> been quite some time..
>
> Anyhow .. the patches explore what the "lib/dmapool.c" does - which is to have a
> DMA pool that the device has associated with. I kind of married that code
> along with drivers/gpu/drm/ttm/ttm_page_alloc.c to create a TTM DMA pool code.
> The end result is DMA pool with extra features: can do write-combine, uncached,
> writeback (and tracks them and sets back to WB when freed); tracks "cached"
> pages that don't really need to be returned to a pool; and hooks up to
> the shrinker code so that the pools can be shrunk.
>
> If you guys think this set of patches make sense  - my future plans were
>   1) Get this in large crowd of testing .. and if it works for a kernel release
>   2) to move a bulk of this in the lib/dmapool.c (I spoke with Matthew Wilcox
>      about it and he is OK as long as I don't introduce performance regressions).
>
> But before I do any of that a second set of eyes taking a look at these
> patches would be most welcome.
>
> In regards to testing, I've been running them non-stop for the last month
> (and found some issues which I've fixed up) - and been quite happy with how
> they work.
>
> Michel (thanks!) took a spin of the patches on his PowerPC and they did not
> cause any regressions (wheew).
>
> The patches are also located in a git tree:
>
>   git://oss.oracle.com/git/kwilk/xen.git devel/ttm.dma_pool.v1.8
>
>   drivers/gpu/drm/nouveau/nouveau_mem.c    |    8 +-
>   drivers/gpu/drm/nouveau/nouveau_sgdma.c  |    3 +-
>   drivers/gpu/drm/radeon/radeon_device.c   |    6 +
>   drivers/gpu/drm/radeon/radeon_gart.c     |    4 +-
>   drivers/gpu/drm/radeon/radeon_ttm.c      |    3 +-
>   drivers/gpu/drm/ttm/Makefile             |    3 +
>   drivers/gpu/drm/ttm/ttm_bo.c             |    4 +-
>   drivers/gpu/drm/ttm/ttm_memory.c         |    5 +
>   drivers/gpu/drm/ttm/ttm_page_alloc.c     |   63 ++-
>   drivers/gpu/drm/ttm/ttm_page_alloc_dma.c | 1317 ++++++++++++++++++++++++++++++
>   drivers/gpu/drm/ttm/ttm_tt.c             |    5 +-
>   drivers/gpu/drm/vmwgfx/vmwgfx_drv.c      |    4 +-
>   drivers/xen/swiotlb-xen.c                |    2 +-
>   include/drm/ttm/ttm_bo_driver.h          |    7 +-
>   include/drm/ttm/ttm_page_alloc.h         |  100 +++-
>   include/linux/swiotlb.h                  |    7 +-
>   lib/swiotlb.c                            |    5 +-
>   17 files changed, 1516 insertions(+), 30 deletions(-)
>    

