Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab1HESnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 14:43:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab1HESnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 14:43:31 -0400
Date: Fri, 5 Aug 2011 14:43:23 -0400
From: Don Zickus <dzickus@redhat.com>
To: Alex Neronskiy <zakmagnus@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v4 2/2] Output stall traces in /proc
Message-ID: <20110805184323.GK20762@redhat.com>
References: <1312495991-28377-1-git-send-email-zakmagnus@chromium.org>
 <1312495991-28377-2-git-send-email-zakmagnus@chromium.org>
 <20110805134042.GJ1972@redhat.com>
 <CAAuSN919rQj93P8HE69_N5vC04ywMFfeJjRdMhn8ga1V-jFb7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAuSN919rQj93P8HE69_N5vC04ywMFfeJjRdMhn8ga1V-jFb7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 10:12:15AM -0700, Alex Neronskiy wrote:
> On Fri, Aug 5, 2011 at 6:40 AM, Don Zickus <dzickus@redhat.com> wrote:
> > I'll have to play with a little bit, but I was wondering what happens when
> > you have multiple stack traces coming in.  Before when it was printing to
> > the console, it was probably a bit of professional courtesy to keep the
> > warnings to a minimum.  But if you are going to use the proc fs, we can
> > probably be a little noisier.  So I had two questions
> >
> > If you don't get to the proc fs fast enough, are you overwriting the
> > shorter stall stack trace with a slightly longer stall stack trace.  It
> > seems the
> >
> >> +                     hardstall_trace.nr_entries = 0;
> >
> > would reset things and you would lose the original worst_stall.
> >
> > Do we want to increment the worst stall time now?  Shouldn't we just stay
> > at the current threshold and continue to print the same stack trace?  To
> > me that is the definition of 'worst stall'.  This might contradict
> > something I said earlier, I don't know (if it does I apologize).  Instead
> > if someone wants to 'skip' that 'worst stall' they can possibly just
> > increment the threshold?
> I don't understand your notion of "worst." If there is a stall and a
> slightly longer stall, then the longer one is the worst one.

Yeah, I don't know why I had it my head this morning that the shorter the
stall the more important it is.  That was pretty dumb.

> 
> I do see what you're saying about affording more noise. If we do what
> you're saying (if I understand correctly), then the "worst" will not
> really be the worst at all, but instead a purely user-tunable
> threshold. The way the code is now, the user can already set their own
> threshold, but the threshold will also adjust itself automatically.
> The question becomes, "what is the best use case to support by
> default?" For example, if a system is allowed to operate for a while
> and then the user goes to check the stalls, then if we can only tell
> them about one stall, the most informative one is probably the worst
> one that happened during that period of operation. Based on your
> suggestion, what they would be shown instead is the most recent stall.
> After checking the stalls, the user can reset the worst/threshold to 0
> or whatever else they would like and then check again later after
> another while.

I understand why you were resetting the stack trace all the time now.

> 
> If the user is willing to micromanage these settings and basically
> react to every stall, then they would benefit most from the threshold
> never automatically adjusting itself. However, if they only check once
> in a while, perhaps not even in response to any particular event, then
> they could be better off if the kernel did some simple filtering on
> its own and gave them back the most "interesting" piece of
> information.

Right.

> 
> > Or another idea I just had (it adds work to this), perhaps create a sample
> > frequency for the lockup timers.  What I mean by that is, currently the
> > timer fires 5 times (or 2.5 for hardlockups) before the NMI triggers.  We
> > could create a knob that allows us to sample at 10 or 20 or whatever.
> > Then next time the hrtimer goes off it would just reload the new
> > frequency.
> >
> > This would allow better resolution on the worst stall I believe, but it
> > invovles more knobs now. So the knobs would look like
> >
> > watchdog_thresh - length of time before NMI fires (currently 10)
> > watchdog_sample_freq - number of times hrtimer fires before NMI fires
> >                        (currently 5, well 2.5)
> > watchdog_worst_stall_hard - number of sample_freq before printing warning
> >                                (currently 2 I think)
> >
> >
> > Because you converted to ms resolution, it is easier to divide the
> > frequency up.  Of course if you increase the sample frequency, you would
> > probably have to increase the worst stall number too.
> >
> > The downside is the power management folks would whine that it drains
> > laptop batteries.  But Matthew Garret sits a few cubes down from me, so I
> > can probably have him help me hook into the idle thread to quiesce the
> > timers.
> >
> > Thoughts?
> Sounds useful. Doing this stuff excessively may waste not only power
> but maybe even CPU time? Anyway, nothing wrong with making it
> adjustable, as far as I can tell. However, I'd like it if at least the
> basic foundation could get accepted soon, if only so I can pull it
> down to Chromium OS ASAP.

Well, the locking needs to be cleaned up *see below*.

> 
> > This lock is defined locally, I don't think that is what you want.  Locks
> > need to be a shared variable.  You might want to use a mutex here so it
> > can sleep in case the stack trace is long.  It is only called from the
> > user context I believe so it should be fine.
> Doesn't it just use one of the locks defined at the top of the file?
> This lock protects the stack trace data structure, so it's not read
> and written at once. This also means it is taken up by the kernel
> during interrupts.

I missed that you defined that as a pointer to a spinlock and assigned it
later.  I see what you are doing now, but I am not a fan of it because you
are now using the same spinlock in both the NMI context and the userspace
context.  This can cause deadlocks if something got screwed up in the
seq_printf functions or produced a very large amount of data.  Normally
you don't want to do that.

What others have done like perf and the APEI error handling is use
something called irq_work_queue(??).  Basically you would capture the
tracae in the NMI context, put it on an irq_work_queue and in the
interrupt context save it to your global trace variable.  Then you could
put spin_lock_irqsave inside the proc sys function and the work queue
function and not have any potential deadlocks.

The softstall case should be ok though.

> 
> > Where do these get created?  Under /proc?  I don't think that will be
> > allowed.  I would think this is a debug feature and we should create
> > something under /sys/kernel/debug like lockup_detector and stick these files in
> > there.
> Okay, and I suppose I'll shove the *stall_worst files into the same
> place (currently they're in /proc/sys/kernel/).

I think that would make sense too.

Cheers,
Don

