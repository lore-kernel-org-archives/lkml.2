Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938Ab1EOLdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:33:49 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59426 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759118Ab1EOLdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:33:47 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: kernel@wantstofly.org, nico@fluxnic.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saeed.bishara@gmail.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCHv2 09/15] [orion] Consolidate the XOR platform setup code.
Date: Sun, 15 May 2011 13:32:48 +0200
Message-Id: <1305459174-25517-10-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
References: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-dove/common.c               |  197 +-------------------------
 arch/arm/mach-kirkwood/common.c           |  199 +-------------------------
 arch/arm/mach-orion5x/common.c            |  102 +-------------
 arch/arm/plat-orion/common.c              |  215 +++++++++++++++++++++++++++++
 arch/arm/plat-orion/include/plat/common.h |   11 ++
 5 files changed, 244 insertions(+), 480 deletions(-)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index e3e043c..6703bf3 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -30,7 +30,6 @@
 #include <mach/bridge-regs.h>
 #include <asm/mach/arch.h>
 #include <linux/irq.h>
-#include <plat/mv_xor.h>
 #include <plat/ehci-orion.h>
 #include <plat/time.h>
 #include <plat/common.h>
@@ -278,208 +277,22 @@ struct sys_timer dove_timer = {
 };
 
 /*****************************************************************************
- * XOR
- ****************************************************************************/
-static struct mv_xor_platform_shared_data dove_xor_shared_data = {
-	.dram		= &dove_mbus_dram_info,
-};
-
-/*****************************************************************************
  * XOR 0
  ****************************************************************************/
-static u64 dove_xor0_dmamask = DMA_BIT_MASK(32);
-
-static struct resource dove_xor0_shared_resources[] = {
-	{
-		.name	= "xor 0 low",
-		.start	= DOVE_XOR0_PHYS_BASE,
-		.end	= DOVE_XOR0_PHYS_BASE + 0xff,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.name	= "xor 0 high",
-		.start	= DOVE_XOR0_HIGH_PHYS_BASE,
-		.end	= DOVE_XOR0_HIGH_PHYS_BASE + 0xff,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device dove_xor0_shared = {
-	.name		= MV_XOR_SHARED_NAME,
-	.id		= 0,
-	.dev		= {
-		.platform_data = &dove_xor_shared_data,
-	},
-	.num_resources	= ARRAY_SIZE(dove_xor0_shared_resources),
-	.resource	= dove_xor0_shared_resources,
-};
-
-static struct resource dove_xor00_resources[] = {
-	[0] = {
-		.start	= IRQ_DOVE_XOR_00,
-		.end	= IRQ_DOVE_XOR_00,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct mv_xor_platform_data dove_xor00_data = {
-	.shared		= &dove_xor0_shared,
-	.hw_id		= 0,
-	.pool_size	= PAGE_SIZE,
-};
-
-static struct platform_device dove_xor00_channel = {
-	.name		= MV_XOR_NAME,
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(dove_xor00_resources),
-	.resource	= dove_xor00_resources,
-	.dev		= {
-		.dma_mask		= &dove_xor0_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(64),
-		.platform_data		= &dove_xor00_data,
-	},
-};
-
-static struct resource dove_xor01_resources[] = {
-	[0] = {
-		.start	= IRQ_DOVE_XOR_01,
-		.end	= IRQ_DOVE_XOR_01,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct mv_xor_platform_data dove_xor01_data = {
-	.shared		= &dove_xor0_shared,
-	.hw_id		= 1,
-	.pool_size	= PAGE_SIZE,
-};
-
-static struct platform_device dove_xor01_channel = {
-	.name		= MV_XOR_NAME,
-	.id		= 1,
-	.num_resources	= ARRAY_SIZE(dove_xor01_resources),
-	.resource	= dove_xor01_resources,
-	.dev		= {
-		.dma_mask		= &dove_xor0_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(64),
-		.platform_data		= &dove_xor01_data,
-	},
-};
-
 void __init dove_xor0_init(void)
 {
-	platform_device_register(&dove_xor0_shared);
-
-	/*
-	 * two engines can't do memset simultaneously, this limitation
-	 * satisfied by removing memset support from one of the engines.
-	 */
-	dma_cap_set(DMA_MEMCPY, dove_xor00_data.cap_mask);
-	dma_cap_set(DMA_XOR, dove_xor00_data.cap_mask);
-	platform_device_register(&dove_xor00_channel);
-
-	dma_cap_set(DMA_MEMCPY, dove_xor01_data.cap_mask);
-	dma_cap_set(DMA_MEMSET, dove_xor01_data.cap_mask);
-	dma_cap_set(DMA_XOR, dove_xor01_data.cap_mask);
-	platform_device_register(&dove_xor01_channel);
+	orion_xor0_init(&dove_mbus_dram_info,
+			DOVE_XOR0_PHYS_BASE, DOVE_XOR0_HIGH_PHYS_BASE,
+			IRQ_DOVE_XOR_00, IRQ_DOVE_XOR_01);
 }
 
 /*****************************************************************************
  * XOR 1
  ****************************************************************************/
-static u64 dove_xor1_dmamask = DMA_BIT_MASK(32);
-
-static struct resource dove_xor1_shared_resources[] = {
-	{
-		.name	= "xor 0 low",
-		.start	= DOVE_XOR1_PHYS_BASE,
-		.end	= DOVE_XOR1_PHYS_BASE + 0xff,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.name	= "xor 0 high",
-		.start	= DOVE_XOR1_HIGH_PHYS_BASE,
-		.end	= DOVE_XOR1_HIGH_PHYS_BASE + 0xff,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device dove_xor1_shared = {
-	.name		= MV_XOR_SHARED_NAME,
-	.id		= 1,
-	.dev		= {
-		.platform_data = &dove_xor_shared_data,
-	},
-	.num_resources	= ARRAY_SIZE(dove_xor1_shared_resources),
-	.resource	= dove_xor1_shared_resources,
-};
-
-static struct resource dove_xor10_resources[] = {
-	[0] = {
-		.start	= IRQ_DOVE_XOR_10,
-		.end	= IRQ_DOVE_XOR_10,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct mv_xor_platform_data dove_xor10_data = {
-	.shared		= &dove_xor1_shared,
-	.hw_id		= 0,
-	.pool_size	= PAGE_SIZE,
-};
-
-static struct platform_device dove_xor10_channel = {
-	.name		= MV_XOR_NAME,
-	.id		= 2,
-	.num_resources	= ARRAY_SIZE(dove_xor10_resources),
-	.resource	= dove_xor10_resources,
-	.dev		= {
-		.dma_mask		= &dove_xor1_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(64),
-		.platform_data		= &dove_xor10_data,
-	},
-};
-
-static struct resource dove_xor11_resources[] = {
-	[0] = {
-		.start	= IRQ_DOVE_XOR_11,
-		.end	= IRQ_DOVE_XOR_11,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct mv_xor_platform_data dove_xor11_data = {
-	.shared		= &dove_xor1_shared,
-	.hw_id		= 1,
-	.pool_size	= PAGE_SIZE,
-};
-
-static struct platform_device dove_xor11_channel = {
-	.name		= MV_XOR_NAME,
-	.id		= 3,
-	.num_resources	= ARRAY_SIZE(dove_xor11_resources),
-	.resource	= dove_xor11_resources,
-	.dev		= {
-		.dma_mask		= &dove_xor1_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(64),
-		.platform_data		= &dove_xor11_data,
-	},
-};
-
 void __init dove_xor1_init(void)
 {
-	platform_device_register(&dove_xor1_shared);
-
-	/*
-	 * two engines can't do memset simultaneously, this limitation
-	 * satisfied by removing memset support from one of the engines.
-	 */
-	dma_cap_set(DMA_MEMCPY, dove_xor10_data.cap_mask);
-	dma_cap_set(DMA_XOR, dove_xor10_data.cap_mask);
-	platform_device_register(&dove_xor10_channel);
-
-	dma_cap_set(DMA_MEMCPY, dove_xor11_data.cap_mask);
-	dma_cap_set(DMA_MEMSET, dove_xor11_data.cap_mask);
-	dma_cap_set(DMA_XOR, dove_xor11_data.cap_mask);
-	platform_device_register(&dove_xor11_channel);
+	orion_xor1_init(DOVE_XOR1_PHYS_BASE, DOVE_XOR1_HIGH_PHYS_BASE,
+			IRQ_DOVE_XOR_10, IRQ_DOVE_XOR_11);
 }
 
 /*****************************************************************************
diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index 08847a6..7c2b5df 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -15,6 +15,7 @@
 #include <linux/mbus.h>
 #include <linux/ata_platform.h>
 #include <linux/mtd/nand.h>
+#include <linux/dma-mapping.h>
 #include <net/dsa.h>
 #include <asm/page.h>
 #include <asm/timex.h>
@@ -27,7 +28,6 @@
 #include <plat/cache-feroceon-l2.h>
 #include <plat/ehci-orion.h>
 #include <plat/mvsdio.h>
-#include <plat/mv_xor.h>
 #include <plat/orion_nand.h>
 #include <plat/common.h>
 #include <plat/time.h>
@@ -364,210 +364,27 @@ void __init kirkwood_crypto_init(void)
 
 
 /*****************************************************************************
- * XOR
- ****************************************************************************/
-static struct mv_xor_platform_shared_data kirkwood_xor_shared_data = {
-	.dram		= &kirkwood_mbus_dram_info,
-};
-
-
-/*****************************************************************************
  * XOR0
  ****************************************************************************/
-static struct resource kirkwood_xor0_shared_resources[] = {
-	{
-		.name	= "xor 0 low",
-		.start	= XOR0_PHYS_BASE,
-		.end	= XOR0_PHYS_BASE + 0xff,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.name	= "xor 0 high",
-		.start	= XOR0_HIGH_PHYS_BASE,
-		.end	= XOR0_HIGH_PHYS_BASE + 0xff,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device kirkwood_xor0_shared = {
-	.name		= MV_XOR_SHARED_NAME,
-	.id		= 0,
-	.dev		= {
-		.platform_data = &kirkwood_xor_shared_data,
-	},
-	.num_resources	= ARRAY_SIZE(kirkwood_xor0_shared_resources),
-	.resource	= kirkwood_xor0_shared_resources,
-};
-
-static u64 kirkwood_xor_dmamask = DMA_BIT_MASK(32);
-
-static struct resource kirkwood_xor00_resources[] = {
-	[0] = {
-		.start	= IRQ_KIRKWOOD_XOR_00,
-		.end	= IRQ_KIRKWOOD_XOR_00,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct mv_xor_platform_data kirkwood_xor00_data = {
-	.shared		= &kirkwood_xor0_shared,
-	.hw_id		= 0,
-	.pool_size	= PAGE_SIZE,
-};
-
-static struct platform_device kirkwood_xor00_channel = {
-	.name		= MV_XOR_NAME,
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(kirkwood_xor00_resources),
-	.resource	= kirkwood_xor00_resources,
-	.dev		= {
-		.dma_mask		= &kirkwood_xor_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(64),
-		.platform_data		= &kirkwood_xor00_data,
-	},
-};
-
-static struct resource kirkwood_xor01_resources[] = {
-	[0] = {
-		.start	= IRQ_KIRKWOOD_XOR_01,
-		.end	= IRQ_KIRKWOOD_XOR_01,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct mv_xor_platform_data kirkwood_xor01_data = {
-	.shared		= &kirkwood_xor0_shared,
-	.hw_id		= 1,
-	.pool_size	= PAGE_SIZE,
-};
-
-static struct platform_device kirkwood_xor01_channel = {
-	.name		= MV_XOR_NAME,
-	.id		= 1,
-	.num_resources	= ARRAY_SIZE(kirkwood_xor01_resources),
-	.resource	= kirkwood_xor01_resources,
-	.dev		= {
-		.dma_mask		= &kirkwood_xor_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(64),
-		.platform_data		= &kirkwood_xor01_data,
-	},
-};
-
 static void __init kirkwood_xor0_init(void)
 {
 	kirkwood_clk_ctrl |= CGC_XOR0;
-	platform_device_register(&kirkwood_xor0_shared);
 
-	/*
-	 * two engines can't do memset simultaneously, this limitation
-	 * satisfied by removing memset support from one of the engines.
-	 */
-	dma_cap_set(DMA_MEMCPY, kirkwood_xor00_data.cap_mask);
-	dma_cap_set(DMA_XOR, kirkwood_xor00_data.cap_mask);
-	platform_device_register(&kirkwood_xor00_channel);
-
-	dma_cap_set(DMA_MEMCPY, kirkwood_xor01_data.cap_mask);
-	dma_cap_set(DMA_MEMSET, kirkwood_xor01_data.cap_mask);
-	dma_cap_set(DMA_XOR, kirkwood_xor01_data.cap_mask);
-	platform_device_register(&kirkwood_xor01_channel);
+	orion_xor0_init(&kirkwood_mbus_dram_info,
+			XOR0_PHYS_BASE, XOR0_HIGH_PHYS_BASE,
+			IRQ_KIRKWOOD_XOR_00, IRQ_KIRKWOOD_XOR_01);
 }
 
 
 /*****************************************************************************
  * XOR1
  ****************************************************************************/
-static struct resource kirkwood_xor1_shared_resources[] = {
-	{
-		.name	= "xor 1 low",
-		.start	= XOR1_PHYS_BASE,
-		.end	= XOR1_PHYS_BASE + 0xff,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.name	= "xor 1 high",
-		.start	= XOR1_HIGH_PHYS_BASE,
-		.end	= XOR1_HIGH_PHYS_BASE + 0xff,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device kirkwood_xor1_shared = {
-	.name		= MV_XOR_SHARED_NAME,
-	.id		= 1,
-	.dev		= {
-		.platform_data = &kirkwood_xor_shared_data,
-	},
-	.num_resources	= ARRAY_SIZE(kirkwood_xor1_shared_resources),
-	.resource	= kirkwood_xor1_shared_resources,
-};
-
-static struct resource kirkwood_xor10_resources[] = {
-	[0] = {
-		.start	= IRQ_KIRKWOOD_XOR_10,
-		.end	= IRQ_KIRKWOOD_XOR_10,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct mv_xor_platform_data kirkwood_xor10_data = {
-	.shared		= &kirkwood_xor1_shared,
-	.hw_id		= 0,
-	.pool_size	= PAGE_SIZE,
-};
-
-static struct platform_device kirkwood_xor10_channel = {
-	.name		= MV_XOR_NAME,
-	.id		= 2,
-	.num_resources	= ARRAY_SIZE(kirkwood_xor10_resources),
-	.resource	= kirkwood_xor10_resources,
-	.dev		= {
-		.dma_mask		= &kirkwood_xor_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(64),
-		.platform_data		= &kirkwood_xor10_data,
-	},
-};
-
-static struct resource kirkwood_xor11_resources[] = {
-	[0] = {
-		.start	= IRQ_KIRKWOOD_XOR_11,
-		.end	= IRQ_KIRKWOOD_XOR_11,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct mv_xor_platform_data kirkwood_xor11_data = {
-	.shared		= &kirkwood_xor1_shared,
-	.hw_id		= 1,
-	.pool_size	= PAGE_SIZE,
-};
-
-static struct platform_device kirkwood_xor11_channel = {
-	.name		= MV_XOR_NAME,
-	.id		= 3,
-	.num_resources	= ARRAY_SIZE(kirkwood_xor11_resources),
-	.resource	= kirkwood_xor11_resources,
-	.dev		= {
-		.dma_mask		= &kirkwood_xor_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(64),
-		.platform_data		= &kirkwood_xor11_data,
-	},
-};
-
 static void __init kirkwood_xor1_init(void)
 {
 	kirkwood_clk_ctrl |= CGC_XOR1;
-	platform_device_register(&kirkwood_xor1_shared);
 
-	/*
-	 * two engines can't do memset simultaneously, this limitation
-	 * satisfied by removing memset support from one of the engines.
-	 */
-	dma_cap_set(DMA_MEMCPY, kirkwood_xor10_data.cap_mask);
-	dma_cap_set(DMA_XOR, kirkwood_xor10_data.cap_mask);
-	platform_device_register(&kirkwood_xor10_channel);
-
-	dma_cap_set(DMA_MEMCPY, kirkwood_xor11_data.cap_mask);
-	dma_cap_set(DMA_MEMSET, kirkwood_xor11_data.cap_mask);
-	dma_cap_set(DMA_XOR, kirkwood_xor11_data.cap_mask);
-	platform_device_register(&kirkwood_xor11_channel);
+	orion_xor1_init(XOR1_PHYS_BASE, XOR1_HIGH_PHYS_BASE,
+			IRQ_KIRKWOOD_XOR_10, IRQ_KIRKWOOD_XOR_11);
 }
 
 
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index c26e6db..5c7e391 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
 #include <linux/serial_8250.h>
 #include <linux/mbus.h>
 #include <linux/mv643xx_i2c.h>
@@ -28,7 +29,6 @@
 #include <mach/hardware.h>
 #include <mach/orion5x.h>
 #include <plat/ehci-orion.h>
-#include <plat/mv_xor.h>
 #include <plat/orion_nand.h>
 #include <plat/time.h>
 #include <plat/common.h>
@@ -239,104 +239,12 @@ void __init orion5x_uart1_init(void)
 /*****************************************************************************
  * XOR engine
  ****************************************************************************/
-struct mv_xor_platform_shared_data orion5x_xor_shared_data = {
-	.dram		= &orion5x_mbus_dram_info,
-};
-
-static struct resource orion5x_xor_shared_resources[] = {
-	{
-		.name	= "xor low",
-		.start	= ORION5X_XOR_PHYS_BASE,
-		.end	= ORION5X_XOR_PHYS_BASE + 0xff,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.name	= "xor high",
-		.start	= ORION5X_XOR_PHYS_BASE + 0x200,
-		.end	= ORION5X_XOR_PHYS_BASE + 0x2ff,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device orion5x_xor_shared = {
-	.name		= MV_XOR_SHARED_NAME,
-	.id		= 0,
-	.dev		= {
-		.platform_data	= &orion5x_xor_shared_data,
-	},
-	.num_resources	= ARRAY_SIZE(orion5x_xor_shared_resources),
-	.resource	= orion5x_xor_shared_resources,
-};
-
-static u64 orion5x_xor_dmamask = DMA_BIT_MASK(32);
-
-static struct resource orion5x_xor0_resources[] = {
-	[0] = {
-		.start	= IRQ_ORION5X_XOR0,
-		.end	= IRQ_ORION5X_XOR0,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct mv_xor_platform_data orion5x_xor0_data = {
-	.shared		= &orion5x_xor_shared,
-	.hw_id		= 0,
-	.pool_size	= PAGE_SIZE,
-};
-
-static struct platform_device orion5x_xor0_channel = {
-	.name		= MV_XOR_NAME,
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(orion5x_xor0_resources),
-	.resource	= orion5x_xor0_resources,
-	.dev		= {
-		.dma_mask		= &orion5x_xor_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(64),
-		.platform_data		= &orion5x_xor0_data,
-	},
-};
-
-static struct resource orion5x_xor1_resources[] = {
-	[0] = {
-		.start	= IRQ_ORION5X_XOR1,
-		.end	= IRQ_ORION5X_XOR1,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct mv_xor_platform_data orion5x_xor1_data = {
-	.shared		= &orion5x_xor_shared,
-	.hw_id		= 1,
-	.pool_size	= PAGE_SIZE,
-};
-
-static struct platform_device orion5x_xor1_channel = {
-	.name		= MV_XOR_NAME,
-	.id		= 1,
-	.num_resources	= ARRAY_SIZE(orion5x_xor1_resources),
-	.resource	= orion5x_xor1_resources,
-	.dev		= {
-		.dma_mask		= &orion5x_xor_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(64),
-		.platform_data		= &orion5x_xor1_data,
-	},
-};
-
 void __init orion5x_xor_init(void)
 {
-	platform_device_register(&orion5x_xor_shared);
-
-	/*
-	 * two engines can't do memset simultaneously, this limitation
-	 * satisfied by removing memset support from one of the engines.
-	 */
-	dma_cap_set(DMA_MEMCPY, orion5x_xor0_data.cap_mask);
-	dma_cap_set(DMA_XOR, orion5x_xor0_data.cap_mask);
-	platform_device_register(&orion5x_xor0_channel);
-
-	dma_cap_set(DMA_MEMCPY, orion5x_xor1_data.cap_mask);
-	dma_cap_set(DMA_MEMSET, orion5x_xor1_data.cap_mask);
-	dma_cap_set(DMA_XOR, orion5x_xor1_data.cap_mask);
-	platform_device_register(&orion5x_xor1_channel);
+	orion_xor0_init(&orion5x_mbus_dram_info,
+			ORION5X_XOR_PHYS_BASE,
+			ORION5X_XOR_PHYS_BASE + 0x200,
+			IRQ_ORION5X_XOR0, IRQ_ORION5X_XOR1);
 }
 
 static struct resource orion5x_crypto_res[] = {
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index 6502209..0a2face 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -19,6 +19,7 @@
 #include <net/dsa.h>
 #include <linux/spi/orion_spi.h>
 #include <plat/orion_wdt.h>
+#include <plat/mv_xor.h>
 
 /* Fill in the resources structure and link it into the platform
    device structure. There is always a memory region, and nearly
@@ -585,3 +586,217 @@ void __init orion_wdt_init(unsigned long tclk)
 	orion_wdt_data.tclk = tclk;
 	platform_device_register(&orion_wdt_device);
 }
+
+/*****************************************************************************
+ * XOR
+ ****************************************************************************/
+static struct mv_xor_platform_shared_data orion_xor_shared_data;
+
+static u64 orion_xor_dmamask = DMA_BIT_MASK(32);
+
+void __init orion_xor_init_channels(
+	struct mv_xor_platform_data *orion_xor0_data,
+	struct platform_device *orion_xor0_channel,
+	struct mv_xor_platform_data *orion_xor1_data,
+	struct platform_device *orion_xor1_channel)
+{
+	/*
+	 * two engines can't do memset simultaneously, this limitation
+	 * satisfied by removing memset support from one of the engines.
+	 */
+	dma_cap_set(DMA_MEMCPY, orion_xor0_data->cap_mask);
+	dma_cap_set(DMA_XOR, orion_xor0_data->cap_mask);
+	platform_device_register(orion_xor0_channel);
+
+	dma_cap_set(DMA_MEMCPY, orion_xor1_data->cap_mask);
+	dma_cap_set(DMA_MEMSET, orion_xor1_data->cap_mask);
+	dma_cap_set(DMA_XOR, orion_xor1_data->cap_mask);
+	platform_device_register(orion_xor1_channel);
+}
+
+/*****************************************************************************
+ * XOR0
+ ****************************************************************************/
+static struct resource orion_xor0_shared_resources[] = {
+	{
+		.name	= "xor 0 low",
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.name	= "xor 0 high",
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device orion_xor0_shared = {
+	.name		= MV_XOR_SHARED_NAME,
+	.id		= 0,
+	.dev		= {
+		.platform_data = &orion_xor_shared_data,
+	},
+	.num_resources	= ARRAY_SIZE(orion_xor0_shared_resources),
+	.resource	= orion_xor0_shared_resources,
+};
+
+static struct resource orion_xor00_resources[] = {
+	[0] = {
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct mv_xor_platform_data orion_xor00_data = {
+	.shared		= &orion_xor0_shared,
+	.hw_id		= 0,
+	.pool_size	= PAGE_SIZE,
+};
+
+static struct platform_device orion_xor00_channel = {
+	.name		= MV_XOR_NAME,
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(orion_xor00_resources),
+	.resource	= orion_xor00_resources,
+	.dev		= {
+		.dma_mask		= &orion_xor_dmamask,
+		.coherent_dma_mask	= DMA_BIT_MASK(64),
+		.platform_data		= &orion_xor00_data,
+	},
+};
+
+static struct resource orion_xor01_resources[] = {
+	[0] = {
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct mv_xor_platform_data orion_xor01_data = {
+	.shared		= &orion_xor0_shared,
+	.hw_id		= 1,
+	.pool_size	= PAGE_SIZE,
+};
+
+static struct platform_device orion_xor01_channel = {
+	.name		= MV_XOR_NAME,
+	.id		= 1,
+	.num_resources	= ARRAY_SIZE(orion_xor01_resources),
+	.resource	= orion_xor01_resources,
+	.dev		= {
+		.dma_mask		= &orion_xor_dmamask,
+		.coherent_dma_mask	= DMA_BIT_MASK(64),
+		.platform_data		= &orion_xor01_data,
+	},
+};
+
+void __init orion_xor0_init(struct mbus_dram_target_info *mbus_dram_info,
+			    unsigned long mapbase_low,
+			    unsigned long mapbase_high,
+			    unsigned long irq_0,
+			    unsigned long irq_1)
+{
+	orion_xor_shared_data.dram = mbus_dram_info;
+
+	orion_xor0_shared_resources[0].start = mapbase_low;
+	orion_xor0_shared_resources[0].end = mapbase_low + 0xff;
+	orion_xor0_shared_resources[1].start = mapbase_high;
+	orion_xor0_shared_resources[1].end = mapbase_high + 0xff;
+
+	orion_xor00_resources[0].start = irq_0;
+	orion_xor00_resources[0].end = irq_0;
+	orion_xor01_resources[0].start = irq_1;
+	orion_xor01_resources[0].end = irq_1;
+
+	platform_device_register(&orion_xor0_shared);
+
+	orion_xor_init_channels(&orion_xor00_data, &orion_xor00_channel,
+				&orion_xor01_data, &orion_xor01_channel);
+}
+
+/*****************************************************************************
+ * XOR1
+ ****************************************************************************/
+static struct resource orion_xor1_shared_resources[] = {
+	{
+		.name	= "xor 1 low",
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.name	= "xor 1 high",
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device orion_xor1_shared = {
+	.name		= MV_XOR_SHARED_NAME,
+	.id		= 1,
+	.dev		= {
+		.platform_data = &orion_xor_shared_data,
+	},
+	.num_resources	= ARRAY_SIZE(orion_xor1_shared_resources),
+	.resource	= orion_xor1_shared_resources,
+};
+
+static struct resource orion_xor10_resources[] = {
+	[0] = {
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct mv_xor_platform_data orion_xor10_data = {
+	.shared		= &orion_xor1_shared,
+	.hw_id		= 0,
+	.pool_size	= PAGE_SIZE,
+};
+
+static struct platform_device orion_xor10_channel = {
+	.name		= MV_XOR_NAME,
+	.id		= 2,
+	.num_resources	= ARRAY_SIZE(orion_xor10_resources),
+	.resource	= orion_xor10_resources,
+	.dev		= {
+		.dma_mask		= &orion_xor_dmamask,
+		.coherent_dma_mask	= DMA_BIT_MASK(64),
+		.platform_data		= &orion_xor10_data,
+	},
+};
+
+static struct resource orion_xor11_resources[] = {
+	[0] = {
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct mv_xor_platform_data orion_xor11_data = {
+	.shared		= &orion_xor1_shared,
+	.hw_id		= 1,
+	.pool_size	= PAGE_SIZE,
+};
+
+static struct platform_device orion_xor11_channel = {
+	.name		= MV_XOR_NAME,
+	.id		= 3,
+	.num_resources	= ARRAY_SIZE(orion_xor11_resources),
+	.resource	= orion_xor11_resources,
+	.dev		= {
+		.dma_mask		= &orion_xor_dmamask,
+		.coherent_dma_mask	= DMA_BIT_MASK(64),
+		.platform_data		= &orion_xor11_data,
+	},
+};
+
+void __init orion_xor1_init(unsigned long mapbase_low,
+			    unsigned long mapbase_high,
+			    unsigned long irq_0,
+			    unsigned long irq_1)
+{
+	orion_xor1_shared_resources[0].start = mapbase_low;
+	orion_xor1_shared_resources[0].end = mapbase_low + 0xff;
+	orion_xor1_shared_resources[1].start = mapbase_high;
+	orion_xor1_shared_resources[1].end = mapbase_high + 0xff;
+
+	orion_xor10_resources[0].start = irq_0;
+	orion_xor10_resources[0].end = irq_0;
+	orion_xor11_resources[0].start = irq_1;
+	orion_xor11_resources[0].end = irq_1;
+
+	platform_device_register(&orion_xor1_shared);
+
+	orion_xor_init_channels(&orion_xor10_data, &orion_xor10_channel,
+				&orion_xor11_data, &orion_xor11_channel);
+}
diff --git a/arch/arm/plat-orion/include/plat/common.h b/arch/arm/plat-orion/include/plat/common.h
index 38ae4bf..0e11ca5 100644
--- a/arch/arm/plat-orion/include/plat/common.h
+++ b/arch/arm/plat-orion/include/plat/common.h
@@ -81,4 +81,15 @@ void __init orion_spi_1_init(unsigned long mapbase,
 			     unsigned long tclk);
 
 void __init orion_wdt_init(unsigned long tclk);
+
+void __init orion_xor0_init(struct mbus_dram_target_info *mbus_dram_info,
+			    unsigned long mapbase_low,
+			    unsigned long mapbase_high,
+			    unsigned long irq_0,
+			    unsigned long irq_1);
+
+void __init orion_xor1_init(unsigned long mapbase_low,
+			    unsigned long mapbase_high,
+			    unsigned long irq_0,
+			    unsigned long irq_1);
 #endif
-- 
1.7.4.4

