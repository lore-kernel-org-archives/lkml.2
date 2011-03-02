Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab1CBMxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 07:53:14 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:58895 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638Ab1CBMxN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:2>);
	Wed, 2 Mar 2011 07:53:13 -0500
Message-Id: <4D6E4BC6020000780003482A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 02 Mar 2011 12:53:10 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jens Axboe" <axboe@kernel.dk>, "Tejun Heo" <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.38-rc5 1/2] block: add @force_kblockd to
	 __blk_run_queue()
References: <20110217111511.GQ19830@htj.dyndns.org>
In-Reply-To: <20110217111511.GQ19830@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.02.11 at 12:15, Tejun Heo <tj@kernel.org> wrote:
> __blk_run_queue() automatically either calls q->request_fn() directly
> or schedules kblockd depending on whether the function is recursed.
> blk-flush implementation needs to be able to explicitly choose
> kblockd.  Add @force_kblockd.
> 
> All the current users are converted to specify %false for the
> parameter and this patch doesn't introduce any behavior change.
> 
> stable: This is prerequisite for fixing ide oops caused by the new
>         blk-flush implementation.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jan Beulich <JBeulich@novell.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: stable@kernel.org 

May I ask what the disposition of this and the second patch is?
Looking at 2.6.38-rc7 I still don't see either of them, while I
had hoped that they would both also make it into 2.6.37.2...

Thanks, Jan

> ---
>  block/blk-core.c                 |   11 ++++++-----
>  block/blk-flush.c                |    2 +-
>  block/cfq-iosched.c              |    6 +++---
>  block/elevator.c                 |    4 ++--
>  drivers/scsi/scsi_lib.c          |    2 +-
>  drivers/scsi/scsi_transport_fc.c |    2 +-
>  include/linux/blkdev.h           |    2 +-
>  7 files changed, 15 insertions(+), 14 deletions(-)
> 
> Index: work/block/blk-core.c
> ===================================================================
> --- work.orig/block/blk-core.c
> +++ work/block/blk-core.c
> @@ -352,7 +352,7 @@ void blk_start_queue(struct request_queu
>  	WARN_ON(!irqs_disabled());
>  
>  	queue_flag_clear(QUEUE_FLAG_STOPPED, q);
> -	__blk_run_queue(q);
> +	__blk_run_queue(q, false);
>  }
>  EXPORT_SYMBOL(blk_start_queue);
>  
> @@ -403,13 +403,14 @@ EXPORT_SYMBOL(blk_sync_queue);
>  /**
>   * __blk_run_queue - run a single device queue
>   * @q:	The queue to run
> + * @force_kblockd: Don't run @q->request_fn directly.  Use kblockd.
>   *
>   * Description:
>   *    See @blk_run_queue. This variant must be called with the queue lock
>   *    held and interrupts disabled.
>   *
>   */
> -void __blk_run_queue(struct request_queue *q)
> +void __blk_run_queue(struct request_queue *q, bool force_kblockd)
>  {
>  	blk_remove_plug(q);
>  
> @@ -423,7 +424,7 @@ void __blk_run_queue(struct request_queu
>  	 * Only recurse once to avoid overrunning the stack, let the unplug
>  	 * handling reinvoke the handler shortly if we already got there.
>  	 */
> -	if (!queue_flag_test_and_set(QUEUE_FLAG_REENTER, q)) {
> +	if (!force_kblockd && !queue_flag_test_and_set(QUEUE_FLAG_REENTER, q)) {
>  		q->request_fn(q);
>  		queue_flag_clear(QUEUE_FLAG_REENTER, q);
>  	} else {
> @@ -446,7 +447,7 @@ void blk_run_queue(struct request_queue
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(q->queue_lock, flags);
> -	__blk_run_queue(q);
> +	__blk_run_queue(q, false);
>  	spin_unlock_irqrestore(q->queue_lock, flags);
>  }
>  EXPORT_SYMBOL(blk_run_queue);
> @@ -1053,7 +1054,7 @@ void blk_insert_request(struct request_q
>  
>  	drive_stat_acct(rq, 1);
>  	__elv_add_request(q, rq, where, 0);
> -	__blk_run_queue(q);
> +	__blk_run_queue(q, false);
>  	spin_unlock_irqrestore(q->queue_lock, flags);
>  }
>  EXPORT_SYMBOL(blk_insert_request);
> Index: work/block/blk-flush.c
> ===================================================================
> --- work.orig/block/blk-flush.c
> +++ work/block/blk-flush.c
> @@ -69,7 +69,7 @@ static void blk_flush_complete_seq_end_i
>  	 * queue.  Kick the queue in those cases.
>  	 */
>  	if (was_empty && next_rq)
> -		__blk_run_queue(q);
> +		__blk_run_queue(q, false);
>  }
>  
>  static void pre_flush_end_io(struct request *rq, int error)
> Index: work/block/cfq-iosched.c
> ===================================================================
> --- work.orig/block/cfq-iosched.c
> +++ work/block/cfq-iosched.c
> @@ -3355,7 +3355,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, s
>  			    cfqd->busy_queues > 1) {
>  				cfq_del_timer(cfqd, cfqq);
>  				cfq_clear_cfqq_wait_request(cfqq);
> -				__blk_run_queue(cfqd->queue);
> +				__blk_run_queue(cfqd->queue, false);
>  			} else {
>  				cfq_blkiocg_update_idle_time_stats(
>  						&cfqq->cfqg->blkg);
> @@ -3370,7 +3370,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, s
>  		 * this new queue is RT and the current one is BE
>  		 */
>  		cfq_preempt_queue(cfqd, cfqq);
> -		__blk_run_queue(cfqd->queue);
> +		__blk_run_queue(cfqd->queue, false);
>  	}
>  }
>  
> @@ -3731,7 +3731,7 @@ static void cfq_kick_queue(struct work_s
>  	struct request_queue *q = cfqd->queue;
>  
>  	spin_lock_irq(q->queue_lock);
> -	__blk_run_queue(cfqd->queue);
> +	__blk_run_queue(cfqd->queue, false);
>  	spin_unlock_irq(q->queue_lock);
>  }
>  
> Index: work/block/elevator.c
> ===================================================================
> --- work.orig/block/elevator.c
> +++ work/block/elevator.c
> @@ -602,7 +602,7 @@ void elv_quiesce_start(struct request_qu
>  	 */
>  	elv_drain_elevator(q);
>  	while (q->rq.elvpriv) {
> -		__blk_run_queue(q);
> +		__blk_run_queue(q, false);
>  		spin_unlock_irq(q->queue_lock);
>  		msleep(10);
>  		spin_lock_irq(q->queue_lock);
> @@ -651,7 +651,7 @@ void elv_insert(struct request_queue *q,
>  		 *   with anything.  There's no point in delaying queue
>  		 *   processing.
>  		 */
> -		__blk_run_queue(q);
> +		__blk_run_queue(q, false);
>  		break;
>  
>  	case ELEVATOR_INSERT_SORT:
> Index: work/drivers/scsi/scsi_lib.c
> ===================================================================
> --- work.orig/drivers/scsi/scsi_lib.c
> +++ work/drivers/scsi/scsi_lib.c
> @@ -443,7 +443,7 @@ static void scsi_run_queue(struct reques
>  					&sdev->request_queue->queue_flags);
>  		if (flagset)
>  			queue_flag_set(QUEUE_FLAG_REENTER, sdev->request_queue);
> -		__blk_run_queue(sdev->request_queue);
> +		__blk_run_queue(sdev->request_queue, false);
>  		if (flagset)
>  			queue_flag_clear(QUEUE_FLAG_REENTER, sdev->request_queue);
>  		spin_unlock(sdev->request_queue->queue_lock);
> Index: work/drivers/scsi/scsi_transport_fc.c
> ===================================================================
> --- work.orig/drivers/scsi/scsi_transport_fc.c
> +++ work/drivers/scsi/scsi_transport_fc.c
> @@ -3829,7 +3829,7 @@ fc_bsg_goose_queue(struct fc_rport *rpor
>  		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
>  	if (flagset)
>  		queue_flag_set(QUEUE_FLAG_REENTER, rport->rqst_q);
> -	__blk_run_queue(rport->rqst_q);
> +	__blk_run_queue(rport->rqst_q, false);
>  	if (flagset)
>  		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
>  	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);
> Index: work/include/linux/blkdev.h
> ===================================================================
> --- work.orig/include/linux/blkdev.h
> +++ work/include/linux/blkdev.h
> @@ -699,7 +699,7 @@ extern void blk_start_queue(struct reque
>  extern void blk_stop_queue(struct request_queue *q);
>  extern void blk_sync_queue(struct request_queue *q);
>  extern void __blk_stop_queue(struct request_queue *q);
> -extern void __blk_run_queue(struct request_queue *);
> +extern void __blk_run_queue(struct request_queue *q, bool force_kblockd);
>  extern void blk_run_queue(struct request_queue *);
>  extern int blk_rq_map_user(struct request_queue *, struct request *,
>  			   struct rq_map_data *, void __user *, unsigned long,


