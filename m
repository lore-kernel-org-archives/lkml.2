Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab1BYMbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 07:31:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:54783 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab1BYMbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 07:31:36 -0500
Subject: Re: [CFS Bandwidth Control v4 2/7] sched: accumulate per-cfs_rq
 cpu usage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
In-Reply-To: <AANLkTik0t6LJNEwN5vYn6Dvx-xg6Agf=W7R6Hqh0s0Y+@mail.gmail.com>
References: <20110216031831.571628191@google.com>
	 <20110216031840.979831163@google.com> <1298467934.2217.766.camel@twins>
	 <AANLkTik0t6LJNEwN5vYn6Dvx-xg6Agf=W7R6Hqh0s0Y+@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Feb 2011 13:31:20 +0100
Message-ID: <1298637080.2428.1751.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 19:33 -0800, Paul Turner wrote:

> >>  #ifdef CONFIG_CFS_BANDWIDTH
> >> +static u64 tg_request_cfs_quota(struct task_group *tg)
> >> +{
> >> +     struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
> >> +     u64 delta = 0;
> >> +
> >> +     if (cfs_b->runtime > 0 || cfs_b->quota == RUNTIME_INF) {
> >> +             raw_spin_lock(&cfs_b->lock);
> >> +             /*
> >> +              * it's possible a bandwidth update has changed the global
> >> +              * pool.
> >> +              */
> >> +             if (cfs_b->quota == RUNTIME_INF)
> >> +                     delta = sched_cfs_bandwidth_slice();
> >
> > Why do we bother at all when there's infinite time? Shouldn't the action
> > that sets it to infinite also make cfs_rq->quota_assinged to to
> > RUNTIME_INF, in which case the below check will make it all go away?

> But more importantly we don't want to decrement the value doled out
> FROM cfs_b->runtime since that would change it from the magic
> RUNTIME_INF.  That's why the check exists.

Ah, quite so.

> >> +             else {
> >> +                     delta = min(cfs_b->runtime,
> >> +                                     sched_cfs_bandwidth_slice());
> >> +                     cfs_b->runtime -= delta;
> >> +             }
> >> +             raw_spin_unlock(&cfs_b->lock);
> >> +     }
> >> +     return delta;
> >> +}
> >
> > Also, shouldn't this all try and steal time from other cpus when the
> > global limit ran out? Suppose you have say 24 cpus, and you had a short
> > burst where all 24 cpus had some runtime, so you distribute 240ms. But
> > 23 of those cpus only ran for 0.5ms, leaving 23.5ms of unused time on 23
> > cpus while your one active cpu will then throttle.
> >
> 
> In practice this only affects the first period since that slightly
> stale bandwidth is then available on those other 23 cpus the next time
> a micro-burst occurs.  In testing this has resulted in very stable
> performance and "smooth" perturbations that resemble hardcapping by
> affinity (for integer points).
> 
> The notion of stealing could certainly be introduced, the juncture of
> reaching the zero point here would be a possible place to consider
> that (although we would need to do a steal that avoids the asymptotic
> convergence problem of RT).
> 
> I think returning (most) of the bandwidth to the global pool on
> (voluntary) dequeue is a more scalable solution
> 
> > I would much rather see all the accounting tight first and optimize
> > later than start with leaky stuff and try and plug holes later.
> >
> 
> The complexity this introduces is non-trivial since the idea of
> returning quota to the pool means you need to introduce the notion of
> when that quota came to life (otherwise you get leaks in the reverse
> direction!) -- as well as reversing some of the lock ordering.

Right, nasty that, RT doesn't suffer this because of the lack of
over-commit.

> While generations do this they don't greatly increase the efficacy and
> I think there is value in performing the detailed review we are doing
> now in isolation of that.
> 
> It's also still consistent regarding leakage since in that in any N
> consecutive periods the maximum additional quota (by a user abusing
> this) that can be received is N+1.  Does the complexity trade-off
> merit improving this bound at this point?

Well, something yes, with N being potentially very large indeed these
days we need some feedback.

One idea would be to keep a cpu mask in the bandwidth thing and setting
the cpu when a cpu claims bandwidth from the global pool and iterate and
clear the complete mask on tick.

That also limits the scope on where to look for stealing time.

> >> +static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
> >> +             unsigned long delta_exec)
> >> +{
> >> +     if (cfs_rq->quota_assigned == RUNTIME_INF)
> >> +             return;
> >> +
> >> +     cfs_rq->quota_used += delta_exec;
> >> +
> >> +     if (cfs_rq->quota_used < cfs_rq->quota_assigned)
> >> +             return;
> >> +
> >> +     cfs_rq->quota_assigned += tg_request_cfs_quota(cfs_rq->tg);
> >> +}
> >
> > So why isn't this hierarchical?,
> 
> It is naturally (since charging occurs within the existing hierarchal
> accounting)

D'0h yes.. somehow I totally missed that.
