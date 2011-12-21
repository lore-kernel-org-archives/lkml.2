Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1LUPRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:17:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52398 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab1LUPRg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:17:36 -0500
MIME-Version: 1.0
In-Reply-To: <1323720569-15435-3-git-send-email-konrad.wilk@oracle.com>
References: <1323720569-15435-1-git-send-email-konrad.wilk@oracle.com>
	<1323720569-15435-3-git-send-email-konrad.wilk@oracle.com>
Date: Wed, 21 Dec 2011 10:17:36 -0500
Message-ID: <CAH3drwZGNBOr0+b8S_7ZAnhG=7RXFdjAc1D+ySxzGMy1LBJOqA@mail.gmail.com>
Subject: Re: [PATCH 2/3] drm/ttm/dma: Fix accounting error when calling ttm_mem_global_free_page.
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
> The code to figure out how many pages to shrink the pool
> ends up capping the 'count' at _manager->options.max_size - which is OK.
> Except that the 'count' is also used when accounting for how many pages
> are recycled - which we end up with the invalid values. This fixes
> it by using a different value for the amount of pages to shrink.
>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> index 6c06d0b..e57aa24 100644
> --- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> +++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> @@ -949,7 +949,7 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
>        struct dma_page *d_page, *next;
>        enum pool_type type;
>        bool is_cached = false;
> -       unsigned count = 0, i;
> +       unsigned count = 0, i, npages;
>        unsigned long irq_flags;
>
>        type = ttm_to_type(ttm->page_flags, ttm->caching_state);
> @@ -971,11 +971,13 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
>        pool->npages_in_use -= count;
>        if (is_cached) {
>                pool->nfrees += count;
> +               npages = count;

This is wrong, i thought we didn't wanted to shrink cached page, your
3/3 patch remove this line. Thought i am kind of wondering why we
don't shrink the cached pool, i can't remember the reason.

>        } else {
>                pool->npages_free += count;
>                list_splice(&ttm_dma->pages_list, &pool->free_list);
> +               npages = count;
>                if (pool->npages_free > _manager->options.max_size) {
> -                       count = pool->npages_free - _manager->options.max_size;
> +                       npages = pool->npages_free - _manager->options.max_size;
>                }
>        }
>        spin_unlock_irqrestore(&pool->lock, irq_flags);
> @@ -1000,8 +1002,8 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
>        }
>
>        /* shrink pool if necessary */
> -       if (count)
> -               ttm_dma_page_pool_free(pool, count);
> +       if (npages)
> +               ttm_dma_page_pool_free(pool, npages);
>        ttm->state = tt_unpopulated;
>  }
>  EXPORT_SYMBOL_GPL(ttm_dma_unpopulate);
> --
> 1.7.7.3
>

Otherwise Reviewed-by:Jerome Glisse <jglisse@redhat.com>
