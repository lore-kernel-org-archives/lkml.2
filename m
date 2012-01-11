Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab2AKUWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:22:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44193 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab2AKUWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:22:35 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, sfr@canb.auug.org.au
Subject: [RFC 0/14] Finish up irq_domain generalization
Date: Wed, 11 Jan 2012 13:22:03 -0700
Message-Id: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the patches that I've been working on to finish up the creation
of the generic irq_domain infrastructure.

I'm taking a different approach that I originally intended.
Originally I intended to start with the basic design of irq_host from
powerpc, but there were some things about the implementation that I
didn't like, so I was going to reimplement those bits and then migrate
powerpc over to use it.  That was a mistake and would have resulted in
a lot more work.  Instead, I should have started with the powerpc
irq_host code, moved it to a common location, and then reworked it in
place.  The powerpc code is working and well tested.  It is a lot less
risky to use it as the starting point with a nicely bisectable series
of changes to make it do what other architectures need.

In this series, patch 2 changes the skeleton irq_domain structure to
match powerpc's irq_host. Patches 3 & 4 make microblaze and powerpc
use the new irq_domain structure.  4 is a big patch that touches a lot
of files, but it is a trivial search & replace change.

Patch 5 has the most impact on ppc I think.  It removes the irq_map[]
table entirely and uses the irq_alloc_desc() functions to manage irq
number assignments.  This can be done now because the irq_data
structure contains both the hwirq number and a domain pointer.  Ben,
I've removed the smp_wmb() calls in this patch because I don't think
they're needed anymore since allocation is managed by
irq_alloc_desc(), but I may be missing something.  I could use your
feedback here.

Patch 7 wholesale moves the powerpc code into kernel/irq/irqdomain.c,
and 8, 9 & 11 are trivial cleanups.

Patch 10 changes the api to have a different function for each revmap
type.  I did this because it looked more natural for providing
revmap-specific arguments to the allocator, and I think it cleaned up
the logic somewhat.

Finally, patches 12, 13 & 14 add a legacy revmap feature needed by arm,
and converts arm to using the ppc irq_domain.

I've tested this series a bit, but it needs scrutiny and review.  I'm
posting it now so everyone can see what I'm planning to do.  I'd like
to get this into linux-next sooner rather than later to avoid
conflicts.  I'm going to create a irqdomain/next branch that I'll push
patches to and that I can use for collecting arm patches that will depend
on the new api.  I've not converted c6x, mips or microblaze, but this
series shouldn't break anything for them and conversion should be simple
to do in follow-on patches.

Please take a look and comment.  I do expect there to be bugs and
things that I've missed, but I'm hopeful that I can get any problems
sorted out quickly and get at least the first 10 patches acked for
merging in the next week or two.

TODO: write usage documentation... I'll have a patch for this before I
post v2

Cheers,
g.

[RFC 01/14] dt: Make irqdomain less verbose
[RFC 02/14] irq_domain: Make irq_domain structure match powerpc's
[RFC 03/14] irq_domain: convert microblaze from irq_host to
[RFC 04/14] irq_domain/powerpc: Use common irq_domain structure
[RFC 05/14] irq_domain/powerpc: eliminate irq_map; use
[RFC 06/14] irq_domain/powerpc: Eliminate virq_is_host()
[RFC 07/14] irq_domain: Move irq_domain code from powerpc to
[RFC 08/14] irqdomain: remove NO_IRQ from irq domain code
[RFC 09/14] irq_domain: Remove references to old irq_host names
[RFC 10/14] irq_domain: Replace irq_alloc_host() with
[RFC 11/14] powerpc: Eliminate NO_IRQ usage
[RFC 12/14] irq_domain: Add support for base irq and hwirq in legacy
[RFC 13/14] irq_domain: Remove 'new' irq_domain in favour of the ppc
[RFC 14/14] irq_domain: Remove irq_domain_add_simple()

 arch/arm/common/gic.c                            |   95 ++--
 arch/arm/common/vic.c                            |   16 +-
 arch/arm/include/asm/hardware/gic.h              |    4 +-
 arch/arm/include/asm/hardware/vic.h              |    2 +
 arch/arm/mach-exynos/common.c                    |    2 +-
 arch/arm/mach-imx/imx51-dt.c                     |    4 +-
 arch/arm/mach-imx/imx53-dt.c                     |    4 +-
 arch/arm/mach-imx/mach-imx6q.c                   |    2 +-
 arch/arm/mach-msm/board-msm8x60.c                |    8 +-
 arch/arm/mach-omap2/board-generic.c              |    2 +-
 arch/arm/mach-prima2/irq.c                       |    2 +-
 arch/arm/mach-versatile/core.c                   |    5 +-
 arch/microblaze/include/asm/irq.h                |    4 +-
 arch/microblaze/kernel/irq.c                     |    2 +-
 arch/microblaze/kernel/setup.c                   |    2 -
 arch/powerpc/Kconfig                             |    1 +
 arch/powerpc/include/asm/ehv_pic.h               |    2 +-
 arch/powerpc/include/asm/i8259.h                 |    2 +-
 arch/powerpc/include/asm/irq.h                   |  247 +--------
 arch/powerpc/include/asm/machdep.h               |    2 +-
 arch/powerpc/include/asm/mpic.h                  |    2 +-
 arch/powerpc/include/asm/parport.h               |    2 +-
 arch/powerpc/include/asm/qe_ic.h                 |   12 +-
 arch/powerpc/include/asm/xics.h                  |    2 +-
 arch/powerpc/kernel/ibmebus.c                    |    2 +-
 arch/powerpc/kernel/irq.c                        |  619 +------------------
 arch/powerpc/kernel/legacy_serial.c              |   14 +-
 arch/powerpc/kernel/pci-common.c                 |    4 +-
 arch/powerpc/kernel/pci_of_scan.c                |    2 +-
 arch/powerpc/platforms/44x/warp.c                |    2 +-
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |   20 +-
 arch/powerpc/platforms/52xx/media5200.c          |   14 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c        |   15 +-
 arch/powerpc/platforms/52xx/mpc52xx_pic.c        |   14 +-
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |   13 +-
 arch/powerpc/platforms/83xx/mpc832x_rdb.c        |    2 +-
 arch/powerpc/platforms/83xx/suspend.c            |    4 +-
 arch/powerpc/platforms/85xx/common.c             |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_cds.c        |    4 +-
 arch/powerpc/platforms/85xx/mpc85xx_ds.c         |    4 +-
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |   22 +-
 arch/powerpc/platforms/86xx/gef_pic.c            |   23 +-
 arch/powerpc/platforms/86xx/pic.c                |    4 +-
 arch/powerpc/platforms/8xx/m8xx_setup.c          |    2 +-
 arch/powerpc/platforms/cell/axon_msi.c           |   35 +-
 arch/powerpc/platforms/cell/beat.c               |    2 +-
 arch/powerpc/platforms/cell/beat_interrupt.c     |   20 +-
 arch/powerpc/platforms/cell/interrupt.c          |   27 +-
 arch/powerpc/platforms/cell/iommu.c              |    2 +-
 arch/powerpc/platforms/cell/pmu.c                |    4 +-
 arch/powerpc/platforms/cell/spider-pic.c         |   32 +-
 arch/powerpc/platforms/cell/spu_base.c           |   16 +-
 arch/powerpc/platforms/cell/spu_manage.c         |    6 +-
 arch/powerpc/platforms/chrp/setup.c              |    4 +-
 arch/powerpc/platforms/embedded6xx/flipper-pic.c |   32 +-
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |   39 +-
 arch/powerpc/platforms/iseries/irq.c             |   11 +-
 arch/powerpc/platforms/maple/pci.c               |    6 +-
 arch/powerpc/platforms/pasemi/misc.c             |    2 +-
 arch/powerpc/platforms/pasemi/setup.c            |    4 +-
 arch/powerpc/platforms/powermac/low_i2c.c        |    6 +-
 arch/powerpc/platforms/powermac/pfunc_base.c     |    4 +-
 arch/powerpc/platforms/powermac/pic.c            |   20 +-
 arch/powerpc/platforms/powermac/smp.c            |    9 +-
 arch/powerpc/platforms/powernv/opal.c            |    2 +-
 arch/powerpc/platforms/powernv/pci.c             |    4 +-
 arch/powerpc/platforms/ps3/interrupt.c           |   21 +-
 arch/powerpc/platforms/ps3/smp.c                 |    4 +-
 arch/powerpc/platforms/ps3/spu.c                 |    4 +-
 arch/powerpc/platforms/pseries/event_sources.c   |    4 +-
 arch/powerpc/platforms/pseries/msi.c             |    7 +-
 arch/powerpc/platforms/pseries/setup.c           |    4 +-
 arch/powerpc/platforms/wsp/msi.c                 |    4 +-
 arch/powerpc/platforms/wsp/opb_pic.c             |   13 +-
 arch/powerpc/sysdev/axonram.c                    |    6 +-
 arch/powerpc/sysdev/bestcomm/bestcomm.c          |    4 +-
 arch/powerpc/sysdev/cpm1.c                       |   17 +-
 arch/powerpc/sysdev/cpm2_pic.c                   |   11 +-
 arch/powerpc/sysdev/ehv_pic.c                    |   16 +-
 arch/powerpc/sysdev/fsl_gtm.c                    |    2 +-
 arch/powerpc/sysdev/fsl_ifc.c                    |    4 +-
 arch/powerpc/sysdev/fsl_lbc.c                    |    2 +-
 arch/powerpc/sysdev/fsl_msi.c                    |   21 +-
 arch/powerpc/sysdev/fsl_msi.h                    |    2 +-
 arch/powerpc/sysdev/i8259.c                      |   19 +-
 arch/powerpc/sysdev/ipic.c                       |   16 +-
 arch/powerpc/sysdev/ipic.h                       |    2 +-
 arch/powerpc/sysdev/mpc8xx_pic.c                 |   13 +-
 arch/powerpc/sysdev/mpic.c                       |   29 +-
 arch/powerpc/sysdev/mpic_msi.c                   |    2 +-
 arch/powerpc/sysdev/mpic_pasemi_msi.c            |    4 +-
 arch/powerpc/sysdev/mpic_u3msi.c                 |    4 +-
 arch/powerpc/sysdev/mv64x60_pic.c                |   13 +-
 arch/powerpc/sysdev/pmi.c                        |    2 +-
 arch/powerpc/sysdev/ppc4xx_msi.c                 |    6 +-
 arch/powerpc/sysdev/ppc4xx_soc.c                 |    2 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c               |   24 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.h               |    2 +-
 arch/powerpc/sysdev/tsi108_pci.c                 |   15 +-
 arch/powerpc/sysdev/uic.c                        |   13 +-
 arch/powerpc/sysdev/xics/icp-hv.c                |    6 +-
 arch/powerpc/sysdev/xics/icp-native.c            |    6 +-
 arch/powerpc/sysdev/xics/xics-common.c           |   27 +-
 arch/powerpc/sysdev/xilinx_intc.c                |   17 +-
 drivers/ata/pata_mpc52xx.c                       |    2 +-
 drivers/dma/fsldma.c                             |   15 +-
 drivers/dma/mpc512x_dma.c                        |    4 +-
 drivers/dma/ppc4xx/adma.c                        |    4 +-
 drivers/edac/mpc85xx_edac.c                      |    6 +-
 drivers/edac/ppc4xx_edac.c                       |    6 +-
 drivers/gpio/gpio-mpc8xxx.c                      |   13 +-
 drivers/macintosh/macio_asic.c                   |    4 +-
 drivers/macintosh/rack-meter.c                   |    2 +-
 drivers/macintosh/smu.c                          |   18 +-
 drivers/macintosh/via-cuda.c                     |    2 +-
 drivers/macintosh/via-pmu.c                      |    6 +-
 drivers/mfd/twl-core.c                           |   12 +-
 drivers/mmc/host/of_mmc_spi.c                    |    7 +-
 drivers/mtd/nand/mpc5121_nfc.c                   |    2 +-
 drivers/net/can/sja1000/sja1000_of_platform.c    |    2 +-
 drivers/net/ethernet/freescale/fs_enet/mac-fcc.c |    2 +-
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c |    2 +-
 drivers/net/ethernet/freescale/fs_enet/mac-scc.c |    2 +-
 drivers/net/ethernet/freescale/gianfar.c         |    6 +-
 drivers/net/ethernet/freescale/gianfar_ptp.c     |    2 +-
 drivers/net/ethernet/ibm/emac/core.c             |   10 +-
 drivers/net/ethernet/ibm/emac/mal.c              |    5 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c     |    4 +-
 drivers/ps3/ps3-vuart.c                          |    4 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c      |    2 +-
 drivers/tty/serial/mpc52xx_uart.c                |    4 +-
 drivers/tty/serial/pmac_zilog.c                  |    3 +-
 drivers/tty/serial/ucc_uart.c                    |    2 +-
 drivers/usb/host/ehci-xilinx-of.c                |    2 +-
 drivers/usb/host/ohci-ppc-of.c                   |    2 +-
 drivers/virt/fsl_hypervisor.c                    |    2 +-
 include/linux/irqdomain.h                        |  171 ++++--
 kernel/irq/irqdomain.c                           |  733 ++++++++++++++++++----
 sound/aoa/core/gpio-feature.c                    |    5 +-
 sound/ppc/tumbler.c                              |    8 +-
 sound/soc/fsl/fsl_ssi.c                          |    2 +-
 141 files changed, 1293 insertions(+), 1652 deletions(-)
