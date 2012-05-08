Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab2EHKBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:01:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34331 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2EHKBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:01:05 -0400
Date: Tue, 8 May 2012 12:02:13 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        "'???/Mobile S/W Platform Lab.(???)/E3(??)/????'" 
	<inki.dae@samsung.com>,
        paul.gortmaker@windriver.com,
        =?utf-8?B?J+uwleqyveuvvCc=?= <kyungmin.park@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Rob Clark <rob@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        prashanth.g@samsung.com, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v3] scatterlist: add sg_alloc_table_from_pages function
Message-ID: <20120508100213.GB4802@phenom.ffwll.local>
Mail-Followup-To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	amwang@redhat.com, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	"'???/Mobile S/W Platform Lab.(???)/E3(??)/????'" <inki.dae@samsung.com>,
	paul.gortmaker@windriver.com,
	=?utf-8?B?J+uwleqyveuvvCc=?= <kyungmin.park@samsung.com>,
	Dave Airlie <airlied@redhat.com>, Rob Clark <rob@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	prashanth.g@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <4FA8EC69.8010805@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA8EC69.8010805@samsung.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 11:50:33AM +0200, Tomasz Stanislawski wrote:
> This patch adds a new constructor for an sg table. The table is constructed
> from an array of struct pages. All contiguous chunks of the pages are merged
> into a single sg nodes. A user may provide an offset and a size of a buffer if
> the buffer is not page-aligned.
> 
> The function is dedicated for DMABUF exporters which often perform conversion
> from an page array to a scatterlist. Moreover the scatterlist should be
> squashed in order to save memory and to speed-up the process of DMA mapping
> using dma_map_sg.
> 
> The code is based on the patch 'v4l: vb2-dma-contig: add support for
> scatterlist in userptr mode' and hints from Laurent Pinchart.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Looks neat and useful and we could use this to kill the copy in
drm_prime.c. So

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  include/linux/scatterlist.h |    4 +++
>  lib/scatterlist.c           |   64 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 68 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index ac9586d..7b600da 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -214,6 +214,10 @@ void sg_free_table(struct sg_table *);
>  int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int, gfp_t,
>  		     sg_alloc_fn *);
>  int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
> +int sg_alloc_table_from_pages(struct sg_table *sgt,
> +	struct page **pages, unsigned int n_pages,
> +	unsigned long offset, unsigned long size,
> +	gfp_t gfp_mask);
> 
>  size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
>  			   void *buf, size_t buflen);
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index 6096e89..85868a1 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -319,6 +319,70 @@ int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
>  EXPORT_SYMBOL(sg_alloc_table);
> 
>  /**
> + * sg_alloc_table_from_pages - Allocate and initialize an sg table from
> + *			       an array of pages
> + * @sgt:	The sg table header to use
> + * @pages:	Pointer to an array of page pointers
> + * @n_pages:	Number of pages in the pages array
> + * @offset:     Offset from start of the first page to the start of a buffer
> + * @size:       Number of valid bytes in the buffer (after offset)
> + * @gfp_mask:	GFP allocation mask
> + *
> + *  Description:
> + *    Allocate and initialize an sg table from a list of pages. Continuous
> + *    ranges of the pages are squashed into a single scatterlist node. A user
> + *    may provide an offset at a start and a size of valid data in a buffer
> + *    specified by the page array. The returned sg table is released by
> + *    sg_free_table.
> + *
> + * Returns:
> + *   0 on success, negative error on failure
> + **/
> +int sg_alloc_table_from_pages(struct sg_table *sgt,
> +	struct page **pages, unsigned int n_pages,
> +	unsigned long offset, unsigned long size,
> +	gfp_t gfp_mask)
> +{
> +	unsigned int chunks;
> +	unsigned int i;
> +	unsigned int cur_page;
> +	int ret;
> +	struct scatterlist *s;
> +
> +	/* compute number of contiguous chunks */
> +	chunks = 1;
> +	for (i = 1; i < n_pages; ++i)
> +		if (page_to_pfn(pages[i]) != page_to_pfn(pages[i - 1]) + 1)
> +			++chunks;
> +
> +	ret = sg_alloc_table(sgt, chunks, gfp_mask);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	/* merging chunks and putting them into the scatterlist */
> +	cur_page = 0;
> +	for_each_sg(sgt->sgl, s, sgt->orig_nents, i) {
> +		unsigned long chunk_size;
> +		unsigned int j;
> +
> +		/* looking for the end of the current chunk */
> +		for (j = cur_page + 1; j < n_pages; ++j)
> +			if (page_to_pfn(pages[j]) !=
> +			    page_to_pfn(pages[j - 1]) + 1)
> +				break;
> +
> +		chunk_size = ((j - cur_page) << PAGE_SHIFT) - offset;
> +		sg_set_page(s, pages[cur_page], min(size, chunk_size), offset);
> +		size -= chunk_size;
> +		offset = 0;
> +		cur_page = j;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(sg_alloc_table_from_pages);
> +
> +/**
>   * sg_miter_start - start mapping iteration over a sg list
>   * @miter: sg mapping iter to be started
>   * @sgl: sg list to iterate over
> -- 
> 1.7.5.4
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
