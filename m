Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab2INVf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:35:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61740 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab2INVfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH 07/24] ARM: iop13xx: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:35 +0200
Message-Id: <1347658492-11608-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:7MyyH4DQRAyQyWfcUPKTw1eEBGZ7d0zdhpUfp1w3YBl
 K6RiOx1ETX5Zgssh7klx27oAam3mcRz+6ND3qIZ3HnqcFpxNuL
 bKeyiCPTq8uIhizlu/pwTJTSjwE74kDqCK5KC0cgmZas40Tohd
 UsNpB5il+hkzaq88+sZpL1ChBTDiE19S2z2JQrLDvvD8zAEK7u
 G90aVD4YDqWszutNyjmcXR+HqX2nm0wWiDQzmSnIgtgXeHH3pu
 iKVKPymm0fuiW+x3P6iy/NdMH6i8XiCz2rxgVy10ZZz87oKI1K
 xREd+0Uq7EnQP6+zgxyPBBgUePe1//KDOtzg/SeqONof00Rcl4
 H20sPghGTmOKAUmirZnGQIqkzvKJbYFmxM+X/0PEy2wBcdP0H+
 LlA7uuN0EdDJw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-iop13xx/include/mach/iop13xx.h |   20 +++++++++-----------
 arch/arm/mach-iop13xx/include/mach/memory.h  |   14 +++++++-------
 arch/arm/mach-iop13xx/io.c                   |   12 ++++++------
 arch/arm/mach-iop13xx/pci.c                  |   16 +++++++---------
 arch/arm/mach-iop13xx/pci.h                  |    4 ++--
 arch/arm/mach-iop13xx/setup.c                |   10 +++++-----
 6 files changed, 36 insertions(+), 40 deletions(-)

diff --git a/arch/arm/mach-iop13xx/include/mach/iop13xx.h b/arch/arm/mach-iop13xx/include/mach/iop13xx.h
index e190dcd..01b41ab 100644
--- a/arch/arm/mach-iop13xx/include/mach/iop13xx.h
+++ b/arch/arm/mach-iop13xx/include/mach/iop13xx.h
@@ -148,18 +148,16 @@ extern unsigned long get_iop_tick_rate(void);
  * IOP13XX chipset registers
  */
 #define IOP13XX_PMMR_PHYS_MEM_BASE	   0xffd80000UL  /* PMMR phys. address */
-#define IOP13XX_PMMR_VIRT_MEM_BASE	   0xfee80000UL  /* PMMR phys. address */
+#define IOP13XX_PMMR_VIRT_MEM_BASE	   (void __iomem *)(0xfee80000UL)  /* PMMR phys. address */
 #define IOP13XX_PMMR_MEM_WINDOW_SIZE	   0x80000
 #define IOP13XX_PMMR_UPPER_MEM_VA	   (IOP13XX_PMMR_VIRT_MEM_BASE +\
 					   IOP13XX_PMMR_MEM_WINDOW_SIZE - 1)
 #define IOP13XX_PMMR_UPPER_MEM_PA	   (IOP13XX_PMMR_PHYS_MEM_BASE +\
 					   IOP13XX_PMMR_MEM_WINDOW_SIZE - 1)
-#define IOP13XX_PMMR_VIRT_TO_PHYS(addr)   (u32) ((u32) addr +\
-					   (IOP13XX_PMMR_PHYS_MEM_BASE\
-					   - IOP13XX_PMMR_VIRT_MEM_BASE))
-#define IOP13XX_PMMR_PHYS_TO_VIRT(addr)   (u32) ((u32) addr -\
-					   (IOP13XX_PMMR_PHYS_MEM_BASE\
-					   - IOP13XX_PMMR_VIRT_MEM_BASE))
+#define IOP13XX_PMMR_VIRT_TO_PHYS(addr)   (((addr) - IOP13XX_PMMR_VIRT_MEM_BASE)\
+					   + IOP13XX_PMMR_PHYS_MEM_BASE)
+#define IOP13XX_PMMR_PHYS_TO_VIRT(addr)   (((addr) - IOP13XX_PMMR_PHYS_MEM_BASE)\
+					   + IOP13XX_PMMR_VIRT_MEM_BASE)
 #define IOP13XX_REG_ADDR32(reg)     	   (IOP13XX_PMMR_VIRT_MEM_BASE + (reg))
 #define IOP13XX_REG_ADDR16(reg)     	   (IOP13XX_PMMR_VIRT_MEM_BASE + (reg))
 #define IOP13XX_REG_ADDR8(reg)      	   (IOP13XX_PMMR_VIRT_MEM_BASE + (reg))
@@ -169,10 +167,10 @@ extern unsigned long get_iop_tick_rate(void);
 #define IOP13XX_PMMR_SIZE		   0x00080000
 
 /*=================== Defines for Platform Devices =====================*/
-#define IOP13XX_UART0_PHYS  (IOP13XX_PMMR_PHYS_MEM_BASE | 0x00002300)
-#define IOP13XX_UART1_PHYS  (IOP13XX_PMMR_PHYS_MEM_BASE | 0x00002340)
-#define IOP13XX_UART0_VIRT  (IOP13XX_PMMR_VIRT_MEM_BASE | 0x00002300)
-#define IOP13XX_UART1_VIRT  (IOP13XX_PMMR_VIRT_MEM_BASE | 0x00002340)
+#define IOP13XX_UART0_PHYS  (IOP13XX_PMMR_PHYS_MEM_BASE + 0x00002300)
+#define IOP13XX_UART1_PHYS  (IOP13XX_PMMR_PHYS_MEM_BASE + 0x00002340)
+#define IOP13XX_UART0_VIRT  (IOP13XX_PMMR_VIRT_MEM_BASE + 0x00002300)
+#define IOP13XX_UART1_VIRT  (IOP13XX_PMMR_VIRT_MEM_BASE + 0x00002340)
 
 #define IOP13XX_I2C0_PHYS   (IOP13XX_PMMR_PHYS_MEM_BASE | 0x00002500)
 #define IOP13XX_I2C1_PHYS   (IOP13XX_PMMR_PHYS_MEM_BASE | 0x00002520)
diff --git a/arch/arm/mach-iop13xx/include/mach/memory.h b/arch/arm/mach-iop13xx/include/mach/memory.h
index 1afa99e..7c032d0 100644
--- a/arch/arm/mach-iop13xx/include/mach/memory.h
+++ b/arch/arm/mach-iop13xx/include/mach/memory.h
@@ -16,12 +16,12 @@
 #define IOP13XX_PMMR_P_START (IOP13XX_PMMR_PHYS_MEM_BASE)
 #define IOP13XX_PMMR_P_END   (IOP13XX_PMMR_PHYS_MEM_BASE + IOP13XX_PMMR_SIZE)
 
-static inline dma_addr_t __virt_to_lbus(unsigned long x)
+static inline dma_addr_t __virt_to_lbus(void __iomem *x)
 {
 	return x + IOP13XX_PMMR_PHYS_MEM_BASE - IOP13XX_PMMR_VIRT_MEM_BASE;
 }
 
-static inline unsigned long __lbus_to_virt(dma_addr_t x)
+static inline void __iomem *__lbus_to_virt(dma_addr_t x)
 {
 	return x + IOP13XX_PMMR_VIRT_MEM_BASE - IOP13XX_PMMR_PHYS_MEM_BASE;
 }
@@ -38,23 +38,23 @@ static inline unsigned long __lbus_to_virt(dma_addr_t x)
 
 #define __arch_dma_to_virt(dev, addr)					\
 	({								\
-		unsigned long __virt;					\
+		void * __virt;						\
 		dma_addr_t __dma = addr;				\
 		if (is_lbus_device(dev) && __is_lbus_dma(__dma))	\
 			__virt = __lbus_to_virt(__dma);			\
 		else							\
-			__virt = __phys_to_virt(__dma);			\
-		(void *)__virt;						\
+			__virt = (void *)__phys_to_virt(__dma);		\
+		__virt;							\
 	})
 
 #define __arch_virt_to_dma(dev, addr)					\
 	({								\
-		unsigned long __virt = (unsigned long)addr;		\
+		void * __virt = addr;					\
 		dma_addr_t __dma;					\
 		if (is_lbus_device(dev) && __is_lbus_virt(__virt))	\
 			__dma = __virt_to_lbus(__virt);			\
 		else							\
-			__dma = __virt_to_phys(__virt);			\
+			__dma = __virt_to_phys((unsigned long)__virt);	\
 		__dma;							\
 	})
 
diff --git a/arch/arm/mach-iop13xx/io.c b/arch/arm/mach-iop13xx/io.c
index 3c36419..b651af9 100644
--- a/arch/arm/mach-iop13xx/io.c
+++ b/arch/arm/mach-iop13xx/io.c
@@ -52,14 +52,14 @@ static void __iomem *__iop13xx_ioremap_caller(unsigned long cookie,
 		if (unlikely(!iop13xx_atux_mem_base))
 			retval = NULL;
 		else
-			retval = (void *)(iop13xx_atux_mem_base +
+			retval = (iop13xx_atux_mem_base +
 			         (cookie - IOP13XX_PCIX_LOWER_MEM_RA));
 		break;
 	case IOP13XX_PCIE_LOWER_MEM_RA ... IOP13XX_PCIE_UPPER_MEM_RA:
 		if (unlikely(!iop13xx_atue_mem_base))
 			retval = NULL;
 		else
-			retval = (void *)(iop13xx_atue_mem_base +
+			retval = (iop13xx_atue_mem_base +
 			         (cookie - IOP13XX_PCIE_LOWER_MEM_RA));
 		break;
 	case IOP13XX_PBI_LOWER_MEM_RA ... IOP13XX_PBI_UPPER_MEM_RA:
@@ -74,7 +74,7 @@ static void __iomem *__iop13xx_ioremap_caller(unsigned long cookie,
 		retval = (void *) IOP13XX_PCIX_IO_PHYS_TO_VIRT(cookie);
 		break;
 	case IOP13XX_PMMR_PHYS_MEM_BASE ... IOP13XX_PMMR_UPPER_MEM_PA:
-		retval = (void *) IOP13XX_PMMR_PHYS_TO_VIRT(cookie);
+		retval = IOP13XX_PMMR_PHYS_TO_VIRT(cookie);
 		break;
 	default:
 		retval = __arm_ioremap_caller(cookie, size, mtype,
@@ -99,9 +99,9 @@ static void __iop13xx_iounmap(volatile void __iomem *addr)
 		    goto skip;
 
 	switch ((u32) addr) {
-	case IOP13XX_PCIE_LOWER_IO_VA ... IOP13XX_PCIE_UPPER_IO_VA:
-	case IOP13XX_PCIX_LOWER_IO_VA ... IOP13XX_PCIX_UPPER_IO_VA:
-	case IOP13XX_PMMR_VIRT_MEM_BASE ... IOP13XX_PMMR_UPPER_MEM_VA:
+	case (u32)IOP13XX_PCIE_LOWER_IO_VA ... (u32)IOP13XX_PCIE_UPPER_IO_VA:
+	case (u32)IOP13XX_PCIX_LOWER_IO_VA ... (u32)IOP13XX_PCIX_UPPER_IO_VA:
+	case (u32)IOP13XX_PMMR_VIRT_MEM_BASE ... (u32)IOP13XX_PMMR_UPPER_MEM_VA:
 		goto skip;
 	}
 	__iounmap(addr);
diff --git a/arch/arm/mach-iop13xx/pci.c b/arch/arm/mach-iop13xx/pci.c
index 861cb12..b38e97c 100644
--- a/arch/arm/mach-iop13xx/pci.c
+++ b/arch/arm/mach-iop13xx/pci.c
@@ -36,8 +36,8 @@ u32 iop13xx_atux_pmmr_offset; /* This offset can change based on strapping */
 u32 iop13xx_atue_pmmr_offset; /* This offset can change based on strapping */
 static struct pci_bus *pci_bus_atux = 0;
 static struct pci_bus *pci_bus_atue = 0;
-u32 iop13xx_atue_mem_base;
-u32 iop13xx_atux_mem_base;
+void __iomem *iop13xx_atue_mem_base;
+void __iomem *iop13xx_atux_mem_base;
 size_t iop13xx_atue_mem_size;
 size_t iop13xx_atux_mem_size;
 
@@ -88,8 +88,7 @@ void iop13xx_map_pci_memory(void)
 				}
 
 				if (end) {
-					iop13xx_atux_mem_base =
-					(u32) __arm_ioremap_pfn(
+					iop13xx_atux_mem_base = __arm_ioremap_pfn(
 					__phys_to_pfn(IOP13XX_PCIX_LOWER_MEM_PA)
 					, 0, iop13xx_atux_mem_size, MT_DEVICE);
 					if (!iop13xx_atux_mem_base) {
@@ -99,7 +98,7 @@ void iop13xx_map_pci_memory(void)
 					}
 				} else
 					iop13xx_atux_mem_size = 0;
-				PRINTK("%s: atu: %d bus_size: %d mem_base: %x\n",
+				PRINTK("%s: atu: %d bus_size: %d mem_base: %p\n",
 				__func__, atu, iop13xx_atux_mem_size,
 				iop13xx_atux_mem_base);
 				break;
@@ -114,8 +113,7 @@ void iop13xx_map_pci_memory(void)
 				}
 
 				if (end) {
-					iop13xx_atue_mem_base =
-					(u32) __arm_ioremap_pfn(
+					iop13xx_atue_mem_base = __arm_ioremap_pfn(
 					__phys_to_pfn(IOP13XX_PCIE_LOWER_MEM_PA)
 					, 0, iop13xx_atue_mem_size, MT_DEVICE);
 					if (!iop13xx_atue_mem_base) {
@@ -125,13 +123,13 @@ void iop13xx_map_pci_memory(void)
 					}
 				} else
 					iop13xx_atue_mem_size = 0;
-				PRINTK("%s: atu: %d bus_size: %d mem_base: %x\n",
+				PRINTK("%s: atu: %d bus_size: %d mem_base: %p\n",
 				__func__, atu, iop13xx_atue_mem_size,
 				iop13xx_atue_mem_base);
 				break;
 			}
 
-			printk("%s: Initialized (%uM @ resource/virtual: %08lx/%08x)\n",
+			printk("%s: Initialized (%uM @ resource/virtual: %08lx/%p)\n",
 			atu ? "ATUE" : "ATUX",
 			(atu ? iop13xx_atue_mem_size : iop13xx_atux_mem_size) /
 			SZ_1M,
diff --git a/arch/arm/mach-iop13xx/pci.h b/arch/arm/mach-iop13xx/pci.h
index c70cf5b..d45a80b 100644
--- a/arch/arm/mach-iop13xx/pci.h
+++ b/arch/arm/mach-iop13xx/pci.h
@@ -1,6 +1,6 @@
 #include <linux/types.h>
 
-extern u32 iop13xx_atue_mem_base;
-extern u32 iop13xx_atux_mem_base;
+extern void __iomem *iop13xx_atue_mem_base;
+extern void __iomem *iop13xx_atux_mem_base;
 extern size_t iop13xx_atue_mem_size;
 extern size_t iop13xx_atux_mem_size;
diff --git a/arch/arm/mach-iop13xx/setup.c b/arch/arm/mach-iop13xx/setup.c
index daabb1f..f5c2a22 100644
--- a/arch/arm/mach-iop13xx/setup.c
+++ b/arch/arm/mach-iop13xx/setup.c
@@ -36,7 +36,7 @@
  */
 static struct map_desc iop13xx_std_desc[] __initdata = {
 	{    /* mem mapped registers */
-		.virtual = IOP13XX_PMMR_VIRT_MEM_BASE,
+		.virtual = (unsigned long)IOP13XX_PMMR_VIRT_MEM_BASE,
 		.pfn 	 = __phys_to_pfn(IOP13XX_PMMR_PHYS_MEM_BASE),
 		.length  = IOP13XX_PMMR_SIZE,
 		.type	 = MT_DEVICE,
@@ -81,8 +81,8 @@ static struct resource iop13xx_uart1_resources[] = {
 
 static struct plat_serial8250_port iop13xx_uart0_data[] = {
 	{
-       .membase     = (char*)(IOP13XX_UART0_VIRT),
-       .mapbase     = (IOP13XX_UART0_PHYS),
+       .membase     = IOP13XX_UART0_VIRT,
+       .mapbase     = IOP13XX_UART0_PHYS,
        .irq         = IRQ_IOP13XX_UART0,
        .uartclk     = IOP13XX_UART_XTAL,
        .regshift    = 2,
@@ -94,8 +94,8 @@ static struct plat_serial8250_port iop13xx_uart0_data[] = {
 
 static struct plat_serial8250_port iop13xx_uart1_data[] = {
 	{
-       .membase     = (char*)(IOP13XX_UART1_VIRT),
-       .mapbase     = (IOP13XX_UART1_PHYS),
+       .membase     = IOP13XX_UART1_VIRT,
+       .mapbase     = IOP13XX_UART1_PHYS,
        .irq         = IRQ_IOP13XX_UART1,
        .uartclk     = IOP13XX_UART_XTAL,
        .regshift    = 2,
-- 
1.7.10

