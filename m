Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0KIBbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:31:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:24186 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab0KIBbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:31:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,172,1288594800"; 
   d="scan'208";a="624826067"
Subject: Re: [patch 2/3]cfq-iosched: schedule dispatch for noidle queue
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>
In-Reply-To: <20101108142842.GC16767@redhat.com>
References: <1289182038.23014.190.camel@sli10-conroe>
	 <20101108142842.GC16767@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 09:31:07 +0800
Message-ID: <1289266267.23014.196.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 22:28 +0800, Vivek Goyal wrote:
> On Mon, Nov 08, 2010 at 10:07:18AM +0800, Shaohua Li wrote:
> > A queue is idle at cfq_dispatch_requests(), but it gets noidle later. Unless
> > other task explictly does unplug or all requests are drained, we will not
> > deliever requests to the disk even cfq_arm_slice_timer doesn't make the
> > queue idle. For example, cfq_should_idle() returns true because of
> > service_tree->count == 1, and then other queues are added. Note, I didn't
> > see obvious performance impacts so far with the patch, but just thought
> > this could be a problem.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > 
> > ---
> >  block/cfq-iosched.c |   23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> > 
> > Index: linux/block/cfq-iosched.c
> > ===================================================================
> > --- linux.orig/block/cfq-iosched.c	2010-11-08 08:41:20.000000000 +0800
> > +++ linux/block/cfq-iosched.c	2010-11-08 08:43:51.000000000 +0800
> > @@ -3265,6 +3265,10 @@ cfq_should_preempt(struct cfq_data *cfqd
> >  	if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cfqq))
> >  		return true;
> >  
> > +	/* An idle queue should not be idle now for some reason */
> > +	if (RB_EMPTY_ROOT(&cfqq->sort_list) && !cfq_should_idle(cfqd, cfqq))
> > +		return true;
> > +
> >  	if (!cfqd->active_cic || !cfq_cfqq_wait_request(cfqq))
> >  		return false;
> >  
> > @@ -3508,8 +3512,25 @@ static void cfq_completed_request(struct
> >  		}
> >  	}
> >  
> > -	if (!cfqd->rq_in_driver)
> > +	if (!cfqd->rq_in_driver) {
> >  		cfq_schedule_dispatch(cfqd);
> > +		return;
> > +	}
> > +	/*
> > +	 * A queue is idle at cfq_dispatch_requests(), but it gets noidle
> > +	 * later. We schedule a dispatch if the queue has no requests,
> > +	 * otherwise the disk is actually in idle till all requests
> > +	 * are finished even cfq_arm_slice_timer doesn't make the queue idle
> > +	 * */
> 
> Why do we have to wait for all requests to finish in device? Will driver
> most likely not ask for next request when 1-2 requests have completed
> and at that time we should expire the queue if queue is no more marked
> as "noidle"?
The issue is a queue is idle just because it's the last queue of the
service tree. Then a new queue is added and the idled queue should not
idle now. we should preempt the idled queue soon. does this make sense
to you?

Thanks,
Shaohua

