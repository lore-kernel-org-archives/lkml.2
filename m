Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1GLQxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:53:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60741 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab1GLQxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:53:46 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Cc: Michal Simek <monstr@monstr.eu>, nico@fluxnic.net,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v3 0/6] ARM: make mach/hardware.h optional
Date: Tue, 12 Jul 2011 11:53:26 -0500
Message-Id: <1310489612-8625-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Currently, all ARM platforms must have a mach/hardware.h include. This is
because it is ultimately included by linux/pci.h which is included in many
places even for !CONFIG_PCI.

This could be fixed simply with an ifdef around the include of mach/hardware.h
in asm/pci.h. However, in the interest of fixing this for single kernel
binary builds, this series removes the include of mach/hardware.h outside of
mach-* and plat-*. What's used from hardware.h is a couple of PCI defines. 
Converting them to variables allows each platform to set the values as needed.

This does not address the inclusion of mach/hardware.h under drivers/*. This
appears to be mostly older platforms. There could also be some indirect
inclusions from other mach/* headers.

I've compile tested on most affected ARM platforms. 

Changes from v2:
- Incorporated compile fixes for microblaze from Michal Simek.
- Added conversion of powerpc to generic pci flag functions.
- Combined powerpc and microblaze conversion to use 
  asm-generic/pci-bridge.h into one commit. Renaming of powerpc pci
  flags functions is separate commit.
- Changed defaults for PCIBIOS_MIN_IO and PCIBIOS_MIN_MEM to 0x1000 and
  0x1000000, respectively.
- Dropped commit moving ARCH_HAS_DMA_SET_COHERENT_MASK defines into 
  memory.h. This conflicts with other clean-up work by Nicolas Pitre.

Changes from v1:
- Added patch 2 to move ARCH_HAS_DMA_SET_COHERENT_MASK defines into memory.h.
- Separated VGA changes and renamed to vga_base.
- Reverted mach/hardware.h removal from ecard.c. It's getting implicitly
  included anyway.

Rob

Rob Herring (6):
  powerpc: rename ppc_pci_*_flags to pci_*_flags
  pci: move microblaze and powerpc pci flag functions into asm-generic
  ARM: remove unnecessary mach/hardware.h includes
  ARM: pci: make pcibios_assign_all_busses use pci_has_flag
  ARM: convert PCI defines to variables
  ARM: set vga memory base at run-time

 arch/arm/include/asm/pci.h                       |   12 ++++-
 arch/arm/include/asm/vga.h                       |    5 +-
 arch/arm/lib/ecard.S                             |    1 -
 arch/arm/lib/io-readsw-armv3.S                   |    1 -
 arch/arm/lib/io-writesw-armv3.S                  |    1 -
 arch/arm/mach-bcmring/include/mach/hardware.h    |    2 -
 arch/arm/mach-cns3xxx/cns3420vb.c                |    1 -
 arch/arm/mach-cns3xxx/include/mach/hardware.h    |   22 -------
 arch/arm/mach-cns3xxx/pcie.c                     |    3 +
 arch/arm/mach-dove/include/mach/hardware.h       |    7 --
 arch/arm/mach-dove/pcie.c                        |    3 +
 arch/arm/mach-ep93xx/include/mach/hardware.h     |    2 -
 arch/arm/mach-footbridge/dc21285.c               |    3 +
 arch/arm/mach-footbridge/include/mach/hardware.h |    5 --
 arch/arm/mach-integrator/include/mach/hardware.h |    7 --
 arch/arm/mach-integrator/pci_v3.c                |    5 ++
 arch/arm/mach-iop13xx/include/mach/hardware.h    |    7 --
 arch/arm/mach-iop13xx/pci.c                      |    5 +-
 arch/arm/mach-iop32x/include/mach/hardware.h     |    3 -
 arch/arm/mach-iop33x/include/mach/hardware.h     |    3 -
 arch/arm/mach-ixp2000/include/mach/hardware.h    |    8 ---
 arch/arm/mach-ixp2000/pci.c                      |    5 ++
 arch/arm/mach-ixp23xx/include/mach/hardware.h    |    4 -
 arch/arm/mach-ixp23xx/pci.c                      |    5 ++
 arch/arm/mach-ixp4xx/common-pci.c                |    5 ++
 arch/arm/mach-ixp4xx/include/mach/hardware.h     |    5 --
 arch/arm/mach-kirkwood/include/mach/hardware.h   |    7 --
 arch/arm/mach-kirkwood/pcie.c                    |    3 +
 arch/arm/mach-ks8695/include/mach/hardware.h     |    9 ---
 arch/arm/mach-ks8695/pci.c                       |    3 +
 arch/arm/mach-mv78xx0/include/mach/hardware.h    |    7 --
 arch/arm/mach-mv78xx0/pcie.c                     |    3 +
 arch/arm/mach-orion5x/include/mach/hardware.h    |    7 --
 arch/arm/mach-orion5x/pci.c                      |    2 +
 arch/arm/mach-pxa/cm-x2xx-pci.c                  |    3 +
 arch/arm/mach-pxa/include/mach/hardware.h        |    3 -
 arch/arm/mach-sa1100/include/mach/hardware.h     |    8 ---
 arch/arm/mach-sa1100/pci-nanoengine.c            |    3 +
 arch/arm/mach-shark/include/mach/hardware.h      |    6 --
 arch/arm/mach-shark/pci.c                        |   12 +++-
 arch/arm/mach-tegra/include/mach/hardware.h      |   28 ---------
 arch/arm/mach-tegra/include/mach/system.h        |    1 -
 arch/arm/mach-tegra/io.c                         |    1 -
 arch/arm/mach-tegra/pcie.c                       |    2 +
 arch/arm/mach-tegra/platsmp.c                    |    1 -
 arch/arm/mach-versatile/include/mach/hardware.h  |    6 --
 arch/arm/mach-versatile/pci.c                    |    3 +
 arch/arm/mm/iomap.c                              |   12 ++++
 arch/arm/mm/proc-xsc3.S                          |    1 -
 arch/arm/plat-iop/pci.c                          |    3 +
 arch/microblaze/include/asm/pci-bridge.h         |   67 +++------------------
 arch/powerpc/include/asm/pci-bridge.h            |   50 +----------------
 arch/powerpc/include/asm/pci.h                   |    2 +-
 arch/powerpc/kernel/pci-common.c                 |   22 ++++----
 arch/powerpc/kernel/pci_32.c                     |    2 +-
 arch/powerpc/kernel/pci_64.c                     |    4 +-
 arch/powerpc/kernel/rtas_pci.c                   |    2 +-
 arch/powerpc/platforms/40x/ep405.c               |    2 +-
 arch/powerpc/platforms/40x/ppc40x_simple.c       |    2 +-
 arch/powerpc/platforms/40x/walnut.c              |    2 +-
 arch/powerpc/platforms/44x/canyonlands.c         |    2 +-
 arch/powerpc/platforms/44x/ebony.c               |    2 +-
 arch/powerpc/platforms/44x/ppc44x_simple.c       |    2 +-
 arch/powerpc/platforms/44x/sam440ep.c            |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c        |    2 +-
 arch/powerpc/platforms/82xx/pq2.c                |    2 +-
 arch/powerpc/platforms/chrp/pci.c                |    2 +-
 arch/powerpc/platforms/powermac/pci.c            |    6 +-
 arch/powerpc/sysdev/fsl_pci.c                    |    4 +-
 arch/powerpc/sysdev/grackle.c                    |    2 +-
 arch/powerpc/sysdev/ppc4xx_pci.c                 |    2 +-
 include/asm-generic/pci-bridge.h                 |   62 ++++++++++++++++++++
 72 files changed, 198 insertions(+), 311 deletions(-)
 delete mode 100644 arch/arm/mach-cns3xxx/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/hardware.h
 create mode 100644 include/asm-generic/pci-bridge.h

-- 
1.7.4.1

