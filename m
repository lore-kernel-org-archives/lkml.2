Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978Ab1EOLeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:34:50 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59465 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759536Ab1EOLes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:34:48 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: kernel@wantstofly.org, nico@fluxnic.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saeed.bishara@gmail.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCHv2 07/15] [orion] Consolidate SPI initialization.
Date: Sun, 15 May 2011 13:32:46 +0200
Message-Id: <1305459174-25517-8-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
References: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change removes the interrupt resource. The driver does not use
it.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-dove/common.c               |   65 +---------------------------
 arch/arm/mach-kirkwood/common.c           |   25 +-----------
 arch/arm/mach-orion5x/common.c            |   29 +------------
 arch/arm/plat-orion/common.c              |   47 +++++++++++++++++++++
 arch/arm/plat-orion/include/plat/common.h |    6 +++
 5 files changed, 58 insertions(+), 114 deletions(-)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 198760b..e3e043c 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -18,7 +18,6 @@
 #include <linux/mbus.h>
 #include <linux/ata_platform.h>
 #include <linux/serial_8250.h>
-#include <linux/spi/orion_spi.h>
 #include <linux/gpio.h>
 #include <asm/page.h>
 #include <asm/setup.h>
@@ -234,71 +233,16 @@ void __init dove_uart3_init(void)
 }
 
 /*****************************************************************************
- * SPI0
+ * SPI
  ****************************************************************************/
-static struct orion_spi_info dove_spi0_data = {
-	.tclk		= 0,
-};
-
-static struct resource dove_spi0_resources[] = {
-	{
-		.start	= DOVE_SPI0_PHYS_BASE,
-		.end	= DOVE_SPI0_PHYS_BASE + SZ_512 - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= IRQ_DOVE_SPI0,
-		.end	= IRQ_DOVE_SPI0,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device dove_spi0 = {
-	.name		= "orion_spi",
-	.id		= 0,
-	.resource	= dove_spi0_resources,
-	.dev		= {
-		.platform_data	= &dove_spi0_data,
-	},
-	.num_resources	= ARRAY_SIZE(dove_spi0_resources),
-};
-
 void __init dove_spi0_init(void)
 {
-	platform_device_register(&dove_spi0);
+	orion_spi_init(DOVE_SPI0_PHYS_BASE, get_tclk());
 }
 
-/*****************************************************************************
- * SPI1
- ****************************************************************************/
-static struct orion_spi_info dove_spi1_data = {
-	.tclk		= 0,
-};
-
-static struct resource dove_spi1_resources[] = {
-	{
-		.start	= DOVE_SPI1_PHYS_BASE,
-		.end	= DOVE_SPI1_PHYS_BASE + SZ_512 - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= IRQ_DOVE_SPI1,
-		.end	= IRQ_DOVE_SPI1,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device dove_spi1 = {
-	.name		= "orion_spi",
-	.id		= 1,
-	.resource	= dove_spi1_resources,
-	.dev		= {
-		.platform_data	= &dove_spi1_data,
-	},
-	.num_resources	= ARRAY_SIZE(dove_spi1_resources),
-};
-
 void __init dove_spi1_init(void)
 {
-	platform_device_register(&dove_spi1);
+	orion_spi_init(DOVE_SPI1_PHYS_BASE, get_tclk());
 }
 
 /*****************************************************************************
@@ -613,9 +557,6 @@ void __init dove_init(void)
 #endif
 	dove_setup_cpu_mbus();
 
-	dove_spi0_data.tclk = tclk;
-	dove_spi1_data.tclk = tclk;
-
 	/* internal devices that every board has */
 	dove_rtc_init();
 	dove_xor0_init();
diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index fc86a80..af864fc 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -15,7 +15,6 @@
 #include <linux/mbus.h>
 #include <linux/ata_platform.h>
 #include <linux/mtd/nand.h>
-#include <linux/spi/orion_spi.h>
 #include <net/dsa.h>
 #include <asm/page.h>
 #include <asm/timex.h>
@@ -292,31 +291,10 @@ void __init kirkwood_sdio_init(struct mvsdio_platform_data *mvsdio_data)
 /*****************************************************************************
  * SPI
  ****************************************************************************/
-static struct orion_spi_info kirkwood_spi_plat_data = {
-};
-
-static struct resource kirkwood_spi_resources[] = {
-	{
-		.start	= SPI_PHYS_BASE,
-		.end	= SPI_PHYS_BASE + SZ_512 - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device kirkwood_spi = {
-	.name		= "orion_spi",
-	.id		= 0,
-	.resource	= kirkwood_spi_resources,
-	.dev		= {
-		.platform_data	= &kirkwood_spi_plat_data,
-	},
-	.num_resources	= ARRAY_SIZE(kirkwood_spi_resources),
-};
-
 void __init kirkwood_spi_init()
 {
 	kirkwood_clk_ctrl |= CGC_RUNIT;
-	platform_device_register(&kirkwood_spi);
+	orion_spi_init(SPI_PHYS_BASE, kirkwood_tclk);
 }
 
 
@@ -757,7 +735,6 @@ void __init kirkwood_init(void)
 {
 	printk(KERN_INFO "Kirkwood: %s, TCLK=%d.\n",
 		kirkwood_id(), kirkwood_tclk);
-	kirkwood_spi_plat_data.tclk = kirkwood_tclk;
 	kirkwood_i2s_data.tclk = kirkwood_tclk;
 
 	/*
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index 9af0b88..d2dee43 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -17,7 +17,6 @@
 #include <linux/mbus.h>
 #include <linux/mv643xx_i2c.h>
 #include <linux/ata_platform.h>
-#include <linux/spi/orion_spi.h>
 #include <net/dsa.h>
 #include <asm/page.h>
 #include <asm/setup.h>
@@ -214,33 +213,9 @@ void __init orion5x_sata_init(struct mv_sata_platform_data *sata_data)
 /*****************************************************************************
  * SPI
  ****************************************************************************/
-static struct orion_spi_info orion5x_spi_plat_data = {
-	.tclk			= 0,
-	.enable_clock_fix	= 1,
-};
-
-static struct resource orion5x_spi_resources[] = {
-	{
-		.name	= "spi base",
-		.start	= SPI_PHYS_BASE,
-		.end	= SPI_PHYS_BASE + 0x1f,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device orion5x_spi = {
-	.name		= "orion_spi",
-	.id		= 0,
-	.dev		= {
-		.platform_data	= &orion5x_spi_plat_data,
-	},
-	.num_resources	= ARRAY_SIZE(orion5x_spi_resources),
-	.resource	= orion5x_spi_resources,
-};
-
 void __init orion5x_spi_init()
 {
-	platform_device_register(&orion5x_spi);
+	orion_spi_init(SPI_PHYS_BASE, orion5x_tclk);
 }
 
 
@@ -513,8 +488,6 @@ void __init orion5x_init(void)
 	orion5x_id(&dev, &rev, &dev_name);
 	printk(KERN_INFO "Orion ID: %s. TCLK=%d.\n", dev_name, orion5x_tclk);
 
-	orion5x_spi_plat_data.tclk = orion5x_tclk;
-
 	/*
 	 * Setup Orion address map
 	 */
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index bcc1734..2afe79d 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -17,6 +17,7 @@
 #include <linux/mv643xx_eth.h>
 #include <linux/mv643xx_i2c.h>
 #include <net/dsa.h>
+#include <linux/spi/orion_spi.h>
 
 /* Fill in the resources structure and link it into the platform
    device structure. There is always a memory region, and nearly
@@ -517,3 +518,49 @@ void __init orion_i2c_1_init(unsigned long mapbase,
 		       SZ_32 - 1, irq);
 	platform_device_register(&orion_i2c_1);
 }
+
+/*****************************************************************************
+ * SPI
+ ****************************************************************************/
+static struct orion_spi_info orion_spi_plat_data;
+static struct resource orion_spi_resources;
+
+static struct platform_device orion_spi = {
+	.name		= "orion_spi",
+	.id		= 0,
+	.dev		= {
+		.platform_data	= &orion_spi_plat_data,
+	},
+};
+
+static struct orion_spi_info orion_spi_1_plat_data;
+static struct resource orion_spi_1_resources;
+
+static struct platform_device orion_spi_1 = {
+	.name		= "orion_spi",
+	.id		= 1,
+	.dev		= {
+		.platform_data	= &orion_spi_1_plat_data,
+	},
+};
+
+/* Note: The SPI silicon core does have interrupts. However the
+ * current Linux software driver does not use interrupts. */
+
+void __init orion_spi_init(unsigned long mapbase,
+			   unsigned long tclk)
+{
+	orion_spi_plat_data.tclk = tclk;
+	fill_resources(&orion_spi, &orion_spi_resources,
+		       mapbase, SZ_512 - 1, NO_IRQ);
+	platform_device_register(&orion_spi);
+}
+
+void __init orion_spi_1_init(unsigned long mapbase,
+			     unsigned long tclk)
+{
+	orion_spi_1_plat_data.tclk = tclk;
+	fill_resources(&orion_spi_1, &orion_spi_1_resources,
+		       mapbase, SZ_512 - 1, NO_IRQ);
+	platform_device_register(&orion_spi_1);
+}
diff --git a/arch/arm/plat-orion/include/plat/common.h b/arch/arm/plat-orion/include/plat/common.h
index d107c62..e72c146 100644
--- a/arch/arm/plat-orion/include/plat/common.h
+++ b/arch/arm/plat-orion/include/plat/common.h
@@ -73,4 +73,10 @@ void __init orion_i2c_init(unsigned long mapbase,
 void __init orion_i2c_1_init(unsigned long mapbase,
 			     unsigned long irq,
 			     unsigned long freq_m);
+
+void __init orion_spi_init(unsigned long mapbase,
+			   unsigned long tclk);
+
+void __init orion_spi_1_init(unsigned long mapbase,
+			     unsigned long tclk);
 #endif
-- 
1.7.4.4

