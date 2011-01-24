Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1AXE3X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 23:29:23 -0500
Received: from www.tglx.de ([62.245.132.106]:55485 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab1AXE3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 23:29:22 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Device tree on x86, part v3
Date: Mon, 24 Jan 2011 09:58:48 +0530
Message-Id: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces device tree support on x86. The device tree is 
passed by the bootloader via setup_data. It is used as an additional 
source of information and does not replace the "traditional" x86 boot
page.
Right now we get the the following information from it:
- hpet location
- apic & ioapic location
- ioapic's interrupt routing
- legacy devices which are not initialized by bios
- devices which are behind a bus which does not support enumeration like 
  i2c

History:
- v1 initial post
- v2: Benh took my device tree apart so once this got fixed I refactor a
      lot of code. Here are the changes:
      - device tree is unflattenend before kmalloc() is working,
        alloc_bootmem() is used for that.
      - irq_host got renamed to irq_domain. This custom implementation
        will leave once the powerpc implementation is in generic shape
      - of_irq_map_pci() is moved from ppc & microblaze into drivers/of
	and used also by x86 instead of a tiny subset of it. Bridges are
        not handled at all on x86 (I don't have any so for so I worry
        later)
      - the device tree is relocated from its initial location. That
        means that the boot loader does not need to know anything about
        kernel's memory layout.
- v3: - rebase on top of current tip. The OLPC merged some OF defines
        which are mostly nops so I replaced them with the code I have.
        irq_create_of_mapping() requires now an irq chip to work. Those
        things are moved into prom.c which is enabled by CONFIG_X86_OF.
        This probably breaks OLPC but I don't know what they need in the
	end.
      - Fixed up Grant's review comments. The most noticeable is the i2c
        controller node which has now three child nodes, representing the
        three controllers indentified by the bar number. Each pci bar
	matches via address translation the correct device tree node.

The series is based on the tip tree and is also available at
  git://git.linutronix.de/users/bigeasy/soda.git ce_of_v3

Sebastian Andrzej Siewior (14):
      x86/e820: remove conditional early mapping in parse_e820_ext
      x86: Add device tree support
      x86/dtb: Add a device tree for CE4100
      x86/dtb: add irq domain abstraction
      x86/dtb: add early parsing of APIC and IO APIC
      x86/dtb: add support hpet
      of: move of_irq_map_pci() into generic code
      x86/dtb: add support for PCI devices backed by dtb nodes
      x86/dtb: Add generic bus probe
      x86/ioapic: Add OF bindings for IO-APIC
      x86/ce4100: use OF for ioapic
      x86/rtc: don't register rtc if we the DT blob
      rtc/cmos: add OF bindings
      x86/pci: remove warning

 Documentation/powerpc/dts-bindings/rtc-cmos.txt |   28 ++
 Documentation/x86/boot_with_dtb.txt             |   26 ++
 arch/microblaze/include/asm/pci-bridge.h        |   12 +
 arch/microblaze/include/asm/prom.h              |   15 -
 arch/microblaze/kernel/prom_parse.c             |   77 -----
 arch/microblaze/pci/pci-common.c                |    1 +
 arch/powerpc/include/asm/pci-bridge.h           |   10 +
 arch/powerpc/include/asm/prom.h                 |   15 -
 arch/powerpc/kernel/pci-common.c                |    1 +
 arch/powerpc/kernel/prom_parse.c                |   84 ------
 arch/x86/Kconfig                                |    7 +
 arch/x86/include/asm/bootparam.h                |    1 +
 arch/x86/include/asm/e820.h                     |    2 +-
 arch/x86/include/asm/io_apic.h                  |    7 +
 arch/x86/include/asm/irq.h                      |    3 -
 arch/x86/include/asm/irq_controller.h           |   12 +
 arch/x86/include/asm/prom.h                     |   88 ++++++-
 arch/x86/kernel/Makefile                        |    1 +
 arch/x86/kernel/apic/io_apic.c                  |   99 +++++++
 arch/x86/kernel/e820.c                          |    8 +-
 arch/x86/kernel/irq.c                           |    9 -
 arch/x86/kernel/irqinit.c                       |    9 +-
 arch/x86/kernel/prom.c                          |  337 +++++++++++++++++++++++
 arch/x86/kernel/rtc.c                           |    3 +
 arch/x86/kernel/setup.c                         |   22 ++-
 arch/x86/pci/ce4100.c                           |    2 +-
 arch/x86/platform/ce4100/ce4100.c               |   24 ++-
 arch/x86/platform/ce4100/falconfalls.dts        |  228 +++++++++++++++
 drivers/of/Kconfig                              |    6 +
 drivers/of/Makefile                             |    1 +
 drivers/of/of_pci.c                             |   80 ++++++
 drivers/rtc/rtc-cmos.c                          |   46 +++
 include/linux/of.h                              |   12 +
 include/linux/of_pci.h                          |   20 ++
 34 files changed, 1072 insertions(+), 224 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/rtc-cmos.txt
 create mode 100644 Documentation/x86/boot_with_dtb.txt
 create mode 100644 arch/x86/include/asm/irq_controller.h
 create mode 100644 arch/x86/kernel/prom.c
 create mode 100644 arch/x86/platform/ce4100/falconfalls.dts
 create mode 100644 drivers/of/of_pci.c
 create mode 100644 include/linux/of_pci.h

Sebastian

