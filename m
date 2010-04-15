Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab0DOXBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:01:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64849 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820Ab0DOXBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HtmdAAekC4ePT8VAJNDK/FlIKsxTRo5517thNtWcumVp0hxJeBTRr685ASNebDjGxc
         33crmTWV6bMJ74W0f2zXx7/FpNPDwv+W9Jwp4JImoUKVjrT6w1dxiCFg9IwK6Cq4uw6u
         yA7PDoY+1RuGj1tWcptE7y29jR/ZG3a7r8Y4s=
Date: Fri, 16 Apr 2010 01:01:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/4] ARM: hw-breakpoint: add ARM backend for the
	hw-breakpoint framework
Message-ID: <20100415225950.GI5069@nowhere>
References: <1268236874-7877-1-git-send-email-will.deacon@arm.com> <1268236874-7877-2-git-send-email-will.deacon@arm.com> <1268236874-7877-3-git-send-email-will.deacon@arm.com> <h2mc62985531004130632kd086ffe9o16edafc359fa0e2@mail.gmail.com> <1271173965.17356.28.camel@e102144-lin.cambridge.arm.com> <20100413204000.GC5602@nowhere> <1271240821.11060.3.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271240821.11060.3.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 11:27:01AM +0100, Will Deacon wrote:
> Hello Frederic,
> 
> On Tue, 2010-04-13 at 21:40 +0100, Frederic Weisbecker wrote:
> > > > > +/* Determine number of WRP registers available. */
> > > > > +static int get_num_wrps(void)
> > > > > +{
> > > > > +       /*
> > > > > +        * FIXME: When a watchpoint fires, the only way to work out which
> > > > > +        * watchpoint it was is by disassembling the faulting instruction
> > > > > +        * and working out the address of the memory access.
> > > >
> > > > Doh! That must explain the problem with DFAR...
> > > > That's really not convenient :-(
> > > >
> > > I know, it makes life a lot harder for us. The most annoying thing is that
> > > I'm yet to find a real implementation that *doesn't* set the DFAR to what
> > > we want - we just can't rely on that!
> > 
> > You mean that sometimes DFAR doesn't have the true ip origin of the
> > exception?
> > May be you can check the trapped regs to find the instruction pointer
> > that caused the exception?
> 
> There are two related issues here:
> 
> 1.) A watchpoint can be synchronous or asynchronous, you can determine which when
>     you take the exception. If the watchpoint is synchronous, then yes, we can look
>     at the trapped regs to find the causative instruction. Then we would need to
>     disassemble the instruction and emulate the address generation part [which may
>     also need the trapped regs] in order to calculate the faulting data address.
>     If the watchpoint exception is asynchronous, we can read the WFAR register to
>     find the address of the causative instruction. Unfortunately, we could still
>     be screwed in this case because we won't be able to emulate the address
>     calculation for a register-relative load/store. Thankfully, v7 cores only
>     generate synchronous watchpoints [apart from some very early revisions which
>     you won't see in the wild] but v6 cores are the opposite; they only generate
>     asynchronous watchpoint exceptions.
> 
> 2.) For a standard data abort, the DFAR is updated to contain the data address which
>     caused the fault. Ideally this would also be the case for watchpoint exceptions
>     because then we wouldn't have to disassemble anything [and as I mentioned
>     previously, I'm yet to find a real implementation that doesn't set the DFAR on
>     taking a watchpoint, but it's not something that the architecture guarantees].



It's a cruel architecture...


     
> > > > Ah and it will make ptrace support easier: the user writes into the val/ctrl
> > > > fields directly as if they were the true registers, then you can just validate
> > > > the fields you want without bitwise ops.
> > > >
> > > I'm unsure about this. As mainline stands, ARM has no ptrace support for the
> > > hardware breakpoint registers. This means that we could expose the
> > > hardware resources in an idealised fashion via ptrace so that if the
> > > interface varies between CPUs, userspace doesn't need to care. I had a
> > > crack at this with another patch in the series here:
> > >
> > > http://lists.infradead.org/pipermail/linux-arm-kernel/2010-March/011169.html
> > 
> > 
> > 
> > Ah, indeed if you need to abstract out various ARM versions, that's quite sensitive.
> > I'm going to look at this thread too.
> 
> It's not so much about necessity, but I think it would be nice if userspace
> didn't have to care so much about the breakpoint/watchpoint debug hardware on the
> target. Since we don't have any backwards compatibility issues [because ptrace in
> mainline has never supported hardware breakpoints on ARM] we can define a stable
> API regardless of the hardware.


Yeah, looking at how this is implemented across versions, it seems
that they all share the same registers, but early versions have
unfeatured reserved bytes in control registers that are filled
with new features over time in subsequent versions.

It looks like the things are then forward compatible but not
backward.

Isn't that enough to provide a ptrace interface? I mean you can't do
much magic here. Having something that works everywhere would consist
in implementing only the minimal set of features only.



> > > > You seem to make a wrong assumption here.
> > > > This is not because the breakpoint is task-bound that we don't
> > > > want it to trigger on the kernel. We may want to trigger breakpoints
> > > > on tasklist_lock accesses from a given task.
> > >
> > > > The only case for which we don't want it to trigger on the kernel
> > > > is for ptrace breakpoints.
> > > >
> > > Surely we can't have breakpoints triggering on *any* part of the
> > > breakpoint handling code path? Otherwise we'll just get stuck. That's
> > > why I disallow breakpoints in the exception section.
> > 
> > 
> > 
> > Ah indeed you really need to protect against recursion.
> 
> I'm unsure about how to provide full protection though. You could still
> set a breakpoint on the breakpoint handling code that exists outside of the
> exception text. Do other archs suffer from this problem? I'm tempted
> just to disallow Kernel breakpoints for now, but that would be a shame.


In x86 we just write the control register to disable the breakpoints
in the exception handler. (I suspect we don't do it early enough though).

You can do the same in ARM.

Currently, there is no true security flow because if a breakpoint
is task bound, x86 refuse breakpoints in kernel addresses.
But as I noticed before, this is a wrong behaviour as we also
want to be able to trace kernel var accesses while in a given task
context, except for ptrace.

I should just add a CAP_SYS_ADMIN() && !ptrace check for kernel
addresses.



> > But I'm unclear about the difference between Supervisor and System.
> > May be System means the common kernel ring? And you enter into
> > Supervisor when an exception triggers?
> 
> Sorry, I think my ARM_BREAKPOINT_SUPER #define is confusing. I'll rename it
> to ARM_BREAKPOINT_PRIV because the hardware only distinguishes between
> privileged and unprivileged accesses, regardless of the mode.


Ok.



> > Do these exceptions also concern page faults and not only debug
> > exceptions?
> 
> I think so.
> 
> One thing that has hit me is the behaviour of the framework when a breakpoint
> is hit. If the breakpoint is synchronous, after the exception has been handled
> [and perf_bp_event has been called], execution will restart at the faulting
> instruction. It is down to the client program [traditionally a debugger] to
> remove the breakpoint, single-step and re-insert the breakpoint. Obviously the
> perf tool doesn't do this, so if you try to perf stat a breakpoint event you
> will livelock [potentially another reason to disable Kernel breakpoints?]


If I understand you correctly,

sync = breakpoint triggers before the instruction is executed,
       trap return to the faulting instruction
async = breakpoint triggers after the instruction is executed

Then yeah, the current breakpoint framework only supports async
ones.

If an arch has no choice but using sync breakpoints, it needs
to handle that. It seems PowerPc has a similar problem, may be
have a look at Prasad's patches.

If there is something that can be handled from the generic
layer to help solving this problem, I'll try something.

