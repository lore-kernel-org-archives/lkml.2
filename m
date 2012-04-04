Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab2DDNb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 09:31:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab2DDNb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 09:31:26 -0400
Date: Wed, 4 Apr 2012 09:31:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, Shaohua Li <shli@kernel.org>
Subject: Re: IOPS based scheduler (Was: Re: [PATCH 18/21] blkcg: move
 blkio_group_conf->weight to cfq)
Message-ID: <20120404133119.GA12676@redhat.com>
References: <20120402214938.GA19634@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F7A2217.2030201@tao.ma>
 <20120402221702.GA21017@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F7A261A.9000200@tao.ma>
 <20120402222504.GA2672@redhat.com>
 <4F7A2B21.5000907@tao.ma>
 <20120403153736.GI5913@redhat.com>
 <4F7B2708.6080504@tao.ma>
 <20120403164959.GJ5913@redhat.com>
 <4F7B32AE.7050900@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7B32AE.7050900@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 01:26:06AM +0800, Tao Ma wrote:
> On 04/04/2012 12:50 AM, Vivek Goyal wrote:
> > On Wed, Apr 04, 2012 at 12:36:24AM +0800, Tao Ma wrote:
> > 
> > [..]
> >>> - Can't we just set the slice_idle=0 and "quantum" to some high value
> >>>   say "64" or "128" and achieve similar results to iops based scheduler?
> >> yes, I should say cfq with slice_idle = 0 works well in most cases. But
> >> if it comes to blkcg with ssd, it is really a disaster. You know, cfq
> >> has to choose between different cgroups, so even if you choose 1ms as
> >> the service time for each cgroup(actually in my test, only >2ms can work
> >> reliably). the latency for some requests(which have been sent by the
> >> user while not submitting to the driver) is really too much for the
> >> application. I don't think there is a way to resolve it in cfq.
> > 
> > Ok, so now you are saying that CFQ as such is not a problem but blkcg
> > logic in CFQ is an issue.
> > 
> > What's the issue there? I think the issue there also is group idling.
> > If you set group_idle=0, that idling will be cut down and switching
> > between groups will be fast. That's a different thing that in the
> > process you will most likely lose service differentiation also for
> > most of the workloads.
> No, group_idle=0 doesn't help. We don't have problem with idling, the
> disk is busy for all the tasks, we just want it to be proportional and
> time endurable.

I am not sure what does time "endurable" mean here. So if group idling
is not a problem, then what is the problem. I am still failing to
understand that what's the problem?

[..]
> > How iops_weight and switching different than CFQ group scheduling logic?
> > I think shaohua was talking of using similar logic. What would you do
> > fundamentally different so that without idling you will get service 
> > differentiation?
> I am thinking of differentiate different groups with iops, so if there
> are 3 groups(the weight are 100, 200, 300) we can let them submit 1 io,
> 2 io and 3 io in a round-robin way. With a intel ssd, every io can be
> finished within 100us. So the maximum latency for one io is about 600us,
> still less than 1ms. But with cfq, if all the cgroups are busy, we have
> to switch between these group in ms which means the maximum latency will
> be 6ms. It is terrible for some applications since they use ssds now.

You can always do faster switching in CFQ. With idling disabled, you can
always expire a queue after dispatching few requests. You don't have to
wait for 1ms. I am not sure why are you assuming that the minimum time
a queue/group has to dispatch is 1ms. 

We already have the notion of not dispatching too many IOs from async
queues. (cfq_prio_to_maxrq()). Something similar can be quickly written
for iops_mode(). Just define a quantum of requests to be dispatched (say
10), and expire a queue after that and charge the queue/group for those
10 requests. Based on its weight, it will automatically go in right
position in the tree and you should get iops based scheduling.

> > 
> > If you explain your logic in detail, it will help.
> > 
> > BTW, in last mail you mentioned that in iops_mode() we make use of time.
> > That's not the case. in iops_mode() we charge group based on number of
> > requests dispatched. (slice_dispatch records number of requests dispatched
> > from the queue in that slice). So to me counting number of requests
> > instead of time will effectively switch CFQ to iops based scheduler, isn't
> > it?
> yes, iops_mode in cfq is calculated iops, but it is switched according
> to the time slice, right? So it can't resolve the problem I mentioned above.

What do you mean that it is switched according to time slice? 

We currently have separate scheduling tree for queue and groups. Currently
iops mode works only for groups. We might still allocate a time slice
to a queue but with idling disabled we will expire it much early. Because
most of the workloads don't keep queue busy long enough. If your workload
keeps the queue busy long enough (say for few ms), then we can introduce
the logic in queue expiry to expire queue after dispatch of few requests
in iops mode so that queue don't get extended time slices.

Thanks
Vivek
