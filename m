Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1GEOKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:10:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab1GEOKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:10:44 -0400
Date: Tue, 5 Jul 2011 10:10:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 2/3]CFQ: add think time check for service tree
Message-ID: <20110705141041.GB24348@redhat.com>
References: <1309757794.15392.238.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309757794.15392.238.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 01:36:34PM +0800, Shaohua Li wrote:
> Subject: CFQ: add think time check for service tree
> 
> Currently when the last queue of a service tree has no request, we don't
> expire the queue to hope request from the service tree comes soon, so the
> service tree doesn't miss its share. But if the think time is big, the
> assumption isn't correct and we just waste bandwidth. In such case, we
> don't do idle.
> 
> [global]
> runtime=10
> direct=1
> 
> [test1]
> rw=randread
> ioengine=libaio
> size=500m
> directory=/mnt
> filename=file1
> thinktime=9000
> 
> [test2]
> rw=read
> ioengine=libaio
> size=1G
> directory=/mnt
> filename=file2
> 
> 	patched		base
> test1	41k/s		33k/s
> test2	15868k/s	15789k/s
> total	15902k/s	15817k/s
> 
> A slightly better
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> ---
>  block/cfq-iosched.c |   26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
> 
> Index: linux/block/cfq-iosched.c
> ===================================================================
> --- linux.orig/block/cfq-iosched.c	2011-07-01 13:43:34.000000000 +0800
> +++ linux/block/cfq-iosched.c	2011-07-01 13:45:24.000000000 +0800
> @@ -74,6 +74,8 @@ static DEFINE_IDA(cic_index_ida);
>  
>  #define sample_valid(samples)	((samples) > 80)
>  #define rb_entry_cfqg(node)	rb_entry((node), struct cfq_group, rb_node)
> +#define cfq_io_thinktime_big(ttime, slice) \
> +	(sample_valid((ttime).ttime_samples) && (ttime).ttime_mean > (slice))
>  

I think instead of a macro, a inline function to check this will be better.
Also you don't have to pass slice_idle value as parameter as funciton
can directly access it from cfqd.

>  /*
>   * Most of our rbtree usage is for sorting with min extraction, so
> @@ -87,9 +89,10 @@ struct cfq_rb_root {
>  	unsigned count;
>  	unsigned total_weight;
>  	u64 min_vdisktime;
> +	struct cfq_ttime ttime;
>  };
> -#define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
> -			.count = 0, .min_vdisktime = 0, }
> +#define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, \
> +			.ttime = {.last_end_request = jiffies,},}
>  
>  /*
>   * Per process-grouping structure
> @@ -1969,7 +1972,8 @@ static bool cfq_should_idle(struct cfq_d
>  	 * Otherwise, we do only if they are the last ones
>  	 * in their service tree.
>  	 */
> -	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq))
> +	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq) &&
> +	   !cfq_io_thinktime_big(service_tree->ttime, cfqd->cfq_slice_idle))
>  		return true;
>  	cfq_log_cfqq(cfqd, cfqq, "Not idling. st->count:%d",
>  			service_tree->count);
> @@ -3231,8 +3235,16 @@ static void
>  cfq_update_io_thinktime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  	struct cfq_io_context *cic)
>  {
> -	if (cfq_cfqq_sync(cfqq))
> +	struct cfq_rb_root *service_tree;
> +	struct cfq_group *cfqg = cfqq->cfqg;
> +
> +	if (cfq_cfqq_sync(cfqq)) {
>  		__cfq_update_io_thinktime(&cic->ttime, cfqd->cfq_slice_idle);
> +		service_tree = service_tree_for(cfqg, cfqq_prio(cfqq),
> +			cfqq_type(cfqq));

I think by now cfqq is already on the service tree and cfqq->service_tree
should be set. So we should be able to just acess that instead of calling
service_tree_for().

I have noticed that cfqq might be queued on one service tree but we can
change the idling on queue and cfqq_type() can return a different value
and different service tree. So trying to avoid use of service_tree_for()
when cfqq is already on a service tree should be good.

> +		__cfq_update_io_thinktime(&service_tree->ttime,
> +			cfqd->cfq_slice_idle);
> +	}
>  }
>  
>  static void
> @@ -3570,7 +3582,13 @@ static void cfq_completed_request(struct
>  	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
>  
>  	if (sync) {
> +		struct cfq_rb_root *service_tree;
> +
>  		RQ_CIC(rq)->ttime.last_end_request = now;
> +
> +		service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
> +			cfqq_type(cfqq));

Ditto.

> +		service_tree->ttime.last_end_request = now;
>  		if (!time_after(rq->start_time + cfqd->cfq_fifo_expire[1], now))
>  			cfqd->last_delayed_sync = now;
>  	}
> 

Thanks
Vivek
