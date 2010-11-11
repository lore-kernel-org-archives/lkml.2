Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab0KKXlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:41:36 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37862 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab0KKXlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:41:36 -0500
Subject: Re: [PATCHv6 0/7] system time changes notification
From: john stultz <johnstul@us.ibm.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
In-Reply-To: <AANLkTimMWcYc2OF1uS0zwRjMyjSGyysMVAsAFMtyOQ-D@mail.gmail.com>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
	 <22542.1289507293@localhost> <20101111205123.GC10585@shisha.kicks-ass.net>
	 <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6>
	 <AANLkTik8FS5p_P_2ygh9qC2qg7wTDP+23LKbhJCKcMez@mail.gmail.com>
	 <1289514994.2742.81.camel@work-vm>
	 <AANLkTimMWcYc2OF1uS0zwRjMyjSGyysMVAsAFMtyOQ-D@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 15:41:19 -0800
Message-ID: <1289518879.2742.144.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 18:19 -0500, Kyle Moffett wrote:
> On Thu, Nov 11, 2010 at 17:50, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Thu, 11 Nov 2010, Kyle Moffett wrote:
> >> What about maybe adding device nodes for various kinds of "clock"
> >> devices?  You could then do:
> >>
> >> #define CLOCK_FD 0x80000000
> >> fd = open("/dev/clock/realtime", O_RDWR);
> >> poll(fd);
> >> clock_gettime(CLOCK_FD|fd, &ts);
> >
> > That won't work due to the posix-cputimers occupying the negative
> > number space already.
> 
> Hmm, looks like the manpages clock_gettime(2) et. al. need updating,
> they don't mention anything at all about negative clockids.  The same
> thing could still be done with, EG:
> 
> #define CLOCK_FD 0x40000000

Again, see Richard's patch and the discussion around it for various
complications here (which cause pid_t size limits and run into
limitations with max number of fds per process).

> > This is very similar in spirit to what's being done by Richard Cochran's
> > dynamic clock devices code: http://lwn.net/Articles/413332/
> 
> Hmm, I've just been poking around and thinking about an extension of
> this concept.  Right now we have:
> 
> /sys/devices/system/clocksource
> /sys/devices/system/clocksource/clocksource0
> /sys/devices/system/clocksource/clocksource0/current_clocksource
> /sys/devices/system/clocksource/clocksource0/available_clocksource
> 
> Could we actually register the separate clocksources (hpet, acpi_pm,
> etc) in the device model properly?
> 
> Then consider the possibility of creating "virtual clocksources" which
> are measured against an existing clocksource.  They could be
> independently slewed and adjusted relative to the parent clocksource.
> Then the "UTS namespace" feature could also affect the current
> clocksource used for CLOCK_MONOTONIC, etc.
> 
> You could perform various forms of time-sensitive software testing
> without causing problems for a "make" process running elsewhere on the
> system.  You could test the operation of various kinds of software
> across large jumps or long periods of time (at a highly accelerated
> rate) without impacting your development environment.

This can already be done by registering a bogus clocksource that returns
a counter value <<'ed up. 

That said, the entire system will then see time run faster, and since
timer irqs are triggered off of other devices and other devices notion
of time would not be accelerated, the irqs would seem late. At extreme
values, this would cause system issues, like instant device timeouts.
Further, it wouldn't accelerate the cpu execution time, so applications
would seem to run very slowly.

At one time I looked at doing this in the other direction (slowing down
system time to emulate what a faster cpu would be like), but there's
tons of issues around the fact that there are numerous time domains in a
system that are all very close to actual time, so lots of assumptions
are made as if there is really only one time domain. So by speeding up
the system time, you break the assumption between devices and things
don't function properly.

Again, you might be able to get away with very minor freq adjustments,
but that can easily be done by registering a clocksource with an
incorrect freq value.

> One really nice example would be testing "ntpd" itself; you could run
> a known-good "ntpd" in the base system to maintain a very stable
> clock, then simulate all kinds of terrifyingly bad clock hardware and
> kernel problems (sudden frequency changes, etc) in a container.  This
> kind of stuff can currently only be easily simulated with specialized
> hardware.

Eh, this stuff is emulated in software frequently. 

Also, doing what you propose could be easily done via virtualization or
a hardware emulator where you really can manage all the different time
domains properly.


> You could also improve "container-based" virtualization, allowing
> perceived "CPU-time" to be slewed based on the cgroup.  IE: Processes
> inside of a container allocated only "33%" of one CPU might see their
> "CPU-time" accrue 3 times faster than a process outside of the
> container, as though the process was the only thing running on the
> system.  Running "top" inside of the container might show 100% CPU
> even though the hardware is at 33% utilization, or 200% CPU if the
> container is currently bursting much higher.

I just don't see the real benefit to greatly complicating the
timekeeping code to keep track of multiple fake time domains when these
things can be achieved in other ways (emulation, or virtualization with
freq adjusted clocksources).

The only cases I see where exposing alternative time domains to the
system time is a good thing is where you actually need to precisely
interact with a device that is adjusted or runs on a different time
crystal (as is the case with the PTP clock Richard is working on, or the
clocks on audio hardware).

thanks
-john

