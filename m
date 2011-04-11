Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab1DKQ7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 12:59:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab1DKQ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 12:59:27 -0400
Date: Mon, 11 Apr 2011 12:59:23 -0400
From: "hch@infradead.org" <hch@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110411165923.GA15442@infradead.org>
References: <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
 <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
 <20110303221353.GA10366@redhat.com>
 <4D761E0D.8050200@fusionio.com>
 <20110308202100.GA31744@redhat.com>
 <4D76912C.9040705@fusionio.com>
 <20110308220526.GA393@redhat.com>
 <20110310005810.GA17911@redhat.com>
 <20110405130541.6c2b5f86@notabene.brown>
 <20110411145022.710c30e9@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110411145022.710c30e9@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 02:50:22PM +1000, NeilBrown wrote:
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 273d60b..903ce8d 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2674,19 +2674,23 @@ static void flush_plug_list(struct blk_plug *plug)
>  	struct request_queue *q;
>  	unsigned long flags;
>  	struct request *rq;
> +	struct list_head head;
>  
>  	BUG_ON(plug->magic != PLUG_MAGIC);
>  
>  	if (list_empty(&plug->list))
>  		return;
> +	list_add(&head, &plug->list);
> +	list_del_init(&plug->list);
>  
>  	if (plug->should_sort)
> -		list_sort(NULL, &plug->list, plug_rq_cmp);
> +		list_sort(NULL, &head, plug_rq_cmp);
> +	plug->should_sort = 0;

As Jens mentioned this should be list_splice_init.  But looking over
flush_plug_list the code there seems strange to me.

What does the local_irq_save in flush_plug_list protect?  Why don't
we need it over the list_sort?  And do we still need it when first
splicing the list to a local one?

It's one of these cases where I'd really like to see more comments
explaining why the code is doing what it's doing.

