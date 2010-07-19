Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966687Ab0GSUUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 16:20:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966644Ab0GSUUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 16:20:35 -0400
Date: Mon, 19 Jul 2010 16:20:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, czoccolo@gmail.com
Subject: Re: [PATCH 2/3] cfq-iosched: Implement a new tunable group_idle
Message-ID: <20100719202024.GD32503@redhat.com>
References: <1279560008-2905-1-git-send-email-vgoyal@redhat.com>
 <1279560008-2905-3-git-send-email-vgoyal@redhat.com>
 <x49iq4bti1q.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49iq4bti1q.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 02:58:41PM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > o Implement a new tunable group_idle, which allows idling on the group
> >   instead of a cfq queue. Hence one can set slice_idle = 0 and not idle
> >   on the individual queues but idle on the group. This way on fast storage
> >   we can get fairness between groups at the same time overall throughput
> >   improves.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  block/cfq-iosched.c |   60 +++++++++++++++++++++++++++++++++++++++++++++------
> >  1 files changed, 53 insertions(+), 7 deletions(-)
> >
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index f44064c..b23d7f4 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -30,6 +30,7 @@ static const int cfq_slice_sync = HZ / 10;
> >  static int cfq_slice_async = HZ / 25;
> >  static const int cfq_slice_async_rq = 2;
> >  static int cfq_slice_idle = HZ / 125;
> > +static int cfq_group_idle = HZ / 125;
> >  static const int cfq_target_latency = HZ * 3/10; /* 300 ms */
> >  static const int cfq_hist_divisor = 4;
> >  
> > @@ -198,6 +199,8 @@ struct cfq_group {
> >  	struct hlist_node cfqd_node;
> >  	atomic_t ref;
> >  #endif
> > +	/* number of requests that are on the dispatch list or inside driver */
> > +	int dispatched;
> >  };
> >  
> >  /*
> > @@ -271,6 +274,7 @@ struct cfq_data {
> >  	unsigned int cfq_slice[2];
> >  	unsigned int cfq_slice_async_rq;
> >  	unsigned int cfq_slice_idle;
> > +	unsigned int cfq_group_idle;
> >  	unsigned int cfq_latency;
> >  	unsigned int cfq_group_isolation;
> >  
> > @@ -1856,6 +1860,9 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> >  	BUG_ON(!service_tree);
> >  	BUG_ON(!service_tree->count);
> >  
> > +	if (!cfqd->cfq_slice_idle)
> > +		return false;
> > +
> >  	/* We never do for idle class queues. */
> >  	if (prio == IDLE_WORKLOAD)
> >  		return false;
> > @@ -1880,7 +1887,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
> >  {
> >  	struct cfq_queue *cfqq = cfqd->active_queue;
> >  	struct cfq_io_context *cic;
> > -	unsigned long sl;
> > +	unsigned long sl, group_idle = 0;
> >  
> >  	/*
> >  	 * SSD device without seek penalty, disable idling. But only do so
> > @@ -1896,8 +1903,13 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
> >  	/*
> >  	 * idle is disabled, either manually or by past process history
> >  	 */
> > -	if (!cfqd->cfq_slice_idle || !cfq_should_idle(cfqd, cfqq))
> > -		return;
> > +	if (!cfqd->cfq_slice_idle || !cfq_should_idle(cfqd, cfqq)) {
> 
> The check for cfqd->cfq_slice_idle is now redundant (as it's done in
> cfq_should_idle).

Yep. I will get rid of extra check.

> 
> > @@ -2215,7 +2236,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
> >  			cfqq = NULL;
> >  			goto keep_queue;
> >  		} else
> > -			goto expire;
> > +			goto check_group_idle;
> >  	}
> >  
> >  	/*
> > @@ -2249,6 +2270,17 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
> >  		goto keep_queue;
> >  	}
> >  
> > +	/*
> > +	 * If group idle is enabled and there are requests dispatched from
> > +	 * this group, wait for requests to complete.
> > +	 */
> > +check_group_idle:
> > +	if (cfqd->cfq_group_idle && cfqq->cfqg->nr_cfqq == 1
> > +	    && cfqq->cfqg->dispatched) {
> > +		cfqq = NULL;
> > +		goto keep_queue;
> > +	}
> 
> I really wish we could roll all of this logic into cfq_should_idle.

Currently whether to idle on queue or not logic is also part of select_queue().
So to keep it same it makes sense to keep group logic also in select_queue().

> 
> > @@ -3420,7 +3453,10 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
> >  		 * the queue.
> >  		 */
> >  		if (cfq_should_wait_busy(cfqd, cfqq)) {
> > -			cfqq->slice_end = jiffies + cfqd->cfq_slice_idle;
> > +			unsigned long extend_sl = cfqd->cfq_slice_idle;
> > +			if (!cfqd->cfq_slice_idle)
> > +				extend_sl = cfqd->cfq_group_idle;
> > +			cfqq->slice_end = jiffies + extend_sl;
> 
> So, if slice_idle and group_idle are both set, slice_idle trumps
> group_idle?  Did you give that case any thought?  If it doesn't make
> sense to configure both, then we should probably make sure they can't
> both be set.

Actually, the wait busy logic makes sense in case of slice_idle, where we
can give an extended slice to a queue and to make sure a queue/group does
not get deleted immediately after completing the slice and hence losing
the share.

Now in case of slice_idle=0, if there is only one queue in the group then
it becomes the same case as one queue in the group with slice_idle=8.

So yes, slice_idle trumps group_idle. group_idle kicks in only if
slice_idle=0. I think by default it being set it does not harm. What good
it will do if slice_idle=8 and group_idle=0. Instead it will become
more work for user to also set one more tunable if he plans to set
slice_idle=0.

Thanks
Vivek



> 
> Cheers,
> Jeff
