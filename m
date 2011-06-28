Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1F1W6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:58:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63424 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab1F1W6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:58:12 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, nico@fluxnic.net,
        Rob Herring <rob.herring@calxeda.com>
Subject: [RFC PATCH 0/4] ARM: make mach/hardware.h optional
Date: Tue, 28 Jun 2011 17:57:35 -0500
Message-Id: <1309301859-17651-1-git-send-email-robherring2@gmail.com>
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

I've compile tested on most affected platforms.

Rob

Rob Herring (4):
  microblaze: move pci flag functions into asm-generic
  ARM: remove unnecessary mach/hardware.h includes
  ARM: pci: make pcibios_assign_all_busses use pci_has_flag
  ARM: convert PCI defines to variables

 arch/arm/include/asm/pci.h                       |   16 +++++-
 arch/arm/include/asm/vga.h                       |    2 +-
 arch/arm/kernel/ecard.c                          |    1 -
 arch/arm/lib/ecard.S                             |    1 -
 arch/arm/lib/io-readsw-armv3.S                   |    1 -
 arch/arm/lib/io-writesw-armv3.S                  |    1 -
 arch/arm/mach-bcmring/include/mach/hardware.h    |    2 -
 arch/arm/mach-cns3xxx/cns3420vb.c                |    1 -
 arch/arm/mach-cns3xxx/include/mach/hardware.h    |   22 --------
 arch/arm/mach-dove/include/mach/hardware.h       |    7 ---
 arch/arm/mach-dove/pcie.c                        |    4 ++
 arch/arm/mach-ep93xx/include/mach/hardware.h     |    2 -
 arch/arm/mach-footbridge/common.c                |    4 +-
 arch/arm/mach-footbridge/dc21285.c               |    4 ++
 arch/arm/mach-footbridge/include/mach/hardware.h |    7 +--
 arch/arm/mach-integrator/include/mach/hardware.h |    7 ---
 arch/arm/mach-integrator/pci_v3.c                |    4 ++
 arch/arm/mach-iop13xx/include/mach/hardware.h    |    7 ---
 arch/arm/mach-iop13xx/pci.c                      |    4 +-
 arch/arm/mach-iop32x/include/mach/hardware.h     |    3 -
 arch/arm/mach-iop33x/include/mach/hardware.h     |    3 -
 arch/arm/mach-ixp2000/include/mach/hardware.h    |    8 ---
 arch/arm/mach-ixp2000/pci.c                      |    2 +
 arch/arm/mach-ixp23xx/include/mach/hardware.h    |    4 --
 arch/arm/mach-ixp23xx/pci.c                      |    4 ++
 arch/arm/mach-ixp4xx/common-pci.c                |    6 ++
 arch/arm/mach-ixp4xx/include/mach/hardware.h     |    5 --
 arch/arm/mach-kirkwood/include/mach/hardware.h   |    7 ---
 arch/arm/mach-kirkwood/pcie.c                    |    4 ++
 arch/arm/mach-ks8695/include/mach/hardware.h     |    9 ---
 arch/arm/mach-mv78xx0/include/mach/hardware.h    |    7 ---
 arch/arm/mach-mv78xx0/pcie.c                     |    4 ++
 arch/arm/mach-orion5x/include/mach/hardware.h    |    7 ---
 arch/arm/mach-orion5x/pci.c                      |    4 ++
 arch/arm/mach-pxa/include/mach/hardware.h        |    3 -
 arch/arm/mach-sa1100/include/mach/hardware.h     |    8 ---
 arch/arm/mach-shark/include/mach/hardware.h      |    6 --
 arch/arm/mach-shark/pci.c                        |   11 +++-
 arch/arm/mach-tegra/include/mach/hardware.h      |   28 ----------
 arch/arm/mach-tegra/include/mach/system.h        |    1 -
 arch/arm/mach-tegra/io.c                         |    1 -
 arch/arm/mach-tegra/pcie.c                       |    2 +
 arch/arm/mach-tegra/platsmp.c                    |    1 -
 arch/arm/mach-versatile/include/mach/hardware.h  |    6 --
 arch/arm/mach-versatile/pci.c                    |    3 +
 arch/arm/mm/iomap.c                              |   12 ++++
 arch/arm/mm/proc-xsc3.S                          |    1 -
 arch/microblaze/include/asm/pci-bridge.h         |   36 +------------
 include/asm-generic/pci-bridge.h                 |   62 ++++++++++++++++++++++
 49 files changed, 144 insertions(+), 211 deletions(-)
 delete mode 100644 arch/arm/mach-cns3xxx/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/hardware.h
 create mode 100644 include/asm-generic/pci-bridge.h

-- 
1.7.4.1

