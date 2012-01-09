Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab2AIB4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 20:56:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60894 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab2AIB4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 20:56:33 -0500
Date: Sun, 8 Jan 2012 17:56:28 -0800
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: introduce BIO_IN_FLIGHT flag
Message-ID: <20120109015628.GB16360@mtj.dyndns.org>
References: <1324996113-1837-1-git-send-email-namhyung@gmail.com>
 <1324996113-1837-2-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324996113-1837-2-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 11:28:32PM +0900, Namhyung Kim wrote:
> BIO_IN_FLIGHT flag is used for tracing block I/O completion.
> This patch fixes tracing bio-based devices - except DM which
> inserts completion tracepoint explicitly - that could not be
> traced such event using blktrace.
> 
> It won't affect tracing normal (request-based) disk devices
> and nested bio handling paths.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  block/blk-core.c          |    5 +++++
>  fs/bio.c                  |    7 +++++++
>  include/linux/blk_types.h |    1 +
>  3 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 1b4fd93af2c0..f61310323954 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -165,6 +165,9 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
>  	if (unlikely(rq->cmd_flags & REQ_QUIET))
>  		set_bit(BIO_QUIET, &bio->bi_flags);
>  
> +	/* completion event was already reported in blk_update_request */
> +	clear_bit(BIO_IN_FLIGHT, &bio->bi_flags);
> +
>  	bio->bi_size -= nbytes;
>  	bio->bi_sector += (nbytes >> 9);
>  
> @@ -1662,6 +1665,8 @@ void generic_make_request(struct bio *bio)
p>  	do {
>  		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
>  
> +		set_bit(BIO_IN_FLIGHT, &bio->bi_flags);
> +
>  		q->make_request_fn(q, bio);
>  
>  		bio = bio_list_pop(current->bio_list);
> diff --git a/fs/bio.c b/fs/bio.c
> index b1fe82cf88cf..10fb7a1d74ba 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -1447,6 +1447,13 @@ void bio_endio(struct bio *bio, int error)
>  	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
>  		error = -EIO;
>  
> +	if (test_bit(BIO_IN_FLIGHT, &bio->bi_flags)) {
> +		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> +
> +		trace_block_bio_complete(q, bio, error);
> +		clear_bit(BIO_IN_FLIGHT, &bio->bi_flags);
> +	}

This really should be filtered from the consumer side.  Not on TP
itself.  Doing it like this makes the TP useless for other consumers
and adds unnecessary flag and operations on it even when the TP is not
in use.  Why not just trigger the TP on boi_endio() and let blktrace
probe filter out bounced or cloned completions?

Thanks.

--
tejun
