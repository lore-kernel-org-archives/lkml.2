Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab1EDPwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:52:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53441 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab1EDPwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:52:34 -0400
Date: Wed, 4 May 2011 09:52:27 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Simek <monstr@monstr.eu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        hpa@zytor.com, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 0/6] General device tree irq domain infrastructure
Message-ID: <20110504155227.GA3317@ponder.secretlab.ca>
References: <20110428192227.8979.49181.stgit@ponder>
 <1304386999.2513.293.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304386999.2513.293.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 11:43:19AM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2011-04-28 at 14:01 -0600, Grant Likely wrote:
> > A lot of this series ends up being fixups to powerpc code; but the 4th
> > patch is of importance to every architecture using CONFIG_OF (except
> > SPARC, which has its own solution).
> > 
> > This series (finally!) factors out device tree irq domain decoding
> > from arch/powerpc and makes it generic for all architectures.  The
> > infrastructure is quite simple.  Any interrupt controller can embed
> > the of_irq_domain structure and register it with the core code.  After
> > that, device nodes referencing interrupts on that device tree node
> > will trigger a call to the domain's map function.
> 
> This leads to an immediate reaction from me : why "of_irq_domain" ?
> 
> The concept of interrupt domains is completely orthogonal to "OF" and
> whether you use the device-tree or not.
> 
> Having a remapping mechanism allowing to deal with multiple interrupt
> domains without playing stupid numbering tricks is generally useful for
> architectures, regardless of their adoption of the device-tree.
> 
> The irq domain has one and -only one- op that is related to OF which
> allows to map a device node to a domain, but that's 'optional' and only
> use if you use the OF resolving process. The whole mechanism can be (and
> is under some circumstances on ppc) without a device-tree relationship.
> 
> We instanciate IRQs within domains manually in some cases, either
> because we lack proper DT informations or bcs the IRQs come from the
> firmware or as "created" out of the blue (device-tree). A domain pointer
> (or NULL for the default domain) is all is needed.
> 
> Thus I object to tying this infrastructure generically to "OF" even if
> it's just a mater of naming of the domain structure and location of the
> code in the kernel tree.
> 
> It should basically all go into kernel/irq/domains.c or something like
> that.

I completely agree that irq domains are a generically useful feature
for architectures, and it should be made available.  I also completely
agree that it is orthogonal to device tree translations, which in a
large part is why I've structured this series and the new code the
way I have.

In this series I'm specifically addressing device tree translation,
which is the one bit that is DT specific, and is important regardless
of the backend translation mechanism.  In fact, the more I looked at
it, the more it seems that the DT api really is orthogonal to the
backend irq mapping and I don't think that the way irq_host ties them
together is necessarily the best way to do it.  Many of the interrupt
controllers which need to gain dt irq parsing have already been
converted to using the irq_alloc_desc*() apis and have all the mapping
mechanism they need, but lack a method of exposing it for DT
translation.

As for the mapping, I agree that the functionality is generally
useful, I'm just not fond of the current implementation.  I think it
is more complex than it needs to be and I'm not excited about bring it
over to the other architectures as-is.

For the majority of fixed hw interrupt controllers it is overkill.
There is no need for a map table when all the irq descs (<=32 of them)
get allocated when the irq controller is instantiated and the mapping
consists of 'virq = hw_irq + virq_base'.  For instance, with the arm
irq controllers, it's be more than sufficient to use irq_alloc_descs
to obtain a range of irq numbers and then a simple of_irq_domain
registration to handle the parsing.

For the cases where an interrupt controller isn't able to alloc all
the irq descs at once, like for MSI, then yes the LINEAR and RADIX
mappings are important.  What bothers me though is the way irq_host
needs to use unions and the ->revmap_type value to implement multiple
behaviours into a single type.  That's the sort of thing that can be
broken out into a library and instantiated only by the interrupt
controllers that actually need it.  Similarly, it bothers me that that
radix mapping makes up a significant portion of the code, yet it has
only one user.  I'd be happier if each kind of mapping had its own
structure that embedded a generic irq_host/irq_domain with mapping
specific ops populated to manipulate it.

Regardless, the immediate priority is to implement a mapper that will
work for all architectures (or at least everything but powerpc and
sparc).  x86 has already implemented a skeleton irq_domain because
there wasn't any common code for it to use.  ARM also needs the
functionality immediately, and I don't want to see yet another
arch-specific implementation.  I'd like to get the framework in place
now, and grafting in mapping features as follow on patches.  That way
the new DT users aren't blocked while waiting for us to hammer down
the features that the other architectures don't need yet.

What I /could/ have done I suppose was called it 'struct irq_domain'
as you suggest, and allowed each translation mechanism to define its
own match/map pair of routines, with device tree being the only one
actually implemented at this point.  Yes, I understand that the
core code treats the controller pointer as an anonymous cookie, but
the api is still very device tree centric, and I'm not convinced that
the assumption that all firmware irq representations will be an array
of u32 values is going to hold up.  I'd rather state upfront that the
device tree translation really is device tree and let translations for
other representation have the option of defining their own API.

However, that is not a strong objection, and if Thomas agrees with you
then I'm okay with renaming of_irq_domain to irq_domain and moving it
to kernel/irq/irqdomain.c.  The mapping functionality I think should
stay out for now until we come to agreement on how it should look, and
I'll fix up any users if the API needs to change at a later date.

g.



> 
> > PowerPC and x86 have been converted to use of_irq_domain.  MIPS and
> > Microblaze have it enabled, but nothing actually registers domains
> > yet, so a workaround is in place to preserve the current behaviour
> > until it is fixed.
> > 
> > I'd really like to get patches 1-4 merged into 2.6.40.  Please test.
> > I'm also running through build testing here, and when it's complete
> > I'll push it out to a 'devicetree/irq-domain' branch on
> > git://git.secretlab.ca/git/linux-2.6
> > 
> > It needs testing.  I've booted it on a powerpc board here without any
> > apparent regressions, but that isn't a very big sample.  I've also
> > build tested on everything I think is affected.
> > 
> > I'd also like to get it into linux-next.  Ben, if things checkout okay
> > over the next few days, would you be okay with me adding it to
> > linux-next, say around Wednesday next week?  As for merging, I think
> > this should probably go via your powerpc tree since the that's where
> > the bulk of the changes are, but I'm open to other suggestions).
> > 
> > Patches 5 & 6 are follow-on cleanup work to powerpc, but patch 6 is
> > RFC only since there is a locking problem that I haven't fixed yet.
> > 
> > Cheers,
> > g.
> > 
> > ---
> > 
> > Grant Likely (6):
> >       powerpc: stop exporting irq_map
> >       powerpc: make irq_{alloc,free}_virt private and remove count argument
> >       powerpc: Make struct irq_host semi-private by moving into irqhost.h
> >       dt: generalize of_irq_parse_and_map()
> >       powerpc: move irq_alloc_descs_at() call into irq_alloc_virt()
> >       powerpc: use irq_alloc_desc() to manage irq allocations
> > 
> > 
> >  arch/microblaze/kernel/irq.c                     |    7 -
> >  arch/microblaze/kernel/setup.c                   |    2 
> >  arch/mips/kernel/prom.c                          |   14 -
> >  arch/powerpc/include/asm/irq.h                   |   88 +------
> >  arch/powerpc/include/asm/irqhost.h               |   27 ++
> >  arch/powerpc/kernel/irq.c                        |  260 ++++++++++++----------
> >  arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |    5 
> >  arch/powerpc/platforms/52xx/media5200.c          |    5 
> >  arch/powerpc/platforms/52xx/mpc52xx_gpt.c        |    1 
> >  arch/powerpc/platforms/52xx/mpc52xx_pic.c        |   80 +------
> >  arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |    5 
> >  arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |   26 +-
> >  arch/powerpc/platforms/86xx/gef_pic.c            |   10 -
> >  arch/powerpc/platforms/8xx/m8xx_setup.c          |    2 
> >  arch/powerpc/platforms/cell/axon_msi.c           |   15 +
> >  arch/powerpc/platforms/cell/spider-pic.c         |   19 +-
> >  arch/powerpc/platforms/embedded6xx/flipper-pic.c |    9 -
> >  arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |    9 -
> >  arch/powerpc/platforms/embedded6xx/wii.c         |    6 -
> >  arch/powerpc/platforms/iseries/irq.c             |   10 -
> >  arch/powerpc/platforms/powermac/pic.c            |   12 +
> >  arch/powerpc/platforms/pseries/ras.c             |    4 
> >  arch/powerpc/platforms/pseries/xics.c            |   14 +
> >  arch/powerpc/sysdev/cpm1.c                       |    8 -
> >  arch/powerpc/sysdev/cpm2_pic.c                   |   10 -
> >  arch/powerpc/sysdev/fsl_msi.c                    |    3 
> >  arch/powerpc/sysdev/i8259.c                      |    3 
> >  arch/powerpc/sysdev/ipic.c                       |   19 +-
> >  arch/powerpc/sysdev/mpc8xx_pic.c                 |   10 -
> >  arch/powerpc/sysdev/mpc8xxx_gpio.c               |   13 +
> >  arch/powerpc/sysdev/mpic.c                       |   33 +--
> >  arch/powerpc/sysdev/mpic_msi.c                   |    3 
> >  arch/powerpc/sysdev/mpic_pasemi_msi.c            |    5 
> >  arch/powerpc/sysdev/mv64x60_pic.c                |   14 +
> >  arch/powerpc/sysdev/qe_lib/qe_ic.c               |    9 -
> >  arch/powerpc/sysdev/uic.c                        |   13 +
> >  arch/powerpc/sysdev/xilinx_intc.c                |    9 -
> >  arch/x86/include/asm/irq_controller.h            |   12 -
> >  arch/x86/include/asm/prom.h                      |    1 
> >  arch/x86/kernel/devicetree.c                     |   77 +------
> >  drivers/of/irq.c                                 |  118 ++++++++++
> >  include/linux/of_irq.h                           |   31 +++
> >  42 files changed, 504 insertions(+), 517 deletions(-)
> >  create mode 100644 arch/powerpc/include/asm/irqhost.h
> >  delete mode 100644 arch/x86/include/asm/irq_controller.h
> 
> 
