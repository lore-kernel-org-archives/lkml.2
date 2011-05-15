Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004Ab1EOLfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:35:31 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59494 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758441Ab1EOLf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:35:28 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: kernel@wantstofly.org, nico@fluxnic.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saeed.bishara@gmail.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCHv2 06/15] [orion] Consolidate I2C initialization.
Date: Sun, 15 May 2011 13:32:45 +0200
Message-Id: <1305459174-25517-7-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
References: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-dove/common.c               |   33 +-------------
 arch/arm/mach-kirkwood/common.c           |   31 +------------
 arch/arm/mach-mv78xx0/common.c            |   70 +---------------------------
 arch/arm/mach-orion5x/common.c            |   31 +------------
 arch/arm/plat-orion/common.c              |   54 ++++++++++++++++++++++
 arch/arm/plat-orion/include/plat/common.h |    6 +++
 6 files changed, 67 insertions(+), 158 deletions(-)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 1d878ce..198760b 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -16,7 +16,6 @@
 #include <linux/serial_8250.h>
 #include <linux/clk.h>
 #include <linux/mbus.h>
-#include <linux/mv643xx_i2c.h>
 #include <linux/ata_platform.h>
 #include <linux/serial_8250.h>
 #include <linux/spi/orion_spi.h>
@@ -305,39 +304,9 @@ void __init dove_spi1_init(void)
 /*****************************************************************************
  * I2C
  ****************************************************************************/
-static struct mv64xxx_i2c_pdata dove_i2c_data = {
-	.freq_m		= 10, /* assumes 166 MHz TCLK gets 94.3kHz */
-	.freq_n		= 3,
-	.timeout	= 1000, /* Default timeout of 1 second */
-};
-
-static struct resource dove_i2c_resources[] = {
-	{
-		.name	= "i2c base",
-		.start	= DOVE_I2C_PHYS_BASE,
-		.end	= DOVE_I2C_PHYS_BASE + 0x20 - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.name	= "i2c irq",
-		.start	= IRQ_DOVE_I2C,
-		.end	= IRQ_DOVE_I2C,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device dove_i2c = {
-	.name		= MV64XXX_I2C_CTLR_NAME,
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(dove_i2c_resources),
-	.resource	= dove_i2c_resources,
-	.dev		= {
-		.platform_data = &dove_i2c_data,
-	},
-};
-
 void __init dove_i2c_init(void)
 {
-	platform_device_register(&dove_i2c);
+	orion_i2c_init(DOVE_I2C_PHYS_BASE, IRQ_DOVE_I2C, 10);
 }
 
 /*****************************************************************************
diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index 485f3b9..fc86a80 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -13,7 +13,6 @@
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
 #include <linux/mbus.h>
-#include <linux/mv643xx_i2c.h>
 #include <linux/ata_platform.h>
 #include <linux/mtd/nand.h>
 #include <linux/spi/orion_spi.h>
@@ -324,37 +323,9 @@ void __init kirkwood_spi_init()
 /*****************************************************************************
  * I2C
  ****************************************************************************/
-static struct mv64xxx_i2c_pdata kirkwood_i2c_pdata = {
-	.freq_m		= 8, /* assumes 166 MHz TCLK */
-	.freq_n		= 3,
-	.timeout	= 1000, /* Default timeout of 1 second */
-};
-
-static struct resource kirkwood_i2c_resources[] = {
-	{
-		.start	= I2C_PHYS_BASE,
-		.end	= I2C_PHYS_BASE + 0x1f,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= IRQ_KIRKWOOD_TWSI,
-		.end	= IRQ_KIRKWOOD_TWSI,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device kirkwood_i2c = {
-	.name		= MV64XXX_I2C_CTLR_NAME,
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(kirkwood_i2c_resources),
-	.resource	= kirkwood_i2c_resources,
-	.dev		= {
-		.platform_data	= &kirkwood_i2c_pdata,
-	},
-};
-
 void __init kirkwood_i2c_init(void)
 {
-	platform_device_register(&kirkwood_i2c);
+	orion_i2c_init(I2C_PHYS_BASE, IRQ_KIRKWOOD_TWSI, 8);
 }
 
 
diff --git a/arch/arm/mach-mv78xx0/common.c b/arch/arm/mach-mv78xx0/common.c
index 0fd9a83..aa27c15 100644
--- a/arch/arm/mach-mv78xx0/common.c
+++ b/arch/arm/mach-mv78xx0/common.c
@@ -13,7 +13,6 @@
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
 #include <linux/mbus.h>
-#include <linux/mv643xx_i2c.h>
 #include <linux/ata_platform.h>
 #include <linux/ethtool.h>
 #include <asm/mach/map.h>
@@ -346,75 +345,12 @@ void __init mv78xx0_ge11_init(struct mv643xx_eth_platform_data *eth_data)
 }
 
 /*****************************************************************************
- * I2C bus 0
+ * I2C
  ****************************************************************************/
-
-static struct mv64xxx_i2c_pdata mv78xx0_i2c_0_pdata = {
-	.freq_m		= 8, /* assumes 166 MHz TCLK */
-	.freq_n		= 3,
-	.timeout	= 1000, /* Default timeout of 1 second */
-};
-
-static struct resource mv78xx0_i2c_0_resources[] = {
-	{
-		.start  = I2C_0_PHYS_BASE,
-		.end    = I2C_0_PHYS_BASE + 0x1f,
-		.flags  = IORESOURCE_MEM,
-	}, {
-		.start  = IRQ_MV78XX0_I2C_0,
-		.end    = IRQ_MV78XX0_I2C_0,
-		.flags  = IORESOURCE_IRQ,
-	},
-};
-
-
-static struct platform_device mv78xx0_i2c_0 = {
-	.name		= MV64XXX_I2C_CTLR_NAME,
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(mv78xx0_i2c_0_resources),
-	.resource	= mv78xx0_i2c_0_resources,
-	.dev		= {
-		.platform_data	= &mv78xx0_i2c_0_pdata,
-	},
-};
-
-/*****************************************************************************
- * I2C bus 1
- ****************************************************************************/
-
-static struct mv64xxx_i2c_pdata mv78xx0_i2c_1_pdata = {
-	.freq_m		= 8, /* assumes 166 MHz TCLK */
-	.freq_n		= 3,
-	.timeout	= 1000, /* Default timeout of 1 second */
-};
-
-static struct resource mv78xx0_i2c_1_resources[] = {
-	{
-		.start  = I2C_1_PHYS_BASE,
-		.end    = I2C_1_PHYS_BASE + 0x1f,
-		.flags  = IORESOURCE_MEM,
-	}, {
-		.start  = IRQ_MV78XX0_I2C_1,
-		.end    = IRQ_MV78XX0_I2C_1,
-		.flags  = IORESOURCE_IRQ,
-	},
-};
-
-
-static struct platform_device mv78xx0_i2c_1 = {
-	.name		= MV64XXX_I2C_CTLR_NAME,
-	.id		= 1,
-	.num_resources	= ARRAY_SIZE(mv78xx0_i2c_1_resources),
-	.resource	= mv78xx0_i2c_1_resources,
-	.dev		= {
-		.platform_data	= &mv78xx0_i2c_1_pdata,
-	},
-};
-
 void __init mv78xx0_i2c_init(void)
 {
-	platform_device_register(&mv78xx0_i2c_0);
-	platform_device_register(&mv78xx0_i2c_1);
+	orion_i2c_init(I2C_0_PHYS_BASE, IRQ_MV78XX0_I2C_0, 8);
+	orion_i2c_1_init(I2C_1_PHYS_BASE, IRQ_MV78XX0_I2C_1, 8);
 }
 
 /*****************************************************************************
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index 0a1c760..9af0b88 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -169,37 +169,10 @@ void __init orion5x_eth_switch_init(struct dsa_platform_data *d, int irq)
 /*****************************************************************************
  * I2C
  ****************************************************************************/
-static struct mv64xxx_i2c_pdata orion5x_i2c_pdata = {
-	.freq_m		= 8, /* assumes 166 MHz TCLK */
-	.freq_n		= 3,
-	.timeout	= 1000, /* Default timeout of 1 second */
-};
-
-static struct resource orion5x_i2c_resources[] = {
-	{
-		.start	= I2C_PHYS_BASE,
-		.end	= I2C_PHYS_BASE + 0x1f,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= IRQ_ORION5X_I2C,
-		.end	= IRQ_ORION5X_I2C,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device orion5x_i2c = {
-	.name		= MV64XXX_I2C_CTLR_NAME,
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(orion5x_i2c_resources),
-	.resource	= orion5x_i2c_resources,
-	.dev		= {
-		.platform_data	= &orion5x_i2c_pdata,
-	},
-};
-
 void __init orion5x_i2c_init(void)
 {
-	platform_device_register(&orion5x_i2c);
+	orion_i2c_init(I2C_PHYS_BASE, IRQ_ORION5X_I2C, 8);
+
 }
 
 
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index 15c3f35..bcc1734 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -15,6 +15,7 @@
 #include <linux/serial_8250.h>
 #include <linux/mbus.h>
 #include <linux/mv643xx_eth.h>
+#include <linux/mv643xx_i2c.h>
 #include <net/dsa.h>
 
 /* Fill in the resources structure and link it into the platform
@@ -463,3 +464,56 @@ void __init orion_ge00_switch_init(struct dsa_platform_data *d, int irq)
 
 	platform_device_register(&orion_switch_device);
 }
+
+/*****************************************************************************
+ * I2C
+ ****************************************************************************/
+static struct mv64xxx_i2c_pdata orion_i2c_pdata = {
+	.freq_n		= 3,
+	.timeout	= 1000, /* Default timeout of 1 second */
+};
+
+static struct resource orion_i2c_resources[2];
+
+static struct platform_device orion_i2c = {
+	.name		= MV64XXX_I2C_CTLR_NAME,
+	.id		= 0,
+	.dev		= {
+		.platform_data	= &orion_i2c_pdata,
+	},
+};
+
+static struct mv64xxx_i2c_pdata orion_i2c_1_pdata = {
+	.freq_n		= 3,
+	.timeout	= 1000, /* Default timeout of 1 second */
+};
+
+static struct resource orion_i2c_1_resources[2];
+
+static struct platform_device orion_i2c_1 = {
+	.name		= MV64XXX_I2C_CTLR_NAME,
+	.id		= 1,
+	.dev		= {
+		.platform_data	= &orion_i2c_1_pdata,
+	},
+};
+
+void __init orion_i2c_init(unsigned long mapbase,
+			   unsigned long irq,
+			   unsigned long freq_m)
+{
+	orion_i2c_pdata.freq_m = freq_m;
+	fill_resources(&orion_i2c, orion_i2c_resources, mapbase,
+		       SZ_32 - 1, irq);
+	platform_device_register(&orion_i2c);
+}
+
+void __init orion_i2c_1_init(unsigned long mapbase,
+			     unsigned long irq,
+			     unsigned long freq_m)
+{
+	orion_i2c_1_pdata.freq_m = freq_m;
+	fill_resources(&orion_i2c_1, orion_i2c_1_resources, mapbase,
+		       SZ_32 - 1, irq);
+	platform_device_register(&orion_i2c_1);
+}
diff --git a/arch/arm/plat-orion/include/plat/common.h b/arch/arm/plat-orion/include/plat/common.h
index 3f23258..d107c62 100644
--- a/arch/arm/plat-orion/include/plat/common.h
+++ b/arch/arm/plat-orion/include/plat/common.h
@@ -66,5 +66,11 @@ void __init orion_ge11_init(struct mv643xx_eth_platform_data *eth_data,
 
 void __init orion_ge00_switch_init(struct dsa_platform_data *d,
 				   int irq);
+void __init orion_i2c_init(unsigned long mapbase,
+			   unsigned long irq,
+			   unsigned long freq_m);
 
+void __init orion_i2c_1_init(unsigned long mapbase,
+			     unsigned long irq,
+			     unsigned long freq_m);
 #endif
-- 
1.7.4.4

