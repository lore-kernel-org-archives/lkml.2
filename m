Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2LPQA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 11:00:29 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63727 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2LPQAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 11:00:25 -0500
Date: Mon, 17 Dec 2012 00:13:36 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
        viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
        martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
        bharrosh@panasas.com, jlayton@samba.org,
        v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 4/4] block: Optionally snapshot page contents to provide
 stable pages during write
Message-ID: <20121216161336.GA6243@gmail.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
 <20121213080811.23360.98131.stgit@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213080811.23360.98131.stgit@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 12:08:11AM -0800, Darrick J. Wong wrote:
> diff --git a/mm/bounce.c b/mm/bounce.c
> index 0420867..fa11935 100644
> --- a/mm/bounce.c
> +++ b/mm/bounce.c
> @@ -178,6 +178,38 @@ static void bounce_end_io_read_isa(struct bio *bio, int err)
>  	__bounce_end_io_read(bio, isa_page_pool, err);
>  }
>  
> +#ifdef CONFIG_NEED_BOUNCE_POOL
> +static int might_snapshot_stable_page_write(struct bio **bio_orig)
> +{
> +	return bio_data_dir(*bio_orig) == WRITE;
> +}
> +
> +static int should_snapshot_stable_pages(struct page *page, int rw)
> +{
> +	struct backing_dev_info *bdi;
> +	struct address_space *mapping = page_mapping(page);
> +
> +	if (!mapping)
> +		return 0;
> +	bdi = mapping->backing_dev_info;
> +	if (!bdi_cap_stable_pages_required(bdi))
> +		return 0;
> +
> +	return mapping->host->i_sb->s_flags & MS_SNAP_STABLE &&
> +	       rw == WRITE;
> +}
> +#else
> +static int might_snapshot_stable_page_write(struct bio **bio_orig)
> +{
> +	return 0;
> +}
> +
> +static int should_snapshot_static_pages(struct page *page, int rw)
                              ^^^^^^
                              It should be _stable_.

Regards,
                                                - Zheng
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_NEED_BOUNCE_POOL */
> +
>  static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
>  			       mempool_t *pool)
>  {
> @@ -192,7 +224,8 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
>  		/*
>  		 * is destination page below bounce pfn?
>  		 */
> -		if (page_to_pfn(page) <= queue_bounce_pfn(q))
> +		if (page_to_pfn(page) <= queue_bounce_pfn(q) &&
> +		    !should_snapshot_stable_pages(page, rw))
>  			continue;
>  
>  		/*
> @@ -284,7 +317,8 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
>  	 * don't waste time iterating over bio segments
>  	 */
>  	if (!(q->bounce_gfp & GFP_DMA)) {
> -		if (queue_bounce_pfn(q) >= blk_max_pfn)
> +		if (queue_bounce_pfn(q) >= blk_max_pfn &&
> +		    !might_snapshot_stable_page_write(bio_orig))
>  			return;
>  		pool = page_pool;
>  	} else {
