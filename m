Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0GVL4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:56:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:44982 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab0GVL4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:56:06 -0400
Date: Thu, 22 Jul 2010 21:55:55 +1000
From: Neil Brown <neilb@suse.de>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
        hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH] md: bitwise operations might not fit in a "bool"
Message-ID: <20100722215555.7ab2b1ee@notabene>
In-Reply-To: <4C482F35.6000004@panasas.com>
References: <4C47ED7B.1050709@gmail.com>
	<20100722173716.66264bef@notabene>
	<4C481FD5.4070509@gmail.com>
	<4C482F35.6000004@panasas.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010 14:44:53 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
> when taking a resolute of a bit-wise AND as true false. Better / faster
> to make it a boolean operation.
> 
> This fixes a bug and a crash because the flags field did not fit into
> the bool operands.

No, that won't work.
Read the rest of the code and see where 'do_sync' and 'do_barriers' are used.

NeilBrown

> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
> git diff --stat -p -M drivers/md/raid1.c
>  drivers/md/raid1.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 73cc74f..67a9159 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -787,7 +787,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
>  	struct bio_list bl;
>  	struct page **behind_pages = NULL;
>  	const int rw = bio_data_dir(bio);
> -	const bool do_sync = (bio->bi_rw & REQ_SYNC);
> +	const bool do_sync = (bio->bi_rw & REQ_SYNC) != 0;
>  	bool do_barriers;
>  	mdk_rdev_t *blocked_rdev;
>  
> @@ -959,7 +959,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
>  	atomic_set(&r1_bio->remaining, 0);
>  	atomic_set(&r1_bio->behind_remaining, 0);
>  
> -	do_barriers = bio->bi_rw & REQ_HARDBARRIER;
> +	do_barriers = (bio->bi_rw & REQ_HARDBARRIER) != 0;
>  	if (do_barriers)
>  		set_bit(R1BIO_Barrier, &r1_bio->state);
>  
> @@ -1640,7 +1640,8 @@ static void raid1d(mddev_t *mddev)
>  			 * We already have a nr_pending reference on these rdevs.
>  			 */
>  			int i;
> -			const bool do_sync = (r1_bio->master_bio->bi_rw & REQ_SYNC);
> +			const bool do_sync =
> +				(r1_bio->master_bio->bi_rw & REQ_SYNC) != 0;
>  			clear_bit(R1BIO_BarrierRetry, &r1_bio->state);
>  			clear_bit(R1BIO_Barrier, &r1_bio->state);
>  			for (i=0; i < conf->raid_disks; i++)
> @@ -1696,7 +1697,9 @@ static void raid1d(mddev_t *mddev)
>  				       (unsigned long long)r1_bio->sector);
>  				raid_end_bio_io(r1_bio);
>  			} else {
> -				const bool do_sync = r1_bio->master_bio->bi_rw & REQ_SYNC;
> +				const bool do_sync =
> +					(r1_bio->master_bio->bi_rw & REQ_SYNC)
> +					!= 0;
>  				r1_bio->bios[r1_bio->read_disk] =
>  					mddev->ro ? IO_BLOCKED : NULL;
>  				r1_bio->read_disk = disk;

