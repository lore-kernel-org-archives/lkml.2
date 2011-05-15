Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967Ab1EOLeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:34:16 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59445 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759118Ab1EOLeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:34:14 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: kernel@wantstofly.org, nico@fluxnic.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saeed.bishara@gmail.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCHv2 10/15] [orion] Consolidate USB platform setup code.
Date: Sun, 15 May 2011 13:32:49 +0200
Message-Id: <1305459174-25517-11-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
References: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-dove/common.c               |   65 +-------------------
 arch/arm/mach-kirkwood/common.c           |   39 +-----------
 arch/arm/mach-mv78xx0/common.c            |   93 ++---------------------------
 arch/arm/mach-orion5x/common.c            |   66 +-------------------
 arch/arm/plat-orion/common.c              |   89 +++++++++++++++++++++++++++
 arch/arm/plat-orion/include/plat/common.h |   12 ++++
 6 files changed, 117 insertions(+), 247 deletions(-)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 6703bf3..1412592 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -30,7 +30,6 @@
 #include <mach/bridge-regs.h>
 #include <asm/mach/arch.h>
 #include <linux/irq.h>
-#include <plat/ehci-orion.h>
 #include <plat/time.h>
 #include <plat/common.h>
 #include "common.h"
@@ -70,77 +69,21 @@ void __init dove_map_io(void)
 }
 
 /*****************************************************************************
- * EHCI
- ****************************************************************************/
-static struct orion_ehci_data dove_ehci_data = {
-	.dram		= &dove_mbus_dram_info,
-	.phy_version	= EHCI_PHY_NA,
-};
-
-static u64 ehci_dmamask = DMA_BIT_MASK(32);
-
-/*****************************************************************************
  * EHCI0
  ****************************************************************************/
-static struct resource dove_ehci0_resources[] = {
-	{
-		.start	= DOVE_USB0_PHYS_BASE,
-		.end	= DOVE_USB0_PHYS_BASE + SZ_4K - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= IRQ_DOVE_USB0,
-		.end	= IRQ_DOVE_USB0,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device dove_ehci0 = {
-	.name		= "orion-ehci",
-	.id		= 0,
-	.dev		= {
-		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-		.platform_data		= &dove_ehci_data,
-	},
-	.resource	= dove_ehci0_resources,
-	.num_resources	= ARRAY_SIZE(dove_ehci0_resources),
-};
-
 void __init dove_ehci0_init(void)
 {
-	platform_device_register(&dove_ehci0);
+	orion_ehci_init(&dove_mbus_dram_info,
+			DOVE_USB0_PHYS_BASE, IRQ_DOVE_USB0);
 }
 
 /*****************************************************************************
  * EHCI1
  ****************************************************************************/
-static struct resource dove_ehci1_resources[] = {
-	{
-		.start	= DOVE_USB1_PHYS_BASE,
-		.end	= DOVE_USB1_PHYS_BASE + SZ_4K - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= IRQ_DOVE_USB1,
-		.end	= IRQ_DOVE_USB1,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device dove_ehci1 = {
-	.name		= "orion-ehci",
-	.id		= 1,
-	.dev		= {
-		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-		.platform_data		= &dove_ehci_data,
-	},
-	.resource	= dove_ehci1_resources,
-	.num_resources	= ARRAY_SIZE(dove_ehci1_resources),
-};
-
 void __init dove_ehci1_init(void)
 {
-	platform_device_register(&dove_ehci1);
+	orion_ehci_1_init(&dove_mbus_dram_info,
+			  DOVE_USB1_PHYS_BASE, IRQ_DOVE_USB1);
 }
 
 /*****************************************************************************
diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index 7c2b5df..9e56cbb 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -26,7 +26,6 @@
 #include <mach/bridge-regs.h>
 #include <plat/audio.h>
 #include <plat/cache-feroceon-l2.h>
-#include <plat/ehci-orion.h>
 #include <plat/mvsdio.h>
 #include <plat/orion_nand.h>
 #include <plat/common.h>
@@ -69,47 +68,13 @@ unsigned int kirkwood_clk_ctrl = CGC_DUNIT | CGC_RESERVED;
 
 
 /*****************************************************************************
- * EHCI
- ****************************************************************************/
-static struct orion_ehci_data kirkwood_ehci_data = {
-	.dram		= &kirkwood_mbus_dram_info,
-	.phy_version	= EHCI_PHY_NA,
-};
-
-static u64 ehci_dmamask = DMA_BIT_MASK(32);
-
-
-/*****************************************************************************
  * EHCI0
  ****************************************************************************/
-static struct resource kirkwood_ehci_resources[] = {
-	{
-		.start	= USB_PHYS_BASE,
-		.end	= USB_PHYS_BASE + SZ_4K - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= IRQ_KIRKWOOD_USB,
-		.end	= IRQ_KIRKWOOD_USB,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device kirkwood_ehci = {
-	.name		= "orion-ehci",
-	.id		= 0,
-	.dev		= {
-		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-		.platform_data		= &kirkwood_ehci_data,
-	},
-	.resource	= kirkwood_ehci_resources,
-	.num_resources	= ARRAY_SIZE(kirkwood_ehci_resources),
-};
-
 void __init kirkwood_ehci_init(void)
 {
 	kirkwood_clk_ctrl |= CGC_USB0;
-	platform_device_register(&kirkwood_ehci);
+	orion_ehci_init(&kirkwood_mbus_dram_info,
+			USB_PHYS_BASE, IRQ_KIRKWOOD_USB);
 }
 
 
diff --git a/arch/arm/mach-mv78xx0/common.c b/arch/arm/mach-mv78xx0/common.c
index aa27c15..f250196 100644
--- a/arch/arm/mach-mv78xx0/common.c
+++ b/arch/arm/mach-mv78xx0/common.c
@@ -20,7 +20,6 @@
 #include <mach/mv78xx0.h>
 #include <mach/bridge-regs.h>
 #include <plat/cache-feroceon-l2.h>
-#include <plat/ehci-orion.h>
 #include <plat/orion_nand.h>
 #include <plat/time.h>
 #include <plat/common.h>
@@ -168,110 +167,30 @@ void __init mv78xx0_map_io(void)
 /*****************************************************************************
  * EHCI
  ****************************************************************************/
-static struct orion_ehci_data mv78xx0_ehci_data = {
-	.dram		= &mv78xx0_mbus_dram_info,
-	.phy_version	= EHCI_PHY_NA,
-};
-
-static u64 ehci_dmamask = DMA_BIT_MASK(32);
-
-
-/*****************************************************************************
- * EHCI0
- ****************************************************************************/
-static struct resource mv78xx0_ehci0_resources[] = {
-	{
-		.start	= USB0_PHYS_BASE,
-		.end	= USB0_PHYS_BASE + SZ_4K - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= IRQ_MV78XX0_USB_0,
-		.end	= IRQ_MV78XX0_USB_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mv78xx0_ehci0 = {
-	.name		= "orion-ehci",
-	.id		= 0,
-	.dev		= {
-		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-		.platform_data		= &mv78xx0_ehci_data,
-	},
-	.resource	= mv78xx0_ehci0_resources,
-	.num_resources	= ARRAY_SIZE(mv78xx0_ehci0_resources),
-};
-
 void __init mv78xx0_ehci0_init(void)
 {
-	platform_device_register(&mv78xx0_ehci0);
+	orion_ehci_init(&mv78xx0_mbus_dram_info,
+			USB0_PHYS_BASE, IRQ_MV78XX0_USB_0);
 }
 
 
 /*****************************************************************************
  * EHCI1
  ****************************************************************************/
-static struct resource mv78xx0_ehci1_resources[] = {
-	{
-		.start	= USB1_PHYS_BASE,
-		.end	= USB1_PHYS_BASE + SZ_4K - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= IRQ_MV78XX0_USB_1,
-		.end	= IRQ_MV78XX0_USB_1,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mv78xx0_ehci1 = {
-	.name		= "orion-ehci",
-	.id		= 1,
-	.dev		= {
-		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-		.platform_data		= &mv78xx0_ehci_data,
-	},
-	.resource	= mv78xx0_ehci1_resources,
-	.num_resources	= ARRAY_SIZE(mv78xx0_ehci1_resources),
-};
-
 void __init mv78xx0_ehci1_init(void)
 {
-	platform_device_register(&mv78xx0_ehci1);
+	orion_ehci_1_init(&mv78xx0_mbus_dram_info,
+			  USB1_PHYS_BASE, IRQ_MV78XX0_USB_1);
 }
 
 
 /*****************************************************************************
  * EHCI2
  ****************************************************************************/
-static struct resource mv78xx0_ehci2_resources[] = {
-	{
-		.start	= USB2_PHYS_BASE,
-		.end	= USB2_PHYS_BASE + SZ_4K - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= IRQ_MV78XX0_USB_2,
-		.end	= IRQ_MV78XX0_USB_2,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mv78xx0_ehci2 = {
-	.name		= "orion-ehci",
-	.id		= 2,
-	.dev		= {
-		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-		.platform_data		= &mv78xx0_ehci_data,
-	},
-	.resource	= mv78xx0_ehci2_resources,
-	.num_resources	= ARRAY_SIZE(mv78xx0_ehci2_resources),
-};
-
 void __init mv78xx0_ehci2_init(void)
 {
-	platform_device_register(&mv78xx0_ehci2);
+	orion_ehci_2_init(&mv78xx0_mbus_dram_info,
+			  USB2_PHYS_BASE, IRQ_MV78XX0_USB_2);
 }
 
 
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index 5c7e391..2132eaf 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -28,7 +28,6 @@
 #include <mach/bridge-regs.h>
 #include <mach/hardware.h>
 #include <mach/orion5x.h>
-#include <plat/ehci-orion.h>
 #include <plat/orion_nand.h>
 #include <plat/time.h>
 #include <plat/common.h>
@@ -68,79 +67,22 @@ void __init orion5x_map_io(void)
 
 
 /*****************************************************************************
- * EHCI
- ****************************************************************************/
-static struct orion_ehci_data orion5x_ehci_data = {
-	.dram		= &orion5x_mbus_dram_info,
-	.phy_version	= EHCI_PHY_ORION,
-};
-
-static u64 ehci_dmamask = DMA_BIT_MASK(32);
-
-
-/*****************************************************************************
  * EHCI0
  ****************************************************************************/
-static struct resource orion5x_ehci0_resources[] = {
-	{
-		.start	= ORION5X_USB0_PHYS_BASE,
-		.end	= ORION5X_USB0_PHYS_BASE + SZ_4K - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= IRQ_ORION5X_USB0_CTRL,
-		.end	= IRQ_ORION5X_USB0_CTRL,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device orion5x_ehci0 = {
-	.name		= "orion-ehci",
-	.id		= 0,
-	.dev		= {
-		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-		.platform_data		= &orion5x_ehci_data,
-	},
-	.resource	= orion5x_ehci0_resources,
-	.num_resources	= ARRAY_SIZE(orion5x_ehci0_resources),
-};
-
 void __init orion5x_ehci0_init(void)
 {
-	platform_device_register(&orion5x_ehci0);
+	orion_ehci_init(&orion5x_mbus_dram_info,
+			ORION5X_USB0_PHYS_BASE, IRQ_ORION5X_USB0_CTRL);
 }
 
 
 /*****************************************************************************
  * EHCI1
  ****************************************************************************/
-static struct resource orion5x_ehci1_resources[] = {
-	{
-		.start	= ORION5X_USB1_PHYS_BASE,
-		.end	= ORION5X_USB1_PHYS_BASE + SZ_4K - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= IRQ_ORION5X_USB1_CTRL,
-		.end	= IRQ_ORION5X_USB1_CTRL,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device orion5x_ehci1 = {
-	.name		= "orion-ehci",
-	.id		= 1,
-	.dev		= {
-		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-		.platform_data		= &orion5x_ehci_data,
-	},
-	.resource	= orion5x_ehci1_resources,
-	.num_resources	= ARRAY_SIZE(orion5x_ehci1_resources),
-};
-
 void __init orion5x_ehci1_init(void)
 {
-	platform_device_register(&orion5x_ehci1);
+	orion_ehci_1_init(&orion5x_mbus_dram_info,
+			  ORION5X_USB1_PHYS_BASE, IRQ_ORION5X_USB1_CTRL);
 }
 
 
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index 0a2face..802cbf4 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -20,6 +20,7 @@
 #include <linux/spi/orion_spi.h>
 #include <plat/orion_wdt.h>
 #include <plat/mv_xor.h>
+#include <plat/ehci-orion.h>
 
 /* Fill in the resources structure and link it into the platform
    device structure. There is always a memory region, and nearly
@@ -800,3 +801,91 @@ void __init orion_xor1_init(unsigned long mapbase_low,
 	orion_xor_init_channels(&orion_xor10_data, &orion_xor10_channel,
 				&orion_xor11_data, &orion_xor11_channel);
 }
+
+/*****************************************************************************
+ * EHCI
+ ****************************************************************************/
+static struct orion_ehci_data orion_ehci_data = {
+	.phy_version	= EHCI_PHY_NA,
+};
+
+static u64 ehci_dmamask = DMA_BIT_MASK(32);
+
+
+/*****************************************************************************
+ * EHCI0
+ ****************************************************************************/
+static struct resource orion_ehci_resources[2];
+
+static struct platform_device orion_ehci = {
+	.name		= "orion-ehci",
+	.id		= 0,
+	.dev		= {
+		.dma_mask		= &ehci_dmamask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+		.platform_data		= &orion_ehci_data,
+	},
+};
+
+void __init orion_ehci_init(struct mbus_dram_target_info *mbus_dram_info,
+			    unsigned long mapbase,
+			    unsigned long irq)
+{
+	orion_ehci_data.dram = mbus_dram_info;
+	fill_resources(&orion_ehci, orion_ehci_resources, mapbase, SZ_4K - 1,
+		       irq);
+
+	platform_device_register(&orion_ehci);
+}
+
+/*****************************************************************************
+ * EHCI1
+ ****************************************************************************/
+static struct resource orion_ehci_1_resources[2];
+
+static struct platform_device orion_ehci_1 = {
+	.name		= "orion-ehci",
+	.id		= 1,
+	.dev		= {
+		.dma_mask		= &ehci_dmamask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+		.platform_data		= &orion_ehci_data,
+	},
+};
+
+void __init orion_ehci_1_init(struct mbus_dram_target_info *mbus_dram_info,
+			      unsigned long mapbase,
+			      unsigned long irq)
+{
+	orion_ehci_data.dram = mbus_dram_info;
+	fill_resources(&orion_ehci_1, orion_ehci_1_resources,
+		       mapbase, SZ_4K - 1, irq);
+
+	platform_device_register(&orion_ehci_1);
+}
+
+/*****************************************************************************
+ * EHCI2
+ ****************************************************************************/
+static struct resource orion_ehci_2_resources[2];
+
+static struct platform_device orion_ehci_2 = {
+	.name		= "orion-ehci",
+	.id		= 2,
+	.dev		= {
+		.dma_mask		= &ehci_dmamask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+		.platform_data		= &orion_ehci_data,
+	},
+};
+
+void __init orion_ehci_2_init(struct mbus_dram_target_info *mbus_dram_info,
+			      unsigned long mapbase,
+			      unsigned long irq)
+{
+	orion_ehci_data.dram = mbus_dram_info;
+	fill_resources(&orion_ehci_2, orion_ehci_2_resources,
+		       mapbase, SZ_4K - 1, irq);
+
+	platform_device_register(&orion_ehci_2);
+}
diff --git a/arch/arm/plat-orion/include/plat/common.h b/arch/arm/plat-orion/include/plat/common.h
index 0e11ca5..6386f8e 100644
--- a/arch/arm/plat-orion/include/plat/common.h
+++ b/arch/arm/plat-orion/include/plat/common.h
@@ -92,4 +92,16 @@ void __init orion_xor1_init(unsigned long mapbase_low,
 			    unsigned long mapbase_high,
 			    unsigned long irq_0,
 			    unsigned long irq_1);
+
+void __init orion_ehci_init(struct mbus_dram_target_info *mbus_dram_info,
+			    unsigned long mapbase,
+			    unsigned long irq);
+
+void __init orion_ehci_1_init(struct mbus_dram_target_info *mbus_dram_info,
+			      unsigned long mapbase,
+			      unsigned long irq);
+
+void __init orion_ehci_2_init(struct mbus_dram_target_info *mbus_dram_info,
+			      unsigned long mapbase,
+			      unsigned long irq);
 #endif
-- 
1.7.4.4

