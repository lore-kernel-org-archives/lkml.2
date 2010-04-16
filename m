Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab0DPP0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 11:26:14 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44313 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab0DPP0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 11:26:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nT0ITLH4Q8tcDyd4RZrCcMxWpBNxvCbqWZmtYosPGeO8SZPXOgr7jXSoSUN2aVYThR
         fIwWAQN17on8bS7WakFTyafuekYbdQ/gJGDQc+S+1vNEUyw7GtftzEC95Xys/S18roj5
         rXThibvySpmIGnrH0KPVd995SKNTdUgK79MuY=
Date: Fri, 16 Apr 2010 17:26:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/4] ARM: hw-breakpoint: add ARM backend for the
	hw-breakpoint framework
Message-ID: <20100416152605.GF5162@nowhere>
References: <1268236874-7877-1-git-send-email-will.deacon@arm.com> <1268236874-7877-2-git-send-email-will.deacon@arm.com> <1268236874-7877-3-git-send-email-will.deacon@arm.com> <h2mc62985531004130632kd086ffe9o16edafc359fa0e2@mail.gmail.com> <1271173965.17356.28.camel@e102144-lin.cambridge.arm.com> <20100413204000.GC5602@nowhere> <1271240821.11060.3.camel@e102144-lin.cambridge.arm.com> <20100415225950.GI5069@nowhere> <1271427479.21600.1.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271427479.21600.1.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 03:17:59PM +0100, Will Deacon wrote:
> Hi Frederic,
> > It's a cruel architecture...
> > 
> 
> It grows on you :)


:-)))


 
> > Yeah, looking at how this is implemented across versions, it seems
> > that they all share the same registers, but early versions have
> > unfeatured reserved bytes in control registers that are filled
> > with new features over time in subsequent versions.
> > 
> > It looks like the things are then forward compatible but not
> > backward.
> > 
> > Isn't that enough to provide a ptrace interface? I mean you can't do
> > much magic here. Having something that works everywhere would consist
> > in implementing only the minimal set of features only.
> 
> I suppose the ptrace interface will involve bit-packing at some point anyway,
> so mirroring the hardware configuration might not be as bad as I initially thought.
> The hardware has some slightly more esoteric features [breakpoint linking, context
> matching etc] that won't be supported in software for now so I'll ignore those bits.



In fact, I guess watchpoint to breakpoint linking is something that userspace
can use. But the context ID linking....well I haven't understood this part
in ARM documentation :)


 
> > > I'm unsure about how to provide full protection though. You could still
> > > set a breakpoint on the breakpoint handling code that exists outside of the
> > > exception text. Do other archs suffer from this problem? I'm tempted
> > > just to disallow Kernel breakpoints for now, but that would be a shame.
> > 
> > 
> > In x86 we just write the control register to disable the breakpoints
> > in the exception handler. (I suspect we don't do it early enough though).
> > 
> > You can do the same in ARM.
> 
> Ok.



Speaking about this made me wonder about the current state in x86.
For now it's safe because task bound breakpoint only allow userspace
addresses.
But this is not right because we want task bound to be able to trigger
on kernel. Once we'll allow this, we need a bit of policy.

Because yeah we can protect against recursion, but always partially.
The only solution to really protect would be disabling the breakpoint
as the very first operation in the trap handler.

But that's ugly and may be costly as well.

So what I'm going to do is to simply check attr.exclude_kernel on
breakpoint creation and look if the address is in the kernel space.

So that if you want to crash your machine why lurking at the very
tight window of trap handler possible recursion, you need to be
root :)

Because when a perf event registers and doesn't have exclude_kernel,
you need to be admin.

Fortunately we don't have this security hole with the current rules,
but I'll try to make this check more generic (will require archs that
support breakpoints to implement arch_check_va_in_kernelspace()).


> > If an arch has no choice but using sync breakpoints, it needs
> > to handle that. It seems PowerPc has a similar problem, may be
> > have a look at Prasad's patches.
> 
> Could you give me a pointer to these patches please [I can't see them on LKML]?
> I *think* PowerPC is lucky enough to have hardware single step, so handling
> synchronous breakpoints isn't *too* difficult. In ARM we have to work out the
> address of the following instruction, which is quite tricky because it could be a
> branch instruction [from a selection of instruction sets] and also be predicated.
> GDB can handle this, but the Kernel doesn't have the capability to do so [there's
> some code in arch/arm/ptrace.c but it's not feature complete].


I don't remember exactly how this is handled. I remember a story about
a one-shot breakpoint, ie: that triggers only once.

Anyway, I have yet to review the latest version:

http://lists.ozlabs.org/pipermail/linuxppc-dev/2010-April/081714.html
http://lists.ozlabs.org/pipermail/linuxppc-dev/2010-April/081715.html
http://lists.ozlabs.org/pipermail/linuxppc-dev/2010-April/081716.html



> 
> > If there is something that can be handled from the generic
> > layer to help solving this problem, I'll try something.
> 
> Unfortunately this is very much an arch problem. As a half-way house, I might
> implement only the ptrace part of hw-breakpoint for ARM. That way we can
> force the client to handle stepping over the breakpoint and we also won't have
> to worry about recursive breakpoints in the Kernel.


:-s

Yeah, we'll see what we can do.

