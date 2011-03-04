Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab1CDKMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:12:42 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:54488 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab1CDKMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:12:37 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>, "'Guan Xuetao'" <epip@hera.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <greg@kroah.com>
References: <cover.1298821856.git.epip@hera.kernel.org> <e01e265d8c1ee1acf67177717a3611691cccf1da.1298821856.git.epip@hera.kernel.org> <201102281635.56528.arnd@arndb.de>
In-Reply-To: <201102281635.56528.arnd@arndb.de>
Subject: RE: [PATCH 16/17] unicore32: add (void __iomem *) to io_p2v macro
Date: Fri, 4 Mar 2011 18:12:18 +0800
Message-ID: <03ba01cbda54$a5c39f00$f14add00$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFwUWJwWz5DKqeEVgvooZZn2tVwVwJLkYN9AjOgA1OUsAwHsA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Monday, February 28, 2011 11:36 PM
> To: Guan Xuetao
> Cc: GuanXuetao; linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; greg@kroah.com
> Subject: Re: [PATCH 16/17] unicore32: add (void __iomem *) to io_p2v macro
> 
> On Sunday 27 February 2011, Guan Xuetao wrote:
> > -#define PKUNITY_AC97_CONR              __REG(PKUNITY_AC97_BASE + 0x0000)
> > -#define PKUNITY_AC97_OCR               __REG(PKUNITY_AC97_BASE + 0x0004)
> > -#define PKUNITY_AC97_ICR               __REG(PKUNITY_AC97_BASE + 0x0008)
> > -#define PKUNITY_AC97_CRAC              __REG(PKUNITY_AC97_BASE + 0x000C)
> > -#define PKUNITY_AC97_INTR              __REG(PKUNITY_AC97_BASE + 0x0010)
> > -#define PKUNITY_AC97_INTRSTAT          __REG(PKUNITY_AC97_BASE + 0x0014)
> > -#define PKUNITY_AC97_INTRCLEAR         __REG(PKUNITY_AC97_BASE + 0x0018)
> > -#define PKUNITY_AC97_ENABLE            __REG(PKUNITY_AC97_BASE + 0x001C)
> > -#define PKUNITY_AC97_OUT_FIFO          __REG(PKUNITY_AC97_BASE + 0x0020)
> > -#define PKUNITY_AC97_IN_FIFO           __REG(PKUNITY_AC97_BASE + 0x0030)
> > +#define PKUNITY_AC97_CONR              io_p2v(PKUNITY_AC97_BASE + 0x0000)
> > +#define PKUNITY_AC97_OCR               io_p2v(PKUNITY_AC97_BASE + 0x0004)
> > +#define PKUNITY_AC97_ICR               io_p2v(PKUNITY_AC97_BASE + 0x0008)
> > +#define PKUNITY_AC97_CRAC              io_p2v(PKUNITY_AC97_BASE + 0x000C)
> > +#define PKUNITY_AC97_INTR              io_p2v(PKUNITY_AC97_BASE + 0x0010)
> 
> One more comment on the types here (applies to the entire patch):
> 
> It would be more straightforward to the define the underlying base
> addresses using io_p2v, and then do a simple addition, instead of
> another macro that adds a type cast:
> 
> #define PKUNITY_SYSTEM_AHB	io_p2v(0xC0000000)
> #define PKUNITY_PERIPHERAL_AHB	io_p2v(0xEE000000)
> 
> #define PKUNITY_UART0_BASE	(PKUNITY_PERIPHERAL_AHB + 0x00000000)
> #define PKUNITY_AC97_BASE	(PKUNITY_PERIPHERAL_AHB + 0x00400000)
> 
> #define PKUNITY_AC97_CONR	(PKUNITY_AC97_BASE + 0x0000)
> #define PKUNITY_AC97_OCR	(PKUNITY_AC97_BASE + 0x0004)
> 
> It would be nice if you could do that for the entire set of hardware
> headers.
Ok, I rewrite this patch, as following (sorry for tediousness):

From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Fri, 4 Mar 2011 18:07:48 +0800
Subject: [PATCH] unicore32: modify io_p2v and io_v2p macros, and adjust PKUNITY_mmio_BASEs

1. remove __REG macro
2. add (void __iomem *) to io_p2v macro
3. add (phys_addr_t) to io_v2p macro
4. add PKUNITY_AHB_BASE and PKUNITY_APB_BASE definitions
5. modify all PKUNITY_mmio_BASEs from physical addr to virtual addr
6. adjust prefix macro for all usage of PKUNITY_mmio_BASEs
  -- by advice with Arnd Bergmann

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/io.h           |    2 +-
 arch/unicore32/include/mach/PKUnity.h     |   88 ++++++++++----------
 arch/unicore32/include/mach/hardware.h    |   11 +--
 arch/unicore32/include/mach/memory.h      |    4 +-
 arch/unicore32/include/mach/regs-ac97.h   |   20 ++--
 arch/unicore32/include/mach/regs-dmac.h   |   20 ++--
 arch/unicore32/include/mach/regs-gpio.h   |   16 ++--
 arch/unicore32/include/mach/regs-i2c.h    |   16 ++--
 arch/unicore32/include/mach/regs-intc.h   |   12 ++--
 arch/unicore32/include/mach/regs-nand.h   |   32 ++++----
 arch/unicore32/include/mach/regs-ost.h    |   22 +++---
 arch/unicore32/include/mach/regs-pci.h    |  122 ++++++++++++++--------------
 arch/unicore32/include/mach/regs-pm.h     |   36 ++++----
 arch/unicore32/include/mach/regs-ps2.h    |    8 +-
 arch/unicore32/include/mach/regs-resetc.h |    4 +-
 arch/unicore32/include/mach/regs-rtc.h    |    8 +-
 arch/unicore32/include/mach/regs-sdc.h    |   32 ++++----
 arch/unicore32/include/mach/regs-spi.h    |   12 ++--
 arch/unicore32/include/mach/regs-umal.h   |   76 +++++++++---------
 arch/unicore32/include/mach/regs-unigfx.h |  128 ++++++++++++++--------------
 arch/unicore32/kernel/entry.S             |    2 +-
 arch/unicore32/kernel/irq.c               |    4 +-
 arch/unicore32/kernel/pci.c               |   12 ++--
 arch/unicore32/kernel/puv3-core.c         |   32 ++++----
 arch/unicore32/kernel/puv3-nb0916.c       |    4 +-
 arch/unicore32/kernel/sleep.S             |    4 +-
 26 files changed, 365 insertions(+), 362 deletions(-)

diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
index 2483fcb..4bd87f3 100644
--- a/arch/unicore32/include/asm/io.h
+++ b/arch/unicore32/include/asm/io.h
@@ -18,7 +18,7 @@
 #include <asm/memory.h>
 #include <asm/system.h>
 
-#define PCI_IOBASE	io_p2v(PKUNITY_PCILIO_BASE)
+#define PCI_IOBASE	PKUNITY_PCILIO_BASE
 #include <asm-generic/io.h>
 
 /*
diff --git a/arch/unicore32/include/mach/PKUnity.h b/arch/unicore32/include/mach/PKUnity.h
index 940e9ed..a18bdc3 100644
--- a/arch/unicore32/include/mach/PKUnity.h
+++ b/arch/unicore32/include/mach/PKUnity.h
@@ -22,83 +22,87 @@
  */
 #define PKUNITY_SDRAM_BASE		0x00000000 /* 0x00000000 - 0x7FFFFFFF 2GB */
 #define PKUNITY_MMIO_BASE		0x80000000 /* 0x80000000 - 0xFFFFFFFF 2GB */
-#define PKUNITY_PCI_BASE		0x80000000 /* 0x80000000 - 0xBFFFFFFF 1GB */
-#include "regs-pci.h"
-#define PKUNITY_BOOT_ROM2_BASE		0xF4000000 /* 0xF4000000 - 0xF7FFFFFF 64MB */
-#define PKUNITY_BOOT_SRAM2_BASE		0xF8000000 /* 0xF8000000 - 0xFBFFFFFF 64MB */
-#define PKUNITY_BOOT_FLASH_BASE		0xFC000000 /* 0xFC000000 - 0xFFFFFFFF 64MB */
 
 /*
  * PKUNITY Memory Map Addresses: 0x0D000000 - 0x0EFFFFFF (32MB)
+ *	0x0D000000 - 0x0DFFFFFF 16MB: for UVC
+ *	0x0E000000 - 0x0EFFFFFF 16MB: for UNIGFX
  */
-#define PKUNITY_UVC_MMAP_BASE		0x0D000000 /* 0x0D000000 - 0x0DFFFFFF 16MB */
+#define PKUNITY_UVC_MMAP_BASE		0x0D000000
 #define PKUNITY_UVC_MMAP_SIZE		0x01000000 /* 16MB */
-#define PKUNITY_UNIGFX_MMAP_BASE        0x0E000000 /* 0x0E000000 - 0x0EFFFFFF 16MB */
+#define PKUNITY_UNIGFX_MMAP_BASE        0x0E000000
 #define PKUNITY_UNIGFX_MMAP_SIZE        0x01000000 /* 16MB */
 
 /*
  * PKUNITY System Bus Addresses (PCI): 0x80000000 - 0xBFFFFFFF (1GB)
+ * 0x80000000 - 0x8000000B 12B    PCI Configuration regs
+ * 0x80010000 - 0x80010250 592B   PCI Bridge Base
+ * 0x80030000 - 0x8003FFFF 64KB   PCI Legacy IO
+ * 0x90000000 - 0x97FFFFFF 128MB  PCI AHB-PCI MEM-mapping
+ * 0x98000000 - 0x9FFFFFFF 128MB  PCI PCI-AHB MEM-mapping
  */
-/* PCI Configuration regs */
-#define PKUNITY_PCICFG_BASE             0x80000000 /* 0x80000000 - 0x8000000B 12B */
-/* PCI Bridge Base */
-#define PKUNITY_PCIBRI_BASE             0x80010000 /* 0x80010000 - 0x80010250 592B */
-/* PCI Legacy IO */
-#define PKUNITY_PCILIO_BASE             0x80030000 /* 0x80030000 - 0x8003FFFF 64KB */
-/* PCI AHB-PCI MEM-mapping */
-#define PKUNITY_PCIMEM_BASE             0x90000000 /* 0x90000000 - 0x97FFFFFF 128MB */
-/* PCI PCI-AHB MEM-mapping */
-#define PKUNITY_PCIAHB_BASE             0x98000000 /* 0x98000000 - 0x9FFFFFFF 128MB */
+#define PKUNITY_PCI_BASE		io_p2v(0x80000000) /* 0x80000000 - 0xBFFFFFFF 1GB */
+#include "regs-pci.h"
+
+#define PKUNITY_PCICFG_BASE		(PKUNITY_PCI_BASE + 0x0)
+#define PKUNITY_PCIBRI_BASE		(PKUNITY_PCI_BASE + 0x00010000)
+#define PKUNITY_PCILIO_BASE		(PKUNITY_PCI_BASE + 0x00030000)
+#define PKUNITY_PCIMEM_BASE		(PKUNITY_PCI_BASE + 0x10000000)
+#define PKUNITY_PCIAHB_BASE		(PKUNITY_PCI_BASE + 0x18000000)
 
 /*
  * PKUNITY System Bus Addresses (AHB): 0xC0000000 - 0xEDFFFFFF (640MB)
  */
+#define PKUNITY_AHB_BASE		io_p2v(0xC0000000)
+
 /* AHB-0 is DDR2 SDRAM */
 /* AHB-1 is PCI Space */
-#define PKUNITY_ARBITER_BASE		0xC0000000 /* AHB-2 */
-#define PKUNITY_DDR2CTRL_BASE		0xC0100000 /* AHB-3 */
-#define PKUNITY_DMAC_BASE		0xC0200000 /* AHB-4 */
+#define PKUNITY_ARBITER_BASE		(PKUNITY_AHB_BASE + 0x000000) /* AHB-2 */
+#define PKUNITY_DDR2CTRL_BASE		(PKUNITY_AHB_BASE + 0x100000) /* AHB-3 */
+#define PKUNITY_DMAC_BASE		(PKUNITY_AHB_BASE + 0x200000) /* AHB-4 */
 #include "regs-dmac.h"
-#define PKUNITY_UMAL_BASE		0xC0300000 /* AHB-5 */
+#define PKUNITY_UMAL_BASE		(PKUNITY_AHB_BASE + 0x300000) /* AHB-5 */
 #include "regs-umal.h"
-#define PKUNITY_USB_BASE		0xC0400000 /* AHB-6 */
-#define PKUNITY_SATA_BASE		0xC0500000 /* AHB-7 */
-#define PKUNITY_SMC_BASE		0xC0600000 /* AHB-8 */
+#define PKUNITY_USB_BASE		(PKUNITY_AHB_BASE + 0x400000) /* AHB-6 */
+#define PKUNITY_SATA_BASE		(PKUNITY_AHB_BASE + 0x500000) /* AHB-7 */
+#define PKUNITY_SMC_BASE		(PKUNITY_AHB_BASE + 0x600000) /* AHB-8 */
 /* AHB-9 is for APB bridge */
-#define PKUNITY_MME_BASE		0xC0700000 /* AHB-10 */
-#define PKUNITY_UNIGFX_BASE		0xC0800000 /* AHB-11 */
+#define PKUNITY_MME_BASE		(PKUNITY_AHB_BASE + 0x700000) /* AHB-10 */
+#define PKUNITY_UNIGFX_BASE		(PKUNITY_AHB_BASE + 0x800000) /* AHB-11 */
 #include "regs-unigfx.h"
-#define PKUNITY_NAND_BASE		0xC0900000 /* AHB-12 */
+#define PKUNITY_NAND_BASE		(PKUNITY_AHB_BASE + 0x900000) /* AHB-12 */
 #include "regs-nand.h"
-#define PKUNITY_H264D_BASE		0xC0A00000 /* AHB-13 */
-#define PKUNITY_H264E_BASE		0xC0B00000 /* AHB-14 */
+#define PKUNITY_H264D_BASE		(PKUNITY_AHB_BASE + 0xA00000) /* AHB-13 */
+#define PKUNITY_H264E_BASE		(PKUNITY_AHB_BASE + 0xB00000) /* AHB-14 */
 
 /*
  * PKUNITY Peripheral Bus Addresses (APB): 0xEE000000 - 0xEFFFFFFF (128MB)
  */
-#define PKUNITY_UART0_BASE		0xEE000000 /* APB-0 */
-#define PKUNITY_UART1_BASE		0xEE100000 /* APB-1 */
+#define PKUNITY_APB_BASE		io_p2v(0xEE000000)
+
+#define PKUNITY_UART0_BASE		(PKUNITY_APB_BASE + 0x000000) /* APB-0 */
+#define PKUNITY_UART1_BASE		(PKUNITY_APB_BASE + 0x100000) /* APB-1 */
 #include "regs-uart.h"
-#define PKUNITY_I2C_BASE		0xEE200000 /* APB-2 */
+#define PKUNITY_I2C_BASE		(PKUNITY_APB_BASE + 0x200000) /* APB-2 */
 #include "regs-i2c.h"
-#define PKUNITY_SPI_BASE		0xEE300000 /* APB-3 */
+#define PKUNITY_SPI_BASE		(PKUNITY_APB_BASE + 0x300000) /* APB-3 */
 #include "regs-spi.h"
-#define PKUNITY_AC97_BASE		0xEE400000 /* APB-4 */
+#define PKUNITY_AC97_BASE		(PKUNITY_APB_BASE + 0x400000) /* APB-4 */
 #include "regs-ac97.h"
-#define PKUNITY_GPIO_BASE		0xEE500000 /* APB-5 */
+#define PKUNITY_GPIO_BASE		(PKUNITY_APB_BASE + 0x500000) /* APB-5 */
 #include "regs-gpio.h"
-#define PKUNITY_INTC_BASE		0xEE600000 /* APB-6 */
+#define PKUNITY_INTC_BASE		(PKUNITY_APB_BASE + 0x600000) /* APB-6 */
 #include "regs-intc.h"
-#define PKUNITY_RTC_BASE		0xEE700000 /* APB-7 */
+#define PKUNITY_RTC_BASE		(PKUNITY_APB_BASE + 0x700000) /* APB-7 */
 #include "regs-rtc.h"
-#define PKUNITY_OST_BASE		0xEE800000 /* APB-8 */
+#define PKUNITY_OST_BASE		(PKUNITY_APB_BASE + 0x800000) /* APB-8 */
 #include "regs-ost.h"
-#define PKUNITY_RESETC_BASE		0xEE900000 /* APB-9 */
+#define PKUNITY_RESETC_BASE		(PKUNITY_APB_BASE + 0x900000) /* APB-9 */
 #include "regs-resetc.h"
-#define PKUNITY_PM_BASE			0xEEA00000 /* APB-10 */
+#define PKUNITY_PM_BASE			(PKUNITY_APB_BASE + 0xA00000) /* APB-10 */
 #include "regs-pm.h"
-#define PKUNITY_PS2_BASE		0xEEB00000 /* APB-11 */
+#define PKUNITY_PS2_BASE		(PKUNITY_APB_BASE + 0xB00000) /* APB-11 */
 #include "regs-ps2.h"
-#define PKUNITY_SDC_BASE		0xEEC00000 /* APB-12 */
+#define PKUNITY_SDC_BASE		(PKUNITY_APB_BASE + 0xC00000) /* APB-12 */
 #include "regs-sdc.h"
 
diff --git a/arch/unicore32/include/mach/hardware.h b/arch/unicore32/include/mach/hardware.h
index b71405a..930bea6 100644
--- a/arch/unicore32/include/mach/hardware.h
+++ b/arch/unicore32/include/mach/hardware.h
@@ -17,17 +17,16 @@
 
 #include "PKUnity.h"
 
+#ifndef __ASSEMBLY__
+#define io_p2v(x)	(void __iomem *)((x) - PKUNITY_MMIO_BASE)
+#define io_v2p(x)	(phys_addr_t)((x) + PKUNITY_MMIO_BASE)
+#else
 #define io_p2v(x)	((x) - PKUNITY_MMIO_BASE)
 #define io_v2p(x)	((x) + PKUNITY_MMIO_BASE)
-
-#ifndef __ASSEMBLY__
-
-# define __REG(x)	(void __iomem *)io_p2v(x)
-
 #endif
 
 #define PCIBIOS_MIN_IO			0x4000 /* should lower than 64KB */
-#define PCIBIOS_MIN_MEM			PKUNITY_PCIMEM_BASE
+#define PCIBIOS_MIN_MEM			io_v2p(PKUNITY_PCIMEM_BASE)
 
 /*
  * We override the standard dma-mask routines for bouncing.
diff --git a/arch/unicore32/include/mach/memory.h b/arch/unicore32/include/mach/memory.h
index b774eff..0bf21c9 100644
--- a/arch/unicore32/include/mach/memory.h
+++ b/arch/unicore32/include/mach/memory.h
@@ -45,8 +45,8 @@ void puv3_pci_adjust_zones(unsigned long *size, unsigned long *holes);
 #define is_pcibus_device(dev)	(dev &&			\
 				(strncmp(dev->bus->name, "pci", 3) == 0))
 
-#define __virt_to_pcibus(x)     (__virt_to_phys(x) + PKUNITY_PCIAHB_BASE)
-#define __pcibus_to_virt(x)     __phys_to_virt((x) - PKUNITY_PCIAHB_BASE)
+#define __virt_to_pcibus(x)     (__virt_to_phys((x) + PKUNITY_PCIAHB_BASE))
+#define __pcibus_to_virt(x)     (__phys_to_virt(x) - PKUNITY_PCIAHB_BASE)
 
 /* kuser area */
 #define KUSER_VECPAGE_BASE	(KUSER_BASE + UL(0x3fff0000))
diff --git a/arch/unicore32/include/mach/regs-ac97.h b/arch/unicore32/include/mach/regs-ac97.h
index ce299bf..b7563e9 100644
--- a/arch/unicore32/include/mach/regs-ac97.h
+++ b/arch/unicore32/include/mach/regs-ac97.h
@@ -2,16 +2,16 @@
  * PKUnity AC97 Registers
  */
 
-#define PKUNITY_AC97_CONR		__REG(PKUNITY_AC97_BASE + 0x0000)
-#define PKUNITY_AC97_OCR		__REG(PKUNITY_AC97_BASE + 0x0004)
-#define PKUNITY_AC97_ICR		__REG(PKUNITY_AC97_BASE + 0x0008)
-#define PKUNITY_AC97_CRAC		__REG(PKUNITY_AC97_BASE + 0x000C)
-#define PKUNITY_AC97_INTR		__REG(PKUNITY_AC97_BASE + 0x0010)
-#define PKUNITY_AC97_INTRSTAT		__REG(PKUNITY_AC97_BASE + 0x0014)
-#define PKUNITY_AC97_INTRCLEAR		__REG(PKUNITY_AC97_BASE + 0x0018)
-#define PKUNITY_AC97_ENABLE		__REG(PKUNITY_AC97_BASE + 0x001C)
-#define PKUNITY_AC97_OUT_FIFO		__REG(PKUNITY_AC97_BASE + 0x0020)
-#define PKUNITY_AC97_IN_FIFO		__REG(PKUNITY_AC97_BASE + 0x0030)
+#define PKUNITY_AC97_CONR		(PKUNITY_AC97_BASE + 0x0000)
+#define PKUNITY_AC97_OCR		(PKUNITY_AC97_BASE + 0x0004)
+#define PKUNITY_AC97_ICR		(PKUNITY_AC97_BASE + 0x0008)
+#define PKUNITY_AC97_CRAC		(PKUNITY_AC97_BASE + 0x000C)
+#define PKUNITY_AC97_INTR		(PKUNITY_AC97_BASE + 0x0010)
+#define PKUNITY_AC97_INTRSTAT		(PKUNITY_AC97_BASE + 0x0014)
+#define PKUNITY_AC97_INTRCLEAR		(PKUNITY_AC97_BASE + 0x0018)
+#define PKUNITY_AC97_ENABLE		(PKUNITY_AC97_BASE + 0x001C)
+#define PKUNITY_AC97_OUT_FIFO		(PKUNITY_AC97_BASE + 0x0020)
+#define PKUNITY_AC97_IN_FIFO		(PKUNITY_AC97_BASE + 0x0030)
 
 #define AC97_CODEC_REG(v)               FIELD((v), 7, 16)
 #define AC97_CODEC_VAL(v)               FIELD((v), 16, 0)
diff --git a/arch/unicore32/include/mach/regs-dmac.h b/arch/unicore32/include/mach/regs-dmac.h
index 09fce9d..66de9e7 100644
--- a/arch/unicore32/include/mach/regs-dmac.h
+++ b/arch/unicore32/include/mach/regs-dmac.h
@@ -5,27 +5,27 @@
 /*
  * Interrupt Status Reg DMAC_ISR.
  */
-#define DMAC_ISR		__REG(PKUNITY_DMAC_BASE + 0x0020)
+#define DMAC_ISR		(PKUNITY_DMAC_BASE + 0x0020)
 /*
  * Interrupt Transfer Complete Status Reg DMAC_ITCSR.
  */
-#define DMAC_ITCSR		__REG(PKUNITY_DMAC_BASE + 0x0050)
+#define DMAC_ITCSR		(PKUNITY_DMAC_BASE + 0x0050)
 /*
  * Interrupt Transfer Complete Clear Reg DMAC_ITCCR.
  */
-#define DMAC_ITCCR		__REG(PKUNITY_DMAC_BASE + 0x0060)
+#define DMAC_ITCCR		(PKUNITY_DMAC_BASE + 0x0060)
 /*
  * Interrupt Error Status Reg DMAC_IESR.
  */
-#define DMAC_IESR		__REG(PKUNITY_DMAC_BASE + 0x0080)
+#define DMAC_IESR		(PKUNITY_DMAC_BASE + 0x0080)
 /*
  * Interrupt Error Clear Reg DMAC_IECR.
  */
-#define DMAC_IECR		__REG(PKUNITY_DMAC_BASE + 0x0090)
+#define DMAC_IECR		(PKUNITY_DMAC_BASE + 0x0090)
 /*
  * Enable Channels Reg DMAC_ENCH.
  */
-#define DMAC_ENCH		__REG(PKUNITY_DMAC_BASE + 0x00B0)
+#define DMAC_ENCH		(PKUNITY_DMAC_BASE + 0x00B0)
 
 /*
  * DMA control reg. Space [byte]
@@ -35,19 +35,19 @@
 /*
  * Source Addr DMAC_SRCADDR(ch).
  */
-#define DMAC_SRCADDR(ch)	__REG(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x00)
+#define DMAC_SRCADDR(ch)	(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x00)
 /*
  * Destination Addr DMAC_DESTADDR(ch).
  */
-#define DMAC_DESTADDR(ch)	__REG(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x04)
+#define DMAC_DESTADDR(ch)	(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x04)
 /*
  * Control Reg DMAC_CONTROL(ch).
  */
-#define DMAC_CONTROL(ch)	__REG(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x0C)
+#define DMAC_CONTROL(ch)	(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x0C)
 /*
  * Configuration Reg DMAC_CONFIG(ch).
  */
-#define DMAC_CONFIG(ch)		__REG(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x10)
+#define DMAC_CONFIG(ch)		(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x10)
 
 #define DMAC_IR_MASK            FMASK(6, 0)
 /*
diff --git a/arch/unicore32/include/mach/regs-gpio.h b/arch/unicore32/include/mach/regs-gpio.h
index 5dd99d4..0273b86 100644
--- a/arch/unicore32/include/mach/regs-gpio.h
+++ b/arch/unicore32/include/mach/regs-gpio.h
@@ -5,35 +5,35 @@
 /*
  * Voltage Status Reg GPIO_GPLR.
  */
-#define GPIO_GPLR	__REG(PKUNITY_GPIO_BASE + 0x0000)
+#define GPIO_GPLR	(PKUNITY_GPIO_BASE + 0x0000)
 /*
  * Pin Direction Reg GPIO_GPDR.
  */
-#define GPIO_GPDR	__REG(PKUNITY_GPIO_BASE + 0x0004)
+#define GPIO_GPDR	(PKUNITY_GPIO_BASE + 0x0004)
 /*
  * Output Pin Set Reg GPIO_GPSR.
  */
-#define GPIO_GPSR	__REG(PKUNITY_GPIO_BASE + 0x0008)
+#define GPIO_GPSR	(PKUNITY_GPIO_BASE + 0x0008)
 /*
  * Output Pin Clear Reg GPIO_GPCR.
  */
-#define GPIO_GPCR	__REG(PKUNITY_GPIO_BASE + 0x000C)
+#define GPIO_GPCR	(PKUNITY_GPIO_BASE + 0x000C)
 /*
  * Raise Edge Detect Reg GPIO_GRER.
  */
-#define GPIO_GRER	__REG(PKUNITY_GPIO_BASE + 0x0010)
+#define GPIO_GRER	(PKUNITY_GPIO_BASE + 0x0010)
 /*
  * Fall Edge Detect Reg GPIO_GFER.
  */
-#define GPIO_GFER	__REG(PKUNITY_GPIO_BASE + 0x0014)
+#define GPIO_GFER	(PKUNITY_GPIO_BASE + 0x0014)
 /*
  * Edge Status Reg GPIO_GEDR.
  */
-#define GPIO_GEDR	__REG(PKUNITY_GPIO_BASE + 0x0018)
+#define GPIO_GEDR	(PKUNITY_GPIO_BASE + 0x0018)
 /*
  * Sepcial Voltage Detect Reg GPIO_GPIR.
  */
-#define GPIO_GPIR	__REG(PKUNITY_GPIO_BASE + 0x0020)
+#define GPIO_GPIR	(PKUNITY_GPIO_BASE + 0x0020)
 
 #define GPIO_MIN	(0)
 #define GPIO_MAX	(27)
diff --git a/arch/unicore32/include/mach/regs-i2c.h b/arch/unicore32/include/mach/regs-i2c.h
index 70b704f..463d108 100644
--- a/arch/unicore32/include/mach/regs-i2c.h
+++ b/arch/unicore32/include/mach/regs-i2c.h
@@ -5,35 +5,35 @@
 /*
  * Control Reg I2C_CON.
  */
-#define I2C_CON		__REG(PKUNITY_I2C_BASE + 0x0000)
+#define I2C_CON		(PKUNITY_I2C_BASE + 0x0000)
 /*
  * Target Address Reg I2C_TAR.
  */
-#define I2C_TAR		__REG(PKUNITY_I2C_BASE + 0x0004)
+#define I2C_TAR		(PKUNITY_I2C_BASE + 0x0004)
 /*
  * Data buffer and command Reg I2C_DATACMD.
  */
-#define I2C_DATACMD	__REG(PKUNITY_I2C_BASE + 0x0010)
+#define I2C_DATACMD	(PKUNITY_I2C_BASE + 0x0010)
 /*
  * Enable Reg I2C_ENABLE.
  */
-#define I2C_ENABLE	__REG(PKUNITY_I2C_BASE + 0x006C)
+#define I2C_ENABLE	(PKUNITY_I2C_BASE + 0x006C)
 /*
  * Status Reg I2C_STATUS.
  */
-#define I2C_STATUS	__REG(PKUNITY_I2C_BASE + 0x0070)
+#define I2C_STATUS	(PKUNITY_I2C_BASE + 0x0070)
 /*
  * Tx FIFO Length Reg I2C_TXFLR.
  */
-#define I2C_TXFLR	__REG(PKUNITY_I2C_BASE + 0x0074)
+#define I2C_TXFLR	(PKUNITY_I2C_BASE + 0x0074)
 /*
  * Rx FIFO Length Reg I2C_RXFLR.
  */
-#define I2C_RXFLR	__REG(PKUNITY_I2C_BASE + 0x0078)
+#define I2C_RXFLR	(PKUNITY_I2C_BASE + 0x0078)
 /*
  * Enable Status Reg I2C_ENSTATUS.
  */
-#define I2C_ENSTATUS	__REG(PKUNITY_I2C_BASE + 0x009C)
+#define I2C_ENSTATUS	(PKUNITY_I2C_BASE + 0x009C)
 
 #define I2C_CON_MASTER          FIELD(1, 1, 0)
 #define I2C_CON_SPEED_STD       FIELD(1, 2, 1)
diff --git a/arch/unicore32/include/mach/regs-intc.h b/arch/unicore32/include/mach/regs-intc.h
index 409ae47..25648f8 100644
--- a/arch/unicore32/include/mach/regs-intc.h
+++ b/arch/unicore32/include/mach/regs-intc.h
@@ -4,25 +4,25 @@
 /*
  * INTC Level Reg INTC_ICLR.
  */
-#define INTC_ICLR	__REG(PKUNITY_INTC_BASE + 0x0000)
+#define INTC_ICLR	(PKUNITY_INTC_BASE + 0x0000)
 /*
  * INTC Mask Reg INTC_ICMR.
  */
-#define INTC_ICMR	__REG(PKUNITY_INTC_BASE + 0x0004)
+#define INTC_ICMR	(PKUNITY_INTC_BASE + 0x0004)
 /*
  * INTC Pending Reg INTC_ICPR.
  */
-#define INTC_ICPR	__REG(PKUNITY_INTC_BASE + 0x0008)
+#define INTC_ICPR	(PKUNITY_INTC_BASE + 0x0008)
 /*
  * INTC IRQ Pending Reg INTC_ICIP.
  */
-#define INTC_ICIP	__REG(PKUNITY_INTC_BASE + 0x000C)
+#define INTC_ICIP	(PKUNITY_INTC_BASE + 0x000C)
 /*
  * INTC REAL Pending Reg INTC_ICFP.
  */
-#define INTC_ICFP	__REG(PKUNITY_INTC_BASE + 0x0010)
+#define INTC_ICFP	(PKUNITY_INTC_BASE + 0x0010)
 /*
  * INTC Control Reg INTC_ICCR.
  */
-#define INTC_ICCR	__REG(PKUNITY_INTC_BASE + 0x0014)
+#define INTC_ICCR	(PKUNITY_INTC_BASE + 0x0014)
 
diff --git a/arch/unicore32/include/mach/regs-nand.h b/arch/unicore32/include/mach/regs-nand.h
index 0c33fe8..a7c5563 100644
--- a/arch/unicore32/include/mach/regs-nand.h
+++ b/arch/unicore32/include/mach/regs-nand.h
@@ -4,67 +4,67 @@
 /*
  * ID Reg. 0 NAND_IDR0
  */
-#define NAND_IDR0	__REG(PKUNITY_NAND_BASE + 0x0000)
+#define NAND_IDR0	(PKUNITY_NAND_BASE + 0x0000)
 /*
  * ID Reg. 1 NAND_IDR1
  */
-#define NAND_IDR1	__REG(PKUNITY_NAND_BASE + 0x0004)
+#define NAND_IDR1	(PKUNITY_NAND_BASE + 0x0004)
 /*
  * ID Reg. 2 NAND_IDR2
  */
-#define NAND_IDR2	__REG(PKUNITY_NAND_BASE + 0x0008)
+#define NAND_IDR2	(PKUNITY_NAND_BASE + 0x0008)
 /*
  * ID Reg. 3 NAND_IDR3
  */
-#define NAND_IDR3	__REG(PKUNITY_NAND_BASE + 0x000C)
+#define NAND_IDR3	(PKUNITY_NAND_BASE + 0x000C)
 /*
  * Page Address Reg 0 NAND_PAR0
  */
-#define NAND_PAR0	__REG(PKUNITY_NAND_BASE + 0x0010)
+#define NAND_PAR0	(PKUNITY_NAND_BASE + 0x0010)
 /*
  * Page Address Reg 1 NAND_PAR1
  */
-#define NAND_PAR1	__REG(PKUNITY_NAND_BASE + 0x0014)
+#define NAND_PAR1	(PKUNITY_NAND_BASE + 0x0014)
 /*
  * Page Address Reg 2 NAND_PAR2
  */
-#define NAND_PAR2	__REG(PKUNITY_NAND_BASE + 0x0018)
+#define NAND_PAR2	(PKUNITY_NAND_BASE + 0x0018)
 /*
  * ECC Enable Reg NAND_ECCEN
  */
-#define NAND_ECCEN	__REG(PKUNITY_NAND_BASE + 0x001C)
+#define NAND_ECCEN	(PKUNITY_NAND_BASE + 0x001C)
 /*
  * Buffer Reg NAND_BUF
  */
-#define NAND_BUF	__REG(PKUNITY_NAND_BASE + 0x0020)
+#define NAND_BUF	(PKUNITY_NAND_BASE + 0x0020)
 /*
  * ECC Status Reg NAND_ECCSR
  */
-#define NAND_ECCSR	__REG(PKUNITY_NAND_BASE + 0x0024)
+#define NAND_ECCSR	(PKUNITY_NAND_BASE + 0x0024)
 /*
  * Command Reg NAND_CMD
  */
-#define NAND_CMD	__REG(PKUNITY_NAND_BASE + 0x0028)
+#define NAND_CMD	(PKUNITY_NAND_BASE + 0x0028)
 /*
  * DMA Configure Reg NAND_DMACR
  */
-#define NAND_DMACR	__REG(PKUNITY_NAND_BASE + 0x002C)
+#define NAND_DMACR	(PKUNITY_NAND_BASE + 0x002C)
 /*
  * Interrupt Reg NAND_IR
  */
-#define NAND_IR		__REG(PKUNITY_NAND_BASE + 0x0030)
+#define NAND_IR		(PKUNITY_NAND_BASE + 0x0030)
 /*
  * Interrupt Mask Reg NAND_IMR
  */
-#define NAND_IMR	__REG(PKUNITY_NAND_BASE + 0x0034)
+#define NAND_IMR	(PKUNITY_NAND_BASE + 0x0034)
 /*
  * Chip Enable Reg NAND_CHIPEN
  */
-#define NAND_CHIPEN	__REG(PKUNITY_NAND_BASE + 0x0038)
+#define NAND_CHIPEN	(PKUNITY_NAND_BASE + 0x0038)
 /*
  * Address Reg NAND_ADDR
  */
-#define NAND_ADDR	__REG(PKUNITY_NAND_BASE + 0x003C)
+#define NAND_ADDR	(PKUNITY_NAND_BASE + 0x003C)
 
 /*
  * Command bits NAND_CMD_CMD_MASK
diff --git a/arch/unicore32/include/mach/regs-ost.h b/arch/unicore32/include/mach/regs-ost.h
index 33049a8..7b91fe6 100644
--- a/arch/unicore32/include/mach/regs-ost.h
+++ b/arch/unicore32/include/mach/regs-ost.h
@@ -4,47 +4,47 @@
 /*
  * Match Reg 0 OST_OSMR0
  */
-#define OST_OSMR0	__REG(PKUNITY_OST_BASE + 0x0000)
+#define OST_OSMR0	(PKUNITY_OST_BASE + 0x0000)
 /*
  * Match Reg 1 OST_OSMR1
  */
-#define OST_OSMR1	__REG(PKUNITY_OST_BASE + 0x0004)
+#define OST_OSMR1	(PKUNITY_OST_BASE + 0x0004)
 /*
  * Match Reg 2 OST_OSMR2
  */
-#define OST_OSMR2	__REG(PKUNITY_OST_BASE + 0x0008)
+#define OST_OSMR2	(PKUNITY_OST_BASE + 0x0008)
 /*
  * Match Reg 3 OST_OSMR3
  */
-#define OST_OSMR3	__REG(PKUNITY_OST_BASE + 0x000C)
+#define OST_OSMR3	(PKUNITY_OST_BASE + 0x000C)
 /*
  * Counter Reg OST_OSCR
  */
-#define OST_OSCR	__REG(PKUNITY_OST_BASE + 0x0010)
+#define OST_OSCR	(PKUNITY_OST_BASE + 0x0010)
 /*
  * Status Reg OST_OSSR
  */
-#define OST_OSSR	__REG(PKUNITY_OST_BASE + 0x0014)
+#define OST_OSSR	(PKUNITY_OST_BASE + 0x0014)
 /*
  * Watchdog Enable Reg OST_OWER
  */
-#define OST_OWER	__REG(PKUNITY_OST_BASE + 0x0018)
+#define OST_OWER	(PKUNITY_OST_BASE + 0x0018)
 /*
  * Interrupt Enable Reg OST_OIER
  */
-#define OST_OIER	__REG(PKUNITY_OST_BASE + 0x001C)
+#define OST_OIER	(PKUNITY_OST_BASE + 0x001C)
 /*
  * PWM Pulse Width Control Reg OST_PWMPWCR
  */
-#define OST_PWMPWCR	__REG(PKUNITY_OST_BASE + 0x0080)
+#define OST_PWMPWCR	(PKUNITY_OST_BASE + 0x0080)
 /*
  * PWM Duty Cycle Control Reg OST_PWMDCCR
  */
-#define OST_PWMDCCR	__REG(PKUNITY_OST_BASE + 0x0084)
+#define OST_PWMDCCR	(PKUNITY_OST_BASE + 0x0084)
 /*
  * PWM Period Control Reg OST_PWMPCR
  */
-#define OST_PWMPCR	__REG(PKUNITY_OST_BASE + 0x0088)
+#define OST_PWMPCR	(PKUNITY_OST_BASE + 0x0088)
 
 /*
  * Match detected 0 OST_OSSR_M0
diff --git a/arch/unicore32/include/mach/regs-pci.h b/arch/unicore32/include/mach/regs-pci.h
index e8e1f1a..6a93416 100644
--- a/arch/unicore32/include/mach/regs-pci.h
+++ b/arch/unicore32/include/mach/regs-pci.h
@@ -8,79 +8,79 @@
 /*
  * PCICFG Bridge Base Reg.
  */
-#define PCICFG_BRIBASE          __REG(PKUNITY_PCICFG_BASE + 0x0000)
+#define PCICFG_BRIBASE          (PKUNITY_PCICFG_BASE + 0x0000)
 /*
  * PCICFG Address Reg.
  */
-#define PCICFG_ADDR             __REG(PKUNITY_PCICFG_BASE + 0x0004)
+#define PCICFG_ADDR             (PKUNITY_PCICFG_BASE + 0x0004)
 /*
  * PCICFG Address Reg.
  */
-#define PCICFG_DATA             __REG(PKUNITY_PCICFG_BASE + 0x0008)
+#define PCICFG_DATA             (PKUNITY_PCICFG_BASE + 0x0008)
 
 /*
  * PCI Bridge configuration space
  */
-#define PCIBRI_ID		__REG(PKUNITY_PCIBRI_BASE + 0x0000)
-#define PCIBRI_CMD		__REG(PKUNITY_PCIBRI_BASE + 0x0004)
-#define PCIBRI_CLASS		__REG(PKUNITY_PCIBRI_BASE + 0x0008)
-#define PCIBRI_LTR		__REG(PKUNITY_PCIBRI_BASE + 0x000C)
-#define PCIBRI_BAR0		__REG(PKUNITY_PCIBRI_BASE + 0x0010)
-#define PCIBRI_BAR1		__REG(PKUNITY_PCIBRI_BASE + 0x0014)
-#define PCIBRI_BAR2		__REG(PKUNITY_PCIBRI_BASE + 0x0018)
-#define PCIBRI_BAR3		__REG(PKUNITY_PCIBRI_BASE + 0x001C)
-#define PCIBRI_BAR4		__REG(PKUNITY_PCIBRI_BASE + 0x0020)
-#define PCIBRI_BAR5		__REG(PKUNITY_PCIBRI_BASE + 0x0024)
+#define PCIBRI_ID		(PKUNITY_PCIBRI_BASE + 0x0000)
+#define PCIBRI_CMD		(PKUNITY_PCIBRI_BASE + 0x0004)
+#define PCIBRI_CLASS		(PKUNITY_PCIBRI_BASE + 0x0008)
+#define PCIBRI_LTR		(PKUNITY_PCIBRI_BASE + 0x000C)
+#define PCIBRI_BAR0		(PKUNITY_PCIBRI_BASE + 0x0010)
+#define PCIBRI_BAR1		(PKUNITY_PCIBRI_BASE + 0x0014)
+#define PCIBRI_BAR2		(PKUNITY_PCIBRI_BASE + 0x0018)
+#define PCIBRI_BAR3		(PKUNITY_PCIBRI_BASE + 0x001C)
+#define PCIBRI_BAR4		(PKUNITY_PCIBRI_BASE + 0x0020)
+#define PCIBRI_BAR5		(PKUNITY_PCIBRI_BASE + 0x0024)
 
-#define PCIBRI_PCICTL0		__REG(PKUNITY_PCIBRI_BASE + 0x0100)
-#define PCIBRI_PCIBAR0		__REG(PKUNITY_PCIBRI_BASE + 0x0104)
-#define PCIBRI_PCIAMR0		__REG(PKUNITY_PCIBRI_BASE + 0x0108)
-#define PCIBRI_PCITAR0		__REG(PKUNITY_PCIBRI_BASE + 0x010C)
-#define PCIBRI_PCICTL1		__REG(PKUNITY_PCIBRI_BASE + 0x0110)
-#define PCIBRI_PCIBAR1		__REG(PKUNITY_PCIBRI_BASE + 0x0114)
-#define PCIBRI_PCIAMR1		__REG(PKUNITY_PCIBRI_BASE + 0x0118)
-#define PCIBRI_PCITAR1		__REG(PKUNITY_PCIBRI_BASE + 0x011C)
-#define PCIBRI_PCICTL2		__REG(PKUNITY_PCIBRI_BASE + 0x0120)
-#define PCIBRI_PCIBAR2		__REG(PKUNITY_PCIBRI_BASE + 0x0124)
-#define PCIBRI_PCIAMR2		__REG(PKUNITY_PCIBRI_BASE + 0x0128)
-#define PCIBRI_PCITAR2		__REG(PKUNITY_PCIBRI_BASE + 0x012C)
-#define PCIBRI_PCICTL3		__REG(PKUNITY_PCIBRI_BASE + 0x0130)
-#define PCIBRI_PCIBAR3		__REG(PKUNITY_PCIBRI_BASE + 0x0134)
-#define PCIBRI_PCIAMR3		__REG(PKUNITY_PCIBRI_BASE + 0x0138)
-#define PCIBRI_PCITAR3		__REG(PKUNITY_PCIBRI_BASE + 0x013C)
-#define PCIBRI_PCICTL4		__REG(PKUNITY_PCIBRI_BASE + 0x0140)
-#define PCIBRI_PCIBAR4		__REG(PKUNITY_PCIBRI_BASE + 0x0144)
-#define PCIBRI_PCIAMR4		__REG(PKUNITY_PCIBRI_BASE + 0x0148)
-#define PCIBRI_PCITAR4		__REG(PKUNITY_PCIBRI_BASE + 0x014C)
-#define PCIBRI_PCICTL5		__REG(PKUNITY_PCIBRI_BASE + 0x0150)
-#define PCIBRI_PCIBAR5		__REG(PKUNITY_PCIBRI_BASE + 0x0154)
-#define PCIBRI_PCIAMR5		__REG(PKUNITY_PCIBRI_BASE + 0x0158)
-#define PCIBRI_PCITAR5		__REG(PKUNITY_PCIBRI_BASE + 0x015C)
+#define PCIBRI_PCICTL0		(PKUNITY_PCIBRI_BASE + 0x0100)
+#define PCIBRI_PCIBAR0		(PKUNITY_PCIBRI_BASE + 0x0104)
+#define PCIBRI_PCIAMR0		(PKUNITY_PCIBRI_BASE + 0x0108)
+#define PCIBRI_PCITAR0		(PKUNITY_PCIBRI_BASE + 0x010C)
+#define PCIBRI_PCICTL1		(PKUNITY_PCIBRI_BASE + 0x0110)
+#define PCIBRI_PCIBAR1		(PKUNITY_PCIBRI_BASE + 0x0114)
+#define PCIBRI_PCIAMR1		(PKUNITY_PCIBRI_BASE + 0x0118)
+#define PCIBRI_PCITAR1		(PKUNITY_PCIBRI_BASE + 0x011C)
+#define PCIBRI_PCICTL2		(PKUNITY_PCIBRI_BASE + 0x0120)
+#define PCIBRI_PCIBAR2		(PKUNITY_PCIBRI_BASE + 0x0124)
+#define PCIBRI_PCIAMR2		(PKUNITY_PCIBRI_BASE + 0x0128)
+#define PCIBRI_PCITAR2		(PKUNITY_PCIBRI_BASE + 0x012C)
+#define PCIBRI_PCICTL3		(PKUNITY_PCIBRI_BASE + 0x0130)
+#define PCIBRI_PCIBAR3		(PKUNITY_PCIBRI_BASE + 0x0134)
+#define PCIBRI_PCIAMR3		(PKUNITY_PCIBRI_BASE + 0x0138)
+#define PCIBRI_PCITAR3		(PKUNITY_PCIBRI_BASE + 0x013C)
+#define PCIBRI_PCICTL4		(PKUNITY_PCIBRI_BASE + 0x0140)
+#define PCIBRI_PCIBAR4		(PKUNITY_PCIBRI_BASE + 0x0144)
+#define PCIBRI_PCIAMR4		(PKUNITY_PCIBRI_BASE + 0x0148)
+#define PCIBRI_PCITAR4		(PKUNITY_PCIBRI_BASE + 0x014C)
+#define PCIBRI_PCICTL5		(PKUNITY_PCIBRI_BASE + 0x0150)
+#define PCIBRI_PCIBAR5		(PKUNITY_PCIBRI_BASE + 0x0154)
+#define PCIBRI_PCIAMR5		(PKUNITY_PCIBRI_BASE + 0x0158)
+#define PCIBRI_PCITAR5		(PKUNITY_PCIBRI_BASE + 0x015C)
 
-#define PCIBRI_AHBCTL0		__REG(PKUNITY_PCIBRI_BASE + 0x0180)
-#define PCIBRI_AHBBAR0		__REG(PKUNITY_PCIBRI_BASE + 0x0184)
-#define PCIBRI_AHBAMR0		__REG(PKUNITY_PCIBRI_BASE + 0x0188)
-#define PCIBRI_AHBTAR0		__REG(PKUNITY_PCIBRI_BASE + 0x018C)
-#define PCIBRI_AHBCTL1		__REG(PKUNITY_PCIBRI_BASE + 0x0190)
-#define PCIBRI_AHBBAR1		__REG(PKUNITY_PCIBRI_BASE + 0x0194)
-#define PCIBRI_AHBAMR1		__REG(PKUNITY_PCIBRI_BASE + 0x0198)
-#define PCIBRI_AHBTAR1		__REG(PKUNITY_PCIBRI_BASE + 0x019C)
-#define PCIBRI_AHBCTL2		__REG(PKUNITY_PCIBRI_BASE + 0x01A0)
-#define PCIBRI_AHBBAR2		__REG(PKUNITY_PCIBRI_BASE + 0x01A4)
-#define PCIBRI_AHBAMR2		__REG(PKUNITY_PCIBRI_BASE + 0x01A8)
-#define PCIBRI_AHBTAR2		__REG(PKUNITY_PCIBRI_BASE + 0x01AC)
-#define PCIBRI_AHBCTL3		__REG(PKUNITY_PCIBRI_BASE + 0x01B0)
-#define PCIBRI_AHBBAR3		__REG(PKUNITY_PCIBRI_BASE + 0x01B4)
-#define PCIBRI_AHBAMR3		__REG(PKUNITY_PCIBRI_BASE + 0x01B8)
-#define PCIBRI_AHBTAR3		__REG(PKUNITY_PCIBRI_BASE + 0x01BC)
-#define PCIBRI_AHBCTL4		__REG(PKUNITY_PCIBRI_BASE + 0x01C0)
-#define PCIBRI_AHBBAR4		__REG(PKUNITY_PCIBRI_BASE + 0x01C4)
-#define PCIBRI_AHBAMR4		__REG(PKUNITY_PCIBRI_BASE + 0x01C8)
-#define PCIBRI_AHBTAR4		__REG(PKUNITY_PCIBRI_BASE + 0x01CC)
-#define PCIBRI_AHBCTL5		__REG(PKUNITY_PCIBRI_BASE + 0x01D0)
-#define PCIBRI_AHBBAR5		__REG(PKUNITY_PCIBRI_BASE + 0x01D4)
-#define PCIBRI_AHBAMR5		__REG(PKUNITY_PCIBRI_BASE + 0x01D8)
-#define PCIBRI_AHBTAR5		__REG(PKUNITY_PCIBRI_BASE + 0x01DC)
+#define PCIBRI_AHBCTL0		(PKUNITY_PCIBRI_BASE + 0x0180)
+#define PCIBRI_AHBBAR0		(PKUNITY_PCIBRI_BASE + 0x0184)
+#define PCIBRI_AHBAMR0		(PKUNITY_PCIBRI_BASE + 0x0188)
+#define PCIBRI_AHBTAR0		(PKUNITY_PCIBRI_BASE + 0x018C)
+#define PCIBRI_AHBCTL1		(PKUNITY_PCIBRI_BASE + 0x0190)
+#define PCIBRI_AHBBAR1		(PKUNITY_PCIBRI_BASE + 0x0194)
+#define PCIBRI_AHBAMR1		(PKUNITY_PCIBRI_BASE + 0x0198)
+#define PCIBRI_AHBTAR1		(PKUNITY_PCIBRI_BASE + 0x019C)
+#define PCIBRI_AHBCTL2		(PKUNITY_PCIBRI_BASE + 0x01A0)
+#define PCIBRI_AHBBAR2		(PKUNITY_PCIBRI_BASE + 0x01A4)
+#define PCIBRI_AHBAMR2		(PKUNITY_PCIBRI_BASE + 0x01A8)
+#define PCIBRI_AHBTAR2		(PKUNITY_PCIBRI_BASE + 0x01AC)
+#define PCIBRI_AHBCTL3		(PKUNITY_PCIBRI_BASE + 0x01B0)
+#define PCIBRI_AHBBAR3		(PKUNITY_PCIBRI_BASE + 0x01B4)
+#define PCIBRI_AHBAMR3		(PKUNITY_PCIBRI_BASE + 0x01B8)
+#define PCIBRI_AHBTAR3		(PKUNITY_PCIBRI_BASE + 0x01BC)
+#define PCIBRI_AHBCTL4		(PKUNITY_PCIBRI_BASE + 0x01C0)
+#define PCIBRI_AHBBAR4		(PKUNITY_PCIBRI_BASE + 0x01C4)
+#define PCIBRI_AHBAMR4		(PKUNITY_PCIBRI_BASE + 0x01C8)
+#define PCIBRI_AHBTAR4		(PKUNITY_PCIBRI_BASE + 0x01CC)
+#define PCIBRI_AHBCTL5		(PKUNITY_PCIBRI_BASE + 0x01D0)
+#define PCIBRI_AHBBAR5		(PKUNITY_PCIBRI_BASE + 0x01D4)
+#define PCIBRI_AHBAMR5		(PKUNITY_PCIBRI_BASE + 0x01D8)
+#define PCIBRI_AHBTAR5		(PKUNITY_PCIBRI_BASE + 0x01DC)
 
 #define PCIBRI_CTLx_AT          FIELD(1, 1, 2)
 #define PCIBRI_CTLx_PREF        FIELD(1, 1, 1)
diff --git a/arch/unicore32/include/mach/regs-pm.h b/arch/unicore32/include/mach/regs-pm.h
index ed2d2fc..854844a 100644
--- a/arch/unicore32/include/mach/regs-pm.h
+++ b/arch/unicore32/include/mach/regs-pm.h
@@ -4,75 +4,75 @@
 /*
  * PM Control Reg PM_PMCR
  */
-#define PM_PMCR                 __REG(PKUNITY_PM_BASE + 0x0000)
+#define PM_PMCR                 (PKUNITY_PM_BASE + 0x0000)
 /*
  * PM General Conf. Reg PM_PGCR
  */
-#define PM_PGCR                 __REG(PKUNITY_PM_BASE + 0x0004)
+#define PM_PGCR                 (PKUNITY_PM_BASE + 0x0004)
 /*
  * PM PLL Conf. Reg PM_PPCR
  */
-#define PM_PPCR                 __REG(PKUNITY_PM_BASE + 0x0008)
+#define PM_PPCR                 (PKUNITY_PM_BASE + 0x0008)
 /*
  * PM Wakeup Enable Reg PM_PWER
  */
-#define PM_PWER                 __REG(PKUNITY_PM_BASE + 0x000C)
+#define PM_PWER                 (PKUNITY_PM_BASE + 0x000C)
 /*
  * PM GPIO Sleep Status Reg PM_PGSR
  */
-#define PM_PGSR                 __REG(PKUNITY_PM_BASE + 0x0010)
+#define PM_PGSR                 (PKUNITY_PM_BASE + 0x0010)
 /*
  * PM Clock Gate Reg PM_PCGR
  */
-#define PM_PCGR                 __REG(PKUNITY_PM_BASE + 0x0014)
+#define PM_PCGR                 (PKUNITY_PM_BASE + 0x0014)
 /*
  * PM SYS PLL Conf. Reg PM_PLLSYSCFG
  */
-#define PM_PLLSYSCFG            __REG(PKUNITY_PM_BASE + 0x0018)
+#define PM_PLLSYSCFG            (PKUNITY_PM_BASE + 0x0018)
 /*
  * PM DDR PLL Conf. Reg PM_PLLDDRCFG
  */
-#define PM_PLLDDRCFG            __REG(PKUNITY_PM_BASE + 0x001C)
+#define PM_PLLDDRCFG            (PKUNITY_PM_BASE + 0x001C)
 /*
  * PM VGA PLL Conf. Reg PM_PLLVGACFG
  */
-#define PM_PLLVGACFG            __REG(PKUNITY_PM_BASE + 0x0020)
+#define PM_PLLVGACFG            (PKUNITY_PM_BASE + 0x0020)
 /*
  * PM Div Conf. Reg PM_DIVCFG
  */
-#define PM_DIVCFG               __REG(PKUNITY_PM_BASE + 0x0024)
+#define PM_DIVCFG               (PKUNITY_PM_BASE + 0x0024)
 /*
  * PM SYS PLL Status Reg PM_PLLSYSSTATUS
  */
-#define PM_PLLSYSSTATUS         __REG(PKUNITY_PM_BASE + 0x0028)
+#define PM_PLLSYSSTATUS         (PKUNITY_PM_BASE + 0x0028)
 /*
  * PM DDR PLL Status Reg PM_PLLDDRSTATUS
  */
-#define PM_PLLDDRSTATUS         __REG(PKUNITY_PM_BASE + 0x002C)
+#define PM_PLLDDRSTATUS         (PKUNITY_PM_BASE + 0x002C)
 /*
  * PM VGA PLL Status Reg PM_PLLVGASTATUS
  */
-#define PM_PLLVGASTATUS         __REG(PKUNITY_PM_BASE + 0x0030)
+#define PM_PLLVGASTATUS         (PKUNITY_PM_BASE + 0x0030)
 /*
  * PM Div Status Reg PM_DIVSTATUS
  */
-#define PM_DIVSTATUS            __REG(PKUNITY_PM_BASE + 0x0034)
+#define PM_DIVSTATUS            (PKUNITY_PM_BASE + 0x0034)
 /*
  * PM Software Reset Reg PM_SWRESET
  */
-#define PM_SWRESET              __REG(PKUNITY_PM_BASE + 0x0038)
+#define PM_SWRESET              (PKUNITY_PM_BASE + 0x0038)
 /*
  * PM DDR2 PAD Start Reg PM_DDR2START
  */
-#define PM_DDR2START            __REG(PKUNITY_PM_BASE + 0x003C)
+#define PM_DDR2START            (PKUNITY_PM_BASE + 0x003C)
 /*
  * PM DDR2 PAD Status Reg PM_DDR2CAL0
  */
-#define PM_DDR2CAL0             __REG(PKUNITY_PM_BASE + 0x0040)
+#define PM_DDR2CAL0             (PKUNITY_PM_BASE + 0x0040)
 /*
  * PM PLL DFC Done Reg PM_PLLDFCDONE
  */
-#define PM_PLLDFCDONE           __REG(PKUNITY_PM_BASE + 0x0044)
+#define PM_PLLDFCDONE           (PKUNITY_PM_BASE + 0x0044)
 
 #define PM_PMCR_SFB             FIELD(1, 1, 0)
 #define PM_PMCR_IFB             FIELD(1, 1, 1)
diff --git a/arch/unicore32/include/mach/regs-ps2.h b/arch/unicore32/include/mach/regs-ps2.h
index 7da2071..17d4e6d 100644
--- a/arch/unicore32/include/mach/regs-ps2.h
+++ b/arch/unicore32/include/mach/regs-ps2.h
@@ -4,17 +4,17 @@
 /*
  * the same as I8042_DATA_REG PS2_DATA
  */
-#define PS2_DATA	__REG(PKUNITY_PS2_BASE + 0x0060)
+#define PS2_DATA	(PKUNITY_PS2_BASE + 0x0060)
 /*
  * the same as I8042_COMMAND_REG PS2_COMMAND
  */
-#define PS2_COMMAND	__REG(PKUNITY_PS2_BASE + 0x0064)
+#define PS2_COMMAND	(PKUNITY_PS2_BASE + 0x0064)
 /*
  * the same as I8042_STATUS_REG PS2_STATUS
  */
-#define PS2_STATUS	__REG(PKUNITY_PS2_BASE + 0x0064)
+#define PS2_STATUS	(PKUNITY_PS2_BASE + 0x0064)
 /*
  * counter reg PS2_CNT
  */
-#define PS2_CNT		__REG(PKUNITY_PS2_BASE + 0x0068)
+#define PS2_CNT		(PKUNITY_PS2_BASE + 0x0068)
 
diff --git a/arch/unicore32/include/mach/regs-resetc.h b/arch/unicore32/include/mach/regs-resetc.h
index 1763989..39900cf 100644
--- a/arch/unicore32/include/mach/regs-resetc.h
+++ b/arch/unicore32/include/mach/regs-resetc.h
@@ -4,11 +4,11 @@
 /*
  * Software Reset Register
  */
-#define RESETC_SWRR	__REG(PKUNITY_RESETC_BASE + 0x0000)
+#define RESETC_SWRR	(PKUNITY_RESETC_BASE + 0x0000)
 /*
  * Reset Status Register
  */
-#define RESETC_RSSR	__REG(PKUNITY_RESETC_BASE + 0x0004)
+#define RESETC_RSSR	(PKUNITY_RESETC_BASE + 0x0004)
 
 /*
  * Software Reset Bit
diff --git a/arch/unicore32/include/mach/regs-rtc.h b/arch/unicore32/include/mach/regs-rtc.h
index 155e387..e94ca19 100644
--- a/arch/unicore32/include/mach/regs-rtc.h
+++ b/arch/unicore32/include/mach/regs-rtc.h
@@ -4,19 +4,19 @@
 /*
  * RTC Alarm Reg RTC_RTAR
  */
-#define RTC_RTAR	__REG(PKUNITY_RTC_BASE + 0x0000)
+#define RTC_RTAR	(PKUNITY_RTC_BASE + 0x0000)
 /*
  * RTC Count Reg RTC_RCNR
  */
-#define RTC_RCNR	__REG(PKUNITY_RTC_BASE + 0x0004)
+#define RTC_RCNR	(PKUNITY_RTC_BASE + 0x0004)
 /*
  * RTC Trim Reg RTC_RTTR
  */
-#define RTC_RTTR	__REG(PKUNITY_RTC_BASE + 0x0008)
+#define RTC_RTTR	(PKUNITY_RTC_BASE + 0x0008)
 /*
  * RTC Status Reg RTC_RTSR
  */
-#define RTC_RTSR	__REG(PKUNITY_RTC_BASE + 0x0010)
+#define RTC_RTSR	(PKUNITY_RTC_BASE + 0x0010)
 
 /*
  * ALarm detected RTC_RTSR_AL
diff --git a/arch/unicore32/include/mach/regs-sdc.h b/arch/unicore32/include/mach/regs-sdc.h
index 3457b88..1303ecf 100644
--- a/arch/unicore32/include/mach/regs-sdc.h
+++ b/arch/unicore32/include/mach/regs-sdc.h
@@ -4,67 +4,67 @@
 /*
  * Clock Control Reg SDC_CCR
  */
-#define SDC_CCR		__REG(PKUNITY_SDC_BASE + 0x0000)
+#define SDC_CCR		(PKUNITY_SDC_BASE + 0x0000)
 /*
  * Software Reset Reg SDC_SRR
  */
-#define SDC_SRR		__REG(PKUNITY_SDC_BASE + 0x0004)
+#define SDC_SRR		(PKUNITY_SDC_BASE + 0x0004)
 /*
  * Argument Reg SDC_ARGUMENT
  */
-#define SDC_ARGUMENT	__REG(PKUNITY_SDC_BASE + 0x0008)
+#define SDC_ARGUMENT	(PKUNITY_SDC_BASE + 0x0008)
 /*
  * Command Reg SDC_COMMAND
  */
-#define SDC_COMMAND	__REG(PKUNITY_SDC_BASE + 0x000C)
+#define SDC_COMMAND	(PKUNITY_SDC_BASE + 0x000C)
 /*
  * Block Size Reg SDC_BLOCKSIZE
  */
-#define SDC_BLOCKSIZE	__REG(PKUNITY_SDC_BASE + 0x0010)
+#define SDC_BLOCKSIZE	(PKUNITY_SDC_BASE + 0x0010)
 /*
  * Block Cound Reg SDC_BLOCKCOUNT
  */
-#define SDC_BLOCKCOUNT	__REG(PKUNITY_SDC_BASE + 0x0014)
+#define SDC_BLOCKCOUNT	(PKUNITY_SDC_BASE + 0x0014)
 /*
  * Transfer Mode Reg SDC_TMR
  */
-#define SDC_TMR		__REG(PKUNITY_SDC_BASE + 0x0018)
+#define SDC_TMR		(PKUNITY_SDC_BASE + 0x0018)
 /*
  * Response Reg. 0 SDC_RES0
  */
-#define SDC_RES0	__REG(PKUNITY_SDC_BASE + 0x001C)
+#define SDC_RES0	(PKUNITY_SDC_BASE + 0x001C)
 /*
  * Response Reg. 1 SDC_RES1
  */
-#define SDC_RES1	__REG(PKUNITY_SDC_BASE + 0x0020)
+#define SDC_RES1	(PKUNITY_SDC_BASE + 0x0020)
 /*
  * Response Reg. 2 SDC_RES2
  */
-#define SDC_RES2	__REG(PKUNITY_SDC_BASE + 0x0024)
+#define SDC_RES2	(PKUNITY_SDC_BASE + 0x0024)
 /*
  * Response Reg. 3 SDC_RES3
  */
-#define SDC_RES3	__REG(PKUNITY_SDC_BASE + 0x0028)
+#define SDC_RES3	(PKUNITY_SDC_BASE + 0x0028)
 /*
  * Read Timeout Control Reg SDC_RTCR
  */
-#define SDC_RTCR	__REG(PKUNITY_SDC_BASE + 0x002C)
+#define SDC_RTCR	(PKUNITY_SDC_BASE + 0x002C)
 /*
  * Interrupt Status Reg SDC_ISR
  */
-#define SDC_ISR		__REG(PKUNITY_SDC_BASE + 0x0030)
+#define SDC_ISR		(PKUNITY_SDC_BASE + 0x0030)
 /*
  * Interrupt Status Mask Reg SDC_ISMR
  */
-#define SDC_ISMR	__REG(PKUNITY_SDC_BASE + 0x0034)
+#define SDC_ISMR	(PKUNITY_SDC_BASE + 0x0034)
 /*
  * RX FIFO SDC_RXFIFO
  */
-#define SDC_RXFIFO	__REG(PKUNITY_SDC_BASE + 0x0038)
+#define SDC_RXFIFO	(PKUNITY_SDC_BASE + 0x0038)
 /*
  * TX FIFO SDC_TXFIFO
  */
-#define SDC_TXFIFO	__REG(PKUNITY_SDC_BASE + 0x003C)
+#define SDC_TXFIFO	(PKUNITY_SDC_BASE + 0x003C)
 
 /*
  * SD Clock Enable SDC_CCR_CLKEN
diff --git a/arch/unicore32/include/mach/regs-spi.h b/arch/unicore32/include/mach/regs-spi.h
index cadc713..de16895 100644
--- a/arch/unicore32/include/mach/regs-spi.h
+++ b/arch/unicore32/include/mach/regs-spi.h
@@ -4,27 +4,27 @@
 /*
  * Control reg. 0 SPI_CR0
  */
-#define SPI_CR0		__REG(PKUNITY_SPI_BASE + 0x0000)
+#define SPI_CR0		(PKUNITY_SPI_BASE + 0x0000)
 /*
  * Control reg. 1 SPI_CR1
  */
-#define SPI_CR1		__REG(PKUNITY_SPI_BASE + 0x0004)
+#define SPI_CR1		(PKUNITY_SPI_BASE + 0x0004)
 /*
  * Enable reg SPI_SSIENR
  */
-#define SPI_SSIENR	__REG(PKUNITY_SPI_BASE + 0x0008)
+#define SPI_SSIENR	(PKUNITY_SPI_BASE + 0x0008)
 /*
  * Status reg SPI_SR
  */
-#define SPI_SR		__REG(PKUNITY_SPI_BASE + 0x0028)
+#define SPI_SR		(PKUNITY_SPI_BASE + 0x0028)
 /*
  * Interrupt Mask reg SPI_IMR
  */
-#define SPI_IMR		__REG(PKUNITY_SPI_BASE + 0x002C)
+#define SPI_IMR		(PKUNITY_SPI_BASE + 0x002C)
 /*
  * Interrupt Status reg SPI_ISR
  */
-#define SPI_ISR		__REG(PKUNITY_SPI_BASE + 0x0030)
+#define SPI_ISR		(PKUNITY_SPI_BASE + 0x0030)
 
 /*
  * Enable SPI Controller SPI_SSIENR_EN
diff --git a/arch/unicore32/include/mach/regs-umal.h b/arch/unicore32/include/mach/regs-umal.h
index 2e718d1..885bb62 100644
--- a/arch/unicore32/include/mach/regs-umal.h
+++ b/arch/unicore32/include/mach/regs-umal.h
@@ -10,86 +10,86 @@
 /*
  * TX/RX reset and control UMAL_CFG1
  */
-#define UMAL_CFG1		__REG(PKUNITY_UMAL_BASE + 0x0000)
+#define UMAL_CFG1		(PKUNITY_UMAL_BASE + 0x0000)
 /*
  * MAC interface mode control UMAL_CFG2
  */
-#define UMAL_CFG2		__REG(PKUNITY_UMAL_BASE + 0x0004)
+#define UMAL_CFG2		(PKUNITY_UMAL_BASE + 0x0004)
 /*
  * Inter Packet/Frame Gap UMAL_IPGIFG
  */
-#define UMAL_IPGIFG		__REG(PKUNITY_UMAL_BASE + 0x0008)
+#define UMAL_IPGIFG		(PKUNITY_UMAL_BASE + 0x0008)
 /*
  * Collision retry or backoff UMAL_HALFDUPLEX
  */
-#define UMAL_HALFDUPLEX		__REG(PKUNITY_UMAL_BASE + 0x000c)
+#define UMAL_HALFDUPLEX		(PKUNITY_UMAL_BASE + 0x000c)
 /*
  * Maximum Frame Length UMAL_MAXFRAME
  */
-#define UMAL_MAXFRAME		__REG(PKUNITY_UMAL_BASE + 0x0010)
+#define UMAL_MAXFRAME		(PKUNITY_UMAL_BASE + 0x0010)
 /*
  * Test Regsiter UMAL_TESTREG
  */
-#define UMAL_TESTREG		__REG(PKUNITY_UMAL_BASE + 0x001c)
+#define UMAL_TESTREG		(PKUNITY_UMAL_BASE + 0x001c)
 /*
  * MII Management Configure UMAL_MIICFG
  */
-#define UMAL_MIICFG		__REG(PKUNITY_UMAL_BASE + 0x0020)
+#define UMAL_MIICFG		(PKUNITY_UMAL_BASE + 0x0020)
 /*
  * MII Management Command UMAL_MIICMD
  */
-#define UMAL_MIICMD		__REG(PKUNITY_UMAL_BASE + 0x0024)
+#define UMAL_MIICMD		(PKUNITY_UMAL_BASE + 0x0024)
 /*
  * MII Management Address UMAL_MIIADDR
  */
-#define UMAL_MIIADDR		__REG(PKUNITY_UMAL_BASE + 0x0028)
+#define UMAL_MIIADDR		(PKUNITY_UMAL_BASE + 0x0028)
 /*
  * MII Management Control UMAL_MIICTRL
  */
-#define UMAL_MIICTRL		__REG(PKUNITY_UMAL_BASE + 0x002c)
+#define UMAL_MIICTRL		(PKUNITY_UMAL_BASE + 0x002c)
 /*
  * MII Management Status UMAL_MIISTATUS
  */
-#define UMAL_MIISTATUS		__REG(PKUNITY_UMAL_BASE + 0x0030)
+#define UMAL_MIISTATUS		(PKUNITY_UMAL_BASE + 0x0030)
 /*
  * MII Managment Indicator UMAL_MIIIDCT
  */
-#define UMAL_MIIIDCT		__REG(PKUNITY_UMAL_BASE + 0x0034)
+#define UMAL_MIIIDCT		(PKUNITY_UMAL_BASE + 0x0034)
 /*
  * Interface Control UMAL_IFCTRL
  */
-#define UMAL_IFCTRL		__REG(PKUNITY_UMAL_BASE + 0x0038)
+#define UMAL_IFCTRL		(PKUNITY_UMAL_BASE + 0x0038)
 /*
  * Interface Status UMAL_IFSTATUS
  */
-#define UMAL_IFSTATUS		__REG(PKUNITY_UMAL_BASE + 0x003c)
+#define UMAL_IFSTATUS		(PKUNITY_UMAL_BASE + 0x003c)
 /*
  * MAC address (high 4 bytes) UMAL_STADDR1
  */
-#define UMAL_STADDR1		__REG(PKUNITY_UMAL_BASE + 0x0040)
+#define UMAL_STADDR1		(PKUNITY_UMAL_BASE + 0x0040)
 /*
  * MAC address (low 2 bytes) UMAL_STADDR2
  */
-#define UMAL_STADDR2		__REG(PKUNITY_UMAL_BASE + 0x0044)
+#define UMAL_STADDR2		(PKUNITY_UMAL_BASE + 0x0044)
 
 /* FIFO MODULE OF UMAL */
 /* UMAL's FIFO module provides data queuing for increased system level
  * throughput
  */
-#define UMAL_FIFOCFG0		__REG(PKUNITY_UMAL_BASE + 0x0048)
-#define UMAL_FIFOCFG1		__REG(PKUNITY_UMAL_BASE + 0x004c)
-#define UMAL_FIFOCFG2		__REG(PKUNITY_UMAL_BASE + 0x0050)
-#define UMAL_FIFOCFG3		__REG(PKUNITY_UMAL_BASE + 0x0054)
-#define UMAL_FIFOCFG4		__REG(PKUNITY_UMAL_BASE + 0x0058)
-#define UMAL_FIFOCFG5		__REG(PKUNITY_UMAL_BASE + 0x005c)
-#define UMAL_FIFORAM0		__REG(PKUNITY_UMAL_BASE + 0x0060)
-#define UMAL_FIFORAM1		__REG(PKUNITY_UMAL_BASE + 0x0064)
-#define UMAL_FIFORAM2		__REG(PKUNITY_UMAL_BASE + 0x0068)
-#define UMAL_FIFORAM3		__REG(PKUNITY_UMAL_BASE + 0x006c)
-#define UMAL_FIFORAM4		__REG(PKUNITY_UMAL_BASE + 0x0070)
-#define UMAL_FIFORAM5		__REG(PKUNITY_UMAL_BASE + 0x0074)
-#define UMAL_FIFORAM6		__REG(PKUNITY_UMAL_BASE + 0x0078)
-#define UMAL_FIFORAM7		__REG(PKUNITY_UMAL_BASE + 0x007c)
+#define UMAL_FIFOCFG0		(PKUNITY_UMAL_BASE + 0x0048)
+#define UMAL_FIFOCFG1		(PKUNITY_UMAL_BASE + 0x004c)
+#define UMAL_FIFOCFG2		(PKUNITY_UMAL_BASE + 0x0050)
+#define UMAL_FIFOCFG3		(PKUNITY_UMAL_BASE + 0x0054)
+#define UMAL_FIFOCFG4		(PKUNITY_UMAL_BASE + 0x0058)
+#define UMAL_FIFOCFG5		(PKUNITY_UMAL_BASE + 0x005c)
+#define UMAL_FIFORAM0		(PKUNITY_UMAL_BASE + 0x0060)
+#define UMAL_FIFORAM1		(PKUNITY_UMAL_BASE + 0x0064)
+#define UMAL_FIFORAM2		(PKUNITY_UMAL_BASE + 0x0068)
+#define UMAL_FIFORAM3		(PKUNITY_UMAL_BASE + 0x006c)
+#define UMAL_FIFORAM4		(PKUNITY_UMAL_BASE + 0x0070)
+#define UMAL_FIFORAM5		(PKUNITY_UMAL_BASE + 0x0074)
+#define UMAL_FIFORAM6		(PKUNITY_UMAL_BASE + 0x0078)
+#define UMAL_FIFORAM7		(PKUNITY_UMAL_BASE + 0x007c)
 
 /* MAHBE MODUEL OF UMAL */
 /* UMAL's MAHBE module interfaces to the host system through 32-bit AHB Master
@@ -99,35 +99,35 @@
 /*
  * Transmit Control UMAL_DMATxCtrl
  */
-#define UMAL_DMATxCtrl		__REG(PKUNITY_UMAL_BASE + 0x0180)
+#define UMAL_DMATxCtrl		(PKUNITY_UMAL_BASE + 0x0180)
 /*
  * Pointer to TX Descripter UMAL_DMATxDescriptor
  */
-#define UMAL_DMATxDescriptor	__REG(PKUNITY_UMAL_BASE + 0x0184)
+#define UMAL_DMATxDescriptor	(PKUNITY_UMAL_BASE + 0x0184)
 /*
  * Status of Tx Packet Transfers UMAL_DMATxStatus
  */
-#define UMAL_DMATxStatus	__REG(PKUNITY_UMAL_BASE + 0x0188)
+#define UMAL_DMATxStatus	(PKUNITY_UMAL_BASE + 0x0188)
 /*
  * Receive Control UMAL_DMARxCtrl
  */
-#define UMAL_DMARxCtrl		__REG(PKUNITY_UMAL_BASE + 0x018c)
+#define UMAL_DMARxCtrl		(PKUNITY_UMAL_BASE + 0x018c)
 /*
  * Pointer to Rx Descriptor UMAL_DMARxDescriptor
  */
-#define UMAL_DMARxDescriptor	__REG(PKUNITY_UMAL_BASE + 0x0190)
+#define UMAL_DMARxDescriptor	(PKUNITY_UMAL_BASE + 0x0190)
 /*
  * Status of Rx Packet Transfers UMAL_DMARxStatus
  */
-#define UMAL_DMARxStatus	__REG(PKUNITY_UMAL_BASE + 0x0194)
+#define UMAL_DMARxStatus	(PKUNITY_UMAL_BASE + 0x0194)
 /*
  * Interrupt Mask UMAL_DMAIntrMask
  */
-#define UMAL_DMAIntrMask	__REG(PKUNITY_UMAL_BASE + 0x0198)
+#define UMAL_DMAIntrMask	(PKUNITY_UMAL_BASE + 0x0198)
 /*
  * Interrupts, read only UMAL_DMAInterrupt
  */
-#define UMAL_DMAInterrupt	__REG(PKUNITY_UMAL_BASE + 0x019c)
+#define UMAL_DMAInterrupt	(PKUNITY_UMAL_BASE + 0x019c)
 
 /*
  * Commands for UMAL_CFG1 register
diff --git a/arch/unicore32/include/mach/regs-unigfx.h b/arch/unicore32/include/mach/regs-unigfx.h
index 58bbd54..faf8b28 100644
--- a/arch/unicore32/include/mach/regs-unigfx.h
+++ b/arch/unicore32/include/mach/regs-unigfx.h
@@ -11,67 +11,67 @@
 /*
  * control reg UDE_CFG
  */
-#define UDE_CFG       __REG(UDE_BASE + 0x0000)
+#define UDE_CFG       (UDE_BASE + 0x0000)
 /*
  * framebuffer start address reg UDE_FSA
  */
-#define UDE_FSA       __REG(UDE_BASE + 0x0004)
+#define UDE_FSA       (UDE_BASE + 0x0004)
 /*
  * line size reg UDE_LS
  */
-#define UDE_LS        __REG(UDE_BASE + 0x0008)
+#define UDE_LS        (UDE_BASE + 0x0008)
 /*
  * pitch size reg UDE_PS
  */
-#define UDE_PS        __REG(UDE_BASE + 0x000C)
+#define UDE_PS        (UDE_BASE + 0x000C)
 /*
  * horizontal active time reg UDE_HAT
  */
-#define UDE_HAT       __REG(UDE_BASE + 0x0010)
+#define UDE_HAT       (UDE_BASE + 0x0010)
 /*
  * horizontal blank time reg UDE_HBT
  */
-#define UDE_HBT       __REG(UDE_BASE + 0x0014)
+#define UDE_HBT       (UDE_BASE + 0x0014)
 /*
  * horizontal sync time reg UDE_HST
  */
-#define UDE_HST       __REG(UDE_BASE + 0x0018)
+#define UDE_HST       (UDE_BASE + 0x0018)
 /*
  * vertival active time reg UDE_VAT
  */
-#define UDE_VAT       __REG(UDE_BASE + 0x001C)
+#define UDE_VAT       (UDE_BASE + 0x001C)
 /*
  * vertival blank time reg UDE_VBT
  */
-#define UDE_VBT       __REG(UDE_BASE + 0x0020)
+#define UDE_VBT       (UDE_BASE + 0x0020)
 /*
  * vertival sync time reg UDE_VST
  */
-#define UDE_VST       __REG(UDE_BASE + 0x0024)
+#define UDE_VST       (UDE_BASE + 0x0024)
 /*
  * cursor position UDE_CXY
  */
-#define UDE_CXY       __REG(UDE_BASE + 0x0028)
+#define UDE_CXY       (UDE_BASE + 0x0028)
 /*
  * cursor front color UDE_CC0
  */
-#define UDE_CC0       __REG(UDE_BASE + 0x002C)
+#define UDE_CC0       (UDE_BASE + 0x002C)
 /*
  * cursor background color UDE_CC1
  */
-#define UDE_CC1       __REG(UDE_BASE + 0x0030)
+#define UDE_CC1       (UDE_BASE + 0x0030)
 /*
  * video position UDE_VXY
  */
-#define UDE_VXY       __REG(UDE_BASE + 0x0034)
+#define UDE_VXY       (UDE_BASE + 0x0034)
 /*
  * video start address reg UDE_VSA
  */
-#define UDE_VSA       __REG(UDE_BASE + 0x0040)
+#define UDE_VSA       (UDE_BASE + 0x0040)
 /*
  * video size reg UDE_VS
  */
-#define UDE_VS        __REG(UDE_BASE + 0x004C)
+#define UDE_VS        (UDE_BASE + 0x004C)
 
 /*
  * command reg for UNIGFX GE
@@ -79,102 +79,102 @@
 /*
  * src xy reg UGE_SRCXY
  */
-#define UGE_SRCXY     __REG(UGE_BASE + 0x0000)
+#define UGE_SRCXY     (UGE_BASE + 0x0000)
 /*
  * dst xy reg UGE_DSTXY
  */
-#define UGE_DSTXY     __REG(UGE_BASE + 0x0004)
+#define UGE_DSTXY     (UGE_BASE + 0x0004)
 /*
  * pitch reg UGE_PITCH
  */
-#define UGE_PITCH     __REG(UGE_BASE + 0x0008)
+#define UGE_PITCH     (UGE_BASE + 0x0008)
 /*
  * src start reg UGE_SRCSTART
  */
-#define UGE_SRCSTART  __REG(UGE_BASE + 0x000C)
+#define UGE_SRCSTART  (UGE_BASE + 0x000C)
 /*
  * dst start reg UGE_DSTSTART
  */
-#define UGE_DSTSTART  __REG(UGE_BASE + 0x0010)
+#define UGE_DSTSTART  (UGE_BASE + 0x0010)
 /*
  * width height reg UGE_WIDHEIGHT
  */
-#define UGE_WIDHEIGHT __REG(UGE_BASE + 0x0014)
+#define UGE_WIDHEIGHT (UGE_BASE + 0x0014)
 /*
  * rop alpah reg UGE_ROPALPHA
  */
-#define UGE_ROPALPHA  __REG(UGE_BASE + 0x0018)
+#define UGE_ROPALPHA  (UGE_BASE + 0x0018)
 /*
  * front color UGE_FCOLOR
  */
-#define UGE_FCOLOR    __REG(UGE_BASE + 0x001C)
+#define UGE_FCOLOR    (UGE_BASE + 0x001C)
 /*
  * background color UGE_BCOLOR
  */
-#define UGE_BCOLOR    __REG(UGE_BASE + 0x0020)
+#define UGE_BCOLOR    (UGE_BASE + 0x0020)
 /*
  * src color key for high value UGE_SCH
  */
-#define UGE_SCH       __REG(UGE_BASE + 0x0024)
+#define UGE_SCH       (UGE_BASE + 0x0024)
 /*
  * dst color key for high value UGE_DCH
  */
-#define UGE_DCH       __REG(UGE_BASE + 0x0028)
+#define UGE_DCH       (UGE_BASE + 0x0028)
 /*
  * src color key for low value UGE_SCL
  */
-#define UGE_SCL       __REG(UGE_BASE + 0x002C)
+#define UGE_SCL       (UGE_BASE + 0x002C)
 /*
  * dst color key for low value UGE_DCL
  */
-#define UGE_DCL       __REG(UGE_BASE + 0x0030)
+#define UGE_DCL       (UGE_BASE + 0x0030)
 /*
  * clip 0 reg UGE_CLIP0
  */
-#define UGE_CLIP0     __REG(UGE_BASE + 0x0034)
+#define UGE_CLIP0     (UGE_BASE + 0x0034)
 /*
  * clip 1 reg UGE_CLIP1
  */
-#define UGE_CLIP1     __REG(UGE_BASE + 0x0038)
+#define UGE_CLIP1     (UGE_BASE + 0x0038)
 /*
  * command reg UGE_COMMAND
  */
-#define UGE_COMMAND   __REG(UGE_BASE + 0x003C)
+#define UGE_COMMAND   (UGE_BASE + 0x003C)
 /*
  * pattern 0 UGE_P0
  */
-#define UGE_P0        __REG(UGE_BASE + 0x0040)
-#define UGE_P1        __REG(UGE_BASE + 0x0044)
-#define UGE_P2        __REG(UGE_BASE + 0x0048)
-#define UGE_P3        __REG(UGE_BASE + 0x004C)
-#define UGE_P4        __REG(UGE_BASE + 0x0050)
-#define UGE_P5        __REG(UGE_BASE + 0x0054)
-#define UGE_P6        __REG(UGE_BASE + 0x0058)
-#define UGE_P7        __REG(UGE_BASE + 0x005C)
-#define UGE_P8        __REG(UGE_BASE + 0x0060)
-#define UGE_P9        __REG(UGE_BASE + 0x0064)
-#define UGE_P10       __REG(UGE_BASE + 0x0068)
-#define UGE_P11       __REG(UGE_BASE + 0x006C)
-#define UGE_P12       __REG(UGE_BASE + 0x0070)
-#define UGE_P13       __REG(UGE_BASE + 0x0074)
-#define UGE_P14       __REG(UGE_BASE + 0x0078)
-#define UGE_P15       __REG(UGE_BASE + 0x007C)
-#define UGE_P16       __REG(UGE_BASE + 0x0080)
-#define UGE_P17       __REG(UGE_BASE + 0x0084)
-#define UGE_P18       __REG(UGE_BASE + 0x0088)
-#define UGE_P19       __REG(UGE_BASE + 0x008C)
-#define UGE_P20       __REG(UGE_BASE + 0x0090)
-#define UGE_P21       __REG(UGE_BASE + 0x0094)
-#define UGE_P22       __REG(UGE_BASE + 0x0098)
-#define UGE_P23       __REG(UGE_BASE + 0x009C)
-#define UGE_P24       __REG(UGE_BASE + 0x00A0)
-#define UGE_P25       __REG(UGE_BASE + 0x00A4)
-#define UGE_P26       __REG(UGE_BASE + 0x00A8)
-#define UGE_P27       __REG(UGE_BASE + 0x00AC)
-#define UGE_P28       __REG(UGE_BASE + 0x00B0)
-#define UGE_P29       __REG(UGE_BASE + 0x00B4)
-#define UGE_P30       __REG(UGE_BASE + 0x00B8)
-#define UGE_P31       __REG(UGE_BASE + 0x00BC)
+#define UGE_P0        (UGE_BASE + 0x0040)
+#define UGE_P1        (UGE_BASE + 0x0044)
+#define UGE_P2        (UGE_BASE + 0x0048)
+#define UGE_P3        (UGE_BASE + 0x004C)
+#define UGE_P4        (UGE_BASE + 0x0050)
+#define UGE_P5        (UGE_BASE + 0x0054)
+#define UGE_P6        (UGE_BASE + 0x0058)
+#define UGE_P7        (UGE_BASE + 0x005C)
+#define UGE_P8        (UGE_BASE + 0x0060)
+#define UGE_P9        (UGE_BASE + 0x0064)
+#define UGE_P10       (UGE_BASE + 0x0068)
+#define UGE_P11       (UGE_BASE + 0x006C)
+#define UGE_P12       (UGE_BASE + 0x0070)
+#define UGE_P13       (UGE_BASE + 0x0074)
+#define UGE_P14       (UGE_BASE + 0x0078)
+#define UGE_P15       (UGE_BASE + 0x007C)
+#define UGE_P16       (UGE_BASE + 0x0080)
+#define UGE_P17       (UGE_BASE + 0x0084)
+#define UGE_P18       (UGE_BASE + 0x0088)
+#define UGE_P19       (UGE_BASE + 0x008C)
+#define UGE_P20       (UGE_BASE + 0x0090)
+#define UGE_P21       (UGE_BASE + 0x0094)
+#define UGE_P22       (UGE_BASE + 0x0098)
+#define UGE_P23       (UGE_BASE + 0x009C)
+#define UGE_P24       (UGE_BASE + 0x00A0)
+#define UGE_P25       (UGE_BASE + 0x00A4)
+#define UGE_P26       (UGE_BASE + 0x00A8)
+#define UGE_P27       (UGE_BASE + 0x00AC)
+#define UGE_P28       (UGE_BASE + 0x00B0)
+#define UGE_P29       (UGE_BASE + 0x00B4)
+#define UGE_P30       (UGE_BASE + 0x00B8)
+#define UGE_P31       (UGE_BASE + 0x00BC)
 
 #define UDE_CFG_DST_MASK	FMASK(2, 8)
 #define UDE_CFG_DST8            FIELD(0x0, 2, 8)
diff --git a/arch/unicore32/kernel/entry.S b/arch/unicore32/kernel/entry.S
index 83698b7..00a259f 100644
--- a/arch/unicore32/kernel/entry.S
+++ b/arch/unicore32/kernel/entry.S
@@ -91,7 +91,7 @@
 	.endm
 
 	.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
-	ldw	\base, =(io_p2v(PKUNITY_INTC_BASE))
+	ldw	\base, =(PKUNITY_INTC_BASE)
 	ldw	\irqstat, [\base+], #0xC	@ INTC_ICIP
 	ldw	\tmp,	  [\base+], #0x4	@ INTC_ICMR
 	and.a	\irqstat, \irqstat, \tmp
diff --git a/arch/unicore32/kernel/irq.c b/arch/unicore32/kernel/irq.c
index e1dbfcb..b23624c 100644
--- a/arch/unicore32/kernel/irq.c
+++ b/arch/unicore32/kernel/irq.c
@@ -226,8 +226,8 @@ static struct irq_chip puv3_normal_chip = {
 
 static struct resource irq_resource = {
 	.name	= "irqs",
-	.start	= PKUNITY_INTC_BASE,
-	.end	= PKUNITY_INTC_BASE + 0xFFFFF,
+	.start	= io_v2p(PKUNITY_INTC_BASE),
+	.end	= io_v2p(PKUNITY_INTC_BASE) + 0xFFFFF,
 };
 
 static struct puv3_irq_state {
diff --git a/arch/unicore32/kernel/pci.c b/arch/unicore32/kernel/pci.c
index 65c265e..100eab8 100644
--- a/arch/unicore32/kernel/pci.c
+++ b/arch/unicore32/kernel/pci.c
@@ -75,27 +75,27 @@ void pci_puv3_preinit(void)
 {
 	printk(KERN_DEBUG "PCI: PKUnity PCI Controller Initializing ...\n");
 	/* config PCI bridge base */
-	writel(PKUNITY_PCIBRI_BASE, PCICFG_BRIBASE);
+	writel(io_v2p(PKUNITY_PCIBRI_BASE), PCICFG_BRIBASE);
 
 	writel(0, PCIBRI_AHBCTL0);
-	writel(PKUNITY_PCIBRI_BASE | PCIBRI_BARx_MEM, PCIBRI_AHBBAR0);
+	writel(io_v2p(PKUNITY_PCIBRI_BASE) | PCIBRI_BARx_MEM, PCIBRI_AHBBAR0);
 	writel(0xFFFF0000, PCIBRI_AHBAMR0);
 	writel(0, PCIBRI_AHBTAR0);
 
 	writel(PCIBRI_CTLx_AT, PCIBRI_AHBCTL1);
-	writel(PKUNITY_PCILIO_BASE | PCIBRI_BARx_IO, PCIBRI_AHBBAR1);
+	writel(io_v2p(PKUNITY_PCILIO_BASE) | PCIBRI_BARx_IO, PCIBRI_AHBBAR1);
 	writel(0xFFFF0000, PCIBRI_AHBAMR1);
 	writel(0x00000000, PCIBRI_AHBTAR1);
 
 	writel(PCIBRI_CTLx_PREF, PCIBRI_AHBCTL2);
-	writel(PKUNITY_PCIMEM_BASE | PCIBRI_BARx_MEM, PCIBRI_AHBBAR2);
+	writel(io_v2p(PKUNITY_PCIMEM_BASE) | PCIBRI_BARx_MEM, PCIBRI_AHBBAR2);
 	writel(0xF8000000, PCIBRI_AHBAMR2);
 	writel(0, PCIBRI_AHBTAR2);
 
-	writel(PKUNITY_PCIAHB_BASE | PCIBRI_BARx_MEM, PCIBRI_BAR1);
+	writel(io_v2p(PKUNITY_PCIAHB_BASE) | PCIBRI_BARx_MEM, PCIBRI_BAR1);
 
 	writel(PCIBRI_CTLx_AT | PCIBRI_CTLx_PREF, PCIBRI_PCICTL0);
-	writel(PKUNITY_PCIAHB_BASE | PCIBRI_BARx_MEM, PCIBRI_PCIBAR0);
+	writel(io_v2p(PKUNITY_PCIAHB_BASE) | PCIBRI_BARx_MEM, PCIBRI_PCIBAR0);
 	writel(0xF8000000, PCIBRI_PCIAMR0);
 	writel(PKUNITY_SDRAM_BASE, PCIBRI_PCITAR0);
 
diff --git a/arch/unicore32/kernel/puv3-core.c b/arch/unicore32/kernel/puv3-core.c
index 7d10e7b..8b1b6be 100644
--- a/arch/unicore32/kernel/puv3-core.c
+++ b/arch/unicore32/kernel/puv3-core.c
@@ -50,8 +50,8 @@ unsigned long long sched_clock(void)
 static struct resource puv3_usb_resources[] = {
 	/* order is significant! */
 	{
-		.start		= PKUNITY_USB_BASE,
-		.end		= PKUNITY_USB_BASE + 0x3ff,
+		.start		= io_v2p(PKUNITY_USB_BASE),
+		.end		= io_v2p(PKUNITY_USB_BASE) + 0x3ff,
 		.flags		= IORESOURCE_MEM,
 	}, {
 		.start		= IRQ_USB,
@@ -82,8 +82,8 @@ static struct musb_hdrc_platform_data puv3_usb_plat = {
 
 static struct resource puv3_mmc_resources[] = {
 	[0] = {
-		.start	= PKUNITY_SDC_BASE,
-		.end	= PKUNITY_SDC_BASE + 0xfff,
+		.start	= io_v2p(PKUNITY_SDC_BASE),
+		.end	= io_v2p(PKUNITY_SDC_BASE) + 0xfff,
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
@@ -95,8 +95,8 @@ static struct resource puv3_mmc_resources[] = {
 
 static struct resource puv3_unigfx_resources[] = {
 	[0] = {
-		.start	= PKUNITY_UNIGFX_BASE,
-		.end	= PKUNITY_UNIGFX_BASE + 0xfff,
+		.start	= io_v2p(PKUNITY_UNIGFX_BASE),
+		.end	= io_v2p(PKUNITY_UNIGFX_BASE) + 0xfff,
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
@@ -108,8 +108,8 @@ static struct resource puv3_unigfx_resources[] = {
 
 static struct resource puv3_rtc_resources[] = {
 	[0] = {
-		.start = PKUNITY_RTC_BASE,
-		.end   = PKUNITY_RTC_BASE + 0xff,
+		.start = io_v2p(PKUNITY_RTC_BASE),
+		.end   = io_v2p(PKUNITY_RTC_BASE) + 0xff,
 		.flags = IORESOURCE_MEM,
 	},
 	[1] = {
@@ -126,16 +126,16 @@ static struct resource puv3_rtc_resources[] = {
 
 static struct resource puv3_pwm_resources[] = {
 	[0] = {
-		.start	= PKUNITY_OST_BASE + 0x80,
-		.end	= PKUNITY_OST_BASE + 0xff,
+		.start	= io_v2p(PKUNITY_OST_BASE) + 0x80,
+		.end	= io_v2p(PKUNITY_OST_BASE) + 0xff,
 		.flags	= IORESOURCE_MEM,
 	},
 };
 
 static struct resource puv3_uart0_resources[] = {
 	[0] = {
-		.start = PKUNITY_UART0_BASE,
-		.end   = PKUNITY_UART0_BASE + 0xff,
+		.start = io_v2p(PKUNITY_UART0_BASE),
+		.end   = io_v2p(PKUNITY_UART0_BASE) + 0xff,
 		.flags = IORESOURCE_MEM,
 	},
 	[1] = {
@@ -147,8 +147,8 @@ static struct resource puv3_uart0_resources[] = {
 
 static struct resource puv3_uart1_resources[] = {
 	[0] = {
-		.start = PKUNITY_UART1_BASE,
-		.end   = PKUNITY_UART1_BASE + 0xff,
+		.start = io_v2p(PKUNITY_UART1_BASE),
+		.end   = io_v2p(PKUNITY_UART1_BASE) + 0xff,
 		.flags = IORESOURCE_MEM,
 	},
 	[1] = {
@@ -160,8 +160,8 @@ static struct resource puv3_uart1_resources[] = {
 
 static struct resource puv3_umal_resources[] = {
 	[0] = {
-		.start = PKUNITY_UMAL_BASE,
-		.end   = PKUNITY_UMAL_BASE + 0x1fff,
+		.start = io_v2p(PKUNITY_UMAL_BASE),
+		.end   = io_v2p(PKUNITY_UMAL_BASE) + 0x1fff,
 		.flags = IORESOURCE_MEM,
 	},
 	[1] = {
diff --git a/arch/unicore32/kernel/puv3-nb0916.c b/arch/unicore32/kernel/puv3-nb0916.c
index a78e604..e731c56 100644
--- a/arch/unicore32/kernel/puv3-nb0916.c
+++ b/arch/unicore32/kernel/puv3-nb0916.c
@@ -39,8 +39,8 @@ static struct resource physmap_flash_resource = {
 
 static struct resource puv3_i2c_resources[] = {
 	[0] = {
-		.start = PKUNITY_I2C_BASE,
-		.end   = PKUNITY_I2C_BASE + 0xff,
+		.start = io_v2p(PKUNITY_I2C_BASE),
+		.end   = io_v2p(PKUNITY_I2C_BASE) + 0xff,
 		.flags = IORESOURCE_MEM,
 	},
 	[1] = {
diff --git a/arch/unicore32/kernel/sleep.S b/arch/unicore32/kernel/sleep.S
index f7c3fc8..607a104 100644
--- a/arch/unicore32/kernel/sleep.S
+++ b/arch/unicore32/kernel/sleep.S
@@ -76,10 +76,10 @@ ENTRY(puv3_cpu_suspend)
 
 
 	@ DDR2 BaseAddr
-	ldw	r0, =io_p2v(PKUNITY_DDR2CTRL_BASE)
+	ldw	r0, =(PKUNITY_DDR2CTRL_BASE)
 
 	@ PM BaseAddr
-	ldw	r1, =io_p2v(PKUNITY_PM_BASE)
+	ldw	r1, =(PKUNITY_PM_BASE)
 
 	@ set PLL_SYS_CFG reg, 275
 	movl	r6, #0x00002401
-- 
1.6.2.2

> 
> In the long run, I would recommend moving away from hardcoded I/O addresses
> entirely, but you can do that at the same time as moving to a flattened
> device tree. When you do that, every driver will do an individual ioremap
> to get the virtual address for a physical location, rather than doing it
> once at boot time for all hardware. This makes the code more flexible when
> dealing with multiple SoC implemetations, but it's not something that
> you need to worry about too much for the initial merge.
> 
> 	Arnd
Thanks Arnd.

Guan Xuetao

