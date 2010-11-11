Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab0KKXTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:19:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40776 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab0KKXTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:19:34 -0500
MIME-Version: 1.0
In-Reply-To: <1289514994.2742.81.camel@work-vm>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
 <22542.1289507293@localhost> <20101111205123.GC10585@shisha.kicks-ass.net>
 <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6>
 <AANLkTik8FS5p_P_2ygh9qC2qg7wTDP+23LKbhJCKcMez@mail.gmail.com> <1289514994.2742.81.camel@work-vm>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Thu, 11 Nov 2010 18:19:10 -0500
Message-ID: <AANLkTimMWcYc2OF1uS0zwRjMyjSGyysMVAsAFMtyOQ-D@mail.gmail.com>
Subject: Re: [PATCHv6 0/7] system time changes notification
To: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Shishkin <virtuoso@slind.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 17:50, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 11 Nov 2010, Kyle Moffett wrote:
>> What about maybe adding device nodes for various kinds of "clock"
>> devices?  You could then do:
>>
>> #define CLOCK_FD 0x80000000
>> fd = open("/dev/clock/realtime", O_RDWR);
>> poll(fd);
>> clock_gettime(CLOCK_FD|fd, &ts);
>
> That won't work due to the posix-cputimers occupying the negative
> number space already.

Hmm, looks like the manpages clock_gettime(2) et. al. need updating,
they don't mention anything at all about negative clockids.  The same
thing could still be done with, EG:

#define CLOCK_FD 0x40000000


On Thu, Nov 11, 2010 at 17:36, john stultz <johnstul@us.ibm.com> wrote:
> On Thu, 2010-11-11 at 17:11 -0500, Kyle Moffett wrote:
>> On Thu, Nov 11, 2010 at 16:16, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > 2) Can't we use existing notification stuff like uevents or such ?
>>
>> What about maybe adding device nodes for various kinds of "clock"
>> devices?  You could then do:
>>
>> #define CLOCK_FD 0x80000000
>> fd = open("/dev/clock/realtime", O_RDWR);
>> poll(fd);
>> clock_gettime(CLOCK_FD|fd, &ts);
>
> Ehh.. I'm not a huge fan of creating dynamic ids for what are static
> clocksources (REALTIME, MONOTONIC, etc).
>
> That said...
>
>> [...]
>>
>> This would also enable the folks who want to support things like PHY
>> hardware clocks (for very-low-latency ethernet timestamping).  It
>> would resolve the enumeration problem; instead of 0, 1, 2, ... as
>> constants, they would show up in sysfs and be open()able.  Ideally you
>> would be able to set up ntpd to slew the "realtime" clock by following
>> a particular hardware clock, or vice versa.
>
> This is very similar in spirit to what's being done by Richard Cochran's
> dynamic clock devices code: http://lwn.net/Articles/413332/

Hmm, I've just been poking around and thinking about an extension of
this concept.  Right now we have:

/sys/devices/system/clocksource
/sys/devices/system/clocksource/clocksource0
/sys/devices/system/clocksource/clocksource0/current_clocksource
/sys/devices/system/clocksource/clocksource0/available_clocksource

Could we actually register the separate clocksources (hpet, acpi_pm,
etc) in the device model properly?

Then consider the possibility of creating "virtual clocksources" which
are measured against an existing clocksource.  They could be
independently slewed and adjusted relative to the parent clocksource.
Then the "UTS namespace" feature could also affect the current
clocksource used for CLOCK_MONOTONIC, etc.

You could perform various forms of time-sensitive software testing
without causing problems for a "make" process running elsewhere on the
system.  You could test the operation of various kinds of software
across large jumps or long periods of time (at a highly accelerated
rate) without impacting your development environment.

One really nice example would be testing "ntpd" itself; you could run
a known-good "ntpd" in the base system to maintain a very stable
clock, then simulate all kinds of terrifyingly bad clock hardware and
kernel problems (sudden frequency changes, etc) in a container.  This
kind of stuff can currently only be easily simulated with specialized
hardware.

You could also improve "container-based" virtualization, allowing
perceived "CPU-time" to be slewed based on the cgroup.  IE: Processes
inside of a container allocated only "33%" of one CPU might see their
"CPU-time" accrue 3 times faster than a process outside of the
container, as though the process was the only thing running on the
system.  Running "top" inside of the container might show 100% CPU
even though the hardware is at 33% utilization, or 200% CPU if the
container is currently bursting much higher.

Cheers,
Kyle Moffett
