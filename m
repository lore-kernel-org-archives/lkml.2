Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1HaGdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 02:33:38 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48548 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1HaGdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 02:33:35 -0400
Date: Wed, 31 Aug 2011 09:33:29 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: thellstrom@vmware.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bskeggs@redhat.com,
        j.glisse@redhat.com, thomas@shipmail.org, airlied@redhat.com,
        airlied@linux.ie, alexdeucher@gmail.com
Subject: Re: [PATCH 1/7] ttm/radeon/nouveau: Check the DMA address from TTM
 against known value.
Message-ID: <20110831093329.1d948a92@farn.lan>
In-Reply-To: <1314758512-19285-2-git-send-email-konrad.wilk@oracle.com>
References: <1314758512-19285-1-git-send-email-konrad.wilk@oracle.com>
	<1314758512-19285-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 22:41:46 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> . instead of checking against the DMA_ERROR_CODE value which is
> per-platform specific. The zero value is a known invalid value
> that the TTM layer sets on the dma_address array if it is not
> used (ttm_tt_alloc_page_directory calls drm_calloc_large which
> creates a page with GFP_ZERO).
> 
> We can't use pci_dma_mapping_error as that is IOMMU
> specific (some check for a specific physical address, some
> for ranges, some just do a check against zero).
> 
> Also update the comments in the header about the true state
> of that parameter.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_sgdma.c |    3 +--
>  drivers/gpu/drm/radeon/radeon_gart.c    |    4 +---
>  include/drm/ttm/ttm_page_alloc.h        |    4 ++--
>  3 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> b/drivers/gpu/drm/nouveau/nouveau_sgdma.c index 82fad91..624e2db
> 100644 --- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> @@ -42,8 +42,7 @@ nouveau_sgdma_populate(struct ttm_backend *be,
> unsigned long num_pages, 
>  	nvbe->nr_pages = 0;
>  	while (num_pages--) {
> -		/* this code path isn't called and is incorrect
> anyways */
> -		if (0) { /*dma_addrs[nvbe->nr_pages] !=
> DMA_ERROR_CODE)*/
> +		if (dev->pdev, dma_addrs[nvbe->nr_pages] != 0) {

This is weird, do you mean && instead of a comma, or what?
Or am I completely missing the comma operator semantics?

>  			nvbe->pages[nvbe->nr_pages] =
>  					dma_addrs[nvbe->nr_pages];
>  		 	nvbe->ttm_alloced[nvbe->nr_pages] =
> true; diff --git a/drivers/gpu/drm/radeon/radeon_gart.c
> b/drivers/gpu/drm/radeon/radeon_gart.c index a533f52..41f7e51
> 100644 --- a/drivers/gpu/drm/radeon/radeon_gart.c
> +++ b/drivers/gpu/drm/radeon/radeon_gart.c
> @@ -181,9 +181,7 @@ int radeon_gart_bind(struct radeon_device
> *rdev, unsigned offset, p = t / (PAGE_SIZE /
> RADEON_GPU_PAGE_SIZE); 
>  	for (i = 0; i < pages; i++, p++) {
> -		/* we reverted the patch using dma_addr in TTM
> for now but this
> -		 * code stops building on alpha so just comment
> it out for now */
> -		if (0) { /*dma_addr[i] != DMA_ERROR_CODE) */
> +		if (rdev->pdev, dma_addr[i] != 0) {

The same question for this condition.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
