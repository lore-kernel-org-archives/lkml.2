Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab1DOOdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:33:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43626 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756092Ab1DOOdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:33:01 -0400
Date: Fri, 15 Apr 2011 10:32:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Mike Frysinger <vapier@gentoo.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [uclinux-dist-devel] freezer: should barriers be smp?
In-Reply-To: <201104150034.21937.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1104151017300.2051-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011, Rafael J. Wysocki wrote:

> > > For example, there's no reason why the CPU cannot reorder things so that
> > > the "if (frozen(p))" is (speculatively) done before the "if (!freezing(p))"
> > > if there's only a compiler barrier between them.
> > 
> > That's true.  On an SMP system, smp_wmb() is identical to wmb(), so
> > there will be a true memory barrier when it is needed.  On a UP system,
> > reordering the instructions in this way will not change the final
> > result -- in particular, it won't break anything.
> > 
> > In your example, the two tests look at different flags in *p.  
> > Speculative reordering of the tests won't make any difference unless
> > one of the flags gets changed in between.  On a UP system, the only way
> > the flag can be changed is for the CPU to change it, in which case
> > the CPU would obviously know that the speculative result had to be
> > invalidated.
> 
> Note, however, that preemption may happen basically at any time, so the
> task that executes the two "if" statements can be preempted after it has
> loaded p->flags into a register and before it checks the TIF_FREEZE (if
> they are reordered).  In that case the p->flags (in memory) may be
> changed by another task in the meantime.

That's okay, because on a UP system there's only one CPU involved.  

When the other task changes p->flags, the CPU will realize that the
register containing the speculative p->flags value is now invalid.  
This will force it to re-read p->flags before testing TIF_FREEZE.

In principle, the sequence of events is no different from single-line
code doing:

	p->a = 1;
	if (p->b)
		...
	if (p->a)
		...

No CPU is ever going to mess this up, even if it does speculatively
load p->a before executing any of the other statements.

A problem can arise only when the "p->a = 1" statement is executed by a 
_different_ CPU.  In that case the original CPU has no way to tell that 
the speculative value is invalid, so a memory barrier is needed to 
prevent the speculative load.

> > > I'm quite convinced that the statement "some CPUs can reorder instructions in
> > > such a way that a compiler barrier is not sufficient to prevent breakage" is
> > > correct.
> > 
> > No.  The correct statement is "Some CPUs can reorder instructions in 
> > such a way that a compiler barrier is not sufficient to prevent 
> > breakage on SMP systems."
> 
> That's if preemption is not taken into account.

It's true even with preemption.

Besides, if this helps to convince you, recall that the task-switch
code (i.e., the scheduler) contains its own memory barriers.  If one
task gets preempted by another, these barriers will defeat instruction
reordering across the preemption boundary.

Alan Stern

