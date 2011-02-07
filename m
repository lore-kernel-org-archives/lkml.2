Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1BGWye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 17:54:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093Ab1BGWyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 17:54:32 -0500
Date: Tue, 8 Feb 2011 09:54:24 +1100
From: NeilBrown <neilb@suse.de>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-raid <linux-raid@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, axboe@kernel.dk
Subject: Re: [PATCH] md_make_request: don't touch the bio after calling
 make_request
Message-ID: <20110208095424.1b886746@notabene.brown>
In-Reply-To: <1297106377-sup-9409@think>
References: <1297106377-sup-9409@think>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Feb 2011 14:21:48 -0500 Chris Mason <chris.mason@oracle.com> wrote:

> md_make_request was calling bio_sectors() for part_stat_add
> after it was calling the make_request function.  This is
> bad because the make_request function can free the bio and
> because the bi_size field can change around.
> 
> The fix here was suggested by Jens Axboe.  It saves the
> sector count before the make_request call.  I hit this
> with CONFIG_DEBUG_PAGEALLOC turned on while trying to break
> his pretty fusionio card.

Thanks Chris!!

I've added it to my queue of md fixes (which I really must send of soon) and
tagged it for -stable.

NeilBrown


> 
> Signed-off-by: Chris Mason <chris.mason@oracle.com>
> ---
>  drivers/md/md.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b76cfc8..a7d3c3c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -287,6 +287,7 @@ static int md_make_request(struct request_queue *q, struct bio *bio)
>  	mddev_t *mddev = q->queuedata;
>  	int rv;
>  	int cpu;
> +	unsigned int sectors;
>  
>  	if (mddev == NULL || mddev->pers == NULL
>  	    || !mddev->ready) {
> @@ -311,12 +312,16 @@ static int md_make_request(struct request_queue *q, struct bio *bio)
>  	atomic_inc(&mddev->active_io);
>  	rcu_read_unlock();
>  
> +	/*
> +	 * save the sectors now since our bio can
> +	 * go away inside make_request
> +	 */
> +	sectors = bio_sectors(bio);
>  	rv = mddev->pers->make_request(mddev, bio);
>  
>  	cpu = part_stat_lock();
>  	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
> -	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
> -		      bio_sectors(bio));
> +	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw], sectors);
>  	part_stat_unlock();
>  
>  	if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)

