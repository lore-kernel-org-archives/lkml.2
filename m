Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1DNWeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:34:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52037 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab1DNWeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:34:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [uclinux-dist-devel] freezer: should barriers be smp?
Date: Fri, 15 Apr 2011 00:34:21 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1104141040060.2487-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1104141040060.2487-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104150034.21937.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 14, 2011, Alan Stern wrote:
> On Thu, 14 Apr 2011, Rafael J. Wysocki wrote:
> 
> > On Thursday, April 14, 2011, Alan Stern wrote:
> > > On Wed, 13 Apr 2011, Rafael J. Wysocki wrote:
> > > 
> > > > The above means that smp_*mb() are defined as *mb() if CONFIG_SMP is set,
> > > > which basically means that *mb() are more restrictive than the corresponding
> > > > smp_*mb().  More precisely, they also cover the cases in which the CPU
> > > > reorders instructions on uniprocessor, which we definitely want to cover.
> > > > 
> > > > IOW, your patch would break things on uniprocessor where the CPU reorders
> > > > instructions.
> > > 
> > > How could anything break on a UP system?  CPUs don't reorder 
> > > instructions that drastically.  For example, no CPU will ever violate
> > > this assertion:
> > > 
> > > 	x = 0;
> > > 	y = x;
> > > 	x = 1;
> > > 	assert(y == 0);
> > > 
> > > even if it does reorder the second and third statements internally.  
> > > This is guaranteed by the C language specification.
> > 
> > Well, you conveniently removed the patch from your reply. :-)
> 
> All the patch does is replace an instance of wmb() with smp_wmb() and 
> an instance of rmb() with smp_rmb().
> 
> > For example, there's no reason why the CPU cannot reorder things so that
> > the "if (frozen(p))" is (speculatively) done before the "if (!freezing(p))"
> > if there's only a compiler barrier between them.
> 
> That's true.  On an SMP system, smp_wmb() is identical to wmb(), so
> there will be a true memory barrier when it is needed.  On a UP system,
> reordering the instructions in this way will not change the final
> result -- in particular, it won't break anything.
> 
> In your example, the two tests look at different flags in *p.  
> Speculative reordering of the tests won't make any difference unless
> one of the flags gets changed in between.  On a UP system, the only way
> the flag can be changed is for the CPU to change it, in which case
> the CPU would obviously know that the speculative result had to be
> invalidated.

Note, however, that preemption may happen basically at any time, so the
task that executes the two "if" statements can be preempted after it has
loaded p->flags into a register and before it checks the TIF_FREEZE (if
they are reordered).  In that case the p->flags (in memory) may be
changed by another task in the meantime.

> > > > > Documentation/memory-barriers.txt:
> > > > > SMP memory barriers are reduced to compiler barriers on uniprocessor compiled
> > > > > systems because it is assumed that a CPU will appear to be self-consistent,
> > > > > and will order overlapping accesses correctly with respect to itself.
> > > > 
> > > > Exactly, which is not guaranteed in general (e.g. on Alpha).  That is, some
> > > > CPUs can reorder instructions in such a way that a compiler barrier is not
> > > > sufficient to prevent breakage.
> > > 
> > > I don't think this is right.  You _can_ assume that Alphas appear to be
> > > self-consistent.  If they didn't, you wouldn't be able to use them at
> > > all.
> > 
> > I'm quite convinced that the statement "some CPUs can reorder instructions in
> > such a way that a compiler barrier is not sufficient to prevent breakage" is
> > correct.
> 
> No.  The correct statement is "Some CPUs can reorder instructions in 
> such a way that a compiler barrier is not sufficient to prevent 
> breakage on SMP systems."

That's if preemption is not taken into account.

> Just for kicks...  Which was added to the kernel first: SMP support or 
> memory barriers?  I don't know the answer; it would take a fair amount 
> of digging to find out.

I have no idea. :-)

Rafael
