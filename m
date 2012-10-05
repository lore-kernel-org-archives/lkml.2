Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab2JEREY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:04:24 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39054 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019Ab2JERET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:04:19 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Sekhar Nori <nsekhar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: [PATCH v4 2/7] ARM: davinci: sram: switch from iotable to ioremapped regions
Date: Fri,  5 Oct 2012 13:04:41 -0400
Message-Id: <1349456686-22736-3-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349456686-22736-1-git-send-email-mporter@ti.com>
References: <1349456686-22736-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Gardiner <bengardiner@nanometrics.ca>

The current davinci init sets up SRAM in iotables. There has been
an observed failure to boot a da850 with 128K specified in the
iotable.

Make the davinci sram allocator do an ioremap of the region
specified by the entries in davinci_soc_info before registering
with gen_pool_add_virt(). Remove all iotable SRAM mappings and
SRAM_VIRT.

Regression tested suspend/resume on AM180x EVM.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/mach-davinci/da850.c               |    6 ------
 arch/arm/mach-davinci/dm355.c               |    6 ------
 arch/arm/mach-davinci/dm365.c               |    6 ------
 arch/arm/mach-davinci/dm644x.c              |    6 ------
 arch/arm/mach-davinci/dm646x.c              |    6 ------
 arch/arm/mach-davinci/include/mach/common.h |    2 --
 arch/arm/mach-davinci/sram.c                |   18 +++++++++++++++---
 7 files changed, 15 insertions(+), 35 deletions(-)

diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 6676dee..b4b324f 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -713,12 +713,6 @@ static struct map_desc da850_io_desc[] = {
 		.length		= DA8XX_CP_INTC_SIZE,
 		.type		= MT_DEVICE
 	},
-	{
-		.virtual	= SRAM_VIRT,
-		.pfn		= __phys_to_pfn(DA8XX_ARM_RAM_BASE),
-		.length		= SZ_8K,
-		.type		= MT_DEVICE
-	},
 };
 
 static u32 da850_psc_bases[] = { DA8XX_PSC0_BASE, DA8XX_PSC1_BASE };
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index a255434..b49c3b7 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -758,12 +758,6 @@ static struct map_desc dm355_io_desc[] = {
 		.length		= IO_SIZE,
 		.type		= MT_DEVICE
 	},
-	{
-		.virtual	= SRAM_VIRT,
-		.pfn		= __phys_to_pfn(0x00010000),
-		.length		= SZ_32K,
-		.type		= MT_MEMORY_NONCACHED,
-	},
 };
 
 /* Contents of JTAG ID register used to identify exact cpu type */
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index b680c83..6c39805 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -985,12 +985,6 @@ static struct map_desc dm365_io_desc[] = {
 		.length		= IO_SIZE,
 		.type		= MT_DEVICE
 	},
-	{
-		.virtual	= SRAM_VIRT,
-		.pfn		= __phys_to_pfn(0x00010000),
-		.length		= SZ_32K,
-		.type		= MT_MEMORY_NONCACHED,
-	},
 };
 
 static struct resource dm365_ks_resources[] = {
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 0755d46..f8aaa7d 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -795,12 +795,6 @@ static struct map_desc dm644x_io_desc[] = {
 		.length		= IO_SIZE,
 		.type		= MT_DEVICE
 	},
-	{
-		.virtual	= SRAM_VIRT,
-		.pfn		= __phys_to_pfn(0x00008000),
-		.length		= SZ_16K,
-		.type		= MT_MEMORY_NONCACHED,
-	},
 };
 
 /* Contents of JTAG ID register used to identify exact cpu type */
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 97c0f8e..ac7b431 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -756,12 +756,6 @@ static struct map_desc dm646x_io_desc[] = {
 		.length		= IO_SIZE,
 		.type		= MT_DEVICE
 	},
-	{
-		.virtual	= SRAM_VIRT,
-		.pfn		= __phys_to_pfn(0x00010000),
-		.length		= SZ_32K,
-		.type		= MT_MEMORY_NONCACHED,
-	},
 };
 
 /* Contents of JTAG ID register used to identify exact cpu type */
diff --git a/arch/arm/mach-davinci/include/mach/common.h b/arch/arm/mach-davinci/include/mach/common.h
index bdc4aa8..046c723 100644
--- a/arch/arm/mach-davinci/include/mach/common.h
+++ b/arch/arm/mach-davinci/include/mach/common.h
@@ -104,8 +104,6 @@ int davinci_pm_init(void);
 static inline int davinci_pm_init(void) { return 0; }
 #endif
 
-/* standard place to map on-chip SRAMs; they *may* support DMA */
-#define SRAM_VIRT	0xfffe0000
 #define SRAM_SIZE	SZ_128K
 
 #endif /* __ARCH_ARM_MACH_DAVINCI_COMMON_H */
diff --git a/arch/arm/mach-davinci/sram.c b/arch/arm/mach-davinci/sram.c
index db0f778..fa56374 100644
--- a/arch/arm/mach-davinci/sram.c
+++ b/arch/arm/mach-davinci/sram.c
@@ -10,6 +10,7 @@
  */
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/genalloc.h>
 
 #include <mach/common.h>
@@ -32,7 +33,7 @@ void *sram_alloc(size_t len, dma_addr_t *dma)
 		return NULL;
 
 	if (dma)
-		*dma = dma_base + (vaddr - SRAM_VIRT);
+		*dma = gen_pool_virt_to_phys(sram_pool, vaddr);
 	return (void *)vaddr;
 
 }
@@ -53,8 +54,10 @@ EXPORT_SYMBOL(sram_free);
  */
 static int __init sram_init(void)
 {
+	phys_addr_t phys = davinci_soc_info.sram_dma;
 	unsigned len = davinci_soc_info.sram_len;
 	int status = 0;
+	void *addr;
 
 	if (len) {
 		len = min_t(unsigned, len, SRAM_SIZE);
@@ -62,8 +65,17 @@ static int __init sram_init(void)
 		if (!sram_pool)
 			status = -ENOMEM;
 	}
-	if (sram_pool)
-		status = gen_pool_add(sram_pool, SRAM_VIRT, len, -1);
+
+	if (sram_pool) {
+		addr = ioremap(phys, len);
+		if (!addr)
+			return -ENOMEM;
+		status = gen_pool_add_virt(sram_pool, (unsigned)addr,
+					   phys, len, -1);
+		if (status < 0)
+			iounmap(addr);
+	}
+
 	WARN_ON(status < 0);
 	return status;
 }
-- 
1.7.9.5

