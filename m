Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab0EPQoD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 12:44:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16894 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0EPQn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 12:43:59 -0400
MIME-Version: 1.0
Message-ID: <b7b4f345-944c-4cbc-b98a-700f915183b9@default>
Date: Sun, 16 May 2010 09:42:40 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Venkatesh Pallipadi <venki@google.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
References: <1273887635-27610-1-git-send-email-venki@google.com>
 <87tyq9mqrz.fsf@basil.nowhere.org>
 <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
 <20100515121424.38f5b389@infradead.org>
 <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>
 <20100515224305.17a04022@infradead.org
 alpine.LFD.2.00.1005161113450.3199@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005161113450.3199@localhost.localdomain>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4BF02095.0007:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> What we can talk about is a vget_tsc_raw() interface along with a
> vconvert_tsc_delta() interface, where vget_tsc_raw() returns you an
> nasty error code for everything which is not usable.

I'm open to something like that provided:

1) It works (whenever possible) without changing privilege levels
   or causing vmexits or other "hidden slowness" problems when
   used both in bare-metal Linux and in a virtual machine.
2) The "transformation" performed by the kernel on the TSC
   does not require some hidden pcpu number that won't work
   in a virtual machine.

If TSC is indeed reliable (see below), it is both faster AND
meets the above constraints.

> > From: Arjan van de Ven [mailto:arjan@infradead.org]
> > If you want a sysfs variable that is always 0... go wild.
> 
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Nah, there are systems which will have it set to 1:
> Dig out your good old Pentium-I box and enjoy.

Hot stove syndrome again?  Are you truly saying that there
are NO single-socket multi-core systems that don't have
stupid firmware (SMI and/or BIOS)?  Or are you saying that
significant TSC clock skew occurs even between the cores
on a single-socket Nehalem system?

If things are this bad, why on earth would the kernel itself
EVER use TSC even as its own internal clocksource?  Or
even to provide additional precision to a slow platform timer?

Or are you saying that many systems (and especially large
multi-socket systems) DO exist where the kernel isn't able
to proactively determine that the firmware is broken and/or
significant thermal variation may occur across sockets?
This I believe.

I understand that you both are involved in pushing the
limits of large systems and that time synchronization is
a very hard problem, perhaps effectively unsolvable,
in these systems.

But that doesn't mean the vast majority of latest generation
single-socket systems can't set "tsc_reliable" to 1.  Or that
the kernel is responsible for detecting and/or correcting
every system with buggy firmware.

Maybe the best way to solve the "buggy firmware problem"
is exactly by encouraging enterprise apps to use TSC
and to expose and *blacklist* systems and/or system vendors
who ship boxes with crappy firmware!

> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> What we could expose is an estimate about the performance of
> gettimeofday/clock_gettime. The kernel has all the information to do
> that, but this still does not solve the notification problem when we
> need to switch to a different clock source.

This would at least be a big step in the right direction.

But if we go with a vget_raw_tsc() or direct TSC solution,
you have convinced me of the need for notification.
Maybe this is a perfect use for (at least one bit in)
the TSC_AUX register and the rdtscp instruction?

And I do agree with Venki that some user library (or at
least published sample code) should be made available
to demonstrate proper usage and to dampen out the worst
of the "broken user problem".

> > From: Arjan van de Ven [mailto:arjan@infradead.org]
> > can you name said "enterprise" software by name please? We need a huge
> > advertisement to let people know not to trust their important data to
> > it..

For obvious reasons I can't do that, but I can point to
enterprise *operating systems* that have long since solved
this same problem one way or another:  Solaris on x86 and
HP-UX (the latter admittedly on ia64).  Enterprise app
vendors are quite happy with requiring conformance to a
very completely specified software/hardware/firmware stack
before providing support to an app customer.  I'm just trying
to ensure that Linux can be part of that spec.
