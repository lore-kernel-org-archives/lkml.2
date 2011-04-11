Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1DKVOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:14:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab1DKVOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:14:38 -0400
Date: Tue, 12 Apr 2011 07:14:28 +1000
From: NeilBrown <neilb@suse.de>
To: "hch@infradead.org" <hch@infradead.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dm-devel@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110412071428.4aa92c6e@notabene.brown>
In-Reply-To: <20110411165923.GA15442@infradead.org>
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
	<20110411165923.GA15442@infradead.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011 12:59:23 -0400 "hch@infradead.org" <hch@infradead.org>
wrote:

> On Mon, Apr 11, 2011 at 02:50:22PM +1000, NeilBrown wrote:
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 273d60b..903ce8d 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -2674,19 +2674,23 @@ static void flush_plug_list(struct blk_plug *plug)
> >  	struct request_queue *q;
> >  	unsigned long flags;
> >  	struct request *rq;
> > +	struct list_head head;
> >  
> >  	BUG_ON(plug->magic != PLUG_MAGIC);
> >  
> >  	if (list_empty(&plug->list))
> >  		return;
> > +	list_add(&head, &plug->list);
> > +	list_del_init(&plug->list);
> >  
> >  	if (plug->should_sort)
> > -		list_sort(NULL, &plug->list, plug_rq_cmp);
> > +		list_sort(NULL, &head, plug_rq_cmp);
> > +	plug->should_sort = 0;
> 
> As Jens mentioned this should be list_splice_init.  But looking over
> flush_plug_list the code there seems strange to me.
> 
> What does the local_irq_save in flush_plug_list protect?  Why don't
> we need it over the list_sort?  And do we still need it when first
> splicing the list to a local one?
> 
> It's one of these cases where I'd really like to see more comments
> explaining why the code is doing what it's doing.

My understanding of that was that the calling requirement of
__elv_add_request is that the queue spinlock is held and that interrupts are
disabled.
So rather than possible enabling and disabling interrupts several times as
different queue are handled, the code just disabled interrupts once, and
then just take the spinlock once for each different queue.

The whole point of the change to plugging was to take locks less often.
Disabling interrupts less often is presumably an analogous goal.

Though I agree that a comment would help.

	q = NULL;
+	/* Disable interrupts just once rather than using spin_lock_irq/sin_unlock_irq
	 * variants
	 */
	local_irq_save(flags);


assuming my analysis is correct.

NeilBrown

