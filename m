Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab1EOLd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:33:56 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59430 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab1EOLdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:33:53 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: kernel@wantstofly.org, nico@fluxnic.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saeed.bishara@gmail.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCHv2 11/15] [orion] Consolidate SATA platform setup.
Date: Sun, 15 May 2011 13:32:50 +0200
Message-Id: <1305459174-25517-12-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
References: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-dove/common.c               |   30 ++----------------------
 arch/arm/mach-kirkwood/common.c           |   30 ++----------------------
 arch/arm/mach-mv78xx0/common.c            |   29 +----------------------
 arch/arm/mach-orion5x/common.c            |   29 +----------------------
 arch/arm/plat-orion/common.c              |   35 +++++++++++++++++++++++++++++
 arch/arm/plat-orion/include/plat/common.h |    5 ++++
 6 files changed, 50 insertions(+), 108 deletions(-)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 1412592..5ed51b8 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -107,35 +107,11 @@ void __init dove_rtc_init(void)
 /*****************************************************************************
  * SATA
  ****************************************************************************/
-static struct resource dove_sata_resources[] = {
-	{
-		.name	= "sata base",
-		.start	= DOVE_SATA_PHYS_BASE,
-		.end	= DOVE_SATA_PHYS_BASE + 0x5000 - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.name	= "sata irq",
-		.start	= IRQ_DOVE_SATA,
-		.end	= IRQ_DOVE_SATA,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device dove_sata = {
-	.name		= "sata_mv",
-	.id		= 0,
-	.dev		= {
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-	.num_resources	= ARRAY_SIZE(dove_sata_resources),
-	.resource	= dove_sata_resources,
-};
-
 void __init dove_sata_init(struct mv_sata_platform_data *sata_data)
 {
-	sata_data->dram = &dove_mbus_dram_info;
-	dove_sata.dev.platform_data = sata_data;
-	platform_device_register(&dove_sata);
+	orion_sata_init(sata_data, &dove_mbus_dram_info,
+			DOVE_SATA_PHYS_BASE, IRQ_DOVE_SATA);
+
 }
 
 /*****************************************************************************
diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index 9e56cbb..e96ec4e 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -172,38 +172,14 @@ static void __init kirkwood_rtc_init(void)
 /*****************************************************************************
  * SATA
  ****************************************************************************/
-static struct resource kirkwood_sata_resources[] = {
-	{
-		.name	= "sata base",
-		.start	= SATA_PHYS_BASE,
-		.end	= SATA_PHYS_BASE + 0x5000 - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.name	= "sata irq",
-		.start	= IRQ_KIRKWOOD_SATA,
-		.end	= IRQ_KIRKWOOD_SATA,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device kirkwood_sata = {
-	.name		= "sata_mv",
-	.id		= 0,
-	.dev		= {
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-	.num_resources	= ARRAY_SIZE(kirkwood_sata_resources),
-	.resource	= kirkwood_sata_resources,
-};
-
 void __init kirkwood_sata_init(struct mv_sata_platform_data *sata_data)
 {
 	kirkwood_clk_ctrl |= CGC_SATA0;
 	if (sata_data->n_ports > 1)
 		kirkwood_clk_ctrl |= CGC_SATA1;
-	sata_data->dram = &kirkwood_mbus_dram_info;
-	kirkwood_sata.dev.platform_data = sata_data;
-	platform_device_register(&kirkwood_sata);
+
+	orion_sata_init(sata_data, &kirkwood_mbus_dram_info,
+			SATA_PHYS_BASE, IRQ_KIRKWOOD_SATA);
 }
 
 
diff --git a/arch/arm/mach-mv78xx0/common.c b/arch/arm/mach-mv78xx0/common.c
index f250196..23d3980 100644
--- a/arch/arm/mach-mv78xx0/common.c
+++ b/arch/arm/mach-mv78xx0/common.c
@@ -275,35 +275,10 @@ void __init mv78xx0_i2c_init(void)
 /*****************************************************************************
  * SATA
  ****************************************************************************/
-static struct resource mv78xx0_sata_resources[] = {
-	{
-		.name	= "sata base",
-		.start	= SATA_PHYS_BASE,
-		.end	= SATA_PHYS_BASE + 0x5000 - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.name	= "sata irq",
-		.start	= IRQ_MV78XX0_SATA,
-		.end	= IRQ_MV78XX0_SATA,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mv78xx0_sata = {
-	.name		= "sata_mv",
-	.id		= 0,
-	.dev		= {
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-	.num_resources	= ARRAY_SIZE(mv78xx0_sata_resources),
-	.resource	= mv78xx0_sata_resources,
-};
-
 void __init mv78xx0_sata_init(struct mv_sata_platform_data *sata_data)
 {
-	sata_data->dram = &mv78xx0_mbus_dram_info;
-	mv78xx0_sata.dev.platform_data = sata_data;
-	platform_device_register(&mv78xx0_sata);
+	orion_sata_init(sata_data, &mv78xx0_mbus_dram_info,
+			SATA_PHYS_BASE, IRQ_MV78XX0_SATA);
 }
 
 
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index 2132eaf..8bbf497c 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -119,35 +119,10 @@ void __init orion5x_i2c_init(void)
 /*****************************************************************************
  * SATA
  ****************************************************************************/
-static struct resource orion5x_sata_resources[] = {
-	{
-		.name	= "sata base",
-		.start	= ORION5X_SATA_PHYS_BASE,
-		.end	= ORION5X_SATA_PHYS_BASE + 0x5000 - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.name	= "sata irq",
-		.start	= IRQ_ORION5X_SATA,
-		.end	= IRQ_ORION5X_SATA,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device orion5x_sata = {
-	.name		= "sata_mv",
-	.id		= 0,
-	.dev		= {
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-	.num_resources	= ARRAY_SIZE(orion5x_sata_resources),
-	.resource	= orion5x_sata_resources,
-};
-
 void __init orion5x_sata_init(struct mv_sata_platform_data *sata_data)
 {
-	sata_data->dram = &orion5x_mbus_dram_info;
-	orion5x_sata.dev.platform_data = sata_data;
-	platform_device_register(&orion5x_sata);
+	orion_sata_init(sata_data, &orion5x_mbus_dram_info,
+			ORION5X_SATA_PHYS_BASE, IRQ_ORION5X_SATA);
 }
 
 
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index 802cbf4..d1cf7c3 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -14,6 +14,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/serial_8250.h>
 #include <linux/mbus.h>
+#include <linux/ata_platform.h>
 #include <linux/mv643xx_eth.h>
 #include <linux/mv643xx_i2c.h>
 #include <net/dsa.h>
@@ -889,3 +890,37 @@ void __init orion_ehci_2_init(struct mbus_dram_target_info *mbus_dram_info,
 
 	platform_device_register(&orion_ehci_2);
 }
+
+/*****************************************************************************
+ * SATA
+ ****************************************************************************/
+static struct resource orion_sata_resources[2] = {
+	{
+		.name	= "sata base",
+	}, {
+		.name	= "sata irq",
+	},
+};
+
+static struct platform_device orion_sata = {
+	.name		= "sata_mv",
+	.id		= 0,
+	.dev		= {
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+void __init orion_sata_init(struct mv_sata_platform_data *sata_data,
+			    struct mbus_dram_target_info *mbus_dram_info,
+			    unsigned long mapbase,
+			    unsigned long irq)
+{
+	sata_data->dram = mbus_dram_info;
+	orion_sata.dev.platform_data = sata_data;
+	fill_resources(&orion_sata, orion_sata_resources,
+		       mapbase, 0x5000 - 1, irq);
+
+	platform_device_register(&orion_sata);
+}
+
+
diff --git a/arch/arm/plat-orion/include/plat/common.h b/arch/arm/plat-orion/include/plat/common.h
index 6386f8e..0ec6b66 100644
--- a/arch/arm/plat-orion/include/plat/common.h
+++ b/arch/arm/plat-orion/include/plat/common.h
@@ -104,4 +104,9 @@ void __init orion_ehci_1_init(struct mbus_dram_target_info *mbus_dram_info,
 void __init orion_ehci_2_init(struct mbus_dram_target_info *mbus_dram_info,
 			      unsigned long mapbase,
 			      unsigned long irq);
+
+void __init orion_sata_init(struct mv_sata_platform_data *sata_data,
+			    struct mbus_dram_target_info *mbus_dram_info,
+			    unsigned long mapbase,
+			    unsigned long irq);
 #endif
-- 
1.7.4.4

