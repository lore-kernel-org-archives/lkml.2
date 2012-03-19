Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162154Ab2CSQdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:33:06 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38548 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab2CSQdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:33:03 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 19 Mar 2012 16:32:41 +0000
X-Google-Sender-Auth: XKDFVvdYifR1BU_ex3VPdMwiDtk
Message-ID: <CACxGe6t_eL+sBUazRJXtKAx=4BWCJMa_zFiMxM1SOXTUOUP3_Q@mail.gmail.com>
Subject: [GIT PULL] irq_domain for all architectures
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's the branch that generalizes powerpc's irq_host infrastructure
for all architectures.  You can read the full description below (also
in the signed tag).  I'm asking for this one to be pulled soon since
several of the arm branches are building on top of it.  It's quite
important for the ARM device tree migration work and to finally get
ARM off of using irq0 for normal devices.

You'll note that I *don't* have any acks from tglx (cc'd) on this
branch.  He hasn't weighed in either way though it has been on the
lists for several rounds of review and he has been cc'd.  I would
prefer to have his ack's before sending this branch, but you'll notice
that none of this code actually touches any core irq processing code
(see the diffstat).  It only handles the allocation and reverse
mapping of irqs to hwirqs so that interrupt controller drivers don't
need to open code their own each time.  Plus it is the hook that DT
irq translations are hung on.  I'm confident that it is okay to ask
you to pull it even though tglx has not given his okay.

Cheers,
g.

The following changes since commit 13d261932bbfff7f45f288c5c8cce43177cccd3b:

  Merge tag 'sound-fixes' of
git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2012-02-14
09:09:24 -0800)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/irqdomain-for-linus

for you to fetch changes up to e7cc3aca0f6a36b018934264ee20bee45dc13e29:

  dt: fix twl4030 for non-dt compile on x86 (2012-03-05 08:09:09 -0700)

----------------------------------------------------------------
Generialize powerpc's irq_host as irq_domain

This branch takes the PowerPC irq_host infrastructure (reverse mapping
from Linux IRQ numbers to hardware irq numbering), generalizes it,
renames it to irq_domain, and makes it available to all architectures.

Originally the plan has been to create an all-new irq_domain
implementation which addresses some of the powerpc shortcomings such
as not handling 1:1 mappings well, but doing that proved to be far
more difficult and invasive than generalizing the working code and
refactoring it in-place.  So, this branch rips out the 'new'
irq_domain and replaces it with the modified powerpc version (in a
fully bisectable way of course).  It converts all users over to the
new API and makes irq_domain selectable on any architecture.

No architecture is forced to enable irq_domain, but the infrastructure
is required for doing OpenFirmware style irq translations.  It will
even work on SPARC even though SPARC has it's own mechanism for
translating irqs at boot time.  MIPS, microblaze, embedded x86 and c6x
are converted too.

The resulting irq_domain code is probably still too verbose and can be
optimized more, but that can be done incrementally and is a task for
follow-on patches.

----------------------------------------------------------------
Benoit Cousson (1):
      mfd: twl-core.c: Fix the number of interrupts managed by twl4030

Grant Likely (28):
      irq_domain: add documentation and MAINTAINERS entry.
      irq_domain: Be less verbose
      irq_domain: Make irq_domain structure match powerpc's irq_host
      irq_domain: convert microblaze from irq_host to irq_domain
      irq_domain/powerpc: Use common irq_domain structure instead of irq_host
      irq_domain/powerpc: eliminate irq_map; use irq_alloc_desc() instead
      irq_domain/powerpc: Eliminate virq_is_host()
      irq_domain: Move irq_domain code from powerpc to kernel/irq
      irq_domain: remove NO_IRQ from irq domain code
      irq_domain: Remove references to old irq_host names
      irq_domain: Replace irq_alloc_host() with revmap-specific initializers
      irq_domain: Add support for base irq and hwirq in legacy mappings
      of/address: add empty static inlines for !CONFIG_OF
      irq_domain: Remove 'new' irq_domain in favour of the ppc one
      irq_domain: Remove irq_domain_add_simple()
      irq_domain: Create common xlate functions that device drivers can use
      irq_domain: constify irq_domain_ops
      irq_domain/c6x: constify irq_domain structures
      irq_domain/c6x: Use library of xlate functions
      irq_domain/powerpc: constify irq_domain_ops
      irq_domain/powerpc: Replace custom xlate functions with library functions
      irq_domain/microblaze: Convert microblaze to use irq_domains
      irq_domain/x86: Convert x86 (embedded) to use common irq_domain
      irq_domain/mips: Allow irq_domain on MIPS
      irq_domain: Centralize definition of irq_dispose_mapping()
      devicetree: Add empty of_platform_populate() for
!CONFIG_OF_ADDRESS (sparc)
      mfd: twl-core: Add IRQ_DOMAIN dependency
      dt: fix twl4030 for non-dt compile on x86

Mark Salter (1):
      irq_domain/c6x: Convert c6x to use generic irq_domain support.

Paul Gortmaker (1):
      ppc-6xx: fix build failure in flipper-pic.c and hlwd-pic.c

 Documentation/IRQ-domain.txt                     |  117 +++
 MAINTAINERS                                      |    9 +
 arch/arm/common/gic.c                            |   95 ++--
 arch/arm/common/vic.c                            |   16 +-
 arch/arm/include/asm/hardware/gic.h              |    4 +-
 arch/arm/include/asm/hardware/vic.h              |    2 +
 arch/arm/mach-exynos/common.c                    |    2 +-
 arch/arm/mach-imx/imx51-dt.c                     |    4 +-
 arch/arm/mach-imx/imx53-dt.c                     |    4 +-
 arch/arm/mach-imx/mach-imx6q.c                   |    3 +-
 arch/arm/mach-msm/board-msm8x60.c                |    8 +-
 arch/arm/mach-omap2/board-generic.c              |    2 +-
 arch/arm/mach-prima2/irq.c                       |    2 +-
 arch/arm/mach-versatile/core.c                   |    7 +-
 arch/c6x/Kconfig                                 |    1 +
 arch/c6x/include/asm/irq.h                       |  245 +-------
 arch/c6x/kernel/irq.c                            |  612 +----------------
 arch/c6x/platforms/megamod-pic.c                 |   25 +-
 arch/microblaze/Kconfig                          |    1 +
 arch/microblaze/include/asm/hardirq.h            |   16 -
 arch/microblaze/include/asm/irq.h                |   42 +-
 arch/microblaze/kernel/intc.c                    |   61 +-
 arch/microblaze/kernel/irq.c                     |   24 +-
 arch/microblaze/kernel/setup.c                   |    2 -
 arch/mips/Kconfig                                |    1 +
 arch/mips/include/asm/irq.h                      |    5 +-
 arch/mips/kernel/prom.c                          |   14 -
 arch/openrisc/include/asm/prom.h                 |   10 +-
 arch/powerpc/Kconfig                             |    1 +
 arch/powerpc/include/asm/ehv_pic.h               |    2 +-
 arch/powerpc/include/asm/i8259.h                 |    2 +-
 arch/powerpc/include/asm/irq.h                   |  247 +-------
 arch/powerpc/include/asm/mpic.h                  |    2 +-
 arch/powerpc/include/asm/xics.h                  |    2 +-
 arch/powerpc/kernel/irq.c                        |  617 +----------------
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |   12 +-
 arch/powerpc/platforms/52xx/media5200.c          |   15 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c        |   16 +-
 arch/powerpc/platforms/52xx/mpc52xx_pic.c        |   12 +-
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |   14 +-
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |   15 +-
 arch/powerpc/platforms/86xx/gef_pic.c            |   15 +-
 arch/powerpc/platforms/cell/axon_msi.c           |   29 +-
 arch/powerpc/platforms/cell/beat_interrupt.c     |   16 +-
 arch/powerpc/platforms/cell/interrupt.c          |   16 +-
 arch/powerpc/platforms/cell/spider-pic.c         |   14 +-
 arch/powerpc/platforms/embedded6xx/flipper-pic.c |   24 +-
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |   29 +-
 arch/powerpc/platforms/iseries/irq.c             |   11 +-
 arch/powerpc/platforms/powermac/pic.c            |   26 +-
 arch/powerpc/platforms/powermac/smp.c            |    9 +-
 arch/powerpc/platforms/ps3/interrupt.c           |   11 +-
 arch/powerpc/platforms/wsp/opb_pic.c             |   26 +-
 arch/powerpc/sysdev/cpm1.c                       |    9 +-
 arch/powerpc/sysdev/cpm2_pic.c                   |   23 +-
 arch/powerpc/sysdev/ehv_pic.c                    |   14 +-
 arch/powerpc/sysdev/fsl_msi.c                    |   10 +-
 arch/powerpc/sysdev/fsl_msi.h                    |    2 +-
 arch/powerpc/sysdev/i8259.c                      |   15 +-
 arch/powerpc/sysdev/ipic.c                       |   31 +-
 arch/powerpc/sysdev/ipic.h                       |    2 +-
 arch/powerpc/sysdev/mpc8xx_pic.c                 |   11 +-
 arch/powerpc/sysdev/mpic.c                       |   17 +-
 arch/powerpc/sysdev/mpic_msi.c                   |    2 +-
 arch/powerpc/sysdev/mv64x60_pic.c                |   11 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c               |   26 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.h               |    2 +-
 arch/powerpc/sysdev/tsi108_pci.c                 |   13 +-
 arch/powerpc/sysdev/uic.c                        |   26 +-
 arch/powerpc/sysdev/xics/xics-common.c           |   25 +-
 arch/powerpc/sysdev/xilinx_intc.c                |   19 +-
 arch/sparc/include/asm/prom.h                    |   10 +-
 arch/x86/Kconfig                                 |    2 +
 arch/x86/include/asm/irq_controller.h            |   12 -
 arch/x86/include/asm/prom.h                      |   10 -
 arch/x86/kernel/devicetree.c                     |  101 +--
 drivers/gpio/gpio-mpc8xxx.c                      |   30 +-
 drivers/mfd/Kconfig                              |    1 +
 drivers/mfd/twl-core.c                           |   22 +-
 drivers/net/phy/mdio-gpio.c                      |    4 +-
 drivers/of/platform.c                            |    4 +-
 include/linux/irqdomain.h                        |  191 ++++--
 include/linux/of_address.h                       |   33 +-
 include/linux/of_irq.h                           |    4 +-
 include/linux/of_platform.h                      |   15 +-
 kernel/irq/irqdomain.c                           |  828 +++++++++++++++++++---
 86 files changed, 1439 insertions(+), 2603 deletions(-)
 create mode 100644 Documentation/IRQ-domain.txt
 delete mode 100644 arch/x86/include/asm/irq_controller.h


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
