Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965937Ab0GSS6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:58:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965095Ab0GSS6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:58:39 -0400
Date: Mon, 19 Jul 2010 14:58:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, czoccolo@gmail.com
Subject: Re: [PATCH 1/3] cfq-iosched: Improve time slice charging logic
Message-ID: <20100719185828.GB32503@redhat.com>
References: <1279560008-2905-1-git-send-email-vgoyal@redhat.com>
 <1279560008-2905-2-git-send-email-vgoyal@redhat.com>
 <x49mxtntikn.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49mxtntikn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 02:47:20PM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > - Currently in CFQ there are many situations where don't know how
> >   much time slice has been consumed by a queue. For example, all
> >   the random reader/writer queues where we don't idle on
> >   individual queues and we expire the queue either immediately
> >   after the request dispatch.
> >
> > - In this case time consumed by a queue is just a memory copy
> >   operation. Actually time measurement is possible only if we
> >   idle on a queue and allow dispatch from a queue for significant
> >   amount of time.
> >
> > - As of today, in such cases we calculate the time since the
> >   dispatch from the queue started and charge all that time.
> >   Generally this rounds to 1 jiffy but in some cases it can
> >   be more. For example, if we are driving high request queue
> >   depth and driver is too busy and does not ask for new
> >   requests for 8-10 jiffies. In such cases, the active queue
> >   gets charged very unfairly.
> >
> > - So fundamentally, whole notion of charging for time slice
> >   is valid only if we have been idling on the queue. Otherwise
> >   in an NCQ queue, there might be other requests on the queue
> >   and we can not do the time slice calculation.
> >
> > - This patch tweaks the slice charging logic a bit so that
> >   in the cases where we can't know the amount of time, we
> >   start charging in terms of number of requests dispatched
> >   (IOPS). This practically switching CFQ fairness model to
> >   fairness in terms of IOPS with slice_idle=0.
> >
> > - As of today this will primarily be useful only with
> >   group_idle patches so that we get fairness in terms of
> >   IOPS across groups. The idea is that on fast storage
> >   one can run CFQ with slice_idle=0 and still get IO
> >   controller working without losing too much of
> >   throughput.
> 
> I'm not fluent in the cgroup code, my apologies for that.  However, just
> trying to make sense of this is giving me a headache.  Now, in some
> cases you are using IOPS *in place of* jiffies.  How are we to know
> which is which and in what cases?

Yes it is mixed now for default CFQ case. Whereever we don't have the
capability to determine the slice_used, we charge IOPS.

For slice_idle=0 case, we should charge IOPS almost all the time. Though
if there is a workload where single cfqq can keep the request queue
saturated, then current code will charge in terms of time.

I agree that this is little confusing. May be in case of slice_idle=0
we can always charge in terms of IOPS. 

> 
> It sounds like this is addressing an important problem, but I'm having a
> hard time picking out what that problem is.  Is this problem noticable
> for competing sync-noidle workloads (competing between groups, that is)?
> If not, then what?

I noticed problem during competing workloads in different groups. With
slice_idle 0, we will drive full queue depth of 32. Sometimes when we
hit high queue depth, say 32, for few jiffies, driver did not ask for
new requests. So say for 10-12 ms, requests only completed and new
requests did not get issued. In that case, all this 10-12 ms gets charged
to active queue and the fact is that this active queue did not even get
to dispatch more than 1 request. This queue was just unfortunate to be
there at that time. The higher weight queue ofen run into this situation
because CFQ tries to keep them as active queue more often.

So if you are driving full queue depth where in NCQ request queue there
are requests pending from multiple queues and groups, you have no way to
measure the time. My impression is that on fast devices, we can no longer
stick to the model of measuring the time. If we switch to IOPS model,
then we can drive deeper requests queue depths and keep the device
saturated, at the same time achieve group IO control.

Thanks
Vivek

> 
> Thanks,
> Jeff
> 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  block/cfq-iosched.c |   24 +++++++++++++++++++++---
> >  1 files changed, 21 insertions(+), 3 deletions(-)
> >
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index 7982b83..f44064c 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -896,16 +896,34 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
> >  		 * if there are mutiple queues in the group, each can dispatch
> >  		 * a single request on seeky media and cause lots of seek time
> >  		 * and group will never know it.
> > +		 *
> > +		 * If drive is NCQ and we are driving deep queue depths, then
> > +		 * it is not reasonable to charge the slice since dispatch
> > +		 * started because this time will include time taken by all
> > +		 * the other requests in the queue.
> > +		 *
> > +		 * Actually there is no reasonable way to know the disk time
> > +		 * queue depth is high, then charge for number of requests
> > +		 * dispatched from the queue. This will sort of becoming
> > +		 * charging in terms of IOPS.
> >  		 */
> > -		slice_used = max_t(unsigned, (jiffies - cfqq->dispatch_start),
> > -					1);
> > +		if (cfqq->cfqd->hw_tag == 0)
> > +			slice_used = max_t(unsigned,
> > +					(jiffies - cfqq->dispatch_start), 1);
> > +		else
> > +			slice_used = cfqq->slice_dispatch;
> >  	} else {
> >  		slice_used = jiffies - cfqq->slice_start;
> >  		if (slice_used > cfqq->allocated_slice)
> >  			slice_used = cfqq->allocated_slice;
> >  	}
> >  
> > -	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u", slice_used);
> > +	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u, sl_disp=%u", slice_used,
> > +			cfqq->slice_dispatch);
> >  	return slice_used;
> >  }
