Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0ITOCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:02:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811Ab0ITOCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:02:45 -0400
Date: Mon, 20 Sep 2010 10:02:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, jaxboe@fusionio.com,
        czoccolo@gmail.com
Subject: Re: [patch]cfq-iosched: schedule dispatch for noidle queue
Message-ID: <20100920140242.GD6138@redhat.com>
References: <1284972817.6598.19.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284972817.6598.19.camel@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 04:53:37PM +0800, Shaohua Li wrote:
> A queue is idle at cfq_dispatch_requests(), but it gets noidle later for
> different reasons. Unless other task explictly does unplug or all requests
> are drained, we will not deliever requests to the disk even cfq_arm_slice_timer
> doesn't make the queue idle. For example, cfq_should_idle() returns true
> because of service_tree->count == 1, and then other queues are added.
> Note, I didn't see obvious performance impacts so far with the patch, but
> just thought this could be a problem.
> 

Shaohua Li,

What are those reasons when an idling queue becomes a non idle one
(without getting a new request in the queue)?

Vivek

> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> ---
>  block/cfq-iosched.c |   23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/block/cfq-iosched.c
> ===================================================================
> --- linux-2.6.orig/block/cfq-iosched.c	2010-09-21 00:20:46.000000000 +0800
> +++ linux-2.6/block/cfq-iosched.c	2010-09-21 00:22:58.000000000 +0800
> @@ -3256,6 +3256,10 @@
>  	if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cfqq))
>  		return true;
>  
> +	/* An idle queue should not be idle now for different reasons */
> +	if (RB_EMPTY_ROOT(&cfqq->sort_list) && !cfq_should_idle(cfqd, cfqq))
> +		return true;
> +
>  	if (!cfqd->active_cic || !cfq_cfqq_wait_request(cfqq))
>  		return false;
>  
> @@ -3509,8 +3513,25 @@
>  		}
>  	}
>  
> -	if (!cfqd->rq_in_driver)
> +	if (!cfqd->rq_in_driver) {
> +		cfq_schedule_dispatch(cfqd);
> +		return;
> +	}
> +	/*
> +	 * A queue is idle at cfq_dispatch_requests(), but it gets noidle later
> +	 * for different reasons. We schedule a dispatch if the queue has no
> +	 * requests, otherwise the disk is actually in idle till all requests
> +	 * are finished even cfq_arm_slice_timer doesn't make the queue idle
> +	 * */
> +	cfqq = cfqd->active_queue;
> +	if (!cfqq)
> +		return;
> +
> +	if (RB_EMPTY_ROOT(&cfqq->sort_list) && !cfq_should_idle(cfqd, cfqq) &&
> +	    (!cfqd->cfq_group_idle || cfqq->cfqg->nr_cfqq > 1)) {
> +		cfq_del_timer(cfqd, cfqq);
>  		cfq_schedule_dispatch(cfqd);
> +	}
>  }
>  
>  /*
> 
