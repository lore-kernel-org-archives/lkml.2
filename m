Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab0EOWfC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 18:35:02 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57561 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0EOWfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 18:35:00 -0400
MIME-Version: 1.0
Message-ID: <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>
Date: Sat, 15 May 2010 15:32:51 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Venkatesh Pallipadi <venki@google.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
References: <1273887635-27610-1-git-send-email-venki@google.com>
 <87tyq9mqrz.fsf@basil.nowhere.org>
 <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default
 20100515121424.38f5b389@infradead.org>
In-Reply-To: <20100515121424.38f5b389@infradead.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090209.4BEF2146.0133:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Arjan van de Ven [mailto:arjan@infradead.org]
(Arjan comments reordered somewhat)

> But friends don't let friends use rdtsc in application code.

Um, I realize that many people have been burned by this
many times over the years so it is a "hot stove".  I also
realize that there are many environments where using
rdtsc is risking stepping on landmines.  But I (we?) also
know there are many environments now where using rdtsc is
NOT risky at all... and with the vast majority of new
systems soon shipping with Invariant TSC and a single socket
(and even most multiple-socket systems with non-broken
BIOSes passing a warp test), why should past burns outlaw
userland use of a very fast, very useful CPU feature?  After
all, CPU designers at both Intel and AMD have spent
a great deal of design effort and transistors to FINALLY
provide an Invariant TSC.

> > The problem is from an app point-of-view there is no vsyscall.
> > There are two syscalls: gettimeofday and clock_gettime.  Sometimes,
> > if it gets lucky, they turn out to be very fast and sometimes
> > it doesn't get lucky and they are VERY slow (resulting in a
> > performance hit of 10% or more), depending on a number of factors
> > completely out of the control of the app and even undetectable to the
> > app.
> 
> But the point is.. in the case you get that 10% hit.... that is exactly
> the case where tsc would not work either!!!

Yes, understood.  But the kernel doesn't expose a "gettimeofday
performance sucks" flag either.  If it did (or in the case of
the patch, if tsc_reliable is zero) the application could at least
choose to turn off the 10000-100000 timestamps/second and log
a message saying "you are running on old hardware so you get
fewer features".

> just when we're trying to get rid of this constraint by allowing a per
> cpu offset... (this is needed to cope with cpus not powering on at the
> exact same time... including hotplug cpu etc etc)
> 
> oh and.. what notification mechanism do you have to notify the
> application that the tsc now is no longer reliable? Such conditions
> can exist... for example due to a CPU being hotplugged, or some SMM
> screwing around and the kernel detecting that or .. or ...

The proposal doesn't provide a notification mechanism (though I'm
not against it)... if the tsc can EVER become unreliable,
tsc_reliable should be 0.

A CPU-hotplugable system is a good example of a case where
the kernel should expose that tsc_reliable is 0.  (I've heard
anecdotally that CPU hotplug into a QPI or Hypertransport system
will have some other interesting challenges, so may require some
special kernel parameters anyway.)  Even if tsc_reliable were
only enabled if a "no-cpu_hotplug" kernel parameter is set,
that is still useful.  And with cores-per-socket (and even
nodes-per-socket) going up seemingly every day, multi-socket
systems will likely be an ever smaller percentage of new
systems.

A virtual machine where live migration to another physical machine
may occur is another good example where tsc_reliable should be 0.
Xen now has a VM config feature that says "migration is disallowed"
for this reason;  the Invariant TSC flag is always off for a VM
unless this "no_migrate" flag is set (or rdtsc is emulated).

> really. Use the vsyscall. If the vsyscall does not do exactly what you
> want, make a better vsyscall.

If this discussion results in a better vsyscall and/or a way
for applications to easily determine (and report loudly) that
the system does NOT provide a good way to do a fast timestamp,
that may be sufficient.  But please propose how that will be done
as the current software choices are inadequate and the CPU
designers have finally fixed the problem for the vast majority
of systems.  I am already aware of some enterprise software
that is doing its best to guess whether TSC is reliable by
looking at CPU families and socket counts, but this is doomed
to failure in userland and is something that the kernel knows
and should now expose.

Thanks,
Dan
