Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1EEAj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 20:39:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:48312 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab1EEAjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 20:39:55 -0400
Subject: Re: [PATCH 0/6] General device tree irq domain infrastructure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Michal Simek <monstr@monstr.eu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        hpa@zytor.com, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20110504155227.GA3317@ponder.secretlab.ca>
References: <20110428192227.8979.49181.stgit@ponder>
	 <1304386999.2513.293.camel@pasglop>
	 <20110504155227.GA3317@ponder.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 10:39:13 +1000
Message-ID: <1304555953.2513.390.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I completely agree that irq domains are a generically useful feature
> for architectures, and it should be made available.  I also completely
> agree that it is orthogonal to device tree translations, which in a
> large part is why I've structured this series and the new code the
> way I have.
> 
> In this series I'm specifically addressing device tree translation,
> which is the one bit that is DT specific, and is important regardless
> of the backend translation mechanism.  In fact, the more I looked at
> it, the more it seems that the DT api really is orthogonal to the
> backend irq mapping and I don't think that the way irq_host ties them
> together is necessarily the best way to do it.  Many of the interrupt
> controllers which need to gain dt irq parsing have already been
> converted to using the irq_alloc_desc*() apis and have all the mapping
> mechanism they need, but lack a method of exposing it for DT
> translation.

But irq_alloc_desc() is purely about allocating the linux side irq
descriptors. Nothing to do with HW numbers here.

You still need a mapping mechanism, regardless of the device-tree, to
map those linux number to your HW numbers.

This is simple and eventually even 1:1 on things like x86, but the
minute you start having cascaded IRQ controllers, multiple IRQ domains,
and/or very large HW numbers that encode node IDs etc... this falls
appart.

And this is still completely orthogonal to the device-tree. 

Mapping is the important functionality. Whatever the actual allocator is
is indeed irrelevant.

> As for the mapping, I agree that the functionality is generally
> useful, I'm just not fond of the current implementation.  I think it
> is more complex than it needs to be and I'm not excited about bring it
> over to the other architectures as-is.

Nobody cares about the current implementation. What is important is
indeed the functionality. The basic thing I think everybody agrees is
that you need to extend the irq_desc (or data, whatever tglx prefers)
with two bits of information: Some identifier of the domain and some
identifier of the interrupt number within that domain.

In addition, PIC code will need a way to perform efficient reverse
mapping. You may decide that for simple IRQ controllers that handle a
small linear range of interrupts, it's kosher to simply reserve a linear
range of descriptors and use a simple offset, I'm find with that now
that we no longer live in a world constrained by NR_IRQ.

But the need for the radix tree remains for things that have massively
large potential HW numbers such as we have on powerpc.

> For the majority of fixed hw interrupt controllers it is overkill.
> There is no need for a map table when all the irq descs (<=32 of them)
> get allocated when the irq controller is instantiated and the mapping
> consists of 'virq = hw_irq + virq_base'.  For instance, with the arm
> irq controllers, it's be more than sufficient to use irq_alloc_descs
> to obtain a range of irq numbers and then a simple of_irq_domain
> registration to handle the parsing.

That's true if and only if you make NR_IRQ a non issue and if you accept
the general wastage due to unused interrupts.

The main problem has always been that hard limit which made me chose a
more efficient mechanisms. Take a mac with 2 cascaded MPICs with 256
sources each which are mostly never used. I would need an NR_IRQs of 512
with your scheme (plus 16 because I do want to continue avoiding the
"ISA" numbers), which is a waste of space, even with SPARSE_IRQ.

Now I hope eventually NR_IRQ will go away and we'll have a more
efficient mechanism to allocate descriptors and so it will become less
of an issue.

> For the cases where an interrupt controller isn't able to alloc all
> the irq descs at once, like for MSI, then yes the LINEAR and RADIX
> mappings are important.  What bothers me though is the way irq_host
> needs to use unions and the ->revmap_type value to implement multiple
> behaviours into a single type.  That's the sort of thing that can be
> broken out into a library and instantiated only by the interrupt
> controllers that actually need it.

But that's what it is really. You'll notice that on the fast path the
interrupt controller code calls directly into the "right" type of revmap
routine. You may want to refactor things a bit if you want, but the
union served me well simply because I didnt have to bother doing lots of
different alloc_bootmem back then. Nowadays, kmalloc is available much
earlier so it might have become a non issue too.

>   Similarly, it bothers me that that
> radix mapping makes up a significant portion of the code, yet it has
> only one user. 

"significant" ? Seriously ? Like 3 function calls ? It's nothing. We use
an existing radix tree facility, and the amount of code in our irq.c is
actually very small.

Originally it was living in xics in fact, but I moved it out
specifically because I wanted a common interface to remapping, so for
example, I can expose the linux -> hw mapping in debugfs generically,
among others.

>  I'd be happier if each kind of mapping had its own
> structure that embedded a generic irq_host/irq_domain with mapping
> specific ops populated to manipulate it.

Whatever, that's just plumbing, I don't care either way, that doesn't
change the fact that the concept of domain doesn't have much to do with
OF :-)

> Regardless, the immediate priority is to implement a mapper that will
> work for all architectures (or at least everything but powerpc and
> sparc).

I oppose the implementation of a new mapper that doesn't include
powerpc, that would be stupid. Either re-use ours or implement a new one
that encompass our needs. I can't talk for sparc but I wouldn't be
surprised if David thought about the same lines.

>   x86 has already implemented a skeleton irq_domain because
> there wasn't any common code for it to use.  ARM also needs the
> functionality immediately, and I don't want to see yet another
> arch-specific implementation.  I'd like to get the framework in place
> now, and grafting in mapping features as follow on patches.  That way
> the new DT users aren't blocked while waiting for us to hammer down
> the features that the other architectures don't need yet.

But the mapping code exist already. It returns a device-node as the
interrupt controller. What you then need is to establish the
relationship between that device-node and a domain in linux, and have
code to decode the content of the interrupts property.

So you need the concept of domain first, generic, and -then- you can
start adding a way to bind it to OF.

> What I /could/ have done I suppose was called it 'struct irq_domain'
> as you suggest, and allowed each translation mechanism to define its
> own match/map pair of routines, with device tree being the only one
> actually implemented at this point.  Yes, I understand that the
> core code treats the controller pointer as an anonymous cookie, but
> the api is still very device tree centric, and I'm not convinced that
> the assumption that all firmware irq representations will be an array
> of u32 values is going to hold up.

How so ?

>   I'd rather state upfront that the
> device tree translation really is device tree and let translations for
> other representation have the option of defining their own API.
> 
> However, that is not a strong objection, and if Thomas agrees with you
> then I'm okay with renaming of_irq_domain to irq_domain and moving it
> to kernel/irq/irqdomain.c.  The mapping functionality I think should
> stay out for now until we come to agreement on how it should look, and
> I'll fix up any users if the API needs to change at a later date.

But I think the mapping functionality is what needs to be sorted first.

Cheers
Ben.

> g.
> 
> 
> 
> > 
> > > PowerPC and x86 have been converted to use of_irq_domain.  MIPS and
> > > Microblaze have it enabled, but nothing actually registers domains
> > > yet, so a workaround is in place to preserve the current behaviour
> > > until it is fixed.
> > > 
> > > I'd really like to get patches 1-4 merged into 2.6.40.  Please test.
> > > I'm also running through build testing here, and when it's complete
> > > I'll push it out to a 'devicetree/irq-domain' branch on
> > > git://git.secretlab.ca/git/linux-2.6
> > > 
> > > It needs testing.  I've booted it on a powerpc board here without any
> > > apparent regressions, but that isn't a very big sample.  I've also
> > > build tested on everything I think is affected.
> > > 
> > > I'd also like to get it into linux-next.  Ben, if things checkout okay
> > > over the next few days, would you be okay with me adding it to
> > > linux-next, say around Wednesday next week?  As for merging, I think
> > > this should probably go via your powerpc tree since the that's where
> > > the bulk of the changes are, but I'm open to other suggestions).
> > > 
> > > Patches 5 & 6 are follow-on cleanup work to powerpc, but patch 6 is
> > > RFC only since there is a locking problem that I haven't fixed yet.
> > > 
> > > Cheers,
> > > g.
> > > 
> > > ---
> > > 
> > > Grant Likely (6):
> > >       powerpc: stop exporting irq_map
> > >       powerpc: make irq_{alloc,free}_virt private and remove count argument
> > >       powerpc: Make struct irq_host semi-private by moving into irqhost.h
> > >       dt: generalize of_irq_parse_and_map()
> > >       powerpc: move irq_alloc_descs_at() call into irq_alloc_virt()
> > >       powerpc: use irq_alloc_desc() to manage irq allocations
> > > 
> > > 
> > >  arch/microblaze/kernel/irq.c                     |    7 -
> > >  arch/microblaze/kernel/setup.c                   |    2 
> > >  arch/mips/kernel/prom.c                          |   14 -
> > >  arch/powerpc/include/asm/irq.h                   |   88 +------
> > >  arch/powerpc/include/asm/irqhost.h               |   27 ++
> > >  arch/powerpc/kernel/irq.c                        |  260 ++++++++++++----------
> > >  arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |    5 
> > >  arch/powerpc/platforms/52xx/media5200.c          |    5 
> > >  arch/powerpc/platforms/52xx/mpc52xx_gpt.c        |    1 
> > >  arch/powerpc/platforms/52xx/mpc52xx_pic.c        |   80 +------
> > >  arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |    5 
> > >  arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |   26 +-
> > >  arch/powerpc/platforms/86xx/gef_pic.c            |   10 -
> > >  arch/powerpc/platforms/8xx/m8xx_setup.c          |    2 
> > >  arch/powerpc/platforms/cell/axon_msi.c           |   15 +
> > >  arch/powerpc/platforms/cell/spider-pic.c         |   19 +-
> > >  arch/powerpc/platforms/embedded6xx/flipper-pic.c |    9 -
> > >  arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |    9 -
> > >  arch/powerpc/platforms/embedded6xx/wii.c         |    6 -
> > >  arch/powerpc/platforms/iseries/irq.c             |   10 -
> > >  arch/powerpc/platforms/powermac/pic.c            |   12 +
> > >  arch/powerpc/platforms/pseries/ras.c             |    4 
> > >  arch/powerpc/platforms/pseries/xics.c            |   14 +
> > >  arch/powerpc/sysdev/cpm1.c                       |    8 -
> > >  arch/powerpc/sysdev/cpm2_pic.c                   |   10 -
> > >  arch/powerpc/sysdev/fsl_msi.c                    |    3 
> > >  arch/powerpc/sysdev/i8259.c                      |    3 
> > >  arch/powerpc/sysdev/ipic.c                       |   19 +-
> > >  arch/powerpc/sysdev/mpc8xx_pic.c                 |   10 -
> > >  arch/powerpc/sysdev/mpc8xxx_gpio.c               |   13 +
> > >  arch/powerpc/sysdev/mpic.c                       |   33 +--
> > >  arch/powerpc/sysdev/mpic_msi.c                   |    3 
> > >  arch/powerpc/sysdev/mpic_pasemi_msi.c            |    5 
> > >  arch/powerpc/sysdev/mv64x60_pic.c                |   14 +
> > >  arch/powerpc/sysdev/qe_lib/qe_ic.c               |    9 -
> > >  arch/powerpc/sysdev/uic.c                        |   13 +
> > >  arch/powerpc/sysdev/xilinx_intc.c                |    9 -
> > >  arch/x86/include/asm/irq_controller.h            |   12 -
> > >  arch/x86/include/asm/prom.h                      |    1 
> > >  arch/x86/kernel/devicetree.c                     |   77 +------
> > >  drivers/of/irq.c                                 |  118 ++++++++++
> > >  include/linux/of_irq.h                           |   31 +++
> > >  42 files changed, 504 insertions(+), 517 deletions(-)
> > >  create mode 100644 arch/powerpc/include/asm/irqhost.h
> > >  delete mode 100644 arch/x86/include/asm/irq_controller.h
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


