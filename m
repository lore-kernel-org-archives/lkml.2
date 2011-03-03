Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab1CCV17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:27:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab1CCV16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:27:58 -0500
Date: Thu, 3 Mar 2011 16:27:45 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110303212745.GA9854@redhat.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
 <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03 2011 at  4:23pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> > diff --git a/block/blk-flush.c b/block/blk-flush.c
> > index 54b123d..c0a07aa 100644
> > --- a/block/blk-flush.c
> > +++ b/block/blk-flush.c
> > @@ -59,7 +59,6 @@ static struct request *blk_flush_complete_seq(struct request_queue *q,
> >  static void blk_flush_complete_seq_end_io(struct request_queue *q,
> >                                          unsigned seq, int error)
> >  {
> > -       bool was_empty = elv_queue_empty(q);
> >        struct request *next_rq;
> >
> >        next_rq = blk_flush_complete_seq(q, seq, error);
> > @@ -68,7 +67,7 @@ static void blk_flush_complete_seq_end_io(struct request_queue *q,
> >         * Moving a request silently to empty queue_head may stall the
> >         * queue.  Kick the queue in those cases.
> >         */
> > -       if (was_empty && next_rq)
> > +       if (next_rq)
> >                __blk_run_queue(q);
> >  }
> >
> ...
> > diff --git a/block/elevator.c b/block/elevator.c
> > index a9fe237..d5d17a4 100644
> > --- a/block/elevator.c
> > +++ b/block/elevator.c
> > @@ -619,8 +619,6 @@ void elv_quiesce_end(struct request_queue *q)
> ...
> > -int elv_queue_empty(struct request_queue *q)
> > -{
> > -       struct elevator_queue *e = q->elevator;
> > -
> > -       if (!list_empty(&q->queue_head))
> > -               return 0;
> > -
> > -       if (e->ops->elevator_queue_empty_fn)
> > -               return e->ops->elevator_queue_empty_fn(q);
> > -
> > -       return 1;
> > -}
> > -EXPORT_SYMBOL(elv_queue_empty);
> > -
> 
> Your latest 'for-2.6.39/stack-unplug' rebase (commit 7703acb01e)
> misses removing a call to elv_queue_empty() in
> block/blk-flush.c:flush_data_end_io()
> 
>   CC      block/blk-flush.o
> block/blk-flush.c: In function ‘flush_data_end_io’:
> block/blk-flush.c:266: error: implicit declaration of function ‘elv_queue_empty’

This allows me to compile:

diff --git a/block/blk-flush.c b/block/blk-flush.c
index de5ae6e..671fa9d 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -263,10 +263,9 @@ static bool blk_kick_flush(struct request_queue *q)
 static void flush_data_end_io(struct request *rq, int error)
 {
 	struct request_queue *q = rq->q;
-	bool was_empty = elv_queue_empty(q);
 
 	/* after populating an empty queue, kick it to avoid stall */
-	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error) && was_empty)
+	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error))
 		__blk_run_queue(q);
 }
 
