Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab1G2HgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 03:36:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:64056 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab1G2HgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 03:36:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,286,1309762800"; 
   d="scan'208";a="2265857"
Subject: Re: [PATCH] sched: Remove WAKEUP_PREEMPT feature check in
 entity_tick
From: Lin Ming <ming.m.lin@intel.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "mingo@elte.hu" <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20110729070356.GA10420@zhy>
References: <1311846203.3938.1555.camel@minggr.sh.intel.com>
	 <20110729062158.GA8971@zhy>
	 <1311922180.3938.1573.camel@minggr.sh.intel.com>
	 <20110729070356.GA10420@zhy>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 15:36:15 +0800
Message-ID: <1311924975.3938.1583.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 15:03 +0800, Yong Zhang wrote:
> On Fri, Jul 29, 2011 at 02:49:40PM +0800, Lin Ming wrote:
> > On Fri, 2011-07-29 at 14:21 +0800, Yong Zhang wrote:
> > > On Thu, Jul 28, 2011 at 05:43:23PM +0800, Lin Ming wrote:
> > > > Currently, entity_tick calls check_preempt_tick if WAKEUP_PREEMPT feature is
> > > > disabled. That's wrong. It should do that if the feature is enabled.
> > > 
> > > Why is it wrong?
> > > check_preempt_wakeup() is used for wakeup.
> > 
> > I guess you mean "check_preempt_tick" here, yes?
> 
> check_preempt_wakeup() excactly.
> try_to_wake_up()
>   check_preempt_curr()
>     sched_fair->check_preempt_wakeup()  <========== [1]
> 
> > 
> > in entity_tick(...):
> >         if (cfs_rq->nr_running > 1 || !sched_feat(WAKEUP_PREEMPT))
> >                 check_preempt_tick(cfs_rq, curr);
> > 
> > Note that, above "if" statement says "if WAKEUP_PREEMPT feature is
> > *disabled* then calls check_preempt_tick".
> 
> Yeah, if !sched_feat(WAKEUP_PREEMPT) [1] will just return;
> thus new waked task will wait until the next tick to schedule.
> 
> > 
> > Shouldn't it be "if WAKEUP_PREEMPT feature is *enabled* then ...."?
> 
> So no IMHO.
> 
> > 
> > > 
> > > > 
> > > > And actually the check is duplicate because check_preempt_tick will do
> > > > that. So just remove it from entity_tick.
> > > 
> > > It's not exactly duplicated. entity_tick() will resched_task(*p)
> > > if p's slice is over. So if there is an following wakeup(say X),
> > > then there is an opportunity for X to schedule quickly.
> > 
> > Understood this.
> > 
> > But what I mean is both "entity_tick" and "check_preempt_tick" check
> > WAKEUP_PREEMPT feature. That's duplicated.
> > 
> > Only need to check it in "check_preempt_tick".
> 
> I think we need that check(!sched_feat(WAKEUP_PREEMPT)) in entity_tick()
> to give new waked task better opportunity.

Thanks for your explanation.

>From another point of view, below !sched_feat(WAKEUP_PREEMPT) still
looks like duplicated.

        if (cfs_rq->nr_running > 1 || !sched_feat(WAKEUP_PREEMPT))
                check_preempt_tick(cfs_rq, curr);

if "!sched_feat(WAKEUP_PREEMPT)" is run,
that implies cfs_rq->nr_running == 1.

Why do we need to call check_preempt_tick when there is only 1 task
runnable?

Thanks,
Lin Ming


