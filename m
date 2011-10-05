Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935510Ab1JEWwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 18:52:16 -0400
Received: from natasha.panasas.com ([67.152.220.90]:37878 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934900Ab1JEWwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 18:52:15 -0400
Message-ID: <4E8CDF7B.7000601@panasas.com>
Date: Thu, 6 Oct 2011 00:51:39 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] block: add bio_map_sg
References: <20111005195403.407628164@bombadil.infradead.org> <20111005195529.760114992@bombadil.infradead.org>
In-Reply-To: <20111005195529.760114992@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 09:54 PM, Christoph Hellwig wrote:
> Add a helper to map a bio to a scatterlist, modelled after blk_rq_map_sg.
> This helper is useful for any driver that wants to create a scatterlist
> from its ->make_request method.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

I have some questions.

- Could we later use this bio_map_sg() to implement blk_rq_map_sg() and
  remove some duplicated code?

- Don't you need to support a chained bio (bio->next != NULL)? Because
  I did not see any looping in the last patch 
	[PATCH 5/5] virtio-blk: implement ->make_request
  Or is it that ->make_request() is a single bio at a time?
  If so could we benefit from both bio-chaining and sg-chaning to
  make bigger IOs?

Thanks
Boaz

> Index: linux-2.6/block/blk-merge.c
> ===================================================================
> --- linux-2.6.orig/block/blk-merge.c	2011-10-04 11:49:32.857014742 -0400
> +++ linux-2.6/block/blk-merge.c	2011-10-04 13:37:51.305630951 -0400
> @@ -199,6 +199,69 @@ new_segment:
>  }
>  EXPORT_SYMBOL(blk_rq_map_sg);
>  
> +/*
> + * map a bio to a scatterlist, return number of sg entries setup. Caller
> + * must make sure sg can hold bio->bi_phys_segments entries
> + */
> +int bio_map_sg(struct request_queue *q, struct bio *bio,
> +		  struct scatterlist *sglist)
> +{
> +	struct bio_vec *bvec, *bvprv;
> +	struct scatterlist *sg;
> +	int nsegs, cluster;
> +	unsigned long i;
> +
> +	nsegs = 0;
> +	cluster = blk_queue_cluster(q);
> +
> +	bvprv = NULL;
> +	sg = NULL;
> +	bio_for_each_segment(bvec, bio, i) {
> +		int nbytes = bvec->bv_len;
> +
> +		if (bvprv && cluster) {
> +			if (sg->length + nbytes > queue_max_segment_size(q))
> +				goto new_segment;
> +
> +			if (!BIOVEC_PHYS_MERGEABLE(bvprv, bvec))
> +				goto new_segment;
> +			if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bvec))
> +				goto new_segment;
> +
> +			sg->length += nbytes;
> +		} else {
> +new_segment:
> +			if (!sg)
> +				sg = sglist;
> +			else {
> +				/*
> +				 * If the driver previously mapped a shorter
> +				 * list, we could see a termination bit
> +				 * prematurely unless it fully inits the sg
> +				 * table on each mapping. We KNOW that there
> +				 * must be more entries here or the driver
> +				 * would be buggy, so force clear the
> +				 * termination bit to avoid doing a full
> +				 * sg_init_table() in drivers for each command.
> +				 */
> +				sg->page_link &= ~0x02;
> +				sg = sg_next(sg);
> +			}
> +
> +			sg_set_page(sg, bvec->bv_page, nbytes, bvec->bv_offset);
> +			nsegs++;
> +		}
> +		bvprv = bvec;
> +	} /* segments in bio */
> +
> +	if (sg)
> +		sg_mark_end(sg);
> +
> +	BUG_ON(bio->bi_phys_segments && nsegs > bio->bi_phys_segments);
> +	return nsegs;
> +}
> +EXPORT_SYMBOL(bio_map_sg);
> +
>  static inline int ll_new_hw_segment(struct request_queue *q,
>  				    struct request *req,
>  				    struct bio *bio)
> Index: linux-2.6/include/linux/blkdev.h
> ===================================================================
> --- linux-2.6.orig/include/linux/blkdev.h	2011-10-04 13:37:13.216148915 -0400
> +++ linux-2.6/include/linux/blkdev.h	2011-10-04 13:37:51.317613617 -0400
> @@ -854,6 +854,8 @@ extern void blk_queue_flush_queueable(st
>  extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
>  
>  extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
> +extern int bio_map_sg(struct request_queue *q, struct bio *bio,
> +		struct scatterlist *sglist);
>  extern void blk_dump_rq_flags(struct request *, char *);
>  extern long nr_blockdev_pages(void);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

