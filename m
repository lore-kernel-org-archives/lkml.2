Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab0C2Vnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:43:51 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55703 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab0C2Vnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:43:49 -0400
Subject: Re: [PATCH] hangcheck-timer is broken on x86
From: john stultz <johnstul@us.ibm.com>
To: Yury Polyanskiy <ypolyans@princeton.edu>
Cc: Joel Becker <Joel.Becker@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Jan Glauber <jan.glauber@de.ibm.com>
In-Reply-To: <ea182b21003291408t5a4fe8a8l47c0041df043a3a9@mail.gmail.com>
References: <20100323233611.6dcbe4f4@penta.localdomain>
	 <20100326214648.GF9984@mail.oracle.com>	 <1269824436.1880.2.camel@work-vm>
	 <20100329101106.3678a312@penta.localdomain>
	 <1269881007.1857.18.camel@work-vm>
	 <20100329130418.2b5c068c@penta.localdomain>
	 <1269888291.3968.5.camel@localhost.localdomain>
	 <ea182b21003291408t5a4fe8a8l47c0041df043a3a9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 14:43:44 -0700
Message-ID: <1269899024.3968.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 17:08 -0400, Yury Polyanskiy wrote:
> >> > What I'm saying is that if you're using getrawmonotonic() to detect
> >> > hangs, you might miss them, as getrawmonotonic may wrap (and thus stop
> >> > continually increasing) if the timer interrupt is delayed. This does not
> >> > apply to systems using the TSC clocksource, but does apply to systems
> >> > using the acpi_pm.
> >>
> >> But if timer interrupt is delayed by more than acpi_pm wrap-around
> >> time, then the update_wall_time() is also screwed. Since it is not, we
> >> can rely on getrawmonotonic().
> >
> > Right, if the box hangs for longer then the clocksource can count for,
> > the timekeeping subsystem will be off by some multiple of that length.
> >
> 
> Oh, I see. You mean that getrawmonotonic() wouldn't work under
> abnormal conditions. I understand now, sorry for the confusion. You
> are correct, of course.

And something else I thought of, while the TSC won't wrap, the
multiplication done to convert to nanoseconds will overflow when you hit
a large enough cycle delta. So even TSC systems are not guaranteed to
have timekeeping (and thus getrawmonotonic) work over infinite time
without accumulation.

We try to establish this length via timekeeping_max_deferment(), so that
we make sure we don't go into tickless mode for longer then the
clocksource can handle.


> I personally don't like the idea of relying on read_persistent_clock()
> not only because of hwclock and ntp. In fact, my core interest in
> hangcheck-timer is to set a very low margin (1 to 3 jiffies for
> example) so that I would get a log message upon any kernel slow down
> or a tick-miss (as a hardware integrity check). I don't think
> read_persistent_clock() is precise enough for this purpose, is it?

read_persistent_clock is a bit coarse, so for small intervals it would
not do. However, the current timeout range for the hangcheck timer is in
seconds, which should be fine for read_persistent_clock().

You might also have some trouble with small intervals. Since things like
tickless systems or other advanced power-savings systems might try to
collate or push timers together to save battery. So ticks may be delayed
a small amount (timers are only guaranteed to fire AFTER the time
specified, there really is no promised bound on how late they may be).

Additionally, on -rt systems, you might have higher priority FIFO tasks
blocking the hangcheck timer from executing for a smallish amount of
time.


> Also, hooking to ntp update code complicates an otherwise simple
> driver. I propose to simply check on non-S390 if the clock source
> resolves to something other than TSC and dump a warning message on
> driver load (something like "Hangcheck: kernel using clocksource %s,
> which is not reliable for hang detection").

That requires the hangcheck code to parse the current clocksource, which
might change as the system runs, so it also has to track the clocksource
over time. So I'm not sure its that much easier of a solution.

Something to also consider might also be to look at the softlockup
watchdog, which is fairly similar but somewhat more deeply integrated
into the kernel. Maybe some of this could be merged?

thanks
-john

