Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031536Ab2COBp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 21:45:29 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:50996 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031222Ab2COBpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 21:45:25 -0400
Date: Wed, 14 Mar 2012 18:45:11 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] watchdog: Make sure the watchdog thread gets CPU on
 loaded system
Message-ID: <20120315014511.GT27051@google.com>
References: <1331757525-5755-1-git-send-email-dzickus@redhat.com>
 <20120314161906.e53359d3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314161906.e53359d3.akpm@linux-foundation.org>
X-Operating-System: Linux/2.6.38.8-gg683 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton (akpm@linux-foundation.org) wrote:
> On Wed, 14 Mar 2012 16:38:45 -0400
> Don Zickus <dzickus@redhat.com> wrote:
> 
> > From: Michal Hocko <mhocko@suse.cz>
> 
> This changelog is awful.
> 
> > If the system is loaded while hotplugging a CPU we might end up with a bogus
> > hardlockup detection. This has been seen during LTP pounder test executed
> > in parallel with hotplug test.
> > 
> > The main problem is that enable_watchdog (called when CPU is brought up)
> 
> You mean watchdog_enable().
> 
> > registers perf event which periodically checks per-cpu counter
> > (hrtimer_interrupts), updated from a hrtimer callback, but the hrtimer is fired
> 
> s/fired/started/
> 
> > from the kernel thread.
> 
> "the kernel thread" being kernel/watchdog.c:watchdog()
> 
> > This means that while we already do check for the hard lockup the kernel thread
> 
> Who is "we" and where in the kernel does this check occur?
> 
> "the kernel thread" is still kernel/watchdog.c:watchdog().
> 
> > might be sitting on the runqueue with zillions of tasks
> 
> What causes these "zillions of tasks"?  Are they userspace tasks? 
> They're preventing the watchdog() function from being called in a
> timely fashion, I assume?
> 
> > so there is nobody to
> > update the value we rely on and so we KABOOM.
> 
> Who is "we" and what is "the value"?
> 
> etcetera.  It is maddeningly inaccurate, vague and handwavy for someone
> who is actually trying to understand what you're trying to tell us.
> 

My paraphrasing:

Set the task priority of the watchdog thread during creation. The current
implementation set the priority as one of the first few instructions from
the context of the watchdog thread. A false lockup can be detected because
the watchdog is not yet MAX_RT_PRIO - 1 so it can be prevented from
running due to a long runqueue or the running of a SCHED_FIFO process.
Once it changes its priority, this is no longer the case. The fix is to
set the priority to MAX_RT_PRIO -1 at creation time instead of at runtime.


> > Let's fix this by boosting the watchdog thread priority before we wake it up
> > rather than when it's already running.
> > This still doesn't handle a case where we have the same amount of high prio
> > FIFO tasks but that doesn't seem to be common.
> 
> Even a single FIFO thread could starve the watchdog() thread.
> 
> > The current implementation
> > doesn't handle that case anyway so this is not worse at least.
> 
> Right.  But this isn't specific to the startup case, is it?  A spinning
> SCHED_FIFO thread could cause watchdog() to get starved of CPU for an
> arbitrarily long time, triggering a false(?) lockup detection?  Or did
> we do something to prevent that case?  I assume we did - it would be
> pretty bad if this were to happen.
> 

I don't think anything prevents a SCHED_FIFO from preventing a false
lockup.

>From sched.h:

/*
 * Priority of a process goes from 0..MAX_PRIO-1, valid RT
 * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
 * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
 * values are inverted: lower p->prio value means higher priority.
 *
 * The MAX_USER_RT_PRIO value allows the actual maximum
 * RT priority to be separate from the value exported to
 * user-space.  This allows kernel threads to set their
 * priority to a value higher than any user task. Note:
 * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
 */

#define MAX_USER_RT_PRIO	100
#define MAX_RT_PRIO		MAX_USER_RT_PRIO

You could make MAX_RT_PRIO greater than MAX_USER_RT_PRIO but that might
have some impact on real-time applications. A simple one-line patch:

- #define MAX_RT_PRIO		MAX_USER_RT_PRIO
+ #define MAX_RT_PRIO		(MAX_USER_RT_PRIO + 1)

would prevent user-space from causing a false lockup detection.

Regards,
Mandeep

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
> 
> > @@ -439,6 +436,7 @@ static int watchdog_enable(int cpu)
> >  
> >  	/* create the watchdog thread */
> >  	if (!p) {
> > +		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
> >  		p = kthread_create_on_node(watchdog, NULL, cpu_to_node(cpu), "watchdog/%d", cpu);
> >  		if (IS_ERR(p)) {
> >  			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
> > @@ -450,6 +448,7 @@ static int watchdog_enable(int cpu)
> >  			}
> >  			goto out;
> >  		}
> > +		sched_setscheduler(p, SCHED_FIFO, &param);
> >  		kthread_bind(p, cpu);
> >  		per_cpu(watchdog_touch_ts, cpu) = 0;
> >  		per_cpu(softlockup_watchdog, cpu) = p;
> 
> It's pretty silly that kthread_create_on_node() sets the scheduling
> policy and priority and then the caller immediately resets it.  There
> should be a version of kthread_create_on_node() whcih takes these as
> arguments.
> 
> Oh well, despite all that the patch looks OK to me, after using
> whiteout all over the changelog.
> 
