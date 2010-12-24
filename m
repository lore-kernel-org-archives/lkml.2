Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0LXQII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 11:08:08 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:33458 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751857Ab0LXQIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 11:08:07 -0500
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Dec 2010 11:08:06 EST
Subject: Re: [RFC][RT][PATCH 3/4] rtmutex: Revert Optimize rt lock wakeup
From: "Peter W. Morreale" <pmorreale@novell.com>
Reply-To: pmorreale@novell.com
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4D13DF250200005A000793E1@novell.com>
References: <20101223224755.078983538@goodmis.org>
	 <20101223225116.729981172@goodmis.org>
	 <4D13DF250200005A000793E1@novell.com>
Content-Type: text/plain; charset="UTF-8"
Organization: LSG - Novell Inc.
Date: Fri, 24 Dec 2010 08:47:56 -0700
Message-ID: <1293205676.3368.80.camel@hermosa.morreale.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 21:45 -0700, Gregory Haskins wrote:
> Hey Steve,
> 
> >>> On 12/23/2010 at 05:47 PM, in message <20101223225116.729981172@goodmis.org>,
> Steven Rostedt <rostedt@goodmis.org> wrote: 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The commit: rtmutex: Optimize rt lock wakeup
> > 
> > Does not do what it was suppose to do.
> > This is because the adaptive waiter sets its state to TASK_(UN)INTERRUPTIBLE
> > before going into the loop. Thus, the test in wakeup_next_waiter()
> > will always fail on an adaptive waiter, as it only tests to see if
> > the pending waiter never has its state set ot TASK_RUNNING unless
> > something else had woke it up.
> > 
> > The smp_mb() added to make this test work is just as expensive as
> > just calling wakeup. And since we we fail to wake up anyway, we are
> > doing both a smp_mb() and wakeup as well.
> > 
> > I tested this with dbench and we run faster without this patch.
> > I also tried a variant that instead fixed the loop, to change the state
> > only if the spinner was to go to sleep, and that still did not show
> > any improvement.
> 
> Just a quick note to say I am a bit skeptical of this patch.  I know you are offline next week, so lets plan on hashing it out after the new year before I ack it.
> 

We shouldn't be too quick to merely rip this out without a little
thinking.  Clearly this is broken, however the intent was clear.  

That being that if a waiter is spinning, we don't need to wake it up. 

The wake up path is substantially more than a barrier; it includes a
barrier as well as grabbing the task_rq_lock only to find that the task
is oncpu. Then various accounting is updated, etc. 

We know definitively that a waiter can only spin if the owner is oncpu,
by definition of adaptive spinning.  We also know that only the owner
can release the lock to a waiter (spinning or not).   So it seems clear
that avoiding unnecessary contention on the rq lock would be a Good
Thing(tm). 

Perhaps this cannot be done safely, but if you saw an improvement in
dbench by merely removing a barrier, imagine the improvement by removing
the contention on the lock.

Happy Holidays to all!

-PWM


 

> Happy holidays!
> -Greg
> 
> > 
> > Cc: Gregory Haskins <ghaskins@novell.com>
> > Cc: Peter Morreale <pmorreale@novell.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/rtmutex.c |   29 ++---------------------------
> >  1 files changed, 2 insertions(+), 27 deletions(-)
> > 
> > diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> > index 318d7ed..e218873 100644
> > --- a/kernel/rtmutex.c
> > +++ b/kernel/rtmutex.c
> > @@ -554,33 +554,8 @@ static void wakeup_next_waiter(struct rt_mutex *lock, 
> > int savestate)
> >  	 */
> >  	if (!savestate)
> >  		wake_up_process(pendowner);
> > -	else {
> > -		/*
> > -		 * We can skip the actual (expensive) wakeup if the
> > -		 * waiter is already running, but we have to be careful
> > -		 * of race conditions because they may be about to sleep.
> > -		 *
> > -		 * The waiter-side protocol has the following pattern:
> > -		 * 1: Set state != RUNNING
> > -		 * 2: Conditionally sleep if waiter->task != NULL;
> > -		 *
> > -		 * And the owner-side has the following:
> > -		 * A: Set waiter->task = NULL
> > -		 * B: Conditionally wake if the state != RUNNING
> > -		 *
> > -		 * As long as we ensure 1->2 order, and A->B order, we
> > -		 * will never miss a wakeup.
> > -		 *
> > -		 * Therefore, this barrier ensures that waiter->task = NULL
> > -		 * is visible before we test the pendowner->state.  The
> > -		 * corresponding barrier is in the sleep logic.
> > -		 */
> > -		smp_mb();
> > -
> > -		/* If !RUNNING && !RUNNING_MUTEX */
> > -		if (pendowner->state & ~TASK_RUNNING_MUTEX)
> > -			wake_up_process_mutex(pendowner);
> > -	}
> > +	else
> > +		wake_up_process_mutex(pendowner);
> >  
> >  	rt_mutex_set_owner(lock, pendowner, RT_MUTEX_OWNER_PENDING);
> >  
> 
> 
> 


