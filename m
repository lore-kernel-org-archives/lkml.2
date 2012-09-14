Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab2INQ0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:26:05 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:36423 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab2INQZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:25:31 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        gregkh@linuxfoundation.org, ben-linux@fluff.org,
        viresh.linux@gmail.com, rajeev-dlh.kumar@st.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 0/8] enable support for AMBA drivers under x86
Date: Fri, 14 Sep 2012 18:23:55 +0200
Message-Id: <1347639843-32119-1-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

Following Alessandro's report on build errors for amba drivers under x86
(see [1]), here's a patchset fixing the errors and adding a pci-amba bridge
driver.
Some notes:

* 1/8 (DMA: PL330 ...) is quite fat. Should this be a problem, we
could simply disable the PL330 driver under non ARM systems (we actually
don't need the PL330 driver for our x86 platform).
* All the mmc drivers have been fixed to use the new linux/sizes.h header.
* As far as the mmci driver is concerned, readsl/writesl have been replaced
by ioread32_rep/iowrite32_rep as suggested by Arnd Bergmann (see [2]).
* asm/amba/pl080.h is needed by arch/arm/mach-s3c64xx/dma.c (registers
definitions, struct pl080s_lli), so we need most of it to be globally
visible. As a consequence Arnd's suggestion (see [2]) about splitting
the file into two parts was not followed for now.

Davide

Notes:
[1] https://lkml.org/lkml/2012/7/3/227
[2] https://lkml.org/lkml/2012/7/3/236

Alessandro Rubini (7):
  DMA: PL330: use prefix in reg names to build under x86
  gpio: pl061 depends on ARM
  pl080.h: moved from arm/include/asm/hardware to include/linux/amba/
  watchdog: sp805_wdt depends on ARM
  mmc: use the new <linux/sizes.h>
  drivers/amba: add support for a PCI bridge
  x86: add CONFIG_ARM_AMBA, selected by STA2X11

Davide Ciminaghi (1):
  mmci: replace readsl/writesl with ioread32_rep/iowrite32_rep

 arch/arm/include/asm/hardware/pl080.h |  146 ---------
 arch/arm/mach-s3c64xx/dma.c           |    2 +-
 arch/arm/mach-spear3xx/spear3xx.c     |    2 +-
 arch/arm/mach-spear6xx/spear6xx.c     |    2 +-
 arch/x86/Kconfig                      |    4 +
 drivers/Kconfig                       |    2 +
 drivers/amba/Kconfig                  |   10 +
 drivers/amba/Makefile                 |    1 +
 drivers/amba/pci-amba.c               |   96 ++++++
 drivers/dma/amba-pl08x.c              |    2 +-
 drivers/dma/pl330.c                   |  581 +++++++++++++++++----------------
 drivers/gpio/Kconfig                  |    2 +-
 drivers/mmc/host/mmci.c               |   10 +-
 drivers/mmc/host/msm_sdcc.c           |    2 +-
 drivers/mmc/host/mvsdio.c             |    2 +-
 drivers/mmc/host/mxcmmc.c             |    2 +-
 drivers/mmc/host/pxamci.c             |    3 +-
 drivers/watchdog/Kconfig              |    2 +-
 include/linux/amba/pl080.h            |  146 +++++++++
 19 files changed, 566 insertions(+), 451 deletions(-)
 delete mode 100644 arch/arm/include/asm/hardware/pl080.h
 create mode 100644 drivers/amba/Kconfig
 create mode 100644 drivers/amba/pci-amba.c
 create mode 100644 include/linux/amba/pl080.h

-- 
1.7.9.1

