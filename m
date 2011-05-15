Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959Ab1EOLeI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:34:08 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59438 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab1EOLeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:34:04 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: kernel@wantstofly.org, nico@fluxnic.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saeed.bishara@gmail.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCHv2 05/15] [orion] Consolidate ethernet platform data
Date: Sun, 15 May 2011 13:32:44 +0200
Message-Id: <1305459174-25517-6-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
References: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-dove/common.c               |   53 +-----
 arch/arm/mach-kirkwood/common.c           |  145 +--------------
 arch/arm/mach-loki/common.c               |  109 +----------
 arch/arm/mach-mv78xx0/common.c            |  218 ++---------------------
 arch/arm/mach-orion5x/common.c            |   85 +---------
 arch/arm/plat-orion/common.c              |  276 +++++++++++++++++++++++++++++
 arch/arm/plat-orion/include/plat/common.h |   35 ++++-
 7 files changed, 348 insertions(+), 573 deletions(-)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 8a414cb..1d878ce 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -16,7 +16,6 @@
 #include <linux/serial_8250.h>
 #include <linux/clk.h>
 #include <linux/mbus.h>
-#include <linux/mv643xx_eth.h>
 #include <linux/mv643xx_i2c.h>
 #include <linux/ata_platform.h>
 #include <linux/serial_8250.h>
@@ -150,56 +149,11 @@ void __init dove_ehci1_init(void)
 /*****************************************************************************
  * GE00
  ****************************************************************************/
-struct mv643xx_eth_shared_platform_data dove_ge00_shared_data = {
-	.t_clk		= 0,
-	.dram		= &dove_mbus_dram_info,
-};
-
-static struct resource dove_ge00_shared_resources[] = {
-	{
-		.name	= "ge00 base",
-		.start	= DOVE_GE00_PHYS_BASE + 0x2000,
-		.end	= DOVE_GE00_PHYS_BASE + SZ_16K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device dove_ge00_shared = {
-	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 0,
-	.dev		= {
-		.platform_data	= &dove_ge00_shared_data,
-	},
-	.num_resources	= 1,
-	.resource	= dove_ge00_shared_resources,
-};
-
-static struct resource dove_ge00_resources[] = {
-	{
-		.name	= "ge00 irq",
-		.start	= IRQ_DOVE_GE00_SUM,
-		.end	= IRQ_DOVE_GE00_SUM,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device dove_ge00 = {
-	.name		= MV643XX_ETH_NAME,
-	.id		= 0,
-	.num_resources	= 1,
-	.resource	= dove_ge00_resources,
-	.dev		= {
-		.coherent_dma_mask	= 0xffffffff,
-	},
-};
-
 void __init dove_ge00_init(struct mv643xx_eth_platform_data *eth_data)
 {
-	eth_data->shared = &dove_ge00_shared;
-	dove_ge00.dev.platform_data = eth_data;
-
-	platform_device_register(&dove_ge00_shared);
-	platform_device_register(&dove_ge00);
+	orion_ge00_init(eth_data, &dove_mbus_dram_info,
+			DOVE_GE00_PHYS_BASE, IRQ_DOVE_GE00_SUM,
+			0, get_tclk());
 }
 
 /*****************************************************************************
@@ -690,7 +644,6 @@ void __init dove_init(void)
 #endif
 	dove_setup_cpu_mbus();
 
-	dove_ge00_shared_data.t_clk = tclk;
 	dove_spi0_data.tclk = tclk;
 	dove_spi1_data.tclk = tclk;
 
diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index f6868fc..485f3b9 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -13,7 +13,6 @@
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
 #include <linux/mbus.h>
-#include <linux/mv643xx_eth.h>
 #include <linux/mv643xx_i2c.h>
 #include <linux/ata_platform.h>
 #include <linux/mtd/nand.h>
@@ -70,7 +69,7 @@ void __init kirkwood_map_io(void)
  * registered.  Some reserved bits must be set to 1.
  */
 unsigned int kirkwood_clk_ctrl = CGC_DUNIT | CGC_RESERVED;
-	
+
 
 /*****************************************************************************
  * EHCI
@@ -120,160 +119,36 @@ void __init kirkwood_ehci_init(void)
 /*****************************************************************************
  * GE00
  ****************************************************************************/
-struct mv643xx_eth_shared_platform_data kirkwood_ge00_shared_data = {
-	.dram		= &kirkwood_mbus_dram_info,
-};
-
-static struct resource kirkwood_ge00_shared_resources[] = {
-	{
-		.name	= "ge00 base",
-		.start	= GE00_PHYS_BASE + 0x2000,
-		.end	= GE00_PHYS_BASE + SZ_16K - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.name	= "ge00 err irq",
-		.start	= IRQ_KIRKWOOD_GE00_ERR,
-		.end	= IRQ_KIRKWOOD_GE00_ERR,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device kirkwood_ge00_shared = {
-	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 0,
-	.dev		= {
-		.platform_data	= &kirkwood_ge00_shared_data,
-	},
-	.num_resources	= ARRAY_SIZE(kirkwood_ge00_shared_resources),
-	.resource	= kirkwood_ge00_shared_resources,
-};
-
-static struct resource kirkwood_ge00_resources[] = {
-	{
-		.name	= "ge00 irq",
-		.start	= IRQ_KIRKWOOD_GE00_SUM,
-		.end	= IRQ_KIRKWOOD_GE00_SUM,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device kirkwood_ge00 = {
-	.name		= MV643XX_ETH_NAME,
-	.id		= 0,
-	.num_resources	= 1,
-	.resource	= kirkwood_ge00_resources,
-	.dev		= {
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-
 void __init kirkwood_ge00_init(struct mv643xx_eth_platform_data *eth_data)
 {
 	kirkwood_clk_ctrl |= CGC_GE0;
-	eth_data->shared = &kirkwood_ge00_shared;
-	kirkwood_ge00.dev.platform_data = eth_data;
 
-	platform_device_register(&kirkwood_ge00_shared);
-	platform_device_register(&kirkwood_ge00);
+	orion_ge00_init(eth_data, &kirkwood_mbus_dram_info,
+			GE00_PHYS_BASE, IRQ_KIRKWOOD_GE00_SUM,
+			IRQ_KIRKWOOD_GE00_ERR, kirkwood_tclk);
 }
 
 
 /*****************************************************************************
  * GE01
  ****************************************************************************/
-struct mv643xx_eth_shared_platform_data kirkwood_ge01_shared_data = {
-	.dram		= &kirkwood_mbus_dram_info,
-	.shared_smi	= &kirkwood_ge00_shared,
-};
-
-static struct resource kirkwood_ge01_shared_resources[] = {
-	{
-		.name	= "ge01 base",
-		.start	= GE01_PHYS_BASE + 0x2000,
-		.end	= GE01_PHYS_BASE + SZ_16K - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.name	= "ge01 err irq",
-		.start	= IRQ_KIRKWOOD_GE01_ERR,
-		.end	= IRQ_KIRKWOOD_GE01_ERR,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device kirkwood_ge01_shared = {
-	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 1,
-	.dev		= {
-		.platform_data	= &kirkwood_ge01_shared_data,
-	},
-	.num_resources	= ARRAY_SIZE(kirkwood_ge01_shared_resources),
-	.resource	= kirkwood_ge01_shared_resources,
-};
-
-static struct resource kirkwood_ge01_resources[] = {
-	{
-		.name	= "ge01 irq",
-		.start	= IRQ_KIRKWOOD_GE01_SUM,
-		.end	= IRQ_KIRKWOOD_GE01_SUM,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device kirkwood_ge01 = {
-	.name		= MV643XX_ETH_NAME,
-	.id		= 1,
-	.num_resources	= 1,
-	.resource	= kirkwood_ge01_resources,
-	.dev		= {
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-
 void __init kirkwood_ge01_init(struct mv643xx_eth_platform_data *eth_data)
 {
+
 	kirkwood_clk_ctrl |= CGC_GE1;
-	eth_data->shared = &kirkwood_ge01_shared;
-	kirkwood_ge01.dev.platform_data = eth_data;
 
-	platform_device_register(&kirkwood_ge01_shared);
-	platform_device_register(&kirkwood_ge01);
+	orion_ge01_init(eth_data, &kirkwood_mbus_dram_info,
+			GE01_PHYS_BASE, IRQ_KIRKWOOD_GE01_SUM,
+			IRQ_KIRKWOOD_GE01_ERR, kirkwood_tclk);
 }
 
 
 /*****************************************************************************
  * Ethernet switch
  ****************************************************************************/
-static struct resource kirkwood_switch_resources[] = {
-	{
-		.start	= 0,
-		.end	= 0,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device kirkwood_switch_device = {
-	.name		= "dsa",
-	.id		= 0,
-	.num_resources	= 0,
-	.resource	= kirkwood_switch_resources,
-};
-
 void __init kirkwood_ge00_switch_init(struct dsa_platform_data *d, int irq)
 {
-	int i;
-
-	if (irq != NO_IRQ) {
-		kirkwood_switch_resources[0].start = irq;
-		kirkwood_switch_resources[0].end = irq;
-		kirkwood_switch_device.num_resources = 1;
-	}
-
-	d->netdev = &kirkwood_ge00.dev;
-	for (i = 0; i < d->nr_chips; i++)
-		d->chip[i].mii_bus = &kirkwood_ge00_shared.dev;
-	kirkwood_switch_device.dev.platform_data = d;
-
-	platform_device_register(&kirkwood_switch_device);
+	orion_ge00_switch_init(d, irq);
 }
 
 
@@ -911,8 +786,6 @@ void __init kirkwood_init(void)
 {
 	printk(KERN_INFO "Kirkwood: %s, TCLK=%d.\n",
 		kirkwood_id(), kirkwood_tclk);
-	kirkwood_ge00_shared_data.t_clk = kirkwood_tclk;
-	kirkwood_ge01_shared_data.t_clk = kirkwood_tclk;
 	kirkwood_spi_plat_data.tclk = kirkwood_tclk;
 	kirkwood_i2s_data.tclk = kirkwood_tclk;
 
diff --git a/arch/arm/mach-loki/common.c b/arch/arm/mach-loki/common.c
index c071804..5f02664 100644
--- a/arch/arm/mach-loki/common.c
+++ b/arch/arm/mach-loki/common.c
@@ -13,7 +13,6 @@
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
 #include <linux/mbus.h>
-#include <linux/mv643xx_eth.h>
 #include <linux/dma-mapping.h>
 #include <asm/page.h>
 #include <asm/timex.h>
@@ -45,116 +44,28 @@ void __init loki_map_io(void)
 
 
 /*****************************************************************************
- * GE0
+ * GE00
  ****************************************************************************/
-struct mv643xx_eth_shared_platform_data loki_ge0_shared_data = {
-	.t_clk		= LOKI_TCLK,
-	.dram		= &loki_mbus_dram_info,
-};
-
-static struct resource loki_ge0_shared_resources[] = {
-	{
-		.name	= "ge0 base",
-		.start	= GE0_PHYS_BASE + 0x2000,
-		.end	= GE0_PHYS_BASE + SZ_16K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device loki_ge0_shared = {
-	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 0,
-	.dev		= {
-		.platform_data	= &loki_ge0_shared_data,
-	},
-	.num_resources	= 1,
-	.resource	= loki_ge0_shared_resources,
-};
-
-static struct resource loki_ge0_resources[] = {
-	{
-		.name	= "ge0 irq",
-		.start	= IRQ_LOKI_GBE_A_INT,
-		.end	= IRQ_LOKI_GBE_A_INT,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device loki_ge0 = {
-	.name		= MV643XX_ETH_NAME,
-	.id		= 0,
-	.num_resources	= 1,
-	.resource	= loki_ge0_resources,
-	.dev		= {
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-
 void __init loki_ge0_init(struct mv643xx_eth_platform_data *eth_data)
 {
-	eth_data->shared = &loki_ge0_shared;
-	loki_ge0.dev.platform_data = eth_data;
-
 	writel(0x00079220, GE0_VIRT_BASE + 0x20b0);
-	platform_device_register(&loki_ge0_shared);
-	platform_device_register(&loki_ge0);
+
+	orion_ge00_init(eth_data, &loki_mbus_dram_info,
+			GE0_PHYS_BASE, IRQ_LOKI_GBE_A_INT,
+			0, LOKI_TCLK);
 }
 
 
 /*****************************************************************************
- * GE1
+ * GE01
  ****************************************************************************/
-struct mv643xx_eth_shared_platform_data loki_ge1_shared_data = {
-	.t_clk		= LOKI_TCLK,
-	.dram		= &loki_mbus_dram_info,
-};
-
-static struct resource loki_ge1_shared_resources[] = {
-	{
-		.name	= "ge1 base",
-		.start	= GE1_PHYS_BASE + 0x2000,
-		.end	= GE1_PHYS_BASE + SZ_16K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device loki_ge1_shared = {
-	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 1,
-	.dev		= {
-		.platform_data	= &loki_ge1_shared_data,
-	},
-	.num_resources	= 1,
-	.resource	= loki_ge1_shared_resources,
-};
-
-static struct resource loki_ge1_resources[] = {
-	{
-		.name	= "ge1 irq",
-		.start	= IRQ_LOKI_GBE_B_INT,
-		.end	= IRQ_LOKI_GBE_B_INT,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device loki_ge1 = {
-	.name		= MV643XX_ETH_NAME,
-	.id		= 1,
-	.num_resources	= 1,
-	.resource	= loki_ge1_resources,
-	.dev		= {
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-
 void __init loki_ge1_init(struct mv643xx_eth_platform_data *eth_data)
 {
-	eth_data->shared = &loki_ge1_shared;
-	loki_ge1.dev.platform_data = eth_data;
-
 	writel(0x00079220, GE1_VIRT_BASE + 0x20b0);
-	platform_device_register(&loki_ge1_shared);
-	platform_device_register(&loki_ge1);
+
+	orion_ge01_init(eth_data, &loki_mbus_dram_info,
+			GE1_PHYS_BASE, IRQ_LOKI_GBE_B_INT,
+			0, LOKI_TCLK);
 }
 
 
diff --git a/arch/arm/mach-mv78xx0/common.c b/arch/arm/mach-mv78xx0/common.c
index 5b474e4..0fd9a83 100644
--- a/arch/arm/mach-mv78xx0/common.c
+++ b/arch/arm/mach-mv78xx0/common.c
@@ -13,7 +13,6 @@
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
 #include <linux/mbus.h>
-#include <linux/mv643xx_eth.h>
 #include <linux/mv643xx_i2c.h>
 #include <linux/ata_platform.h>
 #include <linux/ethtool.h>
@@ -280,175 +279,32 @@ void __init mv78xx0_ehci2_init(void)
 /*****************************************************************************
  * GE00
  ****************************************************************************/
-struct mv643xx_eth_shared_platform_data mv78xx0_ge00_shared_data = {
-	.t_clk		= 0,
-	.dram		= &mv78xx0_mbus_dram_info,
-};
-
-static struct resource mv78xx0_ge00_shared_resources[] = {
-	{
-		.name	= "ge00 base",
-		.start	= GE00_PHYS_BASE + 0x2000,
-		.end	= GE00_PHYS_BASE + SZ_16K - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.name	= "ge err irq",
-		.start	= IRQ_MV78XX0_GE_ERR,
-		.end	= IRQ_MV78XX0_GE_ERR,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mv78xx0_ge00_shared = {
-	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 0,
-	.dev		= {
-		.platform_data	= &mv78xx0_ge00_shared_data,
-	},
-	.num_resources	= ARRAY_SIZE(mv78xx0_ge00_shared_resources),
-	.resource	= mv78xx0_ge00_shared_resources,
-};
-
-static struct resource mv78xx0_ge00_resources[] = {
-	{
-		.name	= "ge00 irq",
-		.start	= IRQ_MV78XX0_GE00_SUM,
-		.end	= IRQ_MV78XX0_GE00_SUM,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mv78xx0_ge00 = {
-	.name		= MV643XX_ETH_NAME,
-	.id		= 0,
-	.num_resources	= 1,
-	.resource	= mv78xx0_ge00_resources,
-	.dev		= {
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-
 void __init mv78xx0_ge00_init(struct mv643xx_eth_platform_data *eth_data)
 {
-	eth_data->shared = &mv78xx0_ge00_shared;
-	mv78xx0_ge00.dev.platform_data = eth_data;
-
-	platform_device_register(&mv78xx0_ge00_shared);
-	platform_device_register(&mv78xx0_ge00);
+	orion_ge00_init(eth_data, &mv78xx0_mbus_dram_info,
+			GE00_PHYS_BASE, IRQ_MV78XX0_GE00_SUM,
+			IRQ_MV78XX0_GE_ERR, get_tclk());
 }
 
 
 /*****************************************************************************
  * GE01
  ****************************************************************************/
-struct mv643xx_eth_shared_platform_data mv78xx0_ge01_shared_data = {
-	.t_clk		= 0,
-	.dram		= &mv78xx0_mbus_dram_info,
-	.shared_smi	= &mv78xx0_ge00_shared,
-};
-
-static struct resource mv78xx0_ge01_shared_resources[] = {
-	{
-		.name	= "ge01 base",
-		.start	= GE01_PHYS_BASE + 0x2000,
-		.end	= GE01_PHYS_BASE + SZ_16K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device mv78xx0_ge01_shared = {
-	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 1,
-	.dev		= {
-		.platform_data	= &mv78xx0_ge01_shared_data,
-	},
-	.num_resources	= 1,
-	.resource	= mv78xx0_ge01_shared_resources,
-};
-
-static struct resource mv78xx0_ge01_resources[] = {
-	{
-		.name	= "ge01 irq",
-		.start	= IRQ_MV78XX0_GE01_SUM,
-		.end	= IRQ_MV78XX0_GE01_SUM,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mv78xx0_ge01 = {
-	.name		= MV643XX_ETH_NAME,
-	.id		= 1,
-	.num_resources	= 1,
-	.resource	= mv78xx0_ge01_resources,
-	.dev		= {
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-
 void __init mv78xx0_ge01_init(struct mv643xx_eth_platform_data *eth_data)
 {
-	eth_data->shared = &mv78xx0_ge01_shared;
-	mv78xx0_ge01.dev.platform_data = eth_data;
-
-	platform_device_register(&mv78xx0_ge01_shared);
-	platform_device_register(&mv78xx0_ge01);
+	orion_ge01_init(eth_data, &mv78xx0_mbus_dram_info,
+			GE01_PHYS_BASE, IRQ_MV78XX0_GE01_SUM,
+			NO_IRQ, get_tclk());
 }
 
 
 /*****************************************************************************
  * GE10
  ****************************************************************************/
-struct mv643xx_eth_shared_platform_data mv78xx0_ge10_shared_data = {
-	.t_clk		= 0,
-	.dram		= &mv78xx0_mbus_dram_info,
-	.shared_smi	= &mv78xx0_ge00_shared,
-};
-
-static struct resource mv78xx0_ge10_shared_resources[] = {
-	{
-		.name	= "ge10 base",
-		.start	= GE10_PHYS_BASE + 0x2000,
-		.end	= GE10_PHYS_BASE + SZ_16K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device mv78xx0_ge10_shared = {
-	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 2,
-	.dev		= {
-		.platform_data	= &mv78xx0_ge10_shared_data,
-	},
-	.num_resources	= 1,
-	.resource	= mv78xx0_ge10_shared_resources,
-};
-
-static struct resource mv78xx0_ge10_resources[] = {
-	{
-		.name	= "ge10 irq",
-		.start	= IRQ_MV78XX0_GE10_SUM,
-		.end	= IRQ_MV78XX0_GE10_SUM,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mv78xx0_ge10 = {
-	.name		= MV643XX_ETH_NAME,
-	.id		= 2,
-	.num_resources	= 1,
-	.resource	= mv78xx0_ge10_resources,
-	.dev		= {
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-
 void __init mv78xx0_ge10_init(struct mv643xx_eth_platform_data *eth_data)
 {
 	u32 dev, rev;
 
-	eth_data->shared = &mv78xx0_ge10_shared;
-	mv78xx0_ge10.dev.platform_data = eth_data;
-
 	/*
 	 * On the Z0, ge10 and ge11 are internally connected back
 	 * to back, and not brought out.
@@ -460,65 +316,19 @@ void __init mv78xx0_ge10_init(struct mv643xx_eth_platform_data *eth_data)
 		eth_data->duplex = DUPLEX_FULL;
 	}
 
-	platform_device_register(&mv78xx0_ge10_shared);
-	platform_device_register(&mv78xx0_ge10);
+	orion_ge10_init(eth_data, &mv78xx0_mbus_dram_info,
+			GE10_PHYS_BASE, IRQ_MV78XX0_GE10_SUM,
+			NO_IRQ, get_tclk());
 }
 
 
 /*****************************************************************************
  * GE11
  ****************************************************************************/
-struct mv643xx_eth_shared_platform_data mv78xx0_ge11_shared_data = {
-	.t_clk		= 0,
-	.dram		= &mv78xx0_mbus_dram_info,
-	.shared_smi	= &mv78xx0_ge00_shared,
-};
-
-static struct resource mv78xx0_ge11_shared_resources[] = {
-	{
-		.name	= "ge11 base",
-		.start	= GE11_PHYS_BASE + 0x2000,
-		.end	= GE11_PHYS_BASE + SZ_16K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device mv78xx0_ge11_shared = {
-	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 3,
-	.dev		= {
-		.platform_data	= &mv78xx0_ge11_shared_data,
-	},
-	.num_resources	= 1,
-	.resource	= mv78xx0_ge11_shared_resources,
-};
-
-static struct resource mv78xx0_ge11_resources[] = {
-	{
-		.name	= "ge11 irq",
-		.start	= IRQ_MV78XX0_GE11_SUM,
-		.end	= IRQ_MV78XX0_GE11_SUM,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mv78xx0_ge11 = {
-	.name		= MV643XX_ETH_NAME,
-	.id		= 3,
-	.num_resources	= 1,
-	.resource	= mv78xx0_ge11_resources,
-	.dev		= {
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-
 void __init mv78xx0_ge11_init(struct mv643xx_eth_platform_data *eth_data)
 {
 	u32 dev, rev;
 
-	eth_data->shared = &mv78xx0_ge11_shared;
-	mv78xx0_ge11.dev.platform_data = eth_data;
-
 	/*
 	 * On the Z0, ge10 and ge11 are internally connected back
 	 * to back, and not brought out.
@@ -530,8 +340,9 @@ void __init mv78xx0_ge11_init(struct mv643xx_eth_platform_data *eth_data)
 		eth_data->duplex = DUPLEX_FULL;
 	}
 
-	platform_device_register(&mv78xx0_ge11_shared);
-	platform_device_register(&mv78xx0_ge11);
+	orion_ge11_init(eth_data, &mv78xx0_mbus_dram_info,
+			GE11_PHYS_BASE, IRQ_MV78XX0_GE11_SUM,
+			NO_IRQ, get_tclk());
 }
 
 /*****************************************************************************
@@ -759,9 +570,4 @@ void __init mv78xx0_init(void)
 #ifdef CONFIG_CACHE_FEROCEON_L2
 	feroceon_l2_init(is_l2_writethrough());
 #endif
-
-	mv78xx0_ge00_shared_data.t_clk = tclk;
-	mv78xx0_ge01_shared_data.t_clk = tclk;
-	mv78xx0_ge10_shared_data.t_clk = tclk;
-	mv78xx0_ge11_shared_data.t_clk = tclk;
 }
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index 310de50..0a1c760 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -15,7 +15,6 @@
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
 #include <linux/mbus.h>
-#include <linux/mv643xx_eth.h>
 #include <linux/mv643xx_i2c.h>
 #include <linux/ata_platform.h>
 #include <linux/spi/orion_spi.h>
@@ -150,95 +149,20 @@ void __init orion5x_ehci1_init(void)
 /*****************************************************************************
  * GE00
  ****************************************************************************/
-struct mv643xx_eth_shared_platform_data orion5x_ge00_shared_data = {
-	.dram		= &orion5x_mbus_dram_info,
-};
-
-static struct resource orion5x_ge00_shared_resources[] = {
-	{
-		.start	= ORION5X_ETH_PHYS_BASE + 0x2000,
-		.end	= ORION5X_ETH_PHYS_BASE + SZ_16K - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= IRQ_ORION5X_ETH_ERR,
-		.end	= IRQ_ORION5X_ETH_ERR,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device orion5x_ge00_shared = {
-	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 0,
-	.dev		= {
-		.platform_data	= &orion5x_ge00_shared_data,
-	},
-	.num_resources	= ARRAY_SIZE(orion5x_ge00_shared_resources),
-	.resource	= orion5x_ge00_shared_resources,
-};
-
-static struct resource orion5x_ge00_resources[] = {
-	{
-		.name	= "eth irq",
-		.start	= IRQ_ORION5X_ETH_SUM,
-		.end	= IRQ_ORION5X_ETH_SUM,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device orion5x_eth = {
-	.name		= MV643XX_ETH_NAME,
-	.id		= 0,
-	.num_resources	= 1,
-	.resource	= orion5x_ge00_resources,
-	.dev		= {
-		.coherent_dma_mask	= DMA_BIT_MASK(32),
-	},
-};
-
 void __init orion5x_eth_init(struct mv643xx_eth_platform_data *eth_data)
 {
-	eth_data->shared = &orion5x_ge00_shared;
-	orion5x_eth.dev.platform_data = eth_data;
-
-	platform_device_register(&orion5x_ge00_shared);
-	platform_device_register(&orion5x_eth);
+	orion_ge00_init(eth_data, &orion5x_mbus_dram_info,
+			ORION5X_ETH_PHYS_BASE, IRQ_ORION5X_ETH_SUM,
+			IRQ_ORION5X_ETH_ERR, orion5x_tclk);
 }
 
 
 /*****************************************************************************
  * Ethernet switch
  ****************************************************************************/
-static struct resource orion5x_switch_resources[] = {
-	{
-		.start	= 0,
-		.end	= 0,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device orion5x_switch_device = {
-	.name		= "dsa",
-	.id		= 0,
-	.num_resources	= 0,
-	.resource	= orion5x_switch_resources,
-};
-
 void __init orion5x_eth_switch_init(struct dsa_platform_data *d, int irq)
 {
-	int i;
-
-	if (irq != NO_IRQ) {
-		orion5x_switch_resources[0].start = irq;
-		orion5x_switch_resources[0].end = irq;
-		orion5x_switch_device.num_resources = 1;
-	}
-
-	d->netdev = &orion5x_eth.dev;
-	for (i = 0; i < d->nr_chips; i++)
-		d->chip[i].mii_bus = &orion5x_ge00_shared.dev;
-	orion5x_switch_device.dev.platform_data = d;
-
-	platform_device_register(&orion5x_switch_device);
+	orion_ge00_switch_init(d, irq);
 }
 
 
@@ -616,7 +540,6 @@ void __init orion5x_init(void)
 	orion5x_id(&dev, &rev, &dev_name);
 	printk(KERN_INFO "Orion ID: %s. TCLK=%d.\n", dev_name, orion5x_tclk);
 
-	orion5x_ge00_shared_data.t_clk = orion5x_tclk;
 	orion5x_spi_plat_data.tclk = orion5x_tclk;
 
 	/*
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index d065591..15c3f35 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -11,7 +11,11 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
 #include <linux/serial_8250.h>
+#include <linux/mbus.h>
+#include <linux/mv643xx_eth.h>
+#include <net/dsa.h>
 
 /* Fill in the resources structure and link it into the platform
    device structure. There is always a memory region, and nearly
@@ -187,3 +191,275 @@ void __init orion_rtc_init(unsigned long mapbase,
 
 	platform_device_register_simple("rtc-mv", -1, orion_rtc_resource, 2);
 }
+
+/*****************************************************************************
+ * GE
+ ****************************************************************************/
+static __init void ge_complete(
+	struct mv643xx_eth_shared_platform_data *orion_ge_shared_data,
+	struct mbus_dram_target_info *mbus_dram_info, int tclk,
+	struct resource *orion_ge_resource, unsigned long irq,
+	struct platform_device *orion_ge_shared,
+	struct mv643xx_eth_platform_data *eth_data,
+	struct platform_device *orion_ge)
+{
+	orion_ge_shared_data->dram = mbus_dram_info;
+	orion_ge_shared_data->t_clk = tclk;
+	orion_ge_resource->start = irq;
+	orion_ge_resource->end = irq;
+	eth_data->shared = orion_ge_shared;
+	orion_ge->dev.platform_data = eth_data;
+
+	platform_device_register(orion_ge_shared);
+	platform_device_register(orion_ge);
+}
+
+/*****************************************************************************
+ * GE00
+ ****************************************************************************/
+struct mv643xx_eth_shared_platform_data orion_ge00_shared_data;
+
+static struct resource orion_ge00_shared_resources[] = {
+	{
+		.name	= "ge00 base",
+	}, {
+		.name	= "ge00 err irq",
+	},
+};
+
+static struct platform_device orion_ge00_shared = {
+	.name		= MV643XX_ETH_SHARED_NAME,
+	.id		= 0,
+	.dev		= {
+		.platform_data	= &orion_ge00_shared_data,
+	},
+};
+
+static struct resource orion_ge00_resources[] = {
+	{
+		.name	= "ge00 irq",
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device orion_ge00 = {
+	.name		= MV643XX_ETH_NAME,
+	.id		= 0,
+	.num_resources	= 1,
+	.resource	= orion_ge00_resources,
+	.dev		= {
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+void __init orion_ge00_init(struct mv643xx_eth_platform_data *eth_data,
+			    struct mbus_dram_target_info *mbus_dram_info,
+			    unsigned long mapbase,
+			    unsigned long irq,
+			    unsigned long irq_err,
+			    int tclk)
+{
+	fill_resources(&orion_ge00_shared, orion_ge00_shared_resources,
+		       mapbase + 0x2000, SZ_16K - 1, irq_err);
+	ge_complete(&orion_ge00_shared_data, mbus_dram_info, tclk,
+		    orion_ge00_resources, irq, &orion_ge00_shared,
+		    eth_data, &orion_ge00);
+}
+
+/*****************************************************************************
+ * GE01
+ ****************************************************************************/
+struct mv643xx_eth_shared_platform_data orion_ge01_shared_data = {
+	.shared_smi	= &orion_ge00_shared,
+};
+
+static struct resource orion_ge01_shared_resources[] = {
+	{
+		.name	= "ge01 base",
+	}, {
+		.name	= "ge01 err irq",
+	},
+};
+
+static struct platform_device orion_ge01_shared = {
+	.name		= MV643XX_ETH_SHARED_NAME,
+	.id		= 1,
+	.dev		= {
+		.platform_data	= &orion_ge01_shared_data,
+	},
+};
+
+static struct resource orion_ge01_resources[] = {
+	{
+		.name	= "ge01 irq",
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device orion_ge01 = {
+	.name		= MV643XX_ETH_NAME,
+	.id		= 1,
+	.num_resources	= 1,
+	.resource	= orion_ge01_resources,
+	.dev		= {
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+void __init orion_ge01_init(struct mv643xx_eth_platform_data *eth_data,
+			    struct mbus_dram_target_info *mbus_dram_info,
+			    unsigned long mapbase,
+			    unsigned long irq,
+			    unsigned long irq_err,
+			    int tclk)
+{
+	fill_resources(&orion_ge01_shared, orion_ge01_shared_resources,
+		       mapbase + 0x2000, SZ_16K - 1, irq_err);
+	ge_complete(&orion_ge01_shared_data, mbus_dram_info, tclk,
+		    orion_ge01_resources, irq, &orion_ge01_shared,
+		    eth_data, &orion_ge01);
+}
+
+/*****************************************************************************
+ * GE10
+ ****************************************************************************/
+struct mv643xx_eth_shared_platform_data orion_ge10_shared_data = {
+	.shared_smi	= &orion_ge00_shared,
+};
+
+static struct resource orion_ge10_shared_resources[] = {
+	{
+		.name	= "ge10 base",
+	}, {
+		.name	= "ge10 err irq",
+	},
+};
+
+static struct platform_device orion_ge10_shared = {
+	.name		= MV643XX_ETH_SHARED_NAME,
+	.id		= 1,
+	.dev		= {
+		.platform_data	= &orion_ge10_shared_data,
+	},
+};
+
+static struct resource orion_ge10_resources[] = {
+	{
+		.name	= "ge10 irq",
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device orion_ge10 = {
+	.name		= MV643XX_ETH_NAME,
+	.id		= 1,
+	.num_resources	= 2,
+	.resource	= orion_ge10_resources,
+	.dev		= {
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+void __init orion_ge10_init(struct mv643xx_eth_platform_data *eth_data,
+			    struct mbus_dram_target_info *mbus_dram_info,
+			    unsigned long mapbase,
+			    unsigned long irq,
+			    unsigned long irq_err,
+			    int tclk)
+{
+	fill_resources(&orion_ge10_shared, orion_ge10_shared_resources,
+		       mapbase + 0x2000, SZ_16K - 1, irq_err);
+	ge_complete(&orion_ge10_shared_data, mbus_dram_info, tclk,
+		    orion_ge10_resources, irq, &orion_ge10_shared,
+		    eth_data, &orion_ge10);
+}
+
+/*****************************************************************************
+ * GE11
+ ****************************************************************************/
+struct mv643xx_eth_shared_platform_data orion_ge11_shared_data = {
+	.shared_smi	= &orion_ge00_shared,
+};
+
+static struct resource orion_ge11_shared_resources[] = {
+	{
+		.name	= "ge11 base",
+	}, {
+		.name	= "ge11 err irq",
+	},
+};
+
+static struct platform_device orion_ge11_shared = {
+	.name		= MV643XX_ETH_SHARED_NAME,
+	.id		= 1,
+	.dev		= {
+		.platform_data	= &orion_ge11_shared_data,
+	},
+};
+
+static struct resource orion_ge11_resources[] = {
+	{
+		.name	= "ge11 irq",
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device orion_ge11 = {
+	.name		= MV643XX_ETH_NAME,
+	.id		= 1,
+	.num_resources	= 2,
+	.resource	= orion_ge11_resources,
+	.dev		= {
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+void __init orion_ge11_init(struct mv643xx_eth_platform_data *eth_data,
+			    struct mbus_dram_target_info *mbus_dram_info,
+			    unsigned long mapbase,
+			    unsigned long irq,
+			    unsigned long irq_err,
+			    int tclk)
+{
+	fill_resources(&orion_ge11_shared, orion_ge11_shared_resources,
+		       mapbase + 0x2000, SZ_16K - 1, irq_err);
+	ge_complete(&orion_ge11_shared_data, mbus_dram_info, tclk,
+		    orion_ge11_resources, irq, &orion_ge11_shared,
+		    eth_data, &orion_ge11);
+}
+
+/*****************************************************************************
+ * Ethernet switch
+ ****************************************************************************/
+static struct resource orion_switch_resources[] = {
+	{
+		.start	= 0,
+		.end	= 0,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device orion_switch_device = {
+	.name		= "dsa",
+	.id		= 0,
+	.num_resources	= 0,
+	.resource	= orion_switch_resources,
+};
+
+void __init orion_ge00_switch_init(struct dsa_platform_data *d, int irq)
+{
+	int i;
+
+	if (irq != NO_IRQ) {
+		orion_switch_resources[0].start = irq;
+		orion_switch_resources[0].end = irq;
+		orion_switch_device.num_resources = 1;
+	}
+
+	d->netdev = &orion_ge00.dev;
+	for (i = 0; i < d->nr_chips; i++)
+		d->chip[i].mii_bus = &orion_ge00_shared.dev;
+	orion_switch_device.dev.platform_data = d;
+
+	platform_device_register(&orion_switch_device);
+}
diff --git a/arch/arm/plat-orion/include/plat/common.h b/arch/arm/plat-orion/include/plat/common.h
index 7cba5e8..3f23258 100644
--- a/arch/arm/plat-orion/include/plat/common.h
+++ b/arch/arm/plat-orion/include/plat/common.h
@@ -9,7 +9,9 @@
  */
 
 #ifndef __PLAT_COMMON_H
+#include <linux/mv643xx_eth.h>
 
+struct dsa_platform_data;
 
 void __init orion_uart0_init(unsigned int membase,
 			     resource_size_t mapbase,
@@ -33,5 +35,36 @@ void __init orion_uart3_init(unsigned int membase,
 
 void __init orion_rtc_init(unsigned long mapbase,
 			   unsigned long irq);
-#endif
 
+void __init orion_ge00_init(struct mv643xx_eth_platform_data *eth_data,
+			    struct mbus_dram_target_info *mbus_dram_info,
+			    unsigned long mapbase,
+			    unsigned long irq,
+			    unsigned long irq_err,
+			    int tclk);
+
+void __init orion_ge01_init(struct mv643xx_eth_platform_data *eth_data,
+			    struct mbus_dram_target_info *mbus_dram_info,
+			    unsigned long mapbase,
+			    unsigned long irq,
+			    unsigned long irq_err,
+			    int tclk);
+
+void __init orion_ge10_init(struct mv643xx_eth_platform_data *eth_data,
+			    struct mbus_dram_target_info *mbus_dram_info,
+			    unsigned long mapbase,
+			    unsigned long irq,
+			    unsigned long irq_err,
+			    int tclk);
+
+void __init orion_ge11_init(struct mv643xx_eth_platform_data *eth_data,
+			    struct mbus_dram_target_info *mbus_dram_info,
+			    unsigned long mapbase,
+			    unsigned long irq,
+			    unsigned long irq_err,
+			    int tclk);
+
+void __init orion_ge00_switch_init(struct dsa_platform_data *d,
+				   int irq);
+
+#endif
-- 
1.7.4.4

