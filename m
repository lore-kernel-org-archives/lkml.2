Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1HKA4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 20:56:40 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34420 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1HKA4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 20:56:38 -0400
MIME-Version: 1.0
In-Reply-To: <x49ty9pqood.fsf@segfault.boston.devel.redhat.com>
References: <x49ty9pqood.fsf@segfault.boston.devel.redhat.com>
Date: Thu, 11 Aug 2011 08:56:37 +0800
X-Google-Sender-Auth: 5YZoDTLO_eqWSjpx1_2EzTN5cXY
Message-ID: <CANejiEVwvO5csrNCHEjcTzUj6ZeuVjHB6Bdavhn-axAyTj144Q@mail.gmail.com>
Subject: Re: [patch] block: fix flush machinery for stacking drivers with
 differring flush flags
From: Shaohua Li <shli@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, msnitzer@redhat.com,
        vgoyal@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/10 Jeff Moyer <jmoyer@redhat.com>:
> Hi,
>
> Commit ae1b1539622fb46e51b4d13b3f9e5f4c713f86ae, block: reimplement
> FLUSH/FUA to support merge, introduced a performance regression when
> running any sort of fsyncing workload using dm-multipath and certain
> storage (in our case, an HP EVA).  The test I ran was fs_mark, and it
> dropped from ~800 files/sec on ext4 to ~100 files/sec.  It turns out
> that dm-multipath always advertised flush+fua support, and passed
> commands on down the stack, where those flags used to get stripped off.
> The above commit changed that behavior:
>
> static inline struct request *__elv_next_request(struct request_queue *q)
> {
>        struct request *rq;
>
>        while (1) {
> -               while (!list_empty(&q->queue_head)) {
> +               if (!list_empty(&q->queue_head)) {
>                        rq = list_entry_rq(q->queue_head.next);
> -                       if (!(rq->cmd_flags & (REQ_FLUSH | REQ_FUA)) ||
> -                           (rq->cmd_flags & REQ_FLUSH_SEQ))
> -                               return rq;
> -                       rq = blk_do_flush(q, rq);
> -                       if (rq)
> -                               return rq;
> +                       return rq;
>                }
>
> Note that previously, a command would come in here, have
> REQ_FLUSH|REQ_FUA set, and then get handed off to blk_do_flush:
>
> struct request *blk_do_flush(struct request_queue *q, struct request *rq)
> {
>        unsigned int fflags = q->flush_flags; /* may change, cache it */
>        bool has_flush = fflags & REQ_FLUSH, has_fua = fflags & REQ_FUA;
>        bool do_preflush = has_flush && (rq->cmd_flags & REQ_FLUSH);
>        bool do_postflush = has_flush && !has_fua && (rq->cmd_flags &
>        REQ_FUA);
>        unsigned skip = 0;
> ...
>        if (blk_rq_sectors(rq) && !do_preflush && !do_postflush) {
>                rq->cmd_flags &= ~REQ_FLUSH;
>                if (!has_fua)
>                        rq->cmd_flags &= ~REQ_FUA;
>                return rq;
>        }
>
> So, the flush machinery was bypassed in such cases (q->flush_flags == 0
> && rq->cmd_flags & (REQ_FLUSH|REQ_FUA)).
>
> Now, however, we don't get into the flush machinery at all.  Instead,
> __elv_next_request just hands a request with flush and fua bits set to
> the scsi_request_fn, even if the underlying request_queue does not
> support flush or fua.
>
> The agreed upon approach is to fix the flush machinery to allow
> stacking.  While this isn't used in practice (since there is only one
> request-based dm target, and that target will now reflect the flush
> flags of the underlying device), it does future-proof the solution, and
> make it function as designed.
>
> In order to make this work, I had to add a field to the struct request,
> inside the flush structure (to store the original req->end_io).  Shaohua
> had suggested overloading the union with rb_node and completion_data,
> but the completion data is used by device mapper and can also be used by
> other drivers.  So, I didn't see a way around the additional field.
>
> I chose to short-circuit empty flush requests (when the flush flags
> don't advertise flush) in blk_insert_cloned_request.  I don't see a huge
> advantage to doing this inside blk_insert_flush, though it could be done
> there as well.
>
> I tested this patch on an HP EVA with both ext4 and xfs, and it recovers
> the lost performance.  Comments and other testers, as always, are
> appreciated.
>
> Cheers,
> Jeff
>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index b850bed..7ee03c6 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -39,6 +39,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
>
>  static int __make_request(struct request_queue *q, struct bio *bio);
> +static bool blk_end_bidi_request(struct request *rq, int error,
> +                                unsigned int nr_bytes, unsigned int bidi_bytes);
>
>  /*
>  * For the allocated request tables
> @@ -1700,6 +1702,7 @@ EXPORT_SYMBOL_GPL(blk_rq_check_limits);
>  int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
>  {
>        unsigned long flags;
> +       int where = ELEVATOR_INSERT_BACK;
>
>        if (blk_rq_check_limits(q, rq))
>                return -EIO;
> @@ -1708,6 +1711,20 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
>            should_fail_request(&rq->rq_disk->part0, blk_rq_bytes(rq)))
>                return -EIO;
>
> +       if (rq->cmd_flags & (REQ_FLUSH|REQ_FUA)) {
> +               /*
> +                * Filter empty flush requests here.  REQ_FLUSH_SEQ will
> +                * ensure that no I/O accounting is done for this request.
> +                */
> +               if (!q->flush_flags && !blk_rq_sectors(rq)) {
> +                       blk_end_bidi_request(rq, 0, 0, 0);
> +                       return 0;
> +               }
> +               where = ELEVATOR_INSERT_FLUSH;
> +               /* REQ_FLUSH_SEQ will be set again by the flush machinery */
> +               rq->cmd_flags &= ~REQ_FLUSH_SEQ;
> +       }
> +
>        spin_lock_irqsave(q->queue_lock, flags);
>
>        /*
> @@ -1716,7 +1733,7 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
>         */
>        BUG_ON(blk_queued_rq(rq));
>
> -       add_acct_request(q, rq, ELEVATOR_INSERT_BACK);
> +       add_acct_request(q, rq, where);
>        spin_unlock_irqrestore(q->queue_lock, flags);
>
>        return 0;
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index 2d162bd..2633a08 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -123,7 +123,7 @@ static void blk_flush_restore_request(struct request *rq)
>
>        /* make @rq a normal request */
>        rq->cmd_flags &= ~REQ_FLUSH_SEQ;
> -       rq->end_io = NULL;
> +       rq->end_io = rq->flush.saved_end_io;
>  }
>
>  /**
> @@ -301,7 +301,6 @@ void blk_insert_flush(struct request *rq)
>        unsigned int fflags = q->flush_flags;   /* may change, cache */
>        unsigned int policy = blk_flush_policy(fflags, rq);
>
> -       BUG_ON(rq->end_io);
>        BUG_ON(!rq->bio || rq->bio != rq->biotail);
>
>        /*
> @@ -320,6 +319,7 @@ void blk_insert_flush(struct request *rq)
>        if ((policy & REQ_FSEQ_DATA) &&
>            !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
>                list_add_tail(&rq->queuelist, &q->queue_head);
> +               blk_run_queue_async(q);
A minor issue. I can understand this is required for
blk_insert_cloned_request() because INSERT_BACK will run
queue but INSERT_FLUSH doesn't. But sounds we don't need
run queue for normal requests. Either __make_request will run
queue (task has plug list) or flush_plug will run queue. delaying
run queue has its benefit. can we do the runqueue in
blk_insert_cloned_request() if this is a INSERT_FLUSH.

Thanks,
Shaohua
