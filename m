Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1CYNVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:21:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:34581 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751206Ab1CYNVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:21:52 -0400
Message-Id: <20110325131617.258789658@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:21:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 00/23] ARM: Final genirq cleanup
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series cleans up the reminding open coded access to
irq_desc and converts the newly merged (sigh) msm to the new irq chip
functions.

The final patches make use of the generic show_interrupts() and
convert the namespace to the new irq_* function names. That conversion
was done with coccinelle. The last patch folds irq_set_chip and
irq_set_handler pairs into irq_set_chip_and_handler with coccinelle.

The series depends on the irq/cleanup branch in

    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

which will go to Linus later today.

If there are no objections I can push the whole lot through tip.

Thanks,

	tglx

 Kconfig                               |    1 
 common/gic.c                          |   15 ++----
 common/it8152.c                       |    4 -
 common/locomo.c                       |   17 +++---
 common/sa1111.c                       |   24 ++++-----
 common/vic.c                          |    6 +-
 include/asm/hw_irq.h                  |    8 ---
 kernel/ecard.c                        |    6 +-
 kernel/irq.c                          |   70 ++++------------------------
 mach-at91/at91cap9_devices.c          |    6 +-
 mach-at91/gpio.c                      |   43 ++++++-----------
 mach-at91/irq.c                       |    3 -
 mach-bcmring/irq.c                    |   10 ++--
 mach-clps711x/irq.c                   |    8 +--
 mach-davinci/cp_intc.c                |    4 -
 mach-davinci/gpio.c                   |   49 ++++++++------------
 mach-davinci/irq.c                    |    6 +-
 mach-dove/irq.c                       |   20 +++-----
 mach-ebsa110/core.c                   |    4 -
 mach-ep93xx/gpio.c                    |   52 ++++++++++++---------
 mach-exynos4/irq-combiner.c           |   13 ++---
 mach-exynos4/irq-eint.c               |   15 +++---
 mach-footbridge/common.c              |    3 -
 mach-footbridge/isa-irq.c             |   10 ++--
 mach-gemini/gpio.c                    |   14 ++---
 mach-gemini/irq.c                     |    6 +-
 mach-h720x/common.c                   |   22 ++++-----
 mach-h720x/cpu-h7202.c                |    6 +-
 mach-integrator/integrator_ap.c       |    4 -
 mach-integrator/integrator_cp.c       |   11 +---
 mach-iop13xx/irq.c                    |   10 ++--
 mach-iop13xx/msi.c                    |    6 +-
 mach-iop32x/irq.c                     |    3 -
 mach-iop33x/irq.c                     |    5 +-
 mach-ixp2000/core.c                   |   20 ++++----
 mach-ixp2000/ixdp2x00.c               |    6 +-
 mach-ixp2000/ixdp2x01.c               |    6 +-
 mach-ixp23xx/core.c                   |   14 ++---
 mach-ixp23xx/ixdp2351.c               |   12 ++--
 mach-ixp23xx/roadrunner.c             |    4 -
 mach-ixp4xx/avila-pci.c               |    8 +--
 mach-ixp4xx/common.c                  |    4 -
 mach-ixp4xx/coyote-pci.c              |    4 -
 mach-ixp4xx/dsmg600-pci.c             |   12 ++--
 mach-ixp4xx/fsg-pci.c                 |    6 +-
 mach-ixp4xx/gateway7001-pci.c         |    4 -
 mach-ixp4xx/goramo_mlr.c              |   12 ++--
 mach-ixp4xx/gtwx5715-pci.c            |    4 -
 mach-ixp4xx/ixdp425-pci.c             |    8 +--
 mach-ixp4xx/ixdpg425-pci.c            |    4 -
 mach-ixp4xx/nas100d-pci.c             |   10 ++--
 mach-ixp4xx/nslu2-pci.c               |    6 +-
 mach-ixp4xx/vulcan-pci.c              |    4 -
 mach-ixp4xx/wg302v2-pci.c             |    4 -
 mach-kirkwood/irq.c                   |   15 +++---
 mach-ks8695/gpio.c                    |    2 
 mach-ks8695/irq.c                     |   18 ++++---
 mach-lpc32xx/irq.c                    |   10 ++--
 mach-mmp/irq-mmp2.c                   |   18 +++----
 mach-mmp/irq-pxa168.c                 |    3 -
 mach-msm/board-msm8960.c              |    2 
 mach-msm/board-msm8x60.c              |    2 
 mach-msm/board-trout-gpio.c           |   10 ++--
 mach-msm/board-trout-mmc.c            |    2 
 mach-msm/gpio-v2.c                    |   49 ++++++++++----------
 mach-msm/gpio.c                       |   18 +++----
 mach-msm/irq-vic.c                    |    7 +-
 mach-msm/irq.c                        |    7 +-
 mach-msm/sirc.c                       |   11 ++--
 mach-mv78xx0/irq.c                    |    8 +--
 mach-mx3/mach-mx31ads.c               |    7 +-
 mach-mx5/eukrea_mbimx51-baseboard.c   |    2 
 mach-mxs/gpio.c                       |   10 ++--
 mach-mxs/icoll.c                      |    3 -
 mach-netx/generic.c                   |    6 +-
 mach-ns9xxx/board-a9m9750dev.c        |    8 +--
 mach-ns9xxx/irq.c                     |   60 ++----------------------
 mach-nuc93x/irq.c                     |    4 -
 mach-omap1/board-osk.c                |    6 +-
 mach-omap1/board-palmz71.c            |    8 +--
 mach-omap1/board-voiceblue.c          |    8 +--
 mach-omap1/fpga.c                     |   10 ++--
 mach-omap1/irq.c                      |    4 -
 mach-omap2/gpmc.c                     |    2 
 mach-omap2/irq.c                      |    3 -
 mach-orion5x/db88f5281-setup.c        |    4 -
 mach-orion5x/irq.c                    |    8 +--
 mach-orion5x/rd88f5182-setup.c        |    4 -
 mach-orion5x/terastation_pro2-setup.c |    2 
 mach-orion5x/ts209-setup.c            |    4 -
 mach-pnx4008/irq.c                    |   10 ++--
 mach-pxa/balloon3.c                   |    8 +--
 mach-pxa/cm-x2xx-pci.c                |    5 +-
 mach-pxa/cm-x300.c                    |    2 
 mach-pxa/irq.c                        |   12 ++--
 mach-pxa/lpd270.c                     |    8 +--
 mach-pxa/lubbock.c                    |    8 +--
 mach-pxa/mainstone.c                  |    8 +--
 mach-pxa/pcm990-baseboard.c           |    8 +--
 mach-pxa/pxa3xx.c                     |    4 -
 mach-pxa/viper.c                      |    8 +--
 mach-pxa/zeus.c                       |   19 ++++---
 mach-rpc/irq.c                        |   14 ++---
 mach-s3c2410/bast-irq.c               |    6 +-
 mach-s3c2412/irq.c                    |   12 ++--
 mach-s3c2416/irq.c                    |    8 +--
 mach-s3c2440/irq.c                    |   10 ++--
 mach-s3c2440/s3c244x-irq.c            |   14 ++---
 mach-s3c2443/irq.c                    |    8 +--
 mach-s3c64xx/irq-eint.c               |   13 ++---
 mach-sa1100/cerf.c                    |    2 
 mach-sa1100/irq.c                     |   16 +++---
 mach-sa1100/neponset.c                |    8 +--
 mach-sa1100/pleb.c                    |    2 
 mach-shark/irq.c                      |    3 -
 mach-shmobile/board-ap4evb.c          |    4 -
 mach-shmobile/board-mackerel.c        |    6 +-
 mach-shmobile/intc-sh7367.c           |    6 +-
 mach-shmobile/intc-sh7372.c           |    6 +-
 mach-shmobile/intc-sh7377.c           |    6 +-
 mach-tcc8k/irq.c                      |    6 +-
 mach-tegra/gpio.c                     |   83 ++++------------------------------
 mach-tegra/include/mach/suspend.h     |    2 
 mach-tegra/irq.c                      |    5 --
 mach-ux500/modem-irq-db5500.c         |    3 -
 mach-versatile/core.c                 |    6 +-
 mach-vt8500/irq.c                     |   14 ++---
 mach-w90x900/irq.c                    |    4 -
 plat-mxc/3ds_debugboard.c             |   14 +----
 plat-mxc/avic.c                       |    4 -
 plat-mxc/gpio.c                       |   24 +++++----
 plat-mxc/irq-common.c                 |    4 -
 plat-mxc/tzic.c                       |    4 -
 plat-nomadik/gpio.c                   |   50 +++++++++++---------
 plat-omap/gpio.c                      |   31 ++++--------
 plat-orion/gpio.c                     |   31 +++++-------
 plat-orion/irq.c                      |    8 +--
 plat-pxa/gpio.c                       |    6 +-
 plat-s3c24xx/irq.c                    |   43 ++++++++---------
 plat-s5p/irq-eint.c                   |    7 +-
 plat-s5p/irq-gpioint.c                |   22 ++++-----
 plat-samsung/irq-uart.c               |   10 +---
 plat-samsung/irq-vic-timer.c          |   13 ++---
 plat-samsung/wakeup-mask.c            |    8 +--
 plat-spear/shirq.c                    |   12 ++--
 plat-stmp3xxx/irq.c                   |    3 -
 plat-stmp3xxx/pinmux.c                |   13 ++---
 147 files changed, 714 insertions(+), 941 deletions(-)

