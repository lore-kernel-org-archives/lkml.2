Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1BOXcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 18:32:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:33667 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab1BOXcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:32:53 -0500
Date: Tue, 15 Feb 2011 15:32:10 -0800
From: Greg KH <gregkh@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: srostedt <srostedt@redhat.com>, a.p.zijlstra@chello.nl, efault@gmx.de,
        ghaskins@novell.com, mingo@elte.hu, stable@kernel.org,
        stable-commits@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Patch "sched: Give CPU bound RT tasks preference" has been
 added to the 2.6.32-longterm tree
Message-ID: <20110215233210.GA3378@suse.de>
References: <12978046423644@kroah.org>
 <1297810967.23343.122.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297810967.23343.122.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 06:02:47PM -0500, Steven Rostedt wrote:
> [ Added LKML ]
> 
> On Tue, 2011-02-15 at 13:17 -0800, gregkh@suse.de wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >     sched: Give CPU bound RT tasks preference
> > 
> > to the 2.6.32-longterm tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/longterm/longterm-queue-2.6.32.git;a=summary
> > 
> > The filename of the patch is:
> >      0006-sched-Give-CPU-bound-RT-tasks-preference.patch
> > and it can be found in the queue-2.6.32 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the 2.6.32 longterm tree,
> > please let <stable@kernel.org> know about it.
> > 
> > 
> 
> I don't mind this patch being added to the long term tree. But I'm
> curious about what is the criteria for adding changes to it? This is a
> performance improvement and not a critical bug fix.

I'll defer to Mike here, as he submitted this series.  I'm pretty sure
it resolves a number of problems reported with the schedular, overall,
with the whole series, right?

Mike?

thanks,

greg k-h


> > >From 10db390cadda977081a7a34f60b8ce62557521c9 Mon Sep 17 00:00:00 2001
> > From: stable-bot for Steven Rostedt <srostedt@redhat.com>
> > Date: Thu, 10 Feb 2011 10:21:08 +0100
> > Subject: sched: Give CPU bound RT tasks preference
> > 
> > From:: Steven Rostedt <srostedt@redhat.com>
> > 
> > Commit: b3bc211cfe7d5fe94b310480d78e00bea96fbf2a upstream
> > 
> > If a high priority task is waking up on a CPU that is running a
> > lower priority task that is bound to a CPU, see if we can move the
> > high RT task to another CPU first. Note, if all other CPUs are
> > running higher priority tasks than the CPU bounded current task,
> > then it will be preempted regardless.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Gregory Haskins <ghaskins@novell.com>
> > LKML-Reference: <20100921024138.888922071@goodmis.org>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >  kernel/sched_rt.c |    8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > --- a/kernel/sched_rt.c
> > +++ b/kernel/sched_rt.c
> > @@ -965,7 +965,8 @@ select_task_rq_rt(struct rq *rq, struct
> >  	 * For equal prio tasks, we just let the scheduler sort it out.
> >  	 */
> >  	if (unlikely(rt_task(rq->curr)) &&
> > -	    rq->curr->prio < p->prio &&
> > +	    (rq->curr->rt.nr_cpus_allowed < 2 ||
> > +	     rq->curr->prio < p->prio) &&
> >  	    (p->rt.nr_cpus_allowed > 1)) {
> >  		int cpu = find_lowest_rq(p);
> >  
> > @@ -1493,9 +1494,10 @@ static void task_woken_rt(struct rq *rq,
> >  	if (!task_running(rq, p) &&
> >  	    !test_tsk_need_resched(rq->curr) &&
> >  	    has_pushable_tasks(rq) &&
> > +	    p->rt.nr_cpus_allowed > 1 &&
> >  	    rt_task(rq->curr) &&
> > -	    rq->curr->prio < p->prio &&
> > -	    p->rt.nr_cpus_allowed > 1)
> > +	    (rq->curr->rt.nr_cpus_allowed < 2 ||
> > +	     rq->curr->prio < p->prio))
> >  		push_rt_tasks(rq);
> >  }
> >  
> > 
> > 
> > Patches currently in longterm-queue-2.6.32 which might be from srostedt@redhat.com are
> 
