Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2IYFvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 01:51:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab2IYFvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 01:51:12 -0400
Message-ID: <5061464B.4090002@suse.de>
Date: Tue, 25 Sep 2012 07:51:07 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, axboe@kernel.dk,
        vgoyal@redhat.com
Subject: Re: [dm-devel] [PATCH v3 11/26] block: Add submit_bio_wait(), remove
 from md
References: <1348526106-17074-1-git-send-email-koverstreet@google.com> <1348526106-17074-12-git-send-email-koverstreet@google.com>
In-Reply-To: <1348526106-17074-12-git-send-email-koverstreet@google.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 12:34 AM, Kent Overstreet wrote:
> Random cleanup - this code was duplicated and it's not really specific
> to md.
> 
> Also added the ability to return the actual error code.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: NeilBrown <neilb@suse.de>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/md/raid1.c  | 19 -------------------
>  drivers/md/raid10.c | 19 -------------------
>  fs/bio.c            | 36 ++++++++++++++++++++++++++++++++++++
>  include/linux/bio.h |  1 +
>  4 files changed, 37 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index deff0cd..28f506a 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2048,25 +2048,6 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
>  	}
>  }
>  
> -static void bi_complete(struct bio *bio, int error)
> -{
> -	complete((struct completion *)bio->bi_private);
> -}
> -
> -static int submit_bio_wait(int rw, struct bio *bio)
> -{
> -	struct completion event;
> -	rw |= REQ_SYNC;
> -
> -	init_completion(&event);
> -	bio->bi_private = &event;
> -	bio->bi_end_io = bi_complete;
> -	submit_bio(rw, bio);
> -	wait_for_completion(&event);
> -
> -	return test_bit(BIO_UPTODATE, &bio->bi_flags);
> -}
> -
>  static int narrow_write_error(struct r1bio *r1_bio, int i)
>  {
>  	struct mddev *mddev = r1_bio->mddev;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 6d06d83..f001c1b 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2410,25 +2410,6 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
>  	}
>  }
>  
> -static void bi_complete(struct bio *bio, int error)
> -{
> -	complete((struct completion *)bio->bi_private);
> -}
> -
> -static int submit_bio_wait(int rw, struct bio *bio)
> -{
> -	struct completion event;
> -	rw |= REQ_SYNC;
> -
> -	init_completion(&event);
> -	bio->bi_private = &event;
> -	bio->bi_end_io = bi_complete;
> -	submit_bio(rw, bio);
> -	wait_for_completion(&event);
> -
> -	return test_bit(BIO_UPTODATE, &bio->bi_flags);
> -}
> -
>  static int narrow_write_error(struct r10bio *r10_bio, int i)
>  {
>  	struct bio *bio = r10_bio->master_bio;
> diff --git a/fs/bio.c b/fs/bio.c
> index 062ba8f..9a30dcf 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -750,6 +750,42 @@ int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
>  }
>  EXPORT_SYMBOL(bio_add_page);
>  
> +struct submit_bio_ret {
> +	struct completion event;
> +	int error;
> +};
> +
> +static void submit_bio_wait_endio(struct bio *bio, int error)
> +{
> +	struct submit_bio_ret *ret = bio->bi_private;
> +
> +	ret->error = error;
> +	complete(&ret->event);
> +}
> +
> +/**
> + * submit_bio_wait - submit a bio, and wait until it completes
> + * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
> + * @bio: The &struct bio which describes the I/O
> + *
> + * Simple wrapper around submit_bio(). Returns 0 on success, or the error from
> + * bio_endio() on failure.
> + */
> +int submit_bio_wait(int rw, struct bio *bio)
> +{
> +	struct submit_bio_ret ret;
> +
> +	rw |= REQ_SYNC;
> +	init_completion(&ret.event);
> +	bio->bi_private = &ret;
> +	bio->bi_end_io = submit_bio_wait_endio;

Hmm. As this is meant to be a generic function, blindly overwriting
the bi_end_io pointer doesn't look like a good idea; the caller
could have set something there.

Please add at least a WARN_ON(bio->bi_end_io) prior to modifying it.

> +	submit_bio(rw, bio);
> +	wait_for_completion(&ret.event);
> +
> +	return ret.error;
> +}
> +EXPORT_SYMBOL(submit_bio_wait);
> +
>  /**
>   * bio_advance - increment/complete a bio by some number of bytes
>   * @bio:	bio to advance
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index d985e90..3bf696b 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -252,6 +252,7 @@ extern void bio_endio(struct bio *, int);
>  struct request_queue;
>  extern int bio_phys_segments(struct request_queue *, struct bio *);
>  
> +extern int submit_bio_wait(int rw, struct bio *bio);
>  extern void bio_advance(struct bio *, unsigned);
>  
>  extern void bio_init(struct bio *);
> 

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)


