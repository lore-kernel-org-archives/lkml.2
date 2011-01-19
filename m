Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1ASAyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 19:54:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332Ab1ASAyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 19:54:12 -0500
Date: Tue, 18 Jan 2011 16:53:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Dillow <dillowda@ornl.gov>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3]  fs/direct-io.c: don't try to allocate more than
 BIO_MAX_PAGES in a bio
Message-Id: <20110118165359.09023fe9.akpm@linux-foundation.org>
In-Reply-To: <1295319627.3051.89.camel@obelisk.thedillows.org>
References: <1294977946.21790.20.camel@obelisk.thedillows.org>
	<x498vynbl4e.fsf@segfault.boston.devel.redhat.com>
	<1295023584.24487.16.camel@lap75545.ornl.gov>
	<x49y66jmljv.fsf@segfault.boston.devel.redhat.com>
	<1295319627.3051.89.camel@obelisk.thedillows.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jan 2011 22:00:27 -0500
David Dillow <dillowda@ornl.gov> wrote:

> When using devices that support max_segments > BIO_MAX_PAGES (256),
> direct IO tries to allocate a bio with more pages than allowed, which
> leads to an oops in dio_bio_alloc(). Clamp the request to the supported
> maximum, and change dio_bio_alloc() to reflect that bio_alloc() will
> always return a bio when called with __GFP_WAIT and a valid number of
> vectors.

Which device driver triggers this condition?

> Also added cc to stable, as this has been a longstanding item.

Well.  -stable only needs the patch if the driver which triggers the
problem is also there.  But we don't know what driver that is, yet???

> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -325,13 +325,18 @@ void dio_end_io(struct bio *bio, int error)
>  }
>  EXPORT_SYMBOL_GPL(dio_end_io);
>  
> -static int
> +static void
>  dio_bio_alloc(struct dio *dio, struct block_device *bdev,
>  		sector_t first_sector, int nr_vecs)
>  {
>  	struct bio *bio;
>  
> +	/*
> +	 * bio_alloc() is guaranteed to return a bio when called with
> +	 * __GFP_WAIT and we request a valid number of vectors.
> +	 */
>  	bio = bio_alloc(GFP_KERNEL, nr_vecs);
> +	BUG_ON(!bio);

This BUG_ON() is pretty pointless,

>  	bio->bi_bdev = bdev;

because the next statement will reliably oops, providing us with the
same information.


>  	bio->bi_sector = first_sector;
> @@ -342,7 +347,6 @@ dio_bio_alloc(struct dio *dio, struct block_device *bdev,
>  
>  	dio->bio = bio;
>  	dio->logical_offset_in_bio = dio->cur_page_fs_offset;
> -	return 0;
>  }
>  
>  /*
> @@ -583,8 +587,9 @@ static int dio_new_bio(struct dio *dio, sector_t start_sector)
>  		goto out;
>  	sector = start_sector << (dio->blkbits - 9);
>  	nr_pages = min(dio->pages_in_io, bio_get_nr_vecs(dio->map_bh.b_bdev));
> +	nr_pages = min(nr_pages, BIO_MAX_PAGES);
>  	BUG_ON(nr_pages <= 0);
> -	ret = dio_bio_alloc(dio, dio->map_bh.b_bdev, sector, nr_pages);
> +	dio_bio_alloc(dio, dio->map_bh.b_bdev, sector, nr_pages);
>  	dio->boundary = 0;
>  out:
>  	return ret;
> 
