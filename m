Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab0IPE0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 00:26:51 -0400
Received: from sh.osrg.net ([192.16.179.4]:48938 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab0IPE0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 00:26:50 -0400
Date: Thu, 16 Sep 2010 13:26:22 +0900
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, khc@pm.waw.pl,
        linux@arm.linux.org.uk
Subject: [PATCH] arm: fix arm: fix pci_set_consistent_dma_mask for
 dmabounce devices
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100916132342R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 16 Sep 2010 13:26:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the regression caused by the commit
6fee48cd330c68332f9712bc968d934a1a84a32a ("dma-mapping: arm: use
generic pci_set_dma_mask and pci_set_consistent_dma_mask").

ARM needs to clip the dma coherent mask for dmabounce devices. This
restores the old trick.

Note that strictly speaking, the DMA API doesn't allow architectures
to do such but I'm not sure it's worth adding the new API to set the
dma mask that allows architectures to clip it.

Reported-by: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/common/it8152.c                     |    8 ++++++++
 arch/arm/mach-ixp4xx/common-pci.c            |    8 ++++++++
 arch/arm/mach-ixp4xx/include/mach/hardware.h |    2 ++
 arch/arm/mach-pxa/include/mach/hardware.h    |    2 +-
 arch/arm/mach-pxa/include/mach/io.h          |    2 ++
 include/linux/dma-mapping.h                  |    4 ++++
 6 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/arch/arm/common/it8152.c b/arch/arm/common/it8152.c
index 7974baa..1bec96e 100644
--- a/arch/arm/common/it8152.c
+++ b/arch/arm/common/it8152.c
@@ -271,6 +271,14 @@ int dma_needs_bounce(struct device *dev, dma_addr_t dma_addr, size_t size)
 		((dma_addr + size - PHYS_OFFSET) >= SZ_64M);
 }
 
+int dma_set_coherent_mask(struct device *dev, u64 mask)
+{
+	if (mask >= PHYS_OFFSET + SZ_64M - 1)
+		return 0;
+
+	return -EIO;
+}
+
 int __init it8152_pci_setup(int nr, struct pci_sys_data *sys)
 {
 	it8152_io.start = IT8152_IO_BASE + 0x12000;
diff --git a/arch/arm/mach-ixp4xx/common-pci.c b/arch/arm/mach-ixp4xx/common-pci.c
index 61cd4d6..24498a9 100644
--- a/arch/arm/mach-ixp4xx/common-pci.c
+++ b/arch/arm/mach-ixp4xx/common-pci.c
@@ -503,6 +503,14 @@ struct pci_bus * __devinit ixp4xx_scan_bus(int nr, struct pci_sys_data *sys)
 	return pci_scan_bus(sys->busnr, &ixp4xx_ops, sys);
 }
 
+int dma_set_coherent_mask(struct device *dev, u64 mask)
+{
+	if (mask >= SZ_64M - 1)
+		return 0;
+
+	return -EIO;
+}
+
 EXPORT_SYMBOL(ixp4xx_pci_read);
 EXPORT_SYMBOL(ixp4xx_pci_write);
 
diff --git a/arch/arm/mach-ixp4xx/include/mach/hardware.h b/arch/arm/mach-ixp4xx/include/mach/hardware.h
index f91ca6d..8138371 100644
--- a/arch/arm/mach-ixp4xx/include/mach/hardware.h
+++ b/arch/arm/mach-ixp4xx/include/mach/hardware.h
@@ -26,6 +26,8 @@
 #define PCIBIOS_MAX_MEM		0x4BFFFFFF
 #endif
 
+#define ARCH_HAS_DMA_SET_COHERENT_MASK
+
 #define pcibios_assign_all_busses()	1
 
 /* Register locations and bits */
diff --git a/arch/arm/mach-pxa/include/mach/hardware.h b/arch/arm/mach-pxa/include/mach/hardware.h
index 7f64d24..428cc7b 100644
--- a/arch/arm/mach-pxa/include/mach/hardware.h
+++ b/arch/arm/mach-pxa/include/mach/hardware.h
@@ -309,7 +309,7 @@ extern unsigned long get_clock_tick_rate(void);
 #define PCIBIOS_MIN_IO		0
 #define PCIBIOS_MIN_MEM		0
 #define pcibios_assign_all_busses()	1
+#define ARCH_HAS_DMA_SET_COHERENT_MASK
 #endif
 
-
 #endif  /* _ASM_ARCH_HARDWARE_H */
diff --git a/arch/arm/mach-pxa/include/mach/io.h b/arch/arm/mach-pxa/include/mach/io.h
index 262691f..fdca3be 100644
--- a/arch/arm/mach-pxa/include/mach/io.h
+++ b/arch/arm/mach-pxa/include/mach/io.h
@@ -6,6 +6,8 @@
 #ifndef __ASM_ARM_ARCH_IO_H
 #define __ASM_ARM_ARCH_IO_H
 
+#include <mach/hardware.h>
+
 #define IO_SPACE_LIMIT 0xffffffff
 
 /*
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index ce29b81..ba8319a 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -102,6 +102,9 @@ static inline u64 dma_get_mask(struct device *dev)
 	return DMA_BIT_MASK(32);
 }
 
+#ifdef ARCH_HAS_DMA_SET_COHERENT_MASK
+int dma_set_coherent_mask(struct device *dev, u64 mask);
+#else
 static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
 {
 	if (!dma_supported(dev, mask))
@@ -109,6 +112,7 @@ static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
 	dev->coherent_dma_mask = mask;
 	return 0;
 }
+#endif
 
 extern u64 dma_get_required_mask(struct device *dev);
 
-- 
1.7.1

