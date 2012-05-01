Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab2EAHSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 03:18:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48952 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab2EAHSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 03:18:05 -0400
Date: Tue, 1 May 2012 09:17:51 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 0/5] Rationalize time keeping
Message-ID: <20120501071749.GD2243@netboy.at.omicron.at>
References: <cover.1335510125.git.richardcochran@gmail.com>
 <4F9B228F.90903@linaro.org>
 <20120428080443.GA2241@netboy.at.omicron.at>
 <4F9EFC70.50405@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9EFC70.50405@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 01:56:16PM -0700, John Stultz wrote:
> On 04/28/2012 01:04 AM, Richard Cochran wrote:
> >I can synchronize over the network to under 100 nanoseconds, so to me,
> >one second is a large offset.
> 
> Well, the leap-offset is a second, but when it arrives is only
> tick-accurate. :)

It would be fine to change the leap second status on the tick, but
then you must also change the time then, and only then, as well. I
know Linux moved away from this long ago, and the new way is better,
but still what the kernel does today is just plain wrong.

But there is a fix. I just offered it.

> True, although even if it is a hack, google *is* using it.  My
> concern is that if CLOCK_REALTIME  is smeared to avoid a leap second
> jump, in that environment we cannot also accurate provide a correct
> CLOCK_TAI.  So far that's not been a problem, because CLOCK_TAI
> isn't a clockid we yet support.  But the expectations bar always
> rises, so I suspect once we have a CLOCK_TAI, someone will want us
> to handle smeared-leap seconds without affecting CLOCK_TAI's
> correctness.

It is either/or, but not both simultaneously.

My proposal does not prevent the smear method in any way. People who
want the smear just never schedule a leap second. People who want the
frequency constant just use the TAI clock interface for the important
work.

We really don't have to support both ways at once.

> >    While these people are usually happy to agree that UTC-SLS is a
> >    sensible engineering solution as long as UTC remains the main time
> >    basis of distributed computing, they argue that this is just a
> >    workaround that will be obsolete once their grand vision of giving
> >    up UTC entirely has become true, and that it is therefore just an
> >    unwelcome distraction from their ultimate goal.
> I think this last point is very telling. Neither of the above
> options are really viable in my mind, as I don't see any real
> consensus to giving up UTC.  What is in-practice is actually way
> more important then where folks wish things would go.

We don't need to give up UTC. We can offer correct UTC and a new,
rational TAI clock and get the leap seconds right, all at the same
time, wow.

> Well, I think that Google shows some folks are starting to use
> workarounds like smeared-leap-seconds/UTC-SLS. So its something we
> should watch carefully and expect more folks to follow.

... but don't hold your breath ...

> Its true
> that you don't want to mix UTC-SLS and standard UTC time domains,
> but its likely this will be a site-specific configuration.
> 
> So its a concern when a correct CLOCK_TAI would be incompatible on
> systems using these hacks/workarounds.

I don't see any problem here.

[ If you do the smear, you can simply just ignore the TAI clock at let
  it be wrong (just like how we handle leap seconds today BTW) or jump
  it at the new epoch. ]

> *Any* extra work is a big deal to folks who are sensitive to
> clock_gettime performance.
> That said, I don't see why its more complicated to also handle leap removal?

It makes your kernel image larger with no added benefit.

> Well, performance sensitive and correctness sensitive are two
> different things. :) I think CLOCK_TAI is much cleaner for things,
> but at the same time, the world "thinks" in UTC, and converting
> between them isn't always trivial (very similar to the timezone
> presentation layer, which isn't fun). So I'd temper any hopes of
> mass conversion. :)

I know, it is a highly politial issue. Converting to UTC is best
handled via timezones. Leap seconds are really just the same as
daylight savings times. Ideally, the kernel would provide only
continuous time, and libc would do the rest.

But I don't expect to change the world, only to fix the kernel.

> Since this is done in
> different ways for each architecture, you need to export the proper
> information out via update_vsyscall() and also update the
> arch-specific vsyscall gettimeofday paths (which is non-trivial, as
> some arches are implemented in asm, etc - my sympathies here, its a
> pain).

Okay, I'll get more familar with that.

> For users of clock_gettime/gettimeofday, a leapsecond is an
> inconsistency. Neither interfaces provide a way to detect that the
> TIME_OOP flag is set and its not 23:59:59 again, but 23:59:60 (which
> can't be represented by a time_t).  Thus even if the behavior was
> perfect, and the leapsecond landed at exactly the second edge, it is
> still a time hiccup to most applications anyway.
> 
> Thus, most of userland doesn't really care if the hiccup happens up
> to a tick after the second's edge. They don't expect it anyway.  So
> they really don't want a constant performance drop in order for the
> hiccup to be more "correct" when it happens.  :)

I don't buy that argument. Repeating a time_t value leads to ambiguous
UTC times, put it is posixly correct. The values are usable together
with difftime(3). Having the time_t go forward and then back again is
certainly worse.

If we leave everything as is, then the user is left with two choices
for data collection applications.

1. Turn off your data system on the night of a leap second.

2. Record data even during a leap second, but post process the files
   to fix up all the uglies.

Either way, the kernel has failed us.

> That's why I'm suggesting that you consider starting by modifying
> the adjtimex() interface. Any application that actually cares about
> leapseconds should be using adjtimex() since its the only interface
> that allows you to realize that's whats happening. Its not a
> performance optimized path, and so its a fine candidate for being
> slow-but-correct.
> 
> My only concern there is that it would cause problems when mixing
> adjtimex() calls with clock_gettime() calls, because you could have
> a tick-length of time when they report different time values. But
> this may be acceptable.

(Introduce yet another kernel bug? No, thanks ;)

Thanks,
Richard
