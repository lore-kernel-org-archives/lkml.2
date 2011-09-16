Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab1IPJzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:55:05 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:39839 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751179Ab1IPJzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:55:03 -0400
Message-ID: <4E731CEB.2010909@tao.ma>
Date: Fri, 16 Sep 2011 17:54:51 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        Maxim Patlasov <maxim.patlasov@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [patch]cfq-iosched: delete deep seeky queue idle logic
References: <1316142577.29510.130.camel@sli10-conroe>
In-Reply-To: <1316142577.29510.130.camel@sli10-conroe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shaohua,
On 09/16/2011 11:09 AM, Shaohua Li wrote:
> Recently Maxim and I discussed why his aiostress workload performs poorly. If
> you didn't follow the discussion, here are the issues we found:
> 1. cfq seeky dection isn't good. Assume a task accesses sector A, B, C, D, A+1,
> B+1, C+1, D+1, A+2...Accessing A, B, C, D is random. cfq will detect the queue
> as seeky, but since when accessing A+1, A+1 is already in disk cache, this
> should be detected as sequential really. Not sure if any real workload has such
> access patern, and seems not easy to have a clean fix too. Any idea for this?
This year's FAST has a paper named "A Scheduling Framework That Makes
Any Disk Schedulers Non-Work-Conserving Solely Based on Request
Characteristics". It has described this situation and suggests a new
scheduler named "stream scheduler" to resolve this. But I am not sure
whether CFQ can work like that or not.

Thanks
Tao
> 
> 2. deep seeky queue idle. This makes raid performs poorly. I would think we
> revert the logic. Deep queue is more popular with high end hardware. In such
> hardware, we'd better not do idle.
> Note, currently we set a queue's slice after the first request is finished.
> This means the drive already idles a little time. If the queue is truely deep,
> new requests should already come in, so idle isn't required.
> Looks Vivek used to post a patch to rever it, but it gets ignored.
> http://us.generation-nt.com/patch-cfq-iosched-revert-logic-deep-queues-help-198339681.html
> 
> Signed-off-by: Shaohua Li<shaohua.li@intel.com>
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index a33bd43..f75439e 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -334,7 +334,6 @@ enum cfqq_state_flags {
>  	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
>  	CFQ_CFQQ_FLAG_coop,		/* cfqq is shared */
>  	CFQ_CFQQ_FLAG_split_coop,	/* shared cfqq will be splitted */
> -	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
>  	CFQ_CFQQ_FLAG_wait_busy,	/* Waiting for next request */
>  };
>  
> @@ -363,7 +362,6 @@ CFQ_CFQQ_FNS(slice_new);
>  CFQ_CFQQ_FNS(sync);
>  CFQ_CFQQ_FNS(coop);
>  CFQ_CFQQ_FNS(split_coop);
> -CFQ_CFQQ_FNS(deep);
>  CFQ_CFQQ_FNS(wait_busy);
>  #undef CFQ_CFQQ_FNS
>  
> @@ -2375,17 +2373,6 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
>  		goto keep_queue;
>  	}
>  
> -	/*
> -	 * This is a deep seek queue, but the device is much faster than
> -	 * the queue can deliver, don't idle
> -	 **/
> -	if (CFQQ_SEEKY(cfqq) && cfq_cfqq_idle_window(cfqq) &&
> -	    (cfq_cfqq_slice_new(cfqq) ||
> -	    (cfqq->slice_end - jiffies > jiffies - cfqq->slice_start))) {
> -		cfq_clear_cfqq_deep(cfqq);
> -		cfq_clear_cfqq_idle_window(cfqq);
> -	}
> -
>  	if (cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
>  		cfqq = NULL;
>  		goto keep_queue;
> @@ -3298,13 +3285,10 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  
>  	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
>  
> -	if (cfqq->queued[0] + cfqq->queued[1] >= 4)
> -		cfq_mark_cfqq_deep(cfqq);
> -
>  	if (cfqq->next_rq && (cfqq->next_rq->cmd_flags & REQ_NOIDLE))
>  		enable_idle = 0;
>  	else if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
> -	    (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
> +	    CFQQ_SEEKY(cfqq))
>  		enable_idle = 0;
>  	else if (sample_valid(cic->ttime.ttime_samples)) {
>  		if (cic->ttime.ttime_mean > cfqd->cfq_slice_idle)
> @@ -3874,11 +3858,6 @@ static void cfq_idle_slice_timer(unsigned long data)
>  		 */
>  		if (!RB_EMPTY_ROOT(&cfqq->sort_list))
>  			goto out_kick;
> -
> -		/*
> -		 * Queue depth flag is reset only when the idle didn't succeed
> -		 */
> -		cfq_clear_cfqq_deep(cfqq);
>  	}
>  expire:
>  	cfq_slice_expired(cfqd, timed_out);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

