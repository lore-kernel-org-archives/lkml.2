Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0DMUkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:40:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53430 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab0DMUkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:40:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lSLLD74hE55rsm5uIUdH8ljRCYAtfk1bvne6tRKy09KP4e9j/XrdEaBl+fAPbupzo5
         hWOpEhSLtipOM1sDzacWaa6vMDxNe7iZjAGngrNNhTQ+aPXp+rgGWGqxJWXx1/jqPgti
         D3xlE0dc9qFb3XfZLSxkWm99aKF3vrNoNr1/M=
Date: Tue, 13 Apr 2010 22:40:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/4] ARM: hw-breakpoint: add ARM backend for the
	hw-breakpoint framework
Message-ID: <20100413204000.GC5602@nowhere>
References: <1268236874-7877-1-git-send-email-will.deacon@arm.com> <1268236874-7877-2-git-send-email-will.deacon@arm.com> <1268236874-7877-3-git-send-email-will.deacon@arm.com> <h2mc62985531004130632kd086ffe9o16edafc359fa0e2@mail.gmail.com> <1271173965.17356.28.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271173965.17356.28.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 04:52:45PM +0100, Will Deacon wrote:
> On Tue, 2010-04-13 at 14:32 +0100, Frederic Weisbecker wrote:
> > (WARNING: I've browsed the ARMv7 breakpoints implementation
> > but I may have an erratic/incomplete understanding, then parts
> > of this review might make little sense)
> > 
> It looks like you've understood it correctly. Actually, I have
> a disclaimer of my own; I'm using a new mail client in the hope
> that LKML won't drop my messages. Anyway...


Looks like that worked as well :)



> > 2010/3/10 Will Deacon <will.deacon@arm.com>:
> > > The hw-breakpoint framework in the kernel requires architecture-specific
> > > support in order to install, remove, validate and manage hardware
> > > breakpoints.
> > >
> > > This patch adds preliminary support for this framework to the ARM
> > > architecture, but restricts the number of watchpoints to a single resource
> > > to get around the fact that the Data Fault Address Register is unpredictable
> > > when a watchpoint debug exception is taken.
> > 
> > What do you mean here by unpredictable? It would be a pity to limit the
> > resources to one register.
> > 
> By unpredictable I mean that the value in the DFAR is not defined to
> correspond to the causative address in any way. This isn't the case
> for a standard data abort, but it is in the case of a watchpoint
> exception.



Ok.



> > 
> > > +}
> > > +
> > > +/* Determine number of WRP registers available. */
> > > +static int get_num_wrps(void)
> > > +{
> > > +       /*
> > > +        * FIXME: When a watchpoint fires, the only way to work out which
> > > +        * watchpoint it was is by disassembling the faulting instruction
> > > +        * and working out the address of the memory access.
> > 
> > Doh! That must explain the problem with DFAR...
> > That's really not convenient :-(
> > 
> I know, it makes life a lot harder for us. The most annoying thing is that
> I'm yet to find a real implementation that *doesn't* set the DFAR to what
> we want - we just can't rely on that!


You mean that sometimes DFAR doesn't have the true ip origin of the
exception?
May be you can check the trapped regs to find the instruction pointer
that caused the exception?


 
> > Ah and it will make ptrace support easier: the user writes into the val/ctrl
> > fields directly as if they were the true registers, then you can just validate
> > the fields you want without bitwise ops.
> > 
> I'm unsure about this. As mainline stands, ARM has no ptrace support for the
> hardware breakpoint registers. This means that we could expose the
> hardware resources in an idealised fashion via ptrace so that if the
> interface varies between CPUs, userspace doesn't need to care. I had a
> crack at this with another patch in the series here:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2010-March/011169.html



Ah, indeed if you need to abstract out various ARM versions, that's quite sensitive.
I'm going to look at this thread too.



 
> > You seem to make a wrong assumption here.
> > This is not because the breakpoint is task-bound that we don't
> > want it to trigger on the kernel. We may want to trigger breakpoints
> > on tasklist_lock accesses from a given task.
> 
> > The only case for which we don't want it to trigger on the kernel
> > is for ptrace breakpoints.
> > 
> Surely we can't have breakpoints triggering on *any* part of the
> breakpoint handling code path? Otherwise we'll just get stuck. That's
> why I disallow breakpoints in the exception section.



Ah indeed you really need to protect against recursion.

But I'm unclear about the difference between Supervisor and System.
May be System means the common kernel ring? And you enter into
Supervisor when an exception triggers?

Do these exceptions also concern page faults and not only debug
exceptions?

 
> > I guess I should remove this tsk parameter as it makes the things
> > only confusing. We should simply create ptrace breakpoints with
> > bp->attr.exclude_kernel set to 1.
> 
> Sounds good to me. That also means that it's one less thing for the arch
> to worry about!


Yeah!



> I'll take a look at the new constraints and allocation patches you
> posted this morning and then adjust these patches accordingly.


Thanks.

