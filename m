Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1ECBsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 21:48:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:54652 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab1ECBsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 21:48:17 -0400
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
In-Reply-To: <20110428192227.8979.49181.stgit@ponder>
References: <20110428192227.8979.49181.stgit@ponder>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 11:43:19 +1000
Message-ID: <1304386999.2513.293.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 14:01 -0600, Grant Likely wrote:
> A lot of this series ends up being fixups to powerpc code; but the 4th
> patch is of importance to every architecture using CONFIG_OF (except
> SPARC, which has its own solution).
> 
> This series (finally!) factors out device tree irq domain decoding
> from arch/powerpc and makes it generic for all architectures.  The
> infrastructure is quite simple.  Any interrupt controller can embed
> the of_irq_domain structure and register it with the core code.  After
> that, device nodes referencing interrupts on that device tree node
> will trigger a call to the domain's map function.

This leads to an immediate reaction from me : why "of_irq_domain" ?

The concept of interrupt domains is completely orthogonal to "OF" and
whether you use the device-tree or not.

Having a remapping mechanism allowing to deal with multiple interrupt
domains without playing stupid numbering tricks is generally useful for
architectures, regardless of their adoption of the device-tree.

The irq domain has one and -only one- op that is related to OF which
allows to map a device node to a domain, but that's 'optional' and only
use if you use the OF resolving process. The whole mechanism can be (and
is under some circumstances on ppc) without a device-tree relationship.

We instanciate IRQs within domains manually in some cases, either
because we lack proper DT informations or bcs the IRQs come from the
firmware or as "created" out of the blue (device-tree). A domain pointer
(or NULL for the default domain) is all is needed.

Thus I object to tying this infrastructure generically to "OF" even if
it's just a mater of naming of the domain structure and location of the
code in the kernel tree.

It should basically all go into kernel/irq/domains.c or something like
that.

Cheers,
Ben.

> PowerPC and x86 have been converted to use of_irq_domain.  MIPS and
> Microblaze have it enabled, but nothing actually registers domains
> yet, so a workaround is in place to preserve the current behaviour
> until it is fixed.
> 
> I'd really like to get patches 1-4 merged into 2.6.40.  Please test.
> I'm also running through build testing here, and when it's complete
> I'll push it out to a 'devicetree/irq-domain' branch on
> git://git.secretlab.ca/git/linux-2.6
> 
> It needs testing.  I've booted it on a powerpc board here without any
> apparent regressions, but that isn't a very big sample.  I've also
> build tested on everything I think is affected.
> 
> I'd also like to get it into linux-next.  Ben, if things checkout okay
> over the next few days, would you be okay with me adding it to
> linux-next, say around Wednesday next week?  As for merging, I think
> this should probably go via your powerpc tree since the that's where
> the bulk of the changes are, but I'm open to other suggestions).
> 
> Patches 5 & 6 are follow-on cleanup work to powerpc, but patch 6 is
> RFC only since there is a locking problem that I haven't fixed yet.
> 
> Cheers,
> g.
> 
> ---
> 
> Grant Likely (6):
>       powerpc: stop exporting irq_map
>       powerpc: make irq_{alloc,free}_virt private and remove count argument
>       powerpc: Make struct irq_host semi-private by moving into irqhost.h
>       dt: generalize of_irq_parse_and_map()
>       powerpc: move irq_alloc_descs_at() call into irq_alloc_virt()
>       powerpc: use irq_alloc_desc() to manage irq allocations
> 
> 
>  arch/microblaze/kernel/irq.c                     |    7 -
>  arch/microblaze/kernel/setup.c                   |    2 
>  arch/mips/kernel/prom.c                          |   14 -
>  arch/powerpc/include/asm/irq.h                   |   88 +------
>  arch/powerpc/include/asm/irqhost.h               |   27 ++
>  arch/powerpc/kernel/irq.c                        |  260 ++++++++++++----------
>  arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |    5 
>  arch/powerpc/platforms/52xx/media5200.c          |    5 
>  arch/powerpc/platforms/52xx/mpc52xx_gpt.c        |    1 
>  arch/powerpc/platforms/52xx/mpc52xx_pic.c        |   80 +------
>  arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |    5 
>  arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |   26 +-
>  arch/powerpc/platforms/86xx/gef_pic.c            |   10 -
>  arch/powerpc/platforms/8xx/m8xx_setup.c          |    2 
>  arch/powerpc/platforms/cell/axon_msi.c           |   15 +
>  arch/powerpc/platforms/cell/spider-pic.c         |   19 +-
>  arch/powerpc/platforms/embedded6xx/flipper-pic.c |    9 -
>  arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |    9 -
>  arch/powerpc/platforms/embedded6xx/wii.c         |    6 -
>  arch/powerpc/platforms/iseries/irq.c             |   10 -
>  arch/powerpc/platforms/powermac/pic.c            |   12 +
>  arch/powerpc/platforms/pseries/ras.c             |    4 
>  arch/powerpc/platforms/pseries/xics.c            |   14 +
>  arch/powerpc/sysdev/cpm1.c                       |    8 -
>  arch/powerpc/sysdev/cpm2_pic.c                   |   10 -
>  arch/powerpc/sysdev/fsl_msi.c                    |    3 
>  arch/powerpc/sysdev/i8259.c                      |    3 
>  arch/powerpc/sysdev/ipic.c                       |   19 +-
>  arch/powerpc/sysdev/mpc8xx_pic.c                 |   10 -
>  arch/powerpc/sysdev/mpc8xxx_gpio.c               |   13 +
>  arch/powerpc/sysdev/mpic.c                       |   33 +--
>  arch/powerpc/sysdev/mpic_msi.c                   |    3 
>  arch/powerpc/sysdev/mpic_pasemi_msi.c            |    5 
>  arch/powerpc/sysdev/mv64x60_pic.c                |   14 +
>  arch/powerpc/sysdev/qe_lib/qe_ic.c               |    9 -
>  arch/powerpc/sysdev/uic.c                        |   13 +
>  arch/powerpc/sysdev/xilinx_intc.c                |    9 -
>  arch/x86/include/asm/irq_controller.h            |   12 -
>  arch/x86/include/asm/prom.h                      |    1 
>  arch/x86/kernel/devicetree.c                     |   77 +------
>  drivers/of/irq.c                                 |  118 ++++++++++
>  include/linux/of_irq.h                           |   31 +++
>  42 files changed, 504 insertions(+), 517 deletions(-)
>  create mode 100644 arch/powerpc/include/asm/irqhost.h
>  delete mode 100644 arch/x86/include/asm/irq_controller.h


