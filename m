Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1LUPb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:31:28 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:47755 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab1LUPb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:31:26 -0500
Date: Wed, 21 Dec 2011 10:30:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, thellstrom@vmware.com
Subject: Re: [PATCH 2/3] drm/ttm/dma: Fix accounting error when calling
 ttm_mem_global_free_page.
Message-ID: <20111221153018.GA26757@phenom.dumpdata.com>
References: <1323720569-15435-1-git-send-email-konrad.wilk@oracle.com>
 <1323720569-15435-3-git-send-email-konrad.wilk@oracle.com>
 <CAH3drwZGNBOr0+b8S_7ZAnhG=7RXFdjAc1D+ySxzGMy1LBJOqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAH3drwZGNBOr0+b8S_7ZAnhG=7RXFdjAc1D+ySxzGMy1LBJOqA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4EF1FBCA.00C0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 10:17:36AM -0500, Jerome Glisse wrote:
> On Mon, Dec 12, 2011 at 3:09 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > The code to figure out how many pages to shrink the pool
> > ends up capping the 'count' at _manager->options.max_size - which is OK.
> > Except that the 'count' is also used when accounting for how many pages
> > are recycled - which we end up with the invalid values. This fixes
> > it by using a different value for the amount of pages to shrink.
> >
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |   10 ++++++----
> >  1 files changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> > index 6c06d0b..e57aa24 100644
> > --- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> > +++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> > @@ -949,7 +949,7 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
> >        struct dma_page *d_page, *next;
> >        enum pool_type type;
> >        bool is_cached = false;
> > -       unsigned count = 0, i;
> > +       unsigned count = 0, i, npages;
> >        unsigned long irq_flags;
> >
> >        type = ttm_to_type(ttm->page_flags, ttm->caching_state);
> > @@ -971,11 +971,13 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
> >        pool->npages_in_use -= count;
> >        if (is_cached) {
> >                pool->nfrees += count;
> > +               npages = count;
> 
> This is wrong, i thought we didn't wanted to shrink cached page, your
> 3/3 patch remove this line. Thought i am kind of wondering why we
> don't shrink the cached pool, i can't remember the reason.

We delete the cached ones:

 988         if (is_cached) {
 989                 list_for_each_entry_safe(d_page, next, &ttm_dma->pages_list, page_list) {
 990                         ttm_mem_global_free_page(ttm->glob->mem_glob,
 991                                                  d_page->p);
 992                         ttm_dma_page_put(pool, d_page);
 993                 }

And then we end up calling in ttm_dma_page_pool_free for (count) pages
that we had already deleted. So it ends up being a bit redundant.

The 3/3 patch fixes that (by removing the call to ttm_dma_page_pool_free
for is_cached. This patch (2/3) tries to preserve the logic if it is either
is_cached or !is_cached.

> 
> >        } else {
> >                pool->npages_free += count;
> >                list_splice(&ttm_dma->pages_list, &pool->free_list);
> > +               npages = count;
> >                if (pool->npages_free > _manager->options.max_size) {
> > -                       count = pool->npages_free - _manager->options.max_size;
> > +                       npages = pool->npages_free - _manager->options.max_size;
> >                }
> >        }
> >        spin_unlock_irqrestore(&pool->lock, irq_flags);
> > @@ -1000,8 +1002,8 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
> >        }
> >
> >        /* shrink pool if necessary */
> > -       if (count)
> > -               ttm_dma_page_pool_free(pool, count);
> > +       if (npages)
> > +               ttm_dma_page_pool_free(pool, npages);
> >        ttm->state = tt_unpopulated;
> >  }
> >  EXPORT_SYMBOL_GPL(ttm_dma_unpopulate);
> > --
> > 1.7.7.3
> >
> 
> Otherwise Reviewed-by:Jerome Glisse <jglisse@redhat.com>

Thanks!
