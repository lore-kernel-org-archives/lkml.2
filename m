Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2DXOed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:34:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45631 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab2DXOeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:34:31 -0400
Date: Tue, 24 Apr 2012 16:33:57 +0200
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
Subject: Re: [PATCH v2] scatterlist: add sg_alloc_table_from_pages function
Message-ID: <20120424143357.GA2017@phenom.ffwll.local>
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
References: <4F96A390.7080305@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F96A390.7080305@samsung.com>
X-Operating-System: Linux phenom 3.2.0-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 02:58:56PM +0200, Tomasz Stanislawski wrote:
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

I like this and we could replace the drm helper function in drm prime with
this one. One comment below.
-Daniel

> ---
>  include/linux/scatterlist.h |    4 +++
>  lib/scatterlist.c           |   63 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 67 insertions(+), 0 deletions(-)
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
> index 6096e89..90f9265 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -319,6 +319,69 @@ int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
>  EXPORT_SYMBOL(sg_alloc_table);
> 
>  /**
> + * sg_alloc_table_from_pages - Allocate and initialize an sg table from
> + *			       an array of pages
> + * @sgt:	The sg table header to use
> + * @pages:	Pointer to an array of page pointers
> + * @n_pages:	Number of pages in the pages array
> + * @offset:     Offset from a start of the first page to a start of a buffer
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
> +		if (pages[i] != pages[i - 1] + 1)
> +			++chunks;

I'm not aware of the details (and didn't bother to do a full audit), but
I guess this could blow up on funky discontig-mem setups. Imo would be
safer to compare the pfn or phys address. And also slightly more readable.
Imo sg table creation is not a fastpath, the exporter should cache these
anyway, so we can waste some cpu cycles here.

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
> +			if (pages[j] != pages[j - 1] + 1)
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
