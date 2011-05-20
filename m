Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab1ETWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:25:58 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:2101 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab1ETWZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:25:53 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [RFC PATCH v4 0/6] MIPS: Octeon: Use Device Tree.
Date: Fri, 20 May 2011 15:25:37 -0700
Message-Id: <1305930343-31259-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 20 May 2011 22:25:52.0235 (UTC) FILETIME=[E0B533B0:01CC173C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New in v4:

Cleanup and error checking suggested by Sergei Shtylyov.

Use device tree passed by bootloader if present.

New in v3:

More updates to device tree bindings, and perhaps more importantly
descriptions/definitions of the bindings

libfdt building moved to devices/of/libfdt.

Cleanup and style improvements as suggested by Grant Likley.

Omitted all the driver changes, as they are unchanged from the last
set, and at this stage the patches are just an RFC.

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



1/6 -  Infrastructure to allow scripts/dtc/libfdt to be used in the
       kernel.

2/6 - OF patch to simplify of_find_node_by_path().

3/6 - Add the statically linked Device Tree templates and bindings
      descriptions.

4/6 - Remove unused arch/mips/prom.c code that conflicts with
      following patches.

5/6 - irq_create_of_mapping() function.

6/6 - Fix up Device Tree template for current environment.

David Daney (6):
  of: Allow scripts/dtc/libfdt to be used from kernel code
  of: Make of_find_node_by_path() traverse /aliases for relative paths.
  MIPS: Octeon: Add device tree source files.
  MIPS: Prune some target specific code out of prom.c
  MIPS: Octeon: Add irq_create_of_mapping() and GPIO interrupts.
  MIPS: Octeon: Initialize and fixup device tree.

 .../devicetree/bindings/mips/cavium/bootbus.txt    |   37 ++
 .../devicetree/bindings/mips/cavium/ciu.txt        |   26 ++
 .../devicetree/bindings/mips/cavium/gpio.txt       |   48 +++
 .../devicetree/bindings/mips/cavium/mdio.txt       |   27 ++
 .../devicetree/bindings/mips/cavium/mix.txt        |   40 ++
 .../devicetree/bindings/mips/cavium/pip.txt        |   98 +++++
 .../devicetree/bindings/mips/cavium/twsi.txt       |   34 ++
 .../devicetree/bindings/mips/cavium/uart.txt       |   19 +
 .../devicetree/bindings/mips/cavium/uctl.txt       |   47 +++
 arch/mips/Kconfig                                  |    1 +
 arch/mips/cavium-octeon/.gitignore                 |    2 +
 arch/mips/cavium-octeon/Makefile                   |   16 +
 arch/mips/cavium-octeon/octeon-irq.c               |  183 ++++++++++-
 arch/mips/cavium-octeon/octeon-platform.c          |  295 +++++++++++++++
 arch/mips/cavium-octeon/octeon_3xxx.dts            |  375 ++++++++++++++++++++
 arch/mips/cavium-octeon/setup.c                    |   39 ++
 arch/mips/kernel/prom.c                            |   49 ---
 drivers/of/Kconfig                                 |    3 +
 drivers/of/Makefile                                |    2 +
 drivers/of/base.c                                  |   48 +++-
 drivers/of/libfdt/Makefile                         |    3 +
 drivers/of/libfdt/fdt.c                            |    2 +
 drivers/of/libfdt/fdt_ro.c                         |    2 +
 drivers/of/libfdt/fdt_wip.c                        |    2 +
 include/linux/libfdt.h                             |    8 +
 include/linux/libfdt_env.h                         |   13 +
 26 files changed, 1366 insertions(+), 53 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/bootbus.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/ciu.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/gpio.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/mdio.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/mix.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/pip.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/twsi.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/uart.txt
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/uctl.txt
 create mode 100644 arch/mips/cavium-octeon/.gitignore
 create mode 100644 arch/mips/cavium-octeon/octeon_3xxx.dts
 create mode 100644 drivers/of/libfdt/Makefile
 create mode 100644 drivers/of/libfdt/fdt.c
 create mode 100644 drivers/of/libfdt/fdt_ro.c
 create mode 100644 drivers/of/libfdt/fdt_wip.c
 create mode 100644 include/linux/libfdt.h
 create mode 100644 include/linux/libfdt_env.h

-- 
1.7.2.3

