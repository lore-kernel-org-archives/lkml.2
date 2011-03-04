Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006Ab1CDTmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:42:39 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11773 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1CDTmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:42:37 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [RFC PATCH v2 00/12] MIPS: Octeon: Use Device Tree.
Date: Fri,  4 Mar 2011 11:42:12 -0800
Message-Id: <1299267744-17278-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 04 Mar 2011 19:42:37.0450 (UTC) FILETIME=[50C0DEA0:01CBDAA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New in v2:

Changed many device tree bindings.  They should be closer to the
standard naming scheme now.

Editing of the template device tree is done in the flattened form
using libfdt.

Standard platform driver functions used in preference to the
of_platform variety.

v1:

Background: The Octeon family of SOCs has a variety of on-chip
controllers for Ethernet, MDIO, I2C, and several other I/O devices.
These chips are used on boards with a great variety of different
configurations.  To date, the configuration and bus topology
information has been hard coded in the drivers and support code.

To facilitate supporting new chips and boards, we would like to make
use use the Device Tree to encode the configuration information.

I would like to get some feedback on the current code I am working
with.  The migration approach is as follows:

o Several device tree templates are statically linked into the kernel
  image.  Based on SOC type and board type one of these is selected in
  early boot.  Legacy configuration probing code is used to prune and
  patch the device tree template.

o New SOCs and boards will directly use a device tree passed by the
  bootloader (This patch set doesn't actually implement this, but it
  is trivial to add).



01/12 - Move configuration code to common place for use by Device Tree
        pruning and patching code.

02/12 - Infrastructure to allow scripts/dtc/libfdt to be used in the
        kernel.

03/12 - OF patch to simplify of_find_node_by_path().  This one I
        previously sent seperatly and receive as of yet unacted upon
        feedback.

04/12 - Add the statically linked Device Tree templates.

05/10 - Remove unused arch/mips/prom.c code that conflicts with
        following patches.

06/10 - irq_create_of_mapping() function.

07/10 - Rearrange legacy configuration code for following patch.

08/10 - Fix up Device Tree template for current environment.

09/10 - Convert I2C driver to use Device Tree.

10/10 - Convert MDIO driver to use Device Tree.

11/10 - Convert Ethernet mgmt driver to use Device Tree.

12/10 - Convert Octeon Ethernet driver to use Device Tree.

David Daney (12):
  MIPS: Octeon: Move some Ethernet support files out of staging.
  of: Allow scripts/dtc/libfdt to be used from kernel code
  of: Make of_find_node_by_path() traverse /aliases for relative paths.
  MIPS: Octeon: Add device tree source files.
  MIPS: Prune some target specific code out of prom.c
  MIPS: Octeon: Add a irq_create_of_mapping() implementation.
  MIPS: Octeon: Rearrance CVMX files in preperation for device tree
  MIPS: Octeon: Initialize and fixup device tree.
  i2c: Convert i2c-octeon.c to use device tree.
  netdev: mdio-octeon.c: Convert to use device tree.
  netdev: octeon_mgmt: Convert to use device tree.
  staging: octeon_ethernet: Convert to use device tree.

 arch/mips/Kconfig                                  |    1 +
 arch/mips/cavium-octeon/.gitignore                 |    2 +
 arch/mips/cavium-octeon/Makefile                   |   13 +
 arch/mips/cavium-octeon/executive/Makefile         |    5 +
 .../mips/cavium-octeon/executive}/cvmx-cmd-queue.c |    8 +-
 .../mips/cavium-octeon/executive}/cvmx-fpa.c       |    0
 .../cavium-octeon/executive}/cvmx-helper-board.c   |   18 +-
 .../cavium-octeon/executive}/cvmx-helper-fpa.c     |    0
 .../cavium-octeon/executive}/cvmx-helper-loop.c    |    6 +-
 .../cavium-octeon/executive}/cvmx-helper-npi.c     |    6 +-
 .../cavium-octeon/executive}/cvmx-helper-rgmii.c   |   17 +-
 .../cavium-octeon/executive}/cvmx-helper-sgmii.c   |   18 +-
 .../cavium-octeon/executive}/cvmx-helper-spi.c     |   20 +-
 .../cavium-octeon/executive}/cvmx-helper-util.c    |   16 +-
 .../cavium-octeon/executive}/cvmx-helper-xaui.c    |   32 +-
 .../mips/cavium-octeon/executive}/cvmx-helper.c    |  120 +++++--
 .../executive}/cvmx-interrupt-decodes.c            |   10 +-
 .../cavium-octeon/executive}/cvmx-interrupt-rsl.c  |    4 +-
 .../mips/cavium-octeon/executive}/cvmx-pko.c       |    6 +-
 .../mips/cavium-octeon/executive}/cvmx-spi.c       |   12 +-
 arch/mips/cavium-octeon/octeon-irq.c               |   25 ++
 arch/mips/cavium-octeon/octeon-platform.c          |  410 +++++++++++---------
 arch/mips/cavium-octeon/octeon_3xxx.dts            |  330 ++++++++++++++++
 arch/mips/cavium-octeon/octeon_68xx.dts            |  116 ++++++
 arch/mips/cavium-octeon/setup.c                    |   17 +
 .../mips/include/asm}/octeon/cvmx-address.h        |    0
 .../mips/include/asm}/octeon/cvmx-asxx-defs.h      |    0
 .../mips/include/asm}/octeon/cvmx-cmd-queue.h      |    0
 .../mips/include/asm}/octeon/cvmx-config.h         |    0
 .../mips/include/asm}/octeon/cvmx-dbg-defs.h       |    0
 .../mips/include/asm}/octeon/cvmx-fau.h            |    0
 .../mips/include/asm}/octeon/cvmx-fpa-defs.h       |    0
 .../mips/include/asm}/octeon/cvmx-fpa.h            |    0
 .../mips/include/asm}/octeon/cvmx-gmxx-defs.h      |    0
 .../mips/include/asm}/octeon/cvmx-helper-board.h   |    0
 .../mips/include/asm}/octeon/cvmx-helper-fpa.h     |    0
 .../mips/include/asm}/octeon/cvmx-helper-loop.h    |    1 +
 .../mips/include/asm}/octeon/cvmx-helper-npi.h     |    1 +
 .../mips/include/asm}/octeon/cvmx-helper-rgmii.h   |    1 +
 .../mips/include/asm}/octeon/cvmx-helper-sgmii.h   |    1 +
 .../mips/include/asm}/octeon/cvmx-helper-spi.h     |    1 +
 .../mips/include/asm}/octeon/cvmx-helper-util.h    |    0
 .../mips/include/asm}/octeon/cvmx-helper-xaui.h    |    1 +
 .../mips/include/asm}/octeon/cvmx-helper.h         |    1 +
 .../mips/include/asm}/octeon/cvmx-ipd.h            |    0
 .../mips/include/asm}/octeon/cvmx-mdio.h           |    0
 .../mips/include/asm}/octeon/cvmx-pcsx-defs.h      |    0
 .../mips/include/asm}/octeon/cvmx-pcsxx-defs.h     |    0
 .../mips/include/asm}/octeon/cvmx-pip-defs.h       |    0
 .../mips/include/asm}/octeon/cvmx-pip.h            |    0
 .../mips/include/asm}/octeon/cvmx-pko-defs.h       |    0
 .../mips/include/asm}/octeon/cvmx-pko.h            |    0
 .../mips/include/asm}/octeon/cvmx-pow.h            |    0
 .../mips/include/asm}/octeon/cvmx-scratch.h        |    0
 .../mips/include/asm}/octeon/cvmx-spi.h            |    0
 .../mips/include/asm}/octeon/cvmx-spxx-defs.h      |    0
 .../mips/include/asm}/octeon/cvmx-srxx-defs.h      |    0
 .../mips/include/asm}/octeon/cvmx-stxx-defs.h      |    0
 .../mips/include/asm}/octeon/cvmx-wqe.h            |    0
 arch/mips/include/asm/octeon/octeon.h              |    5 -
 arch/mips/kernel/prom.c                            |   49 ---
 drivers/i2c/busses/i2c-octeon.c                    |   69 ++--
 drivers/net/octeon/octeon_mgmt.c                   |  321 +++++++++++-----
 drivers/net/phy/mdio-octeon.c                      |   92 +++--
 drivers/of/base.c                                  |   24 ++-
 drivers/staging/octeon/Makefile                    |    5 -
 drivers/staging/octeon/cvmx-packet.h               |   65 ---
 drivers/staging/octeon/cvmx-smix-defs.h            |  178 ---------
 drivers/staging/octeon/ethernet-defines.h          |    2 +-
 drivers/staging/octeon/ethernet-mdio.c             |   31 +-
 drivers/staging/octeon/ethernet-mem.c              |    2 +-
 drivers/staging/octeon/ethernet-rgmii.c            |    4 +-
 drivers/staging/octeon/ethernet-rx.c               |   14 +-
 drivers/staging/octeon/ethernet-rx.h               |    2 +-
 drivers/staging/octeon/ethernet-sgmii.c            |    4 +-
 drivers/staging/octeon/ethernet-spi.c              |    6 +-
 drivers/staging/octeon/ethernet-tx.c               |   12 +-
 drivers/staging/octeon/ethernet-xaui.c             |    4 +-
 drivers/staging/octeon/ethernet.c                  |  102 +++--
 drivers/staging/octeon/octeon-ethernet.h           |    3 +
 include/linux/libfdt.h                             |    3 +
 lib/Kconfig                                        |    6 +
 lib/Makefile                                       |    2 +
 lib/libfdt/Makefile                                |    7 +
 lib/libfdt/libfdt_env.h                            |   21 +
 scripts/dtc/libfdt/libfdt.h                        |    4 +-
 86 files changed, 1421 insertions(+), 835 deletions(-)
 create mode 100644 arch/mips/cavium-octeon/.gitignore
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-cmd-queue.c (98%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-fpa.c (100%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-board.c (98%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-fpa.c (100%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-loop.c (95%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-npi.c (96%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-rgmii.c (97%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-sgmii.c (98%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-spi.c (94%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-util.c (97%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-xaui.c (97%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper.c (93%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-interrupt-decodes.c (98%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-interrupt-rsl.c (97%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-pko.c (99%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-spi.c (99%)
 create mode 100644 arch/mips/cavium-octeon/octeon_3xxx.dts
 create mode 100644 arch/mips/cavium-octeon/octeon_68xx.dts
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-address.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-asxx-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-cmd-queue.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-config.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-dbg-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-fau.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-fpa-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-fpa.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-gmxx-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-board.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-fpa.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-loop.h (96%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-npi.h (96%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-rgmii.h (98%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-sgmii.h (98%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-spi.h (98%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-util.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-xaui.h (98%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper.h (99%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-ipd.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-mdio.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-pcsx-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-pcsxx-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-pip-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-pip.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-pko-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-pko.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-pow.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-scratch.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-spi.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-spxx-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-srxx-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-stxx-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-wqe.h (100%)
 delete mode 100644 drivers/staging/octeon/cvmx-packet.h
 delete mode 100644 drivers/staging/octeon/cvmx-smix-defs.h
 create mode 100644 include/linux/libfdt.h
 create mode 100644 lib/libfdt/Makefile
 create mode 100644 lib/libfdt/libfdt_env.h

-- 
1.7.2.3

