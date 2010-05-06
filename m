Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0EFVJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 17:09:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55237 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab0EFVJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 17:09:26 -0400
Date: Thu, 6 May 2010 17:09:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] direct-io: add a hook for the fs to provide its
	own submit_bio function
Message-ID: <20100506210925.GC2997@infradead.org>
References: <20100506190037.GC13974@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506190037.GC13974@dhcp231-156.rdu.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 03:00:38PM -0400, Josef Bacik wrote:
> +void dio_end_io(struct bio *bio, int error)
> +{
> +	struct dio *dio = bio->bi_private;
> +
> +	if (dio->is_async)
> +		dio_bio_end_aio(bio, error);
> +	else
> +		dio_bio_end_io(bio, error);
> +}
> +EXPORT_SYMBOL(dio_end_io);

_GPL export please as it's quite internal.

> @@ -340,7 +352,10 @@ static void dio_bio_submit(struct dio *dio)
>  	if (dio->is_async && dio->rw == READ)
>  		bio_set_pages_dirty(bio);
>  
> -	submit_bio(dio->rw, bio);
> +	if (!dio->submit_io)
> +		submit_bio(dio->rw, bio);
> +	else
> +		dio->submit_io(dio->rw, bio, dio->inode);

What about making sure that dio->submit_io is always set in
direct_io_worker?

>  static int dio_send_cur_page(struct dio *dio)
>  {
> +	int boundary = dio->boundary;
>  	int ret = 0;
>  
>  	if (dio->bio) {
> @@ -612,7 +628,7 @@ static int dio_send_cur_page(struct dio *dio)
>  		 * Submit now if the underlying fs is about to perform a
>  		 * metadata read
>  		 */
> -		if (dio->boundary)
> +		if (boundary)
>  			dio_bio_submit(dio);
>  	}
>  
> @@ -629,6 +645,8 @@ static int dio_send_cur_page(struct dio *dio)
>  			ret = dio_bio_add_page(dio);
>  			BUG_ON(ret != 0);
>  		}
> +	} else if (boundary) {
> +		dio_bio_submit(dio);
>  	}

These hunk seem like they're unrealted to the actual hook,  I'd rather
have them in a separate patch.

> +static inline ssize_t blockdev_direct_IO_own_submit(int rw, struct kiocb *iocb,
> +	struct inode *inode, struct block_device *bdev, const struct iovec *iov,
> +	loff_t offset, unsigned long nr_segs, get_block_t get_block,
> +	dio_submit_t submit_io)
> +{
> +	return __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
> +				    nr_segs, get_block, NULL, submit_io, 0);
>  }

Please don't add another wrapper.  At this point I'd suggest just using
__blockdev_direct_IO for everything but the trivial blockdev_direct_IO
and also kill blockdev_direct_IO_no_locking.

