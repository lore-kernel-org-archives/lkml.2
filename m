Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab0KVHcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 02:32:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab0KVHcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 02:32:18 -0500
Date: Mon, 22 Nov 2010 18:32:07 +1100
From: Neil Brown <neilb@suse.de>
To: <aniket@netezza.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md: Fix nr_pending race during raid10 recovery
Message-ID: <20101122183207.2c8b85d4@notabene.brown>
In-Reply-To: <1290020270.3055.12.camel@aniket-desktop>
References: <1290020270.3055.12.camel@aniket-desktop>
X-Mailer: Claws Mail 3.7.7 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 13:57:50 -0500
Aniket Kulkarni <aniket@netezza.com> wrote:

> If a RAID10 rdev that is undergoing recovery is marked 'faulty', the rdev 
> could get taken out of the array in spite of outstanding IOs leading to 
> a kernel panic. There are two issues here -
> 
> 1. The ref count (nr_pending) increment for sync or recovery leaves a lot of
> open windows for concurrent rdev removals
> 2. raid10 sync thread continues to submit recovery IOs to faulty devices. These get
> rejected at a later stage by management thread (raid10d).
> 
> Note - rd denotes the rdev from which we are reading, and wr the one we are
> writing to
> 
>   Sync Thread                                Management Thread
> 
> sync_request
>   ++rd.nr_pending
>   bi_end_io = end_sync_read
>   generic_make_request         -------> recovery_request_write
>          |                    |             wr.nr_pending++
>          |                    |             bi_end_io = end_sync_write
>          V                    |             generic_make_request
> end_sync_read    --------------                      |
>   --rd.nr_pending                                    |
>   reschedule_retry for write                         |
>                                                      v
>                                          end_sync_write
>                                              --wr.nr_pending
> 
> So a set-faulty and remove on recovery rdev between sync_request and 
> recovery_request_write is allowed and will lead to a panic.
> 
> The fix is -
> 
> 1. Increment wr.nr_pending immediately after selecting a good target. Ofcourse
> the decrements will be added to error paths in sync_request and end_sync_read.
> 2. Don't submit recovery IOs to faulty targets
> 
> Signed-off-by: Aniket Kulkarni <aniket@netezza.com>
> ---
>  drivers/md/raid10.c |   46 +++++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index c67aa54..ec1ea43 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1408,6 +1408,16 @@ static void sync_request_write(mddev_t *mddev, r10bio_t *r10_bio)
>  
>  done:
>  	if (atomic_dec_and_test(&r10_bio->remaining)) {
> +		for (i = 0; i < conf->copies ; i++)  {
> +			/* for any unsuccessful IOs give up the pending count on the
> +			 * write device
> +			 */
> +			if (!test_bit(BIO_UPTODATE, &r10_bio->devs[i].bio->bi_flags) &&
> +				r10_bio->devs[i].bio->bi_end_io == end_sync_write) {
> +				int d = r10_bio->devs[i].devnum;
> +				rdev_dec_pending(conf->mirrors[d].rdev, mddev);
> +			}
> +		}
>  		md_done_sync(mddev, r10_bio->sectors, 1);
>  		put_buf(r10_bio);
>  	}
> @@ -1443,7 +1453,6 @@ static void recovery_request_write(mddev_t *mddev, r10bio_t *r10_bio)
>  	}
>  	d = r10_bio->devs[1].devnum;
>  
> -	atomic_inc(&conf->mirrors[d].rdev->nr_pending);
>  	md_sync_acct(conf->mirrors[d].rdev->bdev, wbio->bi_size >> 9);
>  	if (test_bit(R10BIO_Uptodate, &r10_bio->state))
>  		generic_make_request(wbio);
> @@ -1906,14 +1915,24 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
>  		int j, k;
>  		r10_bio = NULL;
>  
> -		for (i=0 ; i<conf->raid_disks; i++)
> +		for (i = 0; i < conf->raid_disks; i++)
>  			if (conf->mirrors[i].rdev &&
>  			    !test_bit(In_sync, &conf->mirrors[i].rdev->flags)) {
>  				int still_degraded = 0;
>  				/* want to reconstruct this device */
>  				r10bio_t *rb2 = r10_bio;
> -				sector_t sect = raid10_find_virt(conf, sector_nr, i);
> +				sector_t sect;
>  				int must_sync;
> +
> +				/* Skip over the faulty drives */
> +				if (test_bit(Faulty, &conf->mirrors[i].rdev->flags))
> +					continue;

You shouldn't need to check for Faulty here as In_sync is always cleared when
Faulty is set, and we know In_sync is not clear.

> +
> +				/* up the nr_pending count; this will be decremented on
> +				 * sync/recovery IO completion (success/erorr) to this dev
> +				 */
> +				atomic_inc(&conf->mirrors[i].rdev->nr_pending);

If you delay that atomic_inc a little .....

> +				sect = raid10_find_virt(conf, sector_nr, i);
>  				/* Unless we are doing a full sync, we only need
>  				 * to recover the block if it is set in the bitmap
>  				 */
> @@ -1927,6 +1946,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
>  					 * that there will never be anything to do here
>  					 */
>  					chunks_skipped = -1;
> +					rdev_dec_pending(conf->mirrors[i].rdev, mddev);
>  					continue;
>  				}

.... to here, you don't need the rdev_dec_pending.


>  
> @@ -1997,6 +2017,10 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
>  				if (j == conf->copies) {
>  					/* Cannot recover, so abort the recovery */
>  					put_buf(r10_bio);
> +					/* we wanted to write to 'i' but we didn't; so dec the
> +					 * pending count
> +					 */
> +					rdev_dec_pending(conf->mirrors[i].rdev, mddev);
>  					if (rb2)
>  						atomic_dec(&rb2->remaining);
>  					r10_bio = rb2;
> @@ -2014,6 +2038,22 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
>  				r10_bio = (r10bio_t*) rb2->master_bio;
>  				rb2->master_bio = NULL;
>  				put_buf(rb2);
> +				if (r10_bio)  {
> +					int d;
> +					/* Before throwing away the complete r10bio chain, decrement
> +					 * the nr_pending ref counts incremented along the way
> +					 * We do this only for our master_bio and then on because
> +					 * if biolist == NULL no ref count was incremented in this
> +					 * r10_bio
> +					 */
> +					for (d = 0; d < conf->copies; d++)  {
> +						if (r10_bio->devs[d].bio &&
> +							r10_bio->devs[d].bio->bi_end_io)	{
> +							int dn = r10_bio->devs[d].devnum;
> +							rdev_dec_pending(conf->mirrors[dn].rdev, mddev);
> +						}
> +					}
> +				}

In raid1, we do this rdev_dec_pending loop inside put_buf.  I think I'd like
to do that for raid10 too, but I'll make that a separate patch.


>  			}
>  			goto giveup;
>  		}

I also need some rcu locking in there and need to review the 'resync' (as
opposed to recovery) paths to make sure they are OK too.

Thanks,
NeilBrown


