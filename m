Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1CBHkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:40:49 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:52692 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750881Ab1CBHks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:40:48 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19WitBfQNBWBheULa8nFtfXYkkkwv+QCOHTb5JArQ
	LMBE8pYWkPGM/Y
Subject: Re: [PATCH] sched: next buddy hint on sleep and preempt path
From: Mike Galbraith <efault@gmx.de>
To: Paul Turner <pjt@google.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>
In-Reply-To: <AANLkTimhfvoKWdYJtxQLWhBwfSvZ3jGy7EXX_YSn_HLr@mail.gmail.com>
References: <1299022433-17233-1-git-send-email-venki@google.com>
	 <AANLkTinyAyXCH6sh9pOe36dCeTO_C8wbtmZriKanGtt3@mail.gmail.com>
	 <1299048447.11469.22.camel@marge.simson.net>
	 <AANLkTimhfvoKWdYJtxQLWhBwfSvZ3jGy7EXX_YSn_HLr@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 08:40:43 +0100
Message-ID: <1299051643.17065.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 23:08 -0800, Paul Turner wrote:
> On Tue, Mar 1, 2011 at 10:47 PM, Mike Galbraith <efault@gmx.de> wrote:
> > On Tue, 2011-03-01 at 21:43 -0800, Paul Turner wrote:
> >> On Tue, Mar 1, 2011 at 3:33 PM, Venkatesh Pallipadi <venki@google.com> wrote:
> >
> >> >        for_each_sched_entity(se) {
> >> >                cfs_rq = cfs_rq_of(se);
> >> >                dequeue_entity(cfs_rq, se, flags);
> >> >
> >> >                /* Don't dequeue parent if it has other entities besides us */
> >> > -               if (cfs_rq->load.weight)
> >> > +               if (cfs_rq->load.weight) {
> >> > +                       /*
> >> > +                        * Bias pick_next to pick a task from this cfs_rq, as
> >> > +                        * p is sleeping when it is within its sched_slice.
> >> > +                        */
> >> > +                       if (task_flags & DEQUEUE_SLEEP && se->parent)
> >> > +                               set_next_buddy(se->parent);
> >>
> >> re-using the last_buddy would seem like a more natural fit here; also
> >> doesn't have a clobber race with a wakeup
> >
> > Hm, that would break last_buddy no?  A preempted task won't get the CPU
> > back after light preempting thread deactivates.  (it's disabled atm
> > unless heavily overloaded anyway, but..)
> 
> Ommm yeah.. we're actually a little snookered in this case since the
> pre-empting thread's sleep will be voluntary which will try to return
> time to its hierarchy.
> 
> I suppose keeping the last_buddy is preferable to the occasional clobber.

Yeah, I think we don't want to break it.  I don't know if pgsql still
uses userland spinlocks, haven't run it in quite a while now, but with
those nasty things, last_buddy was the only thing that kept it from
collapsing into a quivering heap when you try to scale.  Preempting a
userland spinlock holder gets ugly in the extreme.

I'm going to test this patch some more, but in light testing, I saw no
interactivity problems with it, and it does _seem_ to be improving
throughput when there are competing grouped loads sharing the box.  I
haven't tested that heftily though, that's just watching the numbers and
recalling the relative effect of mixing loads previously.

	-Mike

