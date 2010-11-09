Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0KIC0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 21:26:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab0KIC0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 21:26:11 -0500
Date: Mon, 8 Nov 2010 21:26:07 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>
Subject: Re: [patch 2/3]cfq-iosched: schedule dispatch for noidle queue
Message-ID: <20101109022607.GB29210@redhat.com>
References: <1289182038.23014.190.camel@sli10-conroe>
 <20101108142842.GC16767@redhat.com>
 <1289266267.23014.196.camel@sli10-conroe>
 <20101109021540.GA29210@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109021540.GA29210@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 09:15:40PM -0500, Vivek Goyal wrote:
> On Tue, Nov 09, 2010 at 09:31:07AM +0800, Shaohua Li wrote:
> > On Mon, 2010-11-08 at 22:28 +0800, Vivek Goyal wrote:
> > > On Mon, Nov 08, 2010 at 10:07:18AM +0800, Shaohua Li wrote:
> > > > A queue is idle at cfq_dispatch_requests(), but it gets noidle later. Unless
> > > > other task explictly does unplug or all requests are drained, we will not
> > > > deliever requests to the disk even cfq_arm_slice_timer doesn't make the
> > > > queue idle. For example, cfq_should_idle() returns true because of
> > > > service_tree->count == 1, and then other queues are added. Note, I didn't
> > > > see obvious performance impacts so far with the patch, but just thought
> > > > this could be a problem.
> > > > 
> > > > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > > > 
> > > > ---
> > > >  block/cfq-iosched.c |   23 ++++++++++++++++++++++-
> > > >  1 file changed, 22 insertions(+), 1 deletion(-)
> > > > 
> > > > Index: linux/block/cfq-iosched.c
> > > > ===================================================================
> > > > --- linux.orig/block/cfq-iosched.c	2010-11-08 08:41:20.000000000 +0800
> > > > +++ linux/block/cfq-iosched.c	2010-11-08 08:43:51.000000000 +0800
> > > > @@ -3265,6 +3265,10 @@ cfq_should_preempt(struct cfq_data *cfqd
> > > >  	if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cfqq))
> > > >  		return true;
> > > >  
> > > > +	/* An idle queue should not be idle now for some reason */
> > > > +	if (RB_EMPTY_ROOT(&cfqq->sort_list) && !cfq_should_idle(cfqd, cfqq))
> > > > +		return true;
> > > > +
> > > >  	if (!cfqd->active_cic || !cfq_cfqq_wait_request(cfqq))
> > > >  		return false;
> > > >  
> > > > @@ -3508,8 +3512,25 @@ static void cfq_completed_request(struct
> > > >  		}
> > > >  	}
> > > >  
> > > > -	if (!cfqd->rq_in_driver)
> > > > +	if (!cfqd->rq_in_driver) {
> > > >  		cfq_schedule_dispatch(cfqd);
> > > > +		return;
> > > > +	}
> > > > +	/*
> > > > +	 * A queue is idle at cfq_dispatch_requests(), but it gets noidle
> > > > +	 * later. We schedule a dispatch if the queue has no requests,
> > > > +	 * otherwise the disk is actually in idle till all requests
> > > > +	 * are finished even cfq_arm_slice_timer doesn't make the queue idle
> > > > +	 * */
> > > 
> > > Why do we have to wait for all requests to finish in device? Will driver
> > > most likely not ask for next request when 1-2 requests have completed
> > > and at that time we should expire the queue if queue is no more marked
> > > as "noidle"?
> > The issue is a queue is idle just because it's the last queue of the
> > service tree. Then a new queue is added and the idled queue should not
> > idle now. we should preempt the idled queue soon. does this make sense
> > to you?
> 
> If that's the case then you should just modify should_preempt() so that
> addition of a new queue could preempt an empty queue which has now become
> noidle.
> 
> You have also modified cfq_completed_request() function, which will wake
> up the worker thread and then try to dispatch a request. IMHO, in practice
> driver asks for new request almost immediately and you don't gain much
> by this additional wakeup.
> 
> So my point being, that we increased the code complexity for no visible
> performance improvement also increased thread wakeups resulting in more
> cpu consumption.
> 
> If there was a visible performance gain in your testing then it would have
> made sense but you said that you did not notice any improvements. Then
> why to increase the complexity.

Thinking more about it. I suspect modification to cfq_completed_request()
is a dead code. In the sense, status of a queue will change from idle to
noidle, when a new request comes in (for most of the cases). If that's
the case then we don't have to modify cfq_completed_request() code at
all. An extra condition in cfq_should_preempt() should cover the case of
preempting the existing empty queue which is noidle.

Can you give me an example in what cases cfq_completed_request() will
really wake up the thread which will result in early dispatch of request
then it would have been if we relied on driver asking for next request.
One such example could be that somebody set slice_idle=0 but that's one
time event and I really don't think we should be optimizing for that 
corner case.

Thanks
Vivek
