Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab0KICjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 21:39:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab0KICjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 21:39:24 -0500
Date: Mon, 8 Nov 2010 21:39:20 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>
Subject: Re: [patch 2/3]cfq-iosched: schedule dispatch for noidle queue
Message-ID: <20101109023919.GB29847@redhat.com>
References: <1289182038.23014.190.camel@sli10-conroe>
 <20101108142842.GC16767@redhat.com>
 <1289266267.23014.196.camel@sli10-conroe>
 <20101109021540.GA29210@redhat.com>
 <1289269716.23014.208.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289269716.23014.208.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 10:28:36AM +0800, Shaohua Li wrote:

[..]
> > > > Why do we have to wait for all requests to finish in device? Will driver
> > > > most likely not ask for next request when 1-2 requests have completed
> > > > and at that time we should expire the queue if queue is no more marked
> > > > as "noidle"?
> > > The issue is a queue is idle just because it's the last queue of the
> > > service tree. Then a new queue is added and the idled queue should not
> > > idle now. we should preempt the idled queue soon. does this make sense
> > > to you?
> > 
> > If that's the case then you should just modify should_preempt() so that
> > addition of a new queue could preempt an empty queue which has now become
> > noidle.
> > 
> > You have also modified cfq_completed_request() function, which will wake
> > up the worker thread and then try to dispatch a request. IMHO, in practice
> > driver asks for new request almost immediately and you don't gain much
> > by this additional wakeup.
> > 
> > So my point being, that we increased the code complexity for no visible
> > performance improvement also increased thread wakeups resulting in more
> > cpu consumption.
> Ah, you are right, we only need modify should_preempt. Updated the patch as below.
> 

Thanks. Jens has already applied the patches on for-2.6.38/core branch of
block tree. I think you shall have to generate an incremental patch
which revert the bits introduced in cfq_completed_request().

Thanks
Vivek

> > If there was a visible performance gain in your testing then it would have
> > made sense but you said that you did not notice any improvements. Then
> > why to increase the complexity.
> I only test some workloads and can't do all tests, but this is an
> obvious bug I thought.
> 
> Thanks,
> Shaohua
> 
> Subject: cfq-iosched: preempt an idle queue if it should not be idle any more
> 
> A queue is idle at cfq_dispatch_requests(), but it gets noidle later. Unless
> other task explictly does unplug or all requests are drained, we will not
> deliever requests to the disk even cfq_arm_slice_timer doesn't make the
> queue idle. For example, cfq_should_idle() returns true because of
> service_tree->count == 1, and then other queues are added. Note, I didn't
> see obvious performance impacts so far with the patch, but just thought
> this could be a problem.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> ---
>  block/cfq-iosched.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux/block/cfq-iosched.c
> ===================================================================
> --- linux.orig/block/cfq-iosched.c	2010-11-09 10:20:38.000000000 +0800
> +++ linux/block/cfq-iosched.c	2010-11-09 10:20:54.000000000 +0800
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
> 
> 
