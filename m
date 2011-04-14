Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058Ab1DNOz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:55:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49895 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759025Ab1DNOzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:55:25 -0400
Date: Thu, 14 Apr 2011 10:55:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Mike Frysinger <vapier@gentoo.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [uclinux-dist-devel] freezer: should barriers be smp?
In-Reply-To: <201104140034.41727.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1104141040060.2487-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Rafael J. Wysocki wrote:

> On Thursday, April 14, 2011, Alan Stern wrote:
> > On Wed, 13 Apr 2011, Rafael J. Wysocki wrote:
> > 
> > > The above means that smp_*mb() are defined as *mb() if CONFIG_SMP is set,
> > > which basically means that *mb() are more restrictive than the corresponding
> > > smp_*mb().  More precisely, they also cover the cases in which the CPU
> > > reorders instructions on uniprocessor, which we definitely want to cover.
> > > 
> > > IOW, your patch would break things on uniprocessor where the CPU reorders
> > > instructions.
> > 
> > How could anything break on a UP system?  CPUs don't reorder 
> > instructions that drastically.  For example, no CPU will ever violate
> > this assertion:
> > 
> > 	x = 0;
> > 	y = x;
> > 	x = 1;
> > 	assert(y == 0);
> > 
> > even if it does reorder the second and third statements internally.  
> > This is guaranteed by the C language specification.
> 
> Well, you conveniently removed the patch from your reply. :-)

All the patch does is replace an instance of wmb() with smp_wmb() and 
an instance of rmb() with smp_rmb().

> For example, there's no reason why the CPU cannot reorder things so that
> the "if (frozen(p))" is (speculatively) done before the "if (!freezing(p))"
> if there's only a compiler barrier between them.

That's true.  On an SMP system, smp_wmb() is identical to wmb(), so
there will be a true memory barrier when it is needed.  On a UP system,
reordering the instructions in this way will not change the final
result -- in particular, it won't break anything.

In your example, the two tests look at different flags in *p.  
Speculative reordering of the tests won't make any difference unless
one of the flags gets changed in between.  On a UP system, the only way
the flag can be changed is for the CPU to change it, in which case
the CPU would obviously know that the speculative result had to be
invalidated.

> > > > Documentation/memory-barriers.txt:
> > > > SMP memory barriers are reduced to compiler barriers on uniprocessor compiled
> > > > systems because it is assumed that a CPU will appear to be self-consistent,
> > > > and will order overlapping accesses correctly with respect to itself.
> > > 
> > > Exactly, which is not guaranteed in general (e.g. on Alpha).  That is, some
> > > CPUs can reorder instructions in such a way that a compiler barrier is not
> > > sufficient to prevent breakage.
> > 
> > I don't think this is right.  You _can_ assume that Alphas appear to be
> > self-consistent.  If they didn't, you wouldn't be able to use them at
> > all.
> 
> I'm quite convinced that the statement "some CPUs can reorder instructions in
> such a way that a compiler barrier is not sufficient to prevent breakage" is
> correct.

No.  The correct statement is "Some CPUs can reorder instructions in 
such a way that a compiler barrier is not sufficient to prevent 
breakage on SMP systems."

Just for kicks...  Which was added to the kernel first: SMP support or 
memory barriers?  I don't know the answer; it would take a fair amount 
of digging to find out.

Alan Stern

