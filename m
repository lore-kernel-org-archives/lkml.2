Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0DMPwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:52:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57289 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654Ab0DMPwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:52:54 -0400
Subject: Re: [RFC PATCH 2/4] ARM: hw-breakpoint: add ARM backend for the 
 hw-breakpoint framework
From: Will Deacon <will.deacon@arm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <h2mc62985531004130632kd086ffe9o16edafc359fa0e2@mail.gmail.com>
References: <1268236874-7877-1-git-send-email-will.deacon@arm.com>
	 <1268236874-7877-2-git-send-email-will.deacon@arm.com>
	 <1268236874-7877-3-git-send-email-will.deacon@arm.com>
	 <h2mc62985531004130632kd086ffe9o16edafc359fa0e2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 16:52:45 +0100
Message-ID: <1271173965.17356.28.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Apr 2010 15:52:45.0706 (UTC) FILETIME=[5BFAFEA0:01CADB21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

Many thanks for taking a look at the these patches, I appreciate the
feedback.

On Tue, 2010-04-13 at 14:32 +0100, Frederic Weisbecker wrote:
> (WARNING: I've browsed the ARMv7 breakpoints implementation
> but I may have an erratic/incomplete understanding, then parts
> of this review might make little sense)
> 
It looks like you've understood it correctly. Actually, I have
a disclaimer of my own; I'm using a new mail client in the hope
that LKML won't drop my messages. Anyway...
> 
> 2010/3/10 Will Deacon <will.deacon@arm.com>:
> > The hw-breakpoint framework in the kernel requires architecture-specific
> > support in order to install, remove, validate and manage hardware
> > breakpoints.
> >
> > This patch adds preliminary support for this framework to the ARM
> > architecture, but restricts the number of watchpoints to a single resource
> > to get around the fact that the Data Fault Address Register is unpredictable
> > when a watchpoint debug exception is taken.
> 
> What do you mean here by unpredictable? It would be a pity to limit the
> resources to one register.
> 
By unpredictable I mean that the value in the DFAR is not defined to
correspond to the causative address in any way. This isn't the case
for a standard data abort, but it is in the case of a watchpoint
exception.
> 
> > +}
> > +
> > +/* Determine number of WRP registers available. */
> > +static int get_num_wrps(void)
> > +{
> > +       /*
> > +        * FIXME: When a watchpoint fires, the only way to work out which
> > +        * watchpoint it was is by disassembling the faulting instruction
> > +        * and working out the address of the memory access.
> 
> Doh! That must explain the problem with DFAR...
> That's really not convenient :-(
> 
I know, it makes life a lot harder for us. The most annoying thing is that
I'm yet to find a real implementation that *doesn't* set the DFAR to what
we want - we just can't rely on that!
> 
<snip>

> > +       /* Setup the address register. */
> > +       write_wb_reg(val_base + i, info->address);
> > +
> > +       /* Setup the control register. */
> > +       write_wb_reg(ctrl_base + i, (info->type << 3) |
> > +                       (info->privilege << 1) | (info->len << 5) | 1);

> Ok, alternatively, why not having the control register in the arch
> breakpoint structure:
> 
> u32   __reserved : 19,
>         len             :  7,
>         type           :  2,
>         privilege      :  2,
>         enabled      :  1;
> 
> It will avoid you to play with bitwise operations that may scale into dirty
> and error prone as you may support more features from the control register
> (link, mask, etc...).
> 
Nice, I like that a lot!

> Ah and it will make ptrace support easier: the user writes into the val/ctrl
> fields directly as if they were the true registers, then you can just validate
> the fields you want without bitwise ops.
> 
I'm unsure about this. As mainline stands, ARM has no ptrace support for the
hardware breakpoint registers. This means that we could expose the
hardware resources in an idealised fashion via ptrace so that if the
interface varies between CPUs, userspace doesn't need to care. I had a
crack at this with another patch in the series here:

http://lists.infradead.org/pipermail/linux-arm-kernel/2010-March/011169.html

> > +       /* Check that the virtual address is in the proper range. */
> > +       if (tsk) {
> > +               if (!(info->privilege & ARM_BREAKPOINT_USER)) {
> > +                       ret = -EFAULT;
> > +                       goto out;
> > +               }
> > +       } else {
> > +               if (!(info->privilege & ARM_BREAKPOINT_SUPER)) {
> > +                       ret = -EFAULT;
> > +                       goto out;
> > +               }
> > +       }
> 
> 
> You seem to make a wrong assumption here.
> This is not because the breakpoint is task-bound that we don't
> want it to trigger on the kernel. We may want to trigger breakpoints
> on tasklist_lock accesses from a given task.

> The only case for which we don't want it to trigger on the kernel
> is for ptrace breakpoints.
> 
Surely we can't have breakpoints triggering on *any* part of the
breakpoint handling code path? Otherwise we'll just get stuck. That's
why I disallow breakpoints in the exception section.

> I guess I should remove this tsk parameter as it makes the things
> only confusing. We should simply create ptrace breakpoints with
> bp->attr.exclude_kernel set to 1.

Sounds good to me. That also means that it's one less thing for the arch
to worry about!
> 
> > +/*
> > + * Release the user breakpoints used by ptrace.
> > + */
> > +void flush_ptrace_hw_breakpoint(struct task_struct *tsk)
> > +{
> > +       int i;
> > +       struct thread_struct *t = &tsk->thread;
> > +
> > +       for (i = 0; i < HBP_NUM; i++) {
> > +               unregister_hw_breakpoint(t->debug.hbp[i]);
> > +               t->debug.hbp[i] = NULL;
> > +       }
> > +}
> 
> 
> Do you actually support ptrace breakpoints?
> 
Yep. See the link mentioned above.
> 
> > +
> > +void hw_breakpoint_pmu_unthrottle(struct perf_event *bp)
> > +{
> > +       /* TODO */
> > +}
> 
> 
> We don't need this callback anymore, it has been removed because
> of ptrace corner cases...
> 
Ok, I'll remove it.

I'll take a look at the new constraints and allocation patches you
posted this morning and then adjust these patches accordingly.

Thanks,

Will

