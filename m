Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab1CVWTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:19:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1CVWTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:19:45 -0400
Date: Tue, 22 Mar 2011 18:19:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq-iosched: Don't clear queue stats when preempt.
Message-ID: <20110322221941.GC8080@redhat.com>
References: <1300832052-404-1-git-send-email-teravest@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300832052-404-1-git-send-email-teravest@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 03:14:12PM -0700, Justin TerAvest wrote:
> Previous commit "cfq-iosched: Don't set active queue in preempt" wrongly
> cleared stats for preempting queues when it shouldn't have, because when
> we choose a queue to preempt, it still isn't necessarily scheduled next.
> 
> Thanks to Vivek Goyal for figuring this out and understanding how the
> preemption code works.
> 
> Signed-off-by: Justin TerAvest <teravest@google.com>
> ---
>  block/cfq-iosched.c |   38 +++++++++++++++-----------------------
>  1 files changed, 15 insertions(+), 23 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 69208d7..efa1f30 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1620,33 +1620,27 @@ static inline void cfq_del_timer(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  	cfq_blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
>  }
>  
> -static void cfq_clear_queue_stats(struct cfq_data *cfqd,
> -				  struct cfq_queue *cfqq)
> -{
> -	cfq_blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
> -	cfqq->slice_start = 0;
> -	cfqq->dispatch_start = jiffies;
> -	cfqq->allocated_slice = 0;
> -	cfqq->slice_end = 0;
> -	cfqq->slice_dispatch = 0;
> -	cfqq->nr_sectors = 0;
> -
> -	cfq_clear_cfqq_wait_request(cfqq);
> -	cfq_clear_cfqq_must_dispatch(cfqq);
> -	cfq_clear_cfqq_must_alloc_slice(cfqq);
> -	cfq_clear_cfqq_fifo_expire(cfqq);
> -	cfq_mark_cfqq_slice_new(cfqq);
> -
> -	cfq_del_timer(cfqd, cfqq);
> -}
> -
>  static void __cfq_set_active_queue(struct cfq_data *cfqd,
>  				   struct cfq_queue *cfqq)
>  {
>  	if (cfqq) {
>  		cfq_log_cfqq(cfqd, cfqq, "set_active wl_prio:%d wl_type:%d",
>  				cfqd->serving_prio, cfqd->serving_type);
> -		cfq_clear_queue_stats(cfqd, cfqq);
> +		cfq_blkiocg_update_avg_queue_size_stats(&cfqq->cfqg->blkg);
> +		cfqq->slice_start = 0;
> +		cfqq->dispatch_start = jiffies;
> +		cfqq->allocated_slice = 0;
> +		cfqq->slice_end = 0;
> +		cfqq->slice_dispatch = 0;
> +		cfqq->nr_sectors = 0;
> +
> +		cfq_clear_cfqq_wait_request(cfqq);
> +		cfq_clear_cfqq_must_dispatch(cfqq);
> +		cfq_clear_cfqq_must_alloc_slice(cfqq);
> +		cfq_clear_cfqq_fifo_expire(cfqq);
> +		cfq_mark_cfqq_slice_new(cfqq);
> +
> +		cfq_del_timer(cfqd, cfqq);
>  	}
>  
>  	cfqd->active_queue = cfqq;
> @@ -3338,8 +3332,6 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  	BUG_ON(!cfq_cfqq_on_rr(cfqq));
>  
>  	cfq_service_tree_add(cfqd, cfqq, 1);
> -
> -	cfq_clear_queue_stats(cfqd, cfqq);
>  }

Can you restore the old following two lines.

        cfqq->slice_end = 0;
        cfq_mark_cfqq_slice_new(cfqq);

It is just to preserve the old behavior. Thought off the top of my head I 
am not sure why these are there. So until somebody has studied it and 
figured it out whether these are required or not, let these be there.

Thanks
Vivek
