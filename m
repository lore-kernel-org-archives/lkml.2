Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab0DNK1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:27:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56020 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754016Ab0DNK1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:27:13 -0400
Subject: Re: [RFC PATCH 2/4] ARM: hw-breakpoint: add ARM backend for the
 hw-breakpoint framework
From: Will Deacon <will.deacon@arm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100413204000.GC5602@nowhere>
References: <1268236874-7877-1-git-send-email-will.deacon@arm.com>
	 <1268236874-7877-2-git-send-email-will.deacon@arm.com>
	 <1268236874-7877-3-git-send-email-will.deacon@arm.com>
	 <h2mc62985531004130632kd086ffe9o16edafc359fa0e2@mail.gmail.com>
	 <1271173965.17356.28.camel@e102144-lin.cambridge.arm.com>
	 <20100413204000.GC5602@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 11:27:01 +0100
Message-ID: <1271240821.11060.3.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Apr 2010 10:27:05.0927 (UTC) FILETIME=[07C71570:01CADBBD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Frederic,

On Tue, 2010-04-13 at 21:40 +0100, Frederic Weisbecker wrote:
> > > > +/* Determine number of WRP registers available. */
> > > > +static int get_num_wrps(void)
> > > > +{
> > > > +       /*
> > > > +        * FIXME: When a watchpoint fires, the only way to work out which
> > > > +        * watchpoint it was is by disassembling the faulting instruction
> > > > +        * and working out the address of the memory access.
> > >
> > > Doh! That must explain the problem with DFAR...
> > > That's really not convenient :-(
> > >
> > I know, it makes life a lot harder for us. The most annoying thing is that
> > I'm yet to find a real implementation that *doesn't* set the DFAR to what
> > we want - we just can't rely on that!
> 
> You mean that sometimes DFAR doesn't have the true ip origin of the
> exception?
> May be you can check the trapped regs to find the instruction pointer
> that caused the exception?

There are two related issues here:

1.) A watchpoint can be synchronous or asynchronous, you can determine which when
    you take the exception. If the watchpoint is synchronous, then yes, we can look
    at the trapped regs to find the causative instruction. Then we would need to
    disassemble the instruction and emulate the address generation part [which may
    also need the trapped regs] in order to calculate the faulting data address.
    If the watchpoint exception is asynchronous, we can read the WFAR register to
    find the address of the causative instruction. Unfortunately, we could still
    be screwed in this case because we won't be able to emulate the address
    calculation for a register-relative load/store. Thankfully, v7 cores only
    generate synchronous watchpoints [apart from some very early revisions which
    you won't see in the wild] but v6 cores are the opposite; they only generate
    asynchronous watchpoint exceptions.

2.) For a standard data abort, the DFAR is updated to contain the data address which
    caused the fault. Ideally this would also be the case for watchpoint exceptions
    because then we wouldn't have to disassemble anything [and as I mentioned
    previously, I'm yet to find a real implementation that doesn't set the DFAR on
    taking a watchpoint, but it's not something that the architecture guarantees].
    
> > > Ah and it will make ptrace support easier: the user writes into the val/ctrl
> > > fields directly as if they were the true registers, then you can just validate
> > > the fields you want without bitwise ops.
> > >
> > I'm unsure about this. As mainline stands, ARM has no ptrace support for the
> > hardware breakpoint registers. This means that we could expose the
> > hardware resources in an idealised fashion via ptrace so that if the
> > interface varies between CPUs, userspace doesn't need to care. I had a
> > crack at this with another patch in the series here:
> >
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2010-March/011169.html
> 
> 
> 
> Ah, indeed if you need to abstract out various ARM versions, that's quite sensitive.
> I'm going to look at this thread too.

It's not so much about necessity, but I think it would be nice if userspace
didn't have to care so much about the breakpoint/watchpoint debug hardware on the
target. Since we don't have any backwards compatibility issues [because ptrace in
mainline has never supported hardware breakpoints on ARM] we can define a stable
API regardless of the hardware.

> > > You seem to make a wrong assumption here.
> > > This is not because the breakpoint is task-bound that we don't
> > > want it to trigger on the kernel. We may want to trigger breakpoints
> > > on tasklist_lock accesses from a given task.
> >
> > > The only case for which we don't want it to trigger on the kernel
> > > is for ptrace breakpoints.
> > >
> > Surely we can't have breakpoints triggering on *any* part of the
> > breakpoint handling code path? Otherwise we'll just get stuck. That's
> > why I disallow breakpoints in the exception section.
> 
> 
> 
> Ah indeed you really need to protect against recursion.

I'm unsure about how to provide full protection though. You could still
set a breakpoint on the breakpoint handling code that exists outside of the
exception text. Do other archs suffer from this problem? I'm tempted
just to disallow Kernel breakpoints for now, but that would be a shame.

> But I'm unclear about the difference between Supervisor and System.
> May be System means the common kernel ring? And you enter into
> Supervisor when an exception triggers?

Sorry, I think my ARM_BREAKPOINT_SUPER #define is confusing. I'll rename it
to ARM_BREAKPOINT_PRIV because the hardware only distinguishes between
privileged and unprivileged accesses, regardless of the mode.

> Do these exceptions also concern page faults and not only debug
> exceptions?

I think so.

One thing that has hit me is the behaviour of the framework when a breakpoint
is hit. If the breakpoint is synchronous, after the exception has been handled
[and perf_bp_event has been called], execution will restart at the faulting
instruction. It is down to the client program [traditionally a debugger] to
remove the breakpoint, single-step and re-insert the breakpoint. Obviously the
perf tool doesn't do this, so if you try to perf stat a breakpoint event you
will livelock [potentially another reason to disable Kernel breakpoints?]

Cheers,

Will



