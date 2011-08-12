Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab1HLMPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 08:15:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:38998 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab1HLMPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 08:15:19 -0400
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
From: Peter Zijlstra <peterz@infradead.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Alex Neronskiy <zakmagnus@chromium.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>
Date: Fri, 12 Aug 2011 14:14:52 +0200
In-Reply-To: <20110811230005.GC16327@google.com>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
	 <1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
	 <1313091323.8491.30.camel@twins>
	 <CAAuSN90BtbRaqkde0iKNQJvpa22AeKJLfyjO6NYqc3kdhqHXtg@mail.gmail.com>
	 <1313094223.26866.15.camel@twins>
	 <CAAuSN90CXXEdco_fNYrv-ZUZPr4nB4HYPM1NCgaSgGz+Z-jaRQ@mail.gmail.com>
	 <1313097475.26866.18.camel@twins> <20110811230005.GC16327@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313151293.6576.29.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 16:00 -0700, Mandeep Singh Baines wrote:
> Hi Peter,
> 
> Peter Zijlstra (peterz@infradead.org) wrote:
> > On Thu, 2011-08-11 at 13:31 -0700, Alex Neronskiy wrote:
> > > 
> > > > I mean, we're at the point where a PREEMPT=y kernel has a pretty decent
> > > > latency and the PREEMPT_RT kernels live at ~30us. So wth are you
> > > > measuring?
> 
> In an earlier patch in the series, Alex was looking into using the timer
> for getting stack traces but using a different time source (TSC, jiffies) for
> measuring the worst latency seen so far.
> 
> Since you know when the watchdog should have run, you can measure the
> difference between when it did run and when it should have. This would allow
> you to be able to measure latency down to the ms or lower.

But that's an arse backwards way of measuring latency. And we already
have an implementation that does it the right way around, its the
preempt-off and irq-off latency tracer in ftrace.

They instrument the preempt/irq disable/enable sites and simply trace
everything in between, getting you an exact measurement and overview of
wth the kernel thought it was doing during that time.

That is much much more useful than a random stacktrace at some point.

In fact it is the tool the -rt kernel uses to find and break these
latencies.

> > > Well, not all kernels have PREEMPT. Chromebook kernels don't, for example.
> > 
> > Can one infer from that statement that the purpose is trying to measure
> > non preempt latency? ...
> > 
> 
> Our "current" plan is to see if we can get away with PREEMPT_VOLUNTARY
> and then fix any issues that we find by adding pre-emption points and
> finer grain locking (to enable pre-emption points) where needed.
> We were hoping to use this patch to find those issues.

Then you're doing it wrong. Use the ftrace infrastructure that's in
place for this purpose, the -rt kernel has been using that for many many
years to do exactly that.

> Right now we have softlockup_thresh set to 10 seconds. But we have no idea
> whether this is too high or not. Ideally, you'd want to set the threshold
> as low as possible but no so low that you start panicking the system
> on temporary stalls.

I can't remember the last time the softlockup thing said anything
useful. Just disable the thing, its useless.

> Let's say that worst stall that every happens on our system is < 1s and
> any stall that is > 1s is really a lockup. With this patch, we could
> say that with confidence and push the threshold down from 10 to 2.
> The quicker we can detect a lockup, the better. We minimize downtown
> and get the machine up in no time (our boot is only 8 seconds).

/me fails to grasp the relation between stalls and boot time. Esp
softlockup crap.

> But I suspect that there are stalls. In Alex's first run with the patch,
> he saw a few lockups which we are now investigating. They were mostly
> in the suspend/resume and boot/shutdown paths. One I'm confident
> is a bug and we'll send a patch upstream shortly.

A stall is mostly people forgetting to tickle the watchdog timer, I'm
very sure these paths actually work (the moment they don't people start
to complain rather loud).

Now optimizing those paths is a whole different game, you want a trace
and profile for that again, seeing if it does something particularly
stupid (trace) and making the more expensive things less so (profile).

> > ... Why not use the tracer build for that purpose?
> > 
> 
> PREEMPT_TRACER is awesome for the lab or development machines but
> it adds too much overhead to use in production. Its add a pretty big
> overhead every time you context switch. With PREEMPT, the overhead
> would be even more.

I don't think context switches are the problem, but simply that you
effectively run with the function tracer enabled.

Also, isn't chromium basically a very limited (aka useless) environment?
You should be able to get a fairly good coverage of chrome (the single
app on there afaik) in pre-production testing.

> The timer period is 1/5 the period of the threshold. The minimum threshold
> is 1s. So if we set the threshold to 1s, we could get a stack trace
> for a 200 ms stall. That would rock.

I'm still not sure of the value of stack traces for latencies, it simply
gives a random snapshot of somewhere in the path (at best, you can hit
after the path with the watchdog approach).

> We would love to set the threshold to 1s and know that we aren't seeing any
> stalls above 200ms. That would give us at least 800 ms of breathing room.
> But right now, we have no idea how much breathing room there is.

OK, but why not run cyclictest? That is the timer sampling latency
detection tool of choice, another on of these -rt things we've been
using for donkey-years. Cyclictest can even run ftrace for you if you
want.

