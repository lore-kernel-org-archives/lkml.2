Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab1ILDZT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 23:25:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1ILDZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 23:25:18 -0400
Date: Mon, 12 Sep 2011 05:25:08 +0200
From: NeilBrown <neilb@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] block: remove support for bio remapping from
 ->make_request
Message-ID: <20110912052508.6b59b5ac@notabene.brown>
In-Reply-To: <20110911145129.GA29504@infradead.org>
References: <20110911145053.GA28996@infradead.org>
	<20110911145129.GA29504@infradead.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Sep 2011 10:51:29 -0400 Christoph Hellwig <hch@infradead.org>
wrote:

> There is very little benefit in allowing to let a ->make_request instance update
> the bios device and sector and loop around it in __generic_make_request when
> we can archive the same through calling generic_make_request from the driver
> and letting the loop in generic_make_request handle it.

Completely agree - I like this change!

> 
> Note that various drivers got the return value from ->make_request and returned
> non-zero values for errors.

:-(

A diff-stat would have been nice... I think I've found all 'my' files though.



> Index: linux-2.6/drivers/md/faulty.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/faulty.c	2011-09-08 12:01:53.000000000 +0200
> +++ linux-2.6/drivers/md/faulty.c	2011-09-08 12:05:58.602773802 +0200
> @@ -169,7 +169,7 @@ static void add_sector(conf_t *conf, sec
>  		conf->nfaults = n+1;
>  }
>  
> -static int make_request(mddev_t *mddev, struct bio *bio)
> +static void make_request(mddev_t *mddev, struct bio *bio)
>  {
>  	conf_t *conf = mddev->private;
>  	int failit = 0;
> @@ -181,7 +181,7 @@ static int make_request(mddev_t *mddev,
>  			 * just fail immediately
>  			 */
>  			bio_endio(bio, -EIO);
> -			return 0;
> +			return;
>  		}
>  
>  		if (check_sector(conf, bio->bi_sector, bio->bi_sector+(bio->bi_size>>9),
> @@ -214,12 +214,11 @@ static int make_request(mddev_t *mddev,
>  		b->bi_bdev = conf->rdev->bdev;
>  		b->bi_private = bio;
>  		b->bi_end_io = faulty_fail;
> -		generic_make_request(b);
> -		return 0;
>  	} else {
>  		bio->bi_bdev = conf->rdev->bdev;
> -		return 1;
>  	}
> +
> +	generic_make_request(b);
>  }

If the 'else' branch was taken, we need to generic_make_request(bio).
And 'b' isn't even declared at this level.
So at the end of the 'then' branch, add
        bio = b;
and make the final call
        generic_make_request(bio);


Changes to these files:
> Index: linux-2.6/drivers/md/linear.c
> Index: linux-2.6/drivers/md/multipath.c
> Index: linux-2.6/drivers/md/raid0.c
> Index: linux-2.6/drivers/md/raid1.c
> Index: linux-2.6/drivers/md/raid10.c
> Index: linux-2.6/drivers/md/raid5.c
> Index: linux-2.6/drivers/md/md.h
> Index: linux-2.6/drivers/md/md.c

Acked-by: NeilBrown <neilb@suse.de>

Thanks,
NeilBrown
