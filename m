Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab1GFOX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 10:23:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab1GFOX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 10:23:28 -0400
Date: Wed, 6 Jul 2011 10:23:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@parallels.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 1/2] cfq: request-deadline policy
Message-ID: <20110706142323.GA27302@redhat.com>
References: <20110704130838.27757.87486.stgit@localhost6>
 <20110705150420.GD24348@redhat.com>
 <4E1407A1.5080809@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1407A1.5080809@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 10:58:41AM +0400, Konstantin Khlebnikov wrote:
> Vivek Goyal wrote:
> >On Mon, Jul 04, 2011 at 05:08:38PM +0400, Konstantin Khlebnikov wrote:
> >>CFQ is designed for sharing disk bandwidth proportionally between queues and groups
> >>and for reordering requests to reduce disks seek time. Currently it cannot
> >>gurantee or estimate latency for individual requests, even if latencies are low
> >>for almost all requests, some of them can stuck inside scheduler for a long time.
> >>The fair policy is good as long as someone luckless begins to die due to a timeout.
> >>
> >>This patch implements fifo requests dispatching with deadline policy: now cfq
> >>obliged to dispatch request if it stuck in the queue for more than deadline.
> >>
> >>This way now cfq can try to ensure the expected latency of requests execution.
> >>It is like a safety valve, it should not work all time, but it should keep latency
> >>in sane range when the scheduler is unable to effectively handle flow of requests,
> >>especially in cases when the "noop" or "deadline" shows better performance.
> >>
> >>deadline can be tuned via /sys/block/<device>/queue/iosched/deadline_{sync,async}
> >>it by default 2000ms for sync and 4000ms for async requests, use 0 to disable it.
> >
> >What's the workload where you are running into issues with existing
> >policy?
> 
> This is huge internal test workload,
> there >100 containers with mail/http/ftp and something more.
> 
> >
> >We have low_latency=1 by default and which tries to schedule every
> >queue once in 300ms atleast. And with-in queue we already have the
> >notion of looking at fifo and dispatch the expired request first.
> 
> Without this patch some requests stuck in the scheduler for more than 30 seconds,
> and it looks like it is no limit.

Have you done any analysis why requets are stuck for more than 30 seconds.
May be running blktrace will help.

Is it async requests which are stuck or sync requests?

We have seen that async requests can be stuck for a long time in CFQ
in an attempt to give sync requests priority. I will be surprised
if it is sync request stuck for 30 seconds.

I think first we need to run traces and analyze why request is stuck
for long time. With 300ms soft latency target, we dynamically reduce
the slice of every queue with 16ms minimum. So without cgroups, one shall
have to have close to 2 million procesess to create 32second delay in
servicing a cfq queue. I don't think you have that many processes doing
IO.

So running some traces and diving little deeper to figure out what's
happening will help. If you are quoting these numbers for async request
or for a sync request which is dependent on some async request, then
I can belive those.

> 
> With this patch max-wait-time (from the second patch) shows 7 seconds for this workload,
> so of course queue is over-congested, but it continues to work predictably.
> 
> >
> >So to me sync queue scheduling shold be pretty good. Async queues
> >can get starved though. With-in sync queue, if some requests have
> >expired, it is probably because of the fact that disk is slow and
> >we are throwing too much IO at it. So if we start always dispatching
> >expired requests first, then the notion of fairness is out of the
> >window.
> >
> >Why not use deadline scheduler for your case?
> 
> Because the scheduler must be universal, load can be arbitrary and constantly changing,
> we also can not modify each machine separately.

That's fine. But every scheduler has some property and one needs to use
a scheduler which suits their workoload/storage.

Anyway, before we figure out how to fix the problem, we need to figure
out what's the problem and what is being delayed and where does the
delay come from.

Thanks
Vivek
