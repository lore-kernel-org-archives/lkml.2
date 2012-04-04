Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab2DDVrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:47:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab2DDVrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:47:01 -0400
Date: Wed, 4 Apr 2012 14:46:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tao Guo <glorioustao@gmail.com>
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, axboe@fusionio.com,
        Tao Guo <Tao.Guo@emc.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] umem: fix up unplugging.
Message-Id: <20120404144656.7b2a06ec.akpm@linux-foundation.org>
In-Reply-To: <1325254651-15379-1-git-send-email-glorioustao@gmail.com>
References: <1325254651-15379-1-git-send-email-glorioustao@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Dec 2011 09:17:31 -0500

(Long delay...)

Tao Guo <glorioustao@gmail.com> wrote:

> We need to implement unplugging to make umem start to work, or I/O
> will never be triggered.
> 

I take it from this that umem simply doesn't work at all?

If so, for how long has this been the case and should we just delete the
thing?

> 
> --- a/drivers/block/umem.c
> +++ b/drivers/block/umem.c
> @@ -111,7 +111,8 @@ struct cardinfo {
>  	int		current_idx;
>  	sector_t	current_sector;
>  
> -	struct request_queue *queue;
> +	struct request_queue	*queue;
> +	struct blk_plug_cb	plug_cb;
>  
>  	struct mm_page {
>  		dma_addr_t		page_dma;
> @@ -513,6 +514,33 @@ static void process_page(unsigned long data)
>  	}
>  }
>  
> +static void mm_unplug(struct blk_plug_cb *cb)
> +{
> +	struct cardinfo *card = container_of(cb, struct cardinfo, plug_cb);
> +
> +	spin_lock_irq(&card->lock);
> +	activate(card);
> +	spin_unlock_irq(&card->lock);
> +}
> +
> +int mm_check_plugged(struct cardinfo *card)
> +{
> +	struct blk_plug *plug = current->plug;
> +	struct cardinfo *c;
> +
> +	if (!plug)
> +		return 0;
> +
> +	list_for_each_entry(c, &plug->cb_list, plug_cb.list) {
> +		if (c == card)
> +			return 1;
> +	}
> +
> +	/* set up unplug callback */
> +	list_add(&card->plug_cb.list, &plug->cb_list);
> +	return 1;
> +}
> +
>  static void mm_make_request(struct request_queue *q, struct bio *bio)
>  {
>  	struct cardinfo *card = q->queuedata;
> @@ -523,6 +551,8 @@ static void mm_make_request(struct request_queue *q, struct bio *bio)
>  	*card->biotail = bio;
>  	bio->bi_next = NULL;
>  	card->biotail = &bio->bi_next;
> +	if (bio->bi_rw & REQ_SYNC || !mm_check_plugged(card))
> +		activate(card);
>  	spin_unlock_irq(&card->lock);
>  
>  	return;
> @@ -884,6 +914,7 @@ static int __devinit mm_pci_probe(struct pci_dev *dev,
>  	blk_queue_make_request(card->queue, mm_make_request);
>  	card->queue->queue_lock = &card->lock;
>  	card->queue->queuedata = card;
> +	card->plug_cb.callback = mm_unplug;
>  
>  	tasklet_init(&card->tasklet, process_page, (unsigned long)card);

