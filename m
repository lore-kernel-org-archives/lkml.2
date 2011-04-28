Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240Ab1D1UBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:01:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34135 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab1D1UBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:01:46 -0400
Subject: [PATCH 0/6] General device tree irq domain infrastructure
To: Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        hpa@zytor.com, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 28 Apr 2011 14:01:43 -0600
Message-ID: <20110428192227.8979.49181.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of this series ends up being fixups to powerpc code; but the 4th
patch is of importance to every architecture using CONFIG_OF (except
SPARC, which has its own solution).

This series (finally!) factors out device tree irq domain decoding
from arch/powerpc and makes it generic for all architectures.  The
infrastructure is quite simple.  Any interrupt controller can embed
the of_irq_domain structure and register it with the core code.  After
that, device nodes referencing interrupts on that device tree node
will trigger a call to the domain's map function.

PowerPC and x86 have been converted to use of_irq_domain.  MIPS and
Microblaze have it enabled, but nothing actually registers domains
yet, so a workaround is in place to preserve the current behaviour
until it is fixed.

I'd really like to get patches 1-4 merged into 2.6.40.  Please test.
I'm also running through build testing here, and when it's complete
I'll push it out to a 'devicetree/irq-domain' branch on
git://git.secretlab.ca/git/linux-2.6

It needs testing.  I've booted it on a powerpc board here without any
apparent regressions, but that isn't a very big sample.  I've also
build tested on everything I think is affected.

I'd also like to get it into linux-next.  Ben, if things checkout okay
over the next few days, would you be okay with me adding it to
linux-next, say around Wednesday next week?  As for merging, I think
this should probably go via your powerpc tree since the that's where
the bulk of the changes are, but I'm open to other suggestions).

Patches 5 & 6 are follow-on cleanup work to powerpc, but patch 6 is
RFC only since there is a locking problem that I haven't fixed yet.

Cheers,
g.

---

Grant Likely (6):
      powerpc: stop exporting irq_map
      powerpc: make irq_{alloc,free}_virt private and remove count argument
      powerpc: Make struct irq_host semi-private by moving into irqhost.h
      dt: generalize of_irq_parse_and_map()
      powerpc: move irq_alloc_descs_at() call into irq_alloc_virt()
      powerpc: use irq_alloc_desc() to manage irq allocations


 arch/microblaze/kernel/irq.c                     |    7 -
 arch/microblaze/kernel/setup.c                   |    2 
 arch/mips/kernel/prom.c                          |   14 -
 arch/powerpc/include/asm/irq.h                   |   88 +------
 arch/powerpc/include/asm/irqhost.h               |   27 ++
 arch/powerpc/kernel/irq.c                        |  260 ++++++++++++----------
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |    5 
 arch/powerpc/platforms/52xx/media5200.c          |    5 
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c        |    1 
 arch/powerpc/platforms/52xx/mpc52xx_pic.c        |   80 +------
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |    5 
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |   26 +-
 arch/powerpc/platforms/86xx/gef_pic.c            |   10 -
 arch/powerpc/platforms/8xx/m8xx_setup.c          |    2 
 arch/powerpc/platforms/cell/axon_msi.c           |   15 +
 arch/powerpc/platforms/cell/spider-pic.c         |   19 +-
 arch/powerpc/platforms/embedded6xx/flipper-pic.c |    9 -
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |    9 -
 arch/powerpc/platforms/embedded6xx/wii.c         |    6 -
 arch/powerpc/platforms/iseries/irq.c             |   10 -
 arch/powerpc/platforms/powermac/pic.c            |   12 +
 arch/powerpc/platforms/pseries/ras.c             |    4 
 arch/powerpc/platforms/pseries/xics.c            |   14 +
 arch/powerpc/sysdev/cpm1.c                       |    8 -
 arch/powerpc/sysdev/cpm2_pic.c                   |   10 -
 arch/powerpc/sysdev/fsl_msi.c                    |    3 
 arch/powerpc/sysdev/i8259.c                      |    3 
 arch/powerpc/sysdev/ipic.c                       |   19 +-
 arch/powerpc/sysdev/mpc8xx_pic.c                 |   10 -
 arch/powerpc/sysdev/mpc8xxx_gpio.c               |   13 +
 arch/powerpc/sysdev/mpic.c                       |   33 +--
 arch/powerpc/sysdev/mpic_msi.c                   |    3 
 arch/powerpc/sysdev/mpic_pasemi_msi.c            |    5 
 arch/powerpc/sysdev/mv64x60_pic.c                |   14 +
 arch/powerpc/sysdev/qe_lib/qe_ic.c               |    9 -
 arch/powerpc/sysdev/uic.c                        |   13 +
 arch/powerpc/sysdev/xilinx_intc.c                |    9 -
 arch/x86/include/asm/irq_controller.h            |   12 -
 arch/x86/include/asm/prom.h                      |    1 
 arch/x86/kernel/devicetree.c                     |   77 +------
 drivers/of/irq.c                                 |  118 ++++++++++
 include/linux/of_irq.h                           |   31 +++
 42 files changed, 504 insertions(+), 517 deletions(-)
 create mode 100644 arch/powerpc/include/asm/irqhost.h
 delete mode 100644 arch/x86/include/asm/irq_controller.h

