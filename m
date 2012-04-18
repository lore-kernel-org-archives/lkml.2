Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2DRX7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:59:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab2DRX7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:59:39 -0400
Message-ID: <4F8F555F.7040404@redhat.com>
Date: Wed, 18 Apr 2012 19:59:27 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
References: <1333552260-1170-1-git-send-email-prarit@redhat.com> <4F7C8C3E.1020203@us.ibm.com> <4F7C9402.3090602@redhat.com> <4F7CF094.5020201@us.ibm.com> <4F7D8FA1.1010107@redhat.com> <4F8F4C31.7010209@linaro.org>
In-Reply-To: <4F8F4C31.7010209@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Hey Prarit,
>     So at tglx's prodding I took a look at the sysrq code, and the problem is
> the entire sysrq path runs with irqs disabled. As you note,with many cores and
> many processes, it can take a while to spit all that data out.
> 
> Instead of the earlier hack I suggested, would you try the following simpler
> one? I suspect we just need to touch the clocksource watchdog before returning. 
> This should avoid the TSC disqualification you're seeing. On systems using
> clocksources that wrap, we'll still lose time, since no time accumulation
> occurred during the long irq off period, but I think that's acceptable given
> this is not normal operation.
> 
> Let me know if this helps.

Hey John,

Thanks for continuing to work on this.  Coincidentally that exact patch was my
first attempt at resolving the problem as well.  The problem is that even after
touching the clocksource watchdog and restoring irqs the printk buffer can take
a LONG time to flush -- and that still will cause an overflow comparison.  So
fixing it with just a touch_clocksource_watchdog() isn't the right thing to do
IMO.  Maybe a combination of the printk() patch you suggested earlier and the
touch_clocksource_watchdog() is the right way to go but I'll leave that up to
tglx and yourself to decide on a correct fix.

There's also some additional information that I've been gathering on this issue;
I have seen *idle* systems switch to the hpet because the clocksource watchdog
hits the overflow comparison.  As expected it happens much less frequently on
newer kernels (linux.git top of tree) than older stable kernels (2.6.32 based)
due to the difference in shift values but it is happening in both cases.

The odd thing about this behaviour is that I would expect it to occur with the
same frequency on small systems as it does on large systems with linux.git as
the watchdog fires once/second.  AFAICT I do not see this on small systems but
see it only on systems with greater than 24 cpus (both Intel and AMD).

Using debug code similar to the dump code I previously provided, I can see that
every so often these large systems can hit a case where the tsc wraps and the
hpet is still monotonically increasing.  When the unstable calculation is
performed the result is obviously affected by the overflow.  Sometimes this
comparison overflow happens within 18 minutes, other times it can take hours or
days.

The other part of this puzzle is that if switch between the tsc and hpet every
10 seconds, and run a gettimeofday() comparison program, the gettimeofday()
program will return a backwards time[1] event usually within half-an-hour.  [I'm
just including this info here to point out that switching between clocksources
seems to cause some momentary instability.  Before anyone points this out I will
say that this not a "real world" bug.  I'm trying to find out if anyone actually
does switch from the tsc to hpet (and back) on multi-purposed systems.  I'm
hoping the answer to that is "no" :) ].

P.

[1] is not really a backwards time event.  The program does a comparison of
gettimeofday() values and returns an error if the new value is less than the
older value.  The gettimeofday() value jumps *forward* slightly for one returned
value when the clocksource switches from the tsc to the hpet (I have not see a
failure the other way around), and that causes the comparison to fail on the
next comparison of gettimeofday().  If I remove the code that returns an error
gettimeofday() returns to returning incrementally increasing values.  Typical
jumps are in the tens of microseconds range.
