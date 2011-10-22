Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1JVKAL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 06:00:11 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:18880 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753584Ab1JVKAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 06:00:09 -0400
X-Greylist: delayed 1006 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Oct 2011 06:00:08 EDT
Message-ID: <4EA28FA6.7000006@shipmail.org>
Date: Sat, 22 Oct 2011 11:40:54 +0200
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        thellstrom@vmware.com, airlied@redhat.com,
        xen-devel@lists.xensource.com, j.glisse@redhat.com, bskeggs@redhat.com
Subject: Re: [PATCH 06/11] ttm/driver: Expand ttm_backend_func to include
 two overrides for TTM page pool.
References: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com> <1319062772-2793-7-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1319062772-2793-7-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad,

I was hoping that we could get rid of the dma_address shuffling into 
core TTM,
like I mentioned in the review. From what I can tell it's now only used 
in the backend and
core ttm doesn't care about it.

Is there a particular reason we're still passing it around?

Thanks,
/Thomas




On 10/20/2011 12:19 AM, Konrad Rzeszutek Wilk wrote:
> The two overrides will be choosen by the backends whether they
> want to use a different TTM page pool than the default.
>
> If the backend does not choose a new override, the default one
> will be used.
>
> Signed-off-by: Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>
> ---
>   drivers/gpu/drm/ttm/ttm_page_alloc.c |   10 +++++++---
>   include/drm/ttm/ttm_bo_driver.h      |   31 +++++++++++++++++++++++++++++++
>   2 files changed, 38 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> index 24c0340..360afb3 100644
> --- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
> +++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> @@ -861,13 +861,17 @@ EXPORT_SYMBOL(ttm_page_alloc_debugfs);
>   int ttm_get_pages(struct ttm_tt *ttm, struct list_head *pages,
>   		  unsigned count, dma_addr_t *dma_address)
>   {
> +	if (ttm->be&&  ttm->be->func&&  ttm->be->func->get_pages)
> +		return ttm->be->func->get_pages(ttm, pages, count, dma_address);
>   	return __ttm_get_pages(pages, ttm->page_flags, ttm->caching_state,
>   				count, dma_address);
>   }
> -{
>   void ttm_put_pages(struct ttm_tt *ttm, struct list_head *pages,
>   		   unsigned page_count, dma_addr_t *dma_address)
>   {
> -	__ttm_put_pages(pages, page_count, ttm->page_flags, ttm->caching_state,
> -			dma_address);
> +	if (ttm->be&&  ttm->be->func&&  ttm->be->func->put_pages)
> +		ttm->be->func->put_pages(ttm, pages, page_count, dma_address);
> +	else
> +		__ttm_put_pages(pages, page_count, ttm->page_flags,
> +				ttm->caching_state, dma_address);
>   }
> diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
> index 09af2d7..1826c3b 100644
> --- a/include/drm/ttm/ttm_bo_driver.h
> +++ b/include/drm/ttm/ttm_bo_driver.h
> @@ -100,6 +100,34 @@ struct ttm_backend_func {
>   	 * Destroy the backend.
>   	 */
>   	void (*destroy) (struct ttm_backend *backend);
> +
> +	/**
> +	 * ttm_get_pages override. The backend can override the default
> +	 * TTM page pool code with a different one.
> +	 *
> +	 * Get count number of pages from pool to pages list.
> +	 *
> +	 * @ttm: ttm which contains flags for page allocation and caching state.
> +	 * @pages: head of empty linked list where pages are filled.
> +	 * @dma_address: The DMA (bus) address of pages
> +	 */
> +	int (*get_pages) (struct ttm_tt *ttm, struct list_head *pages,
> +			  unsigned count, dma_addr_t *dma_address);
> +
> +	/**
> +	 * ttm_put_pages override. The backend can override the default
> +	 * TTM page pool code with a different implementation.
> +	 *
> +	 * Put linked list of pages to pool.
> +	 *
> +	 * @ttm: ttm which contains flags for page allocation and caching state.
> +	 * @pages: list of pages to free.
> +	 * @page_count: number of pages in the list. Zero can be passed for
> +	 * unknown count.
> +	 * @dma_address: The DMA (bus) address of pages
> +	 */
> +	void (*put_pages) (struct ttm_tt *ttm, struct list_head *pages,
> +			   unsigned page_count, dma_addr_t *dma_address);
>   };
>
>   /**
> @@ -109,6 +137,8 @@ struct ttm_backend_func {
>    * @flags: For driver use.
>    * @func: Pointer to a struct ttm_backend_func that describes
>    * the backend methods.
> + * @dev: Pointer to a struct device which can be used by the TTM
> + *  [get|put)_pages overrides in 'struct ttm_backend_func'.
>    *
>    */
>
> @@ -116,6 +146,7 @@ struct ttm_backend {
>   	struct ttm_bo_device *bdev;
>   	uint32_t flags;
>   	struct ttm_backend_func *func;
> +	struct device *dev;
>   };
>
>   #define TTM_PAGE_FLAG_USER            (1<<  1)
>    



