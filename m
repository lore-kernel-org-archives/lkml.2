Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1A0VWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 16:22:52 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:28232 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab1A0VWv (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 27 Jan 2011 16:22:51 -0500
Date: Thu, 27 Jan 2011 16:20:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: dri-devel@lists.freedesktop.org, thomas@shipmail.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Jerome Glisse <jglisse@redhat.com>
Cc: konrad@darnok.org
Subject: Re: [PATCH 4/5] radeon/ttm/PCIe: Use dma_addr if TTM has set it.
Message-ID: <20110127212001.GC4542@dumpdata.com>
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
 <1294420304-24811-5-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294420304-24811-5-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 12:11:43PM -0500, Konrad Rzeszutek Wilk wrote:
> If the TTM layer has used the DMA API to setup pages that are
> TTM_PAGE_FLAG_DMA32 (look at patch titled: "ttm: Utilize the dma_addr_t
> array for pages that are to in DMA32 pool."), lets use it
> when programming the GART in the PCIe type cards.
> 
> This patch skips doing the pci_map_page (and pci_unmap_page) if
> there is a DMA addresses passed in for that page. If the dma_address
> is zero (or DMA_ERROR_CODE), then we continue on with our old
> behaviour.

Hey Jerome,

I should have CC-ed you earlier but missed that and instead just
CC-ed the mailing list. I was wondering what your thoughts are
about this patchset? Thomas took a look at the patchset and he is OK
but more eyes never hurt.

FYI, for clarity I hadn't made the old calls that got moved due
to adding of "{" checkpatch.pl compliant. It complains about it being
past 80 characters. I can naturally fix that up, but thought
that it might detract from the nature of the patch.


> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/gpu/drm/radeon/radeon.h      |    4 ++-
>  drivers/gpu/drm/radeon/radeon_gart.c |   36 ++++++++++++++++++++++++---------
>  drivers/gpu/drm/radeon/radeon_ttm.c  |    5 +++-
>  3 files changed, 33 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
> index 73f600d..c9bbab9 100644
> --- a/drivers/gpu/drm/radeon/radeon.h
> +++ b/drivers/gpu/drm/radeon/radeon.h
> @@ -317,6 +317,7 @@ struct radeon_gart {
>  	union radeon_gart_table		table;
>  	struct page			**pages;
>  	dma_addr_t			*pages_addr;
> +	bool				*ttm_alloced;
>  	bool				ready;
>  };
>  
> @@ -329,7 +330,8 @@ void radeon_gart_fini(struct radeon_device *rdev);
>  void radeon_gart_unbind(struct radeon_device *rdev, unsigned offset,
>  			int pages);
>  int radeon_gart_bind(struct radeon_device *rdev, unsigned offset,
> -		     int pages, struct page **pagelist);
> +		     int pages, struct page **pagelist,
> +		     dma_addr_t *dma_addr);
>  
>  
>  /*
> diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
> index e65b903..4a5ac4b 100644
> --- a/drivers/gpu/drm/radeon/radeon_gart.c
> +++ b/drivers/gpu/drm/radeon/radeon_gart.c
> @@ -149,8 +149,9 @@ void radeon_gart_unbind(struct radeon_device *rdev, unsigned offset,
>  	p = t / (PAGE_SIZE / RADEON_GPU_PAGE_SIZE);
>  	for (i = 0; i < pages; i++, p++) {
>  		if (rdev->gart.pages[p]) {
> -			pci_unmap_page(rdev->pdev, rdev->gart.pages_addr[p],
> -				       PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
> +			if (!rdev->gart.ttm_alloced[p])
> +				pci_unmap_page(rdev->pdev, rdev->gart.pages_addr[p],
> +				       		PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
>  			rdev->gart.pages[p] = NULL;
>  			rdev->gart.pages_addr[p] = rdev->dummy_page.addr;
>  			page_base = rdev->gart.pages_addr[p];
> @@ -165,7 +166,7 @@ void radeon_gart_unbind(struct radeon_device *rdev, unsigned offset,
>  }
>  
>  int radeon_gart_bind(struct radeon_device *rdev, unsigned offset,
> -		     int pages, struct page **pagelist)
> +		     int pages, struct page **pagelist, dma_addr_t *dma_addr)
>  {
>  	unsigned t;
>  	unsigned p;
> @@ -180,15 +181,22 @@ int radeon_gart_bind(struct radeon_device *rdev, unsigned offset,
>  	p = t / (PAGE_SIZE / RADEON_GPU_PAGE_SIZE);
>  
>  	for (i = 0; i < pages; i++, p++) {
> -		/* we need to support large memory configurations */
> -		/* assume that unbind have already been call on the range */
> -		rdev->gart.pages_addr[p] = pci_map_page(rdev->pdev, pagelist[i],
> +		/* On TTM path, we only use the DMA API if TTM_PAGE_FLAG_DMA32
> +		 * is requested. */
> +		if (dma_addr[i] != DMA_ERROR_CODE) {
> +			rdev->gart.ttm_alloced[p] = true;
> +			rdev->gart.pages_addr[p] = dma_addr[i];
> +		} else {
> +			/* we need to support large memory configurations */
> +			/* assume that unbind have already been call on the range */
> +			rdev->gart.pages_addr[p] = pci_map_page(rdev->pdev, pagelist[i],
>  							0, PAGE_SIZE,
>  							PCI_DMA_BIDIRECTIONAL);
> -		if (pci_dma_mapping_error(rdev->pdev, rdev->gart.pages_addr[p])) {
> -			/* FIXME: failed to map page (return -ENOMEM?) */
> -			radeon_gart_unbind(rdev, offset, pages);
> -			return -ENOMEM;
> +			if (pci_dma_mapping_error(rdev->pdev, rdev->gart.pages_addr[p])) {
> +				/* FIXME: failed to map page (return -ENOMEM?) */
> +				radeon_gart_unbind(rdev, offset, pages);
> +				return -ENOMEM;
> +			}
>  		}
>  		rdev->gart.pages[p] = pagelist[i];
>  		page_base = rdev->gart.pages_addr[p];
> @@ -251,6 +259,12 @@ int radeon_gart_init(struct radeon_device *rdev)
>  		radeon_gart_fini(rdev);
>  		return -ENOMEM;
>  	}
> +	rdev->gart.ttm_alloced = kzalloc(sizeof(bool) *
> +					rdev->gart.num_cpu_pages, GFP_KERNEL);
> +	if (rdev->gart.ttm_alloced == NULL) {
> +		radeon_gart_fini(rdev);
> +		return -ENOMEM;
> +	}
>  	/* set GART entry to point to the dummy page by default */
>  	for (i = 0; i < rdev->gart.num_cpu_pages; i++) {
>  		rdev->gart.pages_addr[i] = rdev->dummy_page.addr;
> @@ -267,6 +281,8 @@ void radeon_gart_fini(struct radeon_device *rdev)
>  	rdev->gart.ready = false;
>  	kfree(rdev->gart.pages);
>  	kfree(rdev->gart.pages_addr);
> +	kfree(rdev->gart.ttm_alloced);
>  	rdev->gart.pages = NULL;
>  	rdev->gart.pages_addr = NULL;
> +	rdev->gart.ttm_alloced = NULL;
>  }
> diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
> index 6f156e9..ca04505 100644
> --- a/drivers/gpu/drm/radeon/radeon_ttm.c
> +++ b/drivers/gpu/drm/radeon/radeon_ttm.c
> @@ -647,6 +647,7 @@ struct radeon_ttm_backend {
>  	unsigned long			num_pages;
>  	struct page			**pages;
>  	struct page			*dummy_read_page;
> +	dma_addr_t			*dma_addrs;
>  	bool				populated;
>  	bool				bound;
>  	unsigned			offset;
> @@ -662,6 +663,7 @@ static int radeon_ttm_backend_populate(struct ttm_backend *backend,
>  
>  	gtt = container_of(backend, struct radeon_ttm_backend, backend);
>  	gtt->pages = pages;
> +	gtt->dma_addrs = dma_addrs;
>  	gtt->num_pages = num_pages;
>  	gtt->dummy_read_page = dummy_read_page;
>  	gtt->populated = true;
> @@ -674,6 +676,7 @@ static void radeon_ttm_backend_clear(struct ttm_backend *backend)
>  
>  	gtt = container_of(backend, struct radeon_ttm_backend, backend);
>  	gtt->pages = NULL;
> +	gtt->dma_addrs = NULL;
>  	gtt->num_pages = 0;
>  	gtt->dummy_read_page = NULL;
>  	gtt->populated = false;
> @@ -694,7 +697,7 @@ static int radeon_ttm_backend_bind(struct ttm_backend *backend,
>  		     gtt->num_pages, bo_mem, backend);
>  	}
>  	r = radeon_gart_bind(gtt->rdev, gtt->offset,
> -			     gtt->num_pages, gtt->pages);
> +			     gtt->num_pages, gtt->pages, gtt->dma_addrs);
>  	if (r) {
>  		DRM_ERROR("failed to bind %lu pages at 0x%08X\n",
>  			  gtt->num_pages, gtt->offset);
> -- 
> 1.7.1
