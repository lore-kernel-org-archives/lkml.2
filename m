Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab1CVU7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:59:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265Ab1CVU7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:59:09 -0400
Date: Tue, 22 Mar 2011 16:59:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cfq-iosched: Don't set active queue in preempt
Message-ID: <20110322205905.GM3757@redhat.com>
References: <1300825050-11371-1-git-send-email-teravest@google.com>
 <1300825050-11371-2-git-send-email-teravest@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300825050-11371-2-git-send-email-teravest@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 01:17:29PM -0700, Justin TerAvest wrote:
> Commit "Add unaccounted time to timeslice_used" changed the behavior of
> cfq_preempt_queue to set cfqq active. Vivek pointed out that other
> preemption rules might get involved, so we shouldn't manually set which
> queue is active.
> 
> This cleans up the code to just clear the queue stats at preemption
> time.
> 
> Signed-off-by: Justin TerAvest <teravest@google.com>
> ---
>  block/cfq-iosched.c |   39 +++++++++++++++++++++++----------------
>  1 files changed, 23 insertions(+), 16 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 12e380b..69208d7 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1620,27 +1620,33 @@ static inline void cfq_del_timer(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  	cfq_blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
>  }
>  
> +static void cfq_clear_queue_stats(struct cfq_data *cfqd,
> +				  struct cfq_queue *cfqq)
> +{
> +	cfq_blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
> +	cfqq->slice_start = 0;
> +	cfqq->dispatch_start = jiffies;
> +	cfqq->allocated_slice = 0;
> +	cfqq->slice_end = 0;
> +	cfqq->slice_dispatch = 0;
> +	cfqq->nr_sectors = 0;
> +
> +	cfq_clear_cfqq_wait_request(cfqq);
> +	cfq_clear_cfqq_must_dispatch(cfqq);
> +	cfq_clear_cfqq_must_alloc_slice(cfqq);
> +	cfq_clear_cfqq_fifo_expire(cfqq);
> +	cfq_mark_cfqq_slice_new(cfqq);
> +
> +	cfq_del_timer(cfqd, cfqq);
> +}
> +
>  static void __cfq_set_active_queue(struct cfq_data *cfqd,
>  				   struct cfq_queue *cfqq)
>  {
>  	if (cfqq) {
>  		cfq_log_cfqq(cfqd, cfqq, "set_active wl_prio:%d wl_type:%d",
>  				cfqd->serving_prio, cfqd->serving_type);
> -		cfq_blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
> -		cfqq->slice_start = 0;
> -		cfqq->dispatch_start = jiffies;
> -		cfqq->allocated_slice = 0;
> -		cfqq->slice_end = 0;
> -		cfqq->slice_dispatch = 0;
> -		cfqq->nr_sectors = 0;
> -
> -		cfq_clear_cfqq_wait_request(cfqq);
> -		cfq_clear_cfqq_must_dispatch(cfqq);
> -		cfq_clear_cfqq_must_alloc_slice(cfqq);
> -		cfq_clear_cfqq_fifo_expire(cfqq);
> -		cfq_mark_cfqq_slice_new(cfqq);
> -
> -		cfq_del_timer(cfqd, cfqq);
> +		cfq_clear_queue_stats(cfqd, cfqq);
>  	}
>  
>  	cfqd->active_queue = cfqq;
> @@ -3332,7 +3338,8 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  	BUG_ON(!cfq_cfqq_on_rr(cfqq));
>  
>  	cfq_service_tree_add(cfqd, cfqq, 1);
> -	__cfq_set_active_queue(cfqd, cfqq);
> +
> +	cfq_clear_queue_stats(cfqd, cfqq);

Hi Justin,

Why do we have to clear queue stats here for the preempting queue?

Especially look at cfqq->dispatch_start = jiffies. We have not started
the dispatch yet. When this queue is selected next, then we will start
the dispatch.

So this patch has introduced another bug now. Now after preemption if
we don't select this group, then we have a queue with wrong dispatch
start and that will result in huge slice_used for the queue and
it will not get its fair share.

Thanks
Vivek
