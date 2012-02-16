Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab2BPJJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:09:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63358 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab2BPJJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:09:34 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v5 00/27] irq_domain generalization and rework
Date: Thu, 16 Feb 2012 02:09:01 -0700
Message-Id: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series generalizes the "irq_host" infrastructure from powerpc
so that it can be used by all architectures and renames it to "irq_domain".

Very little has changed between v4 and this version.  A number of bug
fixes have been applied and a few refinements.  Biggest change is a
rewrite of the "mostly eliminate slow-path revmap lookups" patch to
be a lot simpler.

Benoit Cousson (1):
      mfd: twl-core.c: Fix the number of interrupts managed by twl4030

Grant Likely (25):
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
      irq_domain: remove "hint" when allocating irq numbers
      irq_domain: mostly eliminate slow-path revmap lookups
      irq_domain: For NOMAP revmap, allow users to specify the largest usable virq

Mark Salter (1):
      irq_domain/c6x: Convert c6x to use generic irq_domain support.

 Documentation/IRQ-domain.txt                     |  117 ++++
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
 arch/c6x/kernel/irq.c                            |  612 +-----------------
 arch/c6x/platforms/megamod-pic.c                 |   25 +-
 arch/microblaze/Kconfig                          |    1 +
 arch/microblaze/include/asm/hardirq.h            |   16 -
 arch/microblaze/include/asm/irq.h                |   42 +--
 arch/microblaze/kernel/intc.c                    |   61 +-
 arch/microblaze/kernel/irq.c                     |   24 +-
 arch/microblaze/kernel/setup.c                   |    2 -
 arch/powerpc/Kconfig                             |    1 +
 arch/powerpc/include/asm/ehv_pic.h               |    2 +-
 arch/powerpc/include/asm/i8259.h                 |    2 +-
 arch/powerpc/include/asm/irq.h                   |  247 +-------
 arch/powerpc/include/asm/mpic.h                  |    2 +-
 arch/powerpc/include/asm/xics.h                  |    2 +-
 arch/powerpc/kernel/irq.c                        |  617 +-----------------
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
 arch/powerpc/platforms/embedded6xx/flipper-pic.c |   30 +-
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |   35 +-
 arch/powerpc/platforms/iseries/irq.c             |   17 +-
 arch/powerpc/platforms/powermac/pic.c            |   26 +-
 arch/powerpc/platforms/powermac/smp.c            |    9 +-
 arch/powerpc/platforms/ps3/interrupt.c           |   12 +-
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
 arch/powerpc/sysdev/xics/icp-hv.c                |    2 +-
 arch/powerpc/sysdev/xics/icp-native.c            |    2 +-
 arch/powerpc/sysdev/xics/xics-common.c           |   28 +-
 arch/powerpc/sysdev/xilinx_intc.c                |   19 +-
 drivers/gpio/gpio-mpc8xxx.c                      |   30 +-
 drivers/mfd/twl-core.c                           |   16 +-
 include/linux/irqdomain.h                        |  183 ++++--
 include/linux/of_address.h                       |   33 +-
 kernel/irq/irqdomain.c                           |  764 ++++++++++++++++++----
 74 files changed, 1315 insertions(+), 2482 deletions(-)
 create mode 100644 Documentation/IRQ-domain.txt

