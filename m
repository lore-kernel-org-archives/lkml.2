Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0KHOCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:02:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701Ab0KHOCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:02:06 -0500
Date: Mon, 8 Nov 2010 09:02:03 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        czoccolo@gmail.com
Subject: Re: [patch 2/3]cfq-iosched: schedule dispatch for noidle queue
Message-ID: <20101108140202.GA16767@redhat.com>
References: <1289182038.23014.190.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289182038.23014.190.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 10:07:18AM +0800, Shaohua Li wrote:
> A queue is idle at cfq_dispatch_requests(), but it gets noidle later. Unless
> other task explictly does unplug or all requests are drained, we will not
> deliever requests to the disk even cfq_arm_slice_timer doesn't make the
> queue idle. For example, cfq_should_idle() returns true because of
> service_tree->count == 1, and then other queues are added. Note, I didn't
> see obvious performance impacts so far with the patch, but just thought
> this could be a problem.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Hi Shaohua,

I am unable to understand what problem are you solving here. So a queue
currently has property as "idle" and we idle on that. And then some event
happens which makes it "noidle". What is that event?

To my knowledge generally it is arrival of a new request. If that's the case,
then upon arrival of new request in same queue, we will dispatch it and then
when device asks for more request, we should be expering the cfqq and dispatch
requests from other queues.

So I am really not sure what's the problem here which you are trying to 
fix. Can you give more details.

Vivek

 

> 
> ---
>  block/cfq-iosched.c |   23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> Index: linux/block/cfq-iosched.c
> ===================================================================
> --- linux.orig/block/cfq-iosched.c	2010-11-08 08:41:20.000000000 +0800
> +++ linux/block/cfq-iosched.c	2010-11-08 08:43:51.000000000 +0800
> @@ -3265,6 +3265,10 @@ cfq_should_preempt(struct cfq_data *cfqd
>  	if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cfqq))
>  		return true;
>  
> +	/* An idle queue should not be idle now for some reason */
> +	if (RB_EMPTY_ROOT(&cfqq->sort_list) && !cfq_should_idle(cfqd, cfqq))
> +		return true;
> +
>  	if (!cfqd->active_cic || !cfq_cfqq_wait_request(cfqq))
>  		return false;
>  
> @@ -3508,8 +3512,25 @@ static void cfq_completed_request(struct
>  		}
>  	}
>  
> -	if (!cfqd->rq_in_driver)
> +	if (!cfqd->rq_in_driver) {
>  		cfq_schedule_dispatch(cfqd);
> +		return;
> +	}
> +	/*
> +	 * A queue is idle at cfq_dispatch_requests(), but it gets noidle
> +	 * later. We schedule a dispatch if the queue has no requests,
> +	 * otherwise the disk is actually in idle till all requests
> +	 * are finished even cfq_arm_slice_timer doesn't make the queue idle
> +	 * */
> +	cfqq = cfqd->active_queue;
> +	if (!cfqq)
> +		return;
> +
> +	if (RB_EMPTY_ROOT(&cfqq->sort_list) && !cfq_should_idle(cfqd, cfqq) &&
> +	    (!cfqd->cfq_group_idle || cfqq->cfqg->nr_cfqq > 1)) {
> +		cfq_del_timer(cfqd, cfqq);
> +		cfq_schedule_dispatch(cfqd);
> +	}
>  }
>  
>  /*
> 
