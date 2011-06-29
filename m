Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab1F2JbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:31:05 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:57320 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1F2Ja5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:30:57 -0400
Date: Wed, 29 Jun 2011 11:30:50 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/8] blk-throttle: core logic to throttle task while
 dirtying pages
Message-ID: <20110629093050.GA1183@thinkpad>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
 <1309275309-12889-7-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309275309-12889-7-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 11:35:07AM -0400, Vivek Goyal wrote:
...
> +	/*
> +	 * We dispatched one task. Set the charge for other queued tasks,
> +	 * if any.
> +	 */
> +	tg_set_active_task_charge(tg, rw);
> +	throtl_log_tg(td, tg, "[%c] Wake up a task. bdisp=%u sz=%u bps=%llu"
> +			" iodisp=%u iops=%u bioq=%d/%d taskq=%d/%d",
> +			rw == READ ? 'R' : 'W', tg->bytes_disp[rw], sz,
> +			tg->bps[rw], tg->io_disp[rw], tg->iops[rw],
> +			tg->nr_queued_bio[READ], tg->nr_queued_bio[WRITE],
> +			tg->nr_queued_tsk[READ], tg->nr_queued_tsk[WRITE]);

A small nitpick:

tg->bytes_disp[rw] is uint64_t, we should use bdisp=%llu.

> +}
> +
> +static void tg_switch_active_dispatch(struct throtl_data *td,
> +			struct throtl_grp *tg, bool rw)
> +{
> +	unsigned int nr_tasks = tg->nr_queued_tsk[rw];
> +	unsigned int nr_bios = tg->nr_queued_bio[rw];
> +	enum dispatch_type curr_dispatch = tg->active_dispatch[rw];
> +
> +	/* Nothing queued. Whoever gets queued next first, sets dispatch type */
> +	if (!nr_bios && !nr_tasks)
> +		return;
> +
> +	if (curr_dispatch == DISPATCH_BIO && nr_tasks) {
> +		tg->active_dispatch[rw] = DISPATCH_TASK;
> +		return;
> +	}
> +
> +	if (curr_dispatch == DISPATCH_TASK && nr_bios)
> +		tg->active_dispatch[rw] = DISPATCH_BIO;
> +}
> +
> +static void tg_update_active_dispatch(struct throtl_data *td,
> +			struct throtl_grp *tg, bool rw)
> +{
> +	unsigned int nr_tasks = tg->nr_queued_tsk[rw];
> +	unsigned int nr_bios = tg->nr_queued_bio[rw];
> +	enum dispatch_type curr_dispatch = tg->active_dispatch[rw];
> +
> +	BUG_ON(nr_bios < 0 || nr_tasks < 0);
> +
> +	if (curr_dispatch == DISPATCH_BIO && !nr_bios) {
> +		tg->active_dispatch[rw] = DISPATCH_TASK;
> +		return;
>  	}
>  
> +	if (curr_dispatch == DISPATCH_TASK && !nr_tasks)
> +		tg->active_dispatch[rw] = DISPATCH_BIO;
> +}
> +
> +static int throtl_dispatch_tg_rw(struct throtl_data *td, struct throtl_grp *tg,
> +			bool rw, struct bio_list *bl, unsigned int max)
> +{
> +	unsigned int nr_disp = 0;
> +
> +	if (tg->active_dispatch[rw] == DISPATCH_BIO)
> +		nr_disp = throtl_dispatch_tg_bio(td, tg, rw, bl, max);
> +	else
> +		/* Only number of bios dispatched is kept track of here */
> +		throtl_dispatch_tg_task(td, tg, rw, max);
> +
> +	tg_switch_active_dispatch(td, tg, rw);
> +	return nr_disp;
> +}
> +
> +static int throtl_dispatch_tg(struct throtl_data *td, struct throtl_grp *tg,
> +				struct bio_list *bl)
> +{
> +	/* Try to dispatch 75% READS and 25% WRITES */
> +	unsigned int nr_reads = 0, nr_writes = 0;
> +	unsigned int max_nr_reads = throtl_grp_quantum*3/4;
> +	unsigned int max_nr_writes = throtl_grp_quantum - max_nr_reads;
> +
> +	nr_reads = throtl_dispatch_tg_rw(td, tg, READ, bl, max_nr_reads);
> +	nr_writes = throtl_dispatch_tg_rw(td, tg, WRITE, bl, max_nr_writes);
> +
>  	return nr_reads + nr_writes;
>  }
>  
> +static bool tg_should_requeue(struct throtl_grp *tg)
> +{
> +	/* If there are queued bios, requeue */
> +	if (tg->nr_queued_bio[0] || tg->nr_queued_bio[1])
> +		return 1;
> +
> +	/* If there are queued tasks reueue */
> +	if (tg->nr_queued_tsk[0] || tg->nr_queued_tsk[1])
> +		return 1;
> +
> +	return 0;
> +}
> +
>  static int throtl_select_dispatch(struct throtl_data *td, struct bio_list *bl)
>  {
>  	unsigned int nr_disp = 0;
> @@ -832,7 +1016,7 @@ static int throtl_select_dispatch(struct throtl_data *td, struct bio_list *bl)
>  
>  		nr_disp += throtl_dispatch_tg(td, tg, bl);
>  
> -		if (tg->nr_queued[0] || tg->nr_queued[1]) {
> +		if (tg_should_requeue(tg)) {
>  			tg_update_disptime(td, tg);
>  			throtl_enqueue_tg(td, tg);
>  		}
> @@ -899,9 +1083,9 @@ static int throtl_dispatch(struct request_queue *q)
>  
>  	bio_list_init(&bio_list_on_stack);
>  
> -	throtl_log(td, "dispatch nr_queued=%u read=%u write=%u",
> -			total_nr_queued(td), td->nr_queued[READ],
> -			td->nr_queued[WRITE]);
> +	throtl_log(td, "dispatch bioq=%u/%u tskq=%u/%u",
> +			td->nr_queued_bio[READ], td->nr_queued_bio[WRITE],
> +			td->nr_queued_tsk[READ], td->nr_queued_tsk[WRITE]);
>  
>  	nr_disp = throtl_select_dispatch(td, &bio_list_on_stack);
>  
> @@ -1122,7 +1306,7 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
>  
>  		if (tg_no_rule_group(tg, rw)) {
>  			blkiocg_update_dispatch_stats(&tg->blkg, bio->bi_size,
> -					rw, bio->bi_rw & REQ_SYNC);
> +					1, rw, bio->bi_rw & REQ_SYNC);
>  			rcu_read_unlock();
>  			return 0;
>  		}
> @@ -1146,14 +1330,14 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
>  		}
>  	}
>  
> -	if (tg->nr_queued[rw]) {
> +	/* If there are already queued bio or task in same dir, queue bio */
> +	if (tg->nr_queued_bio[rw] || tg->nr_queued_tsk[rw]) {
>  		/*
> -		 * There is already another bio queued in same dir. No
> +		 * There is already another bio/task queued in same dir. No
>  		 * need to update dispatch time.
>  		 */
>  		update_disptime = false;
>  		goto queue_bio;
> -
>  	}
>  
>  	/* Bio is with-in rate limit of group */
> @@ -1178,16 +1362,18 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
>  
>  queue_bio:
>  	throtl_log_tg(td, tg, "[%c] bio. bdisp=%llu sz=%u bps=%llu"
> -			" iodisp=%u iops=%u queued=%d/%d",
> +			" iodisp=%u iops=%u bioq=%u/%u taskq=%u/%u",
>  			rw == READ ? 'R' : 'W',
>  			tg->bytes_disp[rw], bio->bi_size, tg->bps[rw],
>  			tg->io_disp[rw], tg->iops[rw],
> -			tg->nr_queued[READ], tg->nr_queued[WRITE]);
> +			tg->nr_queued_bio[READ], tg->nr_queued_bio[WRITE],
> +			tg->nr_queued_tsk[READ], tg->nr_queued_tsk[WRITE]);
>  
>  	throtl_add_bio_tg(q->td, tg, bio);
>  	*biop = NULL;
>  
>  	if (update_disptime) {
> +		tg_update_active_dispatch(td, tg, rw);
>  		tg_update_disptime(td, tg);
>  		throtl_schedule_next_dispatch(td);
>  	}
> @@ -1197,6 +1383,137 @@ out:
>  	return 0;
>  }
>  
> +static void
> +__blk_throtl_dirty_pages(struct request_queue *q, unsigned long nr_dirty)
> +{
> +	struct throtl_data *td = q->td;
> +	struct throtl_grp *tg;
> +	struct blkio_cgroup *blkcg;
> +	bool rw = WRITE, update_disptime = true, first_task = false;
> +	unsigned int sz = nr_dirty << PAGE_SHIFT;
> +	DEFINE_WAIT(wait);
> +
> +	/*
> +	 * A throtl_grp pointer retrieved under rcu can be used to access
> +	 * basic fields like stats and io rates. If a group has no rules,
> +	 * just update the dispatch stats in lockless manner and return.
> +	 */
> +
> +	rcu_read_lock();
> +	blkcg = task_blkio_cgroup(current);
> +	tg = throtl_find_tg(td, blkcg);
> +	if (tg) {
> +		throtl_tg_fill_dev_details(td, tg);
> +
> +		if (tg_no_rule_group(tg, rw)) {
> +			blkiocg_update_dispatch_stats(&tg->blkg, sz, nr_dirty,
> +							rw, 0);
> +			rcu_read_unlock();
> +			return;
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	spin_lock_irq(q->queue_lock);
> +
> +	tg = throtl_get_tg(td);
> +
> +	/*  Queue is gone. No queue lock held here. */
> +	if (IS_ERR(tg))
> +		return;
> +
> +	tg->unaccounted_dirty += nr_dirty;
> +
> +	/* If there are already queued task, put this task also on waitq */
> +	if (tg->nr_queued_tsk[rw]) {
> +		update_disptime = false;
> +		goto queue_task;
> +	} else
> +		first_task = true;
> +
> +	/* If there are bios already throttled in same dir, queue task */
> +	if (!bio_list_empty(&tg->bio_lists[rw])) {
> +		update_disptime = false;
> +		goto queue_task;
> +	}
> +
> +	/*
> +	 * Task is with-in rate limit of group.
> +	 *
> +	 * Note: How many IOPS we should charge for this operation. For
> +	 * the time being I am sticking to number of pages as number of
> +	 * IOPS.
> +	 */
> +	if (!tg_wait_dispatch(td, tg, rw, sz, nr_dirty)) {
> +		throtl_charge_dirty_io(tg, rw, sz, nr_dirty, 0);
> +		throtl_trim_slice(td, tg, rw);
> +		goto out;
> +	}
> +
> +queue_task:
> +	throtl_log_tg(td, tg, "[%c] task. bdisp=%u sz=%u bps=%llu"
> +			" iodisp=%u iops=%u bioq=%d/%d taskq=%d/%d",
> +			rw == READ ? 'R' : 'W',
> +			tg->bytes_disp[rw], sz, tg->bps[rw],
> +			tg->io_disp[rw], tg->iops[rw],
> +			tg->nr_queued_bio[READ], tg->nr_queued_bio[WRITE],
> +			tg->nr_queued_tsk[READ], tg->nr_queued_tsk[WRITE]);

Ditto.

See the fix below.

Thanks,
-Andrea

---
 block/blk-throttle.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 623cc05..f94a2a8 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -909,7 +909,7 @@ static void throtl_dispatch_tg_task(struct throtl_data *td,
 	 * if any.
 	 */
 	tg_set_active_task_charge(tg, rw);
-	throtl_log_tg(td, tg, "[%c] Wake up a task. bdisp=%u sz=%u bps=%llu"
+	throtl_log_tg(td, tg, "[%c] Wake up a task. bdisp=%llu sz=%u bps=%llu"
 			" iodisp=%u iops=%u bioq=%d/%d taskq=%d/%d",
 			rw == READ ? 'R' : 'W', tg->bytes_disp[rw], sz,
 			tg->bps[rw], tg->io_disp[rw], tg->iops[rw],
@@ -1459,7 +1459,7 @@ __blk_throtl_dirty_pages(struct request_queue *q, unsigned long nr_dirty)
 	}
 
 queue_task:
-	throtl_log_tg(td, tg, "[%c] task. bdisp=%u sz=%u bps=%llu"
+	throtl_log_tg(td, tg, "[%c] task. bdisp=%llu sz=%u bps=%llu"
 			" iodisp=%u iops=%u bioq=%d/%d taskq=%d/%d",
 			rw == READ ? 'R' : 'W',
 			tg->bytes_disp[rw], sz, tg->bps[rw],
