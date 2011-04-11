Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab1DKK7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 06:59:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab1DKK7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 06:59:39 -0400
Date: Mon, 11 Apr 2011 20:59:28 +1000
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110411205928.13915719@notabene.brown>
In-Reply-To: <4DA2C7BE.6060804@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	<1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
	<20110303221353.GA10366@redhat.com>
	<4D761E0D.8050200@fusionio.com>
	<20110308202100.GA31744@redhat.com>
	<4D76912C.9040705@fusionio.com>
	<20110308220526.GA393@redhat.com>
	<20110310005810.GA17911@redhat.com>
	<20110405130541.6c2b5f86@notabene.brown>
	<20110411145022.710c30e9@notabene.brown>
	<4DA2C7BE.6060804@fusionio.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011 11:19:58 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:

> On 2011-04-11 06:50, NeilBrown wrote:

> > The only explanation I can come up with is that very occasionally schedule on
> > 2 separate cpus calls blk_flush_plug for the same task.  I don't understand
> > the scheduler nearly well enough to know if or how that can happen.
> > However with this patch in place I can write to a RAID1 constantly for half
> > an hour, and without it, the write rarely lasts for 3 minutes.
> 
> Or perhaps if the request_fn blocks, that would be problematic. So the
> patch is likely a good idea even for that case.
> 
> I'll merge it, changing it to list_splice_init() as I think that would
> be more clear.

OK - though I'm not 100% the patch fixes the problem - just that it hides the
symptom for me.
I might try instrumenting the code a bit more and see if I can find exactly
where it is re-entering flush_plug_list - as that seems to be what is
happening.

And yeah - list_split_init is probably better.  I just never remember exactly
what list_split means and have to look it up every time, where as
list_add/list_del are very clear to me.


> 
> > From 687b189c02276887dd7d5b87a817da9f67ed3c2c Mon Sep 17 00:00:00 2001
> > From: NeilBrown <neilb@suse.de>
> > Date: Thu, 7 Apr 2011 13:16:59 +1000
> > Subject: [PATCH] Enhance new plugging support to support general callbacks.
> > 
> > md/raid requires an unplug callback, but as it does not uses
> > requests the current code cannot provide one.
> > 
> > So allow arbitrary callbacks to be attached to the blk_plug.
> > 
> > Cc: Jens Axboe <jaxboe@fusionio.com>
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >  block/blk-core.c       |   13 +++++++++++++
> >  include/linux/blkdev.h |    7 ++++++-
> >  2 files changed, 19 insertions(+), 1 deletions(-)
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 725091d..273d60b 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -2644,6 +2644,7 @@ void blk_start_plug(struct blk_plug *plug)
> >  
> >  	plug->magic = PLUG_MAGIC;
> >  	INIT_LIST_HEAD(&plug->list);
> > +	INIT_LIST_HEAD(&plug->cb_list);
> >  	plug->should_sort = 0;
> >  
> >  	/*
> > @@ -2717,9 +2718,21 @@ static void flush_plug_list(struct blk_plug *plug)
> >  	local_irq_restore(flags);
> >  }
> >  
> > +static void flush_plug_callbacks(struct blk_plug *plug)
> > +{
> > +	while (!list_empty(&plug->cb_list)) {
> > +		struct blk_plug_cb *cb = list_first_entry(&plug->cb_list,
> > +							  struct blk_plug_cb,
> > +							  list);
> > +		list_del(&cb->list);
> > +		cb->callback(cb);
> > +	}
> > +}
> > +
> >  static void __blk_finish_plug(struct task_struct *tsk, struct blk_plug *plug)
> >  {
> >  	flush_plug_list(plug);
> > +	flush_plug_callbacks(plug);
> >  
> >  	if (plug == tsk->plug)
> >  		tsk->plug = NULL;
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 32176cc..3e5e604 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -857,8 +857,13 @@ extern void blk_put_queue(struct request_queue *);
> >  struct blk_plug {
> >  	unsigned long magic;
> >  	struct list_head list;
> > +	struct list_head cb_list;
> >  	unsigned int should_sort;
> >  };
> > +struct blk_plug_cb {
> > +	struct list_head list;
> > +	void (*callback)(struct blk_plug_cb *);
> > +};
> >  
> >  extern void blk_start_plug(struct blk_plug *);
> >  extern void blk_finish_plug(struct blk_plug *);
> > @@ -876,7 +881,7 @@ static inline bool blk_needs_flush_plug(struct task_struct *tsk)
> >  {
> >  	struct blk_plug *plug = tsk->plug;
> >  
> > -	return plug && !list_empty(&plug->list);
> > +	return plug && (!list_empty(&plug->list) || !list_empty(&plug->cb_list));
> >  }
> >  
> >  /*
> 
> Maybe I'm missing something, but why do you need those callbacks? If
> it's to use plugging yourself, perhaps we can just ensure that those
> don't get assigned in the task - so it would be have to used with care.
> 
> It's not that I disagree to these callbacks, I just want to ensure I
> understand why you need them.
> 

I'm sure one of us is missing something (probably both) but I'm not sure what.

The callback is central.

It is simply to use plugging in md.
Just like blk-core, md will notice that a blk_plug is active and will put
requests aside.  I then need something to call in to md when blk_finish_plug
is called so that put-aside requests can be released.
As md can be built as a module, that call must be a call-back of some sort.
blk-core doesn't need to register blk_plug_flush because that is never in a
module, so it can be called directly.  But the md equivalent could be in a
module, so I need to be able to register a call back.

Does that help? 

Thanks,
NeilBrown


