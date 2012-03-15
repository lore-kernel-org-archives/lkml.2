Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031516Ab2COPy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:54:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031414Ab2COPy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:54:58 -0400
Date: Thu, 15 Mar 2012 11:54:13 -0400
From: Don Zickus <dzickus@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] watchdog: Make sure the watchdog thread gets CPU on
 loaded system
Message-ID: <20120315155413.GE3941@redhat.com>
References: <1331757525-5755-1-git-send-email-dzickus@redhat.com>
 <20120314161906.e53359d3.akpm@linux-foundation.org>
 <20120315080232.GA17163@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315080232.GA17163@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 09:02:32AM +0100, Michal Hocko wrote:
> On Wed 14-03-12 16:19:06, Andrew Morton wrote:
> > On Wed, 14 Mar 2012 16:38:45 -0400
> > Don Zickus <dzickus@redhat.com> wrote:
> > 
> > > From: Michal Hocko <mhocko@suse.cz>
> > 
> > This changelog is awful.

My apologies too, Andrew for not being more diligent.

Some nitpicks below (hopefully it isn't too picky :-( )

> 
> Sorry about that, What about this?
> 
> If the system is heavy loaded while hotplugging a CPU we might end up
                   heavily                             ,

> with a bogus hardlockup detection. This has been seen during LTP pounder
                                                              the
> test executed in parallel with hotplug test.
                                the

> 
> Hard lockup detector consist of two parts
> 	- watchdog_overflow_callback (executed as a perf counter callback
> 	  from NMI) which checks whether per-cpu hrtimer_interrupts changed
> 	  since the last time it run and panics if not
> 	- watchdog kernel thread which starts watchdog_hrtimer which
> 	  periodically updates hrtimer_interrupts.
> 
> The main problem is that watchdog_enable (called when CPU is brought up)
                                                       a

> registers perf event but the hrtimer is started later when the watchdog
           a

> thread gets a chance to run.

<perhaps an empty line here or merge the paragraphs to make it easier
to read?>

> The watchdog thread starts with a normal priority currently and boosts
                                                    ^^^^^^^(remove?)

> itself as soon as it gets to a CPU. This might be, however, already too
                       ^^^ replace with 'runs on'

> late as demonstrated with the LTP pounder test executed in parallel with
                       ^^^^ replace with 'by'

> LTP hotplug test. There are zillions of userspace processes sitting in
> the runque in this workload while the number of CPUs gets down to 1 and
> then they are onlined back to the original count.
                              sounds awkward, how about
                            "while the number of active CPUS (after
soft-unplugging) is 1. Then all the cpus are soft-plugged back online."

> When we online a CPU and create the watchdog kernel thread it will take
> some time until it gets to a CPU. On the other hand the perf counter
> callback is executed in the timely fashion so we explode the first time
> it finds out there were no changes in the counter.
       ^^^^^ perhaps "it finds out hrtimer_interrupts was not incremented"

> 
> Let's fix this by boosting the watchdog thread priority before we wake it up
> rather than when it's already running.
> This still doesn't handle a case where we have the same amount of high prio
> FIFO tasks but that doesn't seem to be common. The current implementation
> doesn't handle that case anyway so this is not worse at least.
                                            ^^^^ "is no worse."??

> 
> Unfortunately, we cannot start perf counter from the watchdog thread because we
> could miss a real lock up and also we cannot start the hrtimer watchdog_enable
                                                                ^ from

> because we there is no way (at least I don't know any) to start a hrtimer from
          s/we//

> a different CPU.
> 
> [...]
> > > Let's fix this by boosting the watchdog thread priority before we wake it up
> > > rather than when it's already running.
> > > This still doesn't handle a case where we have the same amount of high prio
> > > FIFO tasks but that doesn't seem to be common.
> > 
> > Even a single FIFO thread could starve the watchdog() thread.
> 
> Only if preemption is off, I guess...

I was going suggest that is a good case for touch_softlockup(), but if the
thread is in userspace that won't work.

> 
> > > The current implementation
> > > doesn't handle that case anyway so this is not worse at least.
> > 
> > Right.  But this isn't specific to the startup case, is it?  A spinning
> > SCHED_FIFO thread could cause watchdog() to get starved of CPU for an
> > arbitrarily long time, triggering a false(?) lockup detection?  Or did
> > we do something to prevent that case?  I assume we did - it would be
> > pretty bad if this were to happen.

Well either the thread should use touch_softlockup() (if possible) or we
need to have a higher priority for the softlockup thread to prevent
userspace from blocking it.

> > 
> > > Unfortunately, we cannot start perf counter from the watchdog thread because we
> > > could miss a real lock up and also we cannot start the hrtimer watchdog_enable
> > > because we there is no way (at least I don't know any) to start a hrtimer from
> > > a different CPU.
> > > 
> > > [fix compile issue with param -dcz]
> > > 
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Mandeep Singh Baines <msb@chromium.org>
> > > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > > ---
> > >  kernel/watchdog.c |    7 +++----
> > >  1 files changed, 3 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> > > index d117262..6618cde 100644
> > > --- a/kernel/watchdog.c
> > > +++ b/kernel/watchdog.c
> > > @@ -321,11 +321,9 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
> > >   */
> > >  static int watchdog(void *unused)
> > >  {
> > > -	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
> > > +	struct sched_param param = { .sched_priority = 0 };
> > >  	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
> > >  
> > > -	sched_setscheduler(current, SCHED_FIFO, &param);
> > > -
> > >  	/* initialize timestamp */
> > >  	__touch_watchdog();
> > >  
> > > @@ -350,7 +348,6 @@ static int watchdog(void *unused)
> > >  		set_current_state(TASK_INTERRUPTIBLE);
> > >  	}
> > >  	__set_current_state(TASK_RUNNING);
> > > -	param.sched_priority = 0;
> > >  	sched_setscheduler(current, SCHED_NORMAL, &param);
> > >  	return 0;
> > >  }
> > 
> > Why did watchdog() reset the scheduling policy seven instructions
> > before exiting?  Seems pointless.
> 
> It has been introduced by Thomas in cba9bd22. To be honest I don't
> understand why it makes a sense?

Yeah I noticed that too.  I didn't bother questioning it either when it
went in.  I just assumed Thomas and Peter know scheduling a lot better
than I do. :-)

Cheers,
Don
