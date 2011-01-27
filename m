Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1A0VYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 16:24:51 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:30478 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab1A0VYu (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 27 Jan 2011 16:24:50 -0500
Date: Thu, 27 Jan 2011 16:22:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: dri-devel@lists.freedesktop.org, thomas@shipmail.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>
Cc: konrad@darnok.org
Subject: Re: [PATCH 5/5] nouveau/ttm/PCIe: Use dma_addr if TTM has set it.
Message-ID: <20110127212212.GD4542@dumpdata.com>
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
 <1294420304-24811-6-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294420304-24811-6-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 12:11:44PM -0500, Konrad Rzeszutek Wilk wrote:
> If the TTM layer has used the DMA API to setup pages that are
> TTM_PAGE_FLAG_DMA32 (look at patch titled: "ttm: Utilize the dma_addr_t
> array for pages that are to in DMA32 pool."), lets use it
> when programming the GART in the PCIe type cards.
> 
> This patch skips doing the pci_map_page (and pci_unmap_page) if
> there is a DMA addresses passed in for that page. If the dma_address
> is zero (or DMA_ERROR_CODE), then we continue on with our old
> behaviour.

Hey Ben and Jerome,

I should have CC-ed you guys earlier but missed that and instead just
CC-ed the mailing list. I was wondering what your thoughts are
about this patchset? Thomas took a look at the patchset and he is OK
but more eyes never hurt.


> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_sgdma.c |   28 +++++++++++++++++++++-------
>  1 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> index edc140a..bbdd982 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> @@ -12,6 +12,7 @@ struct nouveau_sgdma_be {
>  	struct drm_device *dev;
>  
>  	dma_addr_t *pages;
> +	bool *ttm_alloced;
>  	unsigned nr_pages;
>  
>  	unsigned pte_start;
> @@ -35,15 +36,25 @@ nouveau_sgdma_populate(struct ttm_backend *be, unsigned long num_pages,
>  	if (!nvbe->pages)
>  		return -ENOMEM;
>  
> +	nvbe->ttm_alloced = kmalloc(sizeof(bool) * num_pages, GFP_KERNEL);
> +	if (!nvbe->ttm_alloced)
> +		return -ENOMEM;
> +
>  	nvbe->nr_pages = 0;
>  	while (num_pages--) {
> -		nvbe->pages[nvbe->nr_pages] =
> -			pci_map_page(dev->pdev, pages[nvbe->nr_pages], 0,
> +		if (dma_addrs[nvbe->nr_pages] != DMA_ERROR_CODE) {
> +			nvbe->pages[nvbe->nr_pages] =
> +					dma_addrs[nvbe->nr_pages];
> +		 	nvbe->ttm_alloced[nvbe->nr_pages] = true;
> +		} else {
> +			nvbe->pages[nvbe->nr_pages] =
> +				pci_map_page(dev->pdev, pages[nvbe->nr_pages], 0,
>  				     PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
> -		if (pci_dma_mapping_error(dev->pdev,
> -					  nvbe->pages[nvbe->nr_pages])) {
> -			be->func->clear(be);
> -			return -EFAULT;
> +			if (pci_dma_mapping_error(dev->pdev,
> +						  nvbe->pages[nvbe->nr_pages])) {
> +				be->func->clear(be);
> +				return -EFAULT;
> +			}
>  		}
>  
>  		nvbe->nr_pages++;
> @@ -66,11 +77,14 @@ nouveau_sgdma_clear(struct ttm_backend *be)
>  			be->func->unbind(be);
>  
>  		while (nvbe->nr_pages--) {
> -			pci_unmap_page(dev->pdev, nvbe->pages[nvbe->nr_pages],
> +			if (!nvbe->ttm_alloced[nvbe->nr_pages])
> +				pci_unmap_page(dev->pdev, nvbe->pages[nvbe->nr_pages],
>  				       PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
>  		}
>  		kfree(nvbe->pages);
> +		kfree(nvbe->ttm_alloced);
>  		nvbe->pages = NULL;
> +		nvbe->ttm_alloced = NULL;
>  		nvbe->nr_pages = 0;
>  	}
>  }
> -- 
> 1.7.1
