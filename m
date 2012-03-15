Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab2COICp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 04:02:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619Ab2COICh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 04:02:37 -0400
Date: Thu, 15 Mar 2012 09:02:32 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] watchdog: Make sure the watchdog thread gets CPU on
 loaded system
Message-ID: <20120315080232.GA17163@tiehlicka.suse.cz>
References: <1331757525-5755-1-git-send-email-dzickus@redhat.com>
 <20120314161906.e53359d3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314161906.e53359d3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-03-12 16:19:06, Andrew Morton wrote:
> On Wed, 14 Mar 2012 16:38:45 -0400
> Don Zickus <dzickus@redhat.com> wrote:
> 
> > From: Michal Hocko <mhocko@suse.cz>
> 
> This changelog is awful.

Sorry about that, What about this?

If the system is heavy loaded while hotplugging a CPU we might end up
with a bogus hardlockup detection. This has been seen during LTP pounder
test executed in parallel with hotplug test.

Hard lockup detector consist of two parts
	- watchdog_overflow_callback (executed as a perf counter callback
	  from NMI) which checks whether per-cpu hrtimer_interrupts changed
	  since the last time it run and panics if not
	- watchdog kernel thread which starts watchdog_hrtimer which
	  periodically updates hrtimer_interrupts.

The main problem is that watchdog_enable (called when CPU is brought up)
registers perf event but the hrtimer is started later when the watchdog
thread gets a chance to run.
The watchdog thread starts with a normal priority currently and boosts
itself as soon as it gets to a CPU. This might be, however, already too
late as demonstrated with the LTP pounder test executed in parallel with
LTP hotplug test. There are zillions of userspace processes sitting in
the runque in this workload while the number of CPUs gets down to 1 and
then they are onlined back to the original count.
When we online a CPU and create the watchdog kernel thread it will take
some time until it gets to a CPU. On the other hand the perf counter
callback is executed in the timely fashion so we explode the first time
it finds out there were no changes in the counter.

Let's fix this by boosting the watchdog thread priority before we wake it up
rather than when it's already running.
This still doesn't handle a case where we have the same amount of high prio
FIFO tasks but that doesn't seem to be common. The current implementation
doesn't handle that case anyway so this is not worse at least.

Unfortunately, we cannot start perf counter from the watchdog thread because we
could miss a real lock up and also we cannot start the hrtimer watchdog_enable
because we there is no way (at least I don't know any) to start a hrtimer from
a different CPU.

[...]
> > Let's fix this by boosting the watchdog thread priority before we wake it up
> > rather than when it's already running.
> > This still doesn't handle a case where we have the same amount of high prio
> > FIFO tasks but that doesn't seem to be common.
> 
> Even a single FIFO thread could starve the watchdog() thread.

Only if preemption is off, I guess...

> > The current implementation
> > doesn't handle that case anyway so this is not worse at least.
> 
> Right.  But this isn't specific to the startup case, is it?  A spinning
> SCHED_FIFO thread could cause watchdog() to get starved of CPU for an
> arbitrarily long time, triggering a false(?) lockup detection?  Or did
> we do something to prevent that case?  I assume we did - it would be
> pretty bad if this were to happen.
> 
> > Unfortunately, we cannot start perf counter from the watchdog thread because we
> > could miss a real lock up and also we cannot start the hrtimer watchdog_enable
> > because we there is no way (at least I don't know any) to start a hrtimer from
> > a different CPU.
> > 
> > [fix compile issue with param -dcz]
> > 
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Mandeep Singh Baines <msb@chromium.org>
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > ---
> >  kernel/watchdog.c |    7 +++----
> >  1 files changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> > index d117262..6618cde 100644
> > --- a/kernel/watchdog.c
> > +++ b/kernel/watchdog.c
> > @@ -321,11 +321,9 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
> >   */
> >  static int watchdog(void *unused)
> >  {
> > -	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
> > +	struct sched_param param = { .sched_priority = 0 };
> >  	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
> >  
> > -	sched_setscheduler(current, SCHED_FIFO, &param);
> > -
> >  	/* initialize timestamp */
> >  	__touch_watchdog();
> >  
> > @@ -350,7 +348,6 @@ static int watchdog(void *unused)
> >  		set_current_state(TASK_INTERRUPTIBLE);
> >  	}
> >  	__set_current_state(TASK_RUNNING);
> > -	param.sched_priority = 0;
> >  	sched_setscheduler(current, SCHED_NORMAL, &param);
> >  	return 0;
> >  }
> 
> Why did watchdog() reset the scheduling policy seven instructions
> before exiting?  Seems pointless.

It has been introduced by Thomas in cba9bd22. To be honest I don't
understand why it makes a sense?
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
