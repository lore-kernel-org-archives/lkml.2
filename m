Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1LUPW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:22:58 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44897 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1LUPW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:22:57 -0500
MIME-Version: 1.0
In-Reply-To: <1323720569-15435-4-git-send-email-konrad.wilk@oracle.com>
References: <1323720569-15435-1-git-send-email-konrad.wilk@oracle.com>
	<1323720569-15435-4-git-send-email-konrad.wilk@oracle.com>
Date: Wed, 21 Dec 2011 10:22:56 -0500
Message-ID: <CAH3drwaNFCwwfObkWAYP93gZ5Mb7B9D5bP7o3uBNsYS4W1otyQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] drm/ttm/dma: Optimize when free-ing the recycled page pool.
From: Jerome Glisse <j.glisse@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, thellstrom@vmware.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 3:09 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> We would free the page pool - even if it was for cached pages
> (which are deleted from the pool - so there are no free pages).
>
> Also we also missed the opportunity to batch the amount of pages
> to free (similar to how ttm_page_alloc.c does it). This reintroduces
> the code that was lost during rebasing.
>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> index e57aa24..156ddcd 100644
> --- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> +++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> @@ -949,7 +949,7 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
>        struct dma_page *d_page, *next;
>        enum pool_type type;
>        bool is_cached = false;
> -       unsigned count = 0, i, npages;
> +       unsigned count = 0, i, npages = 0;
>        unsigned long irq_flags;
>
>        type = ttm_to_type(ttm->page_flags, ttm->caching_state);
> @@ -971,13 +971,16 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
>        pool->npages_in_use -= count;
>        if (is_cached) {
>                pool->nfrees += count;
> -               npages = count;

See patch 2/3 comment otherwise Reviewed-by: Jerome Glisse <jglisse@redhat.com>

>        } else {
>                pool->npages_free += count;
>                list_splice(&ttm_dma->pages_list, &pool->free_list);
>                npages = count;
>                if (pool->npages_free > _manager->options.max_size) {
>                        npages = pool->npages_free - _manager->options.max_size;
> +                       /* free at least NUM_PAGES_TO_ALLOC number of pages
> +                        * to reduce calls to set_memory_wb */
> +                       if (npages < NUM_PAGES_TO_ALLOC)
> +                               npages = NUM_PAGES_TO_ALLOC;
>                }
>        }
>        spin_unlock_irqrestore(&pool->lock, irq_flags);
> @@ -1001,7 +1004,7 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
>                ttm_dma->dma_address[i] = 0;
>        }
>
> -       /* shrink pool if necessary */
> +       /* shrink pool if necessary (only on !is_cached pools)*/
>        if (npages)
>                ttm_dma_page_pool_free(pool, npages);
>        ttm->state = tt_unpopulated;
> --
> 1.7.7.3
>
