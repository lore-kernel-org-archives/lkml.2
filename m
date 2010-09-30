Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab0I3XPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:15:08 -0400
Received: from www.tglx.de ([62.245.132.106]:52274 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab0I3XPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:15:06 -0400
Message-Id: <20100930221351.682772535@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:14:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 00/47] Sparse irq rework
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series cleans up and mostly reimplements the core
sparse irq implementation and sanitizes the most complex (ab)user:
arch/x86

The series is based on the previous rework of irq chip functions which
is available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/core

A combined throwaway git repository with all the following patches on top of
tip/irq/core is available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-sparse-irq.git

The overall changes are (full changelog below):
    56 files changed, 1229 insertions(+), 1682 deletions(-)

The series consists of 3 parts:

    - cleanup of kernel/irq code and implementation of new allocator
    - conversion of x86 to new irq_chip functions and new allocator
    - trivial cleanup of the remaining users and removal of the old stuff

It's fully bisectable and survived a night of testing in my testfarm.

There are two bugfix patches (1/47, 2/47), which resulted of staring
at that maze for way too long. They are targeted for mainline urgent,
but I left them in the queue to avoid further churn.


Rationale:
----------

The current sparse_irq allocator has several short comings due to
failures in the design or the lack of it:

 - Requires iteration over the number of active irqs to find a free slot
   Some architectures have grown their own workarounds for this.

 - Freeing of irq descriptors is not possible

 - Racy between create_irq_nr and destroy_irq plugged by horrible
   callbacks

 - Migration of active irq descriptors is not possible

 - No bulk allocation of irq ranges

Aside of that the sparse irq design failure caused that we sprinkled
irq_desc references all over the place outside of kernel/irq/. That
makes it extremly hard to do the core changes which are necessary to
do further cleanups and improvements like he migration of active irq
descriptors. The arch code needs only to know about the irq chip and
the data associated with the irq. The irq descriptor itself is solely
a core code data structure.

The reason is that with the non sparse code access to the irq data was
just array pointer math and most code (aside of the old __do_IRQ()
users) used the provided accessor functions.

With sparse it requires a radix tree lookup, which casued performance
problems. Instead of tackling the problem at the chip function level
and handing down a pointer to the associated data instead of an irq
number, the low level code acquired a reference to irq_desc and
populated that all over the place. Yeah, it's easier than doing a full
cleanup and a sensible migration path, but the resulting mess is just
disgusting.

The previous chip functions series on which this series is based is
addressing this issue on the chip level side by handing down the
associated interrupt data instead of the interruut number. The x86
cleanup is making use of it.


New implementation:
-------------------

I've implemented a sane allocator which fixes the above short comings
(though migration of active descriptors still needs a full tree wide
cleanup of the direct and mostly unlocked access to irq_desc).

The new allocator still uses a radix_tree, but uses a bitmap for
keeping track of allocated irq numbers. That results in:

 - Fast lookup of a free slot

 - The removal of disposed descriptors (destroy_irq())

 - Prevents the create/destroy race

 - Bulk (de)allocation of consecutive irq ranges

 - Migration of life descriptors after further cleanups

The bitmap is also used in the SPARSE_IRQ=n case for lookup and
raceless (de)allocation of irq numbers. So it removes the requirement
for looping through the descriptor array to find slots.

Right now it uses sparse_irq_lock to protect the bitmap and the radix
tree, but after cleaning up all users we should be able to convert
that to a mutex and switch the radix_tree and descriptor allocations
to GFP_KERNEL.

Note, that I wanted to use lib/idr.c code for it, but idr/ida lacks
bulk allocation and a bitmap based iterator function, so I decided to
open code it for now. That's definitely something which could be
useful for others as well, but I have only a limited coding power.

There are some trivial preparatory patches as well, which touch places
all over the tree to make the conversion and cleanup simpler.


Full conversion and clean up of x86:
------------------------------------

I spent quite a time to come up with a sane and splitable concept,
which does not reach out into drivers/pci/[msi|ht|dmar] and whatever.

But that's simply impossible because everything is twisted together
mainly by optimization hacks done over time. (i.e. handing down
irq_desc to low level msi functions instead of irq_desc.msi_desc would
have kept the mess confined to x86).

So I went there and started to convert stuff piece by piece in x86 and
added the drivers/pci/* fixes as separate patches along the way. Not
nice, but it turned out to be the only way which avoided even more
churn.


Cleanup of leftovers:
---------------------

The leftovers (powerpc, arm, sh) have been converted with minimal
effort to allow the removal of the core code gunk. Not urgent stuff

There are more things which might be cleaned up, but that's not the
scope of this work.


Further work:
-------------

 - Cleanup the irq_desc references all over the tree, which should become
   easier after the remaining __do_IRQ() users are gone.

 - Implement migration of active irq descriptors

 - Implement node bound late allocation of low level irq vectors which
   solves an existing (SGI) problem on large machines.


How to merge:
-------------

It needs:

   - ack to the new allocator design

   - ack to merge the whole arch/!x86 and driver related cleanups
     along with the core changes and the x86 cleanup


Thoughts ?

Thanks,

	tglx
---

 b/Documentation/DocBook/genericirq.tmpl  |   82 +--
 b/arch/arm/include/asm/hw_irq.h          |    2 
 b/arch/arm/kernel/irq.c                  |   30 -
 b/arch/arm/mach-davinci/gpio.c           |    2 
 b/arch/arm/mach-iop13xx/msi.c            |    8 
 b/arch/ia64/kernel/msi_ia64.c            |    8 
 b/arch/ia64/sn/kernel/msi_sn.c           |    4 
 b/arch/powerpc/include/asm/hw_irq.h      |    2 
 b/arch/powerpc/kernel/irq.c              |   32 -
 b/arch/powerpc/platforms/cell/axon_msi.c |    6 
 b/arch/powerpc/platforms/pseries/xics.c  |    2 
 b/arch/powerpc/sysdev/fsl_msi.c          |    4 
 b/arch/powerpc/sysdev/mpic_pasemi_msi.c  |   22 
 b/arch/powerpc/sysdev/mpic_u3msi.c       |   16 
 b/arch/sh/kernel/cpu/irq/ipr.c           |    6 
 b/arch/sh/kernel/irq.c                   |    2 
 b/arch/sparc/kernel/pci_msi.c            |    8 
 b/arch/x86/Kconfig                       |    1 
 b/arch/x86/include/asm/hpet.h            |   10 
 b/arch/x86/include/asm/hw_irq.h          |    7 
 b/arch/x86/include/asm/i8259.h           |    2 
 b/arch/x86/kernel/apb_timer.c            |   54 --
 b/arch/x86/kernel/apic/io_apic.c         |  812 +++++++++++--------------------
 b/arch/x86/kernel/apic/nmi.c             |    2 
 b/arch/x86/kernel/hpet.c                 |   18 
 b/arch/x86/kernel/i8259.c                |   63 +-
 b/arch/x86/kernel/irqinit.c              |   17 
 b/arch/x86/kernel/smpboot.c              |    4 
 b/arch/x86/kernel/uv_irq.c               |   55 --
 b/arch/x86/kernel/visws_quirks.c         |  140 +----
 b/arch/x86/lguest/boot.c                 |   18 
 b/drivers/isdn/hisax/config.c            |   18 
 b/drivers/isdn/hisax/hisax.h             |    1 
 b/drivers/pci/dmar.c                     |    8 
 b/drivers/pci/htirq.c                    |   22 
 b/drivers/pci/msi.c                      |   38 -
 b/drivers/sh/intc.c                      |   37 -
 b/drivers/xen/events.c                   |   23 
 b/include/linux/dmar.h                   |    5 
 b/include/linux/htirq.h                  |    5 
 b/include/linux/interrupt.h              |    3 
 b/include/linux/irq.h                    |  195 +++----
 b/include/linux/irqnr.h                  |    5 
 b/include/linux/lockdep.h                |    8 
 b/include/linux/msi.h                    |   13 
 b/init/main.c                            |    1 
 b/kernel/irq/Kconfig                     |    5 
 b/kernel/irq/Makefile                    |    3 
 b/kernel/irq/chip.c                      |  138 -----
 b/kernel/irq/dummychip.c                 |   67 ++
 b/kernel/irq/handle.c                    |  344 -------------
 b/kernel/irq/internals.h                 |   11 
 b/kernel/irq/irqdesc.c                   |  377 ++++++++++++++
 b/kernel/irq/proc.c                      |   18 
 b/kernel/softirq.c                       |    7 
 kernel/irq/numa_migrate.c                |  120 ----
 56 files changed, 1229 insertions(+), 1682 deletions(-)



