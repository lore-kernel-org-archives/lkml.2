Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab1GLQyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:54:03 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60741 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab1GLQx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:53:57 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Cc: Michal Simek <monstr@monstr.eu>, nico@fluxnic.net,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 6/6] ARM: set vga memory base at run-time
Date: Tue, 12 Jul 2011 11:53:32 -0500
Message-Id: <1310489612-8625-7-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310489612-8625-1-git-send-email-robherring2@gmail.com>
References: <1310489612-8625-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert the incorrectly named PCIMEM_BASE to a variable called vga_base.
This removes the dependency on mach/hardware.h.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/vga.h                       |    5 +++--
 arch/arm/mach-dove/include/mach/hardware.h       |    3 ---
 arch/arm/mach-dove/pcie.c                        |    3 +++
 arch/arm/mach-footbridge/dc21285.c               |    1 +
 arch/arm/mach-integrator/include/mach/hardware.h |    2 --
 arch/arm/mach-integrator/pci_v3.c                |    2 ++
 arch/arm/mach-kirkwood/include/mach/hardware.h   |    3 ---
 arch/arm/mach-kirkwood/pcie.c                    |    3 +++
 arch/arm/mach-mv78xx0/include/mach/hardware.h    |    3 ---
 arch/arm/mach-mv78xx0/pcie.c                     |    3 +++
 arch/arm/mach-orion5x/include/mach/hardware.h    |    3 ---
 arch/arm/mach-orion5x/pci.c                      |    2 ++
 arch/arm/mach-shark/include/mach/hardware.h      |    2 --
 arch/arm/mach-shark/pci.c                        |    2 ++
 arch/arm/mm/iomap.c                              |    3 +++
 15 files changed, 22 insertions(+), 18 deletions(-)

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
index 502d1ca..c2f1c47 100644
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
@@ -228,6 +229,8 @@ static void __init add_pcie_port(int index, unsigned long base)
 
 void __init dove_pcie_init(int init_port0, int init_port1)
 {
+	vga_base = DOVE_PCIE0_MEM_PHYS_BASE;
+
 	if (init_port0)
 		add_pcie_port(0, DOVE_PCIE0_VIRT_BASE);
 
diff --git a/arch/arm/mach-footbridge/dc21285.c b/arch/arm/mach-footbridge/dc21285.c
index a8dfa00..1331fff 100644
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -296,6 +296,7 @@ void __init dc21285_preinit(void)
 	int cfn_mode;
 
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
index ca294ff..bfeb9c9 100644
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
@@ -271,6 +272,8 @@ static void __init add_pcie_port(int index, unsigned long base)
 
 void __init kirkwood_pcie_init(unsigned int portmask)
 {
+	vga_base = KIRKWOOD_PCIE_MEM_PHYS_BASE;
+
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
index a560439..445a332 100644
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
@@ -297,6 +298,8 @@ static void __init add_pcie_port(int maj, int min, unsigned long base)
 
 void __init mv78xx0_pcie_init(int init_port0, int init_port1)
 {
+	vga_base = MV78XX0_PCIE_MEM_PHYS_BASE;
+
 	if (init_port0) {
 		add_pcie_port(0, 0, PCIE00_VIRT_BASE);
 		if (!orion_pcie_x4_mode((void __iomem *)PCIE00_VIRT_BASE)) {
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
index e8706f1..f64965d 100644
--- a/arch/arm/mach-orion5x/pci.c
+++ b/arch/arm/mach-orion5x/pci.c
@@ -560,6 +560,8 @@ int __init orion5x_pci_sys_setup(int nr, struct pci_sys_data *sys)
 {
 	int ret = 0;
 
+	vga_base = ORION5X_PCIE_MEM_PHYS_BASE;
+
 	if (nr == 0) {
 		orion_pcie_set_local_bus_nr(PCIE_BASE, sys->busnr);
 		ret = pcie_setup(sys);
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
index 3d46cf4..430df1a 100644
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

