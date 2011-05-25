Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab1EYWHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 18:07:10 -0400
Received: from void.printf.net ([89.145.121.20]:58110 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab1EYWHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 18:07:08 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: MMC updates for 2.6.40-rc1
Date: Wed, 25 May 2011 18:08:18 -0400
Message-ID: <m37h9eqvql.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to receive the MMC merge for 2.6.40-rc1.  There are currently no merge
conflicts, and the patches have been tested in linux-next.  Thanks.

Highlights are:
Core:
 * eMMC 4.4 "boot partition" support.  This exposes an eMMC device's
   boot partitions, which are accessed separately from the other
   partitions as (e.g.) /dev/mmcblk0boot0.  There's a strong potential
   for bricking the device you're running on by writing to these (they
   are usually used by the bootloader), so we disable write access by
   default.  To write to them, first perform:
     # echo 0 > /sys/block/mmcblkXbootY/force_ro
 
 * An ioctl for running MMC CMD/ACMDs from userspace (with CAP_SYS_RAWIO).
   This is primarily useful for enabling built-in security functionality
   on SD cards.

 * A new per-*card* quirks mechanism, along with two cases where this is
   necessary:  one where some Sandisk cards handle erase/trim arguments
   differently, and one where the same optimization (CMD23 multiblock
   transfers) causes a large (50%, for some tests) performance increase
   on SanDisk cards and a small performance *decrease* on others.

 * Reliable write support for MMC cards, servicing REQ_FUA/REQ_META
   requests.

 * eMMC Dual Data Rate support.

Drivers:
 * SD v3.0 improvements, with support for SDXC cards at ultra-high-speed
   (up to 104MB/sec) modes.  Thanks to Arindam Nath at AMD for this
   patchset, also Andrei Warkentin at Motorola and Philip Rakity at
   Marvell.

 * New "vub300" driver for Elan Digital Systems' VUB300 chip, which is
   a USB connected SDIO/SD/MMC host controller.

 * tmio_mmc, sh_mmcif: Runtime and system-wide suspend support.


The following changes since commit 7c21738efd0b5e8c2a9ac2440e7ffbf432d6f239:
  Linus Torvalds (1):
        Merge branch 'drm-fixes' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Ameya Palande (1):
      mmc: sdhci-pci: Fix checkpatch.pl errors

Andrei Warkentin (17):
      mmc: Reliable write support.
      mmc: quirks: Extends card quirks with MMC/SD quirks matching the CID.
      mmc: core: Rename erase_timeout to cmd_timeout_ms.
      mmc: sdhci: R1B command handling + MMC_CAP_ERASE.
      mmc: core: Allow setting CMD timeout for CMD6 (SWITCH).
      mmc: card: block.c cleanup for host claim/release.
      mmc: MMC boot partitions support.
      mmc: quirks: Support for block quirks.
      mmc: quirks: Fix erase/trim for certain SanDisk cards.
      mmc: core: Fix use of uninitialized data in mmc_cmd_app.
      mmc: Ensure hardware partitions don't mess with mmcblk device naming.
      mmc: quirks: Add/remove quirks conditional support.
      mmc: core: Use CMD23 for multiblock transfers when we can.
      mmc: sdhci: Implement MMC_CAP_CMD23 for SDHCI.
      mmc: core: Block CMD23 support for UHS104/SDXC cards.
      mmc: sdhci: Auto-CMD23 support.
      mmc: sdhci: Auto-CMD23 fixes.

Andy Shevchenko (1):
      mmc: mmc_test: minor clean up, use t = &test.area everywhere

Arindam Nath (11):
      mmc: sd: add support for signal voltage switch procedure
      mmc: sd: query function modes for uhs cards
      mmc: sd: add support for driver type selection
      mmc: sdhci: reset sdclk before setting high speed enable
      mmc: sd: add support for uhs bus speed mode selection
      mmc: sd: set current limit for uhs cards
      mmc: sd: report correct speed and capacity of uhs cards
      mmc: sd: add support for tuning during uhs initialization
      mmc: sdhci: enable preset value after uhs initialization
      mmc: sdhci: add support for programmable clock mode
      mmc: sdhci: add support for retuning mode 1

Chris Ball (5):
      mmc: core: Fix use of uninitialized data in mmc_send_if_cond.
      mmc: card: Fix use of uninitialized data in mmc_blk_issue_rw_rq.
      mmc: initialize struct mmc_command at declaration time
      mmc: initialize struct mmc_data at declaration time
      mmc: initialize struct mmc_request at declaration time

Eliad Peller (1):
      mmc: core: clear MMC_PM_KEEP_POWER flag on resume

Guennadi Liakhovetski (6):
      mmc: sh_mmcif: protect against a theoretical race
      mmc: Add runtime and system-wide PM to the TMIO MMC driver
      mmc: add runtime and system power-management support to the MMCIF driver
      mmc: protect the tmio_mmc driver against a theoretical race
      mmc: tmio: runtime suspend the controller, where possible
      mmc: sdhi: allow powering down controller with no card inserted

Jaehoon Chung (2):
      mmc: dw_mmc: fixed wrong regulator_enable in suspend/resume
      mmc: core: duplicated trial with same freq in mmc_rescan_try_freq()

John Calixto (1):
      mmc: core: Add mmc CMD+ACMD passthrough ioctl

John Ogness (1):
      mmc: remove redundant irq disabling

Magnus Damm (4):
      mmc: tmio/sdhi: break out interrupt request/free
      mmc: sdhi: no need for special interrupt flags
      mmc: sdhi: print physical base address and clock rate
      mmc: sdhi: support up to 3 interrupt sources

Mark Brown (1):
      mmc: sdhci: Fix SDHCI_QUIRK_TIMEOUT_USES_SDCLK

Mikko Vinni (1):
      mmc: sdhci: work around broken dma boundary behavior

Ohad Ben-Cohen (6):
      mmc: mmc_card_keep_power cleanups
      mmc: do not switch to 1-bit mode if not required
      mmc: add MMC_QUIRK_NONSTD_FUNC_IF
      mmc: quirks: wl1271 is MMC_QUIRK_NONSTD_FUNC_IF
      mmc: add MMC_QUIRK_DISABLE_CD
      mmc: quirks: wl1271 is MMC_QUIRK_DISABLE_CD

Philip Rakity (8):
      mmc: Ensure linux starts in eMMC user partition
      mmc: sdhci: Add pre and post reset processing for chip specific reset
      mmc: sdhci: add hooks for setting UHS in platform specific code
      mmc: sdhci-pxa: add platform code for UHS signaling
      mmc: core: eMMC signal voltage does not use CMD11
      mmc: core: add support for eMMC Dual Data Rate
      mmc: sdhci-pxa: Add quirks for DMA/ADMA to match h/w
      mmc: core: eMMC bus width may not work on all platforms

Rabin Vincent (1):
      mmc: block: init force_ro sysfs attribute

Randy Dunlap (1):
      mmc: quirks: fix truncation warnings

Shawn Guo (1):
      mmc: sdhci: change CONFIG of MMC_SDHCI_TEGRA from 'tristate' to 'bool'

Stefan Nilsson XK (1):
      mmc: sdio: optimized SDIO IRQ handling for single irq

Takashi Iwai (1):
      mmc: sdhci: Fix read-only detection with JMicron 388 chip

Tony Olech (1):
      mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver

Venkat Rao (1):
      mmc: tegra: add pm_flags

Vladimir Motyka (1):
      mmc: card: fix potential null dereference of 'idata'

Wolfram Sang (1):
      mmc: core: fix memory leak in mmc_add_host

 Documentation/ioctl/ioctl-number.txt     |    1 +
 Documentation/mmc/00-INDEX               |    2 +
 Documentation/mmc/mmc-dev-attrs.txt      |   10 +
 Documentation/mmc/mmc-dev-parts.txt      |   27 +
 MAINTAINERS                              |    7 +
 arch/arm/mach-tegra/include/mach/sdhci.h |    1 +
 drivers/mmc/card/block.c                 |  712 ++++++++-
 drivers/mmc/card/mmc_test.c              |  116 +-
 drivers/mmc/card/queue.c                 |    8 -
 drivers/mmc/core/bus.c                   |   11 +-
 drivers/mmc/core/core.c                  |  111 +-
 drivers/mmc/core/core.h                  |    7 +-
 drivers/mmc/core/host.c                  |    4 +-
 drivers/mmc/core/mmc.c                   |  186 ++-
 drivers/mmc/core/mmc_ops.c               |   80 +-
 drivers/mmc/core/mmc_ops.h               |    1 -
 drivers/mmc/core/quirks.c                |   89 +-
 drivers/mmc/core/sd.c                    |  405 +++++-
 drivers/mmc/core/sd.h                    |    2 +-
 drivers/mmc/core/sd_ops.c                |   51 +-
 drivers/mmc/core/sdio.c                  |   24 +-
 drivers/mmc/core/sdio_irq.c              |   33 +-
 drivers/mmc/core/sdio_ops.c              |   18 +-
 drivers/mmc/host/Kconfig                 |   33 +-
 drivers/mmc/host/Makefile                |    1 +
 drivers/mmc/host/dw_mmc.c                |    6 +-
 drivers/mmc/host/sdhci-pci.c             |   49 +-
 drivers/mmc/host/sdhci-pxa.c             |   48 +-
 drivers/mmc/host/sdhci-tegra.c           |    2 +
 drivers/mmc/host/sdhci.c                 |  854 ++++++++++-
 drivers/mmc/host/sdhci.h                 |   59 +-
 drivers/mmc/host/sh_mmcif.c              |  126 ++-
 drivers/mmc/host/sh_mobile_sdhi.c        |   50 +-
 drivers/mmc/host/tmio_mmc.c              |   32 +-
 drivers/mmc/host/tmio_mmc.h              |   16 +-
 drivers/mmc/host/tmio_mmc_dma.c          |   21 +-
 drivers/mmc/host/tmio_mmc_pio.c          |  184 ++-
 drivers/mmc/host/vub300.c                | 2506 ++++++++++++++++++++++++++++++
 include/linux/Kbuild                     |    1 +
 include/linux/mfd/tmio.h                 |   17 +
 include/linux/mmc/Kbuild                 |    1 +
 include/linux/mmc/card.h                 |  189 +++-
 include/linux/mmc/core.h                 |    5 +-
 include/linux/mmc/host.h                 |   49 +-
 include/linux/mmc/ioctl.h                |   54 +
 include/linux/mmc/mmc.h                  |   18 +
 include/linux/mmc/sd.h                   |    9 +-
 include/linux/mmc/sdhci.h                |   15 +
 include/linux/mmc/sh_mobile_sdhi.h       |    4 +
 49 files changed, 5699 insertions(+), 556 deletions(-)
 create mode 100644 Documentation/mmc/mmc-dev-parts.txt
 create mode 100644 drivers/mmc/host/vub300.c
 create mode 100644 include/linux/mmc/Kbuild
 create mode 100644 include/linux/mmc/ioctl.h

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
