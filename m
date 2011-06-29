Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab1F2QsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:48:02 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47081 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439Ab1F2Qrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:47:55 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, nico@fluxnic.net,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 6/6] ARM: set vga memory base at run-time
Date: Wed, 29 Jun 2011 11:46:59 -0500
Message-Id: <1309366019-24379-7-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309366019-24379-1-git-send-email-robherring2@gmail.com>
References: <1309366019-24379-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert the incorrectly named PCIMEM_BASE to a variable called vga_base.
This removes the dependency on mach/hardware.h.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
---
 arch/arm/include/asm/vga.h                       |    5 +++--
 arch/arm/mach-dove/include/mach/hardware.h       |    3 ---
 arch/arm/mach-dove/pcie.c                        |    3 +++
 arch/arm/mach-footbridge/dc21285.c               |    1 +
 arch/arm/mach-integrator/include/mach/hardware.h |    2 --
 arch/arm/mach-integrator/pci_v3.c                |    2 ++
 arch/arm/mach-kirkwood/include/mach/hardware.h   |    3 ---
 arch/arm/mach-kirkwood/pcie.c                    |    2 ++
 arch/arm/mach-mv78xx0/include/mach/hardware.h    |    3 ---
 arch/arm/mach-mv78xx0/pcie.c                     |    2 ++
 arch/arm/mach-orion5x/include/mach/hardware.h    |    3 ---
 arch/arm/mach-orion5x/pci.c                      |    1 +
 arch/arm/mach-shark/include/mach/hardware.h      |    2 --
 arch/arm/mach-shark/pci.c                        |    2 ++
 arch/arm/mm/iomap.c                              |    3 +++
 15 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/arm/include/asm/vga.h b/arch/arm/include/asm/vga.h
index 250a4dd..91f4021 100644
--- a/arch/arm/include/asm/vga.h
+++ b/arch/arm/include/asm/vga.h
@@ -2,9 +2,10 @@
 #define ASMARM_VGA_H
 
 #include <linux/io.h>
-#include <mach/hardware.h>
 
-#define VGA_MAP_MEM(x,s)	(PCIMEM_BASE + (x))
+extern unsigned long vga_base;
+
+#define VGA_MAP_MEM(x,s)	(vga_base + (x))
 
 #define vga_readb(x)	(*((volatile unsigned char *)x))
 #define vga_writeb(x,y)	(*((volatile unsigned char *)y) = (x))
diff --git a/arch/arm/mach-dove/include/mach/hardware.h b/arch/arm/mach-dove/include/mach/hardware.h
index 94c5a2c..f1368b9 100644
--- a/arch/arm/mach-dove/include/mach/hardware.h
+++ b/arch/arm/mach-dove/include/mach/hardware.h
@@ -11,9 +11,6 @@
 
 #include "dove.h"
 
-#define PCIMEM_BASE			DOVE_PCIE0_MEM_PHYS_BASE
-
-
 /* Macros below are required for compatibility with PXA AC'97 driver.	*/
 #define __REG(x)	(*((volatile u32 *)((x) - DOVE_SB_REGS_PHYS_BASE + \
 				DOVE_SB_REGS_VIRT_BASE)))
diff --git a/arch/arm/mach-dove/pcie.c b/arch/arm/mach-dove/pcie.c
index 4810426..021579a 100644
--- a/arch/arm/mach-dove/pcie.c
+++ b/arch/arm/mach-dove/pcie.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/mbus.h>
+#include <video/vga.h>
 #include <asm/mach/pci.h>
 #include <asm/mach/arch.h>
 #include <asm/setup.h>
@@ -230,6 +231,8 @@ void __init dove_pcie_init(int init_port0, int init_port1)
 {
 	pcibios_min_io = 0x1000;
 	pcibios_min_mem = 0x01000000;
+	vga_base = DOVE_PCIE0_MEM_PHYS_BASE;
+
 	if (init_port0)
 		add_pcie_port(0, DOVE_PCIE0_VIRT_BASE);
 
diff --git a/arch/arm/mach-footbridge/dc21285.c b/arch/arm/mach-footbridge/dc21285.c
index e7ce279..5821fdd 100644
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -297,6 +297,7 @@ void __init dc21285_preinit(void)
 
 	pcibios_min_io = 0x1000;
 	pcibios_min_mem = 0x81000000;
+	vga_base = PCIMEM_BASE;
 
 	mem_size = (unsigned int)high_memory - PAGE_OFFSET;
 	for (mem_mask = 0x00100000; mem_mask < 0x10000000; mem_mask <<= 1)
diff --git a/arch/arm/mach-integrator/include/mach/hardware.h b/arch/arm/mach-integrator/include/mach/hardware.h
index 0ce5212..65fed7c 100644
--- a/arch/arm/mach-integrator/include/mach/hardware.h
+++ b/arch/arm/mach-integrator/include/mach/hardware.h
@@ -32,8 +32,6 @@
 #define IO_SIZE			0x0B000000                 // How much?
 #define IO_START		INTEGRATOR_HDR_BASE        // PA of IO
 
-#define PCIMEM_BASE		PCI_MEMORY_VADDR
-
 /* macro to get at IO space when running virtually */
 #ifdef CONFIG_MMU
 #define IO_ADDRESS(x)	(((x) & 0x000fffff) | (((x) >> 4) & 0x0ff00000) | IO_BASE)
diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index 11b86e5..dd56bfb 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -27,6 +27,7 @@
 #include <linux/spinlock.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <video/vga.h>
 
 #include <mach/hardware.h>
 #include <mach/platform.h>
@@ -504,6 +505,7 @@ void __init pci_v3_preinit(void)
 
 	pcibios_min_io = 0x6000;
 	pcibios_min_mem = 0x00100000;
+	vga_base = PCI_MEMORY_VADDR;
 
 	/*
 	 * Hook in our fault handler for PCI errors
diff --git a/arch/arm/mach-kirkwood/include/mach/hardware.h b/arch/arm/mach-kirkwood/include/mach/hardware.h
index 470899b..742b74f 100644
--- a/arch/arm/mach-kirkwood/include/mach/hardware.h
+++ b/arch/arm/mach-kirkwood/include/mach/hardware.h
@@ -11,7 +11,4 @@
 
 #include "kirkwood.h"
 
-#define PCIMEM_BASE			KIRKWOOD_PCIE_MEM_PHYS_BASE /* mem base for VGA */
-
-
 #endif
diff --git a/arch/arm/mach-kirkwood/pcie.c b/arch/arm/mach-kirkwood/pcie.c
index 6e32b8a..b53002c 100644
--- a/arch/arm/mach-kirkwood/pcie.c
+++ b/arch/arm/mach-kirkwood/pcie.c
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/mbus.h>
+#include <video/vga.h>
 #include <asm/irq.h>
 #include <asm/mach/pci.h>
 #include <plat/pcie.h>
@@ -273,6 +274,7 @@ void __init kirkwood_pcie_init(unsigned int portmask)
 {
 	pcibios_min_io = 0x00001000;
 	pcibios_min_mem = 0x01000000;
+	vga_base = KIRKWOOD_PCIE_MEM_PHYS_BASE;
 
 	if (portmask & KW_PCIE0)
 		add_pcie_port(0, PCIE_VIRT_BASE);
diff --git a/arch/arm/mach-mv78xx0/include/mach/hardware.h b/arch/arm/mach-mv78xx0/include/mach/hardware.h
index 29e37ed..67cab0a 100644
--- a/arch/arm/mach-mv78xx0/include/mach/hardware.h
+++ b/arch/arm/mach-mv78xx0/include/mach/hardware.h
@@ -11,7 +11,4 @@
 
 #include "mv78xx0.h"
 
-#define PCIMEM_BASE			MV78XX0_PCIE_MEM_PHYS_BASE /* mem base for VGA */
-
-
 #endif
diff --git a/arch/arm/mach-mv78xx0/pcie.c b/arch/arm/mach-mv78xx0/pcie.c
index cc9d1b9..bafd1ed 100644
--- a/arch/arm/mach-mv78xx0/pcie.c
+++ b/arch/arm/mach-mv78xx0/pcie.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/mbus.h>
+#include <video/vga.h>
 #include <asm/irq.h>
 #include <asm/mach/pci.h>
 #include <plat/pcie.h>
@@ -299,6 +300,7 @@ void __init mv78xx0_pcie_init(int init_port0, int init_port1)
 {
 	pcibios_min_io = 0x00001000;
 	pcibios_min_mem = 0x01000000;
+	vga_base = MV78XX0_PCIE_MEM_PHYS_BASE;
 
 	if (init_port0) {
 		add_pcie_port(0, 0, PCIE00_VIRT_BASE);
diff --git a/arch/arm/mach-orion5x/include/mach/hardware.h b/arch/arm/mach-orion5x/include/mach/hardware.h
index b6d55bc..3957354 100644
--- a/arch/arm/mach-orion5x/include/mach/hardware.h
+++ b/arch/arm/mach-orion5x/include/mach/hardware.h
@@ -11,7 +11,4 @@
 
 #include "orion5x.h"
 
-#define PCIMEM_BASE		ORION5X_PCIE_MEM_PHYS_BASE
-
-
 #endif
diff --git a/arch/arm/mach-orion5x/pci.c b/arch/arm/mach-orion5x/pci.c
index d80aeef..7dc672c 100644
--- a/arch/arm/mach-orion5x/pci.c
+++ b/arch/arm/mach-orion5x/pci.c
@@ -562,6 +562,7 @@ int __init orion5x_pci_sys_setup(int nr, struct pci_sys_data *sys)
 
 	pcibios_min_io = 0x00001000;
 	pcibios_min_mem = 0x01000000;
+	vga_base = ORION5X_PCIE_MEM_PHYS_BASE;
 
 	if (nr == 0) {
 		orion_pcie_set_local_bus_nr(PCIE_BASE, sys->busnr);
diff --git a/arch/arm/mach-shark/include/mach/hardware.h b/arch/arm/mach-shark/include/mach/hardware.h
index 4342931..663f952 100644
--- a/arch/arm/mach-shark/include/mach/hardware.h
+++ b/arch/arm/mach-shark/include/mach/hardware.h
@@ -12,7 +12,5 @@
 
 #define UNCACHEABLE_ADDR        0xdf010000
 
-#define PCIMEM_BASE		0xe8000000
-
 #endif
 
diff --git a/arch/arm/mach-shark/pci.c b/arch/arm/mach-shark/pci.c
index 4aea637..92d7227 100644
--- a/arch/arm/mach-shark/pci.c
+++ b/arch/arm/mach-shark/pci.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/init.h>
+#include <video/vga.h>
 
 #include <asm/irq.h>
 #include <asm/mach/pci.h>
@@ -42,6 +43,7 @@ static int __init shark_pci_init(void)
 
 	pcibios_min_io = 0x6000;
 	pcibios_min_mem = 0x50000000;
+	vga_base = 0xe8000000;
 
 	pci_common_init(&shark_pci);
 
diff --git a/arch/arm/mm/iomap.c b/arch/arm/mm/iomap.c
index 8946326..476ad1a 100644
--- a/arch/arm/mm/iomap.c
+++ b/arch/arm/mm/iomap.c
@@ -9,6 +9,9 @@
 #include <linux/ioport.h>
 #include <linux/io.h>
 
+unsigned long vga_base;
+EXPORT_SYMBOL(vga_base);
+
 #ifdef __io
 void __iomem *ioport_map(unsigned long port, unsigned int nr)
 {
-- 
1.7.4.1

