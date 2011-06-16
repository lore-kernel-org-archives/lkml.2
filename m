Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab1FPEki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 00:40:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51453 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1FPEkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 00:40:33 -0400
Subject: [RFC PATCH 00/11] Full device tree support for ARM Versatile
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 15 Jun 2011 22:40:29 -0600
Message-ID: <20110616042653.29371.2052.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches is all over the place, and touches both
core infrastructure and board ports.  The patches also vary quite a
bit in terms of quality and readiness for merging.  However, I wanted
to get the whole lot out onto the list together so it can be seen
exactly what needs to be done to convert an ARM platform over to
registering devices directly out of the DT.

This first 3 patches are an early implementation of irq_domains, plus
some helpers to make creating a simple irq_domain easy.  I've already
posted the first patch before, and I haven't responded to any comments
yet.  These patches are needed so that DT irq connections can be
correctly mapped into the Linux IRQ numberspace.

Patches 4-7 modify the core DT infrastructure to create a new helper
for registering devices (has slightly different semantics from the
older of_platform_bus_probe()), working with AMBA devices, and
allowing platform code to provide a lookup table of 'preferred' names
and platform_data for DT described devices.

The use of platform_data here is sure to raise an eyebrow or two, but
I assure you it is both necessary and temporary.  Necessary because it
allows platforms to transition to DT without having to fix all
name-based clock connections and platform_data usage in device
drivers.  Temporary because platform lookup tables will get removed
after the drivers do get fixed.

Patch 8 is a trivial powerpc patch to migrate a platform to the newer
infrastructure, and patches 9 & 10 are also trivial infrastructure
additions.

Patch 11 is the main event.  It creates a new versatile machine
definition which matches against a versatile device tree, and all
device registrations are generated from DT data.  I've tested this one
on the QEMU versatile model, but not real hardware.  Most certainly
not everything is working here yet.  However, it is an example of how
to migrate a platform over to using the DT.

Cheers,
g.

---

Grant Likely (11):
      irq: add irq_domain translation infrastructure
      of/address: Add of_find_matching_node_by_address helper
      dt/irq: add irq_domain_add_simple() helper
      dt: add of_platform_populate() for creating device from the device tree
      dt: Add default match table for bus ids
      drivers/amba: create devices from device tree
      dt/platform: allow device name to be overridden
      powerpc/5200: convert mpc5200 to use of_platform_populate()
      arm/dt: Add dt machine definition
      arm/dt: Add skeleton dtsi file
      arm/versatile: Add device tree support


 .../devicetree/bindings/arm/primecell.txt          |   21 ++
 arch/arm/boot/dts/skeleton.dtsi                    |   13 +
 arch/arm/boot/dts/versatile-ab.dts                 |  185 +++++++++++++++++++
 arch/arm/boot/dts/versatile-pb.dts                 |   48 +++++
 arch/arm/include/asm/mach/arch.h                   |    9 +
 arch/arm/include/asm/prom.h                        |    5 -
 arch/arm/kernel/devtree.c                          |   14 -
 arch/arm/mach-versatile/Kconfig                    |    8 +
 arch/arm/mach-versatile/Makefile                   |    1 
 arch/arm/mach-versatile/core.c                     |   61 ++++++
 arch/arm/mach-versatile/core.h                     |    5 +
 arch/arm/mach-versatile/versatile_dt.c             |   66 +++++++
 arch/microblaze/include/asm/irq.h                  |   10 -
 arch/microblaze/kernel/irq.c                       |    7 -
 arch/mips/include/asm/irq.h                        |    5 -
 arch/mips/kernel/prom.c                            |   14 -
 arch/powerpc/include/asm/irq.h                     |    1 
 arch/powerpc/platforms/52xx/mpc52xx_common.c       |   10 -
 arch/x86/include/asm/irq_controller.h              |   12 -
 arch/x86/include/asm/prom.h                        |   10 -
 arch/x86/kernel/devicetree.c                       |  101 +++-------
 drivers/of/address.c                               |   18 ++
 drivers/of/platform.c                              |  196 +++++++++++++++++++-
 include/linux/irq.h                                |   92 +++++++++
 include/linux/of_address.h                         |    4 
 include/linux/of_irq.h                             |    2 
 include/linux/of_platform.h                        |   40 ++++
 kernel/irq/Makefile                                |    2 
 kernel/irq/irqdomain.c                             |  193 ++++++++++++++++++++
 29 files changed, 994 insertions(+), 159 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/primecell.txt
 create mode 100644 arch/arm/boot/dts/skeleton.dtsi
 create mode 100644 arch/arm/boot/dts/versatile-ab.dts
 create mode 100644 arch/arm/boot/dts/versatile-pb.dts
 create mode 100644 arch/arm/mach-versatile/versatile_dt.c
 delete mode 100644 arch/x86/include/asm/irq_controller.h
 create mode 100644 kernel/irq/irqdomain.c

-- 
Signature
