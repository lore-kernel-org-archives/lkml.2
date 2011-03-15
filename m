Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab1COP4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 11:56:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758076Ab1COP4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 11:56:20 -0400
Date: Tue, 15 Mar 2011 11:56:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH]cfq-iosched: removing unnecessary think time checking
Message-ID: <20110315155613.GA2587@redhat.com>
References: <1300157851.2337.78.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300157851.2337.78.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 10:57:31AM +0800, Shaohua Li wrote:
> Removing think time checking. A high thinktime queue might means the queue
> dispatches several requests and then do away. Limitting such queue seems
> meaningless. And also this can simplify code. This is suggested by Vivek.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

I really can't find a relation between why should we allow unlimited
dispatch only for low thinktime queues and not for high thinktime queue.

concern here is that due to preemtion it can happen that async IO is
starved. I think high think time queue automatically mitigates that
up to some extent that there will be time interval when async IO will
get time to dispatch.

If we run into issues of sync starving async, then it should probably
controlled by not giving unlimited queue depth to sync but by limiting
it to some higher number.

Thanks
Vivek

> ---
>  block/cfq-iosched.c |   13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> Index: linux/block/cfq-iosched.c
> ===================================================================
> --- linux.orig/block/cfq-iosched.c	2011-03-10 13:52:13.000000000 +0800
> +++ linux/block/cfq-iosched.c	2011-03-10 13:53:08.000000000 +0800
> @@ -2418,19 +2418,14 @@ static bool cfq_may_dispatch(struct cfq_
>  			return false;
>  
>  		/*
> -		 * If there is only one sync queue, and its think time is
> -		 * small, we can ignore async queue here and give the sync
> +		 * If there is only one sync queue
> +		 * we can ignore async queue here and give the sync
>  		 * queue no dispatch limit. The reason is a sync queue can
>  		 * preempt async queue, limiting the sync queue doesn't make
>  		 * sense. This is useful for aiostress test.
>  		 */
> -		if (cfq_cfqq_sync(cfqq) && cfqd->busy_sync_queues == 1) {
> -			struct cfq_io_context *cic = RQ_CIC(cfqq->next_rq);
> -
> -			if (sample_valid(cic->ttime_samples) &&
> -				cic->ttime_mean < cfqd->cfq_slice_idle)
> -				promote_sync = true;
> -		}
> +		if (cfq_cfqq_sync(cfqq) && cfqd->busy_sync_queues == 1)
> +			promote_sync = true;
>  
>  		/*
>  		 * We have other queues, don't allow more IO from this one
> 
