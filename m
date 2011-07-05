Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1GEObs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:31:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab1GEObq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:31:46 -0400
Date: Tue, 5 Jul 2011 10:31:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 3/3]Subject: CFQ: add think time check for group
Message-ID: <20110705143144.GC24348@redhat.com>
References: <1309757796.15392.239.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309757796.15392.239.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 01:36:36PM +0800, Shaohua Li wrote:
> Subject: CFQ: add think time check for group
> 
> Currently when the last queue of a group has no request, we don't expire
> the queue to hope request from the group comes soon, so the group doesn't
> miss its share. But if the think time is big, the assumption isn't correct
> and we just waste bandwidth. In such case, we don't do idle.
> 
> [global]
> runtime=30
> direct=1
> 
> [test1]
> cgroup=test1
> cgroup_weight=1000
> rw=randread
> ioengine=libaio
> size=500m
> runtime=30
> directory=/mnt
> filename=file1
> thinktime=9000
> 
> [test2]
> cgroup=test2
> cgroup_weight=1000
> rw=randread
> ioengine=libaio
> size=500m
> runtime=30
> directory=/mnt
> filename=file2
> 
> 	patched		base
> test1	64k		39k
> test2	540k		540k
> total	604k		578k
> 
> group1 gets much better throughput because it waits less time.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  block/cfq-iosched.c |   19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> Index: linux/block/cfq-iosched.c
> ===================================================================
> --- linux.orig/block/cfq-iosched.c	2011-07-01 13:45:24.000000000 +0800
> +++ linux/block/cfq-iosched.c	2011-07-01 13:48:18.000000000 +0800
> @@ -215,6 +215,7 @@ struct cfq_group {
>  #endif
>  	/* number of requests that are on the dispatch list or inside driver */
>  	int dispatched;
> +	struct cfq_ttime ttime;
>  };
>  
>  /*
> @@ -1062,6 +1063,8 @@ static struct cfq_group * cfq_alloc_cfqg
>  		*st = CFQ_RB_ROOT;
>  	RB_CLEAR_NODE(&cfqg->rb_node);
>  
> +	cfqg->ttime.last_end_request = jiffies;
> +
>  	/*
>  	 * Take the initial reference that will be released on destroy
>  	 * This can be thought of a joint reference by cgroup and
> @@ -2385,8 +2388,9 @@ static struct cfq_queue *cfq_select_queu
>  	 * this group, wait for requests to complete.
>  	 */
>  check_group_idle:
> -	if (cfqd->cfq_group_idle && cfqq->cfqg->nr_cfqq == 1
> -	    && cfqq->cfqg->dispatched) {
> +	if (cfqd->cfq_group_idle && cfqq->cfqg->nr_cfqq == 1 &&
> +	    cfqq->cfqg->dispatched && !cfq_io_thinktime_big(cfqq->cfqg->ttime,
> +	    cfqd->cfq_group_idle)) {

Lets put the group think time check on new line to avoid splittling
function argument on two lines.

>  		cfqq = NULL;
>  		goto keep_queue;
>  	}
> @@ -3245,6 +3249,9 @@ cfq_update_io_thinktime(struct cfq_data
>  		__cfq_update_io_thinktime(&service_tree->ttime,
>  			cfqd->cfq_slice_idle);
>  	}
> +#ifdef CONFIG_CFQ_GROUP_IOSCHED
> +	__cfq_update_io_thinktime(&cfqg->ttime, cfqd->cfq_group_idle);
> +#endif
>  }
>  
>  static void
> @@ -3536,7 +3543,9 @@ static bool cfq_should_wait_busy(struct
>  	if (cfqq->cfqg->nr_cfqq > 1)
>  		return false;
>  
> -	if (cfq_slice_used(cfqq))
> +	/* we are the only queue in the group */
> +	if (cfq_slice_used(cfqq) &&
> +	    !cfq_io_thinktime_big(cfqq->cfqg->ttime, cfqd->cfq_group_idle))
>  		return true;

I think thinktime check should not be anded with slice_used() check. Slice
used check is about that we have been idling all along on queue and now
slice is used so we would like to wait a bit more for queue to get busy so
that group does not lose its share. Given the fact slice is used that 
means we have been idling on the queue and have been getting requests
regularly in the queue.

But group think time check should be applicable irrespective of the fact
whether we have used the slice or not. If thinktime of a group is big,
then we should just not wait for it to get busy because anyway group
idle timer will fire and expire the queue/group before that.

Thanks
Vivek
