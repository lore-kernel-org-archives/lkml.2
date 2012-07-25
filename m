Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab2GYLac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:30:32 -0400
Received: from natasha.panasas.com ([67.152.220.90]:34740 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab2GYLab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:30:31 -0400
Message-ID: <500FD8B7.9040701@panasas.com>
Date: Wed, 25 Jul 2012 14:29:59 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dm-devel@redhat.com>, <tj@kernel.org>, <axboe@kernel.dk>,
        <agk@redhat.com>, <neilb@suse.de>, <drbd-dev@lists.linbit.com>,
        <vgoyal@redhat.com>, <mpatocka@redhat.com>, <sage@newdream.net>,
        <yehuda@hq.newdream.net>
Subject: Re: [PATCH v4 04/12] pktcdvd: Switch to bio_kmalloc()
References: <1343160689-12378-1-git-send-email-koverstreet@google.com> <1343160689-12378-5-git-send-email-koverstreet@google.com>
In-Reply-To: <1343160689-12378-5-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 11:11 PM, Kent Overstreet wrote:

> This is prep work for killing bi_destructor - previously, pktcdvd had
> its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
> necessitating its own bi_destructor implementation.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> ---
>  drivers/block/pktcdvd.c |  115 ++++++++++++++++-------------------------------
>  1 files changed, 39 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index ba66e44..6fe693a 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -522,36 +522,38 @@ static void pkt_bio_finished(struct pktcdvd_device *pd)
>  	}
>  }
>  
> -static void pkt_bio_destructor(struct bio *bio)
> +static void pkt_end_io_read(struct bio *bio, int err)
>  {
> -	kfree(bio->bi_io_vec);
> -	kfree(bio);
> -}


Again here, you decided to move the pkt_end_io_read && pkt_end_io_packet_write
functions from below, to above here. Which makes it impossible to find
any bugs by just reviewing the patch.

So I have not reviewed it. 

I know that you wanted so you can reference them at pkt_alloc_packet_data.
I'd use a forward reference, in this case. And a move in a next patch. But
this is just me. Perhaps the owner of this code can review it?

Cheers
Boaz

> +	struct packet_data *pkt = bio->bi_private;
> +	struct pktcdvd_device *pd = pkt->pd;
> +	BUG_ON(!pd);
>  
> -static struct bio *pkt_bio_alloc(int nr_iovecs)
> -{
> -	struct bio_vec *bvl = NULL;
> -	struct bio *bio;
> +	VPRINTK("pkt_end_io_read: bio=%p sec0=%llx sec=%llx err=%d\n", bio,
> +		(unsigned long long)pkt->sector, (unsigned long long)bio->bi_sector, err);
>  
> -	bio = kmalloc(sizeof(struct bio), GFP_KERNEL);
> -	if (!bio)
> -		goto no_bio;
> -	bio_init(bio);
> +	if (err)
> +		atomic_inc(&pkt->io_errors);
> +	if (atomic_dec_and_test(&pkt->io_wait)) {
> +		atomic_inc(&pkt->run_sm);
> +		wake_up(&pd->wqueue);
> +	}
> +	pkt_bio_finished(pd);
> +}
>  
> -	bvl = kcalloc(nr_iovecs, sizeof(struct bio_vec), GFP_KERNEL);
> -	if (!bvl)
> -		goto no_bvl;
> +static void pkt_end_io_packet_write(struct bio *bio, int err)
> +{
> +	struct packet_data *pkt = bio->bi_private;
> +	struct pktcdvd_device *pd = pkt->pd;
> +	BUG_ON(!pd);
>  
> -	bio->bi_max_vecs = nr_iovecs;
> -	bio->bi_io_vec = bvl;
> -	bio->bi_destructor = pkt_bio_destructor;
> +	VPRINTK("pkt_end_io_packet_write: id=%d, err=%d\n", pkt->id, err);
>  
> -	return bio;
> +	pd->stats.pkt_ended++;
>  
> - no_bvl:
> -	kfree(bio);
> - no_bio:
> -	return NULL;
> +	pkt_bio_finished(pd);
> +	atomic_dec(&pkt->io_wait);
> +	atomic_inc(&pkt->run_sm);
> +	wake_up(&pd->wqueue);
>  }
>  
>  /*
> @@ -567,10 +569,13 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
>  		goto no_pkt;
>  
>  	pkt->frames = frames;
> -	pkt->w_bio = pkt_bio_alloc(frames);
> +	pkt->w_bio = bio_kmalloc(GFP_KERNEL, frames);
>  	if (!pkt->w_bio)
>  		goto no_bio;
>  
> +	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
> +	pkt->w_bio->bi_private = pkt;
> +
>  	for (i = 0; i < frames / FRAMES_PER_PAGE; i++) {
>  		pkt->pages[i] = alloc_page(GFP_KERNEL|__GFP_ZERO);
>  		if (!pkt->pages[i])
> @@ -581,9 +586,12 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
>  	bio_list_init(&pkt->orig_bios);
>  
>  	for (i = 0; i < frames; i++) {
> -		struct bio *bio = pkt_bio_alloc(1);
> +		struct bio *bio = bio_kmalloc(GFP_KERNEL, 1);
>  		if (!bio)
>  			goto no_rd_bio;
> +
> +		bio->bi_end_io = pkt_end_io_read;
> +		bio->bi_private = pkt;
>  		pkt->r_bios[i] = bio;
>  	}
>  
> @@ -1036,40 +1044,6 @@ static void pkt_make_local_copy(struct packet_data *pkt, struct bio_vec *bvec)
>  	}
>  }
>  
> -static void pkt_end_io_read(struct bio *bio, int err)
> -{
> -	struct packet_data *pkt = bio->bi_private;
> -	struct pktcdvd_device *pd = pkt->pd;
> -	BUG_ON(!pd);
> -
> -	VPRINTK("pkt_end_io_read: bio=%p sec0=%llx sec=%llx err=%d\n", bio,
> -		(unsigned long long)pkt->sector, (unsigned long long)bio->bi_sector, err);
> -
> -	if (err)
> -		atomic_inc(&pkt->io_errors);
> -	if (atomic_dec_and_test(&pkt->io_wait)) {
> -		atomic_inc(&pkt->run_sm);
> -		wake_up(&pd->wqueue);
> -	}
> -	pkt_bio_finished(pd);
> -}
> -
> -static void pkt_end_io_packet_write(struct bio *bio, int err)
> -{
> -	struct packet_data *pkt = bio->bi_private;
> -	struct pktcdvd_device *pd = pkt->pd;
> -	BUG_ON(!pd);
> -
> -	VPRINTK("pkt_end_io_packet_write: id=%d, err=%d\n", pkt->id, err);
> -
> -	pd->stats.pkt_ended++;
> -
> -	pkt_bio_finished(pd);
> -	atomic_dec(&pkt->io_wait);
> -	atomic_inc(&pkt->run_sm);
> -	wake_up(&pd->wqueue);
> -}
> -
>  /*
>   * Schedule reads for the holes in a packet
>   */
> @@ -1111,21 +1085,15 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
>  	 * Schedule reads for missing parts of the packet.
>  	 */
>  	for (f = 0; f < pkt->frames; f++) {
> -		struct bio_vec *vec;
> -
>  		int p, offset;
> +
>  		if (written[f])
>  			continue;
> +
>  		bio = pkt->r_bios[f];
> -		vec = bio->bi_io_vec;
> -		bio_init(bio);
> -		bio->bi_max_vecs = 1;
> -		bio->bi_sector = pkt->sector + f * (CD_FRAMESIZE >> 9);
> -		bio->bi_bdev = pd->bdev;
> -		bio->bi_end_io = pkt_end_io_read;
> -		bio->bi_private = pkt;
> -		bio->bi_io_vec = vec;
> -		bio->bi_destructor = pkt_bio_destructor;
> +		bio_reset(bio);
> +		bio->bi_sector	= pkt->sector + f * (CD_FRAMESIZE >> 9);
> +		bio->bi_bdev	= pd->bdev;
>  
>  		p = (f * CD_FRAMESIZE) / PAGE_SIZE;
>  		offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
> @@ -1418,14 +1386,9 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
>  	}
>  
>  	/* Start the write request */
> -	bio_init(pkt->w_bio);
> -	pkt->w_bio->bi_max_vecs = PACKET_MAX_SIZE;
> +	bio_reset(pkt->w_bio);
>  	pkt->w_bio->bi_sector = pkt->sector;
>  	pkt->w_bio->bi_bdev = pd->bdev;
> -	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
> -	pkt->w_bio->bi_private = pkt;
> -	pkt->w_bio->bi_io_vec = bvec;
> -	pkt->w_bio->bi_destructor = pkt_bio_destructor;
>  	for (f = 0; f < pkt->frames; f++)
>  		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
>  			BUG();


