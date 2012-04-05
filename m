Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab2DEQDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:03:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41713 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2DEQD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:03:28 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <tony@atomide.com>, <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <dwmw2@infradead.org>, <sameo@linux.intel.com>,
        <grinberg@compulab.co.il>, <mike@compulab.co.il>, <nm@ti.com>,
        <artem.bityutskiy@linux.intel.com>, <vimal.newwork@gmail.com>,
        <dbaryshkov@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Afzal Mohammed <afzal@ti.com>
Subject: [PATCH v3 0/9] Convert OMAP GPMC to driver
Date: Thu, 5 Apr 2012 21:15:24 +0530
Message-ID: <cover.1333638917.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

GPMC driver conversion series. NAND and smsc911x ethernet device has
been adapted to use GPMC driver.

Patches has been generated over linux-omap/master, HEAD
33fc21e Linux-omap rebuilt: Updated to v3.4-rc1, merged in most of pending branches
As OMAP3EVM does not boot linux-omap/master, merge commit,
58adb29 Merge branch 'io_chain_devel_3.4' of git://git.pwsan.com/linux-2.6 into prm
has to be reverted to get OMAP3EVM boot.
Last patch (with subject prefix TMP - 9/9) is for testing.

Once driver is acceptable, platform code for other peripherals
connected via GPMC would be adapted to make use of GPMC driver. And
then the board modifications. But before that HWMOD entry has to be
populated for respective SoC(s ?).



Now DESTINATION FOR THIS DRIVER has to be decided. Original plan was
to consider GPMC as MFD. The peripheral(s) connected to GPMC being
considered childs of MFD.

GPMC (General Purpose Memory Controller) in brief:
GPMC is an unified memory controller dedicated to interfacing external
memory devices like
 Asynchronous SRAM like memories and application specific integrated circuit devices.
 Asynchronous, synchronous, and page mode burst NOR flash devices NAND flash
 Pseudo-SRAM devices

GPMC has to be configured as required by timings of the connected
peripheral. It needs to be configured only initially (only exception
being resume afaik, where it needs to be reconfigured). Handling GPMC
cannot be left to platform code to handle, then where can it be ?
(currently it is handled by platform code). Once it is configured it
can be used to handle different protocols like NAND, NOR. Various
kinds of devices like ethernet, uart, usb, fpga etc can work using
GPMC interface. GPMC has a seperate additional functionality of
NAND handling (not manhandling ;) ). But with this series, dealing
NAND block of GPMC has been separated from GPMC driver and given
to NAND driver.

It seems decision on where a driver should go is based more on
functionality.

Any suggestions on where GPMC driver could go would be very helpful.
This would also help in reducing amount of platform code for OMAP.

Various options that could be seen so far on where this driver can go,
1. mfd
2. misc
3. drivers/platform/arm/ (create an new one?)
4. memory (create a new one ?)

If GPMC sounds similar to something else that is present in other
chips, please be kind enough to let me know how this is handled by
Kernel (if).

GPMC details can be referred in AM335X Technical Reference Manual
@ http://www.ti.com/lit/pdf/spruh73


Regards
Afzal


v3: Single device structure passed from platform for peripherals using
    multiple CS instead of using multiple device structure having a few
    redundant data, handle interrupts, GPMC NAND handling by GPMC NAND
    driver instead of GPMC driver
v2: Avoid code movement that kept similar code together (for easy review)

TODO:
1. Decide on destination of GPMC driver
2. Modify platform code so that remaining peripherals can be
   configured using GPMC driver instead of platform code doing so.
3. Remove static struct gpmc * (could be done once all other
   peripherals are adapted to use GPMC driver)
4. Devise method to handle OneNAND for GPMC cleanly
5. Handle acquiring CS# (if required)
6. Adapt to HWMOD, use RPM
7. Cleanup (once all peripherals make use of GPMC driver all the
   exported symbols can be removed, and complete removal of a few of
   these functions would be possible, like gpmc_nand_* can be deleted
   now itself)

Afzal Mohammed (9):
  ARM: OMAP2+: gpmc: driver conversion
  ARM: OMAP2+: gpmc: registers for nand driver
  ARM: OMAP2+: nand: create platform data structure
  ARM: OMAP2+: gpmc-nand: populate gpmc configs
  ARM: OMAP2+: gpmc-smsc911x: gpmc driver information
  mtd: nand: omap2: obtain memory from resource
  mtd: nand: omap2: use gpmc provided irqs
  mtd: nand: omap2: handle nand on gpmc
  OMAP3EVM: Test gpmc-nand

 arch/arm/mach-omap2/board-devkit8000.c          |    6 +-
 arch/arm/mach-omap2/board-flash.c               |   63 +--
 arch/arm/mach-omap2/board-flash.h               |   13 +-
 arch/arm/mach-omap2/board-ldp.c                 |    4 +-
 arch/arm/mach-omap2/board-omap3beagle.c         |    6 +-
 arch/arm/mach-omap2/board-omap3evm.c            |   95 +++-
 arch/arm/mach-omap2/board-omap3touchbook.c      |    6 +-
 arch/arm/mach-omap2/board-overo.c               |    5 +-
 arch/arm/mach-omap2/board-zoom.c                |    5 +-
 arch/arm/mach-omap2/common-board-devices.c      |   46 --
 arch/arm/mach-omap2/common-board-devices.h      |    1 -
 arch/arm/mach-omap2/gpmc-nand.c                 |   97 ++--
 arch/arm/mach-omap2/gpmc-smsc911x.c             |   59 +--
 arch/arm/mach-omap2/gpmc.c                      |  543 +++++++++++++++++++----
 arch/arm/plat-omap/include/plat/gpmc-smsc911x.h |    9 +-
 arch/arm/plat-omap/include/plat/gpmc.h          |   66 ++-
 arch/arm/plat-omap/include/plat/nand.h          |   10 +-
 drivers/mtd/nand/omap2.c                        |  296 ++++++++----
 18 files changed, 981 insertions(+), 349 deletions(-)

-- 
1.7.9.3

