Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2BWOSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:18:52 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53451 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab2BWOSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:18:51 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <nsekhar@ti.com>, <linux@arm.linux.org.uk>, <dwmw2@infradead.org>,
        <sameo@linux.intel.com>, "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH v5 3/3] arm:davinci: move NAND and NOR devices as emif MFD slaves
Date: Thu, 23 Feb 2012 19:28:24 +0530
Message-ID: <1330005504-25321-4-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAND and NOR device are made as aemif device slaves, hence all DaVinci
board NAND/NOR device registration is achieved via emif MFD driver.

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
---
Since v4:
No change.
Since v3:
Changed NAND device id to 1 for board-mityomapl138.
Since v2:
Make changes for all DaVinci boards in single patch.
Since v1:
Patch generated using -M option.

 arch/arm/mach-davinci/board-da830-evm.c     |   31 ++++--
 arch/arm/mach-davinci/board-da850-evm.c     |   54 +++++----
 arch/arm/mach-davinci/board-dm355-evm.c     |   33 ++++--
 arch/arm/mach-davinci/board-dm355-leopard.c |   35 ++++--
 arch/arm/mach-davinci/board-dm365-evm.c     |   34 ++++--
 arch/arm/mach-davinci/board-dm644x-evm.c    |  173 +++++++++++++++------------
 arch/arm/mach-davinci/board-dm646x-evm.c    |   30 ++++--
 arch/arm/mach-davinci/board-mityomapl138.c  |   34 ++++--
 arch/arm/mach-davinci/board-neuros-osd2.c   |    1 +
 arch/arm/mach-davinci/board-sffsdr.c        |   34 ++++--
 10 files changed, 299 insertions(+), 160 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index 0b43554..0ad3662 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -396,14 +396,29 @@ static struct resource da830_evm_nand_resources[] = {
 	},
 };
 
-static struct platform_device da830_evm_nand_device = {
-	.name		= "davinci_nand",
-	.id		= 1,
-	.dev		= {
-		.platform_data	= &da830_evm_nand_pdata,
+static struct platform_device da830_evm_devices[] __initdata = {
+	{
+		.name		= "davinci_nand",
+		.id		= 1,
+		.dev		= {
+			.platform_data	= &da830_evm_nand_pdata,
+		},
+		.num_resources	= ARRAY_SIZE(da830_evm_nand_resources),
+		.resource	= da830_evm_nand_resources,
+	},
+};
+
+static struct davinci_aemif_devices da830_emif_devices = {
+	.devices	= da830_evm_devices,
+	.num_devices	= ARRAY_SIZE(da830_evm_devices),
+};
+
+static struct platform_device davinci_emif_device = {
+	.name	= "davinci_aemif",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &da830_emif_devices,
 	},
-	.num_resources	= ARRAY_SIZE(da830_evm_nand_resources),
-	.resource	= da830_evm_nand_resources,
 };
 
 static inline void da830_evm_init_nand(int mux_mode)
@@ -422,7 +437,7 @@ static inline void da830_evm_init_nand(int mux_mode)
 		pr_warning("da830_evm_init: emif25 mux setup failed: %d\n",
 				ret);
 
-	ret = platform_device_register(&da830_evm_nand_device);
+	ret = platform_device_register(&davinci_emif_device);
 	if (ret)
 		pr_warning("da830_evm_init: NAND device not registered.\n");
 
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 9f2a544..49ab16d 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -181,16 +181,6 @@ static struct resource da850_evm_norflash_resource[] = {
 	},
 };
 
-static struct platform_device da850_evm_norflash_device = {
-	.name		= "physmap-flash",
-	.id		= 0,
-	.dev		= {
-		.platform_data  = &da850_evm_norflash_data,
-	},
-	.num_resources	= 1,
-	.resource	= da850_evm_norflash_resource,
-};
-
 static struct davinci_pm_config da850_pm_pdata = {
 	.sleepcount = 128,
 };
@@ -273,19 +263,39 @@ static struct resource da850_evm_nandflash_resource[] = {
 	},
 };
 
-static struct platform_device da850_evm_nandflash_device = {
-	.name		= "davinci_nand",
-	.id		= 1,
-	.dev		= {
-		.platform_data	= &da850_evm_nandflash_data,
+static struct platform_device da850_evm_devices[] __initdata = {
+	{
+		.name		= "davinci_nand",
+		.id		= 1,
+		.dev		= {
+			.platform_data	= &da850_evm_nandflash_data,
+		},
+		.num_resources	= ARRAY_SIZE(da850_evm_nandflash_resource),
+		.resource	= da850_evm_nandflash_resource,
 	},
-	.num_resources	= ARRAY_SIZE(da850_evm_nandflash_resource),
-	.resource	= da850_evm_nandflash_resource,
+	{
+		.name		= "physmap-flash",
+		.id		= 0,
+		.dev		= {
+			.platform_data  = &da850_evm_norflash_data,
+		},
+		.num_resources	= 1,
+		.resource	= da850_evm_norflash_resource,
+
+	},
+
+};
+static struct davinci_aemif_devices da850_emif_devices = {
+	.devices	= da850_evm_devices,
+	.num_devices	= ARRAY_SIZE(da850_evm_devices),
 };
 
-static struct platform_device *da850_evm_devices[] __initdata = {
-	&da850_evm_nandflash_device,
-	&da850_evm_norflash_device,
+static struct platform_device davinci_emif_device = {
+	.name	= "davinci_aemif",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &da850_emif_devices,
+	},
 };
 
 #define DA8XX_AEMIF_CE2CFG_OFFSET	0x10
@@ -352,9 +362,7 @@ static inline void da850_evm_setup_nor_nand(void)
 				ret);
 
 		da850_evm_init_nor();
-
-		platform_add_devices(da850_evm_devices,
-					ARRAY_SIZE(da850_evm_devices));
+		platform_device_register(&davinci_emif_device);
 	}
 }
 
diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index 275341f..e7359e8 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -22,6 +22,7 @@
 #include <media/tvp514x.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
+#include <linux/mfd/davinci_aemif.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -93,15 +94,16 @@ static struct resource davinci_nand_resources[] = {
 	},
 };
 
-static struct platform_device davinci_nand_device = {
-	.name			= "davinci_nand",
-	.id			= 0,
-
-	.num_resources		= ARRAY_SIZE(davinci_nand_resources),
-	.resource		= davinci_nand_resources,
+static struct platform_device dm355_evm_devices[] __initdata = {
+	{
+		.name		= "davinci_nand",
+		.id		= 0,
 
-	.dev			= {
-		.platform_data	= &davinci_nand_data,
+		.resource		= davinci_nand_resources,
+		.num_resources		= ARRAY_SIZE(davinci_nand_resources),
+		.dev		= {
+			.platform_data	= &davinci_nand_data,
+		},
 	},
 };
 
@@ -241,9 +243,22 @@ static struct vpfe_config vpfe_cfg = {
 	.ccdc = "DM355 CCDC",
 };
 
+static struct davinci_aemif_devices davinci_emif_devices = {
+	.devices	= dm355_evm_devices,
+	.num_devices	= ARRAY_SIZE(dm355_evm_devices),
+};
+
+static struct platform_device davinci_emif_device = {
+	.name	= "davinci_aemif",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &davinci_emif_devices,
+	},
+};
+
 static struct platform_device *davinci_evm_devices[] __initdata = {
 	&dm355evm_dm9000,
-	&davinci_nand_device,
+	&davinci_emif_device,
 };
 
 static struct davinci_uart_config uart_config __initdata = {
diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
index e99db28..ec057b6 100644
--- a/arch/arm/mach-davinci/board-dm355-leopard.c
+++ b/arch/arm/mach-davinci/board-dm355-leopard.c
@@ -19,6 +19,7 @@
 #include <linux/clk.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
+#include <linux/mfd/davinci_aemif.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -89,15 +90,16 @@ static struct resource davinci_nand_resources[] = {
 	},
 };
 
-static struct platform_device davinci_nand_device = {
-	.name			= "davinci_nand",
-	.id			= 0,
-
-	.num_resources		= ARRAY_SIZE(davinci_nand_resources),
-	.resource		= davinci_nand_resources,
-
-	.dev			= {
-		.platform_data	= &davinci_nand_data,
+static struct platform_device dm355_evm_devices[] __initdata = {
+	{
+		.name		= "davinci_nand",
+		.id		= 0,
+
+		.resource		= davinci_nand_resources,
+		.num_resources		= ARRAY_SIZE(davinci_nand_resources),
+		.dev		= {
+			.platform_data	= &davinci_nand_data,
+		},
 	},
 };
 
@@ -166,9 +168,22 @@ static struct platform_device dm355leopard_dm9000 = {
 	.num_resources	= ARRAY_SIZE(dm355leopard_dm9000_rsrc),
 };
 
+static struct davinci_aemif_devices davinci_emif_devices = {
+	.devices	= dm355_evm_devices,
+	.num_devices	= ARRAY_SIZE(dm355_evm_devices),
+};
+
+static struct platform_device davinci_emif_device = {
+	.name	= "davinci_aemif",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &davinci_emif_devices,
+	},
+};
+
 static struct platform_device *davinci_leopard_devices[] __initdata = {
 	&dm355leopard_dm9000,
-	&davinci_nand_device,
+	&davinci_emif_device,
 };
 
 static struct davinci_uart_config uart_config __initdata = {
diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 849311d..f97d67d 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -27,6 +27,7 @@
 #include <linux/input.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
+#include <linux/mfd/davinci_aemif.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -155,13 +156,16 @@ static struct resource davinci_nand_resources[] = {
 	},
 };
 
-static struct platform_device davinci_nand_device = {
-	.name			= "davinci_nand",
-	.id			= 0,
-	.num_resources		= ARRAY_SIZE(davinci_nand_resources),
-	.resource		= davinci_nand_resources,
-	.dev			= {
-		.platform_data	= &davinci_nand_data,
+static struct platform_device dm365_emif_devices[] __initdata = {
+	{
+		.name		= "davinci_nand",
+		.id		= 0,
+
+		.resource		= davinci_nand_resources,
+		.num_resources		= ARRAY_SIZE(davinci_nand_resources),
+		.dev		= {
+			.platform_data	= &davinci_nand_data,
+		},
 	},
 };
 
@@ -379,8 +383,17 @@ static void __init evm_init_i2c(void)
 	i2c_register_board_info(1, i2c_info, ARRAY_SIZE(i2c_info));
 }
 
-static struct platform_device *dm365_evm_nand_devices[] __initdata = {
-	&davinci_nand_device,
+static struct davinci_aemif_devices davinci_emif_devices = {
+	.devices	= dm365_emif_devices,
+	.num_devices	= ARRAY_SIZE(dm365_emif_devices),
+};
+
+static struct platform_device davinci_emif_device = {
+	.name	= "davinci_aemif",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &davinci_emif_devices,
+	},
 };
 
 static inline int have_leds(void)
@@ -502,8 +515,7 @@ fail:
 		/* external keypad mux */
 		mux |= BIT(7);
 
-		platform_add_devices(dm365_evm_nand_devices,
-				ARRAY_SIZE(dm365_evm_nand_devices));
+		platform_device_register(&davinci_emif_device);
 	} else {
 		/* no OneNAND support yet */
 	}
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 99a6639..ad4c944 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -44,61 +44,21 @@
 #define LXT971_PHY_ID	(0x001378e2)
 #define LXT971_PHY_MASK	(0xfffffff0)
 
-static struct mtd_partition davinci_evm_norflash_partitions[] = {
-	/* bootloader (UBL, U-Boot, etc) in first 5 sectors */
-	{
-		.name		= "bootloader",
-		.offset		= 0,
-		.size		= 5 * SZ_64K,
-		.mask_flags	= MTD_WRITEABLE, /* force read-only */
-	},
-	/* bootloader params in the next 1 sectors */
-	{
-		.name		= "params",
-		.offset		= MTDPART_OFS_APPEND,
-		.size		= SZ_64K,
-		.mask_flags	= 0,
-	},
-	/* kernel */
-	{
-		.name		= "kernel",
-		.offset		= MTDPART_OFS_APPEND,
-		.size		= SZ_2M,
-		.mask_flags	= 0
-	},
-	/* file system */
-	{
-		.name		= "filesystem",
-		.offset		= MTDPART_OFS_APPEND,
-		.size		= MTDPART_SIZ_FULL,
-		.mask_flags	= 0
-	}
-};
-
-static struct physmap_flash_data davinci_evm_norflash_data = {
-	.width		= 2,
-	.parts		= davinci_evm_norflash_partitions,
-	.nr_parts	= ARRAY_SIZE(davinci_evm_norflash_partitions),
-};
-
-/* NOTE: CFI probe will correctly detect flash part as 32M, but EMIF
- * limits addresses to 16M, so using addresses past 16M will wrap */
-static struct resource davinci_evm_norflash_resource = {
-	.start		= DM644X_ASYNC_EMIF_DATA_CE0_BASE,
-	.end		= DM644X_ASYNC_EMIF_DATA_CE0_BASE + SZ_16M - 1,
-	.flags		= IORESOURCE_MEM,
-};
+#if defined(CONFIG_MTD_PHYSMAP) || \
+	defined(CONFIG_MTD_PHYSMAP_MODULE)
+#define HAS_NOR 1
+#else
+#define HAS_NOR 0
+#endif
 
-static struct platform_device davinci_evm_norflash_device = {
-	.name		= "physmap-flash",
-	.id		= 0,
-	.dev		= {
-		.platform_data	= &davinci_evm_norflash_data,
-	},
-	.num_resources	= 1,
-	.resource	= &davinci_evm_norflash_resource,
-};
+#if defined(CONFIG_MTD_NAND_DAVINCI) || \
+	defined(CONFIG_MTD_NAND_DAVINCI_MODULE)
+#define HAS_NAND 1
+#else
+#define HAS_NAND 0
+#endif
 
+#if (HAS_NAND == 1)
 /* DM644x EVM includes a 64 MByte small-page NAND flash (16K blocks).
  * It may used instead of the (default) NOR chip to boot, using TI's
  * tools to install the secondary boot loader (UBL) and U-Boot.
@@ -166,15 +126,79 @@ static struct resource davinci_evm_nandflash_resource[] = {
 		.flags		= IORESOURCE_MEM,
 	},
 };
+#elif (HAS_NOR == 1)
+static struct mtd_partition davinci_evm_norflash_partitions[] = {
+	/* bootloader (UBL, U-Boot, etc) in first 5 sectors */
+	{
+		.name		= "bootloader",
+		.offset		= 0,
+		.size		= 5 * SZ_64K,
+		.mask_flags	= MTD_WRITEABLE, /* force read-only */
+	},
+	/* bootloader params in the next 1 sectors */
+	{
+		.name		= "params",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= SZ_64K,
+		.mask_flags	= 0,
+	},
+	/* kernel */
+	{
+		.name		= "kernel",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= SZ_2M,
+		.mask_flags	= 0
+	},
+	/* file system */
+	{
+		.name		= "filesystem",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= MTDPART_SIZ_FULL,
+		.mask_flags	= 0
+	}
+};
+
+static struct physmap_flash_data davinci_evm_norflash_data = {
+	.width		= 2,
+	.parts		= davinci_evm_norflash_partitions,
+	.nr_parts	= ARRAY_SIZE(davinci_evm_norflash_partitions),
+};
+
+/* NOTE: CFI probe will correctly detect flash part as 32M, but EMIF
+ * limits addresses to 16M, so using addresses past 16M will wrap */
+static struct resource davinci_evm_norflash_resource[] = {
+	{
+		.start		= DM644X_ASYNC_EMIF_DATA_CE0_BASE,
+		.end		= DM644X_ASYNC_EMIF_DATA_CE0_BASE + SZ_16M - 1,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+#endif
 
-static struct platform_device davinci_evm_nandflash_device = {
-	.name		= "davinci_nand",
-	.id		= 0,
-	.dev		= {
-		.platform_data	= &davinci_evm_nandflash_data,
+static struct platform_device dm644x_emif_devices[] __initdata = {
+#if (HAS_NAND == 1)
+	{
+		.name		= "davinci_nand",
+		.id		= 0,
+		.resource		= davinci_evm_nandflash_resource,
+		.num_resources		=
+			ARRAY_SIZE(davinci_evm_nandflash_resource),
+		.dev		= {
+			.platform_data	= &davinci_evm_nandflash_data,
+		},
 	},
-	.num_resources	= ARRAY_SIZE(davinci_evm_nandflash_resource),
-	.resource	= davinci_evm_nandflash_resource,
+#elif (HAS_NOR == 1)
+	{
+		.name		= "physmap-flash",
+		.id		= 0,
+		.resource		= davinci_evm_norflash_resource,
+		.num_resources		=
+			ARRAY_SIZE(davinci_evm_norflash_resource),
+		.dev		= {
+			.platform_data	= &davinci_evm_norflash_data,
+		},
+	},
+#endif
 };
 
 static u64 davinci_fb_dma_mask = DMA_BIT_MASK(32);
@@ -649,19 +673,19 @@ static int davinci_phy_fixup(struct phy_device *phydev)
 #define HAS_ATA 0
 #endif
 
-#if defined(CONFIG_MTD_PHYSMAP) || \
-    defined(CONFIG_MTD_PHYSMAP_MODULE)
-#define HAS_NOR 1
-#else
-#define HAS_NOR 0
-#endif
+static struct davinci_aemif_devices davinci_emif_devices = {
+	.devices	= dm644x_emif_devices,
+	.num_devices	= ARRAY_SIZE(dm644x_emif_devices),
+};
+
+static struct platform_device davinci_emif_device = {
+	.name	= "davinci_aemif",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &davinci_emif_devices,
+	},
+};
 
-#if defined(CONFIG_MTD_NAND_DAVINCI) || \
-    defined(CONFIG_MTD_NAND_DAVINCI_MODULE)
-#define HAS_NAND 1
-#else
-#define HAS_NAND 0
-#endif
 
 static __init void davinci_evm_init(void)
 {
@@ -683,13 +707,12 @@ static __init void davinci_evm_init(void)
 
 		/* only one device will be jumpered and detected */
 		if (HAS_NAND) {
-			platform_device_register(&davinci_evm_nandflash_device);
 			evm_leds[7].default_trigger = "nand-disk";
 			if (HAS_NOR)
 				pr_warning("WARNING: both NAND and NOR flash "
 					"are enabled; disable one of them.\n");
-		} else if (HAS_NOR)
-			platform_device_register(&davinci_evm_norflash_device);
+		}
+		platform_device_register(&davinci_emif_device);
 	}
 
 	platform_add_devices(davinci_evm_devices,
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index af55a9d..34bc4af 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -104,15 +104,29 @@ static struct resource davinci_nand_resources[] = {
 	},
 };
 
-static struct platform_device davinci_nand_device = {
-	.name			= "davinci_nand",
-	.id			= 0,
+static struct platform_device dm646x_emif_devices[] __initdata = {
+	{
+		.name		= "davinci_nand",
+		.id		= 0,
+
+		.resource		= davinci_nand_resources,
+		.num_resources		= ARRAY_SIZE(davinci_nand_resources),
+		.dev		= {
+			.platform_data	= &davinci_nand_data,
+		},
+	},
+};
 
-	.num_resources		= ARRAY_SIZE(davinci_nand_resources),
-	.resource		= davinci_nand_resources,
+static struct davinci_aemif_devices davinci_emif_devices = {
+	.devices	= dm646x_emif_devices,
+	.num_devices	= ARRAY_SIZE(dm646x_emif_devices),
+};
 
-	.dev			= {
-		.platform_data	= &davinci_nand_data,
+static struct platform_device davinci_emif_device = {
+	.name	= "davinci_aemif",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &davinci_emif_devices,
 	},
 };
 
@@ -782,7 +796,7 @@ static __init void evm_init(void)
 	if (machine_is_davinci_dm6467tevm())
 		davinci_nand_data.timing = &dm6467tevm_nandflash_timing;
 
-	platform_device_register(&davinci_nand_device);
+	platform_device_register(&davinci_emif_device);
 
 	dm646x_init_edma(dm646x_edma_rsv);
 
diff --git a/arch/arm/mach-davinci/board-mityomapl138.c b/arch/arm/mach-davinci/board-mityomapl138.c
index 672d820..4e48ade 100644
--- a/arch/arm/mach-davinci/board-mityomapl138.c
+++ b/arch/arm/mach-davinci/board-mityomapl138.c
@@ -19,6 +19,7 @@
 #include <linux/etherdevice.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
+#include <linux/mfd/davinci_aemif.h>
 
 #include <asm/io.h>
 #include <asm/mach-types.h>
@@ -414,18 +415,35 @@ static struct resource mityomapl138_nandflash_resource[] = {
 	},
 };
 
-static struct platform_device mityomapl138_nandflash_device = {
-	.name		= "davinci_nand",
-	.id		= 1,
-	.dev		= {
-		.platform_data	= &mityomapl138_nandflash_data,
+static struct platform_device mityomapl138_emif_devices[] __initdata = {
+	{
+		.name		= "davinci_nand",
+		.id		= 1,
+
+		.resource		= mityomapl138_nandflash_resource,
+		.num_resources		=
+			ARRAY_SIZE(mityomapl138_nandflash_resource),
+		.dev		= {
+			.platform_data	= &mityomapl138_nandflash_data,
+		},
+	},
+};
+
+static struct davinci_aemif_devices davinci_emif_devices = {
+	.devices	= mityomapl138_emif_devices,
+	.num_devices	= ARRAY_SIZE(mityomapl138_emif_devices),
+};
+
+static struct platform_device davinci_emif_device = {
+	.name	= "davinci_aemif",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &davinci_emif_devices,
 	},
-	.num_resources	= ARRAY_SIZE(mityomapl138_nandflash_resource),
-	.resource	= mityomapl138_nandflash_resource,
 };
 
 static struct platform_device *mityomapl138_devices[] __initdata = {
-	&mityomapl138_nandflash_device,
+	&davinci_emif_device,
 };
 
 static void __init mityomapl138_setup_nand(void)
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index 8d34f51..c1c6fa1 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -26,6 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/mtd/partitions.h>
+#include <linux/mfd/davinci_aemif.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-davinci/board-sffsdr.c b/arch/arm/mach-davinci/board-sffsdr.c
index 31da3c5..ac36320 100644
--- a/arch/arm/mach-davinci/board-sffsdr.c
+++ b/arch/arm/mach-davinci/board-sffsdr.c
@@ -30,6 +30,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
+#include <linux/mfd/davinci_aemif.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -81,14 +82,31 @@ static struct resource davinci_sffsdr_nandflash_resource[] = {
 	},
 };
 
-static struct platform_device davinci_sffsdr_nandflash_device = {
-	.name		= "davinci_nand", /* Name of driver */
-	.id		= 0,
-	.dev		= {
-		.platform_data	= &davinci_sffsdr_nandflash_data,
+static struct platform_device davinci_sffsdr_emif_devices[] __initdata = {
+	{
+		.name		= "davinci_nand",
+		.id		= 0,
+
+		.resource		= davinci_sffsdr_nandflash_resource,
+		.num_resources		=
+			ARRAY_SIZE(davinci_sffsdr_nandflash_resource),
+		.dev		= {
+			.platform_data	= &davinci_sffsdr_nandflash_data,
+		},
+	},
+};
+
+static struct davinci_aemif_devices davinci_emif_devices = {
+	.devices	= davinci_sffsdr_emif_devices,
+	.num_devices	= ARRAY_SIZE(davinci_sffsdr_emif_devices),
+};
+
+static struct platform_device davinci_emif_device = {
+	.name	= "davinci_aemif",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &davinci_emif_devices,
 	},
-	.num_resources	= ARRAY_SIZE(davinci_sffsdr_nandflash_resource),
-	.resource	= davinci_sffsdr_nandflash_resource,
 };
 
 static struct at24_platform_data eeprom_info = {
@@ -121,7 +139,7 @@ static void __init sffsdr_init_i2c(void)
 }
 
 static struct platform_device *davinci_sffsdr_devices[] __initdata = {
-	&davinci_sffsdr_nandflash_device,
+	&davinci_emif_device,
 };
 
 static struct davinci_uart_config uart_config __initdata = {
-- 
1.7.1

