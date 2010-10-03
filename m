Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab0JCTRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 15:17:16 -0400
Received: from www.tglx.de ([62.245.132.106]:43306 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab0JCTRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 15:17:12 -0400
Date: Sun, 3 Oct 2010 21:16:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [patch 00/47] Sparse irq rework
In-Reply-To: <m1wrpzfctu.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1010032034420.14550@localhost6.localdomain6>
References: <20100930221351.682772535@linutronix.de> <m1wrpzfctu.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Oct 2010, Eric W. Biederman wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> > Rationale:
> > ----------
> >
> > The current sparse_irq allocator has several short comings due to
> > failures in the design or the lack of it:
> >
> >  - Requires iteration over the number of active irqs to find a free slot
> >    Some architectures have grown their own workarounds for this.
> >
> >  - Freeing of irq descriptors is not possible
> >
> >  - Racy between create_irq_nr and destroy_irq plugged by horrible
> >    callbacks
> >
> >  - Migration of active irq descriptors is not possible
> 
> I believe you have distored the design when aiming for migration
> of active irq descriptors (which you have not even implemented yet).
> 
> How do you plan to remove the radix tree lookup from the irq
> handling path?

Not at all and it's not even even a requirement to remove the lookup
for implementing live migration.

> On x86 the obvious implementation is to store a pointer to the irq_desc
> in our 256 entry per cpu tables.  Please implement this and see how
> it affects the design.  The code is pretty trivial.

Thought about that already, but that's a pure optimization which does
not change anything about the underlying problem.
 
> >From what I can see of your migration plan it seems incompatible with
> removing the radix tree look up in the path to generic_handle_irq().
> 
> >  - No bulk allocation of irq ranges
> 
> Where is that a short coming?

In embedded, where you have modular irq expanders loaded which
prefer to have a consecutive number space.

> > Aside of that the sparse irq design failure caused that we sprinkled
> > irq_desc references all over the place outside of kernel/irq/. That
> > makes it extremly hard to do the core changes which are necessary to
> > do further cleanups and improvements like he migration of active irq
> > descriptors. The arch code needs only to know about the irq chip and
> > the data associated with the irq. The irq descriptor itself is solely
> > a core code data structure.
> 
> If by core you mean arch code irq handling code certainly and
> msi fits that bill.

Right. The chip functions are changing from (unsigned int) to (struct
irq_data *data). And that's what my first series is providing.
 
> > The reason is that with the non sparse code access to the irq data was
> > just array pointer math and most code (aside of the old __do_IRQ()
> > users) used the provided accessor functions.
> >
> > With sparse it requires a radix tree lookup, which casued performance
> > problems. Instead of tackling the problem at the chip function level
> > and handing down a pointer to the associated data instead of an irq
> > number, the low level code acquired a reference to irq_desc and
> > populated that all over the place. Yeah, it's easier than doing a full
> > cleanup and a sensible migration path, but the resulting mess is just
> > disgusting.
> >
> > The previous chip functions series on which this series is based is
> > addressing this issue on the chip level side by handing down the
> > associated interrupt data instead of the interruut number. The x86
> > cleanup is making use of it.
> 
> And always handing down the data structure so you can do the same
> thing with sparse irq enabled or not is a much needed code cleanup.

Well, that's the plan. I just don't want to do the full tree sweep
myself. I have implemented a migration path in the first series which
allows a step by step cleanup of the chip implementations.
 
> > New implementation:
> > -------------------
> >
> > I've implemented a sane allocator which fixes the above short comings
> > (though migration of active descriptors still needs a full tree wide
> > cleanup of the direct and mostly unlocked access to irq_desc).
> >
> > The new allocator still uses a radix_tree, but uses a bitmap for
> > keeping track of allocated irq numbers. That results in:
> 
> I don't know that I have a problem with this but I do have a problem
> with using a bitmap.  A lot of the kernels irq usage has been distored
> because we use a compact array, that we cannot grow over time.  Using a
> bitmap here essentially removes 90% of the point of sparse irq.  The
> ability to remove a hard coded NR_IRQS from the kernel.

Well, lets look at some (un)realistic numbers:

Assume 16k cores and 32 irqs / core. That's 512k interrupts and
requires a 64k bitmap.

If we hit that limit, then we have some other more serious problems to
solve.

And I really do not see a point to have a truly random 64bit number
space for interrupts. Especially the dynamically allocated interrupts
(MSI & co) do not care about the number space at all. They care about
getting a unique number, nothing else.

> >  - Fast lookup of a free slot
> >
> >  - The removal of disposed descriptors (destroy_irq())
> >
> >  - Prevents the create/destroy race
> >
> >  - Bulk (de)allocation of consecutive irq ranges
> >
> >  - Migration of life descriptors after further cleanups
> 
> You should be able to do all of that by walking your radix tree in the
> sparse irq case.

The bitmap makes the design way simpler and gets rid of useless tree
walks and looped lookups for bulk allocations.
 
> > Full conversion and clean up of x86:
> > ------------------------------------
> >
> > I spent quite a time to come up with a sane and splitable concept,
> > which does not reach out into drivers/pci/[msi|ht|dmar] and whatever.
> >
> > But that's simply impossible because everything is twisted together
> > mainly by optimization hacks done over time. (i.e. handing down
> > irq_desc to low level msi functions instead of irq_desc.msi_desc would
> > have kept the mess confined to x86).
> 
> Those files provide the genirq irq chip implementation especially
> drivers/pci/msi.c.  Of course they will do what every other irq_chip
> implementation does to get access to data.  There is an unpleasant
> difference between which generic irq data field htirq.c uses and msi.c
> which may be worth cleaning up.  But otherwise I don't see any
> fundamental problems.

The fundamental problem I hit, was the hack which handed down irq_desc
to avoid the lookup. If it had been msi_desc in the first place, then
I would not even need to touch the msi code to cleanup x86.

> The big difference is those are the irq controllers that we have code
> for that is not necessarily architecture specific.
> 
> > So I went there and started to convert stuff piece by piece in x86 and
> > added the drivers/pci/* fixes as separate patches along the way. Not
> > nice, but it turned out to be the only way which avoided even more
> > churn.
> 
> You should be able to convert msi.c and company directly to using
> irq_data immediately following your previous patchset shouldn't you.
> Perhaps with two flavors of helper functions during the transition
> to passing irq_data everywhere.

That's already in the first series. Otherwise I would not be possible
to convert one irq chip after the other.
 
> I don't see any code in the msi code is arch specific or sparse irq
> specific.

I just did realize the irq_desc handdown to msi late, when I gradually
converted the irq chips which are used in io_apic.c. I can push that
patch further down in the queue, but that does not make a difference.
 
Thanks,

	tglx
