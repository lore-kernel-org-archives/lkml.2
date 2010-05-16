Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0EPTOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 15:14:45 -0400
Received: from www.tglx.de ([62.245.132.106]:46037 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab0EPTOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 15:14:43 -0400
Date: Sun, 16 May 2010 21:14:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
cc: Arjan van de Ven <arjan@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
In-Reply-To: <b7b4f345-944c-4cbc-b98a-700f915183b9@default>
Message-ID: <alpine.LFD.2.00.1005161925480.3368@localhost.localdomain>
References: <1273887635-27610-1-git-send-email-venki@google.com> <87tyq9mqrz.fsf@basil.nowhere.org> <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default> <20100515121424.38f5b389@infradead.org> <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default> <20100515224305.17a04022@infradead.org
 alpine.LFD.2.00.1005161113450.3199@localhost.localdomain> <b7b4f345-944c-4cbc-b98a-700f915183b9@default>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan,

On Sun, 16 May 2010, Dan Magenheimer wrote:

> > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > What we can talk about is a vget_tsc_raw() interface along with a
> > vconvert_tsc_delta() interface, where vget_tsc_raw() returns you an
> > nasty error code for everything which is not usable.
> 
> I'm open to something like that provided:
> 
> 1) It works (whenever possible) without changing privilege levels
>    or causing vmexits or other "hidden slowness" problems when
>    used both in bare-metal Linux and in a virtual machine.
> 2) The "transformation" performed by the kernel on the TSC
>    does not require some hidden pcpu number that won't work
>    in a virtual machine.

What I have in mind and what I'm working on for quite a while is going
to work on both bare metal and VMs w/o hidden slowness.
 
> If TSC is indeed reliable (see below), it is both faster AND
> meets the above constraints.
> 
> > > From: Arjan van de Ven [mailto:arjan@infradead.org]
> > > If you want a sysfs variable that is always 0... go wild.
> > 
> > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > Nah, there are systems which will have it set to 1:
> > Dig out your good old Pentium-I box and enjoy.
> 
> Hot stove syndrome again?  Are you truly saying that there

Kinda hot stove, yes. I'm unfortunately forced to deal with the 500+
different variants of borked timers and that makes me very reluctant
to believe anything what chip/board/bios vendors promise. It's not the
one time hot stove experience, it's the constant exposure to the never
ending supply of hot stoves, which makes me nervous.

I wish I could say something different.

> are NO single-socket multi-core systems that don't have
> stupid firmware (SMI and/or BIOS)?  Or are you saying that

There are single socket multi-core x86 systems with a sane BIOS, but
there is no reliable way to tell which ones belong into that category.

> significant TSC clock skew occurs even between the cores
> on a single-socket Nehalem system?

There is no clock skew between the cores of a package - at least we
are not aware of such a problem. Though I wouldn't rely on that
forever: they also said that the Titanic was unsinkable :)

> If things are this bad, why on earth would the kernel itself
> EVER use TSC even as its own internal clocksource?  Or

We try to use it for performance sake, but the kernel does at least
it's very best to find out when it goes bad. We then switch back to a
hpet or pm-timer which is horrible performance wise but does not screw
up timekeeping and everything which relies on it completely.

> even to provide additional precision to a slow platform timer?

We don't do that anymore.

> Or are you saying that many systems (and especially large
> multi-socket systems) DO exist where the kernel isn't able
> to proactively determine that the firmware is broken and/or
> significant thermal variation may occur across sockets?
> This I believe.

As I said, we try our very best to determine when things go awry, but
there are small errors which occur either sporadic or after longer
uptime which we cannot yet detect reliably. Multi-socket falls into
that category, but we are working on that.
 
> I understand that you both are involved in pushing the
> limits of large systems and that time synchronization is
> a very hard problem, perhaps effectively unsolvable,
> in these systems.

Well, it would be solvable in hardware and it has been done in
hardware more than 20 years ago. Just not there where it would have
been important: inside of x86 cpus. Hint: there are other
architectures which got that right from the very beginning even on
multi-socket systems.

Admitted, x86 made progress, but we are still some steps away from
something which I would consider reliable under all circumstances.

But you are right, some of the problems with the existing hardware are
just unsolvable and I spent a serious amount of time on trying to
convince myself otherwise.

The nasty thing about the subtle wreckage is that it is really hard to
investigate and debug and I wasted a whole week recently to figure out
what caused the time going backwards problem on a dual socket
westmere. Not fun !

> But that doesn't mean the vast majority of latest generation
> single-socket systems can't set "tsc_reliable" to 1.  Or that
> the kernel is responsible for detecting and/or correcting
> every system with buggy firmware.

It _IS_ responsible to detect buggy firmware otherwise we would just
drain in bug reports about broken timekeeping. We've been there, no
way to go back to this.

> Maybe the best way to solve the "buggy firmware problem"
> is exactly by encouraging enterprise apps to use TSC
> and to expose and *blacklist* systems and/or system vendors
> who ship boxes with crappy firmware!

Blacklists are the last resort if a problem is not detectable by the
kernel. We usually detect the non usability of TSC and emit a
prominent warning into dmesg. Those warnings are there for years, but
the number of systems with BIOS caused TSC wreckage has grown.

> > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > What we could expose is an estimate about the performance of
> > gettimeofday/clock_gettime. The kernel has all the information to do
> > that, but this still does not solve the notification problem when we
> > need to switch to a different clock source.
> 
> This would at least be a big step in the right direction.

Ok.
 
> But if we go with a vget_raw_tsc() or direct TSC solution,
> you have convinced me of the need for notification.
> Maybe this is a perfect use for (at least one bit in)
> the TSC_AUX register and the rdtscp instruction?

Uurgh, no. The vsyscall will return a proper error code when shit
happens. And really, we don't want to encourage the direct use of
rdtsc at all. Also rdtscp is a full serializing instruction, which is
probably not what you want to get fast timestamps.

> And I do agree with Venki that some user library (or at
> least published sample code) should be made available
> to demonstrate proper usage and to dampen out the worst
> of the "broken user problem".

Using a vsyscall is the best way to achieve that. Simple function call
interface with a well defined ABI and a proper return code. If the
user ignores the return code - none of my problems.

Further it allows us 

 - to keep the various CPU generation specific quirks well confined in
   the kernel and we can even do fixups for correctable wreckage.

 - to expose coarser grained fast timestamps when the TSC is not
   usable. [So the best name for it would be vget_timestamp(), which btw. 
   allows us to provide the same interface to non x86 as well ]

Thoughts ?

> > > From: Arjan van de Ven [mailto:arjan@infradead.org]
> > > can you name said "enterprise" software by name please? We need a huge
> > > advertisement to let people know not to trust their important data to
> > > it..
> 
> For obvious reasons I can't do that, but I can point to
> enterprise *operating systems* that have long since solved
> this same problem one way or another:  Solaris on x86 and

On a well selected subset of the machines which they control themself.

> HP-UX (the latter admittedly on ia64).  Enterprise app

But that's probably just a property of ia64 and not the merit of HP,
as their x86 machines have a proven track record of BIOS/SMI problems.

> vendors are quite happy with requiring conformance to a
> very completely specified software/hardware/firmware stack
> before providing support to an app customer.  I'm just trying
> to ensure that Linux can be part of that spec.

I understand that and I'm willing to help, but in a sane and
controlled way which does me not expose to a new category of unfixable
bugreports and complaints.

Thanks,

	tglx
